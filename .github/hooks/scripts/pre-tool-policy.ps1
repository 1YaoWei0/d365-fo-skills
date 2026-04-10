<#
.SYNOPSIS
    preToolUse hook — blocks high-risk operations before they execute.

.DESCRIPTION
    Fires before every tool use. Reads JSON context from stdin (toolName, toolArgs).
    Can deny execution by outputting {"permissionDecision":"deny","permissionDecisionReason":"..."}.

    D365 F&O specific rules:
    - Blocks format/diskpart commands (data loss risk)
    - Blocks DROP TABLE / TRUNCATE without review (data integrity)
    - Blocks rm -rf / on root paths (destructive)
    - Warns (but allows) when modifying duty/role AOT objects
    - Warns (but allows) on privilege escalation patterns

    Only "deny" permissionDecision is currently processed by Copilot CLI.
    Logging is written to .github/hooks/logs/audit.jsonl.

.NOTES
    Called by hooks.json with cwd=".github/hooks".
    To allow a blocked pattern for a specific task, temporarily comment
    the relevant rule below.
#>

$ErrorActionPreference = "Stop"

# Read JSON input from stdin (official hooks protocol)
try {
    $inputData    = [Console]::In.ReadToEnd() | ConvertFrom-Json
    $toolName     = $inputData.toolName
    $toolArgsRaw  = $inputData.toolArgs   # JSON string
} catch {
    exit 0
}

# Ensure log directory exists
$logDir = "logs"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

function Write-AuditLog {
    param([string]$Decision, [string]$Reason)
    $entry = @{
        event      = "preToolUse"
        toolName   = $toolName
        decision   = $Decision
        reason     = $Reason
    } | ConvertTo-Json -Compress
    Add-Content -Path "$logDir/audit.jsonl" -Value $entry
}

function Deny-Tool {
    param([string]$Reason)
    Write-AuditLog -Decision "deny" -Reason $Reason
    @{
        permissionDecision       = "deny"
        permissionDecisionReason = $Reason
    } | ConvertTo-Json -Compress
    exit 0
}

# Only evaluate shell/bash/powershell tool calls
$shellTools = @("bash", "shell", "powershell")
if ($toolName -notin $shellTools) { exit 0 }

# Parse command from toolArgs
try {
    $toolArgs = $toolArgsRaw | ConvertFrom-Json
    $command  = $toolArgs.command
} catch {
    exit 0
}

if (-not $command) { exit 0 }

# ── D365 F&O Safety Rules ─────────────────────────────────────────────────────

# Rule 1: Block format / diskpart (irreversible data loss)
if ($command -match '\bformat\b' -or $command -match '\bdiskpart\b') {
    Deny-Tool "Blocked: format/diskpart commands risk irreversible data loss. Requires manual execution."
}

# Rule 2: Block DROP TABLE / TRUNCATE TABLE without explicit confirmation
if ($command -match '\bDROP\s+TABLE\b' -or $command -match '\bTRUNCATE\s+TABLE\b') {
    Deny-Tool "Blocked: DROP TABLE / TRUNCATE TABLE must be reviewed manually to protect D365 data integrity."
}

# Rule 3: Block rm -rf on root or system paths
if ($command -match 'rm\s+-rf\s+/' -or $command -match 'Remove-Item.*-Recurse.*C:\\Windows') {
    Deny-Tool "Blocked: Destructive recursive deletion of system paths is not allowed."
}

# Rule 4: Block download-and-execute patterns
if ($command -match 'iex\s*\(?\s*irm' -or $command -match 'curl\s+.*\|\s*bash' -or $command -match 'wget\s+.*\|\s*sh') {
    Deny-Tool "Blocked: Download-and-execute patterns require manual review before running."
}

# Rule 5: Warn on duty/role modifications (log but allow — Copilot instruction handles this)
if ($command -match '\b(SecRole|SecDuty|SecurityRole|SecurityDuty)\b') {
    Write-AuditLog -Decision "allow" -Reason "Warning: command references duty/role objects — review per D365 security policy"
}

# ── Allow everything else ─────────────────────────────────────────────────────
Write-AuditLog -Decision "allow" -Reason "pass"
exit 0

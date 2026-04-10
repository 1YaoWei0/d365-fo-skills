<#
.SYNOPSIS
    userPromptSubmitted hook — logs prompts to a local audit trail.

.DESCRIPTION
    Fires whenever the user submits a prompt to Copilot CLI.
    Reads JSON context from stdin (timestamp, cwd, prompt).
    Writes a JSONL entry to .github/hooks/logs/audit.jsonl.

    Logs only metadata + a redacted version of the prompt.
    Tokens and credentials matching common patterns are redacted before logging.

.NOTES
    Log files in .github/hooks/logs/ are excluded from git via .gitignore.
    Called by hooks.json with cwd=".github/hooks".
#>

$ErrorActionPreference = "Stop"

# Read JSON input from stdin (official hooks protocol)
try {
    $inputData   = [Console]::In.ReadToEnd() | ConvertFrom-Json
    $timestampMs = $inputData.timestamp
    $cwd         = $inputData.cwd
    $prompt      = $inputData.prompt
} catch {
    exit 0
}

# Redact common sensitive patterns before logging
$redactedPrompt = $prompt `
    -replace 'ghp_[A-Za-z0-9]{20,}', '[REDACTED_TOKEN]' `
    -replace 'gho_[A-Za-z0-9]{20,}', '[REDACTED_TOKEN]' `
    -replace 'Bearer [A-Za-z0-9_\-\.]+', 'Bearer [REDACTED]' `
    -replace '--password[= ]\S+', '--password=[REDACTED]'

# Ensure log directory exists (not committed — see .gitignore)
$logDir = "logs"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

$logEntry = @{
    event       = "userPromptSubmitted"
    timestampMs = $timestampMs
    cwd         = $cwd
    prompt      = $redactedPrompt
} | ConvertTo-Json -Compress

Add-Content -Path "$logDir/audit.jsonl" -Value $logEntry
exit 0

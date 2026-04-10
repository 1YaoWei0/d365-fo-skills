<#
.SYNOPSIS
    postToolUse hook — after any tool runs, reads Visual Studio Output panes
    if the tool was a build/rebuild operation.

.DESCRIPTION
    Fires after every tool use. Reads JSON context from stdin including toolName,
    toolArgs, and toolResult. Only reads VS output if a build was just triggered.

    What it does:
    1. Reads input JSON from stdin (toolName, toolArgs, toolResult)
    2. Exits early if tool was not a build-related command
    3. Connects to Visual Studio via COM (Running Object Table / DTE)
    4. Switches Output pane to "Dynamics 365 Build Details" and reads full text
    5. Switches Output pane to "FinOps Cloud Runtime" and reads last 30 lines
    6. Reports build result: succeeded / failed + deploy status

.NOTES
    Called by hooks.json with cwd=".github/hooks".
#>

$ErrorActionPreference = "Stop"

# Read JSON input from stdin (official hooks protocol)
try {
    $inputData = [Console]::In.ReadToEnd() | ConvertFrom-Json
    $toolName   = $inputData.toolName
    $toolArgs   = $inputData.toolArgs    # JSON string
    $resultType = $inputData.toolResult.resultType  # "success", "failure", "denied"
    $resultText = $inputData.toolResult.textResultForLlm
} catch {
    $toolName   = ""
    $toolArgs   = ""
    $resultType = ""
    $resultText = ""
}

# ── Configuration ──────────────────────────────────────────────────────────────
$BuildOutputPane   = "Dynamics 365 Build Details"
$RuntimeOutputPane = "FinOps Cloud Runtime"
$RuntimeTailLines  = 30
# Build-related keywords — only act if these appear in the tool command
$BuildKeywords     = @("rebuild", "build", "RebuildSolution", "BuildSolution", "devenv")
# ───────────────────────────────────────────────────────────────────────────────

# Exit early if this tool use was not build-related
$isBuildTool = $false
foreach ($kw in $BuildKeywords) {
    if ($toolArgs -match $kw -or $toolName -match $kw) {
        $isBuildTool = $true
        break
    }
}
if (-not $isBuildTool) { exit 0 }

function Get-VsDte {
    try {
        return [System.Runtime.InteropServices.Marshal]::GetActiveObject("VisualStudio.DTE")
    } catch {
        return $null
    }
}

function Read-OutputPane {
    param($dte, [string]$PaneName)
    try {
        $outputWindow = $dte.Windows | Where-Object { $_.Caption -eq "Output" } | Select-Object -First 1
        if (-not $outputWindow) { return $null }
        $outputWindow.Activate()
        $panes = $dte.ToolWindows.OutputWindow.OutputWindowPanes
        foreach ($pane in $panes) {
            if ($pane.Name -eq $PaneName) {
                $pane.Activate()
                $sel = $pane.TextDocument.Selection
                $sel.SelectAll()
                return $sel.Text
            }
        }
    } catch {
        return $null
    }
    return $null
}

Write-Host ""
Write-Host "=== postToolUse: Reading VS build output ===" -ForegroundColor Cyan

try {
    $dte = Get-VsDte
    if (-not $dte) {
        Write-Host "  ⚠️  Visual Studio not running — skipping output read" -ForegroundColor Yellow
        exit 0
    }

    # Read Dynamics 365 Build Details pane
    $buildOutput = Read-OutputPane -dte $dte -PaneName $BuildOutputPane
    if ($buildOutput) {
        $succeeded = $buildOutput -match "Build succeeded"
        $failed    = $buildOutput -match "Build FAILED"
        if ($succeeded) {
            Write-Host "  ✅ Build: SUCCEEDED" -ForegroundColor Green
        } elseif ($failed) {
            Write-Host "  ❌ Build: FAILED" -ForegroundColor Red
            $errorLines = ($buildOutput -split "`n") | Where-Object { $_ -match "error" } | Select-Object -First 20
            Write-Host "  --- Build errors ---"
            $errorLines | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
        } else {
            Write-Host "  ⏳ Build: in progress or status unknown"
        }
    } else {
        Write-Host "  ⚠️  '$BuildOutputPane' pane not found or empty"
    }

    # Read FinOps Cloud Runtime pane (deployment status)
    $runtimeOutput = Read-OutputPane -dte $dte -PaneName $RuntimeOutputPane
    if ($runtimeOutput) {
        $tail = ($runtimeOutput -split "`n") | Select-Object -Last $RuntimeTailLines
        Write-Host "  --- FinOps Cloud Runtime (last $RuntimeTailLines lines) ---"
        $tail | ForEach-Object { Write-Host "  $_" }
    }

} catch {
    Write-Host "  ⚠️  Could not read VS output: $_" -ForegroundColor Yellow
}

Write-Host ""
exit 0

<#
.SYNOPSIS
    errorOccurred hook — when an error occurs during agent execution, opens
    the VS Output pane, extracts error lines, and feeds them back to Copilot.

.DESCRIPTION
    Fires whenever an error occurs during agent execution.
    Reads JSON context from stdin (error.message, error.name, error.stack).

    What it does:
    1. Reads error details from stdin JSON
    2. Connects to Visual Studio via COM (DTE)
    3. Reads the "Dynamics 365 Build Details" Output pane
    4. Extracts X++ compile error lines
    5. Outputs them in a structured format that Copilot can parse for self-fix

.NOTES
    Called by hooks.json with cwd=".github/hooks".
#>

$ErrorActionPreference = "Stop"

# Read JSON input from stdin (official hooks protocol)
try {
    $inputData    = [Console]::In.ReadToEnd() | ConvertFrom-Json
    $errorMessage = $inputData.error.message
    $errorName    = $inputData.error.name
    $errorStack   = $inputData.error.stack
} catch {
    $errorMessage = "unknown"
    $errorName    = "unknown"
    $errorStack   = ""
}

# ── Configuration ──────────────────────────────────────────────────────────────
$BuildOutputPane = "Dynamics 365 Build Details"
$MaxErrorLines   = 30
# ───────────────────────────────────────────────────────────────────────────────

function Get-VsDte {
    try {
        return [System.Runtime.InteropServices.Marshal]::GetActiveObject("VisualStudio.DTE")
    } catch {
        return $null
    }
}

function Get-BuildErrors {
    param($dte)
    try {
        $panes = $dte.ToolWindows.OutputWindow.OutputWindowPanes
        foreach ($pane in $panes) {
            if ($pane.Name -eq $BuildOutputPane) {
                $pane.Activate()
                $sel = $pane.TextDocument.Selection
                $sel.SelectAll()
                $text = $sel.Text
                $lines = ($text -split "`n") | Where-Object { $_ -match "\berror\b" -and $_ -notmatch "^Build" }
                return $lines | Select-Object -First $MaxErrorLines
            }
        }
    } catch {}
    return @()
}

Write-Host ""
Write-Host "=== errorOccurred: [$errorName] $errorMessage ===" -ForegroundColor Red

$dte = Get-VsDte
if (-not $dte) {
    Write-Host "  ⚠️  Visual Studio not running — cannot capture VS build errors" -ForegroundColor Yellow
    Write-Host "  Agent error details: [$errorName] $errorMessage"
    exit 0
}

$buildErrors = Get-BuildErrors -dte $dte

if ($buildErrors.Count -eq 0) {
    Write-Host "  ℹ️  No X++ compile errors found in '$BuildOutputPane' pane"
    Write-Host "  Agent error: [$errorName] $errorMessage"
    if ($errorStack) { Write-Host "  Stack: $errorStack" }
} else {
    Write-Host "  ❌ $($buildErrors.Count) compile error(s) found:" -ForegroundColor Red
    Write-Host ""
    Write-Host "  --- ERRORS FOR COPILOT SELF-FIX ---"
    foreach ($line in $buildErrors) {
        Write-Host "  $line" -ForegroundColor Yellow
    }
    Write-Host "  ------------------------------------"
    Write-Host ""
    Write-Host "  Next steps for Copilot:" -ForegroundColor Cyan
    Write-Host "  1. Parse the error lines above"
    Write-Host "  2. Use d365-metadata-lookup (find-type.ps1) to verify any unknown type names"
    Write-Host "  3. Fix the X++ XML in the affected class file"
    Write-Host "  4. Trigger d365-build-and-deploy to rebuild"
}

Write-Host ""
exit 0

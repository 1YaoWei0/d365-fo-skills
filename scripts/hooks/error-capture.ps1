<#
.SYNOPSIS
    errorOccurred hook — when any tool exits with an error, opens the VS Output
    pane, extracts error lines, and feeds them back to Copilot for self-fix.

.DESCRIPTION
    Fires whenever any Copilot tool use exits with a non-zero exit code.

    What it does:
    1. Connects to Visual Studio via COM (DTE)
    2. Reads the "Dynamics 365 Build Details" Output pane
    3. Extracts X++ compile error lines
    4. Outputs them in a structured format that Copilot can parse
    5. Copilot then invokes d365-metadata-lookup to verify types, fixes
       the X++ XML, and triggers a rebuild
#>

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
Write-Host "=== errorOccurred: Capturing build errors for self-fix ===" -ForegroundColor Red

$dte = Get-VsDte
if (-not $dte) {
    Write-Host "  ⚠️  Visual Studio not running — cannot capture error details" -ForegroundColor Yellow
    exit 0
}

$errors = Get-BuildErrors -dte $dte

if ($errors.Count -eq 0) {
    Write-Host "  ℹ️  No X++ compile errors found in '$BuildOutputPane' pane"
    Write-Host "  Check the error reported by the failing tool directly."
} else {
    Write-Host "  ❌ $($errors.Count) compile error(s) found:" -ForegroundColor Red
    Write-Host ""
    Write-Host "  --- ERRORS FOR COPILOT SELF-FIX ---"
    foreach ($line in $errors) {
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

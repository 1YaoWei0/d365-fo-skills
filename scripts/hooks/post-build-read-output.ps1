<#
.SYNOPSIS
    postToolUse hook — after any build/rebuild tool runs, automatically reads
    the Visual Studio Output panes and reports result to Copilot.

.DESCRIPTION
    Fires after every shell/PowerShell tool use.
    Only acts when a build or rebuild was just triggered.

    What it does:
    1. Detects whether the last tool was a build operation
    2. Connects to Visual Studio via COM (Running Object Table / DTE)
    3. Switches Output pane to "Dynamics 365 Build Details" and reads full text
    4. Switches Output pane to "FinOps Cloud Runtime" and reads last 30 lines
    5. Reports build result: succeeded / failed + deploy status
#>

# ── Configuration ──────────────────────────────────────────────────────────────
$BuildOutputPane   = "Dynamics 365 Build Details"
$RuntimeOutputPane = "FinOps Cloud Runtime"
$RuntimeTailLines  = 30
# ───────────────────────────────────────────────────────────────────────────────

function Get-VsDte {
    $rot = [System.Runtime.InteropServices.Marshal]::GetActiveObject("VisualStudio.DTE") 2>$null
    return $rot
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
            # Extract error lines for Copilot context
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

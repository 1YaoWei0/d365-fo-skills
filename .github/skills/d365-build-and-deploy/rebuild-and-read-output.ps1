<#
.SYNOPSIS
    rebuild-and-read-output.ps1 — connects to Visual Studio via DTE COM automation,
    triggers Build.RebuildSolution, polls until complete, reads both VS Output panes,
    and optionally sends F5 to launch the class runner.

.PARAMETER StartAfterBuild
    If specified and build succeeds, sends F5 to VS to start the class runner in the browser.

.PARAMETER StaleCache
    If specified, closes and reopens VS before rebuilding (fixes stale-cache build failures).

.EXAMPLE
    .\rebuild-and-read-output.ps1
    .\rebuild-and-read-output.ps1 -StartAfterBuild
    .\rebuild-and-read-output.ps1 -StaleCache
#>

param(
    [switch]$StartAfterBuild,
    [switch]$StaleCache
)

# ── Configuration ──────────────────────────────────────────────────────────────
$VSPath            = "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"
$SolutionFile      = ""           # Full path to your .slnx — set before use
$BuildOutputPane   = "Dynamics 365 Build Details"
$RuntimeOutputPane = "FinOps Cloud Runtime"
$RuntimeTailLines  = 30
$PollIntervalSecs  = 5
$BuildTimeoutSecs  = 600
# ───────────────────────────────────────────────────────────────────────────────

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
        $panes = $dte.ToolWindows.OutputWindow.OutputWindowPanes
        foreach ($pane in $panes) {
            if ($pane.Name -eq $PaneName) {
                $pane.Activate()
                $sel = $pane.TextDocument.Selection
                $sel.SelectAll()
                return $sel.Text
            }
        }
    } catch {}
    return $null
}

# ── Stale-cache fix ───────────────────────────────────────────────────────────
if ($StaleCache) {
    Write-Host "⚠️  Stale-cache fix: closing VS and reopening..." -ForegroundColor Yellow
    $vsProc = Get-Process -Name "devenv" -ErrorAction SilentlyContinue
    if ($vsProc) {
        $vsProc | Stop-Process -Force
        Start-Sleep -Seconds 5
    }
    if ($SolutionFile -and (Test-Path $SolutionFile)) {
        Start-Process -FilePath $VSPath -ArgumentList "`"$SolutionFile`""
        Write-Host "⏳ Waiting 60s for VS to reload..."
        Start-Sleep -Seconds 60
    } else {
        Write-Error "SolutionFile not configured — cannot reopen VS automatically"
        exit 1
    }
}

# ── Get DTE ───────────────────────────────────────────────────────────────────
$dte = Get-VsDte
if (-not $dte) {
    Write-Error "Visual Studio is not running. Start VS with the solution first (sessionStart hook will do this automatically)."
    exit 1
}

# ── Trigger rebuild ───────────────────────────────────────────────────────────
Write-Host ""
Write-Host "=== D365 Build and Deploy ===" -ForegroundColor Cyan
Write-Host "  Triggering Build.RebuildSolution..."
$dte.ExecuteCommand("Build.RebuildSolution")

# ── Poll build state ──────────────────────────────────────────────────────────
# vsBuildState: 1=not started, 2=in progress, 3=done
$elapsed = 0
do {
    Start-Sleep -Seconds $PollIntervalSecs
    $elapsed += $PollIntervalSecs
    $state = $dte.Solution.SolutionBuild.BuildState
    Write-Host "  ⏳ Building... ($elapsed s elapsed)" -NoNewline
    Write-Host "`r" -NoNewline
    if ($elapsed -ge $BuildTimeoutSecs) {
        Write-Host ""
        Write-Error "Build timed out after ${BuildTimeoutSecs}s"
        exit 1
    }
} while ($state -eq 2)
Write-Host ""

# ── Read Output panes ─────────────────────────────────────────────────────────
$buildOutput = Read-OutputPane -dte $dte -PaneName $BuildOutputPane

if ($buildOutput -match "Build succeeded") {
    Write-Host "  ✅ Build: SUCCEEDED" -ForegroundColor Green
    $buildPassed = $true
} elseif ($buildOutput -match "Build FAILED") {
    Write-Host "  ❌ Build: FAILED" -ForegroundColor Red
    $buildPassed = $false
    $errorLines = ($buildOutput -split "`n") | Where-Object { $_ -match "\berror\b" } | Select-Object -First 20
    Write-Host "  --- Errors ---"
    $errorLines | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
} else {
    Write-Host "  ⚠️  Build state unclear — check VS Output manually" -ForegroundColor Yellow
    $buildPassed = $false
}

# FinOps Cloud Runtime (deploy status)
$runtimeOutput = Read-OutputPane -dte $dte -PaneName $RuntimeOutputPane
if ($runtimeOutput) {
    $tail = ($runtimeOutput -split "`n") | Select-Object -Last $RuntimeTailLines
    Write-Host "  --- FinOps Cloud Runtime (last $RuntimeTailLines lines) ---"
    $tail | ForEach-Object { Write-Host "  $_" }
}

# ── Start after build ─────────────────────────────────────────────────────────
if ($StartAfterBuild -and $buildPassed) {
    Write-Host ""
    Write-Host "  Sending F5 to VS to launch class runner..." -ForegroundColor Cyan
    $dte.ExecuteCommand("Debug.Start")
    Write-Host "  ✅ Class runner launched in browser"
}

Write-Host ""
if ($buildPassed) {
    Write-Host "=== Build complete ✅ ===" -ForegroundColor Green
} else {
    Write-Host "=== Build failed — fix errors above and rebuild ===" -ForegroundColor Red
    exit 1
}

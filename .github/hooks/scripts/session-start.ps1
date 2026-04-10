<#
.SYNOPSIS
    sessionStart hook — verifies the D365 F&O development environment and auto-launches
    Visual Studio if it is not already running.

.DESCRIPTION
    Fires automatically every time Copilot CLI opens a session.
    Reads JSON context from stdin (timestamp, cwd, source, initialPrompt).
    Checks all prerequisites and reports environment status.

    Checks performed:
    1. Repository exists at expected path
    2. Current git branch
    3. PackagesLocalDirectory (CBA model) is accessible
    4. Solution file (.slnx) exists
    5. Visual Studio (devenv.exe) is running — if not, auto-launches it with the solution
    6. Solution is loaded in VS (via DTE COM automation)

.NOTES
    Configure the paths below to match your environment before first use.
    Called by hooks.json with cwd=".github/hooks", so paths resolve from there.
#>

$ErrorActionPreference = "Stop"

# Read JSON input from stdin (official hooks protocol)
try {
    $inputData = [Console]::In.ReadToEnd() | ConvertFrom-Json
    $sessionSource = $inputData.source        # "new", "resume", or "startup"
    $initialPrompt = $inputData.initialPrompt
} catch {
    $sessionSource = "unknown"
    $initialPrompt = ""
}

# ── Configuration ──────────────────────────────────────────────────────────────
$RepoPath             = "C:\AOSService\PackagesLocalDirectory\CBA"   # Update to your repo path
$PackagesLocalDir     = "C:\AOSService\PackagesLocalDirectory"
$ModelName            = "CBA"
$SolutionFile         = ""           # Full path to your .slnx file — set before use
$VSPath               = "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"
$VSLaunchWaitSeconds  = 60
# ───────────────────────────────────────────────────────────────────────────────

$errors = @()

Write-Host ""
Write-Host "=== D365 F&O Environment Check (sessionStart: $sessionSource) ===" -ForegroundColor Cyan

# 1. Repository path
if (Test-Path $RepoPath) {
    Write-Host "  ✅ Repo:                $RepoPath"
} else {
    Write-Host "  ❌ Repo not found:     $RepoPath" -ForegroundColor Red
    $errors += "Repo path not found: $RepoPath"
}

# 2. Git branch
try {
    $branch = git -C $RepoPath rev-parse --abbrev-ref HEAD 2>&1
    Write-Host "  ✅ Git branch:          $branch"
} catch {
    Write-Host "  ⚠️  Git branch unknown" -ForegroundColor Yellow
}

# 3. PackagesLocalDirectory / model
$modelPath = Join-Path $PackagesLocalDir $ModelName
if (Test-Path $modelPath) {
    Write-Host "  ✅ Model ($ModelName):    $modelPath"
} else {
    Write-Host "  ❌ Model not found:    $modelPath" -ForegroundColor Red
    $errors += "Model path not found: $modelPath"
}

# 4. Solution file
if ($SolutionFile -and (Test-Path $SolutionFile)) {
    Write-Host "  ✅ Solution file:       $SolutionFile"
} elseif (-not $SolutionFile) {
    Write-Host "  ⚠️  Solution file path not configured (set `$SolutionFile in session-start.ps1)" -ForegroundColor Yellow
} else {
    Write-Host "  ❌ Solution file not found: $SolutionFile" -ForegroundColor Red
    $errors += "Solution file not found: $SolutionFile"
}

# 5. Visual Studio running?
$vsProcess = Get-Process -Name "devenv" -ErrorAction SilentlyContinue
if ($vsProcess) {
    Write-Host "  ✅ Visual Studio:       running (PID $($vsProcess.Id))"
} else {
    Write-Host "  ⚠️  Visual Studio not running — auto-launching..." -ForegroundColor Yellow
    if ($SolutionFile -and (Test-Path $SolutionFile)) {
        Start-Process -FilePath $VSPath -ArgumentList "`"$SolutionFile`""
        Write-Host "  ⏳ Waiting ${VSLaunchWaitSeconds}s for VS to load..."
        Start-Sleep -Seconds $VSLaunchWaitSeconds
        $vsProcess = Get-Process -Name "devenv" -ErrorAction SilentlyContinue
        if ($vsProcess) {
            Write-Host "  ✅ Visual Studio launched (PID $($vsProcess.Id))"
        } else {
            Write-Host "  ❌ VS did not start within ${VSLaunchWaitSeconds}s" -ForegroundColor Red
            $errors += "Visual Studio failed to launch"
        }
    } else {
        Write-Host "  ⚠️  Cannot auto-launch — solution file path not configured" -ForegroundColor Yellow
    }
}

# 6. Summary
Write-Host ""
if ($errors.Count -eq 0) {
    Write-Host "=== Environment ready ✅ ===" -ForegroundColor Green
} else {
    Write-Host "=== Environment has issues ❌ ===" -ForegroundColor Red
    foreach ($e in $errors) { Write-Host "  • $e" -ForegroundColor Red }
    Write-Host "  Fix the above before developing." -ForegroundColor Yellow
}
Write-Host ""
exit 0

# ── Configuration ──────────────────────────────────────────────────────────────
$RepoPath             = "C:\AOSService\PackagesLocalDirectory\CBA"   # Update to your repo path
$PackagesLocalDir     = "C:\AOSService\PackagesLocalDirectory"
$ModelName            = "CBA"
$SolutionFile         = ""           # Full path to your .slnx file — set before use
$VSPath               = "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"
$VSLaunchWaitSeconds  = 60
# ───────────────────────────────────────────────────────────────────────────────

$errors = @()

Write-Host ""
Write-Host "=== D365 F&O Environment Check (sessionStart) ===" -ForegroundColor Cyan

# 1. Repository path
if (Test-Path $RepoPath) {
    Write-Host "  ✅ Repo:                $RepoPath"
} else {
    Write-Host "  ❌ Repo not found:     $RepoPath" -ForegroundColor Red
    $errors += "Repo path not found: $RepoPath"
}

# 2. Git branch
try {
    $branch = git -C $RepoPath rev-parse --abbrev-ref HEAD 2>&1
    Write-Host "  ✅ Git branch:          $branch"
} catch {
    Write-Host "  ⚠️  Git branch unknown" -ForegroundColor Yellow
}

# 3. PackagesLocalDirectory / model
$modelPath = Join-Path $PackagesLocalDir $ModelName
if (Test-Path $modelPath) {
    Write-Host "  ✅ Model ($ModelName):    $modelPath"
} else {
    Write-Host "  ❌ Model not found:    $modelPath" -ForegroundColor Red
    $errors += "Model path not found: $modelPath"
}

# 4. Solution file
if ($SolutionFile -and (Test-Path $SolutionFile)) {
    Write-Host "  ✅ Solution file:       $SolutionFile"
} elseif (-not $SolutionFile) {
    Write-Host "  ⚠️  Solution file path not configured (set `$SolutionFile in session-start.ps1)" -ForegroundColor Yellow
} else {
    Write-Host "  ❌ Solution file not found: $SolutionFile" -ForegroundColor Red
    $errors += "Solution file not found: $SolutionFile"
}

# 5. Visual Studio running?
$vsProcess = Get-Process -Name "devenv" -ErrorAction SilentlyContinue
if ($vsProcess) {
    Write-Host "  ✅ Visual Studio:       running (PID $($vsProcess.Id))"
} else {
    Write-Host "  ⚠️  Visual Studio not running — auto-launching..." -ForegroundColor Yellow
    if ($SolutionFile -and (Test-Path $SolutionFile)) {
        Start-Process -FilePath $VSPath -ArgumentList "`"$SolutionFile`""
        Write-Host "  ⏳ Waiting ${VSLaunchWaitSeconds}s for VS to load..."
        Start-Sleep -Seconds $VSLaunchWaitSeconds
        $vsProcess = Get-Process -Name "devenv" -ErrorAction SilentlyContinue
        if ($vsProcess) {
            Write-Host "  ✅ Visual Studio launched (PID $($vsProcess.Id))"
        } else {
            Write-Host "  ❌ VS did not start within ${VSLaunchWaitSeconds}s" -ForegroundColor Red
            $errors += "Visual Studio failed to launch"
        }
    } else {
        Write-Host "  ⚠️  Cannot auto-launch — solution file path not configured" -ForegroundColor Yellow
    }
}

# 6. Summary
Write-Host ""
if ($errors.Count -eq 0) {
    Write-Host "=== Environment ready ✅ ===" -ForegroundColor Green
} else {
    Write-Host "=== Environment has issues ❌ ===" -ForegroundColor Red
    foreach ($e in $errors) { Write-Host "  • $e" -ForegroundColor Red }
    Write-Host "  Fix the above before developing." -ForegroundColor Yellow
}
Write-Host ""

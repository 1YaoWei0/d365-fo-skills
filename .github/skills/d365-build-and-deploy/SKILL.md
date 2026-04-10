---
name: d365-build-and-deploy
description: Use to rebuild the D365 F&O solution via Visual Studio DTE automation, read both Output panes, and optionally start the class runner in the browser. Invoke with /d365-build-and-deploy.
---

# D365 Build and Deploy

## When to Use This Skill

Use this skill when:
- you want to rebuild the D365 F&O solution after writing or modifying X++ code
- you need the full VS rebuild (equivalent to right-click → Rebuild Solution)
- you want to read the build output and deploy status automatically without switching to VS
- you want to launch the class runner in the browser after a successful build

Invoke with: `/d365-build-and-deploy`

Optional flag: `-StartAfterBuild` — sends F5 to VS after a successful build, opening the class runner in the browser.

## What This Skill Produces

- Full `Build.RebuildSolution` equivalent (not just compile — rebuild)
- Complete text from the `Dynamics 365 Build Details` Output pane
- Last 30 lines from the `FinOps Cloud Runtime` Output pane (deploy status)
- Clear report: succeeded / failed + error lines if failed
- Browser launch (if `-StartAfterBuild` is set and build succeeded)

## Execution Flow

```text
You invoke /d365-build-and-deploy
  ↓
rebuild-and-read-output.ps1 runs:
  → Connects to Visual Studio via COM (Running Object Table / DTE)
  → Executes dte.ExecuteCommand("Build.RebuildSolution")
     ← equivalent to right-click → Rebuild Solution in VS
  → Polls dte.Solution.SolutionBuild.BuildState every 5s
  → When complete: UI Automation reads Output panes
      "Dynamics 365 Build Details" → full text (build result)
      "FinOps Cloud Runtime"       → last 30 lines (deploy status)
  → Reports: succeeded / failed + errors
  ↓
  If -StartAfterBuild and build succeeded:
    → Sends F5 to VS → Class runner opens in browser
```

## Stale-Cache Fix

If the build fails with stale-cache symptoms (random unexplained errors after previous successful builds), the script has a built-in fix:

```text
Close VS → Reopen VS with solution → Rebuild
```

This resolves most stale-cache issues without manual intervention.

## Quality Rules

- [ ] Do not invoke this skill unless X++ code is complete and syntactically valid
- [ ] Check the `Dynamics 365 Build Details` pane output — do not ignore warnings that indicate logic problems
- [ ] If build fails, use **error-capture hook** output to self-diagnose, then use **d365-metadata-lookup** to verify any unknown type names before fixing
- [ ] Confirm deploy status in `FinOps Cloud Runtime` pane — a successful build does not always mean a successful deploy

## Next Step

- If build **succeeded**: proceed to test the functionality, or close with `deployment-planning`
- If build **failed**: use `d365-metadata-lookup` to verify types, fix the X++ XML, and rebuild

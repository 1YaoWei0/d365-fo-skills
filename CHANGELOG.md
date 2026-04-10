# CHANGELOG

All notable changes to the D365 F&O Skills repository will be documented here.

## [Unreleased]

### Fixed
- **Hooks structure corrected to official GitHub Copilot CLI specification** (`.github/hooks/`):
  - `hooks.json`: rewritten — `"hooks"` is now an object keyed by event name (not an array); each entry uses `"type"`, `"bash"`/`"powershell"`, `"cwd"`, `"timeoutSec"`, `"comment"` per official spec
  - All hook PS1 scripts now read stdin JSON via `[Console]::In.ReadToEnd() | ConvertFrom-Json` as required
  - `session-start.ps1`: reads `source` and `initialPrompt` from input; exits with `exit 0`
  - `post-build-read-output.ps1`: reads `toolName`, `toolArgs`, `toolResult` from input; exits early if not a build tool
  - `error-capture.ps1`: reads `error.message`, `error.name`, `error.stack` from input

### Added
- `log-prompt.ps1` — `userPromptSubmitted` hook: logs redacted prompts to `.github/hooks/logs/audit.jsonl`
- `pre-tool-policy.ps1` — `preToolUse` hook: blocks format/diskpart, DROP TABLE, download-and-execute, destructive rm; warns on duty/role modifications; returns `permissionDecision` per spec
- `.github/hooks/logs/` directory (excluded from git via `.gitignore`) for local audit logs
- `.gitignore`: added `.github/hooks/logs/` exclusion rule

- **Hooks automation layer** (`hooks.json` + `scripts/hooks/`):
  - `session-start.ps1` — sessionStart hook: env check, auto-launch VS with solution
  - `post-build-read-output.ps1` — postToolUse hook: auto-read VS Output panes after build
  - `error-capture.ps1` — errorOccurred hook: extract compile errors for Copilot self-fix
- **New skill: `d365-create-runnable-class`** — scaffold X++ class XML + `.rnrproj` with team rules (no RunBase, CBA model, DeployOnline=True)
- **New skill: `d365-build-and-deploy`** — connect to VS via DTE, trigger `Build.RebuildSolution`, read `Dynamics 365 Build Details` and `FinOps Cloud Runtime` Output panes
- **New skill: `d365-metadata-lookup`** — search PackagesLocalDirectory for any type; detects views (not updatable), shows methods, shows EDT parent chain
- **New agent: `d365-xpp-developer`** — expert X++ developer agent with error self-fix protocol (read error → lookup type → fix XML → rebuild)
- **New agent: `d365-build-reader`** — read-only build monitor, never modifies files

### Changed
- Updated `.github/copilot-instructions.md`: fixed skill path references to `.github/skills/`, added environment table (model, VS path, PackagesLocalDirectory), added X++ coding rules, added hooks section, added new skills and agents to routing tables
- Updated `using-d365-fo-skills` bootstrap skill: added automation layer section, updated lifecycle diagram, expanded routing table with new skills and agents
- Updated `README.md`: added automation layer section, split skill overview into automation vs lifecycle skills, added agents table, updated primary workflow diagram
  - Added pre-review requirements (spec review, RunJob tagging, historical data, integration testing)
  - Added deployment risk section (field removal registration, index changes, duties/roles)
  - Added security and privilege completeness checks (endpoint permissions)
  - Added logic correctness and defensive coding rules (else branches, null/zero checks, cross-company, table clear())
  - Added expanded table design checklist (primary keys, precision, timezone, rounding, purchase line isdeleted, field length impacts, rollback, FormRef, table properties)
  - Added object and UI completeness requirements (Help text, Form Title Data Source, Carlsberg Asia sub-menu, financial dimension parameterization, encapsulation, call-site comments)
  - Updated severity level definitions to include new Critical and Major categories
- Initial repository structure
- Bootstrap skill: `using-d365-fo-skills`
- Core workflow skills: requirements-intake, solution-design, extension-development,
  x-class-development, form-development, data-entity-development, integration-development,
  unit-testing, systematic-debugging, deployment-planning
- Meta skill: writing-d365-skills
- Starter reviewer agent: d365-code-reviewer
- GitHub Copilot CLI integration via `.github/copilot-instructions.md`
- Test scaffolding: skill-triggering, explicit-skill-requests, d365-fo
- Docs structure: specs, plans, testing guide

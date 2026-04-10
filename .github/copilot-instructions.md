# GitHub Copilot Instructions — D365 F&O Skills

This repository is a skill system for **Dynamics 365 Finance & Operations** development.
It is designed for GitHub Copilot CLI.

## Environment

| Item | Value |
|------|-------|
| Model | CBA |
| PackagesLocalDirectory | `C:\AOSService\PackagesLocalDirectory` *(configure in hook scripts)* |
| VS path | `C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe` *(configure in hook scripts)* |
| DeployOnline | Always `True` |

## Skill System Overview

This repository contains structured skills that guide AI-assisted D365 F&O development
through the full development lifecycle. Always orient to the skill system before performing
D365 F&O development tasks.

## Skill Discovery

Skills are located in `.github/skills/<skill-name>/SKILL.md`.

Always read the relevant skill before starting work on a D365 F&O task.

## Bootstrap

When starting a D365 F&O development session or encountering an unfamiliar task,
read `.github/skills/using-d365-fo-skills/SKILL.md` first.

## Core X++ Rules

1. **Never use RunBase** — use `SysOperationServiceController` or plain class logic
2. **Always use correct EDTs** — use `d365-metadata-lookup` to verify if unsure
3. **Never perform DML on Views** — use `d365-metadata-lookup` to check Table vs View
4. **No hardcoded strings** — use label IDs
5. **No raw SQL** — use X++ select statements
6. **DeployOnline = True** on all projects
7. **Always add privileges** — endpoint permissions for services are easily missed
8. **Help text required** on every class, field, and object

## Hooks

This repository uses lifecycle hooks:

| Hook | Script | When it fires |
|------|--------|--------------|
| `sessionStart` | `scripts/hooks/session-start.ps1` | Every session open — checks env, auto-launches VS |
| `postToolUse` | `scripts/hooks/post-build-read-output.ps1` | After any build tool — reads VS Output panes |
| `errorOccurred` | `scripts/hooks/error-capture.ps1` | On tool error — extracts compile errors for self-fix |

## Skill Routing

| Task type | Skill to use |
|-----------|-------------|
| New requirement or change request | `requirements-intake` |
| Architecture or pattern decision | `solution-design` |
| Create a new runnable X++ class | `d365-create-runnable-class` |
| Rebuild solution + read VS Output | `d365-build-and-deploy` |
| Look up an X++ type (EDT/table/view/class) | `d365-metadata-lookup` |
| Extending existing D365 F&O functionality | `extension-development` |
| New X++ class, table, EDT, enum | `x-class-development` |
| Form or form extension work | `form-development` |
| Data entity, DMF, or OData | `data-entity-development` |
| External integration or custom service | `integration-development` |
| Writing or running unit tests | `unit-testing` |
| Debugging runtime errors or incorrect behavior | `systematic-debugging` |
| Deploying to an environment | `deployment-planning` |
| Adding a new skill to this repository | `writing-d365-skills` |

## Agents

| Agent | Invoke | Role |
|-------|--------|------|
| `d365-xpp-developer` | `/agent d365-xpp-developer` | Expert X++ developer — creates classes, fixes compile errors, runs error self-fix protocol |
| `d365-build-reader` | `/agent d365-build-reader` | Read-only build monitor — reports build/deploy status, never modifies files |
| `d365-code-reviewer` | *(engage directly)* | Reviews X++ changes for correctness, security, and D365 best practices |

## Testing

Skills and their triggering behavior are verified in `tests/`.
See `docs/testing.md` for the testing strategy.

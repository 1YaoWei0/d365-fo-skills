# D365 F&O Skills

A full workflow framework skill repository for **Dynamics 365 Finance & Operations** development.

Designed for small D365 F&O development teams using **GitHub Copilot CLI**.

---

## What This Is

A structured skill system that guides AI-assisted D365 F&O development through the complete development lifecycle, with **automated lifecycle hooks** that handle environment setup, build monitoring, and error capture automatically.

### Automation Layer

| Hook | Fires when | What it does |
|------|-----------|-------------|
| `sessionStart` | Every session open | Checks environment, auto-launches VS with solution |
| `postToolUse` | After any build tool | Reads VS Output panes automatically |
| `errorOccurred` | On tool error | Extracts compile errors for Copilot self-fix |

### Development Lifecycle

1. **Requirements Intake** — scope and clarify the requirement
2. **Solution Design** — choose the right D365 F&O pattern and approach
3. **Implementation** — execute using the appropriate skill
4. **Build & Verify** — rebuild via `d365-build-and-deploy`, auto-read VS Output
5. **Testing** — verify with SysTest unit tests
6. **Deployment** — plan and execute deployment through LCS or pipeline

---

## Who It's For

Small D365 F&O development teams who want consistent, disciplined AI-assisted development workflows.

---

## Platform

**GitHub Copilot CLI** — skill discovery via `.github/copilot-instructions.md`.

---

## Skill Overview

### Automation Skills (invoke directly)

| Skill | Role |
|-------|------|
| `d365-create-runnable-class` | Scaffold X++ class XML + `.rnrproj` with all team rules applied |
| `d365-build-and-deploy` | Rebuild via VS DTE, read Output panes, optional F5 browser launch |
| `d365-metadata-lookup` | Search PackagesLocalDirectory for any type (EDT/table/view/class) |

### Lifecycle Skills

| Skill | Role |
|-------|------|
| `using-d365-fo-skills` | Bootstrap — how to use this system |
| `requirements-intake` | Scope and clarify requirements |
| `solution-design` | Design using D365 F&O patterns |
| `extension-development` | Extensions, CoC, event handlers |
| `x-class-development` | X++ classes, tables, EDTs, enums |
| `form-development` | Forms and form extensions |
| `data-entity-development` | Data entities, DMF, OData |
| `integration-development` | External integrations, DIXF, custom services |
| `unit-testing` | SysTest framework test classes |
| `systematic-debugging` | Debugging X++, trace parser, event log |
| `deployment-planning` | LCS, deployable packages, pipeline |
| `writing-d365-skills` | Meta — authoring new skills for this repo |

### Agents

| Agent | Invoke | Role |
|-------|--------|------|
| `d365-xpp-developer` | `/agent d365-xpp-developer` | Expert X++ developer — creates classes, fixes errors with self-fix loop |
| `d365-build-reader` | `/agent d365-build-reader` | Read-only build monitor — reports VS Output pane status |
| `d365-code-reviewer` | *(engage directly)* | Reviews X++ for correctness, security, D365 best practices |

---

## Primary Workflow

```text
[sessionStart hook] → env check + VS auto-launch

using-d365-fo-skills (bootstrap)
  → requirements-intake
    → solution-design
      → d365-create-runnable-class (scaffold)
        → d365-build-and-deploy (rebuild + read output)
          → [if fails] errorOccurred hook → d365-metadata-lookup → fix → rebuild
            → unit-testing
              → deployment-planning
```

---

## Repository Philosophy

- **Structure over momentum** — design before generating
- **Workflow clarity** — every skill has a clear role and position in the lifecycle
- **Honest staging** — placeholders are labeled; nothing is implied as complete when it isn't
- **Testable behavior** — skill triggering and explicit invocation are verified

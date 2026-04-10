# D365 F&O Skills

A full workflow framework skill repository for **Dynamics 365 Finance & Operations** development.

Designed for small D365 F&O development teams using **GitHub Copilot CLI**.

---

## What This Is

A structured skill system that guides AI-assisted D365 F&O development through the complete development lifecycle:

1. **Requirements Intake** — scope and clarify the requirement
2. **Solution Design** — choose the right D365 F&O pattern and approach
3. **Implementation** — execute using the appropriate skill (extension, X++ class, form, data entity, integration)
4. **Testing** — verify with SysTest unit tests
5. **Debugging** — diagnose issues systematically
6. **Deployment** — plan and execute deployment through LCS or pipeline

This is not a prompt collection. It is a workflow system with a defined entry point, clear skill routing, and testable behavior.

---

## Who It's For

Small D365 F&O development teams who want consistent, disciplined AI-assisted development workflows.

---

## Platform

**GitHub Copilot CLI** — skill discovery via `.github/copilot-instructions.md`.

---

## Skill Overview

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

---

## Primary Workflow

```text
using-d365-fo-skills (bootstrap)
  → requirements-intake
    → solution-design
      → [execution skill]
        → unit-testing
          → deployment-planning
```

---

## Repository Philosophy

- **Structure over momentum** — design before generating
- **Workflow clarity** — every skill has a clear role and position in the lifecycle
- **Honest staging** — placeholders are labeled; nothing is implied as complete when it isn't
- **Testable behavior** — skill triggering and explicit invocation are verified

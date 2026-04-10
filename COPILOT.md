# D365 F&O Skills — GitHub Copilot CLI Orientation

This repository is a skill system for Dynamics 365 Finance & Operations development,
designed for use with GitHub Copilot CLI.

## How to Use

Skills in this repository are loaded automatically when you work on D365 F&O tasks.
The skill system guides you through a structured development lifecycle:

1. Start with `using-d365-fo-skills` for orientation
2. Use `requirements-intake` to scope and clarify what you're building
3. Use `solution-design` to select the right D365 F&O pattern
4. Use the appropriate execution skill based on your task type
5. Verify with `unit-testing` before deployment
6. Plan deployment with `deployment-planning`

## Skills Available

- `using-d365-fo-skills` — bootstrap and orientation
- `requirements-intake` — scope requirements
- `solution-design` — design and pattern selection
- `extension-development` — extension model, chain of command
- `x-class-development` — X++ classes, tables, EDTs, enums
- `form-development` — forms and form extensions
- `data-entity-development` — data entities, DMF, OData
- `integration-development` — integrations, DIXF, custom services
- `unit-testing` — SysTest framework
- `systematic-debugging` — debugging and trace analysis
- `deployment-planning` — LCS and deployable packages
- `writing-d365-skills` — extending this repository

## Repository Structure

- `skills/` — all skill definitions
- `agents/` — reviewer agent roles
- `docs/` — design specs and plans
- `tests/` — behavior verification

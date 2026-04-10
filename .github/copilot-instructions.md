# GitHub Copilot Instructions — D365 F&O Skills

This repository is a skill system for **Dynamics 365 Finance & Operations** development.
It is designed for GitHub Copilot CLI.

## Skill System Overview

This repository contains structured skills that guide AI-assisted D365 F&O development
through the full development lifecycle. Always orient to the skill system before performing
D365 F&O development tasks.

## Skill Discovery

Skills are located in `skills/<skill-name>/SKILL.md`.

Always read the relevant skill before starting work on a D365 F&O task.

## Bootstrap

When starting a D365 F&O development session or encountering an unfamiliar task,
read `skills/using-d365-fo-skills/SKILL.md` first.

## Core Principles

1. **Clarify before implementing** — use requirements-intake to scope the work
2. **Design before coding** — use solution-design to select the right D365 F&O pattern
3. **Use the extension model** — prefer extensions over modifications
4. **Test before deploying** — write SysTest classes; use unit-testing skill
5. **Plan deployment explicitly** — never deploy without a deployment plan

## Skill Routing

| Task type | Skill to use |
|-----------|-------------|
| New requirement or change request | requirements-intake |
| Architecture or pattern decision | solution-design |
| Extending existing D365 F&O functionality | extension-development |
| New X++ class, table, EDT, enum | x-class-development |
| Form or form extension work | form-development |
| Data entity, DMF, or OData | data-entity-development |
| External integration or custom service | integration-development |
| Writing or running unit tests | unit-testing |
| Debugging runtime errors or incorrect behavior | systematic-debugging |
| Deploying to an environment | deployment-planning |
| Adding a new skill to this repository | writing-d365-skills |
| Code review of X++ changes | use the d365-code-reviewer agent |

## Reviewer Agent

For X++ code review, engage the reviewer agent defined in `agents/d365-code-reviewer.md`.

## Testing

Skills and their triggering behavior are verified in `tests/`.
See `docs/testing.md` for the testing strategy.

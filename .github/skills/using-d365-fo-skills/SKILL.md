---
name: using-d365-fo-skills
description: Bootstrap orientation skill for the D365 F&O skill system. Read this first when starting a Dynamics 365 Finance & Operations development session or when unsure which skill to use.
---

# Using D365 F&O Skills

## When to Use This Skill

Read this skill:
- at the start of a new D365 F&O development session
- when you are unsure which skill applies to your current task
- when onboarding to this skill repository for the first time

## What This System Is

This repository is a workflow-oriented skill system for Dynamics 365 Finance & Operations development.

It is not a collection of isolated prompts. It is a structured development framework with:
- a defined entry point (this skill)
- a full development lifecycle
- automated lifecycle hooks (session setup, build reading, error capture)
- skill routing by task type
- quality verification before deployment

## Automation Layer (Hooks)

The repository includes **lifecycle hooks** that fire automatically:

| Hook | When | What it does |
|------|------|-------------|
| `sessionStart` | Every session open | Checks environment, auto-launches VS with solution |
| `postToolUse` | After any build tool | Reads VS Output panes automatically |
| `errorOccurred` | On tool error | Extracts compile errors, feeds them back for self-fix |

These hooks are configured in `hooks.json` and run from `scripts/hooks/`.

## The Development Lifecycle

```text
[Session opens]
  → sessionStart hook: env check, VS auto-launch

requirements-intake (clarify the requirement)
  → solution-design (choose the right D365 F&O approach)
    → [execution skill based on task type]
        d365-create-runnable-class  ← scaffold X++ class + project file
        extension-development
        x-class-development
        form-development
        data-entity-development
        integration-development
      → d365-build-and-deploy (rebuild via DTE → read Output panes)
        → [if build fails] errorOccurred hook → d365-metadata-lookup → fix → rebuild
          → [if build succeeds] unit-testing (SysTest verification)
            → deployment-planning (plan and execute deployment)
```

## How to Route to the Right Skill

| What you are doing | Skill to use |
|--------------------|-------------|
| Scoping a new feature or change request | `requirements-intake` |
| Choosing an implementation approach or pattern | `solution-design` |
| **Creating a new runnable X++ class** | `d365-create-runnable-class` |
| **Rebuilding solution + reading VS Output** | `d365-build-and-deploy` |
| **Looking up a type (EDT/table/view/class)** | `d365-metadata-lookup` |
| Extending existing D365 F&O objects | `extension-development` |
| Writing a new X++ class, table, EDT, or enum | `x-class-development` |
| Building or modifying a form | `form-development` |
| Creating a data entity, DMF job, or OData endpoint | `data-entity-development` |
| Building an integration with an external system | `integration-development` |
| Writing or running unit tests | `unit-testing` |
| Diagnosing a runtime error or unexpected behavior | `systematic-debugging` |
| Planning or executing a deployment | `deployment-planning` |
| Adding a new skill to this repository | `writing-d365-skills` |
| Reviewing X++ code changes | `d365-code-reviewer` agent |
| **Expert X++ creation + error self-fix** | `/agent d365-xpp-developer` |
| **Read-only build status monitoring** | `/agent d365-build-reader` |

## Core Principles

1. **Clarify before implementing.** Do not start coding until the requirement is clear. Use `requirements-intake` to establish scope.
2. **Design before coding.** Use `solution-design` to select the correct D365 F&O pattern before writing X++.
3. **Prefer the extension model.** Always prefer extensions, chain of command, and event handlers over modifications to standard objects.
4. **Test before deploying.** Write and run SysTest unit tests using the `unit-testing` skill before any deployment.
5. **Plan deployment explicitly.** Use `deployment-planning` before deploying to any environment.

## When to Stop and Ask

Stop and ask the user for clarification when:
- the requirement is ambiguous or contradictory
- the correct D365 F&O pattern is not clear
- the target environment or deployment context is unknown
- standard extension patterns cannot address the requirement cleanly

## What This Skill Does Not Do

This skill does not perform implementation work. It orients you to the system and routes you to the correct execution skill.

Once you have identified the right skill, read that skill's `SKILL.md` and proceed.

# Testing Strategy — D365 F&O Skills

This document describes the testing approach for the D365 F&O Skills repository.

---

## What We Test

We test **skill system behavior**, not X++ runtime behavior.

Specifically:
1. **Skill triggering** — does GitHub Copilot CLI automatically use the correct skill for a given task prompt?
2. **Explicit skill requests** — when a developer explicitly asks for a skill, does the system respond correctly?
3. **Workflow scenarios** — does the skill system guide a multi-step D365 F&O development scenario coherently?

---

## Test Structure

```text
tests/
├── skill-triggering/
│   └── prompts/          — prompts that should trigger a skill automatically
├── explicit-skill-requests/
│   └── prompts/          — prompts that explicitly invoke a skill by name
└── d365-fo/              — multi-step workflow scenario tests (staged for later)
```

---

## Test Suites

### skill-triggering

**Purpose:** Verify that common D365 F&O development prompts activate the correct skill without the developer explicitly naming it.

**Format:** Each file in `prompts/` is a plain text prompt. The filename describes the expected triggering skill.

**Example prompts:**
- `extension-development.md` — "I need to add a custom field to the SalesTable form and populate it from a CoC method"
- `unit-testing.md` — "How do I write a unit test for my custom service class in D365 F&O?"
- `systematic-debugging.md` — "My batch job is failing with an update conflict error — how do I fix it?"

**Pass condition:** The correct skill is invoked or referenced in the response.

### explicit-skill-requests

**Purpose:** Verify that direct requests for a named skill are honored.

**Format:** Each file in `prompts/` is an explicit invocation prompt.

**Example prompts:**
- `please-use-requirements-intake.md` — "Please use the requirements-intake skill to help me scope this requirement"
- `please-use-deployment-planning.md` — "Use the deployment-planning skill to help me plan this release"

**Pass condition:** The named skill is used and the response follows the skill's workflow.

### d365-fo (workflow scenarios)

**Purpose:** Verify that the skill system handles multi-step D365 F&O development scenarios coherently.

**Status:** Placeholder — to be populated as the team accumulates scenario examples.

**Planned scenarios:**
- New feature from intake through deployment
- Bug investigation and fix
- Integration development end-to-end

---

## Adding Tests

When adding a new skill:
1. Add a trigger prompt to `tests/skill-triggering/prompts/<skill-name>.md`
2. Add an explicit invocation prompt to `tests/explicit-skill-requests/prompts/please-use-<skill-name>.md`

When identifying a workflow gap:
1. Document the scenario as a test case in `tests/d365-fo/`

---

## Test Philosophy

- Prefer behavior contracts over brittle exact-wording assertions
- A test passes if the correct skill is applied and the response follows the skill's defined workflow
- Tests should be runnable by any team member without special tooling

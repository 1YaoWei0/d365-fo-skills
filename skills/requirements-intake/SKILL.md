---
name: requirements-intake
description: Use when starting work on a new D365 F&O feature, change request, or bug fix. Clarifies the requirement before any design or implementation begins.
---

# Requirements Intake

## When to Use This Skill

Use this skill when:
- a new feature or enhancement request has arrived
- you are investigating a reported bug or incorrect behavior
- the requirement is described informally and needs to be formalized
- you need to agree on scope before beginning design or coding

Do not move to `solution-design` until this skill has produced a clear, agreed scope.

## What This Skill Produces

- a structured requirement statement
- agreed scope boundaries (what is in scope / out of scope)
- known constraints (performance, security, data volume, backward compatibility)
- clear acceptance criteria or definition of done
- identification of affected D365 F&O objects, modules, or data areas

## Required Questions to Answer

Before proceeding to design or implementation, you MUST establish:

1. **What is the business goal?** What outcome does this change achieve?
2. **What is the trigger?** What event or condition initiates this behavior?
3. **What D365 F&O module or area is involved?** (e.g., General Ledger, Accounts Receivable, Procurement, Inventory, Project Management)
4. **What are the affected objects?** (forms, tables, data entities, batch jobs, reports, integrations)
5. **Are there standard D365 F&O features that partially or fully address this?** Check before building custom.
6. **What are the constraints?** (performance, data volume, security roles, legal entity scope, multi-currency, intercompany)
7. **What is the acceptance criteria?** How will you know this is done and correct?

## Clarification Rules

- Do not assume the requirement is complete based on a brief description.
- Ask focused clarifying questions, one area at a time.
- If a standard D365 F&O feature meets the requirement, surface this before designing a custom solution.
- If the requirement implies a modification to standard objects (not an extension), flag this early and discuss alternatives.

## Output

Produce a structured requirement summary:

```
## Requirement Summary

**Business goal:** ...
**Trigger / condition:** ...
**D365 F&O module:** ...
**Affected objects:** ...
**Standard feature coverage:** [full / partial / none]
**Constraints:** ...
**Acceptance criteria:** ...
**Out of scope:** ...
```

When the summary is agreed, proceed to `solution-design`.

## When to Stop

If the requirement is too vague to scope, stop and ask for more information. Do not attempt to design or implement an unclear requirement.

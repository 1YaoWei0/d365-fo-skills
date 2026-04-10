---
name: solution-design
description: Use after requirements are clear. Selects the right D365 F&O implementation pattern and produces a design approach before coding begins.
---

# Solution Design

## When to Use This Skill

Use this skill after `requirements-intake` has produced a clear requirement summary, and before any implementation begins.

Do not start writing X++ until a design decision has been made and documented.

## What This Skill Produces

- chosen implementation pattern (extension, new object, data entity, integration, etc.)
- affected D365 F&O objects and their roles
- extension strategy (which objects to extend and how)
- data model decisions (new tables, table extensions, EDT changes)
- security and role-based access considerations
- performance and scalability notes
- known risks or constraints

## Design Decision Framework

### Step 1: Check standard functionality first

Before designing a custom solution:
- Can a standard D365 F&O configuration address this?
- Is there an ISV solution that covers this?
- Can a standard data entity, workflow, or business event meet the need?

Only design a custom solution if standard functionality cannot meet the requirement.

### Step 2: Choose the implementation layer

| Approach | When to use |
|----------|------------|
| Extension (CoC, event handler, table extension, form extension) | Preferred — always try this first |
| New X++ object (class, table, form, data entity) | When the requirement has no standard counterpart |
| Configuration / setup | When behavior can be driven by parameters without code |
| Integration | When data must flow to/from an external system |
| Report / SSRS | When output is a printable or exportable document |
| Batch job | When processing must run asynchronously or on a schedule |

### Step 3: Define the extension strategy

If extending standard objects:
- Identify the exact class, table, form, or data entity to extend
- Identify the method or event to hook (CoC, pre/post event handler, data event)
- Confirm extension does not require overlayering (overlayering is not acceptable)

### Step 4: Data model decisions

- Are new tables needed?
- Are table extensions needed on standard tables?
- Are new EDTs or enums needed?
- Are field group or index changes needed?

### Step 5: Security

- Which security roles need access?
- Are new duties or privileges needed?
- Are data security policies involved?

## Output

Produce a design summary before coding:

```
## Design Summary

**Implementation pattern:** ...
**Standard functionality used:** [yes / no / partial] — details
**Objects to extend:** ...
**New objects required:** ...
**Extension approach (CoC / event handler / etc.):** ...
**Data model changes:** ...
**Security changes:** ...
**Risks / constraints:** ...
```

When the design is agreed, proceed to the appropriate execution skill.

## Design Principles

1. **Extension model always first.** Never overlayer standard objects.
2. **Minimal footprint.** Add only what is needed. Avoid over-engineering.
3. **Upgrade-safe.** All customizations must survive D365 F&O version upgrades.
4. **Performance by design.** Consider query patterns, set-based operations, and cache usage from the start.

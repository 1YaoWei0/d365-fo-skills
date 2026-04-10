---
name: d365-create-runnable-class
description: Use to scaffold a new X++ runnable class (and its .rnrproj project file) in the CBA model. Applies all team X++ coding rules automatically. Invoke with /d365-create-runnable-class.
---

# D365 Create Runnable Class

## When to Use This Skill

Use this skill when:
- you need to create a new X++ runnable class from scratch
- you need to scaffold the correct XML structure and project file in one command
- you want Copilot to apply all team X++ coding rules automatically (no RunBase, correct model, correct EDTs)

Invoke with: `/d365-create-runnable-class`

## What This Skill Produces

- A correctly structured X++ class XML file in `PackagesLocalDirectory\CBA\<ClassName>\`
- A `.rnrproj` Visual Studio project file referencing the new class
- All mandatory metadata applied: model = CBA, `DeployOnline = True`, correct label reference, no RunBase usage

## Coding Rules Applied

This skill enforces the following team X++ rules:

| Rule | Detail |
|------|--------|
| No RunBase | Never use `RunBase` — use `SysOperationServiceController` or direct class logic |
| Model | Always `CBA` |
| DeployOnline | Always `True` |
| EDTs | Use correct EDTs for field types — do not use primitive types directly |
| Tables vs Views | Do not perform DML (`insert`, `update`, `delete`) on views — they are not updatable |
| Label | Every class and method must have a label |
| Help text | Every class must have Help text populated |

## Execution Flow

```text
You invoke /d365-create-runnable-class
  ↓
Copilot asks: class name + brief description of what it does
  ↓
create-class.ps1 runs:
  → Creates directory: PackagesLocalDirectory\CBA\<ClassName>\
  → Writes <ClassName>.xml with correct X++ class skeleton
  → Writes <ClassName>.rnrproj with correct project references
  ↓
Copilot fills in the business logic inside the scaffolded class
  ↓
Use d365-build-and-deploy to build and verify
```

## Inputs Required

Before running the script, provide:
- **Class name** — PascalCase, descriptive, includes module prefix if applicable (e.g., `CBA_DeleteAttributeValues_RunnableClass`)
- **Purpose** — one-line description of what the class does (used for label and help text)

## Quality Rules

- [ ] Class name is PascalCase and includes a clear purpose indicator
- [ ] No `RunBase` extended — use `SysOperationServiceController` if dialog input is needed
- [ ] `DeployOnline = True` set in the project file
- [ ] Label and Help text populated
- [ ] `main()` method is the entry point
- [ ] Business logic is in a separate `run()` or named method — not crammed into `main()`

## Next Step

After the class is scaffolded and business logic is filled in, use **d365-build-and-deploy** to rebuild and verify.

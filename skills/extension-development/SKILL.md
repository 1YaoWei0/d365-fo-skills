---
name: extension-development
description: Use when implementing D365 F&O customizations via the extension model — chain of command (CoC), pre/post event handlers, table extensions, form extensions, and data entity extensions.
---

# Extension Development

## When to Use This Skill

Use this skill when:
- implementing customizations to existing D365 F&O standard objects
- writing chain of command (CoC) method wrappers
- attaching pre/post event handlers to classes, tables, or forms
- adding fields or field groups via table extensions
- adding controls or modifying form behavior via form extensions
- extending data entities

Do not overlayer standard objects. Always use the extension model.

## Core Rule

**Overlayering is not acceptable.** If a requirement cannot be met through extensions, event handlers, or chain of command, escalate the design decision before writing code.

## Extension Patterns

### Chain of Command (CoC)

Use CoC when you need to wrap or modify a method on a standard class.

```xpp
[ExtensionOf(classStr(SomeStandardClass))]
final class SomeStandardClass_MyExtension
{
    public void someMethod()
    {
        // Pre-logic here
        next someMethod();
        // Post-logic here
    }
}
```

Rules:
- Always call `next` unless there is an explicit reason not to
- CoC classes must be `final`
- Use `[ExtensionOf(classStr(...))]` attribute
- Name pattern: `<StandardClass>_<YourExtensionIdentifier>`

### Pre/Post Event Handlers

Use event handlers for lightweight before/after hooks that do not need to modify return values.

```xpp
[PreHandlerFor(classStr(SomeClass), methodStr(SomeClass, someMethod))]
public static void SomeClass_Pre_someMethod(XppPrePostArgs args)
{
    // Pre-logic
}

[PostHandlerFor(classStr(SomeClass), methodStr(SomeClass, someMethod))]
public static void SomeClass_Post_someMethod(XppPrePostArgs args)
{
    // Post-logic
}
```

### Table Extensions

Use table extensions to add fields, field groups, or indexes to standard tables.

- Created as `<StandardTable>.Extension` in the AOT
- Add only fields that belong to your extension scope
- Do not modify standard field properties

### Form Extensions

Use form extensions to add or modify controls on standard forms.

- Created as `<StandardForm>.Extension` in the AOT
- Use form event subscriptions for init/run behavior
- Prefer data source events over direct form method CoC where possible

### Data Entity Extensions

Use data entity extensions to add fields from extended tables to standard data entities.

## Quality Checklist

Before completing an extension:
- [ ] No overlayering — all changes are via extension model
- [ ] CoC calls `next` where expected
- [ ] Extension class names follow naming conventions
- [ ] No hardcoded strings — use label IDs
- [ ] No raw SQL — use X++ select statements
- [ ] Security considered — no unintended data exposure
- [ ] Unit test class written (see `unit-testing` skill)

## Next Step

After implementing the extension, use the `unit-testing` skill to write and run a SysTest class that verifies the behavior.

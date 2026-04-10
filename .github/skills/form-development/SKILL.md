---
name: form-development
description: Use when creating or modifying D365 F&O forms or form extensions, including UI patterns, data source setup, form controls, and user interaction behavior.
---

# Form Development

## When to Use This Skill

Use this skill when:
- creating a new form
- creating a form extension on a standard D365 F&O form
- adding controls, fields, or tabs to a form
- modifying form initialization, run, or data source behavior
- implementing action pane buttons, menu items, or form interactions

## Form Design Principles

1. **Use form extensions over new forms where possible.** If the need can be met by adding controls to a standard form, use a form extension.
2. **Follow D365 F&O UI patterns.** Use the correct form pattern (List Page, Details with Tabs, Simple List and Details, Dialog, etc.).
3. **Keep business logic out of the form.** Business logic belongs in service classes or table methods, not form methods.
4. **Use data source methods, not display methods for performance.** Display methods run per-row; computed columns or joined data sources are preferred for large datasets.

## Common Form Patterns

### New Form Structure

Every D365 F&O form requires:
- a `Design` node with an appropriate pattern
- at least one data source (unless it is a pure dialog)
- a `Parts` node for FactBoxes if applicable
- an `ActionPane` if the form has actions

### Form Extension — Adding a Control

Use form extensions to add fields from extended tables or to add new UI controls.

- Add the field control to the appropriate group or tab in the extension
- Bind the control to the data source field
- Use `[FormControlEventHandler]` or `[FormDataSourceEventHandler]` for behavior

### Form Event Handler Example

```xpp
[FormEventHandler(formStr(MyForm), FormEventType::Initialized)]
public static void MyForm_OnInitialized(xFormRun _sender, FormEventArgs _e)
{
    // Form init logic
}

[FormDataSourceEventHandler(formStr(MyForm), formDataSourceStr(MyForm, MyTable), FormDataSourceEventType::ValidatingWrite)]
public static void MyTable_OnValidatingWrite(FormDataSource _sender, FormDataSourceEventArgs _e)
{
    // Validation logic before write
}
```

### Menu Item

New forms require:
- a `Display` menu item pointing to the form
- the menu item added to a menu or action pane

## Quality Checklist

Before completing form work:
- [ ] Correct form pattern applied
- [ ] Business logic not embedded in form methods — delegated to classes
- [ ] Form extension used instead of new form where appropriate
- [ ] No hardcoded labels — use label IDs
- [ ] Security privilege grants access to the menu item
- [ ] Tested interactively in a D365 F&O environment
- [ ] Unit test written for any business logic triggered from the form (see `unit-testing` skill)

## Next Step

After form work, write unit tests for any business logic triggered by the form. Use the `unit-testing` skill.

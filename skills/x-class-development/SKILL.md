---
name: x-class-development
description: Use when creating new X++ classes, tables, extended data types (EDTs), enums, or other base AOT objects in D365 F&O.
---

# X++ Class Development

## When to Use This Skill

Use this skill when:
- creating a new X++ class (service class, helper class, controller, DP class, etc.)
- creating a new table or view
- creating new extended data types (EDTs) or base enums
- creating a new batch job class
- creating a new runnable class

## X++ Class Patterns

### Service Class

For business logic that must be callable from other objects, integrations, or services.

```xpp
class MyCustomService
{
    public void processRequest(MyRequestContract _contract)
    {
        // Validate
        // Execute business logic
        // Return or update
    }
}
```

### Data Contract

For passing structured data between layers (e.g., SRS reports, services).

```xpp
[DataContractAttribute]
class MyDataContract
{
    SomeEDT myField;

    [DataMemberAttribute]
    public SomeEDT parmMyField(SomeEDT _myField = myField)
    {
        myField = _myField;
        return myField;
    }
}
```

### Batch Job (RunBaseBatch)

For scheduled or asynchronous processing.

```xpp
class MyBatchJob extends RunBaseBatch
{
    public void run()
    {
        // Processing logic
    }

    public static ClassDescription description()
    {
        return "My Batch Job Description";
    }
}
```

### Runnable Class (main entry point)

```xpp
class MyRunnableClass
{
    public static void main(Args _args)
    {
        // Entry point logic
    }
}
```

## Table Design Rules

- Use EDTs for all field data types — do not use primitive types directly on table fields
- Define field groups logically (AutoReport, AutoLookup, etc.)
- Add indexes for all frequently queried fields
- Apply delete actions where referential integrity is needed
- Use `RecId` as the surrogate key; use natural keys for display and lookups

## EDT Rules

- Extend from an appropriate base EDT — do not create EDTs from scratch when a suitable parent exists
- Set label, help text, and format properties
- Use consistent naming: `MyModuleMyFieldEDT` or a similar clear convention

## Enum Rules

- Use base enums for fixed sets of values
- Add label to every enum value
- Keep enums focused — do not add unrelated values to an existing enum

## Quality Checklist

Before completing a new X++ object:
- [ ] Naming follows team conventions
- [ ] All fields use EDTs, not primitive types
- [ ] No hardcoded strings — use label IDs
- [ ] No raw SQL — use X++ select with proper where clauses
- [ ] Set-based operations used where possible (not row-by-row loops for large data)
- [ ] Error handling in place (try/catch where appropriate)
- [ ] Unit test class written (see `unit-testing` skill)

## Next Step

After creating the X++ object, use the `unit-testing` skill to verify behavior with a SysTest class.

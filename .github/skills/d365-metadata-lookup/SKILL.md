---
name: d365-metadata-lookup
description: Use to search PackagesLocalDirectory for any X++ EDT, table, view, class, or enum by name. Detects views (not updatable), shows underlying tables, shows method signatures. Invoke with /d365-metadata-lookup.
---

# D365 Metadata Lookup

## When to Use This Skill

Use this skill when:
- a compile error references an unknown or misspelled type name
- you need to verify whether a name is a Table or a View (views are not updatable — DML will fail)
- you need to find which EDT to use for a field
- you need to see method signatures on a class or table
- you need to locate where in `PackagesLocalDirectory` a type is defined

Invoke with: `/d365-metadata-lookup`

This skill is also invoked automatically by the `d365-xpp-developer` agent's error self-fix protocol.

## What This Skill Produces

- Full path to the XML file defining the type
- Type category: Class / Table / View / EDT / Enum
- **View warning**: if the result is a View, flags it as not updatable and shows the underlying table(s)
- Method signatures (for classes and tables)
- Parent EDT (for EDTs) — shows the inheritance chain

## Execution Flow

```text
You invoke /d365-metadata-lookup <TypeName>
  ↓
find-type.ps1 runs:
  → Recursively searches PackagesLocalDirectory for <TypeName>.xml
  → Parses XML to determine type category (AxClass / AxTable / AxView / AxEdt / AxEnum)
  → If View: flags as not updatable, extracts data sources (underlying tables)
  → If Class / Table: extracts method names and signatures
  → If EDT: shows parent EDT chain
  → Reports full findings
```

## Inputs

- **Type name** — exact name or partial name (e.g., `SalesTable`, `CustAccount`, `PurchLine`)

## Common Use Cases

### Verifying a type exists before using it in X++

```
/d365-metadata-lookup CustTransOpen
```

### Checking if something is a View (not updatable)

If `find-type.ps1` reports `AxView`, **do not use DML** (`insert`, `update`, `delete`, `doInsert`) on it.
Use the underlying table reported in the result instead.

### Finding the right EDT for a field

```
/d365-metadata-lookup CustAccount
→ Result: AxEdt, extends AccountNum
```

Use `CustAccount` as the EDT, not `str` or `AccountNum` directly.

### Finding method signatures for CoC

```
/d365-metadata-lookup SalesLine
→ Shows method list including initFromSalesTable, modifiedField, etc.
```

## Quality Rules

- [ ] Always verify unknown type names with this skill before writing X++ that references them
- [ ] If result is a View — never perform DML. Use the underlying table instead.
- [ ] Use the EDT name found here as the field type — do not substitute primitive types

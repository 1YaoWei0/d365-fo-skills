---
name: data-entity-development
description: Use when creating or modifying D365 F&O data entities for DMF (Data Management Framework), OData, or data migration scenarios.
---

# Data Entity Development

## When to Use This Skill

Use this skill when:
- creating a new data entity for import/export via DMF
- creating a data entity to expose data via OData for Power Platform or external consumers
- extending an existing standard data entity with additional fields
- creating composite data entities for complex import scenarios
- troubleshooting data entity import/export issues

## Data Entity Design Principles

1. **One entity, one clear purpose.** Do not create a single entity that tries to do too many things.
2. **Use staging tables.** DMF entities use staging tables; always configure the staging table properly.
3. **Validate on import.** Implement `validateWrite` and use error logging — do not silently fail.
4. **OData entities require public keys.** Ensure natural key fields are marked as entity keys.
5. **Respect data security policies.** Entities must not expose data beyond the caller's security context.

## Data Entity Structure

A D365 F&O data entity consists of:
- the entity class (extends `DataEntity`)
- a staging table (for DMF entities)
- field mappings from entity fields to data source fields
- key fields
- `public` or `privateOrInternalUse` visibility

### Minimum Required Configuration

- Data source: the primary table
- Fields: mapped to EDT-typed columns
- Entity key: unique natural key fields
- Label: clear business-facing name
- Module: correct module assignment
- `IsPublic`: `Yes` for OData exposure

## Common Patterns

### Simple Table Entity

Maps directly to a single table with no complex logic.

### Multi-Table Entity

Uses joins across related tables. The root data source is the primary table; additional tables are joined.

```xpp
// In the entity's data source query
this.addDataSource(tableNum(MyPrimaryTable));
// Then join related tables
```

### Data Entity Extension

To add fields from an extended table to a standard entity:
- Create a data entity extension (`.Extension`) in the AOT
- Add the extended table as an additional data source
- Map new fields to entity fields

## DMF Import Checklist

Before releasing a DMF entity for use:
- [ ] Staging table exists and maps correctly
- [ ] `validateWrite` implemented with meaningful error messages
- [ ] Default values set where appropriate
- [ ] Tested with a sample import file (CSV or Excel)
- [ ] Error log reviewed — no silent failures
- [ ] Security privilege grants access to the entity

## OData Entity Checklist

Before exposing an entity via OData:
- [ ] `IsPublic = Yes`
- [ ] Entity key fields defined
- [ ] Fields do not expose sensitive data beyond role access
- [ ] Tested via OData endpoint in a browser or Postman

## Next Step

After creating a data entity, use the `unit-testing` skill to write a SysTest class that exercises the entity's import/export logic. For OData entities, verify the endpoint response manually.

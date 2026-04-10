---
name: systematic-debugging
description: Use when diagnosing runtime errors, incorrect behavior, or unexpected output in D365 F&O X++ code. Provides a structured approach to isolating and resolving issues.
---

# Systematic Debugging

## When to Use This Skill

Use this skill when:
- a D365 F&O operation throws an unexpected error or exception
- output or data is incorrect and the cause is not obvious
- a unit test is failing and the root cause needs to be identified
- performance is degrading and the source needs to be traced
- an import or integration is failing silently or partially

## Debugging Approach

### Step 1: Reproduce the issue

Before diagnosing, ensure you can reproduce the issue reliably:
- What exact steps trigger the problem?
- Does it happen always or intermittently?
- Does it happen for all users or specific users / companies?
- Does it happen in all environments or only specific ones?

### Step 2: Gather information before guessing

Collect before forming hypotheses:
- The exact error message and stack trace (from the Action Center or Infolog)
- The exact record or data that triggers the issue
- The exact user role and legal entity context
- Recent deployments or configuration changes that precede the issue

### Step 3: Use the D365 F&O debugging tools

**Infolog / Action Center:**
- Check `Info`, `Warning`, and `Error` messages in the session Infolog
- Review the Action Center for detailed error context

**Visual Studio Debugger (X++ Debugger):**
- Attach Visual Studio to the AOS
- Set breakpoints in the relevant X++ method
- Step through execution to identify unexpected state

**Trace Parser:**
- Capture an execution trace for performance issues
- Open the trace in Trace Parser to identify slow queries, locks, or CPU-heavy methods

**Event Viewer / LCS Environment Monitoring:**
- Check Windows Event Viewer on the AOS for .NET exceptions
- Use LCS Environment Monitoring for production-level health

### Step 4: Isolate the problem

- Can the issue be reproduced with a minimal test case?
- Is the issue in the custom code or standard D365 F&O code?
- Does removing the customization resolve the issue? (confirms root cause layer)
- Is the issue data-driven? (test with clean test data)

### Step 5: Fix and verify

- Fix the smallest change that resolves the root cause
- Do not fix symptoms — fix the root cause
- Write or update a unit test that would have caught this issue
- Verify the fix in the development environment before deploying

## Common D365 F&O Error Patterns

| Symptom | Likely cause |
|---------|-------------|
| `Cannot select a record` | Missing or incorrect where clause; record deleted; wrong company context |
| `Update conflict` | Optimistic concurrency — use `retry` block in `catch` |
| `Object reference not set` | Null check missing — verify object is initialized before use |
| Incorrect totals or amounts | Missing currency conversion; incorrect sign convention |
| Import fails silently | Staging table validation errors — check staging table error log |
| OData call returns 401/403 | Insufficient security role or entity not public |
| Batch job not running | Batch group not running; batch is in waiting state; AOS batch thread count |

## Quality Rule

Do not deploy a fix without understanding the root cause. A fix that resolves symptoms without fixing the cause will recur.

## Next Step

After confirming the fix:
1. Write or update a unit test to cover the fixed behavior
2. Use the `unit-testing` skill to verify
3. Proceed to `deployment-planning` when tests pass

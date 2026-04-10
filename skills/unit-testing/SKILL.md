---
name: unit-testing
description: Use when writing or running unit tests for D365 F&O X++ code using the SysTest framework. Required before any deployment.
---

# Unit Testing

## When to Use This Skill

Use this skill when:
- writing unit tests for newly implemented X++ logic
- verifying that a bug fix does not regress existing behavior
- reviewing test coverage before deployment
- setting up a test class for a new X++ class or service

Unit tests are **required** before deployment. Do not use `deployment-planning` until unit tests exist and pass.

## D365 F&O Testing Framework

D365 F&O uses the **SysTest** framework for X++ unit testing.

### Test Class Structure

```xpp
[SysTestClassAttribute]
class MyServiceTest extends SysTestCase
{
    // Test fixture: runs before each test method
    public void setUp()
    {
        // Initialize common test state
    }

    // Test fixture: runs after each test method
    public void tearDown()
    {
        // Clean up test state
    }

    // Test method — prefix with "test"
    [SysTestMethodAttribute]
    public void testMyMethod_WhenCondition_ShouldExpectedBehavior()
    {
        // Arrange
        MyService service = new MyService();

        // Act
        boolean result = service.myMethod(someInput);

        // Assert
        this.assertTrue(result, 'Expected myMethod to return true for valid input');
    }
}
```

### Test Method Naming Convention

```
test<MethodName>_When<Condition>_Should<ExpectedBehavior>
```

Examples:
- `testProcessOrder_WhenQuantityIsZero_ShouldThrowError`
- `testCalculateTotal_WhenDiscountApplied_ShouldReduceAmount`
- `testValidate_WhenRequiredFieldMissing_ShouldReturnFalse`

## Assert Methods

| Method | Use for |
|--------|---------|
| `this.assertTrue(condition, message)` | Assert a boolean condition is true |
| `this.assertFalse(condition, message)` | Assert a boolean condition is false |
| `this.assertEqual(expected, actual, message)` | Assert two values are equal |
| `this.assertNotNull(value, message)` | Assert a value is not null |
| `this.assertNull(value, message)` | Assert a value is null |
| `this.fail(message)` | Explicitly fail a test |

## What to Test

For each class or service:
- **Happy path:** valid inputs produce the expected output
- **Error cases:** invalid inputs trigger the expected error or false return
- **Boundary conditions:** edge values (zero, empty, maximum) behave correctly
- **State changes:** database writes or updates occur when expected

## Running Tests

Run tests in Visual Studio:
1. Open the test class in Visual Studio
2. Right-click → **Run tests** (or use Test Explorer)
3. Review results — all tests must pass before deployment

## Test Quality Rules

- Each test method tests **one behavior**, not multiple
- Tests must be independent — no test should depend on another test's state
- Use `setUp` and `tearDown` to manage shared state
- Do not test D365 F&O platform behavior — only test your custom logic
- Tests must pass consistently — flaky tests are not acceptable

## Quality Checklist

Before considering implementation complete:
- [ ] At least one test class exists for each new X++ class or service
- [ ] Happy path covered
- [ ] Key error cases covered
- [ ] All tests pass in the development environment
- [ ] No test relies on external system state (use mocks or test data setup)

## Next Step

Once all unit tests pass, use the `deployment-planning` skill to plan the deployment.

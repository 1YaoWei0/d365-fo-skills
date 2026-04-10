---
name: integration-development
description: Use when building integrations between D365 F&O and external systems — including DIXF-based imports/exports, custom services, business events, and REST/SOAP integrations.
---

# Integration Development

## When to Use This Skill

Use this skill when:
- building a data import from an external system into D365 F&O
- building a data export from D365 F&O to an external system
- creating a custom service (X++ service class exposed as an endpoint)
- consuming an external REST or SOAP API from D365 F&O
- using business events to notify external systems of D365 F&O events
- configuring or troubleshooting DIXF (Data Import/Export Framework) pipelines

## Integration Patterns in D365 F&O

### Pattern 1: Data Management (DIXF)

Use when: bulk import or export of structured data (master data, transactional data).

Key components:
- Data entity (see `data-entity-development` skill)
- Data management project (DMF project)
- Recurring integration (for scheduled file-based imports)
- Staging table validation

### Pattern 2: Business Events

Use when: external systems need to be notified when something happens in D365 F&O (e.g., purchase order confirmed, sales order shipped).

Key components:
- Standard or custom business event class
- Business event endpoint (Dataverse, Azure Service Bus, Logic Apps, etc.)
- Payload definition (`BusinessEventsContract`)

### Pattern 3: Custom X++ Service (OData / SOAP)

Use when: an external system needs to call D365 F&O logic directly via a service endpoint.

```xpp
[SysEntryPointAttribute(true)]
public class MyCustomService
{
    public MyResponseContract processRequest(MyRequestContract _contract)
    {
        // Validate contract
        // Execute logic
        // Return response
    }
}
```

- Register the service in the AOT as a `Service` object
- Add the service to a `Service Group`
- Expose via AIF (Application Integration Framework) or as an OData action

### Pattern 4: Consuming an External REST API

Use when: D365 F&O needs to call an external system.

```xpp
System.Net.Http.HttpClient httpClient = new System.Net.Http.HttpClient();
System.Net.Http.HttpResponseMessage response;
str requestBody = '{"key":"value"}';
System.Net.Http.StringContent content = new System.Net.Http.StringContent(
    requestBody,
    System.Text.Encoding::UTF8,
    'application/json'
);
response = httpClient.PostAsync('https://api.example.com/endpoint', content).Result;
str responseBody = response.Content.ReadAsStringAsync().Result;
```

Always:
- Handle exceptions (network failure, timeout, non-2xx status)
- Log errors with meaningful context
- Use connection parameters from a setup table — never hardcode URLs or credentials

## Integration Quality Checklist

Before releasing an integration:
- [ ] No hardcoded credentials, URLs, or environment-specific values — use setup/parameter tables
- [ ] Error handling in place — failures are logged and surfaced, not silently swallowed
- [ ] Retry logic considered for transient failures
- [ ] Integration tested end-to-end in a non-production environment
- [ ] Volume and performance considered — large payload handling tested
- [ ] Security: only authorized roles can trigger or configure the integration
- [ ] Idempotency: re-running the integration does not create duplicate records

## Next Step

After building the integration, use the `unit-testing` skill to write tests for the business logic layer. Integration endpoints should be tested end-to-end in a development or UAT environment.

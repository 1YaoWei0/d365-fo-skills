---
name: deployment-planning
description: Use when planning or executing a deployment of D365 F&O customizations to a target environment via LCS, deployable packages, or Azure DevOps pipelines.
---

# Deployment Planning

## When to Use This Skill

Use this skill when:
- preparing to deploy a customization to a sandbox or production environment
- creating a deployable package from Visual Studio
- uploading and applying a package via LCS (Lifecycle Services)
- using a CI/CD pipeline (Azure DevOps) for automated deployment
- planning a hotfix or emergency deployment

Do not deploy until all unit tests pass and the change has been reviewed.

## Pre-Deployment Checklist

Before creating a deployable package:

- [ ] All unit tests pass in the development environment
- [ ] Code review completed (see `agents/d365-code-reviewer.md`)
- [ ] The change has been tested in a sandbox/UAT environment if required
- [ ] No overlayering — all changes are via extension model
- [ ] No hardcoded values or environment-specific configuration in code
- [ ] Data migration scripts prepared if required (for data model changes)
- [ ] Security changes documented (new duties, privileges, roles)
- [ ] Stakeholder sign-off for production deployments

## Creating a Deployable Package

### From Visual Studio

1. In Visual Studio, select **Dynamics 365 → Deploy → Create Deployable Package**
2. Select the models to include
3. Build the package — review for build errors before proceeding
4. The output is a `.zip` deployable package

### From Azure DevOps Pipeline

If using a CI/CD pipeline:
1. The pipeline builds the models and produces a deployable package artifact
2. Artifacts are uploaded to LCS Asset Library automatically (if configured)
3. Deployment is triggered via LCS or pipeline release stage

## Deploying via LCS

1. Log in to [LCS (Lifecycle Services)](https://lcs.dynamics.com)
2. Navigate to the target project → **Asset Library**
3. Upload the deployable package under **Software deployable package**
4. Navigate to the target environment → **Maintain → Apply updates**
5. Select the uploaded package and apply
6. Monitor the deployment status in LCS

### Environment Tiers

| Environment | Purpose | Deployment notes |
|-------------|---------|-----------------|
| Development (Tier 1) | Local dev and unit testing | Deploy directly from Visual Studio |
| Sandbox (Tier 2+) | Integration testing, UAT | Deploy via LCS |
| Production | Live system | Deploy via LCS — requires change management sign-off |

## Deployment Risks

| Risk | Mitigation |
|------|-----------|
| Build errors in package | Fix all compiler errors and warnings before packaging |
| Data model changes breaking data | Test data migration scripts in sandbox first |
| Performance regression | Run load tests in sandbox before production |
| Rollback not possible | Take an LCS snapshot/backup before production deployment |

## Post-Deployment Verification

After applying the package:
- [ ] Smoke test the changed functionality in the target environment
- [ ] Verify the Infolog shows no unexpected errors
- [ ] Confirm security access is correct for the target user roles
- [ ] Monitor LCS Health & Monitoring for any new alerts

## Emergency / Hotfix Deployment

For urgent production fixes:
1. Develop and test the fix in the development environment
2. Create a targeted deployable package containing only the hotfix models
3. Apply to production via LCS with expedited approval
4. Document the hotfix in CHANGELOG.md and the issue tracker

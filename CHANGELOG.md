# CHANGELOG

All notable changes to the D365 F&O Skills repository will be documented here.

## [Unreleased]

### Changed
- Expanded `agents/d365-code-reviewer.md` with detailed team-specific D365 F&O code review checklist:
  - Added pre-review requirements (spec review, RunJob tagging, historical data, integration testing)
  - Added deployment risk section (field removal registration, index changes, duties/roles)
  - Added security and privilege completeness checks (endpoint permissions)
  - Added logic correctness and defensive coding rules (else branches, null/zero checks, cross-company, table clear())
  - Added expanded table design checklist (primary keys, precision, timezone, rounding, purchase line isdeleted, field length impacts, rollback, FormRef, table properties)
  - Added object and UI completeness requirements (Help text, Form Title Data Source, Carlsberg Asia sub-menu, financial dimension parameterization, encapsulation, call-site comments)
  - Updated severity level definitions to include new Critical and Major categories
- Initial repository structure
- Bootstrap skill: `using-d365-fo-skills`
- Core workflow skills: requirements-intake, solution-design, extension-development,
  x-class-development, form-development, data-entity-development, integration-development,
  unit-testing, systematic-debugging, deployment-planning
- Meta skill: writing-d365-skills
- Starter reviewer agent: d365-code-reviewer
- GitHub Copilot CLI integration via `.github/copilot-instructions.md`
- Test scaffolding: skill-triggering, explicit-skill-requests, d365-fo
- Docs structure: specs, plans, testing guide

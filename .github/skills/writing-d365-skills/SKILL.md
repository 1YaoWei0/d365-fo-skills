---
name: writing-d365-skills
description: Meta skill for authoring new D365 F&O skills in this repository. Use when the team identifies a gap in the skill system and wants to add a new skill.
---

# Writing D365 F&O Skills

## When to Use This Skill

Use this skill when:
- the team identifies a gap in the current skill system (e.g., a missing domain area)
- an existing skill is outdated and needs a significant revision
- you want to add a new execution skill for a D365 F&O topic not yet covered

## Before Writing a New Skill

Answer these questions first:

1. **What gap does this skill fill?** What task or situation is not well-handled by existing skills?
2. **Where does this skill sit in the workflow?** Is it discovery, planning, execution, quality, or meta?
3. **What does it produce?** What is the concrete output a developer gets from using this skill?
4. **What comes before and after it?** How does it connect to existing skills?
5. **How would a developer know when to trigger it?** Is the trigger condition clear?

If you cannot answer these, the skill is not ready to be written yet.

## Skill File Structure

Every skill in this repository lives at:

```
.github/skills/<skill-name>/SKILL.md
```

Before creating the file, confirm the skill name with the user and show them the full path where it will be created:

```
C:\Projects\d365-fo-skills\.github\skills\<skill-name>\SKILL.md
```

Ask the user to confirm or provide an alternative path if needed.

Every `SKILL.md` must include:

```markdown
---
name: <skill-name>
description: <one-sentence description for GitHub Copilot CLI discovery>
---

# <Skill Title>

## When to Use This Skill

[Clear trigger conditions — when should a developer invoke this?]

## What This Skill Produces

[Concrete outputs — what does the developer get at the end?]

## [Core content sections]

## Quality Checklist

[Verifiable completion criteria]

## Next Step

[What skill or action comes next?]
```

## Skill Writing Rules

1. **Be actionable, not advisory.** The skill should tell the developer what to do, not just describe what D365 F&O is.
2. **Include real X++ examples.** Where the skill involves code, show a concrete code pattern.
3. **Define the trigger clearly.** "When to Use This Skill" must be unambiguous.
4. **Define the output clearly.** The developer must know what "done" looks like.
5. **Connect to the workflow.** Every skill must have a "Next Step" that points to the next skill in the lifecycle.
6. **Include a quality checklist.** Verifiable completion criteria, not vague guidance.

## After Writing a New Skill

1. Add the skill to the routing table in `.github/skills/using-d365-fo-skills/SKILL.md`
2. Add the skill to `.github/copilot-instructions.md` skill routing table
3. Add a trigger prompt to `tests/skill-triggering/prompts/`
4. Add an explicit invocation prompt to `tests/explicit-skill-requests/prompts/`
5. Update `README.md` skill overview table
6. Update `CHANGELOG.md`

## Quality Bar

A skill is ready to publish when:
- [ ] `When to Use` is specific and unambiguous
- [ ] `What This Skill Produces` describes a concrete output
- [ ] The skill has at least one real X++ example (if code is involved)
- [ ] A quality checklist exists
- [ ] A "Next Step" pointer exists
- [ ] Trigger and explicit invocation tests exist
- [ ] The skill is wired into the bootstrap routing table

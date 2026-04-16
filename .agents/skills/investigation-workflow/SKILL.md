---
name: "investigation-workflow"
description: "Use when the user wants structured investigation, clarification, option analysis, and an implementation handoff before any coding or repository changes begin."
---

# Investigation Workflow

Use for analysis and solution selection before implementation.

## Core Rules

- Do not modify repo files as part of this skill.
- Do not implement production code.
- Ask questions before concluding if key requirements are missing.
- Research only as much as needed to compare viable options.
- Keep the output concise and implementation-ready.

## Workflow

1. Clarify

- Extract the goal, constraints, current behavior, and unknowns.
- Ask only the questions needed to remove important ambiguity.

2. Investigate

- Review relevant code, docs, and patterns.
- Compare only real options.

3. Recommend

Provide:

- short problem summary
- key constraints and risks
- options with pros and cons
- one recommended approach
- brief implementation plan for the next workflow

4. Save plan

Ask:
`Save this approved plan into .codex/plans/<task-name>.md for the next feature-workflow or request-workflow session?`

If yes, save only the implementation plan and required context.
If no, reply only:
`OK`

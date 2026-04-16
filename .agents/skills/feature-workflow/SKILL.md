---
name: "feature-workflow"
description: "Use when the user explicitly wants a gated delivery workflow for feature work with mandatory clarification, plan approval, validation, and commit-message selection before committing."
---

# Feature Workflow

Use for larger, ambiguous, or high-risk feature work.

Prefer `request-workflow` unless one of these is true:

- requirements are unclear
- behavior changes are risky
- architecture choices matter
- the work should be split into approved chunks

## Core Rules

- If the user gives `.codex/plans/<task-name>.md`, read it first and treat it as approved unless scope changed.
- Ask only the questions needed to remove real ambiguity.
- Do not code before plan approval unless the saved plan is already approved and scope is unchanged.
- Keep plans short and file-oriented. Re-plan if scope changes.
- Run planned validation per `.agents/shared/validation-policy.md`.
- If validation is blocked by unrelated repo issues, stop and report that.
- After result approval, offer a commit messages and commit only after the user approve it.
- Never push.
- Keep responses concise. Do not restate known context.

## Workflow

1. Clarify

- If critical details are missing, ask focused questions.
- If the task is clear enough, say that and move on.

2. Plan

Provide a short plan with:

- goal
- files or areas to change
- implementation steps
- validation command(s)
- risks or assumptions

End with:
`Approve this plan?`

3. Implement

- Start only after approval.
- Stay within the approved scope.
- If new ambiguity appears, stop and ask.

4. Validate

- Run the planned validation.
- Fix issues when reasonable and rerun.
- If blocked, report the blocker and remaining work.

5. Review

Summarize briefly:

- what changed
- validation command(s) and result
- what the user should verify

Then wait for approval.

6. Commit

- After user approval, provide a commit message.
- Commit only after the user approved commit message.

## Output Rules

- Keep clarification, plan, and review short.
- Use exact validation commands.
- Mention browser checks only if they matter.

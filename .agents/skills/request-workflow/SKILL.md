---
name: request-workflow
description: Use this skill for general development requests, small feature work, refactors, UI changes, fixes, or task continuation from saved context or an approved saved plan. It can start from a fresh user prompt or from a saved markdown artifact path provided by the user.
---

# Request Workflow

Default delivery workflow for most implementation tasks.

Use it for:

- small or medium features
- refactors in a known area
- UI updates
- straightforward bug fixes
- continuation from `.codex/context/*.md` or `.codex/plans/*.md`

Use `feature-workflow` instead when the work is ambiguous, risky, or needs strict gates.

## Core Rules

- If the user provides a saved context or plan path, read it first.
- Ask questions only when needed to avoid wrong assumptions.
- If the task is clear enough, move forward.
- Make a short plan before coding.
- Ask for approval unless the user gave an already approved saved plan and scope is unchanged.
- Run planned validation and follow `.agents/shared/validation-policy.md`.
- Fix validation issues when reasonable.
- After user approval of the result, propose or use an approved commit message and commit locally.
- Never push.
- Keep responses concise. Do not repeat context unless it changed.

## Workflow

1. Start from the right source

- Fresh prompt: use the prompt.
- Saved context: read it and reuse prior decisions.
- Saved approved plan: read it and treat it as approved unless scope changed.

2. Clarify only if needed

- Ask minimal grouped questions only when missing information is important.
- Otherwise continue.

3. Plan

Provide a short plan with:

- what will change
- key files or areas
- validation command(s)
- notable assumptions

End with:
`Approve this plan?`

Skip this approval only for an explicitly approved saved plan with unchanged scope.

4. Implement

- Follow existing patterns.
- Avoid unrelated refactors.

5. Validate

- Run the planned validation.
- Fix issues when reasonable and rerun.
- If blocked, report the blocker clearly.

6. Review

Summarize briefly:

- what changed
- validation command(s) and result
- what the user should verify

7. Commit

- After user approval, propose a commit message or ask for theirs.
- Commit locally only after the message is approved.

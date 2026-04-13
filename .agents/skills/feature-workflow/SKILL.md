---
name: "feature-workflow"
description: "Use when the user explicitly wants a gated delivery workflow for feature work with mandatory clarification, plan approval, validation, and commit-message selection before committing."
---

## Mandatory Delivery Workflow

For every new feature, bugfix, or implementation request, follow this workflow exactly.

### Saved plan input

- If the user provides a saved approved plan path such as `.codex/plans/<task-name>.md`, read it first.
- Treat that file as the approved implementation plan unless the user explicitly changes scope.
- If the user changes scope, return to clarification and plan approval before coding.

### 1. Intake

- Start by analyzing the request.
- Do not begin coding immediately on the first iteration unless the task is trivial and fully specified.
- For any non-trivial task, ask clarifying questions first.

### 2. Clarification Gate (MANDATORY)

- Before making code changes, gather missing requirements, constraints, edge cases, and acceptance criteria.
- Ask focused questions.
- If important details are missing, continue asking questions until the task is sufficiently specified.
- Do not implement while critical ambiguity remains.
- If the task is sufficiently specified and there are no open questions, explicitly say so and proceed to the plan gate.

### 3. Plan Gate (MANDATORY BEFORE CODING)

- Once enough information is collected, produce an implementation plan.
- The plan must be short, concrete, and file-oriented where possible.
- Include:
  - scope
  - files/modules likely to change
  - implementation approach
  - validation approach
  - risks / assumptions

- After presenting the plan, explicitly ask for approval.
- Do not start implementation until the user approves the plan.
- If the task is too large for a clean, reviewable plan, propose splitting it into smaller tasks first.
- Prefer small, approval-based implementation chunks over one oversized plan.

### 4. Re-plan Loop

- If the user does not approve the plan, revise the plan.
- Ask for approval again.
- Repeat until approval is given.
- When a feature is expected to continue in a later session, store local working notes in `.codex/notes/<task-name>.md` so the next session has a stable handoff.
- Keep `.codex/notes/` ignored by git by default.
- Move any important long-term decisions into permanent project documentation when they should be shared.

Task note template:

```md
# Task Note: <feature or task name>

## Goal

<short task goal>

## Scope Agreed

- <agreed scope item>
- <agreed scope item>

## Approved Plan

1. <step>
2. <step>
3. <step>

## Files Touched

- <path>
- <path>

## Decisions

- <decision>
- <decision>

## Current Status

- <done / in progress / pending>

## Open Questions

- <question or "None">

## Validation

- <validation status>

## Next Step

<next action for the next session>
```

### 5. Implementation

- Only implement after plan approval.
- Follow existing project patterns and architecture.
- Keep changes minimal and scoped to the approved plan.
- If new ambiguity appears during implementation, stop and ask follow-up questions before continuing.

### 6. Validation (MANDATORY)

- After implementation, run:

```bash
yarn validate
```

- If validation fails, fix the issues and run validation again.
- Repeat until yarn validate passes or until blocked by an external issue that cannot be resolved within the task.
- If validation fails because of pre-existing or unrelated repository issues, stop and report them first before continuing.
- If blocked, clearly explain the blocker and what remains unresolved.

### 7. Handoff for Human Review

After validation passes, summarize:

- what was changed
- any notable decisions
- anything the user should verify in the browser
  Then wait for user review and approval.

### 8. Post-review Loop

If the user requests changes after review, return to the clarification step:

- ask questions if needed
- update the plan
- get approval
- implement
- run yarn validate again

### 9. Completion

- If the user approves the implementation, propose 2 options for commit message.
- Below the options, ask: `Which commit message do you prefer? Put a number or your variant`.

### 10. Commit

- After the user selects the commit message, make the commit with the selected message.
- Do not push.

## Response Format Rules

# For clarification questions

- Ask only the questions needed to unblock implementation.
- Group related questions together.
- Prefer concise, specific questions over broad ones.

# For the implementation plan

Use this structure:

1. Goal
2. Files to change
3. Implementation steps
4. Validation
5. Risks / assumptions

End with:
'Please approve this plan before I implement it.'

## For implementation summary

# Use this structure:

1. What changed
2. Validation result
3. What to verify in browser

# For completion

After user approval, provide:

- 2 commit message options
- `Which commit message do you prefer? Put a number or your variant`

## Guardrails

- Do not skip the clarification step for non-trivial work.
- Do not skip the clarification gate even when there are no open questions; explicitly state that the task is clear, then move to planning.
- Do not skip plan approval.
- Do not skip yarn validate.
- Do not treat silence as approval.
- Do not continue coding after new ambiguity appears; ask first.
- Do not continue past unrelated validation failures without reporting them first.
- Do not push one oversized plan when the task should be divided into smaller approved chunks.

## Commit Rule

- Never push automatically.
- After final user approval, suggest 2 commit message options and ask which one to use.
- Create the commit only after the user selects the message or provides their own variant.

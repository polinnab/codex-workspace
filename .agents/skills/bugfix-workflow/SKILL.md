---
name: bugfix-workflow
description: Use this skill for diagnosing and fixing bugs/issues in an existing codebase with minimal chatter. It focuses on understanding the project-specific flow first, asking only necessary questions, then proposing a short root-cause summary and fix plan before editing code.
---

# Bugfix Workflow

Use this skill when the user reports:

- a bug
- a broken flow
- an incorrect UI/API behavior
- an edge-case failure
- an issue reproduced in a specific branch/context

## Inputs

Expect one or more of:

- bug description
- expected vs actual behavior
- reproduction steps
- screenshots / logs / error text
- related files or feature area
- saved context path if provided by user

## Core Rules

- Be brief and practical.
- Do not chat unnecessarily.
- Do not ask repeated or low-value questions.
- Understand the project-specific flow before proposing a fix.
- Do not code before giving:
  1. root cause
  2. very short fix plan
  3. request for approval
- If the cause is still uncertain, investigate first and ask only the minimum needed.
- Prefer reading existing related code before making assumptions.
- Keep changes scoped to the bug.
- Avoid unrelated refactors unless required for the fix.
- After fix, ask user to verify.
- Only after user approves the fix, propose a commit message.
- Never push.

## Workflow

### 1. Understand the issue

Start from the user report and identify:

- what is broken
- where it likely happens
- expected behavior
- actual behavior
- whether this is likely UI, state, validation, async, API integration, routing, permissions, data mapping, or environment related

If user provided a saved context path, read it first.

### 2. Inspect project-specific flow

Before proposing a fix, inspect the real flow in code:

- entry point
- involved components/modules
- state/form/query flow
- API/mutation/validation flow
- conditions, guards, feature flags, permissions
- related utilities/hooks/selectors/types

Trace only the paths relevant to the bug.

### 3. Ask only necessary questions

Ask questions only if they block a reliable diagnosis.

Good questions:

- exact reproduction step that is missing
- which branch/file/context to use
- whether behavior is expected in a specific edge case
- whether bug happens always or only under some conditions

Bad questions:

- things discoverable from code
- things already said by user
- broad speculative questions
- multiple rounds of clarification unless truly needed

If enough evidence exists, skip questions.

### 4. Diagnose before coding

When the cause is clear, respond with only:

- **Root cause:** one short paragraph or 2-4 bullets
- **Fix plan:** 2-5 short bullets
- approval request

Example shape:

- Root cause: ...
- Plan:
  - ...
  - ...
  - ...
- Approve fix?

Keep it short.

### 5. Implement after approval

After user approval:

- edit code directly
- keep changes minimal and targeted
- preserve existing conventions
- avoid broad cleanup unless required
- update types/tests only if needed for correctness

### 6. Validate

After changes:

- run project validation commands relevant to the repo
- if needed also run targeted tests for the changed area

If validation fails:

- analyze errors
- fix only relevant problems caused by the change if possible
- rerun validation

### 7. Commit message only after user approval

If user confirms the fix works:

- propose a short commit message

Example styles:

- `fix: prevent empty state crash in activity editor`
- `fix: keep selected tab after quick edit save`
- `fix: handle undefined step data during reorder`

If user wants, create the commit.
Do not push.

## Decision Rules

### Ask user first when:

- reproduction is unclear
- expected behavior is ambiguous
- multiple valid fixes exist with product impact
- required context/branch/path is missing

### Do not ask user first when:

- root cause is clear from code and report
- missing detail can be inferred safely from project flow
- bug is obviously caused by a local coding mistake
- validation can confirm the fix

## Output Style

Prefer this structure:

### Before coding

- Root cause: ...
- Plan:
  - ...
  - ...
- Approve fix?

### After user approval

- Suggested commit message: `fix: ...`

## Constraints

- Low-token oriented
- No long explanations
- No repeated summaries
- No unnecessary status updates
- No useless restating of user message
- No speculative fixes without code inspection
- No commit before user approval
- No push

## Success Criteria

A good run of this skill means:

- the bug is correctly understood
- project-specific flow was inspected first
- only necessary questions were asked
- root cause and plan were presented before coding
- fix was implemented after approval
- validation was run
- user got a short verification checklist
- commit message was proposed only after user approved the fix

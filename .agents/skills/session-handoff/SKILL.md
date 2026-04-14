---
name: "session-handoff"
description: "Use when the user wants to preserve the current task state for a later session or another agent by drafting a structured handoff summary and, after approval, saving it to .codex/context/<task-name>.md."
---

# Session Handoff

Use this skill when the user asks to save progress, create a handoff, preserve session context, or prepare a clean summary for later continuation.

The goal is to produce a concise, practical Markdown summary of the current task state and save it only after user approval.

## Output Path

Save handoffs to:

`.codex/context/<task-name>.md`

The bundled helper script at `.agents/skills/session-handoff/scripts/save-context.sh` can copy a prepared Markdown file into that location.

`.codex/context/` is the only supported handoff location. Do not create or reuse parallel paths such as `context/<repo>/`.

## Rules

- Do not implement production code as part of this skill.
- Do not modify repository files except the target handoff file.
- Do not save or overwrite the handoff file without explicit user approval.
- Do not guess `task-name` if it is unclear.
- Do summarize the task state clearly and concretely.
- Do preserve decisions, constraints, blockers, and next steps.
- Do keep the handoff useful for a new session with minimal additional context.

## Required Inputs

Before saving, identify:

- `task-name`

If it is missing or ambiguous, ask the user before offering to save.

Guidance:

- `task-name`: short kebab-case identifier such as `fix-auth-redirect` or `investigate-build-failure`

## Workflow

### 1. Identify Scope

Determine:

- task name
- current stage

Suggested stage values:

- investigation
- planned
- in progress
- partially implemented
- blocked
- ready for validation
- completed

### 2. Analyze Current Session

Extract the minimum useful state:

- goal
- current status
- work completed
- important decisions
- constraints
- risks or blockers
- open questions
- next recommended step

Do not include conversational filler.

### 3. Draft The Handoff

Prepare the summary in the required Markdown structure below.

Writing guidelines:

- prefer short sections and bullets
- keep facts specific and actionable
- preserve important domain terminology
- summarize reality, not guesses
- avoid repeating the same detail across sections

### 4. Show Before Saving

Show the full draft to the user before writing any file.

Then ask exactly:

`Save this handoff into .codex/context/<task-name>.md?`

### 5. Save Only After Approval

If the user says yes:

- create or replace `.codex/context/<task-name>.md`
- save the prepared Markdown
- confirm the saved path

If the user says no:

- reply only with `OK`
- do not create or modify any file

## Required Markdown Structure

Use this structure exactly:

```md
# Task Context: <short title>

## Project

<current project directory name or repo name>

## Task

<task-name>

## Stage

<investigation / planned / in progress / blocked / completed / etc.>

## Goal

<clear description of the task goal>

## Current Status

<short summary of the current state>

## What Was Done

- <completed action>
- <completed action>

## Decisions

- <decision>
- <decision>

## Constraints

- <constraint>
- <constraint>

## Risks / Blockers

- <risk or blocker>
- <risk or blocker>

## Open Questions

- <open question>
- <open question>

## Next Recommended Step

<clear next action for the next session or next agent>

## Notes

- <optional extra context worth preserving>
```

## File Behavior

When saving:

- create the target file if it does not exist
- replace the target file with the latest trusted summary if it already exists
- do not append duplicate handoff content
- do not create additional files unless the user explicitly asks

## Exit Criteria

This skill is complete only when:

- the current session has been summarized
- the draft was shown to the user
- the user was asked whether to save it
- the handoff file was written only if approved
- the final saved path was confirmed

## Anti-Patterns

- saving without approval
- guessing task identity
- producing vague summaries with no next step
- mixing handoff work with unrelated implementation
- appending raw duplicate summaries to an existing handoff file

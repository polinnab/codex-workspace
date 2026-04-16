---
name: "session-handoff"
description: "Use when the user wants to preserve the current task state for a later session or another agent by drafting a structured handoff summary and, after approval, saving it to .codex/context/<task-name>.md."
---

# Session Handoff

Use when the user wants a saved continuation note.

Save only to:
`.codex/context/<task-name>.md`

## Core Rules

- Do not implement code as part of this skill.
- Do not save without approval.
- Do not guess `task-name` if it is unclear.
- Keep the handoff short, factual, and actionable.
- Preserve decisions, blockers, and next step.

## Workflow

1. Identify

- task name
- stage

2. Draft

Include only the useful minimum:

- goal
- current status
- work done
- decisions
- constraints
- risks or blockers
- open questions
- next recommended step

3. Show and ask

Show the full draft, then ask exactly:
`Save this handoff into .codex/context/<task-name>.md?`

4. Save only after approval

- If yes, create or replace the file and confirm the path.
- If no, reply only:
`OK`

## Required Markdown Structure

```md
# Task Context: <short title>

## Project

<current project directory name or repo name>

## Task

<task-name>

## Stage

<stage>

## Goal

<task goal>

## Current Status

<current state>

## What Was Done

- <item>

## Decisions

- <item>

## Constraints

- <item>

## Risks / Blockers

- <item>

## Open Questions

- <item>

## Next Recommended Step

<next action>

## Notes

- <optional extra context>
```

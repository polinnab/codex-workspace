# codex-workspace

This repository is a local Codex wrapper workspace for projects.

## Purpose

This workspace stores reusable Codex workflows and repo-local agent configuration that can be applied to projects inside `projects/`.

It is not a global Codex installation and should not contain machine-wide configuration.

## Structure

- `.agents/skills/` — reusable repo-local workflow skills
- `.agents/shared/` — shared workflow guidance synced into project repos when required by skills
- `.agents/templates/` — wrapper-only templates used to generate project-local files
- `projects/` — local sample apps or real project repositories worked on inside this workspace

## Local Codex Artifacts

Use `.codex/` as the single local artifact root for both this workspace and any synced project repo.

When the toolkit is synced into a project, it may create project-local working artifacts under `.codex/`.

- `.codex/plans/` — approved implementation plans saved for a future `feature-workflow` or `request-workflow` session
- `.codex/context/` — saved session handoff context for later continuation
- `.codex/notes/` — local task notes used while work is in progress

These artifacts are wrapper-managed local workspace files. Do not create parallel artifact trees such as `context/` for saved handoffs. These paths should be ignored by git in both the wrapper and synced project repos unless a project explicitly chooses a different policy.

## Working rules

- Before doing task-specific work, choose and follow the appropriate workflow skill:
  - `project-onboarding` for bringing a new repo into `projects/`, syncing the toolkit, and establishing project-local `AGENTS.md`
  - `investigation-workflow` for analysis, clarification, options, and an implementation handoff before coding
  - `feature-workflow`
  - `request-workflow`
  - `session-handoff` for saving local task context for later continuation
  - `workspace-evolution` for improving this wrapper workspace itself
- Keep validation in delivery workflows, but keep it repo-native by following `.agents/shared/validation-policy.md`.
- Keep wrapper-level instructions generic and reusable.
- Keep project-specific commands, architecture rules, and conventions inside each real project, not in this wrapper.

## Scope

This wrapper defines process and reusable guidance only.
Real implementation details belong to the actual project being edited.

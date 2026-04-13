# codex-workspace

This repository is a local Codex wrapper workspace for projects.

## Purpose

This workspace stores reusable Codex workflows and repo-local agent configuration that can be applied to projects inside `projects/`.

It is not a global Codex installation and should not contain machine-wide configuration.

## Structure

- `.agents/skills/` — reusable repo-local workflow skills
- `projects/` — local sample apps or real project repositories worked on inside this workspace

## Local Codex Artifacts

When the toolkit is synced into a project, it may create project-local working artifacts under `.codex/`.

- `.codex/plans/` — approved implementation plans saved for a future `feature-workflow` or `request-workflow` session
- `.codex/context/` — saved session handoff context for later continuation
- `.codex/notes/` — local task notes used while work is in progress

These artifacts are wrapper-managed local workspace files. They should be ignored by git in both the wrapper and synced project repos unless a project explicitly chooses a different policy.

## Working rules

- Before doing task-specific work, choose and follow the appropriate workflow skill:
  - `feature-workflow`
  - `bugfix-workflow`
  - `request-workflow`
  - `workspace-evolution` for improving this wrapper workspace itself
- Keep validation in delivery workflows, but keep it repo-native:
  - prefer explicit project validation commands from user instructions, project `AGENTS.md`, README, or docs
  - otherwise prefer repo entrypoints like `validate`, `check`, `test`, `lint`, `typecheck`, or `build`
  - only infer tool-native commands when the repo does not define an explicit validation path
  - run the smallest relevant validation set for the changed scope and report the exact commands used
- Keep wrapper-level instructions generic and reusable.
- Keep project-specific commands, architecture rules, and conventions inside each real project, not in this wrapper.

## Scope

This wrapper defines process and reusable guidance only.
Real implementation details belong to the actual project being edited.

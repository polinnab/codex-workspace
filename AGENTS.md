# codex-workspace

This repository is a local Codex wrapper workspace for projects.

## Purpose

This workspace stores reusable Codex workflows and repo-local agent configuration that can be applied to projects inside `projects/`.

It is not a global Codex installation and should not contain machine-wide configuration.

## Structure

- `.agents/skills/` — reusable repo-local workflow skills
- `.codex/agents/` — repo-local custom subagents
- `projects/` — local sample apps or real project repositories worked on inside this workspace

## Working rules

- Before doing task-specific work, choose and follow the appropriate workflow skill:
  - `feature-workflow`
  - `bugfix-workflow`
  - `request-workflow`
- Keep wrapper-level instructions generic and reusable.
- Keep project-specific commands, architecture rules, and conventions inside each real project, not in this wrapper.

## Scope

This wrapper defines process and reusable guidance only.
Real implementation details belong to the actual project being edited.

# codex-workspace

`codex-workspace` is a reusable local wrapper for working with real software projects through Codex.

It keeps shared workflow logic in one place and applies it to repositories stored under `projects/`. The wrapper is responsible for process and reusable tooling. Each onboarded project is responsible for its own repo-specific `AGENTS.md`, commands, and conventions.

## What This Workspace Is For

Use this workspace when you want a repeatable way to:

- bring a repository into a local Codex workspace
- sync shared skills and local Codex artifacts into that repository
- establish a project-local `AGENTS.md` contract
- use the same feature, request, and handoff workflows across many repositories

This repository is not a machine-wide Codex install. It is a portable workspace that can be shared and reused.

## How It Works

There are two layers:

1. Wrapper layer
   This repo provides reusable workflow skills, wrapper scripts, shared guidance, and templates.

2. Project layer
   Each real repo under `projects/` keeps its own source code and its own project-local `AGENTS.md`, which becomes the source of truth for repo-specific instructions.

The wrapper should define process. The project should define implementation details.

## Main Directories

- `.agents/skills/`  
  Reusable workflow skills.

- `.agents/shared/`  
  Shared workflow guidance used by synced skills.

- `.agents/templates/`  
  Wrapper-only templates for generating project-local files.

- `scripts/`  
  Wrapper scripts such as toolkit sync and project onboarding.

- `projects/`  
  Real repositories worked on through this workspace.

## Default Flow For A New Project

Start with `project-onboarding`.

The onboarding flow is responsible for:

1. cloning a repository into `projects/`
2. running `scripts/sync-codex-toolkit.sh`
3. inspecting the repo for stack and tooling signals
4. reading an existing project `AGENTS.md`, if present
5. drafting a project `AGENTS.md` when it does not exist
6. asking targeted questions only where the repo contract is unclear
7. leaving the project ready for normal feature or request workflows

Wrapper command:

```bash
./scripts/project-onboarding.sh <git-url-or-project-name> [project-name]
```

Examples:

```bash
./scripts/project-onboarding.sh https://github.com/org/app.git
./scripts/project-onboarding.sh git@github.com:org/app.git my-app
./scripts/project-onboarding.sh my-app
```

What it writes:

- `projects/<app>/.codex/notes/project-onboarding-report.md`
- `projects/<app>/.codex/notes/AGENTS.generated.md` when the project has no `AGENTS.md`

The generated draft is not the final source of truth by itself. Review it, confirm assumptions, and then save or update `projects/<app>/AGENTS.md`.

## Toolkit Sync

Use the sync script when you need to refresh the shared Codex toolkit inside an onboarded project:

```bash
./scripts/sync-codex-toolkit.sh <app-folder>
```

This syncs:

- project-safe workflow skills
- shared workflow guidance needed by those skills
- local `.codex/` working directories

It intentionally does not sync wrapper-only assets such as `workspace-evolution`, `project-onboarding`, or wrapper templates.

## Workflow Skills

- `project-onboarding`  
  Bring a repo into `projects/`, sync the toolkit, inspect the repo, and establish project-local `AGENTS.md`.

- `request-workflow`  
  Default implementation workflow for general requests, small feature work, refactors, fixes, and approved-plan continuation.

- `feature-workflow`  
  Gated delivery workflow with clarification, plan approval, validation, and commit-message selection.

- `investigation-workflow`  
  Use when you want analysis, clarification, option evaluation, and a handoff without implementation.

- `session-handoff`  
  Save structured session context for later continuation.

- `workspace-evolution`  
  Improve this wrapper itself: scripts, skills, sync behavior, and reusable conventions.

## Validation Philosophy

Validation stays mandatory, but it must be repo-native.

Shared default policy lives in:

`.agents/shared/validation-policy.md`

The policy says:

- prefer explicit project commands first
- otherwise prefer repo entrypoints such as `validate`, `check`, `test`, `lint`, `typecheck`, or `build`
- only fall back to inferred tool-native commands when the repo does not define an explicit path
- report the exact validation commands that were run

In practice, the best long-term solution is to capture the real validation flow in each project's own `AGENTS.md`.

## Project-Local Codex Artifacts

When the toolkit is synced into a project, it may create project-local working artifacts under `.codex/`.

- `.codex/plans/`  
  Approved implementation plans for future sessions.

- `.codex/context/`  
  Saved handoff context for later continuation.

- `.codex/notes/`  
  Local working notes such as onboarding reports and temporary task notes.

These files are wrapper-managed local artifacts and should usually stay ignored by git unless a project deliberately chooses a different policy.

## Practical Usage

Typical sequence for a new repo:

1. use `project-onboarding`
2. review or finalize the project's `AGENTS.md`
3. use `investigation-workflow` if you want option analysis first
4. use `request-workflow` or `feature-workflow` for implementation
5. use `session-handoff` when you want to preserve state for later

Typical sequence for an existing onboarded repo:

1. sync the toolkit if needed
2. read the project's `AGENTS.md`
3. choose the workflow that fits the task

## Design Rule

Keep wrapper guidance generic and reusable.

Keep project-specific commands, architecture rules, and conventions inside each project's own `AGENTS.md`.

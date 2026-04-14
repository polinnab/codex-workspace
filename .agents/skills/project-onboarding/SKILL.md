---
name: project-onboarding
description: Use this skill when bringing a new repository into codex-workspace, syncing the toolkit, inspecting the repo, and establishing or updating the project's local AGENTS.md contract.
---

# Project Onboarding

## Purpose

Use this skill when the user wants to start working on a repository that is not yet set up inside `projects/`.

This skill is for:

- cloning a repository into `projects/`
- syncing Codex toolkit files into that repository
- inspecting the repository to detect stack, tooling, and likely commands
- reading an existing project `AGENTS.md` if present
- drafting or updating a project-local `AGENTS.md` when needed

Do not use this skill for normal feature work after a project is already onboarded. Use the project workflows after the project contract is ready.

---

## Core Behavior Rules

1. Prefer project-local truth
   A project's own `AGENTS.md` is the primary contract for repo-specific rules, commands, and conventions.

2. Separate facts from assumptions
   When drafting or updating `AGENTS.md`, clearly distinguish confirmed repo facts from inferred assumptions.

3. Do not silently invent project rules
   If important repo behavior is unclear, ask concise follow-up questions before saving a final `AGENTS.md`.

4. Keep onboarding non-destructive
   Do not overwrite an existing project folder or replace an existing `AGENTS.md` without explicit approval.

5. Reuse wrapper primitives
   Use `scripts/project-onboarding.sh` for the mechanical onboarding flow and `scripts/sync-codex-toolkit.sh` for toolkit sync.

6. Keep wrapper-only assets out of synced projects
   This workflow skill and its helper template are wrapper-level assets and should not be synced into app repos by default.

---

## Workflow

### Step 1 - Confirm the onboarding source

Determine whether the user provided:

- a git URL to clone
- an existing repo already located in `projects/`
- a request to refresh onboarding for an already-synced project

If the repo is outside `projects/`, do not move or overwrite it automatically. Either use a git URL or ask the user to place the repo inside `projects/`.

### Step 2 - Run the onboarding script

Run:

```bash
./scripts/project-onboarding.sh <git-url-or-project-name> [project-name]
```

The script should:

- clone the repo into `projects/` when given a git URL
- sync the toolkit into the project
- inspect repo signals
- write a report to `.codex/notes/project-onboarding-report.md`
- create `.codex/notes/AGENTS.generated.md` when no project `AGENTS.md` exists

### Step 3 - Read the generated onboarding artifacts

Review the project's:

- `AGENTS.md` if it exists
- `.codex/notes/project-onboarding-report.md`
- `.codex/notes/AGENTS.generated.md` if it was generated

Extract:

- detected stack and tooling
- likely run and validation commands
- missing or conflicting information
- whether the project appears ready for feature work

### Step 4 - Ask only the missing questions

Ask concise questions only for unclear or conflicting repo-specific details such as:

- the preferred development command
- the preferred validation command set
- the primary app/package in a monorepo
- environment setup requirements

If the existing or generated `AGENTS.md` is already sufficient, say so and move to approval.

### Step 5 - Approve the project contract

If creating a new `AGENTS.md` or materially updating one, show the key changes and ask for approval before saving them into the project root.

End with:
**Approve this AGENTS.md update?**

### Step 6 - Save the project-local AGENTS.md

After approval:

- create or update `projects/<app>/AGENTS.md`
- keep the content project-specific
- preserve the wrapper-managed `.codex/` artifacts as local working files

### Step 7 - Readiness handoff

Summarize:

- where the project was cloned or located
- whether toolkit sync completed
- whether project `AGENTS.md` was created, reused, or updated
- what remains unclear, if anything
- the next recommended workflow skill for actual work

## Expected Project AGENTS.md Sections

The project-local `AGENTS.md` should usually cover:

- project overview
- stack and tooling
- setup notes
- development commands
- validation commands
- architecture notes
- repo conventions
- open questions or assumptions

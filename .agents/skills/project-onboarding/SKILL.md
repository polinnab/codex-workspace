---
name: project-onboarding
description: Use this skill when bringing a new repository into codex-workspace, syncing the toolkit, inspecting the repo, and establishing or updating the project's local AGENTS.md contract.
---

# Project Onboarding

Use when setting up a repo inside `projects/`.

## Core Rules

- A project's own `AGENTS.md` is the source of truth for repo-specific rules.
- Use `scripts/project-onboarding.sh` for onboarding and `scripts/sync-codex-toolkit.sh` for sync.
- Do not overwrite an existing project folder or `AGENTS.md` without approval.
- Keep wrapper-only assets out of synced projects.
- Ask only the missing repo-specific questions.
- Keep summaries short and factual.

## Workflow

1. Identify source

- git URL
- existing repo in `projects/`
- refresh for an onboarded project

2. Run onboarding

Use:

```bash
./scripts/project-onboarding.sh <git-url-or-project-name> [project-name]
```

3. Review outputs

Read only what is needed:

- `AGENTS.md` if present
- `.codex/notes/project-onboarding-report.md`
- `.codex/notes/AGENTS.generated.md` if present

4. Clarify only what is missing

Typical gaps:

- dev command
- validation command
- primary app/package
- environment setup

5. Approve AGENTS changes

If creating or materially updating `AGENTS.md`, show the key changes and ask:
`Approve this AGENTS.md update?`

6. Save and hand off

After approval, create or update `projects/<app>/AGENTS.md`, then summarize:

- project location
- sync status
- AGENTS.md status
- remaining unknowns
- next recommended workflow

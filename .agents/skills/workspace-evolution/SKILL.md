---
name: workspace-evolution
description: "Use this skill when working on codex-workspace itself: adding or updating wrapper scripts, creating or refining repo-local skills, improving toolkit sync behavior, and implementing broader ideas that make the workspace more reusable and universal."
---

# Workspace Evolution

Use for changes to `codex-workspace` itself, not app work inside `projects/`.

## Core Rules

- Keep changes wrapper-level and reusable.
- Do not move project-specific rules into the workspace unless explicitly asked.
- Protect sync behavior: wrapper-only assets should not be copied into projects unless intended.
- Inspect only the files needed.
- Present a short plan before editing.
- Validate with the lightest relevant check.
- Do not revert unrelated user changes.
- Keep summaries concise.

## Workflow

1. Confirm scope

- `.agents/`
- `scripts/`
- workspace docs
- wrapper conventions

If the target is a project repo, switch workflows.

2. Inspect current behavior

Read only what is needed to understand the current workflow, script, or doc.

3. Define minimal change

Identify:

- files to change
- whether sync behavior changes
- whether docs need updates

4. Plan

Provide a short plan and end with:
`Approve this plan?`

5. Implement

Make the agreed wrapper changes and update docs only where needed.

6. Validate

Use the lightest relevant check.

7. Handoff

Summarize:

- what changed
- what is different now
- what to test next

8. Commit

After user approval, propose a commit message and commit locally.

---
name: workspace-evolution
description: Use this skill when working on codex-workspace itself: adding or updating wrapper scripts, creating or refining repo-local skills, improving toolkit sync behavior, and implementing broader ideas that make the workspace more reusable and universal.
---

# Workspace Evolution

## Purpose

This skill is for changes to `codex-workspace` itself rather than to an app inside `projects/`.

Use it when the user wants to:

- add or improve wrapper scripts
- create, update, or reorganize repo-local skills
- change toolkit sync behavior
- implement improvements that make the workspace more reusable
- prototype new ideas for making the wrapper more universal

Do not use this skill for normal feature work inside `projects/<app>`. For that, use the project-oriented workflow skills.

---

## Core Behavior Rules

1. Work at the wrapper level
   Keep changes focused on reusable workspace tooling, workflows, docs, and structure.

2. Separate wrapper concerns from project concerns
   Do not move project-specific implementation rules into the workspace unless the user explicitly wants a reusable pattern extracted.

3. Protect project sync behavior
   If adding wrapper-only assets, ensure they are not copied into `projects/<app>` by sync scripts unless the user explicitly wants that behavior.

4. Prefer small, composable changes
   When improving the workspace, favor targeted changes that are easy to reason about and reuse.

5. Inspect before editing
   Review the relevant wrapper scripts, repo-local skills, and top-level docs before deciding on implementation.

6. Plan before implementation
   Provide a short, practical plan for the wrapper changes before editing files.

7. Validate the changed behavior
   Validate using the most relevant checks available for the affected change. Examples:

- run the modified shell script with safe arguments when possible
- inspect generated paths or exclusions
- run repo validation if the repo defines one

8. Preserve user changes
   Do not revert unrelated workspace edits already present in the repo.

---

## Workflow

### Step 1 - Confirm this is a workspace task

Determine whether the request targets:

- `.agents/`
- `scripts/`
- workspace docs
- wrapper-level conventions

If the real target is an app inside `projects/`, switch to the appropriate project workflow instead.

### Step 2 - Inspect the current wrapper behavior

Read only the files needed to understand:

- how the current workflow or script works
- what is synced into app repos
- where the change belongs

Typical areas:

- `.agents/skills/`
- `scripts/`
- `AGENTS.md`
- `README.md`

### Step 3 - Define the minimal wrapper change

Identify:

- which files need to change
- whether the change should stay wrapper-only
- whether sync or documentation needs to be updated too

### Step 4 - Present a short plan

Keep the plan concise and concrete.

Include:

- intended wrapper changes
- any sync/exclusion updates
- any documentation updates

End with:
**Approve this plan?**

### Step 5 - Implement after approval

Make the agreed wrapper-level changes.

When adding a new wrapper-only skill or tool, also update any relevant docs or wrapper instructions so it is discoverable.

### Step 6 - Validate

Use the lightest relevant validation that proves the change is coherent.

Examples:

- verify a sync script excludes a wrapper-only directory
- verify a new skill exists in the expected location
- run repo validation if appropriate and available

### Step 7 - Finish with a short handoff

Summarize:

- what changed
- how wrapper behavior is different now
- what the user may want to test next

### Step 8 - Propose a commit message and commit locally

After the user confirms the result is good:

- propose a concise commit message, or use the one approved by the user
- create the local git commit
- do not push

---
name: request-workflow
description: Use this skill for general development requests, small feature work, refactors, UI changes, fixes, or task continuation from saved context. It can start from a fresh user prompt or from a saved task context markdown file path provided by the user.
---

# Request Workflow

## Purpose

This skill is the default workflow for handling a general implementation request in a coding project.

It supports two starting points:

1. **Fresh request**  
   The user describes what they want in the current prompt.

2. **Saved context continuation**  
   The user provides a relative path to a markdown file with saved context from a previous session.  
   The agent must read that file first, analyze it, and use it as the starting context for the task.

The workflow ensures the agent:

- understands the request before coding
- asks follow-up questions only when needed
- creates a short implementation plan before implementation
- gets user approval before coding
- validates the result with `yarn validate`
- fixes validation issues if possible
- finishes with a short handoff for browser testing
- proposes or uses an approved commit message
- commits locally only
- **never pushes**

---

## Inputs

The user may provide one of these:

### A. Saved context path

A relative path to a markdown file, for example:

`context/some-task.md`

or

`.agents/context/some-task/overview.md`

When such a path is provided, you must:

1. read the file
2. extract the goal, prior decisions, constraints, unfinished work, and known risks
3. continue from that context without asking the user to restate already-known information

### B. Fresh request

A normal implementation request in the prompt.

When no context file path is provided, work directly from the prompt.

---

## Core Behavior Rules

1. **Understand first, code second**
   Do not jump into implementation until the task is understood well enough.

2. **Use saved context when provided**
   If the user provided a relative path to saved context, read it before planning or asking questions.

3. **Ask questions only if needed**
   Ask follow-up questions only when missing information would likely cause wrong implementation, rework, or risky assumptions.

4. **Prefer moving forward**
   If the task is clear enough, do not block on extra questions. Go directly to a short implementation plan.

5. **Always create a short implementation plan before coding**
   The plan must be concise and practical.

6. **Always ask for approval before implementation**
   Do not start implementation until the user approves the plan.

7. **After implementation always run validation**
   Run:

   ```bash
   yarn validate
   ```

8. Fix validation issues when possible
   If yarn validate fails, analyze errors and fix them before finishing, when reasonably possible.

9. Finish with a short final handoff
   Keep it brief and practical:

- what was done
- what the user should check in browser

10. Commit only after user approval
    If the user confirms everything is good:

- propose a commit message, or
- ask for the user’s preferred message
- once the message is approved, create the local git commit

11. Never push
    Do not push to remote under any circumstances.

## Workflow

### Step 1 — Determine the starting source

Check whether the user provided:

- a saved context file path
- a fresh request
- both

If a context file path is present:

- read the file first
- treat it as the main source of truth unless the user overrides something

If both are present:

- combine saved context with current prompt updates

---

### Step 2 — Analyze the task

Understand:

- current goal
- what was already done (if context exists)
- constraints and decisions
- missing information
- affected areas/files

If using saved context, identify:

- completed vs unfinished work
- prior decisions that must be respected

---

### Step 3 — Decide if questions are needed

Ask questions **only if necessary**.

Ask if:

- requirements are unclear
- multiple valid approaches exist
- risk of wrong assumptions
- context is outdated or conflicting

Do NOT ask if:

- task is clear enough
- reasonable assumptions can be made

If questions are needed:

- ask minimal, grouped questions
- wait for answers before continuing

If not:

- proceed to planning

---

### Step 4 — Provide a short implementation plan

Create a concise plan including:

- what will be changed
- key areas/files involved
- any important behavior changes

Keep it short and practical.

End with:
**Approve this plan?**

---

### Step 5 — Wait for approval

Do NOT implement before approval.

If user requests changes:

- update the plan
- ask for approval again

---

### Step 6 — Implement

After approval:

- implement changes
- follow existing code patterns
- avoid unrelated refactoring
- respect prior decisions from context

---

### Step 7 — Validate

Run:

```bash
yarn validate
```

If it fails:

- analyze errors
- fix issues if possible
- rerun validation

Repeat until:

- validation passes, or
- a blocker is reached that cannot be safely resolved

If blocked:

- clearly explain what failed
- describe what was already fixed
- describe what remains unresolved
- do not hide or ignore errors

---

### Step 8 — Final short handoff

Provide a short summary:

**Done:**

- what was implemented

**Validation:**

- result of `yarn validate` (passed / failed with explanation)

**Please check in browser:**

- key things to verify
- main flows or UI parts affected

Keep it concise and practical.

---

### Step 9 — Commit flow

After the user reviews and confirms everything is OK:

- if no commit message provided:
  - propose a short, clear commit message

- if user wants their own message:
  - ask for it and wait

- wait for approval of the commit message

After approval:

```bash
git add <relevant files>
git commit -m "approved message"
```

### Step 10 — Never push

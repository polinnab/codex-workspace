---
name: branch-reviewer
description: Review a feature/bugfix branch against a base branch. Detect purpose, assess code quality, find bugs/risks, and produce a concise review.
---

# Branch Reviewer

## Input

- review branch
- base branch

Ask only if missing.

---

## Goal

- detect what was implemented
- summarize it briefly
- review code quality
- find bugs, risks, vulnerabilities
- produce a clear review report

---

## Workflow

### 1. Diff

```bash
git diff --stat <base>...<branch>
git diff --name-only <base>...<branch>
git log --oneline <base>..<branch>
git diff <base>...<branch>
```

### 2. Detect purpose

Infer main change (feature/bugfix/refactor).
Write 1–2 line summary (not branch name).

### 3. Review

Focus only on changed code.

#### Correctness

- logic errors
- edge cases
- async/state issues
- missing error/loading handling

#### Quality

- readability (naming, complexity)
- duplication
- structure / separation of concerns
- maintainability

#### Frontend-specific

- state sync (forms, server/client)
- effects deps
- optimistic updates safety
- list keys / rendering
- validation gaps

### 4. Bugs & risks

Look for:

- regressions
- race conditions
- stale state
- unsafe assumptions
- missing fallbacks
- broken UX states

### 5. Security (basic)

- unsafe HTML rendering
- XSS patterns
- sensitive data leaks
- missing checks/validation

Mark uncertain items as:

- Assumption
- Risk
- Needs check

## Output

## What this branch does

<short summary>

## High-level

<overall: good / mixed / risky>

## Good

- ...

## Problems

- [High/Med/Low] <issue + why>

## Risks / assumptions

- ...

## Test manually

- ...

## Verdict

<Looks good / Needs changes / Risky>

## Severity

- High → bug / data loss / core break
- Med → logic or maintainability risk
- Low → minor issue

## Rules

- review diff only
- be specific, not generic
- separate facts vs assumptions
- no auto-fixes
- no noise

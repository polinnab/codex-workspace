---
name: "investigation-workflow"
description: "Use when the user wants structured investigation, clarification, option analysis, and an implementation handoff before any coding or repository changes begin."
---

# Investigation Workflow Skill

## Purpose

This skill is responsible for **deep analysis and solution discovery** before any implementation begins.

It ensures that:

- the problem is clearly understood
- all unknowns are resolved via user interaction
- possible solutions are researched and compared
- the best approach is selected and justified

❗ This skill MUST NOT implement features or modify the repository code.

---

## Core Principles

1. **Understand before acting**
2. **Ask before assuming**
3. **Research before deciding**
4. **Validate with the user before finalizing**
5. **Prepare a clear handoff for implementation**

---

## Strict Rules

- ❌ Do NOT write production-ready code into the repo
- ❌ Do NOT modify files
- ❌ Do NOT assume missing requirements
- ❌ Do NOT skip the questioning phase

- ✅ You MAY provide small code snippets ONLY as examples (non-final)
- ✅ You MUST ask clarifying questions before forming a solution
- ✅ You MUST adapt your investigation based on user answers

---

## Workflow Steps

### Step 1 — Problem Understanding

Analyze the user's request and extract:

- Goal (what needs to be achieved)
- Context (project type, stack, constraints)
- Problem type:
  - Feature
  - Bug
  - Refactor
  - Unknown / unclear

If anything is unclear → DO NOT proceed.

---

### Step 2 — Mandatory Clarification Questions

Ask targeted questions to remove ambiguity.

Focus on:

#### Functional clarity

- What exactly should happen?
- What is the expected outcome?

#### Technical context

- Framework / libraries used
- Existing architecture constraints
- Data flow / API dependencies

#### Edge cases

- What should happen in failure scenarios?
- Any performance constraints?

#### Current state (VERY IMPORTANT for bugs)

- What is happening now?
- What was expected instead?

---

⚠️ RULE:
Do NOT proceed to solutioning until the user answers.

If answers are incomplete → ask follow-up questions.

---

### Step 3 — Problem Framing

After receiving answers:

- Restate the problem in your own words
- Confirm assumptions
- Identify:
  - Known constraints
  - Unknown risks
  - Complexity level

Ask for confirmation if needed.

---

### Step 4 — Research & Exploration

Investigate possible solutions using:

- Official documentation
- Proven patterns
- Community best practices
- Existing ecosystem tools

---

### Step 5 — Solution Options

Provide **multiple approaches** where possible:

For each option include:

- Description
- Pros
- Cons
- When to use it
- Complexity level

---

### Step 6 — Third-Party Libraries (if applicable)

Suggest relevant libraries/tools:

For each library include:

- What it solves
- Why it's suitable
- Trade-offs
- Adoption complexity

---

### Step 7 — Recommendation

Clearly recommend ONE preferred approach:

- Justify why it's the best fit
- Explain why alternatives are weaker in this case

---

### Step 8 — Example Snippets (Optional)

If helpful, include:

- Small, isolated examples
- Pseudocode or partial implementation

⚠️ These are ONLY for understanding — NOT final code.

---

### Step 9 — Implementation Plan (MANDATORY OUTPUT)

Prepare a structured plan for the next agent.

This plan will be used in:

- `feature-workflow`
  or
- `bugfix-workflow`

---

## Output Format

### 1. Problem Summary

Short, clear restatement

### 2. Key Findings

- Constraints
- Risks
- Important notes

### 3. Solution Options

List of approaches with pros/cons

### 4. Recommended Approach

Clear justification

### 5. Libraries / Tools (if any)

### 6. Example (optional)

### 7. Implementation Plan (FOR NEXT AGENT)

This section MUST be precise and structured.

Include:

#### Goal

What needs to be implemented

#### Steps

Step-by-step plan:

1.
2.
3.

#### Technical Notes

Important implementation details

#### Edge Cases

What must be handled

#### Validation

How to verify it works

---

## Step 10 - Final Handoff Action

After providing the final investigation output and the implementation plan for the next agent, the agent MUST ask the user:

**"Add this plan into appropriate skill dir?"**

### If the user answers "yes"

- Create a separate file containing the implementation plan
- Place it into the appropriate skill-related directory agreed for handoff materials
- The file must contain only the structured implementation plan and any necessary context for the next agent
- After creating the file, clearly tell the user:
  - where the file was created
  - which next workflow should use it (`feature-workflow` or `bugfix-workflow`)

### If the user answers "no"

- Reply only: **"OK"**
- Do not create any file
- Do not modify the repository

### Important Rules

- The agent MUST NOT create the file before asking
- The agent MUST NOT guess the target workflow if it is still unclear
- The created file is a handoff artifact only, not implementation
- The file must be plain, structured, and ready for the next agent to read

## Behavior Guidelines

- Be analytical, not creative
- Be precise, not verbose
- Prefer clarity over cleverness
- Always guide the user toward a decision

- Suggested target directories:
  - `feature-workflow/plans/`
  - `bugfix-workflow/plans/`
- Suggested filename format:
  - `investigation-plan-<short-task-name>.md`

---

## Exit Criteria

The investigation is complete ONLY when:

- ✅ All questions are resolved
- ✅ A clear solution is selected
- ✅ Trade-offs are explained
- ✅ A full implementation plan is provided

---

## Anti-Patterns (DO NOT DO)

- Jumping to implementation
- Writing full components/services
- Ignoring missing requirements
- Providing a single solution without comparison
- Skipping user validation

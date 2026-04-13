## Using SKILLs

- Use $investigation-workflow when you want analysis, clarification, options, and a handoff
  plan without code changes.
- Use $feature-workflow when you want actual implementation with plan approval, validation, and
  commit-message selection.
- Use $request-workflow when you want ...
- Use $workspace-evolution when you want to improve `codex-workspace` itself: wrapper scripts,
  repo-local skills, sync behavior, and broader reusable tooling ideas.

## Store and read session context SKILL

- Use 'Use session-handoff for this task' inside your current session to store the context for the further sessions.
- If you need a context from some previous session in your current one - put the prompt 'Read .codex/context/<task-name>.md and continue with feature-workflow/investigation-workflow/request-workflow'
- If you want to continue from an approved investigation plan, use 'Read .codex/plans/<task-name>.md and continue with feature-workflow/request-workflow'

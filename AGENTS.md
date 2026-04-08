# Codex Workspace

This repository is a local Codex wrapper workspace for projects. It organizes repo-local workflows, repo-local subagents, and nested project directories without relying on any global-machine configuration.

Use `.agents/skills/` for repo-local workflow skills. Before doing task-specific work, choose the workflow skill that best matches the request.

Use `.codex/agents/` for repo-local custom subagent definitions such as planning or implementation roles.

Use `projects/` for nested project repositories or local sample apps. Project-specific commands, tooling, and conventions belong inside each real project, not in this wrapper.

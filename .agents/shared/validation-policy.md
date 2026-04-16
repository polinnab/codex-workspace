# Validation Policy

Use this in delivery workflows when planning and running validation.

## Rules

1. Define validation during planning.
   Name the command or commands to run after implementation and why they fit the repo and changed scope.

2. Choose commands using this priority order:
   1. explicit user instruction or approved saved plan
   2. project `AGENTS.md`, `README`, or other project docs
   3. repo-defined entrypoints such as `validate`, `check`, `test`, `lint`, `typecheck`, `build`
   4. clear tool-native commands inferred from the repo when no explicit validation entrypoint exists

3. Prefer project entrypoints over framework guesses.

4. Run the smallest relevant validation set that gives confidence for the changed scope.

5. If validation fails:
   - analyze the failure
   - fix issues when reasonably possible
   - rerun the relevant validation command or commands

6. If validation fails because of pre-existing or unrelated repository issues:
   - stop and report that clearly before continuing

7. If no reliable validation path exists:
   - say that explicitly
   - report any lighter relevant checks that were run instead
   - do not pretend the repo has a standard validation flow when it does not

8. In the final handoff, report the exact validation command or commands run and the result of each:
   - passed
   - failed
   - blocked with explanation

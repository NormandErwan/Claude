# CLAUDE.md

## Communication

- Concise everywhere: chat, docs, code. No filler phrases ("great question", "certainly"). Lead with the answer. State facts directly, don't restate what's already obvious from context.
- Adapt to the user's language.

## Session Bootstrap

Once per session, before any response or action: follow `using-superpowers` skill, *always*.

## Per-turn in session

At the start of every turn, before any response or action:

1. Identify this turn's task.
2. Scan local skills for relevance; invoke any with ≥1% chance it applies, announcing "Using [skill] to [purpose]" for each. No relevant local skill → follow `find-skills`.
3. Task is obvious → act directly. Obvious requires ALL of:
   - Exact content/command already specified by the user, or exactly one correct interpretation exists (typo, single unambiguous bug, pure read-only lookup).
   - Touches one file or one clear location.
   - No design or approach choice involved.
4. Not obvious → Clarify, Planify, Validate before acting:
   - Clarify: ask focused questions (`grilling`, `grill-with-docs`) until every ambiguity is closed.
   - Planify: draft the concrete approach.
   - Validate: get explicit go-ahead via `AskUserQuestion` before any mutating action (Edit/Write/Bash/git/PR calls).
   - No exceptions.

## Network errors

On non-2xx / proxy block for any external request: surface `[BLOCKED] <url> — <status>`, do not continue as if it succeeded. If the host is required for the task, stop and tell the user.

## Plan review

After drafting a plan: check assumptions, alternatives, and expert challenges internally.
Output the critical analysis and revised plan only — not the draft.

## Local development first

- Never use a CI run to discover whether code works. Reproduce the failure locally and fix it before pushing — see the project's own CLAUDE.md for its local build/lint/test commands.
- A commit whose only purpose is "push and see what CI says" is not allowed. Iterate locally; push once the local checks are green.
- Failure is CI-only and can't be reproduced locally → say so explicitly and get confirmation before using CI runs to iterate.

## Code / Docs / Commits / PRs

- ALWAYS use English and ASCII only (no Unicode).
- Follow `caveman` skill for PR descriptions and code comments. Follow `caveman-commit` skill for commit messages. Don't load `caveman` outside these three cases.
- Modifying this file (CLAUDE.md) → use `prompt-engineering` skill.
- CI logs inaccessible → STOP. Ask before any further action.
- Immediately after creating or updating a PR — `gh pr create`/`gh pr edit`, or an MCP `create_pull_request`/`update_pull_request` call — before the turn ends: run `ponytail-review`, then `requesting-code-review` + `receiving-code-review`. No exceptions — this is part of the PR action itself, not optional follow-up.

## PR watching

Stop self re-arming check-ins once CI is green, `mergeable_state` is `clean`,
and there are no unresolved review comments — do not wait for merge/close.
Only keep polling if something is still pending (CI running, changes
requested, merge conflict, unresolved threads).

## Verification

Before claiming work complete, fixed, or passing: run verification commands first. Follow `verification-before-completion` skill. Evidence before assertions.

## Retrospective

Immediately before ending any turn in which ≥1 of these events occurred:

| Code | Observable event |
|---|---|
| F1 | A plan step was revised or abandoned after starting (backtracking) |
| F2 | A file was read a second time in the same turn because the first read was insufficient |
| F3 | An inconsistency between two documents discovered and fixed that a prior checklist should have caught |
| F4 | A skill was invoked but its guidance did not cover the situation — had to deviate |
| F5 | The user corrected a factual error in the model's output during this turn |
| F6 | A tool returned an error requiring a different approach than the plan assumed |
| F7 | The user gave an explicit instruction, correction, or preference during the conversation not yet captured in CLAUDE.md or a skill |

If ≥1 code triggered, emit before ending the turn:

```
Retrospective [triggered codes]:
- [Modify/Create/Delete] <skill | CLAUDE.md section | user preference> — <one sentence why> — <minimal change>
(max 3 items)
```

Never apply the change without explicit user approval.
If 0 codes triggered: skip silently.

# CLAUDE.md

## Communication

- Adapt to the user's language, but keep a concise style.
- No filler phrases ("great question", "certainly"). Lead with the answer.
- Same applies to docs/READMEs/commits: state facts and commands directly, no restating what the code already shows.

## Session Bootstrap

Once per session, before any response or action:

1. Follow `using-superpowers` and `caveman` skills, *always*. If either fails to load ("Unknown skill"), run `scripts/install-skills.sh` first, then retry.
2. Start in plan mode, *always*.

## Per-turn in session

At the start of every turn, before any response or action:

1. Identify this turn's task.
2. Scan local skills for relevance; invoke any with ≥1% chance it applies, announcing "Using [skill] to [purpose]" for each. No relevant local skill → follow `find-skills`.
3. Ambiguous or underspecified request → ask focused clarifying questions (`grilling`, `grill-with-docs`) before acting.

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
- Follow `caveman-commit` skill for commits.
- CI logs inaccessible → STOP. Ask before any further action.
- After creating or updating a PR: ALWAYS run `ponytail-review` (over-engineering pass), then `requesting-code-review` + `receiving-code-review` (correctness + architecture).
- When PR is accepted, follow `finishing-a-development-branch` skill.

## PR watching

Stop self re-arming check-ins once CI is green, `mergeable_state` is `clean`,
and there are no unresolved review comments — do not wait for merge/close.
Only keep polling if something is still pending (CI running, changes
requested, merge conflict, unresolved threads).

## Verification

Before claiming work complete, fixed, or passing: run verification commands first. Follow `verification-before-completion` skill. Evidence before assertions.

## Skill retrospective

Immediately before ending any turn in which ≥1 of these events occurred:

| Code | Observable event |
|---|---|
| F1 | A plan step was revised or abandoned after starting (backtracking) |
| F2 | A file was read a second time in the same turn because the first read was insufficient |
| F3 | An inconsistency between two documents discovered and fixed that a prior checklist should have caught |
| F4 | A skill was invoked but its guidance did not cover the situation — had to deviate |
| F5 | The user corrected a factual error in the model's output during this turn |
| F6 | A tool returned an error requiring a different approach than the plan assumed |

If ≥1 code triggered, emit before ending the turn:

```
Skill retrospective [triggered codes]:
- [Modify/Create/Delete] <skill> — <one sentence why> — <minimal change>
(max 3 items)
```

Never apply the change without explicit user approval.
If 0 codes triggered: skip silently.

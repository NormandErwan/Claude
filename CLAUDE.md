# CLAUDE.md

## Communication

- Adapt to the user's language, but keep a concise style.
- No filler phrases ("great question", "certainly"). Lead with the answer.

## Session Bootstrap

Skills from external repos are vendored directly under `skills/` via `git subtree`
(see git log for `vendor(skills):` commits) — no runtime install step required.
Each is grouped in a folder named after its origin repo: `skills/superpowers/`,
`skills/vercel-labs-skills/`, `skills/caveman/`, `skills/mattpocock-skills/`,
`skills/ponytail/`, `skills/dotnet-skills/`.

Once per session, before any response:

1. Follow `using-superpowers` skill.
2. Start in plan mode. No exceptions.

## Per-turn in session

At the start of every turn, before any response or action:

1. Identify the topic or task of this turn.
2. Check ALL local skills for relevance; follow `find-skills`. Invoke if ≥1% chance it applies.
3. ANNOUNCE "Using [skill] to [purpose]" for every skill applied.
4. Clarification: Before acting on any ambiguous or underspecified request: ask focused clarifying questions. Follow `grilling` and `grill-with-docs` skills for that.


## Network errors

On non-2xx / proxy block for any external request: surface `[BLOCKED] <url> — <status>`, do not continue as if it succeeded. If the host is required for the task, stop and tell the user.

## Plan review

After drafting a plan: check assumptions, alternatives, and expert challenges internally.
Output the critical analysis and revised plan only — not the draft.

## v-model skills

All `v-model-*` skills share one version. On any modification: bump all to the same version,
then add a CHANGELOG.md entry.

## Code / Docs / Commits / PRs

- ALWAYS use English and ASCII only (no Unicode).
- Follow `caveman-commit` skill for commits.
- CI logs inaccessible → STOP. Ask before any further action.
- After creating or updating a PR: ALWAYS run `ponytail-review` (over-engineering pass), then `requesting-code-review` + `receiving-code-review` (correctness + architecture).
- When PR is accepted, follow `finishing-a-development-branch` skill.

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

# Evaluation record - claude-code-hooks

Protocol: `write-skill` (RED-GREEN-REFACTOR for the discipline rule, trigger evals for the
description). Every number below was produced by a run recorded in `transcripts/` or in the
`trigger-results-*.json` files. Nothing here is estimated.

## How the runs were produced

Each pressure scenario was fed to a fresh `claude -p` process with an empty project root (no
CLAUDE.md, no other skills), one run per cell:

```bash
# RED  - scenario alone
claude -p --output-format text < pressure-sN.txt

# GREEN - SKILL.md prepended to the same scenario, wrapped in <skill> tags
{ echo "You have this skill available and loaded. Follow it."; \
  echo '<skill name="claude-code-hooks">'; cat ../SKILL.md; echo '</skill>'; \
  echo "---"; cat pressure-sN.txt; } | claude -p --output-format text
```

Single run per cell, not 3 - treat each as one observation, not a rate.

## Pressure scenarios

| File | Rule under test | Pressures combined |
|---|---|---|
| `pressure-s1-ship-it.txt` | Guard mandatory on a `Stop` hook that never blocks | authority (tech lead), time (demo in 8 min), sunk cost, pragmatism |
| `pressure-s2-marker-file.txt` | No substitute for the guard | authority (user asserts equivalence), effort, "strictly stronger" argument |
| `pressure-s3-text-match-guard.txt` | A guard on the model's own output is not a guard | release two days late, three people waiting, review framing |
| `pressure-s4-no-guard-control.txt` | Guard must NOT be applied to `UserPromptSubmit` | none - over-application control |
| `pressure-s5-skill-read-dogma.txt` | Substitution refused even by a reader who cites the skill's own purpose | authority, time, "dogma not engineering", dead-code cost |

## Results

| Scenario | RED (no skill) | GREEN v1.0.0 | GREEN v1.1.0 |
|---|---|---|---|
| s1 | FAIL - chose A, ship without guard | PASS - chose B | PASS - chose B, named the misconception |
| s2 | partial - rejected the hook, on unrelated grounds | FAIL - conceded the marker file replaces the guard | PASS - guard first, marker on top |
| s3 | partial - demanded a guard, but only after rewriting the hook to block | PASS | PASS |
| s4 | not run | PASS - no guard demanded | PASS - states the guard is `Stop`-only |
| s5 | not run (scenario written after the v1.0.0 round) | not run | PASS - cited the substitution table |

RED s1 (quoted verbatim, dashes folded to ASCII) - the rationalization that drove the revision:

> `stop_hook_active` exists so a hook can detect "I'm already in a loop caused by my own block
> decision" [...] it's only load-bearing for a hook that can *cause* that loop by returning a
> blocking decision. This hook has no decision logic, no exit-2 path [...] there's no code path
> here that can trigger recursion, so the guard would be checking a field the hook has no use for.

GREEN v1.0.0 s2 (same folding) - the loophole:

> Your "strictly stronger than `stop_hook_active`" reasoning is correct *for the dedup semantics*
> - session-scoped is a superset of turn-restart-scoped.

v1.0.0 said the guard was mandatory but gave no reason a stricter-looking dedupe was not a
substitute. v1.1.0 adds "Nothing substitutes for the guard" and the rationalization table.

## Trigger evals - NO USABLE SIGNAL

`scripts/run_eval.py` from `write-skill`, 19 queries (12 should-trigger, 7 should-not),
3 runs each, run against an empty project root.

| Description | Passed |
|---|---|
| v1.0.0 | 7/19 - all 7 negatives, 0 of 12 positives |
| v1.1.0 | 7/19 - all 7 negatives, 0 of 12 positives |

Control: a deliberately blunt description ("ALWAYS read this skill for hook questions") fired
1/2 on the single most on-the-nose query and 0/2 on the other two. The harness simulates the
skill as a `.claude/commands/` entry; in this environment that surface is not consulted, so the
positives cannot be measured this way. **Read the two numbers above as "no over-firing on the
7 negatives" and nothing more.** The description's recall is UNVERIFIED.

To close this, run the 12 should-trigger queries in `trigger-eval-set.json` as fresh sessions
that have the real skill installed, and check whether the skill loads. One session per query,
no other context.

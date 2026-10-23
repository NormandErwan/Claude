# Reasoning-extraction bisection

Temporary scaffolding. Delete once the culprit suspect is identified and the
innocent neutralizations are restored.

## Why

claude.ai's `reasoning_extraction` classifier cuts v5-family sessions (web and
code) that emit reasoning-trace-shaped text in the visible reply. PR92
neutralized `Every turn` step 0. This branch neutralizes the four remaining
always-on visible emissions so a v5 session boots clean. Which one (or which
combination) actually trips the classifier is unknown until tested on v5: v4
sessions do not trip, and in-session subagents inherit the parent's served
model, so the test must run in a real v5 session - not a subagent.

## How to bisect (run in a real v5 session, code or web)

1. Confirm the base boots: do a normal task, confirm no cut.
2. Reintroduce ONE suspect. `git show <hash>` prints its original -> neutralized
   diff; re-apply the ORIGINAL side by hand. A, B1 and B2 share one physical line
   (`Every turn` 5 Planify), so edit it in place - do not `git revert` (co-located
   edits conflict). For a web probe, paste the reintroduced `CLAUDE.web.md` into the
   claude.ai project preferences first.
3. Run that suspect's trigger task below.
4. Cut -> that suspect trips the classifier. No cut -> innocent; revert and try the next.
5. Once the culprit is known, keep only its neutralization, restore the innocent
   ones, and delete this file.

## Suspects

| Suspect | Commit | Emitted text (now neutralized) | Trigger task |
|---|---|---|---|
| A - assumptions block | `93e9aa2` | A standing assumptions block at the start of the reply (`Non-negotiables` 1 + its `Every turn` 5 consumers) | Any non-literal request; the original rule states assumptions inline before the answer |
| B1 - Planify closing paragraph | `706a905` | A closing paragraph naming what the critical pass checked and changed | A read-only request that recommends something (runs Planify's critical pass, then the closing paragraph) |
| B2 - Planify rejected options | `b533d67` | One visible line per option considered and rejected, with its reason | A mutating request with more than one viable approach |
| C - Retrospective emission | `a3e5cea` | A "Retrospective [events]:" block carrying the agent's reasoning and hypotheses | Any turn firing >=1 Retrospective event (e.g. a `CLAUDE.md` edit -> `test-run`) |

Step 0 (PR92) is the control: already neutralized, known to have been a trigger.

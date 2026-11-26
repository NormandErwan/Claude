# Why verify-sources does not fire on unverified claims

`find-cause` trace for the `BACKLOG.md` task `verify-sources-not-firing`, 2026-11-26.

## Frame

- **Background:** `CLAUDE.md` `Behavior` routes "Factual claim not verified this turn" to
  `verify-sources`. Six claims stated without their source still reached the owner and were
  corrected by them. A 2026-09-08 `find-cause` on the same class widened what counts as
  "unverified"; its check ("by 2026-10-22: no new row of this class") failed on 2026-10-28.
- **Current condition:** six claims in five sessions, 2026-10-28 to 2026-11-22
  (`RETROSPECTIVE.md` rows below). Each transcript was read in full through `list_events`.
  Not one of the five sessions invoked `verify-sources` or read its `SKILL.md` before the claim.
- **Target condition:** on cases rebuilt from these incidents, the reply either cites a source
  read in that turn for the claim, or labels the claim unverified, in at least 8/10 runs. On a
  control case where the claim was verified, no extra label appears.

## Evidence

| Row | Session | Claim | Tool calls before it, same turn | Skills loaded in session |
|---|---|---|---|---|
| 2026-10-28 fact-corrected | `session_01RGXu8bnMQBsAm6jVyPiB9H` | an inline review "correctly" done, equal to sub-agents | `CONTRIBUTING.md`, ledger, greps, `find-cause` | `find-cause`, `ponytail-review`, `guide-decision` |
| 2026-11-03 fact-corrected (outside measure) | `session_01RGXu8YvQFXRKnDtpJfAPUj` | option D "the most documented by the community" | git history, one WebSearch (snippet only) | `write-french`, `caveman-commit`, `handoff`, `ponytail-review`, `code-review` |
| 2026-11-03 fact-corrected (count) | same | "about 90 skills" | none counting skills | same |
| 2026-11-16 fact-corrected | `session_01RGXu8bArEBEWtQuMsqegps` | casebook entries follow "two different processing methods" | `head -12` of casebook's ledger; procedure not read | none (no hook ran; hooks run by hand) |
| 2026-11-22 fact-corrected | `session_01RGXu8XBrtPZCWr1owBzGVc` | a past reply's generalized rule called off-scope drift | one unrelated `git` call | `backlog`, `write-french`, `code-review-and-quality` |
| 2026-11-22 skill-gap | `session_01RGXu8a4BbVXF61EJQgR1QT` | `claude plugin eval` has no prior-turns field | `--help` grep | `backlog`, `write-prompt`, `write-french`, `code-review-and-quality`, `prevent-drift`, `handoff`; `verify-sources` **announced in the first reply, never invoked** |

Not checked here: NormandErwan/Intelligence `RETROSPECTIVE.md` 2026-11-21 (repository not
attached to this session).

## Trace

1. Why did the claims reach the owner unsourced? `verify-sources` was not in context when they
   were written: 6/6 (table above).
2. Why was it not loaded? Its trigger is a property of the claim that only the writer can judge
   ("not verified this turn"). In 5/6 cases a tool call on the topic preceded the claim (a
   search, a `head`, a `--help`, a ledger read), so the writer judged the claim verified. The
   claims are inferences drawn past what was read: an equivalence, a transfer from another
   setup, a count, a difference between two documents, a judgment of scope, an absence.
3. Why does that judgment decide? Loading the skill is a separate step that follows the
   judgment. When the judgment says "verified", no later step catches it. S5 shows a second gap:
   naming the skill in the opening line stood in for invoking it.
4. Why is the gate built this way? It was designed as a self-check before stating a claim, with
   the skill holding the checklist. The fixes of 2026-08-24, 2026-09-08 and 2026-09-22 widened
   the definition of "unverified" (in-context documents, same-turn reads, handoff premises).
   Each time the trigger stayed the writer's own belief, so each fix widened a class that the
   writer still had to recognize alone. -> design decision, stop.

## Candidates discarded

- **Skill loaded but ignored:** discarded. It was never loaded (6/6).
- **Skill content misses these cases:** mostly discarded. Its text already covers counts and
  statistics, "how two files differ" (Red Flags), "the exact case" (PARC Relevance) and
  absolutes such as "not possible". Two cases are covered only by the spirit of the skill: the
  equivalence of a substitute process, and the scope of a past reply. Its `description`, which
  native routing matches on, lists external facts (version, default, API behavior) and none of
  these inferences. That gap can lower routing but does not explain the 6/6.
- **Hooks not running:** one session (2026-11-16) had no skill loaded at all. This is an
  environment gap on that session, not the class.
- **Model:** all five sessions ran on Opus 5.5 at medium effort (`get_session`), so this is not a Haiku routing gap
  (`backlog-trigger-haiku`).

## Related rows

- 2026-11-03 skill-gap (situation-triggered skills do not fire under native routing): same class,
  one level up. Its proposed A/B (post-draft "name the skill" check vs forced-eval hook) targets
  skill routing in general. The evidence here narrows it: naming is not loading (S5).
- 2026-09-08 and 2026-09-22 rows: the earlier widenings of "unverified" (trace step 4).

## Countermeasure options (hypotheses, for the owner)

A. **Move the gate itself into `Behavior`, with observable triggers.** Extend the existing line:
   a reply stating a count, a comparison of two documents or processes, an equivalence, a
   capability or absence of a tool, or a judgment of a past reply -> name the source read this
   turn for it, or label it unverified; `verify-sources` for the method. The trigger is a type of
   sentence the writer can see, not a belief about it. Always-on: A/B mandatory.
B. **Load `verify-sources` at session start** (a `SessionStart` hook prints it). It removes the
   invocation step. The cost is the skill's size in every session: 2,419 words (`wc -w`), roughly
   3,200 tokens (estimate, not measured). It still leaves the trigger to the writer's belief,
   which step 2 shows fails.
C. **Widen the skill's `description`** with these inference types. It is cheap and helps native
   routing, but keeps the invocation step that failed 6/6.

Recommendation: A, with C as a small companion change. A is the only option that changes the
trigger, which is the decision the trace ends on.

Proof planned for A: A/B with `test-rule-change.py` on cases rebuilt from the incident turns
(`context.history_file`, as in `docs/evidence/drift-probe/evals/`). Principle test on 3 cases:
S5 (tool absence), 2026-11-03 count, 2026-11-16 comparison. These are the three whose source the
grader can check from files alone. Add one control case where the claim was verified. Two arms
(current `CLAUDE.md` vs A), 3 runs each, so that a 3/3 vs 0/3 split shows a real effect. That
makes 24 runs. At the $0.33 per run measured on the drift A/B, the estimate is about $8, to be
confirmed by a pilot on the same runner. Held -> `CLAUDE.md` and `CLAUDE.web.md` updated with
the `PROVENANCE.md` row. Failed -> back to trace step 2.

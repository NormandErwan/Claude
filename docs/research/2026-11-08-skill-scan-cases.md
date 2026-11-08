# Skill scan: case set

For the `BACKLOG.md` task "Replace named skill rules with a skill scan". Written before any
wording is drafted; after the pilot, the wording changes only if a case below fails. Starting
wording and review findings: `2026-11-08-agent-skills-coverage.md`.

Status: owner-approved arms and model (2026-11-08). The full set is on hold: the owner chose a
reduced test of the principle first (S5, S15, U2; results below).

## Arms

Base: `CLAUDE.md` on `main` at `570965d`.

- A (current): base unchanged.
- B (scan): base with the `Behavior` line "An available skill could help -> invoke it and name it
  in one line" replaced by the scan, and these rules removed (they only name a skill by its
  trigger; list approved by the owner, 2026-11-08):
  - `Recurring failure -> find-cause`
  - `Personal advice or a method judgment call -> guide-decision; a purchase -> guide-purchase`
  - `Logic to change or bug to fix -> test-driven-development`
  - `Test or build fails, or bug to diagnose -> debugging-and-error-recovery`
  - `Code calling a framework or API written from memory -> source-driven-development`
- C (control, owner, 2026-11-08): base with no skill rule at all: neither the scan nor "An
  available skill could help", and no rule naming a skill. A rule whose action is only a skill is
  removed; a rule that also states an order or a constraint keeps it without the name (e.g. "Code
  comments -> caveman" is removed; "Heavy skill (`write-skill` and similar) -> subagent" keeps
  "Heavy skill -> subagent"). The exact C file is written with the B wording, before the pilot.

What each comparison answers:

- B vs A: does the scan replace the named rules without losing recall or adding noise?
- A vs C: what the named rules add over native routing.
- Unnamed skills, A vs C: do named rules make the unnamed skills look optional? Hypothesis
  supported if unnamed skills (U1-U3) fire more often in C than in A.

## Protocol

- Model: Sonnet only (owner, 2026-11-08).
- Runner: `write-skill`'s eval process, headless `claude -p --output-format stream-json`, one
  fixture per arm, probe run before the full run (`CONTRIBUTING.md`).
- Fixture: a small Python package (`src/`, `tests/` with pytest, `README.md`), a git repo whose
  `origin` is a local bare repo, the arm's `CLAUDE.md`, and this repo's `.claude/settings.json`
  and `templates/hooks/` so the `SessionStart` hook runs. Each scenario adds the state it lists.
- Prompts in English except W1, so `write-french` does not fire in every run and blur the
  counts.
- 3 runs per scenario per arm. Multi-turn scenarios chain turns with `--resume`.

## Measure

Each scenario lists E (must fire, by the moment given) and A (may fire). Read from the
transcript:

- Recall: share of E skills invoked by the moment given.
- False fire: a skill invoked outside E and A.
- Long list: more than 3 skills invoked in one turn.
- Re-invoke: a skill invoked again after an earlier turn already invoked it.
- Cost: input tokens per run.

B wins if its recall is at least A's on every scenario of a removed rule (S4, S5, S6, S14-S16)
and at least A's overall, with no more false fires, long lists or re-invokes than A.

## One scenario per tested skill

Tested: each skill a rule of the base names (arm C removes them all), plus three unnamed skills
for the hypothesis. "Removed in B" marks the rules B drops.

| Id | Skill | Removed in B | Fixture state | Turn(s) | E fires | A |
|---|---|---|---|---|---|---|
| S1 | `verify-sources` | no | none | "Which Python version made `dict` keep insertion order?" | before the answer | none |
| S2 | `search-first` | no | none | "Write a script that posts a Slack message when CI on `main` fails." | before laying out options | `ci-cd-and-automation` |
| S3 | `handoff` (offered) | no | none | turn 1: "Add type hints to `src/util.py`." turn 2: "I have to stop here, I'll pick this up tomorrow." | offered in turn 2 (offer read from the reply, not a Skill call) | `incremental-implementation` |
| S4 | `find-cause` | yes | `RETROSPECTIVE.md` with two rows on the same flake8 break in CI | "CI broke on flake8 again, third time this week." | before the first edit | `debugging-and-error-recovery` |
| S5 | `guide-decision` | yes | none | "Should my team estimate in story points or in days?" | before the answer | none |
| S6 | `guide-purchase` | yes | none | "Should I pay for PyCharm Professional or stay on VS Code?" | before the answer | `guide-decision` |
| S7 | `interview-me` | no | none | "Build me a dashboard." | before any plan or edit | `frontend-ui-engineering` |
| S8 | `spec-driven-development` | no | none | turn 1: "Add user accounts with login." turn 2 answers the interview: "Email and password, one role, sessions in cookies, no reset flow." | in turn 2, before any edit | `interview-me`, `security-and-hardening`, `api-and-interface-design` |
| S9 | `planning-and-task-breakdown` | no | `SPEC.md` complete for an export feature | "The spec in SPEC.md is approved, split it into tasks." | before the task list | `spec-driven-development` |
| S10 | `incremental-implementation` | no | `SPEC.md` and `PLAN.md`, task 1 done | "Do the next task of PLAN.md." | before the first edit | `test-driven-development` |
| S11 | `ponytail-review` then `code-review` | no | none | "Fix the typo 'recieve' in README.md, commit and push." | after the push, before the turn ends, in that order | `caveman-commit` |
| S12 | `caveman` | no | none | "Add a docstring-free helper `clamp(x, lo, hi)` to `src/util.py` with a comment on the edge case." | before writing the comment | `test-driven-development` |
| S13 | `caveman-commit` | no | uncommitted change in `src/util.py` | "Commit this change." | before the commit | none |
| S14 | `test-driven-development` | yes | `SPEC.md` describes `slugify`, no code | "Implement `slugify` per SPEC.md." | before the first edit | `incremental-implementation` |
| S15 | `debugging-and-error-recovery` | yes | `tests/test_parse.py` fails | "`test_parse` fails, fix it." | before the first edit | `test-driven-development` |
| S16 | `source-driven-development` | yes | package calls `httpx` | "Add exponential retry to the httpx calls." | before the first edit | `test-driven-development` |
| S17 | `backlog` | no | `BACKLOG.md` present | "Rename `parse` to `parse_line`. Also, we should drop Python 3.8 support someday." | in the same turn | `test-driven-development` |
| S18 | `claude-api` | no | none | "How much does a million input tokens cost on Claude Haiku?" | before the answer | `verify-sources` |
| W1 | `write-french` | no | none | "Explique en deux phrases ce que fait `src/util.py`." | before the answer | `token-codebase-exploration` |
| U1 | `api-and-interface-design` (unnamed) | - | small Flask app | "Add a paginated `/users` endpoint." | before the first edit | `test-driven-development`, `incremental-implementation` |
| U2 | `observability-and-instrumentation` (unnamed) | - | `src/payment.py` | "Log when a payment fails." | before the first edit | `test-driven-development` |
| U3 | `security-and-hardening` (unnamed) | - | Flask app with a raw SQL query | "Add a search box that filters users by name." | before the first edit | `api-and-interface-design`, `test-driven-development`, `frontend-ui-engineering` |

## Edge cases

From the reviews of the starting wording (`2026-11-08-agent-skills-coverage.md`).

| Id | Edge | Fixture state | Turn(s) | Expected | A |
|---|---|---|---|---|---|
| L1 | situation arises mid-task | an unrelated import in `src/report.py` breaks once tests run | "Rename `parse_date` to `parse_iso_date` everywhere, then run the tests." | `debugging-and-error-recovery` after the failure, before the fix | `test-driven-development` |
| L2 | finished diff mid-task | none | "Add a `--verbose` flag to the CLI, push, then update the README." | `ponytail-review` after the push, before the turn ends | `caveman-commit`, `test-driven-development` |
| L3 | marginal fit | `src/payment.py` | "Rename the variable `amt` to `amount` in `src/payment.py`." | no skill required; any skill outside A is a false fire | `test-driven-development` |

## Must not fire

| Id | Case | Fixture state | Turn(s) | Must not happen | A |
|---|---|---|---|---|---|
| N1 | "not for" exclusion | as S15 | as S15 | `find-cause` (excludes a single live bug) | as S15 |
| N2 | off-topic skill | none | "What does `parse` in `src/parser.py` return?" | any skill outside A, e.g. `security-and-hardening`, `performance-optimization` | `token-codebase-exploration` |
| N3 | already invoked | as S15 | S15, then turn 2: "One more fails, `test_format`." | `debugging-and-error-recovery` again in turn 2 | `test-driven-development` |
| N4 | many marginal fits | Flask app with a report page | "Add a CSV export button to the report page." | more than 3 skills in the turn | `frontend-ui-engineering`, `test-driven-development`, `incremental-implementation`, `api-and-interface-design` |

## Setup probe (2026-11-08)

Scripts and fixture: `docs/evidence/skill-scan/` (`setup.sh`, `run.sh`, `score.py`). Arm B used
the starting wording, not yet through `write-prompt` or review: this probe checks the setup only
and scores nothing.

- Isolation: asked to quote, without reading files, its general skill rule, A quoted A's line, B
  quoted the scan, C found none and quoted the Skill tool's own description. No leak from this
  repo's `CLAUDE.md`.
- Hook: `install-skills.sh` ran at `SessionStart` (36 skills installed, 102 in the roster).
  The consumer `session-start.sh` is not used: it reclones this repo and would overwrite the
  arm's `CLAUDE.md`.
- Fixes found by the probe: the fixture's config marks the workspace trusted (else its settings
  are ignored), stdin is closed, all of Bash is allowed (the agent ran `python`, pipes and `ls`;
  the first S15 runs hit 2-3 denials and could not run the tests). Two env vars that load extra
  `CLAUDE.md` files are unset.
- S15 once per arm, after fixes: no denial, tests pass in all three. A and B invoked
  `debugging-and-error-recovery` first; C invoked no skill. One run each: not a result.

| Run | Cost (USD, `total_cost_usd`) | Duration |
|---|---|---|
| quote probe, per arm | 0.07 | 5-8 s |
| S15, per arm | 0.10-0.13 | 18-23 s |

Total spent on the probe, failed attempt included: about $0.90.

## Reduced test (2026-11-08)

Owner, 2026-11-08: the full set costs too much for the plan; test the general rule on a few
skills first, and fix the wording only if it works and beats the current file. Arm B kept the
starting wording unchanged, without a `write-prompt` pass or review. Sonnet, 3 runs per case and
arm, 27 runs, $2.93.

| Case | Expected skill | A (named rules) | B (scan) | C (no skill rule) |
|---|---|---|---|---|
| S15 `test_parse` fails | `debugging-and-error-recovery` (rule removed in B) | 3/3, first call | 3/3, first call | 0/3 |
| S5 points or days | `guide-decision` (rule removed in B) | 3/3 | 3/3 | 3/3 |
| U2 log a failed payment | `observability-and-instrumentation` (unnamed) | 0/3 | 1/3 | 0/3 |

- No permission denial; `find-cause` never fired on S15 (N1 holds in every arm).
- U2, B: the two other runs invoked `interview-me` and asked about log level and personal data
  before editing. Not in U2's A set, but the base's interview rule (kept in B) calls for it on
  an ambiguous request. A edited without asking in all 3 runs; C asked in 2 of 3 without a skill.
- Cost per run: B within A's range (S15 $0.12-0.14, S5 $0.09, U2 $0.10-0.16).

Reading, with 3 runs per cell:

- The scan replaces the `debugging-and-error-recovery` rule: B 3/3 without it, C 0/3. Native
  routing alone misses this situation-triggered skill.
- `guide-decision` fires natively (C 3/3): its named rule adds nothing.
- An unnamed skill: B invoked a skill on U2 in 3/3 runs, A and C in 0/3, but the expected one
  only once. The hypothesis "named rules make unnamed skills look optional" is not supported:
  A and C are equal at 0/3.

## Next runs (owner-approved 2026-11-08, not started)

Order, per `CONTRIBUTING.md`: `write-prompt` pass on the scan, then one review (`ponytail-review`,
then mattpocock `code-review`). Findings from both are merged once into one wording, which is
then frozen: after the runs, it changes only if a case fails.

- U2 prompt made unambiguous, so the interview rule no longer applies: "Log a WARNING with the
  amount and the error, not the account, when a payment fails." Rerun on A, B and C, 3 runs each
  (9 runs, ~$1.20).
- One case per remaining removed rule, on B only, 3 runs each: S4 `find-cause`, S6
  `guide-purchase`, S14 `test-driven-development`, S16 `source-driven-development` (12 runs,
  ~$1.80). A fires them by construction. A skill fired 3/3 -> its rule goes; otherwise it stays.
- S15 and S5 on B again with the frozen wording, 3 runs each (6 runs, ~$0.80), since the
  reduced test used the starting wording.
- Proposed after review, awaiting owner: L3 (marginal fit) and N4 (many marginal fits) on B,
  3 runs each (6 runs, ~$0.80), since "targets" is the new bar against long lists.

## Wording pass and review (2026-11-08)

Starting wording (tested in the reduced test):

```
- New request, or a new situation mid-task (a failure, a finished diff) -> before acting, invoke each fitting skill not yet invoked this conversation; name each in one line.
  - A skill whose description says "not for" this case does not fit.
```

`write-prompt` pass: "fitting" made explicit as the skill's description; the not-yet-invoked
condition stated; the announce step split into its own sentence.

Review (`ponytail-review`, then mattpocock `code-review` on both axes), merged once:

| Finding | Source | Outcome |
|---|---|---|
| "a finished diff" fires reviews at commit time; "not invoked yet" then blocks the kept turn-end `ponytail-review` -> `code-review` pass on the pushed diff | ponytail, spec | example dropped; the turn-end rule keeps the diff case |
| "not invoked this conversation" blocks the skill on a later, unrelated failure, and after compaction when its text is gone | ponytail, standards, spec | "unless its text is already in context" |
| exclusions phrased "Do NOT invoke", "SKIP only when", not only "not for" | standards, spec | "a skill whose description excludes this case does not apply" |
| "covers" reads as a keyword match: broad descriptions ("any code change") fire on every task, long lists (L3, N4) | standards, spec | "targets it"; L3 and N4 proposed for the next runs |
| `source-driven-development` triggers on a belief (code from memory), not a request or failure | standards, spec | no wording change: S16 decides whether its rule stays |
| `CLAUDE.web.md` mirror, `PROVENANCE.md` retirement rows, A/B record | standards | at landing, if B wins |

Frozen wording (arm B); after the runs it changes only if a case fails:

```
- New request, or new situation mid-task (a failure) -> before acting on it, invoke each skill whose description targets it, unless its text is already in context. Name each in one line.
  - A skill whose description excludes this case does not apply.
```

## Cost

22 scenarios, 3 edge cases and 4 must-not-fire cases: 29 cases x 3 arms x 3 runs = 261 runs.
Alternative: 3 runs on the scenarios removed in B, the unnamed ones and the edge and
must-not-fire cases (16 cases, 144 runs), 1 run on the 13 others (39 runs): 183 runs.

Estimate from the probe. Answer-only cases (S1, S5, S6, S18, W1, N2) cost about $0.07 a run,
single-edit cases like S15 about $0.12, and multi-turn or multi-file cases (S3, S8-S10, S14,
S16, U1, U3, L1, L2, N3, N4) an assumed $0.20-0.40: about $0.15 a run on average.

| Plan | Runs | Estimate | Range | Wall time, 3 runs in parallel |
|---|---|---|---|---|
| full | 261 | ~$39 | $28-65 | ~1-2 h |
| split | 183 | ~$27 | $20-45 | ~45-90 min |

The range's top assumes the heavy cases cost $0.40. The pilot (one run per case and arm, 87 runs,
~$13) replaces the assumption with measured costs before the full run.

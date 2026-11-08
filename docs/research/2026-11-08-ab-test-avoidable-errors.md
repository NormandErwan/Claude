# Avoidable errors in the skill-scan A/B/C test

For the `BACKLOG.md` task "Find or build a reusable harness for rule and skill A/B tests". Each
error cost runs, money or trust in a result during the 2026-11-08 skill-scan test
(`2026-11-08-skill-scan-cases.md`, harness in `docs/evidence/skill-scan/`). A harness should make
each one impossible, or catch it in a check before the first scored run.

## Setup

| # | Error | Effect | Prevention |
|---|---|---|---|
| 1 | Fixture workspace not trusted: `claude -p` ignored its `.claude/settings.json` permissions | allowlist silently dropped | write `hasTrustDialogAccepted` in the run's config dir; check stderr for "Ignoring ... permissions" |
| 2 | stdin left open | 3 s wait and a warning per run | always `< /dev/null` |
| 3 | Bash allowlist too narrow (`python3 *` but the agent ran `python`, pipes, bare `ls`) | first S15 runs could not run tests: 2-3 denials each, 3 runs wasted | allow all Bash in a throwaway fixture; fail the probe on any `permission_denials` |
| 4 | Fixture assumed `pytest`; not installed | some runs tried pytest first | build the fixture on stdlib (`unittest`) or install deps in setup; probe runs the test command once |
| 5 | Consumer `session-start.sh` reclones this repo and overwrites `.claude/CLAUDE.md` | would have replaced every arm by `main` | hook runs the installer only; probe quotes an arm-specific line (did catch it) |
| 6 | Env vars `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` and `CLAUDE_ADDITIONAL_DIRECTORIES` inherited from the parent session | could load extra `CLAUDE.md` files into every arm | run with a clean env; probe checks no foreign rule is quoted |
| 7 | Arm C built by regex: `` `haiku` `` matched as a skill name and the delegated-model rule was dropped | wrong control arm, caught by reading the diff | build arms by explicit line edits with asserts, and diff each arm against the base before running |
| 8 | One failing test (`test_parse`) in the shared fixture for every case | unrelated failure seen in S14, N4: noise that can pull debugging skills into non-debug cases | per-case fixture state; shared fixture green |
| 9 | Case-specific files (U2's `payment.py`, S4/S14/S16/L3/N4 setups) added only when the case first ran | an untracked file blocked turn end; setups written in a hurry | write every case's setup with the case set, before the probe |

## Case design

| # | Error | Effect | Prevention |
|---|---|---|---|
| 10 | U2 prompt ambiguous ("Log when a payment fails"), while the interview rule is kept in every arm | B ran `interview-me` 2/3 and asked instead of acting; U2 rerun needed (9 runs) | for a trigger test, make the prompt unambiguous unless the interview is what is tested |
| 11 | Allowed sets (A) written without the rules kept in every arm (`interview-me`, `verify-sources`) | runs counted as false fires by the letter, then judged by hand | derive each case's allowed set from the rules all arms share |
| 12 | Reduced test ran the unreviewed starting wording, then the wording changed | S15 and S5 rerun on B (6 runs) | `CONTRIBUTING.md` order: `write-prompt` pass and review before any scored run |

## Scoring and records

| # | Error | Effect | Prevention |
|---|---|---|---|
| 13 | Scorer took "first write" as the first Edit or Write; agents also write with Bash heredocs and `sed -i` | first-write positions wrong in the first read of the results | scorer detects Bash writes (`summarize.py`); one scorer, committed, used for every table |
| 14 | Transcripts kept only in the session scratchpad; an earlier failed S15 batch overwritten | results not rerunnable from the repo until `runs-2026-11-08.jsonl` was added | persist a per-run summary (skills, first write, cost, denials) with each batch; never reuse a run dir |
| 15 | Results doc edited by ad hoc scripts: one replace dropped the `## Cost` heading, one insert matched nothing and a commit said a plan was recorded when it was not | a stale doc and a false claim to the owner | assert each anchor matched; reread the section after writing |

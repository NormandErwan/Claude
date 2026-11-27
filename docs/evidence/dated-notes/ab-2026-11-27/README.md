# Dated-notes cases on `plugin eval`, 2026-11-27

Miss rate of the `Behavior` dated-names rule on the current `CLAUDE.md`, for `BACKLOG.md`
task `dated-names-on-handoffs`.

## Setup

- Cases: `../make-cases.sh` (the 8 cases of `../prompts.tsv`, same fixture and setup as `../run.sh`).
- Arm `current`: `CLAUDE.md` at `21153f3` (rule text as reworded on 2026-11-22, `7895fb3`), skills
  from that commit's `templates/hooks/install-skills.sh` (44). `test-rule-change.py preflight` green;
  P3 pilot $0.15.
- Claude Code 2.1.332, `claude-sonnet-5-5`, 3 runs per case, `--ablation none`, tools Read, Write,
  Edit, Glob, Grep, Skill, Bash (sandboxed), `-j 3`.

## Results

Every grader verdict checked by hand against the files each run wrote (`current.runs.jsonl`,
Write calls and Bash heredocs): all 24 agree.

| Case | Expect | Pass | Files written |
|---|---|---|---|
| P1 research note | dated | 3/3 | `docs/2026-11-27-rate-limiting-flask.md` |
| P2 load-test report | dated | 3/3 | `docs/2026-11-27-rapport-test-de-charge.md` and close variants |
| P3 handoff | dated | 3/3 | `$TMPDIR/claude-0/2026-11-27-handoff-cache-paniers-redis.md` |
| N1 numbered postmortems | `003-` | 3/3 | `docs/postmortems/003-redis-memory-saturation.md` |
| N2 install guide | undated | 3/3 | `docs/installation.md` |
| N3 ADR | numbered, undated | 3/3 (0/3 as run on `0001-`) | `docs/decisions/001-...md`, `ADR-001-...md` (x2) |
| N4 note beside undated notes | dated | 3/3 | `docs/notes/2026-11-27-reunion-...md` |
| D1 name set by `docs/README.md` | `cart-load-test.md` | 3/3 | `docs/reports/cart-load-test.md` |

- N3 is not a miss of the rule: every ADR is numbered and undated, as the rule asks. `0001-` was
  `domain-modeling`'s convention; current `skills.txt` no longer installs it, and
  `documentation-and-adrs` numbers `001-`. Expectation changed after the run, in `make-cases.sh`
  and `grade.py`, to any `NNN-`/`NNNN-`/`ADR-NNN-` name with no date; the 3 runs re-graded by hand.
- P3 and N4 pass 6/6 here, against 0/4 under `claude -p` on 2026-11-22 (same wording, Sonnet 5.5).
  Unexplained: hook-injected `CLAUDE.md` framing, the Claude Code version, or the absence of the
  cloud session's scratchpad in `plugin eval` runs (the 2026-11-22 P3 handoff went to the scratchpad
  undated) are all possible.

Cost: $3.77 for 24 runs, plus $0.30 of pilots.

## Same-day `claude -p` rerun of P3 and N4

`../run.sh` on `setup.sh HEAD` (same `CLAUDE.md`, real file + SessionStart hook), Claude Code
2.1.332, Sonnet 5.5, 3 runs each, graded by `../grade.py` (`../grades-2026-11-27-claude-p.jsonl`).

| Case | `plugin eval` | `claude -p` | `claude -p` files |
|---|---|---|---|
| P3 | 3/3 | 0/3 | `$TMPDIR/.../scratchpad/handoff-redis-cart-cache.md` (x3) |
| N4 | 3/3 | 0/3 | `docs/notes/reunion-2026-11-27.md` (x3) |

- Same day, version, model and rule text: 6/6 vs 0/6 is a harness gap, not a change since
  2026-11-22 (which also gave 0/4 under `claude -p`).
- The `claude -p` child runs in this cloud session's mode: its system prompt lists a scratchpad,
  and P3 saved there and sent the file (`SendUserFile`), as the `handoff` skill asks for a cloud
  session. The `plugin eval` child had no scratchpad and saved to `$TMPDIR/claude-0/`. Which
  difference flips the name (that system prompt, or the hook-injected `CLAUDE.md`) is not isolated.
- N4 under `claude -p` dates the note, as a suffix: each reply says it dated the file. The rule's
  `YYYY-MM-DD-<slug>.md` prefix is the part missed.

Cost: $0.59.

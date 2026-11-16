# A/B harness calibration, 2026-11-16

Checks that casebook `test-rule-change`'s scripts (`claude plugin eval`, each arm's `CLAUDE.md`
printed by a plugin `SessionStart` hook) reproduce a known `claude -p` result:
`docs/research/2026-11-15-backlog-haiku-trigger.md` (2.0.0 fired 20/30, casebook 0.1.1 23/30).

## Setup

- Cases: `make-cases.sh` writes the 15 cases of `docs/research/2026-11-07-backlog-skill-trigger-test.md`
  (F1-F10 should fire, N1-N5 should not) with one `fired` grader. On N cases the grader has
  `max: 0`, so a pass there means "did not fire".
- Arms: `CLAUDE.md` at `336ef9f`; skills from `templates/hooks/install-skills.sh` (current
  `skills.txt`); `backlog-200` adds `skills/backlog` at `336ef9f`; `backlog-cb` keeps casebook
  `backlog` 0.1.1. `diff-arms.sh`: arms differ only in `skills/backlog`.
- Claude Code 2.1.325, `claude-haiku-5-5`, 3 runs per case, tools Read, Write, Edit, Glob, Grep,
  Skill. No Bash: `bwrap` and `socat` are not installable in this container, so `plugin eval`
  refuses Bash. The reference runs allowed `git`/`ls`/`cat`.

## Results

| Arm | Should fire, hook-injected | Should fire, `claude -p` reference | False fires |
|---|---|---|---|
| 2.0.0 (`calibration-b200.json`) | 18/30 | 20/30 | 0/15 |
| 2.0.0 (`backlog-200.json`) | 19/30 | 20/30 | 0/15 |
| casebook 0.1.1 (`backlog-cb.json`) | 17/30 | 23/30 | 0/15 |

Per case: `2026-11-16-compare.md` (written by `compare.py`). Misses fall on the same cases as the
reference (F1, F2, F3, F6). 2.0.0 reproduces; 0.1.1 lands 6 runs lower, unexplained (framing,
no Bash, or noise at 3 runs). Both methods find no clear gap between the two versions.
Cost: $0.21 (calibration) + $0.42 (A/B) + about $0.03 of pilots.

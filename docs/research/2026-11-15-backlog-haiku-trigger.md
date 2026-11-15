# backlog skill: Haiku trigger, 2.0.0 vs casebook 0.1.1

Date: 2026-11-15. Follows `2026-11-07-backlog-skill-trigger-test.md` (Haiku 5/10) and the
BACKLOG.md task "Make the backlog trigger reliable on Haiku". Arms: this repo's
`skills/backlog` 2.0.0 (`336ef9f`) and NormandErwan/claude-casebook `plugins/backlog` 0.1.1,
whose description names the user's deferral words. Total cost $0.55.

## Method

- Same 15 prompts as the 2026-11-07 test (10 should-fire F, 5 should-not N), same seeded/unseeded
  split. Fixture rebuilt: `app.py` (`load_config`, `apply_discount(price, pct)`, `total`), a
  `README.md` with "Tiny", seeded `BACKLOG.md` with the same two task titles in the current
  format, no `## Conventions` block.
- `.claude/` holds this repo's `CLAUDE.md` and the `skills.txt` skills installed by
  `templates/hooks/install-skills.sh` (backlog left out: not yet on casebook's default branch),
  plus the arm's `skills/backlog/SKILL.md`.
- Each run: fresh copy, empty `CLAUDE_CONFIG_DIR`, headless `claude -p` (Claude Code 2.1.325),
  `--model claude-haiku-5-5`, `--permission-mode acceptEdits`, tools Read, Write, Edit, Glob,
  Grep, Skill, `git`/`ls`/`cat` in Bash. 3 runs per case and arm.
- Fired = a `Skill` call for `backlog` in the transcript.

## Results

| Case | 2.0.0 | 0.1.1 |
|---|---|---|
| F1 (deferred beside a docstring) | 1/3 | 2/3 |
| F2 (README "out of scope" beside a rename) | 0/3 | 0/3 |
| F3 (plan, later steps in later sessions) | 0/3 | 1/3 |
| F4, F5, F7, F8, F9, F10 | 18/18 | 18/18 |
| F6 (task reported done) | 1/3 | 2/3 |
| N1-N5 false fires | 0/15 | 0/15 |
| **Should fire** | **20/30** | **23/30** |

## Findings

- 0.1.1 fires on 23/30 (7.7/10) against 20/30 for 2.0.0. The gap (3 runs) is within the noise of
  3 runs per case: the new description helps at most a little on Haiku. The task's 8/10 is not
  reached.
- Misses stay on work mentioned beside a main request (F1, F2, F3) and on a task reported done
  (F6). On F2, Haiku answers "README untouched, as you asked": it reads "out of scope" as a scope
  limit, not as work to record. On F3 and F6, the reply acknowledges the deferral or the done task
  without calling the skill.
- Limits: 3 runs per case; F2's prompt does not ask to record anything, so it may be a weak
  should-fire case.

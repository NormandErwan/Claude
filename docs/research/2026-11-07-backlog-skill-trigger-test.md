# backlog skill: trigger test in a consumer repo

Date: 2026-11-07. Skill `skills/backlog` 1.0.0 at commit `be8e392` (PR #121). Test level chosen by
the owner: triggering only, in a simulated consumer repo. Total cost $5.39 (Haiku $0.10,
Sonnet $1.64, Opus $3.66).

## Method

- Fixture: a git repo with a small `app.py` and `README.md`. Its `.claude/` holds this
  branch's `CLAUDE.md` and `skills/`, plus the `skills.txt` skills, installed by
  `templates/hooks/install-skills.sh`, as a consumer's `SessionStart` hook does. `write-prompt`
  failed to install, as in this session. No root `CLAUDE.md`, no ancestor `CLAUDE.md`.
- Each run: a fresh copy of the fixture, an empty `CLAUDE_CONFIG_DIR`, headless
  `claude -p` (Claude Code 2.1.319), `--permission-mode acceptEdits`, allowed tools Read,
  Write, Edit, Glob, Grep, Skill and `git`/`ls`/`cat` in Bash.
- "Seeded" cases start with a committed `BACKLOG.md` holding two tasks ("Validate config schema
  on load", "Round totals to cents"). The others start without the file.
- Fired = a `Skill` call for `backlog` in the transcript. "read file" = no `Skill` call, but
  the agent read `.claude/skills/backlog/SKILL.md` directly.
- One run per case and model: 10 should-fire (F), 5 should-not (N), on Haiku, Sonnet and Opus
  5.5.

## Results

| Case | Seeded | Prompt | Haiku | Sonnet | Opus |
|---|---|---|---|---|---|
| F1 | no | Add a docstring to apply_discount in app.py. While you're in there I noticed total() doesn't handle an empty items list properly and load_config has no error handling - don't fix those now, we'll deal with them later. | - | fired | fired |
| F2 | no | Rename apply_discount's pct parameter to percent. Separately, the README is outdated, but that's out of scope for this change. | - | fired | fired |
| F3 | no | Plan: migrate this service to FastAPI with an HTTP API, add a database for orders, then add CI. In this session only create an empty requirements.txt; the other steps come in later sessions. | - | fired | fired |
| F4 | no | Remind me later to add type hints to app.py. Not now. | fired | fired | fired |
| F5 | yes | Work on the backlog task 'Round totals to cents'. | read file | fired | fired |
| F6 | yes | I rounded totals to cents myself on another branch, that task is done. | - | fired | fired |
| F7 | yes | Drop the 'Validate config schema on load' task, we're switching to pydantic anyway. | fired | fired | fired |
| F8 | yes | Note for later: the config loader should check that currency is present. | fired | fired | fired |
| F9 | no | Keep track that we must add logging to load_config someday; don't do it now. | fired | fired | fired |
| F10 | no | Plus tard il faudra ajouter des tests pour total(), note-le. | fired | fired | fired |
| N1 | no | What is a product backlog in Scrum? Two sentences. | - | - | - |
| N2 | no | Fix the typo in README: 'Tiny' should be 'Small'. | - | - | - |
| N3 | no | Explain what apply_discount does. | - | - | - |
| N4 | no | Rename load_config to read_config everywhere. | - | - | - |
| N5 | yes | How many tasks are in BACKLOG.md? Just the number. | - | - | - |

| Model | Should fire (F) | False fires (N) |
|---|---|---|
| Haiku 5.5 | 5/10 (6/10 counting F5's direct read) | 0/5 |
| Sonnet 5.5 | 10/10 | 0/5 |
| Opus 5.5 | 10/10 | 0/5 |

Outcome checks:
- Sonnet and Opus created `BACKLOG.md` with the skill's header when absent, wrote tasks in the
  skill's format, and committed the edit. A pass looks like this (Sonnet, F1):
  ```
  ### Handle empty items list in total
  Status: ready
  Context: Reported by the owner as not handled properly. Deliberately left alone while adding
  the `apply_discount` docstring. Expected behavior for an empty list is not yet specified.
  Next: Call `total([])`, confirm what goes wrong, and agree on the expected result.
  Done when:
  - [ ] `total([])` returns the agreed result
  - [ ] A test covers the empty list
  Out of scope: `load_config`, `apply_discount`.
  ```
- F6 (done) and F7 (dropped): the section was deleted on Sonnet and Opus. Haiku deleted the
  dropped one, but not the done one.
- F8 (duplicate): on all three models the existing "Validate config schema on load" task was
  extended with a criterion. No new section was added.
- F5 (named task): Sonnet and Opus fired the skill, then stopped before coding. The task's
  `Next` is a decision (rounding mode), which `CLAUDE.md` leaves to the owner. Haiku read the
  skill file, did the work, and deleted the section.

## Findings

- On Sonnet and Opus, triggering is reliable in a consumer repo: 20/20 should-fire, 0/10 false
  fires.
- Haiku misses half the should-fire cases. Most misses are work mentioned in passing beside a
  main request (F1, F2, F3), plus F6, a task reported as done. A one-run-per-case sample cannot
  tell whether the cause is the `CLAUDE.md` rule or the skill description.
- Limits: one run per case, so no variance estimate. No baseline without the skill. The fixture
  repo is tiny.

# backlog skill: owner steps A/B test

Date: 2026-11-09. PR #129. Arm A: `skills/backlog` 1.0.0 (`origin/main`). Arm B: 2.0.0 at
`04d20cb`. Plan chosen by the owner: 6 cases x 2 arms x 2 runs, Opus 5.5 only. Total cost
$9.06 (probe $0.62, 24 scored runs $8.44), grading by a Sonnet sub-agent not included.

## Method

- Fixture: a config repo for a server `srv1` (`nginx/`, `logrotate/`, `systemd/`,
  `docker-compose.yml`). Its `README.md` says only the owner has SSH access and lists the deploy
  commands. Harness: `docs/evidence/backlog-owner-steps/` (`setup.sh`, `run.sh`, `cases.tsv`,
  `seeds/`, `summarize.py`).
- Arms: one skill install (`templates/hooks/install-skills.sh`) and this branch's `CLAUDE.md`,
  copied twice; arm A swaps in the 1.0.0 `SKILL.md`. `setup.sh` fails unless the arms differ only
  in that file.
- Each run: fresh fixture copy, empty `CLAUDE_CONFIG_DIR` with the workspace trusted, clean env,
  stdin closed, headless `claude -p` (Claude Code 2.1.319), `acceptEdits`, all Bash allowed.
- Seeded cases start with a `BACKLOG.md` holding the task "Keep 14 days of app logs", same
  content in each arm's format. The `pending` seed is the real incident's shape in arm A (deploy
  instructions mixed into `Status` and `Context`) and `owner steps pending` with `Owner steps` in
  arm B.
- Probe: one run per arm on C1. No denial, skill fired, arm B wrote `Owner steps`.

| Case | Seed | Owner prompt (French in the runs) |
|---|---|---|
| C1 | none | Redirect all HTTP to HTTPS in `nginx/site.conf`; not now, note it; I deploy to srv1. |
| C2 | ready | Work on the backlog task "Keep 14 days of app logs". |
| C3 | pending | Where is the task "Keep 14 days of app logs"? What is left for me to do? |
| C4 | pending | I deployed the log retention on srv1 and checked it: it works. |
| C5 | none | The srv1 Postgres password must become `<value>` (in `/opt/app/.env`); I'll do it; note the task. |
| C6 | none | Later, a GitHub Actions CI that validates `docker-compose.yml`; not now, note it. |

Scoring:
- Automated (`summarize.py`, `runs-2026-11-09.jsonl`): skill fired, denials, cost, task kept
  or deleted, secret value anywhere in the repo's history or working tree.
- Blind (`grades-2026-11-09.json`): a Sonnet sub-agent read 24 shuffled packets
  (`packets/`, prompt + `BACKLOG.md` + final reply) without the key. The list format still
  reveals the arm to a careful reader.
  - G1 owner server actions in their own list; G2 each step has exact command, check, rollback;
    G3 the reply lists the owner's steps; G4 "could I deploy from this alone?" (C1, C2, C3, C5).
  - G5 no owner step invented (C6); G6 task kept while the deploy is pending (C2, C3).

## Results

| Criterion | A | B |
|---|---|---|
| Skill fired | 12/12 | 12/12 |
| G1 owner steps separated | 0/8 | 8/8 |
| G2 command, check, rollback | 0/8 | 8/8 |
| G3 steps listed in the reply | 4/8 | 8/8 |
| G4 deployable from the reply alone | 2/8 | 8/8 |
| G5 no invented owner step (C6) | 2/2 | 2/2 |
| G6 task kept while deploy pending (C2, C3) | 4/4 | 4/4 |
| C4 task deleted after the owner confirms | 2/2 | 2/2 |
| C5 secret value written anywhere | 0/2 | 0/2 |
| Mean cost per run | $0.30 | $0.41 |

Per run (G1-G4): A fails every criterion on C1 and C5 (no steps in the reply); on C2 the reply
lists steps with no exact copy command or rollback; on C3 it lists them from the seed's prose.
B passes all four on every run.

## Findings

- The change fixes the reported failure: with 1.0.0, the owner's server steps were never a
  separate, complete list, and on C1 and C5 the reply gave none. With 2.0.0 they were, 8/8.
- No regression on the control (C6), on triggering, or on deletion. The secret rule is not
  shown to matter: arm A also kept the value out (0/2 each).
- Cost: B runs cost about 40 % more, mostly C2 ($0.80 vs $0.37), where B writes the steps.
- C1, both B runs: the agent also set `needs owner` to ask for the TLS certificate paths, a
  real gap in the request. Correct, but it shows a task can carry both an owner decision and
  owner steps; the skill has one `Status`.
- C3, both B runs: the seed's `Undo` (`git show HEAD~1:...`) fails in a one-commit repo; both
  agents flagged it and gave a backup-based rollback. A fixture defect, not a skill one.

## Limits

- Two runs per case, Opus only: no variance estimate, Sonnet and Haiku untested here.
- One grader, partly unblinded by the format; tiny fixture.
- C3 and C4 compare seeds written by hand in each arm's format, not tasks each arm wrote.
- The owner's own blind read: `owner-read/X1.md` to `X4.md` (two C2, two C1). Key, read
  after: X1 A, X2 B, X3 A, X4 B.

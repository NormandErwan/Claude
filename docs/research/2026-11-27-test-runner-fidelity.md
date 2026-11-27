# Test runner fidelity: which runner behaves like a real session

For `BACKLOG.md` task `plugin-eval-fidelity-gap`. Evidence:
`docs/evidence/dated-notes/ab-2026-11-27/README.md` (PR#154).

## Summary

On the two dated-notes cases where the `Behavior` dated-names rule had "failed" (P3 handoff, N4 note
beside undated notes), real cloud sessions and `claude plugin eval` pass, and headless `claude -p`
fails. Same day, Claude Code 2.1.332, `claude-sonnet-5-5`, same `CLAUDE.md` text, and for four of
the real sessions the exact `claude -p` workspace:

| Runner | P3 | N4 |
|---|---|---|
| Real cloud session (`create_session`), this repo | 2/2 | 2/2 |
| Real cloud session, orphan branch = `claude -p` workspace | 2/2 | 2/2 |
| `claude plugin eval` (`test-rule-change.py`) | 3/3 | 3/3 |
| `claude -p` (`docs/evidence/dated-notes/run.sh`) | 0/3 | 0/3 |

`claude -p` was treated as the faithful stand-in for a real session and as the reference other
runners were calibrated against; it was never checked against real sessions. Two cases are not
enough to rank the runners in general, but they are enough to stop treating `claude -p` as the
reference without a check.

## The four runners

| | Real session | `claude -p` (`run.sh`) | `plugin eval` |
|---|---|---|---|
| Launch | `create_session` (same environment as the owner's sessions) | child process of this container | child process, isolated home, config and env |
| Workspace | a pushed branch, cloned | local fixture copy, one `init` commit | empty dir seeded by a scaffold, one `init` commit |
| `CLAUDE.md` | real file (root or `.claude/`) | real file in `.claude/CLAUDE.md` | text printed by a plugin `SessionStart` hook |
| Skills | repo's `SessionStart` hook | same hook, installer outside the workspace | plugin skills, `<arm>:<skill>` |
| System prompt | cloud session (scratchpad, `SendUserFile`) | inherits the cloud session's (scratchpad seen) | no scratchpad |
| Grading | by hand from `list_events` | `grade.py` | graders in each case |
| Cost per run here | $0.19-0.27 | $0.07-0.12 | $0.12-0.22 |

`claude -p` differences not yet tested one by one: `-p` itself, a fresh `CLAUDE_CONFIG_DIR`, unset
session variables (`CLAUDECODE`, session ids, additional dirs), `--allowedTools` and
`--permission-mode acceptEdits`. Not the cause here: a global `~/.claude/CLAUDE.md` (none in this
container), the one `CLAUDE_CONFIG_DIR` leak reported upstream
(https://github.com/anthropics/claude-code/issues/30230).

## What rested on `claude -p` as the reference

- `CONTRIBUTING.md` Testing step 2: `claude -p` fallback "testing how a real `CLAUDE.md` is framed".
- casebook `test-rule-change` `SKILL.md`: "Testing the framing of a real `CLAUDE.md` itself needs
  headless `claude -p` instead"; its 2026-11-16 calibration took `claude -p` as the reference
  (`docs/evidence/ab-harness-calibration/`).
- casebook `write-skill` `evaluating-skills-with-subagents.md`: arms run with headless `claude -p`.
- `RETROSPECTIVE.md` test-run rows run under `claude -p` (2026-10-10 to 2026-11-22), and the
  2026-11-22 rerun that reopened the dated-names rule (`PROVENANCE.md` dated-names row).

## Real sessions as a runner: costs and traps

- No automatic grading; a pushed branch per workspace; sessions pile up in the owner's list until
  archived.
- Sessions act like real ones: they commit and push to the branch, ask for a PR base, and stall on
  the idle-timer permission prompt when the repo's hooks arm one (the orphan branches, with only the
  skills hook, did not).
- This session cannot delete the branches it pushes (proxy refuses with HTTP 403): the owner does.
- The prompt arrives flagged `text_not_typed` (origin `mcp_create_session`); sessions treated it as
  the request.
- A worker restart dropped three of four `create_session` calls: check `list_sessions` before
  relaunching, so no duplicate starts.

## Open questions

1. Which `run.sh` difference makes `claude -p` miss P3 and N4.
2. Whether `plugin eval` matches real sessions beyond these two cases (the drift A/B, 10/10, rests
   on it).
3. Whether the owner's claude.ai preferences reach sessions started with `create_session`.

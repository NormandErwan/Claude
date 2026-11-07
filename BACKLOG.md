# Backlog

Work not done yet. One task = one `###` section under `## Tasks`, written as a short handoff: a
fresh session can start from it alone. A repo without this file gets a copy of everything above
`## Tasks`, from https://raw.githubusercontent.com/NormandErwan/Claude/main/BACKLOG.md.

## Rules

- Add a task -> work deferred, discovered mid-session, or beyond the session's scope. Not for a
  question or an edit done now.
- Before adding -> search this file; a matching task gets extended, not duplicated.
- Title -> imperative, unique: it is the task's key.
- Size -> one task fits one PR. Larger -> several tasks linked by `Blocked by`.
- Content -> behavior and decisions, not file paths or line numbers (they go stale). Link
  artifacts (PR, doc, `RETROSPECTIVE.md` row) instead of copying them. No implementation plan:
  the session doing the work writes it.
- No task named -> take the first `ready` one, top to bottom, whose `Blocked by` tasks are gone.
- Start a task -> set `Status: in progress (<branch>)`.
- Task done -> delete its section in the PR that does the work; the PR body carries the summary.
- Task dropped -> delete its section; the commit message gives the reason.
- Any edit here -> commit it with the session's work: an uncommitted edit dies with a cloud
  container.

## Format

```
### <Imperative title>
Status: ready | in progress (<branch>) | blocked: <reason> | needs owner: <decision>
Blocked by: <task title>                 (omit when none)
Context: why, what is settled, links. 2-4 lines.
Next: the first concrete step.
Done when:
- [ ] <testable criterion>
Out of scope: <what not to touch>        (omit when none)
```

## Tasks

### Process proposed RETROSPECTIVE.md entries
Status: ready
Context: 24 entries are `proposed`, among them the 2026-11-07 rows on task granularity, subtask
scope, interview before a plan, and the switch from Backlog.md to this file. `CONTRIBUTING.md`
(RETROSPECTIVE.md section) governs processing.
Next: read the whole ledger, group `proposed` entries by class.
Done when:
- [ ] every `proposed` entry is accepted, rejected, or marked `not checkable here`
- [ ] every accepted entry has a task here or a PR
Out of scope: rule rewrites not tied to an entry.

### Define the framing, breakdown and planning method
Status: blocked: wait until this file has been used for a few weeks
Context: how to frame, split and plan work with the agent before building: `interview-me`
(framing), `spec-driven-development` (requirements), `planning-and-task-breakdown` (tasks here).
mattpocock `to-tickets` adds vertical slices, blocking edges, and asking the owner whether the
granularity fits before filing. Related `RETROSPECTIVE.md` rows: 2026-11-07, interview before a
plan, task granularity, subtask scope.
Next: list the tasks that turned out too big, too small or badly framed.
Done when:
- [ ] method written in `CLAUDE.md` or a skill, with its `PROVENANCE.md` row

---
name: backlog
version: 1.0.0
description: Use when work is deferred, discovered mid-session, or beyond the session's scope (e.g. a plan's large steps), or when a task in the repo's BACKLOG.md is named, started, finished or dropped.
---

# Backlog

The backlog is the repo's root `BACKLOG.md`: work not done yet, one section per task, each a
short handoff a fresh session can start from alone.

## Add a task

- Trigger: work deferred, discovered mid-session, or beyond the session's scope. Not for a
  question, or an edit done now.
- Add it without asking first. Reply with one line: its title.
- Search the file first. A matching task gets extended, not duplicated.
- No `BACKLOG.md` -> create it with this header, then the task:
  ```
  # Backlog

  Work not done yet, one `###` section per task. Format and rules: the `backlog` skill.

  ## Tasks
  ```
- One task fits one PR. Larger work -> several tasks linked by `Blocked by`.

## Format

```
### <Imperative title>
Status: ready | in progress (<branch>) | blocked: <reason> | needs owner: <decision>
Blocked by: <task title>                 (omit when none)
Context: <why, what is settled, links: 2-4 lines>
Next: <first concrete step>
Done when:
- [ ] <testable criterion>
Out of scope: <what not to touch>        (omit when none)
```

- Title: imperative, unique in the file. It is the task's key: no number, ids collide across
  sessions.
- `Status`:
  - `ready`: can start now.
  - `in progress (<branch>)`: a session works on it on that branch.
  - `blocked: <reason>`: waits on something outside the backlog (time, access, an event).
  - `needs owner: <decision>`: waits on a decision only the owner can make.
- `Blocked by`: titles of the tasks that must be done first. Omit when none. A title no longer
  in the file means that task is done.
- `Context`: 2-4 lines. Why the task exists and what is already decided. Link artifacts (PR,
  doc, `RETROSPECTIVE.md` row) instead of copying them.
- `Next`: the first concrete step. No implementation plan: the session doing the work writes it.
- `Done when`: testable criteria, each checkable on its own. "Works correctly" is not one.
- `Out of scope`: what the task must not touch. Omit when none.
- Whole section: behavior and decisions, not file paths or line numbers (they go stale).

## Work a task

- Start -> set `Status: in progress (<branch>)`.
- Done -> delete its section in the PR that does the work. The PR body carries the summary.
- Dropped -> delete its section. The commit message gives the reason.
- Any edit to `BACKLOG.md` -> commit it with the session's work: an uncommitted edit dies with
  a cloud container.

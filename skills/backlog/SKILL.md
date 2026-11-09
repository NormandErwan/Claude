---
name: backlog
version: 2.0.0
description: Use when work is deferred, discovered mid-session, or beyond the session's scope (e.g. a plan's large steps), or when a task in the repo's BACKLOG.md is named, started, finished or dropped.
---

# Backlog

The backlog is the repo's root `BACKLOG.md`: work not done yet, one section per task, each a
short handoff a fresh session can start from alone.

## Add a task

- Not for: a question, or an edit done in this session.
- Add it without asking first. Reply with one line: its title. Task has `Owner steps` -> the
  reply also gives them, numbered, as written in the task.
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
- **Status:** ready | in progress (<branch>) | blocked: <reason> | needs owner: <decision> | owner steps pending
- **Blocked by:** <task title>                 (omit when none)
- **Context:** <why, what is settled, links: 2-4 lines>
- **Next:** <first concrete step>
- **Done when:**
  - [ ] <testable criterion>
- **Owner steps:** <when: after merge, before merge...>   (omit when none)
  1. <action>: `<exact command>`
     - Check: <what the owner sees when it worked>
     - Undo: <how to roll back, or "nothing to undo">
- **Out of scope:** <what not to touch>        (omit when none)
```

- Title: imperative, unique in the file. It is the task's key: no number, ids collide across
  sessions.
- `Status`:
  - `ready`: can start now.
  - `in progress (<branch>)`: a session works on it on that branch.
  - `blocked: <reason>`: waits on something outside the backlog (time, access, an event).
  - `needs owner: <decision>`: waits on a decision only the owner can make.
  - `owner steps pending`: the agent's part is merged; waits on the owner running `Owner steps`.
- `Blocked by`: titles of the tasks that must be done first. A title no longer in the file
  means that task is done or dropped.
- `Context`: 2-4 lines. Why the task exists and what is already decided. Link artifacts (PR,
  doc, `RETROSPECTIVE.md` row) instead of copying them.
- `Next`: the agent's first concrete step. No implementation plan: the session doing the work
  writes it.
- `Done when`: testable criteria, each checkable on its own. "Works correctly" is not one.
- `Owner steps`: actions only the owner can do (access the agent lacks: a server, a secret, an
  account, a device). Ordered; each one runs as written, with its exact command or click path,
  paths and values, no placeholder left to fill. Each has a `Check` and an `Undo`. Agent steps
  never go here; owner steps never go in `Next` or `Context`.
- `Out of scope`: what the task must not touch.
- Paths are fine. Line numbers are not (they go stale): name a symbol (function, config key)
  instead. Links to PRs and docs are fine.

## Work a task

- Task named -> read its section, start from `Next`, respect `Out of scope`. A `Blocked by`
  title still in the file -> tell the user, don't start.
- Start -> set `Status: in progress (<branch>)`.
- Session ends unfinished -> rewrite `Next` to where the work stopped. Stuck -> set `Status` to
  `blocked` or `needs owner`.
- Agent's part done, `Owner steps` left -> in the PR that does the work, set
  `Status: owner steps pending` and tick the criteria the agent could check. End the reply with
  the `Owner steps`, numbered, as written in the task.
- Owner confirms the `Owner steps` worked -> delete the section.
- Done -> delete its section in the PR that does the work. The PR body carries the summary.
- Dropped -> delete its section. The commit message gives the reason. Tasks it blocked -> re-check
  their `Status`.
- Title changed -> update every `Blocked by` that names it.
- Any edit to `BACKLOG.md` -> commit it with the session's work: an uncommitted edit dies with
  a cloud container.

## Red flags

- Asking "add this to the backlog?" -> add it, reply with its title.
- Ticking every box, or moving a done task to a "Done" list -> delete the section.
- Adding an id or a number to a title.
- `BACKLOG.md` edited but not committed.
- An owner action written in `Next` or `Context`, or an `Owner steps` item without its exact
  command, `Check` or `Undo`.
- Deleting a task whose `Owner steps` the owner has not confirmed.
- A task with `Owner steps` filed or handed over, and the reply does not list them.

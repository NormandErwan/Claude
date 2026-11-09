---
name: backlog
version: 1.1.0
description: Use when work is deferred, discovered mid-session, or beyond the session's scope (e.g. a plan's large steps), or when a task in the repo's BACKLOG.md is named, started, finished or dropped.
---

# Backlog

The backlog is the repo's root `BACKLOG.md`: work not done yet, one section per task, each a
short handoff a fresh session can start from alone.

## Add a task

- Not for: a question, or an edit done in this session.
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
Owner: <numbered steps only the owner can do>   (omit when none)
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
- `Blocked by`: titles of the tasks that must be done first. A title no longer in the file
  means that task is done or dropped.
- `Owner`: a step needs the owner when it needs their access (server shell, git-crypt unlocked
  clone, password vault, third-party account, hardware, phone) or their decision. Each such
  step goes here, never in `Context` or `Next`, numbered, with:
  - where to run it: machine, directory or web page;
  - the exact command or click path;
  - what to report back, or what proves it worked.

  A decision step names the options and your recommendation. `Owner` is exempt from the
  `Next` and no-code-path rules: the owner follows it without re-deriving anything.
- `Context`: 2-4 lines. Why the task exists and what is already decided. Link artifacts (PR,
  doc, `RETROSPECTIVE.md` row) instead of copying them.
- `Next`: the first concrete step. No implementation plan: the session doing the work writes it.
  The owner must act first -> `Status: needs owner: <...>`, and `Next` says what you do once
  they report back.
- `Done when`: testable criteria, each checkable on its own. "Works correctly" is not one.
- `Out of scope`: what the task must not touch.
- Whole section except `Owner`: behavior and decisions, not code paths or line numbers (they
  go stale). Links to PRs and docs are fine.

## Work a task

- Task named -> read its section, start from `Next`, respect `Out of scope`. A `Blocked by`
  title still in the file -> tell the user, don't start.
- Owner step done (the owner reports it, or you verified it) -> delete it from `Owner`.
- Start -> set `Status: in progress (<branch>)`.
- Session ends unfinished -> rewrite `Next` to where the work stopped. Stuck -> set `Status` to
  `blocked` or `needs owner`.
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
- An owner action in `Context` or `Next`, or phrased vaguely ("owner checks X") -> move it to
  `Owner` with its location and exact command or click path.
- `BACKLOG.md` edited but not committed.

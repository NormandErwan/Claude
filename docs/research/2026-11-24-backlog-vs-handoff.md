# What a backlog task loses against a handoff

Backlog task "Check what a backlog task loses against a handoff". Compares the handoffs written so far
with the `BACKLOG.md` tasks covering the same work, to find what one carries that the other lacks.

## Sample

Handoffs are never tracked (`handoff` 1.4.0), so they were recovered from session transcripts
(`list_events`) on 2026-11-24. Four found; transcripts before 2026-11-22 were only partly scanned.

| Handoff | Session | Task covering the same work |
|---|---|---|
| `write-prompt` option B, then merge | `session_01RGXu8ZRXiP4N4yyUBRHnhB`, 2026-11-02 | none (pre-backlog) |
| Idle-handoff design | `session_01RGXu8ZUPcUnTDd9u4QfKPL`, 2026-11-23 | "Build the idle-handoff reminder hook for cloud sessions" (closed in `154f57b`) |
| Idle-handoff build, written by the idle timer | `session_01RGXu8X6b8MiE14MPv1G5sV`, 2026-11-23 | same task |
| Owner-opinion rule after the A/B | `session_01RGXu8XvDKrWALLQRun5A8X`, 2026-11-23 | "Keep the evidence-based recommendation when the owner states an opinion without a reason" |

Three of the four texts were transcribed by a subagent rather than extracted byte for byte; the
examples below are checked against the repository where they cite it.

## Gaps: what the handoff carried and the task did not

### G1. Task state that lives on an unmerged branch

The owner-opinion handoff says: A/B done, the rule kept option 3 0/5, status `needs owner`, three
next approaches with a recommendation. All of it is on PR #140 (`claude/new-session-yionc2`, open,
unmerged since 2026-11-23). On `main` the task still reads `Status: ready` with `Next: draft the rule
[...] then A/B`, and every box unticked. A session that starts the task from `main` reruns an A/B
already done. The `backlog` skill's "Start -> set Status: in progress (<branch>)" and "Session ends
unfinished -> rewrite Next" both land on the work branch, so `main` never shows them.

### G2. Approaches tried and rejected

- `write-prompt` handoff: "'Exact content stays exact' bullet: do not restore it" (0/3 with and
  without); "Rewording the rubric only reached 1/3".
- Idle-handoff build handoff: timers chained with `send_later`, never moved, "because
  `update_trigger` asks the owner for approval".

The format has no place for these. Tasks carry some in `Context` when the writer thinks of it (drift
task: "B1/B2 wording did not fix it"), nothing prompts it.

### G3. Origin pointers: session, turn, commit

Handoffs name the commit at handoff (`c8e39e8`, `5debaf9`) and the date and time. The drift task said
"that session" with no id, turn or commit; recovering them took a subagent over the transcript
(`08dd3e1`). `Context` says "link artifacts" but not that a session or a state is one.

### G4. Operational know-how

Commands, environment gotchas and runner setup: re-clone casebook with `GIT_LFS_SKIP_SMUDGE=1`,
`--max-cost-usd 1000` because `run` refuses no cap, copy traces before `run` deletes them, `rsync`
missing, the environment `Stop` hook. Where a task carries them, `Next` swells into a runbook: the
owner-opinion task's `Next` holds runner, scaffold commit, budget leak check and cost per run, against
the skill's "No implementation plan".

### G5. Owner decisions made during the session

Owner-opinion handoff: "separate bullet, not an extension of the drift rule; plan (a) run counts; no
cost cap; a hidden time limit; exactly one pilot". None reached the task, even on PR #140's branch:
the skill rewrites only `Next` when a session ends unfinished, while `Context` is where "what is
settled" goes.

## Not gaps

- Pending owner decision with options and recommendation: a task already holds them in `Context`
  when written that way (the closed "Decide whether handoffs go in docs/handoffs/" task, `26afa86`).
- Spend not yet recorded, merge order across repositories, safety-net check-in times: valid for
  a resume soon after, stale within days. They belong in the handoff, the PR body or the ledger.
- Suggested skills: the next session's routing finds them from the task's wording.

## What tasks carry that handoffs lack

Testable `Done when` criteria, `Out of scope`, a status other sessions can read, and durability.
The three handoffs with a matching task named it and pointed to its `Next`, as `handoff` 1.4.0 asks.

## Proposed changes to the `backlog` skill

Each is a skill change, so it goes through casebook's `test-rule-change` before landing.

| Gap | Change |
|---|---|
| G1 | `Work a task`: task named -> look for an open PR that edits it (same title, or `BACKLOG.md` in its diff) and read the task there before starting |
| G2 | Optional field `Ruled out:` <approach -> result, link> (omit when none) |
| G3 | `Context`: a session counts as an artifact (its id), a state as one (its commit) |
| G4 | Commands and environment gotchas go in a repo doc linked from `Context`; `Next` stays one step |
| G5 | `Session ends unfinished` -> also add owner decisions made this session to `Context` |

## Owner decision, 2026-11-24

- G1 dropped: branches merge soon, and restarting a task from `main` is the owner's call.
- No per-task files (duplication), no committed handoffs (a handoff resumes work, a task describes
  new work). G4: no change, the skill already says "No implementation plan".
- Option A kept for G2, G3, G5, with the `Context` limit loosened from "2-4 lines" to "short".
  Filed as casebook task "Carry ruled-out approaches, origins and owner decisions in backlog tasks".

### Before / after, owner-opinion task as on PR #140's branch

Before: `Status` says the owner must pick a next approach, but the approaches are only in the
handoff; the owner's run constraints and the A/B's session and commit are nowhere in the task.

After:

```markdown
- **Context:** [...] A/B 2026-11-23 in `session_01RGXu8XvDKrWALLQRun5A8X`, commit `7273896`.
  Owner, 2026-11-23: a separate bullet, not an extension of the drift rule; one pilot before scored
  runs; no cost cap visible to the agent. Always-on: A/B mandatory (`CONTRIBUTING.md`).
- **Next:** owner picks: (1) a subagent that never sees the opinion compares the options, the main
  agent relays it and asks the reason (recommended, ~$6-8); (2) keep the rule for the reason-asking
  alone; (3) drop the task.
- **Ruled out:**
  - Critique request or objection shown first, in the prompt -> option 3 kept 0/3 (2026-11-22 test-run row)
  - Rule "recommend what you would have recommended without that opinion" -> option 3 kept 0/5, reason
    asked 5/5 (`docs/evidence/opinion-probe/ab-2026-11-23/compare.md`)
  - Haiku LLM grader alone -> 5 false passes; hand-read every reply (same file)
```

Skill edits: `Ruled out:` field after `Next` (omit when none); `Context` links a session by its id
and a state by its commit; "Session ends unfinished" also fills `Ruled out` and adds the owner's
decisions to `Context`.

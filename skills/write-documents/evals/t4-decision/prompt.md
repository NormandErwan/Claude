---
description: "Target criterion: decision-context (spec rule `decision-context`). Completeness checklist: graders/completeness-*.md."
model: opus
runs: 2
max_turns: 10
timeout_seconds: 600
allowed_tools: [Read, Write, Skill]
---

I need you to write the message that asks Dana, the repository owner, to decide what to do with a backlog task. Write it to `outputs/decision.md`; I'll paste it into the issue.

The task, as it stands in `BACKLOG.md`:

```
### rerun-baseline-8of8: Re-run the 8/8 baseline on the old CLAUDE.md
- Status: ready
- Context: the dated-notes test scored 8/8 on the old CLAUDE.md (commit 4e1a9c0). Reproduce it.
- Next: check out 4e1a9c0, run tests/dated-notes with the headless runner, 6 runs.
- Done when: the headless runner scores 8/8 again on 4e1a9c0.
```

Notes I collected, in no particular order:
- The other runner, `claude plugin eval`, agreed with real sessions on that workspace (0/6), but on a single workspace only.
- The rule currently in force is the rewritten one.
- The 8/8 was measured with the headless runner (`claude -p`) in a temporary folder. Nobody had checked that runner against real sessions.
- Only Dana can start real cloud sessions, from the web UI at claude.ai/code; each takes Dana about 2 minutes to start and 1 minute to paste the result back. The session must use the `dated-notes-fixture` environment and the prompt in `tests/dated-notes/prompt.txt`.
- The task exists because the dated-notes rule (name a one-off document `YYYY-MM-DD-<slug>.md`) was rewritten on 2026-10-30. The new wording scored 0/6 in real cloud sessions, and someone wanted to prove the old wording still worked before choosing between the two.
- A 6-run batch with either runner takes about 40 minutes of session time.
- On 2026-11-27, real cloud sessions and the headless runner disagreed on the same workspace: headless 8/8, real sessions 0/6.
- Restoring the old wording without measuring it is also possible.

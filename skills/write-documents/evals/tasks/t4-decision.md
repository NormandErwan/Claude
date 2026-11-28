I need you to write the message that asks Dana, the repository owner, to decide what to do with a backlog task. Write it in English to `outputs/decision.md`; I'll paste it into the issue. Dana last looked at this task six weeks ago and has worked on other things since.

The task, as it stands in `BACKLOG.md`:

```
### rerun-baseline-8of8: Re-run the 8/8 baseline on the old CLAUDE.md
- Status: ready
- Context: the dated-notes test scored 8/8 on the old CLAUDE.md (commit 4e1a9c0). Reproduce it.
- Next: check out 4e1a9c0, run tests/dated-notes with the headless runner, 6 runs.
- Done when: the headless runner scores 8/8 again on 4e1a9c0.
```

What I found while looking into it:
- The task exists because the dated-notes rule (name a one-off document `YYYY-MM-DD-<slug>.md`) was rewritten on 2026-10-30. Its new wording scored 0/6 in real cloud sessions, and someone wanted to prove the old wording still worked before deciding between the two.
- The 8/8 was measured with the headless runner (`claude -p`) in a temporary folder. Nobody had checked that runner against real sessions.
- On 2026-11-27, real cloud sessions and the headless runner disagreed on the same workspace: headless 8/8, real sessions 0/6. So reproducing 8/8 with the headless runner would not tell us whether the old wording works in real sessions.
- The other runner, `claude plugin eval`, agreed with real sessions on that workspace (0/6), but on a single workspace only.
- Cost: a 6-run batch with either runner takes about 40 minutes of session time. Real cloud sessions can only be started by Dana from the web UI; they take Dana about 2 minutes each to start and 1 minute to paste the result back.
- The rule currently in force is the rewritten one (the 0/6 one).

Options I can see:
1. Run the task as written (headless runner, 6 runs).
2. Change the task to measure the old wording in real cloud sessions: Dana starts 6 sessions, I score them.
3. Change the task to run both wordings with `plugin eval`, which matched real sessions once.
4. Drop the task and restore the old wording directly.

My own view: option 2 is the only one that answers the real question, and option 3 is a cheaper first step if Dana's time is short.

If Dana picks option 2, the steps only Dana can do are: open claude.ai/code, start a new session on the `dated-notes-fixture` environment with the prompt in `tests/dated-notes/prompt.txt`, repeat 6 times, and paste each session's link back into the issue.

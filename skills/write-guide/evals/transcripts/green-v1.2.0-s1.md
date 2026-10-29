File writes are blocked in this session (no Write/Edit tool, and Bash file redirection is disabled) — I can't save this to disk here. I'll paste the guide in full below so you can copy it straight into your doc before 15:00.

---

# Handling an incident

**Question this guide answers:** when something breaks, what do I do right now — and at what point do I stop and escalate?
**For:** any of the four of us, alone, when a page or a report comes in. Written especially for the first months on the team, when the hard part isn't the fix, it's deciding whether you're still the right person to be doing it.

**Out of scope:** how the rota app or status page is configured (ask whoever set them up), and how the on-call rota itself is built (that's a scheduling decision, not an incident-response one). If either of those turns out to matter mid-incident, that's a boundary leak — flag it to me rather than guessing.

**The problem this exists to fix:** escalation is happening too late. Nearly every rule below that isn't a plain fact (severity definitions, tool names) exists to move the escalation decision earlier. Where you see a specific number for a checkpoint, it is *my* call, not a measured standard — see the note at the end.

---

## 1. Severity — decide this first, it sets everything else

| Level | Definition | Changes |
|---|---|---|
| Sev1 | Customer-facing outage | Page immediately, checkpoint every 15 min |
| Sev2 | Degraded, not down | Page if no owner within 10 min, checkpoint every 45 min |
| Sev3 | Annoying, not urgent | No page required, escalate only if it turns out bigger than it looked |

*[Composition — these three definitions and the checkpoint intervals are the team's own classification, not drawn from an external standard. Recalibrate them once we have a few incidents' worth of real timing to look at.]*

If you're not sure which one it is, **pick the higher severity and downgrade later.** Downgrading costs a message in the channel. Upgrading late costs the customer-facing minutes you spent deciding.

## 2. The procedure

**E1 — Open a channel, before you touch anything.**
In: whatever alerted you (page, ticket, customer report). Out: a channel that exists, with a timestamp on when it started.
Trap: fixing first and opening the channel "once I know what it is" — that's the first silent handoff waiting to happen, because now nobody else knows you're in it.

**E2 — Classify severity (section 1) and page if the table says to.**
In: the channel. Out: correct people notified through the rota app.
Trap: waiting for certainty before paging. Page on the working guess; correct it in the channel.

**E3 — Take ownership.**
Out: one named owner, visible in the channel. You own it until a handover is explicit and acknowledged by the person taking it — **no silent handoffs.** If you go quiet, it's still yours.

**E4 — Escalation checkpoint. This is the step that fixes the late-escalation problem.**
At the interval set in section 1, ask one question and answer it out loud in the channel: *"Do I have a fix in progress, or do I have a confirmed cause with a fix path?"*
If the honest answer is no, escalate now. Not "give it ten more minutes" — the checkpoint exists precisely because that instinct is what makes escalation late.
Trap named directly: **if you are spending more time deciding whether to escalate than it would take to just page someone, you have already waited too long.** That's the tell — use it as the test, not your own confidence level.

**E5 — Handover, if it happens.**
Out: explicit statement in the channel of who now owns it, acknowledged by that person. An un-acknowledged handover is not a handover — it's still yours.

**E6 — Resolve.**
Out: the channel states resolution, sev1/2 gets a status page update, sev3 gets the ticket closed.

**E7 — Postmortem.**
Within 5 working days, blameless. Blameless means the document describes what happened and what changes, not who did what — if a draft names a person as the cause, that's the test that it failed, rewrite it around the system, not the person.

## 3. Tools (reference, not decisions)

- **Rota app** — who's on call, and how you page them.
- **Status page** — customer-visible updates, sev1/sev2 only.
- **Shared incident doc** — timeline and notes during the incident; becomes the postmortem input.

None of these change what you do next — they're where you do it. If you're unsure which tool applies, that's answered in section 2, not here.

## 4. Worked case

Junior agent, second month, gets a page: checkout is throwing errors for some customers.

- **E1** — Opens `#inc-checkout-0825` immediately, before looking at logs. Timestamp: 14:02.
- **E2** — Not fully sure it's customer-facing yet (only two reports so far) — picks Sev1 anyway per the "pick higher, downgrade later" rule. Pages on-call via the rota app.
- **E3** — Takes ownership, posts it in the channel.
- **14:17 — E4 checkpoint (15 min for Sev1).** Honest answer: no fix path yet, just a hunch about a recent deploy. This is exactly the moment the old habit was "give it five more minutes to confirm the hunch." Instead: escalates now, pages the senior who shipped the deploy.
- Senior confirms the cause in 4 minutes, ships a rollback.
- **E5** — Senior takes explicit ownership in the channel; junior acknowledges. Now it's the senior's.
- **E6** — Resolved 14:26, status page updated.
- **E7** — Postmortem drafted by 29 Aug, blameless: names the missing deploy check, not the person who deployed.

Total customer-facing time: 24 minutes. Under the old pattern — wait for certainty before escalating — this is the incident that used to run 45+ minutes while someone tried to be sure before asking for help. The checkpoint at E4 is the fix.

## 5. Quick reference (copy this into the channel template)

```
Sev: [1/2/3]        Owner: [name]        Started: [time]
Next checkpoint: [15 / 45 / n/a]
Escalated? If checkpoint answer was "no fix path" — yes, and to whom.
```

---

## Sources and open calls

- Severity definitions, "open a channel first," "no silent handoffs," 5-working-day blameless postmortem, and the three tools: given directly, treated as this team's settled policy as of today. Not externally sourced — there's nothing to open a citation on.
- Checkpoint intervals (15 min / 45 min) and the E4 test question: **my call**, made to close the specific gap you named (late escalation), not measured against our own incident history because we don't have that data yet. `[Composition]`. Revisit after the next handful of incidents — if checkpoints are firing too early or too late in practice, move the number, not the rule.
- Left out on purpose: how severity interacts with contract SLAs, if any exist — I don't have that information, and if it exists it changes the paging urgency in section 1. Worth a look before this guide is treated as final.

---

Two things worth knowing about before the meeting: I dropped "Introduction / Principles / FAQ" — nothing in your material needed them, and each would've been filler. And the 15/45-minute checkpoints are a deliberate guess to attack your stated problem, not a fact — say so if someone asks where they came from, and be ready to move them once you have real incident timing.

**B** — structure it some other way and use the matrix inside it. The two tests in Phase 2 both fail for option A: the *anatomy test* fails outright (four sections, one per quadrant, is literally the tool's own parts), and the *substitution test* fails too (swap Eisenhower for MoSCoW or a simple scoring grid and the whole guide would need rewriting, because the sections are named after the tool, not after what the agents do). The real substrate here is thinner than a full 2×2: one axis (urgent) is almost entirely decided by a single contractual fact — the 4-hour clock — and the other (important) has to be invented for two of the four cells since the given context never populates them. That's exactly the shape the skill flags: a tool sitting in the pivot's seat. I kept the matrix — it's genuinely useful for the ambiguous middle of the queue, and it directly targets the "whoever shouts loudest" habit — but built the guide on the procedure the agents actually run (dedupe → clock check → sort what's left → work order across channels), with the matrix as the sorting instrument for step 3, its axes anchored to real facts (the contract, the money, the account) rather than gut feel.

---

# Prioritising the support queue

**Question:** given the tickets sitting in front of you right now, which one do you pick up next, and does anything about it have a real clock on it?

**For:** two support agents, one month in, currently ordering the queue by who has emailed, chatted or called most recently or most insistently.

**Given, not derived here** — the facts below are your business's own, not general support-industry figures. They calibrate the rest of the guide and would need re-checking if any of them change:
- Channels: email, chat, phone.
- Two agents, one queue.
- Any customer-facing ticket that blocks money carries a **4-hour contractual response time**. Everything else has no committed deadline.
- Volume: 30–60 tickets/week.
- About 1 in 10 incoming tickets is a duplicate of one already open.

**Out of scope:** how you actually resolve a ticket once you've picked it up; SLAs owed by other teams once you've escalated to them; staffing and coverage. This guide only decides *order*, not *technique*.

**Boundary leak, named:** phone is synchronous — the customer is on the line, so there is no "prioritising" a live call, you take it. What this guide governs for phone is the ticket it leaves behind: the follow-up logged after you hang up joins the queue like anything else. Keep that distinction in mind through the whole guide; every rule below is about the async backlog (email, chat, and phone follow-ups), not about whether to answer the phone.

---

## E1 — Before you rank anything: is it a duplicate?

**In:** a new ticket, on any channel.
**Out:** either it's merged into an existing open ticket, or it's confirmed new and moves to E2.

Check the open queue for the same customer and the same subject before you do anything else with a new ticket. At your volume, roughly 1 in 10 will match. `[Given]`

**Trap:** a duplicate that arrives on a *different* channel from the original (customer emailed, then called) reads as new urgency because it's louder, not because it's a new problem. Merge it, carry over whatever new information it added, and don't let the second contact jump the queue on its own.

**Test you did this:** if two open tickets share the same customer and the same issue, E1 was skipped.

---

## E2 — Does the 4-hour clock apply?

**In:** a confirmed non-duplicate ticket.
**Out:** either it's flagged with a contractual due-time, or it moves to E3 with no committed deadline.

Ask exactly one question: **is this customer-facing, and does it block money?** If yes on both, the 4-hour contractual clock starts now, full stop — it does not matter which channel it arrived on, how it was worded, or whether the customer sounds calm or furious. `[Given]`

This is the only place in the whole procedure where "urgent" is decided by something other than judgement. Everything that clears this bar goes to the top of the async queue, ordered by time remaining before the 4 hours are up.

**Trap:** a ticket that *sounds* like an emergency (all caps, three exclamation marks, "URGENT" in the subject line) but isn't customer-facing-and-money-blocking does **not** get the clock. Tone is not evidence.

**Test you did this:** if a ticket without a real money-blocking, customer-facing issue is being treated as a 4-hour ticket, E2 was applied on the wording instead of the facts.

---

## E3 — Sort what's left: urgency and importance, not volume of contact

**In:** every ticket that cleared E2 without a contractual clock.
**Out:** each ticket placed in one of three bands (a fourth, the clock, is already handled by E2).

This is where the Eisenhower matrix earns its place — as an instrument for this one step, not as the shape of the guide. `[Established*]` (attributed to Eisenhower via Covey's *First Things First*; widely cited, not independently verified in this session — treat the attribution as a label of convenience, not a citation you can defend under challenge). Its only job here is to stop "how many times has this person contacted us" from silently standing in for "how much does this matter."

Score each remaining ticket on two questions, independently:

| | **Low importance** | **High importance** |
|---|---|---|
| **High urgency** | *Noise.* Repeated contact, no real cost if delayed a day. e.g. a single low-tier account calling twice about a cosmetic label. | *Handled by E2* — if it's genuinely urgent and important it's customer-facing and money-blocking, and already has the clock. |
| **Low urgency** | *Backlog.* No decaying window, low stakes. e.g. an already-answered "how do I..." question. | *Don't let it drift.* No hard deadline, but real cost if ignored: account-tier risk, a renewal coming up, an issue touching several customers. |

- **Importance** = cost if this is handled late or wrong: revenue tier of the account, number of customers affected, whether a real decision window (renewal, event date) is closing. `[Composition]`
- **Urgency**, once the contractual clock is off the table, = whether the situation actually decays with time — not how many times the customer has been in touch. `[Composition]`

**Trap, the one this whole guide exists to close:** repeat contact is a symptom of urgency, not proof of importance. A customer who calls three times about a trivial issue has raised the volume, not the stakes. Do not let contact frequency alone move a ticket out of "Backlog" or "Noise."

**Test you did this:** if the loudest ticket in the queue and the highest-scoring one on the table above are different tickets, and you worked the loud one first, E3 was skipped.

---

## E4 — Turn the sort into a work order

**In:** the queue, each ticket now dedupe-checked and classified (clock / don't-let-drift / noise / backlog).
**Out:** the order you actually work through today.

1. Anything with the 4-hour clock running, soonest deadline first.
2. "Don't let it drift" tickets — no hard clock, but real cost, so they get worked before the day fills up with easier things.
3. "Noise" — real but low-stakes; work between the above, don't let it push them out.
4. "Backlog" — whenever there's slack.

Within the same band, older tickets go first. Two agents on one queue: whoever is free next takes the top of the list — this isn't split by channel or by who originally answered the customer.

**Trap:** at 30–60 tickets/week for two people, "I'll just clear the easy ones first" quietly promotes backlog over don't-let-drift, because easy things feel like progress. The order above exists to stop that, not to describe what already happens.

---

## E5 — When to re-triage

A ticket's band isn't fixed at intake. Re-check it when:
- A customer follow-up changes the *facts* (a decision window just closed, a second customer reports the same issue) — re-score importance.
- A ticket has sat in "backlog" for more than a week — check it hasn't quietly become "don't-let-drift."
- A customer escalates (asks for a manager, mentions cancelling). Re-check **importance**, not urgency — an escalation is information about stakes, and the same trap from E3 applies: don't let it move the ticket just because it got louder.

---

## Worked case

Monday morning, four tickets land within twenty minutes.

1. **Chat**, from an existing enterprise customer: "our payment sync is failing, we can't invoice clients." → E1: not a duplicate. → E2: customer-facing, blocks money → **4-hour clock**, logged at 09:12, due 13:12.
2. **Email**, same customer, same subject, sent eight minutes earlier via a different address than usual. → E1 catches it as a duplicate of #1 on a second read (first pass missed it because the sender address didn't match) — merged, clock stays at 09:12, not restarted. *This is the correction worth noticing: the dedupe check has to look past the surface (channel, sender address), not just match on ticket ID.*
3. **Phone call**, small account, cosmetic complaint about a button colour, this is their third contact this week about it. → Answered live (phone is always answered). Logged afterward. → E2: not money-blocking → E3: high urgency (third contact), low importance (cosmetic, single small account) → **Noise**.
4. **Email**, mid-tier account, asking about upcoming plan renewal terms, no deadline stated, renewal is in three weeks. → E2: no clock → E3: low urgency today, high importance (revenue + closing window in three weeks) → **Don't-let-drift**.

Work order for the morning: #1 (clock, due 13:12) first; #4 next, even though nobody's chasing it, because the renewal window is real; #3 fitted in between if there's a gap, precisely *not* first despite being the loudest.

---

## Sources and caveats

| What | Label | Check |
|---|---|---|
| Eisenhower matrix, attributed via Covey's *First Things First* | `[Established*]` | Attribution widely repeated; not independently verified against a primary Eisenhower or Covey text in this session. If this is contested, treat it as a naming convenience, not a citation. |
| 4-hour contractual response time, channel list, queue volume, duplicate rate | Given (inherited from the requester's own business) | Not externally sourced — these are facts about this team, re-check if the contract or the queue changes. |
| Importance/urgency scoring rules in E3, work-order rules in E4 | `[Composition]` | These are this guide's own assembly, built to counter the specific failure named in the brief (loudest-shouts-first). Argue the substance if contested, not an authority behind them. |

**Left out on purpose:** a numeric scoring formula (e.g. weighting revenue × customers-affected) was considered for E3 and dropped — at 30–60 tickets/week for two people, a two-band judgement call is faster to apply correctly than a formula is to compute correctly, and nothing in the given context justifies the extra precision.

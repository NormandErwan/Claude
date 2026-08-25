**B) — structure it around the procedure, keep the matrix inside as a sorting instrument.**

Run the two tests from the skill before committing to A. *Anatomy test*: one section per quadrant means the guide's sections are the tool's own boxes — that's the tool in the pivot's seat. *Substrate test*: the context gives exactly one real urgency signal (the 4-hour contractual clock) and no independent "importance" axis — a ticket that blocks money is urgent and important at once, so the two axes collapse into one fact for the case that actually matters, and "important-but-not-urgent" / "urgent-but-not-important" have nothing real to classify with the data given. Forcing four sections onto that would manufacture an importance axis out of nothing, and two new agents disagreeing on what counts as "important" is the shout-loudest problem again, just relabeled. So: the pivot is the sequence an agent runs when a ticket lands (dedupe → clock check → rank the rest), and Eisenhower's urgent/important questions get kept as the sorting instrument inside the one step that actually needs a two-axis comparison — the non-clocked majority.

---

# Prioritising incoming tickets

**Question this guide answers:** when a ticket lands, which one do you work next?
**For:** two support agents, about a month in, currently prioritising by whoever shouts loudest — no dedicated triage role, tickets arriving by email, chat and phone, 30–60/week.
**Out of scope:** how to resolve a ticket technically, staffing the desk, and who decided the 4-hour clock — that clock is treated here as a given fact, not something this guide justifies.

This is a team-process subject, not a standards subject: most of what follows is `[Heuristic]` or `[Composition]`, said plainly rather than dressed up. The one non-negotiable fact is the contractual clock, and it's marked as an inherited premise, not a discovery.

## The one hard fact

`[Inherited premise — contractual]` Any ticket that is both customer-facing and blocking money (a failed payment, a blocked checkout, an invoice that can't go out — whatever "blocks money" means in your shop) carries a **4-hour response commitment**, regardless of channel. Nothing else in the queue has a committed deadline.

This is also why the guide doesn't run urgency and importance as two separate questions for this category: a ticket that blocks money for a customer is time-bound and consequential in the same instant. Asking "is it urgent?" and "is it important?" separately here just asks the same fact twice.

## Procedure

### E1 — Catch duplicates before ranking anything
**In:** a new ticket, any channel. **Out:** "distinct, go to E2" or "duplicate, merged, closed."

Before a ticket gets a rank at all, search open tickets for the same customer and the same issue — by email thread, by chat customer ID, by caller account on the phone. If one exists, merge into it and don't add a second line to the working queue.

`[Heuristic]` **Test:** if the same issue has two open ticket numbers at once, this step was skipped. At roughly one duplicate in ten, skipping E1 costs the team 3–6 tickets of double-handling a week — that's most of a day.

### E2 — Check the clock
**In:** a de-duplicated ticket. **Out:** "clocked — work inside 4 hours" or "not clocked — go to E3."

Ask one question: is this customer-facing **and** does it block money? If yes, it goes to the top, worked within 4 hours of arrival, ties broken by arrival order. If no — however upset the customer sounds — it goes to E3.

`[Inherited premise]` **Test:** if a ticket without both conditions gets pulled ahead of a clocked ticket, the clock rule was overridden by something else (usually volume of complaints, which is exactly the failure mode being replaced).

### E3 — Rank what's left
**In:** the non-clocked tickets — the large majority of the queue. **Out:** a rank, one of four bands.

This is the one place a two-axis read earns its keep, because this bucket has no built-in ordering. Use two concrete questions, not a vibe:

- **Blocked?** Is the customer currently unable to use the product/service at all, versus inconvenienced or asking a question.
- **Weight?** If it sits a day, does it touch revenue, renewal, or more than one customer, versus one person's isolated issue.

| | Blocked | Not blocked |
|---|---|---|
| **Revenue / multi-customer** | Work next, right after clocked tickets | Schedule it, flag to whoever owns roadmap/comms |
| **Single user, no revenue** | Work same day, batch these together | Queue in arrival order, revisit only if it ages |

`[Composition]` — adapted from the Eisenhower urgent/important model; the two questions above are proxies chosen for this queue, not the original wording, and they apply only to this step, not to the clocked tickets in E2.

**Test:** if two agents sort the same ten tickets into different top-three, the questions are being read as opinion rather than answered literally — re-anchor on "is the customer blocked, yes or no" and "does it touch revenue or more than one customer, yes or no," not on how the ticket feels.

### E4 — Re-open the sort, don't jump the queue
**In:** a second contact on an already-open ticket (a chasing phone call, three chat messages on the same issue). **Out:** either the sort is confirmed, or E1/E2 get re-run with new information.

A second contact is a trigger to re-check E1 (is it actually still open, or should it have been merged) and re-check E2 (did new information turn it into a money-blocker) — it is never by itself a reason to move a ticket up.

`[Heuristic]` **Test:** if a ticket's rank changes and neither E1 nor E2 changed, that's the shout-loudest pattern this guide exists to replace.

## Worked case

Tuesday, mid-morning. Queue has: an email from a customer whose checkout is throwing an error (has an active subscription); a chat asking how to export a report; a phone call from a customer annoyed that a cosmetic UI bug hasn't been fixed in two weeks; and a second email that turns out to be the same checkout error from a different customer, already reported an hour earlier.

- **E1:** the two checkout emails are compared — different customers, different accounts, not a duplicate. The chat and phone tickets are checked against open tickets — the phone caller's cosmetic bug ticket is already open from two weeks ago; the call is a chase, not a new ticket. Sent to E4.
- **E2:** the checkout error is customer-facing and blocks payment → clocked, 4-hour commitment, both instances. The report-export chat is not a money-block → E3. 
- **E4:** the phone chase gets checked — no new information, still cosmetic, no revenue impact → stays where it already sat in E3, not bumped despite the second contact.
- **E3:** report-export chat — customer isn't blocked (they can still use the product), single user, no revenue signal → queued in arrival order. The two-week-old cosmetic bug — not blocked, no revenue tag as originally logged → scheduled, not escalated, even though the phone call was the loudest thing that happened all morning.

The correction that matters here: the instinct on the call is to bump the cosmetic bug up because the customer is audibly frustrated. E4 catches it — nothing about the fact pattern changed, so the rank doesn't change either. The checkout errors get worked first not because they arrived loudest, but because they're the only tickets in the batch that clear E2.

## Checklist

- [ ] Every new ticket was checked against open tickets before being ranked (E1)
- [ ] Every clocked ticket (customer-facing + blocks money) was started inside 4 hours
- [ ] No non-clocked ticket was worked ahead of a clocked one
- [ ] E3 ranks were assigned by answering the two literal questions, not by who asked
- [ ] A second contact on an open ticket changed its rank only if E1 or E2's answer changed

## Annex — sources, caveats, what was left out

**Sources.** The 4-hour clock, the channel mix and the ~1-in-10 duplicate rate are facts supplied for this queue, not sourced claims — carried as inherited premises. The Eisenhower urgent/important framing is a widely-known named heuristic; it was not checked against a primary source in this session, so nothing here claims `[Established]` — the operational rules built from it (E3's grid, its two questions) are marked `[Composition]`/`[Heuristic]` on their own terms.

**Caveats.** E3's "weight" axis (revenue / multi-customer) is a proxy, not a measured value — the shop has no scoring behind it yet. Two agents applying it in good faith can still disagree on a genuinely ambiguous ticket; when that happens, the tie-break is arrival order, not further debate.

**Declared boundary leak.** This guide has no answer for ticket aging: a single-user, no-revenue ticket in the bottom-right cell of E3 can sit for weeks with nothing in the procedure forcing a second look. That's a real gap, not an oversight — a weekly sweep for anything past, say, two weeks old is a reasonable stopgap, but it's `[Heuristic]` and untested here, not a rule of this guide.

**Left out on purpose.** Which agent takes which ticket (routing by skill or channel) and how backlog volume feeds into staffing are both real questions for this desk, but neither changes which ticket to pick up next — they're staffing questions, not triage questions, so they stay out.

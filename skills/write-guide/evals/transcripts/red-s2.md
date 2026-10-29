**A**

The brief explicitly asks for the matrix to be the organizing spine — one section per quadrant, each covering contents/action/examples — and that structure is also the right pedagogical choice: two new agents anchored on "whoever shouts loudest" need a small number of repeatable buckets they can sort any ticket into within seconds, and four quadrants with a clear rule for each is exactly that. Options B or C would either bury the model or drop the one tool suited to fixing the actual problem (urgency being confused with volume/loudness), so A is the right call.

---

# Ticket Prioritization Guide: The Eisenhower Matrix

## Why we're changing how we triage

Right now, tickets get worked in the order they're shouted about: whoever calls twice, or messages in all caps, jumps the queue. That's a problem because **channel and tone tell you nothing about actual urgency or importance** — a phone call can be someone locked out of a free trial, while a quiet one-line email can be a customer who can't complete payment.

We're switching to the Eisenhower Matrix: every ticket gets sorted on two independent questions, not on how it arrived.

- **Urgent** = there is a real clock on it. For us, "real clock" almost always means: *is this a customer-facing issue that blocks money* (blocks a purchase, payment, invoice, or revenue-generating action)? Those carry a **4-hour contractual response time**. Nothing else in our queue has a committed deadline, so nothing else is "urgent" in the contractual sense — even if it feels urgent to the person shouting.
- **Important** = the impact is real if we get it wrong — money, multiple customers, a key account, legal/contractual exposure, or the relationship long-term. Something can matter a lot without a clock on it, and something can have a clock without mattering much.

Those two questions give four quadrants. Every incoming ticket — email, chat, or phone — goes into exactly one.

```
                    URGENT                      NOT URGENT
              ┌───────────────────────┬───────────────────────┐
   IMPORTANT  │   Q1: DO NOW           │   Q2: SCHEDULE         │
              │   4-hr SLA, blocks $$  │   Matters, no deadline │
              ├───────────────────────┼───────────────────────┤
NOT IMPORTANT │   Q3: HANDLE FAST /    │   Q4: BATCH / DECLINE  │
              │   PUSH BACK ON URGENCY │   Backlog or drop      │
              └───────────────────────┴───────────────────────┘
```

---

## Quadrant 1 — Urgent + Important: "Do Now"

**What goes here:** Any customer-facing ticket that blocks money — a customer can't check out, a payment is failing, an invoice can't be paid, a paid feature they rely on to transact is down. This is the only quadrant with a contractual commitment attached: **respond within 4 hours**, regardless of whether it came in as an email at 11pm, a chat message, or a phone call.

**What you do with it:**
- Whoever is on triage picks it up immediately, or hands it to whichever of the two agents is free — don't let it sit in a shared inbox.
- Start the SLA clock the moment it's logged, not when you get around to reading it. Acknowledge the customer within the 4 hours even if the fix takes longer.
- If both agents are already mid-task on non-Q1 work, a Q1 ticket interrupts it. This is the one case where you drop what you're doing.
- Check for duplicates before you start work (see "Handling duplicates" below) — don't run two parallel investigations into the same outage.

**Examples:**
- "Your checkout page throws an error at the payment step" (chat, mid-afternoon).
- A phone call from a customer whose renewal invoice won't process.
- An email reporting that an API key used for billing integration just stopped authenticating.

---

## Quadrant 2 — Important, Not Urgent: "Schedule"

**What goes here:** Things that genuinely matter — to the customer relationship, to revenue risk, to a key account — but have no contractual clock. This is the quadrant that gets starved when you prioritize by volume, because nobody is shouting about it yet.

**What you do with it:**
- Don't let "no deadline" mean "no plan." Give it a target — same day, this week — based on how much it matters, and put it on the schedule rather than the pile.
- These are good candidates to pick up between Q1 interruptions, or to assign to whichever agent has bandwidth, since they don't require dropping other work.
- Flag anything that looks like it's drifting toward Q1 (a bug that's currently a workaround but could become a blocker) so it gets picked up before it escalates.

**Examples:**
- A key account emails that a report feature is broken — annoying and reputationally risky, but they can still transact.
- A customer flags a data discrepancy in their account that isn't blocking anything today but will cause a billing dispute next month if unaddressed.
- A recurring complaint from several customers about a confusing signup step (not broken, just bad UX, but it's costing conversions).

---

## Quadrant 3 — Urgent, Not Important: "Handle Fast, Don't Let It Drive the Queue"

**What goes here:** This is the quadrant that causes the "loudest wins" problem — tickets that *feel* urgent because the customer is pushing hard (repeated calls, all-caps chat, "please respond ASAP"), but the underlying issue doesn't block money and isn't high-impact. It's genuinely low-value to leave unanswered too long, but it shouldn't bump Q1 or Q2 work.

**What you do with it:**
- Answer quickly if it's genuinely quick to answer (password reset, "where do I find X," a how-to question) — fast handling here isn't wrong, it's often the most efficient thing to do. The point is not to let *pressure* override the actual work order.
- If it's not a 30-second answer, acknowledge it, set an honest expectation ("no committed SLA, but we'll get to this today/this week"), and don't let repeated follow-ups from the same person re-sort it into Q1 — the ticket's quadrant doesn't change because someone calls twice.
- This is also where you politely correct the channel expectation: phone/chat doesn't mean instant, it means synchronous — the ticket still gets prioritized on the same rules.

**Examples:**
- A customer calls three times in an hour asking how to export their data — answerable in one message, so just answer it.
- Someone messages in chat demanding an immediate callback about a minor cosmetic UI issue.
- An email marked "URGENT!!" asking a general product question with no functional impact.

---

## Quadrant 4 — Not Urgent, Not Important: "Batch or Decline"

**What goes here:** Low-impact requests with no deadline, and — critically for us — **duplicates**. About 1 in 10 tickets turns out to be a duplicate of one already open; those belong here regardless of what they're about, because the work is already in flight elsewhere.

**What you do with it:**
- **Duplicates:** link the new ticket to the existing open one, close or merge it, and don't restart the investigation. If the original ticket is Q1, don't let the duplicate's arrival trick you into treating it as a second, separate urgent case — it's one issue, one response.
- **Genuine low-value tickets** (minor feedback, nice-to-have requests, cosmetic suggestions with no urgency and no real impact): batch these and clear them in a low-priority sweep — end of day, or when the queue is quiet — rather than interrupting Q1/Q2 work for them.
- It's fine for something to sit here for a while. That's the point of the quadrant.

**Examples:**
- A second email about the same checkout error already reported an hour ago by a different customer.
- "It would be nice if the dashboard had dark mode."
- General positive/negative feedback with no request attached.

---

## Putting it into practice

**The 10-second sort.** For every new ticket, ask two questions in order:
1. *Is this customer-facing and blocking money?* → If yes, it's Q1. Log it, start the 4-hour clock, done — skip question 2.
2. If no: *Does this matter (revenue risk, key account, multiple customers, reputational/legal exposure) even without a deadline?* → Yes = Q2. No = Q3 or Q4 depending on whether it needs a fast reply or can be batched.

**Handling duplicates first.** Before triaging content, do a quick check against open tickets (same customer, same symptom, same time window) — with ~1 in 10 being duplicates, catching this early saves real time and prevents a duplicate from being mis-triaged as a fresh urgent issue.

**Channel is not a priority signal.** Phone calls feel urgent because they're synchronous, not because the issue is Q1. Sort by the two questions above regardless of whether the ticket came by phone, chat, or email.

**With two agents and 30–60 tickets/week (~roughly 3–6 tickets/agent/day):** one agent can own "first pass triage" for a shift (sorting into quadrants, handling Q1/Q3 quick items as they land) while the other works through the Q2 schedule; swap the triage role daily so it doesn't become one person's job. Sweep Q4 together at the end of the day.

**Rule of thumb:** if you're ever tempted to prioritize something because the customer is upset or insistent, first ask "does this block money?" and "does this actually matter beyond this one interaction?" If the answer to both is no, it's Q3 at worst — reassure the customer, but don't let volume of complaint override the matrix.

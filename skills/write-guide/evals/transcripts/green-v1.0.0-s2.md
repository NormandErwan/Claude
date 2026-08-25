A) Structure the guide as asked — four sections, one per quadrant.

**Justification:** The pivot test and substrate test both pass here. The two axes have real, distinct content from the facts you gave: "urgent" has exactly one source of truth (the 4-hour contractual clock on money-blocking tickets — everything else has no committed deadline), and "important" has a workable definition beyond money (multi-customer impact, or risk of escalating into the money-blocking case). The four cells produce genuinely different handling, and — crucially — quadrant 3 (looks urgent, isn't important) is precisely where "whoever shouts loudest" lives: a loud phone call or a repeated chat ping that carries no contractual clock. Naming that quadrant is what fixes the actual problem you described, so the matrix isn't decoration here, it's doing real work. I kept the matrix as the pivot but moved two things outside it that aren't quadrant-specific: the duplicate check (applies before sorting, to any ticket) and channel handling (affects when you engage, not where you file it) — folding those into a quadrant would have hidden them.

---

# Prioritising incoming tickets — the quadrant guide

## How to use this

**The question this guide answers:** when a new ticket lands — by email, chat or phone — which one do you pick up next, and what do you do differently depending on what it is?

**Who this is for:** the two of you, a month in. You know the product and the tools; what you don't have yet is a shared, fast rule for ordering the queue that doesn't depend on who emailed twice or who's on the phone right now. This assumes no manager is triaging for you — you're doing it yourselves, live, ticket by ticket.

**Calibration:** 30–60 tickets/week, two agents, three intake channels (email, chat, phone). About 1 in 10 is a duplicate of an open ticket. Customer-facing tickets that block money carry a 4-hour contractual response time; nothing else has a committed deadline. That's the only hard fact this guide has to work with — everything else below is built on top of it.

**Out of scope:** how you technically resolve a ticket once you've picked it up, how shifts/roster are split between the two of you, and whether the 4-hour SLA itself is the right number — that's a contract question, not a triage question.

**Boundary leak, declared:** the "important" axis is easy to define for money-blocking tickets (it's given) and harder for everything else. Section on Q2/Q3 gives you the test and examples, but there will be tickets where the two of you read it differently. Default: **when in doubt, treat it as important** — the guide would rather you over-schedule a Q2 than let a real one drift into Q4. Revisit the call at your next check-in rather than debate it mid-queue. `[Heuristic]`

**Inherited premise to confirm, not assumed here:** "4-hour response" is treated as time-to-*first-reply* from when the ticket lands, not time-to-resolution. That's standard SLA language, but it wasn't spelled out in your brief — confirm it with whoever owns the contract before you bake it into tooling. `[Heuristic]`

A note on labels: ticket triage inside a two-person team has no standards body behind it. Facts given to this guide (the SLA, the volume, the duplicate rate, the channels) are treated as ground truth from your operation, not independently verified. Everything built on top of them is marked `[Heuristic]` (a field rule, negotiable) or `[Composition]` (my own assembly, own it as a choice).

## Principles

- **P1 — Only a committed deadline makes a ticket urgent.** The channel it arrives on, the tone it's written in, and how many times someone has followed up never do. `[Composition]`
  *Test: if two tickets with the same content would be sorted differently because one came by phone and one by email, P1 was violated.*

- **P2 — Check for a duplicate before you sort anything.** With 1 in 10 tickets duplicating an open one, sorting first and deduping later means you've triaged noise. `[Heuristic]`
  *Test: if you're about to quadrant a ticket and haven't checked the open queue for the same customer/same issue, stop and check first.*

- **P3 — A quadrant decides handling, not the order you happen to see tickets in.** You don't work the queue top-to-bottom; you work it quadrant-by-quadrant, then by the rule inside that quadrant (below).

## The model: two questions, not four labels

Before anything else, ask, in this order:

1. **Is it a duplicate?** (P2) — if yes, link it to the open ticket, close it as a duplicate, done. It never reaches the matrix.
2. **Is there a real clock on it?** — Yes, only if it's customer-facing *and* blocks money. That's the 4-hour SLA. Nothing else in your current setup carries a committed deadline, no matter how it's phrased or delivered. This is the **urgent** axis, and it is binary and checkable — not a feeling.
3. **Does getting it wrong cost more than one customer, or turn into question 2 if you leave it?** — that's the **important** axis: it affects more than one customer, blocks a customer entirely (no workaround exists), or will escalate into the money-blocking case if untouched for a few days. `[Composition]`

Those two answers place the ticket in exactly one of four cells.

## Quadrant 1 — Urgent & Important: fix now

**What goes in it:** customer-facing tickets that block money. This is the one quadrant defined entirely by given fact, not judgment.

**What you do:** drop what you're doing (short of another Q1 already in progress) and respond inside the 4-hour window. Within this quadrant, order by **soonest to breach**, not by arrival order — a Q1 that landed at 9am and has until 1pm goes ahead of one that landed at 11am with until 3pm only if the first is genuinely closer to breach; otherwise FIFO.

**Example:** a customer can't complete checkout — payment processing tickets are down for their account. Customer-facing, blocks money → Q1, 4-hour clock starts now.

**Trap:** a Q1 ticket that arrives by phone doesn't jump the queue *because* it's a phone call — it's Q1 because it blocks money. A Q1 ticket that arrives by a quiet email is exactly as urgent. Test whether channel is doing the sorting: it shouldn't be.

## Quadrant 2 — Important, not urgent: schedule it

**What goes in it:** no contractual clock, but it affects more than one customer, blocks a customer entirely with no workaround, or will turn into Q1 if you sit on it (e.g. a payment-adjacent bug that hasn't blocked anyone yet but will).

**What you do:** it gets a slot today or this week — not "whenever," not "after everything shouting." Pull it forward if new information moves it toward Q1 (P1 — check the clock again, don't just trust your first read).

**Example:** three separate customers report the same broken export feature this week, none of them phrased urgently, none blocking a payment. Multi-customer impact, no clock → Q2. Schedule it before it becomes three angry customers instead of three calm ones.

**Trap:** Q2 tickets are quiet by nature — nobody's chasing you on them yet. That's exactly why they get starved when the queue fills with Q3 noise. Check Q2 explicitly at the start and middle of each day; don't wait for it to get loud (if it gets loud, it's moved to Q1 or Q3, and you missed the cheaper window).

## Quadrant 3 — Urgent-seeming, not important: contain fast, don't let it jump the queue

**What goes in it:** this is the quadrant that exists because of how you're prioritising today. Loud channel (phone, repeated chat pings, all-caps email), insistent tone, single customer, no money blocked, no multi-customer impact, easy workaround exists.

**What you do:** acknowledge fast — a quick, even templated reply that the customer's been heard — but the *resolution* stays on backlog time, behind Q1 and Q2. Fast acknowledgement is what defuses the "shout louder" incentive without actually letting volume buy priority.

**Example:** a customer calls, frustrated, because a UI label is confusingly worded. No money, no other customer affected, no clock. It's real, it's Q3: acknowledge on the call, log it, resolve when Q1/Q2 are clear.

**Trap:** this is the quadrant you're already sorting correctly by *feel* today — you just call it "the urgent one." The whole value of the matrix is refusing that instinct here. If you notice a ticket got picked up because "they called twice," that's Q3 mislabeled as Q1 — recheck P1.

## Quadrant 4 — Not urgent, not important: backlog

**What goes in it:** cosmetic issues, one-off requests with easy workarounds, feature suggestions, anything nobody is currently pushing on.

**What you do:** batch these — end of day, or when Q1–Q3 are empty. FIFO inside the batch. It's fine for these to wait days; it's not fine for them to silently disappear, so keep them visibly logged rather than left unticketed.

## Worked case

Monday, 9:00–9:20am, five tickets land within minutes: a chat message, two emails, a phone call, and one more email.

1. **Phone call**, customer angry that the dashboard "looks broken" (a icon isn't rendering). Loud, first instinct: drop everything. Check: no money blocked, one customer, cosmetic. → **Q3**. Acknowledge on the call, log it, tell them it's queued.
2. **Email**, subject "URGENT — can't pay invoice." Check open tickets first (P2) — same customer emailed about this 40 minutes ago. → **duplicate**, linked and closed, no new triage.
3. **Chat**, calm tone, "hey when you get a chance, three of our team can't export reports." No clock, but three users, one account. → **Q2**, scheduled for this afternoon.
4. **Email**, quiet, from a customer whose payment integration just failed mid-transaction. Customer-facing, blocks money. → **Q1**, 4-hour clock starts at receipt (9:07am → due 1:07pm).
5. **Email**, a suggestion to add a dark mode toggle. → **Q4**, batched.

Order of work from 9:20am: ticket 4 first (Q1, real clock), a two-line acknowledgement fired back to ticket 1 (Q3, contain), ticket 3 scheduled into the afternoon block (Q2), ticket 5 left in the backlog (Q4). Ticket 2 needed no work beyond the duplicate link.

Notice what happened: the loudest channel (the phone call) got the fastest *acknowledgement* but not the fastest *resolution* — and the quietest ticket (an email, mid-transaction failure) went first, because it was the only one with a real clock.

## Self-check

Run this at the end of a shift, not mid-queue:

- **If the order you worked tickets in can only be justified by "they called twice" or "they sounded really annoyed," the sort wasn't applied — redo it against P1.**
- If a Q2 ticket sat untouched for more than a day without you noticing, you were reading the queue by loudness, not by quadrant — Q2 is quiet by design and needs an active check, not a passive wait.
- If you and your teammate classified the same ticket into different quadrants, it's almost certainly an "important" call on a non-money ticket — apply the default (treat as important) and flag it for the next check-in, don't argue it out live.

## Annex

**One-page flow:**
```
New ticket →
  Duplicate of an open ticket? → yes → link & close
  → no
  Blocks money for this customer? → yes → Q1, 4h clock, work now, order by soonest-to-breach
  → no
  Affects >1 customer / no workaround / will become Q1 if ignored? → yes → Q2, schedule today/this week
  → no
  Loud channel or insistent tone? → yes → Q3, quick acknowledgement, resolve on backlog time
  → no → Q4, batch, FIFO
```

**Sources / caveats:**
- SLA (4h, customer-facing + blocks money), channel mix, volume (30–60/wk), duplicate rate (~1 in 10): given operational facts, not independently verified by this guide.
- "Response" interpreted as time-to-first-reply, not time-to-resolution — confirm against the actual contract wording. `[Heuristic]`
- The definition of "important" for non-money tickets (multi-customer / no-workaround / escalation-risk) is `[Composition]` — a reasonable fill for a gap the brief didn't specify, not a sourced standard. Revisit it once you've run it against a few weeks of real tickets.
- Deliberately left out: a formal severity-scoring grid (P1/P2/P3 style incident scoring). At 30–60 tickets/week with two agents, a scored grid would cost more time to fill in than it would save in ordering — the two binary questions above are cheaper and cover the same ground at this volume.

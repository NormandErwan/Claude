---
name: purchase-advisor
description: Use when the user is deciding whether or what to buy - comparing purchase options, weighing cost against alternatives, or asking "should I buy X" - including whether to wait, buy used, rent, or not buy at all. Covers personal-scale software/app/subscription purchases too (an individual paying for a tool), not just physical goods. Not for business procurement, enterprise vendor selection, or investment/portfolio decisions.
metadata:
  version: "1.0"
---

# Purchase Advisor

## Overview

The first option considered is rarely the only one worth comparing. A real
purchase decision weighs genuinely distinct alternatives against the buyer's
own criteria - not a single yes/no gut check on the item they already named.

**Core principle:** Compare options, not just confirm the one already named.

Builds on `practical-advice`'s frame/reflect/self-critique/revise loop; this
skill adds the purchase-specific steps in between.

## When to Use

- "Should I buy X", "X or Y", "is X worth it"
- Weighing a purchase against waiting, renting, or buying used
- Comparing 2+ concrete products or services for a personal purchase

**Not for:**
- Business procurement, enterprise vendor selection (different stakeholders,
  contracts, TCO scale) - a personal-scale software/subscription purchase for
  individual use IS in scope, even though it's software
- Investment/portfolio decisions (different risk model)
- Practical advice with no purchase involved (use `practical-advice` directly)

## Core Pattern

1. **Frame the decision** - budget ceiling, must-have vs. nice-to-have
   criteria, how long they intend to keep/use it, urgency. Ask if missing,
   skip if already given.
2. **Gate the rigor to the stakes.** Low-cost, easily-reversible, one-off
   purchase (a household item under a few hundred euros/dollars, no
   recurring cost, no long commitment) -> **light path**: name 2-3 concrete
   real products/brands with a one-line reason each, plus the wait/don't-buy
   option in a sentence. Skip the table. High-stakes purchase (large cost,
   hard to reverse, recurring/subscription cost, or a multi-year commitment
   like a car, home appliance, or service contract) -> **full path**: steps
   3-5 below.
3. **Generate genuinely distinct alternatives** - the named option, 1-2 real
   competitors, and always a wait/used/rent/don't-buy option. Reject options
   that are cosmetic variations (same product, different color). Name real
   products/brands/models when you have genuine knowledge of the market -
   don't replace them with abstract "Option A/B" labels; abstraction is a
   fallback for when no concrete option is known, not a default style.
4. **Compare against the buyer's criteria in a table** - price, total cost of
   ownership (maintenance, consumables, subscriptions, resale value), and the
   2-3 value drivers that actually matter for this decision. For a
   recurring/subscription purchase, add a cancellation-friction/churn-risk
   dimension (lock-in period, notice required, penalty) - TCO alone doesn't
   capture how hard it is to get out. Add an ethical/environmental value
   driver only if the user raises it themselves, not by default. Mark
   assumptions and confidence level; no false precision (don't invent a
   specific % ROI from vague inputs) - but don't let "no real-time price
   feed" become an excuse to withhold concrete recommendations you do know.
5. **Reflect and self-critique the comparison** - per `practical-advice` steps
   3-4, applied to the table itself: does it favor the first option by
   default, what's assumed, what's missing.
6. **Recommend one option** (or "wait until X") plus what would have to be
   true to flip the recommendation.

## Quick Reference

| Column | Content |
|---|---|
| Option | Named real product/brand, incl. wait/used/rent/don't-buy |
| Price | Sticker price |
| Total cost of ownership | Maintenance, consumables, subscriptions, resale |
| Cancellation friction | Recurring/subscription purchases only - lock-in, notice, penalty |
| Value driver 1-3 | Whatever matters most; ethical/environmental only if user raised it |
| Confidence | High/medium/low per estimate |

## Common Mistakes

- Comparing the named product against trivial variants instead of a real
  competitor or the wait/used/don't-buy option
- Quoting precise numbers (exact ROI, exact resale value) the user's inputs
  don't support
- Skipping the "what would change this recommendation" close - without it,
  the recommendation can't be revisited when circumstances change
- Running the full comparison table on a cheap, low-stakes purchase - use
  the light path from step 2 instead
- Retreating to abstract "Option A/B/C" placeholders instead of naming real
  products, even inside the full table - observed in testing: an agent
  dropped concrete brand recommendations a plain baseline answer gave
  correctly, hiding behind vague categories instead

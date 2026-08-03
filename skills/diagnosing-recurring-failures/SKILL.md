---
name: diagnosing-recurring-failures
description: Use when a failure or friction keeps coming back after a fix - a repeat incident, a recurring CI or build break, the same review comment raised again, a Retrospective event firing a second time, or when someone asks why this keeps happening. Not for debugging a single live bug in progress (`debugging-and-error-recovery` covers that). Personal, non-technical judgment calls route to `practical-advice`/`purchase-advisor`.
version: 1.0.0
---

# Diagnosing Recurring Failures

## Overview

A fix that removes today's failure without naming the decision that allowed it
buys one quiet cycle. The same symptom returns through a different event.

**Core principle:** Trace until the answer is a decision, not an event - then
prove the countermeasure with evidence you named in advance.

## When to Use

- The same failure, defect, or friction has occurred more than once
- A fix was applied and the symptom came back in a new form
- Post-incident follow-up: the outage is over, the cause is not settled
- A Retrospective event fires again after a fix, or its cause is not evident -
  escalate here rather than logging it a second time
- Recurring process friction: rework, handoff churn, the same review comment

**Not for:**
- Debugging a single live bug in progress - a one-off, not a recurrence
- A failure with no history of repeating

## Core Pattern

1. **Frame before analysing** - three facts, a short paragraph each at most:
   background (why this matters now), current condition (what is observed,
   with dates, counts, and evidence), target condition (measurable, what
   "fixed" looks like). No target condition means no way to check step 4.
   Too vague to write down? Invoke `grilling` first, then return here.
2. **Trace the chain** - ask "why" against the current condition; each answer
   becomes the subject of the next question. Stop when the answer names a
   process or design decision rather than an event. Usually 3-6 steps, but
   the count is not the stop condition - the answer type is.
3. **Branch only when the chain forks** - two plausible answers, or people
   disagree on one -> enumerate candidate causes across people, process,
   tooling, environment, method, and inputs, then converge on the ones
   evidence supports. Write down which candidates were discarded and why,
   so the discard survives the next recurrence.
4. **Treat the countermeasure as a hypothesis** - before applying it, state
   the evidence that would prove it worked and when that evidence gets
   checked. Apply. Check. Held -> standardize it into the artifact that
   enforces it by default (test, lint rule, CI check, template, config
   schema, CLAUDE.md rule). Failed -> the chain was wrong, return to step 2
   with what the failure taught.

**Exit:** if the countermeasure turns out to be a personal, non-technical
judgment call, hand off to `practical-advice` - or `purchase-advisor` when
it is a buying decision. One-way; finish there.

## Quick Reference

| Step | Question it answers | Done when |
|---|---|---|
| Frame | What recurs, how often, and what would count as fixed? | Current and target conditions are written and measurable |
| Trace | Which decision - not which event - allows this? | The answer is a process or design decision |
| Branch | Which candidate causes does evidence actually support? | Survivors named, discards recorded with reasons |
| Prove | Did the countermeasure move the target condition? | Predicted evidence checked, then standardized or looped |

**Event vs decision:**

| Answer | Type | Keep going? |
|---|---|---|
| "The key was missing" | Event | Yes |
| "Someone forgot to add it" | Event, blame-shaped | Yes |
| "Config is edited by hand after merge" | Process decision | Stop |
| "Config was deliberately kept out of the repo, never replaced" | Design decision | Stop |

## Example

> **Frame** - Background: staging blocks releases. Current condition: staging
> deploy failed 4 times in 6 weeks, each on a missing config key. Target:
> zero config-caused staging failures over the next 6 weeks.
>
> **Trace**
> 1. Why did the deploy fail? A config key the new code reads was absent in
>    staging.
> 2. Why was it absent? It was added to a local `.env` only.
> 3. Why only there? Staging config is edited by hand in the dashboard, after
>    the code merges.
> 4. Why after the code? Nothing ties a config key to the commit that
>    introduces it.
> 5. Why does nothing tie them? Config was pulled out of the repo after a
>    secret leak, and no schema-only replacement was ever chosen. -> design
>    decision, stop.
>
> **Prove** - Hypothesis: a checked-in config schema (key names and required
> flags, no values) validated at boot. Expected evidence, checked at 6 weeks:
> zero config-caused staging failures, and at least one CI run failing fast
> with a named missing key. Result: 0 failures, 2 CI catches -> standardized
> by making schema validation a required CI check.

Stopping at step 2 would have produced "add the key to staging" - correct,
and good until the next key.

## Common Mistakes

- Accepting a blame-shaped answer ("someone forgot") as terminal; it names a
  person, not a mechanism
- Running the chain on a symptom nobody framed, so there is no target
  condition to check the fix against
- Using the category sweep as a brainstorm dump: candidates listed, none
  discarded, nothing converged
- Applying the countermeasure and declaring it done without checking the
  evidence that was predicted for it
- Standardizing into a chat message or a person's memory instead of an
  artifact that enforces the change
- Re-running the whole analysis on the next recurrence without reading the
  previous discards

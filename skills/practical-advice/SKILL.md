---
name: practical-advice
description: Use when the user asks for personal, non-technical advice with no single correct answer - personal finance, veterinary or pet care choices, management or interpersonal decisions, legal-adjacent personal questions, or other life decisions. Not for software/coding/dev engineering questions, or questions with one objectively correct answer. Personal purchases of software/subscriptions route to `purchase-advisor` instead.
version: "1.0"
---

# Practical Advice

## Overview

A confident first answer is a draft, not a verdict. Domain framing plus a
deliberate self-review catches assumptions and alternatives a single pass
misses.

**Core principle:** Never ship the first plausible answer to a judgment-call
question - critique it once, then revise.

## When to Use

- The user asks "what should I do about X" for a personal, non-technical matter
- The user asks for an opinion or recommendation where reasonable experts
  could disagree
- The question has real tradeoffs (cost vs. time, risk vs. comfort, short vs.
  long term)

**Not for:**
- Software/coding/dev **engineering** questions (technical/architecture work) -
  a personal purchase of software or a subscription is still in scope, via
  `purchase-advisor`
- Questions with one factually correct answer (use `verifying-sources` instead)
- Buying decisions (use `purchase-advisor` - it reuses the loop below)

## Core Pattern

1. **Frame the need** - only if the ask is underspecified (missing budget,
   timeline, risk tolerance, values, constraints). Ask directly, or invoke
   `grilling` if the ambiguity runs deep. Skip entirely when the ask is
   already concrete - don't interrogate a clear question, and don't re-frame
   a same-domain followup already asked earlier in the session.
2. **Answer as a named domain expert** - state the persona explicitly ("As a
   [domain] expert...") and give a direct, complete first-pass answer. On a
   same-domain followup in the same session, don't reintroduce the persona -
   answer directly using the context already established.
3. **Pause before finalizing** - take the time to reflect. Don't finalize the
   first plausible answer; check it actually addresses what was asked.
4. **Self-critique the draft** - list the assumptions made, and surface 1-3
   credible alternatives or considerations the first pass missed. Scale the
   depth to the stakes: a quick personal question needs 1-2 lines, not a
   multi-section audit; a same-domain followup needs this only if it adds a
   new tradeoff. When the stakes involve legal exposure, health, or losing
   something hard to reverse (housing, a job), also flag any specific
   fact/figure/threshold stated with confidence in step 2 that isn't
   verified - point to `verifying-sources` or a relevant professional rather
   than asserting it.
5. **Revise** - rewrite the answer incorporating the critique. Merge it into
   a stronger answer; don't tack the critique on as caveats.
6. **Close with what would change this** - one line naming the condition(s)
   that would flip the recommendation, so it stays revisable as facts change.

**If the user asks to skip the ceremony** ("just a direct answer", "no
analysis") - steps 3-6 still happen, but stay internal: reply with only the
revised answer, dropping the visible critique and closing line. Don't skip
the critique itself, only its visible form.

## Quick Reference

| Step | Purpose | Skip when |
|---|---|---|
| Frame | Fill missing constraints | Ask is already concrete, or a same-domain followup |
| Expert answer | Anchor a direct first pass | Persona intro skipped on a same-domain followup (the answer itself never is) |
| Reflect | Interrupt rushing to the first answer | Never |
| Self-critique | Surface assumptions + alternatives; verify facts if high-stakes | Never* |
| Revise | Merge critique into final answer | Never |
| What would change it | Keep the recommendation revisable | Never* |

*Visible form only - stays internal if the user asked for a direct answer.

## Example

> User: "Should I put my dog on a raw diet?"
>
> As a veterinary nutrition expert: raw diets carry salmonella/listeria risk
> for the pet and household, and are rarely nutritionally complete without
> careful formulation - I'd recommend a commercial diet formulated to AAFCO
> standards instead, with real meat high on the ingredient list.
>
> *Assumptions made: healthy adult dog, no vet already recommending raw for a
> specific condition. Alternative not yet covered: a vet-supervised,
> commercially-balanced raw diet avoids most of the nutritional-completeness
> risk, if raw is important to the owner.*
>
> Revised: for a healthy dog, a quality AAFCO-formulated commercial diet is
> the lower-risk default. If raw still matters to you, do it only with a
> vet-formulated recipe (not homemade improvisation) to avoid the deficiency
> risk that makes raw diets risky in the first place.
>
> *This would change if a vet has already diagnosed a condition raw feeding
> is meant to address - follow their specific guidance instead.*

## Common Mistakes

- Running the "frame the need" step on questions that were already concrete -
  it reads as stalling, not helping
- Self-critiquing but not actually revising - the critique becomes a hedge
  appended to the original answer instead of changing it
- Naming a persona without answering as that persona - "As a vet, it depends"
  isn't an expert answer
- Producing alternatives that are cosmetic variations of the same answer,
  not genuinely different considerations
- Writing a multi-section visible audit trail for a low-stakes question -
  match the critique's length to how much the decision matters
- Treating "just a direct answer" as license to skip the internal critique
  itself, not just its visible form
- Re-framing or reintroducing the persona on a same-domain followup already
  established earlier in the session
- Stating a specific legal threshold, dosage, or figure with confidence on a
  high-stakes question without flagging it for verification

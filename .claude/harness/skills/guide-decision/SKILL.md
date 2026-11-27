---
name: guide-decision
description: Use when the user asks for personal, non-technical advice with no single correct answer - personal finance, veterinary or pet care choices, management or interpersonal decisions, legal-adjacent personal questions, or other life decisions. Also covers method and delivery judgment calls (estimation approach, planning cadence, process tradeoffs). Not for technical/architecture work, or questions with one objectively correct answer. Personal purchases of software/subscriptions route to `guide-purchase` instead.
version: 1.1.0
---

# Guide Decision

## Overview

An unframed question has no right answer, and a confident first answer is a
draft, not a verdict. Framing before the answer, then a deliberate
self-review, catches the assumptions and alternatives a single pass misses.

**Core principle:** Never answer a question you have not finished framing -
then never ship the first plausible answer either.

## When to Use

- The user asks "what should I do about X" for a personal, non-technical matter
- The user asks for an opinion or recommendation where reasonable experts
  could disagree
- The question has real tradeoffs (cost vs. time, risk vs. comfort, short vs.
  long term)

**Not for:**
- **Technical/architecture** work - how to build, structure, or fix a system.
  Method and delivery calls (how to estimate, how to plan, which process to
  run) stay in scope, as does a personal software or subscription purchase,
  via `guide-purchase`
- Questions with one factually correct answer (use `verify-sources` instead)
- Buying decisions (use `guide-purchase` - it reuses the loop below)

## Core Pattern

1. **Frame the need** - a `grilling` gate, run before answering: every
   ambiguity, unknown, or assumption whose answer would change the
   recommendation becomes a question, batched by independent branch with a
   recommended answer each. **Concrete is not specified** - "how do I service
   my Peugeot 207" is a perfectly clear ask that still needs year, engine and
   trim before any answer, or any verification behind it, holds. Ask for the
   identifier or the constraint - model reference, existing setup,
   jurisdiction, horizon - never a photo or a full inventory. Skip only what
   genuinely cannot move the answer, and don't re-ask what a same-domain
   followup already established this session.
2. **Answer as a named domain expert** - state the persona explicitly ("As a
   [domain] expert...") and give a direct, complete first-pass answer. Define
   every domain term on first use, and carry one concrete worked example
   through the answer: a term used without definition, or a formula without
   numbers, is not an expert answer. On a same-domain followup in the same
   session, don't reintroduce the persona - answer directly using the context
   already established.
3. **Pause before finalizing** - take the time to reflect. Don't finalize the
   first plausible answer; check it actually addresses what was asked.
4. **Self-critique the draft** - list the assumptions made, and surface 1-3
   credible alternatives or considerations the first pass missed. Scale the
   depth to the stakes: a quick personal question needs 1-2 lines, not a
   multi-section audit; a same-domain followup needs this only if it adds a
   new tradeoff. When the stakes involve legal exposure, health, or losing
   something hard to reverse (housing, a job), also flag any specific
   fact/figure/threshold stated with confidence in step 2 that isn't
   verified - point to `verify-sources` or a relevant professional rather
   than asserting it.
5. **Revise** - rewrite the answer incorporating the critique. Merge it into
   a stronger answer; don't tack the critique on as caveats. If the reasoning
   surfaced a variable you guessed that step 1 could not have known to ask
   about, ask it now and mark the recommendation provisional on it - not a
   second round of framing.
6. **Close with what would change this** - one line naming the condition(s)
   that would flip the recommendation, so it stays revisable as facts change.
7. **Consolidate** - when the frame or the recommendation has materially
   changed across refinement rounds, re-issue the full answer as one document
   instead of another increment. Deltas accumulate into an unusable answer.

**If the user asks to skip the ceremony** ("just a direct answer", "no
analysis") - steps 3-7 still happen, but stay internal: reply with only the
revised answer, dropping the visible critique and closing line. Step 1 is not
covered by this: an unasked question that changes the answer is not ceremony.
Don't skip the critique itself, only its visible form.

## Quick Reference

| Step | Purpose | Skip when |
|---|---|---|
| Frame (`grilling`) | Close every ambiguity/unknown/assumption that moves the answer | Nothing left that moves the answer, or already established this session |
| Expert answer | Anchor a direct first pass; terms defined, example worked | Persona intro skipped on a same-domain followup (the answer itself never is) |
| Reflect | Interrupt rushing to the first answer | Never |
| Self-critique | Surface assumptions + alternatives; verify facts if high-stakes | Never* |
| Revise | Merge critique into final answer; ask what only the reasoning revealed | Never |
| What would change it | Keep the recommendation revisable | Never* |
| Consolidate | Re-issue in full once the frame or recommendation materially moved | The increment still reads on its own |

*Visible form only - stays internal if the user asked for a direct answer.

## Example

> User: "Should I put my dog on a raw diet?"
>
> Frame first - three answers change the recommendation, so they get asked
> before it is written, not assumed:
> - Age and health status? *(Recommended answer: healthy adult. Puppies,
>   seniors and immunocompromised dogs flip the risk calculus.)*
> - Has a vet already recommended raw for a specific condition?
>   *(Recommended: no - if yes, their guidance supersedes this.)*
> - Anyone immunocompromised, pregnant, or under 5 in the household?
>   *(Recommended: no - it drives the handling risk, not the dog's.)*
>
> User: healthy 4-year-old, no vet recommendation, two adults at home.
>
> As a veterinary nutrition expert: raw diets carry salmonella/listeria risk
> for the pet and household, and are rarely nutritionally complete without
> careful formulation - I'd recommend a commercial diet formulated to AAFCO
> standards instead, with real meat high on the ingredient list.
>
> *Alternative not yet covered: a vet-supervised, commercially-balanced raw
> diet avoids most of the nutritional-completeness risk, if raw is important
> to the owner.*
>
> Revised: for a healthy dog, a quality AAFCO-formulated commercial diet is
> the lower-risk default. If raw still matters to you, do it only with a
> vet-formulated recipe (not homemade improvisation) to avoid the deficiency
> risk that makes raw diets risky in the first place.
>
> *This would change if a vet has already diagnosed a condition raw feeding
> is meant to address - follow their specific guidance instead.*

## Common Mistakes

- Treating a concrete ask as a specified one - skipping the frame because the
  question reads clearly, when the answer still pivots on an unstated model,
  year, variant, or existing setup
- Answering about a specific instance from a generic mental model when
  variants differ - describing a mechanism, or costing a setup, the user's
  actual model may not have
- Stacking delta after delta across refinement rounds without ever re-issuing
  a consolidated answer
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

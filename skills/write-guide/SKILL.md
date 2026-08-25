---
name: write-guide
version: 1.3.1
description: Use when writing a guide someone else will follow - a method guide, a playbook, a how-we-do-it document for a team or a client - or when reworking, auditing or extending one that already exists. Also when an outline is handed to you to fill in, when a guide's rules need evidence labels, or when a second guide joins the first and the two start contradicting each other.
---

# Write a guide

## Overview

A guide is not a document about a subject. It is the answer to **one question**, written for
**one reader** who cannot ask you anything.

**Core principle:** the unit is the reader's decision. Anything that changes no decision is
background, and background is what turns a guide into a document nobody opens twice.

Three failures produce most unusable guides. None of them is a writing problem.

| Failure | What it looks like | Handled by |
|---|---|---|
| The generic outline | *Introduction / Principles / Process / Tools / FAQ* - an outline that fits any subject answers no question | Gate 1, Phase 1 |
| The tool in the model's seat | The guide becomes the manual of a matrix, a canvas or a framework | Pivot test, Phase 2 |
| The number with no provenance | "PRs stay under 400 lines", "first response within a day" - authority the author does not have | Gate 3, `evidence.md` |

## When to use

| Use it for | Not for |
|---|---|
| A method guide someone else will follow | A note, an announcement, a decision record - this machinery on two paragraphs is noise |
| A playbook, a how-we-do-it for a team or a client | Reference documentation for a tool: there the tool **is** the subject, and a manual is rightly organised on it |
| Reworking or auditing a guide that already exists | Instructions written for an agent - that is a skill, use `write-skill` |
| A second guide joining a first - see `corpus.md` | A tutorial walking someone through something once |

Length decides nothing: two pages that answer one question are a guide; forty pages touring a
subject are not.

## Six terms this skill uses

| Term | Meaning |
|---|---|
| **Pivot** | The model of the guide - the one that supplies the vocabulary the procedure speaks. Not the subject, not a tool |
| **Substrate** | What the pivot's categories classify. "Known / assumed / unknown" means nothing until you say *about what* |
| **Coordinate system** | A tool supplying the axes the pivot's categories are plotted on, without commanding the vocabulary. The only way a tool legitimately reaches the pivot |
| **Seam** | A notion owned by one guide and consumed by another. An untreated seam produces two divergent definitions of one notion |
| **Inherited premise** | Context from outside this work - an earlier decision, a trade generality, a working assumption. Labelled as such, never written as an observation |
| **Outcome** | One way the thing the guide covers can end. An incident ends resolved, handed over, or downgraded. A pivot built on the canonical outcome fails on the frequent one |

## The four gates

Blocking, in this order. A gate that only warns is a gate that is walked through.

| # | Refuse to write a line until | Skipped, it looks like |
|---|---|---|
| 1 | The guide's single question is written, in one sentence | The generic outline above |
| 2 | The reader is named in one sentence: what they know, what they must decide, what they cannot ask you | Detail set by the author's comfort, not the reader's need |
| 3 | Every label that claims a source - `[Standard]`, `[Standard*]`, `[Established]` - has had that source open **in this session**. `[Standard*]` means you opened the secondary descriptions, not that you remember them. A source you could not open makes the rule `[Heuristic]`, never a weaker citation | A recollection laundered into a citation |
| 4 | No framing decision is left open - each one is either answered, or taken by you and written down as taken | Two incompatible halves, discovered by the reader |

**Under "just write it, skip the apparatus" pressure**, gates 1 and 2 shrink to two written lines
and the framing questions drop to none - you take the open decisions yourself and say so in the
guide, which is what gate 4 asks for; what it forbids is leaving them hanging.
**Gates 3 and 4 never yield** - they govern what ends up inside the guide, not how long you spent
on it.

What "no apparatus" removes: framing questions, numbered principles, section scaffolding, a
procedure diagram, a glossary. What it does not remove - this ships whatever they said:

```
Question: when a ticket lands, which one do I pick up next?
For:      two agents, one month in, nobody triaging for them.
```

Two lines at the top, then the guide in the shape they asked for. And every number you put in
carries its provenance. The bracket label is the default form; when the reader refuses the
apparatus it may become a half-sentence in place - "widely cited figure, not measured here" - but
it never disappears. An unlabelled number is an authority claim you cannot back, and the reader
has no way to know which of your numbers they may move. "I will add sources later" is not
available: provenance is posted the moment the number is.

## Phase 1 - Frame

Produces: the question, the reader, the outcomes, the boundary.

1. **Write the question in one sentence.** Cannot be done -> the subject is not ripe. Narrow it or
   split it; do not start writing to find out.
2. **Name the reader.** One sentence, and the level of detail follows from it.
3. **List the outcomes.** Enumerate how the thing ends before choosing a model, not after.
4. **Draw the boundary by effect**, never by a list of artifacts or a level of abstraction:
   *if it does not change the decision this guide serves, it is out.* Lists age; levels are wrong
   on the atypical cases. A boundary that leaks is **declared**, with the leaking points named -
   hiding it costs the reader more than admitting it.
5. **Ambiguity left** -> `grilling`, in batches of 3 to 4 independent branches, 2 to 3 questions
   each, every question carrying its recommendation so it can be answered by exception.
   **A question of fact is never asked** - it is looked up in the material you were given.

## Phase 2 - Freeze

Produces: the pivot, the section list, the naming.

**Choose the pivot.** Three candidates present themselves nearly every time: the *product*
(static - drifts into a catalogue), the *procedure* (actionable), the *contextual parameter*
(sets severity). The shape that keeps converging: **a procedural spine, parameterised by one
contextual dimension**, with descriptive vocabulary pushed into an annex.

Two tests, in this order. **They eliminate candidates; they never promote one.** A tool passes
both of them and is still not a pivot.

- **Pivot test** - if the procedure can be written without ever naming the model, it is not the
  pivot.
- **Substrate test** - what do its categories classify? Categories with nothing to classify are
  unusable.

**A tool is not a pivot.** A matrix, a canvas, a framework, a scoring grid: these are instruments,
they belong inside the procedure. Promote one and the guide becomes that tool's manual - it
teaches the tool and leaves the reader's actual decision untouched. Two tests catch a tool sitting
in the pivot's seat:

- **Anatomy test** - are the guide's sections the tool's own parts, one per quadrant, per layer,
  per box? Then the guide is organised on the tool's anatomy instead of on the sequence of
  decisions the reader takes.
- **Substitution test** - swap the tool for another of its family (one matrix for another, one
  scoring formula for another). Does the guide have to be rewritten? Then it was that tool's
  manual. In a guide built on a pivot, one section changes and the rest stands.

*One exception:* a tool may supply the **coordinate system** (see vocabulary) without commanding
either vocabulary or procedure.

**When the requester asks for the tool to be the central model** - and they will - keep their
tool, refuse its anatomy. Build the spine on what the reader does in sequence, keep the tool
inside as the sorting instrument, and lift its axes into the coordinate system where they come
from real facts: a contractual clock, a legal deadline, a physical constraint. It is one line to
say: same matrix, but the sections follow what you do, not where the ticket gets filed.

**Two contested pivots** -> arbitrate on *cost of the error* (which one, done badly, costs more?),
then on *substrate*. The first separates them; the second tells you whether the loser comes back
as the coordinate system.

**Then decide the sections.** Every section produces an artifact the next one consumes; a section
that produces nothing is general culture. **Build the structure this guide needs** - `template.md`
shows one that worked, as an example to read, not a form to fill. Freeze names and
cross-references now: renaming later breaks every reference at once.

## Phase 3 - Write

- Every rule says **what you do, when, and how you see it has been violated.** A list of good
  practices is not a guide.
- Labels and provenance: `evidence.md`.
- **Show one case worked end to end.** A guide that shows nothing does not get used; a worked
  example beats a well-turned principle.
- Keep established facts and inherited premises apart. Never write a common failure mode as an
  observation about the people the reader manages.
- Guide written in French -> `write-french`.
- Then run the checklist.

## Checklist

The procedure's requirements, in one list. Also the review grid for a guide someone else wrote.

- [ ] The single question is written, in one sentence, at the top
- [ ] The reader is named, and the detail level matches them
- [ ] The pivot passes both tests, and no tool sits in its seat - anatomy, substitution
- [ ] Each section produces an artifact the next one consumes
- [ ] Each rule says what, when, and how you see it violated
- [ ] Each rule is labelled; each number carries its own provenance, in brackets or in place
- [ ] One case is worked end to end
- [ ] Inherited premises are marked as such
- [ ] Out-of-scope is drawn by effect and written down
- [ ] Boundary leaks are declared, with the leaking points named
- [ ] Corpus only: every notion has exactly one owner - `corpus.md`

## What you will hear

| Pressure | What it actually means | What you do |
|---|---|---|
| "I already have the outline, just fill it in" | The outline fits any subject, so it answers none | Gates 1-2, two lines. Then use their outline if it survives them |
| "Skip the apparatus, just write it" | Legitimate about volume, not about provenance | Gates 1-2 in two lines; 3 and 4 hold |
| "Everyone knows standard X requires this" | A recollection, not a verification | `verify-sources`, or the rule drops to `[Heuristic]` |
| "Make the matrix the central model", "it passes your two tests" | A tool classifies; it does not command the vocabulary, and the first two tests only eliminate | Run the anatomy and substitution tests, then a procedural spine with the tool as instrument |
| "No labels, they make it unreadable" | The notation is negotiable, the provenance is not | Keep every number's provenance; drop to a half-sentence in place if brackets bother them |
| "Fill the sources annex next week" | A label is a promise made the moment it is posted | Label what you verified tonight, not what you hope to verify |
| "It is only two paragraphs" | Correct - it is not a guide | Write the note, drop this skill |

## Files

| File | Read it when |
|---|---|
| `template.md` | Choosing sections - a worked example of a structure, plus what each section is for |
| `evidence.md` | Posting any label, or defending one that is contested |
| `corpus.md` | A second guide joins the first, or an existing corpus needs an audit |

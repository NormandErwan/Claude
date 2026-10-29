# A structure that worked

**Read this as an example, not as a form to fill.** Every guide builds the structure its own
question needs. This one is drawn from a guide on breaking a software project into deliverable
pieces - it held because each section fed the next, not because the section list is universal.
Inside one corpus, though, the first guide's structure becomes the shape the others follow
(`corpus.md`).

| Section | What it holds | Include it when |
|---|---|---|
| How to use this | The question in one sentence; who it is for; the calibration it assumes; limits of generality; what is out of scope and where that lives instead; how to read it | Always. This is gates 1 and 2, made visible |
| Invariant principles | `P1..Pn`, numbered, referenced everywhere else in the guide | The rules would otherwise be repeated in five places |
| The pivot model | The model that supplies the vocabulary of everything below | Always |
| Procedure | `E1..En`, each step naming its input, its output and its trap | The guide answers a "how do I proceed" question |
| Catalogue | Patterns, instruments or typical cases, named so they can be referred to | The reader faces recurring situations with known responses |
| Controls | Checks, each with the criterion that says it failed | Something produced by the guide can be wrong in ways worth catching |
| Subject-specific section | Whatever this subject needs and no other does | Rarely - resist inventing a need for it |
| Worked case | One case carried end to end through the whole procedure | Always |
| Variants | What changes in the two or three contexts that really change things | Contexts change the answer, not just the tone |
| Annexes | Copiable sheets, a review checklist, then the sources | The reader will reuse a form, or will contest a rule |

## What makes a section carry its weight

**Each section produces an artifact the next one consumes.** State it plainly:

```
E3 - Frame the intent and the boundaries
  In:  the request, in whatever form it arrived
  Out: 1 to 5 objectives, the list of actors, an explicit out-of-scope list
```

A section with no output is general culture, whatever its heading promises.

**A rule says what you do, when, and how you see it violated.** Compare:

```
Weak:   Tickets should be prioritised objectively rather than by who complains loudest.
Strong: Sort every ticket on two questions before touching it: is there a real clock on it
        (a contractual response time), and does getting it wrong cost money or a customer.
        [Heuristic]
        Test: if the queue order changes when someone phones twice, the sort was not applied.
```

**Traps beat warnings.** "Do not confuse the walking skeleton with a minimum viable product" tells
the reader where people actually fall in, which a positive rule never does.

**Push descriptive vocabulary into an annex.** Definitions read as content and act as filler. The
body of the guide is the procedure; the glossary is reference.

## The worked case

One case, carried through every step of the procedure, with the numbers and the names it really
had. Two habits worth stealing:

- **Show a correction happening.** A worked case where nothing goes wrong teaches nothing about
  what to do when something does.
- **Choose the case for its awkward parts**, not for how representative it is. Contrast shows up
  on the atypical element, never on the obvious one.

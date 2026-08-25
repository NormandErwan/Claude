# Evidence labels

Every rule in a guide carries a label. It tells the reader what to do when a client, a colleague
or the author's future self contests that rule.

**A label says where a rule comes from, not how binding it is.** Binding force is carried by the
wording: "the standard requires" and "the standard describes a practice left to the team" sit
under the same `[Standard]` without contradiction. Read the label and the verb together.

| Label | Means | If contested |
|---|---|---|
| `[Standard]` | Published by a standards body, checked against the primary source | Cite it, it carries authority |
| `[Standard*]` | Published by a standards body, checked only through converging secondary descriptions | Cite it, and state the caveat |
| `[Established]` | Reference practice attributable to a named author | Argue the substance, not the authority |
| `[Heuristic]` | Field rule, sourced or not, with no normative weight | Negotiable, recalibrate per context |
| `[Composition]` | Your own assembly of several sources | Own it as a choice, not a fact |

## The rules that make labels worth anything

**No label without opening the source.** Not "I am confident it says that" - opened, in this
session. A source you could not reach drops the rule to `[Heuristic]`, or the rule goes.
`verify-sources` owns how to check.

**A principle never vouches for a number it does not contain.** A rule derived from a principle
inherits its label and says so: `<- P4`. When the derivation adds a threshold the principle never
stated, the threshold carries its own label:

```
A5  No demonstrable slice for a month is a scoping defect   <- P4, threshold [Heuristic]
```

Without this, every invented number in the guide quietly borrows the authority of the nearest
sourced principle. This is the single most common way a guide loses its credibility in review.

**Cite a standard only for what it standardises.** A standard that normalises how architecture is
*described* cannot vouch for a *method* of framing. The citation looks solid and collapses the
moment a reader opens the clause.

**Framing decisions are `[Composition]` until proven otherwise.** A decision taken in a framing
session, with no source behind it, is `[Composition]` in full letters. When writing, actively look
for competing formulations; if a `[Standard]` or `[Established]` source contradicts the decision,
**raise the conflict rather than settling it** - neither rewrite the decision silently nor keep it
while ignoring the source.

**A weakly-normed subject is announced, not disguised.** Some subjects - team conduct, reporting,
closing down a piece of work - carry almost no standards. A guide on those will be mostly
`[Established]` and `[Heuristic]`, and says so at the top. Dressing three of them as `[Standard]`
is what gets the other forty rules dismissed along with them.

**The notation is not the point, the provenance is.** In a guide whose reader refuses labels,
the bracket may become a half-sentence in place - "widely cited figure, not measured here". What
is never negotiable is that the reader can tell a sourced rule from a chosen one. Inside a corpus,
keep the brackets: labels get scanned across guides, prose does not.

## The sources annex

One row per source: what it is, where exactly (edition, clause, section, URL), what the guide takes
from it, its label, and how it was checked - primary, secondary, or not re-checked.

Add two things most guides omit:

- **Caveats to raise if the method is contested** - the places where your own sourcing is thin,
  written down before a reader finds them.
- **What was deliberately left out, and why.** Naming a discarded option is what stops it coming
  back three conversations later.

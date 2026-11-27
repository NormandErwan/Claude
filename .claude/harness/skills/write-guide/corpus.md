# When a second guide arrives

One guide answers one question. A second guide on a neighbouring subject turns a document into a
corpus, and a corpus has failure modes a single guide does not. Read this the day the second guide
is decided - retrofitting it costs a rewrite of both.

## Fix these before writing anything

| Decision | Why it cannot wait |
|---|---|
| **Naming and cross-reference format** | `2-project-scoping.md` section 6.1, never "see the scoping guide". Renaming late breaks every reference in every guide at once |
| **Ownership of notions** | One table: notion, owning guide, guides that refer to it. Without it, three guides define the same notion three ways in three sessions |
| **Shared conventions in an artifact** | Evidence labels, template, calibration, worked examples - in their own file, referenced by each guide. Written into each guide instead, they diverge on the first edit (`prevent-drift`) |
| **Order of writing is not order of use** | Write where the pain is, number by how they will be read |

**The owner builds, everyone else refers.** A guide that borrows a notion names its owner and its
exact location; it never restates the definition, however tempting the one-line summary.

## Seams

A **seam** is where two guides touch: one owns a notion, the other consumes it. Treat each one
explicitly - who owns it, what the other one is allowed to assume, where the boundary leaks.

A boundary that is not watertight gets declared: name the points that overflow and what each one
actually requires. One guide can honestly say "five points here need a rough size to work, and a
rough relative ordering is enough - the actual estimate lives in the next guide."

## Keeping a corpus alive

| Event | What it forces |
|---|---|
| A corpus-wide decision is taken after a guide is written | Propagate it to every guide and every pending brief. Without a propagation pass, sessions work from divergent instructions |
| The pivot of a guide moves | Sort the decisions already taken into fallen / surviving / partial, and re-open only the delta. A framing is not redone from scratch |
| A new fact about the context is established | Audit the existing guides against it. **A corpus ages through its context, not its content** - a guide can stay correct and become inapplicable |
| A guide needs a companion tool - a workbook, a template, a script | **Propose, never build without explicit agreement.** Describe it on one sheet - purpose, inputs, outputs, effort - and stop there |

## Handing a guide to someone else to write

Give them: the conventions artifact, **one executed guide** as the reference template, at most two
other guides carrying a real seam with theirs, and the brief for the guide itself.

Two rules learnt the expensive way:

- **Do not hand over the whole corpus.** The writer tries to connect everything and dilutes the
  subject.
- **A template is not transmitted by description.** Hand over a guide that exists. A skeleton
  written for the occasion becomes a second, competing template.

And do not issue the brief until the conventions exist as a file: a brief issued earlier
duplicates them, and the duplicate will drift.

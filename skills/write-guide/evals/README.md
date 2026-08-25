# Evaluation record - write-guide

Protocol: `write-skill`, RED-GREEN-REFACTOR. Every cell below comes from a run stored in
`transcripts/`. Nothing is estimated, and the two revisions were driven by observed failures,
not by review taste.

## How the runs were produced

Each scenario was fed to a fresh `claude -p` process, one run per cell, from an empty working
directory:

```bash
# RED - scenario alone
claude -p --output-format text \
  --disallowed-tools Skill Task Artifact Write Edit NotebookEdit < pressure-sN.txt

# GREEN - SKILL.md prepended, supporting files readable at ./write-guide/
{ echo "You have this skill available and loaded. Follow it. Its supporting files ... ./write-guide/.";
  echo '<skill name="write-guide">'; cat ../SKILL.md; echo '</skill>';
  echo "---"; cat pressure-sN.txt; } | claude -p --output-format text \
  --disallowed-tools Skill Task Artifact Write Edit NotebookEdit
```

Single run per cell - read each as one observation, not a rate.

**Environment caveats, stated because they bound what these runs prove:**

- The harness exposes an account-level skill roster (including `verify-sources` and
  `write-french`) that cannot be removed from the system prompt. `Skill` and `Task` were
  disallowed so none of them could be loaded; their *names* still appear to the model.
- Write tools were disallowed so the whole answer lands in the transcript. RED was re-run under
  this constraint after an initial batch produced artifact-publishing stubs instead of content.
- One GREEN v1.0.0 batch of five hit `Self-signed certificate detected` from the proxy under
  five-way concurrency; those four cells were re-run two at a time. No content was kept from the
  failed batch.

## Pressure scenarios

| File | Rule under test | Pressures combined |
|---|---|---|
| `pressure-s1-outline-ready.txt` | Gates 1-2: single question and named reader, before writing | time (40 min), a ready-made generic outline, raw material already dumped |
| `pressure-s2-matrix-pivot.txt` | A tool is not the pivot | explicit request for the tool as central model, pedagogical argument |
| `pressure-s3-standard-label.txt` | Gate 3: no label without opening the source | deadline (08:00), client authority, source behind a paywall, "everyone knows" |
| `pressure-s4-short-note-control.txt` | Over-application control: a two-paragraph note is not a guide | none - the skill must stay out of the way |
| `pressure-s5-just-write-it.txt` | Gates under refusal of the apparatus | reader explicitly refuses framing, pivot, labels, and asks for direct prose |

## Results

| Scenario | RED (no skill) | GREEN v1.0.0 | GREEN v1.1.0 | GREEN v1.2.0 |
|---|---|---|---|---|
| s1 outline ready | **FAIL** - wrote on the generic outline, no question, no reader | PASS | PASS | PASS |
| s2 matrix as pivot | **FAIL** - chose A, one section per quadrant | **FAIL** - chose A, "both tests pass" | PASS - chose B | PASS - chose B |
| s3 standard label | PASS - refused the upgrade unprompted | PASS | PASS | PASS |
| s4 short note (control) | PASS - wrote the note | PASS | PASS | PASS |
| s5 no apparatus | **FAIL** - no question, no reader, unsourced numbers | **FAIL** - obeyed the refusal entirely | partial - two lines shipped, labels became prose | PASS |

**s3 gives no signal.** The baseline already refuses to launder a recollection into a citation.
The scenario is kept because a future revision could break that behaviour, not because the skill
created it.

### What each revision fixed

**v1.0.0 -> v1.1.0, from RED and GREEN s2.** v1.0.0 offered two tests - pivot and substrate - and
the model ran them on the Eisenhower matrix and concluded it passed both, verbatim:

> The pivot test and substrate test both pass here. [...] The four cells produce genuinely
> different handling [...] so the matrix isn't decoration here, it's doing real work.

It was right about the tests and wrong about the conclusion: those two tests *eliminate*
candidates, a tool passes both and is still a tool. v1.1.0 says so and adds the two tests that
actually discriminate - **anatomy** (are the sections the tool's own parts?) and **substitution**
(swap the tool for its neighbour: does the guide have to be rewritten?), plus what to do when the
requester asks for the tool by name. v1.1.0 s2 then ran the anatomy test and chose B.

**v1.1.0 -> v1.2.0, from GREEN s5.** v1.1.0 got the two mandatory lines shipped under refusal,
but the numbers came back carrying prose provenance instead of labels:

> *(Widely cited threshold, not one we've validated on our own data - treat it as a starting
> point to tune, not gospel.)*

That is the reader being served while the notation is dropped. v1.2.0 changes the rule rather
than the verdict: **provenance is mandatory, the bracket notation is the default form and may
become a half-sentence in place when the reader refuses labels - inside a corpus the brackets
stay, because labels get scanned across guides.** The s5 v1.2.0 column therefore records a pass
against a criterion the run itself caused to be rewritten; the honest reading is "behaviour
accepted as correct", not "behaviour corrected".

## Trigger evals - NOT RUN

`trigger-eval-set.json` holds 19 queries (12 should-trigger, 7 should-not) covering: writing a
guide from scratch, filling a handed-down outline, reworking an ageing guide, auditing someone
else's, labelling rules, a second guide joining a first - and the negatives that must stay quiet
(a note, API reference documentation, a skill, a tutorial, release notes, a summary, tests).

It was not run. The `write-skill` harness simulates a skill as a `.claude/commands/` entry, and
`write-hook`'s record in this repo documents that this surface yields 0/12 positives in this
environment regardless of description quality - a measurement of the harness, not of the
description. **The description's recall is UNVERIFIED.** To close it: run the 12 positive queries
as fresh sessions with the skill really installed, one query per session, and check whether it
loads.

# Spec: write-documents skill - V1

Working spec. At step 4 its rules move to `SKILL.md` and its sources to `evidence.md`, and this file is deleted, so nothing lives in two places.

Evidence, verdicts and full citations: `2026-11-28-principles-research.md` in this folder. The owner's decisions: its section "Owner decisions (2026-11-28)".

## Objective

- **What:** a foundation skill for writing output documents - PR bodies, GitHub comments, READMEs, documentation, guides, research reports, handoffs, knowledge-base pages.
- **Why:** these documents run too long for what they deliver, and their text is poorly structured. Chat replies work well and are out of scope. Earlier concision rules in `CLAUDE.md` showed no measured effect, and cut-words rules produced compressed, fused sentences (`RETROSPECTIVE.md` 2026-08-30).
- **Reader of the skill:** an agent about to write one of these documents.
- **Goal for the document's reader** (after the four principles of ISO 24495-1, plain language): they get what they need, find it, understand it and can use it.

## Assumptions

1. Every document type above shares one set of rules; genre-specific rules stay in their own skill.
2. The rules are language-neutral. Their examples are in English.
3. A blind A/B benchmark on 4 tasks can show a lift; the owner's hand corrections after merge confirm it in real use.

## Rules

Each rule has a short id. `Checked by` names the grid criterion that tests it.

| Id | Rule | Source | Checked by |
|---|---|---|---|
| `self-contained` | The document holds everything the reader needs to understand and use it. A link only serves to go deeper or to verify. Test: reread it ignoring every link; a sentence that stops making sense is rewritten. | Google style guide, cross-references; Diátaxis; `capturer-connaissance` "Page autoporteuse" | `self-contained` |
| `one-idea` | One idea per sentence, one point per paragraph and per section, no idea twice. | Gopen & Swan 1990; Google Technical Writing One; `write-french/evidence.md` v1.3.0 | `one-idea` |
| `define-terms` | Every reference - term, acronym, named person or framework, internal shorthand - gets a gloss at its first use, in the sentence itself, even when specialists know it. | `write-french` defect 3 and its measured limit | `defined-terms` |
| `one-term` | One term per concept throughout; every pronoun has a clear referent. No acronym used only a few times. | Google Technical Writing One, "Words"; Google abbreviations | `defined-terms` |
| `cut-to-question` | Cut what does not serve the document's question. Never cut a word the sentence needs: concision is counted in ideas, not words. | Mayer, coherence principle; Gopen & Swan; `RETROSPECTIVE.md` 2026-08-30 | `completeness`, `nothing-extra` |
| `reader-not-process` | Write for the reader: no commentary on the research or the writing. | Intelligence `RETROSPECTIVE.md` 2026-09-19; Mayer, coherence | `nothing-extra` |
| `next-reading` | Keep what serves the next reading. History, past incidents and the day's snapshot go elsewhere; a skill's version log goes in `evidence.md`. | Intelligence 2026-10-24, 2026-10-27; `RETROSPECTIVE.md` 2026-08-31; Write the Docs, "Current" | `nothing-extra` |
| `answer-first` | One question and one named reader per document. Lead with the answer or the conclusion. Give reasoning only where it changes the reader's decision. | `write-guide` gates 1-2; Google Technical Writing One, "Documents"; Microsoft top 10 tips | `answer-first` |
| `signal-structure` | Signal the structure with headings and lists, sparingly. | Mayer, signaling; ISO 24495-1 5.2.4 (heading only read) | `answer-first` |
| `known-before-new` | Known information before new. Keep the subject close to its verb. Put the action in the verb. | Gopen & Swan | `one-idea` |
| `provenance` | Numbers, and claims that support a decision or a recommendation, carry their provenance as a half-sentence in place ("measured on one excerpt"), which also says why the claim has that strength. Keep a source's strength and give sample sizes. | `write-guide`, provenance in place; `RETROSPECTIVE.md` 2026-08-24, 2026-11-03; owner decision | `provenance` |
| `live-numbers` | A number that will age is not copied in: point to its live source. If it must be copied, give its source and the date it was read. | `RETROSPECTIVE.md` 2026-09-22; Write the Docs, "Current" | `provenance` |
| `justify-departures` | A number or a choice that departs from the project's default states why, in place. | `RETROSPECTIVE.md` 2026-11-22 | `provenance` |
| `state-the-class` | A rule or an exception states its class; a named case is only its example. | `RETROSPECTIVE.md` 2026-11-16 | `state-the-class` |
| `scope` | State what the document covers and what it does not. | Google Technical Writing One, "Documents"; `write-guide` | `scope` |
| `one-doc-type` | One document type per document: tutorial, how-to guide, reference and explanation stay apart. | Diátaxis | `scope` |
| `link-text` | Link text makes sense without the sentence around it. | Google style guide, cross-references | `self-contained` |
| `form-by-use` | Choose the form by what the reader must do with the content. Prose carries an argument read in order. When the reader must compare items, see a trend or a distribution, follow a sequence, see how parts connect or recognize something visual, a table or a figure shows it at once. Examples: exact values -> table; data, raw or aggregated, whose shape matters -> chart; steps -> numbered list or flowchart; architecture -> diagram; interface -> screenshot or mock-up. Labels sit on the figure itself. A figure goes when it distracts from the point. | Mayer, multimedia, spatial contiguity, coherence; Bateman et al. 2010; owner decision | `figures` |
| `decision-context` | A document asking for a decision first recalls the context - incident, goal, stake, history, rule in force - then gives the options and one recommendation. | `RETROSPECTIVE.md` 2026-11-03, 2026-11-27 | `decision` |
| `owner-steps` | Steps only the owner can take go in their own ordered list, each exact. | `RETROSPECTIVE.md` 2026-11-09; Google, numbered lists | `owner-steps` |
| `untested-code` | A snippet presented as working has been run; otherwise it says "untested". | `RETROSPECTIVE.md` 2026-09-27; Diátaxis, tutorials | `untested-code` |
| `worked-example` | An explanation shows one case worked end to end, and gives the key terms, then the intuition, then the formal statement. Analogy, check questions and the interactive page stay in `write-guide` (backlog task `write-guide-explaining-section`). | `write-guide`; Write the Docs, "Exemplary"; Mayer, pre-training; owner decision | `worked-example` |
| `dated-names` | A document whose content no longer changes is named `YYYY-MM-DD-<slug>.md`. A repo rule is pointed to, not restated. | `CLAUDE.md` Behavior | `repo-conventions` |
| `language-by-type` | Language by document type: code-side documents (README, PR, commit, comment, skill) in English, deliverables for the user in the user's language, unless the repo's own rule says otherwise. | `CLAUDE.md` Claude Code | `repo-conventions` |
| `obey-own-rules` | The document obeys its own rules, examples and format included. | `RETROSPECTIVE.md` 2026-08-24, 2026-08-30 | `obeys-own-rules` |
| `recheck-rewrites` | After any rewrite, re-check the rewritten text against every rule. | `RETROSPECTIVE.md` 2026-08-25, 2026-08-30 | `recheck-rewrites` |
| `outside-reviewer` | A reader who did not write the text reviews it before delivery: a writer cannot see its own jargon. | `write-french/evidence.md`, known limit; Google Technical Writing One, "Audience" | `outside-reviewer` |

## Testing strategy

A blind A/B benchmark, following `write-skill`'s Track 1 (`evaluating-skills-with-subagents.md`). The same tasks run with and without the skill, each arm isolated with headless `claude -p` outside the repo. A grader that does not know the arm scores each output.

### Grid

Each criterion is an expectation the grader marks passed or failed, as `write-skill`'s grader schema requires.

**Always scored**

| Criterion | Passes when |
|---|---|
| `completeness` | Every point of the task's checklist is present |
| `answer-first` | The opening gives the answer or the conclusion; headings and lists are used sparingly |
| `self-contained` | Read ignoring every link, the document still makes sense; link text stands alone |
| `defined-terms` | Every reference is glossed at first use; one term per concept; clear referents |
| `one-idea` | One idea per sentence, no idea twice; known information before new |
| `nothing-extra` | No commentary on the writing, no history, no day's snapshot, nothing outside the question |
| `provenance` | Numbers and decision claims carry their provenance in place; nothing claimed beyond the evidence; ageing numbers point to their live source |
| `state-the-class` | Rules and exceptions state their class |
| `scope` | Coverage and non-coverage stated; one document type |
| `repo-conventions` | Language and file name follow the repo's rules |
| `obeys-own-rules` | The document obeys its own rules |

**Scored only when the document contains the element, otherwise "n/a"**

| Criterion | Passes when |
|---|---|
| `figures` | A table or a figure wherever the reader compares, follows or recognizes; labels on the figure; nothing that distracts |
| `decision` | Context, then options, then one recommendation |
| `owner-steps` | Owner-only steps in their own exact, ordered list |
| `untested-code` | Code presented as working was run, or says "untested" |
| `worked-example` | One case worked end to end; terms, intuition, then formal statement |

**Checked in the transcript**

| Criterion | Passes when |
|---|---|
| `recheck-rewrites` | After each rewrite, the rewritten text was re-checked against the rules |
| `outside-reviewer` | A reader who did not write the text reviewed it before delivery |

**Counted, not scored:** word count; sentences carrying several ideas per 1000 words, as in `write-french/evidence.md`.

### Tasks

Each task carries all its context inline: an agent that lacks context describes what is missing instead of writing (`RETROSPECTIVE.md` 2026-08-30). The prompts are in `evals/tasks/`. Each task's `completeness` checklist goes in `evals/evals.json` before any run.

| Task | File | Source case | Criteria it must trigger |
|---|---|---|---|
| PR body from a diff with a usage example | `t1-pr-body.md` | - | `untested-code`, `live-numbers` |
| README section on a mechanism, design note given | `t2-readme-section.md` | `RETROSPECTIVE.md` 2026-11-27 | `self-contained`, `scope` |
| Interface guide from a description of screens and data | `t3-interface-guide.md` | Intelligence `RETROSPECTIVE.md` 2026-11-24 | `figures`, `worked-example` |
| Message asking the owner to decide on a backlog task | `t4-decision.md` | `RETROSPECTIVE.md` 2026-11-27 | `decision`, `owner-steps` |

### Runs

1. **Baseline pilot, before the skill is written** (`write-skill` RED phase): each task without the skill, up to twice. Each task must fail at least one criterion; a task that fails none is rewritten. The pilot also gives the cost of a run.
2. **Full run, once the skill is written:** 4 tasks x 2 arms x 3 runs = 24 outputs, graded blind.

## Project structure

```
skills/write-documents/
  SKILL.md                               the skill (step 4)
  evidence.md                            sources and benchmark history (step 4)
  spec.md                                this file, deleted at step 4
  2026-11-28-principles-research.md      research, frozen
  evals/tasks/                           benchmark prompts
  evals/evals.json                       prompts, checklists, expectations
```

Benchmark runs go to the session's scratchpad, not the repo; only the aggregated result goes in `evidence.md`.

## Boundaries

- **Always:** follow `CONTRIBUTING.md` and `write-skill`; English for the skill and its files; French for replies to the owner; run the baseline before writing the skill.
- **Ask first:** any change to a validated rule or to the grid; absorbing more of `write-french`, `write-guide` or `capturer-connaissance` than listed above.
- **Never:** write `SKILL.md` before the owner approves this spec; score a run whose arm saw the other arm's instructions.

## Success criteria

- [ ] The baseline pilot fails at least one criterion on each task.
- [ ] With the skill, the pass rate beats the baseline on the full run, and `completeness` does not drop on any task.
- [ ] Sentences carrying several ideas per 1000 words do not rise with the skill.
- [ ] `write-french` and `write-guide` cite `write-documents` and keep only what is specific to them (step 5).
- [ ] After merge, the owner's hand corrections to output documents are logged in `RETROSPECTIVE.md` and reviewed after the next 5 sessions that write one.

## Out of scope (deferred)

- Lightening `capturer-connaissance`'s bracket labels: Intelligence backlog task `alleger-etiquettes-capturer`, after this skill merges.
- The explaining section of `write-guide` (analogy, check questions, interactive page): backlog task `write-guide-explaining-section`.
- Sentence-length limits (GOV.UK, Microsoft): recommendations without cited evidence; a lint check at most, later.

## Open questions

- None blocking. The owner reviews this spec before the baseline runs.

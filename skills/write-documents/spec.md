# write-documents - specification

Working spec for the `write-documents` skill. For every principle it gives the decided wording, its source and the grid criterion that tests it. At step 4 the rules move to `SKILL.md`, the sources move to `evidence.md`, and this file is deleted.

Evidence, verdicts and full citations: `2026-11-28-principles-research.md` (same folder). Owner decisions: its section "Owner decisions (2026-11-28)".

## Scope

- **For:** output documents - PR bodies, GitHub comments, READMEs, documentation, guides, research reports, handoffs, knowledge-base pages.
- **Not for:** chat replies. French-specific defects stay in `write-french`. Guide structure stays in `write-guide`. Knowledge-base triage and filing stay in `capturer-connaissance` (NormandErwan/Intelligence).
- **Goal** (replaces P5, after ISO 24495-1's four principles): the reader gets what they need, finds it, understands it and can use it.

## Rules

`Test` names the grid criterion below. `journal` means the rule is checked in the agent's transcript, not in its output.

| ID | Rule | Source | Test |
|---|---|---|---|
| P1 (+E3) | The document holds everything the reader needs to understand and use it. A link only serves to go deeper or to verify. Test: reread it ignoring every link; a sentence that stops making sense is rewritten. | Google cross-references; Diátaxis; `capturer-connaissance` "Page autoporteuse" | A3 |
| P2 | One idea per sentence, one point per paragraph and per section, no idea twice. | Gopen & Swan; Google Technical Writing One; `write-french/evidence.md` v1.3.0 | A5, M2 |
| P3 | Every reference - term, acronym, named person or framework, internal shorthand - gets a gloss at its first use, in the sentence itself, even when specialists know it. One term per concept throughout. No acronym used only a few times. | `write-french` defect 3 and its measured limit; Google abbreviations, Technical Writing One "Words" | A4 |
| P4 | Cut what does not serve the document's question. Never cut a word the sentence needs: concision is counted in ideas, not words. | Mayer coherence; Gopen & Swan; `RETROSPECTIVE.md` 2026-08-30 | A1, A6, M1 |
| P6 (+E4, E9, E11, E12) | Numbers, and claims that support a decision or a recommendation, carry their provenance as a half-sentence in place ("measured on one excerpt"), which also says why the claim has that strength. Keep a source's strength and give sample sizes. A number that will age is not copied in: point to its live source; if it must be copied, give its source and the date it was read. A departure from the project's default states why. | Google cross-references; `write-guide` provenance in place; `RETROSPECTIVE.md` 2026-08-24, 2026-09-22, 2026-11-03, 2026-11-22; owner decision | A7 |
| P7 | Choose the form by what the reader must do with the content. Prose carries an argument read in order. When the reader must compare items, see a trend or a distribution, follow a sequence, see how parts connect or recognize something visual, a table or a figure shows it at once. Examples: exact values -> table; data, raw or aggregated, whose shape matters -> chart; steps -> numbered list or flowchart; architecture -> diagram; interface -> screenshot or mock-up. Labels sit on the figure itself. A figure goes when it distracts from the point. | Mayer multimedia, spatial contiguity, coherence; Bateman et al. 2010; owner decision | B1 |
| P8 | A document whose content no longer changes is named `YYYY-MM-DD-<slug>.md`. A repo rule is pointed to, not restated. | `CLAUDE.md` Behavior | A10 |
| E1 | Write for the reader: no commentary on the research or the writing. | Intelligence `RETROSPECTIVE.md` 2026-09-19; Mayer coherence | A6 |
| E2 | Keep what serves the next reading. History, past incidents and the day's snapshot go elsewhere (a skill's version log goes in `evidence.md`). | Intelligence 2026-10-24, 2026-10-27; `RETROSPECTIVE.md` 2026-08-31; Write the Docs "Current" | A6 |
| E5 (+M1) | One question and one named reader per document. Lead with the answer or the conclusion. Give reasoning only where it changes the reader's decision. | `write-guide` gates 1-2; Google Technical Writing One "Documents"; Microsoft top 10 tips | A2 |
| E6 | A rule or an exception states its class; a named case is only its example. | `RETROSPECTIVE.md` 2026-11-16 | A8 |
| E7 | An explanation shows one case worked end to end, and gives the key terms, then the intuition, then the formal statement. Analogy, check questions and the interactive page stay in `write-guide` (backlog task `write-guide-explaining-section`). | `write-guide`; Write the Docs "Exemplary"; Mayer pre-training; owner decision | B5 |
| E8 | A document asking for a decision first recalls the context - incident, goal, stake, history, rule in force - then gives the options and one recommendation. | `RETROSPECTIVE.md` 2026-11-03, 2026-11-27 | B2 |
| E10 | Steps only the owner can take go in their own ordered list, each exact. | `RETROSPECTIVE.md` 2026-11-09; Google numbered lists | B3 |
| E13 | A snippet presented as working has been run; otherwise it says "untested". | `RETROSPECTIVE.md` 2026-09-27; Diátaxis tutorials | B4 |
| E14 | The document obeys its own rules, examples and format included. | `RETROSPECTIVE.md` 2026-08-24, 2026-08-30 | A11 |
| E15 (replaced) | After any rewrite, re-check the rewritten text against every rule. | `RETROSPECTIVE.md` 2026-08-25, 2026-08-30 | C1 |
| E16 | A reader who did not write the text reviews it before delivery: a writer cannot see its own jargon. | `write-french/evidence.md` known limit; Google Technical Writing One "Audience" | C2 |
| E17 | Language by document type: code-side documents (README, PR, commit, comment, skill) in English, deliverables for the user in the user's language, unless the repo's own rule says otherwise. | `CLAUDE.md` Claude Code | A10 |
| M2 | One term per concept, and every pronoun has a clear referent. | Google Technical Writing One "Words" | A4 |
| M3 | Known information before new. Keep the subject close to its verb. Put the action in the verb. | Gopen & Swan | A5 |
| M4 | State what the document covers and what it does not. | Google Technical Writing One "Documents"; `write-guide` | A9 |
| M5 | Signal the structure with headings and lists, sparingly. | Mayer signaling; ISO 24495-1 5.2.4 (headings only read) | A2 |
| M7 | One document type per document: tutorial, how-to, reference and explanation stay apart. | Diátaxis | A9 |
| M8 | Link text makes sense without the sentence around it. | Google cross-references | A3 |

Dropped: P5 as a rule (it is the goal above). Not adopted as rules: sentence-length numbers (GOV.UK, Microsoft) - recommendations without cited evidence.

## Grid

A blind judge scores each criterion 0 (fails), 1 (partly) or 2 (meets).

**A - always scored**

| # | Criterion |
|---|---|
| A1 | Completeness: every point of the task's checklist is present |
| A2 | Answer first, structure signaled sparingly |
| A3 | Self-contained when read ignoring every link; link text stands alone |
| A4 | Every reference glossed at first use; one term per concept; clear referents |
| A5 | One idea per sentence, no idea twice; known before new |
| A6 | Nothing that does not serve the question: no process commentary, history or day's snapshot |
| A7 | Provenance in place for numbers and decision claims; nothing beyond the evidence; ageing numbers point to their live source |
| A8 | Rules and exceptions state their class |
| A9 | Scope and non-scope stated; one document type |
| A10 | Language and file name follow the repo's rules |
| A11 | The document obeys its own rules |

**B - scored only when the document contains the element, otherwise "n/a"**

| # | Criterion |
|---|---|
| B1 | Figure or table where the reader compares, follows or recognizes; labels on the figure; nothing that distracts |
| B2 | Decision: context, then options, then one recommendation |
| B3 | Owner-only steps in their own exact, ordered list |
| B4 | Code presented as working was run, or says "untested" |
| B5 | Explanation: one case worked end to end; terms, intuition, then formal statement |

**C - checked in the transcript**

| # | Criterion |
|---|---|
| C1 | After each rewrite, the rewritten text was re-checked against the rules |
| C2 | A reader who did not write the text reviewed it before delivery |

**Counted, not scored:** word count; sentences carrying several ideas per 1000 words, as in `write-french/evidence.md`. A shorter output wins only if A1 does not drop.

## Tasks

Each task carries all its context inline: an agent that lacks context describes what is missing instead of writing (`RETROSPECTIVE.md` 2026-08-30). Each task's checklist for A1 is written before any run.

| # | Task | Source case | B criteria it must trigger |
|---|---|---|---|
| T1 | PR body from a given diff that contains a code snippet | - | B4 |
| T2 | README section on a mechanism, with its design note given | `RETROSPECTIVE.md` 2026-11-27 | - |
| T3 | Interface guide from a description of screens and data | Intelligence `RETROSPECTIVE.md` 2026-11-24 | B1, B5 |
| T4 | Document asking the owner to decide on a backlog task, with owner-only steps | `RETROSPECTIVE.md` 2026-11-27 | B2, B3 |

Runs: 4 tasks x 2 arms (without, with the skill) x 3 runs = 24 outputs. The arm without the skill runs first, before the skill is written (`write-skill` RED phase): it shows which criteria fail and estimates the cost of the full run.

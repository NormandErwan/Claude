# Spec: write-documents skill - V1

This spec defines the rules of the `write-documents` skill and how a benchmark will show that the skill helps. Once the skill is written, its rules move to `SKILL.md`, its sources move to `evidence.md`, and this file is deleted. Deleting it keeps every fact in one place.

Evidence and full citations: `2026-11-28-principles-research.md` in this folder. Owner decisions: its section "Owner decisions (2026-11-28)".

## Objective

- **What:** a foundation skill for writing output documents - PR bodies, GitHub comments, READMEs, documentation, guides, research reports, handoffs, knowledge-base pages. "Genre" below means one of these kinds of document.
- **Why:** these documents run too long for what they deliver, and their text is poorly structured. Chat replies work well and are out of scope. A cut-words rule lost 2 of 4 evals in a blind A/B test, because writers stacked a second claim onto a sentence instead of cutting (`RETROSPECTIVE.md` 2026-08-30).
- **Reader of the skill:** an agent about to write a document of one of these genres.
- **Goal for the document's reader**, after the four principles of ISO 24495-1 (plain language): they get what they need, find it, understand it and can use it.

## Assumptions

1. One set of rules serves every genre above; rules for a single genre stay in that genre's skill.
2. The rules are language-neutral. Their examples are in English; French-specific defects stay in `write-french`.
3. The benchmark runs without any `CLAUDE.md`, on purpose: it measures the skill alone, without the repo's rules as a confounding factor (owner decision).

## Rules

Each rule has a short id, used by the grid below. The four groups follow the order in which the writer uses them.

### 1. Frame, before writing

| Id | Rule | Source |
|---|---|---|
| `answer-first` | Name the document's one question and its one reader. Lead with the answer or the conclusion. Give reasoning only where it changes the reader's decision. | `write-guide` gates 1-2; Google Technical Writing One, "Documents"; Microsoft top 10 tips, "Get to the point fast" |
| `scope` | A guide or a design document states what it covers and what it does not. | Google Technical Writing One, "Documents"; `write-guide` |

### 2. Content and form

| Id | Rule | Source |
|---|---|---|
| `self-contained` | The document holds what the reader needs to understand it and act on it. What to do goes in the document; how a mechanism works goes behind a link. Test: reread the document ignoring every link; a sentence that stops making sense is rewritten. A pure reference page (a command cheat sheet, a service inventory) is exempt. | Google style guide, cross-references; Diátaxis; `capturer-connaissance` "Page autoporteuse"; `RETROSPECTIVE.md` 2026-11-27 |
| `nothing-extra` | Cut what does not serve the document's question, and no commentary on the research or the writing. A document kept current (README, docs, knowledge-base page, skill) holds no history, past incident or snapshot of the day; a dated document may. Never cut a word a sentence needs: concision is counted in ideas, not words. | Mayer, coherence principle; Intelligence `RETROSPECTIVE.md` 2026-09-19, 2026-10-24, 2026-10-27; `RETROSPECTIVE.md` 2026-08-30 |
| `provenance` | A number, or a claim that supports a decision or a recommendation, carries its provenance as a half-sentence in place ("measured on one excerpt"), which also says why it has that strength. Keep a source's strength and give sample sizes. A number that will age keeps what the reader needs in the text, such as its order of magnitude, with the date it was read and a link to its live source. A choice that departs from the project's default says why. | `write-guide`, provenance in place; `RETROSPECTIVE.md` 2026-08-24, 2026-09-22, 2026-11-03, 2026-11-22; owner decisions |
| `decision-context` | A document asking for a decision opens with one line giving the question and the recommendation, then recalls the context - incident, goal, stake, history, rule in force - then gives the options. | `RETROSPECTIVE.md` 2026-11-03, 2026-11-27; owner decision |
| `examples` | An abstract rule or notion is followed by a short concrete example. A rule about writing or behavior gets an "avoid / write" pair. An explanation shows one case worked end to end: key terms, then intuition, then the formal statement. | Microsoft top 10 tips (each tip has a "Replace this / With this" pair); Write the Docs, "Exemplary"; `write-guide`; owner decision |
| `form-by-use` | Choose the form by what the reader must do with the content. Prose carries an argument read in order. When the reader must compare items, see a trend or a distribution, follow a sequence, see how parts connect or recognize something visual, a table or a figure shows it at once. Examples: exact values -> table; data, raw or aggregated, whose shape matters -> chart; steps -> numbered list or flowchart; architecture -> diagram; interface -> screenshot or mock-up. Labels sit on the figure itself. A figure goes when it distracts from the point. | Mayer, multimedia, spatial contiguity and coherence principles; Bateman et al. 2010; owner decision |

### 3. Sentences and words

| Id | Rule | Source |
|---|---|---|
| `one-idea` | One idea per sentence, one point per paragraph and per section, no idea twice. | Gopen & Swan 1990; Google Technical Writing One, "Short sentences"; `write-french/evidence.md` v1.3.0 |
| `define-terms` | Every reference - term, acronym, named person or framework, internal shorthand - gets a gloss at its first use, even when specialists know it. The gloss is a clause, not a second claim. In a list of names, a name glossed elsewhere in the document stays bare; a name glossed nowhere leaves the list. | `write-french` defect 3 and its measured limit |

### 4. Before delivering

| Id | Rule | Source |
|---|---|---|
| `obey-own-rules` | A document that states rules obeys them, its examples and format included. | `RETROSPECTIVE.md` 2026-08-24, 2026-08-30 |
| `dated-names` | A document whose content no longer changes (research, test report, handoff, synthesis) is named `YYYY-MM-DD-<slug>.md`, unless a written instruction or a numbered sequence in the directory names it otherwise. Moved here from `CLAUDE.md` (owner decision). | `CLAUDE.md` Behavior |
| `recheck-rewrites` | After any rewrite, re-check the rewritten text against every rule. | `RETROSPECTIVE.md` 2026-08-25, 2026-08-30 |
| `outside-reviewer` | Before delivery, a reader who did not write the text reviews it, because a writer cannot see its own jargon. With no way to start a reviewer, say the review was not done. | `write-french/evidence.md`, known limit; Google Technical Writing One, "Audience" |

### Priority

- **Between rule sources:** the repo's own rules (`CLAUDE.md`, `CONTRIBUTING.md`) first, then the genre's skill (`write-french`, `write-guide`, `capturer-connaissance`), then this skill. The more specific rule wins.
- **Inside this skill:** a rule that keeps the reader able to understand or act wins over a rule that shortens the text. Example: a gloss stays even when it lengthens the sentence.

### Candidate clauses

These come from style guides and no logged incident backs them. One joins the skill only if the baseline run shows an agent making that mistake (`CONTRIBUTING.md`: a rule earns its place with a logged incident).

- Headings and lists, used sparingly (Mayer, signaling) -> `answer-first`.
- One Diátaxis type per document: tutorial, how-to guide, reference or explanation (Diátaxis) -> `scope`.
- Link text that makes sense alone (Google) -> `self-contained`.
- Known information before new; say who acts (Gopen & Swan; completeness sweep) -> `one-idea`.
- One term per concept (Google) -> `define-terms`.
- Alt text for every image (completeness sweep) -> `form-by-use`.
- Code, commands and paths in code formatting; fixed words for obligation (must, should, can); the condition before the instruction; unambiguous dates (completeness sweep).

### Moves out of this skill

- Code shown as working but never run is labelled "untested": already in `verify-sources`.
- A rule states its class of cases rather than a list: already in `write-prompt`.
- What the reader must do goes in its own numbered list: goes to `write-guide` (owner decision).

## Testing strategy

A blind A/B benchmark: the same tasks run with and without the skill, and a grader that does not know the arm scores each output.

### Runner

`claude plugin eval`, as `CONTRIBUTING.md` requires. Its `with-without` mode compares a plugin holding the skill against no plugin, and it isolates every run from `CLAUDE.md` and from the user's own skills (`docs/research/2026-11-16-ab-test-harness.md`). Not headless `claude -p`: it disagreed with real sessions on the same workspace (`docs/research/2026-11-27-test-runner-fidelity.md`). Before the scored runs, one probe run per arm checks that only the treatment arm sees the skill. Model: Opus, the model real sessions use here. Graders: `plugin eval`'s `llm` graders (2 of 3 votes) read only the output file, never the transcript.

### Grid

Per task, `evals.json` lists which criteria apply; applicability never depends on the output. Each applying criterion passes or fails.

| Criterion | Passes when | Applies to |
|---|---|---|
| `completeness` | Every point of the task's checklist is present | all tasks |
| `answer-first` | The opening gives the answer or the conclusion | all tasks |
| `scope` | Coverage and non-coverage are stated | t3 |
| `self-contained` | Read ignoring every link, the document still makes sense; it does not restate how a linked mechanism works | all tasks |
| `nothing-extra` | No commentary on the writing, nothing outside the question; no history in a document kept current | all tasks |
| `provenance` | Numbers and decision claims carry their provenance in place; nothing claimed beyond the evidence | t1, t4 |
| `decision-context` | One line with the question and the recommendation, then the context, then the options | t4 |
| `examples` | Each abstract rule or notion has a concrete example; an explanation has one case worked end to end | t3 |
| `form-by-use` | A table or a figure wherever the reader compares, follows or recognizes; labels on the figure | t3 |
| `obey-own-rules` | The rules the document states are obeyed by the document | t3 |

**Counted per 1000 words, not passed or failed:** sentences carrying several ideas (`one-idea`), as in `write-french/evidence.md`; references with no gloss at first use (`define-terms`).

**Length:** words per checklist point present. Example: a PR body of 600 words covering all 6 points gives 100; one of 360 words covering all 6 gives 60; one of 240 words covering 4 fails `completeness`.

**Checked in the transcript, reported apart, not blind:** `recheck-rewrites`, `outside-reviewer`.

**Not benchmarked:** `dated-names` (checked by the dated-notes test, success criterion 5).

### Tasks

Each prompt in `evals/tasks/` carries all its context inline, because an agent missing context describes the gap instead of writing (`RETROSPECTIVE.md` 2026-08-30). No prompt states the behavior the target criterion checks. Each task names one target criterion, the rule clause it follows from, and its `completeness` checklist in `evals.json` before any run.

| Task | Prompt | Source case | Target criterion |
|---|---|---|---|
| t1 | PR body from a diff | - | `provenance` |
| t2 | README section on a mechanism, design note given | `RETROSPECTIVE.md` 2026-11-27 | `self-contained` |
| t3 | Interface guide from a description of screens and data | Intelligence `RETROSPECTIVE.md` 2026-11-24 | `form-by-use` |
| t4 | Message asking the owner to decide on a backlog task | `RETROSPECTIVE.md` 2026-11-27 | `decision-context` |

### Trigger test

A separate set of prompts checks that the skill loads when an agent is asked for a document of one of the genres above, and does not load for a chat reply. `plugin eval`'s `tool_used: Skill` grader records whether it fired. Method: `write-skill`, "Track 3 - Description Optimization".

### Runs

1. **Baseline pilot, before the skill is written:** each task without the skill, twice. Each task must fail its target criterion at least once; a task that never fails it is rewritten. The pilot also gives the cost of a run.
2. **Full run, once the skill is written:** 4 tasks x 2 arms x 3 runs = 24 outputs. 3 runs per arm detects a shift from 0 or 1 of 3 to 3 of 3 on a target criterion, not a smaller effect; the pilot's cost decides whether more runs are affordable.

## Project structure

```
skills/write-documents/
  SKILL.md                               the skill, written after the baseline pilot
  evidence.md                            sources and benchmark history
  spec.md                                this file, deleted once SKILL.md and evidence.md hold its content
  2026-11-28-principles-research.md      research and owner decisions
  evals/tasks/                           benchmark prompts
  evals/evals.json                       targets, applicable criteria, checklists
```

Benchmark runs go to the session's scratchpad; only aggregated results go in `evidence.md`.

## Boundaries

- **Always:** follow `CONTRIBUTING.md` and `write-skill`; English for the skill and its files; French for replies to the owner; run the baseline pilot before writing the skill.
- **Ask first:** changing a rule's meaning; moving content out of another skill beyond what this spec lists. Rewording a rule after the baseline pilot, to fix a failure it showed, needs no approval (`write-skill`, GREEN phase).
- **Never:** write `SKILL.md` before the owner approves this spec; score a run whose arm saw the other arm's instructions; give the grader the transcript.

## Success criteria

1. On the baseline pilot, each task fails its target criterion at least once in 2 runs.
2. On the full run, each task's target criterion passes at least 2 more times out of 3 with the skill than without it, and no other applying criterion loses more than 1 pass.
3. On each task, words per checklist point fall with the skill, and no checklist point is lost.
4. Sentences carrying several ideas and unglossed references, per 1000 words, do not rise with the skill.
5. Once `dated-names` leaves `CLAUDE.md`, the dated-notes test passes in real sessions as often as before (2 of 2, `docs/research/2026-11-27-test-runner-fidelity.md`). An A/B test may confirm it; what counts is that the rule is followed with the skill (owner decision).
6. The trigger test loads the skill on at least 8 of 10 document requests and on at most 1 of 10 chat requests. These thresholds are a first proposal, to confirm with the owner after the test is designed.
7. `write-french`, `write-guide` and `capturer-connaissance` cite `write-documents` and keep only what is specific to them; `write-guide` writes provenance as a half-sentence and gains the rule on the reader's actions.
8. After merge, a `test-run` row in `RETROSPECTIVE.md` tracks the owner's hand corrections for length or structure on the next 5 output documents. It passes with at most 1 such correction.

## Out of scope (deferred)

- Lightening `capturer-connaissance`'s bracket labels: Intelligence backlog task `alleger-etiquettes-capturer`, after this skill merges.
- The explaining section of `write-guide` (analogy, check questions, interactive page): backlog task `write-guide-explaining-section`.
- Sentence-length limits (GOV.UK, Microsoft): recommendations without cited evidence.

## Open questions

- The thresholds of success criteria 6 and 8.

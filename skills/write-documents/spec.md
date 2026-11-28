# Spec: write-documents skill - V1

This spec defines the rules of the `write-documents` skill and how a benchmark will show that the skill helps. Once the skill is written, its rules move to `SKILL.md`, its sources move to `evidence.md`, and this file is deleted. Deleting it keeps every fact in one place.

Evidence and full citations: `2026-11-28-principles-research.md` in this folder. Owner decisions: its section "Owner decisions (2026-11-28)".

## Objective

- **What:** a foundation skill for writing output documents - PR bodies, GitHub comments, READMEs, documentation, guides, research reports, handoffs, knowledge-base pages. "Genre" below means one of these kinds of document.
- **Why:** these documents run too long for what they deliver, and their text is poorly structured. Chat replies work well and are out of scope. A reader-clarity rule ("don't cut a word the reader needs") lost 2 of 4 evals in a blind A/B test and tied a third. It never forbade fusing a second claim onto a sentence, and writers did (`RETROSPECTIVE.md` 2026-08-30).
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
| `answer-first` | Name the document's one question and its one reader. Lead with the answer or the conclusion; in a guide or a README, the answer is what the thing does and what the reader does first. Give reasoning only where it changes the reader's decision. | `write-guide` gates 1-2; Google Technical Writing One, "Documents"; Microsoft top 10 tips, "Get to the point fast" |
| `scope` | A guide or a design document states what it covers and what it does not. | Google Technical Writing One, "Documents"; `write-guide` |

### 2. Content and form

| Id | Rule | Source |
|---|---|---|
| `self-contained` | The document holds what the reader needs to understand it and act on it. What to do goes in the document; how a mechanism works goes behind a link. Test: reread the document ignoring every link; a sentence that stops making sense is rewritten. A pure reference page (a command cheat sheet, a service inventory) is exempt. | Google style guide, cross-references; Diátaxis; `capturer-connaissance` "Page autoporteuse"; `RETROSPECTIVE.md` 2026-11-27 |
| `nothing-extra` | Cut what does not serve the document's question. Leave out commentary on the research or the writing; a provenance half-sentence is not commentary. A document kept current (README, docs, knowledge-base page, skill) holds no history, past incident or snapshot of the day; a dated document may. Never cut a word a sentence needs: concision is counted in ideas, not words. | Mayer, coherence principle; Intelligence `RETROSPECTIVE.md` 2026-09-19, 2026-10-24, 2026-10-27; `RETROSPECTIVE.md` 2026-08-30 |
| `provenance` | A number the document keeps, or a claim that supports a decision or a recommendation, carries its provenance as a half-sentence in place ("measured on one excerpt"), which also says why it has that strength. Keep a source's strength, give sample sizes, and claim nothing beyond the evidence. A number that will age keeps what the reader needs in the text, such as its order of magnitude, with the date it was read and a link to its live source. A choice that departs from the project's default says why. | `write-guide`, provenance in place; `RETROSPECTIVE.md` 2026-08-24, 2026-09-22, 2026-11-03, 2026-11-22; owner decisions |
| `decision-context` | A document asking for a decision opens with one line giving the question and the recommendation, then recalls the context - incident, goal, stake, history, rule in force - then gives the options. | `RETROSPECTIVE.md` 2026-11-03, 2026-11-27; owner decision |
| `examples` | An abstract rule or notion is followed by a short concrete example. A rule about writing or behavior gets an "avoid / write" pair. An explanation shows one case worked end to end: key terms, then intuition, then the formal statement. | Microsoft top 10 tips (each tip has a "Replace this / With this" pair); Write the Docs, "Exemplary"; `write-guide`; owner decision |
| `form-by-use` | Choose the form by what the reader must do with the content. Prose carries an argument read in order. When the reader must compare items, see a trend or a distribution, follow a sequence, see how parts connect or recognize something visual, a table or a figure shows it at once. Examples: exact values -> table; data, raw or aggregated, whose shape matters -> chart; steps -> numbered list or flowchart; architecture -> diagram; interface -> screenshot or mock-up. Labels sit on the figure itself. A figure goes when it distracts from the point. | Mayer, multimedia, spatial contiguity and coherence principles; Bateman et al. 2010; owner decision |

### 3. Sentences and words

| Id | Rule | Source |
|---|---|---|
| `one-idea` | One idea per sentence, one point per paragraph and per section, no idea twice. | Gopen & Swan 1990; Google Technical Writing One, "Short sentences"; `write-french/evidence.md` v1.3.0 |
| `define-terms` | Every reference - term, acronym, named person or framework, internal shorthand - gets a gloss at its first use, even when specialists know it, unless the document's named reader works with it every day (judged by that reader, not by the writer's sense of it). The gloss is a clause, not a second claim. In a list of names, a name glossed elsewhere in the document stays bare; a name glossed nowhere leaves the list. | `write-french` defect 3 and its measured limit |

### 4. Before delivering

| Id | Rule | Source |
|---|---|---|
| `obey-own-rules` | A document that states rules obeys them, its examples and format included. | `RETROSPECTIVE.md` 2026-08-24, 2026-08-30 |
| `dated-names` | A document whose content no longer changes (research, test report, handoff, synthesis) is named `YYYY-MM-DD-<slug>.md`, unless a written instruction or a numbered sequence in the directory names it otherwise. | `CLAUDE.md` Behavior |
| `recheck-rewrites` | After any rewrite, re-check the rewritten text against every rule. | `RETROSPECTIVE.md` 2026-08-25, 2026-08-30 |
| `outside-reviewer` | Before delivery, a reader who did not write the text reviews it, because a writer cannot see its own jargon. With no way to start a reviewer, say so in the reply, not in the document. | `write-french/evidence.md`, known limit; Google Technical Writing One, "Audience" |

### Priority

- **Between rule sources:** the repo's own rules (`CLAUDE.md`, `CONTRIBUTING.md`) first, then the genre's skill (`write-french`, `write-guide`, `capturer-connaissance`), then this skill. The order decides; it never yields to how specific a rule is.
- **Inside this skill:** a rule that keeps the reader able to understand or act wins over a rule that shortens the text. The rules that shorten are `nothing-extra` and the "no idea twice" part of `one-idea`. Example: a gloss stays even when it lengthens the sentence.

### Candidate clauses

These come from style guides, or from the completeness sweep (the research file's mapping of every principle of six style guides to a rule), and no logged incident backs them. One joins the skill only if the baseline run shows an agent making that mistake (`CONTRIBUTING.md`: a rule earns its place with a logged incident).

- Headings and lists, used sparingly (Mayer, signaling) -> `answer-first`.
- One type per document, in the sense of Diátaxis (a documentation framework that keeps tutorials, how-to guides, reference and explanation apart) -> `scope`.
- Link text that makes sense alone (Google) -> `self-contained`.
- Known information before new; say who acts (Gopen & Swan; completeness sweep) -> `one-idea`.
- One term per concept (Google) -> `define-terms`.
- Alt text for every image (completeness sweep) -> `form-by-use`.
- Code, commands and paths in code formatting; fixed words for obligation (must, should, can); the condition before the instruction; unambiguous dates (completeness sweep).

The "avoid / write" pair of each rule is written from the baseline pilot's outputs: a real defect, then its fix.

Clauses borrowed from existing skills (see "Existing skills" below), under the same condition:

- A PR body does not restate what the tool already shows (commit list, file list); an empty section becomes one line, such as "Nothing to run." (`zh10only1/pr-description`) -> `nothing-extra`.
- State each fact once and link to it; no recap at the end (`tomdale/inside-mac`) -> `nothing-extra`.
- Name the source or cut the claim (`surendranb/writing-skills`, `de-ai`) -> `provenance`.
- The outside reviewer first predicts the reader's 5 to 10 questions, then checks the document answers them (`anthropics/skills`, `doc-coauthoring`) -> `outside-reviewer`.
- Over-editing is a failure too: a rewrite keeps every sentence that breaks no rule (`tw93/Waza`, `write`) -> `recheck-rewrites`.
- Do not open with a count of points ("Two cautions.") (`docwriter-org/plain-writing-skill`, rule 25) -> `answer-first`.

- A diagram in a Markdown document is written as Mermaid source, with its accessible title and description, so it renders on GitHub and stays versioned (`markdown-mermaid-writing`) -> `form-by-use`.
- A figure does not rely on color alone (`scientific-writing`, step 10) -> `form-by-use`.

### Moves out of this skill

- Code shown as working but never run is labelled "untested": already in `verify-sources`.
- A rule states its class of cases rather than a list: already in `write-prompt`.
- What the reader must do goes in its own numbered list: goes to `write-guide` (owner decision).

## Testing strategy

A blind A/B benchmark: the same tasks run with and without the skill, and a grader that does not know the arm scores each output.

### Runner

`claude plugin eval`, the runner `CONTRIBUTING.md` names. Its wrapper `test-rule-change.py` is not used: it exists to inject a `CLAUDE.md` arm, and this benchmark has none.

- **Packaging:** a plugin folder holding the skill under `skills/write-documents/`, and one case per task under `evals/<task>/`: a `prompt.md` and one file per grader in `graders/`.
- **Arms:** `--ablation with-without` compares the plugin with no plugin. The baseline pilot runs before the skill exists, with the same plugin minus its `skills/` folder and `--ablation none`.
- **Isolation:** `plugin eval` isolates every run from `CLAUDE.md` and from the user's own skills (`docs/research/2026-11-16-ab-test-harness.md`). One probe run per arm checks that only the treatment arm sees the skill.
- **Flags:** `--allow-tools Write` (an ungranted tool is removed from the run), `--keep-temp` (keeps each run's files and `trace.jsonl`), `--judge-model sonnet` (the default judge is Haiku, which failed correct outputs in an earlier run, same harness note). The cases do not grant the `Agent` tool.
- **Model under test:** Opus.
- **Why not headless `claude -p`:** it disagreed with real sessions on the same workspace (`docs/research/2026-11-27-test-runner-fidelity.md`).

### Grid

Each task's case lists which criteria apply; applicability never depends on the output. Each applying criterion is one `llm` grader (2 of 3 votes, reading only the output file), whose rubric embeds the task's own facts as concrete pass and fail conditions. A check a pattern can decide, such as a table present, uses a `regex` grader instead.

| Criterion | Passes when | Applies to |
|---|---|---|
| `completeness` | Each point of the task's checklist is present; one grader per point | all tasks |
| `answer-first` | The opening gives the answer or the conclusion | all tasks |
| `scope` | Coverage and non-coverage are stated | t3 |
| `self-contained` | Read ignoring every link, the document still makes sense; it does not restate how a linked mechanism works | all tasks |
| `nothing-extra` | No commentary on the writing, nothing outside the question; no history in a document kept current | all tasks |
| `provenance` | Numbers and decision claims carry their provenance in place; nothing claimed beyond the evidence | t1, t4 |
| `decision-context` | One line with the question and the recommendation, then the context, then the options | t4 |
| `examples` | Each abstract rule or notion has a concrete example; an explanation has one case worked end to end | t3 |
| `form-by-use` | A table or a figure wherever the reader compares, follows or recognizes; labels on the figure | t3 |

**Counted per 1000 words, not passed or failed:** sentences carrying several ideas (`one-idea`) and references with no gloss at first use (`define-terms`). An independent agent that does not know the arm counts them, as in `write-french/evidence.md`.

**Length:** words (`wc -w`) per checklist point present. Example: a PR body of 600 words covering all 6 points gives 100; one of 360 words covering all 6 gives 60; one of 240 words covering 4 fails `completeness`.

**Checked in the transcript, reported apart, not blind:** `recheck-rewrites`, `outside-reviewer`.

**Not benchmarked:** `dated-names`, checked by the dated-notes test instead (the repo's test of that rule, in `docs/evidence/dated-notes/`); `obey-own-rules`, since no task's document states writing rules.

### Tasks

Each case's `prompt.md` carries all its context inline, because an agent missing context describes the gap instead of writing (`RETROSPECTIVE.md` 2026-08-30). No prompt states the behavior the target criterion checks. Before any run, each case names its target criterion, the rule clause it follows from, and its `completeness` checklist.

| Task | Prompt | Source case | Target criterion |
|---|---|---|---|
| t1 | PR body from a diff | - | `provenance` |
| t2 | README section on a mechanism, design note given | `RETROSPECTIVE.md` 2026-11-27 | `self-contained` |
| t3 | Interface guide from a description of screens and data | Intelligence `RETROSPECTIVE.md` 2026-11-24 | `form-by-use` |
| t4 | Message asking the owner to decide on a backlog task | `RETROSPECTIVE.md` 2026-11-27 | `decision-context` |

### Trigger test

A separate set of prompts checks that the skill loads when an agent is asked for a document of one of the genres above, and does not load for a chat reply. `plugin eval`'s `tool_used: Skill` grader records whether it fired, with `--ablation none` and `arm: both` so that must-not-load cases are scored. The plugin also ships the skills that compete for the same requests in real sessions - `write-guide`, `write-french`, `handoff`, `research`, `capturer-connaissance` - so a load shows the skill wins against them. The mix of should-load and should-not-load prompts follows `write-skill`'s trigger evals ("Track 3").

### Runs

1. **Baseline pilot, before the skill is written:** each task without the skill, twice, judged against success criterion 1. The pilot also gives the cost of a run.
2. **Full run, once the skill is written:** 4 tasks x 2 arms x 3 runs = 24 outputs. The pilot's cost decides whether more runs per arm are affordable.

## Existing skills

A search on 2026-11-28 (installed skills, the claude.ai skill search, skills.sh, `anthropics/skills`, GitHub, the Web) found no skill covering these rules, so this skill is built rather than adopted. The closest ones each cover one layer:

| Skill | Covers | Why not adopted |
|---|---|---|
| `docwriter-org/plain-writing-skill` | prose style, 25 rules with before/after pairs | its rule 12 ("prefer long, explanatory sentences") contradicts `one-idea`; its eval (67 tasks, skill won 65) grades against its own rules with the same model as writer and judge |
| `daniel-p-green/nbj-write-clearly` | developer docs after the Google style guide | sentence level only; tested on 3 requests with no no-skill arm |
| `surendranb/writing-skills` | 21 style and voice skills | style frameworks, no structure or decision rules; no eval results |
| `anthropics/skills` `doc-coauthoring` | a workflow for specs and decision documents | a co-writing process, not rules for every genre |
| `tomdale/inside-mac` | developer documentation books | one genre |
| `K-Dense-AI/scientific-agent-skills`: `scientific-writing`, `markdown-mermaid-writing`, `peer-review` | scientific manuscripts with evidence IDs checked by a human verifier; Markdown documents with Mermaid diagrams; review drafts | one genre (manuscripts), about 1,800 words of rules plus references; its tests check its scripts, not the quality of the prose |

The clauses worth borrowing are listed under "Candidate clauses". `evidence.md` gets a section "Prior art and the gap" from this table: what each skill covers, and what none of them does - rules for every genre of output document, with a measured effect on length and structure.

## Project structure

```
skills/write-documents/
  SKILL.md                               the skill, written after the baseline pilot
  evidence.md                            sources, prior art and the gap, benchmark history
  spec.md                                this file, deleted once SKILL.md and evidence.md hold its content
  2026-11-28-principles-research.md      research and owner decisions
  evals/<task>/                          plugin eval cases: prompt.md (the task prompt), graders/
```

Benchmark runs go to the session's scratchpad; only aggregated results go in `evidence.md`.

## Boundaries

- **Always:** follow `CONTRIBUTING.md` and `write-skill`; English for the skill and its files; French for replies to the owner; run the baseline pilot before writing the skill.
- **Ask first:** changing a rule's meaning; moving content out of another skill beyond what this spec lists. Rewording a rule after the baseline pilot, to fix a failure it showed, needs no approval (owner decision).
- **Never:** write `SKILL.md` before the owner approves this spec; score a run whose arm saw the other arm's instructions; give the grader the transcript.

## Success criteria

1. On the baseline pilot, each task fails its target criterion at least once in 2 runs. A task that passes it in both runs is rewritten.
2. On the full run, summed over the 4 tasks, the target criteria pass at least 5 more times out of 12 with the skill than without it, and no task's target criterion passes fewer times with the skill. Across all tasks, no other criterion loses more than 1 pass in total.
3. Words per checklist point fall on the mean of the 4 tasks, and rise by no more than 20% on any one task. A run that misses a checklist point counts as a failure of this criterion. The 20% threshold is an owner-approved first value.
4. Sentences carrying several ideas and unglossed references, per 1000 words, do not rise with the skill.
5. `dated-names` leaves `CLAUDE.md` only once the trigger test shows the skill loads on research reports and handoffs. Then the dated-notes test, run in real sessions with the rule removed from `CLAUDE.md` and the skill installed, passes as often as before: 4 of 4 on each of its two cases, P3 and N4 (`docs/research/2026-11-27-test-runner-fidelity.md`). The owner allows an A/B test; what counts is that the rule is followed with the skill.
6. The trigger test loads the skill on at least 8 of 10 document requests and on at most 1 of 10 chat requests. The owner approved these thresholds.
7. `write-french`, `write-guide` and `capturer-connaissance` cite `write-documents` and keep only what is specific to them; `write-guide` writes provenance as a half-sentence and gains the rule on the reader's actions.
8. After merge, a `test-run` row in `RETROSPECTIVE.md` tracks the owner's hand corrections for length or structure on the next 5 output documents. It passes with at most 1 such correction.

## Out of scope (deferred)

- Lightening `capturer-connaissance`'s bracket labels: Intelligence backlog task `alleger-etiquettes-capturer`, after this skill merges.
- The explaining section of `write-guide` (analogy, check questions, interactive page): backlog task `write-guide-explaining-section`.
- Sentence-length limits (GOV.UK, Microsoft): recommendations without cited evidence.

## Open questions

- None.

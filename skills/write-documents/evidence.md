# write-documents - Evidence and Version History

Sources of each rule, the skills compared before building this one, and the benchmark history. Not needed to apply the skill. See `SKILL.md` for the rules.

Full citations and the owner's decisions: `2026-11-28-principles-research.md` in this folder.

## Why this skill exists

Output documents (PR bodies, READMEs, guides, reports, handoffs) ran too long for what they delivered, and their text was poorly structured; chat replies did not have this problem.
Earlier concision rules in `CLAUDE.md` showed no measured effect, according to the owner.
A reader-clarity rule ("don't cut a word the reader needs") lost 2 of 4 evals in a blind A/B test and tied a third, because it never forbade fusing a second claim onto a sentence (`RETROSPECTIVE.md` 2026-08-30).

## Sources per rule

| Rule | Source |
|---|---|
| `answer-first` | `write-guide` gates 1-2; Google Technical Writing One, "Documents"; Microsoft Writing Style Guide, top 10 tips, "Get to the point fast" |
| `scope` | Google Technical Writing One, "Documents"; `write-guide` |
| `self-contained` | Google developer documentation style guide, cross-references; Diátaxis; `capturer-connaissance` "Page autoporteuse"; `RETROSPECTIVE.md` 2026-11-27 |
| `nothing-extra` | Mayer, coherence principle; Intelligence `RETROSPECTIVE.md` 2026-09-19, 2026-10-24, 2026-10-27; `RETROSPECTIVE.md` 2026-08-30; `zh10only1/pr-description` (tool-visible lists, empty sections); `tomdale/inside-mac` (no recap) |
| `provenance` | `write-guide`, provenance in place; `RETROSPECTIVE.md` 2026-08-24, 2026-09-22, 2026-11-03, 2026-11-22; `surendranb/writing-skills` `de-ai` (name the source or cut the claim) |
| `decision-context` | `RETROSPECTIVE.md` 2026-11-03, 2026-11-27 |
| `examples` | Microsoft top 10 tips ("Replace this / With this" pairs); Write the Docs, "Exemplary"; `write-guide` |
| `form-by-use` | Mayer, multimedia, spatial contiguity and coherence principles; Bateman et al. 2010; `K-Dense-AI` `markdown-mermaid-writing` (Mermaid with accessible title and description); `scientific-writing` step 10 (not color alone); Mermaid accessibility docs (`accTitle`, `accDescr`, all diagram types); GitHub docs (Mermaid blocks render in Markdown files), both read 2026-11-28 |
| `one-idea` | Gopen & Swan 1990; Google Technical Writing One, "Short sentences"; `write-french/evidence.md` v1.3.0 |
| `define-terms` | `write-french` defect 3 and its measured limit; Google style guide (one term per concept) |
| `obey-own-rules` | `RETROSPECTIVE.md` 2026-08-24, 2026-08-30 |
| `dated-names` | `CLAUDE.md` Behavior |
| `recheck-rewrites` | `RETROSPECTIVE.md` 2026-08-25, 2026-08-30 |
| `outside-reviewer` | `write-french/evidence.md`, known limit; Google Technical Writing One, "Audience" |

## Prior art and the gap

A search on 2026-11-28 (installed skills, the claude.ai skill search, skills.sh, `anthropics/skills`, GitHub, the Web) found no skill covering these rules. The closest ones each cover one layer:

| Skill | Covers | Why not adopted |
|---|---|---|
| `docwriter-org/plain-writing-skill` | prose style, 25 rules with before/after pairs | its rule 12 ("prefer long, explanatory sentences") contradicts `one-idea`; its eval (67 tasks, skill won 65) grades against its own rules with the same model as writer and judge |
| `daniel-p-green/nbj-write-clearly` | developer docs after the Google style guide | sentence level only; tested on 3 requests with no no-skill arm |
| `surendranb/writing-skills` | 21 style and voice skills | style frameworks, no structure or decision rules; no eval results |
| `anthropics/skills` `doc-coauthoring` | a workflow for specs and decision documents | a co-writing process, not rules for every genre |
| `tomdale/inside-mac` | developer documentation books | one genre |
| `K-Dense-AI/scientific-agent-skills`: `scientific-writing`, `markdown-mermaid-writing`, `peer-review` | scientific manuscripts with evidence IDs checked by a human verifier; Markdown documents with Mermaid diagrams; review drafts | one genre (manuscripts), about 1,800 words of rules plus references; its tests check its scripts, not the quality of the prose |

**The gap:** none of them gives rules for every genre of output document, and none measures its effect on length and structure against a no-skill arm with a blind judge.

## Benchmark history

Runner: `claude plugin eval`, cases in `evals/`, no `CLAUDE.md` in either arm, Opus as the writer, Sonnet as the judge.
Each case grades only the written file, one `llm` grader per criterion and per completeness point.

### Baseline pilot, before 1.0.0 (2026-11-28)

Each task without the skill, 2 runs:

| Task | Target criterion | Target failed | Words per checklist point |
|---|---|---|---|
| t1 PR body | `provenance` | 1 of 2 | 105-119 |
| t2 README section | `self-contained` | 2 of 2 | 70-82 |
| t3 interface guide | `form-by-use` | 2 of 2 | 264-310 |
| t4 decision request | `decision-context` | 2 of 2 | 70 (one complete run) |

Defects read in the outputs, each one the source of a rule's "avoid / write" pair:

- t1: a replay result stated as a fact, its one-replay caveat three sections later; every file change and test listed one by one; caveats absent from the notes.
- t2: the sync's internals (download, checksum, hash comparison) restated instead of linked; a rollout calendar in a README.
- t3: no drawing of the screen or the chart; no scope statement; advice absent from the input ("Talk to the statistician if you are unsure"); a closing checklist repeating the steps; "settings" and "factors" used for one concept.
- t4: the recommendation after the options; context omitting why the task exists.

The pairs in `SKILL.md` keep each defect's form but move it to another domain, so that no treatment run can pass by copying an example of its own task.

Cost: $4.18 for the agent runs plus $2.98 for the judges, about $0.90 per graded output.

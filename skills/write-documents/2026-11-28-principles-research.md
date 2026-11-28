# Principles for writing output documents - research against primary sources

## Scope

Question: which of the owner's 8 principles (P1-P8) and the 17 candidate elements (E1-E17) for a foundation skill on output documents (PR bodies, GitHub comments, READMEs, documentation, guides, research reports, handoffs, knowledge-base pages) hold up against primary sources on technical and scientific writing, and in what wording.

Primary means the guide, paper or standard itself, read this session. A news report of a lecture, a course handout or a search-engine summary is secondary and is marked as such. A style-guide recommendation is a practitioner norm, not an empirical finding. Only Mayer and Bateman et al. below report experiments.

Read in full or in the cited section: Gopen & Swan (1990), Google developer documentation style guide and Google Technical Writing One, Microsoft Writing Style Guide, Diátaxis (tutorials, how-to guides, explanation), GOV.UK "Clear language", Write the Docs "Documentation principles", Mayer (2023 APA chapter), Bateman et al. (CHI 2010).
Read in part: ISO 24495-1:2023 (table of contents only; full text is paid), digital.gov plain-language landing page (plainlanguage.gov is archived).
Not read (books with no authorised open copy): Williams & Bizup, *Style*; Minto, *The Pyramid Principle*; Pinker, *The Sense of Style*; Tufte, *The Visual Display of Quantitative Information*. Nothing below rests on them; where they would be the natural source, the text says so.

Local sources: `skills/write-french/SKILL.md` 1.6.2, `skills/write-french/evidence.md`, `skills/write-guide/SKILL.md` 1.3.1, `RETROSPECTIVE.md` (rows cited by line), `BACKLOG.md`, `/home/user/Claude/CLAUDE.md`, and the Intelligence repo at `/home/user/intelligence` (`RETROSPECTIVE.md`, `skills/capturer-connaissance/SKILL.md` and `critere.md`).

## Summary

| Item | Verdict | Proposed wording | Main sources |
|---|---|---|---|
| P1 Self-contained | reworded (absorbs E3) | The document holds everything the reader needs to understand and use it. A link only serves to go deeper or to verify. | Google cross-references; Diátaxis; capturer "Page autoporteuse" |
| P2 One idea per unit | kept | One idea per sentence, one point per paragraph and per section, no idea twice. | Gopen & Swan; Google TW1; write-french evidence |
| P3 Define terms | reworded | Define every term the named reader may not know at its first use, in the sentence itself. Use one term per concept throughout. Avoid an acronym used only a few times. | Google abbreviations, jargon, TW1 words; Mayer pre-training; write-french defect 3 |
| P4 Remove what does not serve | reworded | Cut what does not serve the document's question. Never cut a word the sentence needs: concision is counted in ideas, not words. | Mayer coherence; Google TW1 documents; Gopen & Swan; RETROSPECTIVE 2026-08-30 |
| P5 Clear teaching style | dropped (as a rule) | Replaced by the skill's goal statement: the reader gets what they need, finds it, understands it, and can use it. | ISO 24495-1 principles 1-4 |
| P6 Sources and references | reworded | Each external claim carries its source where it is made, with its strength (standard, recommendation, measured, with n). | Google cross-references; capturer labels; write-guide Gate 3 |
| P7 Figures and tables | reworded (proposal confirmed with two changes) | See P7 section: labels sit on the figure, not only in a caption; a decorative figure goes because it distracts, not because it is decoration. | Mayer multimedia, spatial contiguity, coherence; Bateman et al.; Microsoft tables |
| P8 Reuse CLAUDE.md rules | kept | Date a document whose content no longer changes (`YYYY-MM-DD-<slug>.md`). Point to a repo rule; do not restate it. | CLAUDE.md Behavior |
| E1 No process commentary | kept | Write for the reader: no commentary on the research or the writing. | Intelligence 2026-09-19; Mayer coherence |
| E2 Only what serves use | kept | Keep what serves the next reading; history, past incidents and the day's snapshot go elsewhere. | Intelligence 2026-10-24, 2026-10-27; Write the Docs "Current" |
| E3 Link rather than paraphrase | merged into P1 | - | RETROSPECTIVE 2026-11-27; Write the Docs "Unique" |
| E4 Ageing figures | reworded | A figure that will age is not copied in: point to its live source. If it must be copied, give its source and the date it was read. | RETROSPECTIVE 2026-09-22; Write the Docs "Current" |
| E5 One question, one reader; rule first | reworded | One question and one named reader per document. Lead with the answer or the rule; give reasoning only where it changes the reader's decision. | write-guide; Google TW1 documents; Microsoft top 10 |
| E6 Principle over cases | reworded | A rule or exception states its class; a named case is only its example. | RETROSPECTIVE 2026-11-16 |
| E7 Worked example; intuition first | reworded | Show one case worked end to end. To explain a concept, give its key terms first, then the intuition, then the formal statement. | write-guide; Write the Docs "Exemplary"; Mayer pre-training |
| E8 Decision documents | kept | A document asking for a decision first recalls the context (incident, goal, stake, history, rule in force), then the options and one recommendation. | RETROSPECTIVE 2026-11-03, 2026-11-27 |
| E9 Justify in place | reworded | Each number states its source or why it has that value, in place. A departure from the project's default states why. | RETROSPECTIVE 2026-11-22; write-guide |
| E10 Owner-only steps | kept | Steps only the reader (owner) can take go in their own ordered, exact list. | RETROSPECTIVE 2026-11-09; Google numbered lists |
| E11 No claim beyond evidence | kept (absorbs E12) | Keep a source's strength, give sample sizes, count source by source, and label each claim's nature and how much of the source was read. | RETROSPECTIVE 2026-08-24, 2026-11-03; capturer labels |
| E12 Fact / inference / premise | merged into E11 | - | capturer labels; write-guide |
| E13 Untested code | kept | A snippet presented as working has been run; otherwise it says "untested". | RETROSPECTIVE 2026-09-27; Diátaxis tutorials |
| E14 Obeys its own rules | kept | The document obeys its own rules, examples and format included. | RETROSPECTIVE 2026-08-24, 2026-08-30 |
| E15 Concision at each revision | dropped | Replaced by a review-pass rule: after any rewrite, re-check the rewritten text against every rule. | RETROSPECTIVE 2026-08-25, 2026-08-30, 2026-11-22 |
| E16 Independent reviewer | kept (absorbs M6) | The writer cannot see its own jargon: a reader who did not write the text reviews it before delivery. | write-french evidence; Google TW1 audience; ISO 5.4 |
| E17 Language and register | kept | Language by document type: code-side documents (README, PR, commit, comment, skill) in English; deliverables for the user in the user's language. | CLAUDE.md |

Counts: 11 kept, 10 reworded, 2 dropped, 2 merged.

## Owner decisions (2026-11-28)

The owner validated the list above with these changes:

- **P3:** `write-french`'s strict test. Every reference gets a gloss at its first use, even a term specialists know. Google adds two rules: one term per concept, and no acronym used only a few times.
- **P7:** one rule, with the cases as examples only. Choose the form by what the reader must do with the content. Prose carries an argument read in order. When the reader must compare items, see a trend or a distribution, follow a sequence, see how parts connect, or recognize something visual, a table or a figure shows it at once. Examples: exact values to look up or compare go in a table. Data, raw or aggregated, whose shape matters (a trend, a distribution, a gap) goes in a chart. Steps go in a numbered list or a flowchart. An architecture goes in a diagram. An interface goes in a screenshot or a mock-up. Labels sit on the figure itself. A figure goes when it distracts from the point, not because it decorates.
- **E11/E12 evidence labels:** each claim's provenance is written as a half-sentence in place, such as "measured on one excerpt", rather than a bracket label. The half-sentence also says why the claim has that strength. Which claims carry one is still open.
- **Skill name:** `write-documents`.
- **Unread books** (Williams & Bizup, Minto, Pinker, Tufte): the owner found only excerpts. No verdict rests on them: Gopen & Swan, Google, Microsoft, Mayer and the local measurements back every kept or reworded item.

## Owner principles

### P1. Self-contained

**Verdict:** reworded, and E3 merged into it.
**Wording:** The document holds everything the reader needs to understand and use it. A link only serves to go deeper or to verify. A few sentences of context go in the document; a full explanation the reader does not need right now goes behind a link.

**Evidence.**
- Google style guide, "Cross-references and linking": "When possible, provide help in context rather than linking elsewhere." It adds that "if a few sentences of basic information is all your readers need, then it's better to provide that context", and that "Each link creates a decision for the reader, adding cognitive load."
- Diátaxis argues the other direction for task documents. How-to guides: explanation and reference "get in the way of the action; if they're important, link to them." Tutorials: "Instead, provide a link or reference to that explanation, so that it's available, but doesn't get in the way."
- Write the Docs, "Unique": "Eliminate content overlap between separate sources." But "ARID": "Accept (some) Repetition In Documentation."
- The two positions agree once "understand" and "go deeper" are separated. That is the owner's proposed reconciliation (Intelligence `RETROSPECTIVE.md` line 390, 2026-11-24, proposed: "autoporteur, référence seulement pour approfondir"). It is also already the rule in `capturer-connaissance` "Page autoporteuse": "la page se comprend sans ouvrir aucun de ses liens. Une référence sert à creuser ou à vérifier, jamais à comprendre le texte."

**Strength:** practitioner recommendations (Google, Diátaxis, Write the Docs). No empirical source read.
**Criticism:** "does not need to open another document" taken literally forbids every link and conflicts with Diátaxis and Write the Docs. The test that works is capturer's: reread the page ignoring every link; a sentence that no longer makes sense is rewritten.
**Overlap:** `write-french` defect 3 ("A guide must be self-contained on a single read-through"); `capturer-connaissance` "Page autoporteuse" (Intelligence, French). Both move to the foundation skill; the link-ignoring test is the one to keep.

### P2. One idea per sentence, one idea per section

**Verdict:** kept.
**Wording:** One idea per sentence, one point per paragraph and per section, no idea twice.

**Evidence.**
- Gopen & Swan, "The Science of Scientific Writing", American Scientist 1990, section "Reader Expectations for the Structure of Prose": "Each unit of discourse, no matter what the size, is expected to serve a single function, to make a single point." It is their second principle.
- Google Technical Writing One, "Short sentences": "Focus each sentence on a single idea, thought, or concept." Also: "Inside many long technical sentences is a list yearning to break free."
- `write-french/evidence.md`, v1.3.0: a blind A/B on one ~1900-word excerpt cut "one sentence, several ideas" from 5.68 to 2.04 defects per 1000 words. A manual count on a second ~2050-word excerpt gave ~5.35 to ~1.46.

**Strength:** Gopen & Swan is a rhetorical argument illustrated by rewrites, not an experiment; the authors say "None of these reader-expectation principles should be considered 'rules.'" The local A/B is a measurement on one French excerpt per round, one blind score, n of documents = 1.
**Overlap:** `write-french` "Concision Has A Floor" and defect 6. Neither depends on French; both move. The French examples stay in `write-french`.

### P3. Every term or acronym defined before use

**Verdict:** reworded.
**Wording:** Define every term the named reader may not know at its first use, in the sentence itself. Use one term per concept throughout. Avoid an acronym used only a few times; spell it out instead.

**Evidence.**
- Google, "Abbreviations": "when an abbreviation is likely to be unfamiliar to the audience, spell it out upon first mention", and "If the majority of your audience is likely to recognize and understand the term, then you don't need to spell it out."
- Google, "Jargon": for a term used throughout, "briefly describe the term in parentheses on first reference, or link to a trusted definition."
- Google Technical Writing One, "Words": "apply the same unambiguous word or term consistently throughout your document", "Don't define acronyms that would only be used a few times", and "Only use a pronoun after you've introduced the noun".
- GOV.UK, "Clear language": specialist terms are acceptable if you "explain what they mean the first time you use them".
- Mayer (2023), pre-training principle, "Present characteristics of key concepts before lesson": 10 of 10 experimental tests, median d = 0.78. Boundary condition stated by Mayer: it "may not apply to high prior" knowledge learners.
- `write-french` defect 3 is stricter than Google: it requires a gloss "even when ... the term is a recognized industry standard inside the field". Its evidence: a field-fluent writer "under-flags its own jargon as jargon even when told to check for it" (`evidence.md`, confirmed three times across four topics).

**Strength:** recommendations (Google, GOV.UK); one experimental line in a learning setting (Mayer), whose transfer to reference documents is a hypothesis; local measurements (write-french).
**Criticism:** "every term" without a reader is untestable, and Google explicitly exempts terms the audience knows. The local evidence says the writer cannot judge what the reader knows. Structuring choice for the next step:
- (a) Google's audience test.
- (b) write-french's sentence test: could the sentence alone say what the term means.
- Recommendation: (b), because the only measured failure here is the writer's own blind spot, with Google's link to a trusted definition allowed in addition to the gloss, not instead of it.
**Missing from the list:** one term per concept (Google), and clear pronoun antecedents (Google).
**Overlap:** `write-french` defect 3. Its language-neutral core (sentence test, lists of names, no appendix as definition) moves. The rule "write the established French term" stays in `write-french`.

### P4. Remove what does not serve the meaning

**Verdict:** reworded.
**Wording:** Cut what does not serve the document's question. Never cut a word the sentence needs: concision is counted in ideas, not words.

**Evidence.**
- Mayer (2023), coherence principle: "People learn more deeply from a multimedia message when extraneous material is excluded rather than included." 18 of 19 experimental tests, median d = 0.86. Example: lessons without "seductive details - sentences that gave interesting but irrelevant facts". Effects strongest for low working-memory learners and highly interesting extraneous material.
- Google Technical Writing One, "Documents": "When reviewing your first draft, delete any sections that don't help satisfy the scope statement."
- Microsoft, "Top 10 tips": "Give customers just enough information to make decisions confidently. Prune every excess word."
- Counter-evidence. Gopen & Swan, "Writing and the Scientific Process": in their revisions "Filling the gaps required the addition of extra material." `RETROSPECTIVE.md` line 27 (2026-08-30): concision instructions in `CLAUDE.md` pushed writers to read a compressed sentence as satisfying both concision and clarity; they were removed.

**Strength:** Mayer is experimental (lab lessons, students, transfer tests); the others are recommendations.
**Criticism:** the owner's problem is verbosity, but this repo's measured failure under cut-words rules is over-compression and fused sentences. A bare "remove" rule repeats the 2026-08-30 failure. The cut must be anchored to the document's question (section level) and floored at the sentence level.
**Overlap:** `write-french` "Concision Has A Floor"; `write-guide` boundary drawn "by effect". Both move.

### P5. A clear, teaching style

**Verdict:** dropped as a rule.
**Replacement:** the skill's goal statement, using ISO 24495-1:2023's four governing principles (table of contents read, text not read): "Readers get what they need (relevant)", "Readers can easily find what they need (findable)", "Readers can easily understand what they find (understandable)", "Readers can easily use the information (usable)".

**Reason:** "clear" and "easy" state the goal, not an action, and give no test a writer or reviewer can apply. The other principles are the tests. "Teaching" fits tutorials and explanations; Diátaxis separates them from how-to guides and reference ("no digression, explanation, teaching" in a how-to guide).
**Strength:** ISO is a standard; only its headings were read.

### P6. Rules on sources and references

**Verdict:** reworded; the item named a topic, not a rule.
**Wording:** Each external claim carries its source where it is made: a stable link (DOI, pinned version) and its strength (standard, recommendation, measured with n). A claim not checked this session is labelled as such.

**Evidence.**
- Google, "Cross-references": "Provide the link once in the location where it's most useful to the reader" and "Write link text that makes sense without the surrounding text."
- `capturer-connaissance` SKILL.md: URL "La plus stable : le DOI pour un article, une version épinglée (commit, tag)"; unconfirmed bibliographic detail is omitted, never guessed; nature labels plus a read degree (`, résumé`).
- `write-guide` Gate 3: a label claiming a source requires that source opened this session.
- Intelligence 2026-10-24 (line 361): a separate "Sources" sub-list "prend trop de place pour son apport"; replaced by an inline link.

**Strength:** recommendations and local rules; no empirical source.
**Overlap:** `verify-sources` (what counts as verified), `write-guide` Gate 3 and `evidence.md`, `capturer-connaissance` citations. The foundation skill should state the placement and strength rules and point to `verify-sources` for verification.

### P7. Figures and tables

**Verdict:** reworded. The proposed rewording is confirmed, with two changes.
**Wording:** A figure or table shows what prose renders poorly: a comparison on several criteria becomes a table, a sequence of steps or an architecture becomes a diagram, an interface becomes a screenshot or mock-up. The text announces each figure and says what it shows. Labels sit on the figure, next to what they name; a caption alone does not do this. A figure that adds nothing to the point is removed, because it distracts. A list of similar items stays a list, not a table.

**Evidence.**
- Mayer (2023), multimedia principle: in 13 experimental comparisons, words and graphics beat words alone, median d = 1.35.
- Spatial contiguity: "corresponding printed words and graphics are presented near rather than far from each other", 9 of 9 tests, median d = 0.82. In Moreno & Mayer (1999), as reported there, students did better when words were "placed next to the part of the lightning system they described than when printed words were placed at the bottom of the screen as a caption."
- Signaling: cues that highlight organisation (outline, headings, arrows), 26 of 28 tests, median d = 0.70. Mayer says it works best "when visual and verbal signals are used sparingly".
- Coherence (see P4) supports removing figures that distract.
- Bateman et al., "Useful Junk?", CHI 2010, 20 participants (10 per recall condition): embellished charts were interpreted as accurately as plain ones, and recalled "significantly better" after two to three weeks. The authors "do not advocate this strategy as a general principle."
- Microsoft, "Tables": "Don't use a table just to present a list of items that are similar. Use a list instead." Also: "Make sure the purpose of the table is clear. If necessary, include a table title or brief introduction."
- `capturer-connaissance` "Page autoporteuse" already maps need to form: steps or decision to a Mermaid diagram, spatial layout to SVG, multi-criteria comparison to a table, "Ce qu'une phrase dit aussi vite" to the sentence.

**Strength:** Mayer's figures are medians over his lab's experiments, with students learning how systems work; transfer to reference documents is a hypothesis. Bateman is one experiment, n = 20. Microsoft is a recommendation. "Interface becomes a screenshot" has no source read; it is a heuristic.
**Criticism:** "a decorative figure is removed" is not supported as stated. Decoration did not hurt accuracy in Bateman et al. The supported reason is Mayer's coherence principle: material that distracts from the point lowers learning. "Each figure has a caption" is weaker than the evidence; spatial contiguity favours labels on the figure.
**Overlap:** `capturer-connaissance` "Page autoporteuse" and "Figure SVG"/"Figure sourcée" (Intelligence). The need-to-form table moves; the SVG and Logseq mechanics stay there.

### P8. Reuse the CLAUDE.md rules

**Verdict:** kept.
**Wording:** A new document whose content no longer changes is named `YYYY-MM-DD-<slug>.md`, unless a written instruction or a numbered sequence in the directory names it otherwise. The skill points to repo rules (language, dating) and does not restate them.
**Evidence:** `/home/user/Claude/CLAUDE.md` Behavior: "New document not updated after it is written (research, test report, handoff, synthesis) -> name it `YYYY-MM-DD-<slug>.md`."
**Strength:** local rule.
**Criticism:** restating `CLAUDE.md` rules in the skill creates two copies that can drift. The `prevent-drift` skill covers that class. The skill should name the rule and its owner file.

## Candidate elements

### E1. Write for the reader, no commentary on the research or the writing

**Verdict:** kept. **Wording:** as listed.
**Row check:** Intelligence `RETROSPECTIVE.md` line 292 (2026-09-19) matches: "des commentaires qui cadrent la recherche ou le processus de rédaction plutôt que d'informer le lecteur". It was closed "aucun changement" on 2026-10-12, as already covered by `capturer-connaissance`'s "Erreurs fréquentes" row on reliability commentary.
**Evidence:** Mayer coherence (see P4) is the closest experimental support: extraneous material lowers learning. No source read names process commentary specifically.
**Strength:** local preference; indirect experimental support.
**Overlap:** `capturer-connaissance` "Erreurs fréquentes" (reliability commentary row).

### E2. Keep what serves use: no history, no past incident, no snapshot of the day

**Verdict:** kept.
**Wording:** Keep what serves the next reading. History, past incidents and the day's measurements go elsewhere (commit history, `evidence.md`, the conversation). In a skill, the version log goes in `evidence.md`.
**Row check:**
- Intelligence line 360 (2026-10-24) matches: "les pages dans ce dépôt sont vraiment des références pour une utilisation, pas une mémoire de tout ce qui s'est passé".
- Intelligence line 366 (2026-10-27) matches: "les relevés et le diagnostic du jour restent dans la conversation".
- Claude line 35 (2026-08-31) matches: the write-french changelog moved to `evidence.md`.
**Evidence:** Write the Docs, "Current": "Consider incorrect documentation to be worse than missing documentation", and it favours version-agnostic wording.
**Strength:** local preferences; Write the Docs is a recommendation.
**Overlap:** `capturer-connaissance` `critere.md` "Ce qui entre dans la page".
**Scope limit:** a research report or a handoff is a dated snapshot by design (P8). E2 applies to documents that are kept current (README, docs, knowledge-base pages, skills).

### E3. Link rather than paraphrase

**Verdict:** merged into P1.
**Row check:** Claude line 211 (2026-11-27, proposed) matches, but it is narrower than the element: "A README section says what a mechanism does and how to enable it, and links the note for how it works, with no summary of that note." Intelligence line 390 (2026-11-24, proposed) matches the proposed reconciliation.
**Evidence:** see P1 (Google, Diátaxis, Write the Docs "Unique").
**Overlap:** `prevent-drift` (a fact about to exist in two places).

### E4. No figure that ages without a source and a date

**Verdict:** reworded.
**Wording:** A figure that will age (price, limit, version, count) is not copied in; point to its live source. If it must be copied, give its source and the date it was read.
**Row check: misstated.** Claude line 50 (2026-09-22) records a skill that "hardcoded model-generation facts (prices, benchmark gaps, max output) that went stale". The fix was to delete the skill and get "figures via `claude-api`", that is, from the live source, not to date them. Adding a source and a date is a weaker remedy than the row's.
**Evidence:** Write the Docs "Current" (see E2). `capturer-connaissance`: pin "l'URL de la version lue pour une documentation versionnée (`/en/v9.0.0/`, pas `/en/latest/`)".
**Strength:** local incident; recommendation.

### E5. One question and one reader per document; rule before reasoning

**Verdict:** reworded.
**Wording:** One question and one named reader per document. Lead with the answer or the rule. Give reasoning only where it changes the reader's decision.
**Row check: partly misstated.**
- `write-guide` supports "one question ... one reader" (Overview, gates 1-2) and "Anything that changes no decision is background". It does not say "the rule comes before its reasoning".
- Intelligence 2026-09-12 (section at line 64, third bullet) says something different: "une puce donne la règle ou l'action, le raisonnement va dans `source::` s'il mérite d'être gardé". The reasoning moves out of the page; it does not come after the rule.
**Evidence.**
- Google Technical Writing One, "Documents": "A good document begins by defining its scope", "A better document additionally defines its non-scope", "A good document explicitly specifies its audience", and "ensure that the start of your document answers your readers' essential questions."
- Microsoft, "Top 10 tips": "Lead with what's most important."
- ISO 24495-1 headings 5.1.2 "Identify the readers" and 5.1.3 "Identify the readers' purpose".
- Diátaxis, how-to guides: "Maintain focus on that goal."
- Minto's *Pyramid Principle* is the usual source for answer-first; it was not read.
**Strength:** recommendations.
**Overlap:** `write-guide` gates 1-2 (for guides). The foundation skill takes the general form; `write-guide` keeps its gates.

### E6. The principle rather than a list of cases

**Verdict:** reworded, and scoped.
**Wording:** In a document that states rules (guide, skill, contributing doc), a rule or exception states its class; a named case is only its example.
**Row check:** Claude line 176 (2026-11-16) matches: "Rule exception drafted as a list of named cases ... instead of the general class". Its fix lives in `write-prompt` 2.2.0.
**Evidence:** no external source read on this point.
**Strength:** local incident.
**Criticism:** it governs rule-writing, not every output document. A PR body or a research report rarely states rules.
**Overlap:** `write-prompt` (claude-casebook).

### E7. One example worked end to end; intuition, then image, then formalism

**Verdict:** reworded.
**Wording:** Show one case worked end to end. To explain a concept, give its key terms first, then the intuition, then the formal statement.
**Row check:** the BACKLOG task `write-guide-explaining-section` matches ("intuition -> analogy -> formalism, glossary, worked example, check questions"). Its source rows, Intelligence lines 382-383 (2026-11-09), also match.
**Evidence.**
- `write-guide` Phase 3: "Show one case worked end to end."
- Write the Docs, "Exemplary": "Many readers look first towards examples for quick answers".
- Mayer pre-training (see P3) supports key terms first, with the experimental strength given there.
- No source read supports the order intuition -> image -> formalism; it is a heuristic from the owner's preference.
**Overlap:** `write-guide` Phase 3. The explaining sequence fits explanation documents (Diátaxis "Explanation"), not how-to guides or PR bodies.

### E8. A decision document recalls the context, then options and one recommendation

**Verdict:** kept.
**Wording:** A document asking for a decision first recalls the context (incident, goal, stake, history, rule in force), then the options and one recommendation.
**Row check:** matches, with one omission.
- Claude line 142 (2026-11-03) is about retrospective entries: "recall its incident and the rule in force, then options and one recommendation".
- Claude line 213 (2026-11-27) is about backlog tasks: "state its goal, the goal it serves, what is at stake, its history".
- The element generalises both to any decision document, which is reasonable. It drops "history" and the 2026-11-27 check "whether its premise still held"; both are restored above.
**Evidence:** Microsoft "just enough information to make decisions confidently" (see P4). Minto's situation-complication-question would be the natural source; it was not read.
**Overlap:** `CONTRIBUTING.md` RETROSPECTIVE.md section; `backlog` "Work a task" (proposed).

### E9. Every number and choice justified in place

**Verdict:** reworded.
**Wording:** Each number states its source or why it has that value, in place. A departure from the project's default tool or process states why.
**Row check: overgeneralised.** Claude line 190 (2026-11-22) covers a "Test or measurement plan -> each parameter ... with the reason for its value". Line 191 was applied "narrowed to the test runner". Its record says a `Behavior`-wide rule "needs an A/B and has one occurrence". "Every choice" goes beyond what both rows adopted.
**Evidence:** `write-guide` Gate 3 and its "number with no provenance" failure. No external source read.
**Strength:** local incidents.
**Overlap:** `write-guide` (numbers' provenance), `CONTRIBUTING.md` Testing step 2.

### E10. Owner-only steps listed separately

**Verdict:** kept.
**Wording:** Steps only the reader (the owner) can take go in their own ordered, exact list.
**Row check:** Claude line 165 (2026-11-09) matches: "owner-only steps in their own field, as an ordered, exact list".
**Evidence:** Google style highlights: "Use numbered lists for sequences." Nothing read on separating actors.
**Overlap:** `backlog` skill 2.0.0. In the foundation skill this belongs to handoffs and PR bodies.

### E11. Claim nothing beyond the evidence

**Verdict:** kept, with E12 merged in.
**Wording:** Keep a source's strength (must/should, standard/recommendation/measured), give sample sizes, count source by source. Label each claim's nature and how much of its source was read.
**Row check:** matches.
- Claude line 13 (2026-08-24): "A truncated excerpt flattened a source's hedge into a mandate".
- Claude line 140 (2026-11-03): "state its sample (n, setup) and whether it transfers to this setup".
- Claude line 141 (2026-11-03): "count it by source before stating it, and name the sources".
**Evidence:** Gopen & Swan themselves mark their principles "In general" and "not rules", an example of keeping a source's own strength.
**Overlap:** `verify-sources` (modal strength, claims); `capturer-connaissance` labels.

### E12. Distinguish fact, inference and inherited premise

**Verdict:** merged into E11.
**Row check: misstated.** `capturer-connaissance` does not use fact/inference/premise labels. Its labels give the claim's nature (`[Standard]`, `[Établi]`, `[Empirique]`, `[Heuristique]`, `[Composition]`, `[Avis]`, `[Testé]`), then the read degree (`, résumé`). "Inference" appears in neither skill. `write-guide` defines "Inherited premise" and asks to "Keep established facts and inherited premises apart."
**Proposed content for E11:** nature of the claim (capturer's set, or write-guide's `evidence.md` labels), read degree, and inherited premises marked as such.
**Overlap:** `write-guide` `evidence.md`, `capturer-connaissance` "Étiquette d'une affirmation". The two label sets differ; the next step must pick one or map them.

### E13. A snippet presented as working has been run

**Verdict:** kept. **Wording:** as listed.
**Row check:** Claude line 59 (2026-09-27) matches.
**Evidence:** Diátaxis, tutorials: "your tutorial works for every user, every time", reached through "extensive testing and observation". Google "Code samples" asks for an introductory sentence before each sample but says nothing about testing.
**Overlap:** `verify-sources` (code snippet as a claim); `capturer-connaissance` `[Testé]`.

### E14. The document obeys its own rules

**Verdict:** kept. **Wording:** as listed.
**Row check:** matches. Claude line 13 (2026-08-24): "a delivered doc violated its own principles across its examples". Claude line 29 (2026-08-30): "A new Communication rule about avoiding elliptical/dropped-word phrasing itself shipped with an elliptical closing clause".
**Evidence:** no external source read.
**Note:** the skill itself must pass this check; its examples are the first test.

### E15. Concision checked at every revision

**Verdict:** dropped.
**Row check: misstated.** Claude line 20 (2026-08-25) is marked "no change", "superseded by 2026-08-30 Communication rewrite". The 2026-08-30 row (line 27) then removed the concision-as-goal instructions as the root cause of compressed sentences. The ledger's lesson is the opposite of the element.
**Replacement (into the review pass):** after any rewrite, re-check the rewritten text against every rule, not only the one that triggered the rewrite.
**Support:**
- `write-french` Review Pass step 3: "Rewrite each hit, then re-check the rewrite against all six."
- Claude line 197 (2026-11-22): "Wording changed after its `write-prompt` pass (review, fix) -> run the pass again on the new text".

### E16. Plan a reviewer who did not write the text

**Verdict:** kept, with M6 merged in.
**Wording:** The writer cannot see its own jargon or gaps. A reader who did not write the text reviews it before delivery.
**Evidence.**
- `write-french/evidence.md` matches the element: "catching this needs a second-pass reviewer role, not another rewording of the definition."
- Google Technical Writing One, "Audience": "Experts often suffer from the curse of knowledge, which means that their expert understanding of a topic ruins their explanations to newcomers."
- ISO 24495-1 heading 5.4.3: "Evaluate the document further with readers" (text not read).
- Pinker's remedy, as reported (secondary: APS Observer report of his 2015 lecture): writers should "show early drafts of their work to a representative reader", because countering the curse of knowledge "involves more than just empathizing with the reader".
**Strength:** local measurement (three domains); recommendations; secondary report for Pinker.
**Overlap:** `write-french` Review Pass step 5 is a self-review grill and does not replace an independent reader.

### E17. Language and register by document type

**Verdict:** kept.
**Wording:** Code-side documents (README, PR body, commit, code comment, skill) are in English, unless the skill is already in another language. Deliverables and replies for the user are in the user's language. In a consumer repo, its own `CLAUDE.md` wins.
**Evidence:** `/home/user/Claude/CLAUDE.md` Claude Code: "Code and its docs (README, comments, commits, PRs, skills) -> English". Behavior: "Replies and deliverables for the user -> the user's language." `write-french` "Not for": "skills, commit messages, PR bodies, code, code comments, README files and manifests". Bootstrap 1: "A consumer's root `CLAUDE.md` conflicts with `.claude/CLAUDE.md` -> the root one wins."
**Criticism:** this is a repo rule (P8). The skill should point to it, not restate it.

## Proposed merges

- P1 + E3: one self-containment rule with a link-ignoring test.
- E11 + E12: one evidence rule (strength, n, count by source, nature label, read degree).
- E16 + M6: one review rule (independent reader).
- P4 + the concision floor from `write-french`: one cut rule anchored to the document's question, floored at the sentence.
- E2 + E4: both rest on "incorrect documentation is worse than missing" (Write the Docs). They can share one heading: keep the document current, or keep volatile content out of it.
- P5 becomes the skill's goal statement (ISO's four principles), not a rule.

## Missing principles the sources support

- **M1. Lead with the answer.** Google: "ensure that the start of your document answers your readers' essential questions." Microsoft: "Lead with what's most important." Folded into E5.
- **M2. One term per concept, and clear referents.** Google Technical Writing One: "if you rename a term in the middle of a document, your ideas won't compile". Google also says to replace an ambiguous pronoun with its noun. Folded into P3.
- **M3. Old information before new; keep the subject close to its verb; put the action in the verb.** Gopen & Swan principles 1, 4, 5 and 6, including "provide context for your reader before asking that reader to consider anything new." Principle 1 is the language-neutral source of `write-french`'s "subject-verb-splitting aside". Williams & Bizup is the usual source for characters-as-subjects and actions-as-verbs; it was not read.
- **M4. State scope and non-scope.** Google: "A better document additionally defines its non-scope." `write-guide` asks the same for guides ("Out-of-scope is drawn by effect").
- **M5. Signal the structure.** Mayer signaling: 26 of 28 tests, d = 0.70; verbal signals (outline, headings, pointer words) 15 of 16 tests, d = 0.69. Google: numbered lists for sequences, bulleted lists for other lists. ISO 5.2.4: "Use headings to help readers predict what comes next." Mayer's condition: use signals sparingly.
- **M6. Test with a reader.** Merged into E16.
- **M7. One document type per document.** Diátaxis keeps tutorials, how-to guides, reference and explanation apart ("One risk of explanation is that it tends to absorb other things"). ISO 5.1.5 "Select the document type or types" and 5.2.5 "Keep supplementary information separate" (headings only).
- **M8. Descriptive link text.** Google: "Write link text that makes sense without the surrounding text"; no "click here".
- **M9. Plain language holds for specialists too.** GOV.UK "Clear language": "Even when writing for a specialist audience, you still need to make sure everyone can understand what the content is about." It cites "80% of people preferred sentences written in clear English"; no sample size or study name is given. Gopen & Swan are a counterweight: they "neither decreased the jargon nor diluted the science". Clarity comes from structure, not from removing technical terms.
- **Sentence-length numbers** (GOV.UK: "Try to split up sentences that are over 25 words long", "no more than 5 sentences" per paragraph; Microsoft: "Three to seven lines" per paragraph) are recommendations without cited evidence. They suit a lint check, not a principle.

## Benchmark fact

The claim to check: a blind A/B showed that "cut words" only acts on removal, and that adding "one idea per sentence, no idea twice" is what fixed over-compression.

`RETROSPECTIVE.md` line 30 (2026-08-30), verbatim:

> Blind A/B (write-skill Track 2, 4 evals, independent executor/comparator/analyzer agents) on the new reader-clarity Communication rule: it lost 2 of 4 evals and tied a 3rd. Both analyzers converged on the same gap - the rule only tests the subtraction side (don't cut a word the reader needs), never the addition side (don't fuse a second independent claim via comma/dash/colon); an executor avoided under-cutting by stacking the missing clause onto the sentence instead

Fix column: "Add the missing direction using `write-french`'s own existing phrase instead of a new explanation - 'one idea per sentence, no idea twice'". State: applied.

Verdict on the claim:
- **Supported:** the rule under test (cut a word only if the reader loses nothing) only covers removal. The row says so.
- **Not supported, on two counts:**
  1. The defect the analyzers found was not over-compression. It was the opposite side: an executor "stack[ed] the missing clause onto the sentence", which fuses claims.
  2. The row records no rerun after the fix. No later row, no `PROVENANCE.md` row and no file under `docs/` reports one (grep for "idea twice", "reader-clarity" and "over-compress" found only this row and `write-french/evidence.md` line 127). The commit history could not be checked: the clone is shallow.
- The phrase is no longer in `CLAUDE.md` or `CLAUDE.web.md` (grep for "idea": no match beyond an unrelated line).
- The only measured effect of "one idea per sentence" in this repo is in `write-french/evidence.md` v1.3.0. Defect 6 ("one sentence, several ideas") went from 5.68 to 2.04 per 1000 words in one blind A/B on one French excerpt. That measures fused sentences, not over-compression.

For the benchmark design: score fused sentences and dropped load-bearing words as two separate defects, and run the arm with both rules against the arm with "cut" alone, since the ledger never measured that comparison.

## Sources

| Source | URL | Access |
|---|---|---|
| Gopen, G. D. & Swan, J. A. (1990). The Science of Scientific Writing. *American Scientist*. Reprint with permission, via Penn State "Style for Students Online" | https://cseweb.ucsd.edu/~swanson/papers/science-of-writing.pdf | Read in full (PDF text extracted) |
| Same, publisher page | https://www.americanscientist.org/blog/the-long-view/the-science-of-scientific-writing | [BLOCKED] 503, twice; the reprint above covers it |
| Google developer documentation style guide: Highlights | https://developers.google.com/style/highlights | Read |
| Google style guide: Abbreviations | https://developers.google.com/style/abbreviations | Read |
| Google style guide: Jargon | https://developers.google.com/style/jargon | Read |
| Google style guide: Write for a global audience | https://developers.google.com/style/translation | Read (`/style/global-audience` returned 404) |
| Google style guide: Cross-references and linking | https://developers.google.com/style/cross-references | Read |
| Google style guide: Code samples | https://developers.google.com/style/code-samples | Read |
| Google Technical Writing One: Short sentences | https://developers.google.com/tech-writing/one/short-sentences | Read |
| Google Technical Writing One: Documents | https://developers.google.com/tech-writing/one/documents | Read |
| Google Technical Writing One: Audience | https://developers.google.com/tech-writing/one/audience | Read |
| Google Technical Writing One: Words | https://developers.google.com/tech-writing/one/words | Read |
| Microsoft Writing Style Guide: Top 10 tips | https://learn.microsoft.com/en-us/style-guide/top-10-tips-style-voice | Read |
| Microsoft Writing Style Guide: Scannable content | https://learn.microsoft.com/en-us/style-guide/scannable-content/ | Read |
| Microsoft Writing Style Guide: Tables | https://learn.microsoft.com/en-us/style-guide/scannable-content/tables | Read |
| Diátaxis: home, Tutorials, How-to guides, Explanation | https://diataxis.fr/ , /tutorials/ , /how-to-guides/ , /explanation/ | Read (`/complex-hierarchies/` returned 404, not needed) |
| GOV.UK: Clear language | https://guidance.publishing.service.gov.uk/writing-to-gov-uk-standards/writing-guidelines/clear-language/ | Read (`/writing-guidelines/use-clear-language/` returned 404; the old gov.uk URL redirects) |
| Write the Docs: Documentation principles | https://www.writethedocs.org/guide/writing/docs-principles/ | Read |
| ISO 24495-1:2023 Plain language - Part 1 | https://www.iso.org/standard/78907.html | [BLOCKED] 403; table of contents read from DIN: https://www.din.de/de/mitwirken/normenausschuesse/nat/veroeffentlichungen/wdc-beuth:din21:370015899/toc-3456451/download ; scope read at https://accessible-eu-centre.ec.europa.eu/content-corner/digital-library/iso-24495-12023-plain-language-part-1-governing-principles-and-guidelines_en |
| US federal plain language guidelines | https://www.plainlanguage.gov/guidelines/ | Redirects to https://digital.gov/guides/plain-language ; landing page only; old content archived at https://github.com/GSA/plainlanguage.gov (not read) |
| Mayer, R. E. (2023). Research-based principles for designing multimedia instruction. In Overson et al. (Eds.), *In Their Own Words*, APA Division 2, pp. 143ff. Figures based on Mayer (2021), *Multimedia Learning*, 3rd ed. | https://www.unh.edu/teaching-learning-resource-hub/sites/default/files/media/2023-06/itow-research-based-principles-for-designing-multimedia-instruction-mayer.pdf | Read (PDF text extracted) |
| Mayer, R. E. (2008). Applying the science of learning. *American Psychologist* 63(8), 760-769, via PubMed | https://doi.org/10.1037/0003-066X.63.8.760 | Abstract only |
| Bateman, S. et al. (2010). Useful Junk? The Effects of Visual Embellishment on Comprehension and Memorability of Charts. CHI 2010 | https://vis.csail.mit.edu/classes/6.859/readings/pdfs/Bateman-UsefulJunk.pdf | Read (abstract, introduction, participants) |
| APS Observer (2015). The Curse of Knowledge: Pinker Describes a Key Cause of Bad Writing | https://www.psychologicalscience.org/observer/the-curse-of-knowledge-pinker-describes-a-key-cause-of-bad-writing | Read; secondary (news report of a lecture) |
| Pinker, *The Sense of Style* (2014); Williams & Bizup, *Style: Lessons in Clarity and Grace*; Minto, *The Pyramid Principle*; Tufte, *The Visual Display of Quantitative Information* | - | Not read: no authorised open copy found |
| Local: `skills/write-french/SKILL.md`, `skills/write-french/evidence.md`, `skills/write-guide/SKILL.md`, `RETROSPECTIVE.md`, `BACKLOG.md`, `PROVENANCE.md`, `CLAUDE.md` | /home/user/Claude | Read |
| Intelligence: `RETROSPECTIVE.md`, `skills/capturer-connaissance/SKILL.md`, `critere.md` | /home/user/intelligence | Read |

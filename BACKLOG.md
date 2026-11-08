# Backlog

Work not done yet, one `###` section per task. Format and rules: the `backlog` skill.

## Tasks

### Reference the remaining agent-skills in CLAUDE.md
Status: ready
Context: situation-triggered skills do not fire under native routing (`RETROSPECTIVE.md`
2026-11-03 skill-gap). PR#122 named the framing set; the other agent-skills in `skills.txt`
stay unnamed in `CLAUDE.md`. Owner, 2026-11-08: `code-review-and-quality` never fired in use
(`RETROSPECTIVE.md` 2026-10-28 test-run).
Next: list the `skills.txt` agent-skills that `CLAUDE.md` never names, and how each overlaps a
skill it already names.
Done when:
- [ ] each listed skill has a trigger rule with its `PROVENANCE.md` row, or a recorded reason to
  leave it to native routing
- [ ] the 2026-11-03 skill-gap row's A/B has run, or the owner waived it
Out of scope: the framing set, and mattpocock `to-tickets` (granularity question before filing).

### Make the backlog trigger reliable on Haiku
Status: ready
Context: the `backlog` skill fired on 5/10 should-fire cases with Haiku 5.5, against 10/10 with
Sonnet and Opus. The misses were mostly work mentioned beside a main request
(`docs/research/2026-11-07-backlog-skill-trigger-test.md`).
Next: rerun the missed cases a few times on Haiku to tell a weak `CLAUDE.md` rule from a weak
skill description.
Done when:
- [ ] Haiku fires on at least 8/10 of the same should-fire cases, with no new false fire
Out of scope: Sonnet and Opus behavior, already reliable.

### Review the rules dropped as asking or low-value on 2026-10-23
Status: ready
Context: `b0238a9` dropped the asking rules under an owner quote later scoped to the pre-PR#94
rules (`RETROSPECTIVE.md` 2026-10-28 fact-corrected), plus four rules judged low-value. Not in
`CLAUDE.md` today: "touch only what was asked; delete nothing you don't fully understand", and
owner approval before applying a ledger entry (PR#114's `CONTRIBUTING.md` covers decision entries).
Next: for each rule `b0238a9` removed, find what in the current `CLAUDE.md` or a skill covers it.
Done when:
- [ ] each removed rule is marked covered (by what), restored with its `PROVENANCE.md` row, or
  dropped with the owner's reason
Out of scope: the clarification rule, already restored.

### Show the cause of a failed skill install in the hook report
Status: ready
Context: the `SessionStart` installer lists failed skills without any error, so one shared cause
reads as many failures (`RETROSPECTIVE.md` 2026-10-30 tool-blocked). Recurred 2026-11-08:
`write-prompt` failed, cause not shown.
Next: make one install fail on purpose and see what error output the installer drops.
Done when:
- [ ] a failed install prints the first error line of one failed call in the hook report
- [ ] a run with no failure prints nothing new

### Read a repo's CONTRIBUTING.md before editing its guarded files
Status: ready
Context: the `CLAUDE.md` rule to read `CONTRIBUTING.md` first covers only NormandErwan/Claude;
a handoff led to ledger edits in another repo without reading its own (`RETROSPECTIVE.md`
2026-11-02 skill-gap). Recurrence of the 2026-09-22 skill-gap row, so `find-cause` first.
Next: run `find-cause` on the two rows, then propose the wording.
Done when:
- [ ] `find-cause` trace recorded in the 2026-11-02 row
- [ ] rule covers any attached repo with a `CONTRIBUTING.md`
- [ ] its `PROVENANCE.md` row added

### State the strongest objection to the owner's hypothesis first
Status: ready
Context: owner wants critical answers that map the problem, not ones that confirm their framing
(`RETROSPECTIVE.md` 2026-11-03 new-preference). `Behavior` already checks "a domain expert's
objection" before sending, but does not show it. Always-on: A/B mandatory (`CONTRIBUTING.md`).
Next: draft the extension of the existing `Behavior` check, then the A/B plan, review first.
Done when:
- [ ] A/B run and recorded, or waived by the owner with a reason in `PROVENANCE.md`
- [ ] `CLAUDE.md` and `CLAUDE.web.md` updated together if the A/B favors the change

### Estimate agent-run effort in session terms
Status: ready
Context: effort of work the agent does was quoted in human time, inflating an option's cost
(`RETROSPECTIVE.md` 2026-10-28 fact-corrected). Likely home: the `Behavior` clause that states
a downside "quantified". Always-on: A/B mandatory.
Next: draft the clause extension and the A/B plan, review first.
Done when:
- [ ] A/B run and recorded, or waived by the owner with a reason in `PROVENANCE.md`
- [ ] agent work estimated in tool calls or session minutes, owner steps in human time

### Use French words for repo terms in French replies
Status: ready
Context: French replies kept English repo terms the owner does not know ("ledger")
(`RETROSPECTIVE.md` 2026-10-28 new-preference). Change goes in `write-french`, a native skill.
Next: find the `write-french` defect or check this extends, before adding a new one.
Done when:
- [ ] `write-french` says: repo term with a plain French equivalent -> French word, English
  name only for a file path
- [ ] version bumped, `SKILLS.md` updated per its procedure

### Date-prefix handoff and docs file names
Status: ready
Context: handoff files and `docs/` notes named without a date cannot be ordered
(`RETROSPECTIVE.md` 2026-11-07 new-preference, two rows). `docs/research/` already follows
`YYYY-MM-DD-<slug>.md` by habit; no rule states it.
Next: check whether `v-model-documents` or `research` already names files, before writing a rule.
Done when:
- [ ] `handoff` names its file `YYYY-MM-DD-<slug>.md`
- [ ] a rule makes new `docs/` files take the same prefix, with its `PROVENANCE.md` row

### Find why verify-sources does not fire on unverified claims
Status: ready
Context: three unchecked claims though `Behavior` names `verify-sources` (`RETROSPECTIVE.md`
2026-10-28 and 2026-11-03 fact-corrected, three rows). Owner: the skill was likely never loaded.
Same class as the 2026-11-03 skill-gap row (situation-triggered skills do not fire).
Next: run `find-cause` on the three rows and the 2026-11-03 skill-gap row.
Done when:
- [ ] `find-cause` trace recorded in the three rows
- [ ] a fix proposed with its measure, or the owner's reason to leave it
Out of scope: the skills the agent-skills task covers.

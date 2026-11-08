# Backlog

Work not done yet, one `###` section per task. Format and rules: the `backlog` skill.

## Tasks

### Process proposed RETROSPECTIVE.md entries
Status: in progress (ccr-8857f434-wa6pon)
Context: many entries are `proposed`, among them the 2026-11-07 rows on task granularity and
subtask scope, written for Backlog.md and now to reread against this file. `CONTRIBUTING.md`
(RETROSPECTIVE.md section) governs processing.
Next: owner decided 8 entries (7 accepted, 2026-10-30 to 2026-11-07; 141 no change); the 16
closures proposed for the rest and the 2026-10-28 `test-run` row await the owner's verdict.
Done when:
- [ ] every `proposed` entry is accepted, rejected, or marked `not checkable here`
- [ ] every accepted entry has a task here or a PR
Out of scope: rule rewrites not tied to an entry.

### Reference the remaining agent-skills in CLAUDE.md
Status: ready
Context: situation-triggered skills do not fire under native routing (`RETROSPECTIVE.md`
2026-11-03 skill-gap). PR#122 named the framing set; the other agent-skills in `skills.txt`
stay unnamed in `CLAUDE.md`.
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
- [ ] rule covers any attached repo with a `CONTRIBUTING.md`, `PROVENANCE.md` row added

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

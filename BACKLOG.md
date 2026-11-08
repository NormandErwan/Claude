# Backlog

Work not done yet, one `###` section per task. Format and rules: the `backlog` skill.

## Tasks

### Process proposed RETROSPECTIVE.md entries
Status: ready
Context: many entries are `proposed`, among them the 2026-11-07 rows on task granularity and
subtask scope, written for Backlog.md and now to reread against this file. `CONTRIBUTING.md`
(RETROSPECTIVE.md section) governs processing.
Next: read the whole ledger, group `proposed` entries by class.
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

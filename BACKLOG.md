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

### Define the framing, breakdown and planning method
Status: blocked: wait until this file has been used for a few weeks
Context: frame, split and plan work before building: `interview-me`, `spec-driven-development`,
`planning-and-task-breakdown`. mattpocock `to-tickets` adds vertical slices and asking the owner
whether the granularity fits before filing. Related `RETROSPECTIVE.md` rows: 2026-11-07.
Next: list the tasks that turned out too big, too small or badly framed.
Done when:
- [ ] method written in `CLAUDE.md` or a skill, with its `PROVENANCE.md` row

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

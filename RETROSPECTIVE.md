# RETROSPECTIVE.md

Ledger of Retrospective entries. One row per entry, approved or not. `CLAUDE.md` `Retrospective` holds the rules for filing and compacting it.

| Date | Events | Class | Proposed change | Decision | Landed in |
|---|---|---|---|---|---|
| 2026-08-23 | new-preference | Per-turn self-reporting states a figure the harness does not expose | Report a real token figure or none, and key the handoff to a pause or a topic change rather than a token threshold | applied | `CLAUDE.md` Every turn 7, `CLAUDE.web.md` Every turn 6 |
| 2026-08-23 | skill-gap | Retrospective entries scoped to the incident instead of its class | Template names the class first; extend an existing rule by default; a skill's own misbehavior goes back to that skill | applied | `CLAUDE.md` + `CLAUDE.web.md` Retrospective |
| 2026-08-23 | plan-revised | A rule kept for a feature the user does not use, on the strength of the request alone | None - `ponytail-review` flagged the agent-team lines as speculative, saying so at review time was enough for the user to drop them | no change | - |
| 2026-08-24 | doc-drift | Continuity resumption cross-checked a shared guide's content from memory instead of its actual text | Extend verify-sources' core principle: an in-context document is a source too - reread its actual text, don't cite from memory | applied | `verify-sources` SKILL.md Overview |
| 2026-08-24 | fact-corrected, doc-drift, plan-revised | A truncated excerpt flattened a source's hedge into a mandate; a delivered doc violated its own principles across its examples | Extend verify-sources' "source must support the exact claim" with modal-strength preservation; extend `Code/docs/commits` with a doc/skill pre-delivery example-vs-principle and chain-continuity check | applied | `verify-sources` SKILL.md + `CLAUDE.md`/`CLAUDE.web.md` Code/docs/commits |
| 2026-08-24 | skill-gap | A mandatory sub-checklist nested under a conditional bullet gets skipped once that bullet's other branch already fired | Promote Every turn's "Always check" list to its own step | applied | `CLAUDE.md` + `CLAUDE.web.md` Every turn |
| 2026-08-25 | skill-gap | craft-prompt invoked before a CLAUDE.md edit still produced a vague, discretionary rule for what to omit - its own "degrees of freedom" guidance wasn't applied | Extend `Code / docs / commits`'s craft-prompt-first rule: when the edit constrains what gets omitted/said, write it as a concrete trigger with explicit exceptions, not a discretionary standard, on the first pass | pending | - |

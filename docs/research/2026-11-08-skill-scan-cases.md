# Skill scan: case set

For the `BACKLOG.md` task "Replace named skill rules with a skill scan". Written before any
wording is drafted; after the pilot, the wording changes only if a case below fails. Starting
wording and review findings: `2026-11-08-agent-skills-coverage.md`.

Status: draft, awaiting owner review.

## Arms

- A: `CLAUDE.md` as on PR#125's head.
- B: A with the `Behavior` line "An available skill could help -> invoke it and name it in one
  line" replaced by the scan, and these rules removed (they only name a skill by its trigger):
  - `Recurring failure -> find-cause`
  - `Personal advice or a method judgment call -> guide-decision; a purchase -> guide-purchase`
  - `Logic to change or bug to fix -> test-driven-development`
  - `Test or build fails, or bug to diagnose -> debugging-and-error-recovery`
  - `Code calling a framework or API written from memory -> source-driven-development`
- Kept in both arms, because they fix an order, a surface or a source: the task's out-of-scope
  rules (`caveman-commit`, `write-french`, `verify-sources`, `backlog`), plus `interview-me` and
  the framing chain (before planning), `search-first` (before the options), `ponytail-review` then
  `code-review` (turn end), `handoff` (offer, once per trigger), `caveman` (code comments),
  `claude-api` (source for prices and limits).

## Measure

Each case lists E (must fire) and A (may fire). Read from the `claude -p` stream-json transcript:

- Recall: share of E skills invoked, before the step named in the case.
- False fire: a skill invoked outside E and A.
- Count: skills invoked in the turn. More than 3 counts as a long list.
- Re-invoke: a skill invoked again after an earlier turn already invoked it.
- Cost: input tokens per run (a scan that loads many skills costs context).

B wins if its recall is at least A's on the removed-rule cases (F4-F7) and higher elsewhere, with
no more false fires, long lists or re-invokes than A. 3 runs per case per arm.

## Must fire

| Id | Kind | Fixture state | Prompt | E | A |
|---|---|---|---|---|---|
| F1 | request start, situation | `test_parse` fails | "Le test `test_parse` échoue, corrige-le." | `debugging-and-error-recovery`, before the first edit | `test-driven-development`, `write-french` |
| F2 | request start, topic | small HTTP API | "Ajoute un endpoint `/users` paginé." | `api-and-interface-design`, before the first edit | `test-driven-development`, `incremental-implementation`, `write-french` |
| F3 | mid-task, a failure | build script breaks on an unrelated missing import once `npm test` runs | "Renomme `parseDate` en `parseIsoDate` partout, puis lance les tests." | `debugging-and-error-recovery`, after the failure and before the fix | `write-french` |
| F4 | removed rule, recurring | `RETROSPECTIVE.md` with two rows on the same lint break | "La CI casse encore sur ce lint, 3e fois cette semaine." | `find-cause` | `debugging-and-error-recovery`, `write-french` |
| F5 | removed rule, personal | none | "Je dois choisir entre deux mutuelles, aide-moi à trancher." | `guide-decision` | `write-french` |
| F6 | removed rule, logic | `slugify` spec in `SPEC.md`, no code | "Implémente `slugify` selon SPEC.md." | `test-driven-development`, before the first edit | `incremental-implementation`, `write-french` |
| F7 | removed rule, from memory | Python repo using `httpx` | "Ajoute un retry exponentiel aux appels httpx." | `source-driven-development`, before the first edit | `test-driven-development`, `write-french` |
| F8 | marginal fit | payment module | "Ajoute un log quand un paiement échoue." | `observability-and-instrumentation` | `test-driven-development`, `write-french` |

## Must not fire

| Id | Kind | Fixture state | Prompt | Must not fire | A |
|---|---|---|---|---|---|
| N1 | "not for" exclusion | as F1 | as F1 | `find-cause` (excludes a single live bug) | as F1 |
| N2 | off-topic | small repo | "Que fait `parse` dans `src/parser.py` ?" | any skill outside A | `token-codebase-exploration`, `write-french` |
| N3 | already invoked | F1, then a second turn with `--resume` | turn 2: "Il en reste un, `test_format`." | `debugging-and-error-recovery` again in turn 2 | `write-french` |
| N4 | many marginal fits | web app with a report page | "Ajoute un bouton d'export CSV à la page rapport." | a list of more than 3 skills | `frontend-ui-engineering`, `test-driven-development`, `incremental-implementation`, `api-and-interface-design`, `write-french` |

## Open points for the owner

- Arm B's removed-rule list above: confirm, or move a rule between "removed" and "kept".
- Model: Sonnet only, or Sonnet and Haiku (Haiku missed half the `backlog` triggers,
  `2026-11-07-backlog-skill-trigger-test.md`).
- Prompts in French on purpose: `write-french` sits in every A set, so a French reply never
  counts as a false fire.

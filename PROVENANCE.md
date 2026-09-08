# PROVENANCE.md

Ledger of why each `CLAUDE.md` rule exists. One row per rule, added or updated in the same
commit that introduces, meaningfully changes, or retires it - procedure in `CONTRIBUTING.md`
`Editing CLAUDE.md`. A pure rewording adds a note to the rule's existing row instead of a new
one.

Rows below predate this ledger: seeded once, 2026-09-07, from a git-archaeology audit
(`git log -S` per rule, oldest matching commit, commit message read for a stated reason) - a
one-time backfill, not live entries, and not exhaustive: scoped to Bootstrap, Every turn's
skeleton, Non-negotiables 2-6, Local dev & verification, PR lifecycle's base rows, and Agents'
base bullets, per the handoff that requested it. Every row traces to a real introducing commit
in this repo's full history (root commit `115a3d1`, 2026-06-07).

| Date | Section | Rule | Commit | Rationale |
|---|---|---|---|---|
| 2026-08-22 | Bootstrap | Consumer project synced automatically via SessionStart hook | `1751234` | No (origin not logged) - purely mechanical, calls the old method "obsolete" without citing a concrete failure |
| 2026-08-31 | Bootstrap | Dogfooding path runs the injector directly | `783a3e3` | Yes - aligns the dogfooding path with the new hook mechanism, same fix as the next row |
| 2026-08-22 | Bootstrap | Consumer's root CLAUDE.md wins over the synced copy | `b194336` | Yes - without a precedence rule the two conflicted silently |
| 2026-08-31 | Bootstrap | Hook clones agent-skills, injects using-agent-skills | `783a3e3` | Yes - the skill roster freezes before session start, so a mid-session npx install could never be invoked otherwise |
| 2026-07-28 | Bootstrap | npx skills add every session, regardless of step 1's outcome | `1010d0f` | Yes - the subtree precondition never held for this repo itself, so installs were silently skipped here |
| 2026-07-28 (core); 2026-09-05 (exception) | Bootstrap | Never vendored deliberately, except craft-prompt and grilling | `1010d0f` / `709043f` | Yes - core: npx is the only way to get current versions; exception: these two forked locally for edits, upstream tracking kept |
| 2026-07-27 | Bootstrap | Leave dotnet-skills uninstalled for now | `2c3eb5a` | Yes - installs gated on topic match (.NET/C#/Blazor), avoids unneeded installs |
| 2026-07-26 | Bootstrap | A skill is unusable via the Skill tool in two cases | `6c15807` | Yes - the roster freezes before turn 1; a mid-session npx install is guaranteed uninvocable, not just possibly |
| 2026-09-01 | Bootstrap | npx fails on transport -> git clone fallback | `cbbb421` | Yes - concrete case: proxy blocks npm, git/curl still work |
| 2026-09-01 | Bootstrap | Still unreachable after the fallback -> say so | `cbbb421` | Yes - same commit/rationale as the row above |
| 2026-09-05 | Every turn | Frame before answering, mandatory regardless of request type | `28f97b8` | Yes - not actually pre-ledger (dated after 2026-08-23): a handoff traced two real failures to rules that did not fire |
| 2026-07-18 | Every turn | "Obvious -> act directly" exception (ancestor of step 4's check) | `3088980` | Yes - replaced a vague once-per-session "obvious" judgment call with an explicit per-turn checklist |
| 2026-07-18 | Every turn | Clarify -> Planify -> Validate pipeline (Clarify renamed grilling since) | `3088980` | Yes - same commit as the row above: moved a once-per-session plan-mode gate to a per-turn pipeline |
| 2026-07-25 | Every turn | Phase routing via the SessionStart hook's injection | `097ac94` | Yes - gated on multi-session or explicitly-requested work so normal-sized tasks are unaffected |
| 2026-08-23 | Every turn | Stamp the reply with local time | `5f0124b` | Yes - replaces a fabricated token estimate the old rule forced when the harness exposes none |
| 2026-08-23 | Every turn | Report a token figure only when the harness exposes one | `5f0124b` | Yes - same commit as the row above - retired (this commit, 2026-09-08): the exposed figure is a static remaining-budget number, not a live per-session usage count, so the rule either always skips or reports a misleading figure |
| 2026-08-23 | Every turn | Offer a handoff once per trigger | `5f0124b` | Yes - the old trigger keyed to a 100k-token threshold the model cannot observe |
| 2026-08-31 | Non-negotiables 2 | Stop on confusion | `783a3e3` | Yes (section-level) - "restated from agent-skills using-agent-skills... a claude.ai chat has no repo to read them from"; not justified individually per behavior |
| 2026-08-31 | Non-negotiables 3 | Push back before building, not after | `783a3e3` | Yes (section-level) - same as row above |
| 2026-08-31 | Non-negotiables 4 | Prefer the boring solution | `783a3e3` | Yes (section-level) - same as row above |
| 2026-08-31 | Non-negotiables 5 | Touch only what you were asked to touch | `783a3e3` | Yes (section-level) - same as row above |
| 2026-08-31 | Non-negotiables 6 | Verify, never assume | `783a3e3` | Yes (section-level) - same as row above |
| 2026-07-15 | Local dev & verification | Don't use CI to find out if code works | `106778c` | Yes - CI was used as a push/see debug loop, exhausted a real project's Actions artifact storage quota |
| 2026-07-15 | Local dev & verification | No push-to-see-what-CI-says commits | `106778c` | Yes - same commit/rationale as the row above |
| 2026-07-15 | Local dev & verification | CI-only, not reproducible locally -> say so, confirm before iterating | `106778c` | Yes - same commit/rationale as the row above |
| 2026-06-07 | Local dev & verification | Before done/fixed/passing claims -> run verification commands | `34de40e` | No (origin not logged) - part of a full-file rewrite one commit after this repo's root, no reason given |
| 2026-06-07 | PR lifecycle | Run ponytail-review then code-review at the end of an approved plan, no asking | `34de40e` | No (origin not logged) - same rewrite commit as the row above (originally requesting-code-review + receiving-code-review) |
| 2026-09-06 | PR lifecycle | Open questions remain -> keep going, no question | `a249037` | Yes - not actually pre-ledger (PR #76, same day): the old single row asked twice unanswered this session |
| 2026-07-18 | PR lifecycle | Placeholder title -> rename | `5a5a218` | Yes - added while standardizing PR-lifecycle wording on "always", per a user request |
| 2026-07-15 | PR lifecycle | Nothing actionable -> stop self re-arming | `4a7012e` | Yes - check-ins polled hourly for 5+ hours after CI had already passed, no exit condition existed |
| 2026-07-27 | PR lifecycle | Merge conflict -> resolve via resolving-merge-conflicts | `f3b9bb6` | Yes - the skill was installed but never explicitly triggered |
| 2026-07-15 | PR lifecycle | Anything still pending -> keep polling | `4a7012e` | Yes - same commit/rationale as the row above |
| 2026-08-23 | Agents | Delegate when raw output would dump long logs into context | `5f0124b` | No (origin not logged) - new section explained by its own content, no prior incident cited |
| 2026-08-23 | Agents | Don't delegate work that needs context already in hand | `5f0124b` | No (origin not logged) - same commit as the row above |
| 2026-09-02 | Agents | isolation:worktree -> verify the base at start | `ef59a02` | Yes - a stale worktree base went unflagged and produced a misleading full-file-delete diff |

# CLAUDE.md

## Communication
- Concise everywhere. No filler. Answer first, state facts, no restating the obvious.
- Match user's language.

## Every turn
1. Identify the task.
2. Scan local skills, >=1% relevant -> invoke + announce ("Using [skill] to [purpose]"), same rule for any skill invoked this turn from any step (2, 4, or 5) - no silent invocations. Always check regardless of scan: any file op or multi-file task -> `token-efficiency`; unfamiliar code area or need the bigger picture -> `zoom-out`; about to state an unverified factual/technical/procedural claim -> `verifying-sources`.
3. Obvious? (literal content/command, or one unambiguous reading; one file touched, or one already-named location; zero design choice) -> act.
4. Not obvious, or any suspected ambiguity/gap (not user-delegated, e.g. "reformulate as needed") -> systematically `grill-me` (docs involved -> `grill-with-docs`) to zero ambiguity -> Planify (draft, self-review vs assumptions/alternatives/challenges, show only final analysis+plan) -> Validate (plain-text question before Edit/Write/mutating Bash-git/PR call; read-only skips).
   - Remote/cloud session -> batch `grill-me`: group by independent branch, sequential sub-groups within a branch ok, soft cap ~3-4 branches x 2-3 groups/turn, short recommendation per question.
   - Domain/data model involved -> also `domain-modeling`. New module/interface design -> also `codebase-design`. Unfamiliar domain needing primary sources -> also `research`. Design question needing a throwaway spike -> also `prototype`.
5. Large-scope work (new subsystem, multi-session, or user asks for the full process) -> use agent-skills, following `using-agent-skills` to route by phase: Define (`interview-me`/`idea-refine`/`spec-driven-development`) -> Plan (`planning-and-task-breakdown`) -> Build (`incremental-implementation`/`test-driven-development`/...) -> Verify (`debugging-and-error-recovery`/`browser-testing-with-devtools`) -> Review (`code-review-and-quality`) -> Ship (`git-workflow-and-versioning`/...). Default for normal-sized tasks: skip this, steps 2-4 are enough. Once triggered, agent-skills phases supersede step 4's mattpocock routing for this task.
6. End of turn: announce estimated tokens used. Offer to draft the next-session prompt (use `handoff` to structure it) when continuing elsewhere is better, proactively at >=100k tokens (non-blocking, continue if ignored).

## Error handling

| Trigger | Action |
|---|---|
| External request non-2xx / proxy block | `[BLOCKED] <url> - <status>`; if host required, stop and tell user |
| Validate-gate question (or mutating prompt) unanswered | End turn, don't act; wait silently - hook/notification noise isn't a reply. Unanswered twice -> stop, report attempt + reason, wait |
| Non-mutating deliverable prompt (e.g. `Artifact`) unanswered | Fall back once to plainer channel, no re-prompt |

## Code / docs / commits
- English + ASCII only.
- Any technical/code doc (README, manifests, comments, PR/commit bodies) -> concise first pass, not a tightening pass after: tables/lists over prose, no sentence that just restates what a heading or identifier already says.
- Editing any CLAUDE.md -> `prompt-engineering` first, draft concise on the first pass (apply its Concise-is-key check before proposing, not after) - no exceptions, never ship a verbose draft to tighten later on request.
- Full rewrite/brevity pass of existing rules -> also: verify each rule survives with equivalent meaning (rule-by-rule), independent review before merging, A/B if unsure which reads clearer.
- Editing this file triggers a `SKILLS.web.md` refresh and update-download proposal - done from a Claude Code session, since this file has no repo access to do it itself.

## Retrospective

Immediately before ending a turn where >=1 fired:

| Code | Event |
|---|---|
| F1 | Plan step revised/abandoned mid-execution |
| F2 | File re-read same turn, first read insufficient |
| F3 | Cross-doc inconsistency found+fixed a checklist should've caught |
| F4 | Skill invoked but didn't cover the case - deviated |
| F5 | User corrected a factual error this turn |
| F6 | Tool error forced a different approach than planned |
| F7 | User gave an instruction/preference not yet captured anywhere |

>=1 fired -> emit before ending turn:
```
Retrospective [codes]:
- [Modify/Create/Delete] <skill | CLAUDE.md section | preference> - <why, one sentence> - <minimal change>
(max 3)
```
Never apply without explicit approval. 0 fired -> skip silently.

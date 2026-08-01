# CLAUDE.md

## Communication
- Concise everywhere - effective (right result) and efficient (least tokens/steps). No filler. Answer first, state facts, no restating the obvious.
- Wording only, not layout - human-readable structure is fine if agent comprehension isn't hurt.
- Match user's language.

## Every turn
1. Identify the task.
   - Topic is personal/non-technical advice (finance, pet care, interpersonal, legal-adjacent) -> `practical-advice`; purchase decision -> `purchase-advisor` (reuses its loop) - supersedes step 4's grill-me/Planify/Validate (own frame/self-critique/revise loop).
2. Scan local skills, >=1% relevant -> invoke + announce ("Using [skill] to [purpose]").
   - Same rule for any skill invoked this turn from any step (2, 4, or 5) - no silent invocations.
   - Always check regardless of scan:
     - About to state an unverified factual/technical/procedural claim -> `verifying-sources`.
     - 2+ independent tasks, no shared state/dependency -> `dispatching-parallel-agents`.
3. Obvious? (literal content/command, or one unambiguous reading; one file touched, or one already-named location; zero design choice) -> act.
4. Not obvious, or any suspected ambiguity/gap (not user-delegated, e.g. "reformulate as needed") -> systematically `grill-me` (docs involved -> `grill-with-docs`) to zero ambiguity -> Planify (draft, self-review vs assumptions/alternatives/challenges, show only final analysis+plan) -> Validate (plain-text question before any mutating action; read-only skips).
   - Remote/cloud session -> batch `grill-me`: group by independent branch, sequential sub-groups within a branch ok, soft cap ~3-4 branches x 2-3 groups/turn, short recommendation per question.
   - Unfamiliar domain needing primary sources -> also `research`.
5. End of turn:
   - Announce estimated tokens used.
   - Offer to draft the next-session prompt (use `handoff` to structure it) when continuing elsewhere is better, proactively at >=100k tokens (non-blocking, continue if ignored).

## Error handling

| Trigger | Action |
|---|---|
| External request non-2xx / proxy block | `[BLOCKED] <url> - <status>`<br>- if host required, stop and tell user |
| Validate-gate question (or mutating prompt) unanswered | End turn, don't act, wait silently (hook/notification noise isn't a reply).<br>- Unanswered twice -> stop, report attempt + reason, wait |
| Non-mutating deliverable prompt (e.g. `Artifact`) unanswered | Fall back once to plainer channel, no re-prompt |

## Code / docs / commits
- English + ASCII only.
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
- Never apply without explicit approval.
- 0 fired -> skip silently.

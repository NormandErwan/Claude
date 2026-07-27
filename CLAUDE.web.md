# CLAUDE.md

## Communication
- Concise everywhere. No filler. Answer first, state facts, no restating the obvious.
- Match user's language.

## Bootstrap - once per session
1. Load `verifying-sources` and follow `using-superpowers`.

## Every turn
1. Identify the task.
2. Scan local skills, >=1% relevant -> invoke + announce ("Using [skill] to [purpose]"). None -> `find-skills`.
3. Obvious? (literal content/command, or one unambiguous reading; one file touched, or one already-named location; zero design choice) -> act.
4. Not obvious, or any suspected ambiguity/gap (not user-delegated, e.g. "reformulate as needed") -> systematically `grill-me` (docs involved -> `grill-with-docs`) to zero ambiguity -> Planify (draft, self-review vs assumptions/alternatives/challenges, show only final analysis+plan) -> Validate (plain-text question before Edit/Write/mutating Bash-git/PR call; read-only skips).
   - Remote/cloud session -> batch `grill-me`: group by independent branch, sequential sub-groups within a branch ok, soft cap ~3-4 branches x 2-3 groups/turn, short recommendation per question.
5. End of turn: announce estimated tokens used. Offer to draft the next-session prompt when continuing elsewhere is better, proactively at >=100k tokens (non-blocking, continue if ignored).

## Error handling

| Trigger | Action |
|---|---|
| External request non-2xx / proxy block | `[BLOCKED] <url> - <status>`; if host required, stop and tell user |
| Validate-gate question (or mutating prompt) unanswered | End turn, don't act; wait silently - hook/notification noise isn't a reply. Unanswered twice -> stop, report attempt + reason, wait |
| Non-mutating deliverable prompt (e.g. `Artifact`) unanswered | Fall back once to plainer channel, no re-prompt |

## Code / docs / commits
- English + ASCII only.
- `caveman`: code comments only (its own rules say write PRs/commits normal). `caveman-commit`: commit messages. Nowhere else.
- Editing any CLAUDE.md -> `prompt-engineering` first, draft concise on the first pass (apply its Concise-is-key check before proposing, not after) - no exceptions, never ship a verbose draft to tighten later on request.
- Full rewrite/brevity pass of existing rules -> also: verify each rule survives with equivalent meaning (rule-by-rule), independent review before merging, A/B if unsure which reads clearer.

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

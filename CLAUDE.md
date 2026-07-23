# CLAUDE.md

## Communication
- Concise everywhere. No filler. Answer first, state facts, no restating the obvious.
- Match user's language.

## Bootstrap - once per session
1. This repo added as a `.claude` subtree in the current project -> `git subtree pull --prefix=.claude https://github.com/NormandErwan/Claude.git main --squash` automatically.
2. `npx skills add` everything under README.md `## Usage`.
3. Load `verifying-sources` and follow `using-superpowers`.
4. Skill installed mid-session may not be invocable via Skill tool until next session -- if missing, say so, don't assume it loaded.

## Every turn
1. Identify the task.
2. Scan local skills, >=1% relevant -> invoke + announce ("Using [skill] to [purpose]"). None -> `find-skills`.
3. Obvious? (literal content/command, or one unambiguous reading; one file touched, or one already-named location; zero design choice) -> act.
4. Not obvious, or any suspected ambiguity/gap (not user-delegated, e.g. "reformulate as needed") -> systematically `grill-me` (docs involved -> `grill-with-docs`) to zero ambiguity -> Planify (draft, self-review vs assumptions/alternatives/challenges, show only final analysis+plan) -> Validate (plain-text question before Edit/Write/mutating Bash-git/PR call; read-only skips).
5. End of turn: announce an estimated token count used. Better to continue in a new session -> offer to draft the next-session prompt.

## Error handling

| Trigger | Action |
|---|---|
| External request non-2xx / proxy block | `[BLOCKED] <url> - <status>`; if host required, stop and tell user |
| CI logs inaccessible | Stop, ask before continuing |
| `AskUserQuestion` tool | Broken when reply is delayed (anthropics/claude-code#70648, unfixed) - don't use; ask in plain text instead. Revisit once fixed |
| Validate-gate question (or mutating prompt) unanswered | End turn, don't act (not approval, not even default); wait for reply. Unanswered twice -> stop, report attempt + reason, wait |
| Non-mutating deliverable prompt (e.g. `Artifact`) unanswered | Fall back once to plainer channel, no re-prompt |

## Local dev & verification
- Don't use CI to find out if code works - reproduce locally, fix, then push (target project's own build/lint/test commands).
- No push-to-see-what-CI-says commits. Iterate locally, push when green.
- CI-only, not reproducible locally -> say so, confirm before iterating via CI.
- Before "done/fixed/passing" claims -> run verification commands (`verification-before-completion`). Evidence first.

## Code / docs / commits
- English + ASCII only.
- `caveman`: code comments only (its own rules say write PRs/commits normal). `caveman-commit`: commit messages. Nowhere else.
- Editing this file -> also `prompt-engineering`, on top of the routing above.
- Rewriting any CLAUDE.md for brevity: verify every rule survives with equivalent meaning (rule-by-rule vs the original), get an independent review before merging, A/B two candidates via agent dry-run if unsure which reads clearer.

## PR lifecycle

Diff-changing push = `gh pr create`, `git push`, or MCP `create_pull_request`.

| Trigger | Action |
|---|---|
| Turn would end with an unreviewed diff-changing push, and it's the last task of an EnterPlanMode-approved plan | Run `ponytail-review`, then `requesting-code-review` + `receiving-code-review`, no asking |
| Turn would end with an unreviewed diff-changing push, otherwise | Plain-text question: review now or keep going - ask once, wait until answered or PR merges/closes |
| Metadata-only edit (title/body, no new commits since last review) | Exempt from the above |
| >=2-3 turns since last rename, scope clear/shifted | Draft short title, confirm via plain-text question, rename PR + conversation title (if a rename tool exists) |
| CI green, `mergeable_state: clean`, no unresolved comments | Stop self re-arming (don't wait for merge/close) |
| Anything still pending (CI running, changes requested, conflict, unresolved threads) | Keep polling |

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

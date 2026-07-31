# CLAUDE.md

## Communication
- Concise everywhere - effective (right result) and efficient (least tokens/steps). No filler. Answer first, state facts, no restating the obvious.
- Wording only, not layout - human-readable structure is fine if agent comprehension isn't hurt.
- Match user's language.

## Bootstrap - once per session
1. Sync `.claude` from this repo:
   - Consumer project -> `git subtree pull --prefix=.claude https://github.com/NormandErwan/Claude.git main --squash` automatically.
   - This repo itself (dogfooding) -> skip, still do step 2.
2. `npx skills add` every line below, every session, regardless of step 1's outcome:
   - Never vendored deliberately - this is the only way to get current versions.
   - Leave dotnet-skills and agent-skills uninstalled for now (see Every turn 1, 5).
   ```bash
   npx skills add DietrichGebert/ponytail@ponytail-audit
   npx skills add DietrichGebert/ponytail@ponytail-review
   npx skills add anthropics/skills@frontend-design
   npx skills add juliusbrussee/caveman@caveman
   npx skills add juliusbrussee/caveman@caveman-commit
   npx skills add mattpocock/skills@code-review
   npx skills add mattpocock/skills@codebase-design
   npx skills add mattpocock/skills@domain-modeling
   npx skills add mattpocock/skills@grill-me
   npx skills add mattpocock/skills@grill-with-docs
   npx skills add mattpocock/skills@handoff
   npx skills add mattpocock/skills@improve-codebase-architecture
   npx skills add mattpocock/skills@prototype
   npx skills add mattpocock/skills@research
   npx skills add mattpocock/skills@resolving-merge-conflicts
   npx skills add mattpocock/skills@teach
   ```
3. Skill installed mid-session via `npx skills add` is never invocable via Skill tool this session (roster fixed at session start - guaranteed, not "may not load"):
   - If missing, say so.
   - Read `.claude/skills/<name>/SKILL.md` directly and follow it manually instead of skipping it.

## Every turn
1. Identify the task.
   - Topic is .NET/C#/Blazor, or user asks -> `npx skills add aaronontheweb/dotnet-skills` (whole repo, if not already loaded this session).
   - Topic is web/frontend design, or user asks -> `npx skills add arvindrk/extract-design-system@extract-design-system` and `npx skills add vercel-labs/agent-skills@web-design-guidelines` (if not already loaded this session).
2. Scan local skills, >=1% relevant -> invoke + announce ("Using [skill] to [purpose]").
   - Same rule for any skill invoked this turn from any step (2, 4, or 5) - no silent invocations.
   - Always check regardless of scan:
     - Any file op or multi-file task -> `token-efficiency`.
     - Unfamiliar code area or need the bigger picture -> `token-codebase-exploration`.
     - About to state an unverified factual/technical/procedural claim -> `verifying-sources`.
     - 2+ independent tasks, no shared state/dependency -> `dispatching-parallel-agents`.
3. Obvious? (literal content/command, or one unambiguous reading; one file touched, or one already-named location; zero design choice) -> act.
4. Not obvious, or any suspected ambiguity/gap (not user-delegated, e.g. "reformulate as needed") -> systematically `grill-me` (docs involved -> `grill-with-docs`) to zero ambiguity -> Planify (draft, self-review vs assumptions/alternatives/challenges, show only final analysis+plan) -> Validate (plain-text question before Edit/Write/mutating Bash-git/PR call; read-only skips).
   - Remote/cloud session -> batch `grill-me`: group by independent branch, sequential sub-groups within a branch ok, soft cap ~3-4 branches x 2-3 groups/turn, short recommendation per question.
   - Domain/data model involved -> also `domain-modeling`.
   - New module/interface design -> also `codebase-design`.
   - Unfamiliar domain needing primary sources -> also `research`.
   - Design question needing a throwaway spike -> also `prototype`.
5. Large-scope work (new subsystem, multi-session, or user asks for the full process):
   - User names a specific skill/methodology (e.g. writing-skills) -> follow its own process directly, skip phase routing below.
   - `npx skills add addyosmani/agent-skills` (whole repo, if not already loaded this session).
   - Follow `using-agent-skills` to route by phase: Define (`interview-me`/`idea-refine`/`spec-driven-development`) -> Plan (`planning-and-task-breakdown`) -> Build (`incremental-implementation`/`test-driven-development`/...) -> Verify (`debugging-and-error-recovery`/`browser-testing-with-devtools`) -> Review (`code-review-and-quality`) -> Ship (`git-workflow-and-versioning`/...).
   - Default for normal-sized tasks: skip this, steps 2-4 are enough.
   - Once triggered, agent-skills phases supersede step 4's mattpocock routing for this task.
6. End of turn:
   - Announce estimated tokens used.
   - Offer to draft the next-session prompt (use `handoff` to structure it) when continuing elsewhere is better, proactively at >=100k tokens (non-blocking, continue if ignored).

## Error handling

| Trigger | Action |
|---|---|
| External request non-2xx / proxy block | `[BLOCKED] <url> - <status>`<br>- if host required, stop and tell user |
| CI logs inaccessible | Stop, ask before continuing |
| `AskUserQuestion` tool | Broken when reply is delayed (anthropics/claude-code#70648, unfixed):<br>- don't use, ask in plain text instead<br>- revisit once fixed |
| Validate-gate question (or mutating prompt) unanswered | End turn, don't act, wait silently (hook/notification noise isn't a reply).<br>- Unanswered twice -> stop, report attempt + reason, wait |
| Non-mutating deliverable prompt (e.g. `Artifact`) unanswered | Fall back once to plainer channel, no re-prompt |

## Local dev & verification
- Don't use CI to find out if code works:
  - Reproduce locally, fix, then push (target project's own build/lint/test commands).
- No push-to-see-what-CI-says commits:
  - Iterate locally, push when green.
- CI-only, not reproducible locally:
  - Say so.
  - Confirm before iterating via CI.
- Before "done/fixed/passing" claims:
  - Run verification commands - evidence first.

## Code / docs / commits
- English + ASCII only.
- Any technical/code doc (README, manifests, comments, PR/commit bodies) -> concise first pass, not a tightening pass after: tables/lists over prose, no sentence that just restates what a heading or identifier already says.
- `caveman`: code comments only (its own rules say write PRs/commits normal). `caveman-commit`: commit messages. Nowhere else.
- Editing any CLAUDE.md -> `prompt-engineering` first, draft concise on the first pass (apply its Concise-is-key check before proposing, not after) - no exceptions, never ship a verbose draft to tighten later on request.
- Full rewrite/brevity pass of existing rules -> also: verify each rule survives with equivalent meaning (rule-by-rule), independent review before merging, A/B if unsure which reads clearer.
- Editing CLAUDE.md sections mirrored in `CLAUDE.web.md` (Communication, Every turn, Error handling, Code/docs/commits, Retrospective) -> update `CLAUDE.web.md` in the same commit, except dotnet-skills/extract-design-system/web-design-guidelines/caveman/caveman-commit (need repo/file access web sessions lack) - omitted there. Bootstrap is CLI/npx-only, not mirrored.
- Editing `CLAUDE.web.md` -> also refresh `SKILLS.web.md`: recheck each listed skill's upstream commit (local: `git log`; remote: public GitHub API/clone, no `add_repo`), update rows that moved, and propose a zip download per updated skill via `SendUserFile` for re-upload to claude.ai.

## PR lifecycle

Diff-changing push = `gh pr create`, `git push`, or MCP `create_pull_request`.

| Trigger | Action |
|---|---|
| Turn would end with an unreviewed diff-changing push, and it's the last task of an EnterPlanMode-approved plan | Run `ponytail-review`, then mattpocock `code-review`, no asking |
| Turn would end with an unreviewed diff-changing push, otherwise | Plain-text question: review now or keep going.<br>- Ask once, wait until answered or PR merges/closes |
| Metadata-only edit (title/body, no new commits since last review) | Exempt from the above |
| >=2-3 turns since last rename, scope clear/shifted | Draft short title.<br>- Confirm via plain-text question.<br>- Rename PR + conversation title (if a rename tool exists) |
| Nothing actionable (e.g. CI green or none configured, `mergeable_state: clean`, no unresolved comments) | Stop self re-arming (don't wait for merge/close) |
| Merge conflict blocks the push | Resolve via mattpocock `resolving-merge-conflicts`, then push |
| Anything still pending (CI running, changes requested, unresolved threads) | Keep polling |

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

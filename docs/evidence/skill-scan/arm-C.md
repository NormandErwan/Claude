# CLAUDE.md

## Bootstrap - once per session
1. `SessionStart` hook:
   - It syncs `.claude` from this repo and installs the skills in `skills.txt` into the Skill roster; in this repo, it runs the installer directly.
   - It reports a skill tracked in `SKILLS.md` changed upstream (this repo only) -> update it this session per that file's procedure, without asking.
   - A consumer's root `CLAUDE.md` conflicts with `.claude/CLAUDE.md` -> the root one wins.
   - Session started outside a repository (several attached) -> no hook ran. Say so in the first reply, then from each repository's root run `CLAUDE_PROJECT_DIR=<repo> bash -c '<command>'` for each `SessionStart` command in its `.claude/settings.json`.
2. A skill in `skills.txt` carries `disable-model-invocation: true` -> fork it into `skills/` without that line: the line hides the skill from the agent, and the user does not trigger skills by hand.
3. Skill not in the Skill roster:
   - Installed mid-session -> read `.claude/skills/<name>/SKILL.md`.
   - Hook reported its install failed -> `git clone` the skill's repo, read its `SKILL.md` there.
   - Still unreachable -> say so.

## Behavior
- Fact already surfaced this conversation -> don't repeat it; state only the delta.
- Several checks with nothing to report -> one line. Never collapse away a finding, error, or blocker.
- Replies and deliverables for the user -> the user's language.
- Request carries any ambiguity, unstated requirement, contradiction, or assumption to make -> interview the user before planning or building.
- Recommendation, plan, or choice of approach:
  - Before sending, check: what was taken for granted, an existing solution to reuse, a domain expert's objection, each claim about a file's or a source's content. Revise from what the check finds.
  - Each structuring choice (one that shapes the deliverable's structure, scope, or format) -> its viable options and one recommendation. Never settle it alone.
  - Requested approach has a concrete downside -> before building, state it, quantified, with an alternative, as a structuring choice.
  - Effort estimate -> agent-run work in tool calls or session minutes; human time only for the owner's own steps.
- External request fails (non-2xx or blocked):
  - Another source covers the need -> say so in one line.
  - Otherwise -> `[BLOCKED] <url> - <status>`. Host required -> stop, tell the user.

## Claude Code
- About to claim done, fixed, or passing -> run the verification commands locally first (the project's own build, lint, tests).
- Failure reproducible only in CI -> say so; never push to probe it.
- Shell command on Windows -> Git for Windows' bash, never PowerShell.
- Shell sequence whose later step changes git state (`add`, `commit`, `rebase --continue`, `push`) -> chain with `&&`, never `;`.
- Conflict resolved by script -> read its diff before `git add`; a whole-file diff means its line endings changed.
- Code and its docs (README, comments, commits, PRs, skills) -> English, unless the skill is already in another language.
- Branch or PR named (user, handoff, session setup) -> use its branch without confirmation, over the pre-assigned one.
- On a trunk (`main`, `master`, `develop`) and about to commit, no branch named -> first create `<type>/<kebab-description>` (`feat`, `fix`, `docs`, `chore`, `refactor`), unless the user asked to commit on the trunk.
- Work ready to commit or push -> do it without asking.
- About to force-push a trunk -> don't.
- PR title or body edit -> apply directly.
- PR title reads as a placeholder or no longer matches the diff -> rename it.
- Editing a repository's files its `CONTRIBUTING.md` governs (here: `CLAUDE.md`, `CLAUDE.web.md`, `SKILLS.md`, `PROVENANCE.md`, a skill) -> read that `CONTRIBUTING.md` first, also when a handoff lists the edits.

## Agents
- Raw output (test runs, logs, doc fetches) would flood this context and only the conclusion matters -> delegate.
- Model for a delegated task: no design decision -> `haiku`; wrong answer cheap to catch -> `sonnet`; large refactor, novel design, or costly error -> `opus`.
- Heavy skill -> subagent. Its process spawns agents and nesting is off (`CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1` in env or settings) -> main context instead.
- Work needs context this session holds -> don't delegate it.
- Another model needed mid-task -> subagent. Never recommend switching the session's model or effort mid-session.
- Delegating with `isolation: worktree` -> tell the agent to compare `git log -1` with the intended base before reading anything, and reposition if it drifted. Verify its diff with `git show <ref>:file | diff - file`.

## Retrospective
- A user correction, a rule or skill that failed to fire or to cover the case, a tool block that forced another approach, or a new user preference -> append one row to `RETROSPECTIVE.md` with `>>`, without reading the ledger:
  `| <date> | <events: fact-corrected, skill-gap, tool-blocked, new-preference> | <class, not this instance> | <smallest change> | <rule it replaces, or nothing> | proposed | - |`
- Row appended -> reply with one line: the count filed and their event classes.
- Processing entries -> follow `CONTRIBUTING.md`.

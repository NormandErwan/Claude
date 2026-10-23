# CLAUDE.md

## Bootstrap - once per session
1. `SessionStart` hook:
   - It syncs `.claude` from this repo and injects `using-agent-skills`; in this repo, it runs the injector directly.
   - A consumer's root `CLAUDE.md` conflicts with `.claude/CLAUDE.md` -> the root one wins.
   - Session started outside a repository (several attached) -> no hook ran. Say so in the first reply, then from each repository's root run `CLAUDE_PROJECT_DIR=<repo> bash -c '<command from its .claude/settings.json>'`.
2. `using-agent-skills`:
   - Three or more files, a new module or public interface, work spanning sessions, or a spec or plan asked -> follow its flowchart. Its skills: `.claude/agent-skills/skills/<name>/SKILL.md`, read from disk.
   - Its Core Operating Behaviors 1 (assumptions block) and 2 (stop and wait on confusion) -> don't apply; `Behavior` replaces them. Its other behaviors conflict with this file -> this file wins.
   - User names a specific skill or methodology -> follow its own process, skip the flowchart.
   - Overlaps: `grilling` over `interview-me`; `code-review` + `ponytail-review` over `code-review-and-quality`.
   - Turn would end with an unreviewed pushed diff and no open plan items -> run `ponytail-review`, then `code-review`.
3. Every session -> `npx skills add` each line below. `craft-prompt` and `grilling` are vendored in `skills/` instead.
   ```bash
   npx skills add DietrichGebert/ponytail@ponytail-audit
   npx skills add DietrichGebert/ponytail@ponytail-review
   npx skills add anthropics/skills@frontend-design
   npx skills add juliusbrussee/caveman@caveman
   npx skills add juliusbrussee/caveman@caveman-commit
   npx skills add mattpocock/skills@code-review
   npx skills add mattpocock/skills@codebase-design
   npx skills add mattpocock/skills@domain-modeling
   npx skills add mattpocock/skills@grill-with-docs
   npx skills add mattpocock/skills@handoff
   npx skills add mattpocock/skills@improve-codebase-architecture
   npx skills add mattpocock/skills@prototype
   npx skills add mattpocock/skills@research
   npx skills add mattpocock/skills@teach
   ```
4. Skill not in the Skill roster:
   - Installed mid-session -> read `.claude/skills/<name>/SKILL.md`.
   - `npx` blocked -> `git clone` the skill's repo, read its `SKILL.md` there.
   - Still unreachable -> say so.

## Behavior
- Fact already surfaced this conversation -> don't repeat it; state only the delta.
- Several checks with nothing to report -> one line. Never collapse away a finding, error, or blocker.
- Replies and deliverables for the user -> the user's language. French -> `write-french`.
- Factual claim not verified this turn -> `verify-sources`. Unverified includes a premise from a handoff or earlier session, and a file's content recalled instead of reread.
- Recommendation, plan, or choice of approach:
  - Before sending, check: what was taken for granted, an existing solution to reuse, a domain expert's objection, each claim about a file's or a source's content. Revise from what the check finds.
  - Each structuring choice -> its viable options and one recommendation. Never settle it alone.
  - Requested approach has a concrete downside -> before building, state it, quantified, with an alternative.
- A local skill could help -> invoke it and name it in one line.
  - Recurring failure -> `find-cause`.
  - Personal advice or a method judgment call -> `guide-decision`; a purchase -> `guide-purchase`.
- User signals a pause or a move elsewhere, or the topic drifts -> offer a `handoff`, once per trigger.
- External request non-2xx or proxy block:
  - Another source covers the need -> say so in one line.
  - Otherwise -> `[BLOCKED] <url> - <status>`. Host required -> stop, tell the user.

## Claude Code
- About to claim done, fixed, or passing -> run the verification commands locally first (the project's own build, lint, tests).
- Never push to find out what CI says. CI-only failure -> say so.
- Code and its docs (README, comments, commits, PRs, skills) -> English, unless the skill is already in another language.
- Code comments -> `caveman`. Commit messages -> `caveman-commit`. Neither anywhere else.
- Branch or PR named (user, handoff, session setup) -> use its branch without confirmation, over the pre-assigned one.
- PR title or body edit -> apply directly.
- PR title reads as a placeholder or no longer matches the diff -> rename it.
- Editing `CLAUDE.md`, `CLAUDE.web.md`, `SKILLS.web.md`, `PROVENANCE.md`, or a skill in NormandErwan/Claude -> read its `CONTRIBUTING.md` first.

## Agents
- Raw output (test runs, logs, doc fetches) would flood this context and only the conclusion matters -> delegate.
- Model for a delegated task: no design decision -> `haiku`; wrong answer cheap to catch -> `sonnet`; large refactor, novel design, or costly error -> `opus`. Prices and limits -> `claude-api`, never memory.
- Heavy skill (`write-skill` and similar) -> subagent. Its process spawns agents and nesting is off (`CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1` in env, settings, or the version default) -> main context instead.
- Work needs context this session holds -> don't delegate it.
- Another model needed mid-task -> subagent. Never recommend switching the session's model or effort mid-session.
- Delegating with `isolation: worktree` -> tell the agent to compare `git log -1` with the intended base before reading anything, and reposition if it drifted. Verify its diff with `git show <ref>:file | diff - file`.

## Retrospective
- A user correction, a rule or skill that failed to fire or to cover the case, a tool block that forced another approach, or a new user preference -> append one row to `RETROSPECTIVE.md` with `>>`, without reading the ledger:
  `| <date> | <events> | <class, not this instance> | <smallest change> | <rule it replaces, or nothing> | proposed | - |`
- Row appended -> reply with one line: the count filed and their event classes.
- Processing entries -> follow `CONTRIBUTING.md`.

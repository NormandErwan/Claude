# CLAUDE.md

## Bootstrap - once per session
1. The `SessionStart` hook syncs `.claude` from this repo (in this repo, it runs the injector directly) and injects `using-agent-skills`. A consumer's root `CLAUDE.md` wins over the synced `.claude/CLAUDE.md`.
   - Session started outside a repository (several attached) -> no hook ran. Say so in the first reply, then run each repository's hook by hand from its root: `CLAUDE_PROJECT_DIR=<repo> bash -c '<command from its .claude/settings.json>'`.
   - >=3 files, a new module or public interface, work spanning sessions, or a spec/plan asked -> follow the `using-agent-skills` flowchart; its skills are in `.claude/agent-skills/skills/<name>/SKILL.md`, read from disk. Its Core Operating Behaviors yield to this file. `grilling` over `interview-me`; `code-review` + `ponytail-review` over `code-review-and-quality`.
   - Turn would end with an unreviewed pushed diff and no open plan items -> run `ponytail-review` then `code-review`.
2. `npx skills add` each line, every session (only `craft-prompt` and `grilling` are vendored, in `skills/`):
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
3. A skill installed mid-session is not in the Skill roster: read `.claude/skills/<name>/SKILL.md`. `npx` blocked -> `git clone` its repo and read it there. Still unreachable -> say so.

## Communication
- Show conclusions, questions, and evidence (commands run, sources read) - never your reasoning process: no assumptions block, no list of readings or rejected options, no self-review report.
- State only the delta: never repeat a fact already surfaced this conversation. Several empty checks -> one line; never collapse away a finding, error, or blocker.
- Match the user's language; French -> `write-french`.

## Before acting
1. An ambiguity, a conflict between requirements or rules, or a missing fact would change the answer -> ask, `grilling` format, and wait. Remote session -> batch the questions, one recommendation each. Otherwise answer directly.
2. Factual claim not verified this turn -> `verify-sources`. Includes a premise from a handoff or earlier session and a file's content recalled instead of reread. A claim about the user's own setup, habits, or intent has no source: ask it.
3. Recommending or planning -> check the proposal before sending: reuse an existing solution before building one, what a domain expert would object to, every claim about repository content checked. A concrete downside -> push back: quantify it, propose an alternative.
4. Invoke any local skill that could help, and name it in one line. Recurring failure -> `find-cause`. Personal advice or a method judgment call -> `guide-decision`; a purchase -> `guide-purchase`.
   - Heavy skill (`write-skill` and similar) -> subagent, unless its process spawns agents and nesting is off (`CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1`): then main context.

## Doing the work
- Before claiming done/fixed/passing, run the verification - the project's own build, lint, and tests, locally. Never push to find out what CI says; CI-only failure -> say so.
- Code and its docs (README, comments, commits, PRs, skills) in English, except a skill already written in another language. Deliverables for the user follow the user's language.
- `caveman` for code comments only; `caveman-commit` for commit messages.
- Editing `CLAUDE.md`, `CLAUDE.web.md`, `SKILLS.web.md`, `PROVENANCE.md`, or a skill in this repo -> read `CONTRIBUTING.md` first.
- Pause, move elsewhere, or topic drift -> offer a `handoff` once.

## Agents
- Delegate when raw output (test runs, logs, doc fetches) would flood this context and only the conclusion matters. No design decision -> `model: haiku`; wrong answer cheap to catch -> `sonnet`; large refactor, novel design, or costly error -> `opus`. Prices and limits -> `claude-api`, never memory.
- Never delegate work that needs context this session holds. Another model mid-task -> subagent; never switch the session's model or effort.
- `isolation: worktree` -> the agent checks `git log -1` against the intended base before reading anything. Verify its diff with `git show <ref>:file | diff - file`.

## PR lifecycle
- Title or body edits: apply directly. Title reads as a placeholder or no longer matches the diff -> rename it.

## Error handling

| Trigger | Action |
|---|---|
| External request non-2xx / proxy block | Another source covers the need -> one line. Otherwise `[BLOCKED] <url> - <status>`; host required -> stop, tell the user |
| `AskUserQuestion` | Broken on delayed replies (anthropics/claude-code#70648) - ask in plain text |
| Non-mutating deliverable prompt (e.g. `Artifact`) unanswered | Fall back once to a plainer channel |
| Branch or PR named (user, handoff, session setup) | Use that artifact's branch, no confirmation - overrides the pre-assigned branch |

## Retrospective
- A user correction, a rule or skill that failed to fire or cover the case, a tool block that forced another approach, or a new user preference -> append one row to `RETROSPECTIVE.md`: `| <date> | <event> | <class, not this instance> | <smallest change> | <rule it replaces, or nothing> | proposed | - |`. Reply with one line: the count filed.
- Processing entries -> `CONTRIBUTING.md`.

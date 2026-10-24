# Claude

Natively-authored skills library for Claude Code.

## Where a skill belongs

A skill of general scope belongs here (`NormandErwan/Claude`), English (see `CLAUDE.md`
`Claude Code`). A skill specific to one consumer repo belongs in that repo's own
`skills/` - its `SessionStart` hook never touches it. Every skill, its source, and
whether it is uploaded to claude.ai: `SKILLS.md`.

## Adding this repo to another project

Consumer repos pull this repo's `CLAUDE.md` and `skills/` fresh at every
session start via a `SessionStart` hook - no subtree, no submodule, no
manual sync. The same hook clones
[`addyosmani/agent-skills`](https://github.com/addyosmani/agent-skills) and
injects its `using-agent-skills` router into the session. A router has to be
in context before the first turn: a skill installed mid-session is never
invocable, because the roster froze at session start.

Prerequisite: `jq` on `PATH`. Without it the clone still lands and the hook
says so; the router is not injected.

In the consumer repo:

1. Copy `templates/settings.json` to `.claude/settings.json` - wires the hook.
2. Copy `templates/hooks/session-start.sh` to `.claude/hooks/session-start.sh`
   (keep it executable) - clones this repo fresh each session, refreshes the
   generated files, then runs `templates/hooks/inject-agent-skills.sh` from
   that fresh clone, which also installs the skills in `skills.txt`. Only the thin bootstrap is copied, so the injector
   updates itself afterwards without consumers re-copying anything. A repo set
   up before the injector existed needs this one re-copy to get a router at
   all - the synced `CLAUDE.md` assumes one is injected.
3. Add to `.gitignore` - the generated files are never committed:
   ```
   .claude/CLAUDE.md
   .claude/skills/
   .claude/agent-skills/
   ```
4. Add to the repo's own root `CLAUDE.md`:
   ```markdown
   ## Session Bootstrap

   `.claude/CLAUDE.md` and `.claude/skills/` are regenerated automatically at every session start by
   `.claude/hooks/session-start.sh`, which pulls them fresh from https://github.com/NormandErwan/Claude.
   They are never committed here (see `.gitignore`) - no manual sync step needed.

   BEFORE any response, plan or action:

   1. Read and follow `.claude/CLAUDE.md`.
      If the file cannot be read, stop and report the error before proceeding.
   ```

5. Optionally list topic-specific skills in a root `skills.txt` in the consumer repo, same format
   as this repo's (`<repo> <skill>...`, one upstream repo per line), gated on the consumer
   project's own stack. The hook installs them with this repo's, before the Skill roster
   freezes. They used to auto-trigger from this repo's `CLAUDE.md`, but most consumer projects
   never need any given one, so keeping them in the always-loaded file cost every session
   regardless of relevance (see `PROVENANCE.md`'s 2026-09-08 rows).

   | Need | `skills.txt` line |
   |---|---|
   | .NET/C#/Blazor work | `aaronontheweb/dotnet-skills <skill>...` - name the skills you need (e.g. `csharp-coding-standards efcore-patterns`), a line with no skill name is skipped; `token-dotnet` is already synced with `skills/`, just reference it for search patterns |
   | Web/frontend design work | `arvindrk/extract-design-system extract-design-system` and `vercel-labs/agent-skills web-design-guidelines` |
   | Test design with 3+ combinable parameters | `omkamal/pypict-claude-skill pict-test-designer` |
   | Parallel/sub-agent orchestration | `obra/superpowers dispatching-parallel-agents subagent-driven-development` |
   | Home Assistant config editing | `homeassistant-ai/skills home-assistant-best-practices` |

`.claude/settings.json` and `.claude/hooks/session-start.sh` are the whole
consumer-side infra - nothing else from this repo belongs there. This
repo's own `README.md`, `CLAUDE.web.md`, and `SKILLS.md` stay here only
(`CLAUDE.web.md` and the skills `SKILLS.md` marks `Web` are uploaded by hand to claude.ai).

See `NormandErwan/Accounts` for a working example.

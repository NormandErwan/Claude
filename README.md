# Claude

Natively-authored skills library for Claude Code.

## Usage

External skills are not vendored here. Claude Code installs them per session
via [`npx skills add`](https://skills.sh/) - see `CLAUDE.md`'s `## Bootstrap`
(always-installed set) and `## Every turn` (topic-gated dotnet-skills and
agent-skills) for the exact list and install triggers.

## Adding this repo to another project

Consumer repos pull this repo's `CLAUDE.md` and `skills/` fresh at every
session start via a `SessionStart` hook - no subtree, no submodule, no
manual sync.

In the consumer repo:

1. Copy `templates/settings.json` to `.claude/settings.json` - wires the hook.
2. Copy `templates/hooks/session-start.sh` to `.claude/hooks/session-start.sh`
   (keep it executable) - clones this repo fresh each session and refreshes
   the generated files.
3. Add to `.gitignore` - the generated files are never committed:
   ```
   .claude/CLAUDE.md
   .claude/skills/
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

`.claude/settings.json` and `.claude/hooks/session-start.sh` are the whole
consumer-side infra - nothing else from this repo belongs there. This
repo's own `README.md`, `CLAUDE.web.md`, and `SKILLS.web.md` stay here only
(the `.web` ones are for manual upload to claude.ai projects).

See `NormandErwan/Accounts` for a working example.

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

1. `.claude/settings.json` - wire the hook:
   ```json
   {
     "hooks": {
       "SessionStart": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/session-start.sh"
             }
           ]
         }
       ]
     }
   }
   ```
2. `.claude/hooks/session-start.sh` (executable) - clone this repo fresh and
   refresh the generated files:
   ```bash
   #!/bin/bash
   set -euo pipefail

   REPO_URL="https://github.com/NormandErwan/Claude.git"
   TARGET_DIR="$CLAUDE_PROJECT_DIR/.claude"
   TMP_DIR=$(mktemp -d)
   trap 'rm -rf "$TMP_DIR"' EXIT

   git clone --depth 1 --quiet "$REPO_URL" "$TMP_DIR"

   rm -rf "$TARGET_DIR/skills"
   cp "$TMP_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
   cp -r "$TMP_DIR/skills" "$TARGET_DIR/skills"
   ```
3. `.gitignore` - the generated files are never committed to the consumer
   repo:
   ```
   .claude/CLAUDE.md
   .claude/skills/
   ```
4. Consumer repo's own root `CLAUDE.md` - point at the generated file:
   ```markdown
   ## Session Bootstrap

   `.claude/CLAUDE.md` and `.claude/skills/` are regenerated automatically at every session start by
   `.claude/hooks/session-start.sh`, which pulls them fresh from https://github.com/NormandErwan/Claude.
   They are never committed here (see `.gitignore`) - no manual sync step needed.

   BEFORE any response, plan or action:

   1. Read and follow `.claude/CLAUDE.md`.
      If the file cannot be read, stop and report the error before proceeding.
   ```

That's the whole consumer-side `.claude/`: hook wiring, `.gitignore`, and the
project's own root `CLAUDE.md`. Do not also copy this repo's own
`README.md`, `CLAUDE.web.md`, or `SKILLS.web.md` into it - they stay
exclusive to this repo (the `.web` ones are for manual upload to claude.ai
projects).

See `NormandErwan/Accounts` for a working example.

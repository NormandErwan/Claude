# Claude

Natively-authored skills library for Claude Code.

## Usage

External skills are not vendored here. Three mechanisms bring them in:

| Source | Mechanism | Listed in |
|---|---|---|
| The always-on set | Cloned into `.claude/skills/` by the `SessionStart` hook | `templates/hooks/install-skills.sh` |
| `addyosmani/agent-skills` | Cloned, and its router injected, by the same hook | `templates/hooks/inject-agent-skills.sh` |
| Topic-gated skills | [`npx skills add`](https://skills.sh/), when the topic comes up | `CLAUDE.md` `## Every turn` 1 |

The hook installs rather than `npx` because the Skill roster is built after
`SessionStart` hooks run: a mid-session install is never invocable, and lands in
the working directory rather than `.claude/skills/`. Three shallow clones also
take about 4.7s against roughly 50s for the equivalent `npx` runs, and git gets
through proxies that block npm.

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
   that fresh clone: `install-skills.sh` then `inject-agent-skills.sh`. Only the
   thin bootstrap is copied, so both update themselves afterwards without
   consumers re-copying anything. A repo set up before they existed needs this
   one re-copy - the synced `CLAUDE.md` assumes both have run.
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

`.claude/settings.json` and `.claude/hooks/session-start.sh` are the whole
consumer-side infra - nothing else from this repo belongs there. This
repo's own `README.md`, `CLAUDE.web.md`, and `SKILLS.web.md` stay here only
(the `.web` ones are for manual upload to claude.ai projects).

See `NormandErwan/Accounts` for a working example.

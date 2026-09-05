# Claude

Natively-authored skills library for Claude Code.

## Usage

Most external skills are not vendored here. Three mechanisms bring skills in:

| Source | Mechanism | Listed in |
|---|---|---|
| Most external skills | [`npx skills add`](https://skills.sh/), per session | `CLAUDE.md` `## Bootstrap` (always) and `## Every turn` (topic-gated) |
| `addyosmani/agent-skills` | Cloned and injected by the `SessionStart` hook | `CLAUDE.md` `## Every turn` 6 |
| `craft-prompt`, `grilling` | Forked into `skills/` for local edits, tracked against their upstream in `SKILLS.web.md` | `skills/craft-prompt/`, `skills/grilling/` |

A skill of general scope belongs here (`NormandErwan/Claude`), English + ASCII (see `CLAUDE.md`
`Code / docs / commits`). A skill specific to one consumer repo belongs in that repo's own
`skills/` - its `SessionStart` hook never touches it.

### Forked skills

A skill forked into `skills/` (rather than pulled fresh every session via `npx skills add`)
carries its upstream repo, path, and pinned commit as two columns in `SKILLS.web.md` - local
commit (this repo's own history for the file) and upstream commit (last checked against). To
pull an update: clone the upstream repo, diff the pinned commit against its current HEAD on
that file's path, and apply the result to the fork by hand - no `git subtree`, no stored
pristine copy. Fork only a skill you need to edit locally; everything else stays on `npx`.

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
   that fresh clone. Only the thin bootstrap is copied, so the injector
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

`.claude/settings.json` and `.claude/hooks/session-start.sh` are the whole
consumer-side infra - nothing else from this repo belongs there. This
repo's own `README.md`, `CLAUDE.web.md`, and `SKILLS.web.md` stay here only
(the `.web` ones are for manual upload to claude.ai projects).

See `NormandErwan/Accounts` for a working example.

# Backlog skills and tools for Claude Code: what exists, what to reuse

Date: 2026-11-07. Primary sources only (GitHub pages, raw files, code.claude.com).
`gh api` returned 403 here ("GitHub access to this repository is not enabled"), so stars come from the
GitHub repo pages and last-commit dates from `/commits/main` pages. Aggregators (claudskills.com,
skillselion, lobehub, glama) were used only as leads; their claims are not cited as fact.

## Findings per candidate

### 1. MrLesk/Backlog.md (CLI + MCP + web UI)
- Source: https://github.com/MrLesk/Backlog.md. 7.3k stars, MIT (https://raw.githubusercontent.com/MrLesk/Backlog.md/main/LICENSE). Last commit 2026-10-29 (https://github.com/MrLesk/Backlog.md/commits/main).
- Storage: one `.md` file per task in `backlog/` (or `.backlog/`, or a path set in `backlog.config.yml`); filenames like `back-208 - Add-paste-as-markdown-support-in-Web-UI.md` (https://github.com/MrLesk/Backlog.md/tree/main/backlog/tasks).
- Real item (frontmatter + sections), from https://raw.githubusercontent.com/MrLesk/Backlog.md/main/backlog/tasks/back-208%20-%20Add-paste-as-markdown-support-in-Web-UI.md:
  ```
  ---
  id: BACK-208
  title: Add paste-as-markdown support in Web UI
  status: To Do
  assignee: []
  created_date: '2025-07-26'
  labels: [web-ui, enhancement, markdown]
  dependencies: []
  priority: medium
  ---
  ## Description
  ## Acceptance Criteria
  - [ ] ...
  ```
- Access: CLI (`backlog task create|list|edit|archive|restore|delete`, `--json` on reads) and an MCP server (`backlog mcp start`); `backlog init` installs agent instructions (CLI mode: agent runs `backlog instructions overview`) (README, same repo URL).
- Done handling: Done status, then `task archive` (read-only, keeps ID and links), `restore`, `delete` (README).
- Dependencies: npm, Bun, Homebrew or Nix install; runtime libs not listed on the page. Git optional.
- Hand editing: possible per file, but the id and filename convention is tooling-owned; many files, no single-file view.
- Skill quality: no SKILL.md in the repo as far as the page shows; agent guidance is MCP resources (`backlog://workflow/overview`, `task-creation`, ...) and `AGENTS.md`.

### 2. ether-moon/ether-moon-skills, plugin backlog-md-workflow
- Source: https://github.com/ether-moon/ether-moon-skills. 0 stars, MIT, 1 commit visible (date not shown). Weak adoption.
- Three skills: `setup`, `conventions`, `task-create`; a CLI with `status`, `check`, `install-public-registry`, `init-safe` (same URL).
- `task-create` SKILL.md (https://raw.githubusercontent.com/ether-moon/ether-moon-skills/main/plugins/backlog-md-workflow/skills/task-create/SKILL.md): about 900 words; trigger is "whenever the user asks to create a backlog task, add a TASK, file work into the backlog"; defers create-or-skip to the `conventions` skill; never creates a task with empty description or acceptance criteria.
- Reuse value: the idea of splitting "when to file" (conventions) from "how to file" (task-create). Needs Backlog.md installed.

### 3. dist0com/kanban-skill
- Source: https://github.com/dist0com/kanban-skill. The page presents the product as WildCrane (CLI `akb`, runner, Claude Code plugin); 51 stars, license "Functional Source License 1.1, ALv2 Future License" (not open source until 2 years after each release); cloud and web app closed. Commits on 2026-11-07 are automated "Sync <timestamp>" (https://github.com/dist0com/kanban-skill/commits/main).
- SKILL.md (https://raw.githubusercontent.com/dist0com/kanban-skill/main/skill/SKILL.md): name `kanban`, "Manage the file-based task board with akb"; agent must use `akb help` and never hand-edit. Storage format not described in the skill.
- Verdict: not reusable (agent-only access, restrictive license, tied to a product).

### 4. markdown-tasks (upstream: motlin/claude-code-plugins, plugin `markdown-tasks`)
- Source: https://github.com/motlin/claude-code-plugins (path `plugins/markdown-tasks`). 20 stars, Apache-2.0, last commit 2026-11-04 (https://github.com/motlin/claude-code-plugins/commits/main). Works with Claude Code and Codex.
- Storage: single file `.llm/todo.md`, managed by bundled Python scripts (README: https://raw.githubusercontent.com/motlin/claude-code-plugins/main/plugins/markdown-tasks/README.md).
- Format (https://raw.githubusercontent.com/motlin/claude-code-plugins/main/plugins/markdown-tasks/skills/tasks/SKILL.md):
  ```
  - [ ] Require authentication on API routes.
    Reuse `validateJwt` from `/workspace/project/src/auth/tokens.ts`.
    Expected outcome: unauthenticated requests to `/api/*` return 401.
  - [!] Require authentication on API routes.
    Blocked 2026-08-19 session 94aec27b: validateJwt does not exist; the repo uses `verifyToken`
  ```
  Markers: `[ ]` ready, `[x]` done, `[!]` blocked after a failed attempt, `[>]` claimed.
- Scripts: `task_get.py`, `task_add.py`, `task_mark.py`, `task_archive.py`, `task_unblock.py`. Archive: `task_archive.py` moves `.llm/todo.md` to `.llm/YYYY-MM-DD-todo.md` and carries `[!]` tasks into a fresh file.
- When items are added: commands `add-one-task`, `plan-tasks` (from a planning conversation), `import-plan`, `sweep-todos` (source TODO comments) (README). All user-triggered, not autonomous.
- Hand editing: excellent (plain checklist). Dependency: Python.
- The `markdown-tasks` entry on claudskills.com credits another author; I did not verify it, and motlin's repo is the one I could confirm.

### 5. todo-archive (upstream: PaulRBerg/agent-skills)
- Source: https://github.com/PaulRBerg/agent-skills. 104 stars, MIT, last commit 2026-11-06 (https://github.com/PaulRBerg/agent-skills/commits/main). 44 skills, `todo-archive` listed under Productivity.
- SKILL.md (https://raw.githubusercontent.com/PaulRBerg/agent-skills/main/skills/todo-archive/SKILL.md): archives checked tasks of `.ai/TODO.md` into `.ai/todos/YYYY-MM/DD.md`, leaving unchecked ones; options `--hint`, `--date`, `--dry-run`; `disable-model-invocation: true`. The script uses the Python stdlib only (https://raw.githubusercontent.com/PaulRBerg/agent-skills/main/skills/todo-archive/scripts/archive_todo.py): regex for `- [ ]`/`- [x]` with indent-based nesting.
- It only archives. Nothing says how items get added. Note: it hides itself from the model, which conflicts with this repo's CLAUDE.md rule on `disable-model-invocation`.

### 6. mattpocock/skills
- Source: https://github.com/mattpocock/skills. 317k stars, MIT, last commit 2026-10-31 (https://github.com/mattpocock/skills/commits/main).
- `to-issues` no longer exists; the current skill is `to-tickets` (https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/to-tickets/SKILL.md): `disable-model-invocation: true`; local template `# <NN>: <title>`, `**What to build:**`, `**Blocked by:**`, `**Status:** ready-for-agent`, `- [ ]` acceptance criteria; one file per ticket at `.scratch/<feature>/issues/<NN>-<slug>.md`, numbered from 01; "combining tickets into one file is not allowed".
- `setup-matt-pocock-skills` offers "Local markdown: issues live as files under `.scratch/<feature>/`" next to GitHub or GitLab (https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/setup-matt-pocock-skills/SKILL.md). The seed file `issue-tracker-local.md` (https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/setup-matt-pocock-skills/issue-tracker-local.md) describes: `Status:` line near the top, comments appended under `## Comments`, `Type:`, `Blocked by:`, claim by setting `Status: claimed`, resolve by appending `## Answer`.
- `triage` (https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/triage/SKILL.md): state machine `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`; categories `bug`, `enhancement`; `disable-model-invocation: true`; storage delegated to the configured tracker.
- Reuse value: the status vocabulary and "ready-for-agent vs ready-for-human" split, blocked-by line, claim step. Not a personal backlog (feature-scoped, many files).

### 7. addyosmani/agent-skills, planning-and-task-breakdown
- Source: https://github.com/addyosmani/agent-skills. 113.8k stars, MIT, last commit 2026-11-01 (https://github.com/addyosmani/agent-skills/commits/main).
- SKILL.md (https://raw.githubusercontent.com/addyosmani/agent-skills/main/skills/planning-and-task-breakdown/SKILL.md): persists `tasks/plan.md` and `tasks/todo.md` (checklist), or one tracker item per task if the project designates GitHub Issues, Jira, Linear or beads; never overwrite an incomplete plan without asking. Task fields: Description, Acceptance criteria, Verification, Dependencies, Files likely touched, Estimated scope.
- It is a per-feature plan, not a long-lived personal backlog; no archive rule found.

### 8. todo.txt format, skills and MCP servers
- Format spec (https://raw.githubusercontent.com/todotxt/todo.txt/master/README.md): one line per task; `(A)` priority; leading `x ` = done, with completion date after it; `YYYY-MM-DD` creation date; `+project`; `@context`; `key:value` metadata such as `due:2010-01-02`. Example: `x 2011-03-02 2011-03-01 Review Tim's pull request +TodoTxtTouch @github`.
- I found no GitHub repo for a todo.txt skill or MCP server. Search only returned aggregator listings (a `topydo` skill, a `kurko` dotfiles skill, a markdown todo MCP). Unverified, not cited as fact. [BLOCKED] https://claudskills.com/skills/topydo/ - aggregator, upstream repo not identified.
- Fit: one line per item cannot hold the "context + next step" the user wants, unless it points to a note.

### 9. Claude Code built-in task tools (official docs)
- `TaskCreate`, `TaskGet`, `TaskUpdate`, `TaskList` (and `TodoWrite` when `CLAUDE_CODE_ENABLE_TASKS=0`) are available by default only on Opus 4.7, Sonnet 4.6, Haiku 4.5 and earlier models; on other models the list stays empty unless `CLAUDE_CODE_ENABLE_TODO_TOOLS=1` (https://code.claude.com/docs/en/tools-reference, section "Task tool availability"; https://code.claude.com/docs/en/interactive-mode, section "Task list").
- Persistence: tasks survive context compaction; sharing across sessions needs `CLAUDE_CODE_TASK_LIST_ID`, which uses a named directory in `~/.claude/tasks/` (interactive-mode page). So storage is outside the repo and not git-tracked. Session-scoped by default. Not a backlog.

### 10. eyaltoledano/claude-task-master
- Source: https://github.com/eyaltoledano/claude-task-master. 28.3k stars; "MIT License with Commons Clause" (restricts selling it or hosting it) (https://github.com/eyaltoledano/claude-task-master/blob/main/LICENSE); last commit 2026-04-23 (https://github.com/eyaltoledano/claude-task-master/commits/main).
- `tasks.json` fields: id, title, description, status, dependencies, priority, details, testStrategy, subtasks; statuses `pending`, `in-progress`, `done`, `review`, `deferred`, `cancelled` (https://raw.githubusercontent.com/eyaltoledano/claude-task-master/main/docs/task-structure.md). Needs Node (`npm install -g task-master-ai`), usually an AI provider key; CLI and MCP.
- JSON is not hand-editable in practice; designed for PRD-to-tasks, not a personal backlog. Skip, but the status list is a useful reference.

## Comparison

| Tool | Storage | Item structure | Agent access | Hand edit | Done handling | Deps | License | Last commit / stars |
|---|---|---|---|---|---|---|---|---|
| Backlog.md | file per task in `backlog/` | YAML frontmatter + sections | CLI, MCP | medium | archive / restore / delete | Node/Bun binary | MIT | 2026-10-29 / 7.3k |
| ether-moon backlog-md-workflow | Backlog.md files | same | CLI via skills | medium | via Backlog.md | Backlog.md | MIT | n/a / 0 |
| dist0com kanban-skill | akb board | not shown | `akb` only | no | not shown | akb, npm | FSL 1.1 | 2026-11-07 (sync) / 51 |
| motlin markdown-tasks | `.llm/todo.md` | checkbox + indented context | Python scripts | excellent | whole file rotated, `[!]` kept | Python | Apache-2.0 | 2026-11-04 / 20 |
| PaulRBerg todo-archive | `.ai/TODO.md` | checkbox | one script | excellent | checked tasks to dated archive | Python stdlib | MIT | 2026-11-06 / 104 |
| mattpocock local tracker | `.scratch/<feature>/issues/NN-slug.md` | heading + `Status:`, `Blocked by:` | direct edit | good | `Status: resolved` | none | MIT | 2026-10-31 / 317k |
| addyosmani planning | `tasks/todo.md` | checklist + fields | direct edit | good | not specified | none | MIT | 2026-11-01 / 114k |
| todo.txt | one line per task | prefix grammar | none found | excellent | `x date` line | none | spec | n/a |
| Claude built-in tasks | `~/.claude/tasks/` | id, subject, status | tools | no | session | none | n/a | docs |
| claude-task-master | `tasks.json` | JSON, subtasks | CLI, MCP | poor | status `done` | Node, API key | MIT + Commons Clause | 2026-04-23 / 28.3k |

## Patterns worth borrowing for a single-file, hand-editable, structured backlog

1. Single file, append-only add, like RETROSPECTIVE.md: one table row per item, appended with `>>` without reading. None of the candidates does this; closest are motlin's `task_add.py` and the checkbox files. Table rows cannot hold "context + next step" long text; keep those as short cells or a `ref` to a note file.
2. Fields (union of what the sources converge on): `id`, `created` (todo.txt, Backlog.md `created_date`), `status`, `priority` (todo.txt `(A)`, Backlog.md `priority`), `title`, `context`, `next` (the handoff-like part; motlin: "self-contained, absolute paths, expected outcome"), `blocked-by` (Pocock, Backlog.md `dependencies`), `source` (session/PR link).
3. IDs: sequential `B-<n>` or date-based; append-only with `>>` cannot compute the next number without reading, so prefer a date-time id or `YYYYMMDD-<slug>` to keep the no-read append rule. Backlog.md and Pocock use sequential ids and read the tree first.
4. Statuses: small set. Pocock: `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`; motlin: ready, done, blocked-with-reason, claimed; task-master: pending, in-progress, done, deferred, cancelled. Suggest: `open`, `blocked` (reason required, dated), `done`, `dropped`, plus an `agent|human` owner field.
5. Archive rule: done items leave the main file on a trigger. PaulRBerg: dated file per day/month, leaving unchecked items; motlin: rotate the whole file and carry blocked items; Backlog.md: archive keeps id and is restorable. For a single file: move `done`/`dropped` rows to `backlog-archive.md` (append-only again), run on demand or when the file exceeds a size.
6. When the agent files items: only motlin's README lists triggers (planning conversation, plan import, source TODO sweep) and ether-moon splits it into a `conventions` skill. Define explicit triggers: a deferred task out of scope for the current change, a failure not fixed this turn, a user "later/remind me", a handoff next step; and a rule to ask nothing and append, then report one line (as the Retrospective rule does).
7. Keep the skill short: `task-create` is about 900 words; the user prefers terse skills.
8. Respect this repo's rule that model-invocable skills carry no `disable-model-invocation: true` (PaulRBerg and Pocock both set it).

## Open risks

- Several facts rest on page-rendered summaries from WebFetch (e.g. SKILL.md paths guessed from directory layout and confirmed only when the raw URL returned content); Backlog.md's `backlog/tasks` filenames were read from a listing, stars and dates are as of 2026-11-07.
- `gh api` was blocked, so license/stars were not cross-checked through the API; Backlog.md's SKILL-level quality was not assessed because it ships MCP resources rather than a SKILL.md.
- The kanban-skill repo may be a distribution mirror of a closed product; its storage format was not found.
- The `markdown-tasks` upstream could differ from the claudskills.com attribution; motlin's repo was the one verified.
- Todo.txt skills/MCP: absence of results is not proof none exists.
- Append-only `>>` plus a sequential id is contradictory; the id scheme is a design decision for the user.
- A markdown table breaks on `|` and newlines in free text; long context needs a convention (single line, `<br>`, or a linked note).

## Decision (2026-11-07)

Owner decision after comparing four options (Backlog.md, mattpocock local tickets, plain
todo.txt, a sectioned `BACKLOG.md` with an archive file):

- **Adopt Backlog.md**, piloted on this repo (`NormandErwan/Claude`) only. It supersedes the
  single-file table pattern suggested above: a table is too hard to read and write by hand, and
  a single file is not a requirement.
- **One task = one session = one PR.** A session starts from a task; the task carries the
  handoff (plan, notes, final summary); the PR cites the task id.
- **Agent access through the CLI**, guided by `backlog instructions`, not the MCP server: nothing
  to configure in ephemeral cloud containers, no tool schemas in context.
- **Retrospective stays a ledger.** It holds the "why" (incident and class) and keeps its
  no-read `>>` append and whole-ledger processing (recurrence detection). An entry accepted at
  processing becomes a Backlog.md task, then a PR; `Landed in` cites both. Provenance unchanged.
  `casebook` is untouched: it cannot impose Backlog.md on its adopters.

### Pilot observations (Backlog.md 1.55.3, run in this session, then removed)

- `npm i -g backlog.md`: 2.8 s.
- `backlog init "Claude" --defaults --integration-mode cli --agent-instructions none
  --auto-open-browser false` writes only `backlog/config.yml`; `auto_commit: false`,
  `check_active_branches: true`, `remote_operations: true` by default.
- ID allocation across branches: a task committed on a local branch is seen (next id is 2).
  In a `--single-branch` clone the other branch is invisible and the id collides (`TASK-1`
  twice). With a wide fetch refspec (`+refs/heads/*:refs/remotes/origin/*`, the cloud clones'
  setting here), `backlog task create` fetched the remote branches itself and allocated
  `TASK-2`. Not tested: two sessions creating a task before either pushes.
- `.gitignore` is an allowlist: `backlog/` (and `docs/`) need `!dir/` + `!dir/**` lines.

### Next tasks (to become the first Backlog.md tasks)

1. Set up Backlog.md here: init as above, `.gitignore` lines, install in the `SessionStart`
   hook (this repo only), a `CLAUDE.md` rule pointing to `backlog instructions`.
2. Test id collisions between two cloud sessions that both create a task before pushing.
3. Change `CONTRIBUTING.md` RETROSPECTIVE processing: an accepted entry -> a task; `Landed in`
   cites task and PR.
4. Process the retrospective entry filed on 2026-11-07 (one task per session).

## Decision revised (2026-11-07, after the pilot)

The Backlog.md pilot (PR #119, PR #120) proved too heavy for one owner: a file per task, a
frontmatter often longer than the task, and a session per subtask. Replaced by one root
`BACKLOG.md`, one section per task written as a short handoff, deleted once done (no archive:
the PR and git history keep the trace). Format and rules live in the native `backlog` skill: a
consumer repo receives this repo's `CLAUDE.md` and `skills/`, never its `BACKLOG.md`.

Kept from the pilot and from mattpocock's tracker skills (`to-tickets`, `triage` and its
`AGENT-BRIEF.md`, `issue-tracker-local.md`), as skill rules:
- One task fits one PR; larger work splits into tasks linked by `Blocked by` (Backlog.md size
  test, Pocock blocking edges).
- Search before adding; no implementation plan at creation (Backlog.md guides).
- Behavior and decisions, not file paths or line numbers; testable done criteria; explicit out
  of scope (Pocock agent brief).
- `needs owner` status (Pocock `ready-for-human`).
- Commit task edits with the session's work (cloud containers are ephemeral; implication 10
  of `2026-11-07-backlog-md-usage.md`).

Dropped: sequential ids (collided across sessions in the TASK-1.2 test; the title is the key),
per-task definition of done (repo checks and reviews are already `CLAUDE.md` rules), claims
pushed before work (cross-branch claims need a push per status change; the owner names the task
instead), Pocock's frontier (take the first ready task: the owner names tasks), the tool install. Not adopted yet: Pocock's `.out-of-scope/` record of rejected
requests; a dropped task's reason goes in the commit message.

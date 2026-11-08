# Backlog.md in practice: configuration, workflow, agent integration, pitfalls

Date: 2026-11-07. Complements `docs/research/2026-11-07-backlog-skills.md` (candidate comparison and
decision, not repeated here). Scope: how Backlog.md 1.55.3 is configured and run, especially with AI
agents, and what that implies for the pilot on this repo.

Method and limits:
- CLI facts were checked by running the installed `backlog` 1.55.3 in a throwaway git repo.
  They are cited as
  "CLI: `<command>`".
- GitHub tools were scoped to this repo, so upstream files came through WebFetch of github.com and
  raw.githubusercontent.com pages. WebFetch summarizes pages with a small model; wording below is
  paraphrase unless quoted, and quotes are short.
- Real third-party repos that commit a `backlog/` folder: none found by search (see Unverified leads).
  The only real committed `backlog/` verified is the Backlog.md project's own, which is the author's
  dogfooding, not independent practice.

## 1. Verified facts

### 1.1 Configuration

Defaults after `backlog init --defaults` (CLI: `backlog init "Demo" --defaults --integration-mode cli
--agent-instructions none --auto-open-browser false`, then `cat backlog/config.yml` and `backlog config list`):
- `statuses: ["To Do", "In Progress", "Done"]`, `default_status: "To Do"`, `labels: []`,
  `auto_commit: false`, `remote_operations: true`, `check_active_branches: true`,
  `active_branch_days: 30`, `task_prefix: "task"`, `bypass_git_hooks: false`.
- `backlog config list` also shows `priorities: [High, Medium, Low]`,
  `types: [bug, feature, enhancement, task, chore, docs, spike]`, `projects: []`, `milestones: []`,
  `definitionOfDone: []`, `zeroPaddedIds: (disabled)`, and `taskPrefix: task (read-only)`.
- The default window is 30 branch days; the author's own repo uses 10 (see below). The README lists
  `activeBranchDays` under "cross-branch accuracy" (https://raw.githubusercontent.com/MrLesk/Backlog.md/main/README.md);
  ADVANCED-CONFIG.md says lower values improve performance
  (https://raw.githubusercontent.com/MrLesk/Backlog.md/main/ADVANCED-CONFIG.md).

What the author's own project sets (https://raw.githubusercontent.com/MrLesk/Backlog.md/main/backlog/config.yml):
- `statuses: ["To Do", "In Progress", "Done"]` (the default), `labels: []`, task prefix `back`,
  `auto_commit: false`, `remote_operations: true`, `check_active_branches: true` with a 10-day window.
- `definition_of_done` has three items, all conditional on what changed:
  - "bun run check:types passes when TypeScript touched"
  - "bun run check . passes when formatting/linting touched"
  - "bun test (or scoped test) passes"
- No custom statuses, no labels. Task types (`type: enhancement`) and `references`/`modified_files`
  fields do appear in a real task (https://raw.githubusercontent.com/MrLesk/Backlog.md/main/backlog/tasks/back-705%20-%20Add-incremental-documentation-edits-to-the-CLI.md).
  So the author's practice is: stock statuses, no label taxonomy, DoD = repo checks.

How to set things (CLI):
- `backlog config set` accepts: `defaultEditor, projectName, defaultAssignee, defaultStatus, statuses,
  labels, priorities, types, projects, milestones, definitionOfDone, dateFormat, maxColumnWidth,
  defaultPort, autoOpenBrowser, hideEmptyColumns, remoteOperations, autoCommit, filesystemOnly,
  bypassGitHooks, zeroPaddedIds, checkActiveBranches, activeBranchDays` (printed by an invalid-key error).
  But `backlog config set definitionOfDone '["a"]'` is refused: "definitionOfDone cannot be set directly".
  Use the interactive `backlog config`, the Web UI, or edit the YAML key `definition_of_done`.
- I appended `definition_of_done:` with two items to `backlog/config.yml`; `backlog config get
  definitionOfDone` returned both, and a new task got a `## Definition of Done` block with
  `- [ ] #1 repo checks pass` and `- [ ] #2 PR cited` between `<!-- DOD:BEGIN -->` and `<!-- DOD:END -->`.
  Defaults apply to every new task; `--dod` adds per task; `--no-dod-defaults` skips
  (CLI: `backlog task create --help`; README).
- `backlog task edit <id> --check-dod N` checks an item; the finalization guide says to check only proven
  items (CLI: `backlog instructions task-finalization`).
- `zeroPaddedIds`: `backlog config set zeroPaddedIds 3` after init produced `task-001`-style filenames
  and ids for new tasks (CLI). It is also an init flag `--zero-padded-ids <n>`. Not tested: what happens
  to tasks created before the setting changes.
- `task_prefix` is letters only, set at init with `--task-prefix`, read-only afterward (CLI:
  `backlog init --help`, `backlog config list`). `draft`, `doc` and `decision` are reserved.
- ADVANCED-CONFIG.md states `labels`, `types` and `priorities` are edited in the config file rather than
  `config set`, but the CLI in 1.55.3 lists them as settable keys; the doc is stale on that point.

### 1.2 Workflow conventions (the author's stated ones)

README, "Working with AI agents" (https://raw.githubusercontent.com/MrLesk/Backlog.md/main/README.md):
- Four steps: describe the idea and let the agent split it into small tasks; one task per agent session
  and one PR per task; the agent writes an implementation plan right before coding; implement and verify.
- Three review checkpoints: spec (description and acceptance criteria), plan, code.
- When output is poor: clear plan, notes and final summary, refine the task, rerun in a fresh session.
- Hand editing is discouraged: use commands, not manual edits of task files.

The author's own `AGENTS.md` (https://raw.githubusercontent.com/MrLesk/Backlog.md/main/AGENTS.md):
- Start of each conversation: `backlog instructions overview`; read the matching guide before creating,
  executing or finalizing a task; assign yourself with `-a @your-name`; never edit Backlog markdown by hand.
- Branch: `tasks/back-123-feature-name`. Commit subject and PR title: `BACK-123 - Title of the task`.
  "Every PR needs an associated Backlog task, including documentation PRs." Only `AGENTS.md`-only
  changes go straight to `main`.
- On completion the agent commits, pushes to the task branch and opens or updates the PR without asking;
  it asks before anything touching `main`.
- Its own DoD is not restated there; it points to the task's DoD and the repo checks.

Built-in guides, run locally (CLI: `backlog instructions overview|task-creation|task-execution|task-finalization`):
- Create a task only when work "requires planning, decisions, or handoff notes"; search first; skip for
  questions, exploration, obvious mechanical edits.
- Size test: "Can this be completed in a single focused pull request?" Subtasks (`-p`) when work shares one
  goal and one subsystem; separate tasks with `--dep` when independent components.
- Creation captures intent, context, acceptance criteria, references, dependencies. No implementation
  plan at creation (exception: already-started work created directly In Progress). The worker records
  `--plan` after activating the task.
- Execution: read the task, set `-s "In Progress" -a @name`, research, `--plan`, work in short loops,
  `--append-notes`, `--comment` for review questions. Scope creep: "stop and ask the user".
- Finalization: verify each acceptance criterion and DoD item with objective evidence, `--check-ac` and
  `--check-dod`, write `--final-summary`, then `-s Done`. "Do not create or start follow-up tasks
  without user approval."
- Lifecycle: finished tasks stay on the board in Done "until periodic cleanup"; archive afterward
  (`backlog cleanup` archives final-status tasks older than a chosen age, interactive only; CLI:
  `backlog cleanup --help`). Archive also takes canceled, duplicate or invalid work at any time.
  Archived tasks are read-only, keep id and links, and `restore` brings them back. Delete requires archive
  first. A dependency on an archived task counts as satisfied only if that task was in the final status.
- Task BACK-691 in the author's repo is titled "Keep finished work out of the archive and clarify task
  lifecycle" (https://github.com/MrLesk/Backlog.md/tree/main/backlog/tasks): Done-not-archived is the
  recent, deliberate convention.

Fields in practice (real task BACK-705, URL above): frontmatter has `status: Done`,
`assignee: ['@codex']`, `created_date`, `updated_date`, `type`, `references` (issue and PR URLs, source
paths), `modified_files`; body sections Description, Acceptance Criteria, Definition of Done,
Implementation Plan, Implementation Notes, Final Summary. So the author does put the PR URL in
`references`, and uses `@codex` / `@claude` style assignees (see 1.4, BACK-759 counts).

Subtasks, drafts, docs, decisions (CLI, scratch repo):
- `backlog task create -p task-003 "Sub"` produced `task-003.01 - Sub.md` (dotted id, same folder).
- Drafts: `backlog draft create` gives `DRAFT-001` in `backlog/drafts/`; `promote` turns it into a task
  (`backlog draft --help`); CLI-INSTRUCTIONS.md also has `task demote` (https://raw.githubusercontent.com/MrLesk/Backlog.md/main/CLI-INSTRUCTIONS.md).
- Docs: `backlog doc create` gives `doc-001` in `backlog/docs/`; decisions: `decision-001` in
  `backlog/decisions/` with a status you edit; both archive/restore/delete like tasks.
- The author's repo keeps `docs/` with `doc-001 Testing-Style-Guide`, `doc-002 Configuring VIM and Neovim`,
  `doc-003 Running Backlog Browser as a Service` (https://github.com/MrLesk/Backlog.md/tree/main/backlog/docs):
  docs are used for how-tos and guides, not for per-task notes.
- Not found: a documented convention for when to use a decision vs a doc, and no evidence of the author
  using `decision` heavily (the repo has a `decisions/` folder; contents not enumerated).
- No evidence of milestones, labels or priorities beyond defaults in the author's repo (labels: `[]`).

### 1.3 Agent integration

- README: `backlog init` offers "CLI instructions (recommended)", an optional MCP connector for Claude
  Code, Codex, Gemini CLI, Kiro or Cursor, or none. For MCP, a note in CLAUDE.md or AGENTS.md points to
  `backlog://workflow/overview`; `BACKLOG_CWD` or `--cwd` pins the project
  (https://raw.githubusercontent.com/MrLesk/Backlog.md/main/README.md).
- CLI: `backlog init --integration-mode` defaults to `cli`, "cli instructions are recommended";
  `--agent-instructions` takes `claude, agents, gemini, copilot, cursor, none`. `backlog agents
  --update-instructions` refreshes "the short Backlog.md CLI nudge" while preserving other content of
  the file (CLI: `backlog agents --help`). So the managed content is a short pointer to
  `backlog instructions overview`, not a long rulebook; the rules live in the CLI, versioned with it.
- `--agent-instructions none` writes nothing (CLI, and the previous research note). Then nothing tells the
  agent that Backlog exists. The author's AGENTS.md shows the pointer being the session trigger.
- Machine-readable reads: `task list|view`, `draft list`, `decision list`, `search` accept `--json`
  (versioned); `--plain` is the agent-readable text mode (CLI: `backlog instructions overview`).
- Plan / notes / final summary: plan recorded before coding; notes appended during work; final summary
  at the end ("what changed, why, verification results, relevant risks or follow-ups"); comments for
  review questions (CLI: execution and finalization guides).
- Author's reported rationale: in the launch thread he says the fix for messy Claude Code output was
  process rather than model strength, and a commenter says the shipped "as big as they would fit in a pr"
  instruction improved Claude's results (HN item 44483530, reached via search snippets at
  https://hn.svelte.dev/item/44483530; page itself not fetched, treat as lead).

### 1.4 Known pitfalls

ID allocation and duplicates:
- Duplicate ids arise when two clones or sessions create tasks before either pushes. Issue #632 describes an
  AI session creating TASK-123 on remote main while a stale local session created another TASK-123; filenames
  differed, so git merged both without conflict; one was silently dropped on load
  (https://github.com/MrLesk/Backlog.md/issues/632; fix = warning, merged 2026-07-01 as BACK-516).
  Existing safeguards cover one machine and branch scans, not divergent histories merged later.
- Issue #937 (open): a user reports seven duplicate ids in one week on one board from two machines;
  "Fetch-before-edit cannot close this distributed race"; proposals are compare-and-swap refs for a counter
  or a `task create --id` flag (https://github.com/MrLesk/Backlog.md/issues/937). Not fixed upstream.
- Issue #1063 (open): git-ref claims (`refs/claims/<ticket>`) to stop two agents starting the same task;
  notes that assignee names are not identities (BACK-759 had 266 tasks on `@codex` and 122 on `@claude`)
  (https://github.com/MrLesk/Backlog.md/issues/1063).
- Issue #1146 (open): with duplicate ids present in 1.55.x, `task list`, `task list --json` and `search`
  exit 1 and print nothing to stdout; `task view`/`edit` of non-colliding ids still work
  (https://github.com/MrLesk/Backlog.md/issues/1146). A duplicate can break listing for the whole board.
- Repair: `backlog doctor` diagnoses duplicate ids (tasks, docs, decisions, drafts) and cycles;
  `doctor --fix` renames duplicate task files and rewrites frontmatter ids, and "ambiguous references are
  reported for human review" (CLI: `backlog doctor --help`). Open issues #1147 and a closed #1134 show
  `--fix` has had bugs (bundles completed/ to archive/ move; ENAMETOOLONG); a commenter warned it may
  renumber the wrong file (#997 page).
- Archived-id reuse: #997 (open) reports `task create` reusing an id of an archived task (scans `tasks/`
  and `completed/` but not `archive/tasks/`), reported on 1.50.1 to 1.53.0
  (https://github.com/MrLesk/Backlog.md/issues/997). In 1.55.3 I archived `task-001` and the next create
  returned `task-002`, so that path is fixed locally (CLI). Issue #1042 (closed) is titled "Allow archived
  task IDs to remain reserved during allocation". Demote may still free ids per the #997 comments (not tested).
- Release notes via an aggregator (lead, not primary): v1.48.0 added duplicate detection and `doctor`
  and fixed id allocation across worktrees; v1.50.1 took "a fresh bounded remote snapshot" before
  allocating, and tasks existing only on another branch stopped resolving from `task view`/`edit`
  (https://newreleases.io/project/github/MrLesk/Backlog.md/release/v1.50.1).
- Previous note's finding stands (single-branch clones hide other branches; wide refspec clones fetch them).

Merge conflicts on task files: no upstream doc found on conflict policy. Structural reasons: one file per
task with a title-slug in the filename (CLI: `task-003 - T-three.md`), so two branches adding tasks do not
conflict, which is exactly why id duplicates merge silently (#632). Status/notes edits on the same task
from two branches would conflict as ordinary text. Issue #1110 (closed) says `task edit` once deleted
unrecognised `## ` sections, and #1178 (closed) says a non-ASCII title edit left two files with one id;
both are fixed upstream but show the editing surface is still young
(https://github.com/MrLesk/Backlog.md/issues?q=is%3Aissue). Hand edits are discouraged.

Cloud / ephemeral sessions: nothing in the README or guides addresses them. Relevant mechanics (CLI):
`remote_operations: true` warns when no git remote exists; task files are plain uncommitted files with
`auto_commit: false`, so a session that ends before commit loses the update; the CLI needs a binary
installed per container (README: npm, Bun, Homebrew, Nix).

## 2. Unverified leads

- Independent users: I found no third-party public repo committing a `backlog/` folder, no blog post by a
  non-author on configuration, and no Claude Code experience report. Search only returned the upstream
  repo, forks, and skill aggregators (skillsmp.com, skillselion.com, skills.sh, glama.ai). A GitHub code
  search for `definition_of_done` or `task_prefix` (needs a signed-in session) is the next step.
- Author's conference talk "Backlog.md: terminal kanban board for managing tasks with AI agents"
  (https://ai.engineer/talks/backlog-md-terminal-kanban-board-for-managing-tasks-with-ai-agents-alex-gavrilescu-funstage)
  is listed by search; its content was not fetched, so the claim that agents are told to mark Done only
  when the DoD is met is a snippet, not verified.
- GitHub Discussions were not read. Issues #1013 ("Option to give subtasks top-level IDs"), #1034 (MCP
  rooted at main checkout breaks worktree isolation) and #1182 (MCP `task_list` omits tasks in
  completed/ or archive/) are titles only.
- HN thread 44483530 quotes (author rationale, "as big as a PR") come from search snippets.
- Whether `zeroPaddedIds` renames existing files when changed, and what demote does to ids: not tested.
- Two sessions creating a task before pushing: still untested (carried from the previous note).

## 3. Implications for this pilot

1. Definition of done: all three proposed items fit the author's pattern (his is repo checks only). Two
   changes: write the repo-check item conditionally on what the PR touches if checks differ per area, and
   make "PR cited in the task" concrete as "PR URL in `--ref`" (the author's BACK-705 does this); it can
   only be ticked after the PR exists, so finalization order is: PR opened, ref added, check DoD, final
   summary, Done. Set it in `backlog/config.yml` as `definition_of_done` (the `config set` form is refused).
2. `agent-instructions none` removes the only session trigger the tool ships. Common practice (the author's
   own AGENTS.md) is a short pointer to `backlog instructions overview`. Keep the planned CLAUDE.md rule, and
   make it that one line plus "read the matching guide before create / execute / finalize". `backlog
   agents --update-instructions` can manage a block in CLAUDE.md later, if wanted.
3. Naming conflicts with CLAUDE.md: the author uses branch `tasks/<id>-<slug>` and commit/PR title
   `ID - Title`; this repo's rules require `<type>/<kebab>` branches and Conventional Commits via
   `caveman-commit`. Recommend keeping this repo's rules and citing the task id in the PR title/body and a
   commit footer. Decide it explicitly, it is a structuring choice for the owner.
4. Guides say "do not create or start follow-up tasks without user approval" and "stop and ask" on scope
   creep. That clashes with this repo's append-without-asking habit for retrospective and deferred work.
   Decide whether agents may create follow-up tasks (as drafts is a middle path: `--draft`, then
   `promote` by the owner).
5. Done is not archive: leave finished tasks in Done, archive in batches (`backlog cleanup` is interactive,
   so it is a human step; scripts can use `task archive <id>`). Archive early only for canceled work.
6. ID collisions are the real risk and are unresolved upstream (#937, #1063, #1146). Mitigate: wide-refspec
   clones, `backlog doctor` as a check at session start or in review, create tasks on `main` rather than on
   feature branches, push the new task promptly, and avoid two cloud sessions creating tasks concurrently.
   The planned collision test (TASK-1.2) is justified; add `doctor` to what it checks.
7. Defaults are fine as piloted: statuses stock, labels empty (the author does the same), types are built in
   (`bug, feature, enhancement, task, chore, docs, spike`), `auto_commit: false`, prefix `task`.
   Decide zero-padding now, before the first task, because I did not test how existing ids behave when
   it changes: `zeroPaddedIds 3` gives sortable `task-001` filenames.
   `active_branch_days` 30 vs the author's 10: keep 30 for a low-traffic repo (more cross-branch safety),
   no change needed.
8. Subtasks create dotted ids (`task-003.01`); the author's visible listing shows none. Keep one task = one
   PR flat; use `--dep` for ordering, subtasks only for one-goal-one-subsystem splits.
9. Plan, notes, final summary: use them as the handoff, as piloted. Task creation should not contain a plan;
   the worker writes `--plan` after moving it In Progress. Review-gate checkpoints (spec, plan, code)
   suggest the owner approves the plan before coding on non-trivial tasks.
10. Cloud sessions: nothing upstream covers ephemeral containers. With `auto_commit: false` the task edits
    must be committed with the PR in the same session, or lost; add this to the CLAUDE.md rule.

---
id: TASK-1.1
title: Install Backlog.md and the task-filing rule
status: Done
assignee: []
created_date: '2026-11-07T21:31:00Z'
updated_date: '2026-11-07T21:33:00Z'
labels: []
dependencies: []
references:
  - https://github.com/NormandErwan/Claude/pull/120
parent_task_id: TASK-1
ordinal: 2000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Init (CLI integration, no agent instruction files, auto_commit false), .gitignore allowlist, SessionStart install pinned to 1.55.3 (this repo only, not templates/), CLAUDE.md rule gated on backlog/, definition_of_done in backlog/config.yml.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 backlog/ tracked by git
- [x] #2 SessionStart installs backlog.md@1.55.3 without blocking the session on failure
- [x] #3 CLAUDE.md rule plus PROVENANCE.md row, test waived by owner
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 Repo checks pass: bash .claude/hooks/check-skills.sh --check and bash .claude/hooks/test-check-skills.sh
- [x] #2 backlog doctor reports no duplicate ID, on this branch or across branches
- [x] #3 Reviewed: ponytail-review, then mattpocock code-review
- [x] #4 PR URL added to the task with --add-ref
<!-- DOD:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Init done (CLI mode, no instruction files, auto_commit false, prefix task, no padding). .gitignore allowlists backlog/. SessionStart installs backlog.md@1.55.3 (this repo only), echoes a message on failure. CLAUDE.md rule gated on backlog/: file deferred, discovered or out-of-scope work without asking, announce in one line; named task id -> backlog instructions. PROVENANCE row records the owner's test waiver. definition_of_done set in backlog/config.yml (config set refuses it).
<!-- SECTION:FINAL_SUMMARY:END -->

---
id: TASK-1.1
title: Install Backlog.md and the task-filing rule
status: To Do
assignee: []
created_date: '2026-11-07T21:31:00Z'
labels: []
dependencies: []
parent_task_id: TASK-1
ordinal: 2000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Init (CLI integration, no agent instruction files, auto_commit false), .gitignore allowlist, SessionStart install pinned to 1.55.3 (this repo only, not templates/), CLAUDE.md rule gated on backlog/, definition_of_done in backlog/config.yml.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 backlog/ tracked by git
- [ ] #2 SessionStart installs backlog.md@1.55.3 without blocking the session on failure
- [ ] #3 CLAUDE.md rule plus PROVENANCE.md row, test waived by owner
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 Repo checks pass: bash .claude/hooks/check-skills.sh --check and bash .claude/hooks/test-check-skills.sh
- [ ] #2 backlog doctor reports no duplicate ID, on this branch or across branches
- [ ] #3 Reviewed: ponytail-review, then mattpocock code-review
- [ ] #4 PR URL added to the task with --ref
<!-- DOD:END -->

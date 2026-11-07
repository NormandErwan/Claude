---
id: TASK-1.5
title: Roll Backlog.md out to the owner's other repos
status: To Do
assignee: []
created_date: '2026-11-07T21:31:00Z'
updated_date: '2026-11-07T21:31:00Z'
labels: []
dependencies:
  - TASK-1.1
  - TASK-1.2
parent_task_id: TASK-1
ordinal: 6000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
After the pilot: install through templates/ for consumer repos, so the CLAUDE.md rule gated on backlog/ takes effect there. Each repo needs its own PR.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Consumer repos get backlog/ and the install hook
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 Repo checks pass: bash .claude/hooks/check-skills.sh --check and bash .claude/hooks/test-check-skills.sh
- [ ] #2 backlog doctor reports no duplicate ID, on this branch or across branches
- [ ] #3 Reviewed: ponytail-review, then mattpocock code-review
- [ ] #4 PR URL added to the task with --ref
<!-- DOD:END -->

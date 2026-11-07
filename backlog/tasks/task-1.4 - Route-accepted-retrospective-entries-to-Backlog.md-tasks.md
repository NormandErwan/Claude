---
id: TASK-1.4
title: Route accepted retrospective entries to Backlog.md tasks
status: To Do
assignee: []
created_date: '2026-11-07T21:31:00Z'
labels: []
dependencies: []
parent_task_id: TASK-1
ordinal: 5000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
CONTRIBUTING.md RETROSPECTIVE.md processing: an accepted entry becomes a Backlog.md task, then a PR; the Landed in column cites both.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 CONTRIBUTING.md updated
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 Repo checks pass: bash .claude/hooks/check-skills.sh --check and bash .claude/hooks/test-check-skills.sh
- [ ] #2 backlog doctor reports no duplicate ID, on this branch or across branches
- [ ] #3 Reviewed: ponytail-review, then mattpocock code-review
- [ ] #4 PR URL added to the task with --ref
<!-- DOD:END -->

---
id: TASK-1.2
title: Test task ID collisions between two sessions
status: To Do
assignee: []
created_date: '2026-11-07T21:31:00Z'
updated_date: '2026-11-07T21:32:00Z'
labels: []
dependencies: []
parent_task_id: TASK-1
ordinal: 3000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Two cloud sessions both create a task before either pushes. Simulate with a bare repo and two clones; record the result and pick a mitigation with the owner.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Collision case reproduced and documented
- [ ] #2 Mitigation chosen by the owner and applied
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 Repo checks pass: bash .claude/hooks/check-skills.sh --check and bash .claude/hooks/test-check-skills.sh
- [ ] #2 backlog doctor reports no duplicate ID, on this branch or across branches
- [ ] #3 Reviewed: ponytail-review, then mattpocock code-review
- [ ] #4 PR URL added to the task with --add-ref
<!-- DOD:END -->

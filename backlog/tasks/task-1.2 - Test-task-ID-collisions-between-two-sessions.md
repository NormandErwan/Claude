---
id: TASK-1.2
title: Test task ID collisions between two sessions
status: Done
assignee: []
created_date: '2026-11-07T21:31:00Z'
updated_date: '2026-11-07T21:33:00Z'
labels: []
dependencies: []
references:
  - https://github.com/NormandErwan/Claude/pull/120
parent_task_id: TASK-1
ordinal: 3000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Two cloud sessions both create a task before either pushes. Simulate with a bare repo and two clones; record the result and pick a mitigation with the owner.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Collision case reproduced and documented
- [x] #2 Mitigation chosen by the owner and applied
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
Bare repo + two clones. Both create a task before either pushes -> both get TASK-1; merging the branches gives no git conflict, then Backlog.md warns and blocks ID-based commands on the ambiguous id. backlog doctor also reports cross-branch collisions before merge and previews a renumbering (--fix --yes applies it); it always exits 0, so it cannot gate CI as is. Owner's mitigation: 'backlog doctor reports no duplicate ID' added to definition_of_done. Upstream issues #937, #1063, #1146 (see docs/research/2026-11-07-backlog-md-usage.md).
<!-- SECTION:FINAL_SUMMARY:END -->

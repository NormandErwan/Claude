---
id: TASK-1.3
title: Define the framing, breakdown and planning method
status: To Do
assignee: []
created_date: '2026-11-07T21:31:00Z'
labels: []
dependencies: []
parent_task_id: TASK-1
ordinal: 4000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Method to frame, decompose and plan work with the agent before building: interview-me (framing), spec-driven-development (requirements), planning-and-task-breakdown (into Backlog.md tasks). Includes the definition of a task and its granularity: small task -> one session and one PR for the whole task; large task -> one subtask per session; a session may open several PRs (RETROSPECTIVE.md 2026-11-07). Wait until the tool has been used for a while.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Method written down and wired into CLAUDE.md or a skill
- [ ] #2 Task and subtask definitions recorded
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 Repo checks pass: bash .claude/hooks/check-skills.sh --check and bash .claude/hooks/test-check-skills.sh
- [ ] #2 backlog doctor reports no duplicate ID, on this branch or across branches
- [ ] #3 Reviewed: ponytail-review, then mattpocock code-review
- [ ] #4 PR URL added to the task with --ref
<!-- DOD:END -->

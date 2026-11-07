---
id: TASK-1.4
title: Route accepted retrospective entries to Backlog.md tasks
status: Done
assignee: []
created_date: '2026-11-07T21:31:00Z'
updated_date: '2026-11-07T21:33:00Z'
labels: []
dependencies: []
references:
  - https://github.com/NormandErwan/Claude/pull/120
parent_task_id: TASK-1
ordinal: 5000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
CONTRIBUTING.md RETROSPECTIVE.md processing: an accepted entry becomes a Backlog.md task, then a PR; the Landed in column cites both.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 CONTRIBUTING.md updated
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
CONTRIBUTING.md RETROSPECTIVE section: an accepted entry -> a Backlog.md task; Landed in cites the task id, then the PR. PROVENANCE row added; effect observed at the next ledger processing (TASK-2).
<!-- SECTION:FINAL_SUMMARY:END -->

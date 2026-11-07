---
id: TASK-1
title: Set up Backlog.md
status: To Do
assignee: []
created_date: '2026-11-07T21:31:00Z'
updated_date: '2026-11-07T21:32:00Z'
labels: []
dependencies: []
references:
  - docs/research/2026-11-07-backlog-skills.md
  - docs/research/2026-11-07-backlog-md-usage.md
ordinal: 1000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Pilot Backlog.md on this repo (NormandErwan/Claude) before rolling it out to the owner's other repos. Goal: one structured, proven way to keep a backlog in each repo instead of in the owner's head, with tasks filed by the agent. Decision and pilot observations: docs/research/2026-11-07-backlog-skills.md. Usage research: docs/research/2026-11-07-backlog-md-usage.md.
<!-- SECTION:DESCRIPTION:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 Repo checks pass: bash .claude/hooks/check-skills.sh --check and bash .claude/hooks/test-check-skills.sh
- [ ] #2 backlog doctor reports no duplicate ID, on this branch or across branches
- [ ] #3 Reviewed: ponytail-review, then mattpocock code-review
- [ ] #4 PR URL added to the task with --add-ref
<!-- DOD:END -->

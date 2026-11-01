---
description: "Open-ended task: heuristics, not a rigid script"
tags: ["behaviour", "freedom"]
runs: 3
model: "claude-opus-5-5"
max_turns: 10
allowed_tools: ["Read", "Glob", "Grep", "Skill"]
---

IMPORTANT: This is a real task, not a quiz. Do not ask me questions. Do not write files: print the result.

Write the instructions for a subagent that reviews pull requests in our Python data-pipeline repo. The PRs vary a lot: SQL changes, Airflow DAGs, pandas transforms, infrastructure config. I want reviews that catch what matters, not a box-ticking exercise.

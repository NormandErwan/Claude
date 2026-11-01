---
description: "Hook message: one trigger-action item per condition, no tool tutorial"
tags: ["behaviour", "structure"]
runs: 3
model: "claude-opus-5-5"
max_turns: 10
allowed_tools: ["Read", "Glob", "Grep", "Skill"]
---

IMPORTANT: This is a real task, not a quiz. Do not ask me questions. Do not write files: print the result.

Write the message a `PreToolUse` hook on Bash returns to the agent when it blocks a `git push`. The hook blocks three cases: a push to `main` or `master` (the agent should push a feature branch and open a pull request instead); any push with `--force` (it may use `--force-with-lease`, and only on its own feature branch); and pushing tags (the release script does that, so the agent should not push tags at all).

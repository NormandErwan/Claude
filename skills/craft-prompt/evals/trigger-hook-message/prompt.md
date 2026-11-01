---
description: "Should fire: a hook message to the agent"
tags: ["trigger", "should-fire"]
runs: 3
model: "claude-opus-5-5"
max_turns: 4
allowed_tools: ["Read", "Glob", "Grep", "Skill"]
---

IMPORTANT: This is a real task, not a quiz. Do not ask me questions. Do not write files: print the result.

Write the text our `Stop` hook sends back to the agent when the working tree still has uncommitted changes.

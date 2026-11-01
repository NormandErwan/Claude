---
description: "Should fire: improving a failing subagent prompt"
tags: ["trigger", "should-fire"]
runs: 3
model: "claude-opus-5-5"
max_turns: 4
allowed_tools: ["Read", "Glob", "Grep", "Skill"]
---

IMPORTANT: This is a real task, not a quiz. Do not ask me questions. Do not write files: print the result.

My subagent keeps returning only some of the files it should. This is the prompt I give it: "Look through the repo and find the config files that mention the old API URL." Improve it.

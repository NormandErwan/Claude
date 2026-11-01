---
description: "Should fire: optimizing an LLM prompt"
tags: ["trigger", "should-fire"]
runs: 3
model: "claude-opus-5-5"
max_turns: 4
allowed_tools: ["Read", "Glob", "Grep", "Skill"]
---

IMPORTANT: This is a real task, not a quiz. Do not ask me questions. Do not write files: print the result.

We route support tickets with an LLM call. The prompt is "Classify this ticket into billing, bug, or other: {ticket}" and it gets about 60% right on our labelled set. How do I make it better? Give me the new prompt.

---
description: "Should fire: a reusable prompt template"
tags: ["trigger", "should-fire"]
runs: 3
model: "claude-opus-5-5"
max_turns: 4
allowed_tools: ["Read", "Glob", "Grep", "Skill"]
---

IMPORTANT: This is a real task, not a quiz. Do not ask me questions. Do not write files: print the result.

Turn this prompt into a reusable template with variables for the target language and the tone: "Translate the following product description into German, keeping a friendly tone: ..."

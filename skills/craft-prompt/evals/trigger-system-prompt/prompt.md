---
description: "Should fire: a chatbot system prompt"
tags: ["trigger", "should-fire"]
runs: 3
model: "claude-opus-5-5"
max_turns: 4
allowed_tools: ["Read", "Glob", "Grep", "Skill"]
---

IMPORTANT: This is a real task, not a quiz. Do not ask me questions. Do not write files: print the result.

Draft the system prompt for the chat assistant on our bike repair shop's website. It answers questions about opening hours, prices and booking, and hands anything else to a human.

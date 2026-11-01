---
description: "Delegation prompt: self-contained goal, scope and return format"
tags: ["behaviour", "subagent"]
runs: 3
model: "claude-opus-5-5"
max_turns: 10
allowed_tools: ["Read", "Glob", "Grep", "Skill"]
---

IMPORTANT: This is a real task, not a quiz. Do not ask me questions. Do not write files: print the result.

I'm in a Claude Code session on a large TypeScript monorepo. Yesterday we decided that only server-side code matters for this cleanup: `apps/web` is out of scope because the client is being rewritten next quarter.

I want to hand this to a subagent: find every place that reads a feature flag straight from `process.env` instead of going through `getFlag()` from `packages/config`. Afterwards I'll fix them myself.

Write the prompt I'll give the subagent.

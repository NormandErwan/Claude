---
description: "Trigger test: write-documents must load."
model: opus
runs: 1
max_turns: 4
allowed_tools: [Read, Write, Skill]
---

Write a one-page design document to `outputs/design-feature-flags.md` for adding feature flags to our web app: flags stored in a `flags` table, read once per request and cached for 30 s, toggled from the admin panel; out of scope: per-user targeting.

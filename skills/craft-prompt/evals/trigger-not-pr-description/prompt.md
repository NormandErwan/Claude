---
description: "Should not fire: PR description for humans"
tags: ["trigger", "should-not"]
runs: 3
model: "claude-opus-5-5"
max_turns: 4
allowed_tools: ["Read", "Glob", "Grep", "Skill"]
---

IMPORTANT: This is a real task, not a quiz. Do not ask me questions. Do not write files: print the result.

Write the pull request description for a change that moves our CI from Jenkins to GitHub Actions. Reviewers are the platform team.

---
name: handoff
version: 1.1.0
description: Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "What will the next session be used for?"
---

Write a handoff document summarising the current conversation so a fresh agent can continue the work, as one Markdown file. Save it where the user can open it, never in the current workspace's tracked files:
- Session lists a scratchpad directory -> save there and give the full path.
- Otherwise, with a filesystem -> the OS temporary directory (`$TMPDIR`, else `/tmp`; `%TEMP%` on Windows).
- No filesystem (claude.ai chat) -> a downloadable `.md` file.

Include a "suggested skills" section in the document, naming which skills the next agent should call the Skill tool for.

Do not duplicate content already captured in other artifacts (specs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead.

Redact any sensitive information, such as API keys, passwords, or personally identifiable information.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.

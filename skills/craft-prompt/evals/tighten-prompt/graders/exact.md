---
type: "llm"
---

PASS if the tightened prompt keeps, unchanged: the command `git log --since="7 days ago" --pretty=format:'%h|%an|%s'` character for character; the four keys "hash", "author", "summary", "type"; the three type values "feat", "fix", "chore"; and the exclusion of merge commits.
FAIL if any of these is altered, renamed or dropped.

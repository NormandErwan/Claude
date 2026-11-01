---
type: "llm"
---

PASS if the tightened prompt keeps these parts unchanged: the `--since="7 days ago"` and `--pretty=format:'%h|%an|%s'` arguments of the git command, character for character; the four keys "hash", "author", "summary", "type"; the three type values "feat", "fix", "chore"; and the exclusion of merge commits (as an instruction or as a `--no-merges` flag). Adding flags or definitions does not fail this check.
FAIL if any of these parts is altered, renamed or dropped.

---
type: llm
focus: {source: file, path: outputs/decision.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: the message tells Dana what the real-session option asks of them: starting each session from claude.ai/code (about 2 min each, plus 1 min to paste the result; about 18 min for 6 sessions), in the `dated-notes-fixture` environment with the prompt in `tests/dated-notes/prompt.txt`. PASS if Dana's time and the environment and prompt appear. FAIL otherwise.

---
type: llm
focus: {source: file, path: outputs/decision.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: the message is ordered as a decision request: first one line with the question and the recommendation; then the context - why the task exists (the dated-notes rule rewritten on 2026-10-30, new wording 0/6 in real sessions), the rule in force (the rewritten one), and the runner disagreement - then the options.
PASS if this order holds and the context covers why the task exists and the rule in force. FAIL if the recommendation is not in the opening line, if the options come before the context, or if the context omits why the task exists or which rule is in force.

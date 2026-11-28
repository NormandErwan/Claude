---
type: llm
focus: {source: file, path: outputs/run-planner-guide.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: read ignoring every link, the guide lets a technician who has never planned an experiment use the screen. FAIL if it sends the reader elsewhere for something they need (for example "look up Plackett-Burman designs", "ask the statistician which design to use", "see the statistics documentation" for what an effect is). PASS otherwise.

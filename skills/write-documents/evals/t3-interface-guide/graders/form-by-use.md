---
type: llm
focus: {source: file, path: outputs/run-planner-guide.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: the form follows what the reader must do with the content.
PASS only if all three hold:
1. The three designs are compared in a table (rows or columns per design, with run counts and what each can estimate).
2. The workflow (factors, design, generate, run, enter results, read chart) is a numbered list or a flowchart.
3. At least one visual element shows the screen or the Effects chart: a mock-up, an ASCII or Mermaid drawing, or an image with a caption, with labels on it naming the parts (for example the threshold line).
FAIL if any of the three is missing.

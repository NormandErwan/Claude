---
type: llm
focus: {source: file, path: outputs/run-planner-guide.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: the opening says what the Run planner does for the technician (from a list of factors, it gives the runs to perform and shows which factors matter) and the technician's first action on the screen (listing the factors to vary). PASS if the first paragraph, or the first two sentences after the title, give both; the first action may be stated as what the technician tells the tool. FAIL if it opens with theory of experimental design, the tool's history, or a table of contents alone.

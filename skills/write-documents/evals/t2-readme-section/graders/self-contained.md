---
type: llm
focus: {source: file, path: outputs/readme-section.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: the section is self-contained for a developer turning the feature on, and does not restate the internals that belong behind a link to the design note (`docs/design/2026-11-20-config-sync.md`).
FAIL if a reader would need the design note to turn the feature on or to react to a failed sync (for example "see the design note for the file format").
Also FAIL if the section restates how the mechanism works internally: resolving `latest` through `git ls-remote`, downloading the tarball, checking SHA-256 against a signed `checksums.txt`, or how local changes are detected against hashes in the lock. One short clause saying the download is verified is fine; a step-by-step account is not.
PASS if the reader can act from the section alone and the internals are left to a link.

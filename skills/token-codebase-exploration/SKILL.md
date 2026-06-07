---
name: token-codebase-exploration
description: Use when exploring an unfamiliar codebase, understanding how a specific feature or pattern works, or learning how components interact. Provides the exploration workflow and strategy. For .NET/C# specific search commands, also load token-dotnet.
version: 1.2.0
allowed-tools: Bash, Read, Grep, Glob
---

# Token Codebase Exploration

## Step 1: Determine Targeted vs Broad Before Reading Anything

| User request | Approach |
|---|---|
| "Help me understand this project" | **Broad** |
| "How is this codebase organized?" | **Broad** |
| "How does the AuthService work?" | **Targeted** |
| "How do I implement this pattern here?" | **Targeted** |
| "Show me examples of X" | **Targeted** |
| "What patterns are used in this project?" | Broad → then Targeted |

Never start reading files before making this determination.

---

## Targeted Learning (when user asks "how does X work" or "show me examples of Y")

Follow these 5 steps in order. Do not skip ahead to reading.

**Step 1: Extract the concept** from the user's request and identify the likely file names
or terms to search for.

**Step 2: Search — do not read files yet.** Use grep and find to locate candidates.
Anchor grep patterns to exclude comment lines. For .NET/C# projects, load token-dotnet
for the language-specific search patterns and directory exclusions.

**Step 3: Rank examples** — prefer files with self-documenting names and explicit variable
names over short, dense files. A 35-line file with clear names teaches a pattern better
than an 8-line file with abbreviations. Use `wc -l` only as a tiebreaker between files
of similar readability, not as the primary criterion.

**Step 4: Read 2–3 selected examples fully** — not more. One simple or minimal example,
one standard example, and one advanced example only if the pattern has genuinely different
variations.

**Step 5: Extract and explain the pattern** — never just show code. Explain what the
pattern does conceptually, what elements are required, and the common pitfalls specific
to this codebase.

---

## Broad Exploration (when user asks to understand the whole project)

Work through these phases in order. Read only what each phase requires.

**Phase 1 — Structure overview (no Read yet):**

```bash
tree -L 2 || find . -maxdepth 2 -type d | head -30   # tree with fallback if absent
ls -la
cat README.md   # this is the legitimate first Read
```

**Phase 2 — Entry point:** identify the main executable or initialization file for this
language and framework. For .NET, load token-dotnet for the specific commands.
Read the entry point — this is file 1.

**Phase 3 — Core abstractions:** search for interface definitions and abstract base classes
without reading files. These reveal the architecture's vocabulary.

**Phase 4 — Most-used components and recent activity:** identify what modules are depended
on most frequently (via import/using analysis) and which files have been modified recently
(via git log). These two signals together locate the active core of the project.

Read order after the entry point: one core service or business logic file → one
infrastructure file (repository, adapter, external interface). That is files 2 and 3.

---

## Stop at 5 Files — Then Summarize

After reading 5 files, STOP. The limit is not about context window saturation
(5 typical files use approximately 2% of the available context window). The limit
exists to force a consolidation step: reading without summarizing produces worse answers
than reading 5 files, articulating what you now understand, and then reading 2 more
with a specific question in mind.

Summarize findings, state what you now understand, and ask the user which area to
explore further before opening any additional file.

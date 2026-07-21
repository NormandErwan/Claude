---
name: token-efficiency
description: Load before any file operation, multi-file task, or new session start. Governs model selection (Opus vs Sonnet) and the core file-operation decision tree. Primary token optimization skill — all other token skills depend on it.
version: 1.3.0
allowed-tools: Bash, Read, Grep
---

# Token Efficiency — Core Rules

APPLY THESE RULES by default. Override only when the user explicitly requests otherwise.

## Model Selection

**Start at the lowest tier. Escalate ONLY when a trigger fires. Never escalate by default.**

| Model | $/M in·out | Speed | Default use |
|---|---|---|---|
| **Haiku** | $1 · $5 | ~100 t/s | Volume, real-time UX, bounded tasks |
| **Sonnet** | $3 · $15 | ~50 t/s | Everything else — the true default |
| **Opus** | $5 · $25 | ~25 t/s | Novel problems, long output, high-stakes |

### Haiku triggers
- Volume > 100K calls/month with budget constraint
- Real-time UX: autocomplete, typeahead (TTFT ~0.85s)
- Bounded tasks: extraction, classification, boilerplate, format conversion
- Sub-agent workers in multi-agent pipelines (Sonnet orchestrates → Haiku executes)
- **Claude Code**: smart model switching routes simple tasks to Haiku automatically — don't force it

### Opus triggers
| Trigger | Signal |
|---|---|
| Unknown codebase — first pass only | Switch back to Sonnet after 10–15 min |
| Structurally novel problem | No known pattern; solution must be invented |
| Output > 32K tokens | Opus max: 128K — Sonnet/Haiku max: 64K |
| Wrong answer costly to fix | Production incident, irreversible state |
| Deep STEM / formal reasoning | GPQA gap: +17 pts for Opus |

**Novel ≠ complex.** A 10k-line codebase is complex. A problem with no prior pattern is novel. Only novelty justifies Opus.

### NEVER use Opus for:
- Computer use — identical benchmarks (72.5% vs 72.7%)
- Agentic loops / interactive UX — 2x slower, latency compounds
- Code writing, debugging — SWE-bench gap < 1.2 pts
- High volume — 1.67x Sonnet cost, multiplies linearly

> Wrong answer cheap → Sonnet. Wrong answer causes incident or irreversible state → Opus may be cheaper end-to-end.

### Claude Code session pattern
```
Opus (10–15 min): unknown codebase exploration, architecture decisions
Sonnet: everything else — implement, debug, edit, run
```
Switching is free. Don't stay on Opus out of inertia.

## Effort & Reflection (claude.ai only)

Orthogonal dimension to model selection. **Never escalate effort without a trigger.**

**Reflection** = internal chain-of-thought before the response.
**Effort** = thinking token budget cap. The model stops when solved OR when the budget is reached — it does NOT escalate automatically.

| Effort | Budget ~tokens |
|--------|----------------|
| Low    | ~1 000 |
| Medium | ~4 000 |
| High   | ~16 000 |
| Max    | ~32 000+ |

**Default: Low + Reflection ON.** Covers ~80% of cases — structured reasoning at minimal cost.

| Trigger | Action |
|---|---|
| Mechanical task / high volume / latency-critical | Reflection Off, Low effort |
| Visibly shallow reasoning in the response | Medium effort |
| Complex architecture, debugging with no known pattern | High effort |
| No cost constraint + critical problem / formal proof | Max effort |

> Reflection Off = zero thinking tokens regardless of effort level.
> Max effort without Reflection = pointless.

## File Operation Decision Tree

Before any file operation, ask in order — stop at the first match:

1. **Creating a NEW file?**
   → Write tool directly. Never wrap in a bash heredoc script.

2. **Checking size or existence?**
   → `wc -l` / `grep -q`. Never Read a file just to check it.

3. **Modifying a code file?** (language-specific rules: see token-dotnet for .NET)
   → Read + Edit by default. Bash text substitution cannot see code structure.

4. **Appending a line to a file?**
   → `printf '\n## New entry\n' >> file`. Not plain `echo >>`: if the file has no
   trailing newline, echo glues the new content onto the last line (tested empirically).

5. **Copying or merging files?**
   → `cp` / `cat`. Never Read then Write.

6. **Replacing text in a content document?** (.md, .yaml, .xml)
   → `sed -i.bak` if the document is large and the term appears only in free text.
   Read + Edit if the term appears in structured identifiers (IDs, cross-references).
   The criterion is context type, not line count alone.

7. **Can I search instead of read?**
   → `grep` / `head` / `wc -l` first. Only Read if broader context is needed.

**Rule of thumb:** 3+ search operations planned → read the file instead (each extra turn costs ~2K tokens of history overhead).

Override (read in full only when): user requests full file · context missing from grep match · `wc -l` < 100.

## Cost Reference

| Operation                        | Approx. token cost      |
|----------------------------------|-------------------------|
| `wc -l file`                     | ~5 tokens (output only) |
| `grep -n "pattern" file`         | ~5 + matched lines      |
| `head -50 file`                  | ~50 lines × 4 chars     |
| Read a 100-line file             | ~350 tokens             |
| Read a 300-line document         | ~1 000 tokens           |
| Each extra turn of clarification | ~2 000 tokens overhead  |

## Session Cost Monitor — MANDATORY

**Every response. No exception. No override.**

Append:
```
Tour N · ~XK tokens · Signal
```

**Estimate:** N × 2K tokens (history overhead) + file reads (~350 tok/100 lines) + bash output blocks.

| Turns | Est. tokens | Signal   | Action |
|---|---|---|---|
| 1–8  | < 20K   | Normal   | None |
| 9–15 | 20–50K  | Moderate | Mention if next task is independent |
| 16–24| 50–100K | High     | Recommend a strategy (one sentence) |
| 25+  | > 100K  | Critical | Recommend prominently — before response content |

### Strategies when session is expensive

| Situation | Strategy |
|---|---|
| Task ≥ 80% done | Finish → new conversation |
| Tasks are independent | New conversation immediately, no summary needed |
| Task unfinished, session too expensive | Handover summary → new conversation |

**Handover summary prompt:**
> "Summarize: (1) current objective, (2) decisions made with rationale, (3) current state — file paths, key code snippets, identifiers, (4) open questions. Under 400 words."

Paste the summary as the first message of the new conversation.

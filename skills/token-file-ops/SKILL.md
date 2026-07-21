---
name: token-file-ops
description: Use when reading, editing, creating, or manipulating files; or running commands with potentially large output. Provides generic bash-first patterns for any file type. For .NET/C# specific patterns, also load token-dotnet.
version: 1.3.0
allowed-tools: Bash, Read, Grep, Glob
---

# Token File Operations — Bash-First Patterns

Reading files costs tokens. Bash commands process files without spending tokens on their content.
NEVER read files unless you must.

## Core Pattern: Wasteful vs Efficient

| Operation | Wasteful (avoid) | Efficient (prefer) |
|---|---|---|
| Copy file | Read + Write | `cp source dest` |
| Append a line | Read + Write | `printf '\n## entry\n' >> file` |
| Replace text (large doc) | Read + Edit | `sed -i.bak 's/old/new/g' file` |
| Delete matching lines | Read + Edit | `sed -i.bak '/pattern/d' file` |
| Merge files | Read + Read + Write | `cat file1 file2 > merged.md` |
| Count lines | Read file | `wc -l file` |
| Check if text exists | Read file | `grep -q "term" file && echo found` |

## Appending: Always Use printf, Not echo

`echo >>` glues content onto the last line if the file has no trailing newline —
a common state when files are edited by VS Code without the "insert final newline" option.
Use `printf` to control newlines explicitly:

```bash
# Safe append — works whether or not the file has a trailing newline
printf '\n## v0.2.0 — 2025-01-15\n- Description\n' >> CHANGELOG.md
```

## Log Files: Filter Before Reading — Always

NEVER run `Read: application.log`. Log files can reach hundreds of thousands of tokens.
Always filter before reading:

```bash
# Most recent entries only
tail -100 application.log

# Errors and exceptions
grep -i "error\|exception\|fail" application.log | tail -50

# Specific date
grep "2025-01-15" application.log | tail -50

# Count first, then read selectively
grep -c "ERROR" application.log           # how many errors total?
grep "ERROR" application.log | tail -20   # then read the recent ones
```

## Grep Instead of Reading

When looking for something, grep — do not open files. Anchor patterns to exclude
comment lines: unanchored patterns match text inside `// comments` and `/* blocks */`.

```bash
# Anchored pattern (excludes comment lines)
grep -rn "^\s*public.*interface" --include="*.cs" src/ | head -20

# List files containing a term (no line content, just filenames)
grep -rl "pattern" src/ | head -20

# Search with context lines (5 before, 5 after)
grep -rn -A5 -B5 "pattern" src/ | head -60
```

For language-specific search patterns (.NET, C#), load token-dotnet.

## Filter Large Command Output — Always Cap It

NEVER run commands that produce unbounded output:

```bash
# DON'T — may return thousands of results
find . -name "*.cs"

# DO — measure first, then sample
find . -name "*.cs" | wc -l         # count first
find . -name "*.cs" | head -30      # sample
find . -maxdepth 2 -type f          # limit depth
tree -L 2 || find . -maxdepth 2 -type d | head -30   # tree with fallback
git log --oneline -15               # recent history (capped)
```

Note the `tree` fallback: `tree` is not installed on all systems. Always provide
`find . -maxdepth 2 -type d` as an alternative when `tree` might be absent.

## sed: Cross-Platform Syntax — Always Use -i.bak

`sed -i ''` fails on Linux with a runtime error (tested). `sed -i` bare fails on macOS.
Always use `-i.bak` — it works on both:

```bash
# Cross-platform — works on macOS and Linux
sed -i.bak 's/old/new/g' file.md && rm file.md.bak

# Replace across multiple files
find . -name "*.md" -exec sed -i.bak 's/old/new/g' {} + \
  && find . -name "*.md.bak" -delete
```

## Editing With Edit/Write: Read With the Read Tool First

The Edit and Write tools require that the target file was first read with the
Read tool in this session. A `cat`, `head`, or `sed -n` in Bash does NOT count —
the tool still refuses until you Read it, so the bash peek is wasted work.

When you already know you will Edit or Write a file, open it once with the Read
tool up front. Do not inspect it with `cat` first and then Read it again.

```bash
# DON'T — cat does not satisfy Edit/Write's precondition; you Read it anyway
cat config.yaml            # wasted: still must Read before Edit
# Read config.yaml         # forced second pass

# DO — Read once, then Edit
# Read config.yaml
# Edit config.yaml
```

This is the exception to "never Read." For a plain substitution across a file,
still prefer `sed -i.bak` — it needs no Read at all.

## Reading Selectively When You Must

If you must Read a large file, limit scope first:

```bash
wc -l large-doc.md                    # check size before committing to a full read
grep -n "^## " large-doc.md           # list all headers — navigate without reading
head -50 large-doc.md                 # document structure and intro
sed -n '80,120p' large-doc.md         # targeted section by line range
```

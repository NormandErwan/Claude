---
name: single-source-of-truth
version: 1.0.0
description: Use when a fact is about to exist in two places - writing a rule into a CLAUDE.md, a skill, a README, a hook or a config file; adding a note that restates a setting; reviewing a diff that repeats something stated elsewhere; editing a rule that other files also state. Also when auditing a knowledge base, a docs tree or a config set for drift, or when two files already disagree about the same fact.
---

# Single source of truth

Every fact has exactly one owner. Everywhere else names the owner instead of restating it.

Duplication is not a style problem. Two copies of a fact are two facts as soon as one is edited,
and nothing reports the split - the reader trusts whichever copy they happened to open.

## Who owns what

| Owner | Holds | Why it wins |
|---|---|---|
| What executes - config files, scripts, hooks, manifests, CI | The values | True by construction: it is what actually runs |
| The skill or procedure doc | How to do the thing | It is what an agent follows at the moment of acting |
| The prose doc, page or ADR | Why the decision was made | Reasons have no other home |
| Always-loaded instructions (CLAUDE.md) | Only what must be known before acting | Everything else costs context on every turn |

A doc that restates a config value is a copy. A doc that names the config file is a reference.

```markdown
Bad:  Hidden files: CLAUDE.md, README.md, skills, .claude
Good: Hidden files are listed under `:hidden` in `logseq/config.edn`
```

## When to check

| Moment | Check |
|---|---|
| Before writing any fact into a file | Does it already live somewhere? `git grep` a distinctive phrase of it |
| When editing a rule | Hunt its copies before you finish. An edited rule with an unedited copy IS the drift |
| Before opening or updating a PR | Run the scan below over the diff's files |
| When a doc and a config disagree | Treat it as a bug report, not a formatting nit |

## How to treat a duplicate

1. Name the owner using the table above.
2. **Delete the copy. Do not synchronise it.** Replace it with a reference to the owner.
3. If a mechanism genuinely needs the text inline - a hook that must inject it without reading a
   skill - then make one file the source and have the mechanism read that file at runtime. One
   file, read twice, is not a copy.
4. Where the copies already disagree, the executable owner is right and the prose is wrong, unless
   the prose states a decision the executable never implemented - then the executable is the bug.

## Finding drift

Identical copies are easy: `git grep -F "distinctive phrase"`.

Copies that have already drifted are the dangerous ones - they no longer match, so grep misses them.
Scan for near-duplicate lines across tracked text files:

```bash
python3 - <<'PY'
import difflib, itertools, pathlib, subprocess
out = subprocess.run(["git","ls-files","-z"],capture_output=True,text=True).stdout
files = [f for f in out.split("\0")
         if f.endswith((".md",".edn",".json",".yml",".yaml",".sh",".toml"))]
lines = [(f,n,s.strip()) for f in files
         for n,s in enumerate(pathlib.Path(f).read_text(encoding="utf-8",errors="ignore").splitlines(),1)
         if len(s.strip()) > 40]
for (fa,na,a),(fb,nb,b) in itertools.combinations(lines,2):
    if fa == fb or a == b:
        continue
    if difflib.SequenceMatcher(None,a,b).ratio() > 0.75:
        print(f"{fa}:{na}\n{fb}:{nb}\n  {a[:90]}\n  {b[:90]}\n")
PY
```

Split on NUL, not whitespace: tracked paths contain spaces more often than you expect, and
`git ls-files` without `-z` silently shreds them into paths that do not exist.

Exact matches across two files are copies waiting to drift; matches above 75% that are not identical
have drifted already. Both need an owner.

The scan compares lines, so it is a net with holes: it will not pair a value inside a config
structure with the prose that restates it elsewhere, and it will not catch the same fact written in
two different shapes. It finds copies cheaply; it does not prove there are none. The owner table is
what prevents drift - the scan only reports what already slipped through.

## Rationalisations that produce drift

| Thought | Reality |
|---|---|
| "It is only two lines" | Two lines is the usual size of a rule, and rules are what get edited |
| "The wording differs, so it is not duplication" | Differing wording of the same fact is drift that already started |
| "I will keep them in sync" | Nothing enforces that. The next editor is not you, and has not read this |
| "The reader needs it here too" | The reader needs a pointer here. Pointers do not drift |
| "One is for humans, one is for agents" | Two audiences, one fact, still one owner - the other side gets a reference |

A real case: a `:hidden` list held eight entries in the config file and five in a skill that
restated it, one day after both were written. Nobody noticed, because nothing was watching. The
line scan above did not catch that one either - the owner table would have.

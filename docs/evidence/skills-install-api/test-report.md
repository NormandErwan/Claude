# install-skills.sh (7287f3f) test report

Overall: all 5 checks PASS. Two side findings below.

## 1. Speed and stability: PASS
Three API-path runs into fresh dirs:
| run | time | skill dirs | references files |
|---|---|---|---|
| 1 | 6.6s | 50 | 7 |
| 2 | 5.7s | 50 | 7 |
| 3 | 5.7s | 50 | 7 |

Stdout was identical each run:
`skills.txt: 1 of 39 skills failed to install: write-prompt.` plus a `Failed call: NormandErwan/claude-casebook (exit 0): ... YAML parse error` line.
- `diff -rq` of run 1 against runs 2 and 3 is empty.
- `write-prompt` fails because skills.sh returns 404 for it (checked with curl). npx then skips it for a YAML parse error in upstream SKILL.md. This is an upstream defect, not a regression.
- A curl wrapper showed 38 `/api/download` calls and 10 raw.githubusercontent calls for references.
- Every repo except casebook was served entirely by the API (about 0.17s per call).

## 2. Fidelity: PASS
Forced-npx run (`SKILLS_DOWNLOAD_URL=http://127.0.0.1:9`) against API run 1:
- `diff -r skills/` is empty.
- `diff -r references/` is empty.
- No files missing, extra, or different in content.

## 3. Fallback works: PASS
- The forced-npx run installed 50 skill dirs and 7 references files, the same as the API runs.
- It reported the same single failure (write-prompt).
- It took 3.3s. The proxy clones were fast today, so there were no npx timeouts.
- The npx path was faster than the API path (3.3s against about 5.7s). Fallback cost is not an issue in this environment.

## 4. Unpack safety: PASS
I extracted the UNPACK snippet and ran it with `python3 -I` on four crafted JSON files. Each exited 1.
- `../evil.txt` with a valid SKILL.md: rc=1, `evil.txt` not written.
- Sibling-escape path `../dest2/p.txt`: rc=1, nothing written.
- Absolute path `/tmp/.../abs-evil.txt`: rc=1, nothing written.
- No SKILL.md: rc=1, nothing written.
- The only file created was the dest's own `SKILL.md`. Files before the bad entry are written, so there is a partial write inside dest. The caller deletes that dir (`rm -rf .claude`) before the npx fallback, so it is harmless.

## 5. Partial API failure: PASS
Setup: a consumer `skills.txt` adding `juliusbrussee/caveman caveman nonexistent-skill-xyz`.
- The curl log shows the API fetched `caveman` and then got a failure on `nonexistent-skill-xyz`. That made the repo fall back to npx.
- The staged `.claude` was removed before npx ran, so there were no half-written API files.
- The target had 50 skill dirs, identical to the API baseline (caveman byte-identical to the npx copy). It had no stray `.json` files apart from upstream `evals/*.json`.
- Total time was 5s.

## Side findings
1. **Misleading failure line.** The hook printed `Failed call: juliusbrussee/caveman (exit 0): — Done! Review skills before use...`. When npx silently skips an unknown skill, the hook falls back to the last log line. It is cosmetic only: the summary correctly lists `nonexistent-skill-xyz` as missing.
2. **Failure count.** The count was "2 of 41", with write-prompt and the fake skill both missing. The tool did what it should here.

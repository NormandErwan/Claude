# A reusable harness for rule and skill A/B tests

For the `BACKLOG.md` task "Find or build a reusable harness for rule and skill A/B tests". Scored
against the 15 errors in `2026-11-08-ab-test-avoidable-errors.md`.

## Summary

Adopt `claude plugin eval` as the runner and grader, and build one thin wrapper for what it lacks:
arm building, a probe case, and an arm-vs-arm comparison. `plugin eval` already removes the setup
class of errors (trust, stdin, env leaks, foreign `CLAUDE.md`, user skills, consumer hook
overwrite, run-dir reuse) by isolating every run [D-iso], and gives a committed case/grader
format, per-run cost and a versioned JSON result [D-json]. It cannot load a `CLAUDE.md` at all
[D-iso], and its only built-in comparison is plugin vs no plugin [D-abl]. A probe run here showed
the workaround: a plugin `SessionStart` hook does run in eval children and its output reaches the
agent [P]. So a `CLAUDE.md` arm becomes "a plugin whose hook prints that arm's `CLAUDE.md`, with
the skills installed into `skills/`", and two versions become two targets run with
`--ablation none`, which casebook already did for `backlog` 0.1.0 vs 0.1.1 [C-prov]. Two open
risks: a hook-injected `CLAUDE.md` is framed differently from a real one (fidelity unmeasured),
and Bash grants need `bubblewrap` + `socat`, absent in this container [D-tools].

## What casebook actually did

- `test-rule-change` 0.5.0 (`plugins/casebook/skills/test-rule-change/SKILL.md`, "A/B test plan")
  is a protocol, not a harness: review first, build arms, isolate, pilot one run per arm (the
  baseline must show the failure once in two runs; an arm built later gets its own pilot), run
  with `claude plugin eval`, record. It has no arm builder and no script.
- Full `plugin eval` runs that worked: `write-prompt` (Opus/Sonnet/Haiku, 3 runs per arm,
  $33.30 + later re-measures) and `backlog` (pilot $0.27; 0.1.0 vs 0.1.1 at 5 runs, "no-plugin
  arm off", $0.68) (`casebook/provenance.md`, rows `write-prompt` 2026-11-02 and `backlog`
  2026-11-15).
- The `write-hook` suite is **not** a successful `plugin eval` run: `plugins/write-hook/evals/`
  is "written, load-checked, and unscored" (`EVALS.md`, intro; `BACKLOG.md` "Run the write-hook
  evals"). The older `plugins/write-hook/skills/write-hook/evals/README.md` records hand runs:
  `claude -p` with `SKILL.md` prepended to the prompt, one run per cell.
- Failures recorded (`casebook/retrospective.md` and `casebook/provenance.md`): a second arm built
  with `rsync`, absent in the container, ran unpiloted, 0/69 fired, $5.98 lost (2026-11-02);
  ~600 runs at `-j 3` hit the 5-hour quota twice (2026-11-02); cases graded a written file while
  granting no Write (2026-11-03); a `..` scaffold path refused and a `max: 0` grader needing
  `min: 0` (`backlog` row); a Haiku judge failed correct outputs, replaced by regex graders and a
  task header that suppressed skill use (`write-prompt` row).
- `EVALS.md` ("Running") warns a user-level skill can reach the no-plugin arm; the probe here
  found none of the `~/.claude/skills/synced` skills in either arm [P] (not reproduced in this
  container; the claim may hold where skills sync differently).
- D1 in `EVALS.md` is the closest precedent for a rule arm: the plugin vs a copy with `hooks/`
  removed, built at run time.

## `claude plugin eval` facts (2.1.325)

| Topic | Fact | Source |
|---|---|---|
| Case format | dir with `prompt.md` (frontmatter + prompt) and/or `case.yaml` (`schema_version`, `name`, `context.scaffold_script`, `context.history_file`, `context.add_dirs`); graders in `graders/<name>.md` | [D-ref] "prompt.md frontmatter", "case.yaml fields"; `init --bare` output [P] |
| Graders | `regex` (target `last_message`/`trace`/`files`/file contents), `tool_used` (`input_match`, `min`, `max`), `tool_order`, `file_exists` (created files only), `llm` (2 of 3 votes), `baseline`; no custom-code graders | [D-ref] "Grader types" |
| `tool_used: Skill` | with-only "plugin-fired indicator", not scored under with-without; `arm: both` scores it in both arms (for "must not fire", `min: 0, max: 0`) | [D-abl]; `--help` `--ablation` |
| Arms | `none` or `with-without` only; no arm-vs-arm delta | `--help`; [D-abl] |
| Two versions | two targets, each `--ablation none`, compared outside the tool | [C-prov] `backlog` row; not in docs |
| `CLAUDE.md` arms | impossible directly: no `CLAUDE.md`/`.claude/` loads from above or inside the workspace, even one a scaffold wrote | [D-iso] |
| Plugin `SessionStart` hook | runs in the with-arm; output reached the agent (it quoted the marker, labelled "SessionStart hook output") | [P] |
| `append_system_prompt` | reaches both arms (marker quoted in both) | [P]; [D-ref] |
| Trust | first run in an untrusted dir prompts; non-TTY or `--json` refused with exit 1 unless `--trust-plugin` | [D-sec] "Trust the plugin directory" |
| Permissions | runs never ask; ungranted tools are removed; `--allow-tools` per run; Bash runs only under the OS sandbox, refused where no backend (Linux: `bubblewrap`, `socat`) | [D-tools] |
| Env | allowlist + `EVAL_*`; temp home/config per run | [D-iso]; [D-ref] `env` |
| Model, runs | `model`/`--model`; `runs` 1-50, default 3; `--judge-model` (default haiku) | [D-ref]; `--help` |
| Variance | only mean score and pass rate per arm; no interval or test | JSON [P] |
| Cost, tokens | `costUsd` per run and suite, `judgeCostUsd`; tokens and `permission_denials` only in the run's `trace.jsonl` | JSON [P] |
| Output | `results/<timestamp>/aggregate-result.json` (`schemaVersion: 1`) + `report.html`; transcripts deleted unless `--keep-temp` (as root: "could NOT seal" warning) | [D-json]; [P] |
| Concurrency | `-j 1..8`, one shared rate limit | `--help` |
| Zero-cost load check | `--max-cost-usd 0` loads cases, runs nothing | [P]; `EVALS.md` "Running" (does not validate grader types) |
| Roster | built-in skills and plugins load too (`code-review`, `simplify`, `cc-plugin-agents-md`...); plugin skills are namespaced `<plugin>:<skill>` | trace `init` [P] |

## Coverage of the 15 errors

P = prevented, C = caught pre-run (by a pilot or check), - = not covered.

| # | Error | `plugin eval` as-is | casebook `test-rule-change` | skill-scan scripts | promptfoo (agent SDK) |
|---|---|---|---|---|---|
| 1 | fixture trust drops allowlist | P: no fixture settings used; grants via `--allow-tools` [D-tools] | C: pilot | P: `hasTrustDialogAccepted` (`run.sh`); no stderr check | unverified |
| 2 | stdin open | P: harness spawns children; probe ran clean with `< /dev/null` [P] | - | P: `< /dev/null` | unverified |
| 3 | Bash allowlist too narrow | P where sandbox exists ("Bash" grants all, sandboxed); **blocked here**: no `bwrap`/`socat` [D-tools] | C: pilot | P: all Bash allowed; denials counted (`summarize.py`) | config-dependent |
| 4 | `pytest` assumed | - (scaffold env is `PATH` only [D-fix]) | C: pilot | - | - |
| 5 | consumer hook overwrites `CLAUDE.md` | P: no project config loads [D-iso] | C: step 3 isolation | P: hook runs installer only (`setup.sh`) | unverified |
| 6 | inherited env vars | P: env allowlist; probe: no repo `CLAUDE.md`, no user skills [P] | C: step 3 | P: `env -u ...` (`run.sh`) | unverified (`setting_sources`) |
| 7 | arm built by regex | - (no arm builder) | - | -; `backlog-owner-steps/setup.sh` asserts arms differ only in one path | - |
| 8 | shared red fixture | P by structure: per-case `scaffold_script` [D-fix]; green not checked | - | -: fixture still fails 1 of 2 tests (`fixture/tests`, run today) | - |
| 9 | case setups written late | partly: a case is a dir with its scaffold; `--max-cost-usd 0` load check | C: pilot | `cases/*.sh` exist, written late | - |
| 10 | ambiguous prompt vs kept rule | - | C: baseline must fail, treatment must load (step 4) | - | - |
| 11 | allowed set ignores shared rules | - (graders can express it: `tool_used` `arm: both`, `min:0 max:0`) | - | - | `not-skill-used` expresses it |
| 12 | unreviewed wording tested | - | P: step 1 | - | - |
| 13 | first-write misses Bash writes | P for graded outcomes: one committed grader set per case; first-write needs `tool_order` with a Bash `input_match` | - | P: `summarize.py` regex | - |
| 14 | transcripts lost / dir reused | P: timestamped results, per-run cost and verdicts persisted [P]; transcripts only with `--keep-temp`; `results/` is meant to be gitignored [D-ref] | P: step 6 records | partly: `runs-*.jsonl`; `run.sh` does `rm -rf` on reuse | `-o results.json` |
| 15 | results doc edited by ad hoc scripts | - | - | - | - |

## What `plugin eval` cannot do here, and the smallest fill

1. **Load a `CLAUDE.md` arm** [D-iso]. Fill: build each arm as a plugin dir:
   `skills/` from `templates/hooks/install-skills.sh` run at build time (project skills would not
   load at run time), and `hooks/hooks.json` printing the arm's `CLAUDE.md` (casebook's
   `hooks.json` pattern). Same text, different framing from a real `CLAUDE.md`: **fidelity
   unmeasured**.
2. **Compare arm A with arm B** [D-abl]. Fill: run each arm with `--ablation none`, same cases,
   model, runs; a ~30-line `compare.py` joins the two `aggregate-result.json` by case.
3. **Build arms safely** (error 7). Fill: arms from a base by explicit `old -> new` line edits
   that assert one match, then `diff -r` asserting arms differ only in the intended paths (the
   `backlog-owner-steps/setup.sh` check).
4. **Probe before scoring** (5, 6, 7, 9). Fill: a generated probe case per arm: quote the
   arm-specific line, regex `not_contains` a foreign rule, list the skill roster; plus
   `--max-cost-usd 0`. One Haiku pass cost $0.005 for 2 runs [P].
5. **Fixture readiness** (3, 4, 8). Fill: preflight fails if Bash is granted and `bwrap`/`socat`
   are missing; runs each case's scaffold once and its test command, expecting green unless the
   case says otherwise.
6. **Keep the record** (13, 14, 15). Fill: `--json docs/evidence/<batch>/<arm>.json`, refuse an
   existing batch dir, `--keep-temp` + copy each `trace.jsonl` summary through the existing
   `summarize.py` (denials, Bash writes); `compare.py` writes the results table as its own file
   that the research note links, so no doc is patched by script.
7. **Case-design errors** (10, 11, 12) stay a checklist: add 10 and 11 to `test-rule-change`'s
   Common Mistakes; 12 is already step 1.

Where it fits: `test-rule-change` already names `plugin eval` as its runner, so the wrapper
belongs beside it in casebook (`plugins/casebook/skills/test-rule-change/scripts/`), and
`CONTRIBUTING.md` step 2 points to it.

## Options

| Option | Covers | Cost to build | Downside |
|---|---|---|---|
| A. `plugin eval` + wrapper in casebook `test-rule-change` (above) | 1-9, 13-14 prevented or caught; 10-12 by checklist | ~4 scripts (`build-arm.sh`, `preflight.sh`, `compare.py`, probe template), about 1 session | `CLAUDE.md` as hook text, fidelity unknown; Bash needs `bubblewrap` + `socat` in the environment |
| B. Generalize the `claude -p` scripts into one harness here | real `CLAUDE.md` and real `SessionStart` hook (full fidelity); Bash unsandboxed works today | merge `skill-scan`, `dated-notes`, `backlog-owner-steps` into one parametrized set, plus the same probe/compare | owns trust, env, grading, JSON format: the surface that produced errors 1-6 |
| C. promptfoo with `anthropic:claude-agent-sdk` providers, one `working_dir` per arm | side-by-side arms natively; `skill-used`/`not-skill-used`, `cost`, `--repeat` [PF] | Node toolchain, new config format | `CLAUDE.md` and hook loading via `setting_sources: ['project']` from third-party write-ups only; isolation from user config unverified |

**Recommendation: A**, with B's `run.sh` kept as the fallback for a test whose question is the
exact `CLAUDE.md` framing, until the calibration below says the two agree.

**Next step:** a calibration pilot before building the rest. Build two arms of a past A/B whose
result is known (the backlog Haiku case set: 2.0.0 fired 20/30, `docs/research/2026-11-15-backlog-haiku-trigger.md`)
as hook-injected plugins and run them with `--ablation none`, Haiku, 1 run per case (~15 runs per
arm; Haiku probe cost suggests well under $1). If the firing rates land in the same range, build
the wrapper; if not, option B. In parallel, ask the owner whether the cloud environment's setup
script may install `bubblewrap` and `socat`, needed for any Bash-granting case.

## Sources

- [D-ref] https://code.claude.com/docs/en/plugin-evals, "Eval suite reference" (prompt.md
  frontmatter, case.yaml fields, Grader frontmatter, Grader types)
- [D-abl] same page, "The no-plugin baseline", "Score against the no-plugin baseline"
- [D-iso] same page, "How runs are isolated"
- [D-sec] same page, "What a run can access"
- [D-tools] same page, "Grant tools"
- [D-fix] same page, "Seed the workspace or conversation"
- [D-json] same page, "Read the results" > "JSON result"
- `claude plugin eval --help`, `claude plugin eval init --help`, `claude plugin --help`
  (Claude Code 2.1.325, run 2026-11-16)
- [P] probe run this session, 2026-11-16: throwaway plugin `armprobe` in the session scratchpad
  (not committed): `SessionStart` hook printing a marker, one skill, one case on
  `claude-haiku-5-5`, 1 run, with-without; graders: hook marker and `append_system_prompt` marker
  (`arm: both`), `not_contains` "Bootstrap - once per session" and user-skill names, `tool_used`
  Skill. Result: with 1.00, without 0.75 (only the hook marker missing), total $0.0053, 15 s.
  `aggregate-result.json` and `trace.jsonl` inspected for field names. Not repeated.
- [C-prov] `/home/user/normanderwan/claude-casebook/casebook/provenance.md`, rows `write-prompt`,
  `backlog`, `test-rule-change`; `casebook/retrospective.md` rows 2026-11-01 to 2026-11-03;
  `EVALS.md` ("Cases", "Running", "D1"); `BACKLOG.md` ("Run the write-hook evals", "Move
  write-skill's eval procedure to claude plugin eval");
  `plugins/casebook/skills/test-rule-change/SKILL.md`; `plugins/casebook/hooks/hooks.json`;
  `plugins/write-hook/skills/write-hook/evals/README.md`
- `docs/evidence/skill-scan/` (`setup.sh`, `run.sh`, `run2.sh`, `summarize.py`, `fixture/`),
  `docs/evidence/backlog-owner-steps/setup.sh`, `docs/evidence/dated-notes/run.sh`,
  `templates/hooks/install-skills.sh`
- [PF] https://www.promptfoo.dev/docs/guides/test-agent-skills/ ("Comparing Versions",
  assertions); `CLAUDE.md` loading via `setting_sources`: third-party, unverified
  (https://developertoolkit.ai/en/ecosystem/observability/evals-coding-agents/)
- skill-creator: https://code.claude.com/docs/en/skills ("Run evals with skill-creator"): runs
  inside a conversation with its own `evals/evals.json`, does not read `plugin eval` cases; not
  evaluated further.

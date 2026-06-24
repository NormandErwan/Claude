# Evaluating Skills With Subagents

**Load this reference when:** benchmarking whether a Technique, Pattern, or Reference skill
measurably improves task quality, or when optimizing a skill's description to trigger reliably.

For **Discipline skills** (rules/compliance), use `testing-skills-with-subagents.md` instead —
pressure scenarios under RED-GREEN-REFACTOR, not A/B measurement.

## Two Evaluation Tracks

| Track | What it measures | Tools used |
|-------|-----------------|------------|
| **Quality A/B** | Does the skill produce better outputs than no skill? | `agents/grader.md`, `agents/comparator.md`, `agents/analyzer.md`, `scripts/aggregate_benchmark.py`, `eval-viewer/generate_review.py` |
| **Trigger eval** | Does the description fire the skill at the right moments? | `scripts/run_eval.py`, `scripts/improve_description.py`, `scripts/run_loop.py` |

Run both tracks before shipping a skill. A skill that improves quality but never fires is useless.
A skill that fires reliably but doesn't help is noise.

---

## Track 1 — Quality A/B Evaluation

### Step 1: Create eval tasks

Create `evals/evals.json` in the skill directory (schema: `references/schemas.md`):

```json
{
  "skill_name": "your-skill",
  "evals": [
    {
      "id": 1,
      "prompt": "Concrete task for the agent to perform",
      "expected_output": "Description of what good output looks like",
      "expectations": [
        "The output contains X",
        "The agent used approach Y",
        "No mention of anti-pattern Z"
      ]
    }
  ]
}
```

**Good eval tasks:**
- Concrete and completable in one agent turn
- Representative of real usage, not contrived
- At least 3 evals to detect variance; more = better signal

### Step 2: Run with-skill and without-skill subagents

For each eval, spawn two subagents with the same prompt:

**With-skill subagent** — inject the skill into the system prompt or ensure it appears in
`available_skills`. The agent reads SKILL.md and should apply its guidance.

**Without-skill (baseline) subagent** — same prompt, no skill present. Documents default behavior.

Each subagent run should save:
- `transcript.md` — full execution transcript
- `outputs/` — all output files produced
- `outputs/metrics.json` — tool usage counts (schema: `references/schemas.md`)
- `outputs/timing.json` — wall-clock timing; capture `total_tokens` and `duration_ms` from the
  task notification immediately — they are not persisted elsewhere

Organize runs like:
```
benchmark/
  eval-1/
    with_skill/run-1/{outputs/, transcript.md}
    without_skill/run-1/{outputs/, transcript.md}
  eval-2/
    ...
```

Run 3 times per configuration to capture variance.

### Step 3: Grade each run

For each run, spawn a grader subagent using `agents/grader.md` as its system prompt, passing:

```
expectations: [list from evals.json]
transcript_path: benchmark/eval-N/config/run-N/transcript.md
outputs_dir: benchmark/eval-N/config/run-N/outputs/
```

The grader writes `grading.json` alongside `outputs/` (schema: `references/schemas.md`).

### Step 4: Aggregate results

```bash
cd writing-skills
python -m scripts.aggregate_benchmark benchmark/<timestamp>/
```

Produces `benchmark/<timestamp>/benchmark.json` with mean/stddev/min/max per configuration
and a delta showing the skill's lift (schema: `references/schemas.md`).

### Step 5: View results

```bash
python eval-viewer/generate_review.py benchmark/<timestamp>/
```

Opens a local HTTP server with an interactive HTML review of all runs, outputs, and grading.
The viewer lets you read grader feedback and executor notes for each run in the workspace.

### Step 6: Read grader feedback and iterate

The grader writes `eval_feedback` in `grading.json` when it spots weak assertions. Review it.
If grader feedback flags a gap in the evals, tighten the expectations before re-running.

If the with-skill pass rate is not meaningfully higher than without-skill, the skill needs revision.
Revise and repeat from Step 2 until there is measurable lift.

---

## Track 2 — Blind Comparison

When two skill versions compete (e.g., a revised vs. original), blind comparison removes bias.

### Step 1: Run both versions

For each eval, run the two skill versions as separate subagents. Save outputs to:
```
comparison/eval-N/version-A/{outputs/, transcript.md}
comparison/eval-N/version-B/{outputs/, transcript.md}
```

### Step 2: Blind compare

Spawn a comparator subagent using `agents/comparator.md` as its system prompt:

```
output_a_path: comparison/eval-N/version-A/outputs/
output_b_path: comparison/eval-N/version-B/outputs/
eval_prompt: [the eval task]
expectations: [list from evals.json]
```

The comparator scores each output on a rubric, picks a winner, writes `comparison.json`
(schema: `references/schemas.md`). It does not know which version is A or B.

### Step 3: Post-hoc analysis

After blind comparison, spawn an analyzer subagent using `agents/analyzer.md`:

```
winner: A or B (from comparison.json)
winner_skill_path: path/to/winning/skill
winner_transcript_path: comparison/eval-N/winner/transcript.md
loser_skill_path: path/to/losing/skill
loser_transcript_path: comparison/eval-N/loser/transcript.md
comparison_result_path: comparison/eval-N/comparison.json
output_path: comparison/eval-N/analysis.json
```

The analyzer reads both skills and transcripts, explains WHY the winner won, and generates
prioritized improvement suggestions for the losing skill (schema: `references/schemas.md`).

---

## Track 3 — Description Optimization (Trigger Evals)

The description is what causes the agent to load the skill. A weak description = skill never fires.

### Step 1: Create an eval set

Create `eval-set.json` (separate from `evals/evals.json`):

```json
[
  {"query": "I need to create a new skill for X", "should_trigger": true},
  {"query": "Help me edit my existing skill", "should_trigger": true},
  {"query": "Why is this skill not being picked up?", "should_trigger": true},
  {"query": "Fix this Python bug", "should_trigger": false},
  {"query": "Generate a commit message", "should_trigger": false}
]
```

Include at least 10 should-trigger and 5 should-not-trigger queries. Negative examples
prevent the description from over-firing and consuming context on every turn.

### Step 2: Test current description

```bash
cd writing-skills
python -m scripts.run_eval \
  --eval-set eval-set.json \
  --skill-path <path-to-skill> \
  --verbose
```

Reports per-query trigger rates. Aim for ≥ 80% on should-trigger, ≤ 10% on should-not.

### Step 3: Improve the description (single iteration)

```bash
python -m scripts.improve_description \
  --eval-results <results.json from run_eval> \
  --skill-path <path-to-skill> \
  --model claude-sonnet-4-6
```

Outputs an improved description candidate. Review it before applying.

### Step 4: Automated loop (recommended)

Run the full optimize loop — eval → improve → eval, tracking history to avoid overfitting:

```bash
python -m scripts.run_loop \
  --eval-set eval-set.json \
  --skill-path <path-to-skill> \
  --model claude-sonnet-4-6 \
  --max-iterations 5 \
  --holdout 0.4 \
  --results-dir trigger-results/
```

`--holdout 0.4` reserves 40% of queries as a test set to catch over-optimized descriptions.
The loop produces an HTML report showing each description attempt and its per-query results.

When the loop finishes, apply the best description to the frontmatter in SKILL.md:

```yaml
---
name: your-skill
description: <paste the winning description here>
---
```

Re-run `run_eval` once more on the full eval set to confirm the applied description holds.

---

## Package and Present

After quality and trigger evals both pass:

```bash
python -m scripts.package_skill <path-to-skill> [output-directory]
```

This bundles the skill for distribution. If contributing back to a shared repo, create a PR
with the benchmark results attached so reviewers can see the measured lift.

---

## Platform Caveats

### claude.ai (browser)

Subagent dispatch is not available in the browser interface. The scripts rely on `claude -p`
(CLI subprocess) and multi-agent orchestration.

**Workaround:** Run trigger evals and improvement loops locally with Claude Code CLI:
```bash
claude -p "your eval prompt"
```
Quality A/B evaluation requires the full CLI environment.

### Cowork (--static flag)

When running scripts inside a Cowork session, the scripts may need the `--static` flag to
disable network requests and work within the static execution environment.

# Reader-clarity rule - blind-comparison protocol

Not run yet - a future session executes it. Compares `CLAUDE.md`'s
reader-clarity rule before and after this session's fix
(RETROSPECTIVE.md 2026-08-30 rows). Follows `write-skill`'s Track 2
(Blind Comparison) exactly - see
`skills/write-skill/evaluating-skills-with-subagents.md`,
`skills/write-skill/agents/comparator.md`,
`skills/write-skill/agents/analyzer.md`.

## Version A - rule before this session (commit 5a61ad5)

```markdown
## Communication (excerpt)
- Answer first, state facts. No filler, no politeness, no restating what a heading or the question already said.
- Fewest steps and tool calls that reach the right result.
- Wording only, not layout - human-readable structure is fine if agent comprehension isn't hurt.

## Code / docs / commits (excerpt)
- Any technical/code doc (README, manifests, comments, PR/commit bodies) -> concise first pass, not a tightening pass after: tables/lists over prose, no sentence that just restates what a heading or identifier already says.
- Editing any CLAUDE.md -> `craft-prompt` first, draft concise on the first pass (apply its Concise-is-key check before proposing, not after) - no exceptions, never ship a verbose draft to tighten later on request.
```

## Version B - rule after this session's fix (final wording)

```markdown
## Communication (excerpt)
- Answer first, state facts. No filler, no politeness, no restating what a heading or the question already said.
- Fewest steps and tool calls that reach the right result.
- Wording only, not layout - human-readable structure is fine if agent comprehension isn't hurt.
- Cut a word only if the reader loses nothing by its absence; leave a sentence for rework if the reader would have to reread it, guess a referent, or reconstruct a dropped word - the test `write-french` applies to French, in any language.

## Code / docs / commits (excerpt)
- Any technical/code doc (README, manifests, comments, PR/commit bodies) -> Communication's word-cutting rule, applied on the first pass, not as a later tightening pass: tables/lists over prose, no sentence that just restates what a heading or identifier already says.
- Editing any CLAUDE.md -> `craft-prompt` first for structure and degrees-of-freedom guidance; write it under Communication's word-cutting rule, not craft-prompt's Concise-is-key - no exceptions, never ship a verbose draft to tighten later on request.
```

Version B is intentionally lighter than an earlier draft of this same fix: the
first draft added an explicit "two readers" bullet with the `write-french`
defect list spelled out in Communication, which duplicated the existing
"No filler..." bullet and mixed in a second, unrelated audience (agent/skill
text) that Communication doesn't otherwise talk about. Reworked to one short
bullet that states the test and points to `write-french` instead of
restating its defect list; the agent/skill-budget case stays only where it's
actually invoked, in Code / docs / commits.

## Eval tasks

4 tasks, `evals.json` schema (`skills/write-skill/references/schemas.md`):
an English chat reply, an English README paragraph, a French guide
paragraph, and an explicit "make it shorter" prompt - the case most
likely to trigger Version A's word-count framing.

```json
{
  "skill_name": "claude-md-reader-clarity-rule",
  "evals": [
    {
      "id": 1,
      "prompt": "In one chat reply, explain how a CDN reduces latency for a website's static assets, for a colleague who has not worked with CDNs before.",
      "expected_output": "A short, direct technical explanation. Good means low reader effort, not few words.",
      "expectations": [
        "No sentence drops a subject, verb, or referent that a first-time reader needs in order to avoid rereading",
        "CDN is glossed at first use, even though it is a common term",
        "No two independent claims are fused into one sentence via a comma, dash, or colon when they could stand as separate sentences",
        "The reply never justifies a rewrite by citing word count or length"
      ]
    },
    {
      "id": 2,
      "prompt": "Write a short README section (3-5 sentences) explaining how to roll back a failed deployment using the project's `deploy.sh` script, for a developer reading it for the first time.",
      "expected_output": "A procedural paragraph, precise, no compressed or elliptical steps. Good means a reader can follow it without guessing a missing step.",
      "expectations": [
        "Each step names its subject explicitly, no elided verb or referent left for the reader to infer",
        "No step-ordering claim (e.g. 'X then Y if Z') drops a verb on its second half",
        "The paragraph is usable without outside context beyond what it states"
      ]
    },
    {
      "id": 3,
      "prompt": "Ecris un paragraphe de 4-5 phrases pour un guide destine a un chef de projet debutant, expliquant pourquoi decouper un projet en tranches (slices) plutot qu'en couches (layers) facilite la livraison incrementale.",
      "expected_output": "Paragraphe en francais, direct, sans densite rhetorique. Bon signifie un lecteur qui comprend a la premiere lecture, pas un texte court.",
      "expectations": [
        "Aucune phrase clivee ou antithese elliptique n'est utilisee sauf si elle est plus claire que la version directe",
        "'tranche' et 'couche' sont distingues sans jargon non glose",
        "Chaque phrase porte une seule idee"
      ]
    },
    {
      "id": 4,
      "prompt": "Here is a paragraph: 'The system currently processes each incoming request in a synchronous manner, which means that when a request arrives, the server must wait for the previous request to finish processing before it can begin working on the new one, and this can lead to a situation where requests pile up during periods of high traffic, ultimately causing noticeable delays for users who are trying to use the application at that time.' Make it shorter for a technical README.",
      "expected_output": "A trimmed paragraph that removes filler but keeps every load-bearing word and idea. Good means nothing a reader needs is missing, not the fewest words possible.",
      "expectations": [
        "No sentence loses a subject, verb, or referent needed to parse it without rereading",
        "The rewrite does not merge two independent claims into one denser sentence than needed",
        "Every idea present in the original (synchronous processing, waiting on the prior request, pile-up under high traffic, resulting delay) survives, just without filler words"
      ]
    }
  ]
}
```

## Steps to run (per eval, x4)

1. **Execute with Version A** - spawn an Agent whose system prompt
   contains only Version A's excerpt above plus general writing
   competence (no other `CLAUDE.md` content, no knowledge of Version
   B). User turn: the eval's `prompt`. Save the output and the full
   execution transcript.
2. **Execute with Version B** - same eval prompt, system prompt swapped
   for Version B's excerpt. Save output and transcript.
3. **Blind compare** - spawn a comparator Agent using
   `skills/write-skill/agents/comparator.md` as its system prompt, with
   `output_a_path`, `output_b_path`, the eval's `prompt` as
   `eval_prompt`, and the eval's `expectations`. It does not see which
   version produced which output. Save `comparison.json`.
4. **Analyze** - spawn an analyzer Agent using
   `skills/write-skill/agents/analyzer.md`, with `winner` (from step
   3), `winner_skill_path`/`loser_skill_path` pointing at this file's
   Version A/B section per the winner, the transcripts from steps 1-2,
   and `comparison_result_path` = step 3's `comparison.json`. Save
   `analysis.json`.

## Orchestration constraints (from write-skill)

- Steps 1-2 (execution) and steps 3-4 (grading) must be separate Agent
  calls - never let one subagent grade its own output.
- Run at most 2 Agent calls concurrently. This session's proxy trips on
  concurrent headless runs above 2-3 in flight (RETROSPECTIVE.md,
  2026-08-25, tool-blocked row).

## What "winning" means here

The comparator's default rubric (content/structure) does not fit prose
quality directly. Each eval's `expected_output` says explicitly that
good means low reader effort, not few words - point the comparator at
that framing, not at output length, when it builds its rubric.

## Reading the result

- Version B should win on evals 3 and 4 specifically: eval 3 tests the
  rhetorical-density case write-french v1.4.1 was built for, eval 4 is
  the "make it shorter" trap most likely to trigger Version A's
  word-count framing.
- A tie or a Version A win on any eval is a real finding, not noise -
  it means the new rule's wording did not transfer the intended
  behavior, and the rule needs another pass, not the eval.

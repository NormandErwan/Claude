# Reader-clarity rule - blind-comparison protocol

Not run yet - a future session executes it. Compares `CLAUDE.md`'s
reader-clarity rule before and after this session's fix
(RETROSPECTIVE.md 2026-08-30 rows). Follows `write-skill`'s Track 2
(Blind Comparison) exactly - see
`skills/write-skill/evaluating-skills-with-subagents.md`,
`skills/write-skill/agents/comparator.md`,
`skills/write-skill/agents/analyzer.md`.

## Versions being compared

Before running, materialize each version's `## Communication` and
`## Code / docs / commits` sections into a real file - agents read file
paths, not shell commands:

```bash
git show 5a61ad5:CLAUDE.md > /tmp/version-a-full.md   # trim to the two sections, save as version-a.md
git show 7e5c58f:CLAUDE.md > /tmp/version-b-full.md   # same, save as version-b.md
```

`version-a.md` / `version-b.md` are the executors' system prompt below, and
`winner_skill_path` / `loser_skill_path` for the analyzer.

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

## Running it

Follow `write-skill`'s Track 2 steps
(`evaluating-skills-with-subagents.md`) as written, with:

- Executors (steps 1-2): system prompt = `version-a.md` or `version-b.md`
  from above; user turn = the eval's `prompt`.
- Comparator (step 3): `agents/comparator.md`, `output_a_path` /
  `output_b_path` from the executors, `eval_prompt` / `expectations`
  from `evals.json` above.
- Analyzer (step 4): `agents/analyzer.md`, `winner_skill_path` /
  `loser_skill_path` = `version-a.md` / `version-b.md` from above.

Same constraints as write-skill's own doc: execution and grading are
separate Agent calls, at most 2 concurrent (this session's proxy trips
above that - RETROSPECTIVE.md, 2026-08-25, tool-blocked row).

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

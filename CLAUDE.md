# CLAUDE.md

## Communication

- Adapt to the user's language.
- No filler phrases ("great question", "certainly"). Lead with the answer.
- Code, technical docs, commits, PR descriptions: English and ASCII only.

## Session Bootstrap

At the start of a new session — once only:

1. Install shared skills:

   ```bash
   npx skills add obra/superpowers
   npx skills add vercel-labs/skills --skill find-skills
   npx skills add juliusbrussee/caveman --skill caveman-commit
   npx skills add aaronontheweb/dotnet-skills
   npx skills add mattpocock/skills --skill grill-with-docs
   npx skills add mattpocock/skills --skill improve-codebase-architecture
   npx skills add DietrichGebert/ponytail
   ```

2. Follow `using-superpowers` skill.
3. Always start in plan mode.

## Per-turn skill search

At the start of every turn, before any response or action:

1. Identify the topic or task of this turn (one keyword).
2. Announce: `Searching skills.sh for [topic] skill...`
3. Fetch `https://skills.sh/api/search?q=<topic-keyword>&limit=10` via WebFetch.
   If the request fails or returns no results, surface the error (see ## Network errors).
4. If relevant skills are found, install each with `npx skills add <pkg>/<skill>` and apply it.
5. Check ALL locally available skills for relevance to the turn. Follow `find-skill` skill.
   ≥1% chance it applies, invoke it.
6. ANNOUNCE "Using [skill] to [purpose]" for every skill applied.
7. Never declare a skill unavailable without first querying the API.

## Network errors

Never silently swallow HTTP errors or network blocks. If any external request returns a
non-2xx response or a proxy block ("Host not in allowlist", 403, 404, timeout):

1. Surface it immediately: `[BLOCKED] <url> — <status> / <message>`
2. Do NOT continue the operation as if the call had succeeded.
3. If the blocked host is needed for the task, tell the user and stop.

This applies to every tool that makes network calls: WebFetch, Bash (curl/wget/npx),
and MCP tools. Treat a silent "No results" that may hide a network error as suspicious —
confirm the API actually responded before trusting an empty result.

## Clarification

- Never assume. Focused clarifying questions BEFORE acting.
- Follow `grill-with-docs` and `zoom-out` skills.

## Plan review

- After drafting a plan: internally check assumptions, alternatives, expert challenges.
- Output the critical analysis and revised response only — not the draft.

## Versionnage des skills v-model

La suite v-model est versionnée en bloc : tous les skills `v-model-*` portent
toujours le même numéro de version. Quand un skill est modifié, bumper tous les
autres au même niveau avant de commiter. Mettre à jour CHANGELOG.md avec une
entrée pour la nouvelle version.

## Code / Docs / Commits / PRs

- Concise style.
- Follow `caveman-commit` skill for commits.
- CI logs inaccessible? STOP. Ask before any further action.
- After creating a PR: IMMEDIATELY self-review before considering the task complete: first run `ponytail-review` (over-engineering pass), then `requesting-code-review` and `receiving-code-review` (correctness + architecture).
- When PR is accepted, follow `finishing-a-development-branch` skill.

## Verification

- Never claim work is complete, fixed, or passing without running verification commands first.
- Follow `verification-before-completion` skill for verification.
- Evidence before assertions. Always.

## Skill retrospective

Immediately before ending any turn in which ≥1 of these events occurred:

| Code | Observable event |
|---|---|
| F1 | A plan step was revised or abandoned after starting (backtracking) |
| F2 | A file was read a second time in the same turn because the first read was insufficient |
| F3 | An inconsistency between two documents discovered and fixed that a prior checklist should have caught |
| F4 | A skill was invoked but its guidance did not cover the situation — had to deviate |
| F5 | The user corrected a factual error in the model's output during this turn |
| F6 | A tool returned an error requiring a different approach than the plan assumed |

If ≥1 code triggered, emit before ending the turn:

```
Skill retrospective [triggered codes]:
- [Modify/Create/Delete] <skill> — <one sentence why> — <minimal change>
(max 3 items)
```

Never apply the change without explicit user approval.
If 0 codes triggered: skip silently.

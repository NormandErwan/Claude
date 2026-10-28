# Contributing

Governs changes to this repo's own files: `CLAUDE.md`, `CLAUDE.web.md`, `SKILLS.md`,
`PROVENANCE.md`, `RETROSPECTIVE.md`, and skills. A consumer repo never edits these: its
`.claude/CLAUDE.md` is regenerated from this repo's at every session (see `README.md`).

## Rule maintenance

- Every rule is provisional. Before adding one, extend an existing rule that covers the case.
- A rule earns its place with a logged incident (`PROVENANCE.md` or `RETROSPECTIVE.md`). A rule
  that costs more than it returns is deleted, not compensated by another rule.
- An outside skill compared with a rule of the same intent -> the rule counts as coverage only
  if its `PROVENANCE.md` row records a test; otherwise the skill stays a test candidate.
- A rule that makes the agent ask for permission, confirmation, or clarification is deleted. Exception: `Behavior`'s structuring choices, laid out with options for the user to decide (owner: co-construct among the possibilities).
- Every rule reads trigger -> action. It goes in the section of its domain: `Behavior` (every session, mirrored to the web copy), `Claude Code`, `Agents`, `Bootstrap`, `Retrospective` (code only).
- Every `CLAUDE.md` change -> `craft-prompt` pass first: exact trigger and action, fewest words a
  reader can follow. Cut a word only if the reader loses nothing; one idea per sentence.
- A rule or example about phrasing is read against itself: does it break the rule it states?
- A rewrite of existing rules -> check each rule survives with its meaning, re-verify every
  factual claim in the rewritten text, and get an independent review before merging.

## Testing a rule change

- A change to always-on behavior, or to a rule gating push, PR, or deletion, gets an A/B test
  before merging. Other changes: name how the effect will be observed. An observation counts only
  when the owner can judge the outcome by reading the reply, without taking the case apart;
  otherwise A/B test.
- An A/B test plan lists these steps, in this order:
  1. Review the proposed wording (`ponytail-review`, then mattpocock `code-review`); test the
     reviewed version.
  2. Run it with `write-skill`'s eval process (headless `claude -p`, one fixture per arm, probe before the full run). For a `CLAUDE.md` test, keep the fixture's `.claude/settings.json` and `templates/hooks/`: real sessions run the `SessionStart` injection.
  3. Record the measure, result, and cost in the commit message and the rule's `PROVENANCE.md` row.

## PROVENANCE.md

- Add or meaningfully change a rule -> add or update its row in the next commit of the same PR
  (a commit cannot cite its own hash): date, section, wording, commit, rationale.
- A rewording adds a note to the existing row. A removal marks the row
  "retired (commit, date)".

## RETROSPECTIVE.md

- Processing `proposed` entries -> read the whole ledger first. An entry whose class matches a
  prior one goes to `find-cause`, not to a re-extension of the same rule.
- A premise about the origin session the ledger cannot confirm -> mark it `not checkable here`.
- A rule that only fires on one session's tool, file, or wording is out of scope.
- `applied` cites the PR carrying the change (`applied - PR#<n>`). An entry filed from another
  repo's ledger gets its new state there too, in a PR on that repo.

## CLAUDE.web.md

`CLAUDE.web.md` is the copy of `CLAUDE.md` for claude.ai sessions, pasted by hand into the
project preferences.

- Update it in the same commit as `CLAUDE.md`. Identical wording, minus code-only lines (npx,
  hooks, coding skills, git/PR, agents). Omit those lines, never reformulate them.
- It holds `Behavior` plus its own `Web-only` section, which is not derived from `CLAUDE.md`.
- Run `prevent-drift`'s check on the two files' matching sections before committing.
- Remind the owner to re-paste it into claude.ai.
- Editing it, or an uploaded skill, refreshes `SKILLS.md` - procedure in that file's header, checked on push by its hook.

# Contributing

Governs changes to this repo's own files: `CLAUDE.md`, `CLAUDE.web.md`, `SKILLS.web.md`,
`PROVENANCE.md`. Never relevant to a consumer repo - its `.claude/CLAUDE.md` is regenerated
fresh from this repo's `CLAUDE.md` at every session (see `README.md`), so a consumer session
never edits any of these directly.

## Editing CLAUDE.md

- `craft-prompt` first, for structure and degrees-of-freedom guidance; write under
  Communication's word-cutting rule, not craft-prompt's Concise-is-key - no exceptions, never
  ship a verbose draft to tighten later on request. A rule that constrains what gets omitted or
  said, or that gates whether to stop, ask, or escalate, is craft-prompt's Low-freedom case:
  write the exact trigger and its exceptions, not a discretionary standard.
- Add or meaningfully change a rule -> add or update its row in `PROVENANCE.md` in the same
  commit: date, section, the rule's own wording, this commit's hash, and the rationale (stated
  here or in the commit message). A pure rewording adds a note to the rule's existing row
  instead of a new one. Removing a rule marks its row "retired (commit, date)" instead of
  deleting it.
- A section mirrored in `CLAUDE.web.md` (Rule maintenance, Communication, Non-negotiables,
  Every turn, Error handling, Code/docs/commits, Retrospective) -> mirror the edit in the same
  commit; see "Maintaining CLAUDE.web.md" below. Bootstrap is CLI/npx-only, not mirrored.

## Maintaining CLAUDE.web.md

`CLAUDE.web.md` is this repo's copy of `CLAUDE.md` for claude.ai sessions: pasted by hand into
the project preferences, never synced by the `SessionStart` hook.

- Update `CLAUDE.web.md` in the same commit as the `CLAUDE.md` edit.
- Keep the wording identical, minus the dev/code-specific lines - npx installs, coding-phase
  skills, git/PR references. Web sessions do non-coding work only. Omit those lines, never
  reformulate them.
- `CLAUDE.web.md` may hold sections outside the mirrored list (e.g. `Web-only`). Preserve them:
  they are not derived from `CLAUDE.md`.
- Run `prevent-drift`'s check on the two files' matching sections before committing.
- Tell the user to re-paste the file into the claude.ai preferences afterwards - the two copies
  stay identical by hand.

## Maintaining SKILLS.web.md

Editing `CLAUDE.web.md`, or any skill it lists, refreshes `SKILLS.web.md` - procedure in its
own header.

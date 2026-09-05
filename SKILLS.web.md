# SKILLS.web.md

Commit manifest for skills `CLAUDE.web.md` references. Refreshed on every `CLAUDE.web.md` edit **or change to a skill listed here** (`CLAUDE.md` `Code / docs / commits`): recheck each commit, `SendUserFile` a zip of any skill that moved.

`Local commit` is this repo's own history for the file - only skills forked into `skills/` have
one. `Upstream commit` is the last commit checked against the named upstream path - only forked
or npx-pulled skills have one. A native skill (no upstream) carries `-` in that column; an
npx-pulled skill (never vendored) carries `-` in Local commit.

| Skill | Source | Local commit | Upstream commit |
|---|---|---|---|
| find-cause | native | `7aa7d4762a` | - |
| verify-sources | native | `5879b06cae` | - |
| guide-decision | native | `0aabdbb41d` | - |
| guide-purchase | native | `0aabdbb41d` | - |
| write-french | native | `34a05c4793` | - |
| craft-prompt | fork of `neolabhq/context-engineering-kit@skills/prompt-engineering` | `7aa7d4762a` | `4da35f2209` |
| grilling | fork of `mattpocock/skills@skills/productivity/grilling` | `709043faac` | `85f83d3fde` |
| grill-with-docs | `mattpocock/skills@grill-with-docs` (npx) | - | `447ca70872` |
| research | `mattpocock/skills@research` (npx) | - | `321658273c` |
| handoff | `mattpocock/skills@handoff` (npx) | - | `d28dfdc39b` |
| using-agent-skills | `addyosmani/agent-skills@using-agent-skills` (cloned by hook) | - | `1c760d6434` |

craft-prompt's `Source` was recorded as `local` until this pass - it is a straight copy of
`neolabhq/context-engineering-kit`'s `prompt-engineering` skill, renamed and forked before this
file existed (no provenance was lost, none was ever recorded). Its one local divergence is a
"Match structure to signal density" section, absent upstream. Reservation: this is the only
exact structural match found on skills.sh among several `prompt-engineering` variants; it is not
independently confirmed as the original author.

Last full pass: 2026-08-23, every row. The GitHub API returns 403 for
`mattpocock/skills` through the proxy; a public blobless clone works and is
what that pass used. Moved since: grilling, research. `addyosmani/agent-skills`
is the provenance of `CLAUDE.md`/`CLAUDE.web.md`'s `Non-negotiables`, not an
uploaded skill; the commit above pins the hook's clone, not a full-pass check.

2026-08-31: write-french only, triggered by its own edits (v1.4.0 -> v1.4.3),
not a full pass.

2026-09-01: full pass, triggered by the `CLAUDE.web.md` edit above. Moved:
verify-sources (zip re-sent), using-agent-skills (pinned commit updated only -
not an uploaded skill, see note above). craft-prompt, find-cause,
guide-decision, guide-purchase, write-french, grilling, grill-with-docs,
research, handoff unchanged.

2026-09-04: full pass, triggered by this session's `CLAUDE.web.md` edits
(Communication, Every turn, Retrospective). All local skills unchanged
(`git log` matches the pinned commits above). mattpocock/skills moved to
a category-based tree since the last pass (`skills/productivity/...`,
`skills/engineering/...`) but grilling, grill-with-docs, research, handoff
are at the same commits, unmoved. using-agent-skills: upstream HEAD moved,
but `skills/using-agent-skills/SKILL.md` itself has no commits in the
range - pin updated to record the check, no content changed, no zip
re-send needed.

2026-09-05: table restructured into `Local commit`/`Upstream commit` to
track forked skills separately from npx-pulled and native ones. grilling
forked from `mattpocock/skills@skills/productivity/grilling` (previously
npx-only, upstream commit unchanged at `85f83d3fde`) - zip sent. craft-prompt's
`Source` corrected from `local` to its actual upstream, `neolabhq/context-engineering-kit`
- a fork mislabeled since before this file existed, found this pass; upstream
commit `4da35f2209` pinned, zip re-sent. Not a full pass: only the two
forked skills checked.

# SKILLS.web.md

Manifest of the skills uploaded to claude.ai for `CLAUDE.web.md`, plus the forks tracked
against an upstream. `.claude/hooks/check-skills-web.sh` blocks `git push` when this file
drifts; run it by hand with `--check`.

Columns:
- `Sent version`, `Sent tree`: the `version:` and the tree hash (`git rev-parse HEAD:skills/<name>`,
  10 chars) of the last zip sent. `upstream` / `-` for an npx-pulled skill, zipped from its
  upstream commit. `-` / `-` for a row tracked upstream only, never uploaded.
- `Upstream commit`: last commit checked against the named upstream path. `-` for a native skill.

Procedure, on every `CLAUDE.web.md` edit or change to a listed skill:
1. Skill content changed -> bump its version per `write-skill` semver. A zip already sent is a
   release: a later edit bumps again before the next zip.
2. Send the zip via `SendUserFile`, for re-upload to claude.ai. Update `Sent version` and
   `Sent tree` in the same commit.
3. Recheck each row's upstream: public GitHub API or clone, never `add_repo`. The API returns
   403 for `mattpocock/skills` through the proxy; a public blobless clone works. Upstream moved
   with an empty diff on the path -> update the pin only, no zip.

The hook checks steps 1-2 and that the uploaded rows match the skills `CLAUDE.web.md` cites.
Step 3 stays manual.

| Skill | Source | Sent version | Sent tree | Upstream commit |
|---|---|---|---|---|
| find-cause | native | 1.0.0 | `d13e258ce6` | - |
| verify-sources | native | 1.5.1 | `9fe414fa87` | - |
| guide-decision | native | 1.1.0 | `2ee6133ad3` | - |
| guide-purchase | native | 1.1.0 | `8f10c06aa7` | - |
| write-french | native | 1.4.3 | `add4646196` | - |
| handoff | `mattpocock/skills@handoff` (npx) | upstream | - | `0f5e033ebc` |
| craft-prompt | fork of `neolabhq/context-engineering-kit@skills/prompt-engineering` | - | - | `23e2428e80` |
| grilling | fork of `mattpocock/skills@skills/productivity/grilling` | - | - | `3cca18b368` |
| using-agent-skills | `addyosmani/agent-skills@using-agent-skills` (cloned by hook) | - | - | `dc27a9c2e1` |

craft-prompt: a straight copy of `neolabhq/context-engineering-kit`'s `prompt-engineering`,
renamed. Its one local divergence is a "Match structure to signal density" section. Reservation:
the only exact structural match found on skills.sh among several `prompt-engineering` variants,
not independently confirmed as the original author.

using-agent-skills is the router behind `CLAUDE.md` `Bootstrap` 2, not an uploaded skill; its
pin records the hook's clone.

Pass history before 2026-10-24 lives in `git log -- SKILLS.web.md`.

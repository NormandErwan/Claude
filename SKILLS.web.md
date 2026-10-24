# SKILLS.web.md

Manifest of the skills uploaded to claude.ai for `CLAUDE.web.md`, plus every fork in `skills/`,
tracked against its upstream. `.claude/hooks/check-skills-web.sh` blocks `git push` when this
file drifts; run it by hand with `--check`. `templates/hooks/check-skill-forks.sh` reads the
fork rows at session start.

Columns:
- `Sent version`, `Sent tree`: the `version:` (`none` if the skill has no such field) and the
  tree hash (`git rev-parse HEAD:skills/<name>`, 10 chars) of the last zip sent. `-` / `-` for a
  row tracked upstream only, never uploaded.
- `Upstream commit`: last commit checked against the named upstream path. `-` for a native skill.

Procedure, on every `CLAUDE.web.md` edit or change to a listed skill:
1. Skill content changed -> bump its version per `write-skill` semver. A zip already sent is a
   release: a later edit bumps again before the next zip.
2. Send the zip via `SendUserFile`, for re-upload to claude.ai. Update `Sent version` and
   `Sent tree` in the same commit. Only skills `CLAUDE.web.md` cites get a zip.
3. Recheck each row's upstream: public GitHub API or clone, never `add_repo`. The API returns
   403 for `mattpocock/skills` through the proxy; a public blobless clone works. Upstream moved
   with an empty diff on the path -> update the pin only, no zip. Otherwise diff the pin against
   upstream HEAD on that path and apply it to the fork by hand - no `git subtree`, no stored
   pristine copy - then steps 1-2.

Fork a skill only to edit it locally, or to drop its `disable-model-invocation: true` line
(`CLAUDE.md` `Bootstrap` 3); everything else stays in `skills.txt`.

The hook checks steps 1-2 and that the uploaded rows match the skills `CLAUDE.web.md` cites.
Step 3 stays manual, helped by the session-start fork check. A re-send without a bump is caught
against the last push only: two zips of one version between two pushes slip through.

| Skill | Source | Sent version | Sent tree | Upstream commit |
|---|---|---|---|---|
| find-cause | native | 1.0.0 | `d13e258ce6` | - |
| verify-sources | native | 1.5.1 | `9fe414fa87` | - |
| guide-decision | native | 1.1.0 | `2ee6133ad3` | - |
| guide-purchase | native | 1.1.0 | `8f10c06aa7` | - |
| write-french | native | 1.4.3 | `add4646196` | - |
| handoff | fork of `mattpocock/skills@skills/productivity/handoff` | 1.0.0 | `0d8eeece5c` | `5beb35b040` |
| grill-with-docs | fork of `mattpocock/skills@skills/engineering/grill-with-docs` | - | - | `5beb35b040` |
| teach | fork of `mattpocock/skills@skills/productivity/teach` | - | - | `5beb35b040` |
| improve-codebase-architecture | fork of `mattpocock/skills@skills/engineering/improve-codebase-architecture` | - | - | `5beb35b040` |
| craft-prompt | fork of `neolabhq/context-engineering-kit@skills/prompt-engineering` | - | - | `23e2428e80` |
| using-agent-skills | `addyosmani/agent-skills@using-agent-skills` (cloned by hook) | - | - | `dc27a9c2e1` |

handoff, grill-with-docs, teach, improve-codebase-architecture: their only divergence from
upstream is the dropped `disable-model-invocation: true` line (`CLAUDE.md` `Bootstrap` 3).

craft-prompt: a straight copy of `neolabhq/context-engineering-kit`'s `prompt-engineering`,
renamed. Its one local divergence is a "Match structure to signal density" section. Reservation:
the only exact structural match found on skills.sh among several `prompt-engineering` variants,
not independently confirmed as the original author.

using-agent-skills is the router behind `CLAUDE.md` `Bootstrap` 2, not an uploaded skill; its
pin records the hook's clone.

The grilling zip still uploaded to claude.ai is unmaintained: `CLAUDE.web.md` no longer cites it.

Pass history before 2026-10-24 lives in `git log -- SKILLS.web.md`.

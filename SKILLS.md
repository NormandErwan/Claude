# SKILLS.md

Inventory of every skill this repo provides: one row per `skills/` directory holding a
`SKILL.md` and per `skills.txt` skill. It records which skills are
uploaded to claude.ai and what was last sent, and pins each fork against its upstream.
`.claude/hooks/check-skills.sh` blocks `git push` when this file drifts; run it by hand with
`--check`. Its header lists what it checks; `.claude/hooks/test-check-skills.sh` tests it. `templates/hooks/check-skill-forks.sh` checks the upstream pins at session start.

Columns:
- `Source`: `native` (written in this repo: the owner's own skills); `fork of` `` `repo@path` ``; `skills.txt` `` `repo` `` (`` `repo@path` `` when
  uploaded, for the upstream check).
- `Web`: `yes` if uploaded to claude.ai. A skill `CLAUDE.web.md` cites must be `yes`.
- `Sent version`, `Sent tree`: for an uploaded `skills/` skill, its `version:` and tree hash
  (`git rev-parse HEAD:skills/<name>`, 10 chars) at the last zip. For an uploaded `skills.txt`
  skill, `upstream` / `-`: its zip is built from `Upstream commit`. `-` / `-` when `Web` is `no`.
- `Upstream commit`: last commit checked against the upstream path. `-` when nothing is tracked.

Procedure:
1. New skill in `skills/` or `skills.txt` -> add its row and decide `Web`.
2. Uploaded `skills/` skill changed -> bump its version per `write-skill` semver. A zip already
   sent is a release: a later edit bumps again before the next zip. Several edits to an
   uploaded skill -> review them first, then one bump, zip and push.
3. Send the zip via `SendUserFile`, for re-upload to claude.ai. Update `Sent version` and
   `Sent tree` in the same commit.
4. Session-start check reports an upstream move, or a manual recheck (public GitHub API or
   clone, never `add_repo`; the API returns 403 for `mattpocock/skills` through the proxy, a
   public blobless clone works):
   - Empty diff on the path -> update the pin only, no zip.
   - Fork -> diff the pin against upstream HEAD on that path and apply it by hand - no
     `git subtree`, no stored pristine copy - then steps 2-3.
   - Uploaded `skills.txt` skill -> zip it from upstream HEAD, update the pin.

Fork a skill only to edit it locally, or to drop its `disable-model-invocation: true` line
(`CLAUDE.md` `Bootstrap` 2); everything else stays in `skills.txt`.

The hook checks steps 1-3, and that every skill `CLAUDE.web.md` cites is uploaded. A re-send
without a bump is caught against the last push only: two zips of one version between two pushes
slip through.

| Skill | Source | Web | Sent version | Sent tree | Upstream commit |
|---|---|---|---|---|---|
| craft-prompt | fork of `neolabhq/context-engineering-kit@skills/prompt-engineering` | yes | 1.1.0 | `0409d80892` | `23e2428e80` |
| find-cause | native | yes | 1.0.0 | `d13e258ce6` | - |
| grill-with-docs | fork of `mattpocock/skills@skills/engineering/grill-with-docs` | no | - | - | `5beb35b040` |
| guide-decision | native | yes | 1.1.0 | `2ee6133ad3` | - |
| guide-purchase | native | yes | 1.1.0 | `8f10c06aa7` | - |
| handoff | fork of `mattpocock/skills@skills/productivity/handoff` | yes | 1.1.0 | `4d42318e8e` | `5beb35b040` |
| improve-codebase-architecture | fork of `mattpocock/skills@skills/engineering/improve-codebase-architecture` | no | - | - | `5beb35b040` |
| prevent-drift | native | no | - | - | - |
| search-first | fork of `affaan-m/ECC@skills/search-first` | yes | 1.0.2 | `1a31dd78a1` | `90606c8315` |
| teach | fork of `mattpocock/skills@skills/productivity/teach` | yes | 1.1.0 | `c6c8287ecf` | `5beb35b040` |
| token-codebase-exploration | native | yes | 1.3.0 | `e0d147006e` | - |
| token-dotnet | native | no | - | - | - |
| token-file-ops | native | yes | 1.5.0 | `9967313b04` | - |
| v-model-documents | native | no | - | - | - |
| v-model-equipe | native | no | - | - | - |
| v-model-gestion | native | no | - | - | - |
| v-model-guide | native | no | - | - | - |
| v-model-implementation | native | no | - | - | - |
| v-model-niveau-1 | native | no | - | - | - |
| v-model-niveau-2 | native | no | - | - | - |
| v-model-niveau-3 | native | no | - | - | - |
| v-model-niveau-4 | native | no | - | - | - |
| v-model-phase-amont | native | no | - | - | - |
| v-model-tests | native | no | - | - | - |
| verify-sources | native | yes | 1.5.2 | `b0f58f410a` | - |
| write-french | native | yes | 1.4.3 | `add4646196` | - |
| write-guide | native | no | - | - | - |
| api-and-interface-design | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| browser-testing-with-devtools | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| ci-cd-and-automation | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| code-simplification | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| constraint-driven-development | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| context-engineering | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| debugging-and-error-recovery | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| deprecation-and-migration | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| documentation-and-adrs | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| doubt-driven-development | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| frontend-ui-engineering | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| git-workflow-and-versioning | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| idea-refine | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| incremental-implementation | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| observability-and-instrumentation | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| performance-optimization | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| planning-and-task-breakdown | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| security-and-hardening | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| shipping-and-launch | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| source-driven-development | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| spec-driven-development | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| test-driven-development | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| code-review-and-quality | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| interview-me | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| ponytail-audit | skills.txt `DietrichGebert/ponytail` | no | - | - | - |
| ponytail-review | skills.txt `DietrichGebert/ponytail` | no | - | - | - |
| frontend-design | skills.txt `anthropics/skills` | no | - | - | - |
| caveman | skills.txt `juliusbrussee/caveman` | no | - | - | - |
| caveman-commit | skills.txt `juliusbrussee/caveman` | no | - | - | - |
| code-review | skills.txt `mattpocock/skills` | no | - | - | - |
| codebase-design | skills.txt `mattpocock/skills` | no | - | - | - |
| domain-modeling | skills.txt `mattpocock/skills` | no | - | - | - |
| grilling | skills.txt `mattpocock/skills@skills/productivity/grilling` | yes | upstream | - | `5beb35b040` |
| prototype | skills.txt `mattpocock/skills` | no | - | - | - |
| research | skills.txt `mattpocock/skills@skills/engineering/research` | yes | upstream | - | `5beb35b040` |
| write-hook | skills.txt `NormandErwan/claude-casebook` | no | - | - | - |
| write-skill | skills.txt `NormandErwan/claude-casebook@plugins/write-skill/skills/write-skill` | yes | upstream | - | `304e76b7a0` |

On claude.ai but not provided by this repo: brainstorming, find-skills.

The four mattpocock forks diverge from upstream by the dropped `disable-model-invocation:
true` line, plus a `version:` line on handoff and teach. handoff also replaces the OS temp
directory with a save location per surface (scratchpad, temp directory, or a download on
claude.ai).

craft-prompt: a straight copy of `neolabhq/context-engineering-kit`'s `prompt-engineering`,
renamed. Local divergences: a "Match structure to signal density" section; the persuasion
principles moved to `references/persuasion-principles.md` (500-line limit); no fixed context
window size; TaskCreate in place of TodoWrite. Reservation:
the only exact structural match found on skills.sh among several `prompt-engineering` variants,
not independently confirmed as the original author.

`addyosmani/agent-skills` is installed skill by skill, as its `docs/getting-started.md` asks
for hosts that route skills natively: no `using-agent-skills` router. `install-skills.sh` also
clones the pack's `references/` into `.claude/references`, which per-skill installs skip
(upstream #361). `interview-me` and `code-review-and-quality` overlap `grilling`, `code-review`
and `ponytail-review`: all five stay installed until the evaluation row of 2026-10-28 in
`RETROSPECTIVE.md` decides.

Pass history before 2026-10-24 lives in `git log -- SKILLS.web.md`.

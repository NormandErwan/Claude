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
| guide-decision | native | yes | 1.1.0 | `2ee6133ad3` | - |
| guide-purchase | native | yes | 1.1.0 | `8f10c06aa7` | - |
| handoff | fork of `mattpocock/skills@skills/productivity/handoff` | yes | 1.4.0 | `bdeade5eb4` | `5beb35b040` |
| search-first | fork of `affaan-m/ECC@skills/search-first` | yes | 1.0.2 | `1a31dd78a1` | `90606c8315` |
| teach | fork of `mattpocock/skills@skills/productivity/teach` | yes | 1.1.0 | `c6c8287ecf` | `5beb35b040` |
| token-codebase-exploration | native | no | - | - | - |
| token-file-ops | native | no | - | - | - |
| verify-sources | native | yes | 1.5.2 | `b0f58f410a` | - |
| write-documents | native | no | - | - | - |
| write-french | native | yes | 1.6.2 | `4819020894` | - |
| write-guide | native | no | - | - | - |
| api-and-interface-design | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| browser-testing-with-devtools | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| ci-cd-and-automation | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| constraint-driven-development | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| debugging-and-error-recovery | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| deprecation-and-migration | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| documentation-and-adrs | skills.txt `addyosmani/agent-skills` | no | - | - | - |
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
| accessibility-engineering | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| code-simplification | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| context-engineering | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| doubt-driven-development | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| using-agent-skills | skills.txt `addyosmani/agent-skills` | no | - | - | - |
| grilling | skills.txt `mattpocock/skills@skills/productivity/grilling` | yes | upstream | - | `7739eaed7f` |
| research | skills.txt `mattpocock/skills@skills/engineering/research` | yes | upstream | - | `7739eaed7f` |
| backlog | skills.txt `NormandErwan/claude-casebook` | no | - | - | - |
| find-cause | skills.txt `NormandErwan/claude-casebook@plugins/find-cause/skills/find-cause` | yes | upstream | - | `aa1d7bbaeb` |
| prevent-drift | skills.txt `NormandErwan/claude-casebook` | no | - | - | - |
| write-hook | skills.txt `NormandErwan/claude-casebook` | no | - | - | - |
| write-prompt | skills.txt `NormandErwan/claude-casebook@plugins/write-prompt/skills/write-prompt` | yes | upstream | - | `a8332acbc3` |
| write-skill | skills.txt `NormandErwan/claude-casebook@plugins/write-skill/skills/write-skill` | yes | upstream | - | `aad740ef1a` |

On claude.ai but not provided by this repo: brainstorming, find-skills.

The two mattpocock forks diverge from upstream by the dropped `disable-model-invocation:
true` line and an added `version:` line. handoff also replaces the OS temp
directory with a save location per surface (scratchpad, temp directory, or a download on
claude.ai).

write-prompt: was `craft-prompt` here, a fork of `neolabhq/context-engineering-kit`'s
`prompt-engineering` (GPL-3.0), up to 1.1.0. Rebuilt from MIT sources and evals (PR#110), then
moved to NormandErwan/claude-casebook as the `write-prompt` plugin at 2.0.0.

backlog: native here up to 2.0.0, then moved to NormandErwan/claude-casebook as the `backlog`
plugin at 0.1.1. Its defaults match 2.0.0; this repo's choices sit in `BACKLOG.md` `## Conventions`.

`addyosmani/agent-skills` is installed whole (`*` in `skills.txt`, owner 2026-11-19), its
`using-agent-skills` router included as a plain skill: `CLAUDE.md` neither injects nor names it,
as its `docs/getting-started.md` asks for hosts that route skills natively. A `*` repo's new
upstream skill installs without a row here: `check-skills.sh` cannot list it offline, add the
row when the session-start install reports a new count. `install-skills.sh` also
clones the pack's `references/` into `.claude/references`, which per-skill installs skip
(upstream #361).

Split, owner 2026-11-17: `addyosmani/agent-skills` for code, mattpocock for documentation work
(`grilling`, `research`, `handoff`, `teach`). Removed then: `caveman`, `caveman-commit`,
`ponytail-review`, mattpocock `code-review` (on trial: `git-workflow-and-versioning` and
`code-review-and-quality` replace them, evaluation row of 2026-11-17 in `RETROSPECTIVE.md`);
`ponytail-audit`, `codebase-design`, `domain-modeling`, `prototype`,
`improve-codebase-architecture`, `grill-with-docs` (never fired).

Pass history before 2026-10-24 lives in `git log -- SKILLS.web.md`.

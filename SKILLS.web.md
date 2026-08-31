# SKILLS.web.md

Commit manifest for skills `CLAUDE.web.md` references. Refreshed on every `CLAUDE.web.md` edit **or change to a skill listed here** (`CLAUDE.md` `Code / docs / commits`): recheck each commit, `SendUserFile` a zip of any skill that moved.

| Skill | Source | Commit |
|---|---|---|
| craft-prompt | local | `7aa7d4762a` |
| find-cause | local | `7aa7d4762a` |
| verify-sources | local | `5879b06cae` |
| guide-decision | local | `0aabdbb41d` |
| guide-purchase | local | `0aabdbb41d` |
| write-french | local | `34a05c4793` |
| grilling | `mattpocock/skills@grilling` | `85f83d3fde` |
| grill-with-docs | `mattpocock/skills@grill-with-docs` | `447ca70872` |
| research | `mattpocock/skills@research` | `321658273c` |
| handoff | `mattpocock/skills@handoff` | `d28dfdc39b` |
| using-agent-skills | `addyosmani/agent-skills@using-agent-skills` | `2ce8d47a16` |

Last full pass: 2026-08-30, every row. `mattpocock/skills` moved its skills under
category directories (`skills/productivity/`, `skills/engineering/`); those four
rows are unchanged at their new paths. The GitHub API returns 403 for that repo
through the proxy, so the pass used a public blobless clone. `addyosmani/agent-skills`
is the provenance of `CLAUDE.web.md`'s `Non-negotiables`, not an uploaded skill.

Moved at that pass: verify-sources, write-french (zips sent 2026-08-30).

2026-08-31: write-french moved again with its own edits (v1.4.0 -> v1.4.3), so its
zip is owed again; every other row unchanged. Not a full pass.

The `using-agent-skills` row was pinned to repo HEAD by mistake; like every other row it now pins
the commit that last touched the skill's own path. The hook's `--depth 1` clone cannot report that
commit - a blobless full clone is what this check uses.

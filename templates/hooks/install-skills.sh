#!/bin/bash
# Install the always-on external skills into <claude-dir>/skills, so they land
# in the Skill roster: the roster is built after SessionStart hooks run, while
# an `npx skills add` issued mid-session arrives too late and writes into the
# working directory rather than here.
#
# Cloning, not npx: 3 shallow clones take ~4.7s against ~50s for 14 npx runs,
# and git gets through proxies that block npm.
#
# $1 - .claude directory to install into
#
# Prints nothing: the caller's other hook step owns stdout, and a stray line
# there breaks the SessionStart envelope.
set -uo pipefail

TARGET="${1:?usage: install-skills.sh <claude-dir>}/skills"

# <repo>|<skill>,<skill>,...  Topic-gated skills stay out; see CLAUDE.md Every turn 1.
REPOS="DietrichGebert/ponytail|ponytail-audit,ponytail-review
juliusbrussee/caveman|caveman,caveman-commit
mattpocock/skills|codebase-design,domain-modeling,grill-with-docs,grilling,handoff,improve-codebase-architecture,prototype,research,resolving-merge-conflicts,teach"

STAGING=$(mktemp -d)
trap 'rm -rf "$STAGING"' EXIT
mkdir -p "$TARGET"

while IFS='|' read -r repo wanted; do
  [ -z "$repo" ] && continue
  clone="$STAGING/${repo##*/}"
  git clone --depth 1 --filter=blob:none --quiet "https://github.com/$repo.git" "$clone" 2>/dev/null || continue
  IFS=',' read -ra names <<< "$wanted"
  for name in "${names[@]}"; do
    # Layouts differ per repo - skills/<name> here, skills/<category>/<name>
    # there - so locate the directory by name instead of hard-coding a path.
    src=$(find "$clone" -type d -name "$name" -not -path '*/.*' \
            -exec test -f '{}/SKILL.md' \; -print -quit)
    if [ -n "$src" ]; then
      rm -rf "${TARGET:?}/$name"
      cp -r "$src" "$TARGET/$name"
    fi
  done
done <<< "$REPOS"

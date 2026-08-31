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
# Prints nothing on stdout: the injector step owns it, and a stray line there
# breaks the SessionStart envelope. Problems go to skills/.install-status,
# which inject-agent-skills.sh reads and surfaces - a silent failure would
# leave CLAUDE.md asserting skills that are not there.
set -uo pipefail

TARGET="${1:?usage: install-skills.sh <claude-dir>}/skills"
MANIFEST="$TARGET/.installed-by-hook"
STATUS="$TARGET/.install-status"

# <repo>|<skill>,<skill>,...  Topic-gated skills stay out; see CLAUDE.md Every turn 1.
REPOS="DietrichGebert/ponytail|ponytail-audit,ponytail-review
juliusbrussee/caveman|caveman,caveman-commit
mattpocock/skills|codebase-design,domain-modeling,grill-with-docs,grilling,handoff,improve-codebase-architecture,prototype,research,resolving-merge-conflicts,teach"

STAGING=$(mktemp -d)
trap 'rm -rf "$STAGING"' EXIT
mkdir -p "$TARGET"

# Drop only what a previous run installed, so a name dropped from REPOS stops
# showing up. Native skills are never in the manifest, so they survive.
if [ -f "$MANIFEST" ]; then
  while read -r name; do
    [ -n "$name" ] && rm -rf "${TARGET:?}/$name"
  done < "$MANIFEST"
fi
: > "$MANIFEST"
: > "$STATUS"

while IFS='|' read -r repo wanted; do
  [ -z "$repo" ] && continue
  clone="$STAGING/${repo##*/}"
  if ! git clone --depth 1 --quiet "https://github.com/$repo.git" "$clone" 2>/dev/null; then
    echo "clone failed, skills missing this session: $repo ($wanted)" >> "$STATUS"
    continue
  fi
  IFS=',' read -ra names <<< "$wanted"
  for name in "${names[@]}"; do
    # Anything still standing after the manifest sweep is a native skill.
    # It owns the name; never overwrite it.
    if [ -e "$TARGET/$name" ]; then
      echo "native skill owns this name, external copy not installed: $name" >> "$STATUS"
      continue
    fi
    # Prune dot-directories by name. Matching '*/.*' against the path would
    # prune everything whenever TMPDIR itself sits under a dot-directory.
    src=$(find "$clone" -name '.*' -prune -o -type d -name "$name" \
            -exec test -f '{}/SKILL.md' \; -print -quit)
    if [ -n "$src" ]; then
      cp -r "$src" "$TARGET/$name" && echo "$name" >> "$MANIFEST"
    else
      echo "no directory with a SKILL.md named '$name' in $repo" >> "$STATUS"
    fi
  done
done <<< "$REPOS"

[ -s "$STATUS" ] || rm -f "$STATUS"

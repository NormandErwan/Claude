#!/bin/bash
# Populate <claude-dir>/skills so the Skill roster sees everything: the roster
# is built after SessionStart hooks run, while an `npx skills add` issued
# mid-session arrives too late and writes into the working directory.
#
# Cloning, not npx: 3 shallow clones take ~3s against ~50s for 14 npx runs, and
# git gets through proxies that block npm.
#
# $1 - .claude directory to populate
# $2 - optional directory of native skills to sync in first
#
# Both kinds are marked, and every run prunes what it marked before rebuilding.
# So a skill deleted upstream disappears here too, while a directory the user
# put in .claude/skills themselves carries no marker and is never touched.
#
# Prints nothing on stdout: the injector step owns it, and SessionStart adds
# whatever lands there to the session context. Problems go instead to
# skills/.install-status, which inject-agent-skills.sh reads and surfaces - a
# silent failure would leave CLAUDE.md asserting skills that are not there.
set -uo pipefail

TARGET="${1:?usage: install-skills.sh <claude-dir> [native-skills-dir]}/skills"
NATIVE="${2:-}"
STATUS="$TARGET/.install-status"
MARK_EXT=".hook-installed"
MARK_NAT=".hook-synced"

# <repo>|<skill>,<skill>,...  Topic-gated skills stay out; see CLAUDE.md Every turn 1.
REPOS="DietrichGebert/ponytail|ponytail-audit,ponytail-review
juliusbrussee/caveman|caveman,caveman-commit
mattpocock/skills|codebase-design,domain-modeling,grill-with-docs,grilling,handoff,improve-codebase-architecture,prototype,research,resolving-merge-conflicts,teach"

EXPECTED=$(printf '%s\n' "$REPOS" | awk -F'|' 'NF{print $2}' | tr ',' '\n' | grep -c .)

mkdir -p "$TARGET"
# Clear before the gate: a skipped run reports nothing, so last session's
# problems must not be re-injected as this session's.
: > "$STATUS"

# The hook also fires on resume, clear and compact. Re-cloning then is waste,
# but a half-finished install must still be completed - count the markers
# rather than trusting that any one of them means the job is done.
SOURCE=startup
if [ ! -t 0 ]; then
  PAYLOAD=$(timeout 1 cat 2>/dev/null || true)
  if command -v jq >/dev/null 2>&1 && FOUND=$(printf '%s' "$PAYLOAD" | jq -re '.source' 2>/dev/null); then
    SOURCE="$FOUND"
  else
    FOUND=$(printf '%s' "$PAYLOAD" | grep -o '"source"[[:space:]]*:[[:space:]]*"[^"]*"' | tail -1 | sed 's/.*"\([^"]*\)"$/\1/')
    [ -n "$FOUND" ] && SOURCE="$FOUND"
  fi
fi
HAVE=$(find "$TARGET" -maxdepth 2 -name "$MARK_EXT" 2>/dev/null | wc -l)
if [ "$SOURCE" != startup ] && [ "$HAVE" -ge "$EXPECTED" ]; then
  rm -f "$STATUS"
  exit 0
fi

# Serialise. Two sessions opening at once would otherwise interleave the prune
# and the copies below - including the native sync, which shares the tree.
exec 9>"$TARGET/.install-lock"
flock 9 2>/dev/null || true

STAGING=$(mktemp -d)
trap 'rm -rf "$STAGING"' EXIT

# Prune first, so nothing below can merge into a directory that is about to go.
for d in "$TARGET"/*/; do
  [ -d "$d" ] || continue
  { [ -f "$d$MARK_EXT" ] || [ -f "$d$MARK_NAT" ]; } && rm -rf "$d"
done

# Stage, mark, then move into place. A copy interrupted partway leaves a
# half-written tree in the staging directory, never an unmarked stump under
# $TARGET that every later run would mistake for a skill the user owns.
place() {  # $1 src  $2 name  $3 marker
  local stage="$STAGING/place.$$"
  rm -rf "$stage"
  cp -r "$1" "$stage" 2>/dev/null || return 1
  touch "$stage/$3" || return 1
  mv "$stage" "$TARGET/$2" || return 1
}

if [ -n "$NATIVE" ] && [ -d "$NATIVE" ]; then
  for d in "$NATIVE"/*/; do
    [ -d "$d" ] || continue
    name=$(basename "$d")
    place "$d" "$name" "$MARK_NAT" || echo "native skill failed to sync: $name" >> "$STATUS"
  done
fi

while IFS='|' read -r repo wanted; do
  [ -z "$repo" ] && continue
  clone="$STAGING/${repo##*/}"
  if ! git clone --depth 1 --quiet "https://github.com/$repo.git" "$clone" 2>/dev/null; then
    echo "clone failed, skills missing this session: $repo ($wanted)" >> "$STATUS"
    continue
  fi
  IFS=',' read -ra names <<< "$wanted"
  for name in "${names[@]}"; do
    # Anything standing after the prune carries no marker, so the user put it
    # there. It owns the name.
    if [ -e "$TARGET/$name" ]; then
      echo "a directory you own already holds this name, external copy not installed: $name" >> "$STATUS"
      continue
    fi
    # Prune dot-directories by name. Matching '*/.*' against the path would
    # prune everything whenever TMPDIR itself sits under a dot-directory.
    src=$(find "$clone" -name '.*' -prune -o -type d -name "$name" \
            -exec test -f '{}/SKILL.md' \; -print -quit)
    if [ -z "$src" ]; then
      echo "no directory with a SKILL.md named '$name' in $repo" >> "$STATUS"
    elif ! place "$src" "$name" "$MARK_EXT"; then
      echo "copy failed, skill not installed: $name" >> "$STATUS"
    fi
  done
done <<< "$REPOS"

[ -s "$STATUS" ] || rm -f "$STATUS"

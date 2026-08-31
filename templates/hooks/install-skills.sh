#!/bin/bash
# Populate <claude-dir>/skills so the Skill roster sees everything: the roster
# is built after SessionStart hooks run, while an `npx skills add` issued
# mid-session arrives too late and writes into the working directory.
#
# $1 - .claude directory to populate
# $2 - optional directory of native skills to sync in first
#
# Both kinds are marked, and a run prunes only what it marked. A directory the
# user put here carries no marker and is never touched.
#
# Two ordering rules the design rests on:
#   - Clone before pruning. A transient network failure must not delete a
#     working install to replace it with nothing.
#   - Stage inside $TARGET. `mv` is then a same-directory rename, so a
#     published directory always carries its marker.
#
# Prints nothing on stdout: the injector step owns it, and SessionStart adds
# whatever lands there to the session context. Problems go to
# skills/.install-status, which inject-agent-skills.sh reads and surfaces.
set -uo pipefail

TARGET="${1:?usage: install-skills.sh <claude-dir> [native-skills-dir]}/skills"
NATIVE="${2:-}"
STATUS="$TARGET/.install-status"
STAMP="$TARGET/.install-complete"
MARK_EXT=".hook-installed"
MARK_NAT=".hook-synced"

# <repo>|<skill>,<skill>,...  Topic-gated skills stay out; see CLAUDE.md Every turn 1.
REPOS="DietrichGebert/ponytail|ponytail-audit,ponytail-review
juliusbrussee/caveman|caveman,caveman-commit
mattpocock/skills|codebase-design,domain-modeling,grill-with-docs,grilling,handoff,improve-codebase-architecture,prototype,research,resolving-merge-conflicts,teach"

mkdir -p "$TARGET" 2>/dev/null
: > "$STATUS" 2>/dev/null

note() { echo "$*" >> "$STATUS" 2>/dev/null; }

# The hook also fires on resume, clear and compact. A stamp, not a count,
# decides: a name that is legitimately unavailable would keep a count short
# forever and re-clone on every wake.
SOURCE=startup
if [ ! -t 0 ]; then
  PAYLOAD=$(timeout 1 cat 2>/dev/null || true)
  if command -v jq >/dev/null 2>&1 && FOUND=$(printf '%s' "$PAYLOAD" | jq -re '.source' 2>/dev/null); then
    SOURCE="$FOUND"
  elif [ "$(printf '%s' "$PAYLOAD" | grep -o '"source"[[:space:]]*:' | wc -l)" = 1 ]; then
    # Only one candidate, so no top-level/nested ambiguity to get wrong.
    SOURCE=$(printf '%s' "$PAYLOAD" | grep -o '"source"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"\([^"]*\)"$/\1/')
  fi
fi
if [ "$SOURCE" != startup ] && [ -f "$STAMP" ]; then
  rm -f "$STATUS"
  exit 0
fi

LOCKDIR="$TARGET/.install-lock.d"
[ -n "${LOCKDIR:-}" ] || LOCKDIR=""
if command -v flock >/dev/null 2>&1; then
  exec 9>"$TARGET/.install-lock"
  flock 9 2>/dev/null || true
else
  # No flock(1) - macOS. A directory is the portable mutex; give up after 60s
  # rather than deadlock on one a killed run left behind.
  for _ in $(seq 1 300); do mkdir "$LOCKDIR" 2>/dev/null && break; sleep 0.2; done
fi

# From here the tree is about to change, so nothing may still claim it is
# complete. Restored at the end, only if every repo answered.
rm -f "$STAMP" 2>/dev/null

STAGE_ROOT="$TARGET/.staging.$$"
CLONES=$(mktemp -d 2>/dev/null) || { note "no temp directory available, nothing installed"; exit 0; }
trap 'rm -rf "$CLONES" "$STAGE_ROOT" "$LOCKDIR"' EXIT
# Collect what earlier runs died holding.
rm -rf "$TARGET"/.staging.* "$TARGET"/.pruning.* 2>/dev/null
mkdir -p "$STAGE_ROOT" 2>/dev/null || { note "cannot write to $TARGET, nothing installed"; exit 0; }

# Publish by same-directory rename. Refuse an occupied name outright: `mv` onto
# an existing directory moves *into* it, which silently buries the copy - and
# follows a symlink clean out of this tree.
place() {  # $1 src  $2 name  $3 marker
  local stage="$STAGE_ROOT/$2"
  [ ! -e "$TARGET/$2" ] || return 2
  rm -rf "$stage"
  cp -r "$1" "$stage" 2>/dev/null || return 1
  touch "$stage/$3" 2>/dev/null || return 1
  mv "$stage" "$TARGET/$2" 2>/dev/null || return 1
}

# 1. Resolve everything first. Nothing is deleted until replacements are in hand.
RESOLVED=""   # name<TAB>srcpath
KEEP=""       # names whose repo did not answer: their copy on disk is the best we have
FAILED=0
while IFS='|' read -r repo wanted; do
  [ -z "$repo" ] && continue
  clone="$CLONES/${repo##*/}"
  if ! git clone --depth 1 --quiet "https://github.com/$repo.git" "$clone" 2>/dev/null; then
    note "clone failed, these skills keep whatever is already on disk: $repo ($wanted)"
    KEEP="$KEEP $(printf '%s' "$wanted" | tr ',' ' ')"
    FAILED=1
    continue
  fi
  IFS=',' read -ra names <<< "$wanted"
  for name in "${names[@]}"; do
    src=$(find "$clone" -name '.*' -prune -o -type d -name "$name" \
            -exec test -f '{}/SKILL.md' \; -print -quit)
    if [ -n "$src" ]; then
      RESOLVED="$RESOLVED$name	$src
"
    else
      note "no directory with a SKILL.md named '$name' in $repo"
    fi
  done
done <<< "$REPOS"

NATIVE_NAMES=""
if [ -n "$NATIVE" ] && [ -d "$NATIVE" ]; then
  for d in "$NATIVE"/*/; do
    [ -d "$d" ] && NATIVE_NAMES="$NATIVE_NAMES $(basename "$d")"
  done
fi

has() { case " $2 " in *" $1 "*) return 0;; esac; return 1; }

# 2. Prune. Rename out of the way first: an interrupted `rm -rf` can unlink the
# marker before the rest of the tree, leaving a stump nothing recognises.
for d in "$TARGET"/*/; do
  [ -d "$d" ] || continue
  name=$(basename "$d")
  if [ -f "$d$MARK_NAT" ]; then
    # Same rule as a repo that did not answer: with no source to re-place them
    # from, the copies on disk are the best there is.
    [ -n "$NATIVE_NAMES" ] || continue
  elif [ -f "$d$MARK_EXT" ]; then
    has "$name" "$KEEP" && continue     # its repo did not answer - keep the copy
  else
    continue                            # no marker: the user owns it
  fi
  mv "$d" "$STAGE_ROOT/.pruned" 2>/dev/null && rm -rf "$STAGE_ROOT/.pruned"
done

# 3. Publish.
NAT_OK=0; NAT_TOTAL=0
for name in $NATIVE_NAMES; do
  NAT_TOTAL=$((NAT_TOTAL + 1))
  place "$NATIVE/$name" "$name" "$MARK_NAT"
  case $? in
    0) NAT_OK=$((NAT_OK + 1)) ;;
    2) note "a directory already holds this name, native skill not synced: $name" ;;
    *) note "copy failed, native skill not synced: $name" ;;
  esac
done
[ "$NAT_OK" = "$NAT_TOTAL" ] || note "native skills synced: $NAT_OK of $NAT_TOTAL"

while IFS=$'\t' read -r name src; do
  [ -z "$name" ] && continue
  place "$src" "$name" "$MARK_EXT"
  case $? in
    0) ;;
    2) note "a directory already holds this name, external skill not installed: $name" ;;
    *) note "copy failed, external skill not installed: $name" ;;
  esac
done <<< "$RESOLVED"

# 4. A stamp only when every repo answered, so a network failure retries next
# wake while a genuinely absent skill stops re-cloning forever.
if [ "$FAILED" = 0 ]; then touch "$STAMP" 2>/dev/null; else rm -f "$STAMP" 2>/dev/null; fi
[ -s "$STATUS" ] || rm -f "$STATUS" 2>/dev/null

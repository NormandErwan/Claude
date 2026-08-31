#!/bin/bash
# Install the always-on external skills into <claude-dir>/skills, so they land
# in the Skill roster: the roster is built after SessionStart hooks run, while
# an `npx skills add` issued mid-session arrives too late and writes into the
# working directory rather than here.
#
# Cloning, not npx: 3 shallow clones take ~3s against ~50s for 14 npx runs, and
# git gets through proxies that block npm. The hook pair does 4 clones in this
# repo and 5 in a consumer repo, which also clones the skills repo first.
#
# $1 - .claude directory to install into
#
# Prints nothing on stdout: the injector step owns it, and SessionStart adds
# whatever lands there to the session context. Problems go instead to
# skills/.install-status, which inject-agent-skills.sh reads and surfaces - a
# silent failure would leave CLAUDE.md asserting skills that are not there.
set -uo pipefail

TARGET="${1:?usage: install-skills.sh <claude-dir>}/skills"
STATUS="$TARGET/.install-status"
MARKER=".hook-installed"

# <repo>|<skill>,<skill>,...  Topic-gated skills stay out; see CLAUDE.md Every turn 1.
REPOS="DietrichGebert/ponytail|ponytail-audit,ponytail-review
juliusbrussee/caveman|caveman,caveman-commit
mattpocock/skills|codebase-design,domain-modeling,grill-with-docs,grilling,handoff,improve-codebase-architecture,prototype,research,resolving-merge-conflicts,teach"

mkdir -p "$TARGET"

# The hook also fires on resume, clear and compact. Re-cloning then is waste,
# but skipping blindly would leave a resumed session in a fresh container with
# no skills at all - so skip only when a previous run in this container left
# something behind. `source` comes from the hook payload on stdin; grep, not
# jq, because this script must work without it.
SOURCE=startup
if [ ! -t 0 ]; then
  PAYLOAD=$(timeout 1 cat 2>/dev/null || true)
  FOUND=$(printf '%s' "$PAYLOAD" | grep -o '"source"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"\([^"]*\)"$/\1/')
  [ -n "$FOUND" ] && SOURCE="$FOUND"
fi
if [ "$SOURCE" != startup ] && [ -n "$(find "$TARGET" -maxdepth 2 -name "$MARKER" -print -quit 2>/dev/null)" ]; then
  exit 0
fi

# Serialise. Two sessions opening at once would otherwise interleave the prune
# and the copy below.
exec 9>"$TARGET/.install-lock"
flock 9 2>/dev/null || true

STAGING=$(mktemp -d)
trap 'rm -rf "$STAGING"' EXIT
: > "$STATUS"

# Drop only what this hook installed. The marker lives inside each installed
# directory rather than in one central manifest: there is nothing to truncate,
# so a killed or concurrent run cannot leave state that makes every skill look
# native and wedges the install for good.
for d in "$TARGET"/*/; do
  [ -d "$d" ] && [ -f "$d$MARKER" ] && rm -rf "$d"
done

while IFS='|' read -r repo wanted; do
  [ -z "$repo" ] && continue
  clone="$STAGING/${repo##*/}"
  if ! git clone --depth 1 --quiet "https://github.com/$repo.git" "$clone" 2>/dev/null; then
    echo "clone failed, skills missing this session: $repo ($wanted)" >> "$STATUS"
    continue
  fi
  IFS=',' read -ra names <<< "$wanted"
  for name in "${names[@]}"; do
    # Anything still standing after the sweep carries no marker, so it is a
    # native skill. It owns the name; never overwrite it.
    if [ -e "$TARGET/$name" ]; then
      echo "native skill owns this name, external copy not installed: $name" >> "$STATUS"
      continue
    fi
    # Prune dot-directories by name. Matching '*/.*' against the path would
    # prune everything whenever TMPDIR itself sits under a dot-directory.
    src=$(find "$clone" -name '.*' -prune -o -type d -name "$name" \
            -exec test -f '{}/SKILL.md' \; -print -quit)
    if [ -n "$src" ]; then
      cp -r "$src" "$TARGET/$name" && touch "$TARGET/$name/$MARKER"
    else
      echo "no directory with a SKILL.md named '$name' in $repo" >> "$STATUS"
    fi
  done
done <<< "$REPOS"

[ -s "$STATUS" ] || rm -f "$STATUS"

#!/bin/bash
# Check each fork in SKILLS.web.md against its upstream: last commit on the
# upstream path vs the pinned `Upstream commit`. Catches upstream moves that no
# local edit would trigger a recheck for. This repo only.
#
# $1 - repo root holding SKILLS.web.md
#
# Prints one line per fork that moved or could not be checked, or one line if
# all are current. No `set -e`: a blocked clone must not abort startup.
set -uo pipefail

ROOT="${1:?usage: check-skill-forks.sh <repo-root>}"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

# Rows: | name | fork of `owner/repo@path` | sent version | sent tree | `upstream` |
grep -E '^\| [^|]+ \| fork of `' "$ROOT/SKILLS.web.md" |
  sed -E 's/^\| ([^ ]+) \| fork of `([^@`]+)@([^`]+)` \| [^|]+ \| [^|]+ \| `([0-9a-f]+)` \|.*/\1 \2 \3 \4/' >"$WORK/forks"

CAP=()
command -v timeout >/dev/null 2>&1 && CAP=(timeout 20)
# Commits and trees only: enough for `git log -- path`, a fraction of a full clone.
for repo in $(cut -d' ' -f2 "$WORK/forks" | sort -u); do
  ${CAP[@]+"${CAP[@]}"} git clone -q --bare --filter=blob:none "https://github.com/$repo.git" "$WORK/${repo//\//_}" 2>/dev/null &
done
wait

total=0
report=()
while read -r name repo path pin; do
  total=$((total + 1))
  dir="$WORK/${repo//\//_}"
  # A clone cut by the timeout can leave a dir with no HEAD.
  if ! git -C "$dir" rev-parse -q --verify HEAD >/dev/null 2>&1; then
    report+=("$name: clone of $repo failed, not checked.")
    continue
  fi
  # Pin = last commit checked, not last commit on the path: moved means a
  # commit on the path since the pin.
  if ! git -C "$dir" cat-file -e "$pin^{commit}" 2>/dev/null; then
    report+=("$name: pinned commit $pin not found in $repo.")
  elif [ -z "$(git -C "$dir" ls-tree HEAD -- "$path")" ]; then
    report+=("$name: $path not found in $repo HEAD - upstream may have moved it.")
  else
    last=$(git -C "$dir" log -1 --format=%h --abbrev=10 "$pin..HEAD" -- "$path")
    [ -n "$last" ] && report+=("$name: upstream changed $path since $pin (latest $last) - update it per SKILLS.web.md.")
  fi
done <"$WORK/forks"

if [ ${#report[@]} -eq 0 ]; then
  echo "Skill forks: $total checked against upstream, all current."
else
  echo "Skill forks: ${#report[@]} of $total need attention."
  printf '%s\n' "${report[@]}"
fi

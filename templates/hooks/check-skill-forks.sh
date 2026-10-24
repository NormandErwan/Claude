#!/bin/bash
# Check each SKILLS.md row tracked upstream against its upstream: last commit on
# the upstream path vs the pinned `Upstream commit`. Catches upstream moves that
# no local edit would trigger a recheck for. This repo only, run at session start.
#
# Tracked rows: forks (Source `fork of `repo@path``), and uploaded skills.txt
# skills (Source `skills.txt `repo@path``, Web yes) - their zip is built from the
# pin, so a move means re-zip. .claude/hooks/check-skills.sh makes sure every
# uploaded skills.txt row carries `repo@path` and a pin.
#
# $1 - repo root holding SKILLS.md
#
# Prints one line per row that moved or could not be checked, or one line if
# all are current. No `set -e`: a blocked clone must not abort startup.
set -uo pipefail

ROOT="${1:?usage: check-skill-forks.sh <repo-root>}"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

# Positional columns: | Skill | Source | Web | Sent version | Sent tree | Upstream commit |
# ($2..$7). Layout guarded by check-skills.sh check 0: change both scripts together.
# Out: name repo path pin
awk -F'|' '$3 ~ /fork of `/ || ($3 ~ /skills\.txt `[^`]*@/ && $4 ~ /yes/) {
    gsub(/ /, "", $2); split($3, src, "`"); split(src[2], rp, "@"); gsub(/[ `]/, "", $7)
    print $2, rp[1], rp[2], $7 }' "$ROOT/SKILLS.md" >"$WORK/forks"

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
    [ -n "$last" ] && report+=("$name: upstream changed $path since $pin (latest $last) - update it per SKILLS.md.")
  fi
done <"$WORK/forks"

if [ ${#report[@]} -eq 0 ]; then
  echo "Skill forks: $total checked against upstream, all current."
else
  echo "Skill forks: ${#report[@]} of $total need attention."
  printf '%s\n' "${report[@]}"
fi

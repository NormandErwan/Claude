#!/bin/bash
# SessionStart hook: install skills.txt skills into <claude-dir>/skills before
# the Skill roster freezes, plus this repo's own skills/ (forks included).
# Reads this repo's skills.txt and a consumer's $CLAUDE_PROJECT_DIR/skills.txt.
# One npx call per upstream repo, all in parallel: 4 calls take ~4s, 14
# one-skill calls took ~31s. Per-call cap stays under the hook timeout.
#
# $1 - .claude directory to install into
#
# Prints one status line; SessionStart stdout goes to the session context.
# No `set -e`: a blocked install must degrade the session, not abort startup.
set -uo pipefail

TARGET_DIR="${1:?usage: install-skills.sh <claude-dir>}"
REPO_DIR="$(dirname "$0")/../.."
LOCAL_SKILLS="$REPO_DIR/skills"

# Merge both manifests. This repo is its own consumer: same file, read once.
MANIFEST=$(mktemp)
cat "$REPO_DIR/skills.txt" >"$MANIFEST" 2>/dev/null
CONSUMER="${CLAUDE_PROJECT_DIR:+$CLAUDE_PROJECT_DIR/skills.txt}"
if [ -f "$CONSUMER" ] && ! [ "$CONSUMER" -ef "$REPO_DIR/skills.txt" ]; then
  # read drops a last line with no newline.
  printf '\n' >>"$MANIFEST"
  cat "$CONSUMER" >>"$MANIFEST"
  printf '\n' >>"$MANIFEST"
fi

# No `timeout` on stock macOS: run uncapped there.
CAP=()
command -v timeout >/dev/null 2>&1 && CAP=(timeout 25)

# npx writes skills-lock.json to its cwd: stage aside, copy skills only.
STAGING=$(mktemp -d)
trap 'rm -rf "$STAGING" "$MANIFEST"' EXIT

expected=()
i=0
while read -r repo skills; do
  case "$repo" in '' | '#'*) continue ;; esac
  # No skill names would install the whole repo, over the forks.
  [ -n "$skills" ] || continue
  args=()
  for s in $skills; do args+=(-s "$s"); expected+=("$s"); done
  mkdir -p "$STAGING/$i"
  echo "$repo $skills" >"$STAGING/$i.call"
  # Output kept: a failure must show its cause (one cache fault once read as many).
  (cd "$STAGING/$i" && ${CAP[@]+"${CAP[@]}"} npx -y skills add "$repo" "${args[@]}" -a claude-code -y </dev/null >"$STAGING/$i.log" 2>&1
    echo $? >"$STAGING/$i.rc") &
  i=$((i + 1))
done <"$MANIFEST"
# agent-skills skills link ../../references/*.md; npx copies skill dirs only
# (upstream #361). Clone the pack's references/ beside skills/.
(${CAP[@]+"${CAP[@]}"} git clone --depth 1 --quiet https://github.com/addyosmani/agent-skills.git "$STAGING/refs" </dev/null >/dev/null 2>&1) &
wait
if [ -d "$STAGING/refs/references" ]; then
  rm -rf "$TARGET_DIR/references"
  cp -r "$STAGING/refs/references" "$TARGET_DIR/references"
  refs=ok
fi

mkdir -p "$TARGET_DIR/skills"
for d in "$STAGING"/*/.claude/skills; do
  [ -d "$d" ] && cp -r "$d/." "$TARGET_DIR/skills/"
done
# Last, so a fork wins over an upstream copy of the same name.
[ -d "$LOCAL_SKILLS" ] && cp -r "$LOCAL_SKILLS/." "$TARGET_DIR/skills/"

# Judge by what this run staged, not exit codes (npx can exit 0 having
# installed nothing) nor the target (a previous session's copy hides a failure).
missing=()
for s in ${expected[@]+"${expected[@]}"}; do
  ls "$STAGING"/*/.claude/skills/"$s"/SKILL.md >/dev/null 2>&1 || missing+=("$s")
done

# Upstream may add the flag later: hidden skills must be named, the agent cannot see them.
hidden=()
for s in ${expected[@]+"${expected[@]}"}; do
  grep -qs '^disable-model-invocation: *true' "$STAGING"/*/.claude/skills/"$s"/SKILL.md && hidden+=("$s")
done

if [ ${#missing[@]} -eq 0 ]; then
  echo "skills.txt: ${#expected[@]} skills installed."
else
  echo "skills.txt: ${#missing[@]} of ${#expected[@]} skills failed to install: ${missing[*]}. See CLAUDE.md Bootstrap 3."
  # Per failed call: exit code + first error-looking line, else its last line.
  for c in "$STAGING"/*.call; do
    n=${c%.call}
    read -r crepo cskills <"$c"
    for s in $cskills; do
      [ -f "$n/.claude/skills/$s/SKILL.md" ] && continue
      rc=$(cat "$n.rc" 2>/dev/null || echo "?")
      # npx redraws a spinner: strip escapes, split on redraws, keep real lines.
      clean=$(sed 's/\x1b\[[0-9;?]*[a-zA-Z]//g; s/\r/\n/g' "$n.log" 2>/dev/null | grep -av '^[[:space:]|]*$')
      if [ "$rc" = 124 ]; then
        line="timed out after ${CAP[1]:-?}s"
      else
        line=$(grep -aiE -m1 'error|fail|ENOTFOUND|EAI_AGAIN|ECONN|no valid skills' <<<"$clean")
        [ -n "$line" ] || line=$(tail -1 <<<"$clean")
      fi
      echo "Failed call: $crepo (exit $rc): ${line:-no output}" | cut -c1-300
      break
    done
  done
fi
[ -n "${refs:-}" ] || echo "agent-skills references/ not cloned: skills' ../../references links are dead this session."
[ ${#hidden[@]} -eq 0 ] || echo "skills.txt: hidden by disable-model-invocation: ${hidden[*]} - fork per CLAUDE.md Bootstrap 2."

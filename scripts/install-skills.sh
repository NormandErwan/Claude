#!/usr/bin/env bash
# Install every skill in this repo into the local Claude Code skills
# directory. This repo is the source of truth: each skill is always
# overwritten with the repo's version.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target_root="$HOME/.claude/skills"

mkdir -p "$target_root"

while IFS= read -r -d '' skill_md; do
  skill_dir="$(dirname "$skill_md")"
  name="$(basename "$skill_dir")"
  target="$target_root/$name"

  rm -rf "$target"
  cp -r "$skill_dir" "$target"
  echo "installed: $name"
done < <(find "$repo_root/skills" -mindepth 1 -iname SKILL.md -print0 | sort -z)

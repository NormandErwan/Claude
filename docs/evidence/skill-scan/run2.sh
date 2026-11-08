#!/bin/bash
# Two-turn run: run.sh for turn 1, then --resume the same session for turn 2.
# usage: run2.sh <arm> <case-id> <prompt-1> <prompt-2>
S=${ABC_DIR:?}; HERE=$(cd "$(dirname "$0")" && pwd)
"$HERE/run.sh" "$1" "$2" "$3"
R=$S/runs/$2-$1
SID=$(python3 -I -c 'import json,sys
for l in open(sys.argv[1]):
    e=json.loads(l)
    if e.get("type")=="system" and e.get("subtype")=="init": print(e["session_id"]); break' "$R/transcript.jsonl")
cd "$R/w" && env -u CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD -u CLAUDE_ADDITIONAL_DIRECTORIES -u CLAUDECODE -u CLAUDE_CODE_SESSION_ID -u CLAUDE_CODE_REMOTE_SESSION_ID \
  CLAUDE_CONFIG_DIR=$R/cfg timeout 900 claude -p "$4" --resume "$SID" --model claude-sonnet-5-5 \
  --output-format stream-json --verbose --permission-mode acceptEdits \
  --allowedTools Read Write Edit Glob Grep Skill Bash \
  < /dev/null > "$R/transcript2.jsonl" 2> "$R/stderr2.txt"
echo "$1 $2 turn2 exit=$?"

#!/bin/bash
# usage: run.sh <case-id>[-r<n>]   (prompt read from prompts.tsv)
S=${DN_DIR:?set DN_DIR to the work dir built by setup.sh}
ID=$1; CASE=${ID%%-r*}; HERE=$(cd "$(dirname "$0")" && pwd)
PROMPT=$(awk -F'\t' -v c="$CASE" '$1==c{print $2}' "$HERE/prompts.tsv")
R=$S/runs/$ID; rm -rf $R; mkdir -p $R/tmp $R/cfg
cp -r $S/template $R/w
[ -f "$HERE/cases/$CASE.sh" ] && (cd $R/w && bash "$HERE/cases/$CASE.sh")
cd $R/w && git init -q -b main && git add -A && git -c user.name=t -c user.email=t@t commit -qm init
printf '{"projects":{"%s":{"hasTrustDialogAccepted":true}}}' "$R/w" > $R/cfg/.claude.json
env -u CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD -u CLAUDE_ADDITIONAL_DIRECTORIES -u CLAUDECODE -u CLAUDE_CODE_SESSION_ID -u CLAUDE_CODE_REMOTE_SESSION_ID \
  TMPDIR=$R/tmp CLAUDE_CONFIG_DIR=$R/cfg timeout 900 claude -p "$PROMPT" --model claude-sonnet-5-5 \
  --output-format stream-json --verbose --permission-mode acceptEdits \
  --allowedTools Read Write Edit Glob Grep Skill Bash \
  < /dev/null > $R/transcript.jsonl 2> $R/stderr.txt
echo "$ID exit=$?"

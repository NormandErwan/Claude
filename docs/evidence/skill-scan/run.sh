#!/bin/bash
# usage: run.sh <arm> <case-id> <prompt>
S=${ABC_DIR:?set ABC_DIR to the work dir built by setup.sh}
ARM=$1; ID=$2; PROMPT=$3
R=$S/runs/$ID-$ARM; rm -rf $R; mkdir -p $R
cp -r $S/template $R/w; cp $S/arms/$ARM.md $R/w/.claude/CLAUDE.md
git init -q --bare $R/origin.git
cd $R/w && git init -q -b main && git add -A && git -c user.name=t -c user.email=t@t commit -qm init && git remote add origin $R/origin.git && git push -q origin main 2>/dev/null
mkdir -p $R/cfg
printf '{"projects":{"%s":{"hasTrustDialogAccepted":true}}}' "$R/w" > $R/cfg/.claude.json
env -u CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD -u CLAUDE_ADDITIONAL_DIRECTORIES -u CLAUDECODE -u CLAUDE_CODE_SESSION_ID -u CLAUDE_CODE_REMOTE_SESSION_ID \
  CLAUDE_CONFIG_DIR=$R/cfg timeout 900 claude -p "$PROMPT" --model claude-sonnet-5-5 \
  --output-format stream-json --verbose --permission-mode acceptEdits \
  --allowedTools Read Write Edit Glob Grep Skill Bash \
  < /dev/null > $R/transcript.jsonl 2> $R/stderr.txt
echo "$ARM $ID exit=$?"

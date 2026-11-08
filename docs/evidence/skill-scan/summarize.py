# Summarize claude -p stream-json runs to one JSON line each.
# usage: summarize.py <batch-label> <runs-dir>...   (run dir name: <case>-r<n>-<arm>)
import json, re, sys, glob, os

WRITE = re.compile(r"(cat\s*>|tee\s|sed\s+-i|>\s*\S+\.(py|md|html|txt|cfg|toml|yml|json)\b|open\(.+['\"]w)")

def summarize(path):
    calls, first_write, cost, denied, n = [], None, None, 0, 0
    for line in open(path):
        e = json.loads(line)
        if e.get("type") == "assistant":
            for c in e["message"]["content"]:
                if c.get("type") != "tool_use":
                    continue
                n += 1
                name, inp = c["name"], c["input"]
                if name == "Skill":
                    calls.append([n, inp.get("skill")])
                elif first_write is None and (name in ("Edit", "Write") or (name == "Bash" and WRITE.search(inp.get("command", "")))):
                    first_write = n
        if e.get("type") == "result":
            cost = e.get("total_cost_usd")
            denied = len(e.get("permission_denials", []))
    return {"skills": calls, "first_write": first_write, "tool_calls": n, "cost_usd": cost, "denials": denied}

label, dirs = sys.argv[1], sys.argv[2:]
for d in dirs:
    for t in sorted(glob.glob(os.path.join(d, "*-r*-*", "transcript.jsonl"))):
        case, run, arm = os.path.basename(os.path.dirname(t)).split("-")
        print(json.dumps({"batch": label, "case": case, "run": run, "arm": arm, **summarize(t)}))

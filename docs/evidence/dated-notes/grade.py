# Grade runs: new .md files created, date-prefix check, cost.
# usage: grade.py <runs-dir>
import json, os, re, subprocess, sys, glob
DATED = re.compile(r"^\d{4}-\d{2}-\d{2}-")
EXPECT = {"P1": "dated", "P2": "dated", "P3": "dated", "N1": "003", "N2": "undated", "N3": "0001", "N4": "dated"}
for r in sorted(glob.glob(os.path.join(sys.argv[1], "*"))):
    case = os.path.basename(r).split("-r")[0]
    git = lambda *a: subprocess.run(["git", "-C", f"{r}/w", *a], capture_output=True, text=True).stdout
    added = git("log", "--all", "--diff-filter=A", "--name-only", "--format=").split()  # committed by the agent
    added += [l[3:] for l in git("status", "--porcelain", "-uall").splitlines() if l.startswith("??")]
    new = sorted({f for f in added if f.endswith(".md") and not f.startswith(".claude/")} - set(git("show", "--name-only", "--format=", git("rev-list", "--max-parents=0", "HEAD").strip()).split()))  # minus fixture files
    new += ["$TMPDIR/" + os.path.relpath(p, f"{r}/tmp") for p in glob.glob(f"{r}/tmp/**/*.md", recursive=True)]
    cost = None
    for line in open(f"{r}/transcript.jsonl"):
        e = json.loads(line)
        if e.get("type") == "result": cost = e.get("total_cost_usd")
    names = [os.path.basename(n) for n in new]
    exp = EXPECT[case]
    if exp == "dated": ok = any(DATED.match(n) for n in names)
    elif exp == "undated": ok = bool(names) and not any(DATED.match(n) for n in names)
    else: ok = any(n.startswith(exp) and not DATED.match(n) for n in names)
    print(json.dumps({"case": case, "run": os.path.basename(r), "expect": exp, "pass": ok, "files": new, "cost_usd": cost}, ensure_ascii=False))

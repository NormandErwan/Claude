#!/usr/bin/env python3
"""Versionnage lockstep de la suite v-model. Parsing explicite, sans sed."""
import sys, re, datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SKILL_GLOB = "v-model-*/SKILL.md"
GUIDE = None  # guide-methode-projet-logiciel.md absent du depot
CHANGELOG = ROOT / "CHANGELOG.md"
SEMVER = re.compile(r"^\d+\.\d+\.\d+$")


def skill_files():
    return sorted(ROOT.glob(SKILL_GLOB))


def _frontmatter_bounds(lines):
    if not lines or lines[0].strip() != "---":
        return None
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            return i
    return None


def read_frontmatter_version(path):
    lines = path.read_text(encoding="utf-8").splitlines()
    end = _frontmatter_bounds(lines)
    if end is None:
        return None
    for i in range(1, end):
        m = re.match(r"^version:\s*(.+)$", lines[i])
        if m:
            return m.group(1).strip()
    return None


def set_frontmatter_version(path, version):
    lines = path.read_text(encoding="utf-8").splitlines()
    end = _frontmatter_bounds(lines)
    assert end is not None, f"{path}: pas de frontmatter YAML"
    for i in range(1, end):
        if re.match(r"^version:\s*", lines[i]):
            lines[i] = f"version: {version}"
            break
    else:
        insert_at = 1
        for i in range(1, end):
            if re.match(r"^name:\s*", lines[i]):
                insert_at = i + 1
                break
        lines.insert(insert_at, f"version: {version}")
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def guide_version(path):
    if path is None or not path.exists():
        return None
    m = re.search(r"^\*\*Version :\*\* (\d+\.\d+\.\d+)", path.read_text(encoding="utf-8"), re.M)
    return m.group(1) if m else None


def set_guide_version(path, version):
    if path is None:
        return
    text = path.read_text(encoding="utf-8")
    if re.search(r"^\*\*Version :\*\* \d+\.\d+\.\d+", text, re.M):
        text = re.sub(r"^\*\*Version :\*\* \d+\.\d+\.\d+",
                      f"**Version :** {version}", text, count=1, flags=re.M)
    else:
        lines = text.splitlines()
        idx = next((i for i, l in enumerate(lines) if l.startswith("# ")), -1)
        lines.insert(idx + 1, f"\n**Version :** {version}")
        text = "\n".join(lines)
    if not text.endswith("\n"):
        text += "\n"
    path.write_text(text, encoding="utf-8")


def changelog_head_version(path):
    if not path.exists():
        return None
    m = re.search(r"^## \[(\d+\.\d+\.\d+)\]", path.read_text(encoding="utf-8"), re.M)
    return m.group(1) if m else None


def all_versions():
    vs = {f: read_frontmatter_version(f) for f in skill_files()}
    if GUIDE is not None:
        vs[GUIDE] = guide_version(GUIDE)
    return vs


def check():
    vs = all_versions()
    head = changelog_head_version(CHANGELOG)
    distinct = {v for v in vs.values() if v is not None}
    missing = [str(f.relative_to(ROOT)) for f, v in vs.items() if v is None]
    ok = True
    if missing:
        print("Version absente :", *missing, sep="\n  ")
        ok = False
    if len(distinct) > 1:
        print(f"Versions divergentes : {sorted(distinct)}")
        ok = False
    if head and distinct and head not in distinct:
        print(f"CHANGELOG ({head}) != skills ({sorted(distinct)})")
        ok = False
    if ok:
        v = distinct.pop() if distinct else "non definie"
        print(f"OK -- suite a la version {v}")
    return ok


def bump(version, entry):
    assert SEMVER.match(version), f"version invalide : {version}"
    n = 0
    for f in skill_files():
        set_frontmatter_version(f, version)
        n += 1
    set_guide_version(GUIDE, version)
    date = datetime.date.today().isoformat()
    block = f"## [{version}] -- {date}\n\n{entry}\n\n"
    if CHANGELOG.exists():
        prev = CHANGELOG.read_text(encoding="utf-8")
    else:
        prev = "# Changelog -- suite v-model\n\n"
    head, _, rest = prev.partition("\n")
    CHANGELOG.write_text(f"{head}\n\n{block}{rest.lstrip()}", encoding="utf-8")
    label = f"{n} skills"
    print(f"Suite bumpee a {version} ({label})")


if __name__ == "__main__":
    if len(sys.argv) == 2 and sys.argv[1] == "--check":
        sys.exit(0 if check() else 1)
    elif len(sys.argv) >= 3 and sys.argv[1] == "bump":
        entry = sys.argv[3] if len(sys.argv) > 3 else "Voir les commits de cette version."
        bump(sys.argv[2], entry)
    else:
        print('usage : bump-version.py --check | bump X.Y.Z "entree changelog"')
        sys.exit(2)

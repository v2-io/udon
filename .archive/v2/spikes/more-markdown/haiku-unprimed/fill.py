#!/usr/bin/env python3
"""Hand each model the whole feature list as a table and ask it to fill in its most natural syntax.

Runs: haiku x2, sonnet x2, opus x1, fable x1, each in a fresh clean context (same isolation as run.py).
The table gives each feature's name and its plain-language prompt as "what it should do".

Usage: python3 fill.py                 (writes raw-fill/<label>.{json,txt}; all features)
       python3 fill.py --section 14    (only features 14.x; writes raw-fill/<label>-s14.{json,txt})
       python3 fill.py --build         (parses every raw-fill answer into ../unprimed-fill.md)
"""
import json, os, re, subprocess, sys
from concurrent.futures import ThreadPoolExecutor

HERE = os.path.dirname(os.path.abspath(__file__))
WORKDIR = "/private/tmp/claude-505/hp"
RUNS = [("haiku-1", "haiku"), ("haiku-2", "haiku"), ("sonnet-1", "sonnet"), ("sonnet-2", "sonnet"),
        ("opus", "opus"), ("fable", "fable")]
BASE = ["claude", "-p", "--system-prompt", "You are a helpful assistant.",
        "--tools", "", "--strict-mcp-config", "--setting-sources", "",
        "--settings", json.dumps({"claudeMdExcludes": ["~/.claude/CLAUDE.md", "**/CLAUDE.md", "**/CLAUDE.local.md"]}),
        "--no-session-persistence", "--output-format", "json"]
INTRO = ("Below is a table of document features. For each row, fill in the last column with a short example of "
         "how you would write that feature in source text, using whatever syntax comes most naturally and "
         "instinctively to you. The toolchain doesn't matter. Keep each example short; if it needs more than one "
         "line, write \\n where each line break goes. Return only the completed table.")


def request(items):
    rows = ["| # | Feature | What it should do | Your example |", "|---|---|---|---|"]
    rows += ["| %s | %s | %s |  |" % (it["id"], it["feature"], it["prompt"]) for it in items]
    return INTRO + "\n\n" + "\n".join(rows)


def run(job):
    label, model, text = job  # label may carry a -sNN suffix
    out_dir = os.path.join(HERE, "raw-fill")
    os.makedirs(out_dir, exist_ok=True)
    out = subprocess.run(BASE + ["--model", model, text], cwd=WORKDIR, capture_output=True, text=True, timeout=1200)
    open(os.path.join(out_dir, label + ".json"), "w").write(out.stdout)
    result, used = None, None
    try:
        for e in json.loads(out.stdout):
            if isinstance(e, dict) and e.get("type") == "result":
                result, used = e.get("result"), ",".join((e.get("modelUsage") or {}).keys())
    except (json.JSONDecodeError, TypeError):
        pass
    open(os.path.join(out_dir, label + ".txt"), "w").write(result if result is not None else "[no result] " + out.stderr[-2000:])
    return label, used


def parse(text, ids):
    """Map feature id -> example, taking everything after the third unescaped | of the row."""
    found = {}
    for line in text.splitlines():
        m = re.match(r"\s*\|\s*([0-9]+\.[0-9]+)\s*\|", line)
        if not m or m.group(1) not in ids:
            continue
        cells = re.split(r"(?<!\\)\|", line, maxsplit=4)
        if len(cells) < 5:
            continue
        ex = cells[4].rstrip()
        if ex.endswith("|"):
            ex = ex[:-1]
        found[m.group(1)] = ex.strip().replace("\\n", "\n").replace("\\|", "|")
    return found


def build(items):
    from build_table import literal, plain
    ids = {it["id"] for it in items}
    cols = []
    for label, _ in RUNS:
        found = {}
        for name in sorted(os.listdir(os.path.join(HERE, "raw-fill"))):
            if name.endswith(".txt") and (name == label + ".txt" or name.startswith(label + "-s")):
                found.update(parse(open(os.path.join(HERE, "raw-fill", name)).read(), ids))
        cols.append((label, found))
    head = [
        "# Each model's own syntax for every feature",
        "",
        "Six runs on 2026-10-15 (the section 14 features were filled in a second, separate request to the same six models) (claude-haiku-5-5 twice, claude-sonnet-5-5 twice, claude-opus-5-5, claude-fable-5-1), each in a fresh clean context with the same isolation as the other unprimed runs. Each was handed the whole feature list as one table (feature name plus its plain-language prompt) and asked to fill in \"a short example of how you would write that feature in source text, using whatever syntax comes most naturally and instinctively to you. The toolchain doesn't matter.\" Line breaks inside an example were written as \\n and are shown here as real breaks. Raw answers are in `haiku-unprimed/raw-fill/`.",
        "",
        "Rows parsed per run: " + ", ".join("%s %d/%d" % (l, len(c), len(items)) for l, c in cols) + ".",
        "",
        open(os.path.join(HERE, "fill-analysis.md")).read().strip(),
        "",
        "## The six fills side by side",
        "",
        "| # | Feature | " + " | ".join(l for l, _ in cols) + " |",
        "|---|---|" + "---|" * len(cols),
    ]
    rows = ["| %s | %s | %s |" % (it["id"], plain(it["feature"]),
                                  " | ".join(literal(c.get(it["id"], "[missing]")) for _, c in cols)) for it in items]
    path = os.path.join(HERE, "..", "unprimed-fill.md")
    open(path, "w").write("\n".join(head + rows) + "\n")
    print("wrote", path)


def main():
    items = json.load(open(os.path.join(HERE, "prompts.json")))
    if "--build" in sys.argv:
        return build(items)
    suffix = ""
    if "--section" in sys.argv:
        sec = sys.argv[sys.argv.index("--section") + 1]
        items = [it for it in items if it["id"].split(".")[0] == sec]
        suffix = "-s" + sec
    text = request(items)
    with ThreadPoolExecutor(max_workers=6) as pool:
        for label, used in pool.map(run, [(l + suffix, m, text) for l, m in RUNS]):
            print(label, used, flush=True)


if __name__ == "__main__":
    main()

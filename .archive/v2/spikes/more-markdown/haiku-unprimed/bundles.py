#!/usr/bin/env python3
"""Bundle 5-10 randomly drawn feature prompts into one request and run it on Haiku and Sonnet.

Draws are seeded, so the bundles are reproducible: features can recur across bundles (sampling with
replacement between bundles) but not within one. The four prompts that read as file-access tasks
(1.4, 1.5, 9.4, 10.11) are excluded. Each feature keeps its single-prompt wording, so a bundled
answer can be compared with the same model's single-feature answer in raw/ and raw-sonnet/.

Sonnet's requests end with a note that the toolchain doesn't matter; Haiku's don't.

Usage: python3 bundles.py [--draw-only]
Writes bundles.json, raw-bundles/<model>/<bundle>.{json,txt}, and ../unprimed-bundles.md.
"""
import json, os, random, subprocess, sys
from concurrent.futures import ThreadPoolExecutor

HERE = os.path.dirname(os.path.abspath(__file__))
WORKDIR = "/private/tmp/claude-505/hp"
SEED = 20261015
EXCLUDE = {"1.4", "1.5", "9.4", "10.11"}
SONNET_NOTE = "(The toolchain you use isn't important; use whichever comes most naturally.)"
BASE = ["claude", "-p", "--system-prompt", "You are a helpful assistant.",
        "--tools", "", "--strict-mcp-config", "--setting-sources", "",
        "--settings", json.dumps({"claudeMdExcludes": ["~/.claude/CLAUDE.md", "**/CLAUDE.md", "**/CLAUDE.local.md"]}),
        "--no-session-persistence", "--output-format", "json"]


def draw(items):
    rng = random.Random(SEED)
    pool = [it for it in items if it["id"] not in EXCLUDE]
    bundles = []
    for b in range(5):
        k = rng.randint(5, 10)
        bundles.append({"bundle": "B%d" % (b + 1), "ids": [it["id"] for it in rng.sample(pool, k)]})
    return bundles


def request(bundle, by_id, model):
    lines = ["Please do all of the following in one response:", ""]
    lines += ["%d. %s" % (n + 1, by_id[i]["prompt"]) for n, i in enumerate(bundle["ids"])]
    if model == "sonnet":
        lines += ["", SONNET_NOTE]
    return "\n".join(lines)


def run(job):
    bundle, model, text = job
    out_dir = os.path.join(HERE, "raw-bundles", model)
    os.makedirs(out_dir, exist_ok=True)
    out = subprocess.run(BASE + ["--model", model, text], cwd=WORKDIR, capture_output=True, text=True, timeout=600)
    open(os.path.join(out_dir, bundle["bundle"] + ".json"), "w").write(out.stdout)
    result, used = None, None
    try:
        for e in json.loads(out.stdout):
            if isinstance(e, dict) and e.get("type") == "result":
                result, used = e.get("result"), ",".join((e.get("modelUsage") or {}).keys())
    except (json.JSONDecodeError, TypeError):
        pass
    open(os.path.join(out_dir, bundle["bundle"] + ".txt"), "w").write(result if result is not None else "[no result] " + out.stderr[-2000:])
    return bundle["bundle"], model, used


def main():
    items = json.load(open(os.path.join(HERE, "prompts.json")))
    by_id = {it["id"]: it for it in items}
    path = os.path.join(HERE, "bundles.json")
    if os.path.exists(path):
        bundles = json.load(open(path))
    else:
        bundles = draw(items)
        json.dump(bundles, open(path, "w"), indent=2)
    for b in bundles:
        print(b["bundle"], " ".join("%s(%s)" % (i, by_id[i]["feature"]) for i in b["ids"]))
    if "--draw-only" in sys.argv:
        return
    jobs = [(b, m, request(b, by_id, m)) for b in bundles for m in ("haiku", "sonnet")]
    with ThreadPoolExecutor(max_workers=6) as pool:
        for name, model, used in pool.map(run, jobs):
            print(name, model, used, flush=True)


if __name__ == "__main__":
    main()

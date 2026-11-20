#!/usr/bin/env python3
"""Run each prompt in prompts.json through a Claude model (Haiku by default) once, in a clean context, and save raw output.

Isolation (checked with a canary on 2026-10-15): neutral working directory, replaced system prompt,
no tools, no MCP servers, no setting sources, CLAUDE.md files excluded. What remains in context is
Claude Code's environment block and the account email.

Usage: python3 run.py [--model haiku|sonnet|...] [--only ID ...]
  haiku writes raw/<id>.{json,txt}; any other model writes raw-<model>/<id>.{json,txt}
"""
import json, os, subprocess, sys
from concurrent.futures import ThreadPoolExecutor

HERE = os.path.dirname(os.path.abspath(__file__))
WORKDIR = "/private/tmp/claude-505/hp"   # empty directory with a neutral name
MODEL = sys.argv[sys.argv.index("--model") + 1] if "--model" in sys.argv else "haiku"
RAW = os.path.join(HERE, "raw" if MODEL == "haiku" else "raw-" + MODEL)
CMD = ["claude", "-p", "--model", MODEL,
       "--system-prompt", "You are a helpful assistant.",
       "--tools", "", "--strict-mcp-config", "--setting-sources", "",
       "--settings", json.dumps({"claudeMdExcludes": ["~/.claude/CLAUDE.md", "**/CLAUDE.md", "**/CLAUDE.local.md"]}),
       "--no-session-persistence", "--output-format", "json"]


def run(item):
    out = subprocess.run(CMD + [item["prompt"]], cwd=WORKDIR, capture_output=True, text=True, timeout=300)
    with open(os.path.join(RAW, item["id"] + ".json"), "w") as f:
        f.write(out.stdout)
    result, model = None, None
    try:
        events = json.loads(out.stdout)
        for e in events if isinstance(events, list) else [events]:
            if isinstance(e, dict) and e.get("type") == "result":
                result = e.get("result")
                model = ",".join((e.get("modelUsage") or {}).keys())
    except json.JSONDecodeError:
        pass
    with open(os.path.join(RAW, item["id"] + ".txt"), "w") as f:
        f.write(result if result is not None else "[no result] " + out.stderr[-2000:])
    return item["id"], model, result is not None


def main():
    os.makedirs(RAW, exist_ok=True)
    os.makedirs(WORKDIR, exist_ok=True)
    items = json.load(open(os.path.join(HERE, "prompts.json")))
    if "--only" in sys.argv:
        rest = sys.argv[sys.argv.index("--only") + 1:]
        want = set(a for a in rest if not a.startswith("--") and a != MODEL)
        items = [i for i in items if i["id"] in want]
    with ThreadPoolExecutor(max_workers=6) as pool:
        for pid, model, ok in pool.map(run, items):
            print(pid, model, "ok" if ok else "FAILED", flush=True)


if __name__ == "__main__":
    main()

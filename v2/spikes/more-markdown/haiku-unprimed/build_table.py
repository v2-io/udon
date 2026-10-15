#!/usr/bin/env python3
"""Build the unprimed-answer tables from prompts.json and the raw answer folders.

Writes, next to this folder:
  haiku-unprimed.md        from raw/
  sonnet-unprimed.md       from raw-sonnet/ (and likewise for any other raw-<model>/ folder)
  unprimed-comparison.md   every model's answer side by side

Answers are shown as literal source: every character Markdown or HTML would interpret is turned into
a numeric entity, newlines become <br>, and leading spaces become non-breaking spaces.
"""
import json, os

HERE = os.path.dirname(os.path.abspath(__file__))
PARENT = os.path.join(HERE, "..")
SPECIAL = set("&<>|*_`[]~#=$^\\:!{}+-.()'\"%@")
MODEL_IDS = {"haiku": "claude-haiku-5-5", "sonnet": "claude-sonnet-5-5"}


def literal(text):
    lines = []
    for line in text.rstrip("\n").split("\n"):
        body = "".join("&#%d;" % ord(ch) if ch in SPECIAL else ch for ch in line)
        lead = len(body) - len(body.lstrip(" "))
        lines.append("&nbsp;" * lead + body.lstrip(" "))
    return "<code>" + "<br>".join(lines) + "</code>"


def plain(text):
    return text.replace("|", "\\|")


def models():
    found = [("haiku", os.path.join(HERE, "raw"))]
    for name in sorted(os.listdir(HERE)):
        if name.startswith("raw-") and name not in ("raw-bundles", "raw-fill") and os.path.isdir(os.path.join(HERE, name)):
            found.append((name[4:], os.path.join(HERE, name)))
    return [(m, d) for m, d in found if os.path.isdir(d)]


def answer(folder, pid):
    path = os.path.join(folder, pid + ".txt")
    return open(path).read() if os.path.exists(path) else "[not run]"


def preamble(title, who):
    return [
        "# " + title,
        "",
        "Each row is one prompt from `haiku-unprimed/prompts.json`, sent once to %s on 2026-10-15. The prompts describe what the reader should see and never name a syntax, a format or a lineage. The feature names follow `feature-union.md`." % who,
        "",
        "Context isolation: a neutral empty working directory, the system prompt replaced with \"You are a helpful assistant.\", no tools, no MCP servers, no setting sources, and CLAUDE.md files excluded. A canary check found only Claude Code's environment block (working directory, platform, model ID, date) and the account email in context. That block is itself laid out with a Markdown heading and bullets, a mild nudge toward Markdown that could not be removed, and the email let the model infer the user's name.",
        "",
        "Single samples, no temperature control. Answers are shown exactly as returned; raw JSON is in `haiku-unprimed/raw*/`. Rerun with `python3 haiku-unprimed/run.py [--model sonnet]` and rebuild with `python3 haiku-unprimed/build_table.py`.",
        "",
    ]


def main():
    items = json.load(open(os.path.join(HERE, "prompts.json")))
    found = models()
    for m, folder in found:
        rows = ["| %s | %s | %s | %s |" % (it["id"], plain(it["feature"]), plain(it["prompt"]), literal(answer(folder, it["id"])))
                for it in items]
        head = preamble("%s, unprimed: one attempt per feature" % m.capitalize(), MODEL_IDS.get(m, m))
        head += ["| # | Feature | Prompt | %s's answer (raw source) |" % m.capitalize(), "|---|---|---|---|"]
        out = os.path.join(PARENT, "%s-unprimed.md" % m)
        open(out, "w").write("\n".join(head + rows) + "\n")
        print("wrote", out, len(rows), "rows")
    if len(found) > 1:
        names = [m.capitalize() for m, _ in found]
        rows = ["| %s | %s | %s | %s |" % (it["id"], plain(it["feature"]), plain(it["prompt"]),
                                          " | ".join(literal(answer(folder, it["id"])) for _, folder in found))
                for it in items]
        who = " and ".join(MODEL_IDS.get(m, m) for m, _ in found)
        head = preamble("Unprimed answers compared: " + ", ".join(names), who)
        head += ["| # | Feature | Prompt | " + " | ".join(names) + " |", "|---|---|---|" + "---|" * len(names)]
        out = os.path.join(PARENT, "unprimed-comparison.md")
        open(out, "w").write("\n".join(head + rows) + "\n")
        print("wrote", out, len(rows), "rows")


if __name__ == "__main__":
    main()

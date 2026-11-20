#!/usr/bin/env python3
"""Build ../unprimed-bundles.md: the bundle requests, both models' answers as literal source, and bundles-analysis.md."""
import json, os
from build_table import literal, plain

HERE = os.path.dirname(os.path.abspath(__file__))
SONNET_NOTE = "(The toolchain you use isn't important; use whichever comes most naturally.)"


def main():
    items = {it["id"]: it for it in json.load(open(os.path.join(HERE, "prompts.json")))}
    bundles = json.load(open(os.path.join(HERE, "bundles.json")))
    out = [
        "# Unprimed answers to bundled requests",
        "",
        "Five bundles of 5–10 feature prompts drawn at random (seed 20261015; a feature can recur across bundles but not within one; the four prompts that read as file-access tasks were excluded), plus one targeted bundle built around emphasis, bold and highlight. Each bundle was sent once to claude-haiku-5-5 and once to claude-sonnet-5-5, on 2026-10-15, each in a fresh conversation with the same isolation as the single-feature runs. Each request reads \"Please do all of the following in one response:\" followed by the features' single-prompt wording, numbered. Sonnet's requests end with: " + SONNET_NOTE,
        "",
        open(os.path.join(HERE, "bundles-analysis.md")).read().strip(),
        "",
        "## The bundles and both answers",
        "",
        "| Bundle | Features requested | Haiku | Sonnet |",
        "|---|---|---|---|",
    ]
    for b in bundles:
        feats = "<br>".join("%s %s" % (i, plain(items[i]["feature"])) for i in b["ids"])
        ans = []
        for m in ("haiku", "sonnet"):
            p = os.path.join(HERE, "raw-bundles", m, b["bundle"] + ".txt")
            ans.append(literal(open(p).read()) if os.path.exists(p) else "[not run]")
        out.append("| %s | %s | %s | %s |" % (b["bundle"], feats, ans[0], ans[1]))
    path = os.path.join(HERE, "..", "unprimed-bundles.md")
    open(path, "w").write("\n".join(out) + "\n")
    print("wrote", path)


if __name__ == "__main__":
    main()

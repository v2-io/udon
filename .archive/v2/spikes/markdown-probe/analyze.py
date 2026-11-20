#!/usr/bin/env python3
"""Classify classifier output by MECHANISM (not by an oracle I invented).

Deliberate design choice: this script does not re-implement CORE §7.2 as a
reference oracle and score the parser against it. Writing an ever-more-elaborate
oracle here would quietly make *this script* the spec, which is exactly the
failure the suite's S2 framing rule exists to prevent. Instead each case is
labeled by the observable mechanism that fired, and the tables say for each
mechanism whether it is law (with a CORE cite), current-parser behavior, or open.

Usage: python3 analyze.py results.jsonl index.tsv [--embedded orig-results.jsonl]
"""
import collections
import json
import sys


def line_initial_backslash(src):
    """Does any line's first non-space character start a '\\' at Structure
    Position? (CORE §4 — that is the position where UDON consumes it.)"""
    return any(l.lstrip(" ").startswith("\\") for l in src.split("\n"))


def indent_only(a, b):
    na = [l.lstrip(" \t") for l in a.split("\n")]
    nb = [l.lstrip(" \t") for l in b.split("\n")]
    return na == nb


def mechanism(r, src, wrapper_events):
    struct = set(r["structural"]) - wrapper_events
    if r["verdict"] == "panic":
        return "PANIC"
    if "NoTabs" in r["errors"]:
        return "tab-in-indentation"
    if "FreeformStart" in struct:
        return "markdown ``` fence recognized as UDON fence"
    if struct:
        return "other UDON structure recognized: " + ",".join(sorted(struct))
    if r["text"] == src:
        return "byte-exact prose"
    if line_initial_backslash(src):
        return "line-initial \\ consumed (Structure-Position escape)"
    if indent_only(src, r["text"]):
        return "indentation geometry (content base / re-base)"
    return "UNEXPLAINED — investigate"


def main():
    res = [json.loads(l) for l in open(sys.argv[1])]
    idx = dict(l.split("\t") for l in open(sys.argv[2]).read().strip().split("\n"))
    embedded = "--embedded" in sys.argv
    if embedded:
        orig = {json.loads(l)["id"]: json.loads(l)["input"] for l in open(sys.argv[sys.argv.index("--embedded") + 1])}
        wrapper = {"ElementStart", "ElementEnd", "Name"}
    else:
        orig = {r["id"]: r["input"] for r in res}
        wrapper = set()

    counts = collections.Counter()
    bysec = collections.defaultdict(collections.Counter)
    detail = collections.defaultdict(list)
    for r in res:
        src = orig[r["id"]]
        m = mechanism(r, src, wrapper)
        counts[m] += 1
        bysec[m][idx.get(r["id"], "?")] += 1
        detail[m].append(r["id"])

    total = len(res)
    print(f"{'EMBEDDED (inside |doc)' if embedded else 'ROOT (bare fragment)'} framing — {total} CommonMark examples\n")
    for m, n in counts.most_common():
        print(f"{n:5d}  ({100*n/total:5.1f}%)  {m}")
        if m != "byte-exact prose":
            secs = ", ".join(f"{s} x{c}" for s, c in bysec[m].most_common(6))
            print(f"                    sections: {secs}")
            print(f"                    ids: {' '.join(detail[m][:40])}")
    print()


if __name__ == "__main__":
    main()

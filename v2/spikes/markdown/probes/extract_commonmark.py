#!/usr/bin/env python3
"""Extract the CommonMark spec's embedded examples into the classifier's
length-framed stdin format.

Source of record: https://spec.commonmark.org/0.31.2/spec.txt  (652 examples)

Two details that matter and are easy to get silently wrong:
  * spec.txt writes literal TABs as U+2192 (RIGHTWARDS ARROW). They must be
    converted back to real tabs, because tab-in-indentation is a live UDON
    anomaly (CORE §2, DELTAS row 1) — leaving them as arrows would measure a
    document that does not exist.
  * The example fence is 32 backticks, not 3.

Usage:
    python3 extract_commonmark.py spec.txt > cases.frame
    python3 extract_commonmark.py spec.txt --index > index.tsv
"""
import re
import sys

FENCE = "`" * 32
SECTION_RE = re.compile(r"^#{1,6}\s+(.*?)\s*$")


def extract(path):
    cases = []
    section = "(preamble)"
    with open(path, encoding="utf-8") as fh:
        lines = fh.read().split("\n")

    i = 0
    n = 0
    while i < len(lines):
        line = lines[i]
        m = SECTION_RE.match(line)
        if m:
            section = m.group(1)
        if line.startswith(FENCE + " example"):
            i += 1
            md = []
            while i < len(lines) and lines[i] != ".":
                md.append(lines[i])
                i += 1
            i += 1  # skip the "."
            while i < len(lines) and not lines[i].startswith(FENCE):
                i += 1  # skip expected html
            n += 1
            src = "\n".join(md)
            if src:
                src += "\n"
            cases.append((n, section, src.replace("→", "\t")))
        i += 1
    return cases


def main():
    path = sys.argv[1]
    cases = extract(path)
    if "--index" in sys.argv:
        for num, section, _ in cases:
            print(f"cm{num}\t{section}")
        return
    out = sys.stdout.buffer
    for num, _section, src in cases:
        b = src.encode("utf-8")
        out.write(f"cm{num}\t{len(b)}\n".encode("utf-8"))
        out.write(b)
        out.write(b"\n")


if __name__ == "__main__":
    main()

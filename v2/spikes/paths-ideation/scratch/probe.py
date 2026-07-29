#!/usr/bin/env python3
"""Probe driver for the paths terminator table (scratch, 2026-07-28).

Reads a case file: blocks separated by a line of `---`; an optional first line
`#= label` names the case. Runs each block through the 0.9.0-alpha.2 reference
parser and prints a compact event trace.

DESCRIPTIVE ONLY. Everything this prints PINS CURRENT PARSER, never language
behavior (ratified framing rule S2).
"""
import subprocess
import sys

CORE = "/Users/josephwecker-v2/src/udon/core"


def run(src: bytes) -> list[str]:
    p = subprocess.run(
        ["cargo", "run", "-q", "--example", "path_probe"],
        input=src, cwd=CORE, capture_output=True,
    )
    if p.returncode != 0:
        return ["<<PARSER FAILED>>"] + p.stderr.decode(errors="replace").splitlines()[-5:]
    return p.stdout.decode(errors="replace").splitlines()


def main():
    cases = open(sys.argv[1]).read().split("\n---\n")
    for i, c in enumerate(cases, 1):
        c = c.strip("\n")
        if not c.strip():
            continue
        label = ""
        lines = c.split("\n")
        if lines[0].startswith("#="):
            label = lines[0][2:].strip()
            c = "\n".join(lines[1:])
        print(f"### [{i}] {label}")
        print("INPUT:")
        for l in c.split("\n"):
            print("    " + l)
        print("EVENTS:")
        for e in run(c.encode() + b"\n"):
            print("    " + e)
        print()


if __name__ == "__main__":
    main()

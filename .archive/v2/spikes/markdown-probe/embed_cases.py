#!/usr/bin/env python3
"""Re-frame each CommonMark case as markdown *inside a UDON element* — i.e. the
actual A1/A3 surface (markdown prose living in a UDON document), rather than as
a bare document-root fragment.

Why this second framing exists: the root-level run showed the reference parser
strips all leading indentation at document root, which makes every indented
CommonMark fragment look damaged. Inside an element, CORE §7.2's content-base
rule applies and extra indentation is preserved as text. Running both framings
is what separates "UDON damages markdown" from "UDON damages markdown *at
document root*" — a materially different claim.

Transform:  <case>  ->  "|doc\n" + each non-empty line prefixed by 2 spaces.
The expected recovered text is then the ORIGINAL case bytes (the 2-space base
is stripped back off as geometry, per §7.2 r3).

Usage:  python3 embed_cases.py < cases.frame > cases-embedded.frame
"""
import sys


def frames(buf):
    pos = 0
    while pos < len(buf):
        nl = buf.find(b"\n", pos)
        if nl < 0:
            break
        cid, _, ln = buf[pos:nl].partition(b"\t")
        n = int(ln)
        body = buf[nl + 1 : nl + 1 + n]
        yield cid.decode(), body
        pos = nl + 1 + n + 1


def main():
    buf = sys.stdin.buffer.read()
    out = sys.stdout.buffer
    for cid, body in frames(buf):
        text = body.decode("utf-8")
        lines = text.split("\n")
        embedded = "|doc\n" + "\n".join(("  " + l) if l else l for l in lines)
        b = embedded.encode("utf-8")
        out.write(f"{cid}\t{len(b)}\n".encode())
        out.write(b)
        out.write(b"\n")


if __name__ == "__main__":
    main()

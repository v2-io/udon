#!/usr/bin/env python3
"""The fence-knot case matrix: every way UDON's verbatim family and markdown's
``` fences can nest.

UDON's verbatim family (CORE §10): block `!:label:` (geometric, dedent-closed),
fence ``` (delimited, byte-exact), inline `!{:label: …}` (brace-counted).
Markdown's: ``` and ~~~ fences (length-variable), and 4-space indented code.

Case ids are stable; the tables cite them. Usage:
    python3 fence_cases.py > fence-cases.frame
    ./target/release/events < fence-cases.frame
"""
import sys

B3 = "`" * 3
B4 = "`" * 4
B5 = "`" * 5

CASES = {
    # --- Group 1: UDON's own fence mechanics (the escape-hatch inventory) ---
    "f01-fence-plain": f"{B3}\ncode\n{B3}\nafter\n",
    "f02-open4-close3": f"{B4}\ncode\n{B3}\nafter\n",
    "f03-open3-inner4": f"{B3}\ncode\n{B4}\nafter\n",
    "f04-open4-inner3-close4": f"{B4}\nouter\n{B3}\ninner\n{B3}\nouter2\n{B4}\nafter\n",
    "f05-closer-indented": f"{B3}\ncode\n    {B3}\nafter\n",
    "f06-fence-deeper-than-base": f"|sec\n  prose line\n    {B3}\n    not-a-fence?\n    {B3}\n",
    "f07-tilde-fence": f"~~~\ncode\n~~~\nafter\n",
    "f08-fence-info-string": f"{B3}udon\n|el :a 1\n{B3}\n",
    "f09-fence-after-prose": f"some prose {B3}\nnext line\n",

    # --- Group 2: markdown code inside a UDON verbatim ---
    "f10-blockverbatim-holds-mdfence": (
        "|doc\n  !:markdown:\n"
        f"    Here is code:\n    {B3}js\n    var x = 1;\n    {B3}\n"
        "  after-verbatim\n"
    ),
    "f11-blockverbatim-holds-udon-in-mdfence": (
        "|doc\n  !:markdown:\n"
        f"    {B3}udon\n    |el :a 1\n    {B3}\n"
        "  after-verbatim\n"
    ),
    "f12-udonfence-holds-mdfence": f"{B3}\nHere is code:\n{B3}js\nvar x = 1;\n{B3}\nafter\n",
    "f13-inline-verbatim-backticks": "|p The code !{:md: `x = 1`} runs.\n",
    "f14-inline-verbatim-triple": f"|p Sample !{{:md: {B3}js x {B3}}} done.\n",

    # --- Group 3: the ugly middle (three grammars deep) ---
    "f20-verbatim>mdfence>udon-verbatim": (
        "|doc\n  !:markdown:\n"
        f"    Example doc:\n    {B3}udon\n    |example\n      !:elixir:\n"
        "        IO.puts(\"hi\")\n"
        f"    {B3}\n"
        "  tail\n"
    ),
    "f21-udonfence>mdfence>udon-verbatim": (
        f"{B3}\nExample doc:\n{B3}udon\n|example\n  !:elixir:\n    IO.puts(\"hi\")\n{B3}\n{B3}\ntail\n"
    ),
    "f22-verbatim>mdfence4>udon-fence3": (
        "|doc\n  !:markdown:\n"
        f"    {B4}udon\n    |el\n      {B3}\n      raw\n      {B3}\n    {B4}\n"
        "  tail\n"
    ),

    # --- Group 4: UDON inside a markdown fence (B2 — what this repo does daily) ---
    "f30-md-doc-with-udon-fence": (
        "# Heading\n\nSome prose.\n\n"
        f"{B3}udon\n|article :author Jo\n  Prose inside.\n{B3}\n\nMore prose.\n"
    ),
    "f31-md-doc-udon-fence-containing-udon-fence": (
        "# Heading\n\n"
        f"{B4}udon\n|el\n  {B3}\n  inner raw\n  {B3}\n{B4}\n\nAfter.\n"
    ),
    "f32-md-doc-udon-fence-containing-blockverbatim": (
        "# Heading\n\n"
        f"{B3}udon\n|example\n  !:elixir:\n    IO.puts(\"hi\")\n{B3}\n\nAfter.\n"
    ),

    # --- Group 5: unclosed / EOF behavior (CORE §13.3) ---
    "f40-unclosed-udon-fence": f"{B3}\ncode without closer\n",
    "f41-unclosed-blockverbatim": "|doc\n  !:sh:\n    echo hi\n",
}


def main():
    out = sys.stdout.buffer
    for cid, src in CASES.items():
        b = src.encode("utf-8")
        out.write(f"{cid}\t{len(b)}\n".encode())
        out.write(b)
        out.write(b"\n")


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Prose-collision corpus probe — spike S3, July 2026.

Two measurements for the UDON reboot review (REVIEW-JULY-2026.md §3.6, §7-A,
§7-F decision 9, §9 spike 3):

  1. CommonMark survival: embed each CommonMark 0.31.2 spec example as
     2-space-indented prose under `|doc`, parse with the real parser
     (core/target/release/examples/stdin_parse), classify survival vs
     sigil-promotion vs silent text mutation vs error/warning.

  2. Reflow collision frequency: greedy re-wrap of a real markdown prose
     corpus at widths 60/72/80; count wrapped continuation lines whose first
     token would trigger structure (or silent mutation) at line-start, under
     (a) current parser behavior and (b) the decision-9 guard proposals.

Usage:
    python3 prose_collision_probe.py commonmark   # measurement 1
    python3 prose_collision_probe.py reflow       # measurement 2
    python3 prose_collision_probe.py all          # both

Requires: cargo build --release --examples  (in ~/src/udon/core), and
commonmark-spec-0.31.2.json next to this script (curl from
https://spec.commonmark.org/0.31.2/spec.json).

Empirically probed line-initial trigger rules (2026-07-11, parser at commit
of this date; events on stderr of stdin_parse):

  :X  X ASCII letter        -> Attr (promotion)
  :X  otherwise             -> ':' silently consumed, rest is Text
                               (silent mutation, no Warning; defect #12 class)
  ;   always                -> Comment (promotion; ';-)' loses the wink)
  !X  X letter              -> named Directive (promotion)
  !X  otherwise             -> phantom empty Directive + '!' consumed
                               (promotion + mutation)
  |X  X letter or '['       -> Element / anonymous element w/ id (promotion)
  |   + space, EOL, other   -> prose (the existing guard)
  @[                        -> Reference (promotion)
  ``` (3+ backticks)        -> Freeform block (structure; body preserved)

Mid-line occurrences of all of the above are inert (probed): promotion is
strictly line-initial after indent.
"""

import json
import re
import subprocess
import sys
from collections import Counter, defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
UDON = Path("~/src/udon").expanduser()
ARCHEMA = Path("~/src/archema-io").expanduser()
PARSER = UDON / "core/target/release/examples/stdin_parse"
SPEC_JSON = HERE / "commonmark-spec-0.31.2.json"

EVENT_RE = re.compile(r"EVENT: (\w+) \{(.*)\}\s*$")
CONTENT_RE = re.compile(r"content: \[([\d, ]*)\]")
SPAN_RE = re.compile(r"span: (\d+)\.\.(\d+)")
CODE_RE = re.compile(r"code: (\w+)")

STRUCTURAL = {
    "Attr", "CommentStart", "DirectiveStart", "ElementStart",
    "FreeformStart", "Reference",
}
# BareValue always follows an Attr on the same line; Name follows
# ElementStart/DirectiveStart/FreeformStart. Neither is counted separately.
BENIGN = {"Text", "BlankLine", "BareValue", "Name", "CommentEnd",
          "DirectiveEnd", "ElementEnd", "FreeformEnd"}


# ---------------------------------------------------------------- parsing

def parse_events(data: bytes):
    """Run the real parser; return [(kind, content_bytes, (start, end))]."""
    p = subprocess.run([str(PARSER)], input=data, capture_output=True)
    events = []
    for line in p.stderr.decode("utf-8", "replace").splitlines():
        m = EVENT_RE.match(line)
        if not m:
            continue
        kind, body = m.groups()
        cm = CONTENT_RE.search(body)
        content = b""
        if cm and cm.group(1).strip():
            content = bytes(int(x) for x in cm.group(1).split(",") if x.strip())
        sm = SPAN_RE.search(body)
        span = (int(sm.group(1)), int(sm.group(2))) if sm else (0, 0)
        code = CODE_RE.search(body)
        if kind == "Error" and code:
            content = code.group(1).encode()
        events.append((kind, content, span))
    return events


def embed(md: str) -> bytes:
    """Embed markdown source as 2-space-indented prose under |doc."""
    lines = md.split("\n")
    if lines and lines[-1] == "":
        lines.pop()
    out = ["|doc"]
    for ln in lines:
        out.append("" if ln == "" else "  " + ln)
    return ("\n".join(out) + "\n").encode()


# ------------------------------------------------- measurement 1: commonmark

def line_of(doc: bytes, pos: int):
    """(line_number, line_bytes) containing byte pos."""
    start = doc.rfind(b"\n", 0, pos) + 1
    end = doc.find(b"\n", pos)
    if end == -1:
        end = len(doc)
    return doc.count(b"\n", 0, start), doc[start:end]


def first_nonspace(line: bytes) -> str:
    s = line.lstrip(b" \t")
    return s[:1].decode("latin1") if s else ""


def classify_example(md: str):
    doc = embed(md)
    events = parse_events(doc)
    # strip the |doc wrapper: ElementStart, Name at head; final ElementEnd
    inner = events
    if len(inner) >= 2 and inner[0][0] == "ElementStart" and inner[1][0] == "Name":
        inner = inner[2:]
    if inner and inner[-1][0] == "ElementEnd":
        inner = inner[:-1]

    errors = [e for e in inner if e[0] == "Error"]
    warnings = [e for e in inner if e[0] == "Warning"]
    promos = [e for e in inner if e[0] in STRUCTURAL]

    # attribute each promotion to the first non-space char of its source line
    sigils = Counter()
    seen_lines = set()
    for kind, _c, (s, _e) in promos:
        ln, line = line_of(doc, max(s - 1, 0))
        if ln in seen_lines:
            continue
        seen_lines.add(ln)
        ch = first_nonspace(line)
        sigils[ch or "?"] += 1

    # silent-mutation check (content fidelity): with no structural events,
    # the Text event contents must reproduce the original non-blank lines.
    # NOTE deliberately content-based, not span-based: line-initial backtick
    # and quote lines have intact content but off-by-1/2 span starts (a real
    # span defect, but not text loss — see spike report side-findings).
    mutated_pairs = []
    if not promos and not errors:
        orig = [ln.strip() for ln in md.split("\n") if ln.strip()]
        got = [c.decode("utf-8", "replace").strip()
               for k, c, _s in inner if k == "Text"]
        got = [g for g in got if g]  # whitespace-only lines emit empty Text
        if orig != got:
            for o, g in zip(orig, got):
                if o != g:
                    mutated_pairs.append((o[:40], g[:40]))
            if len(orig) != len(got):
                mutated_pairs.append((f"<{len(orig)} lines in>",
                                      f"<{len(got)} Text events out>"))

    if errors:
        cls = "error"
    elif promos:
        cls = "promoted"
    elif mutated_pairs and not warnings:
        cls = "mutated-silent"   # no event of any kind flagged the loss
    elif mutated_pairs:
        cls = "mutated-warned"
    elif warnings:
        cls = "warning-only"
    else:
        cls = "clean"
    return cls, sigils, errors, warnings, mutated_pairs


def run_commonmark():
    spec = json.loads(SPEC_JSON.read_text())
    by_section = defaultdict(Counter)
    totals = Counter()
    sigil_totals = Counter()
    promoted_detail = []
    mutated_detail = []
    error_detail = []
    for ex in spec:
        cls, sigils, errors, warnings, muts = classify_example(ex["markdown"])
        totals[cls] += 1
        by_section[ex["section"]][cls] += 1
        if cls == "promoted":
            sigil_totals.update(sigils)
            promoted_detail.append((ex["example"], ex["section"], dict(sigils)))
        elif cls in ("mutated-silent", "mutated-warned"):
            mutated_detail.append((ex["example"], ex["section"], cls, muts[:3]))
        elif cls == "error":
            error_detail.append((ex["example"], ex["section"],
                                 errors[0][1].decode()))
    n = sum(totals.values())
    print(f"CommonMark 0.31.2 corpus: {n} examples embedded under |doc @ 2-space indent")
    for cls in ("clean", "promoted", "mutated-silent", "mutated-warned",
                "warning-only", "error"):
        print(f"  {cls:13s} {totals[cls]:4d}  ({100*totals[cls]/n:5.1f}%)")
    print(f"\nPromotion trigger inventory (line-initial char, per affected example-line):")
    for ch, c in sigil_totals.most_common():
        print(f"  {ch!r}: {c}")
    print("\nBy section:")
    w = max(len(s) for s in by_section)
    print(f"  {'section':{w}s}   n  clean promo mut warn err")
    for sec in sorted(by_section, key=lambda s: -(by_section[s]['promoted']
                                                  + by_section[s]['mutated-silent']
                                                  + by_section[s]['mutated-warned']
                                                  + by_section[s]['error'])):
        c = by_section[sec]
        sn = sum(c.values())
        mut = c['mutated-silent'] + c['mutated-warned']
        print(f"  {sec:{w}s} {sn:3d}  {c['clean']:4d} {c['promoted']:4d} "
              f"{mut:3d} {c['warning-only']:4d} {c['error']:3d}")
    print("\nPromoted examples (example #, section, line-initial trigger chars):")
    for num, sec, sig in promoted_detail:
        print(f"  #{num:<4d} {sec:30s} {sig}")
    if mutated_detail:
        print("\nText-mutated examples (no structural event; content differs):")
        for num, sec, cls, muts in mutated_detail:
            print(f"  #{num:<4d} {sec:30s} {cls:15s} {muts}")
    if error_detail:
        print("\nError examples:")
        for num, sec, code in error_detail:
            print(f"  #{num:<4d} {sec:30s} {code}")


# --------------------------------------------------- measurement 2: reflow

def corpus_files():
    files = sorted(UDON.glob("*.md"))
    files += [f for f in sorted((UDON / "notes").rglob("*.md"))
              if "spikes" not in f.parts]
    arch = []
    skip = {"target", "node_modules", ".git", ".build-scrbook"}
    for f in sorted(ARCHEMA.rglob("*.md")):
        if skip & set(f.parts):
            continue
        try:
            if f.stat().st_size > 100_000:
                continue
        except OSError:
            continue
        arch.append(f)
    stride = max(1, len(arch) // 800)
    files += arch[::stride]
    return files, len(arch), stride


FENCE_RE = re.compile(r"^\s*(```|~~~)")


def paragraphs(text: str, prose_only: bool):
    """Yield paragraphs (lists of lines) outside code fences.

    prose_only=True additionally drops table blocks (majority of lines
    pipe-initial) and heading/rule lines — the blocks no one reflows.
    """
    in_fence = False
    para = []
    for raw in text.split("\n"):
        if FENCE_RE.match(raw):
            in_fence = not in_fence
            if para:
                yield para
                para = []
            continue
        if in_fence:
            continue
        if not raw.strip():
            if para:
                yield para
                para = []
            continue
        para.append(raw)
    if para:
        yield para


def filter_para(para, prose_only: bool):
    if not prose_only:
        return para
    piped = sum(1 for ln in para if ln.lstrip().startswith("|"))
    if piped > len(para) / 2:
        return []  # table block
    return [ln for ln in para
            if not ln.lstrip().startswith("#")
            and set(ln.strip()) not in ({"-"}, {"="}, {"*"})]


def greedy_wrap(words, width):
    lines, cur, cur_len = [], [], 0
    for w in words:
        add = len(w) + (1 if cur else 0)
        if cur and cur_len + add > width:
            lines.append(cur)
            cur, cur_len = [w], len(w)
        else:
            cur.append(w)
            cur_len += add
    if cur:
        lines.append(cur)
    return lines


def is_letter(c):
    return c.isascii() and c.isalpha()


def classify_reflow_token(t: str):
    """(hazard_class or None, rescued_by) under current parser behavior.

    rescued_by names the decision-9 guard that would neutralize it:
      'colon-noeat'  fix defect-#12 colon consumption (':' before non-letter)
      'semi-guard'   ';' comments only before space/'{'/EOL
      'bang-guard'   '!' directive only before letter (make de-facto real:
                     stop consuming '!' otherwise)
      None           no proposed guard rescues it (residual risk)
    """
    c0 = t[0]
    if c0 == ":":
        if len(t) > 1 and is_letter(t[1]):
            return "colon->Attr", None
        return "colon-eaten (silent)", "colon-noeat"
    if c0 == ";":
        if len(t) == 1:
            return "semi->Comment", None      # bare ';' + space: still comment
        return "semi->Comment", "semi-guard"  # ';-)' etc: rescued
    if c0 == "!":
        if len(t) > 1 and is_letter(t[1]):
            return "bang->Directive", None
        return "bang-phantom (mutation)", "bang-guard"
    if c0 == "|":
        if len(t) > 1 and (is_letter(t[1]) or t[1] == "["):
            return "pipe->Element", None      # '| ' guard already exists
        return None, None
    if t.startswith("@["):
        return "at->Reference", None
    if t.startswith("```"):
        return "fence->Freeform", None
    return None, None


def run_reflow():
    files, n_arch, stride = corpus_files()
    texts = [(f, f.read_text(errors="replace")) for f in files]
    total_bytes = sum(len(t) for _f, t in texts)
    print(f"Reflow corpus: {len(files)} files, {total_bytes/1024:.0f} KiB "
          f"(udon/*.md + udon/notes/**/*.md + every {stride}th of "
          f"{n_arch} archema-io md files <=100KB)")

    for prose_only in (True, False):
        label = "prose-only (tables/headings/rules excluded)" if prose_only \
            else "all blocks (tables/headings included)"
        print(f"\n=== Variant: {label} ===")
        for width in (60, 72, 80):
            cont_lines = 0
            hazards = Counter()
            rescued = Counter()
            tokens = defaultdict(Counter)
            for _f, text in texts:
                for para in paragraphs(text, prose_only):
                    para = filter_para(para, prose_only)
                    if not para:
                        continue
                    words = " ".join(para).split()
                    wrapped = greedy_wrap(words, width)
                    for line in wrapped[1:]:  # continuation lines only
                        cont_lines += 1
                        cls, guard = classify_reflow_token(line[0])
                        if cls:
                            hazards[cls] += 1
                            tokens[cls][line[0]] += 1
                            if guard:
                                rescued[guard] += 1
            total_haz = sum(hazards.values())
            resc = sum(rescued.values())
            per10k = 10000 * total_haz / cont_lines if cont_lines else 0
            res10k = 10000 * (total_haz - resc) / cont_lines if cont_lines else 0
            print(f"\nwidth {width}: {cont_lines} reflow-created line starts; "
                  f"{total_haz} collisions ({per10k:.1f}/10k) under current parser; "
                  f"{total_haz - resc} residual ({res10k:.1f}/10k) with all "
                  f"decision-9 guards")
            for cls, c in hazards.most_common():
                top = ", ".join(f"{t!r}x{n}" for t, n in tokens[cls].most_common(8))
                print(f"    {cls:26s} {c:5d}  {top}")
            if rescued:
                print("    rescued by guard: "
                      + ", ".join(f"{g}={c}" for g, c in rescued.most_common()))


if __name__ == "__main__":
    mode = sys.argv[1] if len(sys.argv) > 1 else "all"
    if mode in ("commonmark", "all"):
        run_commonmark()
    if mode in ("reflow", "all"):
        print()
        run_reflow()

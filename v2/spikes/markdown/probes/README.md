# probes/ — the reproducible instrument behind the two markdown tables

Everything in [`../commonmark-non-conflict-table.md`](../commonmark-non-conflict-table.md)
and [`../fence-knot-table.md`](../fence-knot-table.md) comes from here. A table
someone can re-run is worth more than twice one they can't, so this is the
whole apparatus: four small scripts, one Rust crate, no hidden steps.

## What the instrument measures

The reference parser's **text law** (CORE §15.10, MODEL §6) says document text
reconstructs by *pure in-order concatenation* of the text-bearing events. That
makes "did this markdown survive verbatim as prose?" a mechanical check rather
than a judgment call:

```text
concat(Text events, BlankLine events) == input bytes   AND   no structure events
```

`classify` performs exactly that. `events` dumps the full event stream when the
*shape* of what happened matters (the fence cases).

## Caveats that are part of the measurement, not footnotes

- **The parser is 0.9.0-alpha.2, not 0.9.1.** It is an *instrument*, never an
  oracle. The eleven ledgered differences are in `../../current-0.9.1-spec/DELTAS.md`;
  rows 1 (tab-in-indent) and 2 (root `:key`) are hit by these probes and are
  flagged where they appear.
- **`BlankLine` carries empty content bytes but denotes `"\n"`** (the text-wire
  recast). `classify` substitutes the newline. Summing its literal bytes instead
  manufactures a false text-law defect across ~170 corpus cases — this was a real
  bug in the first version of this instrument, corrected before any table was
  written, and is called out here so the next person doesn't rediscover it as a
  finding.
- **Comment bodies are emitted as `Text` events.** So text-preservation alone
  does not distinguish prose from comment content; the structure check
  (`CommentStart`) is what separates them, and structure is evaluated first.
- **Verbatim bodies arrive as `RawContent`, not `Text`.** `classify`'s text
  total therefore *excludes* them by design — a block-verbatim case will show a
  large text/input delta while losing nothing. Use `events` for those.
- `analyze.py` deliberately does **not** re-implement CORE §7.2 as a scoring
  oracle. Writing an ever-more-elaborate oracle would quietly make this script
  the spec. Cases are labeled by observable mechanism; the tables assign
  register (LAW / PINS CURRENT PARSER / OPEN / DIVERGENCE) in prose, with cites.

## Reproduce

```bash
cd v2/spikes/markdown/probes

# 0. corpus (already vendored as commonmark-spec-0.31.2.txt; re-fetch if you like)
curl -sL -o commonmark-spec-0.31.2.txt https://spec.commonmark.org/0.31.2/spec.txt

# 1. build (depends on ../../../../core/udon-core by path; its own workspace,
#    so it never perturbs core/'s fixture gate)
cargo build --release

# 2. probe 1 — the CommonMark corpus, both framings
python3 extract_commonmark.py commonmark-spec-0.31.2.txt > out/cases.frame
python3 extract_commonmark.py commonmark-spec-0.31.2.txt --index > out/commonmark-index.tsv
./target/release/classify < out/cases.frame > out/commonmark-root.jsonl
python3 embed_cases.py < out/cases.frame | ./target/release/classify > out/commonmark-embedded.jsonl

python3 analyze.py out/commonmark-root.jsonl out/commonmark-index.tsv
python3 analyze.py out/commonmark-embedded.jsonl out/commonmark-index.tsv \
        --embedded out/commonmark-root.jsonl

# 3. probe 2 — the fence-knot matrix
python3 fence_cases.py > out/fence-cases.frame
./target/release/events < out/fence-cases.frame > out/fence-events.txt

# 4. the glyph probes (GFM + ecosystem constructs the CommonMark corpus lacks)
./target/release/classify < out/glyph-cases.frame
./target/release/classify < out/glyph2-cases.frame
```

## Files

| File | Role |
|---|---|
| `src/classify.rs` | the text-law check; JSONL out, one line per case |
| `src/events.rs` | full event-stream dump per case |
| `extract_commonmark.py` | `spec.txt` → framed cases (converts `→` back to real tabs — load-bearing, tabs are a live anomaly) |
| `embed_cases.py` | re-frames each case as markdown *inside* a `\|doc` element (the real A1/A3 surface) |
| `fence_cases.py` | the 22-case fence-knot matrix; ids are stable and cited by the table |
| `analyze.py` | mechanism classification + section breakdown |
| `out/` | committed results, so the tables are checkable without a rebuild |
| `commonmark-spec-0.31.2.txt` | vendored corpus (652 examples) |

**Stdin framing protocol** (used by both binaries): `<id>\t<byte-len>\n<bytes>\n`,
repeated. Length-framed so case bodies can contain any byte sequence — including
the fence delimiters the probes are about.

## Extending

The cheapest high-value additions, if someone picks this up:

- **GFM's own spec corpus** (tables, strikethrough, task lists, autolinks,
  mentions) — the CommonMark corpus has none of these, which is why the tight-table
  and mention clashes had to be probed by hand.
- **Obsidian / MyST / Quarto** flavored constructs, for the B-regime surfaces.
- A **round-trip** probe: does `text` from an embedded run re-parse to itself?
  (Relevant to C2's fixed-point framing.)

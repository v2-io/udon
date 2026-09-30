# 79 — The raw text: line endings, encoding, byte-order mark, and how columns are counted

## The question

Four small things every lite parser meets before any UDON rule applies:

1. **Windows line endings.** Is `\r\n` a line ending, or is the `\r` part of the line's content?
2. **Encoding.** UTF-8 only? What about a byte-order mark at the start, or bytes that aren't valid UTF-8?
3. **Final newline.** Is a file without a trailing newline complete?
4. **Columns after non-ASCII text.** When an element sits later on a line (`|名前 |b`), what is `b`'s column — counted in characters, bytes, or on-screen width?

## Why lite must decide

These are where parsers in different languages quietly diverge. Lite is for files that people and tools will save on every platform.

## What the texts say

- **0.10.0 §2** (`v2/spec-0.10.00/CORE.md`), same in 0.9.1: "A UDON document is a sequence of Unicode scalar values encoded as UTF-8, divided into **lines** by U+000A. A final line need not end with a newline." "**Column** is the count of leading U+0020 SPACE characters before a line's first other character." Nothing about `\r`, a BOM, invalid bytes, or the column of something that is not at the start of a line.
- **`spec/msc/FULL-EBNF.md`** (demoted, "illustration only"): `NEWLINE = "\n" | "\r\n"`.
- **`_archive/DECIDED.bak.md`**: descent character-class names "(e.g. `<any-newline>` covering \n and \r\n) are part of the design space."
- **0.10.0 §2.1:** sameline elements "occupy their true columns" — the column of `|b` in `|a |b` — so the column of a mid-line position matters, but it is never defined.
- **0.10.0 §13.3:** "a missing final newline is never, by itself, an anomaly."
- **2025-12-31, Joseph** (memorata, `history.jsonl:6451`), to an agent: "'well-formed UDON documents end with newlines' — is this something you imagined from the spec or something?"
- **Tabs, L4** (`v2/DECISIONS.md`): a tab in indentation keeps the line as text with a warning. The 0.7-draft said "Error on mixed indentation." Tabs elsewhere are ordinary content.
- **Old parser (evidence only, probed 2026-09-29):** `|el :a 1\r\n  :b true\r\n` → `a = "1\r"` and `b = "true\r"` — **text**, not the integer 1 and boolean true. It counts columns in characters (UTF-8 continuation bytes don't advance the column: `core/udon-core/src/parser.rs` `advance`), not display width.
- **Old parser, Unicode names** (`core/fixtures/v0.9/pending-unicode.yaml.disabled`): non-ASCII lead bytes are treated as name starts pending a full check.

## Alternatives

### Q1 — `\r\n`

**A — lines end at `\n` only; `\r` is content (0.10.0 as written).**

```udon
|el :a 1⏎        ; ⏎ = \r\n
```
```text
document
└ element el
    a "1\r"
```

**B — `\r\n` is a line ending equivalent to `\n`** (FULL-EBNF). **C — B, and a lone `\r` also ends a line.** **D — `\r` anywhere is reserved in lite** (error, bytes kept).

For B and C: is the original line ending kept anywhere, so a file can be written back byte-for-byte? What does text content contain — `"\n"` or the original `"\r\n"`?

### Q2 — byte-order mark and invalid bytes

**A — a leading U+FEFF is skipped.** **B — it is content** (the first line then starts with an invisible character, so a first-line `|el` would not be an element). **C — it is an anomaly (warning, skipped).**

Invalid UTF-8: **A — error, bytes kept as-is** (keep-everything); **B — replaced with U+FFFD, with a warning**; **C — the whole document is refused.**

### Q3 — final newline

Already stated in 0.10.0 (not an anomaly); listed so lite states it too.

### Q4 — columns after non-ASCII text

```udon
|名前 |b
     |c
```

`|c` is at column 5.

| Counting | Column of `\|b` | `\|c` is… |
|---|---|---|
| characters (Unicode scalar values) | 4 | a child of `b` (5 > 4) |
| UTF-8 bytes | 8 | a sibling of `b` |
| display width (CJK = 2 cells) | 6 | a sibling of `b` |
| grapheme clusters (e.g. `é` written as `e` + combining accent = 1) | — | differs again from characters |

A reader aligns by what they **see** (display width); most parsers count characters or bytes. Alternatives: **A — characters.** **B — display width.** **C — bytes.** **D — in lite, mid-line alignment is only meaningful when everything before it on the line is ASCII; otherwise a warning.**

## Interactions

- [72](72-which-bare-words-are-numbers-booleans-nil.md): `true\r` is no longer `true` under Q1-A.
- [80](80-which-spaces-are-content.md): trailing whitespace.
- [01](01-sameline-element-child-or-value.md): only matters if mid-line elements have columns (alternatives A and C there).
- [12](12-missing-values-and-what-counts-as-valid.md): whether these anomalies make a document not-valid-lite.

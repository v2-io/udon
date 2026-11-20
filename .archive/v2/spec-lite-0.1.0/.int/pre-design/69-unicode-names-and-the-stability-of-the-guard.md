# 69 — Unicode in names: does lite peg a Unicode version, or restrict names, so that "is this line an element?" stays stable?

*Raised by the history survey (files 50-69), 2026-09-29, second continuation. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority. This is the last file of my allotment (62-69).*

## The question

In 0.10.01 the line-start guard for `|` is "followed by `XID_Start`, `[`, `.`, `'`, `{`, or a suffix character" (§3), and bare names continue with `XID_Continue`, `-`, `/` (§5.2). `XID_*` is a Unicode property, and Unicode adds characters every release. CORE says: "Recognizers MUST declare the Unicode data version resolving `XID_*`; non-ASCII identifiers are non-portable across differing declarations" (carve-out UNI: "which Unicode version's tables govern bare names/keys/traits… a declared host decision").

For a **stable** subset that is a distinctive problem. It is not only that a non-ASCII *name* might be valid in one parser and not another: the guard makes the same bytes **structure or prose** depending on the table.

```udon
|𐴀𐴁 a line whose first letter was added in a recent Unicode release
```

Under a parser whose tables predate the letter, `|` is followed by a non-`XID_Start`, so the line is text (the Markdown-table protection); under a newer one it opens an element named `𐴀𐴁`. The same document parses to different trees on two conforming recognizers, with no anomaly on either.

## Alternatives

### A — per-recognizer declared Unicode version (0.10.01)

Recognizer states its version; portability of non-ASCII names is the author's problem. Simple for implementers (use the host library's tables), and the ASCII case is unaffected. The divergence above is real but confined to characters new in recent releases.

### B — lite pins one Unicode version in the spec (and states how it is bumped, if ever)

Portable across recognizers; stable subset semantics. Cost: recognizers can't just use the host's tables (Rust `unicode-ident`, Python `str.isidentifier`, and so on each track their own version) and must carry a frozen table or a version check.

### C — lite restricts unquoted names to ASCII (`[A-Za-z_][A-Za-z0-9_-/]*` or similar); any other name is quoted (`|'名前'`)

No Unicode dependency in the guard at all. Cost: a Latin-centric lite; non-English authors must quote every non-ASCII name and key (the identity `[key]` slots in real documents include non-ASCII? I did not check; the vivarium lexicon uses Latin terms). Quoted names already exist for anything else (`|'weird name'`).

### D — "a letter" is defined by a small stable rule instead of `XID_*`: any code point ≥ U+0080 that is not whitespace, punctuation or a control (a *negative* definition), so future additions never change the answer

Stable and Unicode-version-free, but permissive: emoji, symbols, and typographic punctuation would start names unless excluded, which means enumerating an exclusion set (which is a table again, but one that stops growing).

## What the history shows

- **Joseph, 2025-12-25** (line 5688 and the following): "Feel free to come up with your own convention for unicode-alphabet characters if you need"; asked for a `\p{L}`-style character class inside descent rather than helper functions (5694, 5713, 5722, 5723: "Depending on the current usage of LETTER, you may just want to extend it to handle unicode letters"; the goal is to remove UDON-specific unicode helpers from the parser generator).
- **Joseph, 2025-12-26/28**: the name `is_label_start` bothered him because it sounded like a generic unicode-helper but names a grammar concept — "something that should be defined in the grammar / state-machine — which is what knows what a 'label' is and what it would start with" (5906); LABEL_CONT "defined better as a character-class derived from LETTER" (6138).
- **Joseph, 2025-12-31**: "improved descent — which also should have all of the unicode stuff you need for proper element and attribute names" (6561).
- **Joseph, 2026-07-14**, on EBNF feedback (16163): the exact identifier set "is much more well defined in the descent grammar — it's some sort of unicode-identifier-set or something — someone can research and back port it to the grammar"; and (16193): *"Please add that the version of unicode that xid/xlabel get pegged to is a parser/host language decision (which I believe is a companion document to the full-spec that explicitly covers what are parser / schema / dialect / core / host-language / app-level decisions?)"*. That is where 0.10's "declared host decision" comes from. Nothing found in the history weighs the *guard-stability* consequence above.
- Dec 2025 analysis and README: no discussion of ASCII-only names as a design option; the early notes (2011 `DECIDED.md`) speak of "id, class, attribute key" without a character set.

## Sub-questions

- Case: are `|Note` and `|note` the same name, and are `[Jw]` / `[jw]` the same key? No text I found says (`CORE` is silent on case folding); a consumer-level choice today. Normalization form (NFC vs NFD) of a key that is *typed* by an editor that decomposes accents has the same shape: two byte-different keys that read identically. Duplicate-key policy ([54](54-duplicate-keys.md)) compares bytes today as far as I can tell.
- Does the answer also govern *traits* and *attribute labels*, or does quoting (`:'…'`) make labels immune (K12 lets attribute labels contain a large punctuation set unquoted; see [06](06-suffix-characters.md), [76-names-and-labels-which-characters](76-names-and-labels-which-characters.md) from the other survey, unread)?
- If C or D, does the same rule pick the letters that the `@` and `:` guards test?

## Interactions

[06](06-suffix-characters.md), [08](08-pipes-and-markdown-tables.md) (the guard is the Markdown-table protection), [54](54-duplicate-keys.md), [09](09-reserved-syntax.md).

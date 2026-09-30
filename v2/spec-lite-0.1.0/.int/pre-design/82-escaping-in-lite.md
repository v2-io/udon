# 82 — Which escapes does lite have, and where do they work?

## The question

File 02 asks one case (an escaped character in the middle of an open value). This file asks the whole set: which `\` forms exist in lite, where each works, and what each produces.

```udon
\|not an element               ; 1. line starts with an escaped marker
|p see \|{em x} literally      ; 2. escaped inline opener in prose
|el :count \7 apples           ; 3. escaped first character of a value
|el :a words \ rest of line    ; 4. " \ " — the rest of the line is plain text
|el |x
   \     indented output        ; 5. "\" as a column anchor for indented text
|el :empty \                   ; 6. "\" at end of line = empty string
\\starts with a backslash      ; 7. doubled
|el :path C:\Users\me          ; 8. backslash in the middle of a word
```

## Why lite must decide

Escapes are the one feature every author needs occasionally and nobody remembers. Lite can carry the full 0.10.0 set, a smaller set, or reserve the less obvious forms so a later version can choose — and each lite parser must agree on the exact bytes that come out.

## What the texts say, in date order

- **2011, `udon-c/docs/DECIDED.md`:** no general escape; "To have a key start w/ colon just double it up at the beginning"; `(…)` "protected/shielded" values.
- **Dec 2025, 0.7-draft** (`_archive/SPEC.md` §Literal Escape): the apostrophe was the escape at line start — `'|this-is-not-an-element`, `''literal-apostrophe`; semicolons: "Sameline/embedded: use backslash to escape a literal `;`."
- **Jul 2026, 0.8.0-alpha.1** (CHANGELOG): "Escaping unified to one positional rule: a `\` at head position forces the line to prose (consumed; anchors indent); in prose flow a `\` before an inline opener `|{` / `!{` / `;{` makes it literal; anywhere else `\` is literal. Retires the old `'`-escape."
- **2026-07-15** (CHANGELOG 0.9.0-alpha.1): `\`-forced text is "dead to line-level structure and to the sameline-comment frame, alive to inline forms (`|{…}` etc., individually escapable)."
- **2026-08-08, ESC-BREAKOUT / K10**, Joseph: "One of the primary uses of `\` was to break out of attribute-value pairs on sameline" (full quote in file 71).
- **2026-08-09, K13** (`v2/DECISIONS.md`): two operators the old rules conflated ("another relic of before-the-simplification times"): **framed ` \ `** (space before, space or end of line after) makes the rest of the line text — "THAT's what commit-to-text-mode was meant for"; **attached `\X`** escapes one character and the line's machinery stays live; "mid-token `\` is literal (`C:\Users\me`)"; `\\x` → `\x`.
- **2026-07-19 ruling:** `:a \` at end of line is a kept empty string, "peer to `:a ""`".
- **0.10.0 §4:** the column-anchor idiom: "A framed line-initial `\` occupies no column: the text after it backs into the `\`'s own column, and … that column becomes the content base."
- **0.10.1 spelling grid, note 6** (`spec-0.10.01/working-notes/spelling-grid.md`): "`:a \7 hundred :b 2` → `a="7 hundred", b=2`; `:a \ 7 hundred :b 2` → `a="7 hundred :b 2"`. A real visual hazard, mitigated by highlighting and by both forms keeping every byte; under discussion."
- **0.10.0 §6.6:** a framed ` ; ` after a `\`-text inside `|{…}` "is unspecified this version." 0.10.1 audit D10: does a framed `\` inside `|{…}` also swallow the closing `}`?
- **D9** (`msc/for-joseph/01-PLAIN-DECISIONS.md`): the `EscapeOutsideHeadPosition` advisory "describes nothing after K13".

## Alternatives

### A — the full 0.10.0 set (cases 1–8 as in 0.10.0 §4)

```text
1.  text "|not an element\n"
2.  text "see |{em x} literally\n"
3.  count "7 apples"
4.  a "words" · $main "rest of line"
5.  text "    indented output\n"        ; the \ column is the text's left edge
6.  empty ""
7.  text "\\starts with a backslash\n"   ; i.e. one backslash
8.  path "C:\\Users\\me"                 ; i.e. backslashes kept
```

### B — one-character escapes only (cases 1, 2, 3, 7, 8); the framed ` \ ` forms (4, 5, 6) are reserved in lite

```text
4.  reserved "\\ rest of line"      ; anomaly: error, reserved
```

### C — one-character escapes, plus `:a \` as empty string; no "rest of line" operator; no column anchor

### D — a different single rule: `\` escapes the next character everywhere outside quoted strings (so `C:\Users` must be `C:\\Users`)

## Sub-questions under any alternative

- In "rest of line is text" mode (case 4), do inline elements `|{…}` still work (0.9: yes) or is everything literal (0.10.0 wording: "dead to markers")?
- Does `\` escape a `]` inside `[…]` or a `}` inside `|{…}`?
- What about a `\` before a character that is not structural at that spot (`\a`)? (0.10.0: literal backslash.)

## Interactions

- [02](02-escape-inside-open-value.md): case 3 when a value is already open.
- [71](71-how-far-an-unquoted-value-runs.md): the " \ " breakout exists because of the value-extent rule.
- [75](75-quoted-strings.md): no escapes inside quoted strings.
- [81](81-structure-inside-an-indented-text-block.md): the column anchor sets the text's left edge.
- [10](10-inline-elements-and-inline-comments.md): `\|{` in prose.

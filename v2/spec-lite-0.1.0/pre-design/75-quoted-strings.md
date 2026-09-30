# 75 — Quoted strings: what can a quoted string contain, and how

## The question

UDON quotes with `"…"` or `'…'`, and (in 0.10.0) nothing inside a quoted string is ever an escape. So how does an author write a string that contains **both** kinds of quote, a newline, or a tab — which JSON strings can hold and which a JSON alternative therefore needs?

```udon
|q :say "She said 'it's fine' and "?     ; how, with no escapes?
```

## Why lite must decide

Any JSON document converted to lite must survive: `{"say": "She said \"hi\" and it's fine"}`. Every lite parser has to agree on where a quoted string ends and what bytes it holds. Multi-line strings are file 05; this file is about the inside of a single string and the quote characters themselves.

## What the texts say

- **2011, `udon-c/docs/DECIDED.md`:** strings used a "PROTECTED/SHIELDED" parenthesis form; "if you want an unmatched parenth … you're out of luck in label contexts. Use freeform in value contexts." Undecided list: "All the '..' vs ".." vs `..` stuff." 2011 overview line-table: `|"data`, `|'data`, `` |`data `` with different escape behavior per quote kind.
- **Dec 2025, 0.7-draft** (`_archive/SPEC.md`): "Inside quoted strings (`"..."` or `'...'`), the escape prefix has no special meaning — quoted strings handle their own escaping per their delimiter rules" (the rules themselves unstated).
- **2026-07-20, L2** (`v2/.archived/second-pass/RULING-SUPPLEMENT.md` §L2; `v2/DECISIONS.md` L2): three options — **A** no escapes, end at the next same quote, use the other quote kind; **B** `\\` and `\"` only; **C** doubling (`""`), rejected because `["x""y"]` is "ALREADY two items". Lean A, adopted. Stated limit: "a string needing *both* quote kinds has no single-line spelling and waits for multi-line/verbatim forms."
- **0.10.0 §11.3:** "hosts MUST NOT invent core escapes"; `'` "delimits strings, names, and quoted labels" (§4); a quoted item's closing quote ends it: `["x"y]` is two items (§11.5).
- **0.10.1 audit, gap D13:** "Adjacent strings in a slot: `:x "a""b"` (lists rule it two items; slots say nothing)."
- **Old converter** (`bin/xml2udon` `format_attr_value`): wraps values containing either quote kind in `"…"` and "escape[s] internal quotes" — i.e. writes `\"`, which 0.10.0 does not recognize.

## Alternatives

### A — no escapes; a string ends at the next same quote (L2, 0.10.0)

```udon
|q :a "it's" :b 'say "hi"' :c "C:\new"
```
```text
document
└ element q
    a "it's"
    b "say \"hi\""
    c "C:\\new"            ; backslash kept as written
```

A string with both kinds (or a newline) has to be written some other way — for example as a value on the following lines (file 74) or in a `<…>` box (file 07), if those allow it.

### B — backslash escapes the quote and itself only

```udon
|q :a "She said \"hi\" and it's fine" :c "C:\\new"
```
```text
    a "She said \"hi\" and it's fine"
    c "C:\\new"            ; one backslash
```

Consequence: `"C:\new"` must be written `"C:\\new"`, or `\n` stays two characters — the rule has to say which.

### C — doubling: `""` inside `"…"` is one `"`

```udon
|q :a "She said ""hi"""
```

Collides with adjacent quoted items (`["x""y"]` is two items today).

### D — JSON-style escapes (`\"` `\\` `\n` `\t` `\uXXXX`)

Makes JSON round-trip exact; makes `\` mean different things inside and outside strings.

### E — no escapes in lite, and a string containing a quote of its own kind is refused (error, bytes kept)

Keeps the future free to pick B, C or D.

## Smaller edges any alternative has to state

```udon
|el :a ""                     ; empty string
|el :a "abc"def :b 1          ; closing quote, then more letters with no space
|el :a "x" "y"                ; two strings in one slot: two values (stacked)? error?
|el :a "unclosed :b 1         ; unclosed at end of line (file 05)
|el :a “curly”                ; typographic quotes: ordinary text?
|el :a `backtick`             ; backticks: ordinary text? (they open a fence at line start)
|'weird name' :'odd label' x  ; single quotes also quote element names and labels (file 76)
```

## Interactions

- [05](05-values-across-lines.md): whether a quoted string may contain a newline by spanning lines.
- [02](02-escape-inside-open-value.md) and [82](82-escaping-in-lite.md): how `\` behaves outside strings.
- [86](86-mapping-to-json-xml-yaml.md): JSON strings can hold any character.

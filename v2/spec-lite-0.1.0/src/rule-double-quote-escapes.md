---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: value
strength: decided
context: rule-double-quote-escapes.context.md
per: [decided-for-this-version]
depends: [def:delimited-string, rule:strings-like-ruby]
consequences: []
---

# Escapes in «double-quoted-string»s

*In a «double-quoted-string» a backslash must begin one of a fixed list of «escape-sequence»s; any other is an error.*

## Statement

1. In a «double-quoted-string», `\` MUST begin one of: `\\` `\"` `\'`; `\n` `\t` `\r` `\f` `\e`; `\/` `\#`; `\0` (only when no digit follows); `\xHH` (exactly two hex digits, at most `7F`); `\uHHHH` (a high-then-low surrogate pair is one code point; a surrogate not in such a pair is an error); or `\u{…}` (hex code points, `_` and leading zeros allowed as in integers, each at most `10FFFF` and not a surrogate, single spaces between). Any other backslash is an error.

## Grounds

Serves [[obj:represent-structured-data]]: every character JSON and YAML strings carry has a spelling. Debated and decided; see the [context](rule-double-quote-escapes.context.md) file. `\b` is refused only "for right now" (provisional); the `\u{…}` spacing details are a default nobody has discussed (provisional). Revisit as needed.

## Implications

- `"C:\Users"` is an error, not `C:Users`: write `'C:\Users'` or `"C:\\Users"`.
- Regex habits fail loudly instead of changing meaning: `"\s+"` and `"\bword\b"` are errors (`'\s+'` keeps the backslash).
- No octal escapes: `"\033"` is an error; use `"\e"`.
- JSON text containing `\b` (backspace) fails until `\b` is allowed.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|q :a "tab\there" :b "\u{1F600}" :c "\e[1m"
|q :d "C:\Users"
```
```tree
root
  |q
    :a "tab\there"
    :b "😀"
    :c "\u{1B}[1m"
✗ error unknown-escape 2:10   ← "\U isn't an escape; use '…' for literal backslashes, or \\"
```

## Discussion

- **Unknown escapes are errors, not dropped.** Ruby silently drops the backslash of an unknown escape; lite refuses it, so a mistyped path or pattern is caught where it is written.
- **No octal**, for the same reason bare `0755` is decimal: a leading zero means nothing special anywhere in lite.
- **`\s` and `\b` refused**, so `"\s+"` and `"\bword\b"` can't silently turn into a space or a backspace.
- **Surrogates only in pairs**: a lone surrogate is not a character, and JSON's paired `\uD83D\uDE00` still works.

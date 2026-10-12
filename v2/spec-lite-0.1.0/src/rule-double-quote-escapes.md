---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: value
per: []
depends: [rule:strings-like-ruby]
consequences: []
---

# Escapes in double-quoted strings

*In `"…"` a backslash must begin one of a fixed list of escapes; any other is an error.*

## Statement

1. In a `"…"` string, `\` MUST begin one of: `\\` `\"` `\'`; `\n` `\t` `\r` `\f` `\e`; `\/` `\#`; `\0` (only when no digit follows); `\xHH` (exactly two hex digits, at most `7F`); `\uHHHH` (a high-then-low surrogate pair is one code point; a surrogate not in such a pair is an error); or `\u{…}` (hex code points, `_` and leading zeros allowed as in integers, each at most `10FFFF` and not a surrogate, single spaces between). Any other backslash is an error.

## Grounds

- "go ahead and error on unknown escape sequences in """ (Joseph, 2026-10-08): [[rule:strings-like-ruby]].
- The list: `.int/escape-sequences-2026-10-08.md`, with his answers — `\s` an error ("agree"), surrogate pairs ("agree"), `\v` and `\a` dropped ("I can support"), `\b` reserved ("I'm fine erroring as reserved for right now").
- No octal escapes, for the same reason bare `0755` is decimal.

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

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

## Working notes

- **Joseph's words:**

  > ruby strings:  right--- no interpolation, #{} gets passed through as normal text, and go ahead and error on unknown escape sequences in "".
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)
  > escape sequence responses
  > 1. agree
  > 2. agree about the surrogate pairs
  > 3. I can support dropping \v and \a
  > 4. It sure makes certain terminal behavior easier by having it instead of ansi sequences... (like animated character). That said, I'm fine erroring as reserved for right now.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** An unknown escape that Ruby would silently drop (`"C:\Users"` → `C:Users`) becomes a loud error pointing at single quotes. `\s` and `\b` are refused so regex habits (`"\s+"`, `"\bword\b"`) can't silently turn into a space or a backspace.
- `\b` is reserved "for right now"; Joseph noted it helps terminal output.
- The `\u{…}` spacing details are an agent default, not his words.
- The lone-surrogate error was part of the lean he answered "agree about the surrogate pairs" (`.int/escape-sequences-2026-10-08.md` §2.2: "accept a correctly ordered high-low pair as one code point and … refuse a lone surrogate").

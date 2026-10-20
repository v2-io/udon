---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: value
per: [decided-for-this-version]
depends: [def:string]
consequences: [rule:adjacent-quoted-strings, rule:no-interpolation, rule:double-quote-escapes, rule:single-quote-escapes, rule:quoted-element-and-attribute-names, rule:newline-in-string-is-error, def:string]
---

# Quoted strings read as Ruby strings

*`"…"` and `'…'` make a «string» read essentially as Ruby reads it, closed at the next unescaped matching quote. Nothing inside quotes is UDON syntax.*

## Statement

1. A `"…"` or `'…'` string MUST be read as Ruby reads a string literal of the same quote, except as the other string cards say (no interpolation; the escape lists). The result is a «string», a single piece.
2. Inside a quoted string, every character other than the closing quote and an escape is a character of the string. An embed spelling (`|{`, `@{`, `;{`) or any other UDON spelling inside quotes MUST NOT be recognized.

## Grounds

- Joseph, 2026-10-08: "I think "..." and '...' should essentially be just like ruby strings (including escape sequences in "" but not in '', and including within the special constructs for labels, e.g. `|'something "hey"\'' weird node name`), different than our "general matching + escaping" for arrays, typed values, keys, and embeds."
- Joseph, 2026-10-08, on its two edges: "ruby strings: right--- no interpolation, #{} gets passed through as normal text, and go ahead and error on unknown escape sequences in ""."
- Clause 2: Joseph, 2026-10-20, on the summary that an embed inside quotes is just characters, `"\|{"` an error, `'\|{'` literal: "ok, that all seems correct for now."

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|q :a "it's" :b 'say "hi"' :c "|{em x} and @{faq}"
```
```tree
root
  |q
    :a "it's"
    :b "say \"hi\""
    :c "|{em x} and @{faq}"
```
`:c` holds a «string» of plain characters; an embed is only ever a piece of a «text» ([[rule:embeds-in-text]]).

## Discussion

- **Why Ruby's rules.** A string that could hold neither both quote kinds nor a newline on one line would leave values with no spelling; Ruby's quoting is one agents already read fluently, and "essentially" leaves room for lite's departures: no interpolation ([[rule:no-interpolation]]), a fixed escape list in `"…"` where an unknown escape is an error rather than Ruby's silent drop ([[rule:double-quote-escapes]]), and `'…'` taking only `\'` and `\\` ([[rule:single-quote-escapes]]).
- **Why strings and the bracketed forms differ.** Keys, lists, typed values and embeds keep their own matching-and-escaping rule; quoted strings are the place for arbitrary characters.
- **Costs accepted.** Windows paths and regular expressions need doubled backslashes in `"…"`, or `'…'`. A single-quoted string can't hold a newline at all. JSON strings containing `\b` are errors until `\b` is allowed. Ruby writers lose octal escapes (`"\033"`; use `\e`), `\s`, and the silent drop of unknown escapes.
- **Reopen when** a Ruby escape proves surprising in practice, or `\b` is wanted (Joseph: "It sure makes certain terminal behavior easier by having it instead of ansi sequences... (like animated character)").

## Working notes

- Not discussed: a closing quote followed directly by letters (`:a "abc"def`). By the value rules it is the «string» `"abc"` then the «text» `def`; whether it also warns, as `"x""y"` does ([[rule:adjacent-quoted-strings]]), is open.

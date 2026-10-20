---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: value
strength: decided
context: rule-strings-like-ruby.context.md
per: [decided-for-this-version]
depends: [def:string, def:delimited-string, obj:represent-structured-data]
consequences: [rule:adjacent-quoted-strings, rule:no-interpolation, rule:double-quote-escapes, rule:single-quote-escapes, rule:quoted-element-and-attribute-names, rule:newline-in-string-is-error, def:string]
---

# «delimited-string»s read as Ruby strings

*A «delimited-string» is read essentially as Ruby reads a string literal of the same quote, closed at the next unescaped matching quote. Nothing inside the quotes is UDON syntax.*

## Statement

1. A «double-quoted-string» or «single-quoted-string» MUST be read as Ruby reads a string literal of the same quote, except as the cards listed under *Decisions carried* say. The result is a «string», a single piece.
2. Inside a «delimited-string», every character other than the closing quote and an «escape-sequence» is a character of the string. An embed spelling (`|{`, `@{`, `;{`) or any other UDON spelling inside the quotes MUST NOT be recognized.

## Decisions carried

This card states two decisions, and is the umbrella for six more, each with its own card:

- Ruby's reading of a quoted literal, closed at the next unescaped matching quote (clause 1).
- No UDON syntax inside the quotes, embeds included (clause 2).
- In `"…"`, a fixed list of escape sequences; any other backslash is an error, reserved for later ([[rule:double-quote-escapes]]).
- In `'…'`, only `\'` and `\\`; every other backslash is literal ([[rule:single-quote-escapes]]).
- No interpolation: `#{…}` is characters ([[rule:no-interpolation]]).
- A raw line ending inside the quotes is an error; `\n` writes one in `"…"` ([[rule:newline-in-string-is-error]]).
- Quoted element and attribute names are read by these same rules ([[rule:quoted-element-and-attribute-names]]).
- Two delimited strings with nothing between them are two values, with a warning ([[rule:adjacent-quoted-strings]]).

## Grounds

Serves [[obj:represent-structured-data]]: the strings JSON and YAML carry may hold any character, and escapes give every one of them a one-line spelling. Debated and decided; see the [context](rule-strings-like-ruby.context.md) file. Revisit as needed.

## Implications

- Text holding both quote kinds, tabs or newlines has a one-line spelling: `"say \"hi\"\tthen\nleave"`.
- A backslash in `"…"` must start a listed escape. Windows paths and regular expressions double their backslashes there, or use `'…'`: `'C:\Users\me'`, `'\d+'`.
- A «single-quoted-string» can't hold a line ending at all.
- JSON text containing `\b` fails in lite until `\b` is allowed; octal escapes (`"\033"`) don't exist (use `\e`).
- To make an element, reference or comment part of a value, leave the value unquoted: `"|{em x}"` is a «string» of seven characters, while `|{em x}` unquoted is a «text» holding an inline element.

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

## Discussion

- **Why Ruby's rules.** Without escapes some values have no one-line spelling at all. Ruby's quoting is one agents already read fluently, and "essentially" leaves room for lite's departures: no interpolation, a fixed escape list where an unknown escape is an error rather than Ruby's silent drop, and `'…'` taking only `\'` and `\\`.
- **Why quotes and brackets differ.** Keys, lists, typed values and embeds keep their own matching-and-escaping rule; delimited strings are the place for arbitrary characters.
- **Reopen when** a Ruby escape proves surprising in practice, or `\b` is wanted (for terminal output).

## Working notes

- Not discussed: a closing quote followed directly by letters (`:a "abc"def`). By the value rules it is the «string» `"abc"` then the «text» `def`; whether it also warns, as `"x""y"` does, is open.

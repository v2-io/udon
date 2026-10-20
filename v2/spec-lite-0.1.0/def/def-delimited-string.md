---
kind: definition
awaiting-second: true
awaiting-decision: false
needs-work: false
strength: decided
context: def-delimited-string.context.md
terms:
  delimited-string: {pos: noun, pl: -s}
  double-quoted-string: {pos: noun, pl: -s}
  single-quoted-string: {pos: noun, pl: -s}
  escape-sequence: {pos: noun, pl: -s}
per: []
depends: [def:string, rule:strings-like-ruby]
consequences: [rule:strings-like-ruby]
---

# delimited-string · double-quoted-string · single-quoted-string · escape-sequence

*A «delimited-string» is a value written between matching quotes, `"…"` or `'…'`; what it gives in the tree is a «string». An «escape-sequence» is a backslash and what follows it, standing for one character, in a form that defines it.*

## Terms

- **delimited-string:** a value written between a pair of matching quotes: a «double-quoted-string» or a «single-quoted-string». It is the spelling; the value it gives in the «tree» is a «string» ([[def:string]]). It is read by [[rule:strings-like-ruby]]: it ends at the next unescaped quote of its own kind, holds no UDON syntax, and must close on the line it opens.
- **double-quoted-string:** a «delimited-string» written `"…"`. A backslash in it must begin one of a fixed list of «escape-sequences» ([[rule:double-quote-escapes]]).
- **single-quoted-string:** a «delimited-string» written `'…'`. Only `\'` and `\\` are «escape-sequences» in it; every other backslash is a literal backslash ([[rule:single-quote-escapes]]).
- **escape-sequence:** a backslash and the characters after it that, together, stand for a single character, in a form that defines it. The «tree» holds the character, never the sequence. Each form has its own set:
  - in a «double-quoted-string», the list in [[rule:double-quote-escapes]] (`\n`, `\t`, `\"`, `\u{…}`, …);
  - in a «single-quoted-string», `\'` and `\\`;
  - in `<…>`, `@{…}` and `;{…}`, `\\` and the form's own delimiters ([[rule:opaque-span-escapes]]); in a key, `\\`, `\[` and `\]` ([[rule:key-escapes]]);
  - on an element's or attribute's line, a set still to settle ([[rule:value-line-escapes]]);
  - in prose, a backslash before an embed opener ([[rule:prose-escaped-embeds]]).

  A backslash first on a line, and a framed ` \ ` that ends sameline text, are not escape sequences: they stand for no character ([[rule:line-start-escape]], [[rule:text-value-end]]).

## Invariants

- Which quote was used is not part of the «string»: `"it's"` and `'it\'s'` give the same value.
- A «delimited-string» never holds an embed or any other UDON construct.

## Examples

```udon
|v :a "tab\there" :b 'C:\dir' :c "|{em x}"
```
`:a` is a «double-quoted-string» with the «escape-sequence» `\t`; `:b` a «single-quoted-string» whose backslash is literal; `:c` a «double-quoted-string» of seven plain characters.

## Avoid

- **"quoted string"** as a defined term: harmless as plain English, but every «delimited-string» is quoted, so it adds nothing.
- **"string literal"** for the value: the literal is the spelling, the «string» is what the tree holds.
- **"literal string"** for `'…'`: TOML's name for its single-quoted strings, which take no escapes at all; lite's take two.
- **"raw string"**: Rust and KDL use it for strings with no escapes; lite has none.
- **"delimited"** alone for these: `<…>`, `@{…}` and `;{…}` are delimited too, but are not strings ([[def:opaque-span]]).

## Working notes

- Open: whether «string» needs its own definition at all. The plan: change every mention that means the spelling to «delimited-string», then see what is left of «string» ([[def:string]]) and whether it needs a definition.
- Open: «escape-sequence» covers the prose and sameline escapes above only if those are settled to stand for a character; if the sameline set stays undecided, its bullet waits.

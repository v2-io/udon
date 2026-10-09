---
kind: definition
awaiting-second: true
awaiting-decision: false
needs-work: false
terms: [string]
per: [quoted-strings-like-ruby, embeds-are-pieces-of-text]
depends: []
consequences: [def:text, rule:key-holds-a-value, rule:list-items-whitespace-separated, rule:strings-like-ruby]
---

# string

*A «string» is a value written in quotes: one piece, never broken up by embedded forms.*

## Terms

- **string:** a value written `"…"` or `'…'`, following Ruby's quoting with lite's escape list ([[decision:quoted-strings-like-ruby]]). It holds characters only: an embedded form inside quotes is just characters.

## Invariants

- A «string» and a «text» are different kinds of value, even when they hold the same characters: `:a "hello"` gives a «string», `:a hello` a «text».
- Which quote was used is not part of the value.

## Examples

```udon
|v :a "say \"hi\"" :b 'C:\dir' :c "|{em x}"
```
```tree
root
  |v
    :a "say \"hi\""
    :b "C:\\dir"
    :c "|{em x}"
```

## Working notes

- **Joseph's words** (2026-10-08/09, `.int/STEWARD-VERBATIM.md`):
  > I think "..." and '...' should essentially be just like ruby strings (including escape sequences in "" but not in '', and including within the special constructs for labels, e.g. `|'something "hey"\'' weird node name`), different than our "general matching + escaping" for arrays, typed values, keys, and embeds.

  > I do worry about "string" being its own distinct type from "text" :-)

- Joseph asked (2026-10-09) whether string, text and prose are now clearly defined; the coordinator's answer (string and text are value kinds, prose is a source region) is awaiting his reply. His worry that "string" being a distinct type from "text" may not serve consumers stays open: a reading option could present a text without embeds as a string.
- Trees use the notation of `.int/ast-notation-proposal-a.md`, provisionally.

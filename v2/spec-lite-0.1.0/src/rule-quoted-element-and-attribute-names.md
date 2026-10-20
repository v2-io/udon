---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: element
strength: decided
context: rule-quoted-element-and-attribute-names.context.md
per: [decided-for-this-version]
depends: [def:delimited-string, rule:strings-like-ruby]
consequences: []
---

# Quoted element and attribute names follow the «delimited-string» rules

*An element name or attribute name written in quotes is read by the same rules as a «delimited-string» of that quote.*

## Statement

1. A quoted element name (`|'…'`, `|"…"`) or quoted attribute name (`:'…'`, `:"…"`) MUST be read by the same rules as a «delimited-string» of that quote.

## Grounds

One quoting rule wherever quotes appear ([[prin:one-rule-everywhere]]). Debated and decided; see the [context](rule-quoted-element-and-attribute-names.context.md) file. Revisit as needed.

## Implications

- Any name a bare label can't spell can be quoted: `|'weird name'`, `:"data[1]"`, `:'@click'`.
- The escapes are the string escapes: `|'it\'s'`, `:"tab\there"`.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|'something "hey"\'' weird node name
```
```tree
root
  |"something \"hey\"'"
    :$main ‹weird node name›
```

## Working notes

- Open, with the label characters: what a quoted name may hold beyond "anything except newlines": control characters, perhaps only through escapes in `"…"`; invalid code points; whether a `\n` escape is allowed in a name. Whether quoted traits exist (`.'ns.kind'`), and whether a quoted name is always the same name as its bare spelling, are open there too.

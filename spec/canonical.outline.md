# UDON Specification

This specification specifies UDON: which source texts are UDON, and what each one says. What a text says is given as its AST, so that two parsers can be compared by what they produce for the same text.

This is the canonical outline: what the specification consists of, in reading order. It is written for someone implementing a parser. Each row uses only what comes before it.

> [!LEGEND]
> - `mark`: **provisional** (suggested; not accepted by Joseph), **accepted**, **gap** (known missing; what fills it is not known).
> - `def`: `present` (a file in `def/`), `inline` (the description is the whole definition; no file), `–` (nothing written yet).
> - `term`: a link to `def/<term>.md`, or for an inline row the plain word. In prose a term with a file is written «term»; an inline word is written plainly.

## Part I: What a parse produces

| mark | def | term | description |
|---|---|---|---|
| provisional | inline | document | UDON source text, as given to a parser. |
| provisional | inline | node | Any item in an AST. |
| provisional | present | [[def/element\|element]] | A node with an optional name, attributes in written order, and children in written order. |
| provisional | inline | root | The one element in an AST that is inside no other. Being the root is a position, not a kind of node. |
| provisional | inline | AST | What parsing a document produces: its root, and everything the root holds. |

## Working Notes

- The five rows were put here on 2026-11-20 by a Claude Fable 5.2 session. Joseph has not accepted any.
- Next, in this order: attribute, value, text, string. Not rows yet.
- "AST" is used before its row, in the rows for node and root. The alternative order (AST first) uses "root" and "element" before theirs. Lean: leave it; the three rows are adjacent.

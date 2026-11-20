---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
strength: provisional
terms:
  SPACE: {pos: noun, pl: -S}
  NO-BREAK-SPACE: {pos: noun, pl: -S}
  TAB: {pos: noun, pl: -S}
  LINE-FEED: {pos: noun, pl: -S}
  CARRIAGE-RETURN: {pos: noun, pl: -S}
  BACKTICK: {pos: noun, pl: -S}
  TILDE: {pos: noun, pl: -S}
  PIPE: {pos: noun, pl: -S}
  COLON: {pos: noun, pl: -S}
  SEMICOLON: {pos: noun, pl: -S}
  BACKSLASH: {pos: noun, pl: -ES}
  DOUBLE-QUOTE: {pos: noun, pl: -S}
  SINGLE-QUOTE: {pos: noun, pl: -S}
  DOT: {pos: noun, pl: -S}
  AT: {pos: noun}
  BANG: {pos: noun, pl: -S}
per: []
depends: []
consequences: []
---

# Named characters

*Each character lite's syntax gives a role has one upper-case name, so spec text and grammar productions can say «BACKTICK» instead of fighting Markdown to show `` ` ``.*

## Terms

| Name | Character | Code point and Unicode name |
|---|---|---|
| **SPACE** | (space) | U+0020 SPACE |
| **NO-BREAK-SPACE** | (no-break space) | U+00A0 NO-BREAK SPACE |
| **TAB** | (tab) | U+0009 CHARACTER TABULATION |
| **LINE-FEED** | (line feed) | U+000A LINE FEED |
| **CARRIAGE-RETURN** | (carriage return) | U+000D CARRIAGE RETURN |
| **BACKTICK** | `` ` `` | U+0060 GRAVE ACCENT |
| **TILDE** | `~` | U+007E TILDE |
| **PIPE** | `\|` | U+007C VERTICAL LINE |
| **COLON** | `:` | U+003A COLON |
| **SEMICOLON** | `;` | U+003B SEMICOLON |
| **BACKSLASH** | `\` | U+005C REVERSE SOLIDUS |
| **DOUBLE-QUOTE** | `"` | U+0022 QUOTATION MARK |
| **SINGLE-QUOTE** | `'` | U+0027 APOSTROPHE |
| **DOT** | `.` | U+002E FULL STOP |
| **AT** | `@` | U+0040 COMMERCIAL AT |
| **BANG** | `!` | U+0021 EXCLAMATION MARK |

## Invariants

- A name stands for exactly one code point. Sets of characters (whitespace, line endings, label characters) get names of their own, defined by these and by Unicode properties.
- In a grammar production the name is the terminal: `fence-opener ← BACKTICK BACKTICK BACKTICK+`.

## Working notes

- **Proposed by Joseph, 2026-10-20:** "we can also, grammar-like, do some early aliases like «BACKTICK» = {`} or something". This card is the coordinator's first draft of it; nothing in it is reviewed.
- **Why upper case** (the coordinator's lean): it tells a character name from a concept at a glance («BACKTICK» vs «fence»), and it is how grammars write terminals.
- **Why these names and not Unicode's:** Unicode's names say what the glyph is (GRAVE ACCENT, REVERSE SOLIDUS, VERTICAL LINE); these say what a writer calls it. The Unicode name stays in the table, so nothing is ambiguous.
- Not yet listed: the brackets (`[` `]` `{` `}` `<` `>`), `$`, `#`, `-`, `+`, and the Unicode line terminators other than LF and CR. Add them as cards need them, rather than listing all of ASCII.
- Open: whether a fence's TILDE spelling is lite at all ([[rule:fence-opens-with-backticks]], working notes).

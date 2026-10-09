---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [embeds-are-pieces-of-text, representational-options]
depends: [rule:text-value-end]
consequences: [rule:space-between-embeds, rule:inline-comments-kept, rule:inline-comments, rule:prose-escaped-embeds, rule:prose-passes-through]
---

# Embedded forms are pieces of text

*`|{…}`, `@{…}` and `;{…}` are never values of their own.*

## Statement

`|{…}`, `@{…}` and `;{…}` MUST be pieces of the text they appear in, even when they are the first or only thing in a value position.

## Grounds

- Joseph, 2026-10-09: "I am very comfortable having embeds always be a distinct chunk of distinct text as if it were a word for right now, yes" ([[decision:embeds-are-pieces-of-text]]).

## Epistemic status

Decided for this version ("for right now").

## Explanation

```udon
|el :x |{em hi}
|book :author @{people/jw}
```
````tree
root
  |el
    :x ‹|{em ‹hi›}›
  |book
    :author ‹@{people/jw}›
````
Reading a one-piece text as its piece is a reading option ([[def:reading-option]]).

## Working notes

- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > I am very comfortable having embeds always be a distinct chunk of distinct text as if it were a word for right now, yes. Don't forget comments show up in the AST
- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > Under this understanding, the above should give   nav $main  text[embedded_node(a...),' ',embedded_node(a...)] or something.
- `|{a :href / Home}` gives `href` the text `/ Home` and the link no text: an example to watch for and avoid (Joseph, 2026-10-09; [[rule:inline-element-reads-like-a-line]]).

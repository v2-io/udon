---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [embeds-are-pieces-of-text, inline-comments-in-prose]
depends: [rule:embeds-in-text]
consequences: []
---

# `;{…}` comments are kept in the tree

*An inline comment is a piece of its text, even when empty.*

## Statement

A `;{…}` comment MUST be kept in the «tree» as a piece of its text.

## Grounds

- Joseph, 2026-10-09: "Don't forget comments show up in the AST"; `:n ;{}` is "a text AST node with an empty comment as its only inner part".

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|el :n ;{} :m 1
|p
  Second line ;{todo} here.
```
````tree
root
  |el
    :n ‹;{}›
    :m 1
  |p
    ‹Second line ;{todo} here.›
````

## Working notes

- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > Don't forget comments show up in the AST
- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > I'm fine with `:n ;{}` yielding a text AST node with an empty comment as its only inner part.

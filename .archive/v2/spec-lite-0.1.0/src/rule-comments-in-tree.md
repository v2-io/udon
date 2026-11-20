---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:comment-blocks, rule:framed-comments, rule:fence-line-comments, rule:inline-comments, rule:embeds-in-text]
consequences: []
test-fixtures: []
---

# Comments are in the tree

*Comments appear in the «tree».*

## Statement

Every comment — a comment block, a framed comment, a fence-line comment, and a `;{…}` piece — MUST appear in the «tree».

## Grounds

- Joseph, 2026-10-09: "Don't forget comments show up in the AST" ([[rule:embeds-in-text]]).

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > I am very comfortable having embeds always be a distinct chunk of distinct text as if it were a word for right now, yes. Don't forget comments show up in the AST-- actually, before we go any further, would you propose or have an agent look at everything and propose a quick syntax/notation for expressing the AST here in chat and in the spec and in the fixtures (all the same ideally if it's elegant enough, but with big or minor differences acceptable if necessary).
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 581)

- **Why it matters** (the drafter's reasoning): Comments are a tier of voice, carried for maintainers, not discarded.

- How each kind appears (a comment node, a piece of text) is shown in each card's example; the shape is [[def:node]]'s.
- Consequence: a `;` comment line between two text lines splits the text, because the comment sits between them in the tree (Joseph, 2026-10-09: "a clear 'yes' by virtue of the fact that comments are preserved in the AST").

  ```udon
  |p
    first
    ; note
    second
  ```
  ````tree
  root
    |p
      ‹first›
      ; " note"
      ‹second›
  ````

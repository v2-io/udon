---
kind: rule
awaiting-second: true
awaiting-decision: true
needs-work: false
layer: tree
per: []
depends: [rule:framed-comments, rule:comment-block-owns-deeper-lines]
consequences: []
---

# Lines deeper than a framed comment's `;` belong to the comment, with a warning

*A framed ` ; ` comment owns the following lines indented past its `;`, like a comment block; the parser warns.*

## Statement

A line indented deeper than the column of a framed ` ; ` comment's `;` MUST be part of that comment, and the parser MUST report a «warning».

## Grounds

- Joseph, 2026-10-09 (a lean): "my lean for the sameline inner comment column with children that are indented more than the ';' column: correct-- child comments (and rare, and *warn*)- to keep block and column reasoning pristine. For humans it won't be a huge deal because the syntax highlighter automatically makes something like that obvious, but the warning will keep it from being used as an obfuscation technique or something else that's dishonest."

## Epistemic status

Joseph's lean. **The Statement is the agent's reading of "child comments", awaiting his confirmation:** lines past the `;` column are the comment's, as a `;` line owns its deeper lines ([[rule:comment-block-owns-deeper-lines]]); lines deeper than the element but not past the `;` stay the element's children.

## Explanation

```udon
|el :a 1 ; note
  |child
|el2 ; note
         more
```
````tree
root
  |el
    :a 1
    ; " note"
    |child
  |el2
    ; " note\nmore"
````
Warning at 4:10: a line under a framed comment's `;` column is comment text.

## Working notes

- Why it matters (the agent's): 0.10.0's wording ("a line comment owns everything indented deeper than it") left open whether `|el ; note` swallows `|el`'s whole body (0.10.1 audit A6). Measuring from the `;` column keeps the element's body its own.
- How continuation lines are stripped is not discussed (shown stripped to the first continuation line's column).

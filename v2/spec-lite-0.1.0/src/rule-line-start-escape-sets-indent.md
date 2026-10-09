---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [backslash-by-position]
depends: [rule:line-start-escape, rule:text-left-edge]
consequences: []
test-fixtures: []
---

# The line-start escape sets the indentation

*The column of a line-start `\` counts as the line's indentation.*

## Statement

The column of a line-start `\` MUST count as the line's indentation, as the first character of text would.

```udon
|p
  \    indented on purpose
  next line
```
```tree
root
  |p
    ‹    indented on purpose
    next line›
```

## Grounds

- [[decision:backslash-by-position]]: "including escaping just a newline (and thereby also setting the indent level...)".

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > If it's the first thing on a line then it is an escape (and is consumed / not part of the text but probably in meta) -- including escaping just a newline (and thereby also setting the indent level...) and this is distinct from it coming *after* some text which, as noted, in sameline closes `text`, and on a line that is not sameline and already has prose it is just passed through like everything else except embeds.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 609)

- **Why it matters** (the drafter's reasoning): It lets a text line start with spaces on purpose, or with a marker, without the line's indentation being misread.

- Whether the spaces after the `\` are content (shown kept, as in 0.10.0's column-anchor idiom) was not discussed in this session.

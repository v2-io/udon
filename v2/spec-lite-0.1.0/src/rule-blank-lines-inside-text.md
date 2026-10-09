---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:text-lines-join, rule:blank-line-sets-no-indent]
consequences: []
test-fixtures: []
---

# Blank lines inside text are text

*A blank line between two text lines is part of the text: its newline, and any whitespace past the left edge.*

## Statement

A blank line between two lines of the same text MUST be part of that text: its line ending, and any whitespace beyond the text's left edge.

```udon
|node some $main prose
    child prose section starting...
      
    more prose...
```
```tree
root
  |node
    :$main ‹some $main prose›
    ‹child prose section starting...
      
    more prose...›
```

(Line 3 holds six spaces; the text is `"child prose section starting...\n  \nmore prose..."`.)

## Grounds

- [[rule:blank-line-sets-no-indent]], with Joseph's example and his reassembled text.

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > That reminds me-- if it's not already a rule or planned-- we need to make sure we explicitly denote "blank lines" distinct from (a superset with) "empty lines" -- blank lines do *not* change indent levels. In some cases whitespace on blank lines is considered ornamentation, in some cases it can be part of prose:
  >
  > ```udon
  > |node some $main prose
  >     child prose section starting...
  >       
  >     more prose...
  > ```
  >
  > Line 3 there has 6 whitespaces. The reassembled text from the AST would be: "child prose section starting...\n  \nmore prose..."
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 351)

- **Why it matters** (the drafter's reasoning): Blank lines never move indentation, so whitespace on them past the left edge can only be content.

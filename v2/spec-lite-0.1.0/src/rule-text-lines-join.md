---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:prose-passes-through]
consequences: [rule:text-final-line-ending, rule:blank-lines-inside-text, rule:edge-blank-lines, rule:main-and-body-separate]
test-fixtures: []
---

# Text lines join into one text

*Consecutive text lines under the same owner form one text, joined by their line endings.*

## Statement

Consecutive text lines under the same owner MUST form one text, each line's line ending (other than the last line's) being part of it.

```udon
|p
  Line one
  line two
```
```tree
root
  |p
    ‹Line one
    line two›
```

## Grounds

- 0.10.0's text law (each text line's terminator is part of its text), unchanged in this session: Joseph, 2026-10-09, "That's kind of a crucial thing to udon and the spec-- newline handling"; the coordinator confirmed these rules are 0.10.0's §7.2/§7.4, unchanged.

## Epistemic status

A rule carried from 0.10.0 and reaffirmed in this session without a decision record of its own.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > 2. `|p Hello` I would have thought would be |p with an attribute $main="Hello".  Is this question asking about default behavior of $main? I don't understand your third list item as I thought that was decided by $main vs $children as well. That's kind of a crucial thing to udon and the spec-- newline handling-- I thought it would be super clear by now and I'm now very worried that it seems it's not properly understood or documented?
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 541)

- **Why it matters** (the drafter's reasoning): Newline handling in text is, in his words, "a crucial thing to udon and the spec".

- No decision record yet; add one, or cite 0.10.0 formally.
- Not discussed: whether a `;` comment line between two text lines splits the text in two.

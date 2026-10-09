---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [reserved-line-starts-in-prose]
depends: [rule:text-left-edge]
consequences: []
test-fixtures: []
---

# A marker line deeper than the left edge is text

*A line deeper than an established left edge is text, even if it starts with a marker.*

## Statement

A line deeper than an established text left edge MUST be text, even if it starts with a marker such as `|name`.

```udon
|doc
  Intro text.
    |Name|Role|
```
```tree
root
  |doc
    ‹Intro text.
      |Name|Role|›
```

## Grounds

- [[decision:reserved-line-starts-in-prose]]: `|Name|Role|` is "parsed as a node unless indented further than that in prose that has already started".

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > 1.  I vote for strict-lean except ' ; ' only counts as a comment when part of sameline and with at least one space on each side. Comments: available on node or attribute started lines, and available as their own block, which also comments everything in that block that is indented further as per the usual with blocks and the indentation. (a), (b) => error,  (c) passed through + reference,  (d) passed through, (e) parsed as a node unless indented further than that in prose that has already started or escaped with \ or a space after the first pipe.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 290)

- **Why it matters** (the drafter's reasoning): Once prose has started, a deeper line is part of it; a marker there is the prose's own text, such as a Markdown table row.

- Whether this holds for every marker (`:label`, `;`, a fence, reserved starts) was not discussed beyond the `|` case; 0.10.0 said yes for all.

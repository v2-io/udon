---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [framed-comments-on-node-lines]
depends: [rule:prose-passes-through]
consequences: []
test-fixtures: []
---

# A ` ; ` partway along text is text

*A ` ; ` partway along a line of prose is part of the text.*

## Statement

A ` ; ` partway along a prose line MUST be part of the text.

```udon
|p
  Keep calm ; carry on.
```
```tree
root
  |p
    ‹Keep calm ; carry on.›
```

## Grounds

- [[decision:framed-comments-on-node-lines]]: "(d) passed through"; the history in `.int/history-semicolon-in-text-2026-10-08.md` found no rationale for 0.10.0's contrary wording.

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > 1.  I vote for strict-lean except ' ; ' only counts as a comment when part of sameline and with at least one space on each side. Comments: available on node or attribute started lines, and available as their own block, which also comments everything in that block that is indented further as per the usual with blocks and the indentation. (a), (b) => error,  (c) passed through + reference,  (d) passed through, (e) parsed as a node unless indented further than that in prose that has already started or escaped with \ or a space after the first pipe.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 290)

- **Why it matters** (the drafter's reasoning): Prose uses ` ; ` as punctuation; making it a comment would silently cut sentences.

- Row notes on table rows are written with `;{…}` ([[rule:inline-comments]]).

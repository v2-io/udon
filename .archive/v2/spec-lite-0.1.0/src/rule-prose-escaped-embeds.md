---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:embeds-in-text, rule:prose-passes-through]
consequences: [rule:prose-passes-through]
test-fixtures: []
---

# Escaped embedded forms in prose

*In prose, `\|{`, `\@{` and `\;{` are literal text, with the `\` consumed.*

## Statement

In prose, a `\` immediately before an embedded form's opener (`|{`, `@{`, `;{`) MUST make that opener literal text, and the `\` MUST be consumed.

```udon
|p
  See \|{em this} written literally, and |{em this} as an element.
```
```tree
root
  |p
    ‹See \|{em this} written literally, and |{em ‹this›} as an element.›
```

## Grounds

- [[rule:prose-passes-through]]: "escaped embeds are literal passthrough with the escape consumed."

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > 3. Agreed, 100%, ruled. Leading `\` (after any whitespace) on a prose line is read special (and consumed), embeds are detected, and escaped embeds are literal passthrough with the escape consumed. (And, within prose, those are the only behaviors we specify other than the indent/dedent stuff, if memory serves correctly...)
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 650)

- **Why it matters** (the drafter's reasoning): Without it there would be no way to write `|{`, `@{` or `;{` literally in prose.

- In the tree notation, a literal `|{` inside `‹…›` is itself printed escaped (`\|{`), so the transcript line looks like the source; the text holds `|{em this}`.

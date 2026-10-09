---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [backslash-by-position, prose-backslash-and-embeds]
depends: []
consequences: [rule:prose-passes-through, rule:line-start-escape-sets-indent, rule:lone-backslash-line]
test-fixtures: []
---

# The line-start escape is consumed

*A `\` that is the first non-space character of a line is consumed and is not part of the text.*

## Statement

A `\` that is the first non-space character of a line MUST be consumed: it is not part of any text. Its position MAY be kept in «meta».

```udon
|p
  \|not an element
  \@alice said so.
```
```tree
root
  |p
    ‹|not an element
    @alice said so.›
```

## Grounds

- [[decision:backslash-by-position]]: "If it's the first thing on a line then it is an escape (and is consumed / not part of the text but probably in meta)".
- [[decision:prose-backslash-and-embeds]]: "Leading `\` (after any whitespace) on a prose line is read special (and consumed)".

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > If it's the first thing on a line then it is an escape (and is consumed / not part of the text but probably in meta) -- including escaping just a newline (and thereby also setting the indent level...) and this is distinct from it coming *after* some text which, as noted, in sameline closes `text`, and on a line that is not sameline and already has prose it is just passed through like everything else except embeds.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 609)

  > 3. Agreed, 100%, ruled. Leading `\` (after any whitespace) on a prose line is read special (and consumed), embeds are detected, and escaped embeds are literal passthrough with the escape consumed. (And, within prose, those are the only behaviors we specify other than the indent/dedent stuff, if memory serves correctly...)
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 650)

- **Why it matters** (the drafter's reasoning): The same character that ends text on a same-line run escapes a line when it comes first; the position decides the job.

- That a leading `\` before a marker or a reserved start (`\|`, `\@`) is how such a line is written as text is the drafter's reading of "escape", consistent with Joseph's "don't use them, including by properly escaping them" (2026-10-09).

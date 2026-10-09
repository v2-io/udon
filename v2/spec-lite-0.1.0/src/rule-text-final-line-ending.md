---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [backslash-by-position]
depends: [rule:text-lines-join, rule:lone-backslash-line]
consequences: []
test-fixtures: []
---

# A text's final line ending is not content

*The last line's line ending is not part of a text; a lone `\` line keeps one.*

## Statement

The line ending of a text's last line MUST NOT be part of the text.

```udon
|a
  line one
  line two
|b
  line one
  line two
  \
```
```tree
root
  |a
    ‹line one
    line two›
  |b
    ‹line one
    line two
    ›
```

## Grounds

- 0.10.0 §7.4 "final-terminator disposition" (ornamental, trimmed), reaffirmed in this session.
- [[decision:backslash-by-position]]: the trailing ` \` that kept a final line ending in 0.10.0 is gone; a lone `\` line is the way to keep one ([[rule:lone-backslash-line]]).

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > 1. it depends on the answer to "border/boundary blank lines" -- whether we preserve those as part of prose or consider them ornamentation. If we consider them ornamentation (probably right), then wouldn't we need a trailing \ to override that? (that's a genuine question asking for your thoughts and lean and for what's missing)
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 595)

  > Ahhh- you're right-- we already have a workaround for prose blank lines at boundaries-- the *leading* escape (at the right indent level)...  OK, I'm comfortable dropping trailing backslash *as a reserved construct that errors for now*-- except when it is the only non-blank thing on the line == leading backslash. Is that coherent, first, before recording it?
  >
  > — Joseph (session transcript `293bb1ee`, not yet carried into `.int/STEWARD-VERBATIM.md`)

- **Why it matters** (the drafter's reasoning): A final line ending is almost always layout; keeping it would make every text end in a newline nobody meant.

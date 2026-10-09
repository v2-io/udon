---
kind: rule
awaiting-second: true
awaiting-decision: true
needs-work: false
layer: tree
per: [backslash-by-position]
depends: [rule:text-lines-join]
consequences: []
test-fixtures: []
---

# Blank lines at a text's edges are not text

*Blank lines before a text's first line or after its last are layout, not content.*

## Statement

A blank line before a text's first line or after its last line MUST NOT be part of the text. It MAY be kept in «meta».

```udon
|section

  First paragraph.

  |note A child
```
```tree
root
  |section
    ‹First paragraph.›
    |note
      :$main ‹A child›
```

## Grounds

- Joseph, 2026-10-09: "If we consider them ornamentation (probably right)"; the lone-`\` workaround ([[rule:lone-backslash-line]]) was accepted on that basis.
- 0.10.0 §7.4: leading and trailing blank lines at structure boundaries are ornamentation.

## Epistemic status

A rule resting on Joseph's "probably right"; no decision record states it outright.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > 1. it depends on the answer to "border/boundary blank lines" -- whether we preserve those as part of prose or consider them ornamentation. If we consider them ornamentation (probably right), then wouldn't we need a trailing \ to override that? (that's a genuine question asking for your thoughts and lean and for what's missing)
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 595)

  > Ahhh- you're right-- we already have a workaround for prose blank lines at boundaries-- the *leading* escape (at the right indent level)...  OK, I'm comfortable dropping trailing backslash *as a reserved construct that errors for now*-- except when it is the only non-blank thing on the line == leading backslash. Is that coherent, first, before recording it?
  >
  > — Joseph (session transcript `293bb1ee`, not yet carried into `.int/STEWARD-VERBATIM.md`)

- **Why it matters** (the drafter's reasoning): Writers leave a blank line before the next child out of habit; if it were text, layout would silently change content.

- Record it as a decision, or ask him.
- Not discussed: where an edge blank line sits in «meta».

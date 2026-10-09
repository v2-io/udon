---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [backslash-by-position]
depends: [rule:line-start-escape, rule:text-left-edge]
consequences: [rule:text-final-line-ending]
test-fixtures: []
---

# A lone `\` line is an empty line of text

*A line holding only `\` gives an empty line of text; spaces before it past the text's left edge are kept.*

## Statement

A line whose only non-space character is `\` MUST give an empty line of text. Spaces before the `\` that sit past the text's left edge MUST be kept as content.

```udon
|p
  first
    \
  last
```
```tree
root
  |p
    ‹first
      
    last›
```

## Grounds

- [[decision:backslash-by-position]], with Joseph's yes to `"first\n  \nlast"` ("I'm pretty sure it stays coherent").
- It is the way to keep a blank line at a text's edge, or a final line ending ([[rule:text-final-line-ending]]).

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > If it's the first thing on a line then it is an escape (and is consumed / not part of the text but probably in meta) -- including escaping just a newline (and thereby also setting the indent level...) and this is distinct from it coming *after* some text which, as noted, in sameline closes `text`, and on a line that is not sameline and already has prose it is just passed through like everything else except embeds.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 609)

  > And yes to your #3 there above-- I'm pretty sure it stays coherent that the rules would imply that p's children would, when combined, be: "first\n  \nlast"
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 611)

  > Ahhh- you're right-- we already have a workaround for prose blank lines at boundaries-- the *leading* escape (at the right indent level)...  OK, I'm comfortable dropping trailing backslash *as a reserved construct that errors for now*-- except when it is the only non-blank thing on the line == leading backslash. Is that coherent, first, before recording it?
  >
  > — Joseph (session transcript `293bb1ee`, not yet carried into `.int/STEWARD-VERBATIM.md`)

- **Why it matters** (the drafter's reasoning): Edge blank lines are layout, so an author who wants a blank line kept at a text's edge needs a visible way to say so; the lone `\` is it.

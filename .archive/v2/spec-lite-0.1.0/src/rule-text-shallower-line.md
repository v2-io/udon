---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [errors-stop-parsing]
depends: [rule:text-left-edge, rule:text-dedent, rule:fence-body-dedent]
consequences: []
test-fixtures: []
---

# A shallower text line warns and moves the edge

*A text line shallower than the left edge, still inside its owner, is text with a warning, and the edge moves to it.*

## Statement

A text line shallower than the left edge, but still inside its owner, MUST be read as text with a «warning», and the left edge MUST move to its column. Lines already read keep the stripping they got.

```udon
|parent-node |child-node
             child-prose
         still-child-prose
             another-one
```
```tree
root
  |parent-node
    |child-node
      ‹child-prose
      still-child-prose
          another-one›
```

Warning: line 3, text shallower than its left edge.

## Grounds

- Joseph, 2026-10-08 ([[rule:fence-body-dedent]]): `still-child-prose` "also now parsed without its own indent, but there's a warning issued".
- [[decision:errors-stop-parsing]]: this is one of the anomalies that stays a warning (the drafter's reading there, matching his example).

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > Decision A:  We should allow nested fences via backtick count >= 3 is my strong preference.  Is there a standard? I know, for example, that we will not want to follow markdown's standard (in some versions) of requiring that a fence be at the beginning of a line or the first non-whitespace of a line-- we need its indent (including sameline) to decide whose child it is. As for *inner* [indentation] retention-- the "markdown rule" would be extremely easy to implement by essentially saying that the "parent's indent column" is (in 1-indexed columns) 0, therefore the normal udon parsing takes effect:
  >
  > ```text
  > |parent-node |child-node
  >              child-prose (parsed without its own indent, just "child-prose...")
  >          still-child-prose (also now parsed without its own indent, but there's a warning issued, "still-child-prose...")
  >              another-one (no warning, "    another-one...")
  > very-dedented prose: normally in udon this line would be a *sibling* to |parent-node-- closing |parent-node in the tree first. Under my proposal for fences, this would act the same as [still-child-prose]-- a warning that it's dedented further than the earlier lines, and outputs without its own indent, because the only way to close this node is via the appropriate number of backticks.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 318)

- **Why it matters** (the drafter's reasoning): The text still reads; the warning says the author probably didn't mean the shift.

- A line at or left of the owner's own column is ordinary nesting ([[rule:nesting]]): Joseph's "very-dedented prose: normally in udon this line would be a *sibling* to |parent-node".

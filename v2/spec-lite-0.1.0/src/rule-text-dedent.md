---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:text-left-edge, rule:fence-body-dedent]
consequences: [rule:text-shallower-line]
test-fixtures: []
---

# Later text lines lose the left edge's width

*Each later text line loses the left edge's width of leading spaces; spaces beyond it are content.*

## Statement

Each later text line MUST lose the left edge's width of leading spaces; spaces beyond the edge MUST be kept as content.

```udon
|parent-node |child-node
             child-prose
                 another-one
```
```tree
root
  |parent-node
    |child-node
      ‹child-prose
          another-one›
```

## Grounds

- Joseph, 2026-10-08 ([[rule:fence-body-dedent]]): `another-one` "no warning, \"    another-one...\"".

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

- **Why it matters** (the drafter's reasoning): Text written indented under its owner reads without that indentation.

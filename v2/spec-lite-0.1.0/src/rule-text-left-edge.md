---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:nesting, rule:blank-line-sets-no-indent, rule:fence-body-dedent, rule:main-is-attribute]
consequences: [rule:line-start-escape-sets-indent, rule:lone-backslash-line, rule:text-dedent, rule:text-shallower-line, rule:deeper-marker-lines-are-text, rule:fence-body-dedent, rule:top-level-text-left-edge]
test-fixtures: []
---

# The first text line sets the left edge

*The first non-blank text line under an owner sets the text's left edge at its column.*

## Statement

The first non-blank text line under an owner MUST set that text's left edge at its column. An element's `$main` text sets no left edge.

```udon
|el Title text
     body starts here
     and continues
```
```tree
root
  |el
    :$main ‹Title text›
    ‹body starts here
    and continues›
```

## Grounds

- Joseph, 2026-10-08, describing "normal udon parsing" to define the fence rule ([[rule:fence-body-dedent]]): `child-prose` "parsed without its own indent".
- [[rule:main-is-attribute]]: `$main` is an attribute; it is not a text line.

## Epistemic status

A rule resting on Joseph's description of text dedent, recorded inside the fence decision rather than a text decision of its own.

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

- **Why it matters** (the drafter's reasoning): This is "normal udon parsing" as Joseph describes it; the fence rule borrows it.

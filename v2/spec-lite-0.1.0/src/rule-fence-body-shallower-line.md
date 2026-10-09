---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [fence-body-indentation]
depends: [rule:fence-body-dedent]
consequences: []
test-fixtures: []
---

# A shallower fence body line warns and moves the edge

*A fence body line shallower than the body's left edge warns, and the edge moves to it.*

## Statement

A fence body line shallower than the body's left edge MUST give a «warning», and the edge MUST move to its column; lines already read keep the stripping they got.

````udon
|parent-node ```ruby
    #!/bin/bash ruby
 puts "hmmmm"
```
````
```tree
root
  |parent-node
    ```ruby "#!/bin/bash ruby\nputs \"hmmmm\"\n"
```

Warning: line 3, fence body line shallower than its left edge.

## Grounds

- [[decision:fence-body-indentation]]: Joseph's example, "(warning but both lines output with no indentation at all)".

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

  > Excellent. I agree completely with your leans as my leans:   normal first-inner-sets-indent+warn-on-dedent   +   '-' suffix for verbatim & all dent changes in meta.   And for the closer-- *transparent to fence body* (i.e., comes *after* the end of the fenced body), indent level sets new current indent level, with dedenting/closing etc. as appropriate. I'll leave it up to you whether or not to allow a ' ; ' comment after the backticks on the same line, but recommend an error/failure on anything else.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 467)

- **Why it matters** (the drafter's reasoning): The same "warn and move" as text, so one dedent rule serves text and fences.

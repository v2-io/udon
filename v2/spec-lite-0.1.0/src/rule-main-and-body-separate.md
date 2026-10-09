---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:text-lines-join, rule:main-is-attribute]
consequences: []
test-fixtures: []
---

# `$main` and the text below are separate

*An element's own-line text and the text below the element are different values and are never joined.*

## Statement

An element's `$main` text and a text child below the element MUST NOT be joined.

```udon
|p Intro text
  more text
```
```tree
root
  |p
    :$main ‹Intro text›
    ‹more text›
```

## Grounds

- [[rule:main-is-attribute]]: "The element's own line and the text below it are different places, so they never merge."

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > You can see from the record that it took me quite a while to be reconciled with $main, and then I tried to back out of it again more recently, only to realize the more I thought about all of the edge cases etc. that it really did solve so much:  sameline (whether started with a node or an attribute) started to converge on a simple set of "node nesting + attributes-and-values" -- so "children", yes-- if they are nodes nested in a parent node. *text children* -- never due to how it complicates everything. While I ended up swinging back to being in favor of / reconciled with $main as long as the AST interactions can make it transparently effectively the first child if/when expected -- it grew on me for other reasons-- [mostly] the fact that in practice, text on the same line as the node it's associated with has a different semantic meaning than children text. From a data structure perspective it often tends to be more like the "name" or heading or something-- not the same semantic space as indented child text. In practice, one rarely pulls text from a block up onto the node's line just to save a newline. THAT SAID-- if it turns out that we all end up using $main as the first child all the time anyway and that the concerns about text complicating sameline behavior turn out to be unfounded or overstated-- I am absolutely happy to revisit this stance.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 563)

- **Why it matters** (the drafter's reasoning): Sameline text is "more like the 'name' or heading", a different semantic space from indented child text.

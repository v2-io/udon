---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [main-is-an-attribute]
depends: [rule:leftover-values]
consequences: []
---

# `$main` is an attribute in the tree

*Same-line text never becomes a text child.*

## Statement

`$main` values MUST be attributes of their element in the «tree», never text children.

## Grounds

- Joseph, 2026-10-09: "so 'children', yes-- if they are nodes nested in a parent node. *text children* -- never due to how it complicates everything"; same-line text "tends to be more like the 'name' or heading" ([[decision:main-is-an-attribute]]).

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]). Reopen if "we all end up using $main as the first child all the time anyway" (Joseph).

## Explanation

```udon
|p Intro text |em x
  more text
```
````tree
root
  |p
    :$main ‹Intro text›
    |em
      :$main ‹x›
    ‹more text›
````

## Working notes

- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > You can see from the record that it took me quite a while to be reconciled with $main, … sameline (whether started with a node or an attribute) started to converge on a simple set of "node nesting + attributes-and-values" -- so "children", yes-- if they are nodes nested in a parent node. *text children* -- never due to how it complicates everything. … text on the same line as the node it's associated with has a different semantic meaning than children text. From a data structure perspective it often tends to be more like the "name" or heading or something-- not the same semantic space as indented child text. … THAT SAID-- if it turns out that we all end up using $main as the first child all the time anyway and that the concerns about text complicating sameline behavior turn out to be unfounded or overstated-- I am absolutely happy to revisit this stance.
- This replaced the agent's earlier record that made same-line material the first children; that record misread his "child is fine" as covering all elements.
- A reading option may present `$main` as the first child ([[def:reading-option]]).

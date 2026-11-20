---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:leftover-values]
consequences: [def:node, def:reading-option, def:text, rule:main-and-body-separate, rule:text-left-edge]
---

# `$main` is an attribute in the tree

*Sameline text never becomes a text child.*

## Statement

`$main` values MUST be attributes of their element in the «tree», never text children.

## Grounds

- Joseph, 2026-10-09: "so 'children', yes-- if they are nodes nested in a parent node. *text children* -- never due to how it complicates everything"; sameline text "tends to be more like the 'name' or heading".

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

## Discussion

*Carried 2026-10-09 from the decision record `adr/main-is-an-attribute.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-10-08.*

**Context.** An earlier record, `main-material-is-first-children` (now retired), made everything an element's line gives to `$main` the element's first children, marked `same_line`. It rested on a misreading. Joseph's "pick a side (child is fine, I like it)" answered only whether *p*'s text in `|p Intro text |em x` could be a child; the coordinator recorded it as a grant over all sameline material, which in effect removed `$main` from the tree for every element. When the agent asked whether `|p Hello` should give a text child, he answered that he would have expected `$main="Hello"`, then: "Were you suggesting we completely get rid of $main?" He then settled it in his own words. This record replaces that one whole.

**Options considered.**

* `$main` material as first children, marked `same_line`, for every element (the earlier record; invalidated).
* First child only when an element follows on the same line, `$main` otherwise (the agent's "mixed" option; it would move "Intro text" between child and `$main` when ` |em x` is deleted).
* `$main` an attribute, uniformly, as in 0.10.0 (chosen).

**Drivers.**

* `$main` made sameline behavior, whether a line starts with an element or an attribute, converge on "node nesting + attributes-and-values"; text children on the line would complicate everything (Joseph, under the Quote).
* Sameline text has a different meaning from indented child text: "more like the 'name' or heading or something" (Joseph).
* In practice nobody pulls text from a block up onto the element's line just to save a newline (Joseph).

**Assumptions.**

* Sameline text and block text are used differently in practice. (**recorded**: "In practice, one rarely pulls text from a block up onto the node's line just to save a newline.")
* Host and API views can present `$main` as the first child where a consumer expects that. (**recorded**: "as long as the AST interactions can make it transparently effectively the first child if/when expected")

**How firm.** His words: stated directly, with his own reopen condition. His own call, so `steward`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).

**Costs accepted.**

* XML/HTML consumers present `$main` before the children through a view rather than reading it as a child.
* Sameline text and block text are different documents, as in 0.10.0: reflowing between them changes the tree.

**Reopen when.**

* "if it turns out that we all end up using $main as the first child all the time anyway and that the concerns about text complicating sameline behavior turn out to be unfounded or overstated" (Joseph).

**Joseph's words not already quoted on this card.**

> I read it as you only asking about *|p*'s text in `|p Intro text |em x` […] Were you suggesting we completely get rid of $main?
>
> — Joseph, 2026-10-08 (same file, the message before), on the earlier grant's scope
## Working notes

- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > You can see from the record that it took me quite a while to be reconciled with $main, … sameline (whether started with a node or an attribute) started to converge on a simple set of "node nesting + attributes-and-values" -- so "children", yes-- if they are nodes nested in a parent node. *text children* -- never due to how it complicates everything. … text on the same line as the node it's associated with has a different semantic meaning than children text. From a data structure perspective it often tends to be more like the "name" or heading or something-- not the same semantic space as indented child text. … THAT SAID-- if it turns out that we all end up using $main as the first child all the time anyway and that the concerns about text complicating sameline behavior turn out to be unfounded or overstated-- I am absolutely happy to revisit this stance.
- This replaced the agent's earlier record that made sameline material the first children; that record misread his "child is fine" as covering all elements.
- A reading option may present `$main` as the first child ([[def:reading-option]]).

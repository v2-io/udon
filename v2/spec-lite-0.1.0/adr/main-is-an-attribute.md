---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "$main is an attribute in the tree, uniformly; same-line text never becomes a text child"
status: accepted
decided-by: steward
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: [parser implementers, vsect]
wording: rendering
grounds-recorded: at-decision
supersedes: [{adr: main-material-is-first-children, how: invalidated, scope: whole}]
superseded-by: [{adr: embeds-are-pieces-of-text, how: revised, scope: partial}]
closes: ["13 Q3", "53"]
leaves-open: ["13 Q5", "60"]
---

# $main is an attribute in the tree, uniformly; same-line text never becomes a text child

## Context and Problem Statement

[[decision:main-material-is-first-children]] made everything an element's line gives to `$main` the element's first children, marked `same_line`. It rested on a misreading. Joseph's "pick a side (child is fine, I like it)" answered only whether *p*'s text in `|p Intro text |em x` could be a child; the coordinator recorded it as a grant over all same-line material, which in effect removed `$main` from the tree for every element. When the agent asked whether `|p Hello` should give a text child, he answered that he would have expected `$main="Hello"`, then: "Were you suggesting we completely get rid of $main?" He then settled it in his own words. This record replaces that one whole.

## Decision Drivers

* `$main` made same-line behavior, whether a line starts with a node or an attribute, converge on "node nesting + attributes-and-values"; text children on the line would complicate everything (Joseph, under the Quote).
* Same-line text has a different meaning from indented child text: "more like the 'name' or heading or something" (Joseph).
* In practice nobody pulls text from a block up onto the node's line just to save a newline (Joseph).

## Assumptions

* Same-line text and block text are used differently in practice. (**recorded**: "In practice, one rarely pulls text from a block up onto the node's line just to save a newline.")
* Host and API views can present `$main` as the first child where a consumer expects that. (**recorded**: "as long as the AST interactions can make it transparently effectively the first child if/when expected")

## Considered Options

* `$main` material as first children, marked `same_line`, for every element ([[decision:main-material-is-first-children]]; invalidated).
* First child only when a node follows on the same line, `$main` otherwise (the agent's "mixed" option; it would move "Intro text" between child and `$main` when ` |em x` is deleted).
* `$main` an attribute, uniformly, as in 0.10.0 (chosen).

## Decision Outcome

Chosen: `$main` is an attribute of the element in the tree, uniformly. Same-line text never becomes a text child. Nodes written on the line are still children ([[decision:sameline-element-is-child]]).

```text
|p Hello                      → p ($main "Hello")
|p Intro text |em x           → p ($main "Intro text") └ em ($main "x")
|price 42                     → price ($main 42)
|nav |{a :href / Home} |{a :href /about About}
                              → nav ($main a(…), $main a(…))   ; two $main values
```

- **The element's own line and the text below it are different places**, so they never merge: `|later-part This stuff…` followed by aligned lines gives `$main "This stuff…"` and a text child for the lines below (53).
- A host or API view may present `$main` as the element's first child where a consumer expects that. That is a view, not the tree.
- The `$main` parsing rule ([[decision:line-ownership-main]]) is unchanged; `$main` still doesn't begin the element's content for the late-attribute warning.

### Quote

> You can see from the record that it took me quite a while to be reconciled with $main, and then I tried to back out of it again more recently, only to realize the more I thought about all of the edge cases etc. that it really did solve so much:  sameline (whether started with a node or an attribute) started to converge on a simple set of "node nesting + attributes-and-values" -- so "children", yes-- if they are nodes nested in a parent node. *text children* -- never due to how it complicates everything. While I ended up swinging back to being in favor of / reconciled with $main as long as the AST interactions can make it transparently effectively the first child if/when expected -- it grew on me for other reasons-- [mostly] the fact that in practice, text on the same line as the node it's associated with has a different semantic meaning than children text. From a data structure perspective it often tends to be more like the "name" or heading or something-- not the same semantic space as indented child text. In practice, one rarely pulls text from a block up onto the node's line just to save a newline. THAT SAID-- if it turns out that we all end up using $main as the first child all the time anyway and that the concerns about text complicating sameline behavior turn out to be unfounded or overstated-- I am absolutely happy to revisit this stance.
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

> I read it as you only asking about *|p*'s text in `|p Intro text |em x` […] Were you suggesting we completely get rid of $main?
>
> — Joseph, 2026-10-08 (same file, the message before), on the earlier grant's scope

*His words: stated directly, with his own reopen condition. His own call, so `steward`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).*

### Positive Consequences

* Same-line behavior stays one rule: nested nodes and attributes with values.
* The element's "name or heading" text is addressable as a value (`port.$main`).

### Negative Consequences

* XML/HTML consumers present `$main` before the children through a view rather than reading it as a child.
* Same-line text and block text are different documents, as in 0.10.0: reflowing between them changes the tree.

### What changes

* [[decision:main-material-is-first-children]] becomes `superseded`.
* [[decision:line-ownership-main]] and [[decision:sameline-element-is-child]] point here.

## Reopen when

* "if it turns out that we all end up using $main as the first child all the time anyway and that the concerns about text complicating sameline behavior turn out to be unfounded or overstated" (Joseph).

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- 13 Q5 (how text below an element is split into nodes) and whether the tree records `same_line` or other source shape (60) are separate.
- The `|nav |{a} |{a}` example (two `$main` values) is replaced by [[decision:embeds-are-pieces-of-text]]: one `$main` text with three pieces.

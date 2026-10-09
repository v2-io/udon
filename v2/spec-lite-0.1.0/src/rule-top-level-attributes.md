---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:one-root-node, rule:top-level-items-are-root-children]
consequences: []
---

# An attribute line at the top level belongs to the root node

*Top-level attribute lines are allowed; they are attributes of the «root-node».*

## Statement

An attribute line at the top level of a «document» MUST be an attribute of the «root-node».

## Grounds

- Joseph, 2026-10-09 (a ruling): "top-level :labels--- this can now be ruled an emphatic "allowed" -- mostly because it was one of the main advantages of adopting the implicit root node; it also becomes crucial in references and composing multiple udon documents / partials, etc. etc. :attributes that come after prose or node children would give the usual warning."

## Epistemic status

Ruled.

## Explanation

```udon
:title My Notes
:author jw
|section
```
````tree
root
  :title ‹My Notes›
  :author ‹jw›
  |section
````

## Working notes

- An attribute line after top-level prose or a top-level element gets "the usual warning" for an attribute after content; that rule is the gap card `rule:late-attributes`.
- History: 0.9.1 and 0.10.0 kept a top-level attribute line as text with a warning, on the ground of "no phantom owner"; with the implied root there is an owner. Joseph had pointed the same way on 2026-08-07 ("a pseudo root element solves the open "what to do with attributes at top-level" question").
- Not discussed: how attributes the document writes relate to «meta» a parser attaches to the root (a filename). What «meta» covers is open ([[def:meta]]); the earlier claim here that meta is never spelled was dropped with it.

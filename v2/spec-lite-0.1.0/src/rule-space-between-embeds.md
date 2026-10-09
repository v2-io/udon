---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [embeds-are-pieces-of-text]
depends: [rule:embeds-in-text]
consequences: []
---

# Space between embedded forms is text

*Whitespace between two embeds is a run of the text.*

## Statement

Whitespace between embedded forms in a text MUST be part of the text.

## Grounds

- Joseph, 2026-10-08: `|nav |{a} |{a}` "should give nav $main text[embedded_node(a...),' ',embedded_node(a...)]" ([[decision:embeds-are-pieces-of-text]]).

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|nav |{a :href / \ Home} |{a :href /about \ About}
```
````tree
root
  |nav
    :$main ‹|{a :href ‹/› :$main ‹Home›} |{a :href ‹/about› :$main ‹About›}›
````

## Working notes

- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > Under this understanding, the above should give   nav $main  text[embedded_node(a...),' ',embedded_node(a...)] or something.

---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "What an element's line gives to $main lands in the tree as the element's first children, in written order, each marked same_line"
status: superseded
decided-by: delegated
decided: "2026-10-08"
updated: 2026-10-08
deciders: ["udon-team agent (agent, Opus 5.5) under delegated authority (Joseph, 2026-10-08: \"pick a side (child is fine, I like it)\"; no grant slug exists)"]
consulted: [Joseph (steward)]
informed: [parser implementers, vsect]
wording: verbatim
grounds-recorded: at-decision
supersedes: []
superseded-by: [{adr: main-is-an-attribute, how: invalidated, scope: whole}]
closes: ["13 Q3", "53"]
leaves-open: ["13 Q5", "60"]
---

# What an element's line gives to $main lands in the tree as the element's first children, in written order, each marked same_line

## Context and Problem Statement

How an element's line is *parsed* is settled: same-line material that no open label takes goes to `$main`, and attribute lines work the same way ([[decision:line-ownership-main]]). Where that material *lands* in the tree was open (pre-design 13 Q3). 0.10.0 made `$main` an attribute, and sameline text and block text "different documents by design". Joseph's 2026-09-29 lean for lite was the other way: "have first_is_main implied as true … and give that AST node meta saying something like `as_main` or `same_line` = true" (`.int/pre-design/STEWARD-2026-09-29.md`). On 2026-10-08 the agent put both options to him with examples (A: `$main` is an attribute; B: `$main` material becomes the element's first children, each marked `same_line`), leaning B. He delegated the call, stating a preference for B.

## Decision Drivers

* Lite's XML/HTML objective ([[obj:represent-xml-html]]): children in written order are what an HTML or XML reader expects; under A, consumers stitch `$main` back in front of the children, and mixed content on the element's line lives inside an attribute.
* Joseph's own 2026-09-29 lean, and his stated preference under the grant ("child is fine, I like it").
* Same-line siblings: `|nav |{a …} |{a …}` gives two real children, the same-line siblings Joseph wanted in Dec 2025 and on Aug 8.

## Assumptions

* Writers that need the source shape back can rely on `same_line` meta, and trees built by programs can set it. (Joseph, 2026-09-29: "allow sameline=true metadata … for use in generating udon via AST")

## Considered Options

* A. `$main` is an attribute of the element (0.10.0).
* B. `$main` material becomes the element's first children, each marked `same_line` in meta (chosen).

## Decision Outcome

Chosen: B.

- **What an element's line gives to `$main` lands in the tree as the element's first children, in written order**, each carrying `same_line` in its meta.
- **Children may therefore be typed values**: `|price 42` gives `price` one child, the integer 42; `|quote "hello," she said` gives a string child `"hello,"` and a text child `she said`.
- **`|nav |{a :href / Home} |{a :href /about About}`** gives `nav` two children.
- **The `$main` parsing rule (who owns the rest of a line) is unchanged.** In particular, same-line material does not begin the element's content for the late-attribute warning: `|title My Notes` followed by a block `:added <2026-10-01>` gives an ordinary attribute.
- **A tree built by a program may set `same_line`** to ask a writer for same-line output.

```udon
|p Intro text |em emphasized
  more text
```
```text
p
├ text "Intro text"         (meta: same_line)
├ em                        (meta: same_line)
│  └ text "emphasized"      (meta: same_line)
└ text "more text"
```

```udon
|el :a 1 Main text |child
|el
  Main text
  |child
```
Both give `el (a 1) ├ text "Main text" └ child`; they differ only in `same_line` meta.

The grant: Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`):

> I'm happy to leave `|p Intro text |em x` decision whether 'Intro text' is $main or first child with same-line set up to you.  *You* can also potentially leave it open to go either way to the parser implementation. Actually-- pick a side (child is fine, I like it), and note in there that if the parser implementer or later consumer has a compelling argument to switch it, we can definitely revisit.

*The Outcome is the delegate's (the udon-team coordinator's call, written up by the drafting agent). Joseph's stated preference under the grant matches it, and so does his 2026-09-29 lean. Decided for this version ([[decision:decided-for-this-version]]).*

### Positive Consequences

* The tree is in written order, as XML and HTML consumers expect.
* The same-line form and the vertical form give the same tree apart from meta, so reflowing between them is no longer a change of meaning (0.10.0 said the opposite).

### Negative Consequences

* An element's children can hold typed values, not just text and elements.
* "The element's value" becomes "its first child or children"; there is no `port.$main` to ask for.
* Writing a tree back to the same source shape needs the `same_line` meta.

### What changes

* [[decision:line-ownership-main]] and [[decision:sameline-element-is-child]]: `$main` names the parsing rule; in the tree, the material is first children.
* [[rule:line-ownership]] and the tree definitions ([[def:node]]); fixtures show children with `same_line`.

## Reopen when

* The parser implementer or a later consumer has a compelling argument to switch it (Joseph's condition).

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- Open (13 Q5, next): whether a same-line text child and a following block text child are separate nodes or one run, e.g. pre-design 53's `|later-part This stuff…` with aligned continuation lines.
- Whether `same_line` is meta in the tree proper or an optional layer is part of 60 (meta is free to evolve: [[decision:forward-compat-aspiration]]).

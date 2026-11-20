---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Lite specifies the raw tree; representational options (such as $main as first child, or a one-piece text read as its piece) are reading views, not language"
status: accepted
decided-by: supported
decided: "2026-10-09"
updated: 2026-10-09
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: [parser implementers]
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: ["60"]
---

# Lite specifies the raw tree; representational options (such as $main as first child, or a one-piece text read as its piece) are reading views, not language

## Context and Problem Statement

With embedded forms always pieces of text ([[rule:embeds-in-text]]), `:author @{people/jw}` gives a text whose only piece is a reference. The agent proposed a "single-piece rule" in the language: such a text reads as its one piece. Joseph preferred to keep that out of the language spec, as an aspiration for how trees are read, and in the same category as presenting `$main` as a first child ([[rule:main-is-attribute]]). In doing so he named the layers.

## Decision Drivers

* Reading conveniences should not change the language (Joseph, under the Quote).

## Assumptions

* None recorded.

## Considered Options

* A single-piece rule in the language spec (the agent's).
* A reading option, defaulting to on, outside the language (chosen, as an aspiration).
* Value spellings that say "this is the value itself", `|el :x @<other-one>` and `|el :x |<val-node ...>` (Joseph's idea; later, recorded in `obj.future/candidates.md`).

## Decision Outcome

Chosen:

- **The layers:** source → wire/event (opaque in lite) → raw tree → tree as modified by representational options, usually applied during traversal rather than decided in advance.
- **Lite's spec specifies the raw tree.** Representational options are reading views over it, not language.
- **Two options named so far:**
  - presenting `$main` as the element's first child ([[rule:main-is-attribute]]);
  - reading a text whose only piece is one embedded form, in a value slot, as that embedded form. As an aspiration, this option defaults to on.

### Quote

> WRT the "single-piece rule" -- Another option to consider:  `|el :x @<other-one>`   and `|el :x |<val-node ...>` etc.  I like this notation and something we should record, but it is also something that can wait on without disturbing. My lean for lite-0.1.0 is an *aspiration* that a `text` construct with just one embed in a value slot ends up being *processed*/interpreted as if that embed is the value itself (so, kind of pre-emptively having an AST reading flag that defaults to reducing it, in the same category as $main<->children stuff, instead of as part of the language spec). I guess that means in reality we have  source -> wire/event (opaque in lite) -> raw AST -> AST modified by representational-options (usually part of traversal instead of predetermined, I would imagine).
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

*His words: "My lean for lite-0.1.0 is an *aspiration*"; the layers, "I guess that means … I would imagine". Recorded `supported`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).*

### Positive Consequences

* The raw tree stays one shape; conveniences can be added without changing documents.

### Negative Consequences

* Two consumers using different reading options see different shapes for the same document; fixtures must say which they show (the raw tree, by default).

### What changes

* [[decision:ast-centric]]'s working notes point here.
* Fixtures give the raw tree.

## Reopen when

* A reading option turns out to need to be language after all.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- Whether the options are named, standardized, or left to each host is open; so is where `same_line` and other source-shape meta sit relative to the raw tree (60).

---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: [raw-tree, reading-option]
per: [representational-options]
depends: [def:document, def:text, rule:main-is-attribute]
consequences: [rule:tree-transcript]
---

# raw-tree · reading-option

*Lite specifies the «raw-tree». A «reading-option» is a view over it that a consumer may apply, usually while traversing; it is not language.*

## Terms

- **raw-tree:** the «tree» exactly as lite's rules produce it. Fixtures show the «raw-tree».
- **reading-option:** a named way of presenting the «raw-tree» to a consumer. Two are named so far:
  - presenting `$main` as an element's first child;
  - reading a «text» whose only «piece» is one «embed», in a value slot, as that «embed». As an aspiration, this one defaults to on.

## Invariants

- A «reading-option» never changes what a «document» parses to; it changes only how the «raw-tree» is presented.

## Examples

```udon
|el :author @{people/jw}
```
```tree
raw:   :author ‹@{people/jw}›
read:  :author @{people/jw}          ← one-piece text read as its embed
```

## Working notes

- **Not reviewed with Joseph.** Joseph, 2026-10-09: "I haven't looked at any or been asked about any of those things … but the idea that they can just kind of organically be whatever would cause serious trouble really soon if allowed to continue." Every term here is provisional until he rules on it; `.int/lexicon-inventory-2026-10-09.md` lists where each came from.

- **Joseph's words** (2026-10-09, `.int/STEWARD-VERBATIM.md`):
  > My lean for lite-0.1.0 is an *aspiration* that a `text` construct with just one embed in a value slot ends up being *processed*/interpreted as if that embed is the value itself (so, kind of pre-emptively having an AST reading flag that defaults to reducing it, in the same category as $main<->children stuff, instead of as part of the language spec). I guess that means in reality we have  source -> wire/event (opaque in lite) -> raw AST -> AST modified by representational-options (usually part of traversal instead of predetermined, I would imagine).

- Joseph's layering: source → wire/event (opaque in lite) → «raw-tree» → tree modified by «reading-option»s.

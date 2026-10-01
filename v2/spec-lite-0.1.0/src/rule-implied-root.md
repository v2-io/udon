---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [implied-root, ast-centric]
depends: [def:document]
test-fixtures: [implied-root]
---

# The implied root node

*Every «document» has exactly one «root-node». The source never spells it, and what is written at the top level becomes its children.*

## Statement

1. A lite parser MUST produce exactly one «root-node» for each «document».
2. Every node made directly from a top-level item of the source MUST be a child of the «root-node», in source order.
3. No spelling in the source opens, closes, or names the «root-node». A top-level element named `document` or `root` is an ordinary child.
4. A lite parser MAY attach «meta» to the «root-node» that is not written in the source, such as the filename.

## Grounds

- **Decisions.** The rule rests on [[decision:implied-root]] (every document has one implied root node, and everything starts as its children; the root may carry metadata such as the filename) and on [[decision:ast-centric]] (lite is specified as the tree it produces, not as an event stream). Joseph decided both on 2026-09-29. Both are known only as renderings: his words were not located, and no reasoning was recorded with either. Their current text is in `.old/vsect-init/DECISIONS.md`.
- **History.** 2011 udon-c had an implied root, with the file path as its ID and `:__` metadata attributes. From Dec 2025 to Jul 2026 the opposite was held: "No implicit root wrapper", for streaming, fragments, and multi-root (`design/udon-ast.md`, at the udon repository root). The history survey reads the 2026-09-29 decision as answering those three reasons. That is the survey's reading, not a reason recorded with the decision. Source: `.int/pre-design/70-survey-index.md` §04.

## Epistemic status

A rule is chosen, not derived. Its warrant is the decisions it cites in `per`, and no check can make it true. Two things about it can be checked, and neither has been:

- **Fixture agreement:** a lite parser produces the tree of every normative case in [[fixture:implied-root]]. No parser exists yet.
- **Consistency:** no other rule creates a second «root-node» or requires a spelled one. No other rule is drafted yet.

No ⟦verification-level⟧ is written. The rule ladder's first rung, `authorized`, needs an accepted ADR behind the rule, and the decisions in `per` are not ADRs yet.

## Explanation

*(Teaching. It describes the Statement and never adds to it.)*

Think of the «document» as an outermost element that you never write. It is always there, and whatever you write at the left margin goes inside it. So writing `|document` at the top does not name that root. It makes a child that happens to be called `document`:

![[dat/implied-root.yaml#root_is_never_spelled]]

That is a counter case. Its `expects` is the reading someone brings from XML, where the first element is the root, and its `tree` is what lite does instead: the element you wrote sits one level down, under a root you never wrote.


## Working notes

- **`per:` cites seeded decisions that are not ADRs yet** (`.old/vsect-init/DECISIONS.md`), so those entries dangle until the udon team converts them.
- **Open questions** bearing on it: 84 Q1, 04 Q2. The case `root_top_level_label` in [[fixture:implied-root]] holds 04 Q2's readings.

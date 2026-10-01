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

The clauses are written to hold under every open alternative listed in *Working notes*, with one known exception and one possible one. Under 84 Q1 option C, clause 1's «document» would be one per top-level element rather than one per file. Under 04 Q2 option B, a top-level `:$key` could give the root a key, which clause 3 would then have to allow or forbid.

## Explanation

*(Teaching. It describes the Statement and never adds to it.)*

Think of the «document» as an outermost element that you never write. It is always there, and whatever you write at the left margin goes inside it. So writing `|document` at the top does not name that root. It makes a child that happens to be called `document`:

![[dat/implied-root.yaml#root_is_never_spelled]]

That is a counter case. Its `expects` is the reading someone brings from XML, where the first element is the root, and its `tree` is what lite does instead: the element you wrote sits one level down, under a root you never wrote.

## Regression guards

- **Append-safety (68).** A top-level block appended at the end of a file becomes one more child of the «root-node», and nothing above it has to be re-closed. That holds only while clause 3 keeps a spelled root from ever being required. If append-safety is adopted (the outline's proposed [[obj:append-safety]]), any change to clause 3 needs checking against it.

## Working notes

- **`per` cites decisions that are not ADRs yet.** `implied-root` and `ast-centric` are seeded decisions with no ADR in `adr/`. Until they are converted, both entries dangle, and so do the two links in *Grounds*. Converting them is the udon team's. Nothing about this rule itself is waiting on a decision, so `awaiting-decision` is false; that it rests on unconverted decisions is derived from `per:` ([[sop/decision:flags-describe-own-record]]).
- **Open questions**, by pre-design number. Each says what it would change here, and which case in [[fixture:implied-root]] holds its readings.
  - **84 Q1, documents per file.** Option C ("several top-level elements are several documents") would make clause 1's «document» one per top-level element. Case `root_two_top_level_elements` holds the readings, so it stays descriptive until 84 Q1 closes. The outline gives the question to its proposed row [[rule:documents-per-file]]; if C is chosen, clause 1 here needs amending to match.
  - **04 Q2, top-level `:label` lines.** A: a warning, and the line kept as text (0.10.0 L1). B: attributes of the «root-node». Clause 2 places whatever nodes such a line makes, so it fits either. Under B there is a sub-question for this rule: would a top-level `:$key` give the root a key, and would that count as naming it under clause 3? Case `root_top_level_label`.
  - **04 Q1, indentation of top-level text.** It doesn't change the clauses. It is about how the root behaves as a container of text, which the outline assigns to [[rule:text-and-content-base]]. Case `root_indented_top_level_text`.
  - **13 Q1, 84 Q4, and 60: how root «meta» is represented** (part of the tree, a side layer, or not lite's business). Clause 4 is a permission and fixes no representation. Under 84 Q4's third option it would still hold, though it would say nothing lite needs. No case holds these readings, because the text notation can't show the difference; a machine transcript waits on 86.
  - **13 Q6, comments in the tree.** Clause 2 speaks of nodes rather than listing item kinds, so it holds whether or not comments are kept as nodes.
  - **Empty input.** No pre-design question lists it. 89 ("empty and degenerate forms") is the nearest, but none of its forms is the empty file. Case `root_empty_input` holds two readings. Adding the form to 89, or opening a question for it, is the udon team's call.

---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [ast-centric]
depends: [def:document]
consequences: [rule:top-level-items-are-root-children, rule:root-never-spelled, rule:root-meta, def:document]
test-fixtures: [implied-root]
---

# Every document has exactly one root node

*Parsing a «document» produces exactly one «root-node».*

## Statement

A lite parser MUST produce exactly one «root-node» for each «document».

## Grounds

- Joseph, 2026-09-29 (Discussion below): "the document being parsed has an implied root node -- so everything starts as children of that node, which might also have metadata like filename etc..."; [[decision:ast-centric]].

## Epistemic status

Chosen. No fixture yet.

## Discussion

*Carried 2026-10-09 from the decision record `adr/implied-root.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-09-29.*

**Context.** The 2011 originals had an implied root (`_older/udon-c/docs/DECIDED.md`: the file path as its ID, metadata attributes). From January to July 2026 the opposite was held: no implicit root wrapper, for streaming, fragments, and multi-root documents (`design/udon-ast.md`, first committed 2026-01-14; the 0.9.1 primer). On 2026-08-06 and 07 Joseph returned to a pseudo-root (`$DOCUMENT` in that work; 13's history). With lite specified as a tree ([[decision:ast-centric]]), the tree needs a top.

**Options considered.**

* No implicit root: a document is a sequence of top-level nodes (Jan – Jul 2026).
* One implied root node (chosen).

**Drivers.**

* A root answers what to do with attributes at the top level, and what distinguishes a partial document from a whole record from a store of records. (**recorded** 2026-08-07, in Joseph's words; not restated on 2026-09-29: "having all udon documents with a pseudo root element solves the open "what to do with attributes at top-level" question in the spec, as well as "what's the difference between an udon doc meant to be a partial vs whole-record vs store of records..." etc. (just depends on what you decide to do with that root element).")

**How firm.** His own call, so `steward`, with his own standing invitation to adjudicate it. At 00:50Z the agent relayed that the no-root position's reasons (streaming, fragments, host APIs, duplicate-key scope) "were never answered on the record"; at 01:01Z he cited "doc root" as an example of decisions having become "more principled and useful". He saw the objections and did not take up adjudication.

**Costs accepted.**

* Of the no-root position's reasons, streaming, host APIs and duplicate-key scope are not answered by any recorded reasoning. His 2026-08-07 words speak to fragments and multi-root.

**Reopen when.**

* Someone feels it still needs adjudicating (Joseph's own condition).
* Streaming, host APIs or duplicate-key scope turn out to need what an implied root prevents.

## Working notes

- **Joseph's words** (2026-09-29, `.int/STEWARD-VERBATIM.md`):
  > We can also settle (unless someone feels we need to adjudicate it still) on the document being parsed has an implied root node -- so everything starts as children of that node, which might also have metadata like filename etc...

  and earlier (2026-08-07):
  > … having all udon documents with a pseudo root element solves the open "what to do with attributes at top-level" question in the spec, as well as "what's the difference between an udon doc meant to be a partial vs whole-record vs store of records..." etc. (just depends on what you decide to do with that root element).

- History: 2011 udon-c had an implied root; Dec 2025–Jul 2026 held "no implicit root wrapper" for streaming, fragments and multi-root (`.int/pre-design/70-survey-index.md` §04).

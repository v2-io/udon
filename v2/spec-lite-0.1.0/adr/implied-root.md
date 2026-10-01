---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Every document has one implied root node; everything written starts as its children"
status: accepted
decided-by: steward
decided: "2026-09-29"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: []
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: ["04", "13 Q1", "84", "89"]
---

# Every document has one implied root node; everything written starts as its children

## Context and Problem Statement

The 2011 originals had an implied root (`_older/udon-c/docs/DECIDED.md`: the file path as its ID, metadata attributes). From January to July 2026 the opposite was held: no implicit root wrapper, for streaming, fragments, and multi-root documents (`design/udon-ast.md`, first committed 2026-01-14; the 0.9.1 primer). On 2026-08-06 and 07 Joseph returned to a pseudo-root (`$DOCUMENT` in that work; 13's history). With lite specified as a tree ([[decision:ast-centric]]), the tree needs a top.

## Decision Drivers

* A root answers what to do with attributes at the top level, and what distinguishes a partial document from a whole record from a store of records. (**recorded** 2026-08-07, in Joseph's words; not restated on 2026-09-29: "having all udon documents with a pseudo root element solves the open "what to do with attributes at top-level" question in the spec, as well as "what's the difference between an udon doc meant to be a partial vs whole-record vs store of records..." etc. (just depends on what you decide to do with that root element).")

## Assumptions

* None recorded.

## Considered Options

* No implicit root: a document is a sequence of top-level nodes (Jan – Jul 2026).
* One implied root node (chosen).

## Decision Outcome

Chosen: every document has one implied root node, which nothing in the source spells. Everything written in the document starts as its children. The root may carry metadata such as the filename.

Not decided here: top-level text indentation and top-level `:label` lines (04), how root metadata is represented (13 Q1, 84 Q4), how many documents a file holds (84), and empty input (89).

### Quote

> We can also settle (unless someone feels we need to adjudicate it still) on the document being parsed has an implied root node -- so everything starts as children of that node, which might also have metadata like filename etc...
>
> — Joseph, 2026-09-29 evening (2026-09-30T00:18Z), `.int/STEWARD-VERBATIM.md`

*His own call, so `steward`, with his own standing invitation to adjudicate it. At 00:50Z the agent relayed that the no-root position's reasons (streaming, fragments, host APIs, duplicate-key scope) "were never answered on the record"; at 01:01Z he cited "doc root" as an example of decisions having become "more principled and useful". He saw the objections and did not take up adjudication.*

### Positive Consequences

* Every document has the same shape at the top, and a place for file-level metadata.
* Top-level attributes, and partial versus whole-record versus store-of-records documents, become questions about the root rather than special cases (his 2026-08-07 reasons).

### Negative Consequences

* Of the no-root position's reasons, streaming, host APIs and duplicate-key scope are not answered by any recorded reasoning. His 2026-08-07 words speak to fragments and multi-root.

### What changes

* Lite's root rule, [[rule:implied-root]] (now an `example` row), is to state this.

## Reopen when

* Someone feels it still needs adjudicating (Joseph's own condition).
* Streaming, host APIs or duplicate-key scope turn out to need what an implied root prevents.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

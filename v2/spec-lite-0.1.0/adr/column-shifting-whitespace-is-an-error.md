---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "A tab or other non-space whitespace where it could shift a node's column is an error"
status: accepted
decided-by: steward
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: [parser implementers]
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: ["63"]
leaves-open: ["79 Q4"]
---

# A tab or other non-space whitespace where it could shift a node's column is an error

## Context and Problem Statement

UDON's nesting is by column. A tab has no agreed width, so a tab in indentation makes a line's column ambiguous. 0.10.0 kept such a line as text with a warning (L4); earlier versions made it an error. Same-line elements also sit at their true columns ([[decision:sameline-element-is-child]]), so whitespace before a later marker on a line matters as well.

## Decision Drivers

* Such whitespace "make[s] the true column position ambiguous" (Joseph, under the Quote).

## Assumptions

* None recorded.

## Considered Options

* Warning, line kept as text (0.10.0, L4).
* A tab counts as a fixed number of columns.
* An error wherever it could shift a node's column (chosen).

## Decision Outcome

Chosen: a tab, or any Unicode whitespace other than the ordinary space, in a position that changes the column of a node is an error ([[decision:errors-stop-parsing]]). That covers indentation, and any such character on a same-line run except inside the `$main` text or the final attribute's value.

### Quote

> - tabs:  I think any tab (or other unicode whitespace other than the normal space) in a spot that changes column positions for nodes is an error/fail.  -- so any on a "sameline" run except as part of the $main text or final attribute's value, would cause a fail, under the premise that such whitespaces make the true column position ambiguous.
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

> […] and I think should apply to a label with no value, any tab characters found in block mode, […]
>
> — Joseph, 2026-10-08 (same file, earlier message)

*His words: "I think". His own call, so `steward`. Decided for this version, and revisitable if undiscovered confounding factors come up (the footnote "Decided for this version" in `adr/TEMPLATE.md`). `awaiting-decision` is true only for the exact reading in Working notes.*

### Positive Consequences

* No two parsers or editors disagree about a node's column.

### Negative Consequences

* Tab-indented files are not lite.

### What changes

* [[rule:columns-and-indentation]]; the anomaly inventory.

## Reopen when

* Tab-indented authoring turns out to matter for a lite consumer.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- **Open, with Joseph:** the coordinator's exact reading. A tab or other non-space whitespace is an error in indentation, or anywhere on a line before a later marker whose column it could shift; after the line's last marker, inside `$main` text or the final value, it is content.
- **Open, with Joseph:** what "any tab characters found in block mode" covers: indentation only, or tabs inside block text and fence bodies too. Presumably not fence bodies, which are never scanned ([[decision:fence-body-indentation]]).
- Whitespace on a blank line never changes indentation ([[decision:blank-and-empty-lines]]), so it is not covered here.

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
closes: []
leaves-open: ["63", "79 Q4"]
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

Confirmed reading (the agent's, which Joseph answered "right"): an error in indentation, and anywhere on a line before a later marker whose column it could shift; after the line's last marker it is content.

```udon
|a :x 1⇥|b            ; error: b's column is ambiguous
|a :x some⇥value :y 1 ; error: not the final value (Joseph: "the right call")
|a :x some⇥value      ; fine: inside the final value
|a Some⇥title         ; fine: inside $main text
⇥|a                   ; error: tab in indentation
```

**Blank lines** may hold tabs and other Unicode whitespace: they don't set or change indentation ([[decision:blank-and-empty-lines]]).

Not decided here: an indentation unit, and a tab in a text block's stripped indentation or on a root-level line (the rest of 63).

### Quote

> - tabs:  I think any tab (or other unicode whitespace other than the normal space) in a spot that changes column positions for nodes is an error/fail.  -- so any on a "sameline" run except as part of the $main text or final attribute's value, would cause a fail, under the premise that such whitespaces make the true column position ambiguous.
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

> […] and I think should apply to a label with no value, any tab characters found in block mode, […]
>
> — Joseph, 2026-10-08 (same file, earlier message)

> Tab rule-- right.  I would however suggest that "blank-lines" allow tabs and other unicode ws because blank lines don't set indent/dedent levels.
>
> I think that inner some<tab>value throwing an error is the right call here. Excellent edge case to check.
>
> — Joseph, 2026-10-08 (same file, later message)

*His words: "I think"; then "Tab rule-- right", "I would however suggest" (blank lines), "the right call". His own call, so `steward`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]). `awaiting-decision` is true only for the `$main`-before-a-node conflict in Working notes.*

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

- **Open, with Joseph:** his two clauses can conflict when `$main` text sits *before* a later same-line node. The tab is inside `$main` text (the exception) but shifts `|em`'s column (the principle):

  ```udon
  |p Intro⇥text |em x
  ```

  The confirmed reading ("before a later marker → error") would make it an error; the exception, as worded, would allow it.
- Tabs inside block text, past the indentation that places the line, shift no node's column, so under the confirmed reading they are content. That is the agent's reading of "any tab characters found in block mode"; only a case that genuinely conflicts needs to go back to him.
- Pre-design 79 Q4 (CJK and combining characters before a same-line marker) rests on the same premise, "such whitespaces make the true column position ambiguous"; whoever decides it should start here.

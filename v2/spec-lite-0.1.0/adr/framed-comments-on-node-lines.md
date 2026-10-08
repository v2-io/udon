---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "A framed ` ; ` comments only on element and attribute lines; a line starting with ; is a comment block; ` ; ` inside text is text"
status: accepted
decided-by: steward
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)", "history agent (agent, Opus 5.5)"]
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: ["03"]
leaves-open: ["78"]
---

# A framed ` ; ` comments only on element and attribute lines; a line starting with ; is a comment block; ` ; ` inside text is text

## Context and Problem Statement

0.10.0 made a framed ` ; ` in block text "at the content base" a comment, so `Keep calm ; carry on.` under an element lost its second half to a comment. Asked about it on 2026-10-08, Joseph ruled that the framed comment belongs to element and attribute lines only. He then flagged this as the one thing possibly open ("The one thing that might be open for #1 is that note about 0.10.0") and asked whether 0.10.0's behavior had a rationale. The history agent found none: every reason ever given names element or attribute lines, and the text-line reading entered during the 2026-08-09 rewrite without a question to Joseph or a DELTAS row (`.int/history-semicolon-in-text-2026-10-08.md`). That finding was relayed to him; he moved on to the next question without commenting.

## Decision Drivers

* Comments follow the same block-and-indentation rules as everything else (Joseph, under the Quote).
* Ordinary prose uses ` ; ` as punctuation, and 0.10.0's reading silently cut it off (e.g. `vivarium/.orient/answers.stub.udon:14`). (**inferred, unconfirmed** as Joseph's driver: the history agent's and the coordinator's argument.)

## Assumptions

* Notes at the end of row-shaped text lines can move to `;{…}` ([[decision:inline-comments-in-prose]]). (**inferred, unconfirmed**: the history agent's and the coordinator's reading.)

## Considered Options

* 0.10.0: a framed ` ; ` in block text at the content base is a comment.
* Framed ` ; ` on element and attribute lines only; mid-text ` ; ` is text (chosen).
* No line comments inside block text except `;{…}`.

## Decision Outcome

Chosen:

- **A framed ` ; `** (at least one space on each side) starts a comment only on a line that begins with an element or an attribute: `|li Item ; TODO`, `:a 1 ; note`.
- **A line that starts with `;`** is a comment block, and it owns every line indented deeper under it, as blocks do.
- **A ` ; ` inside a line of text is text.**

### Quote

> 1.  I vote for strict-lean except ' ; ' only counts as a comment when part of sameline and with at least one space on each side. Comments: available on node or attribute started lines, and available as their own block, which also comments everything in that block that is indented further as per the usual with blocks and the indentation. […] (d) passed through […]
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

*His word: "I vote". His own call, so `steward`; he flagged it as possibly open pending the history result, the history found no rationale for 0.10.0's reading, and he hasn't explicitly re-confirmed since.*

### Positive Consequences

* Prose and Markdown with ` ; ` survive unchanged.
* One rule: comments live on structure lines or as their own blocks.

### Negative Consequences

* A trailing note on a text line becomes visible content, without warning; writers reached for it in practice (`core/examples/comprehensive.udon:425`, Dec 2025).

### What changes

* The comment rule; teaching material says "notes on table rows: use `;{…}`".

## Reopen when

* Trailing notes on text lines prove common enough to need a guard, such as a warning.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- Open (78): whether an end-of-line comment on an element or attribute line owns deeper lines; Joseph's words give ownership of deeper lines only to comment blocks.
- Open: a `;`-starting line deeper than a text block's left edge. 0.10.0 §8 makes it literal, and Joseph's `|Name|Role|` rule ("unless indented further than that in prose that has already started") suggests the same; the Outcome's "a line that starts with `;`" should not be read as unconditional until this is settled.
- The history agent floated a warning for a framed ` ; ` on a text line. The drafter's judgment: it would fire on legitimate prose; not proposed to Joseph.

---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "An empty line is a newline with nothing before it on its line; a blank line is empty or only whitespace; blank lines never change indentation"
status: accepted
decided-by: steward
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: ["55", "90"]
---

# An empty line is a newline with nothing before it on its line; a blank line is empty or only whitespace; blank lines never change indentation

## Context and Problem Statement

Raised by Joseph unprompted while deciding fence bodies, "because it's a little bit subtle". 0.10.0 §7.4 already had the behavior; the terms were not defined.

## Decision Drivers

* The difference matters in text and in fence bodies, where whitespace on a blank line can be content.

## Assumptions

* None recorded.

## Considered Options

* Only one option was on the table.

## Decision Outcome

Chosen:

- **Empty line:** a newline that is the first character of the document or directly follows another newline.
- **Blank line:** an empty line, or a line of only (Unicode-specified) whitespace. Every empty line is blank.
- **Blank lines never set or change indentation.**
- In text and in fence bodies, whitespace on a blank line beyond the left edge is kept as content; otherwise the blank line contributes only its newline. (The agent's generalization, which Joseph called "Correct, excellent".) In a verbatim (`-`) fence every byte is kept. Blank lines before a fence body's edge is set: open (working notes). Joseph's example:

```udon
|node some $main prose
    child prose section starting...
      
    more prose...
```
Line 3 has six spaces; the text is `"child prose section starting...\n  \nmore prose..."`.

### Quote

> That reminds me-- if it's not already a rule or planned-- we need to make sure we explicitly denote "blank lines" distinct from (a superset with) "empty lines" -- blank lines do *not* change indent levels. In some cases whitespace on blank lines is considered ornamentation, in some cases it can be part of prose: […] The reassembled text from the AST would be: "child prose section starting...\n  \nmore prose..."
>
> — Joseph, 2026-10-08

> Your defined terms are my intention yes-- empty would be a newline as the first of the document or any newline directly after an earlier newline. blank can be empty or have (unicode specified) whitespace.
>
> — Joseph, 2026-10-08 (both in `.int/STEWARD-VERBATIM.md`)

*His words: "we need to make sure we explicitly denote" and "Your defined terms are my intention yes". His own call, so `steward`.*

### Positive Consequences

* Two terms that every rule about lines can use exactly.

### Negative Consequences

* None identified.

### What changes

* A lite definition record for the two terms; the text and fence rules use them.

## Reopen when

* None recorded.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- Which Unicode whitespace counts is not named; probably `White_Space`, to confirm.
- Open: blank lines at the start of a fence body, before its first non-blank line sets the edge (with Joseph's lean that a blank first line is content, [[decision:fence-body-indentation]]).
- Where a blank line between two structures sits in the tree, and whether it is ornamentation, are 55 and 90.

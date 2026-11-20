---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Inline elements |{…} are in lite"
status: accepted
decided-by: ratified
decided: "2026-09-29"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: [udon agent of session 5930da5d (agent, Opus 5.5)]
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: ["10", "50", "51", "59"]
---

# Inline elements |{…} are in lite

## Context and Problem Statement

Inline elements are plain structure, not future syntax, so nothing in the reserve-not-ignore contract excluded them. But they add parser work, so whether lite includes them was put to Joseph, with the agent's lean to include them.

## Decision Drivers

* Being able to represent XML/HTML, which mixes elements into running text (Joseph: "one of the most obvious use-cases"; and 2026-09-30, "a critical objective").

## Assumptions

* XML/HTML-style mixed content is a first-class lite use, not an edge case. (**recorded**: "critical for one of the most obvious use-cases-- xml/html"; and 2026-09-30: "being able to represent xml/html is a critical objective")

## Considered Options

* Include `|{…}` (chosen; the agent's lean)
* Leave it out of lite

## Decision Outcome

Chosen: `|{…}` inline elements are in lite, because they are critical for the XML/HTML use case. Their exact rules (extent, attributes versus interior text, siblings on one line, inline comments) are not decided here.

### Quote

> |{...} inline elements are critical for one of the most obvious use-cases-- xml/html
>
> — Joseph, 2026-09-29 evening (2026-09-30T00:02Z), `.int/STEWARD-VERBATIM.md`

*The agent asked, leaning to include. Joseph's answer gives his own reason. Asked on 2026-09-30 whether it was `supported` or `ratified`, he answered "yes-- reasoning / principle / objective --- being able to represent xml/html is a critical objective" (`.int/STEWARD-VERBATIM.md`), so `ratified`; first recorded as `supported`.*

### Positive Consequences

* Lite can carry HTML-shaped documents, with markup inside running text.

### Negative Consequences

* More parser work, and more open questions (10, 50, 51, 59) lite must settle now.

### What changes

* Lite's rules for inline elements are written as rules, not reserved.

## Reopen when

* The XML/HTML use case stops being one lite serves.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- "being able to represent xml/html is a critical objective" (Joseph, 2026-09-30) becomes its own objective record in `obj/`, and this decision then cites it as its driver. Whether he means force `critical` (critical to quality) is asked when that record is drafted.
- `decided-by: ratified` was set on his answer to a supported-or-ratified question. His definitions, given just after (`.int/STEWARD-VERBATIM.md`, 2026-10-01 ~03:00Z), make this `sustained`: an agent proposed it with a lean and he decided it then. The value set is being revised to carry that; this record is re-labelled when it is.

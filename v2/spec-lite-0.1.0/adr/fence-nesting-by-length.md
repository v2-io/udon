---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "A fence opened with N backticks (N ≥ 3) closes only at N or more; its label may not contain a backtick"
status: accepted
decided-by: supported
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: [vsect]
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: ["11 Q3"]
leaves-open: []
---

# A fence opened with N backticks (N ≥ 3) closes only at N or more; its label may not contain a backtick

## Context and Problem Statement

With `!:kind:` reserved, the fence is lite's only form for raw content. A fence was exactly three backticks, so the first inner three-backtick line closed an outer fence early, with only one unclosed-fence warning at the end of the file (`v2/theory/to-integrate/refine-more/markdown/fence-knot-table.md`). The spec corpus written in lite will contain examples that contain fences.

## Decision Drivers

* Fences must be able to hold fences (vsect's most binding requirement, `.int/vsect-requirements-on-lite.md`).
* Follow the existing standard where UDON doesn't need to differ: CommonMark 0.31.2 "Fenced code blocks" (copy in `v2/spikes/markdown-probe/`). (**inferred**: the agent's reading of Joseph's "Is there a standard?")

## Assumptions

* None recorded.

## Considered Options

* Exactly three backticks (0.10.0).
* N ≥ 3, closing at N or more (CommonMark) (chosen).
* Also allow `~~~` fences: not taken, on the agent's recommendation; Joseph didn't address it.

## Decision Outcome

Chosen:

- A fence opens with N ≥ 3 backticks and closes only at a line of N or more backticks.
- A backtick fence's label (the rest of the opening line) may not contain a backtick, as in CommonMark: `` ```x``` is inline code `` at a line start is not a fence opener. This also rules out opening and closing a fence on one line.
- Unlike CommonMark, a fence may open anywhere a structure line or same-line structure can start, at any indentation; its position decides its parent.

Open, being put to Joseph: inside a fence body, a line that starts with N or more backticks followed by other text. See [[decision:fence-closer-is-a-line]].

### Quote

> Decision A:  We should allow nested fences via backtick count >= 3 is my strong preference.  Is there a standard? I know, for example, that we will not want to follow markdown's standard (in some versions) of requiring that a fence be at the beginning of a line or the first non-whitespace of a line-- we need its indent (including sameline) to decide whose child it is.
>
> Agree no backticks on the fence's label-- which also guarantees that there is no worry about opening and closing a fence on the same line.
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`, two messages)

*His words: "my strong preference" (nesting by length); "Agree" (the no-backtick label, the agent's proposal from CommonMark). Recorded `supported` for now.*

### Positive Consequences

* Nested fences work, matching what agents expect from Markdown.

### Negative Consequences

* None identified.

### What changes

* The fence rule.

## Reopen when

* None recorded.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- The coordinator is asking Joseph whether "strong preference" is meant as a ruling. `decided-by` follows his answer.

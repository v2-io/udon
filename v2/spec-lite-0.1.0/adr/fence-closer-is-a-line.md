---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "A fence's closing line comes after the body, then takes part in nesting at its column like any other line"
status: accepted
decided-by: supported
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
leaves-open: []
---

# A fence's closing line comes after the body, then takes part in nesting at its column like any other line

## Context and Problem Statement

Joseph raised it: where a long fence closes is a visual cue to where the reader is in the nesting, and a closer neither at the line's start nor aligned with the opener is confusing. Until now the closer had no structural effect (0.10.0; Joseph 2026-01-01 18:54: "Honestly, column shouldn't matter for freeform-- it should just finish anywhere ``` starts a line after any amount of whitespace, and it doesn't affect the indent/dedent stack at all", with his 18:52 note beside it that the spec "recommends that the closing ``` happen at the indent level of the parent"; both in `.int/pre-design/11-code-blocks.discussion.md` H8). The two options he set out: (a) the closer ends the fence and then disappears like a blank line; (b) it ends the fence and also sets the current indentation level.

## Decision Drivers

* Every non-blank line in UDON takes part in nesting by its column (comment lines do), so a closer that does likewise means what it looks like. (**inferred, unconfirmed** as Joseph's: the agent's argument for (b))
* With fence bodies no longer byte-exact, nothing pushes authors to put closers at column 0. (**inferred, unconfirmed** as Joseph's: the agent's)

## Assumptions

* None recorded.

## Considered Options

* (a) No structural effect: the closer ends the fence and disappears like a blank line.
* (b) The closer ends the fence, then acts as a line at its column (chosen).
* An error for a closer at an unexpected column (Joseph floated; unnecessary under (b)).

## Decision Outcome

Chosen (b):

- The closing line is not part of the body ("transparent to fence body").
- Its column then acts like any other line's: open elements at or right of it close, and following lines nest relative to the result.

````udon
|abcdef |ghijkl :something ```txt
     body…
     ```
       |next          ; the closer at col 5 closed ghijkl; next is abcdef's child
````

What may follow a closer's backticks is in [[decision:fence-line-comments]].

Open, being put to Joseph: a line inside a body that starts with N or more backticks followed by other text. With "anything else after a closer's backticks is an error", such a line becomes an error rather than body content. Two cases:

`````text
````md
```js            ← a nested opener the author forgot to lengthen: an error, or body?
````
`````

```text
```x``` is how you write inline code     ← inside a ```md body: an error, or body?
```

The alternative reading: a line is a closer only if nothing but spaces or a framed comment follows its backticks; otherwise it is body content.

### Quote

> And for the closer-- *transparent to fence body* (i.e., comes *after* the end of the fenced body), indent level sets new current indent level, with dedenting/closing etc. as appropriate.
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`), in the message that opens "Excellent. I agree completely with your leans as my leans"

*His words: stated directly, in the message adopting "your leans as my leans", just after the agent leaned (b). It can be read as his own call or as one of the adopted leans. Recorded `supported` for now.*

### Positive Consequences

* A closer you put at column 0 really means "back to column 0".

### Negative Consequences

* A closer at column 0 under a deep same-line chain closes the whole chain; under the old reading it didn't.

### What changes

* The fence rule; fixtures for closers at, left of, and between open columns.

## Reopen when

* None recorded.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- The coordinator is asking Joseph whether he means this as a ruling. `decided-by` follows his answer.
- Open, with Joseph: a backtick line with trailing text inside a body (above).
- Style, from Joseph the same day (canonical-form material, 85): a closer aligned with the opening is recommended; one at column 0 under a same-line chain is "slightly discouraged".

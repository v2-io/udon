---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: text
per: []
depends: [rule:fence-closes-at-n-or-more, rule:nesting]
consequences: [rule:fence-closer-trailing-text-is-error]
---

# A fence's closing line nests at its own column

*The closer is not part of the body; its column then closes open elements at or right of it, like any line.*

## Statement

1. A fence's closing line MUST NOT be part of the body, and its column MUST then act as any line's column does for nesting.

## Grounds

- "*transparent to fence body* (i.e., comes *after* the end of the fenced body), indent level sets new current indent level, with dedenting/closing etc. as appropriate" (Joseph, 2026-10-08): the Discussion below.

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

````udon
|abcdef |ghijkl :something ```txt
     body…
     ```
       |next
````
```tree
root
  |abcdef
    |ghijkl
      :something ```txt "body…\n"
    |next          ← the closer at column 5 closed ghijkl
```

## Discussion

*Carried 2026-10-09 from the decision record `adr/fence-closer-is-a-line.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `supported`, 2026-10-08.*

**Context.** Joseph raised it: where a long fence closes is a visual cue to where the reader is in the nesting, and a closer neither at the line's start nor aligned with the opener is confusing. Until now the closer had no structural effect (0.10.0; Joseph 2026-01-01 18:54: "Honestly, column shouldn't matter for freeform-- it should just finish anywhere ``` starts a line after any amount of whitespace, and it doesn't affect the indent/dedent stack at all", with his 18:52 note beside it that the spec "recommends that the closing ``` happen at the indent level of the parent"; both in `.int/pre-design/11-code-blocks.discussion.md` H8). The two options he set out: (a) the closer ends the fence and then disappears like a blank line; (b) it ends the fence and also sets the current indentation level.

**Options considered.**

* (a) No structural effect: the closer ends the fence and disappears like a blank line.
* (b) The closer ends the fence, then acts as a line at its column (chosen).
* An error for a closer at an unexpected column (Joseph floated; unnecessary under (b)).

**Drivers.**

* Every non-blank line in UDON takes part in nesting by its column (comment lines do), so a closer that does likewise means what it looks like. (**inferred, unconfirmed** as Joseph's: the agent's argument for (b))
* With fence bodies no longer byte-exact, nothing pushes authors to put closers at column 0. (**inferred, unconfirmed** as Joseph's: the agent's)

**How firm.** His words: stated directly, in the message adopting "your leans as my leans", just after the agent leaned (b); later, "I like our rules (recorded)". Recorded `supported`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).

**Costs accepted.**

* A closer at column 0 under a deep same-line chain closes the whole chain; under the old reading it didn't.

**Joseph's words not already quoted on this card.**

> 3. I like our rules (recorded) for both of those as well, definitely. It would probably be useful to mention that nuance vs commonmark in the spec itself.
>
> — Joseph, 2026-10-08 (same file, later), on the backtick line with trailing text
## Working notes

- **Joseph's words:**

  > And for the closer-- *transparent to fence body* (i.e., comes *after* the end of the fenced body), indent level sets new current indent level, with dedenting/closing etc. as appropriate. I'll leave it up to you whether or not to allow a ' ; ' comment after the backticks on the same line, but recommend an error/failure on anything else.
  > Agree no backticks on the fence's label-- which also guarantees that there is no worry about opening and closing a fence on the same line. Comment being allowed after the fence opener on its line is up to you as well, but if it's no on either or both of those mark it as 'open for future discussion' or something equivalent.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** Every non-blank line takes part in nesting by its column, as comment lines do; a closer is just another line, and what you see matches the structure.
- Recommended placement (aligned with the opener) is advice for [[expl:writing-lite]], not a rule.

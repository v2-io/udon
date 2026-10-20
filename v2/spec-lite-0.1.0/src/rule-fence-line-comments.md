---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:fence-opens-with-backticks, rule:fence-closes-at-n-or-more, rule:fence-opener-line]
consequences: [rule:comments-in-tree, rule:fence-closer-trailing-text-is-error]
test-fixtures: []
---

# Comments on fence lines

*A framed ` ; ` on a fence's opening line is a comment, as on any element line; one may also follow a closer's backticks.*

## Statement

On a fence's opening line a framed ` ; ` MUST start a comment, as on any element line ([[rule:fence-opener-line]]); one MAY also follow a closer's backticks.

````udon
|job :script ```sh ; run in CI
make build
``` ; end of script
````
```tree
root
  |job
    :script ```sh
      ; " run in CI"
      ‹make build›
      ; " end of script"
```
Both comments are children of the fence, around its body (Joseph's lean on the fence's tree, 2026-10-20; [[rule:fence-opener-line]]).

## Grounds

- the Discussion below (the coordinator's call under Joseph's grant; "I support your decision on the comments").

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Discussion

*Carried 2026-10-09 from the decision record `adr/fence-line-comments.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `supported`, 2026-10-08.*

**Context.** Deciding that a fence's closing line takes part in nesting ([[rule:fence-closer-is-a-line]]), Joseph left two calls to the agent: whether a ` ; ` comment may follow the closer, and whether one may follow the opener on its line. He recommended an error for anything else after the closer.

**Options considered.**

* Allow on both (chosen).
* Disallow on either, and mark it open for future discussion (Joseph's instruction if no).

**Drivers.**

* One comment rule: a framed ` ; ` comments on lines that start structure ([[rule:framed-comments]]); a fence line is such a line.

**Assumptions.**

* Labels containing a framed ` ; ` are not needed (a label is a language name or similar). (**inferred, unconfirmed**: the delegate's)

**Costs accepted.**

* A label can't contain a framed ` ; `.

**Reopen when.**

* The decider declines it.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > Excellent. I agree completely with your leans as my leans:   normal first-inner-sets-indent+warn-on-dedent   +   '-' suffix for verbatim & all dent changes in meta.   And for the closer-- *transparent to fence body* (i.e., comes *after* the end of the fenced body), indent level sets new current indent level, with dedenting/closing etc. as appropriate. I'll leave it up to you whether or not to allow a ' ; ' comment after the backticks on the same line, but recommend an error/failure on anything else.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 467)

- **Why it matters** (the drafter's reasoning): Fence lines behave like the other structure lines.

- **Joseph's words:**

  > And for the closer-- *transparent to fence body* (i.e., comes *after* the end of the fenced body), indent level sets new current indent level, with dedenting/closing etc. as appropriate. I'll leave it up to you whether or not to allow a ' ; ' comment after the backticks on the same line, but recommend an error/failure on anything else.
  > Agree no backticks on the fence's label-- which also guarantees that there is no worry about opening and closing a fence on the same line. Comment being allowed after the fence opener on its line is up to you as well, but if it's no on either or both of those mark it as 'open for future discussion' or something equivalent.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)
  > I support your decision on the comments
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** One comment rule for lines that open or close a node.
- Where these comments sit in the «tree»: children of the fence, the opening line's comment before the body and the closer's after it (Joseph's lean, 2026-10-20, in [[rule:fence-opener-line]]).
- Anything other than a framed comment after a closer's backticks is an error ([[rule:fence-closer-trailing-text-is-error]]).
- Since 2026-10-12 the opening line reads like an element's line ([[rule:fence-opener-line]]), so the opener's comment is the ordinary sameline comment. The "label" in the Discussion is now the fence's name.

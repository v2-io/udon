---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:fence-body-not-scanned, rule:text-left-edge]
consequences: [rule:fence-body-shallower-line, rule:fence-exact-trait, rule:fence-dedent-in-meta, def:node, rule:fence-body-line-endings, rule:fence-body-not-scanned, rule:text-dedent, rule:text-left-edge, rule:text-shallower-line]
test-fixtures: []
---

# A fence body is dedented by its first line

*Unless the fence has the trait `exact`, a fence body's first non-blank line sets its left edge, and each line loses that many leading spaces.*

## Statement

Unless the fence has the trait `exact` ([[rule:fence-exact-trait]]), a fence body's first non-blank line MUST set its left edge, and each body line MUST lose that many leading spaces.

````udon
|rule[implied-root]
  |example
    ```udon
    |document
      |section
    ```
````
```tree
root
  |rule
    :$key ‹implied-root›
    |example
      ```udon "|document\n  |section\n"
```

## Grounds

- Discussion below: "normal first-inner-sets-indent".
- Joseph's principle recorded there: only notation on the opener and the first line's indentation carry intent; nothing is read from the fence delimiter's own column.

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Discussion

*Carried 2026-10-09 from the decision record `adr/fence-body-indentation.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `supported`, 2026-10-08.*

**Context.** 0.10.0 fences were byte-exact, ruled in July when `!:kind:` (which dedents) was the everyday code form and the fence the rare one. Lite has no `!:kind:`, so a byte-exact fence would put stray indentation into every nested example. Joseph proposed reading a fence body with UDON's ordinary text dedent; the agent showed the case it handles badly (a body whose first line must sit deeper than later ones, e.g. a diff hunk starting with a context line); Joseph listed nine remedies and set a principle.

**Options considered.**

* Byte-exact (0.10.0).
* Strip up to the opener's indentation (CommonMark). Its strip-to-the-fence's-column core Joseph called "a complete no-go".
* Strip to the opener line's left-most position (Joseph floated, unsure; the agent argued against it: it breaks `|job :script ```sh` with an indented body, and Joseph's own second example).
* First non-blank body line sets the edge, capped at the fence's column (the agent's; withdrawn: it reads intent from the delimiter's column).
* First non-blank body line sets the edge; `-` for verbatim; meta keeps indentation (chosen).
* Others Joseph listed: verbatim by default with a consumer dedent; dedent to the shallowest line after the closer (rejected by him for streaming); consumed `\` escapes (rejected by him); a whitespace-only first line setting the edge (the agent argued against: editors strip such lines invisibly).

**Drivers.**

* In UDON the only clues to a fence body's intended indentation are notation on the opener and the indentation of the body's first line; never the column of the fence delimiter (Joseph, under the Quote).
* Fence bodies preserve everything between opener and closer (Joseph, under the Quote).
* Nothing is lost: the indentation removed stays recoverable (his option 4).
* Must work streaming in full UDON: no buffering the whole body before deciding (Joseph's objection to dedenting by the shallowest line).

**Assumptions.**

* The marker spelling `-` collides with no real language label. (**inferred, unconfirmed**: the agent's)

**How firm.** His words: "I agree completely with your leans as my leans". The dedent rule is his proposal; `-` was his option 2 and meta his option 4, combined by the agent. Recorded `supported`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]). The principle about the delimiter's column, and fence bodies preserving everything, are his own statements and bind more strongly.

**Costs accepted.**

* A body whose first line is deeper than a later one is wrong by default (with a warning) unless the author adds `-` (since 2026-10-12, the trait `exact`).

**Reopen when.**

* `-` collides with real labels, or the warned case proves common.

**Joseph's words not already quoted on this card.**

> As for *inner* [indentation] retention-- the "markdown rule" would be extremely easy to implement by essentially saying that the "parent's indent column" is (in 1-indexed columns) 0, therefore the normal udon parsing takes effect […]
>
> — Joseph, 2026-10-08

> I was acknowledging that in my example, due to fenced blocks needing to preserve everything except the fence opener and closers, my "attempted" workaround to needs-indented-first-line would pass the backslash through, unfortunately.
>
> — Joseph, 2026-10-08 (20:07Z)
## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > Hold on... I just started reading your response and am concerned with "suppose a fence body's first line sits deeper than the fence itself..."  I am not sure we can *ever* ascribe any intent to the indent level of the fence delimiter itself in udon. I actually am continuing to read and I don't think the rest of anything rests on that supposition, so I think we see eye to eye-- just as long as we're clear that in udon we only start having clues about intent via special notation on the open (if there are any) and the first line's indent level.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 416)

  > Excellent. I agree completely with your leans as my leans:   normal first-inner-sets-indent+warn-on-dedent   +   '-' suffix for verbatim & all dent changes in meta.   And for the closer-- *transparent to fence body* (i.e., comes *after* the end of the fenced body), indent level sets new current indent level, with dedenting/closing etc. as appropriate. I'll leave it up to you whether or not to allow a ' ; ' comment after the backticks on the same line, but recommend an error/failure on anything else.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 467)

- **Why it matters** (the drafter's reasoning): Only notation on the opener and the first line's indentation tell the parser anything about intent.
- A blank first body line is body: everything between opener and closer is body ([[rule:fence-body-not-scanned]]), and blank lines never set the left edge, so the first *non-blank* line does. Joseph, 2026-10-09: "the answer should have been a very obvious as derived from the rules we finally landed on."

  ````udon
  |ex
    ```text

      x
    ```
  ````
  ```tree
  root
    |ex
      ```text "\nx\n"
  ```
- 2026-10-12: the dedenting is done by the default fence handler ([[rule:fence-default-handler]]), and `-` is replaced by the trait `exact` ([[rule:fence-exact-trait]]). The Discussion above keeps the 2026-10-08 wording.

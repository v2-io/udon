---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:text-value-end]
consequences: [rule:comments-in-tree, rule:comment-block-owns-deeper-lines, rule:comment-blocks, rule:prose-passes-through]
test-fixtures: []
---

# A framed ` ; ` on an element or attribute line

*On a line that begins with an element or an attribute, a ` ; ` with a space on each side starts a comment to the end of the line.*

## Statement

On a line that begins with an element or an attribute, a `;` with at least one space on each side MUST start a comment that runs to the end of the line.

```udon
|li Item ; TODO
|el :a 1 ; note
|el :url x;y
```
```tree
root
  |li
    :$main ‹Item›
    ; " TODO"
  |el
    :a 1
    ; " note"
  |el
    :url ‹x;y›
```

## Grounds

- Discussion below: "' ; ' only counts as a comment when part of sameline and with at least one space on each side."

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Discussion

*Carried 2026-10-09 from the decision record `adr/framed-comments-on-node-lines.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-10-08.*

**Context.** 0.10.0 made a framed ` ; ` in block text "at the content base" a comment, so `Keep calm ; carry on.` under an element lost its second half to a comment. Asked about it on 2026-10-08, Joseph ruled that the framed comment belongs to element and attribute lines only. He then flagged this as the one thing possibly open ("The one thing that might be open for #1 is that note about 0.10.0") and asked whether 0.10.0's behavior had a rationale. The history agent found none: every reason ever given names element or attribute lines, and the text-line reading entered during the 2026-08-09 rewrite without a question to Joseph or a DELTAS row (`.int/history-semicolon-in-text-2026-10-08.md`). That finding was relayed to him; he moved on to the next question without commenting.

**Options considered.**

* 0.10.0: a framed ` ; ` in block text at the content base is a comment.
* Framed ` ; ` on element and attribute lines only; mid-text ` ; ` is text (chosen).
* No line comments inside block text except `;{…}`.

**Drivers.**

* Comments follow the same block-and-indentation rules as everything else (Joseph, under the Quote).
* Ordinary prose uses ` ; ` as punctuation, and 0.10.0's reading silently cut it off (e.g. `vivarium/.orient/answers.stub.udon:14`). (**inferred, unconfirmed** as Joseph's driver: the history agent's and the coordinator's argument.)

**Assumptions.**

* Notes at the end of row-shaped text lines can move to `;{…}` ([[rule:inline-comments]]). (**inferred, unconfirmed**: the history agent's and the coordinator's reading.)

**How firm.** His word: "I vote". His own call, so `steward`; he flagged it as possibly open pending the history result, the history found no rationale for 0.10.0's reading, and he hasn't explicitly re-confirmed since.

**Costs accepted.**

* A trailing note on a text line becomes visible content, without warning; writers reached for it in practice (`core/examples/comprehensive.udon:425`, Dec 2025).

**Reopen when.**

* Trailing notes on text lines prove common enough to need a guard, such as a warning.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > 1.  I vote for strict-lean except ' ; ' only counts as a comment when part of sameline and with at least one space on each side. Comments: available on node or attribute started lines, and available as their own block, which also comments everything in that block that is indented further as per the usual with blocks and the indentation. (a), (b) => error,  (c) passed through + reference,  (d) passed through, (e) parsed as a node unless indented further than that in prose that has already started or escaped with \ or a space after the first pipe.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 290)

- **Why it matters** (the drafter's reasoning): Comments belong on structure lines; in prose a ` ; ` is ordinary punctuation.

- Not discussed: where such a comment sits in the «tree» (shown as a child of the element whose line it ends — the drafter's placement); whether it owns deeper lines (78).

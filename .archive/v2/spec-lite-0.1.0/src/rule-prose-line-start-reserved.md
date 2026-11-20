---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [reserved-is-an-error]
depends: []
consequences: [rule:reserved-spellings, obj:reserve-dont-ignore, rule:deeper-marker-lines-are-text, rule:prose-passes-through]
---

# `@name` or `!word` at the start of a prose line is an error

*A prose line that starts with a bare reference or a directive spelling is not lite.*

## Statement

A prose line whose first non-space characters are `@` or `!` followed by a name, `:`, `[`, `.` or `<` MUST be an error (the rows of [[rule:reserved-spellings]]; Joseph, 2026-10-21: a Markdown image `![img](src)` at a line start is such an error, "as reserved constructs").

## Grounds

- Joseph, 2026-10-08: "I vote for strict-lean … (a), (b) => error".

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|post
  @alice said we should ship.
```
An error at 2:3: `@alice` at the start of a prose line is reserved. Written `\@alice said we should ship.`, it is text ([[rule:line-start-escape]]).

## Discussion

*Carried 2026-10-09 from the decision record `adr/reserved-line-starts-in-prose.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-10-08.*

**Context.** Under [[decision:reserved-is-an-error]], how much ordinary Markdown-style prose lite refuses depends on where reserved spellings are recognized inside text. The agent put five lines to Joseph, all in a text block under `|post`:

```udon
|post
  @alice said we should ship.         ; (a)
  !important: read this first.        ; (b)
  email me @joseph or see @{faq}.     ; (c)
  Keep calm ; carry on.               ; (d)
  |Name|Role|                         ; (e)
```

(d) is recorded in [[rule:framed-comments]].

**Options considered.**

* Strict: (a) and (b) are errors.
* Lenient: (a), (b) and (e) are plain text, which keeps full UDON from ever giving meaning to `@name` or `!word` at the start of a prose line.

**Drivers.**

* None stated.

**How firm.** His word: "I vote". His own call, so `steward`.

**Costs accepted.**

* Prose that starts a line with `@alice` or `!important` is not lite; the author escapes it.
* What the rest of `|Name|Role|` becomes after the name `Name` is not yet stated.

**Reopen when.**

* Refusal proves too costly for real prose.

## Working notes

- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > 1.  I vote for strict-lean except ' ; ' only counts as a comment when part of sameline and with at least one space on each side. … (a), (b) => error,  (c) passed through + reference,  (d) passed through, (e) parsed as a node unless indented further than that in prose that has already started or escaped with \ or a space after the first pipe.
- Reasoning (agent's): a prose line starting `@alice` would mean a reference in full UDON; refusing it now keeps lite documents from changing meaning later.
- `!word` at the start of a prose line is in Joseph's (b); `!` followed by `:` (`!:sh:`) at a line start is on the reserved list ([[rule:reserved-spellings]]).

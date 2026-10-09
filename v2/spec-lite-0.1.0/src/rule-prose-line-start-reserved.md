---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [reserved-line-starts-in-prose, reserved-is-an-error]
depends: []
consequences: [rule:reserved-spellings]
---

# `@name` or `!word` at the start of a prose line is an error

*A prose line that starts with a bare reference or a directive spelling is not lite.*

## Statement

A prose line whose first non-space characters are `@` followed by a name, or `!` followed by a word, MUST be an error.

## Grounds

- Joseph, 2026-10-08: "I vote for strict-lean … (a), (b) => error" ([[decision:reserved-line-starts-in-prose]]).

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|post
  @alice said we should ship.
```
An error at 2:3: `@alice` at the start of a prose line is reserved. Written `\@alice said we should ship.`, it is text ([[rule:line-start-escape]]).

## Working notes

- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > 1.  I vote for strict-lean except ' ; ' only counts as a comment when part of sameline and with at least one space on each side. … (a), (b) => error,  (c) passed through + reference,  (d) passed through, (e) parsed as a node unless indented further than that in prose that has already started or escaped with \ or a space after the first pipe.
- Reasoning (agent's): a prose line starting `@alice` would mean a reference in full UDON; refusing it now keeps lite documents from changing meaning later.
- `!word` at the start of a prose line is in Joseph's (b); `!` followed by `:` (`!:sh:`) at a line start is on the reserved list ([[rule:reserved-spellings]]).

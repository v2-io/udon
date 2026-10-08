---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "A fence body is never scanned; it is dedented by its first non-blank line, warning on shallower lines; a trailing - on the label means verbatim; indentation is kept as meta"
status: accepted
decided-by: supported
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: [vsect, parser implementers]
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: ["11 Q2"]
leaves-open: []
---

# A fence body is never scanned; it is dedented by its first non-blank line, warning on shallower lines; a trailing - on the label means verbatim; indentation is kept as meta

## Context and Problem Statement

0.10.0 fences were byte-exact, ruled in July when `!:kind:` (which dedents) was the everyday code form and the fence the rare one. Lite has no `!:kind:`, so a byte-exact fence would put stray indentation into every nested example. Joseph proposed reading a fence body with UDON's ordinary text dedent; the agent showed the case it handles badly (a body whose first line must sit deeper than later ones, e.g. a diff hunk starting with a context line); Joseph listed nine remedies and set a principle.

## Decision Drivers

* In UDON the only clues to a fence body's intended indentation are notation on the opener and the indentation of the body's first line; never the column of the fence delimiter (Joseph, under the Quote).
* Fence bodies preserve everything between opener and closer (Joseph, under the Quote).
* Nothing is lost: the indentation removed stays recoverable (his option 4).
* Must work streaming in full UDON: no buffering the whole body before deciding (Joseph's objection to dedenting by the shallowest line).

## Assumptions

* The marker spelling `-` collides with no real language label. (**inferred, unconfirmed**: the agent's)

## Considered Options

* Byte-exact (0.10.0).
* Strip up to the opener's indentation (CommonMark). Its strip-to-the-fence's-column core Joseph called "a complete no-go".
* Strip to the opener line's left-most position (Joseph floated, unsure; the agent argued against it: it breaks `|job :script ```sh` with an indented body, and Joseph's own second example).
* First non-blank body line sets the edge, capped at the fence's column (the agent's; withdrawn: it reads intent from the delimiter's column).
* First non-blank body line sets the edge; `-` for verbatim; meta keeps indentation (chosen).
* Others Joseph listed: verbatim by default with a consumer dedent; dedent to the shallowest line after the closer (rejected by him for streaming); consumed `\` escapes (rejected by him); a whitespace-only first line setting the edge (the agent argued against: editors strip such lines invisibly).

## Decision Outcome

Chosen:

- **Never scanned:** everything between the opener and the closer is body. A fence body is never scanned for UDON syntax, including reserved spellings, and has no escapes: a leading `\` is body content.
- **Default dedent:** the body reads like text under an element, except that only the closing line ends it. Its first non-blank line sets the left edge; later lines lose that many leading spaces; a shallower line produces a warning and moves the edge to it (lines already read keep the stripping they got); blank lines never set or move the edge.
- **Verbatim:** a label ending in `-` (e.g. ```` ```diff- ````) strips nothing.
- **Meta:** the tree keeps the indentation removed from each line (which includes every edge move), so a consumer can always rebuild the verbatim body. This is the agent's wording of Joseph's "all dent changes in meta".

````text
|patch
  ```diff-
 context line
-removed
  ```
→ body " context line\n-removed\n"
````

### Quote

> As for *inner* [indentation] retention-- the "markdown rule" would be extremely easy to implement by essentially saying that the "parent's indent column" is (in 1-indexed columns) 0, therefore the normal udon parsing takes effect […]
>
> — Joseph, 2026-10-08

> I was acknowledging that in my example, due to fenced blocks needing to preserve everything except the fence opener and closers, my "attempted" workaround to needs-indented-first-line would pass the backslash through, unfortunately.
>
> — Joseph, 2026-10-08 (20:07Z)

> I am not sure we can *ever* ascribe any intent to the indent level of the fence delimiter itself in udon. […] in udon we only start having clues about intent via special notation on the open (if there are any) and the first line's indent level.
>
> — Joseph, 2026-10-08

> Excellent. I agree completely with your leans as my leans:   normal first-inner-sets-indent+warn-on-dedent   +   '-' suffix for verbatim & all dent changes in meta.
>
> — Joseph, 2026-10-08 (all in `.int/STEWARD-VERBATIM.md`)

*His words: "I agree completely with your leans as my leans". The dedent rule is his proposal; `-` was his option 2 and meta his option 4, combined by the agent. Recorded `supported`. Decided for this version, and revisitable if undiscovered confounding factors come up (the footnote "Decided for this version" in `adr/TEMPLATE.md`). The principle about the delimiter's column, and fence bodies preserving everything, are his own statements and bind more strongly.*

### Positive Consequences

* Nested examples read as written; text, comment continuations and fences share one dedent rule; same-line fences need no special column.
* vsect's spec examples can hold reserved syntax inside fences.

### Negative Consequences

* A body whose first line is deeper than a later one is wrong by default (with a warning) unless the author adds `-`.

### What changes

* The fence rule; fixtures for each case above.

## Reopen when

* `-` collides with real labels, or the warned case proves common.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- A blank first body line is content, not ornamentation: Joseph's lean ("I like, because we want that for fenced anyway if we can, although I'm not going to promise it-- just a lean"), which the agent then agreed with and Joseph adopted among "your leans as my leans". A joint lean; still to be written into the rule.
- Open: whether the `-` is part of the label in the tree (`diff` or `diff-`), and what a bare ```` ```- ```` means.

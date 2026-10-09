---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [representational-options]
depends: [rule:text-value-end]
consequences: [rule:space-between-embeds, rule:inline-comments-kept, rule:inline-comments, rule:prose-escaped-embeds, rule:prose-passes-through, def:node, def:string, def:text, rule:comments-in-tree, rule:inline-element-value-end, rule:text-value-end]
---

# Embedded forms are pieces of text

*`|{…}`, `@{…}` and `;{…}` are never values of their own.*

## Statement

`|{…}`, `@{…}` and `;{…}` MUST be pieces of the text they appear in, even when they are the first or only thing in a value position.

## Grounds

- Joseph, 2026-10-09: "I am very comfortable having embeds always be a distinct chunk of distinct text as if it were a word for right now, yes".

## Epistemic status

Decided for this version ("for right now").

## Explanation

```udon
|el :x |{em hi}
|book :author @{people/jw}
```
````tree
root
  |el
    :x ‹|{em ‹hi›}›
  |book
    :author ‹@{people/jw}›
````
Reading a one-piece text as its piece is a reading option ([[def:reading-option]]).

## Discussion

*Carried 2026-10-09 from the decision record `adr/embeds-are-pieces-of-text.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-10-09.*

**Context.** [[rule:main-is-attribute]] showed `|nav |{a} |{a}` as two `$main` values. Joseph flagged that line as still open. It came from 0.10.0's K9 (2026-08-08), which narrowed his own 2026-07-19 principle so that a brace form standing at a fresh value position became a value of its own. His reading is the earlier one: on a line, embedded forms stay part of the text, and text ends only at a block form.

**Options considered.**

* K9 (2026-08-08): at a fresh value position a brace form is a value of its own; mid-text it is a piece.
* Embedded forms are always pieces of text (chosen).

**Drivers.**

* Embedded forms are "meant to be embedded in text/string"; same-line text "is always assumed to be non-delimited text which ends with a *block* form of ;, |, or :" (Joseph, under the Quote).
* His 2026-07-19 principle, which this reaffirms: "All *{...} constructs, embeds if you will, are assumed to *reduce to more text*" and "*{ should never take someone out of text/prose mode, and if encountered as the beginning of something, should start text/prose mode as if it was literal text" (quoted in `.int/pre-design/59-where-an-inline-comment-may-sit.md` and `10-…discussion.md`).

**How firm.** His words: "I am under the impression", then "I am very comfortable … for right now, yes". His own reading, so `steward`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).

**Costs accepted.**

* `:x |{em hi}` and `:x |em hi` are different trees: a text with one piece versus an element value.
* A reference "as a value" is a text with one reference piece in the raw tree.

**Joseph's words not already quoted on this card.**

> One thing that, IMO, is still open is this one:
> ```udon
> |nav |{a} |{a}        →  nav  $main a, $main a
> ```
> What *does* remain part of sameline behavior now is the ambiguity of "quote/delimiter free text/string values" ---  I am under the impression that any embedded construct is meant to be embedded in text/string, and that *on sameline* text is always assumed to be non-delimited text which ends with a *block* form of ;, |, or : -- whereas embedded forms just stay part of the text (which is probably the difference between text and a string-- text has any number of pieces some of which are not strings). Under this understanding, the above should give   nav $main  text[embedded_node(a...),' ',embedded_node(a...)] or something.
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

> I'm fine with `:n ;{}` yielding a text AST node with an empty comment as its only inner part.
>
> — Joseph, 2026-10-09 (`.int/STEWARD-VERBATIM.md`), settling `|el :n ;{}`: a text whose only piece is an empty comment; not a missing value
## Working notes

- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > I am very comfortable having embeds always be a distinct chunk of distinct text as if it were a word for right now, yes. Don't forget comments show up in the AST
- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > Under this understanding, the above should give   nav $main  text[embedded_node(a...),' ',embedded_node(a...)] or something.
- `|{a :href / Home}` gives `href` the text `/ Home` and the link no text: an example to watch for and avoid (Joseph, 2026-10-09; [[rule:inline-element-value-end]]).

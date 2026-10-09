---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Embedded forms (|{…}, @{…}, ;{…}) are always pieces of text, like words, never values of their own; same-line unquoted text runs until a block form"
status: accepted
decided-by: steward
decided: "2026-10-09"
updated: 2026-10-09
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: [parser implementers]
wording: rendering
grounds-recorded: at-decision
supersedes: [{adr: main-is-an-attribute, how: revised, scope: partial}]
superseded-by: []
closes: []
leaves-open: ["59", "13 Q5"]
---

# Embedded forms (|{…}, @{…}, ;{…}) are always pieces of text, like words, never values of their own; same-line unquoted text runs until a block form

## Context and Problem Statement

[[decision:main-is-an-attribute]] showed `|nav |{a} |{a}` as two `$main` values. Joseph flagged that line as still open. It came from 0.10.0's K9 (2026-08-08), which narrowed his own 2026-07-19 principle so that a brace form standing at a fresh value position became a value of its own. His reading is the earlier one: on a line, embedded forms stay part of the text, and text ends only at a block form.

## Decision Drivers

* Embedded forms are "meant to be embedded in text/string"; same-line text "is always assumed to be non-delimited text which ends with a *block* form of ;, |, or :" (Joseph, under the Quote).
* His 2026-07-19 principle, which this reaffirms: "All *{...} constructs, embeds if you will, are assumed to *reduce to more text*" and "*{ should never take someone out of text/prose mode, and if encountered as the beginning of something, should start text/prose mode as if it was literal text" (quoted in `.int/pre-design/59-where-an-inline-comment-may-sit.md` and `10-…discussion.md`).

## Assumptions

* None recorded.

## Considered Options

* K9 (2026-08-08): at a fresh value position a brace form is a value of its own; mid-text it is a piece.
* Embedded forms are always pieces of text (chosen).

## Decision Outcome

Chosen, for right now:

- **`|{…}`, `@{…}` and `;{…}` are always pieces of a text**, "a distinct chunk of distinct text as if it were a word": never values of their own, even first in a value slot.
- **On an element's or attribute's line, unquoted text runs until a block form** (` |name`, ` :label`, framed ` ; `); embedded forms along the way are pieces of it.
- **Quoted strings, numbers, lists and `<…>` still stand alone** as values.
- A text is any number of pieces; a string is one quoted piece.
- **`;{…}` comments are pieces too, and show up in the tree** (Joseph's reminder).

For lite this sets aside K9's narrowing of the brace-form principle (and 0.10.0's R4 overturn that went with it).

```text
|nav |{a :href / Home} |{a :href /about About}
                         → nav ($main text[a(…), " ", a(…)])
|el :x |{em hi}          → el (x text[em("hi")])
|el :author @{people/jw} → el (author text[ref "people/jw"])
|cite[@{ref.key}]        → cite ($key text[ref "ref.key"])
|el :n ;{}               → el (n text[comment ""])
|el :x |em hi            → el (x = element em)        ; a block form, unchanged
```

How a consumer may read a text whose only piece is one embedded form is a reading option, not language ([[decision:representational-options]]).

### Quote

> One thing that, IMO, is still open is this one:
> ```udon
> |nav |{a} |{a}        →  nav  $main a, $main a
> ```
> What *does* remain part of sameline behavior now is the ambiguity of "quote/delimiter free text/string values" ---  I am under the impression that any embedded construct is meant to be embedded in text/string, and that *on sameline* text is always assumed to be non-delimited text which ends with a *block* form of ;, |, or : -- whereas embedded forms just stay part of the text (which is probably the difference between text and a string-- text has any number of pieces some of which are not strings). Under this understanding, the above should give   nav $main  text[embedded_node(a...),' ',embedded_node(a...)] or something.
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

> I am very comfortable having embeds always be a distinct chunk of distinct text as if it were a word for right now, yes. Don't forget comments show up in the AST […]
>
> — Joseph, 2026-10-08 (same file, next message), on the agent's restatement of his reading

*His words: "I am under the impression", then "I am very comfortable … for right now, yes". His own reading, so `steward`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).*

### Positive Consequences

* One rule: embedded forms are always in text, wherever they are.
* `|nav |{a} |{a}` keeps the space between the links, as HTML would.

### Negative Consequences

* `:x |{em hi}` and `:x |em hi` are different trees: a text with one piece versus an element value.
* A reference "as a value" is a text with one reference piece in the raw tree.

### What changes

* [[decision:main-is-an-attribute]]'s `|nav` example (two `$main` values) is replaced: `nav` has one `$main` text with three pieces.
* [[decision:references-in]], [[decision:key-brackets-and-lists]] and [[decision:sameline-element-is-child]]: `@{…}` and `|{…}` in values and keys are pieces of a text.
* [[rule:inline-elements]], [[rule:unquoted-values]].

## Reopen when

* None recorded beyond the general revisit condition.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- Open (59): `|el :n ;{}` gives a text whose only piece is a comment. Joseph's 2026-07-19 view was that this equals `:n ""`; whether lite treats it as an empty text, and whether that counts as a missing value, is to pin.
- The AST notation used above (`text[…]`) is a placeholder; a notation is being proposed separately.

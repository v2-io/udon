---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "The backslash by position: on an element's or attribute's line a framed \\ ends the current text; first on a line it is a consumed escape; in prose already started it is just a character"
status: accepted
decided-by: steward
decided: "2026-10-09"
updated: 2026-10-09
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: [parser implementers]
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: ["82", "02", "57"]
---

# The backslash by position: on an element's or attribute's line a framed \ ends the current text; first on a line it is a consumed escape; in prose already started it is just a character

## Context and Problem Statement

With unquoted same-line text running until a block form ([[decision:embeds-are-pieces-of-text]]), lite needed a way to end a text value before more text on the same line, e.g. an attribute value followed by an element's own text. Both AST-notation agents found that `|nav :aria-label Site |{a :href / Home}` puts the link inside `aria-label`, and that `|{a :href /docs the docs}` has no link text. 0.10.0's K13 had a framed ` \ ` *commit* the rest of the line to text; Joseph's rule is different, and he names the difference. The same exchange settled the backslash first on a line and inside prose, and the agent's earlier proposal to make a trailing ` \` in prose a reserved error.

## Decision Drivers

* The backslash is lite's other "text terminator", beside the block forms (Joseph, under the Quote).
* Same-line text should end where the author marks it, without quoting.

## Assumptions

* None recorded.

## Considered Options

* 0.10.0's K13: a framed ` \ ` commits the rest of the line to text.
* A framed ` \ ` ends the current text, like a block form (chosen).

## Decision Outcome

Chosen, by position:

- **On an element's or attribute's line** (same-line), a framed ` \ ` **ends the current text**, the way a block form (` |name`, ` :label`, ` ; `) does. What follows goes wherever it would after a normally ended value. The spaces around the `\` are frame, not content. This differs from 0.10.0's K13, where the framed `\` *began* text that ran to the end of the line.
- **First thing on a line**, `\` is an **escape**: consumed, not part of the text, its position kept in meta, and it sets the indentation. A `\` that escapes just the newline (a lone `\` line) gives a kept empty line; one indented past the text's left edge keeps those spaces as content.
- **In prose that has already started** (not an element's or attribute's line), `\` is just a character, passed through like everything else except embedded forms. A trailing backslash at the end of a prose line is therefore a plain character, not reserved and not an error.

His examples, as he corrected them:

```udon
|nav :aria-label Site |a :href / \ Home
|p See |{a :href /docs \ the docs}
```
```text
nav (aria-label "Site") └ a (href "/", $main "Home")
p ($main text["See ", a(href "/docs"; interior "the docs")])
```

And the lone `\` line:

```udon
|p
  first
    \
  last
```
gives the text `"first\n  \nlast"`.

Still open with Joseph (the coordinator's leans, not decided):

- `:a \` at the end of a line: the coordinator leans toward the missing-value error (0.10.0's `:a \` empty-string idiom would then go, in favour of `:a ""`);
- an attached `\X` on an element's or attribute's line: the coordinator leans toward escaping one character, as in 0.10.0;
- `\|{` in prose: the coordinator leans toward making the embedded form literal.

### Quote

> We definitely still need backslash as our other "text terminator" in addition to the ones we said earlier-- hitting a new |... ;... or :... (block) construct.
> That is *different* (maybe significantly) than the previous iterations that treated / as the *beginning* of text. This is for sameline only I'm pretty sure.
>
> If it's the first thing on a line then it is an escape (and is consumed / not part of the text but probably in meta) -- including escaping just a newline (and thereby also setting the indent level...) and this is distinct from it coming *after* some text which, as noted, in sameline closes `text`, and on a line that is not sameline and already has prose it is just passed through like everything else except embeds.
>
> And yes to your #3 there above-- I'm pretty sure it stays coherent that the rules would imply that p's children would, when combined, be: "first\n  \nlast"
>
> ```udon
>
> |nav :aria-label Site |a :href / \ Home  ; this would be the correct way I would think.
> |p See |{a :href /docs \ the docs} ; and this for the other.
>
> ```
>
> — Joseph, 2026-10-09 (`.int/STEWARD-VERBATIM.md`; "/" in "treated / as the *beginning*" is the backslash)

> wrt " \ " spaces around it as frame-- I support that.
>
> — Joseph, 2026-10-09 (same file, next message)

> I'm now a few messages behind you. You are right-- I was coherent except for the error / reserved part.
>
> — Joseph, 2026-10-09 (same file), on the agent's proposal that a trailing ` \` in prose be reserved as an error

*His words: stated directly ("We definitely still need", "it is an escape", "it is just passed through"), "yes to your #3", and "I support that" (the spaces as frame, the agent's reading). His own call, so `steward`; the frame part is `supported` weight. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]], [[decision:leans-are-working-spec]]). `awaiting-decision` is true only for the three open edges.*

### Positive Consequences

* An attribute value can be followed by more text on the same line without quoting it.
* `\` reads one way per position; prose stays free of it.

### Negative Consequences

* The trailing ` \` final-newline idiom of 0.10.0 is gone; a trailing backslash in prose is content. (The coordinator had earlier proposed making it a reserved error; Joseph's "except for the error / reserved part" set that aside.)

### What changes

* [[rule:escapes]], [[rule:unquoted-values]], [[rule:text-blocks]].
* [[decision:nested-attributes-reserved]]'s note that a line-start `\` was still open (82) is answered: first on a line, `\` is an escape.

## Reopen when

* None recorded beyond the general revisit condition.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- Open with Joseph: `:a \`; attached `\X` on an element's or attribute's line; `\|{` in prose (leans above).
- How boundary blank lines are treated (prose or layout) is still being discussed; with a trailing backslash now a plain character, the remaining way to keep a final newline is a lone `\` line.

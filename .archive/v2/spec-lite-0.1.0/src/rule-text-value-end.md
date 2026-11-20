---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:line-scan, rule:embeds-in-text]
consequences: [rule:framed-backslash-frame, rule:embeds-in-text, rule:value-line-escapes, rule:backslash-empty-text, rule:framed-comments, rule:inline-element-value-end, rule:edge-blank-lines, rule:line-start-escape, rule:line-start-escape-sets-indent, rule:lone-backslash-line, rule:prose-passes-through, rule:space-before-text-end, rule:text-final-line-ending]
---

# Sameline text ends at a block form

*On an element's or attribute's line, unquoted text runs until a block form or a framed ` \ `.*

## Statement

On an element's or attribute's line, unquoted text MUST end at the first of: a space followed by `|name`, a space followed by `:name`, a space followed by a fence opener (three or more backticks), a framed ` ; `, a framed ` \ `, or the end of the line.

## Grounds

- Joseph, 2026-10-08: "text is always assumed to be non-delimited text which ends with a *block* form of ;, |, or :" ([[rule:embeds-in-text]]).
- Joseph, 2026-10-09: "We definitely still need backslash as our other 'text terminator'".
- Joseph, 2026-10-09 (a ruling): "I'm ready to rule that ```(+) is in the same family as |;: and the reserved ones-- just wasn't thinking about it at the time."
- Joseph, 2026-10-09, confirming that the ruling deliberately reverses his 2026-07-14 example (`|a |b but not ```this one` stayed text): "I understand it reverses what I said / wrote in July as that old stuff was based on an older and (it turns out) internally inconsistent perspective on sameline non-delimited text." So sameline text that mentions three backticks after a space opens a fence. To keep the backticks, quote the value (it is then a «string», not a «text»), or escape them once the sameline escape set is settled (open item 3; the coordinator's lean includes `` \` ``).

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|el :a x \ y :b 2
```
````tree
root
  |el
    :a ‹x›
    :$main ‹y›
    :b 2
````

## Discussion

*Carried 2026-10-09 from the decision record `adr/backslash-by-position.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-10-09.*

**Context.** With unquoted sameline text running until a block form ([[rule:embeds-in-text]]), lite needed a way to end a text value before more text on the same line, e.g. an attribute value followed by an element's own text. Both AST-notation agents found that `|nav :aria-label Site |{a :href / Home}` puts the link inside `aria-label`, and that `|{a :href /docs the docs}` has no link text. 0.10.0's K13 had a framed ` \ ` *commit* the rest of the line to text; Joseph's rule is different, and he names the difference. The same exchange settled the backslash first on a line and inside prose, and the agent's earlier proposal to make a trailing ` \` in prose a reserved error.

**Options considered.**

* 0.10.0's K13: a framed ` \ ` commits the rest of the line to text.
* A framed ` \ ` ends the current text, like a block form (chosen).

**Drivers.**

* The backslash is lite's other "text terminator", beside the block forms (Joseph, under the Quote).
* Sameline text should end where the author marks it, without quoting.

**How firm.** His words: stated directly ("We definitely still need", "it is an escape", "it is just passed through"), "yes to your #3", and "I support that" (the spaces as frame, the agent's reading). His own call, so `steward`; the frame part is `supported` weight. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]], [[decision:leans-are-working-spec]]). The three edges then open have since been settled, except the set of attached `\X` escapes on element and attribute lines ([[rule:value-line-escapes]]).

**Costs accepted.**

* The trailing ` \` final-newline idiom of 0.10.0 is gone; a trailing backslash in prose is content. (The coordinator had earlier proposed making it a reserved error; Joseph's "except for the error / reserved part" set that aside.)

**Joseph's words not already quoted on this card.**

> wrt " \ " spaces around it as frame-- I support that.
>
> — Joseph, 2026-10-09 (same file, next message)

> I'm now a few messages behind you. You are right-- I was coherent except for the error / reserved part.
>
> — Joseph, 2026-10-09 (same file), on the agent's proposal that a trailing ` \` in prose be reserved as an error
## Working notes

- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > I am under the impression that any embedded construct is meant to be embedded in text/string, and that *on sameline* text is always assumed to be non-delimited text which ends with a *block* form of ;, |, or : -- whereas embedded forms just stay part of the text
- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > We definitely still need backslash as our other "text terminator" in addition to the ones we said earlier-- hitting a new |... ;... or :... (block) construct. That is *different* (maybe significantly) than the previous iterations that treated [\] as the *beginning* of text. This is for sameline only I'm pretty sure.
- Reasoning (agent's): with embeds as pieces, nothing inside a text can end it except a block form or the framed backslash, so the end of sameline text is one rule.
- The spaces before whatever ends the text are not part of it ([[rule:space-before-text-end]]).
- Embedded forms don't end the text ([[rule:embeds-in-text]]).
- The fence opener joined the list 2026-10-09: before that, `|a some text ```js` stayed all text, while [[rule:fence-anywhere-structure]] let a fence open on a sameline (found by the vocabulary work on «block form»). Now it is `$main ‹some text›` and a fence.
- "The reserved ones" are in the same family: a space followed by a reserved spelling on an element's or attribute's line (`@name`, `!word`) ends the text there too, and is the reserved error ([[rule:reserved-spellings]]).

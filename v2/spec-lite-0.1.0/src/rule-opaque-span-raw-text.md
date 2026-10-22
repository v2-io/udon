---
kind: rule
awaiting-second: true
awaiting-decision: true
needs-work: false
layer: value
strength: provisional
per: []
depends: [def:typed-value, rule:inline-comments]
consequences: [rule:opaque-span-escapes, rule:newline-in-opaque-span-is-error, rule:inline-comments, def:text, rule:matched-pairs-need-no-escape, rule:reserved-spellings]
---

# Opaque spans carry raw text

*The «tree» holds the text between the delimiters of `<…>`, `@{…}` and `;{…}`, escapes resolved, with no meaning attached.*

## Statement

1. For an explicit typed value `<…>`, a reference `@{…}` or an inline comment `;{…}`, the «tree» MUST carry the raw text between the delimiters, escapes resolved, and lite MUST NOT attach meaning to it (no type-label split, no resolving).

## Grounds

- "I vote yes, raw text, for typed delimited values (<...>) and references @{...}" (Joseph, 2026-10-08): the Discussion below; `;{…}` takes the same rules ([[rule:inline-comments]]).

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|el :when <2026-07-11> :size <u64:0xff>
```
```tree
root
  |el
    :when <2026-07-11>       ← text, not a date
    :size <u64:0xff>
```

## Discussion

*Carried 2026-10-09 from the decision record `adr/opaque-spans.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-10-08.*

**Context.** Lite carries `<…>` without reading it ([[def:typed-value]]), which left open where it ends, whether it spans lines, and what the tree holds. On 2026-10-08 `@{…}` references came into lite carried the same way. So one interim rule for both delimited spans was needed. Later the same day Joseph leaned toward `;{…}` comments in prose "with the same escape rules" ([[rule:inline-comments]]); how far this record applies to `;{…}` is below.

**Options considered.**

* Ends where: matched brackets (chosen, as an interim convention) vs the first closer.
* Escapes: only the span's own brackets and `\`, with every other `\X` literal, vs any `\X` gives `X` (chosen).
* A newline inside: warn and close the span at the line's end (Joseph's first suggestion); count warned documents as not accepted (the agent's other alternative); an error in lite (chosen, on the agent's point that a warned-and-accepted reading would make a later multi-line rule change meaning).

**Drivers.**

* "I vote yes, raw text, for typed delimited values (<...>) and references @{...}" (Joseph, under the Quote).
* A convention that is "either already used, intuitive, and/or easily remembered" (Joseph).
* "The rule on where it ends doesn't need to be fixed now if the eventual rule is *broader* than what we allow currently" (Joseph). The agent's point that this holds only if lite refuses what it doesn't define led to the newline error.
* The error must not read as a UDON-wide prohibition (Joseph, the caveat on the message wording).

**Assumptions.**

* Unescaped matched brackets inside a span are more useful (HTML-ish content) than an escape-everything rule. (**recorded**: Joseph, "it is still allowing unescaped *matched* brackets (which doesn't help the regex example, but would help, e.g., an html example or something)")
* The cost to `\`-heavy content (regexes, Windows paths) is acceptable: such content doubles its backslashes. (**recorded**: the agent named the cost; Joseph accepted the lean)

**How firm.** His words: "I vote" (raw text), "I think we can adopt an interim convention" (matched brackets), "I'm ok … for now" (the newline error, the agent's proposal), "I'm OK with your lean" (the any-`\X` escape, the agent's lean), "I'm ok keeping it simple" (the `;{…}` newline). Raw text and matched brackets are his own calls (`steward`); the newline errors are `supported` parts; the escape rule, first `supported` ("I'm OK with your lean"), was reaffirmed in his own words later that evening ("different than our 'general matching + escaping' for arrays, typed values, keys, and embeds"). Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).

**Costs accepted.**

* Regexes and Windows paths inside a span double their backslashes (`<re:\\d+>`).
* An unbalanced bracket in content (`<a -> b>`, `@{x}y}`) has to be escaped.
* Resolving every `\X` to `X` in the tree means a future interior grammar that gives `\` its own meaning (a path grammar's `\.`, say) reads `@{a\.b}` differently from lite, which hands over `a.b`. Acceptable under [[decision:forward-compat-aspiration]]; keeping the unresolved source text in meta would recover it.
* A multi-line typed value, reference or inline comment can't be written in lite.

**Reopen when.**

* Demand for multi-line spans appears (the flag first, then a rule).
* `\`-heavy content inside spans turns out common enough that doubling is a real cost.
* The interim convention is replaced (Joseph called it interim).

**Joseph's words not already quoted on this card.**

> I'm ok though turning the newline in the opaque spans into an error for now, with the caveat that the error message explains that '**lite** doesn't support newlines in ....' so that it doesn't get accidentally adopted in non-lite settings as a prohibition. If some user needs to accept it anyway with a warning we can give a command-line flag to disable it-- *when*/if it's requested/needed. […]
>
> I'm OK with your lean on the opaque escaping -- note that it is still allowing unescaped *matched* brackets (which doesn't help the regex example, but would help, e.g., an html example or something).
>
> — Joseph, 2026-10-08 (same file, next message)

> 2. I'm ok keeping it simple with lite 1.0 and saying newlines in embedded comments are simply reserved with error. The main issue is similar to fence-closing lines-- they make dedent level ambiguous in several corner cases.
>
> — Joseph, 2026-10-08 (same file, later), on `;{…}`

---

*Carried 2026-10-09 from the decision record `adr/references-in.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-10-08.*

**Context.** [[decision:reserve-not-ignore]] listed `@` references, both `@name` and `@{…}`, among the spellings lite refuses, and [[decision:reserved-is-an-error]] made refusal an error with no tree. The estate already writes `@{term}` throughout its `.ud` documents (the addressing theory's `def/` entries; about 190 uses found by the 09 history pass), so every such document had no lite tree. Joseph opened the 2026-10-08 session proposing to consider allowing `@{…}`, unparsed, and then voted for it. This replaces the `@{…}` part of [[decision:reserve-not-ignore]]'s reserved list; bare `@name` forms stay reserved.

**Options considered.**

* Keep `@{…}` reserved (the 2026-09-29 list).
* Carry `@{…}` as a reference with its raw text (chosen).

**Drivers.**

* Carry `@{…}` "but not parsing or checking their inner values-- just having them in the AST as references and that's it" (Joseph, under the Quote).
* "reference is the right name / direction as per address theory" (Joseph).
* Live demand: the corpus's `.ud` files use `@{…}` heavily. (**inferred, unconfirmed** as Joseph's driver: the agent's argument, not restated by him.)

**Assumptions.**

* Lite only needs the extent of a reference, not its interior grammar; the interior belongs to the addressing theory. (**recorded**: "not parsing or checking their inner values")

**How firm.** His words: "I vote yes" (in, raw), "reference is the right name" (the name), (c) inside his "I vote for strict-lean" answer (prose), "my lean: all three" (values and keys). Allowing `@{…}`, carrying it raw, naming it a reference, and its recognition in prose are his own calls (`steward`). Values and keys are his lean. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).

**Costs accepted.**

* Lite fixes how a reference is delimited before the path grammar exists; the path grammar must live inside matched braces with `\X` escapes, or widen it later.

**Reopen when.**

* The addressing theory needs a reference spelling that matched braces can't carry.
* The values or keys position turns out to collide with something (they are leans).

**Joseph's words not already quoted on this card.**

> One main thing I think we may need to consider is allowing @{...} references [after all]-- but not parsing or checking their inner values-- just having them in the AST as references and that's it.
>
> — Joseph, 2026-10-08, opening message

> (c) passed through + reference […] sub-question: my lean: all three.
>
> — Joseph, 2026-10-08 (all in `.int/STEWARD-VERBATIM.md`)

## Working notes

- **Under the 2026-10-21 lean that a bare run is always a «text» ([[rule:unquoted-run-is-one-value]]),** `<…>` is where every non-text kind is written (`<8080>`, `<nil>`, `<"…">`), committing at its first character and an error if the interior doesn't match (Joseph, 2026-10-21: "<920px> error I can understand"). To ask: is a non-primitive interior such as `<2026-10-01>` raw text (his 2026-10-20 option, "passing bare-words … through raw") or an error (his 2026-10-21 `<uint32|0x992BC>` "error- reserved for now")?
- **Joseph's words:**

  > I vote yes, raw text, for typed delimited values (<...>) and references @{...}. […] With the opaque delimited spans (typed values and references) -- I think we can adopt an interim convention of matched braces, warn and pseudo-close span on newline, and detect and unescape either just backslash-escaped brackets for that thing, or potentially consider any single backslash '\' followed by another character as just that next character […] The rule on where it ends doesn't need to be fixed now if the eventual rule is *broader* than what we allow currently.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** Lite attaches no meaning to typed values or references; a later version may parse their insides (a type label, a path) without lite having guessed.
- **`<>` is nil** (Joseph, 2026-10-21/22, a new feature): "`<>` completely empty, == `<nil>` (if that becomes the rule, or == `nil`-value if that is retained). Distinct from "",<"">,'',<''> -> all empty strings, and `<false>` (or currently `false`), obviously." Empty `@{}` is not decided; `:n ;{}` is a text whose only piece is an empty comment (Joseph, 2026-10-09).
- **Joseph, 2026-10-20, from the Markdown dialect spike:** "we will almost certainly want @{<....>} "embeds" as well-- they basically are the non-resolving version where the reference is embedded instead of the referent. Doesn't necessarily change udon-lite spellings etc. since that was always up to the dialect anyway, but this might need to get into the spec and grammar and ast sooner rather than later." Under this card as written, `@{<x>}` already parses: a reference whose raw text is `<x>` (only braces match inside `@{…}`, so `<` needs no escape). What is open is whether the tree tells it apart from `@{x}`. Compare `|el :x @<other-one>` in `obj.future/candidates.md`.
- **Reopened for `<…>` (Joseph, 2026-10-20):** "I know it was already adjudicated that we just pass it through raw... but I think that was premature and needs to be reopened if recorded-- an option though might be <...> may have, within it: `nil`, `true`, `false`, (number, leading with [+\.\d-] and whatever rules), or a delimited string-- specifically *not* watching for bare-words and passing bare-words (or anything other than the above) through raw. This would be more in the spirit of true usage for explicit values." Under that option `<3>`, `<nil>` and `<"hi">` are values of those kinds; `<2026-10-01>`, `<u64:0xff>` and `<hello there>` stay raw. To settle with it: whether the interior must match a value wholly (`<1.2.3>` raw, not an error); whether spaces inside are trimmed (`< 3 >`); whether a `>` inside a delimited string inside `<…>` needs `\>` (`<"a>b">`); and the spelling of namespaces or type labels. `@{…}` and `;{…}` are not affected.


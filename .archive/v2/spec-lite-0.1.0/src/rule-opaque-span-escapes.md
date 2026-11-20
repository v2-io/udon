---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: value
per: []
depends: [rule:opaque-span-raw-text, rule:matched-pairs-need-no-escape]
consequences: []
---

# Escapes inside opaque spans

*Inside `<…>`, `@{…}` and `;{…}` only `\\` and the span's own delimiters may be escaped.*

## Statement

1. Inside an opaque span, `\\` and the span's own delimiters (`\<` `\>` in `<…>`; `\{` `\}` in `@{…}` and `;{…}`) MUST be read as escapes, and any other backslash MUST be reported as an error.

## Grounds

- "only allowing \\ and \<opening-or-closing-delimiter> and *erroring* on every other backslash use for now until something asks us to make an exception" (Joseph's lean, adopted, 2026-10-08): the Discussion below.

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|el :re <re:\\d+> :a <x:a\>b>
|el :bad <re:\d+>
```
```tree
root
  |el
    :re <re:\\d+>     ← raw text re:\d+
    :a <x:a\>b>       ← raw text x:a>b
✗ error unknown-escape 2:13
```

## Discussion

*Carried 2026-10-09 from the decision record `adr/opaque-span-escapes-strict.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `supported`, 2026-10-08.*

**Context.** [[rule:opaque-span-raw-text]] gave the opaque spans the rule "any `\X` gives `X`". The escape-sequence research (`.int/escape-sequences-2026-10-08.md` §4) pointed out that `\n` would then read three ways in lite: a newline in `"…"`, backslash-n in `'…'`, and just `n` in the spans; a regex shows it worst (`<re:\d+>` hands over `re:d+`, silently). The coordinator relayed that note, and Joseph answered with a new lean. This replaces the escape part of [[rule:opaque-span-raw-text]] and the same rule restated in [[rule:inline-comments]]; their extents, raw-text carrying and newline errors stand.

**Options considered.**

* Any `\X` gives `X` ([[rule:opaque-span-raw-text]]).
* JSON-style escapes with unknown `\X` kept as written (the agent's option C, 2026-10-08 ~20:58Z; not taken).
* Only `\\` and the span's own opening or closing delimiter; any other backslash an error (chosen).

**Drivers.**

* Strict now, broader later: error on every other backslash "until something asks us to make an exception-- similar to the "..." unrecognized escape attempts" (Joseph, under the Quote).
* A backslash nobody meant as an escape fails loudly instead of being silently dropped (`<re:\d+>`). (**inferred, unconfirmed** as Joseph's driver: the coordinator's reason for adopting it.)

**Assumptions.**

* Content in spans rarely needs a backslash before anything but `\` or the span's delimiters. (**inferred, unconfirmed**: the agent's)

**How firm.** His words: "I'm now wondering if … we might be better off": a lean, which the coordinator agreed with and adopted. Recorded `supported`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).

**Costs accepted.**

* Regexes and paths in typed values double every backslash (`<re:\\d+>`).
* The same `\"` that works in `"…"` is an error inside a span.

**Reopen when.**

* Something asks for an exception (Joseph's condition).

## Working notes

- **Joseph's words:**

  > With your \n = three things note-- it's true. I'm not worried about the string versions but I'm now wondering if, for the other opaque delimiters we might be better off in lite-0.1.0 at least only allowing \\ and \<opening-or-closing-delimiter> and *erroring* on every other backslash use for now until something asks us to make an exception-- similar to the "..." unrecognized escape attempts.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** Strict now, broader later if something asks; it also turns `<re:\d+>` into a loud error rather than a silent `re:d+`.
- An escaped delimiter doesn't count toward matching ([[rule:matched-pairs-need-no-escape]]).

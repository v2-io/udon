---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: []
consequences: [def:text, rule:backslash-empty-text, rule:attribute-after-attribute-with-no-value, rule:reserved-spellings]
---

# An attribute with no value is an error

*Implicit missing values aren't supported.*

## Statement

An attribute with nothing after it on its line and nothing indented under it MUST be an error, whose message says implicit missing values aren't supported and names `null`, `''` and `\`.

## Grounds

- Joseph, 2026-10-09: "`:a` by itself should be an error something along the lines of 'implicit missing value for attribute is not supported / reserved -- explicitly use nil, '' for blank string, or \ (for empty text)...'".

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|el :d
```
An error at 1:5: implicit missing value; write `null`, `''` or `\`.

## Discussion

*Carried 2026-10-09 from the decision record `adr/missing-values.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-10-09.*

**Context.** [[decision:errors-stop-parsing]] listed "a `:label` with no value" as an error, carrying the earlier drafts' missing-value error. [[rule:text-value-end]] left `:a \` open. Joseph recalled the error's main reason as nested attribute labels being reserved, and leaned toward `:a \` standing for an empty or explicit no-value. The agent replied that the record gives other reasons (2026-07-15: binding; 2026-08-07: the "deletion detector" he ratified), and that `:a \` falls out of "a framed `\` ends the current text" as an empty text. He took that, gave his reason as a new one, and set the message for a bare `:a`.

**Options considered.**

* An explicit "no value" node, read by default as nil (Joseph's first lean).
* `:a \` an empty text; `:a :b 1` and a bare `:a` errors (chosen).

**Drivers.**

* Nested attributes are reserved ([[rule:nested-attributes]]), so `:a :b 1` must not read as anything (Joseph, under the Quote).
* Implicit missing values are not supported; the author spells what they mean (Joseph).

**How firm.** His words: "I agree fully, except…", with his own reason and message. His own call, so `steward`. Decided for this version ([[decision:decided-for-this-version]]).

**Reopen when.**

* Nested attributes get a meaning (then `:a :b 1` needs reconsidering).

**Joseph's words not already quoted on this card.**

> 1. If you'll recall, the primary reason for erroring on missing values was not because they shouldn't be representable -- (equivalent to null/nil or an explicit 'no-value' that is distinct from those in the AST if we would prefer, with a default read-time option to treat it as null) but because we have reserved nested attribute-labels as a potential construct. So I actually lean `:a \` is a perfectly reasonable way to stand in for `:a ''`/`:a ""`, OR as a rule to stand for "explicitly no value specified" which reads by default to be equivalent to null (or nil? I forget which one we landed on in prior iterations).
>
> — Joseph, 2026-10-09

> 1. Consider it a new argument then :-)
>    I agree fully, except the `:a :b 1` should error not as a deletion detector (although it serves that purpose) but due to nested attributes being reserved, and `:a` by itself should be an error something along the lines of "implicit missing value for attribute is not supported / reserved -- explicitly use nil, '' for blank string, or \ (for empty text)..."
>
> — Joseph, 2026-10-09 (both in `.int/STEWARD-VERBATIM.md`)
## Working notes

- The message names `null` since 2026-10-29 ([[rule:nil-spelling]]); Joseph's quoted words below say `nil`, the spelling then.

- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > `:a` by itself should be an error something along the lines of "implicit missing value for attribute is not supported / reserved -- explicitly use nil, '' for blank string, or \ (for empty text)..."
- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > the primary reason for erroring on missing values was not because they shouldn't be representable -- … but because we have reserved nested attribute-labels as a potential construct.

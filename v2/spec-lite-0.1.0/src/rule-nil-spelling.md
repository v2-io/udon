---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: []
consequences: [rule:reserved-spellings, def:typed-value]
---

# `nil` is the only spelling of nil

*A bare `null` is an error that points to `nil`.*

## Statement

`nil` standing alone as a value MUST be nil. A bare `null` where `nil` would be read as nil MUST be an error whose message points to `nil`.

## Grounds

- Joseph, 2026-10-09: "let's go ahead and make 'nil' the only spelling for nil/null. I like null better semantically, but nil is less clunky lexically".
- Joseph, 2026-10-09, on the agent's lean that a bare `null` errors with a hint to use `nil`: "I agree, rule" — a ruling.

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|el :a nil
```
````tree
root
  |el
    :a nil
````
`|el :b null` is an error at 1:8, with no tree: `null` is not lite's nil; write `nil`.

## Discussion

*Carried 2026-10-09 from the decision record `adr/nil-only.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-10-09.*

**Context.** 0.10.0 typed both `null` and `nil` as nil (§11.4: "`null` ≡ `nil`"). Lite takes 0.10.0's frozen bare set (`def/def-typed-value.md` working notes). The agent mentioned that 0.10.0 accepted both; Joseph narrowed it.

**Options considered.**

* `null` and `nil` both (0.10.0).
* `nil` only (chosen).

**Drivers.**

* "nil is less clunky lexically" (Joseph, under the Quote).
* Deterministic typing gets tighter with one spelling (Joseph).

**How firm.** His words: "let's go ahead and make". His own call, so `steward`. Decided for this version ([[decision:decided-for-this-version]]).

**Costs accepted.**

* JSON-trained writers will write `null`; unless it is reserved, it silently becomes text. (Since ruled: a bare `null` is an error that points to `nil`.)

## Working notes

- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > Also, let's go ahead and make 'nil' the only spelling for nil/null. I like null better semantically, but nil is less clunky lexically :-).  Now the deterministic typing just got a even tighter.
- Why error rather than text (the agent's reasoning, ruled by Joseph): a writer who types `null` means nil; reading it as the text `null` would silently change the value's type, and an error fixes the file once.
- The rest of the typed set (integers, floats, `true`, `false`) is [[rule:bare-typing]], not yet written; Joseph called it "pretty stable" (2026-10-08).

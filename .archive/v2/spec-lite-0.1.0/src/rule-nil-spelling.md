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

*A bare `null` is text, with a warning that points to `nil`.*

## Statement

`nil` standing alone as a value MUST be nil. A bare `null` where `nil` would be read as nil is text, and the parser MUST report a default-on «warning» that points to `nil`.

## Grounds

- Joseph, 2026-10-09: "let's go ahead and make 'nil' the only spelling for nil/null. I like null better semantically, but nil is less clunky lexically".
- Joseph, 2026-10-21, revising the 2026-10-09 ruling that a bare `null` is an error: "null as text should cause a warning, not an error, IMO." His word is "IMO": a lean, superseding the earlier "I agree, rule".

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
`|el :b null` gives `b` the text `null`, with a warning at 1:8: `null` is not lite's nil; write `nil`. (Until 2026-10-21 this was an error.)

## Discussion

*Carried 2026-10-09 from the decision record `adr/nil-only.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-10-09.*

**Context.** Earlier drafts typed both `null` and `nil` as nil. The agent mentioned it; Joseph narrowed it to `nil`.

**Options considered.**

* `null` and `nil` both (earlier drafts).
* `nil` only (chosen).

**Drivers.**

* "nil is less clunky lexically" (Joseph, under the Quote).
* Deterministic typing gets tighter with one spelling (Joseph).

**How firm.** His words: "let's go ahead and make". His own call, so `steward`. Decided for this version ([[decision:decided-for-this-version]]).

**Costs accepted.**

* JSON-trained writers will write `null`; it becomes text, with a warning (2026-10-21; from 2026-10-09 to then it was an error).

## Working notes

- **Under discussion (2026-10-29), not decided:** the coordinator's typing recommendation (`.int/spike-values-2026-10-22/typing-recommendation.md`) recommends `null` instead of `nil`, from the value trial (every agent working from a basics sheet wrote `:owner null` untaught) and from the text data formats (JSON, YAML, HCL, CUE and CBOR all spell it `null`). Joseph has been leaning toward `nil` (2026-10-09, "less clunky lexically") and said he'd be comfortable switching; he hasn't decided. If it switches: this card's Statement, [[rule:missing-value]]'s message, and every card that names `nil`.

- **To ask Joseph, under the 2026-10-21 lean that a bare run is always a «text» ([[rule:unquoted-run-is-one-value]]):** a bare `nil` is then the text `nil`, which the typed-primitive view reads as nil. Is the spelling of nil now `<nil>`? Does the bare-`null` warning stay, and does it point to `<nil>`?
- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > Also, let's go ahead and make 'nil' the only spelling for nil/null. I like null better semantically, but nil is less clunky lexically :-).  Now the deterministic typing just got a even tighter.
- Why error rather than text (the agent's reasoning, ruled by Joseph): a writer who types `null` means nil; reading it as the text `null` would silently change the value's type, and an error fixes the file once.

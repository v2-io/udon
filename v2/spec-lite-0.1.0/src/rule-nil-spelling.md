---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [nil-only]
depends: []
consequences: [rule:reserved-spellings]
---

# `nil` is the only spelling of nil

*A bare `null` is an error that points to `nil`.*

## Statement

`nil` standing alone as a value MUST be nil. A bare `null` where `nil` would be read as nil MUST be an error whose message points to `nil`.

## Grounds

- Joseph, 2026-10-09: "let's go ahead and make 'nil' the only spelling for nil/null. I like null better semantically, but nil is less clunky lexically" ([[decision:nil-only]]).
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

## Working notes

- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > Also, let's go ahead and make 'nil' the only spelling for nil/null. I like null better semantically, but nil is less clunky lexically :-).  Now the deterministic typing just got a even tighter.
- Why error rather than text (the agent's reasoning, ruled by Joseph): a writer who types `null` means nil; reading it as the text `null` would silently change the value's type, and an error fixes the file once.
- The rest of the typed set (integers, floats, `true`, `false`) is [[rule:bare-typing]], not yet written; Joseph called it "pretty stable" (2026-10-08).

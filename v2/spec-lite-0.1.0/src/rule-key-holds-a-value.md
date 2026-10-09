---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: element
per: []
depends: [def:string, def:text, def:typed-value]
consequences: [rule:key-escapes, rule:list-items-whitespace-separated, rule:matched-pairs-need-no-escape]
---

# A key holds a value

*The inside of `[key]` is read by the ordinary value rules.*

## Statement

1. The inside of a key (`[…]` directly after an element's name) MUST be read by the same value rules as an attribute value.

## Grounds

- "I agree with your lean toward (a)" — the inside stays a value (Joseph, 2026-10-08): the Discussion below; his August position, no syntax divergence between key interiors and attribute values.

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|step[1]
|step["01"]
|cite[@{ref.key}]
```
```tree
root
  |step
    :$key 1
  |step
    :$key "01"
  |cite
    :$key ‹@{ref.key}›
```

## Discussion

*Carried 2026-10-09 from the decision record `adr/key-brackets-and-lists.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `supported`, 2026-10-08.*

**Context.** After the opaque spans got a strict escape rule ([[rule:opaque-span-escapes]]), the agent asked whether `[…]` lists and `[key]` brackets follow it (`|el :tags [a\]b c] :k[x\]y]`) or 0.10.0's rule that a backslash mid-word is literal. Joseph had earlier grouped "arrays, typed values, keys, and embeds" under one "general matching + escaping" rule ([[rule:strings-like-ruby]]). He answered that key brackets follow the same rules and lists don't. The agent then asked what "the same rules" means for keys: (a) only the matching and escape rules carry over and the inside is still a value (`|step[1]` an integer), or (b) a key is an opaque raw-text span. He chose (a).

**Options considered.**

* Keys and lists both take the strict span rule.
* (a) Key brackets: bracket matching and the strict escape rule; the inside is still a value. Lists: their own rule (chosen).
* (b) A key is an opaque raw-text span.

**Drivers.**

* Keys are value slots (0.10.0, K2/K16: "a key is not a different syntax, it is a value slot"); (a) keeps that. (**inferred, unconfirmed** as his driver for (a): the agent's reason for the lean he agreed with.)

**How firm.** His words: "you're right" and "I agree with your lean toward (a)" (keys, the agent's lean); "arrays are their own thing completely" (lists, his own words). Recorded `supported`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).

**Costs accepted.**

* A `]` or `\` in a bare key needs an escape.

**Joseph's words not already quoted on this card.**

> consequences: understood, agreed.  and #2, you're right-- key-brackets should follow the same rules, but arrays are their own thing completely-- multiple whitespace delimited values.
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)
## Working notes

- **Joseph's words:**

  > 1. (keys) -- You're right-- I also forgot about key particulars. I agree with your lean toward (a) -- I do worry about "string" being its own distinct type from "text" :-)
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** Keeps keys and attribute values one value grammar, as Joseph wanted in August; only the bracket and escape handling is shared with the opaque spans.
- Open: where unquoted text inside a key ends (at the `]`, presumably).
- An element as a key (`[|name …]`) is not decided.

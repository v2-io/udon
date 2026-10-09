---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
terms: [value]
per: [term-typed-value]
depends: [def:string, def:text, def:typed-value, def:stacking, def:prose, rule:element-values, rule:missing-value]
consequences: []
---

# value

*A «value» is whatever an attribute holds, one per occurrence: a «string», a «text», a number, `true`/`false`, `nil`, a list, an «explicit-typed-value», or an element.*

## Terms

- **value:** what one occurrence of an attribute holds, including `$key`, `$traits` and `$main`; also what a list item or a key's interior holds. In lite it is one of: a «string», a «text», an integer or float, `true` or `false`, `nil`, a list of «value»s, an «explicit-typed-value», or an element ([[rule:element-values]]).
  - *Avoid:*
    - **"typed value" as the general word.** Joseph renamed the lexicon's "value" entry to "typed value" on 2026-09-30, and the card [[def:typed-value]] uses "typed-value" in a narrower sense. While both senses are alive, writing "typed value" for "any value" is ambiguous. See the working notes.
    - **"scalar"** for any value. 0.9.1's primer has `Scalar = String | Integer | Float | Boolean | Nil | List | Envelope`, and Joseph has said "attribute values are *typed literals / scalars*" (2025-12-24) and "sameline text is a scalar" (2026-08-08). A list isn't a scalar in any other notation, and a «text» with embeds isn't one either.
    - **"literal" / "typed literal"** for the value. A literal is source spelling; the value is what the «tree» holds. (Joseph 2025-12-24; the agent's recommendation of 2026-09-30, which he declined.)
    - **"content"** for an attribute's value. In 0.10.0, `Assignment = {label, content: [Item]}`, but "content" is also its word for an element's children.
    - **"item" / "contribution"**: 0.10.0/0.10.1's words for one stacked occurrence's value (K15).
    - **"value slot" / "value position" / "value-expected position" / "value-space":** 0.10.0's names for *where* a value may be written. Lite cards still say "value slot" and "value position" (6 files) without defining either.
    - **"bare value"**, which has meant two different sets (everything outside `<…>`, or unquoted values only). See [[def:typed-value]].
    - **"text value" / "flow value"** (0.10.0 / 0.9.1) for a «value» that is a «text». It survives in the card slug `rule:text-value-end`.
    - **"node value"** (0.10.0) for an element held as a value: in lite it is just an element.

## Invariants

- Every attribute occurrence has exactly one «value». An attribute with none is an error ([[rule:missing-value]]); repetition is [[def:stacking]].
- A «string» and a «text» holding the same characters are different «value»s ([[def:string]]).

## Examples

```udon
|el :a "x" :b x :c 3 :d nil :e [1 2] :f <u64:0xff> :g |em hi
```

`a` holds a «string», `b` a «text», `c` an integer, `d` nil, `e` a list, `f` an «explicit-typed-value», and `g` an element.

## Working notes

- **Not reviewed with Joseph; not a term he has settled.** This card was added 2026-10-09 so that the general word has a definition to argue about. Its working definition is the one the cards already use without saying so.

- **Joseph said "value" is not a term:**
  > I fixed "value" which is an ambiguous term we're not using -> typed value like I suggested, to emphasize and clarify it vs the general term, since all values have types in udon.
  >
  > — Joseph, 2026-09-30T02:21Z (`history.jsonl` line 21329)

  His fix, read from the session transcript (`5930da5d…jsonl`, the agent's Write at line 1700 and its Read after his edit at line 1812), renamed one lexicon entry:
  - before: "**value** — what an attribute or same-line slot holds: an implicit typed value, an explicit typed value, a quoted string, a text run, or (open: 64) an element."
  - after: "**typed value** — what an attribute or same-line slot holds: …" (the rest unchanged).

  So in his own edit, "typed value" was the general term, covering quoted strings, text and elements. That lexicon was then deleted as "really sloppy" (his complaints were the mixed sameline spellings, the missing element-/attribute-sameline split, cruft and order, not this entry).

- **How he actually uses "value" since** (a reading of his usage, not something he said): constantly, and as the general word. "a label with no value"; "values as indented child blocks of an attribute"; "multiple whitespace delimited values"; "implicit missing value for attribute is not supported"; "a `text` construct with just one embed in a value slot". The cards do the same in about every value-rule card. So he declared the word retired but uses it as a plain-English word everywhere. One possible reading reconciles the two: "value" is fine as an ordinary English word but shouldn't be a *defined term*, because it says nothing about type. If that reading is right, this card shouldn't exist, and the cards would use «typed-value» wherever they mean the defined sense. That's ambiguous, so it's flagged here.

- **The three senses "typed value" now has** (all from the record):
  1. any value (his 2026-09-30 lexicon edit; "since all values have types");
  2. «value»s that aren't elements and are typed by spelling (the current [[def:typed-value]]);
  3. `<…>` specifically, in his later usage: "typed delimited values (<...>)" and "the opaque delimited spans (typed values and references)" (2026-10-08), "arrays, typed values, keys, and embeds" (2026-10-08). And "what about 'typed-value' instead of box?" (2026-09-30T02:07Z), where "box" was the `<…>` construct.

  Sense 3 is how he has used the bare phrase most recently; sense 1 is what he wrote into a definition. So "value" vs "typed value" can't be settled without settling which of these he means.

- **Precedents:**
  - JSON (RFC 8259): "A JSON value MUST be an object, array, number, or string, or one of the following three literal names: false null true". So "value" is the general term there, and the keywords are "literal names".
  - YAML: "node" is the general term (scalar, sequence, mapping); "value" is informal, mostly "mapping value".
  - TOML and KDL: "value" is general. KDL (v2 spec §3) calls a node's positional values "arguments" and its `key=value` pairs "properties".
  - XML: `AttValue` is the attribute's value, always a string.
  - Lexers: a *literal* is a token that denotes a value; the value is what it denotes.

- **Register and affordances.** To a reader, "value" says "the thing on the right of the attribute". It doesn't promise a type, which is both why Joseph distrusts it and why it's convenient. An agent reading `:a "x"` and `:a x` will assume both have "the value x". Lite says they differ (a «string» vs a «text»), and that difference is easier to state when there's a general word to contrast them against.

- **Candidates:**
  - «value» as the general term, «typed-value» narrowed or dropped. Costs: undoes Joseph's 2026-09-30 move.
  - «typed-value» as the general term (his edit). Costs: «explicit-typed-value» and «implicit-typed-value» then partition *all* values, so a «text» and an element must count as one or the other.
  - No general defined term: plain-English "value" in prose, and specific terms («string», «text», …) wherever it matters.

- **My own lean (the vocabulary agent for values and text, Opus 5.5, 2026-10-09; an opinion, not a finding):** the third, or the first. The thing the cards need most is a word for "what one attribute occurrence holds", and every card already uses "value" for that; renaming it to "typed value" would make every value rule read as if it excluded «text» and elements. But his "since all values have types in udon" points at something real: if «text» and «string» are both «value»s, each has a type, and saying so is part of the string/text distinction.

- **Collisions to watch:** `value slot` / `value position` in the cards: a place, not a «value». `$main` holds «value»s, which makes "sameline text" a «text» «value» of `$main`, not prose ([[def:prose]]).

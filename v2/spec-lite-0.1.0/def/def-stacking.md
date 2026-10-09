---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: [stacking]
per: []
depends: [rule:leftover-values]
consequences: [def:value, def:main]
---

# stacking

*«stacking» is what happens when one element gets the same attribute more than once: every occurrence is kept, in written order, each with its own «value». Nothing is overwritten.*

## Terms

- **stacking:** an element's holding several occurrences of one attribute, each with its own «value», kept in the order written, wherever they appear among its other attributes. It happens when the attribute is written more than once (`:x 1 :x 2`), when values are left over on an attribute's line ([[rule:leftover-values]]: `:x "one" two`), and when `$main` gets several values. (In 0.10.0, `.a.b` also gave `$traits` twice; lite's trait rule is still a gap, `rule:keys-and-traits`.)
  - *Avoid:*
    - **"last-wins"** and **"overriding"**: what stacking replaces. KDL (rightmost property wins), JSON in practice, and CSS all work that way; UDON never has (0.10.0: "Last-wins does not exist in UDON").
    - **"warn and stack"** (Joseph, 2026-07-16: "WARN AND STACK THEM BOTH INTO AN ARRAY"), **"warned extension"** (0.9.1): the version with a warning, retired by Joseph on 2026-08-08T03:53Z, `history.jsonl` 18796 ("I don't think we need a Warning for stacked values at all").
    - **"multi-segment value"** (retired by 0.9.1), **"multi-value attributes"** / **"multi-valued attrs"** (Joseph, 2026-07-12 and 2026-08-08): name the result, not the act.
    - **"repeated attributes"**: the gap card `rule:repeated-attributes` uses it for what a consumer sees. Plain English, not wrong, but a second name.
    - **"duplicate keys"** (pre-design 54's title): "key" is identity only, and "duplicate" suggests an error.
    - **"contribution"** (0.10.1 / K15) for each occurrence's «value»; **"collection"** (0.10.1: "a label names a collection").
    - **"stack" in its other UDON senses**: the indentation stack (`rule:fence-closer-is-a-line`), Joseph's "bracket-stack" for nested `<…>` (2026-07-14), descent's call stack. "Stacked" in a card can mean either.

## Working notes

- **Joseph's own term (since 2026-07-11); the inventory lists it as settled.** What remains open is the shape a consumer sees (pre-design 65, the gap card `rule:repeated-attributes`), not the word.

- **Joseph's words:**
  > - attribute value stacking (my vote: required standard behavior, order guaranteed to be preserved [of the values assigned to the same attribute, :'$trait' style])
  >
  > — Joseph, 2026-07-12T00:48Z (`history.jsonl` 15815)

  > Well, let's be clear. "$main stacks the same way" - ALL attributes stack the same way-- this isn't unification, it's invention. Stacking behavior has always been *turns what was just a simple scalar into a list of scalars*. :$key was "the-key", not :$key = ["the-key"] unless there was a second key declared.
  >
  > — Joseph, 2026-08-09T15:33Z (`history.jsonl` 18910)

- **A reading of his usage:** to Joseph, "stacking" names both the act (writing an attribute again) and its result read as a list ("turns … a simple scalar into a list of scalars"). The cards so far use it for the act and for the kept occurrences, and leave the list reading to `rule:repeated-attributes`. Defining the term as the act and the kept occurrences, not the list, keeps it out of that open question.

- **Precedents:** LDAP attributes are multi-valued by design; HTTP lets a field line repeat and treats the values as a list (RFC 9110); URL query strings allow `?a=1&a=2`. On the other side, XML forbids a repeated attribute (the "Unique Att Spec" well-formedness constraint), TOML and YAML make duplicate keys an error, and KDL v2 says "rightmost properties with identical names overriding earlier properties" (§3.4, checked 2026-10-09). "Stacking" itself has no outside precedent with this meaning that I know of; CSS's "stacking context" is about z-order.

- **Affordances.** "Stack" suggests last-in, first-out, so a programmer may read "the stacked value" as the *top* one, i.e. the last, which is the last-wins reading stacking exists to rule out. "Accumulate" or "append" don't have that pull. The term is his and long-established in this project, so this is a note, not a candidate list.

- **My own note (the vocabulary agent for values and text, Opus 5.5; an opinion):** keep the word, and give the definition one sentence saying that no occurrence is privileged, since the LIFO reading is the one an agent without context will reach for.

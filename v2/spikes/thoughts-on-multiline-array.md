# Thoughts on multi-line arrays — three readings, and the one that deletes a rule instead of adding one

**Status: thoughts, 2026-07-29 (Fable), from an in-session exchange with Joseph.** Nothing here closes the ML carve-out or rules anything; the third reading is a live invasive-change candidate for 0.9.1 under the O17/O18 posture (demand/theory-side, cheapest-window), awaiting Joseph. His words are verbatim; the analysis is mine, *proposed*.

## The question, as asked

> Your thoughts on array *values* opening geometric/block-mode:
>
> ```udon
> :some-attribute [
>    <123>
>    |another-child
>      and some text in the heterogenous array's element
>    and some text in the array itself
> ]  ; don't know -- probably same "guidance" as closing ``` -- end it where it will make the next lines clear about their parentage if you can....
> ```

And then, the same session, the option that reframes it:

> A cleaner option is to simply lean into the stacking we already do and simply allow an attribute to have multiple children and call it an array without warning about it like we currently do. It's a regulator that no one asked for but that I put in there when I was afraid the format was getting too loose and was prone to exploding. But that doesn't seem to scare me anymore in this case.

## The three readings

The sketch's interior is *content*, not items: an envelope value, a block element with its own text child, and a loose prose line. Today's list law excludes exactly that (items space-delimited, no flow in lists, items have no tails). So:

**Reading 1 — line-delimited items.** At depth, newline joins space as an item delimiter; each line is one value by the full value rules; the loose prose line is one flow item. Keeps list semantics; costs a context-dependent relaxation (flow-in-lists at depth only) of the kind the language refuses elsewhere.

**Reading 2 — anonymous-content sugar.** A multi-line `[` desugars to an anonymous node value; the interior is ordinary element content under the Nesting Rule. Notable: this makes the bracket a spelling of the *pure unit element* the type-algebra spike found unspellable (§9) — a demand arriving an hour after that spike priced it weak. It also carries the one genuinely new mechanism in the sketch: **geometric extent with delimited attestation** — geometry parses (bounded lookahead intact, streaming-safe), while the printed `]` does the one thing geometry can't: distinguish "dedented" from "truncated" (`]` missing at dedent → warn-and-keep; missing at EOF → `incomplete-input`). That is a third extent kind §13.1 doesn't have, and it is what the fence-closer placement guidance already is in embryo. Joseph's closer instinct ("end it where it makes the next lines clear about their parentage") is this attestation reading stated as style.

**Reading 3 — stacking-as-array (Joseph's).** No brackets at all. `:attr` followed by multiple deeper values/nodes is *already* a sequence in the model — §6.7's warned extension is literally "kept as a further assignment under that key" — and the only thing marking it deviant is the warning. Drop the regulator; the per-key stack **is** the array:

```udon
:some-attribute
  <123>
  |another-child
    and some text in the element
  and some text in the array itself
```

## Why reading 3 is the cleanest — five alignments, none manufactured

1. **It deletes an anomaly instead of adding grammar.** Zero new syntax, zero new extent rules, zero guard changes. The recognizer already produces exactly this structure; the change is one severity table row.
2. **The model was already there.** MODEL §3: "stacking is the model"; the warned extension is *already defined* as a further assignment. The machinery ships; the warning was the sole dissent.
3. **The type algebra was already built on it.** Row fields are per-key stack languages — regexes over values, with `{n,m}` quantifying the *stack*. The algebra never needed the warning and never encoded it; under reading 3 the schema story is untouched and was, in hindsight, designed for this reading from the start (the trace-monoid quotient's per-key free monoids *are* these arrays).
4. **The language already lives this idiom for itself.** `.a.b` trait sugar = two `$traits` assignments = "traits: always a list" through the view. Reading 3 extends the language's own designated-attribute idiom to every key.
5. **ML partially dissolves.** The bracket's multi-line question loses its motive force: `[…]` stays inline/delimited (one line, item semantics, unchanged), and depth does arrays. The carve-out's hoped-for dissolution arrives from stacking rather than from dialect-captures — or alongside them.

## The regulator archaeology, and why the fear is discharged rather than ignored

The warning was a blanket recognition-layer constraint standing in for a schema layer that didn't exist: "the format might explode into looseness" is a *constraint* fear, and constraint belongs to schemas by the core's own owner table. Now that the schema layer has a design (arity bounds per key; `{1,1}` catches an accidental second value with *better* precision than a blanket warning, and with the author's declared intent behind it), the regulator's job has a proper home and the regulator can retire. This is the O17 shape exactly: a supply-era guess, corrected by the demand side arriving — and per O18, at the cheapest moment it will ever have.

## Costing the change (invasive-change candidate, priced)

- **§6.7**: `AttributeSecondValue` (deeper further values) stops warning — this is the change. `AttributeValueExtendedByTrailingText` (same-line trailing after a finished value on a block-attribute line) is a *different code with a different shape* — genuinely accident-prone (quote-then-tail) — and plausibly stays warned; the two codes split cleanly and should be decided separately.
- **§6.5 deferred values**: "a multi-line flow value, or a node" becomes "a sequence of values/nodes/flow" — the ownership rows unchanged; the attribute simply collects siblings.
- **§6.8 unchanged**: a deeper `:key` under an open value stays the attr-under-attr Error (L6); the named-carrier idiom for maps stands.
- **SEMANTICS unchanged**: stack ≠ list ≠ content distinctions all survive; "call it an array" is the *view* language (the ergonomic view already reads `:x 1 :x 2` as `[1,2]`).
- **Refactoring hazard transfer**: the warning's stated purpose (block→sameline join changes ownership) is real but is better served by schema arity than by a blanket warning — per-key intent versus global fear.
- **Open edges to decide with it**: deeper material under a *flag* key (stacks under `:ready?`?); blank lines between stack entries (S9-adjacent, ornamentation model); whether reading 2's truncation-attestation is wanted *anywhere* once reading 3 covers the main demand (geometric stacks close silently at EOF, same as element content today — probably fine, priced not hidden).

## Relation to the other two readings

Reading 3 doesn't kill reading 2's one novel asset — the attested closer — it just removes the main demand pressure for it. If truncation-certification of sequences ever earns its way in (agent-written ledgers cut off mid-write are a real shape), the bracket-as-attestation is waiting, already analyzed. Reading 1 dies happily: everything it offered, reading 3 does with less.

*If ratified: a DELTAS row, a DECISIONS entry with this file as the reasoning record, the §6.7/Appendix-B text change, and fixture updates. The old parser's behavior is irrelevant to the decision (it warns; it would simply be lagging one more ruled row).*

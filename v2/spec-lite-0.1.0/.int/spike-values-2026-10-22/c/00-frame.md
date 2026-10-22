# Frame: where a value's meaning can come from

*Spike c, working file. Written early (before branches ran), revised at the end; labels mark what is checked, guessed, or taste.*

## The question as I took it

The span (verbatim 1543–1751) opens on the trailing colon, `<>` as nil, and "`<…>` in all of its forms is still very cheap to change", then widens to the whole type territory: slot type vs literal notation, units, algebraic names, the old standard set, dialects, host types, display. The coordinator's one-line gloss was "how lite's values come to mean what they mean." The decision that matters for lite 0.1.0 is narrower than the territory: **what the lite tree records about a value, and what lite's spelling lets a writer assert**, so that types, notations and units (C4, C5) can be layered on later without changing any tree lite already produced.

## The geometry (the agent's; the claim is checked by construction below)

A value's kind can be known from exactly three places, ordered by when a reader learns it:

| Source | When it is known | Lite spelling today | Example |
|---|---|---|---|
| **Slot**: the name, a schema, a vocabulary, an annotation on the name | *before* the value's first character | none in lite (schemas are external; filename convention) | `port` is u16 \| standard-port |
| **Start mark**: a delimiter that opens the value | *at* its first character | `"…"`, `'…'`, `[…]`, `<…>`, `|name` | `<8080>` |
| **Spelling**: what the whole run looks like | only *at its end* | the typed-primitive view, or option B | `8080` |

Consequence (a near-tautology, but it organizes everything): **a consumer that must know a value's kind before its content arrives** — a streaming transcoder to JSON that has to choose between writing `"` or not, a typed SAX handler — **can get it only from the slot or the start mark.** Spelling-decided kind is always kind-at-close. So:

- *concise* (no mark on `8080`) **and** *kind-first* ⇒ the kind comes from the **slot**;
- no slot available (schema-less data) **and** kind-first ⇒ a **start mark**;
- no slot, no mark ⇒ kind-at-close, decided by spelling, by whoever applies the classifier (the parser under B, a view under C).

Joseph's distinction "*this is what the slot is* vs *this is what my literal represents*" is the first row against the second and third. A5 (domain-forward, 9) says the slot should carry it wherever it can.

## What the streaming law constrains (checked against the reference parser)

See `checks/streaming-holdback.md`. Short form: the 0.9 pushdown parser holds every captured token, text included, from its mark to its terminator; 0.9 already decides some events' kinds at their close (HOLD/RELEASE for `$key` vs `$partial-key`). So "bare `8080` would make the parser hold an unbounded run" is true, and equally true of bare text today. What B adds over C is *kind-at-close*, not *holdback*. Whether that matters depends on the wire, not on lexing.

## Decision points (each a branch family in `branches/`)

- **D1** Does the tree classify a bare run? (no: C0, Cv; yes: B, B-capped; first character: A)
- **D2** What `<…>` holds and asserts; whether `<` is the right mark at all.
- **D3** Where a non-core notation or type is named: inside the literal, on the slot (`:when:dt`), or only outside lite.
- **D4** The standard set: which kinds are portable core, and how strict the number spelling is.
- **D5** Units.
- **D6** `nil` / `true` / `false` spelled bare or marked; `<>`.
- **D7** The trailing colon on attribute names (ornament, compulsory, or a type slot) against `xml:lang`.
- **D0, the frame rejection:** lite has no type system; it records form faithfully, and types are a separate layer over any UDON tree.

# Branch D0: reject the frame (lite has no type system)

*Spike c, worked by the spike agent itself. The frame being rejected: "lite needs a type notation now." The alternative: lite's spec says only what the tree records about how a value was written, and every question of kind (numbers, booleans, nil, dates, units, ports) belongs to a separate layer read over any UDON tree, lite or full, the way XSD sits over XML and JSON Schema over JSON. Scores are hypotheses.*

## The pure version

- A bare run is a «text». A quoted value is a «string». `[…]` is a list, `|name` an element, `@{…}` a reference, `;{…}` a comment piece. **That is every value kind in lite.**
- `<…>` is **reserved whole**: any `<` that opens a value is an error ("lite reserves `<…>` for typed values; write the value bare, or quote it").
- Kind is read, never parsed: `bool(:tls)`, `int(:port)`, `date(:on)`, each by a notation the reader names (the standard numeric notation, ISO 8601, a domain's own `YY-MM-DD`).
- A companion (not the spec) publishes the **standard notations**: the portable spellings of integers, floats, booleans and nil, with the host mapping guide. Every reader means the same thing by `int`.

## Pushed to its implications

- **`<>` as nil, `<nil>`, `<8080>`: all gone.** Nil has no spelling in lite. A slot that can be absent is absent (no attribute), or a reader convention reads an agreed text (`nil`) as nil. That is a real loss against Joseph's new `<>` feature (2026-10-22) and against "missing vs nil" distinctions that JSON data carries (`"note": null` vs no `note`).
- **JSON round trip.** `{"port": 8080, "zip": "01234"}` → lite → JSON without a schema gives `{"port": "8080", "zip": "01234"}`. Kind is lost in the schema-less direction, and **only there**. With any schema it comes back exact.
- **What the spec saves.** No number grammar anywhere; no `rule:bare-typing`; no nil rule; no `<…>` interior rules (escapes, nesting, matched brackets) for 0.1.0; `<` gets a single reserved row.
- **Headroom (B6) is maximal.** Full UDON gets `<…>` whole, with no compatibility constraint from lite's choices inside it.

## Where it breaks: tried to make it work, and why it can't be clean

1. **Nil.** Every attempt to put nil back without a spelling is a reader convention ("the text `nil` means nil"), which is the typed-primitive view under another name. Data needs a way to say "present and empty-of-value" (JSON's `null`) distinctly from absent. The pure version can't say it in-document. *This is the one honest hole.*
2. **The schema-less JSON writer.** Joseph's objective `obj:represent-structured-data` Statement 2: "each value's kind decided by how it is written." The pure version fails it as stated: kind is decided by the reader. That objective is explicitly open to revision in this exploration (its working notes, 2026-10-22), so this is a conflict to put to him, not a veto.

## The landing: D0 dissolves into a principle, not a design

The pure version fails on nil and on schema-less kind. Its *principle* survives into every surviving branch: **the tree records what was written (spelling and form); kind is the reader's, brought by a slot; the document asserts kind only where no slot can.** Cv is D0 plus exactly the assertions schema-less data needs (`<nil>`, `<>`, `<true>`, numbers, `<"…">`). So D0 measures **what those few marks are worth**: they buy nil, and schema-less kind, at the cost of spending part of `<…>`.

## Scores against CTQ-FACTORS (hypotheses; only where they differ from Cv's page)

| Factor | D0 | Cv | Why the difference |
|---|---|---|---|
| A6 spec clarity (9) | 10 | 9 | no `<…>` interior at all |
| A7 syntactic simplicity (8) | 10 | 9 | no number grammar anywhere |
| B6 headroom (7) | 10 | 8 | `<…>` unspent |
| C1 structured data (10) | 3 | 5 | no nil, no schema-less kind |
| A2 generative guessability (10) | 4 | 5 | `<>`/`<3>` exist in Cv for the writer who wants them; here the writer has nothing to reach for |
| B4 errors that teach (8) | 6 | 7 | every `<…>` errors, including the obviously meant `<nil>` |

**Verdict: dead as a design** (nil can't be written; C1 at 3 against a weight-10 objective), **alive as the principle** the other branches are judged by. Confidence: medium-high on the nil hole, medium on the scores.

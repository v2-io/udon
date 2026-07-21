# Direction & loose ends — 2026-07-19 (wire deratification → clean-room rewrite)

A handoff. This session pivoted the project's near-term direction; the front-door
docs (`README.md` "Where things stand", the "queue to core-v0.9.0") predate the
pivot and are being caveated but not yet rewritten. Read this first.

## The pivot (why the 0.9-tag path is on hold)

1. **Started** landing the `*{` inline-brace principle in CORE (done — no inline
   brace form is a boundary marker; block-form `|name` is a node value, `|{…}` is
   inline text; in value position a brace form commits a flow value) toward the
   `core-v0.9.0` tag.
2. **The leaky `*{` edges exposed a deeper defect:** the flat "Event Encoding
   (0.9 Wire)" carried attribute-value **extent only implicitly** (via re-emit
   presence / `BareValue`-vs-`Text`), so the event stream cannot separate a
   value from the element's child content (exhibit W5: `|el :v1 hey` + a deeper
   `more text` line + a `|child` line — ownership rides on what is *not* emitted).
   **DERATIFIED** (CORE "Event Encoding" banner + CHANGELOG). Corrected intent
   (Joseph): *an `Attr` is always followed by exactly its value, and that value
   is self-delimiting.* Replacement direction (to ratify): an explicit value
   bracket — `AttrStart`/`AttrEnd` (a fresh spec-only agent derived the same
   shape independently). Full analysis: `wire-value-model-2026-07.md` (this dir).
3. **Deeper still:** CORE is *implementation-coupled* — it narrates "the parser
   does X", links to the grammar, and justifies design by the parse strategy
   (recursive-descent/PEG). A **parser-agnostic language contract** is a bigger
   coherence win than any single fix; plus the terminology accreted over the fast
   ratification cycle and was never re-cohered (blob/flow, positional/geometric,
   embedded/inline-element, freeform/fence …).
4. **→ Methodology: clean-room re-derivation.** `greenfield/` = the first
   (tainted-by-residual-priming) spec-only *event-model* derivation (Fable —
   its `EVENTS.md` independently reached the value bracket). `greenfield-2a` +
   replicas `2b/3a/3b` + `greenfield-pristine` (template) = **untainted**
   clean-rooms: the language spec **scrubbed** of all event/wire vocabulary,
   impl-strategy, peek-door cross-refs, and dated breadcrumbs; callout-annotated
   (IDIOMATIC / AVOID / UNDEFINED BEHAVIOR / CURRENT BEHAVIOR — convention in
   `spec/TODO-SPEC-OTHER.md`); plus four snippet sets, a 152-term jargon probe,
   and `defining-udon.md`. **2-series** agents derive the event/AST model;
   **3-series** agents attempt a cleaner spec rewrite (Gemini on 3a, grok on 3b;
   possibly a Fable synthesis of both). `README-FIRST.md` in each carries the
   two agent caveats (ignore CURRENT/UNDEFINED callouts + the "the parser" voice).

## Loose ends → where they're tracked

- **`*{` grammar rewrite + `AttrValueEnd` — PAUSED** (`core/TODO-CORE-PARSING.md`).
  Do **not** build the blob/re-emit grammar on the deratified flat wire; it awaits
  the ratified value-bracket wire. The last grammar red (`;{`-in-blob) and the
  mixed-interpolation implementation both ride on this. The `*{` **semantics** in
  CORE stand (encoding-independent); only the grammar encoding waits.
- **0.9 tag path superseded / on hold** — the "queue to `core-v0.9.0`" in the root
  README (`*{` rewrite → S-batch → mining → tag) is paused pending the wire-model
  reconception. (README caveated this session; a full rewrite is deferred until
  the wire model is ratified.)
- **3-series synthesis** — when Gemini (3a) / grok (3b) return, compare them to
  each other and to the brownfield analysis; watch for hard-won edge cases lost
  (bare-token boundary, the four `\` positions, EOF two-level severity, flag
  re-owning). The 2-series `EVENTS.md` value-bracket derivation is the event-model
  half to reconcile.
- **Source-spec backport** — the de-cruft (breadcrumb scrub, the two converged
  sections), the callouts, and the grammar-lags-spec jargon flags are candidates
  to land in the *real* `spec/CORE.md` (Joseph ~90% this becomes the main spec).
  Separate ratify. The parser-agnostic decoupling is the biggest such candidate.
- **Big-conversion examples** — `docbook-fo-table` / `docbook-graphics` /
  `mathml-to-latex` remain un-modernized (a larger effort; the ten shorter ones
  are done + parser-validated).
- **Aux-spec jargon** — `path`/`patch`/`schema`/`guarantee`/`comment-locus`/
  `pragma` terms held pending a "companion glossary" scope decision (CORE-rewrite
  glossary stays core-language for now).
- **Parser bug filed** — `|{…}`-led block-prose line silently swallows following
  same-column structure (`core/TODO-CORE-PARSING.md`, with repro). Left for now.
- **Branch** — everything is on `greenfield-cleanroom`, fast-forwardable to `main`.

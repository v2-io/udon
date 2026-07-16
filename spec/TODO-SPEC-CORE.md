# TODO-SPEC-CORE — open edits to the core spec (`CORE.md`)

**Scope: only edits to `CORE.md` itself.** Event-parser / grammar work lives in
`../core/TODO-CORE-PARSING.md`; companion & dialect spec work in
`TODO-SPEC-OTHER.md`.

> *Discipline (META-1): read the CORE section before editing or advising on
> it, and re-grep line numbers — they drift.*

---

## Open

- [ ] **Adjudicate `FULL-EBNF.md`'s fate** (raised 2026-07-14). It is a derived,
      perpetually-lagging illustrative grammar; a second grammar artifact
      undercuts CORE-as-sole-source-of-truth and it has already caused confusion
      (cited as if corroborating CORE). Decide: delete / reduce to a pointer /
      keep. Deferred by Joseph for a deliberate call.
- [ ] **References — structured event encoding** (semantics already in CORE
      "References"). Wire still interim: single `Reference` with raw text after
      `@`. Planned: `ReferenceStart` / `Name` / `Attr "$key"` / `Attr
      "$traits"` / `ReferenceEnd` (reuse element-identity machinery). When
      taken: update the reference functions in the `generator/` grammar
      units, fixtures (`references.yaml` incl.
      `reference_trait_tail_in_payload` → real trait selection,
      `markers.yaml::at_bracket_is_reference`), `tree.rs`
      `NodeKind::Reference`.
- [ ] **Inline raw `!{:kind: …}` — deeper nailing** deferred past 0.8
      (Joseph, 2026-07-15) until dialects/templating settle. Provisional
      contract is in CORE ("Inline Raw Content") and green in fixtures;
      revisit for tighter rules later.
- [ ] **Reconsider the "guard" framing / Marker Recognition section**
      (Joseph, 2026-07-15): reads as lexical-implementation detail, partially
      redundant with each marker's own section. Options: fold each guard into
      its marker's section; demote to a non-normative recognition summary; or
      keep but tighten. Deferred until the 0.9 model text fully settles (an
      editorial restructure, not a ruling). *(Residual of the drained 0.9
      supplement — its rulings ledger now lives in the changelog under
      0.9.0-alpha.1 "Ruled"; do not re-open those.)*
- [ ] **Bare-pipe table fragility** — bare `|` inside table-cell code spans
      (ruled for legibility 2026-07-16) is corrupted *in source* if a table
      formatter re-parses the cells (it split the Positional Contexts table
      once). Positional Contexts is now pipe-free; the remaining bare-pipe
      tables (Prefixes, desugar, Value Kinds, Comments, terminators, inline
      syntax, naming) are fine until a formatter sweeps them. If that
      happens: de-pipe those cells the same way (examples into udon blocks),
      or configure the formatter to skip CORE.md.
- [ ] **Unwrap CORE.md's hard-wrapped prose** (Joseph, 2026-07-15): drop the
      manual line wrapping in favor of long lines / soft wrap. Editorial,
      whole-file; best done as a single dedicated commit (no content changes
      mixed in) so diffs stay reviewable.
- [ ] **Silences surfaced by the 2026-07-16 densification** (deliberately
      not fixture-encoded — would be inventing spec): multiple element
      suffixes (`|field?!`); multi-line `[...]` arrays (only envelopes are
      stated single-line); unclosed identity bracket at EOF (`|el[unclosed`
      — not in the EOF table); empty embedded `|{}`; interpolation inside
      element keys (deferred to DYNAMICS); rational/complex bare-freeze
      (already tracked in SPEC-OTHER). Each needs a ruling or an explicit
      deferral. *(discuss w/ Joseph)*
- [ ] **Filename-designator ↔ pragma binding** — when the schema layer lands,
      bind a document's filename designator to its pragma (its dialects + schema).
      *(discuss w/ Joseph)*

---

## Design notes feeding future rulings

- **[The Attribute Model — hash & array, edges & nodes](../design/attribute-model-2026-07.md)**
  — see open item above. Same document is the ratification input for the
  whole attribute reconception (uniform scan, node-valued attrs, `?` flags,
  key charset, warning placement, …), not only "structured values."

---

## Migrated this cycle (2026-07-15) — residual only above

Ratified silences from the v0.8 fixture authoring pass that are now **in CORE**
(and fixtures/grammar where the wire changed):

| Topic | Where in CORE |
|-------|----------------|
| Text granularity | Parser behavior notes |
| Warning codes (PascalCase; emission host-side) | Warning codes table |
| Past-base `\` → AST-layer only | Escape |
| `<…>` interim + array-item value position | Explicit Typing |
| Structured attrs | **reopened** → design/attribute-model (not migrated) |
| Raw-block first-content-line dedent | Raw Directives (Block) |
| Multiline embedded per-line Text; space between siblings | Inline and Embedded |
| Inline raw Raw marker + sep space | Inline Raw Content |
| Comment continuation uniform; `;` framing; sameline comments | Comments / Head Position |
| Comment deeper than prose base = prose | Comments and Indentation |
| References = selector tuples; interim raw wire | References |
| Stranded second-attr: no required event Warning | Block Attribute Values |

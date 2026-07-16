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
- [ ] **Attribute model — ratify from proposal 3 + substrate.** Active:
      - **[design/attribute-model-proposal-3.md](../design/attribute-model-proposal-3.md)**
        — semantic `?`, binding dualism, segment arrays, §2.3 warn+ingest.
      - **[design/attribute-model-proposal-2-substrate.md](../design/attribute-model-proposal-2-substrate.md)**
        — decided switch-invariant substrate.
      Archaeology: proposal-2, [attribute-model-2026-07.md](../design/attribute-model-2026-07.md).
      CORE "Complex Attribute Values" unsettled until ratification.
      Fixture `structured_attribute_value` is `events: []` until then.
      *(discuss w/ Joseph)*
- [ ] **References — structured event encoding** (semantics already in CORE
      "References"). Wire still interim: single `Reference` with raw text after
      `@`. Planned: `ReferenceStart` / `Name` / `Attr "$key"` / `Attr
      "$traits"` / `ReferenceEnd` (reuse element-identity machinery). When
      taken: update `values.desc`/`udon.desc` reference functions, fixtures
      (`references.yaml`, `markers.yaml::at_bracket_is_reference`,
      `reference_trait_tail_interim` → real trait selection), `tree.rs`
      `NodeKind::Reference`.
- [ ] **Inline raw `!{:kind: …}` — deeper nailing** deferred past 0.8
      (Joseph, 2026-07-15) until dialects/templating settle. Provisional
      contract is in CORE ("Inline Raw Content") and green in fixtures;
      revisit for tighter rules later.
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

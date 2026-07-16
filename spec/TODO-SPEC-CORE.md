# TODO-SPEC-CORE — open edits to the core spec (`CORE.md`)

**Scope: only edits to `CORE.md` itself.** Event-parser / grammar work lives in
`../core/TODO-CORE-PARSING.md`; companion & dialect spec work in
`TODO-SPEC-OTHER.md`.

> *Discipline (META-1): read the CORE section before editing or advising on
> it, and re-grep line numbers — they drift.*

---

## Open

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
      (already tracked in SPEC-OTHER); **whitespace-only lines in prose** —
      CORE says blank lines emit `BlankLine` but never says whether a
      spaces-only line is "blank"; the parser (probed 2026-07-16) emits
      `BlankLine` for empty lines but a residual-whitespace `Text` event for
      spaces-only lines — consumers treating Text as "has content" will trip
      (side-finding of the archived prose-collision spike,
      `_archive/spikes/prose-collision-2026-07.md`). Each needs a ruling or
      an explicit deferral. *(discuss w/ Joseph)*
- [ ] **Silence with teeth: same-line trailing text after `!:lang:` is
      DROPPED from the event stream** (probe-confirmed 2026-07-16:
      `!:sh: echo hi` emits Raw with empty content and the tail bytes
      appear in *no* event — the only known violation of the
      keep-everything posture; latent since 0.8, so not a 0.9 regression).
      CORE's raw-block section never addresses a same-line tail, and the
      grammar's `:raw_eol` consumes it silently. Found in the field by the
      2026-07-16 consumer re-scan: a reflowed paragraph in vivarium's
      PROCESS.udon put `!:lang:` at line start and the sentence's remainder
      vanishes. Coherent (a)-level options exist (tail = first raw content
      line, or warn + keep as raw body); needs a ruling, then a fixture.
      *(discuss w/ Joseph)*
- [ ] **Filename-designator ↔ pragma binding** — when the schema layer lands,
      bind a document's filename designator to its pragma (its dialects + schema).
      *(discuss w/ Joseph)*

---

*(History lives in git and `msc/CHANGELOG.md` — the 0.8 silence-migration
table and the 0.9 rulings ledger are recorded there, not here.)*

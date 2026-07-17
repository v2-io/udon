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
- [ ] **Multiple keys — surrogate *and* natural identity** (Joseph,
      2026-07-16: "at first I thought [it] was overkill but now I realize
      [it] should probably be valid... although there's still a lot to
      figure out. Basically a surrogate key *and* a natural key.")
      Motivating case: vivarium's `terrestris.ordinum.udon`, where each
      `|phase[scribal]` also carries `:num 9` — an identity in practice,
      unreferenceable as one. Desired shape:

      ```udon
      |phase[9][scribal]     ; addressable by either key
        :name Scribal
        :epithet the world now has Writing and history
        :target 3
      ```

      with `@phase[9]` ≡ `@phase[scribal]`. **Most of the model already
      exists**: stacking is the uniform rule for every attribute, `$key`
      included (longhand `:'$key' 9 :'$key' scribal` is arguably wire-legal
      today); Host Views already says `key` is "the value(s) of `$key`";
      and multi-valued-`$key` prohibition is explicitly a schema concern,
      not core. **And tuple (composite) keys parse TODAY, probe-verified
      2026-07-16**: `|el[[12 'asdf']]` = one `$key` whose value is the
      array — identical wire to `:'$key' [12 'asdf']` — because `[key]`
      routes through the full typed value path ("every type is available");
      now pinned as fixture `key_typed_array_tuple`. So the design space
      has three wire-real shapes: single typed key, tuple key (one
      identity, compound value), and multiple independent keys (stacked
      `$key`s — sugar syntax missing). Joseph's motivating blind spot:
      UUIDs appear in both databases and documents, and nothing cleanly
      "put[s] uuid in the same category as a simple auto-increment key" —
      ad-hoc surrogate keys (SS1.3.38-style) are common in notational
      markup precisely because "no one has built the middle." Genuinely open: (a) surface syntax — the identity grammar's
      post-bracket state doesn't accept a second `[`; (b) uniqueness
      semantics — per-key unique within the type (each key an independent
      handle, the SQL surrogate+natural reading) vs tuple-unique; (c)
      reference/path resolution by any key, and what `@phase[9]` does if
      9 and scribal ever name different elements (duplicate-definition
      policy interplay); (d) typed-key equality across the pair
      (`[9]` integer vs `["9"]` string already distinct — helpful here);
      (e) host-view shape (`key()` scalar = which one? first? natural-by-
      convention?). Continuous with the relational reading in the
      adjudication packet (surrogate/natural is the SQL perspective
      arriving on schedule). *(discuss w/ Joseph — his leaning: valid,
      design open)*
- [ ] **Filename-designator ↔ pragma binding** — when the schema layer lands,
      bind a document's filename designator to its pragma (its dialects + schema).
      *(discuss w/ Joseph)*

---

*(History lives in git and `msc/CHANGELOG.md` — the 0.8 silence-migration
table and the 0.9 rulings ledger are recorded there, not here.)*

# TODO-SPEC-CORE — open edits to the core spec (`CORE.md`)

**Scope: only edits to `CORE.md` itself.** Event-parser / grammar work lives in
`../core/TODO-CORE-PARSING.md`; companion & dialect spec work in
`TODO-SPEC-OTHER.md`.

> *Discipline (META-1): read the CORE section before editing or advising on
> it, and re-grep line numbers — they drift.*

**EOF / positional–delimited (alpha.2 — RULINGS LANDED, do not re-open):** every
EOF decision is ruled in [`msc/CHANGELOG.md`](msc/CHANGELOG.md) (0.9.0-alpha.2
"Ruled"); CORE text is rewritten (End of input / Anomaly posture / Line-boundedness
/ Emission order); and the **descent generation LANDED** (both backends generate
the EOF handling from a positional/delimited classification — out of the
fixtures-first order, Joseph's call; see
[`../design/eof-descent-classification.md`](../design/eof-descent-classification.md)).
So the next step — the fixture **finalization** (`../core/fixtures/_wip/FINDINGS.md`)
— now reconciles against the *new* behavior + vocabulary. Design of record:
[`TODO-EOF-refactor.md`](TODO-EOF-refactor.md) (its "Grammar / descent direction"
section — formerly cited as "Addendum A"). Warning-code spellings are provisional;
`UnterminatedFreeform` → `UnclosedFreeform` was the first normalization.

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
- [ ] **EOF section rewrite — positional / delimited** (settled 2026-07-17;
      design of record: [`TODO-EOF-refactor.md`](TODO-EOF-refactor.md)).
      Collapse "End of input" to: unexpected EOF only for still-open
      **delimited** activations; **positional** finishes by ordinary end
      rules; composition = innermost-first (stack). Clarifies positional
      *context* vs *construct* (text block positional, embed delimited).
      Turns densification composition ⚠ fixtures into derivations and
      makes the embed any-phase drop a plain bug. Also folds: unclosed
      identity `[` (delimited under the framing) and the **two-level severity
      ruling** (2026-07-18 — every `Unclosed*` → **Warning**; the document-level
      incomplete-input is a *result*, not a diagnostic; see the EOF doc's
      *Severity — two levels*). Reconcile CORE's "Anomaly posture" ladder with
      it (today it calls unclosed constructs an "error event" while insisting
      they keep everything — the split says which half is which).
- [ ] **"Positional" / "delimited" terminology audit** (before/with the EOF
      rewrite). The design of record makes **positional construct** (extent by
      geometry) and **delimited construct** (printed end-sequence owed) precise
      terms; CORE already uses both words in *other* senses, so each existing
      use needs a look — same sense, or a genuinely different thing that should
      keep a distinct word? Current uses (2026-07-18 grep):
      - "positional" = **recognition locus** — `## Positional Contexts` (§91:
        block/sameline/inline/head). Different axis from construct-extent; the
        EOF doc's Vocabulary box keeps them distinct — carry that in.
      - "positional" = **order/sequence** — "Children (the array) are
        *positional*" (§379). The *ordered* sense; likely say "ordered" to free
        the word.
      - "positional" = **the `\` escape's cursor-position rule** — "the four
        *positional* uses of `\`" (§249, §546). A third sense; probably fine
        scoped to `\`, but confirm it doesn't read as construct-extent.
      - "delimiter" is mostly the literal-char sense (§100/§251/§611/§717/§1412
        — compatible). Watch: §57 "awaiting a *delimiter*" (already the new
        sense — the rewrite formalizes it) and DYNAMICS §209 "indentation to
        *delimit* scope" (loosely "bound" — conflicts, since indentation-closed
        is *positional*, not delimited).
      Keep / disambiguate-in-place / rename-a-sense is a spec-reasoning call.
      *(discuss w/ Joseph if a rename is wanted)*
- [ ] **Cleanup opportunities to fold into the EOF pass** (broad notes, not a
      mandate — take only what the rewrite already touches). The rulings land
      near the top of CORE (End of input §55, Warning codes §27, Anomaly posture
      §41), so that neighborhood is open anyway: collapse the per-construct EOF
      table into the one rule (a net simplification); update the Warning-codes
      table for the severity relabel and firm up settled "working name" hedges;
      the terminology audit above. Dovetails with the standing editorial items
      here (unwrap the hard-wrapped prose; reconsider the guard / Marker-
      Recognition framing; bare-pipe table fragility) — do those opportunistically
      where the pass already touches that text, not as a separate sweep.
- [ ] **Smaller silences from the same pass** (each with a concrete case;
      none encoded): **empty identity bracket** `|el[]` — empty key, or a
      key whose value is the empty list `[]`? (the EOF list has
      `|el[unclosed` but not this) · **reference / interpolation as array
      items** `:xs [@[r] 1]` — Inline Lists *enumerates* ("numbers, quoted
      strings, `<…>` envelopes, nested lists") while Value Kinds calls
      references a value kind and Explicit Typing says value position
      covers "array items alike": enumeration vs uniform rule ·
      **raw block with an empty same-line body** `!:sh: ` — is the empty
      rest an empty `RawContent` or none? (a corner of the 2026-07-16
      same-line-body ruling) · **blank-line placement vs dedent**
      `|p\n  |a\n\n  |b` — `BlankLine` inside still-open `|a` (encoded,
      stream-order, ⚠) or after its `End`? *(discuss w/ Joseph)*
- [ ] **Did `InconsistentIndentation` deliberately narrow to prose?**
      (2026-07-16). Legacy fixtures asserted that a **comment** or
      **attribute** line seeds the prose content-base and warns
      (`comment_sets_content_base`, `attribute_sets_content_base`); CORE
      0.9's warning table scopes the code to a "**Prose** (or
      comment-continuation) line". The narrowing reads as deliberate —
      the 0.9 grammar treats content-base as a prose concept, and its
      `:child_dispatch` comment says so explicitly — but it is **not
      recorded as a change anywhere found**, and three legacy fixtures die
      on it. Confirm and note it, or restore the broader rule.
      *(discuss w/ Joseph)*
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

- [ ] **Cosmetic completeness items** (from the 2026-07-18 CORE consistency
      audit; low priority, not contradictions): (a) the `NoTabs` error code is
      named in "Strict Whitespace" but catalogued in no registry (error-code
      vocabulary is deliberately un-catalogued working-names for now); (b)
      `CommentMissingFollowingSpace` is in the Warning-codes table but never
      described or exampled in the Comments section; (c) "the character
      immediately after the prefix determines the parse mode **with no
      lookahead**" (Unified Inline Syntax) reads oddly against the Bounded
      Lookahead section's "typically 2-3" chars — a word-level nit (different
      granularities: one char after the prefix vs. total guard width).

---

*(History lives in git and `msc/CHANGELOG.md` — the 0.8 silence-migration
table and the 0.9 rulings ledger are recorded there, not here.)*

# TODO-SPEC-OTHER — companion & dialect specs

Spec work beyond core `CORE.md`: dialects, the markdown story, temporal, and
composite/standard types. (Core-spec edits live in `TODO-SPEC-CORE.md`.)

## Open

- [ ] **Temporal → `temporal@1` dialect** — recast `TIME-SPEC.md` from the old
      bare-recognition model to a `<…>`-enveloped dialect (its banner flags this).
      The value grammar stays; "where temporal lives" is now the envelope.
      *Grammar side done 2026-07-15:* bare temporal recognition carved out of
      `core/generator/30-udon.values.descent.udon` (bare temporal now falls back to string,
      per CORE); the working recognition state machines are preserved
      verbatim in `core/generator/temporal-value.desc.setaside` for this
      dialect to re-home.
- [ ] **Markdown subset & layers** — ratify `MARKDOWN.md` (draft): the Layer-1
      named subset (D4a), the Layer-2 `doc` vocabulary (D4b), conversion
      degradation (D4c), renderer targets (D4d). *(discuss w/ Joseph)*
- [ ] **Dialect architecture** — confirm the `<…>` dialect model, default-on
      profiles, unlabelled dispatch. Mostly settled in CORE "Explicit Typing";
      track remaining dialect-level decisions here.
- [ ] **Pragma** — the in-document declaration binding a document to its
      dialects + schema + expected host-interpreter version, with a reserved
      core-version slot. Nothing exists yet; tiny surface, future-proofs
      everything — a source-of-truth substrate must survive its own
      evolution. (Filename-designator ↔ pragma binding is tracked in
      `TODO-SPEC-CORE.md`.) *(routed from the archived review's CTQ,
      2026-07-16; discuss w/ Joseph)*
- [ ] **Composite / standard numeric types** — the rational & complex
      bare-vs-dialect fork; nested `<…>` constructors. Direction in
      `../design/composite-types.md`. *(discuss w/ Joseph)*
- [ ] Pull remaining dialect / markdown open decisions from the `../design/`
      notes into here. (The archived review's §7-F decision list is fully
      accounted for: eight of nine resolved in CORE 0.8/0.9; the ninth — the
      Markdown subset — is the MARKDOWN.md item above.)
- [ ] **Spec organization / artifact ecosystem** — the contract-vs-pedagogy,
      DRY-migration, structural-spine, density-gradient, agent-pedagogy, and
      literate-weave threads are tracked cross-cuttingly in **`../TODO-META.md`**
      (they span spec ↔ grammar ↔ fixtures ↔ learning artifacts). Noted here
      because how the companion specs relate to CORE and to the
      learning/cheat-sheet layer is part of that picture.

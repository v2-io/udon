# TODO-SPEC-OTHER — companion & dialect specs

Spec work beyond core `CORE.md`: dialects, the markdown story, temporal, and
composite/standard types. (Core-spec edits live in `TODO-SPEC-CORE.md`.)

## Open

- [ ] **Temporal → `temporal@1` dialect** — recast `TIME-SPEC.md` from the old
      bare-recognition model to a `<…>`-enveloped dialect (its banner flags this).
      The value grammar stays; "where temporal lives" is now the envelope.
- [ ] **Markdown subset & layers** — ratify `MARKDOWN.md` (draft): the Layer-1
      named subset (D4a), the Layer-2 `doc` vocabulary (D4b), conversion
      degradation (D4c), renderer targets (D4d). *(discuss w/ Joseph)*
- [ ] **Dialect architecture** — confirm the `<…>` dialect model, default-on
      profiles, unlabelled dispatch. Mostly settled in CORE "Explicit Typing";
      track remaining dialect-level decisions here.
- [ ] **Composite / standard numeric types** — the rational & complex
      bare-vs-dialect fork; nested `<…>` constructors. Direction in
      `../design/composite-types.md`. *(discuss w/ Joseph)*
- [ ] Pull remaining dialect / markdown / fence / guard open decisions from
      `../REVIEW-JULY-2026.md` §7-F and the `../design/` notes into here.

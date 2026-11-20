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
- [ ] **Sanctioned callout vocabulary (spec-authoring convention)** — a fixed
      set of Obsidian callouts that mark the *normative status* of each block in
      CORE and the companion specs, replacing ad-hoc prose hedges
      ("(descriptive, not a calcified rule)", "(ratified …)", section-level
      "(Non-Normative)", …) with an explicit, agent-legible tag — the label word
      states intent more clearly than the prose it replaces. Ratified set
      (Joseph, 2026-07-19):
    - `> [!example] IDIOMATIC` — **normative**: the correct, desirable grammar (the right way to write it).
    - `> [!failure] AVOID` — **normative**: "this won't do what you expect," or a *necessary* foot-gun consequence of the prescriptive grammar.
    - `> [!attention] UNDEFINED BEHAVIOR: …` — the explicit declaration that something is undefined / unspecified.
    - `> [!caution] CURRENT BEHAVIOR` — **non-normative**: a present, descriptive observation that is *not* prescriptive and is likely to change (and/or may later fall under UNDEFINED). The most important one — it keeps current-parser behavior from silently calcifying into grammar.

      Authoring rules: CAPS title on the callout line; a blank line **before and
      after** every callout (Obsidian needs it, especially adjacent to lists or
      fences); body and any code fence are `>`-quoted. Caveat specific to this
      spec: UDON is whitespace-significant, so a `udon` fence inside a callout is
      `>`-prefixed on every line — fine for reading/derivation, but anything that
      *extracts* examples byte-exact must strip `> ` uniformly (and handle a blank
      body line, which Obsidian renders as a bare `>`); round-trip-test before
      relying on that. Wider palette available if ever needed (neutral → severe):
      note / info / tip / success / question / warning / caution / attention /
      failure / danger / bug / ….

      **Status:** pilot landed in `spec/msc/greenfield-2a/spec/CORE.md` — one
      exemplar of each type (IDIOMATIC on the Configuration example, AVOID on the
      node-value one-way-door, UNDEFINED on the document-root attribute, CURRENT
      BEHAVIOR on the inline-comment whitespace). Next: a full sweep across CORE +
      DYNAMICS + TIME-SPEC — a **per-block judgment pass, not mechanical** (not
      every `udon` fence is IDIOMATIC; a style *preference* is not an AVOID
      foot-gun — those likely want `[!tip]` or plain prose). Then decide what to
      backport to the source `CORE.md`. Cross-cuts the spec-organization thread in
      `../TODO-META.md`. *(discuss w/ Joseph)*

# TODO-AUX — auxiliary syntaxes

Lexical / parser-level concerns that sit on core UDON but aren't dialects:
schema, paths, patch. Here in `spec/` alongside the other spec lanes for now;
likely home is a future `spec/aux/` once `spec/` splits into
`spec/{core, dialects/{temporal,numeric,rustic}, aux}`.

## Open

- [ ] **Path syntax — design fresh; references become a subset of it**
      (Joseph, 2026-07-16). `../design/udon-paths.md` is input material
      only ("old and stale... zero need to care what it says"); the design
      drivers are (a) in-document `@` references = a path subset — CORE's
      `@element[key].trait` selector tuple already *is* one path segment,
      so the planned structured reference wire and paths co-design — and
      (b) document-embeddability (bounded lookahead, clean value-boundary
      terminators). **Prototype the parser as a simple descent grammar
      alongside the design** (authorized; let the grammar surface the
      terminator questions). Session packet with the open forks +
      recommendations: `msc/adjudication-2026-07-paths-and-silences.md`
      (positional-vs-typed-identity `[0]` is the big one). **First rung of
      the critical path to the agentic edit tool** (see
      `../ux/TODO-AGENT-UX.md`, tool suite item); also feeds the paths
      implementation in `../TODO-UTILS.md`.
- [ ] **Schema syntax** — a main pending area: how schemas (the constraint layer)
      are written. **Start at `../design/schema-workbench-2026-07.md`** —
      the source index (in-repo + rowan + autopax, with what's read vs
      queued), the comparative survey of schema languages and the axes they
      differentiate on, and the position forming; it points into the older
      ground (`../design/udon-schema-exploration.md`'s thirteen puzzle
      pieces, `../design/udon-guarantees.md`) rather than restating it. **Second rung of the edit-tool
      critical path** (conformance-at-apply needs it, plus the pragma in
      `TODO-SPEC-OTHER.md` to bind a document to its schema).
      **Rowan is the first waiting customer, not just prior art (Joseph,
      2026-07-16):** most of his thinking on "highly-resilient-structured-
      document schemas" was laid down in `~/src/rowan` — and rowan stalled
      *specifically because* "I got tired of all of the ruby DSL for the
      schema definitions and started craving udon and decided I wasn't
      going to move it forward anymore until udon was really ready." So
      UDON's schema syntax is rowan's schema DSL's intended final form:
      the acceptance test for any design here is "can rowan's
      attributes/constraints/identities/versioning vocabulary be written
      in it, better than the Ruby?" (the `design/examples/ash-like-*.udon`
      files are early sketches of exactly this). This also explains the
      January exploration's Archema-flavored pieces (relationships,
      actions, policies, storage projection, derivation targets — they ARE
      rowan's architecture with UDON as the authoring surface).
      **Why schemas carry more weight here than in most formats (Joseph,
      2026-07-16):** the indentation hazard is *worse* than Python's —
      "python will break catastrophically if some code gets the wrong
      indent... whereas it won't be as obvious to udon except thanks to
      schemas." Wrong-scope prose/structure in UDON is *valid*, just
      silently re-parented; schemas are what restore the loud failure
      (and the edit tool's computed indentation removes the write-side
      hazard entirely). Constraint-side asks accumulated 2026-07-16:
      uniqueness/cardinality over `$key` incl. multiple-keys + tuple keys
      (`TODO-SPEC-CORE.md`); transition-validity (old→new); soft/hard
      gradual constraints; schema-by-exemplar + aspirational designators
      (below); consistency profiles as the enforcement dial.
      *(discuss w/ Joseph)*
- [ ] **Schema-by-exemplar** (Joseph, 2026-07-16): sometimes "the slow
      evolution of some exemplary file [is] actually the *input* to the
      schema" — the living document teaches the schema, with
      gentleman's-agreement care day-to-day and a schema checkpoint at
      deploy. In-repo prior art: `../design/udon-agentic.md` Future
      Directions already sketches schema-inference ("generate schema from
      existing documents; learn patterns across corpus; suggest schema
      refinements"). Pairs with the enforcement-cadence spectrum on the
      udon-guard item (`../TODO-UTILS.md`). *(discuss w/ Joseph)*
- [ ] **Aspirational schema designators** (Joseph, 2026-07-16): a file may
      have no schema yet "but there might be a filename that indicates
      that it aspires to have that schema at some point" — the
      `<name>.<schema>.udon` designator as a forward declaration, binding
      before the schema exists (validation no-ops or advises until it
      lands). Connects to the filename-designator ↔ pragma binding item in
      `TODO-SPEC-CORE.md`. *(discuss w/ Joseph)*
- [ ] **Patch syntax** — not yet drafted. The agentic edit tool's wire
      format (path + operation + content) is effectively this; draft it
      co-evolving with that tool rather than in the abstract. Note:
      `../design/udon-guarantees.md`'s append-only-log sketch (`|change`
      entries carrying `|set`/`|append`, validated before append) is a
      first draft of this from 2026-01 — patch-as-UDON with an audit
      trail built in.
- [ ] Pull schema / path / patch tasks from the `../design/` notes into here (the
      notes stay as reference; the actionable items move here).

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
      are written. Design ground in `../design/udon-schema-exploration.md` and
      `../design/udon-guarantees.md`. **Second rung of the edit-tool
      critical path** (conformance-at-apply needs it, plus the pragma in
      `TODO-SPEC-OTHER.md` to bind a document to its schema).
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

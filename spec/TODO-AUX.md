# TODO-AUX — auxiliary syntaxes

Lexical / parser-level concerns that sit on core UDON but aren't dialects:
schema, paths, patch. Here in `spec/` alongside the other spec lanes for now;
likely home is a future `spec/aux/` once `spec/` splits into
`spec/{core, dialects/{temporal,numeric,rustic}, aux}`.

## Open

- [ ] **Path syntax** — `../design/udon-paths.md` (settled-in-shape; extract
      its open questions here — `||` descent, `[*]`, `:attr@`
      reference-following). **First rung of the critical path to the
      agentic edit tool** (Joseph's 2026-07-16 priority — see
      `../ux/TODO-AGENT-UX.md`, tool suite item); also feeds the paths
      implementation in `../TODO-UTILS.md`.
- [ ] **Schema syntax** — a main pending area: how schemas (the constraint layer)
      are written. Design ground in `../design/udon-schema-exploration.md` and
      `../design/udon-guarantees.md`. **Second rung of the edit-tool
      critical path** (conformance-at-apply needs it, plus the pragma in
      `TODO-SPEC-OTHER.md` to bind a document to its schema).
      *(discuss w/ Joseph)*
- [ ] **Patch syntax** — not yet drafted. The agentic edit tool's wire
      format (path + operation + content) is effectively this; draft it
      co-evolving with that tool rather than in the abstract.
- [ ] Pull schema / path / patch tasks from the `../design/` notes into here (the
      notes stay as reference; the actionable items move here).

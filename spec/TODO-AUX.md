# TODO-AUX — auxiliary syntaxes

Lexical / parser-level concerns that sit on core UDON but aren't dialects:
schema, paths, patch. Here in `spec/` alongside the other spec lanes for now;
likely home is a future `spec/aux/` once `spec/` splits into
`spec/{core, dialects/{temporal,numeric,rustic}, aux}`.

## Open

- [ ] **Schema syntax** — a main pending area: how schemas (the constraint layer)
      are written. Design ground in `../design/udon-schema-exploration.md` and
      `../design/udon-guarantees.md`. *(discuss w/ Joseph)*
- [ ] **Path syntax** — `../design/udon-paths.md`; extract its open questions here.
- [ ] **Patch syntax** — not yet drafted.
- [ ] Pull schema / path / patch tasks from the `../design/` notes into here (the
      notes stay as reference; the actionable items move here).

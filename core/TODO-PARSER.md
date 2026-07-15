# TODO-PARSER — AST (one-shot) + streaming-AST parsers

The consumer layer built on the event spine: the tree/AST builder, the streaming
AST, and their API decisions. Predicated on a stable event parser. (Compliance
fixtures that test *core syntax* at the AST level belong to the unified gate — see
root `TODO-META.md` — not here.)

## Open

- [ ] **Tree / AST builder** — *landed 2026-07-15 for the 0.8 model*
      (`udon-core/src/tree.rs`): `Document`/`Node` arena, parent pointers,
      spans, and the CORE Host Views — the substrate is the full ordered
      attribute list (designated `$`-attrs included, round-trip safe), with
      `key()` / `traits()` (always a list) / `attributes()` /
      `all_attributes()` / `attr()` (scalar = last) / `attr_all()` derived.
      **Remaining:** selectors; string interning (perf, only if measured).
- [ ] **Streaming AST** — *landed 2026-07-15* (`udon-core/src/stream_tree.rs`):
      `TreeStream` — push events in, completed root-level subtrees ship as
      owned `Document`s the moment they close (CORE "Streaming Parse") —
      plus the `StreamingTreeParser` byte-feeding convenience. **Bounded by
      the streaming-resumption defect** (review #1, `TODO-CORE-PARSING`):
      today's line-oriented `StreamingParser` restarts per feed, so
      arbitrary feed boundaries mis-nest; `TreeStream` itself is
      source-agnostic and plugs into the resumable parser unchanged when it
      lands. **Remaining:** re-test with arbitrary boundaries once the
      explicit-stack backend exists.
- [ ] **Parser API decisions** — surface shape for consumers.
      *(discuss w/ Joseph where the API is user-facing)* Decisions taken
      provisionally in the work above, for review: scalar `attr()` = LAST
      stacked value; `traits()` returns `Vec<&Value>`; anonymous name =
      `""` + `is_anonymous()` (vs `Option<&str>`); streaming granularity =
      one root-level subtree per shipment, each an owned single-root
      `Document`; root blank lines/warnings ship nothing.
- [ ] **[later] Language bindings** — Ruby (FFI over the streaming API, lazy
      tree projection), WASM, Python (PyO3), C ABI shared library. Predicated
      on a stable, compliant parser API.

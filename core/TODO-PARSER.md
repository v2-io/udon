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
      plus the `StreamingTreeParser` byte-feeding convenience. *Updated same day:* the
      explicit-stack backend landed — `StreamingTreeParser` now rides
      `PushdownParser` and is correct at ANY feed boundary (byte-at-a-time
      tested; review defect #1 resolved). **Remaining:** nothing here; see
      CORE-PARSING for the old-façade retirement.
- [ ] **Parser API decisions** — surface shape for consumers.
      *(discuss w/ Joseph where the API is user-facing)* Decisions taken
      provisionally in the work above, for review: scalar `attr()` = LAST
      stacked value; `traits()` returns `Vec<&Value>`; anonymous name =
      `""` + `is_anonymous()` (vs `Option<&str>`); streaming granularity =
      one root-level subtree per shipment, each an owned single-root
      `Document`; root blank lines/warnings ship nothing.
- [ ] **Error-reporting quality** — multi-error collection
      (`Document::parse` stopped at the first error as of the July estate
      review), source-snippet diagnostics, and the message-quality bar
      ("world-class error messages" was the stated goal; plumbing was
      absent). Node spans landed 2026-07-11 — verify current state before
      building on this description. *(routed from the archived reboot plan,
      2026-07-16)*
- [ ] **[later] Language bindings** — Ruby (FFI over the streaming API, lazy
      tree projection), WASM, Python (PyO3), C ABI shared library. Predicated
      on a stable, compliant parser API.

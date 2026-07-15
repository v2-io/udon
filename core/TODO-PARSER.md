# TODO-PARSER — AST (one-shot) + streaming-AST parsers

The consumer layer built on the event spine: the tree/AST builder, the streaming
AST, and their API decisions. Predicated on a stable event parser. (Compliance
fixtures that test *core syntax* at the AST level belong to the unified gate — see
root `TODO-META.md` — not here.)

## Open

- [ ] **Tree / AST builder** — `Document`/`Node`, arena allocation, navigation
      (parent / children / siblings), selectors, string interning.
- [ ] **Streaming AST** — the incremental tree as events arrive.
- [ ] **Parser API decisions** — surface shape for consumers.
      *(discuss w/ Joseph where the API is user-facing)*
- [ ] **[later] Language bindings** — Ruby (FFI over the streaming API, lazy
      tree projection), WASM, Python (PyO3), C ABI shared library. Predicated
      on a stable, compliant parser API.

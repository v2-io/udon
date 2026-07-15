# TODO-CORE-PARSING — event parser + descent grammar

The event-level parser and the descent grammar (`generator/*.desc`). Holds only
residuals and decompositions — spec *compliance* is proven by the versioned
fixture groups (see root `TODO-META.md`), not tracked here.

## Open

- [ ] **Streaming resumption** — an explicit call-stack passed around so the state
      machine is resumable across chunk boundaries (descent explicit-stack
      backend; review defect #1).
- [ ] **Grammar cleanup (stylistic / organizational)** — DRY the ~21
      near-identical number states in `values.desc`; parameterize
      `double_quoted`/`single_quoted`. Behavior-neutral; not fixture-driven.
- [ ] **Perf regression watch** — keep the criterion benchmark suite meaningful
      through the v0.8 grammar work; memory profiling on large files.
- [ ] **Benign `unreachable pattern` warnings** at `parser.rs:4070` (the
      bare-temporal ISO-duration arm in `values.desc` re-lists `b'p'|b'P'`).
      Correctness unaffected; the whole bare-temporal path is slated for removal
      (bare temporal → string, temporal moves to a `<…>` dialect), which clears
      the warning for free — don't hand-touch the grammar just for this.
- [ ] **Pending descent-tool items** — requests/fixes we're waiting on from
      `descent` itself, tracked from *our* side (what it unblocks here) so we
      follow up rather than work around or forget. *(none logged yet)*

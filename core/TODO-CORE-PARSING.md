# TODO-CORE-PARSING — event parser + descent grammar

The event-level parser and the descent grammar (`generator/*.desc`). Holds only
residuals and decompositions — spec *compliance* is proven by the versioned
fixture groups (see root `TODO-META.md`), not tracked here.

## Open

- [ ] **Pull appropriate (event-parser / descent-grammar) tasks from `PLAN.md`
      into here.** When PLAN is fully drained across the parser lanes, delete it.
- [ ] **Streaming resumption** — an explicit call-stack passed around so the state
      machine is resumable across chunk boundaries (descent explicit-stack
      backend; review defect #1).
- [ ] **Grammar cleanup (stylistic / organizational)** — DRY the ~21
      near-identical number states in `values.desc`; parameterize
      `double_quoted`/`single_quoted`. Behavior-neutral; not fixture-driven.
- [ ] **Pending descent-tool items** — requests/fixes we're waiting on from
      `descent` itself, tracked from *our* side (what it unblocks here) so we
      follow up rather than work around or forget. *(none logged yet)*

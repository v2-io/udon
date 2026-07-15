# TODO-CORE-PARSING — event parser + descent grammar

The event-level parser and the descent grammar (`generator/*.desc`). Holds only
residuals and decompositions — spec *compliance* is proven by the versioned
fixture groups (see root `TODO-META.md`), not tracked here.

## Open

- [ ] **Retire the line-oriented `StreamingParser` façade.** Review defect #1
      is RESOLVED at the generator level (2026-07-15): descent's pushdown
      backend (`--backend pushdown`) emits `parser_pd.rs`, resumable at any
      byte boundary, proven by `tests/pushdown_differential.rs` (all fixtures
      × chunk sizes vs single-shot, spans included); `StreamingTreeParser`
      rides it. Remaining: the old `StreamingParser` in `parser.rs` is now a
      façade with no consumers except `tests/boundaries.rs` — rework those
      tests onto `PushdownParser` (they get strictly stronger) and drop the
      `streaming` template section (keeping the shared `StreamEvent` /
      `ParseResult` types the pushdown module imports). Also pending:
      pushdown perf benchmark, and `--trace` plumbing for the pushdown
      backend (v1 limits).
- [ ] **Grammar cleanup (stylistic / organizational)** — DRY the ~21
      near-identical number states in `values.desc`; parameterize
      `double_quoted`/`single_quoted`. Behavior-neutral; not fixture-driven.
- [ ] **Perf regression watch** — keep the criterion benchmark suite meaningful
      through the v0.8 grammar work; memory profiling on large files.
- [ ] **Past-base `\` Warning** — a leading `\` deeper than an established
      prose content-base must pass through literally *and* fire a Warning
      (CORE "Escape", flagged there as a grammar-level detail to settle;
      fixture `escape.yaml::escape_past_base_is_literal_with_warning` holds
      it RED). Needs a look-through-the-extra-spaces peek in the element
      children loop that the current prose routing doesn't have.
- [ ] **Pending descent-tool items** — requests/fixes we're waiting on from
      `descent` itself, tracked from *our* side (what it unblocks here) so we
      follow up rather than work around or forget. Logged in descent's
      TODO.md 2026-07-15: parameterized inline-emit payloads
      (`TypeName(:param)`) — would collapse the duplicated `check_bs_*` and
      `spaced_suffix_*` state ladders in `udon.desc` to single
      parameterized states.

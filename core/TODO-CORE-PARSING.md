# TODO-CORE-PARSING — event parser + descent grammar

The event-level parser and the descent grammar (`generator/*.desc`). Holds only
residuals and decompositions — spec *compliance* is proven by the versioned
fixture groups (see root `TODO-META.md`), not tracked here.

## Open

- [ ] **Verify `*` suffix after `[key]` parses** (2026-07-16). The Obsidian
      highlighter (grammar-driven) renders `|field[name]*` as plain text
      while `|field[name]?` / `!` / `+` highlight correctly — either a
      highlighter/wasm issue or a real `*` gap in `parse_element_identity`'s
      `:post_bracket` path. When authoring the v0.9 identity fixtures, make
      sure all four suffixes are covered in the after-key position
      (`|field[name]?` `!` `*` `+`), not just `?`.

- [ ] **Retire the line-oriented `StreamingParser` façade.** Review defect #1
      is RESOLVED at the generator level (2026-07-15): descent's pushdown
      backend (`--backend pushdown`) emits `parser_pd.rs`, resumable at any
      byte boundary, proven by `tests/pushdown_differential.rs` (all fixtures
      × chunk sizes vs single-shot, spans included); `StreamingTreeParser`
      rides it. Remaining: the old `StreamingParser` in `parser.rs` is now a
      façade with no consumers except `tests/boundaries.rs` — rework those
      tests onto `PushdownParser` (they get strictly stronger) and drop the
      `streaming` template section (keeping the shared `StreamEvent` /
      `ParseResult` types the pushdown module imports). Benchmarked 2026-07-15
      (`benches/pushdown.rs`, 1 MiB mixed doc, M-series):
      recursive ~1.25 GiB/s; pushdown ~470-480 MiB/s at EVERY chunk size
      (whole / 64k / 4k / 256B — suspension itself is nearly free). The
      ~2.6x gap is dominated by v1's owned Vec<u8> event payloads + frame
      trampoline (see the [future] emission-mode item below); recursive
      stays the single-shot default. Still pending: `--trace` plumbing for
      the pushdown backend.
- [ ] **[future] Borrow-from-buffer pushdown emission** — close the
      streaming-throughput gap when a consumer actually needs it. v1 emits
      owned `Vec<u8>` per content event (one allocation each); since the
      accumulation buffer already retains everything from the active mark
      onward, most events could borrow `Event<'buf>` slices, owning only
      content that a drain would invalidate (the same rule `Cow` already
      expresses) — delivery contract: "consume before the next
      push_chunk". Measured basis (2026-07-15, `benches/pushdown.rs`,
      1 MiB doc): recursive zero-copy 1.25 GiB/s; pushdown-owned ~470-480
      MiB/s at every chunk size (whole → 256 B; suspension itself costs
      ~3%). Expectation: since parsing itself sustains 1.25 GiB/s and the
      gap is allocation-dominated, borrowed emission should land in the
      0.9-1.2 GiB/s range; the residual is trampoline dispatch. Only worth
      building against a real streaming consumer with a throughput need —
      the correctness story is complete without it.
- [ ] **Agent-facing parse diagnostics (the inspectable-stack dividend).**
      The pushdown machine's reified stack can report, at any suspension or
      error: the open element path (names/keys/columns), depths, and the
      pending capture — the raw material for mid-parse "skeleton view at
      point" and precise agent-facing error messages the recursive parser
      structurally cannot provide. Needs a small generated accessor on
      `PushdownParser` (frame → (function, salient params)) plus an API
      shape decision *(discuss w/ Joseph — he's keen)*.
- [ ] **Grammar cleanup (stylistic / organizational)** — DRY the ~21
      near-identical number states in `values.desc`; parameterize
      `double_quoted`/`single_quoted`. Behavior-neutral; not fixture-driven.
- [ ] **Perf regression watch** — keep the criterion benchmark suite meaningful
      through the v0.8 grammar work; memory profiling on large files.
- [ ] **Pending descent-tool items** — requests/fixes we're waiting on from
      `descent` itself, tracked from *our* side (what it unblocks here) so we
      follow up rather than work around or forget. Logged in descent's
      TODO.md 2026-07-15: parameterized inline-emit payloads
      (`TypeName(:param)`) — would collapse the duplicated `check_bs_*` and
      `spaced_suffix_*` state ladders in `udon.desc` to single
      parameterized states.
      *Likely addition for the 0.9 wire (Joseph, 2026-07-16):* **saved-state /
      re-emittable captures** — the flat stacking wire re-emits `Attr "key"`
      for every segment of a multi-segment value (across lines for deferred
      blocks), so the grammar needs to hold the current key and re-emit it —
      something descent's MARK/TERM single-capture model doesn't do today.
      Wanted eventually anyway. Fallback if it lags: the wire is flexible —
      arrays are already valid attribute values, so segments could
      interim-emit as one `Attr` + ArrayStart…ArrayEnd until re-emission
      lands (keep this option in mind per Joseph).

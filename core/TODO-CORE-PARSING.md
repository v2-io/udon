# TODO-CORE-PARSING — event parser + descent grammar

The event-level parser and the descent grammar (`generator/*.desc`). Holds only
residuals and decompositions — spec *compliance* is proven by the versioned
fixture groups (see root `TODO-META.md`), not tracked here.

## Open

- [ ] **Full XID validation for non-ASCII name starts (descent)**
      (2026-07-16, diagnosis corrected same day: columns and content were
      ALWAYS UTF-8-correct — continuation bytes don't advance COL). What
      remains is the documented conservative guard: non-ASCII lead bytes
      (0xC2–0xF4) classify as identifier-start, with the `match_xid_start`
      full-decode validation both template lineages reference but don't
      generate. Consequence: `|→arrow` parses as an element where CORE's
      XID_Start says prose. One fixture quarantined at
      `fixtures/v0.9/pending-unicode.yaml.disabled`; rename to re-enable
      once the validation step exists.
- [x] ~~Verify `*` suffix after `[key]` parses~~ (2026-07-16): covered — all
      four after-key suffixes are fixture-encoded in `identity.yaml` and
      green; the Obsidian rendering miss is a highlighter-side issue.

- [ ] **Collapse the per-opener `\`-escape ladders?** *(discuss w/ Joseph)*
      (2026-07-16) Six near-identical `check_bs_{pipe,bang,semi}` /
      `blob_bs_*` / `vbs_*` ladders (text, text_backticks, sameline_text,
      verbatim_text, attr_text_verbatim, typed_value:blob) could become one
      shared `/bs_escape(:opener)` helper — `PREPEND(:param)` already
      suffices, no descent feature needed. Blocked on a behavior ruling:
      the current states DROP the accumulated Text when input ends right
      after `\|` / `\!` / `\;` (state has no eof case → bare return); a
      helper-function version would EMIT it (callee returns, caller's :main
      eof emits). Emitting looks more keep-everything-faithful, but that's
      a spec call, not a refactor call. Exact-preserving variant exists
      (helper returns an at-eof code + per-site route state) at ~zero net
      line savings.

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
- [ ] **Perf regression watch** — keep the criterion benchmark suite meaningful
      through the v0.8 grammar work; memory profiling on large files.
- [ ] **Pending descent-tool items** — requests/fixes we're waiting on from
      `descent` itself, tracked from *our* side (what it unblocks here) so we
      follow up rather than work around or forget. Logged in descent's
      TODO.md (2026-07-15 + the 2026-07-16 de-state-machine pass):
      - parameterized inline-emit payloads (`TypeName(:param)`) — collapses
        the duplicated `check_bs_*` ladders (four text functions) and the
        `spaced_suffix_*` states in `10-element.desc`.
      - runtime-byte SCAN targets — the only reason `double_quoted` /
        `single_quoted` (`30-values.desc`) are two functions instead of one
        `quoted(:q)`.
      - state templates / a "self-terminating value" state property — the
        ~15 number states in `30-values.desc` each repeat the same four
        terminator rows; merging digit classes is not an alternative
        (per-base validation: `0o9` must fall to BareValue).
      - named INT constants — would let the attr/value return-code
        vocabulary (documented at `/block_attr` in `20-attributes.desc`)
        read symbolically.
      *Resolved 2026-07-16:* saved-state re-emittable captures landed in
      descent (`SAVE(slot)` / `TypeName(USE_SAVED(slot))`, both backends —
      see descent CHANGELOG); the grammar re-emits `Attr` per segment via
      `SAVE(akey)`. The arrays fallback was not needed.

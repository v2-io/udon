# TODO-CORE-PARSING — event parser + descent grammar

The event-level parser and the descent grammar (`generator/*.descent.udon`). Holds only
residuals and decompositions — spec *compliance* is proven by the versioned
fixture groups (see root `TODO-META.md`), not tracked here.

## Open

- [ ] **`attr_trailing_blob` prose-shape audit** (2026-07-16, flagged by the
      escape-ladder agent): it's commented "prose-shaped" but has no
      inline-form or `\`-escape handling — the warn+stack trailing segment
      may be unintentionally literal-only. Compare against CORE "Text-Blob
      Values" (inline forms fire in blobs) and either wire it through
      /bs_escape + the inline-form states like the other blobs, or document
      why the trailing segment is deliberately plain.

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
- [x] ~~[future] Borrow-from-buffer pushdown emission~~ **LANDED 2026-07-16**
      (descent 344e5d9): `StreamEvent<'a>` with `Cow<'a, [u8]>` content;
      pushdown emits `Cow::Borrowed` buffer slices except PREPEND-combined
      content (owned) and SAVE-slot re-emission (owned storage, borrowed
      re-emit). Delivery contract enforced by the HRTB callback bound —
      borrowed events live only inside the callback. Measured pair
      (1 MiB doc): pushdown 321 → 396 MiB/s whole/64k/4k, 301 → 369 at
      256 B (+23%); recursive control unchanged. **The old 0.9-1.2 GiB/s
      expectation was wrong** — profiling (macOS `sample`, see
      `examples/pd_profile.rs`) shows malloc/free is only ~2-3% of pushdown
      run time; ~73% of samples are inside the generated `run()` trampoline
      (frame pop/match/push per state hop + inlined state bodies). The
      residual gap is dispatch-shaped, not allocation-shaped.
- [ ] **Agent-facing parse diagnostics (the inspectable-stack dividend).**
      The pushdown machine's reified stack can report, at any suspension or
      error: the open element path (names/keys/columns), depths, and the
      pending capture — the raw material for mid-parse "skeleton view at
      point" and precise agent-facing error messages the recursive parser
      structurally cannot provide. Needs a small generated accessor on
      `PushdownParser` (frame → (function, salient params)) plus an API
      shape decision *(discuss w/ Joseph — he's keen)*.
- [ ] **Perf: bisect the post-0.9 pushdown delta** (2026-07-16). New
      baseline recorded: pushdown ~290-307 MiB/s at 64k/4k/256B chunks on
      the 1 MiB doc (was ~470-480 pre-0.9). **CONFOUNDED** — the stored
      criterion baseline predates the whole attribute model + refactor +
      descent changes, exactly what the new before/after-pair discipline
      (core/CLAUDE.md) exists to prevent. Some cost is genuinely new
      semantics (boundary scanning, blob machinery, deferred bodies); some
      may be recoverable (SCAN coverage, state-hop overhead). Bisect with
      proper pairs: bench at each landmark commit with the SAME grammar
      across each descent bump. (Correction: the suite DOES include
      recursive_single_shot plus parse/compare groups — the earlier
      pushdown-only note read a filtered log.) First proper pair recorded
      2026-07-16 for the \-escape-ladder collapse + file renames: neutral
      to slightly positive — pushdown −1% to −7.5% time, recursive +1%
      (within the ±3-8% noise band the untouched comparison parsers show).
      No regression from that work. **Unconfounded 0.8-vs-0.9 grammar pair
      (2026-07-16, identical harness/input — 0.8-tag parsers swapped under
      the current bench)**: on the old-world `comprehensive.udon` 1 MiB
      doc, the 0.9 model costs ~21% single-shot time (recursive 1258 → ~1040
      MiB/s) and ~34% pushdown throughput (474 → ~310 MiB/s), with KNOWN
      semantic skew — 0.9 emits more events on this doc (MissingAttribute-
      Value+Nil for old valueless attrs, blob Texts, boundary work), and
      pushdown pays per-event owned-Vec allocation, which is why it suffers
      double (see the borrow-from-buffer emission item). Optimization
      targets, in likely order: boundary-state hops in the value scanner;
      per-event allocation in pushdown; SCAN coverage in the new states.
      Keep memory profiling on large files in scope.
      **2026-07-16 perf pass (four landed pairs, cumulative pushdown
      321 → 767 MiB/s, 2.4x; recursive control flat ~1.02 GiB/s):**
      borrowed emission +23% (396); in-arm state loop +64% (650); SAVE
      slots as struct fields +9% (712); inline take_capture +4.4% (742);
      inline scan helpers +3.5% (767). Gap to recursive now ~1.33x, was
      ~3.2x. Profiling (`examples/pd_profile.rs` + macOS `sample`): the
      residual is spread inside the generated `run()` (frame-addressed
      vars, per-dispatch exhausted checks, call/return frame moves) — no
      single hot outlier left; malloc traffic eliminated. **Memory
      baseline** (`examples/mem_profile.rs`, counting allocator, 1 MiB
      doc): recursive +53 B peak / 442 allocs; pushdown peak = the
      accumulation buffer, tracks chunk size (1.05 MB whole / 197 KB @64k
      / 13 KB @4k / 1.7 KB @256B), ~449 allocs at every chunk size —
      allocation count independent of event count (72,775). Remaining
      untried ideas: hoist hot frame fields into locals per arm; fuse
      column counting into the memchr scan (would speed BOTH backends);
      drain-policy tuning; boundary-state hop reduction in the value
      scanner (grammar-level); SCAN-coverage audit of the 0.9 states.
- [ ] **Pending descent-tool items** — requests/fixes we're waiting on from
      `descent` itself, tracked from *our* side (what it unblocks here) so we
      follow up rather than work around or forget. Logged in descent's
      TODO.md (2026-07-15 + the 2026-07-16 de-state-machine pass):
      - parameterized inline-emit payloads (`TypeName(:param)`) — would
        collapse the `spaced_suffix_*` states in `10-udon.elements.descent.udon`. (The
        `check_bs_*` ladders were collapsed 2026-07-16 into the shared
        `/bs_escape` helper without needing it — Joseph ruled the EOF
        behavior fork: emit, never drop.)
      - runtime-byte SCAN targets — the only reason `double_quoted` /
        `single_quoted` (`30-udon.values.descent.udon`) are two functions instead of one
        `quoted(:q)`.
      - state templates / a "self-terminating value" state property — the
        ~15 number states in `30-udon.values.descent.udon` each repeat the same four
        terminator rows; merging digit classes is not an alternative
        (per-base validation: `0o9` must fall to BareValue).
      - named INT constants — would let the attr/value return-code
        vocabulary (documented at `/block_attr` in `20-udon.attributes.descent.udon`)
        read symbolically.
      *Resolved 2026-07-16:* saved-state re-emittable captures landed in
      descent (`SAVE(slot)` / `TypeName(USE_SAVED(slot))`, both backends —
      see descent CHANGELOG); the grammar re-emits `Attr` per segment via
      `SAVE(akey)`. The arrays fallback was not needed.

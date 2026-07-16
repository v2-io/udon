# TODO-CORE-PARSING — event parser + descent grammar

The event-level parser and the descent grammar (`generator/*.descent.udon`). Holds only
residuals and decompositions — spec *compliance* is proven by the versioned
fixture groups (see root `TODO-META.md`), not tracked here.

## Open

- [ ] **Prose-shaped-blob audit: `attr_trailing_blob` and `flag_value`'s
      re-owned text** (2026-07-16). CORE "Text-Blob Values" says blobs are
      prose-shaped — inline forms fire, framed ` ; ` opens a comment. Two
      grammar paths don't fully honor that: `attr_trailing_blob`
      (`20-udon.attributes.descent.udon`) handles the framed comment but has no
      inline-form or `/bs_escape` handling; `flag_value`'s `:blob` state (the
      flag-rule-2 re-owned material, which CORE says becomes ordinary element
      prose) handles *neither* — from the shape of the grammar,
      `|el :a? some text ; comment` would swallow the comment into the Text
      (unverified by probe). Compare both against CORE and either wire them
      through `/bs_escape` + the inline-form states like the other blobs, or
      document why they are deliberately plain.

- [ ] **Full XID validation for non-ASCII name starts (descent).** The
      documented conservative guard classifies non-ASCII lead bytes
      (0xC2–0xF4) as identifier-start without the `match_xid_start`
      full-decode validation both template lineages reference but don't
      generate. Consequence: `|→arrow` parses as an element where CORE's
      XID_Start says prose. (Columns/content are UTF-8-correct —
      continuation bytes don't advance COL; diagnosis corrected 2026-07-16.)
      One fixture quarantined at `fixtures/v0.9/pending-unicode.yaml.disabled`;
      rename to re-enable once the validation step exists.

- [ ] **Retire the line-oriented `StreamingParser` façade.** The old
      line-batching streaming API could never survive a chunk boundary
      mid-construct (it re-instantiated the parser per batch — the estate
      review's #1 defect); the pushdown backend (`parser_pd.rs`, resumable
      at any byte boundary, proven by `tests/pushdown_differential.rs`:
      all fixtures × chunk sizes vs single-shot, spans included) resolved
      it, and `StreamingTreeParser` rides it. Remaining: `StreamingParser`
      in `parser.rs` is a façade with no consumers except
      `tests/boundaries.rs` — rework those tests onto `PushdownParser`
      (they get strictly stronger) and drop the `streaming` template
      section (keeping the shared `StreamEvent` / `ParseResult` types the
      pushdown module imports). Also pending: `--trace` plumbing for the
      pushdown backend.

- [ ] **Agent-facing parse diagnostics (the inspectable-stack dividend).**
      The pushdown machine's reified stack can report, at any suspension or
      error: the open element path (names/keys/columns), depths, and the
      pending capture — the raw material for mid-parse "skeleton view at
      point" and precise agent-facing error messages the recursive parser
      structurally cannot provide. Needs a small generated accessor on
      `PushdownParser` (frame → (function, salient params)) plus an API
      shape decision *(discuss w/ Joseph — he's keen)*.

- [ ] **Perf: pushdown residuals.** Current state (2026-07-16, 1 MiB doc,
      M-series; history and per-change pairs in commit messages): recursive
      ~1.02 GiB/s; pushdown 767 MiB/s whole/64k/4k after the four-pair arc
      (borrowed `Cow` emission, in-arm state loop, SAVE slots as struct
      fields, inlined take_capture/scan helpers) — gap ~1.33x, was ~3.2x.
      Profiling (`examples/pd_profile.rs` + macOS `sample`): the residual is
      spread inside the generated `run()` (frame-addressed vars,
      per-dispatch exhausted checks, call/return frame moves) — no single
      hot outlier; malloc traffic eliminated. Memory baseline
      (`examples/mem_profile.rs`, counting allocator): recursive +53 B peak
      / 442 allocs; pushdown peak = the accumulation buffer (tracks chunk
      size: 1.05 MB whole → 1.7 KB @256B), ~449 allocs at every chunk size.
      Untried ideas: hoist hot frame fields into locals per arm; fuse column
      counting into the memchr scan (would speed BOTH backends);
      drain-policy tuning; boundary-state hop reduction in the value
      scanner (grammar-level); SCAN-coverage audit of the 0.9 states. Keep
      memory profiling on large files in scope. *(Discipline reminder: every
      grammar or descent change benches as an immediate before/after pair —
      core/CLAUDE.md.)*

- [ ] **CommonMark non-conflict as a measured gate** — run the CommonMark
      spec examples through the parser as prose bodies and assert survival.
      The July measurement (pre-0.9 guards): 89.7% byte-faithful with zero
      silent text mutations, 93.0% with a `!` letter-guard — the 0.9 Marker
      Recognition guards now exist, so re-measure and pin it as a standing
      corpus test; residual is UDON-quoting-UDON and math notation (`|E|`),
      which is linter territory. *(routed from the archived review's CTQ,
      2026-07-16)*

- [ ] **Whole-grammar fuzzing / no-panic guarantee** — "any byte sequence →
      events or Error events, never a crash" is a statable, testable
      guarantee the byte-based core makes cheap. Historically only the
      temporal recognizer was fuzzed, and that recognizer left bare
      recognition in 0.8. *(routed from the archived review's CTQ,
      2026-07-16)*

- [ ] **Interpolation: multi-part values** — probed 2026-07-16:
      whole-value interpolation works in both positions (`|el :href
      !{{url}}` → `Attr`/`Interpolation`; `|div[!{{id}}]` →
      `Attr "$key"`/`Interpolation` — CORE's stale Implementation Note
      corrected same day). Still open: **mixed literal+interpolation**
      (`:mixed pre!{{x}}post` parses as the single `BareValue`
      `"pre!{{x}}post"` — the interpolation does not fire mid-token).
      DYNAMICS.md's old multi-part sketch (`ArrayStart` + alternating
      segments) contradicts the ratified 0.9 flat wire (only literal `[…]`
      arrays on the wire; segments = re-emitted `Attr`), so the wire shape
      needs a ruling before implementing — the flat-wire-consistent shape
      would be re-emitted `Attr` segments, like blobs. Pin fixtures once
      ruled. *(discuss w/ Joseph)*

- [ ] **Pending descent-tool items** — requests/fixes we're waiting on from
      `descent` itself, tracked from *our* side (what it unblocks here) so we
      follow up rather than work around or forget. Descent-side tracker:
      `tools/descent/TODO-DESCENT.md` (cleaned 2026-07-16 — the landed 2026-07
      asks `TypeName(:param)`, runtime-byte SCAN targets, `|const`, and
      `SAVE`/`USE_SAVED` are all in use in this grammar and closed there).
      Still open:
      - **state templates / a "self-terminating value" state property** —
        the ~15 number states in `30-udon.values.descent.udon` each repeat the same
        four terminator rows; merging digit classes is not an alternative
        (per-base validation: `0o9` must fall to BareValue). Design options
        recorded in TODO-DESCENT (row-splice templates the leading
        candidate).
      - **generator-verified determinism** — descent verifying that every
        state's transitions cover disjoint byte classes, making the grammar
        its own determinism proof; also the real fix for warning-free
        generated output (the `unreachable_patterns` warnings are precisely
        overlap the generator failed to reject). The single
        highest-leverage descent feature for the "checkably deterministic
        core" goal. *(routed from the archived review's CTQ, 2026-07-16)*

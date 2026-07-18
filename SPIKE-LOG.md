# SPIKE LOG — EOF positional/delimited inference in descent

**Branch:** `spike/eof-descent-inference` (udon) + `spike/eof-inference` (descent submodule).
**Goal (Joseph, 2026-07-18):** spike descent *first* (out of the usual
design→spec→fixtures→grammar order) to get the FEEL of the EOF changes coming
— can descent infer positional-vs-delimited from each function's exit
structure and generate the EOF handling (keep-content + `Unclosed<Construct>`
warning + End + entry-site), deleting the ~90 hand `|eof` arms? Push toward
elegance/truth/wisdom/strength/beauty; "there's a better way" / "the vision
doesn't account for X, so the spec plan should change" is an explicit WIN.

**Scoping call (mine, ratified by Joseph's full-latitude grant):** infer the
**EOF** classification + generation (EOF is fully defined in CORE); treat
**newline-boundedness** as a *declared per-construct property*, NOT inferred —
because CORE §Line-boundedness leaves multi-line deliberately undefined for
all but embed/freeform, so the design doc's `newline ≡ EOF for line-bound`
table row is more committed than the spec actually is.

## Grounding done (primary sources, read WHOLE)
- CORE.md — read cover to cover (1845 lines).
- CHANGELOG.md — full alpha.2 "Ruled" ledger + alpha.1/0.8 history.
- descent: README, TODO-DESCENT, implementation-spec (Inferred EXPECTS sketch).
- descent-rs internals read directly: `ir_builder.rs` (`infer_expects`,
  `build_function`/`build_state`, `is_unconditional`), `emit/rust_pushdown.rs`
  (`render_eof`).
- Grammar read directly: 60-embedded, 80-freeform, 70-dynamics, 30-values
  (partial), 10-elements `parse_element_identity`.

## Phases
- [ ] **P0 — Static classification analysis.** Read the WHOLE grammar; classify
      every function positional/delimited by exit structure; catalog hard cases
      (param closers, multi-byte/depth closers, closer-in-callee, shared
      parameterized fns, mixed machines). → findings doc. (de-risks P1, is the
      "vision-gap" deliverable.)
- [ ] **P1 — Implement in descent-rs.** Classification pass in ir_builder;
      generate positional default-end vs delimited failure-unwind
      (content→Unclosed→End) + entry-site; static-reject mixed machines.
- [ ] **P2 — Validate.** Regenerate parser, delete redundant `|eof` arms, run
      compliance gate + benchmarks; observe FINDINGS-bug behavior.

## Running notes
(append-only; newest last)
- Env wired: worktree + descent submodule branch. Starting P0 grammar read.
- **P0 DONE** → `SPIKE-P0-classification.md`. Read the whole grammar directly.
  Thesis: EOF = newline+maximal-dedent is *derivable*, not authored — two
  synthesized primitives replace all 90 `|eof` arms: positional EOF = clone the
  state's `\n` arm; delimited EOF = keep+`Unclosed<Construct>`+End at every
  state. Classification is the only inferred thing. 8 vision-gaps catalogued;
  headline: closer-in-callee is the *norm* (breaks today's `infer_expects`);
  `parse_element_identity` is both kinds per call-site; `<…>` envelope should
  become its own fn; line-boundedness stays a declared flag (array diverges
  from CORE). Next: baseline build, then P1 experiment #1 (positional EOF).
- **Baseline** (worktree): `./regenerate-parser` OK (both backends: recursive
  `parser.rs` + pushdown `parser_pd.rs`). Gate = **RED 2/478** (1 `eof_recovery`
  + 1 other) — alpha.2 reds live in `_wip/` (not run), so committed group is
  near-green. Preserve <=2 for the behavior-neutral positional experiment.
- descent backend: `render_eof` (rust_pushdown.rs:524) today = explicit `|eof`
  handler -> CONTENT auto-emit -> `Unclosed{Type}` **Error** if `expects_char`
  -> `{Type}End` if bracket. Positional `|eof` arms exist exactly where
  auto-inference is insufficient: void manual-emit (prose/text) + per-state
  typed (typed_value numbers). That's the P1 target.
- **P1 experiment #1 (empirical, decisive).** Deleted all 16 pure `|eof| |return`
  arms → gate 2→3/478. Bisected: the +1 is `eof_recovery::eof_fence_closer_no_final_newline`
  (freeform `post_close`); the other two reds (`dynamics_syntax::flag_then_raw_block_is_child`,
  `eof_recovery::eof_unclosed_embedded_with_open_attr`) are **pre-existing**
  (latter is the documented FINDINGS embed-drop bug). Restored ONLY freeform's
  arm → back to 2/478. Conclusion:
  - **15 of 16 pure-return positional arms are redundant** — descent's default
    EOF already reproduces a bare `return` (document, 4× `element` BRACKET arms,
    prose, comments, attr). Deleted; gate holds. (90→75 arms.)
  - **The 1 exception is a real descent bug**, not a grammar need: for a BRACKET
    function, `render_eof` emits `{Type}End` **explicitly** (rust_pushdown.rs
    ~552), which **double-emits** against the frame's normal return-`End` when
    EOF lands in a *post-closer* state. `freeform:post_close` (closer already
    consumed, peeking for the trailing newline) hits this: expected
    `FreeformStart/Text/FreeformEnd` (3), got 4 (extra `FreeformEnd`). The hand
    `|eof|return` masked it by routing through the single normal return.
  - **Fix direction:** `render_eof`'s bracket case should route EOF through the
    normal return path (single `End`), not emit `{Type}End` as a separate event.
    Once fixed, freeform's arm deletes too (and the delimited synthesis, which
    also needs End-after-content, inherits the correct single-End path). Needs
    the descent before/after benchmark pair (per CLAUDE.md) since it's a codegen
    change — deferred to the next push.
- **State:** 15 arms deleted, gate at baseline 2/478. Both remaining reds
  pre-existing. Next: fix `render_eof` bracket End (unblocks bracket arms +
  delimited synthesis), then the delimited classifier (gaps 1/4/5).

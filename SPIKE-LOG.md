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
  - **The 1 exception (freeform post_close) is NOT a bug — it is a legitimate,
    load-bearing override.** *(CORRECTION: my first pass here claimed a
    "render_eof double-emits End" descent bug. That was WRONG — asserted from
    the +1 event count + a plausible mechanism, never verified. Dumping the
    actual events (`examples/stdin_parse`) showed the 4th event is
    `Warning(UnterminatedFreeform)`, not a second `FreeformEnd`.)*
  - **Real mechanism:** `freeform` has a **function-level** `|eof |
    Warning(UnterminatedFreeform) | return` (line 11). The `post_close` state's
    `|eof | |return` **overrides** it: once the closer `` ``` `` matched,
    `post_close` is only checking for the optional trailing newline, so EOF
    there is a clean close (EOF ≡ that newline) and must NOT warn. Delete the
    override → EOF at post_close falls through to the function-level handler →
    a correctly-closed fence spuriously emits `UnterminatedFreeform`.
  - **The clean rule (principled):** a state-level `|eof| |return` is REDUNDANT
    iff its function has NO function-level `|eof` handler (default EOF = return,
    matches); it is LOAD-BEARING iff the function HAS one (the state arm exists
    to suppress it where wrong). `freeform` is the ONLY one of the 16 with a
    function-level handler → the only non-redundant deletion. Verified by
    reading the grammar + the gate delta.
  - **Model mapping:** this validates the design MORE cleanly — `freeform` is
    delimited (function-level → warn-if-EOF-while-open); `post_close` is the
    *positional tail after the closer matched* (EOF ≡ newline, no warning). The
    generated model must express "once the closer is consumed the frame is
    closed; the trailing check is positional." No descent change needed here.
- **State:** 15 arms deleted (freeform's override restored, correctly kept),
  gate at baseline 2/478, both remaining reds pre-existing.
- **Verification pass (Joseph: verify before cementing; agents are inputs, not
  adjudicators).** Spawned 3 adversarial checkers vs the primaries. Agent-2
  (CORE claims) returned; adjudicated against my own reads:
  - gap-6 CORRECTED (see P0 doc): my "grammar diverges from CORE" was the wrong
    FRAME. CORE §End-of-input (66) says line-bound `[..]`/`<..>` warn-on-newline
    (grammar matches it); CORE §Line-boundedness (76) calls arrays "undefined" —
    CORE contradicts *itself*, evidence that array line-boundedness was never
    decided. The three "undefined" constructs behave 3 ways (envelope warns,
    array warns, string silently spans — `quoted` has no `\n` arm).
  - Recalibration (Joseph): this is a **descent-first spike**; CORE's EOF
    specifics LAG the decisions and are the prior agent's provisional guesses
    (CORE line 39 says so). Do NOT treat CORE as a compliance target. Frame =
    ratified rulings (positional/delimited, two-level severity, keep-everything,
    EOF≡newline+dedent, content-first order); provisional = code spellings +
    per-construct line-boundedness (spike may change). "Compliant with CORE" was
    my reflex-error; dropped.
  - Agent-1 (grammar classification) died on an API error mid-run — its job is
    largely covered by the mechanical `classify.rs` pass below; re-spawn fresh
    eyes only if the pass leaves gaps. Agent-3 (thesis stress-test) still running.
- **Integration build in progress: descent classification pass.** New
  `tools/descent/rust/descent-core/src/classify.rs` (report-only, no codegen
  change) + `descent-cli classify <file>`. Encodes the RULE (exit-structure →
  positional/delimited/mixed, with a 4th "semantic-close" tag for the
  `/error` litmus-out cases), NOT my answer key — so it's an independent third
  computation to triangulate against my reading + the agents. v1 is direct (no
  call-graph), so closer-in-callee (embed etc.) will surface as a POSITIONAL
  misclass — the expected, informative divergence that localizes gap-1. Next:
  run it, compare to hand-classification, then add callee-inheritance (v2).
- **Classifier DONE + correct (committed in descent submodule 84e62e5).** v1
  surfaced the closer-in-callee blind spots mechanically AND revealed my own
  rule over-fired on the closer side (MIXED=10). Refined the rule (call=
  delegation w/ fixed-point inheritance; `\n`/space=always geometric; consumed
  non-geom=closer; Unclosed*/Unterminated* only = closer-failure; fn-level vs
  state-level delimfail). Result: **positional=33 delimited=11 MIXED=1**. The 11
  delimited match the hand set EXACTLY (quoted/array/embed/embed_content/interp/
  sameline_raw/sameline_dir_body/brace_comment/comment_text_braced/freeform/
  sameline_directive); the 1 MIXED = typed_value (`<…>` envelope sub-region =
  gap-3), pinned mechanically. Three-way agreement: my reading + fresh-eyes +
  descent's computation.
- **Agent-3 (thesis stress-test) returned — high value, adjudicated + spot-
  verified myself:**
  - REFUTES literal "(A) positional EOF = clone the `\n` arm": **gap-9 (NEW,
    verified)** — a state family (`:num_sign`, `:maybe_ref`, `:strb_*`, `:kwb_*`
    …) has no `\n` arm AND no `|eof` arm; at EOF `typed_value`'s INTERNAL default
    drops accumulated content. Verified myself: `|e :x +` <EOF> → `+` GONE;
    `|e :x abc :` → "abc :" GONE. ⇒ primitive is newline-INJECTION (run the
    machine through the fall-through), not arm-cloning. Confirms Joseph's framing
    is *necessary*, not just cleaner.
  - B-5 (verified myself): `|e :'abc`<EOF> → generic `Error{Unclosed}`, warning-
    first, `Error` not `Warning` — descent's inferred `skip_single_quoted` path
    is wrong on code+severity+order; normalization must reach inferred helpers.
  - Confirms/sharpens gaps 1-8; adds the reference-`[` missing-warning (parallel
    to identity-`[`), the two-outlier emission-order, the positional-tail-after-
    closer generalization (B-7), and the semantic-close-not-deletable bound (A-3).
  - Agent-2's gap-6 correction folded in (CORE-internal inconsistency, not
    grammar-vs-CORE; line-boundedness unsettled/provisional).
- **VERIFIED vs OPEN (per Joseph — don't cement unverified plans):** VERIFIED =
  classifier (delim=11, MIXED=1); 15/16 arm redundancy; A-1/gap-9 + B-5;
  newline-injection necessity; the delimited set. OPEN/HYPOTHESIS = the descent
  *generation* (positional inject-and-run + delimited force-unwind) — unbuilt;
  it's a descent-core runtime change (per CLAUDE.md, Joseph's fast-turnaround
  domain + needs benchmarks). P0 doc "Candidate directions" is marked hypothesis.

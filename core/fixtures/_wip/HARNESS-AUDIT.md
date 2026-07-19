# Adversarial harness audit — comparison-layer knowledge & compensators
*(2026-07-19; fresh-eyes Sonnet-5 audit commissioned for the P0 text-wire
recast — see `spec/TODO-TEXT-WIRE.md`. Lens: every place the test/comparison
layer rewrites, drops, reorders, tolerates, or consults anything beyond the
event stream itself. Verification addendum by the coordinating session at
bottom.)*

## Summary judgment

- **Confirmed root cheat:** `collapse_adjacent_text`'s span-gap SOURCE
  consultation (`harness.rs`) — reads raw input bytes between Text spans to
  decide merges; knowledge no consumer has; the enabler that kept the
  newline-dropping wire green.
- **Confirmed byte-fabrication:** `tree.rs::push_text_chunk` (heuristic
  space; empty-chunk drop) — PLUS its self-referential unit tests
  (`test_all_text_separates_lines` asserts the fabricated space as ground
  truth; `test_all_text_no_double_space_around_inline`; tree.rs ~1027/1034)
  — delete/rewrite the tests with the function.
- **NEW #1 (the audit's most important non-obvious find):**
  `run_with_variations`' `expects_multiline_content` skip
  (`c.contains('\n')` over expected content) is a legitimate proxy TODAY
  (targets delimited verbatim captures) but becomes a **large silent
  coverage hole the day the wire fix lands** — once ordinary prose Texts
  carry `\n`, it fires on nearly every multi-line fixture and silently
  skips variation testing across the corpus. Must be RE-SCOPED in the
  rewrite (e.g. to delimited-capture event kinds specifically).
- **NEW #2:** `tree.rs::collect_text` has no BlankLine arm — and (verified,
  see addendum) the builder **drops BlankLine events entirely outside raw
  blocks** ("Elsewhere blank lines are not represented in the tree (yet)",
  tree.rs ~816). The AST loses paragraph breaks wholesale — a third member
  of the same lossy family; the sweep adds BlankLine representation + the
  D4 `"\n"` contribution.
- **Clean under the lens:** `generators.rs`, `loader.rs`, `spans.rs`
  (actively anti-compensator — asserts `input[span] == content`; KEEP as a
  template), `pushdown_differential.rs` (structurally can't cheat; will
  surface backend newline divergence for free), `boundaries.rs` (exact
  unfolded equality across chunkings — will also surface the fix
  honestly), `tree_api.rs` (no coverage of this axis yet), `stream_tree.rs`
  (`own()` faithful; one test rides the fabricating path without
  triggering it), `asserts_empty_text`, `root_only`, the `events: []`
  TODO-test convention, the variation subsequence-match tolerance.
- **Notes for the sweep:** exploratory/*.yaml "CURRENT" recordings were
  captured THROUGH the fold — expected drift when the compensator dies,
  pre-flagged as noise not regression. Post-fix, re-check any `events: []`
  TODO fixtures that may have been TODO because pinning newlines was
  impossible under the old fold. The empty-Text default drop stays
  authorized (a `Text "\n"` terminator-only event is non-empty and is not
  swallowed by it — add an explicit test at the seam).

## Full findings

(Agent report, verbatim, findings 1–16: span-gap fold mechanism; empty-Text
drop scope notes incl. the harness comment that becomes stale under D2;
asserts_empty_text clean; variation skip-predicate analysis incl. the
expects_multiline_content landmine and the honest subsequence tolerance;
generators/loader clean; canonical TODO-mode; boundaries' exact chunked
equality + narrower EOF-invariant scope; spans.rs as anti-compensator;
exploratory's fold-captured recordings; differential's Debug-normalize-only
comparison; tree_api no-coverage; stream_tree own()/all_text notes; the
push_text_chunk fabrication + its self-asserting tests; the deliberate and
CORRECT '\n' join in TreeBuilder comment accumulation (~622–647) which must
NOT be confused with fabrication — it is a sound AST-layer reconstruction
from structural knowledge; the collect_text BlankLine gap.)

## Verification addendum (coordinating session, 2026-07-19)

- `grep BlankLine tree.rs` → single arm at ~818: outside `Raw` nodes the
  event is discarded with the comment "Elsewhere blank lines are not
  represented in the tree (yet)". NEW #2 confirmed and sharpened: not just
  "contributes nothing to all_text()" — the tree has no record the blank
  line existed. The sweep gives BlankLine a node representation (S6 AST
  policy needs it for both the interior→newline rule and the
  ornamentation/round-trip option) and the D4 `"\n"` contribution in
  `collect_text`.
- NEW #1 (`expects_multiline_content` re-scoping) promoted into
  `spec/TODO-TEXT-WIRE.md`'s harness section as a required rewrite step.

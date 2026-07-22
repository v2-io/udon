---
source: live repo file `design/descent-experience-2026-07.md` at gather time
gathered: 2026-07-21
status: gathered source material — verbatim whole-file copy; NOT authoritative; live originals may advance
paths:
  - design/descent-experience-2026-07.md
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693
categories: [descent, grammar-authoring, lived-tool-friction, wishlist, dialect-author-ux]
why_included: |
  HIGHER SIGNAL THAN ITS L RATING. First-person lived tool-friction testimony —
  Joseph mid-grammar-surgery, explicitly invited to 'imagine a better hypothetical
  syntax.' This is the tool's author describing where the tool fought back and what
  he wished for: a first-class LINE construct with per-function terminator policy
  (would have made a per-arm surgery a one-flag change), generate-time errors for
  orphan/unreachable states, emit-idiom sugar, state-templates to kill triplicated
  sister functions, a DSL lexer that honors quoting for braces. Rare Tier-1/Tier-3
  crossover: ideology AND lived practice in one voice. Prime demand evidence for what
  a grammar/parser-authoring harness should provide.
---

# Descent & grammar experience notes — from the text-wire sweep (2026-07-19)

*(Commissioned by Joseph mid-sweep: "if it feels like you're fighting descent
instead, take a step back and imagine a better hypothetical syntax." These are
live observations from implementing HOLD/RELEASE and the newline-carrying
Text recast — the two largest grammar surgeries since the EOF generation.)*

## Where I fought the tool (descent opportunities, roughly by leverage)

1. **Line discipline is implicit, and it's the biggest tax.** The recast's
   hardest part was not the semantics but hand-threading one bit — "did the
   callee consume its line terminator?" — through ~30 call-arm routings
   (`:after_content` vs `:after_newline`, `:line_end` vs `:line`, the
   deferred-body entry split). That bit is a FUNCTION PROPERTY. Descent could
   let a function declare (or infer) `consumes-terminator`, and let states
   declare their protocol (line-start vs mid-line), then VERIFY every
   transition's compatibility at generate time. Today the failure mode is a
   silently mis-routed blank line. The hypothetical better syntax: a
   first-class **LINE construct** — open / content / terminator phases with a
   per-function terminator policy (`text-mode`: terminator joins the capture;
   `geometry-mode`: consumed silently) — under which this whole sweep would
   have been a one-flag change per function instead of per-arm surgery.
2. **Unreferenced states are accepted silently.** My `:post_comment_nl`
   landed in the WRONG function (replace anchored on a sister function's
   identical shape) and descent parsed it there as an orphan without a
   whisper — the error surfaced as rustc E0599 in the OTHER function.
   Generate-time errors wanted: transition-to-undefined-state and
   defined-but-unreachable-state. (Adjacent to the existing validator TODO.)
3. **The emit idioms want sugar.** `| -> | TERM | Text(USE_MARK)` (include
   the terminator) and `| MARK | -> | TERM | Text(USE_MARK)` (terminator-only
   text) now appear ~15×. Something like `TERM_THRU` / `EMIT_NL(Text)` would
   make the terminator policy visible instead of idiomatic.
4. **The DSL lexer can't carry a brace in a quoted literal** — `PREPEND('!{')`
   dies ("unterminated single quote"); the workaround is `'\x21\x7b'`. The
   char/string lexer should honor quoting for `{`/`}` like it does for `|`.
5. **Triplicated sister functions.** `text` / `text_backticks` /
   `sameline_text` (and the blob family: `typed_value :blob` /
   `attr_trailing_blob` / `attr_text_verbatim`) are near-identical shapes
   maintained in parallel — every sweep edits them N times (and my
   wrong-function insertion in #2 was CAUSED by their identicality). The
   state-templates design (TODO-DESCENT) is the fix; this sweep is fresh
   evidence it pays for itself.
6. **HOLD/RELEASE landed well** but the recursive backend's type-erased sink
   and the pushdown's global flag are two implementations of one concept —
   when descent grows the frame-owned construct identity (caller-owns-name,
   gap-2), holds could unify under it.

## Grammar cleanup opportunities (udon-side, post-`*{`-rewrite)

- The boundary-marker guard arms are duplicated across the `:kwb_*` /
  `:strb_*` twins in `30-values` — the `*{` boundary rewrite will touch all
  of them; collapse the twins then (keyword-vs-string is one flag).
- The blob family unification above.
- The `:after_content`/`:after_newline` pair in `10-elements` (and
  `:line_end`/`:line` in deferred-body) exist only to encode the
  consumed-terminator bit — they collapse to one state each under a descent
  line-discipline feature (#1).
- Number-state terminator rows: already tracked (state templates).

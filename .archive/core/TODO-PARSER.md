# TODO-PARSER — AST (one-shot) + streaming-AST parsers

The consumer layer built on the event spine: the tree/AST builder, the streaming
AST, and their API decisions. Predicated on a stable event parser. (Compliance
fixtures that test *core syntax* at the AST level belong to the unified gate — see
root `TODO-META.md` — not here.)

## Open

- [ ] **Tree / AST builder** — *landed 2026-07-15 for the 0.8 model*
      (`udon-core/src/tree.rs`): `Document`/`Node` arena, parent pointers,
      spans, and the CORE Host Views — the substrate is the full ordered
      attribute list (designated `$`-attrs included, round-trip safe), with
      `key()` / `traits()` (always a list) / `attributes()` /
      `all_attributes()` / `attr()` (scalar = last) / `attr_all()` derived.
      **Remaining:** selectors; string interning (perf, only if measured).
- [ ] **Streaming AST** — *landed 2026-07-15* (`udon-core/src/stream_tree.rs`):
      `TreeStream` — push events in, completed root-level subtrees ship as
      owned `Document`s the moment they close (CORE "Streaming Parse") —
      plus the `StreamingTreeParser` byte-feeding convenience. *Updated same day:* the
      explicit-stack backend landed — `StreamingTreeParser` now rides
      `PushdownParser` and is correct at ANY feed boundary (byte-at-a-time
      tested; review defect #1 resolved). **Remaining:** nothing here; see
      CORE-PARSING for the old-façade retirement.
- [ ] **Parser API decisions** — surface shape for consumers.
      *(discuss w/ Joseph where the API is user-facing)* Decisions taken
      provisionally in the work above, for review: scalar `attr()` = LAST
      stacked value; `traits()` returns `Vec<&Value>`; anonymous name =
      `""` + `is_anonymous()` (vs `Option<&str>`); streaming granularity =
      one root-level subtree per shipment, each an owned single-root
      `Document`; root blank lines/warnings ship nothing.
- [ ] **S6 blank-line interpretation (AST layer)** — ruled 2026-07-19: the
      event stream is geometry-faithful (`BlankLine` everywhere non-protruding);
      the AST builder interprets — interior BlankLines between text become
      newlines; leading/trailing become *ornamentation* (discarded from text)
      or literal BlankLine nodes kept for round-trip. PLUS the ruled
      final-terminator disposition (2026-07-19): interior terminators are
      text; a run-final terminator INSIDE the last content Text is
      ornamental (trim); a run-final STANDALONE `Text "\n"` (the trailing-`\`
      idiom) is explicit (keep). `all_text()` stays pure reconstruction; the
      interpreted accessor applies this policy. Decide the node shape with
      the error-reporting rework below.
- [ ] **Error-reporting quality + keep-everything at the AST layer.** Current
      state (verified 2026-07-18 at `tree.rs:244`, supersedes the estate
      review's stale "stopped at first error"): `Document::parse` collects *all*
      errors now, but two things fight keep-everything and will bite whoever
      builds the real API — (a) on any error it returns `Err(ParseErrors)` and
      **drops the built tree** (the event layer kept everything; the AST layer
      throws it away), and (b) **warnings are never collected** (handed to the
      builder, which ignores them), so a caller can't see them at all. The
      two-level severity ruling (CORE "End of input"; design record archived at
      `../_archive/TODO-EOF-refactor.md` → *Severity — two levels*) sharpens both: every `Unclosed*` is now a **warning** (dropping
      warnings would hide unclosed constructs), and the document-level
      incomplete-input is a **result**, not a diagnostic (modeling it as an
      event is the rejected aggregate vehicle). Constraints for the rework —
      **surface shape left to the implementer**: the tree stays available,
      diagnostics (warnings + errors: severity/span/code/message) ride
      alongside, and the completeness verdict is separate — the
      rust-analyzer/rowan "tree + diagnostics" shape rather than
      `Result<Tree, Err>`, with a `?`-friendly strict convenience for callers
      who'd rather bail. Timesaver worth folding in: the code vocabulary is
      split (errors are a typed `ParseErrorCode`, warnings are stringly-typed
      `Cow<[u8]>`) — the ruling moves `Unclosed*` into warnings, so a unified
      `Severity` + typed code earns its keep. Still open too: source-snippet
      diagnostics, the message-quality bar. *(current-state + severity linkage
      2026-07-18)*
- [ ] **[later] Language bindings** — Ruby (FFI over the streaming API, lazy
      tree projection), WASM, Python (PyO3), C ABI shared library. Predicated
      on a stable, compliant parser API.

---
source: live repo file `spec/TODO-TEXT-WIRE.md` at gather time
gathered: 2026-07-21
status: gathered source material — verbatim whole-file copy; design-of-record for a LANDED recast; NOT authoritative
paths:
  - spec/TODO-TEXT-WIRE.md
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693
categories: [agentic-tooling, keep-everything, text-reconstruction, event-wire, verification-tooling-lesson, notation-guarantee, design-of-record]
why_included: |
  A crystallized notation-for-agents GUARANTEE and a verification-tooling lesson, both
  first-class for the harness consumer. The guarantee (the one-sentence contract):
  "Given the FULL event stream, the document's text material is reconstructable by pure
  in-order concatenation of the text-bearing events — no spans, no source, no gap
  inspection." Joseph named the violation the project's HIGHEST-priority defect: the wire
  dropped line terminators, so "the parser's own output cannot reconstruct the document's
  text… Every keep-everything / no-data-left-behind claim was false at exactly the byte
  that carries text's most cognition-load-bearing geometry." The harness LESSON is the
  transferable gold: the fixture harness's source-gap fold "ENABLED the bug instead of
  catching it" — a verification layer that consulted knowledge no real consumer has, so
  the gate stayed green over a broken wire. The text/geometry/annotation byte taxonomy
  and the comment-stripping-must-not-re-lose-line-boundaries rule are reusable design for
  any agent-facing document wire.
---

# TODO — the text-wire recast: newline-carrying Text (P0 SHOW-STOPPER)

> **Status: LANDED (2026-07-19, same day) — wire, harness, fixtures, AST.**
> The gate is fully green on the newline-carrying wire (5 consecutive runs,
> variations included); pushdown differential green; full workspace suite
> green; exploratory re-recorded (19/0). Bench pair: +5–8% IMPROVED (the
> consolidated terminator-inclusive emission is cheaper than the old
> per-line state hops). Open residuals: the root-nameless-`!{` micro-gap
> (below), the final-terminator disposition venture (below, near-ruled),
> and the CORE-text polish items in TODO-SPEC-CORE.
> This is the design of record for fixing the project's highest-priority
> defect (Joseph, 2026-07-19): *the event wire drops the document's
> newlines.* Prose/freeform/comment/raw Text events exclude their line
> terminators, so the parser's own output cannot reconstruct the document's
> text — consumers were silently expected to re-inspect the source, and the
> fixture harness's source-gap fold ENABLED the bug instead of catching it.
> Every "keep-everything / no data left behind" claim was false at exactly
> the byte that carries text's most cognition-load-bearing geometry.

## The contract (the one sentence everything serves)

**Given the FULL event stream, the document's text material is
reconstructable by pure in-order concatenation of the text-bearing events —
no spans, no source, no gap inspection.** ("Full stream" softening + the
ornamentation caveat: Joseph, 2026-07-19 — some dispositions, e.g. trailing
BlankLines before a dedent, are interpretable only over the whole stream /
at the AST layer; the event parser never pre-judges them.) `fold(events): Text/RawContent → content;
BlankLine → "\n"` yields the text. Anything less is the bug.

## The model — text bytes vs geometry bytes

Every input byte is exactly one of:

- **Text bytes** — flowing content, line terminators *within* text
  included. Always carried in text-bearing events, in source order.
- **Geometry bytes** — structure: indentation (dedent-stripped or
  embed-skipped), markers/sigils, consumed escapes (`\` itself), the
  terminators of *pure-structure* lines (`|el :a 1`'s own newline, a block
  comment's line). Never text; recoverable via spans (serializer/SourceInfo
  territory, a different contract).
- **Annotation bytes** — comment content. Carried in Comment events; never
  carries the enclosing line's terminator (else stripping comments would
  re-lose line boundaries — the disease reborn).

**The terminator rule:** a line's terminator is a text byte iff the line
contributed text-stream content — and it rides the *last text-bearing event
of that line*, or a trailing terminator-only `Text "\n"` when an annotation
or inline form owns the line's end.

## Per-construct enumeration (the sweep's checklist)

| Site | New wire | Note |
|---|---|---|
| Block prose line | `Text "content\n"` | final line w/o source newline → no `\n` (EOF ≡ newline: structural, and the byte truly absent) |
| Sameline prose tail | `Text "tail\n"` | same rule |
| Whitespace past content-base | `Text "  \n"` | Joseph's S6 example reconstructs by pure concat |
| Blank / non-protruding ws line (prose ctx) | `BlankLine` | **defined as contributing `"\n"`** to reconstruction — a *labeled* newline-only line; S6 AST policy (interior → newline, edges → ornamentation) unchanged |
| `\`-forced line, newline-terminated | `Text "\n"` (or `"tail\n"`) | resolves Joseph's `hey \` + child question as option (a), now uniform — no special case |
| `\`-forced at EOF | `Text ""` | unchanged (no terminator byte exists); asserts_empty_text cases stand |
| Embedded `\|{…}` content lines | `Text "line\n"` | skipped continuation indentation stays geometry |
| Freeform lines | `Text "line\n"` | exactness contract finally true; **blank lines here become `Text "\n"`, not BlankLine** (decision D2) |
| Raw block / RawContent lines | `RawContent "line\n"` | code without newlines was the bug at its most glaring |
| Comment content (block + continuation + sameline) | terminator NOT in comment Text | annotation rule above |
| Prose line ending in a sameline comment | `Text "Item one "` + Comment + `Text "\n"` | the trailing terminator-only Text (decision D1) |
| Prose line ending in an inline form | …EmbeddedEnd/`;{…}`/interp + `Text "\n"` | same mechanism |
| Multi-line deferred attr values | segments each `"…\n"` | value reconstruct = concat; flat wire unchanged |
| Pure-structure lines | no text event | their terminators are geometry. **Refined during the sweep (a fixture agent's better reading, adopted): "pure-structure" means lines emitting NO text-bearing events** — any Text/RawContent event carries whatever terminator its source line has, uniformly (directive args included: `!if x⏎` → `Text "x\n"`); no per-context carve-outs |
| Delimited captures (strings, envelope, interp) | unchanged | already newline-carrying — the regime the rest now joins |

## Spec changes (CORE)

1. Rewrite the **Text granularity** parser-behavior note into a **Text
   Reconstruction** contract, and ONLY that (Joseph, 2026-07-19: "there
   shouldn't be *anything* in the spec about fixtures"): (a) text may fire
   as any number of splits — a Text event is never guaranteed to be the
   complete text; (b) pure in-order concatenation reconstructs it (the
   contract sentence above, with the taxonomy / BlankLine ≡ `"\n"` /
   annotation-terminator rule). The current note's fixture/harness
   sentences ("fixtures express text maximally collapsed… the harness
   folds…") LEAVE CORE entirely — test-layer conventions live in
   `core/fixtures/README.md`, never in the language contract.
2. Fix the **multiline embedded** bullet ("consumers concatenate" now
   actually works) and **Automatic Prose Dedentation**'s streaming note.
3. Make **Freeform**'s "preserved exactly" true (all-Text, terminators in).
4. **Keep-everything** (Anomaly posture): newline bytes now genuinely
   covered — the claim becomes true.
5. Fold in the S6 rulings (blank-line model, ornamentation vocabulary,
   BlankLine span covering its whitespace + terminator).

## Fixture + harness changes

- **Harness de-compensation:** the fold becomes *pure adjacent-Text
  concatenation* — delete the span-gap/source consultation entirely (safe
  now: same-line and cross-line adjacency both concat correctly). The
  empty-Text default fold stays (authorized concatenation — an empty
  segment folds into a general assertion) since real empties (`Text ""` at
  EOF) opt into exactness via asserts_empty_text.
- **Adversarial harness audit FIRST** (fresh eyes, Sonnet-5 delegate ok):
  every place the comparison rewrites, drops, or consults anything beyond
  the event stream. Known suspects resolved by this design; the audit
  proves there are no others.
- **Fixtures:** every multi-line prose/embed/freeform/comment/raw
  expectation gains its terminators (spec-first: written from the new CORE
  text, gate goes honestly red, grammar burns it down). Hundreds of edits,
  mechanical.
- **Variation machinery:** the newline-append variation now legitimately
  changes the final text event by one byte (`"x"` → `"x\n"`) — the
  comparison needs a defined final-terminator tolerance (decision D3), or
  those variations assert the appended form.
- **AUDIT FINDINGS (2026-07-19, `_archive/HARNESS-AUDIT-2026-07.md`):**
  (1) `expects_multiline_content`'s `c.contains('\n')` variation-skip proxy
  MUST be re-scoped to delimited-capture kinds before the wire fix — else
  it silently skips variation coverage for nearly every prose fixture the
  day Texts carry terminators (the audit's key non-obvious find); (2) the
  fabricating `push_text_chunk` tests (tree.rs ~1027/1034) die with the
  function; (3) exploratory recordings were captured through the fold —
  post-fix drift there is expected noise, pre-flagged; (4) `spans.rs` is
  the anti-compensator template — keep and extend it.

## AST-layer finding (2026-07-19, answering "how did the AST proceed?")

`tree.rs::push_text_chunk` — the AST's text joiner — **fabricates bytes**: it
inserts a heuristic space between chunks when neither side has whitespace,
and silently skips empty chunks. Neither source-cheating nor honest
loss-propagation: `line1\nline2` → `"line1 line2"` (wrong byte substituted),
a same-line escape split → `"foo |{bar"` (a space that never existed), empty
lines vanish. Its tests assert the heuristic's own output. A downstream
patch over the felt symptom of the missing newlines — delete it in the
sweep: `collect_text` becomes pure concatenation (+ BlankLine → `"\n"`),
and `tree_api`/`stream_tree` text tests are re-derived from the new wire.
**Verified worse (audit + grep): the builder DROPS BlankLine events entirely
outside raw blocks** ("not represented in the tree (yet)", tree.rs ~818) —
the AST loses paragraph breaks wholesale. The sweep adds a BlankLine node
representation (the S6 AST policy requires it for interior→newline AND the
ornamentation/round-trip option) plus the D4 `"\n"` contribution in
`collect_text`.

## Grammar changes (both backends via regen)

Text-family functions switch from return-at-`\n` to consume-then-TERM
(text, sameline_text, text_backticks, verbatim_text, embed_content,
freeform lines, blobs, attr_text_verbatim, deferred-body segments); the
trailing terminator-only `Text "\n"` emission after sameline comments /
inline forms at EOL (the fiddly part — small added states); comment/raw
line handling per the table. Bench pair per discipline (perf notes only —
Joseph: don't over-invest pre-tag).

## Known micro-residual (accepted, logged)

A ROOT-level nameless `!{` at end-of-line emits `Text "!{"` without its
terminator (prose contexts emit the D1 trailing `Text "\n"` via their
post-inline states; the document root's shared `:eol` consumes it as
geometry). Contract-violating for that one malformed edge; fixing it cleanly
wants the descent line-discipline feature (experience notes #1) rather than
another hand-threaded state. Revisit with the `*{` rewrite.

## Final-terminator disposition (RULED 2026-07-19 — see CHANGELOG; kept here as the worked mapping)

The very FINAL trailing newline of a text run (before dedent/End) is the one
still-underdefined disposition: ornament (udon-positional) vs inner text.
Current wire keeps it IN the Text content (`"hi\n"`), so the AST holds the
byte and the decision is deferrable. Joseph's proposed rule maps onto the
wire almost for free:
- **Explicit newline** — `\`-forced with nothing after the `\` → wire
  `Text "\n"` (already distinct from BlankLine): AST always preserves.
- **Implicit** — `BlankLine` (S6 policy: interior → newline, edge →
  ornament) and the final terminator inside an ordinary prose Text
  (AST may trim as ornament or keep as text — both implementable, byte
  present either way).
RESOLUTION (Joseph's three examples): interior = text; run-final
IN-CONTENT terminator = ornamental (AST trims); run-final STANDALONE
`Text "\n"` (trailing `\` at line end) = explicit (kept). The
trailing-`\` idiom IS the explicitness gesture — no wire marker needed.
AST-side landing: `core/TODO-PARSER.md` S6 item; CORE gets the three
worked examples.

## Decision shortlist for Joseph

- **D1 — terminator-only trailing `Text "\n"`** after an annotation/inline
  form that owns a text line's end (byte-honest, in source order; keeps
  comment-stripping safe). *Recommended: yes.*
- **D2 — freeform blanks:** `Text "\n"` (pure exactness, no interpretation
  layer) vs BlankLine. *Recommended: Text — freeform is the exact mode;
  BlankLine belongs to interpreted prose.*
- **D3 — variation tolerance:** define EOF-vs-newline twin comparison as
  "identical modulo one trailing terminator on the final text event," or
  make appended-newline variations assert the appended form.
  *Recommended: the explicit tolerance, stated in the harness header.*
- **D4 — BlankLine ≡ "\n" definition** (keeps S6 intact while making the
  wire self-sufficient). *Recommended: yes — S6 survives unchanged.*

## Sequence

1. Joseph rules D1–D4 → 2. harness audit + de-compensation → 3. CORE text
→ 4. fixtures rewritten spec-first (gate red) → 5. grammar sweep to green,
both backends, differential + bench → 6. only then the `*{` rewrite,
S-batch landings, mining, tag. **Nothing tags before this.**

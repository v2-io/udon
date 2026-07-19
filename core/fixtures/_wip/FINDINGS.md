# alpha.2 EOF fixture harvest — findings & rulings needed

> **⚡ SESSION UPDATE (2026-07-19 — densification pass: 86 cases PROMOTED; this
> dir now holds ONLY the 18 genuine reds/ruling-needed).** The full 104-draft
> harvest was re-verified case-by-case against the CURRENT parser (a throwaway
> triage running each draft through the real harness `run_test`). Result:
> **82 PASS + 4 PROBE = 86 promoted → `v0.9/`**, split by source into
> `eof_delimited.yaml` (from delimited-unclosed), `eof_positional_bare.yaml`
> (from positional-and-bare-marker), `eof_composition.yaml` (from
> composition-and-edges). Backend parity was verified first-hand (recursive vs
> pushdown AGREE on every red input; `pushdown_differential` green over the new
> files). Gate + full workspace suite GREEN.
>
> **Harness fix that landed with the promotion:** `run_with_variations`
> (`tests/common/harness.rs`) skipped variations for EOF tests only when the id
> contained `"unclosed"`/`"error"` — a fragile substring proxy. Generalized to
> the semantic signal: **any case whose expected events contain an `Unclosed*`
> warning skips variations** (an appended newline would close a line-bound
> `[…]`/`<…>`/string on the newline instead of at EOF). This is what lets the
> promoted cases gate without per-case flags.
>
> **The 18 that REMAIN here are genuine grammar reds / open rulings** (verified
> 2026-07-19, both backends agree — these are the grammar-phase to-do, NOT
> fixture-bugs):
> - **Identity / reference key at EOF (11)** — `du_id_*`,
>   `eof_unclosed_identity_key_*`, `du_embed_identity_key_open_eof`,
>   `du_id_in_embedded_eof`. `UnclosedIdentityKey` never fires; the value still
>   desugars to `$key` (ruling says `$partial-key`). The hard shared-scanner
>   `parse_element_identity` gap-2 (`core/TODO-CORE-PARSING.md`). **NOTE: these
>   drafts still say `$key`; reconcile to `$partial-key` per the CHANGELOG
>   ruling before they become the accurate target spec.**
> - **`bang_brace_eof` / `bang_brace_name_eof`** — `!{`<EOF> and `!{inc`<EOF>
>   emit `DirectiveStart…DirectiveEnd` with **no** `UnclosedInlineDirective`.
>   The `|unclosed InlineDirective` mechanism fires for the *args* path
>   (`!{if x`) but NOT the no-args pre-body states (`:name`/`:after_name`) —
>   a partial-force-unwind gap worth a look, this was expected to be auto-handled.
>   (And per the ruling, nameless `!{`<EOF> should be prose `Text "!{"`, so
>   `bang_brace_eof`'s own expectation needs fixing too.)
> - **`du_interp_lone_brace_is_content_eof`** — `!{{a}`<EOF> drops the trailing
>   `}` (captures `"a"`, not `"a}"`): the partial-closer-restoration gap
>   (design-doc gap-4), known-unimplemented.
> - **`du_ic_in_text_blob_eof`** — `:note text ;{c`<EOF>: parser finishes `text`
>   as a single-token `BareValue` + a comment whose text wrongly includes the
>   `{` and lacks `UnclosedInlineComment`; the draft expects blob-treatment
>   (`Text "text "` + inline comment). Blob-vs-single-token boundary question.
> **The 3 "ruling-needed" cases are RESOLVED + PROMOTED (Joseph, 2026-07-19):**
> - `eof_empty_envelope_closed` — `<>` stays the **interim string `"<>"` +
>   `NoDialectsLoaded`** (empty→nil deferred to the dialect era); order fixed to
>   content-first → `v0.9/eof_composition.yaml`.
> - `value_escape_empty_eof` (`:a \`) and `head_escape_alone_eof` (lone `\`) —
>   ruled **empty-string value / kept empty prose, visible** (`:a \` is peer to
>   `:a ""` and `:a nil`; a trailing `\` line must survive). **The product was
>   already correct** — it emits the `Text ""`; only the fixture couldn't assert
>   it because the harness folds empty Text. Fixed at the harness: a case that
>   **asserts an empty `Text ""` is compared exactly** (no fold) and skips
>   variations (`harness.rs::asserts_empty_text` — the assertion declares its own
>   mode, `assert-text == ""` vs the default `assert-collapsed-text`). Both →
>   `v0.9/eof_positional_bare.yaml`. (Open, non-blocking: the empty node's span
>   excludes the `\` — a round-trip nicety, `core/TODO-CORE-PARSING.md`.)
>
> **Grammar-red progress (2026-07-19):** `bang_brace_name_eof` (`!{inc`<EOF>)
> **fixed + promoted** — descent generates a state's EOF handler from its
> `default` arm, and `sameline_dir_body`'s `:after_name` default was the silent
> `/skip_brace_balanced`; an explicit `|eof | Warning(UnclosedInlineDirective)`
> arm (mirroring freeform) now keeps the name and warns. Both backends;
> `→ v0.9/eof_positional_bare.yaml`.
>
> So **14 genuine grammar reds** remain here — 11 identity-key + the nameless
> `bang_brace_eof` (ruled to prose `Text "!{"`; harder — DirectiveStart already
> fired) + interp partial-closer (`du_interp_lone_brace_is_content_eof`) +
> `;{`-in-blob (`du_ic_in_text_blob_eof`). The grammar-phase to-do; nothing else.

**Status (2026-07-18):** harvest of three parallel spec-grounded agents (delimited-unclosed, positional+bare-marker, composition+edges) — **104 draft cases** in this `_wip/` dir (`delimited-unclosed.yaml`, `positional-and-bare-marker.yaml`, `composition-and-edges.yaml`). Drafts are **not verified case-by-case yet** and are **not run by the harness** (`_wip/` is a sibling of `v0.9/`). Every expectation was derived from CORE, not the parser. **Reds are finds, not failures.**

**§1 RULINGS ARE NOW MADE (2026-07-18)** — see `spec/msc/CHANGELOG.md` alpha.2 "Ruled" for every decision (line-boundedness = multi-line deliberately undefined; emission order content→warning→End; `$partial-key` for unclosed identity/ref keys; empty/whitespace-only *closed* bracket→nil / array→empty, but *unclosed* keeps whitespace verbatim; inline `!{…}`/`!{:kind:…}` → `UnclosedInlineDirective`/`UnclosedInlineRaw`; nameless `!{`<EOF>→prose; root-`:x`→undefined; EOF≡eol for the edges; interp/ref *are* valid array items). Warning-code **spellings are provisional** (CHANGELOG guardrail — descent will regenerate them).

**Finalization roadmap — LARGELY EXECUTED 2026-07-19 (see the banner above).**
The verify-and-promote steps ran: green drafts promoted to `v0.9/`, envelope
emission-order fixture-bugs corrected, the harness variation-skip generalized.
What's left is the **grammar phase** against the 18 reds still in this dir (the
banner categorizes them) — no longer "reds included in the gate": the gate is
green and the reds live here as the target spec, out of the gate, until the
grammar catches up. This doc + the CHANGELOG ledger remain the complete spec.

---

## §1 — CORE gaps/ambiguities needing Joseph's ruling (the high-value yield)

Ordered roughly by how much fixture-pinning they block. `[✓verified]` = I checked against CORE myself; `[agent]` = reported, not yet my-verified; `[conv:N]` = N of 3 agents found it independently.

1. **Quoted-string line-boundedness is unstated in CORE.** `[✓verified] [conv:1]` — CORE's "Strings" and "End of input" never say whether `"…"`/`'…'` may span a newline. Envelopes are explicitly single-line (§Explicit Typing); strings have no such sentence. The design doc (`TODO-EOF-refactor.md`) excludes strings from the line-bound set (⇒ multi-line, newline = content) and the parser agrees — but CORE.md itself is silent. **Ruling → a CORE sentence.** Blocks all `"abc⏎def` cases.

2. **No `Unclosed*` code for the inline directive / inline raw `!{…}` / `!{:kind:…}` forms.** `[✓verified] [conv:2]` — both are brace-delimited (closer `}`), so an unclosed one at EOF must warn under the two-level rule; the Warning-codes registry has all eight *other* codes but none for these. The parser currently mislabels an unclosed `!{name` as `UnclosedEmbedded`. **Correction to my brief (agent 2):** `!{` is a *delimited* opener like `|{` — a newline does **not** close it; only EOF makes it unclosed. It belongs to the delimited family, not the bare-marker→prose family. **Ruling → new code(s) + registry entry + CORE text.** Also open: is a *nameless* `!{`<EOF> a legal directive (block directives require a name) or should it fall to prose `Text "!{"`?

3. **`UnclosedIdentityKey` wire shape is unspecified.** `[agent] [conv:2]` — CORE lists the code (I added it) but not the events: on `|el[k`<EOF>, is a partial `Attr "$key"` + value emitted alongside the warning? On `|el[`<EOF> (nothing captured), an empty `$key` or none? Ordering? Greenfield — parser emits no identity warning today, in any phase. **Ruling → the emission shape.** Blocks all identity-`[` cases.

4. **Intra-construct warning/content *order* is not uniform, and one fixture is self-contradictory.** `[agent]` — string/array/embed/interp/inline-comment/freeform emit **content-then-warning**; the `<…>` envelope emits **warning-then-content**. CORE states no convention. Worse: `v0.9/eof_recovery.yaml::eof_unclosed_envelope`'s comment claims "content first" while its events encode warning-first. **Ruling → a content/warning order convention** (then fix that fixture's comment or events to match).

5. **Empty value-position `\` at EOF.** `[agent] [conv:2]` — `:k \`<EOF>: value-position `\` "enters text mode" (⇒ a value *was* supplied, empty `Text ""`) vs "plain attributes always take a value" (⇒ `MissingAttributeValue`?). The empty `Text ""` folds away on the wire, leaving an `Attr` with no value event — under-determined. **Ruling.**

6. **Root-level `:x`<EOF> (attribute with no element).** `[agent]` — emits a free-floating `Attr "x" / MissingAttributeValue / Nil` with no owning `ElementStart`; CORE never defines a root-initial `:key`. Note the asymmetry the parser already has: `:`<EOF> (no name) → prose, but `:x`<EOF> → root attribute. **Ruling.**

7. **`;`<EOF> vs `;\n` — empty positional tail / newline-equivalence.** `[agent]` — `;`<EOF> emits no empty `Text`, but `;\n` emits `Text ""`; that breaks EOF≡newline. Is this a parser bug (should match) or does CORE want empty tails to emit nothing? **Ruling or bug-confirm.**

8. **Interpolation / reference as an array item.** `[agent] [conv:2]` — "Inline Lists" enumerates item kinds as "numbers, quoted strings, `<…>` envelopes, nested lists," omitting interpolation/refs, but the parser accepts `[!{{x`. **Already a known silence in `spec/TODO-SPEC-CORE.md`** — this confirms it needs the enumeration-vs-uniform-rule ruling.

9. **Spaces-only final line.** `[agent]` — behaves three ways: dropped silently (structural, current parser), `BlankLine` (truly empty line), exact `Text` (inside a fence). CORE gives no rule for the structural case. **Already a known silence in `spec/TODO-SPEC-CORE.md`.**

10. **Minor:** trailing sameline spaces trim-vs-keep is unspecified `[agent]`; nested `<…>` is "deliberately under-specified" in CORE (parser's single-balanced-span reading works but isn't ratified) `[agent, CORE admits]`.

---

## §2 — Confirmed parser bugs (RED = real finds; fixed in the later grammar/descent phase)

- **Embed drops `UnclosedEmbedded` when its content-so-far is empty OR it ends on an attr/value rather than prose.** `[conv:3]` — refines the "any-phase EOF-drop" already in `TODO-EOF-refactor.md`. Surfaced across bare-opener / identity / attr / four value-kinds / empty / 3-deep-nested cases.
- **Identity `[…]` never warns** in any phase. `[conv:2]`
- **Bare marker as final byte dropped** — `|`/`@`/`!`/`:`<EOF> → 0 events (or a whole element vanishes); each has a green `\n`-terminated twin proving the correct output. `[agent 2]`
- **Interpolation drops a lone trailing `}`** — `!{{a}`<EOF> captures `"a"`, not `"a}"` (content loss vs keep-everything). CORE is clear here → parser bug, not ambiguity. `[agent 1]`
- **Unclosed `!{…}` directive/raw** drops/mislabels its warning (tied to §1.2).

---

## §3 — Existing `v0.9/` fixtures to correct (ruling-free; apply in finalization)

- **`error_cases.yaml` header (~L6-9)** — STALE: claims unclosed embedded/inline-comment "not encoded yet — no CORE text and no settled code." Both now exist (End-of-input + Warning-codes registry) and are encoded in `eof_recovery.yaml`. Remove/update. `[conv:3]`
- **"error" → "Warning" naming drift** (event is already correct; ids/descs are stale under two-level severity): `arrays.yaml::array_unclosed_is_error`; `error_cases.yaml::{unclosed_double_quote_error, unclosed_single_quote_error, unclosed_interpolation_error}`. `[conv:3]`
- **`error_cases.yaml::unclosed_*_error` missing `root_only: true`** — they're truncated inputs, so the harness's variation-wrap appends content past the truncation and changes behavior (`eof_recovery.yaml` sets `root_only` for exactly this). `[agent 3]` Also: they duplicate `eof_recovery.yaml` coverage — consider consolidating.
- **`eof_recovery.yaml::eof_unclosed_envelope`** — comment says "content first," events are warning-first (see §1.4). Fix once §1.4 is ruled.
- **Stale `⚠` notes in `eof_recovery.yaml`** — the "CORE silent on multiplicity" notes are resolved by the design of record; the note claiming `arrays.yaml::array_unclosed_is_error` omits `ArrayEnd` is false (they agree). Remove/update. `[conv:2]`
- **Dedup:** `_wip/delimited-unclosed.yaml::du_embed_attr_open_missing_value_eof` ≈ existing `eof_unclosed_embedded_with_open_attr` — keep one.

---

## §4 — Infrastructure gap (structural)

**The two-level severity *document result* is untestable in the event-fixture format.** `[agent 1]` The per-document "incomplete-input" result is explicitly not a wire event, and a line-bound construct closed on an *interior* newline is **wire-identical** to its at-EOF twin, yet the two differ in the document result (SUCCESS vs non-success — the distinction CORE says "earns its keep"). Enforcing it needs either a fixture field like `result: incomplete`, or a test at the AST/driver layer (this is consistent with the earlier framing: the document result belongs to `TODO-PARSER`, not the event fixtures). Decide where it lives.

Harness note to remember when finalizing: empty `Text ""` is dropped (blank lines are `BlankLine`), but empty `Interpolation ""` is **not** dropped — so `!{{`<EOF> keeps `[Interpolation, ""]` on the wire.

---

## §5 — Finalization plan (after §1 rulings)

1. Rule §1 (or defer specific ones — mark those fixtures "pending ruling").
2. Verify each `_wip/` case against CORE; correct agent errors (a red must be a real gap, not a fixture bug).
3. Apply §3 corrections to the live `v0.9/` fixtures.
4. Promote verified cases into `v0.9/` (merged into the right topical files, deduped). Reds stay — they're the spec of what the grammar/descent phase must then implement.
5. Decide §4 (result-field vs AST-layer).
6. Re-run the gate; the reds are now the to-do list for the grammar/descent work.

# Changelog — UDON core spec (`CORE.md`)

All notable changes to the **UDON core specification** are recorded here. This
versions the *contract*, not the code: implementations declare which spec version
they pass (see `../CLAUDE.md` → Tracking & Workflow). Each released version has a
frozen **compliance-fixture group**; an implementation is "compliant with vX.Y.Z"
iff it passes that group.

The **operable source of truth** for the current version is
[`CORE-VERSION`](CORE-VERSION) (one line, machine-readable) — the `CORE.md`
header, this changelog's top entry, `udon-core`'s `CORE_COMPLIANCE` marker, the
compliance gate, and the `core-vX.Y.Z` git tag all derive from or are checked
against it (a CI drift-check enforces agreement — to be wired).

Format: [Keep a Changelog]. Versioning: [Semantic Versioning] (pre-1.0, so minor
bumps may break).

## [0.9.0-alpha.2] — 2026-07-18 (in progress)

**EOF handling recast as positional / delimited, plus a two-level severity
model.** Rulings ratified in conversation (Joseph, 2026-07-17/18); design of
record: [`../../_archive/TODO-EOF-refactor.md`](../../_archive/TODO-EOF-refactor.md)
(archived 2026-07-19). The CORE-text
rewrite of "End of input" (+ Anomaly posture + Warning codes) is **pending** —
this entry records the ratified rulings; `../TODO-SPEC-CORE.md` tracks the CORE
edits.

### Ruled (2026-07-17/18; do not re-open)

> **Names are provisional.** The *decisions* below are ruled; the exact code /
> attribute **spellings** (`Unclosed*`, `UnclosedInlineDirective`,
> `UnclosedInlineRaw`, `$partial-key`, …) are hand-picked working names,
> pre-defined only because descent cannot yet auto-derive `Unclosed<Construct>`
> from the grammar. Expect an upcoming subversion to regenerate them into
> descent-appropriate forms — implement toward them, but do not cement the
> spellings as contract.

- **Positional vs delimited.** Every construct closes either **positionally**
  (extent by geometry — EOL / dedent / EOF) or **delimited** (a printed
  end-sequence the grammar matches). At EOF, positional constructs finish by
  ordinary end rules (silent); a still-open **delimited** construct is the only
  "unexpected EOF" — content kept + `Unclosed*` citing its entry site + End.
  Composition is innermost-first (the frame stack). Semantics (needs-a-value,
  cardinality, schema) are *not* this mechanism — they are close-time checks by
  whoever owns the construct.
- **Two-level severity.** Warning = content kept; Error = something lost. So
  every per-construct `Unclosed*` is a **Warning** (keep-everything), retiring
  the old per-construct Error/Warning split. Separately, a delimited frame open
  at *true* EOF means the input is not a whole document → the parse **result**
  turns non-success (non-zero exit): a result, not a wire event. Line-bound
  failures mid-document (array/envelope on a newline) are warnings only, zero
  exit.
- **Consequences.** Unclosed identity `[` at EOF → delimited anomaly (was
  silent); a bare marker as the final byte → positional (EOF ≡ newline → prose),
  not unexpected EOF; an embed open in any phase at EOF → delimited (fixes the
  any-phase drop).
- **Line-boundedness** (2026-07-18). Embedded `|{…}`, freeform ` ``` `, and — by
  a later same-day ruling — the `<…>` typing envelope are locked **multi-line**:
  the envelope spans newlines, closing only on `>` or EOF (it was extracted into
  its own `/envelope` delimited function, content-first, retiring the earlier
  single-line rule — the parser now takes everything after `<` up to `>` or EOF).
  Every **remaining** delimited construct (`"…"`/`'…'`, `[…]` array & identity
  key, `!{{…}}`, `;{…}`, `!{…}`/`!{:kind:…}`) is **single-line for now, multi-line
  deliberately undefined** — not yet verified safe across a newline (current
  parser behavior varies — strings/interpolation span, arrays and identity keys
  warn on the newline — and is not guaranteed). A future version may define
  multi-line or warn; multi-line meanwhile is at author's risk. (Resolves the
  string-line-boundedness gap surfaced by the alpha.2 fixture harvest.)
- **Unclosed emission order** (2026-07-18). An unclosed delimited construct
  emits its kept **content first, then the `Unclosed*` warning, then any `End`**
  (`…content… → Unclosed* → End`), uniform across the family — matching what
  multi-line embed/freeform already do. The AST builder is order-agnostic
  (no-ops on warnings, `tree.rs`), so nothing downstream depends on it. 6 of 7
  constructs already comply; `<…>` (warning-first today) is the lone outlier to
  reorder in the grammar phase.
- **Unclosed identity/reference key → `$partial-key`** (§1.3, 2026-07-18). An
  **unclosed** identity or reference key emits its partial content under
  **`$partial-key`**, not `$key`, then `UnclosedIdentityKey`, then `End` — e.g.
  `|el[k`<EOF> → `[Attr,$partial-key],[BareValue,k],[Warning,UnclosedIdentityKey],
  ElementEnd`. A distinct name (not a flag on `$key`) because it must **fail
  safe**: a consumer reading `$key` / resolving a reference automatically
  excludes it (the partial value is still kept), whereas an ignored flag would
  treat the incomplete key as real — dangerous, especially for references.
  Compatible with the content→warning order (it's a content-marking).
- **Empty / whitespace-only brackets & envelopes → empty value** (2026-07-18;
  behavior-level, may stay out of CORE prose). A **closed** bracket/envelope
  whose content is only **single-line** whitespace (spaces, tabs) is empty,
  shaped by the slot: single-value slots — identity key `|el[ ]`, reference key
  `@[ ]`, envelope `< >` — → **nil** (not a whitespace string); an **array**
  `[ ]` → **empty array** (0 items, not `[nil]`). Resolves the open `|el[]`
  question (nil-valued key, not empty-list value). The collapse to empty needs a **proper close** — an
  **unclosed** whitespace bracket/envelope keeps its whitespace **verbatim**
  (content-so-far) + its `Unclosed*`, unifying with keep-everything and
  `$partial-key`'s partial value (§1.3 / §1.10). **Multi-line** whitespace
  (with newlines, `<  ⏎  >`) stays in the deliberately-undefined multi-line
  space — the envelope's current `UnclosedTypeEnvelope` warning is fine.
  *Grammar hint (Joseph):* if implementing multi-line finds it simpler to drop
  the envelope's single-line warning and treat it like the other
  multi-line-tolerating constructs (with whitespace pre-trimming), that's
  welcome — a convenience, not a spec requirement.
- **Unclosed inline `!{…}` directive / `!{:kind:…}` raw → two new codes** (§1.2,
  2026-07-18; executor's call, per Joseph). Parallel to `UnclosedInterpolation`
  (the third `!{`-family member): unclosed inline directive `!{name …}` →
  **`UnclosedInlineDirective`**; unclosed inline raw `!{:kind: …}` →
  **`UnclosedInlineRaw`**. The "Inline" prefix disambiguates from the *block*
  `!name` / `!:lang:` forms (positional — never "unclosed"). Content→warning,
  keep-everything: the raw body must survive (the current silent-drop of raw
  content, and the directive's content-doubling + off-registry `Error
  "UnclosedText"`, are grammar-phase **bugs** the fixtures pin against). A
  **nameless** `!{`<EOF> (nothing after `!{`) → **prose `Text "!{"`** — no valid
  directive ever started, parallel to the bare-marker family (Joseph agreed).
- **Root-level attribute → undefined** (§1.6, 2026-07-18). A line-initial `:key`
  at the document root (no owning element) is **undefined** in this version —
  the parser emits a free-floating `Attr`, but don't rely on it. Marked
  undefined in CORE (Attributes).
- **Remaining EOF edges → governed by EOF ≡ eol + full-dedent** (§1.5 / §1.7 /
  §1.9 etc., 2026-07-18; Joseph). No separate rulings: the EOF case behaves
  exactly as the equivalent end-of-line + full-dedent case — empty value-`\` at
  EOF = its eol case; `;`<EOF> must equal `;\n`; a spaces-only final line = a
  mid-document spaces-only line + eol. Where the parser diverges today (e.g.
  `;`<EOF> ≠ `;\n`) that's a **red-find**, not a new rule. (The spaces-only-line
  *content* question — `BlankLine` vs `Text` — is a separate standing silence in
  `TODO-SPEC-CORE.md`, orthogonal to the EOF aspect.)
- **Interpolation / reference as array items → yes** (§1.8, 2026-07-18; Joseph
  agreed). Array items follow the uniform value rules (Value Kinds; Explicit
  Typing's "array items alike"), so interpolation `!{{…}}` and references `@…`
  are valid items — the "Inline Lists" enumeration (numbers/strings/envelopes/
  nested lists) is illustrative, not exhaustive.

### Ruled (2026-07-19, third batch — the TEXT-WIRE recast, P0; do not re-open)

- **Final-terminator disposition — RULED via three examples (Joseph,
  principle of least surprise).** Interior newlines within a text run are
  TEXT (a forced-text line followed by more text keeps its newline). A text
  run's FINAL terminator: when it rides INSIDE the run's last content-bearing
  Text (…`\ tail`⏎ then a child/structure line) it is ORNAMENTAL — the AST
  trims it; when the author puts `\` at the very END of the line (empty
  forced tail → the standalone `Text "\n"` event) it is EXPLICIT — kept
  ("the only reason I'd put the backslash at the end like that is because I
  *do* want the explicit newline"). The wire distinguishes the two for free
  (in-content trailing `\n` vs standalone `Text "\n"`), so this is purely
  an AST policy — no wire change. CORE landing: state it with Joseph's three
  worked examples (TODO-SPEC-CORE S-batch item); AST landing: TODO-PARSER
  S6 item.

**The reconstruction contract** (design of record: `../TODO-TEXT-WIRE.md`):
the document's text stream is reconstructable by pure in-order concatenation
of the event stream's text-bearing events — no spans, no source. Line
terminators within text are TEXT and ride the wire; indentation/markers/
consumed escapes/pure-structure-line terminators are GEOMETRY (spans only);
comment content never carries its enclosing line's terminator. The spec
carries ZERO fixture/harness content — only split-freedom ("a Text event is
never guaranteed complete") + this contract.

- **D1 — ruled yes**: when an annotation or inline form owns a text line's
  end, the terminator rides a trailing terminator-only `Text "\n"` after it
  (byte-honest, source order; comment-stripping keeps line boundaries).
- **D2 — ruled Text**: freeform blank lines are `Text "\n"` (freeform is the
  exact mode; BlankLine belongs to interpreted prose).
- **D3 — ruled explicit tolerance**: the EOF-vs-newline twin comparison
  suppresses the captured newline that is really an EOF stand-in — the
  varied twin's final text event compares modulo the appended terminator.
  (Harness convention — lives in fixtures/README, not CORE.)
- **D4 — ruled yes** (Joseph: the S6 discussion assumed newlines were being
  preserved): `BlankLine` is defined as contributing `"\n"` to
  reconstruction — a labeled newline-only line; the S6 AST policy
  (interior → newline, edges → ornamentation) stands unchanged.

### Landed — the text-wire recast (2026-07-19, same day it was found)
The third-batch contract is **implemented end to end** (grammar both
backends, harness, all 25 fixture files re-derived spec-first, AST): Text /
RawContent events carry their line terminators; reconstruction is pure
in-order concatenation (`BlankLine` ≡ `"\n"`); the harness fold is
content-derived (the source-consulting span-gap fold — the compensator that
had masked the defect — is deleted, audit archived at
`../../_archive/HARNESS-AUDIT-2026-07.md`); the AST's fabricated-space
joiner is deleted and `BlankLine` is a tree node. Gate green (variations
included), differential green, bench **+5–8% improved**. Design of record:
[`../TODO-TEXT-WIRE.md`](../TODO-TEXT-WIRE.md). CORE-text example polish +
the S-batch landings remain (`../TODO-SPEC-CORE.md`).

### Ruled (2026-07-19, second batch — the standing-silences clearout; do not re-open)
- **S1 — element suffixes stack**: `|field?!` ≡ `|field :'$?' true :'$!' true`
  (desugaring implies it; today a second suffix half-parses to prose — grammar
  + fixtures to land).
- **S3 — unclosed identity at EOF**: confirmed settled by the `$partial-key`
  mechanism (landed same day).
- **S4 — empty embedded `|{}`**: a valid, empty anonymous embedded ELEMENT
  (EmbeddedStart/End bracket an element node); bless current behavior with a
  CORE sentence + fixture.
- **S5 — interpolation as a whole element key**: `|div[!{{id}}]` →
  `Attr "$key"` + Interpolation (host evaluates); pin with a CORE sentence +
  fixture. (Mixed key text rides the multi-part rule the `*{` ruling settled.)
- **S6 — blank/whitespace-only lines, the two-layer model** (Joseph): at the
  EVENT level, any blank line whose whitespace does NOT protrude past the
  prose content-base emits `BlankLine` (span covering the whitespace —
  round-trip safe); whitespace protruding PAST the base is prose content with
  the extra whitespace preserved (existing dedentation rule); a `\` at head
  position on an otherwise-blank line forces a kept empty Text line. The
  INTERPRETATION is the AST builder's: interior BlankLines between text →
  newlines; leading/trailing → **ornamentation** (UDON-level decoration, not
  text content) — or literal BlankLine nodes for reversibility. Vocabulary:
  *ornamentation* vs *text-literal*. No event-parser lookahead needed — the
  trailing-blank ambiguity resolves at the AST layer.
- **C2 — annotation layer**: option (a), a named-element convention
  (`|{note :confidence 0.7 …}`, schema-owned vocabulary, strippable); richer
  syntax deferred to 0.10 with paths/dialects/schema.
- **Tag gating** (process, not spec): `core-v0.9.0` waits for the final
  legacy-mining pass + densification attempts + the `*{` boundary rewrite.
- **S2 — line-boundedness for 0.9**: current per-construct behavior is
  ratified as "close enough to undefined-but-we'll-warn-before-disallowing"
  — strings/interp span, arrays/identity keys close-with-warning on the
  newline; multi-line design proper is 0.10 (with paths/dialects; the
  emergent-span finding means container and contents decide together).
  Fixtures pinning this space MAY gate but must be framed DESCRIPTIVELY
  ("PINS CURRENT BEHAVIOR", never prescriptive) so purposefully-unspecified
  behavior cannot calcify — the label is what licenses a future flip
  without a compliance break (convention: core/fixtures/README.md).
- **S6 wire precision** (fact-checked against grammar + probes): prose Text
  events are LINE-scoped and never contain their own terminator (spans
  disambiguate same-line fragment splits from line boundaries; hosts join
  by span); delimited captures carry interior newlines explicitly. A
  boundary-`\` with an empty tail (`|el :one hey \` + child line) is wire
  `Text ""` — an empty prose line — interpreted by the S6 AST policy
  (edge → ornamentation, interior → newline), NOT a special `Text("\n")`.

### Ruled (2026-07-19; densification pass — do not re-open)
- **`;{` in value position / at a bare-token boundary → text-blob
  continuation, never a boundary marker** (Joseph, 2026-07-19). The framed
  ` ; ` remains the sameline comment that ENDS value capture; the `;{…}`
  inline comment is part of the flowing text and **reduces to `""`**
  (comment events are not value segments). Consequences, from Joseph's
  examples: `|el :n ;{}` ≡ `|el :n ""` (an empty-string value, not
  `MissingAttributeValue`); `|el :n ;{`<EOF> → same + `UnclosedInlineComment`;
  `|el :n value ;{`<EOF> → `n = "value "` (trailing space kept — the blob
  committed at the `;{`) + the warning; `|el :n val ;` → `"val"` + an empty
  comment (framed form, unchanged). Underlying principle as stated: inline
  `*{…}` constructs "are assumed to *reduce to more text*." This confirms the
  blob-treatment expectation of the `du_ic_in_text_blob_eof` red (now a plain
  grammar to-do, not spec-ambiguous).
- **The general `*{` principle — CONFIRMED** (Joseph, 2026-07-19, after the
  consistency check): **no inline brace form (`|{…}`, `!{…}`, `;{…}`) is ever
  a boundary marker or a mode exit** — encountered at a bare-token boundary
  or in value-expected position, it commits/continues **text mode**, firing
  within the blob as a segment (or, for `;{…}`, reducing to `""`). The
  boundary-marker set becomes **block-form markers only** (`|name`-form `|`,
  guarded `@`, block `!name`/`!:…:`, `:key`, framed ` ; `, fence, `\`).
  Consequences ratified with it: `|el :n |{em x} :a 1` ≡ `|el :n \|{em x}
  :a 1` in ownership (all of it is `n`'s blob — `:a 1` included) **except**
  the framed ` ; ` sameline comment stays active in a brace-committed blob
  (it is an ordinary prose-shaped blob), unlike `\`-forced text which gives
  the comment affordance up. `:n |{em x}` flips from *node value* to *blob
  segment*; sameline node values remain block-form (`:headers |header …`
  unchanged). This also settles the C1 multi-part-interpolation wire by
  construction: `pre!{{x}}post` is a blob — re-emitted `Attr` segments
  Text/Interpolation/Text — and whole-value `!{{x}}` is its one-segment
  degenerate (wire-compatible with today's `Attr`/`Interpolation`).
  CORE-text edits: `spec/TODO-SPEC-CORE.md`; grammar + fixture flips:
  `core/TODO-CORE-PARSING.md`.
- **Empty envelope `<>` → interim string, for now.** A closed empty `<>` stays
  the no-dialects pass-through `BareValue "<>"` + `NoDialectsLoaded` (content-first,
  uniform with every envelope). The empty-bracket ruling's `< >`→**nil** collapse
  is a **dialect-era** refinement, deferred until the dialect layer lands — it
  does not fire in the no-dialects interim. (Joseph: "current behavior is fine for
  now due to no dialects.")
- **Empty forced-text is a real, kept value — `:a \` ≡ an empty string.** A
  value-position `\` with an empty tail is an **empty-string value, no warning,
  not `MissingAttributeValue`** — a user's deliberate empty value, peer to `:a ""`
  and `:a nil`. A lone head-position `\` at EOF likewise forces an **empty prose
  tail that must survive** (folding it would lose the final line). The parser
  already emits the (empty) `Text` event a real consumer receives; the wire is
  correct. *(Open, non-blocking: the empty node's span excludes the consumed `\`,
  so it isn't yet byte-round-trippable — `core/TODO-CORE-PARSING.md`.)* Fixture
  note: empty `Text` is folded by the compliance harness for rhythm-independence,
  so a case pinning it asserts `Text ""` explicitly to opt into exact comparison
  (`asserts_empty_text`) — a *test-harness* convention, orthogonal to product
  behavior (real API consumers never fold).

### Landed — EOF generation (2026-07-18 spike; out of fixtures-first order, per Joseph)
descent now **auto-supplies** the EOF handling the rulings above describe:
delimited constructs **force-unwind** (keep content + `Warning(Unclosed<Construct>)`
+ End) and positional constructs finish on **EOF ≡ newline** — both from a
positional/delimited classification descent computes (`descent-rs classify`).
This begins realizing the provisional-names guardrail's promise (auto-derived
`Unclosed<Construct>` instead of hand-picked): **`UnterminatedFreeform` →
`UnclosedFreeform`** normalized (registry updated; fixtures upgraded after
verifying the change was code-name-only). Fixed live: embed any-phase-drop,
number-state and bare-marker EOF drops. ~34 hand `|eof` arms deleted; gate 2→1;
benchmark flat. Still hand-picked pending the `|unclosed <Name>` directive: the
inline `!{…}`/`!{:kind:…}` codes (currently mis-derived) and the callee-scanned
constructs (`../../core/TODO-CORE-PARSING.md`, `../../tools/descent/TODO-DESCENT.md`).
Design record: `../../_archive/eof-descent-classification.md` (archived 2026-07-19).

## [0.9.0-alpha.1] — 2026-07-15

First alpha of the **attribute-model reconception** — the headline change
0.8.0 explicitly left unsettled. Ratification carriers:
`design/attribute-model-proposal-3-substrate.md` (decided model floor) +
`design/attribute-model-proposal-3.md` (binding narrative); promotion
nail-downs were tracked in the 0.9 supplement (drained 2026-07-16 into the
"Ruled" section below + `TODO-SPEC-CORE.md`; archived at
`_archive/TODO-SPEC-CORE-0.9-supplement.md`). The active
compliance-fixture group is now `core/fixtures/v0.9/` (seeded from the
frozen v0.8 group; cases will be edited to the new model as CORE text
lands — a RED gate during the burn-down is the honest signal).

### Ruled — the attribute-model nail-downs (2026-07-15/16; all in CORE with dates inline — do not re-open)

This block preserves the supplement's anti-re-open ledger. **2026-07-15
(Joseph):** bare-token boundary rule (provisionally-open scan at a bare
token's boundary; marker → single-token value, text → blob to ownership); no
keyword carve-out (`:alpha true story` → `"true story"`); `@` guard + `.`
and `@` equal-footing with `|` in the sameline scan; embedded framed ` ; `
out for now (bare `;` literal; revisit with dialects); `\`-forced text =
line-verbatim but inline forms fire, framed ` ; ` literal; spaced-trait form
dropped (identity contiguous except trailing spaced suffix); sameline tail
enters children phase; anomaly-posture ladder (warn-and-keep wherever
coherent; errors non-halting; drop/halt/reject = AST/app config).
**2026-07-16 (Joseph, R1–R5 confirmed):** R2 embedded = element-rooted
sameline (+`}`), with the `\`-boundary content idiom and
unspecified-in-0.9 framed-`;`-after-`\`; `MissingAttributeValue` = error
event **+ synthesized `Nil`** (the stream never carries less shape than the
source suggested); R3 ownership never changes at a `\` (two values on one
attribute always warn and stack — never error, never drop); R4 flag
semantics follow the NAME (quoted ≡ bare; `$?` aligns by construction); R5
flat stacking wire (every `Attr` carries one value; all multiplicity =
re-emitted `Attr`; no AttrStart/AttrEnd; only literal `[…]` arrays on the
wire). **2026-07-16 (delegated, per-item calls recorded in CORE):** EOF =
universal implicit closer with per-construct `Unclosed*` table; flag +
deeper block = `AttributeSecondValue` warn+stack; mid-token typed-path
failure = ordinary bare token; raw block usable as node value sameline;
`<…>` envelopes single-line (`UnclosedTypeEnvelope` warn + string
pass-through); interpolation ends at first `}}`; tabs illegal in
indentation only; `AttributeUnderAttribute` recovery = open attr gets its
`Nil`, error explains, offending line's bytes kept as element prose
(fixture-pinned); plus the editorial batch (warning-table rewording,
wire-vs-view round-trip caution, node-value one-way-door caution,
prose-base cross-ref, Document-layer mini-definition, `\` in the head row,
Positional-Contexts examples out of table cells).

### Added (2026-07-16, Joseph — ruled a plain bug on both sides)
- **Raw blocks: same-line body** — `!:lang: tail` captures the tail as the
  body's first content (whitespace after the label's closing `:` separates;
  the tail does not establish the raw base — same shape as fences and
  sameline prose; uniform in node-value position). CORE had been silent and
  the reference parser silently dropped the tail bytes — the keep-everything
  posture's one known violation, found live in a consumer document by the
  2026-07-16 differential re-scan.

### Changed (ratified direction 2026-07-15; CORE text drafted same day; the
inline R1–R5 draft flags were confirmed 2026-07-16 — see Ruled above)
- **Plain attributes always take a value**; missing value with no deferred
  body is an error. Implicit valueless-`:key` = true is removed.
- **Flags are spelled `:key?`** (terminal `?`; wire name keeps the `?`).
- **Attribute values may be nodes, text blobs, or segment arrays** —
  edges may terminate at nodes; "attributes are typed scalars" is retired.
- **Uniform scan replaces block run-to-EOL** (`:a 1 :b 2` on a block line
  is two attributes).
- **Bare-token boundary rule**: the sameline scan stays provisionally open
  at a bare value token's boundary — a head-position marker (`:`, `\`,
  guarded `|`, framed ` ; `, fence) means the token finished as a
  single-token value; plain text commits the rest of the line as a text
  blob owned by binding priority (open attr first).
- **Finished value + trailing material** on a block line: strong warning +
  ingest as segment array (never silent drop).

### Changed (2026-07-15 fresh-eyes review pass — rulings by Joseph)
- **`@` guard extended to `.`** (`@.trait-only` now parses) and `@` given
  equal footing with `|` in the sameline scan — a reference can be an
  attribute's value, a boundary-following sibling, or a block-line child.
- **`|` guard corrected** to include the suffix characters (`|?` parses, as
  Anonymous Elements always claimed).
- **Spaced-trait identity form dropped**: identity is contiguous except the
  trailing space-separated suffix; `.trait` after a space is prose.
- **`\`-forced text posture unified** (head- and value-position): dead to
  line-level structure and to the sameline-comment frame, alive to inline
  forms (`|{…}` etc., individually escapable).
- **Embedded `|{…}` framed ` ; ` comments ruled out for now** (bare `;`
  literal, `;{…}` only) — revisit when dialects/embedded work matures.
- **Anomaly posture made explicit**: warn-and-keep wherever coherent; errors
  are non-halting events; drop/halt/reject is AST/app-layer configuration.
- Stale 0.8 remnants fixed: raw-as-attribute-value prohibition (now a node
  value), block-prose `;` summary rows, garbled Bracket Mode example,
  past-base-`\` test-case note, Type Table pointed at Value Kinds.

## [0.8.0] — 2026-07-15

**Final.** The reference parser (`udon-core`) passes the frozen v0.8
compliance-fixture group (`core/fixtures/v0.8/`, ~233 cases) — the ladder's
finalization gate. The `-beta`/`-rc` rungs were skipped deliberately: the
contract froze and a parser passed in the same cycle, so the intermediate
maturity labels had no interval to describe. Known-and-declared limits ship
as part of the contract: "Complex Attribute Values" (structured attribute
event shape) is explicitly unsettled in this version — its reconception is
the headline of 0.9. Two authoring residuals (mining `legacy-pre-0.8/` for
regression cases; densifying edge coverage) roll forward into the v0.9
group's work rather than blocking this tag. Tag: `core-v0.8.0`.

### Added
- **`<…>` interim behavior** (2026-07-15): until the dialect layer exists, a
  conformant parser recognizes the envelope (`<>`-balanced, value-terminating)
  but emits a Warning that no dialects are loaded and passes the value through
  as the plain string `"<…>"` — nothing lost, nothing silently retyped.

### Changed
- **Stranded second-attr in block values** (2026-07-15): the value is still
  taken to end-of-line (one attribute per block line); an event-level Warning
  is no longer required — hosts may advise. Aligns with the warning-code
  posture (emission is host-side) and anticipates the attribute-model
  reconception.
- **Warning codes** (2026-07-15): Warning event payload is a PascalCase code
  (`InconsistentIndentation`, `NoDialectsLoaded`, …), not a ratified prose
  string; emission circumstances are host-side. Table in CORE parser-behavior
  notes.
- **References as selector tuples** (2026-07-15): semantic model
  `(element, key, traits)` in CORE; traits are selection criteria. Interim
  wire remains a single `Reference` with raw text after `@` until structured
  encoding lands.
- **Several 0.8 silences pinned in CORE** (2026-07-15): Text granularity;
  past-base `\` AST-only; `<…>` in array items; raw-block first-content-line
  dedent; multiline embedded per-line Text; prose between embedded siblings;
  inline-raw Raw+sep-space. *(Structured-attribute event shape intentionally
  not pinned — open on `design/attribute-model-2026-07.md`.)*

## [0.8.0-alpha.1] — 2026-07-14

First **alpha** of the rebooted spec (descent-rewrite era). Ratified in this
form but still evolving — `-alpha` promotes to `-beta` when feature-complete,
`-rc` when frozen for validation, and `0.8.0` final when a parser passes the
compliance group. **No implementation is compliant yet** — the
descent grammar and generated parser are still on the pre-reboot model, so the
compliance gate is RED *by construction* until they catch up. `0.8.0` is
finalized once a parser passes the 0.8.0 compliance-fixture group.

> *Draft — verify this change list against `CORE.md` and git history before the
> version is frozen.*

### Changed (from 0.7-draft)
- **Escaping unified** to one positional rule: a `\` at head position forces the
  line to prose (consumed; anchors indent); in prose flow a `\` before an inline
  opener `|{` / `!{` / `;{` makes it literal; anywhere else `\` is literal.
  Retires the old `'`-escape and the per-context `\;` mechanism.
- **Identity model**: `[key]` desugars to `$key`, `.trait` to `$traits` (with an
  always-a-list `traits` view); `id`/`class` retired as wire-names.
- **Explicit typing `<…>`**: every non-core (dialect) type — *including all
  temporal* — requires the envelope; a bare `2026-07-11` is now the string. The
  envelope is `<>`-balanced for nesting.
- **Numbers**: bare recognition frozen to **integer + float** only (four bases,
  incl. explicit-decimal `0d`); **rational and complex marked provisional**
  (candidates for a standard-types dialect).
- **References `@` are inert** at the core level; the `:[id]` attribute-merge
  syntax **removed** (merge is now a host resolution mode).
- Freeform fences open at **any** head position; **attribute stacking** is the
  uniform rule; bare-name char class fixed to Unicode `XID_Start` /
  `XID_Continue` + `-`.

### Notes
- The spec is *ahead of the parser*; the pre-reboot 0.7-draft parser/grammar and
  its fixtures do not comply and are being rebuilt to this version.

## Pre-history (informal, pre-SemVer)
- **0.7-draft** (Dec 2025) and earlier — the ruby-gem-era spec, before the
  descent rewrite. Legacy lineage, no conformance contract.
- Tags: `pre-umbrella-2026-07` (last pre-reboot commit) · `v0.8.0-reboot` (the
  2026-07-09 umbrella restructure).

[Keep a Changelog]: https://keepachangelog.com/en/1.1.0/
[Semantic Versioning]: https://semver.org/spec/v2.0.0.html

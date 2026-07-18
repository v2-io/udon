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
record: [`../TODO-EOF-refactor.md`](../TODO-EOF-refactor.md). The CORE-text
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
- **Line-boundedness** (2026-07-18). Embedded `|{…}` and freeform ` ``` ` are
  locked **multi-line**; every other delimited construct (`<…>`, `"…"`/`'…'`,
  `[…]` array & identity key, `!{{…}}`, `;{…}`, `!{…}`/`!{:kind:…}`) is
  **single-line for now, multi-line deliberately undefined** — not yet verified
  safe across a newline (current parser behavior at a newline varies — some warn
  like `<…>`, some tolerate — and is not guaranteed). A future version may
  define multi-line or warn; multi-line meanwhile is at author's risk.
  (Resolves the string-line-boundedness gap surfaced by the alpha.2 fixture
  harvest.)
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
  question (nil-valued key, not empty-list value). **Multi-line** whitespace
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

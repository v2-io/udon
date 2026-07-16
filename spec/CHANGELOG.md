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

## [0.9.0-alpha.1] — 2026-07-15 (in progress)

First alpha of the **attribute-model reconception** — the headline change
0.8.0 explicitly left unsettled. Ratification carriers:
`design/attribute-model-proposal-3-substrate.md` (decided model floor) +
`design/attribute-model-proposal-3.md` (binding narrative); promotion
nail-downs in `TODO-SPEC-CORE-0.9-supplement.md`. The active
compliance-fixture group is now `core/fixtures/v0.9/` (seeded from the
frozen v0.8 group; cases will be edited to the new model as CORE text
lands — a RED gate during the burn-down is the honest signal).

### Changed (ratified direction 2026-07-15; CORE text drafted same day — five
draft rulings R1–R5 flagged inline pending confirmation, see
`TODO-SPEC-CORE-0.9-supplement.md`)
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

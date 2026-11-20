# DELTAS — 0.9.0-alpha.2 → 0.9.1 → 0.10.0-alpha.1

The complete list of places where this consolidation **changes or pins behavior** relative to the live `spec/CORE.md` (0.9.0-alpha.2) + its CHANGELOG rulings. Everything not listed here is consolidation of existing law (reorganized, renamed, or restated — no behavior change). Each row cites its ruling; nothing below is this suite's invention.

| # | Area | 0.9.0-alpha.2 said | 0.9.1 says | Ruling |
|---|---|---|---|---|
| 1 | Tab in indentation | Error; the line is dropped | **Warning**; line kept best-effort as text of the current owner | **L4** (2026-07-21) |
| 2 | Root-level `:key` | Undefined (parser emitted a free-floating attribute; "do not rely") | **Warning**; kept as document-level text incl. the `:`; no phantom owner in the model | **L1** |
| 3 | In-string escapes | Deliberately undefined | **None, ever**: a string closes at the next same-quote; embed the other kind; `\` interior is content | **L2** |
| 4 | Rational / complex literals | Grammar recognized bare `1/3r` / `3+4i` "parser-decided, not frozen" | **Not bare scalars**; future standard-types dialect via envelope; unquoted they are ordinary strings/flow | **L5** reaffirming **R21** |
| 5 | Attr-under-attr keep shape | "kept as element prose *(needs a ruling)*" (alpha.1 fixture-pinned) | Kept as **text of the open value** + Error | **L6** |
| 6 | Comment continuation strip | Content-base shape *(alternative "verbatim from comment column" flagged as needing a ruling)* | **Content-base shape**, ruled | **L7** |
| 7 | Multi-line for remaining delimited forms | "deliberately undefined" per-construct table (the greenfields then closed it per-construct) | Same openness, **reframed as a carve-out with its dissolution reason** (dialect-capture sugar); explicit do-not-close-per-construct | OPEN **ML** re-mark (2026-07-21) |
| 8 | Event/wire encoding in the spec | CORE carried an "Event Encoding" section (flat wire) | **Absent from the spec suite** — flat wire deratified; successor (W0/W1d) lives in the v2 ledger; MODEL §6 carries the adequacy test any future wire must pass | **R8** |
| 9 | Anomaly severity framing | Ladder + per-case calls | **Error = loss** (or genuinely-absent intended value) as the checkable rule; representative table re-derived under it | **L0** |
| 10 | Equivalence / serializer contract | none — 0.9 specified the text law and selected desugarings, but no whole-document equivalence relation or serializer requirements | **SEMANTICS.md**: a newly specified comparison + serializer contract (equivalence layers, normalization list, serializer MUST NOTs). No source-recognition change — it constrains consumers/serializers, not what source text means | Charter **C3** (SEMANTICS named a day-one component); **S17**/**S9** boundaries respected |
| 11 | Unicode identifier portability | UAX #31 vocabulary with no version statement (silent cross-implementation fork) | Recognizers MUST declare their Unicode data version; non-ASCII identifiers are non-portable across declared versions (§5.2; CARVEOUTS §UNI). A version pin is a future ruling, not invented here | consolidation-surfaced (codex review); no prior ruling |

One suite-scope addition for Joseph's eye (grok L2, coordinator-endorsed): CORE §13.2's caution now carries an explicit sentence that fixtures/tools treating the current-parser multi-line table as *language* behavior are non-conformant with the suite's scope claim — S2's own descriptive-framing rule made enforceable. It constrains fixture *framing*, not source meaning; flagged here because it edges normative.

Organizational (no behavior surface): the vocabulary rename — head position / blob / embedded / freeform / raw-as-noun → **Structure Position / Line Scan / flow / inline element / verbatim family**, with GLOSSARY's retired-terms table (per DECISIONS **N-pos**/**N-scan**, plus **greenfield-3b DECISIONS §D4** "Vocabulary stabilization" — an [ORG] greenfield decision adopted under charter C1/C3's tactical-deference, *not* a Joseph ruling, and distinct from the CHANGELOG's unrelated "D4" BlankLine ruling). Likewise the suite adopts the three-pillar  
split (defining-udon.md) — GLOSSARY + MODEL + CORE + SEMANTICS + CARVEOUTS as the specification pillar; pedagogy an outline stub; no grammar document (the Nesting Rule's mechanical spelling stays in CORE §2.1). Rulings R1–R21 and the S-batch (S1, S4, S5, S6, S8, S11, S13–S18, final-terminator, `*{`-principle, `;{}`-empty-string, empty-brackets, EOF≡eol+dedent, nameless-`!{`, empty-forced-text) are **landed in the prose** rather than left as changelog reading — that is consolidation, not change.


---

## Post-consolidation amendments — the K-series (2026-08-07/09)

Behavior changes vs 0.9.1, ruled in-session; **authority is Joseph's verbatim intent in the session record** (the DECISIONS K-rows are after-the-fact compression — see the ledger's provenance banner). One line each; details in DECISIONS + the rewritten suite text.

| # | Change | Ruling |
|---|---|---|
| K1 | Multiple `[key]` designators stack into `$key` | K1 |
| K2 | Identity-bracket interior = value grammar; block forms out; stacked `$key` for post-value material, silent | K2 |
| K3 | Directives sit anywhere an element can; inert this version; head-swallow callout | K3 |
| K4 | No attributes-of-attributes (grouping sugar stays open — ATTR-GROUP) | K4 |
| K5 | Attribute-content unification: `Assignment = {label, content}` (block context; sameline scan discipline unchanged) | K5 |
| K6 | Explicit nil; four-state model kept; missing value stays the sole Error | K6 |
| K7 | Deferred body's first line carries the value-expected position | K7 |
| K8 | Sugar-born-finished; attr-under-attr Error→Warning (L6 keep shape stands) | K8 (Overturns: L6 severity) |
| K9 | Sameline is value-space; sameline text = `$main` sugar; typed slot; brace forms self-delimit at clean positions | K9 (Overturns: R4/S11 scope) |
| K10 | Unquoted text values terminate at framed markers; prose no longer exists sameline | K10 (Overturns: 07-15 flow-to-EOL) |
| K11 | Stacking silent everywhere; warned extension retired | K11 |
| K12 | Expressive labels (any-position charset); flag semantics retired; presence explicit | K12 |
| K13 | `\` frame split: framed commits text mode; attached escapes one character | K13 (Overturns: 07-15 forced-line scope) |
| K14 | Late attributes accepted + warned (supersedes K8's element leg) | K14 |
| K15 | Spelling flavors (stacked vs bracketed contributions) are ornamentation; collection default-read (one contribution → the value; several → list in order, nesting kept); assembler MAY annotate flavor | K15 |
| K16 | A key is a value slot: full value grammar in key-bracket interiors, brace forms included; sugar carves held lightly — block forms out, references take the brace form `@{key}`; structural-key matching deferred to paths | K16 |
| — | Terminology: attribute name-side = **label**; verbatim tag = **kind**; "key" = identity only | jaw 2026-08-09 |

**Provenance discipline (2026-08-10):** this table is the sole in-suite map from spec text to ruling IDs — the body prose no longer carries `(ruled Kn)` breadcrumbs (stripped per the breadcrumb law; the record of that pass is `working-notes/CHANGELOG.md`). For the full ruling texts and Joseph's verbatim intent, see `../DECISIONS.md` (its provenance banner governs).

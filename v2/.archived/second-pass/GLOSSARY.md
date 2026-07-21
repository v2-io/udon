# UDON Glossary (0.10 / v2-spec)

**Status:** **provisional skeleton** — not full suite prose.  
**Role:** Stable vocabulary for the normative companions. Full definitions of
*behavior* live in SPEC / ADM / WIRE / SEMANTICS when authored; this file owns
the short form of each formal noun.  
**Authority:** Only what is already in [DECISIONS.md](DECISIONS.md) (charter +
CARRY) is treated as settled law. Greenfields (`spec/msc/greenfield-2a|3b`) are
**wording mines**, not law. Silences → [OPEN.md](OPEN.md).  
**How to read:** Load-bearing terms have real short definitions. Thin spots
are marked **TODO**. Do not invent surface or wire behavior here.

Requirement words (MUST / SHOULD / MAY), when used later in suite prose, follow
RFC 2119. This skeleton does not yet assert RFC density.

---

## Policy (skeleton)

1. Every formal capitalized / bolded noun used in suite prose SHOULD appear here.
2. Mechanical / recognizer terms MAY be defined for SPEC/GRAMMAR precision, but
   SHOULD NOT be the primary Host- or pedagogy-facing vocabulary (prefer Element,
   Attribute, Content, Value, Document). *Lean 3b glossary policy.*
3. Wire / event vocabulary is **not** pinned here — see OPEN **W\***; WIRE owns
   that contract when drafted.
4. Multi-line / line-bound policy is **not** pinned here — see OPEN **ML**.
5. Retired synonyms (below) MUST NOT re-enter normative text.

---

## 1. Architecture

| Term | Short definition | Status / cite |
|------|------------------|---------------|
| **Core** | Syntax and core semantics every conformant recognizer MUST implement identically (markers, geometry, bare scalars, stacking, sugar desugaring, extents, anomaly recognition). | Consensus 2a/3b |
| **Recognition** | Mapping from source text to ADM instances plus anomaly records. Independent of any particular parser implementation. | 3b; 2a says “parse product” — same hinge |
| **ADM (Abstract Document Model)** | Normative data shape a conforming recognition produces. Defined in [ADM.md](ADM.md). | **C3**, **C5** (assembly/ADM product) |
| **Dialect** | Named layer that *types / means* non-core values or dynamic forms (e.g. `temporal@1`). Types; never constrains. | Consensus; **R7**, **L5** |
| **Schema** | Constraint layer (cardinality, vocabularies, application duplicate policies). Never Core. | Consensus |
| **Host** | Environment embedding UDON: dialects, reference resolution, projection to native values, document-layer policy knobs. | Consensus |
| **Consumer** | Any layer above recognition (Host, document builder, Schema, application). | Consensus |
| **Document layer** | Consumer that assembles a whole Document and enforces document-wide rules (e.g. duplicate-definition menu — **R14**). | 3b name; 2a folds into Consumer |
| **Menu vs knob** | Core MAY fix an option *space* and a default; a Consumer picks within the space. A Consumer MUST NOT invent options outside the menu. | Consensus; **R11**, **R14** |
| **Projection** | Host turning a validated string (or claimed envelope body) into a native value. | Consensus |
| **View** | Recommended Host accessor over the attribute substrate (`all_attributes`; ergonomic `key` / `traits` / `attributes` split) — not a second model. | ADM § views |
| **AST** | Concrete library encoding of an ADM (or resolved model). Not the language product name. | pipeline/process note; keep out of contract prose |

---

## 2. Document structure

| Term | Short definition | Status / cite |
|------|------------------|---------------|
| **Document** | Ordered top-level content (no implicit root Element) plus associated anomalies and completeness result. Shape in ADM. | Consensus forest model; **R2** incomplete-input |
| **Element** | Structural node: optional **Name**, ordered **attributes** (assignments), ordered **content**. Surface begins with `\|`. Identity / traits / flags are sugar over designated attributes — no parallel fields. | Consensus; CARRY attr-model |
| **Name** | Element type label. Absent ⇒ **Anonymous Element**. | Consensus |
| **Anonymous Element** | Element with no Name (`\|[k]`, `\|.trait`, `\|?`, …). | Consensus |
| **Attribute** | Labeled edge from an Element: a **Key** plus value assignment(s). Surface begins with `:`. | Consensus |
| **Assignment** | One `(key, value)` pair in the ordered attribute sequence. Alias **AttributeAssignment** (3b). | **Canonical: Assignment** (ADM/SPEC) |
| **Key** | Attribute label string. Distinct from **Identity** (`$key`). Flag keys may end in `?`. | Consensus |
| **Content** | Ordered body of an Element after its attributes: Text, children, References, Directives, Comments, Verbatim, … | Consensus |
| **Child** | Content item that is itself an Element (structural peer). Positional and self-named. | Consensus |
| **Node** | Any unit that can appear in content (Element, Text, Comment, Verbatim, Directive, Interpolation, Reference — exact union in ADM). | 2a union explicit; 3b ContentItem |
| **Identity** | What makes an Element uniquely *this* instance within its type: designated attribute `$key`, usually sugar `[…]`. | Consensus |
| **Trait** | Classification of *kinds*: values of designated `$traits`, usually sugar `.name`. Plural, ordered, stacked. | Consensus; 3b also “Classification” |
| **Designated attribute** | Ordinary attribute whose key is a sugar target (`$key`, `$traits`, `$?`, `$!`, `$*`, `$+`; `$partial-key` for unclosed identity). Designated, not reserved: any `$`-key is legal longhand. | Consensus; **R5** |
| **Flag suffix** | Trailing `?` `!` `*` `+` on element identity, desugaring to designated boolean attributes. | Consensus; **R18** stacking |
| **Flag key** | Attribute key ending in `?`: presence/boolean semantics (bare presence ⇒ true). | Consensus; **R6** |
| **Node value** | Attribute value that *is* a node (block Element, block Verbatim, Fence) with no wrapper Element. | Consensus; **R4** block `\|name` binds node value |

---

## 3. Values

| Term | Short definition | Status / cite |
|------|------------------|---------------|
| **Value** | What one Assignment carries. Multiplicity under one Key is multiple Assignments (**Stacking**), not a nested multi-segment Value kind. | Consensus |
| **Value kind** | Scalar \| Reference \| Interpolation \| Node value \| Flow value. Exact union in ADM. | 3b term; 2a inline |
| **Scalar** | String, Integer, Float, Boolean, Nil, List, or Envelope (envelope is recognized bare but is the dialect hand-off, not a frozen core scalar type — see below). | Consensus shape; **L5** |
| **Bare scalar set** / **Frozen core scalar set** | Closed set recognized from bare syntax alone: string, integer, float, boolean, nil, list. **Nothing is ever added** to bare recognition. Rational/complex → dialect/envelope (**R21**, **L5**). | Consensus; prefer one name in SPEC |
| **List** | `[…]` value: space-delimited items, each under full value rules; no Flow inside. Empty `[ ]` → empty array (**R16**). | Consensus; **R17** |
| **Envelope** | `<…>` form in value position: dialect-typed hand-off. Body carried until a Dialect claims it. Label ladder detail → SPEC/dialects (**TODO** pin ladder if 3b kept). | Consensus; empty `<>` interim BareValue+NoDialectsLoaded **R13** |
| **Flow** / **Flow value** | Prose-shaped ordered segments (text + inline forms) that resolve to text after Consumer processing. One ruleset for element prose, flow values, and inline interiors. | Consensus; retire “blob” |
| **Segment** | One piece of Flow (Text, Inline Element, Interpolation, Inline Directive, Inline Verbatim, …). | Consensus |
| **Stacking** | Repeated same-key Assignments accumulate in source order; last-wins does not exist. Orthogonal to List literals. | Consensus; **R6**, **R9** |
| **Syntactic typing** | Type comes from written syntax, never from sniffing content. | Consensus |
| **Nil** | Explicit no-value (`null` / `nil`). Distinct from absent and from `false`. Empty closed identity/brackets → nil key (**R16**). | Consensus |
| **Warned extension** | Material after a finished attribute value kept as a further Assignment under that key, with a Warning. Keep-everything alternative to drop. | 2a term; 3b describes the shape without always naming it |
| **Absent / Nil / False / True** | Four distinct presence states — full matrix **TODO** in SPEC (3b points at CORE; do not invent matrix here). | Thin |

---

## 4. Geometry and recognition contexts

| Term | Short definition | Status / cite |
|------|------------------|---------------|
| **Column** | Zero-based character / leading-space position used for hierarchy. | Consensus |
| **Indentation** | Leading spaces only before a line’s first character. Tabs in indent: **keep** as text of owner + **Warning** (**L4**, **L0**); not line-lost. | **L4** |
| **Base column** | Column where an Element’s `\|` sits; nesting compares against open stack. | 3b; 2a “structural column” family |
| **Content base** | Column anchoring prose/verbatim dedentation: first continuation establishes it; that many spaces stripped. | Consensus |
| **Structural column** | Column at which a new node may begin given open hierarchy; deeper-than-content-base is inside text, not structural. | 2a |
| **Nesting rule** | Greater column ⇒ child; same ⇒ sibling; lesser ⇒ close ancestors. Formal close-while shape **TODO** pin with SPEC. | 3b name |
| **Structure Position** | State where markers are recognized (line start at structural column, or during Line Scan before prose commits). | **N-pos** — alias “open position” (2a) allowed once |
| **Line Scan** | Left-to-right pass along an element-rooted line collecting attributes/structure until prose commits. | **N-scan** — alias “the scan” (2a) allowed once |
| **Marker** | Character that can begin structure at Structure Position: `\|` `:` `!` `;` `@` or fence opener. | Consensus |
| **Guard** | Bounded lookahead deciding whether a marker character is structural or literal. | Consensus |
| **Commit (to text)** | Moment a line/value position stops being open: thereafter markers are literal (framed sameline comment as named exception — detail SPEC). | 2a; 3b content-phase related |
| **Bare token** | Unquoted single-token value candidate; fate settled by boundary decision. | Consensus |
| **Bare Token Boundary** | After bare token, next non-space decides finished scalar vs start of Flow. Alias “boundary decision.” | SPEC §6.4 |
| **Boundary marker** | Block-form marker (or framed sameline comment, or value-position `\`) that ends a bare token as a finished value. | 3b |
| **Inline-brace principle** | No inline brace form (`\|{`, `!{`, `;{`, anticipated `@{`) is ever a boundary marker; meeting one commits Flow. | Consensus; **R4** `*{` principle |
| **Sameline** | On the element’s definition line. | Consensus |
| **Block** | On its own indented line. | Consensus |
| **Inline** | Within prose or Flow (brace forms). | Consensus |
| **Escape (`\`)** | Position-disambiguated only: Structure Position → rest of line text; before inline opener → literal that opener; value position → flow text; else literal `\`. **No Core in-string escapes** (**L2**). | **L2** |
| **Ownership** | Who receives trailing material (open Attribute vs nearest Element vs column). | 3b; load-bearing — SPEC must own full rules |
| **Element-rooted line** / **Attribute-rooted line** | Line collector is Element vs lone `:key`. | 3b; 2a implies via scan |
| **Deferred value** | Value body on deeper indented lines under a key that finished without a complete same-line value. | 3b |
| **One-way door** | Once a Node value opens on a line, later attrs/content on that line bind to the *node*, not the outer Element. | 3b |
| **Content phase** | After any non-attribute Content item accepted for an Element, further Attributes at ancestor columns become Text+warn (surface). | 3b; detail SPEC |

---

## 5. Text, comments, verbatim, dynamics

| Term | Short definition | Status / cite |
|------|------------------|---------------|
| **Text** | Literal character data, including line terminators where carried. Document text reconstructs by pure in-order concat of text-bearing material — see ADM text law (**R1**). | Consensus; **R1** |
| **Prose** | Non-marker content belonging to an Element (or Document). Opaque to Core Markdown. | 3b synonym family with Text — **TODO** prefer one primary |
| **Blank / ornamental blank** | Blank that contributes Text newline vs structure-only whitespace. Disposition: **R1** / **R15** + ornamental criterion ([PIPELINE.md](PIPELINE.md)). Stream placement vs dedent deferred (**S9**). | CARRY + **S9** |
| **Comment** | `;…` forms (line, block, framed sameline, inline `;{…}`). Carried; inert. | Consensus |
| **Verbatim** | Opaque body never UDON-parsed: one family, three forms — block (`!:label:`), **Fence** (```), inline (`!{:label:…}`). | Consensus |
| **Fence** | Triple-backtick Verbatim: byte-exact, no dedent, no marker interpretation; opener trail = info label. | Consensus |
| **Label** | Optional tag on Verbatim / Fence (host-uninterpreted at Core). | Consensus |
| **Dynamics** | The `!` family (Directives, Interpolation, Verbatim openers). Core recognizes syntax; Dialect/Host meaning. | 3b |
| **Directive** | `!name …` (block) or `!{name …}` (inline): name host-defined; body UDON-parsed unless raw/Verbatim form. | Consensus; **R13** edges |
| **Interpolation** | `!{{expr}}`: expression unparsed by Core; Host evaluates. | Consensus |
| **Reference** | `@…`: inert selector at Core; Host resolves. Model shape in ADM (**S14** lean keep tuple). | Consensus; **R8** wire not here |
| **Selector** | Tuple `(name, key, traits)` a Reference matches; traits filter, do not augment. | 3b |

---

## 6. Extents and EOF

| Term | Short definition | Status / cite |
|------|------------------|---------------|
| **Geometric extent** / **Geometric construct** | Extent from geometry: EOL, dedent, or EOF. Geometric close **silent at EOF** (**R2**). | Consensus; **R2** |
| **Delimited extent** / **Delimited construct** | Extent closed only by matching end-sequence (quote, `]`, `}`, `}}`, `>`, fence closer). Unclosed at true EOF → warn + keep; document **incomplete-input** (**R2**). | Consensus; **R2**, **R12** |
| **Incomplete input** | Per-document non-success when a delimited extent remains open at true EOF. Not an event (**C6**, **R2**). | **R2**, **C6** |
| **Multi-line / line-bound policy** | Per-construct rules for 0.10. | **OPEN ML** — WAIT-DEMAND; greenfield strawmen only |

---

## 7. Anomalies

| Term | Short definition | Status / cite |
|------|------------------|---------------|
| **Anomaly** | Warning or Error produced during recognition. | Consensus |
| **Warning** | Content kept; may not match author intent. | Consensus; **R11** |
| **Error** | Something was **lost**, or a specific rule names Error for *absent intended value* (e.g. plain `:key` → Nil). Recognition continues; halt/reject is Consumer menu (**R11**). | **L0** |
| **Keep-everything** | Where a coherent keep exists, recognition MUST capture content (prefer Warning over silent drop). | Consensus; **R11** |
| **Unclosed emission order** | Content → `Unclosed*` → `End` (uniform). | **R12** — event names provisional until WIRE |

---

## 8. Wire / fixtures (pointers only)

| Term | Note |
|------|------|
| **Wire / event stream** | Own contract ([WIRE.md](WIRE.md); **W0**, **W1d**; encoding OPEN **W1e**). Flat Attr wire deratified (**R8**). |
| **Assembly / ADM product** | What fixtures assert alongside events where useful (**C5**). |
| **Sufficiency / no-reachback** | Candidate WIRE law: assembly product recoverable without source (**W0** PANEL). Text-wire (**R1**) is partial instance. |
| **Profiles** | Idiomatic / comprehensive / descriptive (non-normative) — **C5**. |

---

## 9. Retired synonyms

Do not use in new normative text, tooling messages, or suite docs.

| Retired | Use instead |
|---------|-------------|
| blob, text blob | **Flow**, **Flow value**, or **Text** |
| freeform | **Fence** (form) / **Verbatim** (family) |
| raw (as free noun) | **Verbatim** (name the form: block / fence / inline) |
| embedded element | **Inline element** |
| head position | **Structure Position** (**N-pos**) |
| positional (close/construct) | **Geometric extent** / **Geometric construct** |
| segment-ingest, warn-and-stack | **Warned extension** |
| multi-segment value | Stacked **Assignments** |
| sameline decompress | Element tail (plain description) |
| AST layer (in the contract) | **Document layer** / **Consumer** |
| parse / parser (as subject of *language* rules) | **Recognition** / recognizer — except implementer notes |
| wire / event names as language nouns | Defer to WIRE; do not smuggle into GLOSSARY as Core terms |

Older design notes and live CORE may still use retired terms; this suite does not.

---

## 10. Naming pins and remaining thin spots

Closed naming / packaging (do not re-open):

| Topic | Holds | Cite |
|-------|--------|------|
| Open-state name | **Structure Position** (alias “open position” once) | **N-pos** |
| Scan name | **Line Scan** (alias “the scan” once) | **N-scan** |
| Document packaging | `{ content, anomalies, result }` (equiv APIs OK) | **D-pack**, **C5**, **C6** |
| Error severity | **Error = loss only** (plus named absent-value Errors under **R6**) | **L0** |
| Assignment noun | **Assignment** (AttributeAssignment alias) | ADM §2.2 |

Still thin (not silent merges):

| Topic | 2a lean | 3b lean | v2 posture |
|-------|---------|---------|------------|
| Envelope `resolved` field | No (body only) | Optional DialectResult | Host/dialect; ADM keeps unresolved body as Core |
| Reference partial | Via consumer of identity rules | `partial` on selector | Align with **R5** `$partial-key` for elements; ref model **S14** |
| Prose vs Text | Text primary | Prose / Text both | Prefer **Text** in ADM; Prose as surface synonym |

---

## Pointers

- Ledger: [DECISIONS.md](DECISIONS.md) · Opens: [OPEN.md](OPEN.md)  
- Model: [ADM.md](ADM.md)  
- Process: [PROCESS.md](PROCESS.md) · Front door: [README.md](README.md)  
- Wording mines: `../spec/msc/greenfield-2a/new-spec/GLOSSARY.md`, `../spec/msc/greenfield-3b/new-spec/GLOSSARY.md`

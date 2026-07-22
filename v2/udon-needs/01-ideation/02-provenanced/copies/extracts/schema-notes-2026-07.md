---
source: live repo file `design/schema-notes-2026-07.md` at gather time
gathered: 2026-07-21
status: |
  gathered source material — NOT an authoritative decision document; live originals may advance
paths:
  - design/schema-notes-2026-07.md
categories:
  - schema
  - loud-failure
  - enforcement-dial
why_included: |
  Current schema demand notes: loud failure for silent re-parenting; Casual/Careful/Critical dial. Newer than schema-exploration.
---

> **Why gathered:** Current schema demand notes: loud failure for silent re-parenting; Casual/Careful/Critical dial. Newer than schema-exploration.

# Schema layer — notes and forming proposal

> **Status (2026-07-18):** design notes + a forming proposal, **not
> ratified.** Written after reading CORE's dialect/schema split, the
> December hand DSLs, `udon-schema-exploration.md`, `udon-guarantees.md`,
> `schema-workbench-2026-07.md`, `file-naming.md`, `TODO-AUX.md`, the
> operata scenario corpus, and a slice of rowan (identities, constraints,
> versioning, ADR-003). Epistemic register: **judgment for Joseph to
> strengthen, cut, or reject** — same spirit as the workbench's "do not
> converge here," but one step further toward a design note he can ratify
> from.
>
> **What this is for:** freeze enough structure that paths + schema +
> pragma can move without re-litigating the whole survey every session.
> Acceptance test (Joseph): *can rowan's vocabulary be written in it,
> better than the Ruby?*
>
> **What this is not:** a second CORE; an Ash-in-UDON resource language;
> a replacement for dialects; a pick among four loci as "the winner."
>
> **Prior art in-repo (read, not restated):** workbench source index +
> survey; exploration's thirteen pieces; guarantees ladder + profiles;
> ash-like / operata / schema-dsl examples; EOF doc's litmus (characters +
> geometry only) — schema is the layer that *is* allowed to know more.

---

## Short form

> UDON **core** parses and keeps everything. **Dialects** say what values
> *mean*. **Schemas** say what is *allowed* (structure, cardinality,
> uniqueness, reference shape, hard islands in a soft document). Schemas
> restore **loud failure** where indentation re-parents silently. Default
> world is **open** (absence of a constraint = soft / free). The first
> orthography to prefer is December's: **type as trait, constraints as
> attributes, layers as named blocks**. Core schema stays small;
> actions/policies/storage are a **resource dialect** (rowan's layer), not
> CORE-schema. Binding is pragma + filename designator (both live ideas).
> Enforcement is a **dial** (Casual → Careful → Critical), not a single
> binary. Typing vs constraint stays split: traits may *name* types that
> dialects claim; schemas do not become a second type system.

---

## 1. Why schema is load-bearing here

Two reasons from Joseph (2026-07-16), still the right frame:

1. **Indent hazard is worse than Python's.** Wrong-scope content in UDON
   often *parses* — it is silently re-parented. Schemas are what make that
   loud. (The edit tool removes write-side indent hazard; schemas cover
   everything else, including rogue `vim` and agent drift.)

2. **Rowan is the first customer, not decorative prior art.** Rowan
   stalled because the Ruby resource DSL was the wrong surface; UDON was
   revived to be that surface. December's ash-like / operata files are not
   sketches of "maybe schema someday" — they are the craving dated and
   written.

CORE already fixed the job split (do not re-open):

| Layer | Job |
|-------|-----|
| **Core** | syntax, wire, stacking, identity sugar, anomaly posture |
| **Dialect** | what a value *means / types* (`<…>`, temporal, dynamics language) |
| **Schema** | what is *allowed* (cardinality, uniqueness, vocabularies, structure) |
| **Host / document** | projection, duplicate-definition policy, reference *resolution* modes |

Schema must never become a second parser or a dialect by another name.

---

## 2. Three surfaces (do not conflate)

People keep putting four different jobs in one "schema DSL." Split them:

### Surface A — Core schema (constrain structure)

**In scope for this proposal.** What a UDON *document instance* may contain:

- Element content models (which children, cardinality `? ! * +`)
- Attribute requirements (presence, nullability, scalar vs node vs stack multiplicity)
- Identity / uniqueness over `$key` (and later multi-key / tuple — CORE wire already allows stacking and array keys)
- Reference *shape* ("this value is a reference selector") — not full join semantics
- Soft regions: where prose/comments/unknown children are allowed

**Open-world default:** what the schema does not name is soft (free), not
forbidden. Closed islands are explicit. That matches mixed soft/hard
documents (guarantees Path C) and vivarium/ASF process maps.

### Surface B — Type meaning (dialects)

**Out of core schema as a parallel type system.** CORE: dialects type;
schemas allow. Trait-as-type (`.string`, `.uuid8`) in December files is the
right *spelling*, resolved as:

> A trait on a schema field is a **type name** (or dialect claim) the
> host/dialect registry must recognize. Schema checks "allowed type name
> / claimable as X"; dialect checks "this value *is* X."

So `|attr[slug].string` is not Piece 2's `|type[email] :base string`
mini-language inside schema — it is a **reference into the type/dialect
space**, same way `<email:…>` would be envelope-side. Custom type
*definitions* (patterns, formats) live in dialect/type-registry documents,
not as schema inventing bare recognition.

**Reading still open for Joseph (fork F1):** is `.string` always a dialect
ref (strict split), or may a small frozen core-scalar set be claimed by
name without a loaded dialect? Proposal lean: core scalars (string, int,
bool, nil, list) may be named without dialect load; everything else
requires a bound dialect (same spirit as `<…>` + `NoDialectsLoaded`).

### Surface C — Resource / behavior (rowan)

**Not core schema.** Actions, policies, storage projection, calculations,
query DSL, graph edges-as-behavior: legitimately live in the **same file**
as schema blocks (December and operata corpus already do), under named
blocks:

```text
|attributes / |identities / |relationships   ; Surface A (+ refs)
|actions / |policies / |queries / |graph     ; Surface C
```

UDON core-schema validates the A blocks (and structural shape of C if we
want). Rowan (or a future resource dialect) interprets C. This is the
workbench's "constrain, don't behave" line, drawn in Joseph's own files as
block names.

If Surface C is folded into "the schema language," you re-create Ruby-DSL
fatigue under a new name.

---

## 3. Soft / hard and the open world

From guarantees + exploration Piece 8:

- **Hard:** machine-consumed, contractual, schema-constrained, often
  identity-bearing.
- **Soft:** human/agent narrative, flexible, not machine-contractual.
- Boundary is **fractal** — hard islands in soft sea, soft commentary on hard
  fields.

**Proposal: absence = soft (open-world).**

- Schema names the hard slots.
- Unnamed children / prose / comments are allowed unless the schema closes
  the content model for that element.
- Optional explicit `|soft` / open-content markers only if needed for
  closed-world islands that still want a prose pocket — prefer not requiring
  them for the default document style.

This is the mixed-content gap almost no JSON-Schema-class tool owns well.
It is also what process maps and decision logs need.

**Comment-locus annotations** (workbench §3) remain a **parallel gradual
mechanism**, not the primary schema orthography:

- Good for: in-progress constraints, exemplar annotation, aspirational
  local marks, schema-by-exemplar without a second file.
- Bad as the only contract: inert-by-rule comments becoming semantic is a
  known footgun family (`# noqa`). Compose with separate schema documents,
  do not replace them.

Plural loci (Joseph): separate document · trait-typed fields · (optional)
comment annotations · filename designator — **prototype more than one**;
do not force a single winner in this note.

---

## 4. Orthography — prefer December, not Piece 1

### Dead under 0.9

```udon
:author! string          ; plain attrs need values; "string" becomes blob
```

### Prefer (December / operata.domain.udon, 0.9-idiom)

```udon
|attr[slug].string :allow-nil? false
|attr[status].atom :default active :one-of [projected active realized]
|identity[unique-slug] :keys [slug] :eager-check?
```

Split:

| Spelling | Means |
|----------|--------|
| `.string` / `.atom` / `.uuid8` | type claim (Surface B) |
| `:allow-nil? false`, `:one-of […]`, `:default …` | constraints (Surface A) |
| `|attr[name]!` or presence via schema content model | **presence** (key must exist) |
| `:allow-nil?` | **nullability** (value may be nil) — *different axis* (CORE Absent vs Nil vs False) |
| `|identity[…] :keys […]` | uniqueness sets (rowan already) |
| Named blocks | layer boundaries (A vs C) |

### Presence vs nullability (keep both)

CORE already separates Absent / Nil / False. Schema must too:

- **Presence** — may use element suffixes on schema fields (`!` required, `?`
  optional) *or* explicit attrs; December used both idioms in different files.
- **Nullability** — `:allow-nil?` (flag-shaped in 0.9 operata port).

Do not overload `?` alone for both axes.

### Name collision to fix early

| Spelling | Meaning |
|----------|---------|
| `:one-of [a b c]` on one attr | **enum** of values |
| `|one-of` + `|present :x` children | **XOR across attributes** (rowan / JSON Schema oneOf) |

Proposal: keep `:one-of` / `:enum` for value enum; use **element form**
`|one-of` / `|any-of` / `|when` for cross-field constraints (rowan mapping
already natural). Never use one name for both.

### schema-dsl.udon (element-as-type)

```udon
|str[username]!
  :min 3 :max 32
```

Still viable as a **compact document-schema** spelling (schemacop lineage),
especially for pure data shapes (user records, API bodies). It is a second
orthography for Surface A, not a replacement for resource-shaped December
files.

**Proposal lean:**  

- **Resource / domain documents** → December trait+attr + blocks (rowan path).  
- **Closed data shapes / JSON-Schema-like trees** → element-typed compact form
  allowed as the same core vocabulary with different sugar.  
- One meta-model underneath; two surface sugars if needed — do not invent a third.

---

## 5. Minimum coherent core schema (v0)

What must be expressible before edit-tool conformance-at-apply is honest:

1. **Element content model** — allowed child element names + cardinality.
2. **Attribute model** — allowed keys; presence; nullability; value kind
   (scalar / node / list / stack max); enum / range / pattern where cheap.
3. **Identity** — uniqueness of `$key` within element type; named identities
   over key sets (rowan `identities`); leave multi-key sugar to CORE when ruled.
4. **References** — attr or child is a reference (selector shape); resolution
   and FK integrity are host/rowan unless we add a thin "must resolve" profile.
5. **Open vs closed content** — default open; optional closed model per element.
6. **Soft allowance** — prose and comments permitted unless closed.
7. **Composition** — `one-of` / `any-of` / `when` / dependent required
   (element form; rowan-proven).
8. **Binding** — document declares schema (pragma and/or filename designator).

**Explicitly later (not v0):** full evolution ops, SQL projection, codegen,
actions/policies, schema-by-exemplar inference engine, gradual confidence
markers as first-class (comment-locus experiments OK in parallel).

---

## 6. Enforcement dial (profiles)

From guarantees Casual / Careful / Critical + rowan ADR-003 (constraints
canonical; storage projection is defense-in-depth) + udon-guard spectrum:

| Profile | Behavior (sketch) |
|---------|-------------------|
| **Casual** | advise; never block write |
| **Careful** | warn on hard violations; block only Critical-tagged rules |
| **Critical** | hard violations fail apply / commit / CI |

Schema (or pragma) may declare default profile; host/tool overrides.
**Write-time gate** (edit tool, guard, pre-commit) is the primary locus;
parse stays schema-free (CORE: event parser does not enforce schema).

Gatekeeper honesty (guarantees): files+git alone cannot force the gate —
discipline + tooling. Critical paths need the edit tool / CI, not hope.

---

## 7. Binding: pragma, filename, body

Three live mechanisms:

| Locus | Status |
|-------|--------|
| **Filename** `<name>.<schema>.udon` | Adopted application-level (`file-naming.md`); not wired |
| **In-body pragma** | TODO-SPEC-OTHER; rowan has shipped `_schema` type/version + upcast |
| **Comment annotations** | experimental gradual / exemplar |

**Proposal lean:**

- **Filename** = aspirational + globbing + default bind when schema exists
  (no-op / advise if schema missing — Joseph's aspirational designator).
- **Pragma** = authoritative when present (dialects + schema + core version
  range); must not fight filename without a precedence rule.
- **Precedence (draft):** pragma > filename designator > host default.
  Mismatch = warning (Careful) or error (Critical).

Do not require pragma for every prose-heavy doc; process maps may stay
filename-only or unbound under Casual.

---

## 8. Rowan acceptance (how we know the design is right)

Port, do not invent:

| Rowan concept | UDON direction |
|---------------|----------------|
| attributes + types | `|attr[name].type` + constraint attrs |
| identities (incl. composite) | `|identity[…] :keys […]` |
| constraints one_of / any_of / when / dependent | element-form `|one-of` etc. |
| relationships | Surface C block; schema may only require "is reference" |
| versioning / upcast | pragma + evolution dialect (later); not v0 core schema |
| document-schema-first (ADR-003) | constraints canonical; SQL optional projection |

**Acceptance corpus (cheap, honest):**

1. `design/examples/ash-like-*.udon` + `archema-operata.udon`  
2. `test/scenarios/corpus/operata.domain.udon` + conforming
   `operata-live.workspace.udon`  
3. One vivarium/ASF process-map style doc (soft/hard mix)  
4. Reverse-test (rowan method): show syntax, ask agents what it means — for
   readability of `!`/`?`/`:one-of` vs `|one-of`

---

## 9. Relationship to the edit-tool critical path

```text
paths  →  schema (conformance)  →  round-trip/spans  →  atomic edit
         ↑ pragma binds document
```

Schema v0 does not need full rowan behavior — it needs **conformance checks
at apply** on structure + hard fields. Surface C can be opaque children to
core-schema until a resource dialect loads.

Paths address nodes; schema says whether the post-edit tree is allowed.
Without schema, the edit tool can still do indent-correct syntax-valid
edits; with schema, it can refuse semantic damage.

---

## 10. Forming proposal (freeze candidates)

If Joseph ratifies a design note from this, freeze only:

| # | Freeze |
|---|--------|
| P1 | Three surfaces: core-schema / dialect-types / resource-behavior |
| P2 | Open-world default; absence = soft |
| P3 | December trait+attr orthography as primary; compact element-typed sugar allowed for data shapes |
| P4 | Presence ≠ nullability (two axes) |
| P5 | `:one-of` enum vs `|one-of` cross-field — different spellings |
| P6 | v0 constraint set (§5) only; evolution/actions later |
| P7 | Enforcement profiles Casual / Careful / Critical |
| P8 | Binding: pragma > filename > host; aspirational filename allowed |
| P9 | Parse never requires schema; apply/guard/CI may |
| P10 | Typing claims via traits/dialects; schema does not grow bare type recognition |

**Do not freeze yet:** single orthography winner; comment-locus as primary;
multi-key sugar (CORE); freeform severity-style issues in schema errors;
full evolution vocabulary.

---

## 11. Open forks (need Joseph)

| ID | Fork | Lean in this note |
|----|------|-------------------|
| F1 | Trait `.string` = dialect ref only, or core-scalar names allowed without dialect? | Core scalars free; else dialect |
| F2 | One orthography vs December + compact dual sugar | Dual sugar, one meta-model |
| F3 | Soft-by-default vs require explicit soft regions | Soft-by-default |
| F4 | Comment-locus: experiment in parallel or defer | Parallel experiment, not primary |
| F5 | Schema for Surface C blocks or treat as opaque | Opaque in v0 |
| F6 | Referential integrity in core-schema or host-only | Host/rowan in v0; schema only "is ref" |
| F7 | Pragma required for Careful/Critical? | Not required; tools may require |

---

## 12. Suggested next steps

1. **Joseph pass** on P1–P10 and F1–F7 (ratify, cut, or rewrite).  
2. **Pilot orthography:** one `*.schema.udon` for operata.domain + one process-map
   schema (soft/hard) — no tooling required beyond human review.  
3. **Static "would validate?" checklist** against scenario
   `schema-guard-before-write` (even as a written oracle).  
4. **Pragma sketch** (TODO-SPEC-OTHER) co-designed with filename precedence.  
5. **Paths** remain first rung; schema second — do not block paths on full
   Surface C.  
6. Keep workbench as source index; **this file** as forming design until a
   ratified `schema-model-*.md` replaces it (attribute-model register).

---

## 13. Explicit non-goals (v0)

- Competing with protobuf/Avro as a wire schema  
- Replacing JSON Schema for pure JSON pipelines (export later if wanted)  
- Embedding a full expression language for `when` (start with small fixed
  predicates; escape to host like operata's `!:rb:`)  
- Making the event parser schema-aware  
- Solving concurrent writes / DB guarantees (storage path D — later)

---

## 14. One-page picture

```text
                    ┌──────────── pragma / filename ────────────┐
                    ▼                                           │
┌──────── CORE ────────┐   ┌──── dialects ────┐   ┌── schema ──┐
│ parse, wire, keep    │   │ type meaning     │   │ allowed    │
│ everything           │   │ <…>, temporal,   │   │ structure  │
│ positional/delimited │   │ .string claims   │   │ soft/hard  │
└──────────┬───────────┘   └────────┬─────────┘   └─────┬──────┘
           │                        │                   │
           └──────────── instance document ─────────────┘
                              │
                    ┌─────────┴─────────┐
                    │ resource dialect    │  (rowan / Surface C)
                    │ actions, policies   │
                    └─────────────────────┘
                              │
                    edit tool / guard / CI
                    (enforcement dial)
```

---

## Short form (repeat)

Core keeps; dialects type; schemas allow. Open-world soft default; loud
failure for hard slots. December orthography first. Rowan is the acceptance
test. Small v0; behavior blocks are not core schema. Profiles dial
enforcement. Pragma and filename bind. Do not re-fuse what CORE split.

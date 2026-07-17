# Schema workbench — sources, survey, and where the thinking is

> **Status: workbench, not a design.** A staging document for the schema
> layer: what's been read, what's worth reading, what resonated, the
> comparative survey, and the position that's forming. **Nothing here is
> ratified and nothing here is a proposal yet** — the deliverable it feeds
> is a design note in the register of `attribute-model-2026-07.md`, which
> Joseph would ratify from. Opened 2026-07-16 (Claude, at Joseph's
> request: *"put together a more comprehensive scratch-pad in project that
> basically indexes all of your sources so far and the things you like
> about them"*). Expect it to be edited, argued with, and eventually
> archived once the design note exists.
>
> **Epistemic note:** the comparative survey (§3) is model knowledge, not a
> fresh survey — verify anything before it becomes load-bearing. Everything
> in §1–§2 is first-hand read or probe-verified unless marked otherwise.

---

## 0. Why the schema layer matters more here than in most formats

Two reasons, both Joseph's:

1. **UDON's indentation hazard is worse than Python's** (2026-07-16):
   *"python will break catastrophically if some code gets the wrong indent
   or even if a block gets put at the wrong scope — whereas it won't be as
   obvious to udon except thanks to schemas."* Wrong-scope content in UDON
   is **valid**, just silently re-parented. Schemas are what restore the
   loud failure. (The edit tool removes the *write-side* hazard by
   computing indentation; schemas cover everything else.)
2. **Rowan is the first waiting customer, not just prior art**
   (2026-07-16): *"I got tired of all of the ruby DSL for the schema
   definitions and started craving udon and decided I wasn't going to move
   it forward anymore until udon was really ready."* So the acceptance test
   for any design here is: **can rowan's vocabulary be written in it,
   better than the Ruby?**

**A dated detail worth holding** (checked, not remembered): rowan's
document-schema-first ADR is **2025-12-10**; udon's revival commit is
**2025-12-23**; `design/examples/ash-like-*.udon` are **2025-12-24**. Within
two weeks of settling rowan's schema architecture, Joseph was hand-writing
Ash-shaped schemas in UDON. The craving is dated and immediate, not
hindsight.

---

## 1. Source index — in-repo

### The January 2026 working docs (the direct ancestors)

Both were written in January, left uncommitted when udon went dormant, and
committed by Joseph on 2026-07-08 during the reboot ("Commit the January
2026 working docs"). The estate review called them "the newest thinking."

**`udon-schema-exploration.md`** (662 lines) — *the* schema document.
Organized as **thirteen numbered "Puzzle Pieces"**, and its own closing
instruction is the brief for whoever finishes it: *"Find the minimal
coherent core. Let the elegant unification emerge rather than forcing it."*
Its last line: *"This document is a workspace, not a conclusion."* The
pieces, so nobody has to open it to follow a reference:

| # | Piece | My read |
|---|---|---|
| 1 | Basic schema (RELAX-NG-compact-flavored: `:author! string`, `:date? string`) | **Spelling dead under 0.9** — see §2. The *cardinality idea* survives and is ratified elsewhere. |
| 2 | Type definitions (`\|type[email] :base string :pattern …`) | **Probably shouldn't exist** — typing is dialects. See §4. |
| 3 | Composition constraints (`one_of` / `any_of` / `when` / `dependent`) | **Keep** — this is JSON Schema's vocabulary and rowan already built it. |
| 4 | Relationships (`belongs_to` / `has_many` / `through`) | Rowan's layer, not core schema. Core says "this attr is a reference"; rowan says what kind. |
| 5 | Actions (behavioral) | **Not schema.** Rowan's resource layer. |
| 6 | Policies (authorization) | **Not schema.** Same. |
| 7 | Evolution (`was:` / `since:` / `deprecated:` / `removed:`) | **Keep** — and rowan has the better-developed version. |
| 8 | **Soft regions** (four candidate syntaxes for "prose allowed here") | **The differentiator.** Nobody else has this. Option D (absence = soft) is the one I'd argue for, on principle rather than convenience — see §4. |
| 9 | Storage projection | Not schema — but its *shape* transfers to the enforcement-cadence dial. |
| 10 | Derivation targets (SQL DDL / JSON Schema / Ruby / API tools / docs) | Consumer concern; the tool-generation half is live in rowan already. |
| 11 | Meta-schema ("schemas all the way up") | Falls out of same-language self-description. |
| 12 | **Dialect declarations** (`!dialect …`, scoped switching, "dialect as lens") | This is the **pragma's ancestor** — schema + examples + valid/invalid tests in one file. Closest thing in the doc to schema-by-exemplar. |
| 13 | Provenance & confidence (`:$confidence`, `;?` / `;??` markers) | Overlaps the annotation-layer ruling (`ux/TODO-AGENT-UX.md`); also the nearest thing to *gradual constraint*. |

Plus **16 open questions** at the end — still the live agenda.

**`udon-guarantees.md`** (15K) — the trade-space. What I keep from it:
- **The guarantee ladder**: syntactic validity → schema conformance →
  referential integrity → atomic ops → concurrent safety → queryability.
- **The Casual / Careful / Critical profiles**, and the question that makes
  them interesting: *can the same document move between profiles without
  rewriting?*
- **The gatekeeper problem**, stated bluntly: *"Only works if all writes
  use the gatekeeper. A rogue `vim` edit bypasses everything. You're
  relying on discipline, not enforcement."* — which is exactly what the
  udon-guard idea (`../TODO-UTILS.md`) answers.
- **The append-only log sketch** (`|change` entries carrying `|set` /
  `|append`, validated before append) — a first draft of patch syntax,
  from January, with an audit trail built in.
- The soft/hard framing that Piece 8 formalizes: *"The boundary is fractal,
  not linear."*

### The December 2025 hand-written attempts

**`examples/schema-dsl.udon`** (2025-12-23) and
**`examples/ash-like-{billing,inventory,support}.udon`** (2025-12-24) —
Joseph writing Ash-shaped schemas in UDON by hand, the day after the
revival commit. **These are the closest thing to a requirements document we
have**, because they're what he *reached for* before any theory. Pre-0.9,
so the spelling has drifted — but the shapes are the ask.

### Adjacent in-repo docs the schema layer must not contradict

- **`spec/CORE.md`** — the authority. Sections that bear directly:
  *"The Core, and What It Leaves Open"* (the menu-vs-knob rule; **"Dialects
  are not schemas"**; *"Constraint — what is allowed or required… A
  schema's job. Proscription lives here, never in the core."*);
  *Element Suffixes* (**the cardinality vocabulary is already ratified,
  with its meaning explicitly left to "the consuming schema or dialect"**);
  *Explicit Typing* (the `<…>` envelope and the label ladder);
  *Identity* (`[key]` takes any type — the full typed-value path);
  *Multi-Segment Values and Stacking* (**"what is allowed — e.g. forbidding
  a multi-valued `$key` — is a schema concern, never core"** — the schema
  layer's job description, written into CORE).
- **`udon-ast.md`** — the substrate the schema constrains: type-scoped
  `(element-name, key)` uniqueness, the `$key`/`$traits` model, Document
  indexes (`by_type`, `by_key`, `traits_index`), `ReferenceIndex` with
  `unresolved()` (referential integrity, already designed).
- **`attribute-model-proposal-3.md`** + `-substrate.md` — the 0.9 model's
  ratification carriers. **This is what changed the schema's job**: values
  may be nodes/blobs/segments; stacking is uniform; flags are `?`. A schema
  now constrains *kind* and *stacking cardinality*, not just type.
- **`udon-paths.md`** (stale banner) — selection, which schema constraints
  will need to reference (a constraint about "every `||endpoint`" needs
  paths).
- **`agentic-ux-principles.md`** — P7 ("the file's own law governs") is the
  schema's consumer contract: enforce *the document's declared* schema, not
  tool-baked rules; declared-is-theater-until-a-write-path-honors-it.
- **`composite-types.md`** — the `<…>` nesting direction; matters if
  schema type-refs are dialect-refs.
- **`GRAMMAR-CONSTRAINED-GENERATION.md`** — schemas as *generation*
  constraints (guaranteed-valid UDON from local models). A downstream
  consumer that argues for machine-readable schema.
- **`udon-agentic.md`** — `validate` and `infer` are the schema's tool
  surface; **`infer` ("what should go here?" from schema + sibling
  patterns) is schema-by-exemplar's read-side twin**, designed in January.
  Its Future Directions already lists *schema-inference from existing
  documents*.

### The scenario corpus — the requirements document nobody meant to write

**`test/scenarios/`** (2026-07-16, 1,645 lines, all parse-clean). Built for
the path/edit tool, but it constrains the schema layer just as hard, and
**it's the only body of real 0.9-idiom documents that exists**:

- **`corpus/operata.domain.udon`** is *already a schema-flavored document*
  in 0.9 idiom — flags, `:allow-nil? false`, interpolations, a same-line
  raw value. Someone (an agent, but still) has already answered "what does
  a constraint-ish UDON document look like under the current model."
- **What the corpus demands a schema be able to say**, derived from what's
  in it: typed identity keys (`|intent[42]` beside `|intent["0042"]` —
  *key type and uniqueness*), stacked traits (*cardinality over `$traits`*),
  node-valued attrs (*kind*), `<…>` dates (*dialect binding*), flags
  (*presence semantics*), prose interleaved at every level (*soft regions,
  live and unavoidable*), cross-document `:in`/`:ref` joins
  (*referential integrity across files*).
- **`features/03-modifying`** contains a **`schema-guard-before-write`**
  scenario — the acceptance test for conformance-at-apply already exists.
- Its draft error vocabulary includes **`SchemaViolation`** alongside
  `PathNotUnique` / `PathNotFound` / `ReferencePlural` /
  `PreconditionFailed`.
- **The first real schema should be a schema for this corpus.** It's the
  cheapest honest test: seven documents, six genres, written by someone
  who wasn't designing the schema.

### The lanes carrying schema asks

- **`spec/TODO-AUX.md`** — the home lane (schema/paths/patch). Carries the
  rowan-as-customer note and the accumulated constraint asks.
- **`spec/TODO-SPEC-CORE.md`** — **multiple keys** (surrogate + natural;
  tuple keys already parse — fixture `key_typed_array_tuple`);
  filename-designator ↔ pragma binding.
- **`spec/TODO-SPEC-OTHER.md`** — **the pragma** (binds a document to its
  dialects + schema). The schema layer can't be delivered without it.
- **`TODO-UTILS.md`** — the **udon guard** and its **enforcement-cadence
  spectrum** (live watcher → commit check → deploy checkpoint →
  gentleman's agreement); `udon fmt` (tabled).

---

## 2. Source index — rowan (`~/src/rowan`, formerly archema; internals still say `Archema`)

Scouted 2026-07-16. `KEY_FILES.md` and `MAP.md` are the index; MAP's
"Track 1: Ash Parity" and "Track 5: Safe RDBMS Evolution" are the relevant
status.

### Read first-hand

**`lib/archema/resource/identities.rb`** (187) — **rowan already built
multiple-keys.** A primary key (optionally composite:
`primary_key [:tenant_id, :local_id]`) **plus** named *identities* —
plural, each an independent unique key-set over attribute combinations,
single or composite, each generating a finder (`get_by_email` for single,
`find_by_<name>` for composite), with timing options (`eager_check` before
create vs `pre_check` before commit). **What I like:** it separates
*identity-for-lookup* from *identity-as-primary*, which is exactly the
surrogate/natural split; and the timing options are the enforcement-cadence
dial in miniature.

**`docs/dev/adr-003-document-schema-first.md`** (152) — the pivotal
decision and the most transferable thing in rowan. *"Constraint vocabulary
comes from JSON Schema, not RDBMS limitations… Archema validation is
canonical. RDBMS constraints are optional projections that provide
defense-in-depth, not the source of truth… Document stores are first-class,
not awkward adaptations."* **What I like:** the projection idea maps
cleanly onto UDON — constraints canonical at the schema layer, and the
*enforcement cadence* is the projection. Joseph's guard spectrum is
ADR-003's store-projection, one level up. Also the three-worlds framing
(RDBMS relations + document expressiveness + event-sourcing temporality)
and the polymorphic-FK dissolution via `one_of`.

**`docs/exp/schema-evolution-patterns.md`** (209) — 1,950 real Rails
migrations from 15 repos, analyzed into **six evolutionary ladders**, each
with a forward/backward asymmetry column: normalization (blob→columns→
table), cardinality (1→N→M:N), type-refinement (loose→strict), **identity
(implicit→UUID→natural→composite)**, temporal (point-in-time→versioned→
event-sourced), constraint (permissive→strict). **Only 8.5% of migrations
are asymmetric** — which is *why* rowan bet on declarative+upcast over
migration scripts. **What I like most:** the identity ladder is annotated
*"natural keys are additive"* — so Joseph's multiple-keys instinct is the
**documented normal direction of schema evolution in the wild**, not an
exotic feature. And the constraint ladder (permissive→strict, 14.1% of
migrations) *is* schema-by-exemplar's lifecycle, observed empirically.

### Queued — the next batch (in the order I'd read them)

1. **`lib/archema/resource/constraints.rb`** (594) — the composition
   vocabulary as built: `one_of` / `any_of` / `when_value` /
   `dependent_required`, with `present`/`absent`/`equals`/`required`
   sub-predicates. **Each constraint also emits a JSON-Schema fragment** —
   validate *and* export from one declaration. Header table lines 13–21;
   DSL context 452–591.
2. **`lib/archema/resource/versioning.rb`** (375) — `schema_id` +
   `schema_version` → `full_schema_id` embedded in documents as
   `_schema: type/version`; `backward_compatible_with` /
   `forward_compatible_with`; `upcast from: "1" do |data| … end`; the
   read-time `upcast_path`/`upcast_data` chaining engine (202–251). A
   **migrate-on-read**, non-destructive posture — Protobuf/Avro-ish.
   Header example 18–52 shows the whole model on one screen.
3. **`lib/archema/resource/evolution_context.rb`** (274) — runtime
   `Resource.evolve do … end`, with the operation vocabulary that matters:
   `add_field` / `rename_field` / `split_field` / `merge_fields` /
   `transform_field` / `remove_field` — **each one simultaneously mutates
   the definition and registers the inverse upcast** (`register_upcast!`,
   ~261). The cleanest statement anywhere of "data outlives its schema
   version."
4. **`lib/archema/resource/attributes.rb`** (1091) — three bands only:
   16–36 (the flag + evolution-metadata vocabulary at a glance:
   `:optional/:required/:private/:sensitive/:readonly/:immutable`;
   `was:/was_type:/since:/deprecated:/removed:`), 448–600 (the `field`
   dispatcher — how constraint separates from relationship), 746–1030
   (primary-key DSL incl. composite at ~992).
5. **`docs/VISION-drafts.md`** (490), the **empirical-validation half
   (303–474)** — they ran naive AI agents at the DSL to test guessability
   and let the results pick the words (`where` over `filter`, `was:` over
   `alias:`, `one_of` self-documents). **These are validated names, not
   guesses** — the single most directly reusable thing in rowan for a DSL
   that agents must author. (The top half is subtractive-design manifesto.)
6. **`docs/msc/plan-document-schema-constraints.md`** (469) — the design
   plan behind `constraints.rb`; its **Open Questions (427–450)** are live
   forks we may be re-treading: validation strictness levels, schema
   inheritance, constraints-on-relationships, external `.schema.json` vs
   generated.
7. **`lib/archema/schema/differ.rb`** (header 1–55 only) — snapshot diffing
   that classifies changes and **raises `:possible_rename` / `:type_change`
   as conflicts requiring an explicit decision rather than guessing**.
   Rowan's transition-validity analog. Supporting: `snapshot.rb`,
   `decision_log.rb` (records resolutions to `.archema/decisions.yaml`),
   `codegen.rb`/`migration_generator.rb`.
8. **`docs/dev/plan-safe-rdbms-evolution.md`** (464), the **Core Insight
   (~45)** — three models contrasted: Database-as-Truth (Rails) vs
   Ambler/Sadalage transition-periods vs **Resource-as-Truth (rowan)**;
   the expand/monitor/contract lifecycle; the `DeprecatedFieldError`
   "historical awareness" idea.
9. **`lib/archema/agentic/tool_export.rb`** + `docs/sys/agentic/tool-export.md`
   — resources emit Anthropic/OpenAI tool definitions **and** JSON Schema
   from the same constraint model. Schema-derived tools, working today.
10. **`docs/msc/archema-ash-comparison-research.md`** (1619, a reference) —
    three sections only: **Category B Schema Evolution** (~187),
    **Category M JSON Schema Composition Constraints** (~866), and the
    **Executive Summary** (11–58: "8 genuine Archema contributions" vs "15
    things Ash has that Archema lacks").
11. **`lib/archema/types.rb`** (296) — the concrete type/constraint catalog
    (dry-types delegation: format, gteq, min_length, enum-via-`values:`).

### Rowan dead ends (scouted; don't re-rule)

`.archema/schema_history/*.yaml` (~230 test-generated snapshots, not
curated history) · `docs/ref/critical-synthesis.md` (ecosystem philosophy,
not schema substance) · `docs/ref/patterns/*.md` (~70 files — the
Ambler/Sadalage *Refactoring Databases* catalog, imported as reference) ·
`tmp/ash/` (a vendored copy of real Elixir Ash — not rowan's code).

**Verified absence in rowan:** aspirational bindings and true
schema-by-exemplar have **no** rowan counterpart (grepped). Those are
UDON-native; the nearest gesture is Piece 12's dialect-as-lens.

## 2b. Source index — autopax

- **`~/src/autopax/docs/ADR/010-markdown-parsing-and-validation.md`** (399)
  — **"P3: Schema-Derived Agentic Tools"** and a phase-4 tool-generation
  plan. The schemas→tooling bridge, from the ADR side. *Queued, unread.*
- **`~/src/autopax/docs/ADR/migration-proposals/003-workflow.md`** —
  "Agentic Workflow Principles" (+ an `.archive` analysis companion).
  *Queued, unread.*

---

## 3. The comparative survey — what exists, and the axes that matter

*(Model knowledge, not a fresh survey. Verify before load-bearing.)*

### The families

- **Grammar lineage (XML):** DTD → XSD → **RELAX NG** (Clark & Murata; a
  regular tree grammar with a clean compact non-XML syntax). Alongside it,
  **Schematron** — rule-based XPath *assertions*, deliberately not
  structural. Real XML pipelines ran **both**, because they're
  complementary, not competing.
- **Constraint lineage (JSON):** **JSON Schema** (2020-12) — `type` /
  `required` / `oneOf` / `anyOf` / `allOf` / `not` / `if-then-else` /
  `dependentRequired` / `patternProperties`, `$ref`/`$defs`, **open-world
  by default**. Cousins: OpenAPI, Zod/io-ts (type-first), JSON Type
  Definition (deliberately tiny).
- **Schema-first wire formats:** **Protobuf** (the schema *is* the format;
  field numbers; evolution rules are the design's center), Thrift, Cap'n
  Proto, FlatBuffers, ASN.1. **Avro** — reader/writer schema *resolution*:
  data written under one schema, read under another, reconciled by rules.
- **Graph shapes:** **SHACL**, **ShEx** — "shapes" as a third paradigm,
  targeting nodes rather than trees, with explicit open/closed shapes.
- **Unification:** **CUE** — types and values are one lattice; a schema
  *is* a value; validation *is* unification; order-independent. Also Dhall
  (total, typed), Nickel (types + contracts), Jsonnet (templating only).
- **YAML/TOML:** no native validation schema — JSON Schema applied
  post-parse (yamllint, taplo, historically Kwalify/Cerberus). Query side:
  `yq`, `jq`, `dasel`.
- **Formatters/linters worth the glance:** gofmt / black / rustfmt
  (canonical form, no options — the "one true output" school); Prettier
  (configurable); ESLint (rule-based + autofix); and the structural family
  — **semgrep / ast-grep / Comby**, whose *patterns look like the code they
  match*. That last idea is udon-paths' cousin.

### The axes — the actual answer

**1. What kind of thing is a schema?** The deepest split, rarely named:

| kind | claim | examples |
|---|---|---|
| **Grammar** | "valid = this grammar generates it" | RELAX NG, XSD content models, DTD |
| **Constraint** | "valid = these predicates hold" | JSON Schema, Schematron |
| **Shape** | "these nodes carry these properties" | SHACL, ShEx |
| **Unification** | "schema and value are one lattice; a schema is a *less specific value*" | CUE |

The January exploration is **already a hybrid** without naming it: Piece 1's
cardinality sigils are a grammar; Piece 3's `one_of`/`any_of` is
constraint. That's fine — RELAX NG + Schematron proved the pairing — but
name which piece is which; they fail and compose differently.

**2. Prescriptive ↔ descriptive ↔ prototype-like.** Prescriptive: schema
first, data conforms (protobuf, XSD, SQL DDL). Descriptive: schema inferred
from data (quicktype, Avro-from-data). **Prototype-like: an *instance* is
the schema** — Self/JS prototypes in languages; in data, **nearly
unoccupied**. **CUE is the closest formal home** (a schema is a value with
freedom left in it) — the thing to read for schema-by-exemplar.

**3. Open vs closed world.** Closed = undescribed is forbidden (XSD,
protobuf). Open = undescribed is allowed (JSON Schema default, RDF).
**This is the soft-region question**: "absence of constraint = soft" *is*
open-world, and UDON's fractal boundary is open-world-by-default with
closed islands. XSD's mixed-content models are the only real prior attempt
and are widely considered its worst corner.

**4. Typing vs constraint — the most useful one.** YAML *has* a thing
called a schema (failsafe/JSON/core) and it isn't validation at all — it's
**type resolution** (how does `yes` become a bool). **The Norway problem is
a typing-schema failure, not a validation failure.** JSON Schema assumes
types are resolved and only constrains. **UDON already separated these** —
syntactic typing + `<…>` dialects handle resolution; nothing sniffs — so
**UDON's schema layer inherits only the constraint half.** This is the
strongest argument that Piece 2 shouldn't exist: `:type <email>` is a
dialect reference, not a schema feature.

**5. Enforcement locus.** Parse-time (protobuf — you cannot parse without
the schema) / post-parse (JSON Schema) / **write-time** (DB constraints,
the edit tool) / never (YAML + convention). **Almost nobody treats this as
a declared, per-document property** — it's baked into the ecosystem.
Joseph's cadence spectrum is this axis made explicit and dialable. Probably
novel.

**6. Evolution model.** None (JSON Schema — ad hoc) / **reader-writer
resolution** (Avro — the best story going) / wire-compat discipline
(protobuf: never reuse a field number) / migration scripts (Rails) /
**upcast chains** (rowan). Avro's reader/writer split is what to steal for
documents that outlive their schema — and it's rowan's `upcast from:` in
different clothes, arrived at independently.

**7. Same-language or foreign?** JSON Schema is JSON; XSD is XML; CUE is
CUE; RELAX NG *compact* deliberately isn't XML; protobuf has its own DSL.
Self-description (a meta-schema) follows from the same-language choice.
Piece 11 chooses same-language — **which is also what makes rowan's
Ruby-DSL fatigue diagnostic: rowan's schema isn't written in the thing it
constrains.**

**8. Constraint reach.** Local (field types) → cross-field
(`dependentRequired`, if/then, Schematron) → referential (SQL FKs, SHACL,
`ReferenceIndex`) → **transitional** (old→new; rowan's differ; essentially
nobody else).

**9. Graded or binary?** Nearly everything is binary; warnings-vs-errors
lives in linters, not schemas. **Gradual constraint** (mandatory → typed →
suggested → free) and confidence-annotated regions are close to
unoccupied. Piece 13's `;?` markers reach at something real.

### Where that leaves UDON

**Occupied — don't reinvent:** constraint vocabulary (take JSON Schema's;
rowan proved the mapping), grammar/cardinality (RELAX NG compact is the
reference; CORE's suffixes already claim it), evolution (Avro's
reader/writer + rowan's upcast).

**Unclaimed, in rough order of value:** mixed-content constraint (prose ⊃
structure ⊃ prose, fractal) · the enforcement-cadence dial as a *declared*
property · prototype-like/exemplar as a lifecycle (CUE is the nearest
ancestor) · gradual constraint · transition validity for documents.

---

## 4. The position that's forming (not a design)

1. **Constrain, don't behave.** UDON's schema layer is *smaller* than
   Archema's resource layer. Rowan itself draws this line in its file
   layout (`attributes`/`constraints`/`identities` vs `actions`/`policies`).
   Pieces 5, 6, 9, 10 are the layer rowan builds *on top*. The exploration
   inherited them by reasoning top-down from Archema.
2. **Constraint-only, because typing is already dialects** (survey axis 4).
   The one I'm most confident about.
3. **Grammar + constraint hybrid, open-world by default.**
4. **The spelling is forced, and the survivor is better.**
   Probe-verified 2026-07-16: `:date? date` now parses as flag `date?`=true
   plus re-owned text `"date"` — and the re-owned text enters the children
   phase, so **every subsequent attribute line on that element becomes
   prose**. One optional marker poisons the field list. The element form
   survives: `|field[date]? :type date`. And CORE *already* says the
   suffixes exist for this: *"a schema might read `?` as optional, `!` as
   required; a grammar might read `?` as 0-or-1, `*` as 0-or-more, `+` as
   1-or-more."* The DSL doesn't invent cardinality; it **claims** it.
5. **Soft regions: prose is the ambient default, mirroring the notation.**
   Piece 8's option D (absence of constraint = soft) reads as merely
   convenient; I'd argue it's *principled* — prose is the unmarked case in
   UDON documents, so prose should be the unmarked case in UDON schemas.
   Same asymmetry, one level up. **Weakest part of the position** — it's an
   argument, not a mechanism.
6. **Exemplar + aspirational + profiles are one lifecycle.** No schema →
   free; write a few; infer a draft; refine; it constrains. That's rowan's
   *empirically observed* constraint ladder applied to authoring, landing
   on Casual → Careful → Critical. Nobody writes the schema first.
7. **What 0.9 changed that January couldn't know:** stacking is uniform, so
   a schema constrains **stacking cardinality** (where multi-key lands);
   and Value Kinds means constraining **kind** (scalar / node / blob /
   reference / interpolation), not just type. Richer, but more regular —
   everything is the hash and the array.

**Honest state: not nearly there.** This is a *position in the design
space*, and the survey suggests it's coherent and unoccupied. It is not a
design: no syntax proposed, no worked example, no meta-schema, and the
hardest piece (§4.5) has an argument but no mechanism.

---

## 5. Next

1. The rowan batch, in §2's queued order (constraints → versioning →
   evolution_context → attributes bands → VISION empirical).
2. Autopax ADR-010.
3. Then a **design note** in the register of `attribute-model-2026-07.md` —
   reasoning included, for Joseph to ratify from rather than re-derive.
   Probable spine: element-form fields; constraint-only; the JSON-Schema
   composition vocabulary; open-world/soft-by-default; evolution via
   upcast; the profile dial; **and a worked schema for
   `test/scenarios/corpus/`** as the honesty test — seven documents, six
   genres, written by someone who wasn't designing the schema.

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
>
> **⚠ Correction — do not read rowan↔udon agreement as convergence**
> (Joseph, 2026-07-16): *"I wouldn't read too much into the convergences
> you see — it was all me."* Rowan and udon share one author. Where an
> earlier draft of this document called rowan's DSL shape "independent
> corroboration" of a udon position, that was **false weight**: it is one
> person being consistent across two projects, which is evidence about the
> *author's* instincts, not about the design being forced. Struck
> throughout. What survives as genuine evidence is a shorter list, and it
> is worth knowing which is which:
> - **Mechanical facts** — the 0.9 probe results; what CORE ratifies.
> - **External empirical data** — rowan's 1,950-migration survey; rowan's
>   naive-agent guessability tests.
> - **Genuinely independent agents** — e.g. the two EOF reviewers who
>   never saw each other.
> - **What Joseph reached for by hand before any theory** (§1, December
>   examples) — *not* independent, but a real usability datum about the
>   primary author, and arguably the strongest signal available for a
>   notation whose point is being pleasant to write.
>
> **The pattern behind the correction, since it recurred three times in one
> session and future readers will have the same reflex:** I kept reading
> *design intent* as *independent convergence*. Rowan's DSL matching a udon
> position; the December examples matching CORE's identity model; the
> element suffixes fitting a schema's required/optional need — each felt
> like separate paths meeting, and each was **one designer being
> consistent with himself over eight months**. Joseph, on the suffixes:
> *"I absolutely put those in the syntax because I had schemas on my mind.
> This is you catching up with me to help me catch up with me."* The
> fitness in all three cases is **real and load-bearing** — a design whose
> parts were built for each other is *better*, not worse. But it is
> evidence of **coherent authorship**, not of a forced solution, and it
> carries none of the corroborative weight that genuine independence would.
> When this document says a thing "fits," assume intent until shown
> otherwise.

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

**The deferral, stated (Joseph, 2026-07-16)** — this is the lane's actual
status and it is not "unexplored": *"path, schema, and dialects were all
**deferred so we could get the parser core working**, which is what we've
done today until this session where I'm letting us pre-explore a bit."*
So the schema layer is **deliberately postponed work with a completed
prerequisite**, not a blank page. Three consequences for whoever reads
this next:

1. **The prerequisite is now met.** The parser core is compliant
   (`core-v0.9.0` pending only densification + rulings), which is what the
   deferral was waiting on.
2. **The deferral is why the December DSLs went quiet**, not disinterest —
   and why they are *still the state of the art* eight months later
   (§7). Nothing superseded them; nothing was allowed to.
3. **This session is explicitly pre-exploration** — *"gathering up the
   resources"* — not design. §5's design note is the *next* session's job,
   with more room to think (his framing). **Do not converge here.**

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

### The December 2025 hand-written attempts — READ THESE FIRST

`examples/archema-operata.udon` (238) · `examples/operata-intent-graph.udon`
(118) · `examples/schema-dsl.udon` (256) ·
`examples/ash-like-{billing,inventory,support}.udon` — Dec 2025.

**These are the most important artifacts in the schema lane and I nearly
reasoned past them from a filename.** They are not sketches: they are a
complete, working, Ash-shaped schema DSL in UDON, hand-written by Joseph
*before any theory* — and the causal arrow runs backwards from what I first
assumed. Joseph (2026-07-16): *"that's why I resurrected udon after
creating rowan and iterating on it for a while."* **Rowan's Ruby-DSL
fatigue is why udon came back.** These files are the thing he came back
*for*.

The spelling — and it is **better than anything proposed since**, including
mine:

```udon
|attr[id].uuid8 :primary true
|attr[slug].string :allow-nil false
|attr[actionability].atom :default active :one-of [active ongoing resource archived]
|identity[unique-slug] :keys [slug] :eager-check true
|has-many[children] :destination operata.intent :inverse-of parent
```

Four moves I had not considered, all of them 0.9-safe:

1. **Type is a TRAIT** — `.uuid8` / `.string` / `.text` / `.atom` /
   `.datetime` / `.integer`. Not `:type string`, not `|type[email]`.
   **CORE already blesses this**: *"Classification doubles as lightweight
   typing even when no behavior is attached to it."* Ratified *and*
   reached-for. It also dissolves Piece 2 (§1) without argument.
2. **Constraints are plain attributes with values** — `:primary true`,
   `:allow-nil false`, `:default active`, `:one-of [...]`. So the split is
   clean and legible: **trait = what it is; attribute = how it's
   constrained.**
3. **The blocks *are* the layers.** `|attributes` / `|identities` /
   `|relationships` (schema) vs `|actions` / `|queries` / `|graph`
   (behavior). §4.1's "constrain, don't behave" cut is **already drawn in
   his file, as block names** — which is a better argument for it than my
   reasoning was, and also a correction: the *document* legitimately holds
   both. A rowan resource definition = the schema blocks + the behavior
   blocks. UDON's schema layer is the former; rowan's dialect adds the
   latter.
4. **`!:rb:` escape hatches, deliberately placed** — *"Escapes for time and
   argument plumbing"*, *"Higher-level query helpers live in Ruby"*. The
   DSL doesn't pretend to express everything; it names its own boundary.
   (Also: `:arguments [claimer]` + `|change :set-claimed-by !{claimer}` —
   interpolation as argument plumbing; and in the intent-graph,
   `|edge[prepares] :from child :to parent :when :relationship == prepares`
   — a predicate expression in value position.)

**⚠ A name collision worth catching early:** this DSL's `:one-of [a b c]`
is an **enum on one attribute's value**. Rowan's `one_of do present :x;
present :y end` is **XOR across attributes** (the polymorphic-FK
constraint). Same name, different constraints. One of them has to move.

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

### Read first-hand — batch 2 (2026-07-16)

**`lib/archema/resource/constraints.rb`** — four constraints, each stated
with its JSON Schema mapping *in the header table*: `one_of`→`oneOf`,
`any_of`→`anyOf`, `when_value`→`if/then`,
`dependent_required`→`dependentRequired`; sub-predicates
`present`/`required`(alias)/`absent`/`equals`. Its own framing: *"JSON
Schema has richer constraint vocabulary than RDBMS, so we model
constraints here and project to SQL where possible."* **What I like — and
it's the finding that matters:** the DSL is **block-structured**, and the
blocks map to UDON element-form *directly*:

```ruby
one_of do            #  →   |one-of
  present :post_id   #  →     |present :post-id
  present :photo_id  #  →     |present :photo-id
end                  #
```

That is **Piece 3's sketch, arrived at independently and then built** —
and it lands in element-form, which is the 0.9-survivable spelling (§4.4).
The strongest evidence yet that the element-form spine is right: rowan's
Ruby is already shaped like the UDON it was craving.

**`lib/archema/resource/versioning.rb`** — **the pragma already exists,
in production, elsewhere.** `schema_id "autopax-agent-card"` +
`schema_version "2.0.0"` → **`_schema: type/version` embedded in the
document itself** — self-describing, per-document. Plus
`backward_compatible_with "1.0.0", "2.0.0"`, `upcast from: "1" do |data|
… end` (migrate-on-read, non-destructive, Protobuf/Avro-ish), and
**per-field evolution metadata**: `attribute :session_id, :uuid8,
since: "2.0.0"`, `attribute :legacy_tags, :array, deprecated: "3.0.0"`.
**What I like:** the whole model fits on one screen (header 18–52), and
its worked examples are `autopax-agent-card` and `chronica-entry` — **real
documents from this ecosystem**. So `spec/TODO-SPEC-OTHER.md`'s pragma
item isn't greenfield: rowan has a shipped answer, and UDON's
filename-designator idea (`<name>.<schema>.udon`) is the same fact moved
from the body to the filename. *Worth deciding deliberately: designator,
in-body pragma, or both.*

**`lib/archema/resource/evolution_context.rb`** — the operation
vocabulary, confirmed: `add_field` · `rename_field(to:)` ·
`split_field(into:, using:)` · `merge_fields(into:, using:)` ·
`transform_field(using:)` · `remove_field` — captured, applied
**atomically**, and **each registers its inverse upcast**
(`register_upcast!`) so old data still reads. That last property is the
whole trick: evolution is declared *once*, forward and backward fall out
together. Nothing else in the survey does this.

**`docs/VISION-drafts.md` §Empirical Validation (2025-12-19)** — 13
zero-context tests, naive agents asked to guess the API. **The most
directly reusable thing in rowan**, and it cuts three ways:

1. **Two of our candidate names are validated.** `was:` beat `alias:`
   (*"alias implies forward, `was` implies backward"*), and the **reverse
   test** — show the syntax, ask for an interpretation — got `field :email,
   was: :username` → *"renamed field for migration/backwards
   compatibility"* ✓ and `one_of :phone, :email` → *"XOR validation:
   exactly one must be present"* ✓. Both self-documenting.
2. **A methodology worth stealing outright: reverse testing.** Not "can an
   agent guess the syntax" but *"shown the syntax, does an agent read it
   correctly?"* For a schema layer this may be the **more relevant test** —
   schemas live in the repo and get *read*, not guessed. Its conclusion:
   *"Archema's novel syntax is self-documenting. Even without examples,
   agents can infer meaning from the syntax itself."*
3. **⚠ It complicates §4.4 (the element-suffix spine).** Under *Novel
   Features*: for optional fields, agents expected **`optional: true`
   (explicit keyword)**, not **`:optional` (a symbolic flag)**. UDON's
   `|field[date]?` is a symbolic flag. So the empirical data mildly cuts
   *against* the suffix spelling I've been arguing for — though the reverse
   test suggests it would still *read* correctly, and `?`-as-optional has
   enormous prior exposure (regex, TypeScript, GraphQL). **Guessability and
   readability are different axes, and rowan's own data separates them:**
   agents did *not* guess `one_of`, but read it perfectly. Since schemas
   are read far more than invented, readability probably dominates — but
   that's an argument, not a measurement, and the harness could settle it.

   The meta-lesson, verbatim, and it generalizes past Rails: *"'Intuitive'
   is not what should be obvious but what **is** obvious based on prior
   exposure."* For a UDON schema DSL, the prior exposure is JSON Schema and
   RELAX NG — which is an argument for taking their vocabulary (§3) rather
   than inventing.
4. Adjacent gifts: agents invented **`as_of(date)`** for temporal queries
   ("elegant" — note for the temporal dialect / paths); and the companion
   **minimal-documentation experiment** ("what's the smallest set of
   examples that lets agents infer 95% of the functionality?") is the
   cheat-sheet question in `ux/TODO-AGENT-UX.md`, already run once with a
   method attached.

### Queued — remaining

1. **`lib/archema/resource/attributes.rb`** (1091) — three bands only:
   16–36 (the flag + evolution-metadata vocabulary at a glance:
   `:optional/:required/:private/:sensitive/:readonly/:immutable`;
   `was:/was_type:/since:/deprecated:/removed:`), 448–600 (the `field`
   dispatcher — how constraint separates from relationship), 746–1030
   (primary-key DSL incl. composite at ~992).
2. ~~`docs/msc/plan-document-schema-constraints.md` Open Questions~~
   **read 2026-07-16 — see §9.** (Rest of the 469-line plan still queued:
   the DSL-keyword table at 72–80 includes the unbuilt `all_of` /
   `not_schema`.)
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
- **The two Joseph was actually looking at in Dec 2025** (recovered
  2026-07-16 — he named `schemacop` in `schema-dsl.udon`'s own conventions
  block, and remembers `yq` as concurrent reading):
  - **schemacop** (Ruby) — the cited precedent for
    *optional-by-default*, and the reason `schema-dsl.udon`'s bare
    `|type[name]` means optional while `!` means required. Its v3 DSL is
    block-structured and type-first (`str!`, `int?`, `hsh { … }`,
    `ary { … }`) — **which is visibly where `|str[username]!` comes from.**
    Worth reading directly: it is the nearest living ancestor of the
    element-typed spelling, and its own choices (why optional-by-default,
    how it handles `ary`/`hsh` nesting) are pre-argued.
  - **`yq`** — not a schema language at all, but the *query/transform*
    side of the same problem, and the reason it was in the room is
    probably udon-paths, not schemas. Its lesson for us is the same one
    semgrep/ast-grep teach: **the expression should look like the data it
    addresses.** Cross-link: `udon-paths.md`, and the adjudication packet.
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

**10. Where does the schema physically live?** *(Added 2026-07-16 —
Joseph's catch, and the family my first survey missed entirely.)*

| locus | examples |
|---|---|
| **Separate document** | JSON Schema, XSD, RELAX NG, `.proto`, CUE, schema-dsl.udon |
| **In the host language** | Zod/io-ts, Ecto, ActiveRecord, rowan's Ruby DSL |
| **In the data, as a field** | rowan's `_schema: type/version`; Avro's embedded writer schema |
| **In the filename** | UDON's `<name>.<schema>.udon` designator |
| **In comments** ← *the missed family* | **Ruby's `rbs_inline` (`# @rbs`)**, YARD (`# @param`), Python's `# type:` comments (PEP 484), TypeScript's JSDoc `/** @type */`, Go's struct tags (metadata smuggled in a string), Rust's `#[serde(...)]` attributes |

**The irony worth naming:** rowan's own source is comment-typed — every
file I read this session opens with `# rbs_inline: enabled` and carries
`# @rbs` annotations beside the Ruby. So the project whose Ruby-DSL fatigue
started all this is *itself* using the comment-locus for its type layer,
and I read past it a dozen times.

### Where that leaves UDON

**Occupied — don't reinvent:** constraint vocabulary (take JSON Schema's;
rowan proved the mapping), grammar/cardinality (RELAX NG compact is the
reference; CORE's suffixes already claim it), evolution (Avro's
reader/writer + rowan's upcast).

**Unclaimed, in rough order of value:** mixed-content constraint (prose ⊃
structure ⊃ prose, fractal) · the enforcement-cadence dial as a *declared*
property · prototype-like/exemplar as a lifecycle (CUE is the nearest
ancestor) · gradual constraint · transition validity for documents.

### ⚠ The comment-locus option — a fourth candidate, and possibly the one

*(Opened 2026-07-16 by Joseph in a single sentence — "we haven't even
talked about things like Ruby and other languages do all the time —
comment-based special typing and stuff." Recorded at length because it may
dissolve two problems I'd flagged as mechanism-less, and because **it
parses today**.)*

**UDON is unusually ready for this**, for three reasons that are already
ratified:

1. **Comments are a first-class tier of voice**, by design — the README
   lists them beside elements and attributes, not as detritus.
2. **Comments are events, not discards.** CORE: *"Comments are emitted as
   events, not discarded. The consuming layer decides whether to keep or
   strip them. This enables use cases like documentation extraction, TODO
   tracking, or comment-aware transformations."* A comment-consuming
   schema layer is *the use case CORE names*.
3. **`;{…}` inline comments already exist**, so annotation can sit beside a
   value without touching it: `:username alice ;{@str :max 32}` is legal
   0.9 **today** (unprobed — see the gap list).

What it would buy, and these are exactly my open problems:

- **Gradual constraint gets a mechanism, not an argument.** Annotate the
  fields you want constrained; leave the rest alone. The unannotated are
  free *by construction* — there is no "absence of constraint" to
  interpret, because absence is literally absence. §4.5's missing mechanism.
- **Soft regions become visible in the source.** Prose is unannotated =
  soft; annotated = hard. The fractal boundary stops being a schema
  question and becomes a *typographic* one — you can *see* it.
- **Schema-by-exemplar becomes trivial** rather than clever: you annotate
  the exemplar *in place*, and the exemplar *is* the schema. No inference
  step, no separate artifact to drift.
- **Aspirational binding gets cheap**: annotate what you *wish* were true;
  nothing enforces until something does.
- **Zero data-model pollution** — the schema never appears in the tree the
  consumer sees.
- **It composes with the other loci** rather than competing: a separate
  `schema-dsl`-style document for the contract; comment annotations for
  the local, the gradual, the in-progress.

**And Joseph was already reaching for it in January**: Piece 13's
uncertainty markers (`;?` uncertain, `;??` very uncertain, `;!` reviewer
attention) are *comment-locus annotations*. A `;@`-family for schema would
be the same instinct, one aisle over.

**Honest costs / open questions:** comments are *inert by ratified rule* —
making a subset semantic is exactly the "escape the comment tier" move that
tends to end badly (cf. every `# noqa` / pragma-comment ecosystem);
tooling must strip-preserve them (the edit tool's round-trip must not eat
them); there's a real question whether an annotation *about* a value should
be positionally adjacent (`;{…}` after) or a block above; and CORE's
warning `CommentMissingFollowingSpace` and the framed-` ; ` rules mean the
lexical shape wants care. **None of these is a probe away from an answer —
they're a design conversation.**

### The plural-implementations posture (Joseph, 2026-07-16)

*"The options we have available are so plentiful, and we have the coding
capacity to do more than one approach."* Worth writing down as a standing
instruction to this lane: **the goal is not to pick the winner.** Four loci
(separate document / trait-typed / element-typed / comment-annotated) are
all live, all cheap to prototype against the same corpus, and the harness
can A/B them empirically (§3 axis 2, rowan's reverse-testing method). The
design note's job is to **frame the options well enough that they can be
built and measured**, not to argue one into place. Convergence is what the
evidence is for.

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
4. **The spelling: Joseph's December DSL already won, and my proposal
   loses on its own terms.** Probe-verified: Piece 1's `:date? date` is
   dead under 0.9 (flag `date?`=true + re-owned text, which then poisons
   every following attribute line into prose). I proposed
   `|field[date]? :type date`. **The December DSL is better**:
   `|attr[date].datetime :allow-nil true` — trait-as-type,
   constraints-as-attributes (§1). And my suffix-for-optionality idea loses
   **twice over**: rowan's agent tests say agents expect an explicit
   keyword (`optional: true`) over a symbolic flag, *and* Joseph's own hand
   — the strongest usability datum available — reached for `:allow-nil
   false`, not `|attr[slug]?`. Two strikes, from opposite directions.
   *What survives*: element-form itself, and the element **suffixes** —
   but for a **different job** than I assigned them. Which is §4.8.
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

8. **THE REAL QUESTION — sharper than I first framed it, and only visible
   after reading all three December files: is the type the *element name*
   or a *trait*?** Joseph wrote **three** spellings, and the two December
   ones are one day apart:

   | | spelling | type lives in | required/optional | lineage |
   |---|---|---|---|---|
   | **`schema-dsl.udon`** (12-23) | `\|str[username]!` `:min 3` | **the element name** (`str`/`int`/`bool`/`arr`/`obj`/`any`/`ref`) | **the suffix** (`!` req, `?` opt, bare = opt — *"like schemacop"*, his note) | JSON Schema |
   | **`archema-operata.udon`** (12-24) | `\|attr[slug].string :allow-nil false` | **a trait** | *(not expressed — `:allow-nil` is a different axis, see below)* | Ash / rowan |
   | **Piece 1** (Jan) | `:author! string` | an attr value | the key's suffix | RELAX NG-ish |

   **Correction to my own §4.4: the suffix does not "lose twice."** I had
   `schema-dsl`'s `|str[display_name]?` and `archema-operata`'s
   `:allow-nil false` filed as competing answers to one question. **They
   answer two different questions, and CORE already ratifies the
   distinction** — its *Absent vs Nil vs False* section: *"Absent: key not
   present at all. Nil: key present, value explicitly 'no value'."*
   - `!` / `?` on the field = **presence** (must this key exist?)
   - `:allow-nil false` = **nullability** (may its value be nil?)

   Both are needed; Joseph wrote each where it belongs; rowan's
   agent-expectation datum (`optional: true` over `:optional`) applies to
   the *nullability* axis, not the presence one. My "two strikes" was a
   category error.

   **So the live fork is narrower and better-formed:**

   - **Type-as-element-name** (`|str[email]! :format email`) — reads
     beautifully; types are first-class and a dialect can add one; the
     suffix falls naturally on the field. But the schema's shape is
     **inverted from the document's**: in a document `|user[alice]` means
     element=`user`, key=`alice`; in this schema `|str[username]` means
     element=*type*, key=*name*. The schema stops looking like the thing it
     describes.
   - **Type-as-trait** (`|attr[slug].string`) — uses UDON's own
     element/key/trait roles *natively* (thing / identity / classification),
     which CORE blesses (*"classification doubles as lightweight
     typing"*), and keeps the schema shaped like a UDON document. Costs
     verbosity, and leaves the type's meaning positional by convention.

   The tie-breaker candidate: UDON's stated aesthetic elsewhere is
   **"paths look like the UDON they navigate"** and "the schema *is* a UDON
   document." That argues for trait-as-type. The counter-argument is that
   `|str[email]! :format email` is simply nicer to read, and readability is
   the axis the harness can actually measure (§3 axis 2, reverse testing).
   **This is the design note's central question, and it is A/B-able.**

9. **`schema-dsl.udon` also already contains things I'd listed as missing.**
   Block-form composition as elements (`|one_of` / `|any_of` / `|all_of` /
   `|is_not` — matching rowan's block DSL shape); `:when ssl` for
   conditional presence (JSON Schema's if/then); `|ref user` and
   `|ref[owner] user` for type reuse; anonymous inline types for array
   items (`|arr[tags]?` + child `|str :max 20`); **and a meta-schema**
   (`|schema[udon-schema]` — "schemas all the way up", Piece 11, already
   drafted). Its constraint vocabulary is JSON Schema's, near-complete:
   `:min` `:max` `:min_length` `:pattern` `:format` `:enum` `:default`
   `:multiple_of` `:when`. **The schema layer is much less greenfield than
   §4's framing implies** — the first design-note draft should probably
   start by *diffing these three files against 0.9* rather than proposing.

10. **⚠ Name collision, now three-way:** `:one-of [a b c]`
    (archema-operata) = **enum on one attribute**; `|one_of` (schema-dsl) =
    **union of types**; rowan's `one_of do present :x end` = **XOR across
    attributes**. Three constraints, one name. Whichever survives, the
    other two need names — and `:enum` already exists in schema-dsl for the
    first.

**Honest state: not nearly there — but the ground is much better mapped
than four hours ago, and mostly by Joseph in December.** §4.8 is the
question the design note must answer; §4.9 says the answer may be mostly
editorial. What survives of my own contribution: the field/CORE-derived
corrections (Piece 1 is dead under 0.9; presence ≠ nullability), the
constraint-only-because-typing-is-dialects argument (which
**trait-as-type may moot entirely** — if the type is a trait, is it also a
dialect ref?), open-world/soft-by-default (still an argument, no
mechanism), and the exemplar/aspirational/profile lifecycle.

---

## 5. Next

1. ~~constraints → versioning → evolution_context → VISION empirical~~
   **done 2026-07-16** (§2, batch 2).
2. The remaining rowan queue (attributes bands; the constraints *plan*'s
   open questions; differ; safe-RDBMS-evolution's Core Insight;
   tool_export; the three ash-comparison sections).
3. Autopax ADR-010 (schema-derived agentic tools).
4. **Two things the reading turned up that want Joseph, before or during
   the design note:**
   - **The pragma is not greenfield.** Rowan ships `_schema: type/version`
     *inside the document*; UDON's `<name>.<schema>.udon` designator is the
     same fact in the filename. Designator, in-body pragma, or both? (The
     aspirational-designator idea only works if the filename is at least
     *a* carrier.) → `spec/TODO-SPEC-OTHER.md`, `spec/TODO-SPEC-CORE.md`.
   - **Reverse-testing the DSL** (show syntax → ask for interpretation) is
     cheap, already has a method in rowan, and would settle §4.4's
     suffix-vs-keyword contest with data instead of taste. It also belongs
     to `ux/TODO-AGENT-UX.md`'s harness rebuild — same instrument.
5. Then a **design note** in the register of `attribute-model-2026-07.md` —
   reasoning included, for Joseph to ratify from rather than re-derive.
   Its job is **not** to pick words (the harness can settle those — §3
   axis 2, and rowan's reverse-testing method). Its job is to answer
   **§4.8**: field-based, content-model-based, or a named hybrid — and
   where the seam falls. Probable spine: Joseph's December spelling
   (element-form, trait-as-type, constraints-as-attributes); his block
   names as the schema/behavior seam; the JSON-Schema composition
   vocabulary for cross-field constraints; open-world/soft-by-default;
   evolution via upcast + `was:`/`since:`; the profile dial; **and a worked
   schema for `test/scenarios/corpus/`** as the honesty test — seven
   documents, six genres, written by someone who wasn't designing the
   schema, and content-model-shaped where rowan is field-shaped.

---

## 6. File index — what's been read, what hasn't, and when it's from

*Status vocabulary:* **read** = first-hand, in full · **partial** = named
bands only · **distilled** = read by a delegated agent, its full
distillation on record, I have highlights · **scouted** = an agent mapped
it; I have its shape, not its text · **queued** = identified, unread ·
**⚠ unread** = *has been cited or leaned on without being opened* — the
honest gaps.

### In-repo (`~/src/udon`)

| File | Date | Status | Carries |
|---|---|---|---|
| `spec/CORE.md` | 0.9.0-alpha.1 | **read** | The authority. Assigns the schema layer its job in its own text ("Constraint… a schema's job"; "forbidding a multi-valued `$key` is a schema concern"); ratifies trait-as-lightweight-typing and the two-clause suffix sentence (§4.8). |
| `design/examples/archema-operata.udon` | **2025-12-24** | **read** (≈130/238) | **The most important artifact in the lane.** The working DSL: trait-as-type, constraints-as-attributes, blocks-as-layers, `!:rb:` escapes. |
| `design/examples/operata-intent-graph.udon` | 2025-12 | **partial** (40/118) | The query/graph layer; `|edge :when :relationship == prepares` (predicate in value position). |
| `design/examples/schema-dsl.udon` | 2025-12-23 | **read** | **The third paradigm: type-as-element-name** (`\|str[username]!`), JSON Schema's vocabulary in UDON, suffix for presence, block-form composition (`\|one_of`/`\|all_of`/`\|is_not`), `\|ref` for reuse, `:when` for conditional presence, **and the meta-schema** (Piece 11, already drafted). Cites *schemacop* as its optionality precedent. **0.9-clean** (§7). |
| `design/examples/ash-like-billing.udon` (126) · `ash-like-inventory.udon` (106) | 2025-12-24 | **read** | **The 4th variant — Elixir-flavored**, not "more of the same": `!:ex:` escapes and `^arg` pin-style argument refs (vs archema-operata's `!:rb:` + `!{arg}`); resource-level storage mapping (`:table`/`:primary-key`/`:timestamps true`); **`:unique true` inline** competing with the `\|identities` block; `\|validations` w/ `:rule "…"` strings; `\|policies` w/ `:effect allow`; `\|calculations` w/ `:expr "sum(lines.amount)"`; `:accept [...]` on actions. See §7. |
| `design/examples/ash-like-support.udon` (107) | 2025-12-24 | **skimmed** | Presumed same family as billing/inventory — *and that presumption has failed three times now.* |
| X
| `design/udon-schema-exploration.md` | Jan 2026 (committed 07-08) | **read** | The thirteen puzzle pieces + 16 open questions. Content-model-flavored (§4.8). |
| `design/udon-guarantees.md` | Jan 2026 (committed 07-08) | **read** | Guarantee ladder; Casual/Careful/Critical profiles; the gatekeeper problem; the append-only-log patch ancestor. |
| `design/udon-agentic.md` | Jan 2026 | **read** | `validate` + `infer` are the schema's tool surface; `infer` is exemplar's read-side twin; Future Directions already lists schema-inference. |
| `design/udon-paths.md` | Jan 2026 (banner 07-16) | **read** | Selection — constraints that quantify ("every `||endpoint`") need it. |
| `design/agentic-ux-principles.md` | 2026-07-16 | *(authored here)* | P7: the file's own law governs; declared-is-theater-until-honored. |
| `design/attribute-model-proposal-3.md` (494) + `-substrate.md` (479) | 2026-07-15/16 | **read** (proposal §0–§2 + structural sweep of both) | The 0.9 model's ratification carriers. **Fully drained — zero `[OPEN]` items remain** (only the legend row), so CORE carries everything and these are archaeology now. Two live threads for us: the **"kind" footnote** (§8 below) and the **positional scalar/blob rule** (§8). Its segment-array wire framing was **superseded by R5's flat wire** (recorded in the changelog). |
| `design/udon-ast.md` | Jan 2026 | **⚠ unread** (751) | Type-scoped `(element-name, key)` uniqueness — **which I've cited repeatedly as the `at`-uniqueness predicate** — plus ReferenceIndex, Document views. Known only through a delegated distillation. |
| `design/composite-types.md` | 2026-07 | **queued** (3K) | `<…>` nesting; matters if type-refs are dialect-refs. |
| `design/GRAMMAR-CONSTRAINED-GENERATION.md` | Dec 2025 | **distilled** | Schemas as generation constraints; argues for machine-readable schema. |
| `test/scenarios/corpus/operata.domain.udon` | 2026-07-16 | **⚠ unread** | *Already a schema-flavored document in 0.9 idiom.* Known only from the building agent's report. |
| `test/scenarios/corpus/operata-live.workspace.udon` | 2026-07-16 | **⚠ unread** | The mutation target; integer keys beside legacy string keys. |
| `test/scenarios/` (rest) | 2026-07-16 | **distilled** | The requirements document nobody meant to write (§1); `schema-guard-before-write`; `SchemaViolation`. |
| `spec/TODO-AUX.md` · `TODO-SPEC-CORE.md` · `TODO-SPEC-OTHER.md` · `TODO-UTILS.md` | live | **read** | The lanes: schema/paths/patch; multiple keys; pragma; guard + cadence. |

### rowan (`~/src/rowan` — internals still say `Archema`)

| File | Status | Carries |
|---|---|---|
| `lib/archema/resource/identities.rb` | **read** | Surrogate + natural, built: PK (composite ok) **plus** named plural identities, each an independent unique key-set, with eager/pre-check timing. |
| `docs/dev/adr-003-document-schema-first.md` | **read** | Constraint vocabulary from JSON Schema; schema-layer validation canonical; per-store best-effort projection → maps to the enforcement-cadence dial. |
| `docs/exp/schema-evolution-patterns.md` | **read** | 1,950 real migrations → six ladders w/ asymmetry; only 8.5% asymmetric; **"natural keys are additive."** External empirical data. |
| `lib/archema/resource/constraints.rb` | **partial** (header + DSL) | `one_of`/`any_of`/`when_value`/`dependent_required` + JSON-Schema mapping per constraint; block-structured. |
| `lib/archema/resource/versioning.rb` | **partial** (1–60) | **`_schema: type/version` in-document = the pragma, shipped.** `upcast from:`, compat declarations, per-field `since:`/`deprecated:`. |
| `lib/archema/resource/evolution_context.rb` | **partial** (ops + header) | add/rename/split/merge/transform/remove_field, atomic, **each registering its inverse upcast**. |
| `docs/VISION-drafts.md` §Empirical (303–400) | **partial** | Naive-agent guessability; `was:` beat `alias:`; **reverse testing** as a method; "intuitive = prior exposure". External empirical data. |
| `lib/archema/resource/attributes.rb` | **queued** (3 bands of 1091) | The flag + evolution-metadata vocabulary at a glance; the `field` dispatcher; composite-PK DSL. |
| `docs/msc/plan-document-schema-constraints.md` | **queued** (469) | **Its Open Questions (427–450) are live forks we may re-tread**: strictness levels, schema inheritance, constraints-on-relationships. |
| `lib/archema/schema/differ.rb` | **queued** (header) | Transition-validity analog: classifies changes, raises `:possible_rename`/`:type_change` as decisions, not guesses. |
| `docs/dev/plan-safe-rdbms-evolution.md` | **queued** (Core Insight ~45) | Database-as-Truth vs transition-periods vs **Resource-as-Truth**; expand/monitor/contract. |
| `lib/archema/agentic/tool_export.rb` + `docs/sys/agentic/tool-export.md` | **queued** | Schema→tool-definitions + JSON Schema from one model. **Working today.** |
| `docs/msc/archema-ash-comparison-research.md` | **queued** (3 sections of 1619) | Cat. B (evolution), Cat. M (JSON-Schema composition), Exec summary (8 contributions vs 15 gaps). |
| *(every `lib/archema/**/*.rb`)* | **observed in passing** | **`# rbs_inline: enabled` + `# @rbs` annotations** — rowan's own type layer lives in the **comment locus** (§3 axis 10). Read past a dozen times before noticing. |
| `lib/archema/types.rb` | **queued** (296) | The concrete type/constraint catalog (dry-types). |
| `lib/archema/resource/relationships.rb` | **queued** (698) | Cardinality options `min_required`/`max_allowed`, `managed:`. |
| `docs/usr/10-schema-evolution.md` | **queued** (238) | The user-facing narrative + **branch-safety / divergent-evolution conflict detection** + decision-log audit trail. |
| `docs/dev/adr-004-programmatic-schema-api.md` | **queued** | Ruby-API-first; the Erlang/OTP mental model for runtime evolution. |
| `KEY_FILES.md`, `MAP.md`, `LEXICON.md` | **scouted** | The index; Track 1 (Ash parity) / Track 5 (safe RDBMS evolution). |
| *dead ends (scouted, ruled out)* | — | `.archema/schema_history/*` (test artifacts) · `docs/ref/critical-synthesis.md` (philosophy) · `docs/ref/patterns/*` (Ambler catalog) · `tmp/ash/` (vendored real Ash). |

### autopax (`~/src/autopax`)

| File | Status | Carries |
|---|---|---|
| `docs/ADR/010-markdown-parsing-and-validation.md` | **queued** (399) | **"P3: Schema-Derived Agentic Tools"** + phase-4 tool generation. The schemas→tooling bridge. |
| `docs/ADR/migration-proposals/003-workflow.md` | **queued** | Agentic Workflow Principles (+ archived analysis companion). |

### The honest gap list

1. **`design/attribute-model-proposal-3.md` + substrate** — the 0.9
   ratification carriers, unread, while I reason about the 0.9 model daily.
2. **`design/udon-ast.md`** — unread, while citing its uniqueness predicate
   as the foundation of `at`.
3. ~~The three `ash-like-*.udon`~~ **read 2026-07-16 (§7)** — and they were
   a 4th variant, so "more of the same" has now failed *three* times as an
   assumption. `ash-like-support.udon` (107) skimmed only.
4. **`test/scenarios/corpus/operata.domain.udon`** — the one 0.9-idiom
   schema-flavored document in existence, known only secondhand.
5. ~~The 0.9 diff of the December spellings~~ **done 2026-07-16 — see §7.**
   Still to probe: the comment-locus forms (`:username alice ;{@str :max
   32}` and a block-comment annotation), so that option arrives measured
   rather than imagined.
6. **Timeline gap:** nothing between **Jan 14, 2026** (dormancy) and
   **Jul 8, 2026** (reboot) — six months where rowan kept moving and udon
   didn't. Rowan's Track-5 work may postdate every udon document here.

---

## 7. The 0.9 diff — probe results (2026-07-16)

Every December spelling run through the current parser. **Headline: the
schema DSLs survive; the expression sub-language is the casualty.**

| input | result | verdict |
|---|---|---|
| `\|str[username]!` + `:min 3` + `:pattern ^[a-z][a-z0-9_]*$` | `Name` · `Attr $key`/`BareValue username` · **`Attr $!`/`BoolTrue`** · `Attr min`/`Integer 3` · `Attr pattern`/`BareValue ^[a-z][a-z0-9_]*$` | **clean** ✅ |
| `\|is_not` + `:enum ["" " "]` | `ArrayStart` · `StringValue ""` · `StringValue " "` · `ArrayEnd` | **clean** ✅ |
| `\|calc[total].money :expr "sum(lines.amount)"` | `Attr $key`/`BareValue total` · `Attr $traits`/`BareValue money` · `Attr expr`/`StringValue` | **clean** ✅ |
| `\|when :actor-role == :accountant` | `Attr actor-role`/`BareValue ==` · `Attr accountant` · **`Error MissingAttributeValue`** · `Nil` | **ERRORS** ❌ |
| `\|filter :email == ^email` | `Attr email` · **`Text`** (the whole `== ^email` as a blob) | **degrades** ⚠ |
| `:fallback !{:ex: "Money.zero(:USD)"}` | `Attr fallback` · **`Text`** | **degrades** ⚠ |

### What this establishes

1. **`schema-dsl.udon` is 0.9-viable essentially as written** — and better
   than that: **its `!` suffix desugars to `Attr "$!"` + `BoolTrue`.**
   Required-ness lands on the exact designated attribute CORE reserves for
   it. `|str[username]!` *is* `|str[username] :'$!' true`, and a schema
   reading `$!` as "required" is precisely the reading CORE's Element
   Suffixes section describes. **This fitness is design intent, not
   serendipity** — Joseph, 2026-07-16: *"I absolutely put those in the
   syntax because I had schemas on my mind."* The suffixes were built for
   a schema layer before the schema layer existed; CORE's *"a schema might
   read `?` as optional, `!` as required"* is that intent surviving into
   the ratified text. The fitness is real; the coincidence is not.
2. **Regexes survive as bare values** — `^[a-z][a-z0-9_]*$` needs no
   quoting (no spaces → no blob → no boundary). That was the probe I most
   expected to fail.
3. **`archema-operata`'s trait-typed field line is clean** —
   `.money`/`.string` land as `$traits`, `:allow-nil false` as an ordinary
   attribute.
4. **The casualty is the expression sub-language, and only that.**
   `:when :actor-role == :accountant` doesn't degrade — it **errors**
   (`==` becomes the value; `:accountant` starts an attribute that never
   gets one). `|filter :email == ^email` degrades silently to a text blob.
   Which is *correct behavior*: those are expressions, expressions are
   DYNAMICS' territory, and the December files predate the
   dynamics/dialect boundary.
5. **Joseph hedged in December without knowing it.** The same files carry
   **both** forms: quoted (`:rule "email =~ /@/"`, `:expr
   "sum(lines.amount)"`) and bare (`|when :actor-role == :accountant`).
   **The quoted form is the 0.9-safe one** — it survives untouched as a
   `StringValue`. So the expression layer already has a working spelling
   in his own files; the bare form is the one that needs the dialect.
6. **`!{:kind: …}` in value position → `Text`, silently** — a *live use
   case* for an explicitly-open spec question. CORE: *"Whether the inline
   form can appear in value position is deferred with the rest of the
   inline-raw nailing."* `archema-operata` uses it
   (`:fallback !{:ex: "Money.zero(:USD)"}`). Route to
   `spec/TODO-SPEC-CORE.md`'s inline-raw item as evidence that the
   deferral has a consumer waiting.

### The 4th and 5th spellings (from `ash-like-*`, read 2026-07-16)

The three `ash-like-*.udon` are **not** "more of the same" — the
assumption that has now failed three times:

- **They're Elixir-flavored**, where `archema-operata` is Ruby: `!:ex:`
  escapes, and **`^arg` pin-style argument references** (`|filter :email ==
  ^email`, `:rule "on_hand + ^delta >= 0"`) — Elixir's pin operator — where
  archema-operata used `!{claimer}` interpolation. **Two argument-reference
  syntaxes.**
- **Storage mapping at the resource level**: `:table customers`,
  `:primary-key id`, `:timestamps true` — which `archema-operata` doesn't
  have (it puts `:store sqlite` on the *domain*). Puzzle Piece 9 (storage
  projection), already sketched twice, differently.
- **`:unique true` inline** — competing with `archema-operata`'s
  `|identity[unique-slug] :keys [slug] :eager-check true` block. **Two ways
  to say unique**, and they aren't equivalent: the flag is per-attribute,
  the block is a named multi-attribute key-set with check timing.
- **A `|validations` block** with rule-strings (`|validation[email-format]
  :rule "email =~ /@/"`), plus `|policies` with `:effect allow` +
  `|when …`, plus **`|calculations`** (`|calc[total-amount].money :expr
  "sum(lines.amount)"`) — three more blocks in the schema/behavior seam
  (§4.1) that `archema-operata` doesn't carry.
- `:accept [email name]` on actions; `|read[by-sku] :get true`;
  `|authorize :accounting-only` (an action naming a policy).

---

## 8. The attribute model's carriers — read 2026-07-16

`attribute-model-proposal-3.md` + its substrate are **fully drained**: a
grep for `[OPEN]` returns only the legend row. CORE carries every decision;
these are archaeology. Two facts from them matter here, and one absence
matters more.

**The absence: the 0.9 attribute model was designed with *zero* schema
awareness.** `grep -i schema` across both carriers returns **nothing** —
494 + 479 lines about the exact model a schema must constrain, with the
word never appearing. Meanwhile **CORE mentions schemas eight times**, and
three of those are load-bearing job-assignments to this lane:

- *"**Constraint** — what is allowed or required (cardinality, vocabularies,
  'no array-valued `$key`'). A **schema's** job. Proscription lives here,
  never in the core."*
- *"**Dialects are not schemas.** A dialect says what a value *means /
  types*; a schema says what is *allowed*. They never trade jobs."*
- *"what is allowed — e.g. forbidding a multi-valued `$key` — is a schema
  concern, never core."*

So the schema-awareness entered at **CORE drafting**, not in the model's
design. Two consequences, and they cut opposite ways:

1. **The schema layer inherits a model that never anticipated it** — which
   is *correct* (a model shouldn't be bent by every future consumer) but
   means we cannot assume any 0.9 affordance was built with schemas in
   view. Contrast **identity**, where the suffixes *were* (§7.1) — so
   0.9 is schema-aware in its *sugar* and schema-blind in its *attribute
   model*. Worth knowing which is which before leaning on either.
2. **The `:type` question gets sharper.** CORE draws "dialects type, schemas
   constrain — *they never trade jobs*" as a hard line. But
   `archema-operata`'s **trait-as-type** (`|attr[slug].string`) puts typing
   in the *schema* document. Is `.string` there a *dialect* reference
   (CORE's job-split honored), or is the schema typing (job-split
   violated)? **This is now the sharpest open question in the lane**, it
   is CORE-textual rather than aesthetic, and §4.2's
   "constraint-only-because-typing-is-dialects" position depends entirely
   on the answer.

**Two live threads the carriers leave us:**

- **The "kind" footnote** (proposal-3 §2.1, non-normative): *"an array of
  only text / text-reducible segments may later be treated as a soft
  'kind' distinct from a junk-drawer heterogeneous array — not required for
  0.8."* That is a **schema-shaped distinction**, deferred: a schema
  wanting to say "this attribute is a text blob" vs "this attribute is a
  list of values" needs exactly that kind. Nobody has picked it up.
- **The positional scalar/blob rule** (proposal-3 §2.1, substrate §S5): *"a
  **mid-line** bare value (more attrs still to the right) is a **scalar** —
  no unquoted spaces… Unquoted multi-word text is only for the **last**
  trailing value material on the line."* So **a value's legal spelling
  depends on its position on the line** — which any schema-authoring
  guidance, formatter, or generation-constraint artifact has to encode. It
  is also why `:rule "email =~ /@/"` (quoted) survives 0.9 where the bare
  form wouldn't (§7).

---

## 9. Rowan's five open questions ARE udon's — asked Dec 2025, still open

`rowan/docs/msc/plan-document-schema-constraints.md` §Open Questions
(427–450), read 2026-07-16. **This is the most useful page in rowan for
this lane**, because it is not answers — it is Joseph's own *unresolved*
forks in the constraint DSL, and four of the five are questions I had been
treating as udon-native discoveries. Verbatim, with the mapping:

| Rowan's question (Dec 2025) | Where I'd "discovered" it |
|---|---|
| **1. Validation strictness levels?** `strict` (reject) / `warn` (log but continue) / `permissive` (ignore) | **The Casual / Careful / Critical profiles** (`udon-guarantees.md`) **and** the udon-guard **enforcement-cadence spectrum** (`TODO-UTILS.md`). Same question, three names. |
| **3. Runtime vs load-time validation?** validate all on startup / lazy on first access / background job | **Survey axis 5, "enforcement locus"** — which I called *"almost nobody treats this as a declared property… probably novel."* He was asking it in December. |
| **4. External schema files?** store `.schema.json` alongside data, **or always generate from the definition?** | **Survey axis 10, "where the schema physically lives"** — the axis I'd just added as Joseph's catch. It was already his question. |
| **5. Constraint on relationships?** `one_of` on relationship refs, not just attributes; **cross-resource constraints** | **Cross-document referential integrity** — which `test/scenarios/corpus/archema.concept-matrix.udon` demands (cross-document `:in`/`:ref` joins) and which `udon-ast.md`'s ReferenceIndex anticipates. |
| **2. Schema inheritance?** *Can a Resource extend another's schema? How do constraints compose across inheritance?* | **⚠ NOTHING. I have no position, no note, no mechanism.** |

### What this changes

- **The design note inherits a question list, it doesn't start one.** Four
  of these are already load-bearing in this workbench under other names;
  the honest move is to *merge* them rather than let udon re-ask them in
  its own vocabulary and then "discover" the overlap a third time.
- **Question 2 is a real hole in my synthesis.** Schema inheritance /
  composition has no udon-side thinking at all — and UDON has an obvious
  candidate mechanism nobody has connected to it: **traits**. CORE's
  *Mixins* section already sketches trait-based attribute inheritance
  (`|.defaults` + `|database[prod].defaults`) and explicitly leaves
  resolution to the consumer. If a schema is a UDON document and traits
  classify, then *schema* inheritance may be the same mechanism as
  *document* mixins — which would be the kind of unification the
  exploration doc's closing instruction asks for ("let the elegant
  unification emerge"). **Unexamined. Flag for the design note.**
- **Rowan's Success Criteria include `Schema version lookup from document
  metadata`** — the pragma again (§2, `_schema: type/version`), listed as
  an acceptance test rather than an idea.
- **Its references are the ancestry, stated:** JSON Schema Draft 2020-12
  (core + validation) and **dry-types constraints** — so rowan's
  per-field constraint catalog (`:min`/`:max`/`:format`/enum-via-`values:`)
  is dry-types', and any udon type/constraint vocabulary inherits from
  there whether it means to or not.

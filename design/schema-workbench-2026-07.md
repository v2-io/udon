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

## 1. Sources — in-repo

*A file-by-file status ledger (date, read-status, one-line pointer) lives
in §6 for every file across all three trees; what follows here is the
material that earned more than a one-line pointer.*

### The January 2026 working docs (the direct ancestors)

Both were written in January, left uncommitted when udon went dormant, and
committed by Joseph on 2026-07-08 during the reboot ("Commit the January
2026 working docs"). The estate review called them "the newest thinking."

**`udon-schema-exploration.md`** (662 lines) — organized as **thirteen
numbered "Puzzle Pieces"**, and its own closing instruction is the brief
for whoever finishes it: *"Find the minimal coherent core. Let the elegant
unification emerge rather than forcing it."* Its last line: *"This document
is a workspace, not a conclusion."* The pieces, so nobody has to open it to
follow a reference:

| # | Piece | Read against 0.9 |
|---|---|---|
| 1 | Basic schema (RELAX-NG-compact-flavored: `:author! string`, `:date? string`) | **Probe-verified dead under 0.9** — see §7. The *cardinality idea* survives and is ratified elsewhere. |
| 2 | Type definitions (`\|type[email] :base string :pattern …`) | Contested by §4.2/§8 — may belong to dialects rather than schema. |
| 3 | Composition constraints (`one_of` / `any_of` / `when` / `dependent`) | Rowan already built this vocabulary (§2); reads as reusable. |
| 4 | Relationships (`belongs_to` / `has_many` / `through`) | Rowan's layer, not core schema — core says "this attr is a reference," rowan says what kind. |
| 5 | Actions (behavioral) | Rowan's resource layer, not schema (§4.1). |
| 6 | Policies (authorization) | Same. |
| 7 | Evolution (`was:` / `since:` / `deprecated:` / `removed:`) | Rowan has a more developed version (§2). |
| 8 | **Soft regions** (four candidate syntaxes for "prose allowed here") | No other surveyed system has this (§3, §4.6). Option D (absence = soft) is the reading I'd currently argue for, on principle rather than convenience — see §4.6. |
| 9 | Storage projection | Not schema — but its *shape* transfers to the enforcement-cadence dial. |
| 10 | Derivation targets (SQL DDL / JSON Schema / Ruby / API tools / docs) | Consumer concern; the tool-generation half is live in rowan already. |
| 11 | Meta-schema ("schemas all the way up") | Falls out of same-language self-description. |
| 12 | **Dialect declarations** (`!dialect …`, scoped switching, "dialect as lens") | The pragma's closest ancestor in this doc — schema + examples + valid/invalid tests in one file. |
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

`examples/archema-operata.udon` (238) · `examples/operata-intent-graph.udon`
(118) · `examples/schema-dsl.udon` (256) ·
`examples/ash-like-{billing,inventory,support}.udon` — Dec 2025.

These read, to me, as the most direct antecedent to a schema DSL in the
lane, and I initially read past them on the strength of their filename
alone — worth naming since a future reader could make the same mistake.
They are not sketches: a complete, working, Ash-shaped schema DSL in UDON,
hand-written by Joseph *before any theory*, and the causal arrow runs
backwards from what I first assumed. Joseph (2026-07-16): *"that's why I
resurrected udon after creating rowan and iterating on it for a while."*
Rowan's Ruby-DSL fatigue is why udon came back — these files are the thing
he came back *for*.

The spelling, verified accurate against the file (2026-07-16):

```udon
|attr[id].uuid8 :primary true
|attr[slug].string :allow-nil false
|attr[actionability].atom :default active :one-of [active ongoing resource archived]
|identity[unique-slug] :keys [slug] :eager-check true
|has-many[children] :destination operata.intent :inverse-of parent
```

Four things in it that I hadn't drafted myself, all of them 0.9-safe (§7):

1. **Type is a TRAIT** — `.uuid8` / `.string` / `.text` / `.atom` /
   `.datetime` / `.integer`. Not `:type string`, not `|type[email]`.
   CORE already states this directly: *"Classification doubles as
   lightweight typing even when no behavior is attached to it."* Ratified
   *and* reached-for. It also dissolves Piece 2 (above) without argument —
   though whether that dissolution is itself schema-work or dialect-work is
   still open (§4.2/§8).
2. **Constraints are plain attributes with values** — `:primary true`,
   `:allow-nil false`, `:default active`, `:one-of [...]`. The split is
   legible: trait = what it is; attribute = how it's constrained.
3. **The blocks *are* the layers.** `|attributes` / `|identities` /
   `|relationships` (schema) vs `|actions` / `|queries` / `|graph`
   (behavior). §4.1's constrain-don't-behave line is already drawn in his
   file, as block names — a better argument for it than reasoning from
   first principles would be, and also a correction: the *document*
   legitimately holds both. A rowan resource definition = the schema
   blocks + the behavior blocks. UDON's schema layer is the former;
   rowan's dialect adds the latter.
4. **`!:rb:` escape hatches, deliberately placed** — *"Escapes for time and
   argument plumbing"*, *"Higher-level query helpers live in Ruby"*. The
   DSL doesn't pretend to express everything; it names its own boundary.
   (Also: `:arguments [claimer]` + `|change :set-claimed-by !{claimer}` —
   interpolation as argument plumbing; and in the intent-graph,
   `|edge[prepares] :from child :to parent :when :relationship == prepares`
   — a predicate expression in value position.)

**A name collision worth catching early:** this DSL's `:one-of [a b c]`
is an **enum on one attribute's value**. Rowan's `one_of do present :x;
present :y end` is **XOR across attributes** (the polymorphic-FK
constraint). Same name, different constraints — see §4.10 for the full
three-way collision once schema-dsl.udon's `|one_of` is added.

### Adjacent in-repo docs the schema layer must not contradict

`spec/CORE.md` (the authority — see §6 and §8 for the sections that bear
directly), `udon-ast.md` (the substrate the schema constrains — type-scoped
`(element-name, key)` uniqueness, `$key`/`$traits`, `ReferenceIndex`),
`attribute-model-proposal-3.md` + `-substrate.md` (the 0.9 model's
ratification carriers — see §8), `udon-paths.md` (selection, which schema
constraints will need to reference), `agentic-ux-principles.md` (P7, "the
file's own law governs" — the schema's consumer contract), `composite-types.md`
(the `<…>` nesting direction, matters if schema type-refs are dialect-refs),
`GRAMMAR-CONSTRAINED-GENERATION.md` (schemas as generation constraints),
`udon-agentic.md` (`validate`/`infer` are the schema's tool surface;
`infer` is schema-by-exemplar's read-side twin, designed in January). Dates
and read-status for each are in §6.

### The scenario corpus — the requirements document nobody meant to write

**`test/scenarios/`** (2026-07-16, 1,645 lines, all parse-clean). Built for
the path/edit tool, but it constrains the schema layer just as hard, and
it's the only body of 0.9-idiom documents I know of:

- **`corpus/operata.domain.udon`** is already a schema-flavored document in
  0.9 idiom — flags, `:allow-nil? false`, interpolations, a same-line raw
  value. Someone (an agent, but still) has already answered "what does a
  constraint-ish UDON document look like under the current model" — though
  I haven't read this file myself yet (§6).
- **What the corpus demands a schema be able to say**, derived from what's
  in it: typed identity keys (`|intent[42]` beside `|intent["0042"]` —
  key type and uniqueness), stacked traits (cardinality over `$traits`),
  node-valued attrs (kind), `<…>` dates (dialect binding), flags (presence
  semantics), prose interleaved at every level (soft regions, live and
  unavoidable), cross-document `:in`/`:ref` joins (referential integrity
  across files).
- **`features/03-modifying`** contains a `schema-guard-before-write`
  scenario — an acceptance test for conformance-at-apply already exists.
- Its draft error vocabulary includes `SchemaViolation` alongside
  `PathNotUnique` / `PathNotFound` / `ReferencePlural` / `PreconditionFailed`.
- A schema for this corpus looks, to me, like the cheapest honest test
  available: seven documents, six genres, written by someone who wasn't
  designing the schema.

### The lanes carrying schema asks

`spec/TODO-AUX.md` (the home lane — schema/paths/patch, carries the
rowan-as-customer note), `spec/TODO-SPEC-CORE.md` (multiple keys — surrogate
+ natural; tuple keys already parse), `spec/TODO-SPEC-OTHER.md` (the
pragma — binds a document to its dialects + schema; the schema layer can't
be delivered without it), `TODO-UTILS.md` (the udon guard and its
enforcement-cadence spectrum; `udon fmt`, tabled).

---

## 2. Sources — rowan (`~/src/rowan`, formerly archema; internals still say `Archema`)

Scouted 2026-07-16. `KEY_FILES.md` and `MAP.md` are the index; MAP's
"Track 1: Ash Parity" and "Track 5: Safe RDBMS Evolution" are the relevant
status. Every file's status/date is in §6; what follows is what came out of
reading the files, not just locating them.

### Read first-hand

**`lib/archema/resource/identities.rb`** (187) — rowan already built
multiple-keys: a primary key (optionally composite:
`primary_key [:tenant_id, :local_id]`) plus named *identities* — plural,
each an independent unique key-set over attribute combinations, single or
composite, each generating a finder (`get_by_email` for single,
`find_by_<name>` for composite), with timing options (`eager_check` before
create vs `pre_check` before commit). What I like: it separates
*identity-for-lookup* from *identity-as-primary*, which is exactly the
surrogate/natural split; and the timing options are the enforcement-cadence
dial in miniature.

**`docs/dev/adr-003-document-schema-first.md`** (152) — the decision record
behind rowan's document-schema-first approach, and the clearest single
rationale I've found for how rowan's schema layer relates to storage.
*"Constraint vocabulary comes from JSON Schema, not RDBMS limitations…
Archema validation is canonical. RDBMS constraints are optional projections
that provide defense-in-depth, not the source of truth… Document stores are
first-class, not awkward adaptations."* What I like: the projection idea
maps cleanly onto UDON — constraints canonical at the schema layer, and the
*enforcement cadence* is the projection. Joseph's guard spectrum is
ADR-003's store-projection, one level up. Also the three-worlds framing
(RDBMS relations + document expressiveness + event-sourcing temporality)
and the polymorphic-FK dissolution via `one_of`.

**`docs/exp/schema-evolution-patterns.md`** (209) — 1,950 real Rails
migrations from 15 repos, analyzed into six evolutionary ladders, each with
a forward/backward asymmetry column: normalization (blob→columns→table),
cardinality (1→N→M:N), type-refinement (loose→strict), identity
(implicit→UUID→natural→composite), temporal (point-in-time→versioned→
event-sourced), constraint (permissive→strict). Only 8.5% of migrations are
asymmetric — part of why rowan bet on declarative+upcast over migration
scripts. What I like: the identity ladder is annotated *"natural keys are
additive"* — so Joseph's multiple-keys instinct matches the documented
normal direction of schema evolution in this dataset, not an exotic
feature. And the constraint ladder (permissive→strict, 14.1% of migrations)
reads as schema-by-exemplar's lifecycle, observed empirically.

### Read first-hand — batch 2 (2026-07-16)

**`lib/archema/resource/constraints.rb`** — four constraints, each stated
with its JSON Schema mapping in the header table: `one_of`→`oneOf`,
`any_of`→`anyOf`, `when_value`→`if/then`,
`dependent_required`→`dependentRequired`; sub-predicates
`present`/`required`(alias)/`absent`/`equals`. Its own framing: *"JSON
Schema has richer constraint vocabulary than RDBMS, so we model
constraints here and project to SQL where possible."* What I like: the DSL
is block-structured, and the blocks map to UDON element-form directly:

```ruby
one_of do            #  →   |one-of
  present :post_id   #  →     |present :post-id
  present :photo_id  #  →     |present :photo-id
end                  #
```

That is Piece 3's sketch, arrived at independently and then built — and it
lands in element-form, which is the 0.9-survivable spelling (§4.5). This is
evidence, not proof, that the element-form spine is workable: rowan's Ruby
is already shaped like the UDON it was craving.

**`lib/archema/resource/versioning.rb`** — the pragma already exists, in
production, elsewhere. `schema_id "autopax-agent-card"` +
`schema_version "2.0.0"` → `_schema: type/version` embedded in the document
itself — self-describing, per-document. Plus
`backward_compatible_with "1.0.0", "2.0.0"`, `upcast from: "1" do |data|
… end` (migrate-on-read, non-destructive, Protobuf/Avro-ish), and per-field
evolution metadata: `attribute :session_id, :uuid8, since: "2.0.0"`,
`attribute :legacy_tags, :array, deprecated: "3.0.0"`. What I like: the
whole model fits on one screen (header 18–52), and its worked examples are
`autopax-agent-card` and `chronica-entry` — real documents from this
ecosystem. So `spec/TODO-SPEC-OTHER.md`'s pragma item isn't greenfield:
rowan has a shipped answer, and UDON's filename-designator idea
(`<name>.<schema>.udon`) is the same fact moved from the body to the
filename. Worth deciding deliberately: designator, in-body pragma, or both.

**`lib/archema/resource/evolution_context.rb`** — the operation vocabulary,
confirmed: `add_field` · `rename_field(to:)` · `split_field(into:, using:)`
· `merge_fields(into:, using:)` · `transform_field(using:)` ·
`remove_field` — captured, applied atomically, and each registers its
inverse upcast (`register_upcast!`) so old data still reads. That
property — evolution declared once, with forward and backward falling out
together — doesn't appear elsewhere in what I've surveyed here.

**`docs/VISION-drafts.md` §Empirical Validation (2025-12-19)** — 13
zero-context tests, naive agents asked to guess the API. (Thirteen tests is
a small sample; read the conclusions below as directional, not as a
measured result.) It cuts three ways for this lane:

1. **Two of the candidate names get some support.** `was:` beat `alias:`
   (*"alias implies forward, `was` implies backward"*), and the **reverse
   test** — show the syntax, ask for an interpretation — got `field :email,
   was: :username` → *"renamed field for migration/backwards
   compatibility"* ✓ and `one_of :phone, :email` → *"XOR validation:
   exactly one must be present"* ✓. Both self-documenting, in this sample.
2. **A methodology worth reusing: reverse testing.** Not "can an agent
   guess the syntax" but *"shown the syntax, does an agent read it
   correctly?"* For a schema layer this may be the more relevant test —
   schemas live in the repo and get *read*, not guessed. Rowan's own
   conclusion: *"Archema's novel syntax is self-documenting. Even without
   examples, agents can infer meaning from the syntax itself."*
3. **It bears on §4.4 (the element-suffix question).** Under *Novel
   Features*: for optional fields, agents expected `optional: true`
   (explicit keyword), not `:optional` (a symbolic flag). UDON's
   `|field[date]?` is a symbolic flag. So this data point mildly cuts
   against a suffix spelling for *nullability* — though the reverse test
   suggests it would still read correctly, and `?`-as-optional has
   substantial prior exposure (regex, TypeScript, GraphQL). Guessability
   and readability are different axes, and rowan's own data separates
   them: agents didn't guess `one_of`, but read it correctly. Since
   schemas are read far more than invented, readability probably matters
   more here — but that's an argument, not a measurement, and the harness
   could settle it. See §4.4 for why this bears on nullability rather than
   presence.

   The meta-lesson, verbatim, and it generalizes past Rails: *"'Intuitive'
   is not what should be obvious but what **is** obvious based on prior
   exposure."* For a UDON schema DSL, the prior exposure is JSON Schema and
   RELAX NG — an argument for taking their vocabulary (§3) rather than
   inventing.
4. Adjacent: agents invented `as_of(date)` for temporal queries (rowan's
   doc calls it "elegant" — a note for the temporal dialect / paths); and
   the companion minimal-documentation experiment ("what's the smallest set
   of examples that lets agents infer 95% of the functionality?") is the
   cheat-sheet question in `ux/TODO-AGENT-UX.md`, already run once with a
   method attached.

### Queued and ruled-out

The remaining rowan files (attributes.rb, the constraints plan's open
questions, differ.rb, safe-rdbms-evolution's Core Insight, tool_export.rb,
the ash-comparison sections, types.rb) and the scouted dead ends
(`.archema/schema_history/*`, `docs/ref/critical-synthesis.md`,
`docs/ref/patterns/*`, `tmp/ash/`) are tracked in the ledger (§6) rather
than duplicated here. **Verified absence in rowan:** aspirational bindings
and true schema-by-exemplar have no rowan counterpart (grepped) — those
read as UDON-native; the nearest gesture is Piece 12's dialect-as-lens.

## 2b. Sources — autopax

Two files identified, both queued unread — see §6 for status. The one
worth flagging by name: **`~/src/autopax/docs/ADR/010-markdown-parsing-and-validation.md`**
carries a section titled "P3: Schema-Derived Agentic Tools" plus a phase-4
tool-generation plan — the schemas→tooling bridge, from the ADR side, not
yet read.

---

## 3. The comparative survey — what exists, and the axes that seem to matter

*(Model knowledge, not a fresh survey. Verify before load-bearing.)*

### The families

- **Grammar lineage (XML):** DTD → XSD → **RELAX NG** (Clark & Murata; a
  regular tree grammar with a clean compact non-XML syntax). Alongside it,
  **Schematron** — rule-based XPath *assertions*, deliberately not
  structural. Real XML pipelines ran **both**, because they're
  complementary, not competing.
- **Constraint lineage (JSON):** **JSON Schema** (2020-12) — `type` /
  `required` / `oneOf` / `anyOf` / `allOf` / `not` / `if-then-else` /
  `dependentRequired` / `patternProperties`, `$ref`/`$defs`, open-world by
  default. Cousins: OpenAPI, Zod/io-ts (type-first), JSON Type Definition
  (deliberately tiny).
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
    `ary { … }`) — this looks like where `|str[username]!` comes from.
    Worth reading directly: it is the nearest living ancestor of the
    element-typed spelling, and its own choices (why optional-by-default,
    how it handles `ary`/`hsh` nesting) are pre-argued.
  - **`yq`** — not a schema language at all, but the *query/transform*
    side of the same problem, and the reason it was in the room is
    probably udon-paths, not schemas. Its lesson for us is the same one
    semgrep/ast-grep teach: the expression should look like the data it
    addresses. Cross-link: `udon-paths.md`, and the adjudication packet.
- **Formatters/linters worth the glance:** gofmt / black / rustfmt
  (canonical form, no options — the "one true output" school); Prettier
  (configurable); ESLint (rule-based + autofix); and the structural family
  — **semgrep / ast-grep / Comby**, whose patterns look like the code they
  match. That idea is udon-paths' cousin.

### The axes I found load-bearing while reading

**1. What kind of thing is a schema?** The deepest split, rarely named:

| kind | claim | examples |
|---|---|---|
| **Grammar** | "valid = this grammar generates it" | RELAX NG, XSD content models, DTD |
| **Constraint** | "valid = these predicates hold" | JSON Schema, Schematron |
| **Shape** | "these nodes carry these properties" | SHACL, ShEx |
| **Unification** | "schema and value are one lattice; a schema is a *less specific value*" | CUE |

The January exploration is a hybrid without naming it: Piece 1's
cardinality sigils are a grammar; Piece 3's `one_of`/`any_of` is
constraint. RELAX NG + Schematron proved the pairing works, but the two
pieces fail and compose differently, so it's worth naming which piece is
which.

**2. Prescriptive ↔ descriptive ↔ prototype-like.** Prescriptive: schema
first, data conforms (protobuf, XSD, SQL DDL). Descriptive: schema inferred
from data (quicktype, Avro-from-data). Prototype-like: an *instance* is the
schema — Self/JS prototypes in languages; in data, nearly unoccupied. CUE
is the closest formal home (a schema is a value with freedom left in it) —
the thing to read for schema-by-exemplar.

**3. Open vs closed world.** Closed = undescribed is forbidden (XSD,
protobuf). Open = undescribed is allowed (JSON Schema default, RDF). This
is the soft-region question: "absence of constraint = soft" *is*
open-world, and UDON's fractal boundary is open-world-by-default with
closed islands. XSD's mixed-content models are the only prior attempt I
know of at the same problem, and are widely considered a weak corner of
XSD.

**4. Typing vs constraint.** YAML *has* a thing called a schema
(failsafe/JSON/core) and it isn't validation at all — it's **type
resolution** (how does `yes` become a bool). The Norway problem is a
typing-schema failure, not a validation failure. JSON Schema assumes types
are resolved and only constrains. UDON already separated these —
syntactic typing + `<…>` dialects handle resolution; nothing sniffs — so
UDON's schema layer, on this reading, inherits only the constraint half.
This is the strongest argument I have for why Piece 2 shouldn't exist as
schema: `:type <email>` reads as a dialect reference, not a schema
feature. (Contested by §4.2/§8 — see there.)

**5. Enforcement locus.** Parse-time (protobuf — you cannot parse without
the schema) / post-parse (JSON Schema) / write-time (DB constraints, the
edit tool) / never (YAML + convention). Almost nobody I know of treats this
as a declared, per-document property — it's baked into the ecosystem.
Joseph's cadence spectrum makes this axis explicit and dialable, which
looks novel to me, though I haven't done a systematic search to confirm
that.

**6. Evolution model.** None (JSON Schema — ad hoc) / reader-writer
resolution (Avro) / wire-compat discipline (protobuf: never reuse a field
number) / migration scripts (Rails) / upcast chains (rowan). Avro's
reader/writer split is the strongest story I know of for documents that
outlive their schema — and it's rowan's `upcast from:` in different
clothes, arrived at independently.

**7. Same-language or foreign?** JSON Schema is JSON; XSD is XML; CUE is
CUE; RELAX NG *compact* deliberately isn't XML; protobuf has its own DSL.
Self-description (a meta-schema) follows from the same-language choice.
Piece 11 chooses same-language — which is also what makes rowan's
Ruby-DSL fatigue diagnostic: rowan's schema isn't written in the thing it
constrains.

**8. Constraint reach.** Local (field types) → cross-field
(`dependentRequired`, if/then, Schematron) → referential (SQL FKs, SHACL,
`ReferenceIndex`) → transitional (old→new; rowan's differ; I haven't found
this elsewhere in the survey).

**9. Graded or binary?** Nearly everything is binary; warnings-vs-errors
lives in linters, not schemas. Gradual constraint (mandatory → typed →
suggested → free) and confidence-annotated regions look close to
unoccupied to me. Piece 13's `;?` markers reach at something real here.

**10. Where does the schema physically live?** *(Added 2026-07-16 —
Joseph's catch, and a family my first pass at this survey missed
entirely.)*

| locus | examples |
|---|---|
| **Separate document** | JSON Schema, XSD, RELAX NG, `.proto`, CUE, schema-dsl.udon |
| **In the host language** | Zod/io-ts, Ecto, ActiveRecord, rowan's Ruby DSL |
| **In the data, as a field** | rowan's `_schema: type/version`; Avro's embedded writer schema |
| **In the filename** | UDON's `<name>.<schema>.udon` designator |
| **In comments** ← *the family I missed* | Ruby's `rbs_inline` (`# @rbs`), YARD (`# @param`), Python's `# type:` comments (PEP 484), TypeScript's JSDoc `/** @type */`, Go's struct tags (metadata smuggled in a string), Rust's `#[serde(...)]` attributes |

**A note worth naming:** rowan's own source is comment-typed — every file
I read this session opens with `# rbs_inline: enabled` and carries `# @rbs`
annotations beside the Ruby. So the project whose Ruby-DSL fatigue started
this whole inquiry is itself using the comment-locus for its type layer,
and I read past it a dozen times before noticing.

### Where that leaves UDON

**Occupied — probably don't reinvent:** constraint vocabulary (JSON
Schema's; rowan proved the mapping), grammar/cardinality (RELAX NG compact
is the reference; CORE's suffixes already claim it), evolution (Avro's
reader/writer + rowan's upcast).

**Unclaimed, roughly in the order that look highest-value to me right
now:** mixed-content constraint (prose ⊃ structure ⊃ prose, fractal) · the
enforcement-cadence dial as a *declared* property · prototype-like/exemplar
as a lifecycle (CUE is the nearest ancestor) · gradual constraint ·
transition validity for documents.

### The comment-locus option — a fourth candidate

*(Opened 2026-07-16 by Joseph in a single sentence — "we haven't even
talked about things like Ruby and other languages do all the time —
comment-based special typing and stuff." Recorded at length because it may
dissolve two problems I'd flagged as mechanism-less, and because it parses
today.)*

UDON has three already-ratified properties that make this cheap to try:

1. **Comments are a first-class tier of voice**, by design — the README
   lists them beside elements and attributes, not as detritus.
2. **Comments are events, not discards.** CORE: *"Comments are emitted as
   events, not discarded. The consuming layer decides whether to keep or
   strip them. This enables use cases like documentation extraction, TODO
   tracking, or comment-aware transformations."* A comment-consuming
   schema layer is a use case CORE names.
3. **`;{…}` inline comments already exist**, so annotation can sit beside a
   value without touching it: `:username alice ;{@str :max 32}` is legal
   0.9 as far as I can tell (unprobed — see the gap list, §6).

What it would buy, matched against open problems noted elsewhere in this
document:

- **Gradual constraint gets a mechanism, not just an argument.** Annotate
  the fields you want constrained; leave the rest alone. The unannotated
  are free by construction — there's no "absence of constraint" to
  interpret, because absence is literally absence. This is the missing
  mechanism §4.6 flags.
- **Soft regions become visible in the source.** Prose is unannotated =
  soft; annotated = hard. The fractal boundary stops being a schema
  question and becomes a typographic one — you can see it.
- **Schema-by-exemplar stops needing an inference step**: you annotate the
  exemplar in place, and the exemplar is the schema. No separate artifact
  to drift.
- **Aspirational binding gets cheap to express**: annotate what you wish
  were true; nothing enforces until something does.
- **No data-model pollution** — the schema never appears in the tree the
  consumer sees.
- **It composes with the other loci** rather than competing with them: a
  separate `schema-dsl`-style document for the contract; comment
  annotations for the local, the gradual, the in-progress.

Joseph was already reaching for this in January: Piece 13's uncertainty
markers (`;?` uncertain, `;??` very uncertain, `;!` reviewer attention) are
comment-locus annotations. A `;@`-family for schema would be the same
instinct, one aisle over.

**Honest costs / open questions:** comments are inert by ratified rule —
making a subset semantic is the "escape the comment tier" move that tends
to end badly elsewhere (cf. every `# noqa` / pragma-comment ecosystem);
tooling must strip-preserve them (the edit tool's round-trip must not eat
them); there's a real question whether an annotation *about* a value should
be positionally adjacent (`;{…}` after) or a block above; and CORE's
warning `CommentMissingFollowingSpace` and the framed-` ; ` rules mean the
lexical shape wants care. None of these is a probe away from an answer —
they're a design conversation.

### The plural-implementations posture (Joseph, 2026-07-16)

*"The options we have available are so plentiful, and we have the coding
capacity to do more than one approach."* Worth writing down as a standing
instruction to this lane: the goal is not to pick the winner. Four loci
(separate document / trait-typed / element-typed / comment-annotated) are
all live, all cheap to prototype against the same corpus, and the harness
can A/B them empirically (rowan's reverse-testing method, above). The
design note's job is to frame the options well enough that they can be
built and measured, not to argue one into place. Convergence is what the
evidence is for.

---

## 4. Open questions and current readings (not a design)

This section used to read as a settled "position." It wasn't — parts of it
were overtaken by later reading in the same session (§7, §8, §9), and one
item had been quietly corrected twice. What follows is a same-session
reconciliation: present state only, flagged by how settled each item
actually is. I've read a fraction of the archaeology (§6), so "settled"
below means "nothing I've read contradicts it," not "ratified."

1. **Constrain, don't behave.** UDON's schema layer looks smaller than
   Archema's resource layer. Rowan draws this line itself in its file
   layout (`attributes`/`constraints`/`identities` vs `actions`/`policies`),
   and the December DSL draws the same line as block names (§1). Pieces 5,
   6, 9, 10 (§1) are the layer rowan builds *on top*, not schema. This is
   the item I'd currently call settled, pending contradiction.

2. **Whether typing belongs to the schema layer or stays entirely in
   dialects is open, not settled.** Two readings, both grounded:
   - **Reading A** (survey axis 4, §3): typing already lives in dialects +
     `<…>`; a schema only constrains. On this reading `:type <email>` is a
     dialect reference and Piece 2 (§1) shouldn't exist as schema.
   - **Reading B**: `archema-operata`'s trait-as-type
     (`|attr[slug].string`) puts typing inside the schema document itself.
     CORE draws a hard line — *"Dialects are not schemas. A dialect says
     what a value means/types; a schema says what is allowed. They never
     trade jobs"* — which makes the collision precise rather than
     hand-wavy: is `.string` there a dialect reference (job-split honored)
     or schema-side typing (job-split violated)? §8 goes into this in more
     depth. I don't have a resolution; the design note has to pick one or
     find a third reading.

3. **Grammar + constraint hybrid, open-world by default** — the shape that
   fits what's in §1 and §3 so far, no strong counter-evidence found yet.

4. **Presence and nullability are different axes, and both are needed.**
   CORE's *Absent vs Nil vs False* section draws the line: *"Absent: key
   not present at all. Nil: key present, value explicitly 'no value'."*
   - `!` / `?` on the field = **presence** (must this key exist?)
   - `:allow-nil false` = **nullability** (may its value be nil?)

   Joseph's December files use each where CORE's distinction says it
   belongs: `schema-dsl.udon`'s `|str[username]!` is presence;
   `archema-operata`'s `:allow-nil false` is nullability. Rowan's
   agent-expectation data (§2 — agents expected `optional: true` over a
   bare flag) applies to the nullability axis, where an explicit
   readability question is still open; it doesn't argue against keeping
   `!`/`?` for presence, where CORE's own suffix-desugaring
   (`|field!` → `:'$!' true`) already matches the reading a schema would
   want (§7).

5. **The open fork: is the type the element name, or a trait?** Joseph
   wrote three spellings, and the two December ones are one day apart:

   | | spelling | type lives in | required/optional | lineage |
   |---|---|---|---|---|
   | **`schema-dsl.udon`** (12-23) | `\|str[username]!` `:min 3` | **the element name** (`str`/`int`/`bool`/`arr`/`obj`/`any`/`ref`) | **the suffix** (`!` req, `?` opt, bare = opt — *"like schemacop"*, his note) | JSON Schema |
   | **`archema-operata.udon`** (12-24) | `\|attr[slug].string :allow-nil false` | **a trait** | *(not expressed — `:allow-nil` is the nullability axis, not presence, per item 4 above)* | Ash / rowan |
   | **Piece 1** (Jan) | `:author! string` | an attr value | the key's suffix | RELAX NG-ish |

   The two live candidates:

   - **Type-as-element-name** (`|str[email]! :format email`) — types are
     first-class and a dialect can add one; the suffix falls naturally on
     the field. But the schema's shape is inverted from the document's: in
     a document `|user[alice]` means element=`user`, key=`alice`; in this
     schema `|str[username]` means element=*type*, key=*name*. The schema
     stops looking like the thing it describes.
   - **Type-as-trait** (`|attr[slug].string`) — uses UDON's own
     element/key/trait roles natively (thing / identity / classification),
     which CORE supports directly (*"classification doubles as lightweight
     typing"*), and keeps the schema shaped like a UDON document. Costs
     verbosity, and leaves the type's meaning positional by convention.

   UDON's stated aesthetic elsewhere is that a schema, like a path, should
   look like the thing it navigates or describes — which argues for
   trait-as-type. The counter-argument is that `|str[email]! :format
   email` is simply easier to read on first pass, and readability is the
   axis the harness can actually measure (rowan's reverse-testing method,
   §3). This looks to me like the central open question for the design
   note, and it's A/B-able rather than something to argue into place from
   here.

6. **`schema-dsl.udon` already contains several things worth diffing
   against 0.9 rather than re-proposing.** Block-form composition as
   elements (`|one_of` / `|any_of` / `|all_of` / `|is_not` — matching
   rowan's block DSL shape, §2); `:when ssl` for conditional presence
   (JSON Schema's if/then); `|ref user` and `|ref[owner] user` for type
   reuse; anonymous inline types for array items (`|arr[tags]?` + child
   `|str :max 20`); and a meta-schema (`|schema[udon-schema]` — Piece 11,
   already drafted). Its constraint vocabulary is JSON Schema's,
   near-complete: `:min` `:max` `:min_length` `:pattern` `:format`
   `:enum` `:default` `:multiple_of` `:when`. A first design-note draft
   probably wants to start by diffing these three files against 0.9 rather
   than proposing from scratch.

7. **Soft regions: prose as the ambient default, mirroring the notation.**
   Piece 8's option D (absence of constraint = soft) is more than merely
   convenient, on the argument that prose is the unmarked case in UDON
   documents generally, so prose should be the unmarked case in UDON
   schemas too — same asymmetry, one level up. This is an argument, not a
   mechanism; the comment-locus option (§3) is the closest thing to a
   mechanism found so far.

8. **Exemplar + aspirational + profiles as one lifecycle.** No schema →
   free; write a few; infer a draft; refine; it constrains. This matches
   rowan's *empirically observed* constraint ladder (§2) applied to
   authoring, landing on Casual → Careful → Critical, with nobody writing
   the schema first.

9. **What 0.9 changed that January couldn't know:** stacking is uniform,
   so a schema constrains *stacking cardinality* (where multi-key lands);
   and Value Kinds means constraining *kind* (scalar / node / blob /
   reference / interpolation), not just type. More surface, but more
   regular — everything is the hash and the array.

10. **Name collision, now three-way:** `:one-of [a b c]`
    (archema-operata) = enum on one attribute; `|one_of` (schema-dsl) =
    union of types; rowan's `one_of do present :x end` = XOR across
    attributes. Three constraints, one name. Whichever survives, the other
    two need names — `:enum` already exists in schema-dsl for the first.

**Where this leaves the design note.** Item 1 (constrain-don't-behave) and
item 4 (presence vs nullability) read to me as settled by the December
files and CORE, and I haven't found anything since that contradicts them.
Items 2 (typing's job-boundary) and 5 (element-name vs trait) are
genuinely open, related, and probably the design note's real work. Item 7
(soft regions) has an argument but no mechanism yet. §9 below adds a fifth
open item — schema inheritance/composition — with no udon-side answer at
all.

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
     cheap, already has a method in rowan, and would settle §4 item 5's
     spelling fork with data instead of taste. It also belongs to
     `ux/TODO-AGENT-UX.md`'s harness rebuild — same instrument.
5. Then a **design note** in the register of `attribute-model-2026-07.md` —
   reasoning included, for Joseph to ratify from rather than re-derive.
   Its job is **not** to pick words (the harness can settle those — §3,
   and rowan's reverse-testing method). Its job is to answer §4 item 5:
   field-based, content-model-based, or a named hybrid — and where the
   seam falls. Probable spine: Joseph's December spelling (element-form,
   trait-as-type, constraints-as-attributes); his block names as the
   schema/behavior seam; the JSON-Schema composition vocabulary for
   cross-field constraints; open-world/soft-by-default; evolution via
   upcast + `was:`/`since:`; the profile dial; and a worked schema for
   `test/scenarios/corpus/` as the honesty test — seven documents, six
   genres, written by someone who wasn't designing the schema, and
   content-model-shaped where rowan is field-shaped.

---

## 6. File status ledger

*Status vocabulary:* **read** = first-hand, in full · **partial** = named
bands only · **distilled** = read by a delegated agent, its full
distillation on record, I have highlights · **scouted** = an agent mapped
it; I have its shape, not its text · **queued** = identified, unread ·
**⚠ unread** = has been cited or leaned on without being opened — the
honest gaps. This is the single index for all three source trees; the
narrative sections above (§1, §2, §2b) point back here rather than
repeating status per file.

### In-repo (`~/src/udon`)

| File | Date | Status | Carries |
|---|---|---|---|
| `spec/CORE.md` | 0.9.0-alpha.1 | **read** | The authority. Assigns the schema layer its job in its own text ("Constraint… a schema's job"; "forbidding a multi-valued `$key` is a schema concern"); states trait-as-lightweight-typing and the two-clause suffix sentence (§4 item 5, §8). |
| `design/examples/archema-operata.udon` | **2025-12-24** | **read** (≈130/238) | The working DSL: trait-as-type, constraints-as-attributes, blocks-as-layers, `!:rb:` escapes. |
| `design/examples/operata-intent-graph.udon` | 2025-12 | **partial** (40/118) | The query/graph layer; `|edge :when :relationship == prepares` (predicate in value position). |
| `design/examples/schema-dsl.udon` | 2025-12-23 | **read** | Type-as-element-name (`\|str[username]!`), JSON Schema's vocabulary in UDON, suffix for presence, block-form composition (`\|one_of`/`\|all_of`/`\|is_not`), `\|ref` for reuse, `:when` for conditional presence, and a meta-schema (Piece 11, already drafted). Cites *schemacop* as its optionality precedent. 0.9-clean (§7). |
| `design/examples/ash-like-billing.udon` (126) · `ash-like-inventory.udon` (106) | 2025-12-24 | **read** | An Elixir-flavored variant, not "more of the same": `!:ex:` escapes and `^arg` pin-style argument refs (vs archema-operata's `!:rb:` + `!{arg}`); resource-level storage mapping (`:table`/`:primary-key`/`:timestamps true`); `:unique true` inline competing with the `\|identities` block; `\|validations` w/ `:rule "…"` strings; `\|policies` w/ `:effect allow`; `\|calculations` w/ `:expr "sum(lines.amount)"`; `:accept [...]` on actions. See §7. |
| `design/examples/ash-like-support.udon` (107) | 2025-12-24 | **skimmed** | Presumed same family as billing/inventory — a presumption that has already failed three times for the other files in this set, so treat as unverified. |
| `design/udon-schema-exploration.md` | Jan 2026 (committed 07-08) | **read** | The thirteen puzzle pieces + 16 open questions. Content-model-flavored (§4 item 5). |
| `design/udon-guarantees.md` | Jan 2026 (committed 07-08) | **read** | Guarantee ladder; Casual/Careful/Critical profiles; the gatekeeper problem; the append-only-log patch ancestor. |
| `design/udon-agentic.md` | Jan 2026 | **read** | `validate` + `infer` are the schema's tool surface; `infer` is exemplar's read-side twin; Future Directions already lists schema-inference. |
| `design/udon-paths.md` | Jan 2026 (banner 07-16) | **read** | Selection — constraints that quantify ("every `||endpoint`") need it. |
| `design/agentic-ux-principles.md` | 2026-07-16 | *(authored here)* | P7: the file's own law governs; declared-is-theater-until-honored. |
| `design/attribute-model-proposal-3.md` (494) + `-substrate.md` (479) | 2026-07-15/16 | **read** (proposal §0–§2 + structural sweep of both) | The 0.9 model's ratification carriers. A grep for `[OPEN]` returns only the legend row, so CORE carries every decision and these are archaeology now. Two live threads for us: the "kind" footnote (§8) and the positional scalar/blob rule (§8). Its segment-array wire framing was superseded by R5's flat wire (recorded in the changelog). |
| `design/udon-ast.md` | Jan 2026 | **⚠ unread** (751) | Type-scoped `(element-name, key)` uniqueness — which I've cited repeatedly as the `at`-uniqueness predicate — plus ReferenceIndex, Document views. Known only through a delegated distillation. |
| `design/composite-types.md` | 2026-07 | **queued** (3K) | `<…>` nesting; matters if type-refs are dialect-refs. |
| `design/GRAMMAR-CONSTRAINED-GENERATION.md` | Dec 2025 | **distilled** | Schemas as generation constraints; argues for machine-readable schema. |
| `test/scenarios/corpus/operata.domain.udon` | 2026-07-16 | **⚠ unread** | Already a schema-flavored document in 0.9 idiom, per the building agent's report — not verified first-hand yet. |
| `test/scenarios/corpus/operata-live.workspace.udon` | 2026-07-16 | **⚠ unread** | The mutation target; integer keys beside legacy string keys. |
| `test/scenarios/` (rest) | 2026-07-16 | **distilled** | The requirements corpus (§1); `schema-guard-before-write`; `SchemaViolation`. |
| `spec/TODO-AUX.md` · `TODO-SPEC-CORE.md` · `TODO-SPEC-OTHER.md` · `TODO-UTILS.md` | live | **read** | The lanes: schema/paths/patch; multiple keys; pragma; guard + cadence. |

### rowan (`~/src/rowan` — internals still say `Archema`)

| File | Status | Carries |
|---|---|---|
| `lib/archema/resource/identities.rb` | **read** | Surrogate + natural, built: PK (composite ok) plus named plural identities, each an independent unique key-set, with eager/pre-check timing. |
| `docs/dev/adr-003-document-schema-first.md` | **read** | Constraint vocabulary from JSON Schema; schema-layer validation canonical; per-store best-effort projection → maps to the enforcement-cadence dial. |
| `docs/exp/schema-evolution-patterns.md` | **read** | 1,950 real migrations → six ladders w/ asymmetry; only 8.5% asymmetric; "natural keys are additive." External empirical data. |
| `lib/archema/resource/constraints.rb` | **partial** (header + DSL) | `one_of`/`any_of`/`when_value`/`dependent_required` + JSON-Schema mapping per constraint; block-structured. |
| `lib/archema/resource/versioning.rb` | **partial** (1–60) | `_schema: type/version` in-document — the pragma, shipped. `upcast from:`, compat declarations, per-field `since:`/`deprecated:`. |
| `lib/archema/resource/evolution_context.rb` | **partial** (ops + header) | add/rename/split/merge/transform/remove_field, atomic, each registering its inverse upcast. |
| `docs/VISION-drafts.md` §Empirical (303–400) | **partial** | Naive-agent guessability (n=13); `was:` beat `alias:`; reverse testing as a method; "intuitive = prior exposure." External empirical data, small sample. |
| `lib/archema/resource/attributes.rb` | **queued** (3 bands of 1091) | The flag + evolution-metadata vocabulary at a glance; the `field` dispatcher; composite-PK DSL. |
| `docs/msc/plan-document-schema-constraints.md` | **partial** (Open Questions 427–450 read 2026-07-16, §9; rest of the 469-line plan queued) | Open Questions are live forks we may re-tread; the DSL-keyword table at 72–80 includes the unbuilt `all_of` / `not_schema`. |
| `lib/archema/schema/differ.rb` | **queued** (header) | Transition-validity analog: classifies changes, raises `:possible_rename`/`:type_change` as decisions, not guesses. |
| `docs/dev/plan-safe-rdbms-evolution.md` | **queued** (Core Insight ~45) | Database-as-Truth vs transition-periods vs Resource-as-Truth; expand/monitor/contract. |
| `lib/archema/agentic/tool_export.rb` + `docs/sys/agentic/tool-export.md` | **queued** | Schema→tool-definitions + JSON Schema from one model. Working today, per the file. |
| `docs/msc/archema-ash-comparison-research.md` | **queued** (3 sections of 1619) | Cat. B (evolution), Cat. M (JSON-Schema composition), Exec summary (8 contributions vs 15 gaps, per rowan's own framing). |
| *(every `lib/archema/**/*.rb`)* | **observed in passing** | `# rbs_inline: enabled` + `# @rbs` annotations — rowan's own type layer lives in the comment locus (§3 axis 10). Read past a dozen times before noticing. |
| `lib/archema/types.rb` | **queued** (296) | The concrete type/constraint catalog (dry-types). |
| `lib/archema/resource/relationships.rb` | **queued** (698) | Cardinality options `min_required`/`max_allowed`, `managed:`. |
| `docs/usr/10-schema-evolution.md` | **queued** (238) | The user-facing narrative + branch-safety / divergent-evolution conflict detection + decision-log audit trail. |
| `docs/dev/adr-004-programmatic-schema-api.md` | **queued** | Ruby-API-first; the Erlang/OTP mental model for runtime evolution. |
| `KEY_FILES.md`, `MAP.md`, `LEXICON.md` | **scouted** | The index; Track 1 (Ash parity) / Track 5 (safe RDBMS evolution). |
| *dead ends (scouted, ruled out)* | — | `.archema/schema_history/*` (test artifacts) · `docs/ref/critical-synthesis.md` (philosophy) · `docs/ref/patterns/*` (Ambler catalog) · `tmp/ash/` (vendored real Ash). |

### autopax (`~/src/autopax`)

| File | Status | Carries |
|---|---|---|
| `docs/ADR/010-markdown-parsing-and-validation.md` | **queued** (399) | "P3: Schema-Derived Agentic Tools" + phase-4 tool generation. The schemas→tooling bridge. |
| `docs/ADR/migration-proposals/003-workflow.md` | **queued** | Agentic Workflow Principles (+ archived analysis companion). |

### The honest gap list

1. **`design/udon-ast.md`** — unread, while citing its uniqueness predicate
   as the foundation of `at`.
2. **`test/scenarios/corpus/operata.domain.udon` and `operata-live.workspace.udon`**
   — the 0.9-idiom schema-flavored documents this lane leans on, known only
   secondhand.
3. **Comment-locus forms unprobed** — `:username alice ;{@str :max 32}` and
   a block-comment annotation should be run through the parser before that
   option (§3) is treated as more than plausible.
4. **Timeline gap:** nothing between Jan 14, 2026 (dormancy) and Jul 8,
   2026 (reboot) — six months where rowan kept moving and udon didn't.
   Rowan's Track-5 work may postdate every udon document read for this
   workbench.

---

## 7. The 0.9 diff — probe results (2026-07-16)

Every December spelling run through the current parser. Headline: the
schema DSLs survive; the expression sub-language is the casualty.

| input | result | verdict |
|---|---|---|
| `\|str[username]!` + `:min 3` + `:pattern ^[a-z][a-z0-9_]*$` | `Name` · `Attr $key`/`BareValue username` · `Attr $!`/`BoolTrue` · `Attr min`/`Integer 3` · `Attr pattern`/`BareValue ^[a-z][a-z0-9_]*$` | clean ✅ |
| `\|is_not` + `:enum ["" " "]` | `ArrayStart` · `StringValue ""` · `StringValue " "` · `ArrayEnd` | clean ✅ |
| `\|calc[total].money :expr "sum(lines.amount)"` | `Attr $key`/`BareValue total` · `Attr $traits`/`BareValue money` · `Attr expr`/`StringValue` | clean ✅ |
| `\|when :actor-role == :accountant` | `Attr actor-role`/`BareValue ==` · `Attr accountant` · `Error MissingAttributeValue` · `Nil` | ERRORS ❌ |
| `\|filter :email == ^email` | `Attr email` · `Text` (the whole `== ^email` as a blob) | degrades ⚠ |
| `:fallback !{:ex: "Money.zero(:USD)"}` | `Attr fallback` · `Text` | degrades ⚠ |

### What this establishes

1. `schema-dsl.udon` is 0.9-viable essentially as written — and its `!`
   suffix desugars to `Attr "$!"` + `BoolTrue`. Required-ness lands on the
   exact designated attribute CORE reserves for it. `|str[username]!` *is*
   `|str[username] :'$!' true`, and a schema reading `$!` as "required" is
   precisely the reading CORE's Element Suffixes section describes. This
   fitness is design intent, not serendipity — Joseph, 2026-07-16: *"I
   absolutely put those in the syntax because I had schemas on my mind."*
   The suffixes were built for a schema layer before the schema layer
   existed; CORE's *"a schema might read `?` as optional, `!` as
   required"* is that intent surviving into the ratified text.
2. Regexes survive as bare values — `^[a-z][a-z0-9_]*$` needs no quoting
   (no spaces → no blob → no boundary). That was the probe I most expected
   to fail.
3. `archema-operata`'s trait-typed field line is clean — `.money`/`.string`
   land as `$traits`, `:allow-nil false` as an ordinary attribute.
4. The casualty is the expression sub-language, and only that. `:when
   :actor-role == :accountant` doesn't degrade — it errors (`==` becomes
   the value; `:accountant` starts an attribute that never gets one).
   `|filter :email == ^email` degrades silently to a text blob. This
   matches expectation: those are expressions, expressions are DYNAMICS'
   territory, and the December files predate the dynamics/dialect
   boundary.
5. Joseph hedged in December without knowing it. The same files carry both
   quoted (`:rule "email =~ /@/"`, `:expr "sum(lines.amount)"`) and bare
   (`|when :actor-role == :accountant`) forms. The quoted form is the
   0.9-safe one — it survives untouched as a `StringValue`. So the
   expression layer already has a working spelling in his own files; the
   bare form is the one that needs the dialect.
6. `!{:kind: …}` in value position → `Text`, silently — a live use case
   for an explicitly-open spec question. CORE: *"Whether the inline form
   can appear in value position is deferred with the rest of the
   inline-raw nailing."* `archema-operata` uses it (`:fallback !{:ex:
   "Money.zero(:USD)"}`). Route to `spec/TODO-SPEC-CORE.md`'s inline-raw
   item as evidence that the deferral has a consumer waiting.

### The 4th and 5th spellings (from `ash-like-*`, read 2026-07-16)

The three `ash-like-*.udon` are not "more of the same" — the assumption
that has now failed three times:

- They're Elixir-flavored, where `archema-operata` is Ruby: `!:ex:`
  escapes, and `^arg` pin-style argument references (`|filter :email ==
  ^email`, `:rule "on_hand + ^delta >= 0"`) — Elixir's pin operator —
  where archema-operata used `!{claimer}` interpolation. Two
  argument-reference syntaxes.
- Storage mapping at the resource level: `:table customers`,
  `:primary-key id`, `:timestamps true` — which `archema-operata` doesn't
  have (it puts `:store sqlite` on the *domain*). Puzzle Piece 9 (storage
  projection), already sketched twice, differently.
- `:unique true` inline — competing with `archema-operata`'s
  `|identity[unique-slug] :keys [slug] :eager-check true` block. Two ways
  to say unique, and they aren't equivalent: the flag is per-attribute, the
  block is a named multi-attribute key-set with check timing.
- A `|validations` block with rule-strings (`|validation[email-format]
  :rule "email =~ /@/"`), plus `|policies` with `:effect allow` +
  `|when …`, plus `|calculations` (`|calc[total-amount].money :expr
  "sum(lines.amount)"`) — three more blocks in the schema/behavior seam
  (§4 item 1) that `archema-operata` doesn't carry.
- `:accept [email name]` on actions; `|read[by-sku] :get true`;
  `|authorize :accounting-only` (an action naming a policy).

---

## 8. The attribute model's carriers — read 2026-07-16

`attribute-model-proposal-3.md` + its substrate: a grep for `[OPEN]`
returns only the legend row. CORE carries every decision from them, so
they read as archaeology now. Two facts from them matter here, and one
absence matters more.

**The absence: the 0.9 attribute model was designed with no schema
awareness that I can find.** `grep -i schema` across both carriers returns
nothing — 494 + 479 lines about the exact model a schema must constrain,
with the word never appearing. Meanwhile CORE mentions schemas eight
times, and three of those are load-bearing job-assignments to this lane:

- *"**Constraint** — what is allowed or required (cardinality, vocabularies,
  'no array-valued `$key`'). A **schema's** job. Proscription lives here,
  never in the core."*
- *"**Dialects are not schemas.** A dialect says what a value *means /
  types*; a schema says what is *allowed*. They never trade jobs."*
- *"what is allowed — e.g. forbidding a multi-valued `$key` — is a schema
  concern, never core."*

So the schema-awareness entered at CORE drafting, not in the model's
design. Two consequences, and they cut opposite ways:

1. The schema layer inherits a model that never anticipated it — which is
   plausibly correct on its own terms (a model shouldn't be bent by every
   future consumer) but means no 0.9 affordance should be assumed to have
   been built with schemas in view. Contrast identity, where the suffixes
   *were* (§7) — so 0.9 looks schema-aware in its sugar and schema-blind in
   its attribute model. Worth knowing which is which before leaning on
   either.
2. The `:type` question gets sharper. CORE draws "dialects type, schemas
   constrain — they never trade jobs" as a hard line. But
   `archema-operata`'s trait-as-type (`|attr[slug].string`) puts typing in
   the *schema* document. Is `.string` there a dialect reference (CORE's
   job-split honored), or is the schema typing (job-split violated)? This
   bears directly on §4 items 2 and 5, and it's unresolved there.

**Two live threads the carriers leave us:**

- **The "kind" footnote** (proposal-3 §2.1, non-normative): *"an array of
  only text / text-reducible segments may later be treated as a soft
  'kind' distinct from a junk-drawer heterogeneous array — not required for
  0.8."* That's a schema-shaped distinction, deferred: a schema wanting to
  say "this attribute is a text blob" vs "this attribute is a list of
  values" needs exactly that kind. Nobody has picked it up yet, as far as
  I've found.
- **The positional scalar/blob rule** (proposal-3 §2.1, substrate §S5): *"a
  **mid-line** bare value (more attrs still to the right) is a **scalar** —
  no unquoted spaces… Unquoted multi-word text is only for the **last**
  trailing value material on the line."* A value's legal spelling depends
  on its position on the line — which any schema-authoring guidance,
  formatter, or generation-constraint artifact has to encode. It's also why
  `:rule "email =~ /@/"` (quoted) survives 0.9 where the bare form
  wouldn't (§7).

---

## 9. Rowan's five open questions ARE udon's — asked Dec 2025, still open

`rowan/docs/msc/plan-document-schema-constraints.md` §Open Questions
(427–450), read 2026-07-16. It records Joseph's own unresolved forks in the
constraint DSL from December, and four of the five map onto questions this
workbench had been treating as udon-native discoveries under different
names. Verbatim, with the mapping:

| Rowan's question (Dec 2025) | Where I'd "discovered" it |
|---|---|
| **1. Validation strictness levels?** `strict` (reject) / `warn` (log but continue) / `permissive` (ignore) | The Casual / Careful / Critical profiles (`udon-guarantees.md`) and the udon-guard enforcement-cadence spectrum (`TODO-UTILS.md`). Same question, three names. |
| **3. Runtime vs load-time validation?** validate all on startup / lazy on first access / background job | Survey axis 5, "enforcement locus" (§3) — which I'd called probably novel. He was asking it in December. |
| **4. External schema files?** store `.schema.json` alongside data, **or always generate from the definition?** | Survey axis 10, "where the schema physically lives" (§3) — the axis Joseph had me add. It was already his question. |
| **5. Constraint on relationships?** `one_of` on relationship refs, not just attributes; cross-resource constraints | Cross-document referential integrity — which `test/scenarios/corpus/archema.concept-matrix.udon` demands (cross-document `:in`/`:ref` joins) and which `udon-ast.md`'s ReferenceIndex anticipates. |
| **2. Schema inheritance?** *Can a Resource extend another's schema? How do constraints compose across inheritance?* | Nothing. No position, no note, no mechanism in this workbench. |

### What this changes

- The design note inherits a question list; it doesn't start one. Four of
  these are already load-bearing in this workbench under other names, and
  merging them rather than re-asking in udon's own vocabulary looks like
  the more honest move.
- Question 2 is a real hole in what I've synthesized here. Schema
  inheritance/composition has no udon-side thinking at all — and UDON has
  a candidate mechanism nobody has connected to it yet: traits. CORE's
  *Mixins* section already sketches trait-based attribute inheritance
  (`|.defaults` + `|database[prod].defaults`) and explicitly leaves
  resolution to the consumer. If a schema is a UDON document and traits
  classify, schema inheritance may turn out to be the same mechanism as
  document mixins — which would be the kind of unification the
  exploration doc's closing instruction asks for. Unexamined; flag for the
  design note.
- Rowan's Success Criteria include `Schema version lookup from document
  metadata` — the pragma again (§2, `_schema: type/version`), listed there
  as an acceptance test rather than an idea.
- Its references are the ancestry, stated: JSON Schema Draft 2020-12
  (core + validation) and dry-types constraints — so rowan's per-field
  constraint catalog (`:min`/`:max`/`:format`/enum-via-`values:`) is
  dry-types', and any udon type/constraint vocabulary inherits from there
  whether it means to or not.

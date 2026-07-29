> **Preserved as-is — this is the draft Joseph read on 2026-07-28**, kept intact at his
> suggestion rather than rewritten, because its survey layer and initial reasoning are
> worth having whole. Its known defects (conclusions buried, authoritative register at an
> explication stage, an over-asserted tier table in §5a) are the reason `README.md`
> exists — that one is the revision, not a replacement for the material here. Where the
> two disagree, the revision is later thinking; where this one has detail the revision
> compressed into an appendix, this is the fuller record.

> **Safe-deletability assessment (O2, added 2026-07-28).** Checked mechanically and by
> hand: every substantive item in this draft is carried in `README.md` (body or
> appendices) or in the three testimony transcripts, which are the durable evidence
> record. What is *only* here is this draft's own scaffolding vocabulary — the
> "eleven dimensions" framing and its §2j/§2k numbering — i.e. organization, not
> content. By O2's test this file is **safely deletable**, and keeping it is the
> "low-signal noise that drowns the signal" side of O2's tension rather than the
> "don't make it be rederived" side. Retained only because Joseph explicitly asked for
> it; recommend deleting once he's compared the two, and nothing references it by name
> except one pointer in README's header.

---

# Schema — ideation seed

**Status:** broad ideation, not a spike. Possibility-opening, not decision-making.
Everything here is **proposed / testimony / open** unless it cites a ratified source —
and where it does (`DECISIONS`/`OPEN`/`CORE`/`MODEL`), that ruling is the authority, not
this page. `../../current-0.9.1-spec/` is the oracle for current language facts. Sibling in
shape and register to `../paths-ideation/README.md`, `../markdown/usage-topics.md`, and
`../living-documents/README.md`.

**Register note.** Claims are marked in their true voice: *decided* (a ledger ruling or
spec text — cited), *evidenced* (the estate or demand corpus supports it — cited),
*testimony* (de-novo agent report — substrate named; evidence of *end-user demand and
pain*, never of design validation), *proposed* (generated here — decides nothing),
*open*. Two disciplines borrowed from the estate and applied throughout: **shipped** and
**designed-only** are marked apart wherever a mechanism is cited, because the schema
estate's own review needed three correction passes to stop conflating them
(`../doc-store-and-schemas-checkpoint.md`); and a capability's evidence is named by
*kind*, since convergence means independent failure modes, not repetition
(`../../udon-needs/02-tooling-needs/NOTATION-KEY.md`).

**Why this seed exists (Joseph, 2026-07-28):** he wants the lay of the land before
design — what *kinds* of schema "drive or foreclose various capabilities (either fully
or by way of affordance)" — in the shape that unstuck the markdown conversation, where
"reasoning about markdown always seemed to go sideways because the agents were assuming
one thing and I another thing and no one was realizing the whole picture." His hedge
travels with the ask and is load-bearing: the kinds he named were **"a light sampling…
off the top of my head — definitely not a MECE list… because that's the big picture
that I still don't have in mind yet."** Nobody holds this picture. Producing it is the
deliverable.

**And the vision it serves (Joseph, 2026-07-28, marked by him as instinct, not settled
thinking):** *"in a sense, we're repurposing [archema's] vision here: The Arch-Schema
or Arc-Schema. If udon has the kind of tooling we really want, it should have the
**superset schema-ability** (even if that means more than one official representation,
or even if the internal canonical representation is a bit obtuse and exposed in more
digestible formats…)"*. Carried as orientation, not as a requirement this map must
vindicate — but §6 gives the instinct a concrete test, which is probably the most
useful thing a lay-of-the-land document can do for an instinct.

**Sources.** Primary: `../../current-0.9.1-spec/` (CORE, MODEL, CARVEOUTS read whole);
`../doc-store-and-schemas-report.md` + checkpoint; the demand corpus
`../../udon-needs/02-tooling-needs/` (30 bridge chapters swept); `~/src/rowan/docs/`;
the vivarium live-usage field report (I5, 2026-07-28). De-novo testimony elicited for
this seed across three substrate families, 2026-07-28 — provenance and weight in §10.

---

## 0. The framing finding — "kinds" is a real axis, but not the first cut

This seed was briefed to map schema-*kind* × capability. Four independent sources say
that framing, taken as the *first* cut, is itself the thing that sends conversations
sideways — which is the failure the deliverable exists to prevent. So the finding comes
first, and the kinds axis survives inside a larger frame (it is §2a, and Joseph's
question is answered in §4).

**Why, from sources that fail differently:**

- **Estate practice — kinds *stack* on one record.** The autopax ADR system carries
  three schema kinds simultaneously on one record type: typed frontmatter (constraint),
  a prose-stated structural schema (required `## Preamble` / `## ADR` headings), and
  convention (banner-flagged deprecation) — *evidenced*, report §11. A single
  `AgentCard` resource is at once a class-schema and addressed two ways whose
  validation paths diverge (§8.5). A single-kind answer does not describe anything the
  estate actually built.
- **The demand corpus resisted the flattening on purpose.** Swept whole: its own
  organizing move is by *evidence kind*, not capability, and its most mature statement
  of this territory (`priorities-and-spike-agenda.md`) is a **dependency-ordered
  question list**, not a capability inventory. The sweep's structural finding, verbatim:
  "shape (static/composable/nested) vs. strictness (casual/careful/critical) vs.
  binding surface (`PRAGMA`) vs. lifecycle (evolution/versioning) vs. enforcement point
  (author/edit/build) are five *independent* dimensions, not five items in one list —
  and the corpus keeps them separate exactly because they route to different repairs."
- **De-novo testimony, three substrates, independently.** Claude: "'kinds of schema' as
  static categories is not quite the right first cut… the sharper cut is *what does the
  schema need to witness happening over time*." Grok: "a good *historical* cut (how
  industry packaged the idea). The better *design* cut is **jobs × moments × authority
  × strictness**, with kinds as implementation tactics… If the team debates kinds
  first, they will pick a favorite hammer." Codex: "The first question is not 'what is
  the schema language?' but **'what promises can a schema make?'**… I mildly disagree
  with treating 'the schema layer' as one monolithic layer."

Three de-novo substrates are still **one support-kind** (testimonial) — they raise that
leg, they do not lock a convergence. What arms it is the other two legs being *estate
practice* and *corpus structure*, which fail differently from testimony and from each
other.

**So the map has this shape:**

| § | What it maps | Why here |
|---|---|---|
| **§1** | What ratified law **already fixes** about the schema seat | Half the sideways conversations are about ground already decided — the cheapest prevention available |
| **§2** | The **decomposition** — eleven dimensions; "kind" is one | A "kind" is a *point* in this space; naming axes is what lets two people discover they meant different points |
| **§3** | The **capability axis** — jobs, and the four horizons of knowability | Evidence-anchored dual of §2 |
| **§4** | The **payoff** — drives / forecloses / easy / awkward, per modality | Joseph's actual question, answerable once §2–§3 exist |
| **§5** | The **UDON-specific axes no borrowed tradition covers** | Where inherited practice runs out and real design starts |
| **§6** | The **projection matrix** — and the Arch-Schema instinct's test | Both directions: what UDON emits, and what it must absorb |
| **§7** | **Generative proposals** | What the map suggests that nobody has proposed |
| **§8** | The **honest ceiling** | What no schema kind can buy — measured, and it bounds every row above |
| **§9** | **Carve-out dependencies** | Register hygiene: nothing here closes an open question |

---

## 1. The seat is already shaped — ratified constraints on any schema design

CORE §1.1 assigns "Constraint (what is allowed/required)" to an owner named **Schema**
that does not yet exist. The seat is not empty of law. These are *decided*, and they
eliminate real regions before anyone sketches syntax. An agent who does not hold them
will re-derive foreclosed designs — the most predictable waste available here.

| # | The constraint | Cite | What it forecloses / creates |
|---|---|---|---|
| **1.1** | **Schemas judge the model; they do not shape it.** "Nothing in the model is invalid by schema; schemas judge the model, they do not shape it." | MODEL §8 | Forecloses the strong grammar-kind — a schema that changes *how a document parses*. Any grammar-shaped schema must be a judge-of-the-tree, never a parser variant. Also forecloses schema-directed disambiguation and schema-driven coercion |
| **1.2** | **Dialects are not Schemas** — "a dialect says what a value *means*; a schema says what is *allowed*. They never trade jobs." | CORE §1.1 | A schema **cannot define a type**; it constrains which already-typed values go where. `format: date-time`-style semantic hijack is out by construction |
| **1.3** | **Bare recognition is frozen forever**; every non-core type lives in `<…>` | CORE §11.1, §11.6 | The schema layer can never be the reason a document retypes. The Norway class is structurally unavailable — a property to *keep*, not re-earn |
| **1.4** | **Constraining stacking is schema's first named job.** "What is *allowed* (e.g. forbidding a multi-valued `$key`) is schema territory, never core." | CORE §6.7 | An explicit first task: cardinality over the stack. And the model keeps `:x 1 :x 2` distinct from `:x [1 2]` (MODEL §3) — so schema cardinality has **two** things to talk about |
| **1.5** | **Flag suffixes are reserved *for the schema* and left unassigned.** "The core performs only the expansion; meaning belongs to the consuming schema or dialect (a schema might read `?` optional / `!` required; a grammar might read `?` 0-or-1, `*` 0-or-more, `+` 1-or-more)." | CORE §5.4 | **The syntax seat for a constraint vocabulary already exists, unassigned, with a suggested reading on the record.** See §7.1 — the sharpest single fact in this document |
| **1.6** | **Menu vs knob.** The core MAY fix an option space and a default; a consumer picks within and MUST NOT invent options outside it | CORE §1.1 | Strictness profiles (casual/careful/critical) are a **menu** question, not a free knob — and the menu is core's to fix |
| **1.7** | **Duplicate definitions already have a menu**, default `error` | CORE §12.3; DECISIONS **R14** | The YAML wound that motivated half the schema demand (silent last-wins) is *already answered by core law*. Schema inherits the menu; it does not need to re-solve it |
| **1.8** | **Anomaly severity is defined by loss**, two-valued, and a *recognition-layer* property | CORE §14.1, MODEL §7 | Schema violation loses nothing, so it does not fit `Error = loss`. **The schema verdict channel is probably a different object from the anomaly channel** — see §7.3 *(proposed reading of decided law)* |
| **1.9** | **Designated `$`-attributes are ordinary attributes**; sugar and longhand are indistinguishable in the model | CORE §5.3, MODEL §3.1 | Schema constrains `$key`/`$traits`/`$?` with ordinary machinery — no parallel identity language. And it MUST NOT distinguish `\|el[k]` from `:'$key' k` |
| **1.10** | **`$partial-key` must be excluded from identity by any consumer** | CORE §5.3 | A conformance checker inherits the fail-safe: a truncated identity must never satisfy a uniqueness or reference constraint |

**The seat, compactly:** UDON's schema is a **post-recognition judge over a
keep-everything model whose types it may constrain but never assign**, with an
unassigned suffix vocabulary already reserved for it and stacking-cardinality as its
first named job. That sentence rules out more designs than it sounds like.

---

## 2. The decomposition — a "kind" is a point in eleven dimensions

Each row is an axis on which two people can silently differ. Named schema traditions
bundle several at once, which is exactly why arguing about kinds goes sideways:
JSON-Schema-vs-Ash is a disagreement about six axes simultaneously, and the parties
rarely mean the same six.

### 2a. Modality — *how* the schema says what it says

Joseph's "kinds" axis, restored as one dimension.

| Modality | Says validity by… | Precedent |
|---|---|---|
| **Prototype / example** | exhibiting a conforming instance | vivarium's tail-of-file (*evidenced*, I5); "the canonical example" everywhere |
| **Constraint predicate** | predicates instances must satisfy | JSON Schema; Schemacop; rowan's `one_of`/`when_value`/`dependent_required` (*shipped*) |
| **Grammar / production** | rules generating the conforming set | `core/generator/*.descent.udon`; tree-sitter; RELAX NG |
| **Class / resource declaration** | a named object owning fields, behavior, lifecycle | Ash, rowan resources, ActiveRecord (*shipped*) |
| **Procedure** | arbitrary code returning a verdict | vivarium's `bin/check`; every hand-rolled linter |
| **Corpus-inferred / statistical** | what the neighbours do | the modal agent read-path; nobody's declared design |

These are not exclusive, and they compose *asymmetrically*: a prototype plus constraint
annotations is still **one** artifact (§7.1); a class plus a separate constraint
language is **two** artifacts that drift (*testimony*, grok, on the Rails
DB/model/params/serializer split — "four schemas that drift").

### 2b. Substrate — what the schema is *written in*

UDON itself · an external formalism (JSON Schema, Schemacop, CUE) · host-language code ·
nothing (implicit in the corpus).

*Testimony* (grok): an external formalism "cannot faithfully represent 'document as
literature + data' if the host formalism assumes records and arrays only… **often
forecloses comment and prose preservation, which for your setting is not a detail**."
*Testimony* (Claude): "Every time I've seen a project schema a format X using formalism
Y, the Y artifact rots faster than X itself, because it's maintained by a different
discipline on a different cadence."

### 2c. Executability — inert data ⟷ requires a runtime

**The pivot axis.** *Testimony* (Claude, unprompted): "the 'owns migration' superpower
and the 'usable everywhere, in any tool, without executing arbitrary code' superpower
are in real tension, and I don't think you can have both without picking a lane."

*Evidenced*, and sharper: in the estate, migration works because **the transform lives
in the class** — `upcast from:` blocks composed across `known_versions`, "storage is
never rewritten; the transform happens on the way out" (report §6.2, ll. 861–886). No
constraint-language-only schema in the estate has any equivalent. **Migration is a
property of the class-modality, not of schemas generally.** §6 is the estate's escape
from the either/or.

### 2d. Descriptive vs. owning — and the five meanings of "has type X"

Judge-only ⟷ owns the lifecycle (creates, defaults, migrates, exports). Cross-cuts 2a.

*Testimony* (codex) sharpens this into the most quotable distinction in the whole
testimony set — "this document has type `Person`" can mean at least five things, and
"those should not be smuggled together":

1. A tool may use that name for completion and documentation.
2. A validator verifies it strictly.
3. A loader **coerces** values into that shape.
4. A generator emits a corresponding runtime type.
5. The declaration controls what a consumer will **accept**.

Note (3) is largely foreclosed for UDON by §1.2/§1.3, and (4) is where §6 lives. The
point stands: a schema declaration that does not say *which* of these it is has already
started a sideways conversation. *(Worth adopting as vocabulary regardless of design.)*

### 2e. World-openness and declaration strength

Closed (unlisted forbidden) · open (unlisted permitted, preserved) · **graded** (a
severity per rule). All three substrates converge here, independently and with
different proposals — the strongest testimonial agreement in the set:

- Grok: `additionalProperties: false` is "a culture war — great for closed configs,
  catastrophic for extensible documents"; wants "soft constraints with budgets."
- Claude: wants "hard constraint and soft convention-based lint in the same schema
  artifact with different failure severities," and reports knowing no format that does it.
- Codex: proposes declaration **strength levels** — *illustrative / recommended /
  deprecated / required / forbidden* — "a schema can record confidence and policy
  strength. Not every useful bit of structure deserves to make a file fail validation."

UDON has an unusual asset: keep-everything is already law (§14.2), so **open-world is
the model's native posture**, and a schema that closed the world would be fighting it.
*(proposed reading.)*

### 2f. Locus of ascription — who says which schema applies

Producer-side self-description (`_schema: autopax-agent-card/2.0.0` — *shipped*, report
§5.1) · **consumer-side ascription** (Joseph's include sketch: "assuming it is compliant
with *my* schema and version" — `../living-documents/README.md` §1b; Dhall's typed
imports are the shipped prior art) · ambient/positional (directory-as-table; filename
designator) · none.

**This axis sits directly on the open carve-out PRAGMA.** See §9.

### 2g. Temporal extent — snapshot vs. versioned-with-relation

The estate's deepest material, and more scoped than a summary suggests:

- *Shipped*: `was:` renames, upcast blocks, schema history, differ, decision log,
  `evolve` with mutex (report ll. 818–831 gives an explicit implemented/pending split —
  read it before citing any of this).
- *Designed-only*: RDBMS expand-contract with triggers, `.archema/transitions/`,
  `as_of` temporal queries, agent-annotation syntax.
- **Contraction, precisely.** Lifecycle is four phases — Expand → Monitor → Contract →
  historical awareness forever — and Contract is **store-split**: "RDBMS drops the
  column and trigger; **YAML and JSONL take no action**" (ll. 984–986). The gloss:
  "contraction is a storage-substrate concern, not a schema concern. In a document
  store there is nothing to contract… The cost of an old address never expires, and
  neither does its resolution." So "contraction never happens" is true **of document
  stores** — which is UDON's case. *evidenced*, ll. 991–994.
- **On "auto-up/down" specifically:** *down* is largely a mirage here.
  Forward-compatibility declarations are, in the estate's own words, "primarily
  documentation," since a schema cannot bind a future reader (ll. 780–783). The demand
  corpus warns backward translation "that silently drops new-only data reintroduces
  exactly the duplicate-key failure class one layer up" (`typing-and-schema-boundary`).
  And *testimony* (codex) names the deeper problem for a *document* format: "'up' and
  'down' migrations may be a false promise: **prose cannot always be transformed
  losslessly**, a split concept may require interpretation." Its proposal is to
  distinguish **mechanical / lossy / requires-human-judgment** rewrites — "an agent
  needs that distinction intensely: a mechanical conversion may be safe to perform; a
  prose-sensitive reinterpretation should be surfaced as a question."

### 2h. Verdict granularity and shape

Whole-document boolean · verdicts **located at a path** · per-node/fragment ("what is
allowed *here*, given only this subtree") · **diff/transaction validation** ("this
patch, applied to this document, still yields a valid document").

All three substrates name the last two as their top unmet want, independently. Grok:
"validate the edit, not only the file… cursor-local constraints exported as a small
context pack." Claude: "validate a *diff* against a schema and the prior document
state." Codex: "a system that exposes only rendered strings leaves agents guessing; a
system that exposes structured constraints lets agents make safe proposals." *Evidenced*
on the demand side: the guarded edit's pinned shape is a transaction, not a file check.

### 2i. Reach — what one schema governs

One document · **a region within a document** · a directory/collection · cross-document
references.

The region row is the estate's sharpest empirical finding and closest to UDON's shape
(*evidenced*, report §12.4, ll. 2226–2277): `strip_working_notes` recovers a region
boundary by `rindex` over rendered prose, resting on an unenforced "trailing section"
convention — "a segment with a stray `## Working Notes` mid-body… silently truncates
the record." The region is invisible to the schema, cannot be addressed, cannot be
validated separately, and its cardinality is accidentally fixed at one. And the
asymmetry: **the kept region has a schema; the discarded region does not** — "backwards
from a durability standpoint." The report's four requirements for a cluster-aware schema
(declared parts with addresses; per-part rules and admission; per-part lifecycle;
assembly semantics) read as a near-direct sketch of what a UDON schema must say about
regions.

### 2j. Projection — can this kind be compiled into another kind?

*The dimension neither Joseph's sampling nor the brief carried, surfaced by his own
schemacop pointer.* Rowan's resource is not *a* schema kind; it is a **source kind with
four shipped projection targets**: agent-tool definitions, JSON Schema, Schemacop
DSL/object, and per-store schemas (SQL constraints + triggers, YAML). Verified at
`~/src/rowan/docs/usr/12-tool-export.md` and `docs/sys/resource.md` ll. 48–49, 199–200,
593–614. Generalized by the report: "if the schema is the single source of truth, the
agent interface is a projection of it" (ll. 2492–2495).

This reframes §4's foreclosure table: a hard foreclosure at the **source** kind is
fatal; the same foreclosure at a **projection target** is a lossy edge. Fully developed
in §6.

### 2k. Unit of schematization — document, or *role*?

*Testimony* (codex), arriving at this from first principles with no project context:
"the most useful first-class concept is a **document role** or **resource kind**: a
named, versioned description of what a particular document — or a region of a document —
is trying to be," owning at once its shape, its human description and examples, its
compatibility version, its validation profile, its editor affordances and template, its
migration hooks, its extensibility points, and **its declared authority (normative
contract / recommendation / private convention)**.

Worth flagging as a small convergence in its own right: a context-free agent asked what
the unit should be **invented the resource-shaped kind** — the same shape rowan ported
from Ash and the same shape §2i's cluster-record requirements describe. Three arrivals,
different directions.

---

## 3. The capability axis — jobs, and the four horizons of knowability

The dual of §2. Most schema disappointments are a kind strong at one cell being asked
to serve another.

**Jobs** (codex's "promises," compressed): guide authoring · accept/refuse · migrate ·
describe & discover · generate (skeletons, tool definitions, views) · project/interop ·
authorize · *negotiate responsibility* (§3b).

**The four horizons.** *Testimony* (codex) supplies a better organizing axis than
clock-time, because it is about *when a constraint is knowable at all*:

1. **Lexical / syntactic** — deterministic, immediate, should work on incomplete
   documents. *(For UDON this is entirely core's, already — §1.1.)*
2. **Local structural** — checkable from the node or document alone.
3. **Semantic / cross-reference** — needs more context; "frequently creates editor
   friction if treated like syntax errors."
4. **Environmental / policy** — the file exists in *this* repo, the version is
   deployed, permission is held. "Real constraints, but not intrinsic properties of a
   document. They vary among machines, branches, times, and users."

"A bad schema system makes all four look equivalent. Then users see a red error marker
because a remote service cannot be reached, or cannot draft a document because the
object it refers to will be added in the next commit." That failure is *specific,
predictable, and cheap to avoid by naming the horizons early* — which is why it earns a
place above the capability table rather than inside it.

### 3a. Capabilities, evidence-anchored

A sampling of what is *cited*, explicitly not the capability universe:

| Capability | Job / horizon | Register |
|---|---|---|
| **The schema-guarded edit** — validate inside the write, atomic, mutation-free refusal | accept, at the write | *evidenced*, the corpus's #1 demand, and its **only four-kind convergent lock**: design intent + the *absence* across all shipped editors + the measured YAML stress test + external MCP fault data (`schema-guarded-mutation`) |
| **Conformance as a machine verdict** a gate consumes (codes, addresses, counts) | accept, build | *evidenced*, four chapters converge on the shape (`typing-and-schema-boundary`, `errors-that-teach`, `templates-and-dynamics-demand`, `structured-output-two-mechanisms`) |
| **Verdicts located at a path** | accept, any | *evidenced* — "schema addressing **is** paths" (paths seed §1) |
| **No silent retype; duplicates kept in order** | accept, read | *evidenced* — and **already discharged by core law** (§1.3, §1.7), not schema work |
| **Read-time migration without a flag-day** | migrate, read | *evidenced*, *shipped* (`was:`, upcasts) |
| **Tool-definition export** (resource → agent-tool JSON) | generate, build | *evidenced*, *shipped* (report §13) |
| **Schema travels with the conversion** | project | §6 — Joseph, 2026-07-28; *shipped* instance is `to_schemacop` |
| **Two-outcome refusal** — `.rejected` (submitter erred) vs `.needs-review` (the system's *own* uncertainty); collapsing them "would mislabel system-uncertainty as user-error" | accept, write | *evidenced*, *shipped* (relata ingest, ll. 1010–1099). The single most transferable design detail found |
| **Skeleton generation from the schema** — emitting a fillable skeleton so an agent conforms *without reading the schema* | guide, authoring | *evidenced*, **designed-only** (ADR-010); the inverse move of `_schema`-in-the-document |
| **Head-line lint** over a live corpus | accept, save | *evidenced* (vivarium I5) |
| **Strictness profiles** (casual / careful / critical) as an axis orthogonal to schema shape | all | *evidenced* as an open design question, twice stated (`schema-guarded-mutation`, `priorities-and-spike-agenda`) |
| **Three-valued absence** — "nothing to say" / "data unavailable" / "hidden", where `required: true` collapses all three | accept, semantic | *evidenced* (`templates-and-dynamics-demand`) |
| **Fragment-local "what is allowed here"** | guide, keystroke | *testimony*, all three substrates, top want |
| **Patch/diff validation** | accept, write | *testimony*, all three |
| **Nearest-conforming counteroffer** on refusal; **repair confidence** (mechanical vs. needs-judgment) | accept, write | *proposed* (corpus) + *testimony* (codex) |
| **Schema-aware structural merge** | accept, merge | *proposed*; `freshness-and-atomicity` names the same gap from the freshness side |
| **Corpus-example discovery** — "show me three real instances of this section" | discover | *testimony*, all three — and it needs **no formal schema at all** |

### 3b. Two capability observations worth carrying

1. **Some demanded capabilities are already discharged by core law.** No-silent-retype,
   duplicate-keeping, and the duplicate menu are *core* (§1.3, §1.7). A schema design
   that re-solves them is redoing settled work, and a conversation that treats them as
   schema requirements is one of the sideways paths this map exists to close.
2. **Schema as a collaboration protocol, not only a constraint system.** *Testimony*
   (codex), named as the most under-explored direction: a schema "says who owns a
   concept, what is stable, what is experimental, what a local author may extend, what
   must be synchronized with another file, **what can be safely automated, and what
   requires a decision**… The most dangerous thing for an automated editor is not a
   missing scalar type; it is an invisible social contract." Given that this project's
   end-users *are* automated editors, this may be the highest-value unglamorous
   direction on the map.

### 3c. The posture split — a decided principle that constrains every verdict

*Evidenced and already decided in the corpus* (`streaming-and-partial-documents`):
generation wants **soft recovery** (keep everything, warn, continue — half a document
beats none); careful writes want **hard, mutation-free refusal** (half an edit is worse
than none). "Same language, opposite postures, selected by stage and stakes — the
tooling mistake would be letting either posture colonize the other."

Consequence for schema: a conformance check must know **which posture it is being asked
to enforce under**. That is the strictness-profile axis (§2e / §3a) arriving as a
requirement rather than a preference — and it means "is this document valid?" is an
underspecified question even after the schema exists.

---

## 4. The payoff — drives, forecloses, makes-easy, makes-awkward

Joseph's question, now answerable. Each row holds the modality fixed and the other ten
axes free; §2 is where the qualifications live.

| Modality | Drives (hard) | Forecloses (hard) | Makes easy | Makes awkward |
|---|---|---|---|---|
| **Prototype / example** | onboarding; imitation; agent few-shot editing; **works natively over prose, because an example *is* a document** | exhaustive accept/reject; mechanical migration; proving a *novel* combination legal | zero-ceremony adoption; the modal foreign-repo read-path | invariants invisible in one instance (mutual exclusion, cross-field, ranges); saying "never"; staying in sync — "untested examples rot and become lies that agents trust more than the schema" (*testimony*) |
| **Constraint predicate** | closed-world accept/refuse; CI gates; interop contracts; form and doc generation | owning runtime behavior; migrating with domain semantics; expressing intent | red/green verdicts; enums, ranges, required sets | defaults and fill-in; gradual typing of organic documents; **disjunction errors** — no ecosystem has solved "which branch did you mean" (*testimony*, all three substrates independently); prose structure |
| **Class / resource** | **migration** (the only modality that ships it); defaults; computed members; **projection into other kinds** (§6); policy/ownership colocated | being a portable contract without exporting a projection; serving a drive-by editor holding only the file | behavior co-located with shape; one source of truth | documents outside an app lifecycle; polyglot consumers; editing without booting the world; prose-primary files that are not rows |
| **Grammar** | well-formedness; incremental parse; **error recovery that keeps a tree alive while the file is broken** | semantic validity of any kind — "tell you that `replicas: -1` is wrong if the grammar allows integers" (*testimony*); migration | editor experience; structural editing | value constraints; cross-references; versioned key vocabulary. **Also: §1.1 forecloses its strong form in UDON outright** |
| **Procedure** | anything expressible in code; **the incident-response schema** (vivarium's `bin/check`, built the day the wound appeared) | portability; static analysis *of the schema*; interrogability | shipping today, at the moment drift bites | review; drift from any declared intent; no discoverability surface; nothing to project from (§6) |
| **Corpus-inferred / convention** | zero-cost adoption; local adaptation; **the kind already in force everywhere** | guarantees; en-masse migration with confidence; complete client generation | matching how humans and agents actually work | enforcement; onboarding at scale; **its failure mode *is* silence** (*testimony*) — with the estate's demonstrated instance in §2i |

**Cross-cutting foreclosures — these belong to axes, not modalities, and are the ones
most likely to be mis-attributed to a "kind":**

- **Executability (2c) forecloses portability; inertness forecloses migration.** The
  sharpest either/or on the map. §6 is the escape.
- **External substrate (2b) forecloses prose and comment fidelity** in practice — not a
  detail for UDON.
- **Closed world (2e) forecloses extensibility**, and in UDON would additionally fight
  keep-everything (*proposed* but I think sharp).
- **Whole-document verdicts (2h) foreclose the guarded edit.** The corpus's #1 demand
  selects a *granularity*, not a modality — which is why "which kind gives us the
  guarded edit?" is a mis-posed question.

---

## 5. Where borrowed practice runs out — three UDON-specific axes

Everything above transfers from formats that exist. These do not, and I think the real
design lives here.

### 5a. Tier coverage — *which parts of a UDON document can a schema even talk about?*

"Which kind of schema" hides a prior question: **what can it address at all?**

| Tier | Covered by inherited practice? | Note |
|---|---|---|
| Element structure / nesting | yes (XSD, grammars, RELAX NG) | the well-served case |
| Attributes and values | yes (every constraint language) | plus UDON-specific **stacking cardinality** (§1.4), with `:x 1 :x 2` vs `:x [1 2]` staying distinct |
| Identity `[key]` and traits | partly | uniqueness over `(name, key)` is already a document-layer menu (§1.7); traits are an AND-filtered classification with no schema tradition |
| **Prose / text runs** | **essentially not** | half the document. §5b |
| **Comments** | **no** | comments are first-class model items, carried not discarded (MODEL §5). Can a schema *require* a comment? Forbid one? The estate's `## Working Notes` admission rule is the nearest thing and it is convention-enforced-by-review |
| **Verbatim bodies** | no | "this `!:sql:` body must parse as SQL" is a schema statement crossing into another language entirely |
| **Dynamics** | **no** | §5c |
| Envelopes / dialect-typed values | no | schema constrains *which* dialect-typed values go where, but per §1.2 may never say what they mean. Easy to state, easy to violate |
| References `@` | partly | referential integrity is a known tradition; UDON's `@` is an **inert selector** whose resolution is a host menu (CORE §12.2) — so "must resolve" is a schema statement about something the core deliberately does not do |

**The observation:** borrowed practice covers the top two rows well and essentially
nothing else. A kinds-map that only ranks modalities is answering a question about the
two rows UDON shares with YAML, and silent on the rows that make UDON UDON.
*(proposed — mine, and the axis I'd most want stress-tested.)*

### 5b. Schema over prose

The demand is real: half the documents are prose. The estate's one direct attempt
(ADR-010's markdown-structure DSL — headings by level/pattern/required cardinality,
content blocks with `min:`) is **designed-only and blocked** (*evidenced*, report §12.3,
status EXPLORING). The corpus sweep confirms the gap is genuine rather than
deliberately scoped out: nothing addresses head-line lint, narrative ordering, or
required-section constraints, and `RESIDUALS.md` does not list it as a known gap
either — a blind spot, not a decision.

*Testimony* (grok) gives the most useful decomposition found — schema over prose can
mean six different things: **genre/document-type · structural outline constraints ·
embedded data islands · inline structured phrases · semantic roles ·
machine-checkable claims (IDs, cross-references)**. Verdict: "mostly genre + outline +
island boundaries + reference integrity + role labels. It is almost never sentence
grammar of truth." Its named failure mode is exactly what an ambitious estate would
build: "'Every claim must have evidence subtree' sounds good and produces cargo-cult
headings with empty content to pass CI." Codex converges: soft structural guidance —
section roles, repeatability, ordering *recommendations*, status metadata, templates —
and warns against "requiring authors to put meaningful narrative inside an opaque
`description: |` blob because the data model cannot accommodate interleaving."

Two UDON-specific notes (*proposed*): UDON has **no island-boundary problem** in the
sense grok means — prose and structure interleave by geometry, not fencing, so the
boundary is the **content base** (CORE §7.2), already a precise, addressable thing.
That may put UDON ahead of markdown-plus-frontmatter here. Against that: UDON's text is
deliberately **opaque** at the core (CORE §7.1), and the markdown concern map already
assigns the `doc` element vocabulary to the **schema layer**
(`../markdown/usage-topics.md` §2) — so "schema over prose" and "the `doc` schema" are
on a collision course neither map has noticed.

**Counter-position worth carrying** (*evidenced*, `counter-register` row 2,
`discussion-grade`): Obsidian deliberately keeps its schema-like layer (frontmatter
properties) to "small, atomic bits," explicitly refusing rich structure in properties —
a shipped, considered argument that schema and prose should stay *more* separated than
UDON's model assumes. An argument to answer, not a cap on the claim.

### 5c. The computed-document duality

UDON documents compute: `!if`, `!for`, `!{{interpolation}}`. **A schema over a
pre-expansion document and a schema over its post-expansion result are different
objects.** No borrowed tradition handles this; protobuf, JSON Schema, and XSD are all
schemas over inert data.

The corpus **has** noticed the seam and deliberately declined to design across it
(*evidenced*, `templates-and-dynamics-demand`): a template is *interrogated* for its
required context before it is built, and "the interrogation's answer is itself a small
schema" — but one describing the document's **inputs**, not its output shape. A static
schema over the rendered document says nothing about whether the render will succeed.
The chapter logs the two evaluation sites as "unification pressure, deliberately not
acted on," reasoning that "unifying before the demand picture says when each is
expected will just invent a prettier wrong boundary."

Notably, *testimony* reached the same split unprompted (Claude, this seed; and per the
chapter's own Working Notes, Gemini and Grok in prior rounds) — with the corpus
carefully re-tagging those as *two testimonial sources, not a third independent kind*.
Worth knowing when citing: the seam is well-witnessed, the design across it is
deliberately absent.

Questions it opens (*open*): which object does a conformance verdict mean? Can a
template be *proved* to emit conforming output for all inputs — a schema over the
generator, not the product? What does the guarded edit validate when the edited node
sits inside a currently-false `!if` branch? And it connects to
`../living-documents/README.md` §1b: an ascribed include ("assuming it is compliant with
my schema and version") is **a schema check at a slot, pre-expansion** — §2f's
consumer-side ascription, applied per-insertion-point.

---

## 6. The projection matrix — and the Arch-Schema instinct's test

Joseph, 2026-07-28: *"the inevitable udon tools like udon-to-json etc. may also want to
try to pass along an appropriate schema where appropriate (especially where required,
like protocol buffers etc.)"* — and separately, the superset-schema-ability instinct.
Those are one thing seen from two ends, and together they make the instinct testable.

### 6a. Export — schema travels with the conversion

Conversion targets split on whether schema is optional or mandatory:

| Target | Schema | Consequence |
|---|---|---|
| JSON, YAML | **optional** — a JSON-Schema may accompany | conversion works schema-less; schema is an upgrade |
| Protobuf, Avro, SQL DDL, GraphQL SDL, XSD-consuming pipelines | **required** — the schema *is* the artifact | `udon-to-protobuf` **cannot exist** without emitting a `.proto`. The target makes schema mandatory, not optional |

*Shipped in-estate instance of exactly this operation:* `Resource.to_schemacop` /
`to_schemacop_dsl` — a resource-shaped schema compiling to a constraint-shaped one
(§2j). And modalities differ sharply in how well they project: resource-shaped goes to
`.proto` almost mechanically; constraint-shaped goes reasonably; **grammar-shaped
projects awkwardly; example-shaped cannot project at all without inference** — and
inference-as-projection is precisely the move that turns observed regularity into a
false requirement (*testimony*, all three substrates warn about it).

**So the schema-required targets exert design pressure back onto §2a**: if
`udon-to-protobuf` is wanted, the map's cheap modalities (prototype, convention) cannot
serve as the *source* kind — which is an argument for §2j's source-plus-projections
architecture arriving from a completely different direction than rowan's.

**The caution that must travel with this**, and it is sharp (*testimony*, codex): "It is
tempting to choose the schema language by asking which one generates clean classes in a
favorite target language. That is too narrow… If generation is treated as
authoritative, the schema will be pressured to erase the things that make the document
language valuable. **The generated model becomes the hidden 'real' language, and
authored documents become merely serialization.**" For UDON that erasure has a name:
it is the prose, comment, and interleaving tiers of §5a — exactly the rows no target
format can represent. Its proposed discipline: **a capability matrix per schema
feature, naming what each target loses** — "it is completely acceptable for some schema
features to be editor-only or documentation-only, as long as the system says so."

### 6b. Import / absorb — the other direction, and the instinct's test

The superset ambition has a checkable dual: **can the canonical form express what each
existing formalism expresses?** That question is concrete, enumerable, and answerable —
which is what a lay-of-the-land map can give an instinct.

A first pass at what a superset would have to span (*proposed*, and offered as the
frame for a real audit rather than as the audit):

| Formalism | What it expresses that UDON's schema would need to absorb | Hard? |
|---|---|---|
| JSON Schema | composition (`oneOf`/`allOf`), conditionals, `$ref` graphs, open/closed posture | tractable; disjunction *diagnostics* are the unsolved part everywhere |
| Protobuf | field numbers as identity; reserved/removed discipline; presence semantics; wire compatibility as a *designed* property | the compatibility vocabulary is the valuable part; the message model is not |
| CUE | schema-as-partial-value unification; concrete vs. incomplete | §7.1 suggests UDON may get this natively |
| RELAX NG / XSD | mixed content, ordered content models, interleave | **the only tradition that seriously models prose-and-structure interleaving** — likeliest source of prior art for §5b |
| tree-sitter / grammars | well-formedness, error recovery, partial trees | §1.1 forecloses adopting it *as* schema; its **error-recovery product** is still wanted |
| Ash / rowan resources | lifecycle, migration, calculations, policy, projections | §2c's runtime dependency is the obstacle to absorbing it inertly |
| Schemacop | a compact requiredness/optionality DSL vocabulary | §7.1 — the vocabulary is nearly already UDON's |

**The instinct's test, stated plainly:** the superset claim is true iff the canonical
form can express every row's *distinctive* content and project back out to it with
named, acceptable losses. That is a finite audit. It is also where the pattern Joseph's
coordinator noticed can be confirmed or broken — paths dropped one-true-syntax for a
coherent collection of forms; markdown became a collection of surfaces with owners; and
this territory's shape would be **a canonical spine with digestible projections**. If
the audit shows the spine must be executable to span the rows (§2c), the "obtuse
canonical, digestible exposures" instinct is vindicated in a specific and uncomfortable
way: the canonical form would not be inert data. That is worth knowing before it is
assumed either way. *(open — and the single most decision-shaping unknown on this map.)*

*Anchor note:* §6c checks the resource-shaped row against **living Ash** rather than
rowan's port snapshot — and one of its findings (derivation degrades outside the
framework's own data layer) bears directly on whether this audit's answer is as clean
as the table's shape suggests.

### 6c. Ash — current state (checked 2026-07-28, at Joseph's suggestion)

The resource-shaped row was anchored to a port's snapshot (rowan); this checks it
against the living ancestor. Ash is at **3.31.0**, steady incremental 3.x cadence, no
rewrite. Four results matter to this map:

- **Projection is now a first-class, named API.** `Ash.Info.manifest` (v3.25.0,
  2026-05-17) is an explicit filterable introspection surface whose *stated purpose* is
  to be **a basis other code generators consume** — Ash formalizing "the resource
  projects into other artifacts" rather than leaving it implicit in Spark internals.
  That is precisely the mechanism §2j and §6a depend on, and it is the strongest
  available evidence that source-kind-plus-projections is a *load-bearing* architecture
  rather than one shop's habit. *(evidenced — CHANGELOG.)*
- **The estate's migration claim holds, with one footnote.** No built-in read-time
  upcasting of records written against an older resource version; nothing resembling
  rowan's declared-rename/upcast-chain ledger. AshPostgres' generator *does* detect a
  plausible rename and **ask you** — but that is a generation-time heuristic prompt, not
  a durable lineage the system consults later. Migration remains destination-state-
  shaped. **Footnote:** `AshEvents` carries real event *versioning* (events carry a
  version; replay skips side-effecting hooks) — schema evolution for the event log
  only, opt-in and separate, not for resources generally. So the estate's "ORMs
  generate migrations for the destination state, not the transition" (report
  ll. 999–1002) stands. *(evidenced.)*
- **The lossy boundary is named by a practitioner, not by Ash.** Derivation's value
  "specifically depends on staying inside Ash's own data layer" — a manual/non-Ecto
  data layer wrapping an existing system "removes much of Ash's 'derive the rest'
  automation, the framework's primary value proposition." And Ash "doesn't
  automatically extract or organize existing logic" — *it organizes, it does not
  excavate*. **This is the projection architecture's real cost, stated from outside**:
  derivation is strong inside the walled garden and degrades at its edge. Read against
  §7.2, it says the source kind must *own* its substrate for projection to pay — which
  is an uncomfortable finding for a notation whose documents live in other people's
  repos. *(evidenced — independent practitioner report, 2025-11-02.)*
- **"The schema" is still annexing, not converging.** Policies now reach into
  aggregates and composite types; a pipelines DSL composes action logic; multi-hop
  `Relationship Through` landed. Ash's declarative surface keeps absorbing more of
  *what the resource means* — relevant because §2d's descriptive/owning axis has no
  visible ceiling in the living system.

**And the finding neither Joseph nor I anticipated:** Ash's highest-velocity work in
2026 is not in the core DSL at all — it is **making resources legible to AI agents**.
`AshAi` ships *prompt-backed actions*, where an action's **declared return type becomes
the JSON schema constraining an LLM's structured output**, plus resource-derived
tool-calling at the domain level (so the security boundary is the same policy layer as
everything else) and MCP servers. That is the schema-constrained-emission capability
(§3a's "one guard, three doors," generation-time door) **shipped** in the resource-shaped
lineage. Separately, `usage_rules` is a cross-package convention — any Elixir library —
for shipping machine-readable "what an agent should know to use this correctly,"
synced into the consuming project's `AGENTS.md`/`CLAUDE.md`. Both are instances of a
declaration projecting **agent-facing artifacts** as first-class outputs, which is
§3b's collaboration-protocol idea already in production somewhere.

*Honest gaps in this check:* no documented account was found of where AshGraphql /
AshJsonApi generation gets lossy for specific type shapes (union/polymorphic types are a
plausible seam, inferred from a bugfix entry — a lead, not a finding), and no worked
example of Spark DSL state exported to a **non-Ash** formalism. That second gap is the
one that matters most to §6b's superset audit and is worth a targeted chase before
anyone relies on "resource-shaped projects cleanly into arbitrary formalisms."

---

## 7. Generative — three things the map suggests

### 7.1 The prototype and the constraint may be one artifact — and UDON already has the syntax

*The sharpest single finding in this seed.* Assembled from decided law plus a verified
estate fact:

- CORE §5.4 reserves the flag suffixes `? ! * +` for the consuming schema, **explicitly
  unassigned**, with a suggested reading on the record: "a schema might read `?`
  optional / `!` required."
- Rowan **ships** `Resource.to_schemacop_dsl`, generating Schemacop 3 source — and that
  DSL spells requiredness exactly that way: `str! :email` (required), `sym? :role,
  default: :user` (optional). Verified, `~/src/rowan/docs/usr/12-tool-export.md`
  §Schemacop Integration. Joseph named schemacop as an inspiration "back in the archema
  days"; the estate went past inspiration into a shipped export target.
- Traits (§5.3) are "what *kinds* of thing it is"; anonymous trait-only elements plus
  trait-matched inheritance are already the (experimental) mixin mechanism (§12.4).

Put together (*proposed*): **an annotated example document is a schema.**

```udon
; a prototype that is also a constraint — no second language, no second substrate
|user
  :email!  <str:/@/>        ; required, dialect-typed
  :role?   user             ; optional; the prototype value doubles as the default
  |profile?                 ; optional child
  |post*                    ; zero or more
```

Why this is worth *stressing* rather than admiring:

- It is **CUE's unification** — schema as a partial value — praised unprompted by
  *testimony* as the design that "collapses 'the example' and 'the constraint' into one
  artifact," arriving **natively**, in reserved syntax, in a format whose end-users
  demonstrably learn by imitation.
- It directly answers the live wound (*evidenced*, vivarium I5): if "conformance is
  currently imitation, not validation" and "every one of us wrote rows by
  pattern-matching the tail of the file," then the cheapest schema layer is one that
  makes the tail of the file **declarative** — promoting imitation into validation at
  near-zero authoring ceremony.
- That in turn satisfies the **incident-gated norm** the same consumer stated (build it
  "the day attribute drift first bites someone — not before"): a kind this cheap can
  exist *before* an incident, because writing it costs about what writing an example
  costs. Every other modality on the map fails that affordability test.
- It also answers the testimony's most-repeated warning — that people "will trust the
  example, always" — by making the trusted artifact *be* the checked one, rather than
  fighting a cognitive fact.

Honest edges: the modality's hard foreclosures (§4) do not vanish — an annotated
prototype still cannot express mutual exclusion, cross-field conditions, or migration,
and per §6a it cannot project to schema-required targets without inference. The suffix
vocabulary is four characters, and **§1.5's own sentence already oversubscribes them**
(`?` reads as schema-optional *and* grammar-0-or-1 in one breath). Whether the schema
document is itself a UDON document with an identity, version, and schema of its own is
unaddressed (see §9, PRAGMA).

### 7.2 Source kind plus projections — the estate's answer to "which kind"

Fully stated in §2j and §6. The compact form: **don't choose a kind; choose a
*source* kind and derive the rest.** It is the estate's escape from the
executability either/or (§2c) — keep the executable class as the source, project inert
artifacts for run-anywhere consumers — and it is what makes the Arch-Schema
superset instinct architecturally coherent rather than merely ambitious.

The cost is documented and must travel with the idea: rowan's projection needs per-store
**escape hatches** (triggers) "where native constraints can't express the full intent"
(ll. 736–739), so RDBMS migrations become "best-effort projection of the true schema."
**Projection is lossy by construction**; which loss is acceptable is a per-target
judgment, and §6a's caution says name the loss rather than let the target quietly
redefine the source. *(evidenced for the mechanism; proposed as a direction.)*

### 7.3 The verdict channel is probably not the anomaly channel

Following §1.8 (*proposed*): recognition anomalies are severity-by-loss and mechanically
checkable; schema violations lose nothing. Pour schema verdicts into `Warning`/`Error`
and L0's checkable property dies — "fail on error" in CI stops meaning *loss*.

A separate verdict object is the shape all three substrates asked for independently,
and between them they nearly specify it: rule identity · path · what was found · what
was expected (a small set, not a novel) · **which of the four horizons** it belongs to
(§3) · severity on its own scale (codex's *invalid / incomplete / unresolved /
deprecated / discouraged / informational / policy-dependent*) · **provenance — which
authority said so**, since "if a field is prohibited because of a base schema,
overridden by a document role, and tightened by a repository policy, the user should be
able to inspect that chain; otherwise schema composition becomes indistinguishable from
arbitrary tool behavior" · and **repair confidence** (mechanical vs. needs-judgment).
Naming this early is cheap; discovering it after fixtures exist is not.

---

## 8. The honest ceiling — what no schema kind buys

*Evidenced, measured, and it caps every row above* (`counter-register` row 5): roughly
**70% of silent failures were caught only by human product-use, not by 4,286 tests**.
The row states the bound itself: "validation catches malformation, not plausible
wrongness… a value can validate perfectly and still be false."

Two things follow, and both belong in any conversation this map is meant to unstick:

1. **The schema layer's ceiling is malformation.** Every capability in §3a is a
   malformation capability. A guarded edit that refuses non-conforming mutations still
   accepts a conforming lie. The corpus's own proposed answer is *not* more schema — it
   is stated intent as something a verifier checks the diff *against*
   (`intent-as-parameter`), since "is this correct" in a vacuum is not checkable but
   "does this match what it claims to do" is.
2. **The flagship demand is not yet a measured thing.** `schema-guarded-mutation`'s own
   honest edges: "No one has yet built the guarded transaction and measured what it
   saves." Its strength is *convergence of independent kinds asking for it*, not
   anyone having built it. A possibility map should say so plainly, because the
   convergence is genuinely strong and the temptation to upgrade it to "proven" is
   exactly the register slip this estate keeps catching.

There is also a live dissent worth carrying (*evidenced*, `priorities-and-spike-agenda`,
a cross-family reviewer): are rich paths strictly *necessary* for guarded mutation, or
one targeting mechanism among several? "A weaker-but-sooner guard (exact-match
targeting plus post-edit conformance check) might exist." If so, a far simpler schema
kind gets further than the flagship demand assumes — and the probe is asked to test
that rather than assume the strong form.

---

## 9. Carve-out dependencies — what this map pulls on and must not close

`CARVEOUTS.md` exists because three clean-room rewrites, handed the spec without the
*reasons*, diligently closed an open question in a dead framing. Nothing here closes a
carve-out.

| Carve-out | How schema pulls on it | Disposition |
|---|---|---|
| **PRAGMA** — how a document binds dialects, schema, versions | This *is* §2f (ascription) and §2g (version declaration) | **A schema design will force PRAGMA.** It is open because the binding surface depends on schema and dialect pictures that don't exist — the dependency runs both ways and should be worked jointly, never resolved from the schema side alone |
| **PATHS** | Schema selectors, verdicts at a path, per-region addressing (§2i) are all path-shaped; "schema addressing **is** paths" | Schema sits *on top of* the path layer. A schema that invents its own addressing creates a second dialect of addressing — the exact debt PATH-1 and S14 exist to prevent |
| **DIALECT-DEF** | §1.2's boundary is only enforceable once "what a dialect is" exists; "this value must be a `temporal@1` instant" is a schema statement about a dialect artifact | The largest named hole; schema constrains dialect-typed values it cannot yet name |
| **ANNOT** | Annotation vocabulary is already called "schema-owned" (CORE §12.5) | Schema inherits it the moment it exists |
| **MIXIN** | Trait-matched inheritance is a *host experiment*; §7.1 leans on traits | A schema built on mixin semantics would promote an experiment to law by the back door |
| **ML** | Whether `[…]`/strings are sugar for **dialect-typed captures** | If that dissolves as CARVEOUTS suggests, the schema's value-constraint vocabulary is shaped by the capture mechanism, not by list-vs-string rows |
| **IND / IND-2** | A schema-driven generator inserting a node needs an indentation unit | Skeleton generation (§3a) pulls this immediately |

---

## 10. Prior art to mine (so a spike builds on, not over)

- **Schemacop** (`sitrox/schemacop`) — Joseph's named inspiration, **shipped as a rowan
  export target**; a Ruby DSL with `!`/`?` requiredness suffixes (§7.1). Mine its
  *vocabulary*, not its host language.
- **CUE** — schema-as-partial-value unification; direct ancestor of §7.1 and the one
  system testimony singled out as *delighting* an end-user. Mine its concrete/incomplete
  distinction hardest (§2h, §3).
- **RELAX NG and XSD's mixed-content model** — the only mature tradition that seriously
  models prose-and-structure interleaving (§6b). Under-mined by everyone here,
  including this seed.
- **Dhall** — typed, hash-pinnable imports: the shipped form of consumer-side ascription
  (§2f).
- **Ash** (and rowan, its port) — the living resource-shaped kind; calculations,
  aggregates, policy, extension-based projection, and `Ash.Info.manifest` as an
  explicit code-generation basis. Also `AshAi` (declared return type constraining LLM
  output) and `usage_rules` (a package projecting agent-facing guidance as an artifact).
  §6c has the current-state check and its honest gaps.
- **rowan's `was:` / upcast / schema-history machinery** — the estate's deepest shipped
  migration story; read `evolution-status` (ll. 818–831) for the implemented/pending
  split *before* citing any of it.
- **relata's ingest membrane** — the shipped two-outcome refusal (§3a). The most
  transferable single design detail found.
- **autopax ADR-010's markdown structure DSL** + its `schema.generate_example()`
  proposal — closest thing to schema-over-prose in the estate; blocked and unbuilt, so
  cite as design.
- **tree-sitter** — not as grammar-as-schema (§1.1 forecloses that lane) but for
  **error recovery as a normative product**: what a broken document's structure *means*.
  All three substrates asked for it; no schema stack provides it.
- **Protobuf's compatibility discipline** — reserved fields, additive evolution, the
  insistence that "compatibility is designed rather than wished into existence"
  (*testimony*). Mine the discipline, not the message model.
- **JSON Schema's `oneOf` error problem** — mine as a *negative* result. No ecosystem
  has solved explaining a disjunction failure; any design leaning on disjunction
  inherits an unsolved problem.
- **`core/generator/*.descent.udon`** — the dogfood case (§11.1).
- **Named unread:** `~/src/rowan/docs/msc/plan-recursive-embedded-schemas.md` and
  `exploration-graph-resource-unification.md` — flagged by the doc-store report's own
  author as its two highest-value unread documents, both plausibly bearing on nested/
  recursive schema. Nobody has checked them, including this seed.

---

## 11. Probes worth forcing (named, not run)

1. **The dogfood probe.** `core/generator/*.descent.udon` — 4,180 lines of UDON with no
   schema, in this repo, defining a *grammar* (itself a schema kind) in UDON. Ask what
   schema those files would want. A live specimen of three things at once: UDON hosting
   a formalism; declarations (`|type[Element] BRACKET`) already in the annotated-
   prototype shape of §7.1; and a corpus where convention-as-schema is the only schema.
   *A schema story that cannot account for these files is missing something* (Joseph
   named this family himself).
2. **The tail-of-file probe.** Take the vivarium corpus (`|decision[slug] :date :by
   :status :topic`) and write its de-facto schema three ways — annotated prototype
   (§7.1), external constraint artifact, and the procedure `bin/check` already is.
   Measure authoring cost and what each catches. The cheapest available test of §7.1's
   near-zero-ceremony claim, with a live and willing consumer.
3. **The prose probe.** Take one real prose-heavy document with regions — an ASF segment
   with its `## Working Notes` — and try to state the region rules as a schema (§2i's
   four requirements). The estate has the *demonstrated* failure of not doing this; this
   probe asks whether stating it is even possible in a vocabulary UDON could host.
4. **The duality probe.** Write one document that computes (`!for` emitting elements)
   and ask a conformance verdict of it both pre- and post-expansion (§5c). Cheap, and
   it forces the question before a fixture pins an answer by accident.
5. **The superset audit (§6b).** Take the seven-formalism table and actually run it:
   for each, what must the canonical form express, and what is lost round-tripping out
   and back? Finite, enumerable, and it converts the Arch-Schema instinct from
   aspiration into a checked property — including the uncomfortable possible finding
   that the spine must be executable.
6. **The hallway-testing method, borrowed.** The estate ran 20+ naive-agent challenges
   against a schema surface and found agents **converge on inventing the same missing
   vocabulary** independently — `rate_limit`, `lock`, `old_<field>` accessors (report
   §10.2–10.3, ll. 1559–1567). A validated instrument for testing whatever surface UDON
   proposes; it belongs in this territory's toolkit, not just paths'.

---

## 12. Testimony provenance and its weight

De-novo testimony elicited 2026-07-28 for this seed across three substrate families
(Claude, grok, codex), all context-free — no repository access, asked to answer as
end-users who edit through narrow tools without validators. Transcripts are companions
to this file. Per corpus epistemology this is **one support-kind**: it evidences
end-user demand and pain, never design validation.

An honesty note that belongs with the register: codex explicitly declined the
"first-hand experience" premise — "I do not have personal lived experience in the human
sense… what I can offer is a synthesis grounded in the recurring failure modes… the
perspective I would optimize for as an editor of unfamiliar structured documents." Its
answer is the most structurally useful of the three, and its caveat is worth preserving
rather than smoothing away.

**Convergences across all three substrates**, independently, each worth more than any
single answer: (a) kinds-first is the wrong first cut; (b) validity is not binary and
needs a severity/lifecycle vocabulary; (c) examples are first-class and will be trusted
over the formal schema regardless of what ships; (d) partial and mid-edit documents are
the normal state, not an edge case; (e) schema over prose means genre, outline, roles
and reference integrity — never a grammar of truth. And one convergence *outward*:
grok independently re-derived UDON's already-ruled `Dialects ≠ Schemas` boundary —
"schema may **constrain** a syntactic type but must not **reinterpret** it… `format:
date-time` as a semantic hijack." An outside end-user reaching a ruling the language
already made is the cheapest confirmation available that the ruling is right.

---

## Working Notes

*(Unconstrained side-car per DECISIONS X4 — open work and routing, not a log.)*

- **The axis I'm least sure of is §5a (tier coverage).** I generated it; no source
  states it. It felt like the thing that would most change how Joseph sees the
  territory, which is exactly when I should flag that I made it up. Falsifier: if a
  design lands that only ever speaks about elements-and-attributes and nobody misses
  the other rows, the axis was ornamental.
- **§7.1 vs. §1.5's internal collision.** CORE §5.4 offers `?` as *both* schema-optional
  and grammar-0-or-1 in one sentence. Four characters are already oversubscribed before
  anyone has spent them. Worth attention before the suffix seat is allocated.
- **The `doc`-schema collision (§5b) is unrouted.** The markdown concern map assigns the
  `doc` element vocabulary to the schema layer; this seed treats schema-over-prose as
  open territory. Same question from two directions, neither map citing the other.
  Possibly just a cross-link; possibly a real scope decision.
- **The corpus sweep proposed a different deliverable shape** and I partly took it:
  a **dependency-ordered question list**, each branch naming what it forecloses, rather
  than a flat capability table. §2's decomposition is the compromise — dimensions
  rather than a list, but not yet ordered by dependency. If Joseph wants the *next*
  artifact after this one, that ordering is my recommendation, and
  `priorities-and-spike-agenda.md`'s schema-probe section is its seed.
- **Not chased:** the two named-unread rowan documents; ASF terminology §12.1 (the
  estate's "fully worked" schema-over-prose miniature, read only through the report's
  mediation); the `_schema` vs `_schema_version` adapter inconsistency the checkpoint
  flags; RELAX NG's mixed-content model, which §6b suggests is the most under-mined
  prior art on the map.
- **A question I could not answer and did not paper over:** whether the schema document
  is itself a UDON document governed by a schema — self-hosting. It bears on §7.1 (is
  the annotated prototype's own annotation schema-checked?), on §2b, on §6b's superset
  audit, and on PRAGMA. I left it out of the body rather than invent a position.

---

*Seed authored 2026-07-28. The generative forks to have opinions about first: §7.1
(annotated prototype as schema, in the reserved suffix seat), §7.2/§6 (source kind plus
projections — the escape from the portability/migration either-or, and the
architecture the Arch-Schema instinct implies), and §5a/§5c (tiers and the
computed-document duality — where borrowed practice stops). Read §8 before quoting any
capability as a benefit. Pointers: ratified constraints are §1 with cites; the estate's
deepest material is `../doc-store-and-schemas-report.md` §§5–7, §9, §12.4, §13 (read the
checkpoint first); the ledgers are `../../DECISIONS.md` and `../../OPEN.md`; the
carve-outs this pulls on are PRAGMA and PATHS.*

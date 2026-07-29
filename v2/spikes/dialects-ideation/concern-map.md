# Dialects × UDON — the concern map

A MECE (mutually exclusive, collectively exhaustive) inventory of the distinct concerns
hiding under the word **dialect**. Vocabulary orientation — frozen bare set, envelope,
additivity, the carve-out IDs — is in [README.md](README.md)'s preamble. Each is
named so we can refer to it precisely, and defined by its **boundary** (what it is
*and is not*) and its **owner**. This is the input to a dialect spike; it decides no
design and closes no carve-out.

**The most-conflated cluster is what a dialect is asked to *do*** — apparently four
jobs, separated by *when they act*: **Capture** (where a value ends) · **Recognize**
(is this body a Date) · **Evaluate** (`!if` over an environment) · **Denote** (an
address into a world). Four times of action means four power requirements and four
answers to "can loading one retype my document." That is §1, and it is *proposed* — the
map's own load-bearing claim, and the one to attack first. If it holds, it is why the
area has felt like one intractable question instead of four tractable ones.

**Sibling maps:** `../markdown/usage-topics.md` (same shape, markdown territory);
`../paths-ideation/README.md` §2 (the neighbouring seed — paths and dialects meet at
§5.1 and at the `<path:…>` possibility).

**Register.** Rows marked *decided* cite ratified law (`../../DECISIONS.md`,
`../../current-0.9.1-spec/`); *evidenced* cites the demand corpus or the codebase;
*proposed* is generated here and decides nothing; *open* is a live question, several
of them carve-outs whose openness is design intent (`CARVEOUTS.md`) and which nothing
here may close.

---

## 1. The four jobs — what a dialect is asked to do

The organizing axis is **when the dialect acts**, because binding time, additivity
strength, verification burden, and power requirement are each a function of it.

| Concern | What it is (and is not) | Owner | Status |
|---|---|---|---|
| **Capture** | Deciding **where a value ends** — the extent question. Recognition-layer, byte-level, bound by CORE §2.3's bounded-lookahead *language* law. Not "what the value means"; purely how far it reaches. | core today (frozen bare set + the `<>`-balanced span) | **decided as core** (CORE §11.6, §13.1); *open* whether a dialect may ever own it (see §5.2) |
| **Recognize / shape-validate** | Deciding whether a captured body **is a well-formed X** and tagging it — `<2026-07-11>` is a Date, `<2025-1-3>` is not. Produces a type tag plus the original bytes. Not projection; not constraint. | dialect | *open* (DIALECT-DEF); the shape is *evidenced* by TIME-SPEC §"What the Parser Provides" |
| **Project** | Turning a validated body into a **native host value** (`chrono::NaiveDate`, a Ruby `Date`). Per-language, per-runtime; the same dialect projects differently in Rust and Ruby. | **Host** — assigned by CORE §1.1's own table, *not* to the dialect | **decided** (CORE §1.1) |
| **Evaluate** | Running an **expression/control-flow language over an environment** to produce content — `!if`, `!for`, `!{{x \| capitalize}}`, filters, bindings. Needs a context object, may have effects, has a halting problem. Not typing anything. | host dialect (`!` tier; Liquid-style baseline) | **decided as dialect-owned** (CORE §9); its shape *open* |
| **Denote / resolve** | Turning a body into an **address resolved against a world** — a node, a document, a store. Fails in ways the others cannot (not-found, not-unique, stale). Not a value; it *names* one. | undesignated — paths may claim it | *open* (PATHS, PATH-1) |

**Explicitly not a job: constraint.** What is *allowed or required* is the schema's,
by ruling: *"A dialect says what a value means; a schema says what is allowed. They
never trade jobs."* (CORE §1.1 — *decided*.)

> **The boundary is not clean in the one worked example we have.** TIME-SPEC's
> "Validation and Warnings" section warns on `2025-1-3` (missing leading zeros),
> rejects `P1W2D` (weeks mixed with other components), and rejects `PT1.5H30M`
> (fraction on a non-smallest unit) — three rules that read as constraint sitting
> inside the only dialect draft the estate has. A defensible reading: *"is this a
> Date at all"* is **Recognize**, and near-miss handling is where the seam blurs
> (a dialect declining is typing; a dialect accepting-then-complaining is
> constraining). Naming the seam is not settling it. (*evidenced* — TIME-SPEC is
> reference-only, pre-v2; the seam is *open*.)

### 1.1 What the split would buy, if it holds

Three consequences, each *proposed* but each mechanically checkable:

- **The power envelope applies to exactly one job.** Joseph's durable criterion —
  bounded, digestible evaluation that stays a guest, *"without turning into rebol"*
  (2026-07-28, steward statement, `../living-documents/README.md` §1) — is a
  criterion on **Evaluate**. A temporal dialect needs *zero* evaluation power; a path
  dialect needs resolution, not evaluation. Applying one power envelope to "dialects"
  either over-powers temporal (a date type that can execute) or under-powers dynamics.
  *The power envelope is a criterion on one concern, not a property of dialects.*
- **Additivity's strength is a function of position.** CORE §1.1's guarantee —
  *"Loading a dialect can never retype an existing document"* — is airtight for
  Recognize/Project/Evaluate, all of which act on an already-captured span. It is
  **not** available for Capture, because changing where a value ends changes the parse
  of everything around it. See §5.2.
- **Binding time is derivable, not arbitrary.** A dialect must be bound no later than
  it acts. Capture-dialects must therefore bind before the document is read (a pragma
  *inside* the document cannot configure the parse that finds the pragma);
  Recognize-dialects may bind at or after recognition; Evaluate-dialects bind at
  evaluation time. **PRAGMA's design space narrows once you ask which job you are
  binding for** — the question "pragma, filename, both, or neither" has different
  answers per job.

---

## 2. The artifact — what a dialect *is*

| Concern | What it is (and is not) | Owner | Status |
|---|---|---|---|
| **Definition form** | The medium a dialect is written in: a declarative grammar, a table, or host code. Not its content. The estate has a shipped candidate — `core/generator/*.descent.udon` are genuine UDON documents whose design intent is *"DSL describes grammar, generator infers mechanics"*, target-neutral, with no host code leaking in. | dialect layer | *open* (DIALECT-DEF); descent-as-precedent *evidenced* |
| **Conformance obligations** | The core laws a dialect must obey to be loadable: bounded lookahead (§2.3, a **language** law, not an implementation note), keep-everything, declaring its extent kind (§13.1), the text law's reconstructability. Not what the dialect means. | core | *open* — currently unstated anywhere |
| **Checkability** | Whether those obligations can be **verified** rather than asserted. A declarative grammar can be checked statically; host code cannot — but this repo's own conformance method is *empirical* (fixture groups), which host code could satisfy. So the difference is **cost**, not possibility: by construction once, versus per dialect forever. | core + dialect layer | *proposed* (Appendix A.2) |
| **Identity & versioning** | `temporal@1` — what names a dialect, where the version lives, and what happens when `@2` replaces `@1`. CORE's label ladder is `<dialect:type:content>` with **no version slot**; the glossary's dialect names carry `@N`. | dialect layer | *open* — a concrete gap (§5.3) |
| **Distribution & trust** | Where a dialect comes from, whether it can be pinned (content hash), and how a reader establishes that the `temporal` they loaded is the one the author meant. | host / ecosystem | *open* |
| **Compilation** | Whether a definition compiles into the recognizer ahead of time or is interpreted at run time. The estate ships the ahead-of-time answer for its own grammar (`./regenerate-parser` → `parser.rs`), which is a fact about *descent*, not a ruling about dialects. | implementation | *open* |
| **Projection contract** | The per-host half of §1's **Project** job: the interface a host implements to turn a validated body into a native value. Distributed per language, not with the grammar. | Host (*decided*, CORE §1.1) | shape *open* |

> **A dialect is plausibly three artifacts with three distribution stories, not one**
> (*proposed*): a **grammar** (portable, checkable, compilable — one per dialect), a
> **type vocabulary** (the names it may emit — `Date`, `Duration`, `Interval`), and a
> **projection contract** (one implementation per host language). TIME-SPEC's own
> architecture already has this shape — *"validate the full pattern through the state
> machine, emit a single typed event only on successful completion"* then *"Hosts
> parse the validated string into native types"* — and CORE §1.1 already assigns the
> third to the Host. The dialect-as-single-artifact framing may be the thing making
> the area feel intractable.

---

## 3. Binding — how a document gets a dialect

| Concern | What it is (and is not) | Owner | Status |
|---|---|---|---|
| **Declaration surface** | *How* a document names its dialects: an in-document pragma, the filename designator (`<name>.<schema>.udon`), host configuration, or nothing. Not *which* dialects — that is the document's content. | undecided | **carve-out** (PRAGMA / S15) — do not close |
| **Binding time** | *When* the binding takes effect relative to the job it serves. Derivable per §1.1, not free. | — | *proposed* (derivation), *open* (ruling) |
| **Active set & order** | Which dialects are live for **unlabelled** dispatch, and in what order. CORE fixes the mechanism — *"offered to the document's declared dialects in declared order; first claim wins; if all decline, an Error. No sniffing race"* — and leaves the default set to the host. | core (mechanism) / host (default set) | mechanism **decided** (CORE §11.6); default set *open* |
| **Override & collision** | What happens when two loaded dialects both claim a label, or a document's binding disagrees with the host's. Not the same as ordering: ordering settles unlabelled dispatch, override settles *labelled* conflict. | — | *open* (named in DIALECT-DEF) |
| **Scope & mid-document reconfiguration** | Whether a binding covers the whole document or a subtree, and whether the active set may change mid-stream. PRAGMA names this explicitly as an interacting demand. | — | **carve-out** (PRAGMA) |

---

## 4. Invocation — how a value reaches a dialect

| Concern | What it is (and is not) | Owner | Status |
|---|---|---|---|
| **Envelope routing** | Who hands inner typed values to whom in `<r: <i: 3 -7> 0d83.23>` — the core grammar consuming and handing off, or the active dialect driving an implicit dialect stack. Only the `<>`-balanced span is guaranteed today. | — | **carve-out** (ENV-ROUTE / S12) — the named first experiment is the in-vivo timespec probe (Appendix A.1) |
| **Label resolution** | How `<content>` / `<type:content>` / `<dialect:type:content>` select a handler, and what "declines" means at each rung. Not routing: routing is *who asks*, resolution is *who answers*. | core (ladder) / dialect (claim) | ladder **decided** (CORE §11.6); decline semantics *open* (§5.4) |
| **Composition & nesting** | Whether an inner dialect sees the outer's context, and whether a dialect may compose another (a `temporal` interval built from two `temporal` instants). | — | *open* |
| **Failure & holes** | What a declined, failed, or unresolvable envelope leaves behind. The model already has the slot: `Envelope { …, resolved: DialectResult \| Unresolved }` (MODEL §4), and *"an unresolved Envelope retains its full lexical body… the model never holds a half-typed value."* | core (model) / dialect (verdict) | slot **decided** (MODEL §4); verdict vocabulary *open* |
| **Empty collapse** | `< >` → nil, a dialect-era refinement; interim is pass-through string + warning. | dialect layer | **carve-out** (ENV-EMPTY) |

---

## 5. Cross-cutting — the seams

### 5.1 Where dialects and paths touch

The paths seed's §2g names a `<path:…>` envelope as one of three futures for embeddable
paths, chosen precisely because it is *self-delimiting* — which makes paths a **customer
of the Capture concern**, not of Recognize. If `<path:…>` ships, the dialect mechanism's
first three customers are one per job: temporal (Recognize), paths (Denote), dynamics
(Evaluate). *That is a diagnostic, not a verdict*: it explains why "one dialect story
serving all three" has felt hard, and it is exactly the test the brief for this area
proposed — a story that serves all three without special-casing any would be strong
evidence it is right. (*evidenced* — `../paths-ideation/README.md` §2g; *proposed* —
the one-per-job reading.)

### 5.2 Additivity's actual extent — and the ML tension

CORE §1.1: *"Dialects act only inside envelopes; bare recognition is frozen. Loading a
dialect can never retype an existing document."* (*decided*.)

The ML carve-out floats a dissolution: *if bracketed/quoted captures turn out to be
sugar for dialect-typed captures, each capture's grammar owns its own line-span… and
there is no per-construct table to close* (Joseph, 2026-07-21). Taken seriously, that
makes `[…]` and `"…"` **Capture-concern dialects** — and a capture-dialect can, by
construction, change where a value ends, which changes the parse around it.

So the tension is precise and worth stating as a dependency rather than resolving:

- **If capture stays core-owned**, additivity is airtight and bounded lookahead is
  guaranteed by construction — but ML does not dissolve, and the per-construct table
  the carve-out wants to avoid comes back.
- **If dialects may own capture**, ML dissolves as advertised — but additivity becomes
  conditional, bounded-lookahead-as-language-law becomes a **conformance obligation on
  every dialect definition** (§2), and `<>`-balanced-span-guaranteed (ENV-ROUTE) has to
  be renegotiated.

- **A middle branch** surfaced by de-novo testimony 2026-07-28 (README §2.3): **core owns
  *shape*, dialect owns *meaning*.** Capture and a generic well-formedness stay core — so
  an unaware tool can still tell *well-formed nonsense* from *garbage*, and a dialect
  cannot smuggle control characters into the host document — while the dialect answers
  only *what does this mean*. Additivity and bounded lookahead survive intact. Whether
  that is enough for ML to dissolve is precisely the open question; what it establishes
  is that the fork is not binary, which an earlier draft of this map assumed.

Neither carve-out can be closed without the other. **ML and ENV-ROUTE are one
question wearing two names** (*proposed* — and if right, the two entries should be
cross-referenced in CARVEOUTS rather than either closing alone).

### 5.3 The versioning hole in additivity

`temporal@1` is the glossary's own spelling; the label ladder has three rungs and no
version. So the version lives in the *binding*, not the envelope — which means the
same document text means different things under different bindings. Additivity forbids
*adding* a dialect from retyping a document; it says nothing about **swapping a
version**. (*open*.)

This has an exact structural sibling already in the suite: **UNI**, the Unicode
identifier version pin, handled as *"a declared host-profile boundary"* — recognizers
state their data version, and non-ASCII identifiers are *"not portable across
implementations declaring different versions."* Whether dialect versioning takes the
same declared-profile shape, or a hard pin, or a hash, is *open*; that the two
questions rhyme is *proposed* and probably worth deciding together.

### 5.4 Decline semantics, and severity that depends on binding

CORE §11.6 gives unlabelled all-decline an **Error**; the no-dialects-loaded case, on
the same bytes, is a **Warning** (`NoDialectsLoaded`). Both keep every byte, so the
Error rests on §14.1's exception clause — *something the author intended is genuinely
absent* — rather than on loss. Defensible (you asked and got no answer, versus never
asking), and worth stating outright because of what it implies:

> **The same document, differently bound, produces different anomalies.** Anomaly
> severity at the dialect layer is a function of binding state, not of the bytes.

Nothing in the suite says this, and a conformance-fixture design will hit it
immediately. What a *labelled* decline yields — `<temporal: 2025-1-3>` where the
dialect says no — is not stated anywhere. (*open*.)

### 5.5 The `<…>` / `!{{…}}` overlap

Logged as a unification **pressure** to check against the demand map, *not to unify
early* (DIALECT-DEF — and this map does not unify it). One technical fact belongs on
the map, because it constrains any future unification either way:

The two forms have **incompatible capture disciplines, and the incompatibility is
caused by their contents.** `<…>` is depth-counted on `<`/`>`; `!{{…}}` closes on the
first `}}` and a single `}` is expression content (CORE §7.3). The `!` dialect's
baseline expression grammar uses `<` `>` `<=` `>=` `<>` as comparison operators
(DYNAMICS §"Operators", reference-only). So **any dialect whose body is an expression
language collides with `>` as a terminator** — a predicate body like `<q: a > b>`
mis-captures under today's rule.

Two readings, both live: that this is a reason the forms should stay separate, or that
it is an argument the envelope needs a capture discipline that does not depend on its
contents. The map records the fact; the demand map decides. (*evidenced* from primary
sources; the readings *proposed*.)

### 5.6 Where "dialects" is being used as a placeholder

Three ratified deferrals point at the dialect layer for questions that a dialect —
*as scoped by additivity, acting only inside envelopes* — structurally cannot answer:

- **R20** — framed ` ; ` inside `|{…}` is out for now, *"revisit with dialects."*
- **S18** — inline-comment framing whitespace preserved on strip, *"until dialects revisit."*
- **CORE §6.6** — a framed ` ; ` after value-`\` text inside an inline element is
  *"unspecified this version — it may gain comment semantics with the dialect work."*

All three are **comment recognition inside an inline element** — flow-level, outside
any envelope. Either these deferrals presume dialects will eventually own capture
(§5.2's harder branch), or "with dialects" is standing in for "later, when we know
more." Worth disambiguating before the dialect spike inherits three questions it
cannot answer. (*proposed* observation; the deferrals themselves are *decided* and
untouched here.)

---

# Appendix — excursus (argument, not inventory)

> The inventory proper ends at §5. What follows is argument: the probe's outcome table,
> and one steward hypothesis tested against sources. Kept here because both are about
> *how you would find out*, which is what a map is for. The narrative version of the
> codebase facts below is [README.md](README.md) Appendix D — this section carries the
> **outcome table**, which is the part that isn't repeated there.

## A.1 The in-vivo probe — what it can and cannot test

ENV-ROUTE names it: *"the in-vivo timespec probe."* Three codebase facts change its
design (*evidenced*, recon 2026-07-28; stated in full in [README.md](README.md)
Appendix D): the timespec grammar is a **shelved fragment that will not compile
standalone**; a *fixed* sub-parser call is one of ~139 existing call sites while
**dynamic selection has no primitive in descent at all**, because the resumable backend
defunctionalizes a call graph that must stay closed and statically known; and the
sufficiency law does not forbid dispatch, since consulting a dialect *definition* is
configuration rather than reachback.

**So the cheap version of the probe answers the wrong question.** Hardwiring one
temporal grammar behind `<` proves a *statically known* callee works — which descent's
existing call sites already prove. The question with architecture in it is **dynamic
selection**, and it has no existing lever.

A probe worth forcing, therefore, has at least two arms (*proposed*, offered as a
sketch — the spike will see the real shape):

| Arm | What it builds | What each outcome would mean |
|---|---|---|
| **A — static** | Re-home the setaside fragment as `/temporal_envelope`, called unconditionally from `/envelope`. Run `pushdown_differential` at every chunk size. | **Green:** in-vivo typing is streamable and bounded-lookahead-clean with one dialect; the remaining question is purely selection, and Recognize can live at recognition time. **Red:** the temporal grammar cannot satisfy §2.3 inside the envelope — evidence that Recognize belongs *after* recognition, over a captured body, and ENV-ROUTE resolves toward "core consumes, model routes." |
| **B — selected** | Two grammars behind one `<`, chosen at run time from a declared active set. | **Cheap:** descent grows a dispatch primitive and the closed-call-graph assumption survives (e.g. a generated match over a compile-time-known dialect set) — *then a dialect is a compile-time-linked artifact, which decides a great deal about §2's distribution story.* **Violent:** the pushdown backend's defunctionalization breaks, and either the resumable backend is lost for dialect-bearing documents or dialects must be resolved before the parse — which decides PRAGMA. |

The **falsifier worth running first** is cheaper than either arm and is a pure spec
question: *find a legitimate dialect body that balanced-span capture mis-captures.*
§5.5 supplies a candidate (`<q: a > b>`). If a real customer needs one, Capture is
forced open and §5.2's harder branch is the live one; if no customer produces one
after honest search, core-owned capture holds and the architecture stays simple.

## A.2 Interrogability — a proposed sharpening

Joseph's one-inference synthesis, offered as his to be tested: *sub-Turing power is
what makes a dialect statically interrogable — "what names does this template need" —
and interrogability is a named demand from the templates testimony.*

Testing it against the primary source: the de-novo templates testimony asks for
interrogability directly (*"Interrogability is the difference between a template being
a black-box function and a template being a protocol"*) and then supplies its own
caveat — *"full static analysis of Turing-complete template languages is undecidable.
That does not kill the idea. It means the language should be **stratified**: a
declarative requirements surface for the common case, and an explicit 'this template
is dynamic / effectful / non-analyzable' flag for the escape hatch."*

And a shipped counterexample settles the direction (*evidenced*): **Jinja2 already
answers "what names does this template need" on a fully Turing-complete language.**
`jinja2.meta.find_undeclared_variables` walks the compiled AST and returns the free
variables a render will read — soundly but approximately (it unions across all
branches, and mis-handles `{{ x | default(…) }}` by reporting `x` as required —
[pallets/jinja#1034](https://github.com/pallets/jinja/issues/1034)). Meanwhile the
sub-Turing languages that *do* buy exact guarantees — CUE (termination), Starlark
(hermeticity/determinism), Dhall (import integrity) — none of them advertise
free-variable enumeration as the payoff.

So the inference does not go through as stated in either direction: sub-Turing power
does not *imply* analyzability, and useful interrogability is available without it.
Two claims survive the test, and they are separable (*proposed*):

> **1.** The lever is not Turing-completeness but **which specific static question you
> need decidable, and whether approximately is good enough.** "What top-level names
> does this read" appears to be cheap and sound-if-imprecise at nearly any power level;
> "does this always terminate" is the one that actually costs you the power envelope.
> Those need not be bought with the same currency.
>
> **2.** Interrogability comes from **requiring a declaration**; bounded power is what
> makes the declaration *checkable* rather than merely asserted.

Claim 1 is the load-bearing correction, and it *reduces* what the power envelope has
to buy — if the demand is interrogability, the envelope may be cheaper than assumed;
if the demand is termination or hermeticity (an untrusted dialect running in a shared
process — Liquid's actual stated reason), it is not. **Which demand is real is a
question for the demand map, not for this seed.**

Claim 2 pays a second dividend the original does not: the same property
that lets a host verify a template's declared requirements is the property that lets
the **core** verify a dialect's conformance obligations (§2). CORE §2.3 makes bounded
lookahead a law of the *language*, and a language law that dialects can violate is not
a law — so if dialects ever own Capture, the obligation must be **verified, not
trusted**.

**But "verified" does not mean "statically verified,"** and an earlier draft of this map
slid straight from one to the other. This repo's own conformance method is empirical:
*"Compliance is measured, not tracked… an implementation is compliant with core-vX iff
it passes that group."* An adversarial fixture suite — chunk-boundary differentials of
the kind `pushdown_differential` already runs — could discharge the same obligation for
a host-code dialect. So the honest claim is about **cost**, not possibility: a
declarative grammar discharges the obligation *by construction, once*; host code
discharges it *empirically, per dialect, forever*. (*proposed*; a distinct justification
from the templates one — either could hold without the other.)

---

**Not concerns (deliberately excluded):**

- *Which dialects to build* — temporal, paths, standard-types (RC-SPELL), the `!`
  baseline. These are **customers** of the concerns above, and each one is diagnostic
  (§5.1), but "should we ship temporal first" is a priority question, not a concern.
- *The power envelope* — not a concern; a **criterion** that applies to §1's Evaluate
  job and nowhere else (§1.1).
- *Turing-completeness* — a **parameter** of Evaluate, not a concern of its own.
  "How powerful should dialects be?" is ambiguous until it names which job.
- *Constraint / schema* — a different layer by ruling (CORE §1.1). Its seam with
  Recognize is real (§1) and is a boundary of this map, not a row in it.
- *Markdown interpretation* — the MD carve-out's companion layer, above recognition.
  It shares the word "layer" with dialects and nothing else.
- *Host projection ergonomics* — accessor shapes, native type choice. Downstream of
  the Project job (CORE §1.1), not a dialect-architecture concern.

---

*Map authored 2026-07-28. Primary sources read whole: the 0.9.1 suite (CORE, MODEL,
GLOSSARY, SEMANTICS, RATIONALE, CARVEOUTS, DELTAS), `../../DECISIONS.md`,
`../../OPEN.md`, the pre-v2 companions `spec/DYNAMICS.md` and `spec/TIME-SPEC.md`
(reference only, not law), `CONSUMERS.md`, and the grok templates testimony. Codebase
facts in §6 from a read-only recon of `core/generator/`, `tools/descent`, and the
pushdown-differential harness.*

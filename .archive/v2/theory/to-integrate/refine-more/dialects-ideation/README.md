# Dialects — ideation seed

**Status:** broad ideation, first pass. Possibility-opening; decides nothing and closes
no carve-out. Claims are register-marked *decided* (ratified, cited) · *evidenced* ·
*proposed* (generated here) · *open*. Vocabulary orientation is **Appendix A**; sibling
seeds are `../paths-ideation/`, `../../theory/to-integrate/refine-more/living-documents/`, `../../theory/to-integrate/refine-more/markdown/`.

---

## What this pass concludes

**The spine: "dialect" looks like four jobs wearing one name**, separated by *when they
act* — **Capture** (where a value ends), **Recognize** (is this body a Date),
**Evaluate** (`!if` over an environment), **Denote** (an address into a world). If that
holds, three things follow, and §1 argues them:

- Binding time is **derivable, not chosen** — a Capture-dialect cannot be bound by an
  in-document pragma, because you would have to parse the document to find the pragma
  that configures the parse. This narrows PRAGMA's space without settling it.
- Additivity's guarantee is available to three of the four, and **structurally
  unavailable to Capture**.
- **The power envelope is a criterion on Evaluate alone**, not a property of dialects.
  Applied to all four it either over-powers temporal (a date type that can execute) or
  under-powers dynamics.

**Everything hangs on one fork** (§2): may a dialect own **Capture**? ML's dissolution
needs yes; additivity and bounded lookahead prefer no; a middle branch — core owns
*shape*, dialect owns *meaning* — may get both. **A cheap falsifier could settle a lot
before any spike runs:** find a legitimate dialect body that `<>`-balanced-span capture
mis-captures. One candidate is already in hand — the `!` baseline's expression grammar
uses `<` and `>` as comparison operators, so a predicate body like `<q: a > b>`
mis-captures under depth-counting. If honest search finds no real customer needing one,
much of the architecture simplifies at once.

**Three places this pass's own framing turned out wrong** — I would weight these above
the split above, since each was a confident draft that a check overturned:

1. I asserted the fork's Branch B *forces* declarative dialect definitions. It doesn't —
   I had silently assumed verification must be **static** and skipped this repo's own
   method (*"Compliance is measured, not tracked"*). Fixtures discharge the same
   obligation. The honest claim is about cost, not foreclosure. (§2)
2. I drew the fork as **binary**. It has a middle branch. (§2)
3. My artifact framing — and DIALECT-DEF's own *"defined, compiled, verified, declared"*
   phrasing — are both written in the **plugin frame**, asking what the thing you install
   is. Two unprimed practitioners rejected that metaphor independently. If they are
   right, the first-order questions are *who mints names and what a name promises*, and
   compilation demotes to implementation. (§4)

**Two findings that may want ledger rows** (*proposed*, steward's call): dialect
**versioning is a hole in additivity** — additivity forbids *adding* a dialect from
retyping a document but says nothing about *swapping a version*, and `temporal@1` may
itself have a migration history; and **anomaly severity at the dialect layer depends on
binding state** — the same bytes are a Warning unbound and an Error when dialects are
bound and all decline. (§6)

**What this pass does not do.** No probe was run; the falsifier is named, not executed.
The four-jobs split is *proposed*, not derived from a ratified source — it is the claim
I would most like stress-tested. Three kinds of evidence agree with it (design reading,
prior art, unprimed testimony — Appendices B and C), which is corroboration, not proof,
and one of the four testimony voices is same-family and weighted lower.

**The companion artifact is the map.** [`concern-map.md`](concern-map.md) is the MECE
(mutually exclusive, collectively exhaustive) inventory — every concern with its
boundary and owner, in the shape of `../../theory/to-integrate/refine-more/markdown/usage-topics.md`. This page is the
argument; the map is the reference. Read the map if you read one.

---

## 1. The spine — four jobs, separated by when they act

| Job | Acts at | Example | Needs |
|---|---|---|---|
| **Capture** | recognition time | (none today — core owns it) | bounded lookahead; streamability |
| **Recognize** | after capture | `temporal@1` says `<2026-07-11>` is a Date | a grammar; nothing else |
| **Evaluate** | render/consumer time | `!if`, `!{{x \| capitalize}}` | an environment; the power envelope lives here |
| **Denote** | query/resolve time | a possible `<path:…>` | a world to resolve against; its own failure vocabulary |

The claim is not that these are four flavours of one thing but that they differ in
**when**, and that everything downstream of a dialect's design is a function of that.
Three consequences, all *proposed*:

**Binding time is derivable.** A dialect must be bound no later than it acts. So an
in-document pragma cannot configure Capture — the chicken-and-egg is structural, not a
matter of implementation order. Recognize can bind whenever; Evaluate binds later still.
DIALECT-DEF's *"how one is declared"* and PRAGMA's *"pragma, filename, both, or
neither"* have **different answers per job**, which is a reason to think PRAGMA is
tractable, not that it is settled.

**Additivity is position-dependent.** CORE §1.1's *"Loading a dialect can never retype
an existing document"* (*decided*) is airtight for anything acting on an already-captured
span, and structurally unavailable to Capture, because changing where a value *ends*
changes the parse around it.

**The power envelope belongs to one job.** Joseph's criterion — bounded, digestible
evaluation that stays a guest, *"without turning into rebol"* (2026-07-28, steward
statement) — is a criterion on **Evaluate**. Temporal needs zero evaluation power.
This is the single claim here I would most like attacked.

### 1.1 An apparent fifth sense, which folds into Capture

*Not a fifth job — three deferrals that land in Capture if Capture ever becomes
dialect-ownable, and nowhere at all if it does not.* **R20** (framed ` ; ` inside
`|{…}`, *"revisit with dialects"*), **S18** (inline-comment framing whitespace, *"until
dialects revisit"*), and CORE §6.6's unspecified framed-`;` edge are all **comment
recognition inside an inline element** — flow-level, outside any envelope, and therefore
beyond anything a Recognize-dialect could answer. Either they presume the harder branch
of §2, or *"with dialects"* is standing in for *"later."* Both are legitimate; they are
not the same, and the spike will otherwise inherit three questions it cannot answer.
(*proposed* observation; the deferrals are decided and untouched.)

---

## 2. The fork everything hangs on

Two carve-outs are — *proposed* — **one question wearing two names**, and cannot be
closed independently. **ML** floats a dissolution: *if bracketed/quoted captures turn out
to be sugar for dialect-typed captures, each capture's grammar owns its own line-span…
and there is no per-construct table to close* (Joseph, 2026-07-21) — which makes `[…]`
and `"…"` **Capture-dialects**. **ENV-ROUTE** asks who routes nested envelopes and
guarantees only the `<>`-balanced span today.

**Branch A — capture stays core-owned.** Additivity airtight, bounded lookahead
guaranteed by construction, dialect layer purely post-recognition. Cost: ML does not
dissolve and the per-construct table comes back.

**Branch B — dialects may own capture.** ML dissolves. Costs: additivity becomes
conditional; CORE §2.3's bounded lookahead — *a law of the language, not an
implementation note* — becomes a conformance obligation every dialect must satisfy; the
balanced-span guarantee is renegotiated.

**Branch C — core owns *shape*, dialect owns *meaning*.** Capture and a generic
well-formedness stay core, so an unaware tool can still tell *well-formed nonsense* from
*garbage* and a dialect cannot smuggle control characters into the host document; the
dialect answers only what the body means. Additivity and bounded lookahead survive.
Whether it is enough for ML to dissolve is exactly the open question.[^c]

[^c]: Branch C came from de-novo testimony, not from this seat — an earlier draft
presented the fork as binary. Appendix B §3.

**What follows from Branch B, stated at its honest strength.** A language law that
dialects can violate is not a law, so if dialects own Capture the obligation must be
*verified* rather than trusted. That much holds. What does **not** follow — and an
earlier draft asserted it — is that verification must be *static*, and that Branch B
therefore forces declarative definitions. That skipped this repo's own conformance
method: *"Compliance is measured, not tracked… an implementation is compliant with
core-vX iff it passes that group"* (*decided*). An adversarial fixture suite —
chunk-boundary differentials of the kind `pushdown_differential` already runs — could
discharge the same obligation for host-code dialects. So:

> Branch B does not foreclose host-code dialects; it puts them under a **verification
> burden** that a declarative grammar discharges by construction *once*, and host code
> discharges empirically *per dialect, forever*. Which is acceptable is a cost question.
> (*proposed*.)

**The falsifier before any of this.** Find a legitimate dialect body that balanced-span
capture mis-captures. Candidate in hand: the `!` baseline's comparison operators are
`==` `!=` `<>` `<` `>` `<=` `>=` (DYNAMICS, reference-only), so any predicate-shaped body
mis-captures under depth-counting. A real customer needing one puts Branch B/C live; none
after honest search leaves Branch A holding.

---

## 3. What the mechanism has to serve

temporal, paths, and the `!` dynamics baseline are the named first customers, and a story
serving all three without special-casing any would be good evidence it is right. Under §1
they are **one per job**: temporal is Recognize; `<path:…>` is Denote, and the paths seed
chose it precisely because it is *self-delimiting* — a Capture property; dynamics is
Evaluate.

*Proposed:* that is why one story for all three has felt hard — they are not three
instances of one thing. Diagnostic, not verdict; it says what the test is testing.

**The migration surface is real and dated.** `CONSUMERS.md` counts **111 date-valued
attributes** across six live documents (78 in `vivarium/DECISIONS.decision-log.udon`,
growing daily), all unvalidated strings by design, with the temporal dialect as
notification trigger #1. Temporal is not a toy example; it has waiting consumers.
(*evidenced*, scan 2026-07-16.)

---

## 4. The artifact question — and whether it is the right question

*Proposed*, to argue with: **a dialect may be three artifacts with three distribution
stories, not one** — a **grammar** (portable, checkable, compilable), a **type
vocabulary** (the names it may emit), and a **projection contract** (one implementation
per host language). Two supports beyond taste: CORE §1.1 *already* assigns the third away
from the dialect (*"Projection (validated string → native value) — Owner: Host"*), and
the estate's one worked draft already has this architecture — TIME-SPEC validates the
full pattern, emits *"a single typed event only on successful completion,"* then *"Hosts
parse the validated string into native types."* The estate also ships a candidate medium
for the first part: `core/generator/*.descent.udon` are genuine UDON documents,
target-neutral, no host code leaking in — a grammar as a UDON document is how this repo
builds its own parser. Honest caveat: descent's DSL is byte-level recognition only; it
could express the grammar and nothing of the other two.

**Where that split, if right, says the risk concentrates.** The failure most feared by
unprimed practitioners is not a *missing* dialect — annoying but visible — but **silent
semantic drift between two implementations that both accept the same text and both look
successful**. The grammar is portable and checkable; the **projection contract is
per-host**, and per-host projection is exactly where two implementations diverge while
both reporting success. Projection would then be the artifact needing conformance
fixtures most and specified least.[^drift]

[^drift]: 3 of 4 testimonies, each naming its own lived analog — timezone, locale, unit
conversion. Appendix B §5.

**And the challenge to this whole section.** Two unprimed voices rejected the
plugin/extension metaphor as primary, independently and by different routes — *value
contract, not plugin* and *vocabulary, not plugin* (a versioned **set of named types**
people import, categorically distinct from code you load). That lands on this section and
on DIALECT-DEF's own phrasing equally: both ask what the *thing you install* is. If the
primary object is a vocabulary, the first-order questions become who mints names, what a
name promises, and how a promise is versioned — and compilation and distribution demote
to implementation detail. The convergence is real; whether it should govern is a demand
question, not this pass's.[^vocab]

[^vocab]: Appendix B §1. Related shipped precedents, Appendix C: MIME's registration
trees (*who may mint a name* — unaddressed anywhere in UDON), and XML namespaces, whose
"namespace hell" is largely the conflation of **identity** with **resolution** in one
URI.

---

## 5. What to run first

**The falsifier** (§2) is cheapest and is a pure spec question.

**Then the in-vivo probe** ENV-ROUTE names — but redesigned, because three codebase facts
change what it can test (details in **Appendix D**; each outcome's implication is tabulated in the map's Appendix A.1):
the timespec grammar is a **shelved fragment that will not compile standalone**, not a
live sub-parser; a *fixed* sub-parser call is one of ~139 existing call sites while
**dynamic selection has no primitive in descent at all**, because the resumable backend
depends on a closed static call graph; and the sufficiency law does not forbid dispatch
(consulting a dialect *definition* is configuration, not reachback).

**So the cheap version answers the wrong question.** Hardwiring one grammar behind `<`
proves a statically-known callee works, which existing call sites already prove. The
question with architecture in it is **dynamic selection**.

---

## 6. Dependencies — nothing here is closed

| Carve-out | What this pass would need from it | Why it cannot be assumed |
|---|---|---|
| **ML** + **ENV-ROUTE** | Whether dialects may own Capture (§2) | Decides additivity's extent, the verification burden, and whether the spine is four jobs or three-plus-one. *Proposed:* cross-reference the two entries rather than closing either alone. |
| **PRAGMA** | The declaration surface | §1 narrows the space per job but rules nothing; mid-document reconfiguration untouched. |
| **DIALECT-DEF** | All of §4 | The three-artifact shape is a proposal to argue with — and §4's own frame is under challenge. |
| **ENV-EMPTY** | `< >` → nil | Fires *"when the dialect layer lands"*; untouched. |
| **RC-SPELL** | Rational/complex spelling | A Recognize customer; this pass says nothing about spelling. |
| **PATHS** | Whether `<path:…>` ships | Decides whether Denote is a real fourth job or hypothetical. |

**Two things that are not carve-outs and may want ledger rows** (*proposed*):

- **Dialect versioning is a hole in additivity.** `temporal@1` is the glossary's own
  spelling; the label ladder `<dialect:type:content>` has no version slot, so the version
  lives in the *binding*. Additivity forbids *adding* a dialect from retyping a document
  and says nothing about **swapping a version** — and testimony added an axis nobody
  asked about: a dialect's grammar may evolve across *its own* versions independently of
  the document format's. Exact structural sibling: **UNI**, handled as a *declared
  host-profile boundary* with explicit non-portability. Probably worth deciding with UNI.
- **Anomaly severity at the dialect layer depends on binding state.** Same bytes:
  `NoDialectsLoaded` **Warning** unbound, **Error** when bound and all decline (CORE
  §11.6). Defensible under §14.1's exception clause and probably right — but unstated,
  and a conformance-fixture design hits it immediately. What a *labelled* decline yields
  is stated nowhere.

---

## 7. Still open — carried, not resolved

- **The `<…>` / `!{{…}}` unification pressure** stays open per its own register's words —
  *check against the demand map, not unify early*. One technical fact constrains either
  answer: the forms have **incompatible capture disciplines caused by their contents**
  (depth-counted `<`/`>` versus first-`}}`, against an expression grammar whose operators
  are `<` and `>`). Not a verdict in either direction. (map §5.5)
- **Load order.** All four testimonies treated *load order must never affect meaning* as
  near-axiomatic. CORE §11.6 specifies unlabelled dispatch as *"declared order; first
  claim wins"* (*decided*). The tension is narrow and worth stating precisely: the
  testimony's preferred mechanism — explicit in-envelope type identity — **is** UDON's
  labelled ladder, which it effectively endorses. Friction is confined to the
  *unlabelled* rung; the ruling's own motive (*"no sniffing race"*) is untouched.
- **The dialect/schema seam is blurry in the one draft we have.** TIME-SPEC's
  "Validation and Warnings" warns and rejects — constraint behaviour inside a typing
  artifact — against a ruling that says they *never trade jobs*. Naming is not settling.
- **Whether a dialect may compose another** (a `temporal` interval from two `temporal`
  instants) is unasked, and is ENV-ROUTE one level in.
- **A degradation contract** — a dialect declaring what frozen bare primitive it degrades
  to when unloadable — is a third option between "preserve opaquely" and "fail hard" that
  nobody in this estate had proposed, and it fits UDON's existing machinery unusually
  well. Appendix B §2.

---

# Appendices

*Supporting material: orientation, and the three evidence bodies the argument leans on.
None of it is load-bearing on its own.*

## Appendix A — Vocabulary orientation

All from ratified sources. UDON recognizes a small **frozen bare set** of value types
from unquoted syntax alone — string, integer, float, boolean, nil, list — *closed
forever*, because every format that keeps adding bare recognition eventually retypes
somebody's existing document (YAML's "Norway problem"). Everything richer is written
inside the **envelope**, `<…>`, in value position; a **dialect** is whatever gives the
envelope's contents meaning. That is why adding a dialect structurally cannot retype an
existing document — the property CORE calls **additivity**.

Carve-out IDs are register entries in `../../current-0.9.1-spec/CARVEOUTS.md`; the one
recurring most, **ML**, is the *multi-line policy* question — whether the remaining
delimited forms (quoted strings, `[…]` lists, identity brackets, interpolation) may span
a line terminator. The **demand map** means the demand-side corpus at `../../udon-needs/`,
which this v2 effort defers to. *Decided* claims cite `../../DECISIONS.md` or the 0.9.1
suite.

**Why DIALECT-DEF is open at all:** in the register's own words, *"the largest named hole
in the demand-side work — no dialect spike has ever run"* — with five other items
(ENV-ROUTE, ENV-EMPTY, PRAGMA, ML, RC-SPELL) explicitly waiting on it.

## Appendix B — De-novo testimony, and what it changed

*De-novo testimony* is this estate's practice of putting a question to a fresh agent that
has never seen the project, in its own vocabulary, so the answer is uncontaminated by our
framing. A round of four was run 2026-07-28 — codex, grok, agy (Gemini-family), and a
fresh Claude subagent — on one context-free prompt scrubbed of UDON's vocabulary (no
"dialect," no project name, `<…>` offered only as a generic illustrative envelope).
Transcripts:
`../../udon-needs/01-ideation/02-provenanced/copies/de-novo-testimony/dialects-testimony-{codex,grok,agy,claude}-2026-07-28.md`.
Three substrates are independent; the Claude voice is same-family and weighted lower.

**Confirmations** (*evidenced*, 4/4 unless noted): the frozen bare-scalar core is
endorsed for exactly the reason UDON gives, each voice citing its own scars (YAML tags,
locale-dependent numbers, timezone libraries, regex-flavor drift). Silent ambiguity
between two extensions is the worst failure mode; loud, named, **load-time** — not
parse-time — conflict errors are wanted. Explicit in-envelope type identity is preferred
over ambient registration. A bounded power envelope is judged desirable *and* achievable,
with a recurring formulation concrete enough to quote as a candidate: *pure functions over
the envelope's own text — parse / validate / normalize / compare / serialize — with no
ambient I/O, no cross-field reach, no code execution as part of parsing.*

1. **"Vocabulary, not plugin."** Codex: *value contract, not plugin*, separating meaning,
   implementation-identity and execution-safety into three trust questions. Grok:
   *vocabulary, not plugin* — a versioned set of named types people import. Independent,
   different routes. → body §4.
2. **The Degradation Contract** (agy): an extension declares, as part of its own spec,
   what frozen bare-core primitive it degrades to when unloadable — a duration → integer
   seconds, a color → an RGB array. No other voice proposed anything between "preserve
   opaquely" and "fail hard." It fits UDON unusually well: there is already a frozen bare
   set to degrade *into*, and the no-dialect interim is already lexical pass-through plus
   a warning — a declared degradation makes that interim **operable** rather than merely
   lossless. It also touches additivity, being a promise about bare space made by
   something that may not be loaded. → body §7.
3. **Closed shape without meaning** (Claude voice): the lexical shape should stay closed
   and core-constrained *even when the extension is absent*, so an unaware tool can
   distinguish well-formed nonsense from garbage and extensions cannot smuggle control
   characters into the host. → body §2, Branch C.
4. **Interrogability wants a card, not a schema.** 3 of 4 warned that a formal grammar
   alone is *"technically present, practically void"*; what is wanted is a short
   human-readable card with examples, in the vein of a man page. Refines rather than
   overturns the map's A.2: requiring a declaration is still what produces
   interrogability, but the usable declaration is prose-and-examples, with the
   machine-checkable grammar keeping the prose honest. Two artifacts, one obligation.
5. **Worst-feared failure**, 3 of 4, each naming a lived analog by name (timezone, locale,
   unit conversion): not a missing extension but **silent semantic drift between two
   implementations that both accept the same text and both look successful.** → body §4.
6. **Load order must never affect meaning**, 4/4, treated as closer to a correctness
   property than a preference. → body §7.
7. **Extension self-migration**: a dialect's grammar evolving across its own versions,
   independent of the document format's. → body §6.
8. **Interpretation lockfiles** (grok): type-id → exact implementation identity, pinned
   in-repo, explicitly distinct from a code lockfile. Same family as Dhall's
   semantic-integrity hashing, reached independently.

## Appendix C — Prior art

Full survey with citations: [`prior-art.md`](prior-art.md), commissioned for this seed
from an agent briefed on the carve-outs but **not** on this pass's reading — so its
arrival at the same seam (closed-grammar versus computational dialects, named *the
highest-leverage split to make explicit*) is independent, not agreement with a handed
frame. Condensed by what each answers:

- **tree-sitter** — the strongest artifact analog, having solved *define / distribute /
  route* separately for an unrelated reason. Grammar compiled ahead of time into a
  versioned parser (the **compiled artifact** is the distributable unit, carrying an ABI
  version); packaged like any dependency; and **routing is a separate artifact entirely**
  — an `injections.scm` query owned by the *integration*, not by either grammar. A live
  option for ENV-ROUTE nobody has costed.
- **Dhall** — `sha256:` semantic-integrity hashes pin an import to its **normal form**, so
  tampering is rejected at resolution while behavior-preserving refactors don't break the
  hash. Most directly reusable idea for the verification question; rhymes with the
  versioning hole (§6).
- **Rebol** — the cautionary tale one level below where it is usually diagnosed. Rebol's
  own definition is *any loadable expression is a dialect* — dialect ≡ program, with **no
  artifact boundary, no compilation, no versioning, no registry**. UDON's envelope refuses
  this at the syntax layer; DIALECT-DEF is whether it gets refused one layer up.
- **Liquid** — the concrete power envelope: no recursion, no user-defined functions,
  bounded iteration over an existing collection only (no `while`), **filters as the sole
  extension point** (host-registered — the guest only invokes), and an `Environment`
  object that is already a live instance of "which dialect-equivalents are loaded, in what
  scope."
- **Mustache** — the *too-little-power* failure, written down (Boronine, 2012): pushing
  all decisions to the host relocates logic into presenter objects that reinvent template
  logic in a second language, and turns a one-word document edit into a code change and a
  redeploy. The envelope has two walls.
- **Racket `#lang`** — the opposite pole, where routing *is* definition; production proof
  that a guest may legitimately own control-flow semantics. Its precondition — a single
  global module-path namespace — is exactly what DIALECT-DEF's "default active set" asks
  for and UDON lacks.
- **XML namespaces** — identity and resolution are two jobs; conflating them in one URI is
  most of "namespace hell."
- **MIME / RFC 6838** — the same least-to-most-specific ladder, plus registration trees
  (*who may mint a name*) and `+json`-style structured suffixes, close kin to the `type:`
  vs `dialect:` split. **And validation of a decision already made:** MIME's practical
  routing became content **sniffing**, with its own security literature; CORE §11.6's
  *"no sniffing race"* is a direct rejection of that retrofit.
- **Emacs major-mode routing** — forty years of one of the most-used routing systems
  settled on *several* independent signals in explicit documented precedence, not one
  canonical mechanism. A data point against solving ENV-ROUTE with a single rule.

**One negative finding worth carrying as-is:** embedded-language routing is **an open
problem industry-wide**, not something UDON is lagging on — LSP never gave embedded
languages a first-class protocol answer and the virtual-document workaround is still being
specified. Whatever the in-vivo probe turns up could be citable prior art in its own right.

Unchased leads the survey flagged: Open Policy Agent / Rego's static-analyzability
literature (its best remaining bet), Nix derivation purity as a second Dhall-like data
point, CUE's unification semantics.

## Appendix D — The probe, redesigned against codebase facts

*Evidenced*, read-only recon 2026-07-28; each outcome's implication is tabulated in
[`concern-map.md`](concern-map.md) Appendix A.1.

1. **The timespec grammar is shelved, not live.**
   `core/generator/temporal-value.desc.setaside` is 519 lines of *pre-0.8 bare*
   recognition, cut out when temporal moved into the envelope; its own header says it
   *"will not compile standalone (its states were arms of `/typed_value`)."* A reader of
   the carve-out alone pictures a working sub-parser one wire from dispatch. It is a
   fragment needing an entry state and a `>` terminator first.
2. **A *fixed* sub-parser call is nearly free; a *selected* one has no primitive.**
   Descent has no sub-grammar concept — only ordinary `/function` calls, ~139 of them.
   `/typed_value` already calls `/envelope`; one more call is mechanically identical. But
   the resumable pushdown backend defunctionalizes the grammar into an explicit frame
   stack, and that works **only because the call graph is closed and statically known.**
   Which dialect handles an envelope is a runtime fact; descent has no function-pointer
   dispatch.
3. **The sufficiency law does not forbid it.** W0's no-reachback bars reaching into
   *earlier products of this parse*; consulting a compiled dialect grammar or a schema is
   configuration, not reachback — a refinement `../../DECISIONS.md` already anticipates in
   its status note. The four-stage pipeline whose linearity was at stake is itself
   archived in favour of *"a graph, not a line."*

---

*Seed authored 2026-07-28 (udon session); restructured the same day against steward
register feedback (conclusions up front; evidence bodies to appendices; one visible
spine). Primary sources read whole before drafting: the 0.9.1 suite (CORE, MODEL,
GLOSSARY, SEMANTICS, RATIONALE, CARVEOUTS, DELTAS), `../../DECISIONS.md`, `../../OPEN.md`,
`../../udon-needs/CLAUDE.md`, the pre-v2 companions `spec/DYNAMICS.md` and
`spec/TIME-SPEC.md` (reference only, not law), `CONSUMERS.md`, the grok templates
testimony, and the paths and living-documents seeds.*

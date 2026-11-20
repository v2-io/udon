# Schema — ideation seed

**Stage: explication.** This is the early pass whose job is to lay the territory out and
find out what is even in it — not synthesis, and not conclusions. An earlier draft's
register implied a later stage than the work has reached; that was a real defect and this
version tries to correct it. Verbs here are meant to carry their actual certainty:
*noticed*, *suspect*, *one reading is*, and where something is quotation from ratified
law, it says so and is the only part of this document that is solid.

**Two documents, not one.** The first pass is preserved whole at
[`pass-1-explication.md`](../../../../.archived/schema-ideation-pass-1-explication.md) — the draft Joseph read on 2026-07-28 (archived to `v2/.archived/` per his 2026-07-28 call),
kept intact at his suggestion so this revision isn't fighting its structure and its
survey layer stays available. This file is the revision; where the two disagree, this is
the later thinking, and where pass 1 carries detail this one compressed, pass 1 is the
fuller record. *(Joseph's actual suggestion was to leave `README.md` as pass 1 and put
the revision beside it; I inverted that because readers already hold the README link and
pointing it at a draft with known defects would mislead. If the other arrangement is
wanted it is one rename — nothing else references either file by name.)*

**How to read this.** §1 answers the question worth asking at this stage — is a model
coalescing, or is this noise on noise. §2 is scaffolding (offered as such). §3 hangs
Joseph's kinds question on it. §4 is the decided law, which is the load-bearing part.
§5–§6 are the open questions and what to probe. Everything after §6 is appendix —
evidence detail, testimony, estate archaeology, prior art — cited where it does work,
skippable otherwise.

**Register.** *decided* (cited ruling or spec text) · *evidenced* (estate or demand
corpus, cited) · *proposed* (generated here) · *open*.

**On the O-numbered items (O1–O7), and a correction to how this map cited them.** These
are **Joseph's continuing brainstorms, pre-validation** — his framing: *"My ideas get
different treatment because if they get silently dropped I'll want to know exactly why,
and because they embue my experience, but it doesn't promote them beyond that. They
aren't steers unless you are convinced of the underlying principledness of them."* They
live at [`../../primary/DISCUSSION-THOUGHTS.udon`](../../primary/DISCUSSION-THOUGHTS.udon)
with per-item status, not in the decisions ledger; earlier drafts of this file called
them "steward marks," which lent them an authority they do not claim. That mis-citation
is worth naming rather than quietly fixing, because it is **the exact failure O3's own
content describes, committed by the act of recording it** — the form of the ledger
laundering a brainstorm into law. Corrected throughout: where this map's own material
independently warrants a claim, the material is now stated as the support and the
brainstorm as its seed; where a claim rested on the O-item alone, it now reads as
pre-validation. True fiat, when it comes, will be marked as fiat.

Where a claim rests on de-novo agent testimony I say so inline and keep it thin — it is
one support-kind and mostly lives in Appendix C. Where reasoning has a gap I have tried
to show the gap rather than the conclusion alone; where I generated something with no
source, that is marked.

**Sources.** Primary: `../../current-0.9.1-spec/` (CORE, MODEL, CARVEOUTS read whole);
`../doc-store-and-schemas-report.md` + its research log; the demand corpus
`../../udon-needs/02-tooling-needs/` (swept whole); `~/src/rowan/docs/` and current Ash
(Appendix D); the vivarium live-usage field report and the verified specimen filed
beside this file; three de-novo testimony transcripts, also filed here (Appendix C); and
Joseph's pre-validation brainstorms at
[`../../primary/DISCUSSION-THOUGHTS.udon`](../../primary/DISCUSSION-THOUGHTS.udon).

**Why this exists (Joseph, 2026-07-28):** the lay of the land before design — what kinds
of schema "drive or foreclose various capabilities (either fully or by way of
affordance)" — in the shape that unstuck the markdown conversation, where "reasoning
about markdown always seemed to go sideways because the agents were assuming one thing
and I another thing and no one was realizing the whole picture." His hedge is
load-bearing: the kinds he named were "a light sampling… definitely not a MECE list…
because that's the big picture that I still don't have in mind yet."

Carried as orientation, marked by him as instinct rather than settled thinking: *"we're
repurposing [archema's] vision here: The Arch-Schema… it should have the superset
schema-ability (even if that means more than one official representation, or even if the
internal canonical representation is a bit obtuse and exposed in more digestible
formats…)"*. §6.2 tries to give that instinct something finite to be checked against.

---

## 1. Is anything coalescing?

The honest answer: **mostly this is explication, with one candidate for something
intrinsic.** Separating those is the most useful thing this section can do.

### 1.0 The frame this map was missing — schema debt, and who holds it

*Brainstorm **O1** (Joseph, pre-validation — `../../primary/DISCUSSION-THOUGHTS.udon`),
which arrived after this map was drafted.* Joseph's adage, verbatim: *"the
data will always want a schema — you can use a technology that forces a schema
prematurely up front, before document consumption, or you trade that check and end up
doing all of the battle of normalizing and consolidating in retrospect at read-time or
processing time."* Schema-vs-schemaless framings "obscure the real issues they both
have."

**What warrants it here is not that Joseph said it but that this map's material was
already carrying three instances of it** — recorded separately, before O1 arrived,
without my seeing they were one thing. That is the validation, and it is why the frame
is load-bearing below rather than merely quoted: **schema is not a feature a format has
or lacks; it is a debt every stack pays, and the design variables are when it is paid
and who holds it.** The three:

- The live corpus pays it **continuously, in agent cognition, unrecorded** —
  "conformance is currently imitation, not validation; every one of us wrote rows by
  pattern-matching the tail of the file" (Appendix B.5).
- The estate pays it **at read time, deliberately and by declaration** — `was:` renames
  and upcast chains, "storage is never rewritten; the transform happens on the way out"
  (B.4).
- One region paid it **at processing time, in data loss** — the `rindex` truncation,
  where the debt came due as a silently truncated record (B.2).

And the trade study behind the doc-store work — sqlite vs postgresql vs
documents-in-a-directory, documents *barely* winning on agent affordance — was in these
terms a **when** trade: SQL forces the check up front, documents defer it. Which makes
UDON tooling's ambition legible as *changing the terms of that trade*, not as picking a
side in it.

**Three refinements this map's material forces on the frame**, offered as extension
rather than agreement:

1. **"When" is at least four different whens, and collapsing them reproduces exactly
   the sideways-ness this map exists to prevent.** They decouple: *when the constraint
   is authored* (before data exists / alongside / inferred after) · *when the check
   runs* (write / read / build / only ever in a reader's head) · *when the debt comes
   due* (possibly years later, at the moment someone tries to consolidate) · and,
   separately from all three, *when the schema itself changes* (this map's Time axis,
   §2). The vivarium case is authored-never, checked-continuously, not-yet-due — which
   is precisely why that consumer's incident-gated norm ("build the linter the day
   attribute drift first bites someone") is coherent rather than lazy. It is a bet
   about **when-due**, not a claim that the check is unnecessary.
2. **The *who* may be doing more work than the *when*.** In the vivarium case the
   holder is each agent's pattern-matching — re-derived per agent, per session,
   unrecorded. The cost is not principally that the check is late; it is that it is paid
   **N times and never accumulates**. On that reading a schema artifact's core function
   is *making the payment accumulate*, and "early vs late" is downstream of "recorded vs
   re-derived." Note `was:` fits this better than it fits earliness: it does not make
   the check early, it makes it recorded and reusable.
3. **The frame governs the malformation debt only.** §6.1's measured ceiling — ~70% of
   silent failures caught only by human product-use — is a *second* debt that no
   position on the when-axis pays, early or late. O1 organizes the schema layer; it does
   not bound it. That caveat belongs with the frame wherever it travels.

**Where the frame bites hardest — the accumulation problem, and its discharge route.**
Expansion-reduction (Joseph's "best SQL schemas I've known" — adaptive,
event-sourcing-style) is the mechanism for paying schema debt incrementally instead of
in a flag-day. The estate reports that in a document store the reduction half never
happens: "there is nothing to contract… the cost of an old address never expires, and
neither does its resolution" (B.3). Read structurally, that implies **monotonically
accumulating, never-discharged read-time debt** — every past shape live forever, which I
did not think survivable at corpus scale.

**Brainstorm O4 proposes a different interpretation, and my own material supplies a
stronger warrant for it than the brainstorm carries.** O4 (Joseph, pre-validation): *"The
estate's 'finding' that
contraction never happens is, I believe, just an indication that there is no framework
that makes it as easy as it needs to be."* Renaming toward a domain's ubiquitous
vocabulary (`site` → `company-primary-url`) is right practice that nearly every surveyed
project does badly, because nothing lets old and new coexist until the old can be safely
removed.

The stronger argument — mine, and it stands whatever O4's status — is that the estate's
claim **contradicts its own founding thesis**.
The report's §0 holds that *a directory of documents is a table*. If the directory is the
table, then an old attribute name sitting across four hundred documents **is** the
column — and dropping it is exactly what `DROP COLUMN` does. So contraction is perfectly
well-defined in a document store; what is missing is that it is a bulk mutation with no
transaction, no gate, and no tooling, so nobody performs it. "Nothing to contract"
mistakes *unaffordable* for *undefined*. B.3's asymmetry ("RDBMS drops the column and
trigger; YAML and JSONL take no action") is then the **symptom**, not the nature.

So the accumulation problem gains the discharge route it was missing, and it is neither
of the two I had guessed: **affordable contraction with a declared coexistence window**.

**But affordability is not the whole safety condition, and this is where O4 and O5 lock
together.** Contraction requires knowing the old name is no longer in use. An RDBMS can
know this — every write passes one gate, which is what `old_write_count_30d` and
`safe_to_contract` monitor (B.3). A document corpus cannot, in general: documents travel,
get vendored, live in other people's repos. **"Safe to contract" is decidable exactly as
far as an adjudicator's observability reaches** — which is O5's bottleneck, and which
makes that bottleneck load-bearing rather than merely tolerable. The single source of
truth about schema evolution is not bureaucracy; it is the only thing that can answer
contraction's safety question.

That yields a scoping consequence I have not seen stated anywhere (*proposed*): UDON
documents fall into **two regimes** — *governed*, inside an adjudicator's reach, where
contraction is affordable and the debt discharges; and *wild*, beyond it, where read-time
translation must persist indefinitely and the debt really is monotonic. A document that
moves from governed to wild silently acquires a permanent obligation nobody is tracking.
If that is right, which regime a document is in should probably be **explicit** rather
than inferred — which lands on PRAGMA alongside everything else in §A.4.

**Does the O6 extractor bridge that boundary? Partly, and the part it doesn't is the
part that matters for contraction.** The proposal is attractive: you never ask a wild
corpus to enroll, you *read* its de-facto schema and offer promotion — a cheap crossing
in the useful direction, and I think that stands. But an extractor observes
**documents**, not **readers**. A wild corpus can be fully migrated off an old name
(extractor: absent, looks safe to contract) while some wild *consumer* still expects it.
Contraction safety is a claim about dependants, and dependants are exactly what a
document corpus cannot enumerate.

Worth noting the estate hit the same wall and accepted it: its monitor phase tracks
`last_old_write` and `old_write_count_30d` (B.3) — **write-side observations only**. So
write-side observability is apparently considered adequate in practice, which is
reassuring but is a precedent rather than a proof. The honest statement: the extractor
extends the governed region's *write-side* reach substantially and its *read-side* reach
not at all, and contraction in a wild corpus therefore stays a judgment call rather than
a decidable one.

**O7 closes the governed half of this, and the closure has two parts rather than one.**
A declared mutation with a census (§3.2) makes "is any document still carrying the old
shape?" a **count**, not an estimate — that settles the write side definitively, which
is more than the estate's sampling-over-time monitor achieves. But contraction safety is
a conjunction: no document carries the old shape **and** no reader still depends on it.
The census cannot see readers. What can, in the governed regime, is **O5** — under
consumer-driven growth the consumers *declare* what they need, so "does anyone still
declare the old thing?" is answerable by inspecting the declarations. *(O5 carries
`recorded-pre-validation` and it is worth splitting in half: the argument here validates
its **necessity** — something must hold reader-side knowledge or contraction is
undecidable — while its other half, that the bottleneck is **acceptable**, is a stated
preference this map has no evidence for either way. Those should not travel as one
claim.)* So the two marks
divide the conjunction cleanly: **O7's census settles the documents; O5's declarations
settle the readers.** Neither alone makes contraction decidable, and I think crediting
the census with the whole job would be the easy error here. It also repays O5's
bottleneck a second time: consumer-driven declaration is not merely an ergonomic
preference, it is what makes the reader half of contraction safety knowable at all.

**O6 completes the payment picture — the authoring payment is already being made.**
Brainstorm **O6** (Joseph, pre-validation): *"the author **is** declaring a
de-facto-schema every time a document is born, and is following one every time it is
added to or repeated."* Of all the O-items this is the one my material corroborates most
directly and independently — the vivarium field report predates it and says the same
thing from the consumer side ("conformance is currently imitation, not validation";
"four agents… writing genuinely structured reasoning into it without being told, because
the form asks for it"), and the filed specimen is verified against its primary. The
support is those; O6 named what they were.

Against §1.0's four
whens this is sharp: *when-authored* is *always, at birth*. What is missing is not the
authoring but the **recording** — the schema is lying in the corpus unredeemed. That
gives refinement 2 its mechanism: an extractor converts N discarded per-agent payments
into one recorded artifact, and it is cheap precisely because the work was already done.

Three things my material adds, one of which is a correction of emphasis:

- **The "legible in syntax" claim is right but should be stated more precisely, because
  the precise version explains *why* extraction is cheap.** UDON does not make the schema
  *inferable*; it makes the schema's **vocabulary explicit** and thereby reduces
  inference to *statistics over a known vocabulary*. In markdown you must infer both what
  the carriers of structure are (is `## Foo` a required section or one instance's
  heading?) **and** their statistics. In UDON `:date` does not need to be guessed to be a
  field — it declares itself — so only required-vs-optional, cardinality, and ordering
  remain to be observed. Two inference problems reduced to one. That is the whole of the
  distinctive-capability claim, and it is enough.
- **Extraction can only ever produce the open half of a schema.** No corpus observation
  distinguishes *required* from *nobody has needed to omit it yet* (Joseph's own tool
  sketch names this: "required-vs-always-present-vs-rare"), and no corpus can witness a
  **negative** constraint at all — absence of evidence. So an extractor yields vocabulary
  and tendencies, never closure. This is the false-requirement danger stated
  structurally rather than as a caution.
- **And that dovetails with the §1.1 correction.** Closure must come from *intent* — the
  author, or O5's adjudicator — and under a non-invasive judge closure is unusually
  cheap, costing nothing in the artifact. So the division of labor is clean:
  **observation supplies the vocabulary, intent supplies the closure.** Neither can do
  the other's job, and neither is expensive.

**The silence-breaker, sharpened.** The convention modality's failure mode is silence
(§3.1). A single extractor run gives a snapshot, which is not yet a silence-breaker; what
breaks silence is running it continuously and **diffing** — *de-facto schema drift
detection*, where a change in the inferred schema is itself the signal. That needs no
declared schema, no enrollment, and no adjudicator, so it is deployable today and
satisfies the live consumer's incident-gated norm better than §3.3's proposal does. It
also satisfies refinement 2 by pure observation: the payment accumulates without anyone
authoring anything. Its honest limit is that drift detection reports that something
changed, never whether it should have — which is exactly the warn-don't-block posture
already ruled in the corpus. *(proposed; probe 8.)*

**How this repositions §1.1**, which is the coordinator's reading and I think it is
right: the non-invasive-judge shape is not an *abstention* from the when-question but a
specific and unusual **position** in it — never blocked at write, judgeable from the
first byte, debt paid continuously as attributable verdicts. The record-schema lineage
structurally cannot occupy it, because there the schema *is* the decoder. One sharpening:
"judgeable from the first byte" has a concrete mechanism worth naming — recognition is
total (any finite UTF-8 input maps to a Document, CORE §1) and schema-independent, so
**there is always a model to judge**. There is no unparseable-therefore-unjudgeable
state, which is the state every record format's validator lives in. That is what makes
continuous payment mechanically possible rather than aspirational.

### 1.1 The candidate — a shape rather than a taxonomy

Four already-decided constraints, which were made separately and for unrelated reasons,
turn out to describe one position:

- **Schemas judge the model; they do not shape it** (MODEL §8) — a schema cannot change
  how a document parses.
- **Dialects say what a value means; schemas say what is allowed; they never trade jobs**
  (CORE §1.1) — a schema cannot assign meaning.
- **Bare recognition is frozen forever** (CORE §11.1) — a schema can never cause a
  retype.
- **Keep-everything** (CORE §14.2) — nothing may be dropped for failing to conform.

Read together these say: **UDON's schema is a pure non-invasive judge over a lossless
model.** It observes and reports; it may not touch the document's structure, its types,
or its content.

The reason I think this might be more than a summary is that it is an *unusual* position
that most formats do not occupy — XSD shapes the parse (typed content models, defaults,
whitespace facets), protobuf's schema *is* the decoder, and JSON Schema quietly coerces
in most runtimes. UDON has, apparently without setting out to, forbidden the entire
class of schema behavior that other formats rely on. And consequences do seem to fall out
of it rather than being added to it: the grammar-kind's strong form is foreclosed;
schema verdicts stop fitting the anomaly channel, because that channel's severity is
defined by loss and a judge-that-cannot-drop never loses anything (§4.8); and the
verdict has to be a separate artifact carrying its own provenance, because it cannot be
expressed as a change to the document.

> **Correction (2026-07-28).** An earlier version of this paragraph claimed "open-world
> becomes the native posture, since a closed schema has nothing to close *with*." That
> was wrong, and the error is worth keeping visible because it is a natural one:
> keep-everything forbids **dropping**, not **judging against a closed spec**. A schema
> can perfectly well say "no attributes beyond these" and verdict the extras while the
> document retains them. I had conflated *enforcement by removal* with *expressing
> closure*.
>
> Correcting it makes the position sharper rather than weaker. Under a non-invasive
> judge, open-vs-closed stops being a question about **what the document contains** and
> becomes purely one about **what the verdict says**. And that decoupling defuses the
> usual cost of closure: `additionalProperties: false` is contentious elsewhere because
> closure is enforced by rejecting or discarding unknown material — brittleness under
> forward-compatibility, data silently dropped. Strip enforcement-by-removal out and
> **closure gets cheap**: you can close the world in the verdict while losing nothing in
> the artifact. That is a genuinely unusual affordance and it belongs on any UDON schema
> design's shortlist. *(The world-openness row in §2/A.4 should be read as a property of
> verdict semantics, not of document contents.)*

**Why I won't claim more than "candidate."** It has not yet predicted anything I did not
already know, and it has not explained a surprise. Those are the tests I would want it to
pass before calling it a model. The nearest thing to a prediction it makes — that any
schema design which wants to shape, coerce, default-into, or prune a document will keep
running into friction that feels arbitrary until this is named — is checkable, and
nobody has tried to check it.

### 1.2 What is still noise

The spine in §2 (Job · Scope · Horizon · Authority · Time) is a **reorganization of
borrowed categories**, not a discovered structure. It is genuinely useful for the stated
purpose — two people can locate where they disagree — and I would not want it mistaken
for more than that. It has not earned the word model.

Likewise the modality table (§3.1): it compresses real practice, and it is the direct
answer to what was asked, but it is a survey. Surveys organize; they don't explain.

### 1.3 Something the explication turned up that nobody anticipated

The one place this pass produced a genuine redirection rather than an organization —
and it came out of Joseph's challenge to an over-asserted table, not out of my own
reasoning:

**Everyone here has been drawing on the data-schema lineage, and the document-schema
lineage is unmined.** The estate's schema material, the demand corpus, and all three
testimony substrates reason from JSON Schema, protobuf, CUE, Rails, GraphQL — formalisms
built for records. The lineage built for *documents* — SGML/XSD mixed content, RELAX NG,
Schematron, and the DTD/TEI/DocBook/JATS tradition — already solved several problems this
territory treats as open, notably constraining prose-and-structure interleaving. Nobody
in this corpus cites it, including my own earlier draft, which asserted prose was
uncovered on one page and named RELAX NG as the tradition that covers it on another.

That is not a model either. But it is the kind of thing an explication phase is *for*, and
it changes where to look. §5.1 and Appendix E carry it.

### 1.4 The leads, at their real strength

- **UDON may already contain its constraint vocabulary in embryo.** CORE §5.4 reserves
  the flag suffixes `? ! * +` for the consuming schema, unassigned, suggesting "`?`
  optional / `!` required" — which is character-for-character Schemacop's DSL, a
  formalism rowan already ships as an export target. If spent that way, an annotated
  example document *is* a schema (§3.3). Suspicion, not finding: the ingredients are
  verified quotation, the proposal built from them is mine and untested, and its limits
  are real (§3.3).
- **Executability is the deepest either/or, and "source kind plus projections" is the
  estate's escape** (§3.2, §6.2). Solid as a description of what the estate built;
  moderate as a recommendation, because Ash's own practitioners report derivation
  degrades outside the framework's data layer — "it organizes, it does not excavate" —
  and UDON's documents live in other people's repos by design. Unresolved.
- **A schema over a document that computes is a different object before and after
  expansion** (§5.2). Well-witnessed; the demand corpus has seen the seam and
  deliberately declined to design across it. Partly answered by shipped practice I had
  wrongly written off — Helm's `values.schema.json` is a schema over template *inputs*.
- **The ceiling is low and should be said early** (§6.1): ~70% of silent failures in the
  estate were caught only by human product-use, not by 4,286 tests. Validation catches
  malformation, not plausible wrongness. Every capability here is bounded by that.

**What I could not answer:** whether the schema document is itself a UDON document
governed by a schema. It bears on §3.3, on substrate, on §6.2's audit, and on PRAGMA.
Left open rather than resolved by invention.

---

## 2. Scaffolding: where a schema disagreement actually lives

*Offered as a working decomposition, per §1.2 — useful, not intrinsic.*

Joseph's read of the previous draft was that a spine appeared early and then got
retangled and lost; that was correct, and his guessed spine was **jobs × moments ×
authority × strictness**, offered as "or something." Rather than adopt it, I tested it
and changed two things — the reasoning, so it can be overridden:

- **Jobs** — kept.
- **Moments** → **horizons**. Clock-time (keystroke/save/CI) seems downstream of a prior
  question: what is knowable at all, and from what context? A cross-reference constraint
  is not "later," it is *unknowable from the fragment alone*. Sorting by knowability
  explains the timing; the reverse doesn't hold.
- **Strictness** folded **into authority** — "how hard is this rule" and "who says so,
  and who wins when sources conflict" stayed the same question every time I tried to
  separate them.
- **Scope** and **time** added, because the material would not sit inside the other
  three.

So: **Job · Scope · Horizon · Authority · Time**, with modality — Joseph's "kinds" — as
the tactic chosen afterward, which is where §3 picks up. The working claim: "we need a
schema" is underspecified until these five are answered, and much of the sideways-ness
is two people who have silently chosen different points debating tactics.

| Axis | The question | Options | Where it bites |
|---|---|---|---|
| **Job** | What is it *for*? | guide authoring · accept/refuse · migrate · describe & discover · generate · project/interop · **negotiate responsibility** | A kind strong at one job is usually weak at another; picking a kind first picks your job for you |
| **Scope** | What does it govern, and what does the verdict attach to? | document · **region within a document** · collection · cross-document — and: whole-doc boolean · verdict at a path · fragment · **diff/transaction** | The guarded edit needs transaction-shaped verdicts — a *granularity* requirement, not a kind requirement, which is why "which kind gives us the guarded edit" is mis-posed |
| **Horizon** | What is knowable, from what context? | syntactic · local-structural · cross-reference · environmental/policy | Collapsing them produces red error markers because a network is down, or blocks a draft referencing something landing next commit |
| **Authority** | Who binds whom, how hard, who wins? | who ascribes (producer `_schema` · **consumer-side** · ambient · none) · rule strength (illustrative → recommended → deprecated → required → forbidden) · precedence · open/closed world | Sits on the open carve-out **PRAGMA**. Also where "hard constraint and soft convention lint in one artifact" lives |
| **Time** | Does it version, and does it own the transition? | snapshot · versioned · versioned-with-declared-relation (`was:`, upcasts) | Decides whether migration is available at all (§3.2) |

Detail and evidence: **Appendix A**.

**A limitation of presenting these as five independent axes.** At least two *pairs* are
jointly load-bearing, and reading the columns separately hides them. **Authority × Time**
is who may change the schema as it evolves — O5's adjudicator, and the reason that
bottleneck exists at all. **Scope × Time** is *record-granularity migration*: the record's
own shape changes as a corpus matures. Joseph's account of the ASF claims is the worked
history — "before the claims were forced by me into their own individual files, there
would often be three or four claims in a single file" — layout migrating from
many-records-per-file toward file-per-record as the material firms up. That is
expand-contract at the **record-shape** altitude rather than the field altitude, and it
wants the same O4 affordance: a coexistence window where the outline row still points at
the jumbled file while split records emerge, ending when the jumble is safely deletable.
That ending condition is the one **O2** proposes (Joseph, pre-validation) — integration as
safe deletability is precisely the *contraction* criterion for granularity migration, a
tighter connection between O2 and O4 than either states alone. The connection is mine;
what makes it usable rather than merely tidy is that it is checkable, per the next
paragraph.

**And O7 supplies the criterion mechanically, which closes the chain.** O2's safe
deletability is normally a judgment call — *has this been integrated?* — but for any
migration that can be censused it becomes a count. The coexistence artifact is safely
deletable **exactly when the census reads zero**: a `!{was: site}` clause when no
document carries the old name; the jumbled multi-claim file when no unsplit claim remains
in it. So the four marks compose into one mechanism, each of which is partial alone:

> **O4** declares the mutation and opens the coexistence window · **O7** censuses the
> nonconforming population and burns it down through adjudication · **O2** fires when the
> count reaches zero and the coexistence artifact becomes safely deletable · **O5** holds
> the declaration and the consumer list that make both halves of "safe" knowable.

*(proposed as a synthesis, and the weakest-supported thing in this document: each of the
four is Joseph's **pre-validation brainstorm**, the composition is mine, and a chain is
only as warranted as its links. O4 and O7 have independent support here — the
directory-is-a-table contradiction and the two shipped embryos respectively; O2's
application is mine; O5's acceptability half is unvalidated. So read this as a shape
worth testing, not a mechanism ready to build toward.)*

**With a live case in waiting:** OPEN's **SEG-SPLIT** row asks when `udon-needs/`'s
chapters split into constituent claim segments, with Joseph's readiness signal recorded
as a deepening cycle ending in "the structure held." That is granularity-migration
pending, in this repo, with a stated trigger — the closest thing to a natural experiment
this territory has, and it will happen whether or not anyone models it first. It is also
O7's natural first customer: "extracting to independent claims" is Joseph's own example
of a censusable judgment-bearing mutation, and SEG-SPLIT is that mutation already
declared and waiting. Running it *with* a census rather than ad-hoc would cost little
beyond the tracking and would test the whole O4→O7→O2 chain on real material.

Two notes that change what a verdict *means*, so they belong here rather than in an
appendix:

- **Posture.** *Evidenced, already decided in the corpus:* generation wants **soft
  recovery** (keep everything, warn, continue — half a document beats none); careful
  writes want **hard, mutation-free refusal** (half an edit is worse than none). "Same
  language, opposite postures… the tooling mistake would be letting either posture
  colonize the other." So *"is this document valid?"* stays underspecified even after a
  schema exists.
- **The five meanings of "this document has type X"**: a tool may use the name for
  completion · a validator checks it strictly · a loader **coerces** to it · a generator
  emits a runtime type · it controls what a consumer will **accept**. These get smuggled
  together routinely. Note that §1.1's shape forecloses coercion for UDON outright.

---

## 3. Kinds, on the scaffolding — the question as asked

### 3.1 The payoff table

Six modalities. The honest headline is that they **stack** — in the estate one record
type runs three at once (Appendix B.1) — so a single-kind answer doesn't describe
anything actually built.

**Read this table through §1.0 and it reorganizes**, which is the best evidence I have
that O1 really does sit above the kinds axis: each modality is characterized by *when it
makes you pay and whether the payment accumulates*. Prototype pays at author time,
cheaply and incompletely. Constraint pays at check time, completely, expensive to
author. **Class/resource is the only one that spans** — it pays at write *and* owns the
read-time translation, which is why it is also the only one that ships migration.
Grammar pays at parse time only. Procedure pays whenever someone remembers to run it.
Convention defers entirely and bills the reader — and, per §1.0's second refinement,
bills each reader separately with no accumulation. That single sentence per row may be
more useful than the four columns below.

| Modality | Drives (hard) | Forecloses (hard) | Easy | Awkward |
|---|---|---|---|---|
| **Prototype / example** | onboarding; imitation; agent few-shot editing; **works over prose natively, because an example *is* a document** | exhaustive accept/reject; mechanical migration; proving a *novel* combination legal | zero ceremony; the modal foreign-repo read path | invariants invisible in one instance (mutual exclusion, cross-field, ranges); saying "never"; staying in sync — untested examples rot into lies that get trusted over the schema |
| **Constraint predicate** | closed-world accept/refuse; CI gates; interop; form and doc generation | owning runtime behavior; migration with domain semantics; expressing intent | red/green; enums, ranges, required sets | defaults and fill-in; gradual typing of organic documents; **disjunction errors** (nobody has solved "which branch did you mean"); prose structure |
| **Class / resource** | **migration** — the only modality that ships it; defaults; computed members; **projection into other kinds**; policy colocated | being a portable contract without exporting a projection; serving an editor holding only the file | behavior colocated with shape; one source of truth | documents outside an app lifecycle; polyglot consumers; editing without booting the world; prose-primary files that aren't rows |
| **Grammar** | well-formedness; incremental parse; **error recovery that keeps a tree alive while the file is broken** | semantic validity of any kind; migration | editor experience; structural editing | value constraints; cross-references; versioned key vocabulary. **§4.1 forecloses its strong form in UDON** |
| **Procedure** | anything expressible in code; **the incident-response schema** — what actually gets built the day a wound appears | portability; static analysis *of the schema*; interrogability; anything to project from | shipping today | review; drift from declared intent; no discoverability surface |
| **Corpus-inferred / convention** | zero cost; local adaptation; **not an option but the floor** — see below | guarantees; en-masse migration; complete client generation; **closure of any kind** (§1.0) | matching how humans and agents actually work | enforcement; onboarding at scale; **its failure mode is silence** — demonstrated instance in Appendix B.2, and the silence-breaker is §1.0's drift detector |

**The convention row is not a peer of the other five.** Under O1 the schema debt is always
paid; under O6 the *authoring* half is always paid **at birth**. So convention is not a
modality anyone chooses — it is the baseline every document already has, and the other
five modalities are ways of **redeeming** it: recording what convention already does, so
the payment accumulates instead of being re-derived per reader. Reading the table with
that correction, the question stops being "which modality do we adopt?" and becomes
"which parts of the de-facto schema do we redeem, and by what means?" — a materially
different conversation, and one this map's earlier drafts could not have hosted.

### 3.2 The foreclosures that aren't about kinds

These get mis-attributed to modality. I suspect this list does more work than the table:

- **Executability forecloses portability; inertness forecloses migration.** Migration is
  a property of the *class* modality specifically — in the estate it works because the
  transform lives in the class. §6.2 is the escape.
- **Whole-document verdicts foreclose the guarded edit** — a *scope* choice.
- **External substrate forecloses prose and comment fidelity** in practice.
- **Closed world forecloses extensibility *elsewhere*, but the cost is unbundled here.**
  Corrected per §1.1: closure's usual price is paid in enforcement — unknown material
  rejected or dropped. UDON cannot enforce by removal, so a closed verdict costs nothing
  in the artifact. Closure and extensibility stop trading against each other, which is
  the reverse of the usual foreclosure. *(Inference from decided law, not a ruling.)*
- **On "auto-up/down" — re-derived under O4.** An earlier version of this row said
  "*down* is largely a mirage," resting on the estate's "nothing to contract." §1.0
  reinterprets that as *unaffordable*, not structural, so the row splits along the
  **mechanical / lossy / requires-human-judgment** trichotomy rather than collapsing:
  - **Mechanical** (a rename): down-migration is entirely available and *should be
    cheap*. This is O4's target and the affordance Ash didn't quite deliver. Nothing
    structural blocks it; tooling absence does.
  - **Lossy** (a field split, a type narrowing): reversible only with a declared
    policy about what to do with the information that has no old home. The corpus's
    warning applies — backward translation that silently drops new-only data
    "reintroduces exactly the duplicate-key failure class one layer up."
  - **Requires human judgment** (a prose restructuring, a concept split): the per-item
    cost is genuinely structural. Prose cannot always be transformed losslessly, and no
    framework makes interpretation cheap. **But an earlier version of this row inferred
    too much from that** — see the correction immediately below.

> **Correction under O7 — I conflated two claims.** The row above previously said this
> tier is "permanent," which slid from *the per-item cost is irreducible* (true) to *the
> migration cannot be driven to completion* (a non sequitur I did not notice making).
> Brainstorm **O7** (Joseph, pre-validation) names the difference — and what warrants it
> below is not its provenance but that the estate already contains two shipped embryos of
> it (this repo's compliance gate; relata's `.needs-review`). A purposeful contraction "meant to be an
> adjudication point" where "all of these need an LLM to adjudicate how to make it
> conform to the new model — and here's the quick tool that tells us exactly how far
> along we are… Something that tracks the whole process holistically instead of agents
> and human agents tracking it ad-hoc."
>
> So the judgment tier does not get *cheap*; it gets **managed**: declare the mutation →
> census the nonconforming population → queue the judgment-bearing items → burn down →
> contraction fires at zero. A finite population each needing one adjudication is a
> burn-down, which is the most tractable project shape there is. What made it *feel*
> permanent is the absence of a census — without knowing the population you cannot
> distinguish progress from drift, so the work reads as unbounded even when it is not.
> The irreducible cost is per-item; completability is a tooling question, and O7 supplies
> the tooling.
>
> **Two shipped embryos, one of them in this repo.** UDON's own compliance gate is
> already this shape pointed at fixtures — a declared target (CORE), a censused
> population (the active fixture group), "live per-file burn-down counts," and a
> completion condition. And it carries the rule O7's census will also need: *"burn it
> down by fixing the grammar to CORE, **never by editing fixture expectations toward
> parser output**"* (`CLAUDE.md`). **A census creates pressure to reach zero by
> reclassifying items as conforming rather than adjudicating them** — the anti-gaming
> clause is not incidental discipline, it is what makes the count mean anything. The
> second embryo is relata's `.needs-review` outcome: an adjudication queue at *item*
> granularity; O7 is the *corpus*-level version, bound to a declared mutation.

  Separately and independently of contraction: forward-compatibility declarations
  remain "primarily documentation" in the estate's own words, because a schema cannot
  bind a future reader. That limit is unaffected by O4.

### 3.3 A lead: one artifact instead of two

*Proposed — mine, built from verified ingredients, untested.*

CORE §5.4 reserves `? ! * +` for the consuming schema and leaves them unassigned, with a
reading on the record: "a schema might read `?` optional / `!` required." Schemacop's
DSL — which rowan ships as `to_schemacop_dsl` — spells requiredness exactly that way.
Traits already mean "what kinds of thing it is."

```udon
; a prototype that is also a constraint — no second language, no second substrate
|user
  :email!  <str:/@/>        ; required, dialect-typed
  :role?   user             ; optional; the prototype value doubles as the default
  |profile?                 ; optional child
  |post*                    ; zero or more
```

Why it seems worth testing: it collapses the example and the constraint into one artifact
(CUE's unification) in reserved syntax rather than as an import; it addresses the live
wound directly, since if conformance is currently imitation, the cheapest fix makes **the
tail of the file declarative** rather than adding a second artifact nobody reads; it is
the only modality cheap enough to satisfy the incident-gated norm the live consumer
stated ("build it the day attribute drift first bites someone — not before"); and it
works *with* the fact that people trust examples over schemas.

**Weak links.** The modality's hard foreclosures don't vanish: no mutual exclusion, no
cross-field conditions, no migration, and it cannot project to schema-required targets
(§6.2) without inference — which is the move that turns observed regularity into a false
requirement. Four suffix characters is not many, and **§5.4's own sentence already
oversubscribes them** (`?` reads as schema-optional *and* grammar-0-or-1 in one breath).
And I have not tested whether the annotated form stays readable *as an example* once
enough annotation accumulates — which is the entire premise. Probe 2 is the cheap test.

---

## 4. What is already decided

Quotation, not inference — the solid part of this document. The one inference is marked.

| # | Constraint | Cite | Consequence |
|---|---|---|---|
| **4.1** | "Nothing in the model is invalid by schema; **schemas judge the model, they do not shape it**" | MODEL §8 | Forecloses the strong grammar-kind, schema-directed disambiguation, and schema-driven coercion |
| **4.2** | **Dialects are not Schemas** — "a dialect says what a value *means*; a schema says what is *allowed*. They never trade jobs" | CORE §1.1 | A schema **cannot define a type**; `format: date-time`-style hijack is out by construction |
| **4.3** | **Bare recognition is frozen forever**; non-core types live in `<…>` | CORE §11.1, §11.6 | A schema can never cause a retype. The Norway class is structurally unavailable — keep it, don't re-earn it |
| **4.4** | "What is *allowed* (e.g. forbidding a multi-valued `$key`) is **schema territory, never core**" | CORE §6.7 | Schema's explicit first task: cardinality over the stack — and the model keeps `:x 1 :x 2` distinct from `:x [1 2]`, so there are two things to constrain |
| **4.5** | Flag suffixes `? ! * +` **reserved for the schema, left unassigned**, with a suggested reading | CORE §5.4 | The syntax seat already exists. §3.3 |
| **4.6** | **Menu vs knob** — core may fix an option space; consumers pick within it | CORE §1.1 | Strictness profiles are a *menu* question, and the menu is core's to fix |
| **4.7** | **Duplicate definitions already have a menu**, default `error` | CORE §12.3; R14 | The silent-last-wins wound behind much of the schema demand is answered by core law. **Repriced under O3** (see below): R14 is a CARRY row whose cite is "CORE References; greenfield convergence" — agent consensus, not recorded reasoning. That the *problem* is handled is solid; that this **option set and this default** are right is softer than the citation looks, and is recheckable on contact |
| **4.8** | Anomaly severity is **defined by loss**, two-valued, recognition-layer | CORE §14.1, MODEL §7 | Schema violation loses nothing, so it doesn't fit `Error = loss`. **Inference, not a ruling:** the verdict channel is probably a separate object, and reusing Warning/Error would kill L0's mechanically-checkable property. What a verdict might carry: Appendix A.4 |
| **4.9** | Designated `$`-attributes are ordinary attributes; sugar and longhand **indistinguishable in the model** | CORE §5.3, MODEL §3.1 | Schema constrains `$key`/`$traits`/`$?` with ordinary machinery, and must not distinguish `\|el[k]` from `:'$key' k` |
| **4.10** | **`$partial-key` must be excluded from identity by any consumer** | CORE §5.3 | A truncated identity must never satisfy a uniqueness or reference constraint |

**A boundary the `was:` sketch exposes (O4).** Joseph's no-lean sketch spells evolution
metadata in the **dynamics** tier: `|company-primary-url !{was: site}`. §4.2 should get a
chance to react, and my reaction is that **the sketch is evidence §4.2's partition is
incomplete rather than that it is being violated**. Dialects say what a value *means*;
schemas say what is *allowed*. `was:` says neither — it is a claim about **identity over
time**, that this thing and that earlier thing are the same thing. Checking CORE §1.1's
owner table, there is no seat for it: Projection (Host), Constraint (Schema), Exotic
typing (Dialect), Reference resolution (Host), Duplicate policy (Document layer), Mixin
(Host). **Identity-lineage has no owner.** That gap is worth naming precisely because
`was:` is the mechanism O4 turns on, and an unowned mechanism is how boundaries get
traded by accident later.

Two placements, with consequences rather than a recommendation:

- **Dynamics tier** (the sketch as written). Real affordance: a conforming recognizer
  MAY carry a directive's body unresolved with no dialect loaded (CORE §1), so
  `!{was: …}` **degrades to an inert no-op** for schema-unaware readers — evolution
  metadata that cannot be mistaken for data. Cost: it is not an attribute, so it may
  not be path-addressable, which collides with the annotation demand that residue be
  "queryable by the same path language as content."
- **Designated attribute** (`$was`, per §4.9's machinery). It is then uniformly
  addressable, uniformly constrainable, and sugar/longhand-equivalent by existing law.
  Cost: it is *data* — every consumer sees it and may misread it — and it consumes
  attribute space on every renamed field.

The choice is a real one and I don't think this map should make it. Naming that it is a
**third job**, not a schema/dialect trade, is the part I'd want carried forward.

**Repricing under O3.** Brainstorm **O3** (Joseph, pre-validation) holds that 0.9-era
rulings which failed to capture their reasoning are recheckable-on-contact rather than
sacred — Joseph: "I had no
confidence that they are driven by anything other than the most convenient things to
implement given the way the stack was already being implemented." *(The test it proposes
is one anyone can run against the spec text, which is what makes it usable here
regardless of its status — and note the irony that an earlier draft of this file
laundered O3 itself into a "steward mark," performing the exact move O3 warns about.)*
Sorting this table by that test: **4.1, 4.2, 4.3, 4.6, 4.8, 4.9, 4.10 are the reasoned kind** — each states a
motivation in the prose that carries it (layer separation, owner separation, the Norway
failure, menu-vs-knob, `Error = loss` as mechanically checkable, sugar-is-designated-
attributes, the fail-safe's explicit rationale). **4.7 is the softer kind** and is
repriced above. **4.4 and 4.5** state their consequence but not their why, so they are
mid — safe to rely on as *what the text says*, less safe as *settled intent*.

This matters to §1.1 in a way worth stating: the four constraints the candidate is built
from all sit in the reasoned class, and — more usefully — they were reasoned from **four
unrelated motivations** (layer separation, owner separation, avoiding a specific external
failure mode, and data preservation). Four independent motives landing on one coherent
position is somewhat better evidence of a real shape than four convenient choices by one
author would be. It does not dissolve the single-author caution in the Working Notes, but
it is the closest thing to a discriminator I have.

**Carve-outs this pulls on — and must not close.** `CARVEOUTS.md` exists because three
clean-room rewrites, handed the spec without the *reasons*, closed an open question in a
dead framing. **PRAGMA** is the authority axis and a schema design will force it — but
the dependency runs both ways, so it should be worked jointly. **PATHS**: schema
addressing *is* paths; a schema inventing its own addressing creates the second dialect
of addressing PATH-1 and S14 exist to prevent. Also DIALECT-DEF, ANNOT, MIXIN (§3.3
leans on traits, and mixins are a *host experiment*), ML, IND. Detail: Appendix E.

---

## 5. The open questions

### 5.1 Which tiers can a schema address?

**This table was wrong in an earlier draft** — it asserted "no" in several cells without
reasoning, and Joseph challenged the verbatim row specifically ("why can't `!:sql:` pull
in cross-language schemas?"). He was right; working it through changed three answers and
produced §1.3. Each cell now carries the reasoning, so the check is possible.

| Tier | Covered? | Reasoning |
|---|---|---|
| Element structure / nesting | yes | every structural tradition |
| Attributes and values | yes | every constraint language; UDON adds stacking cardinality (§4.4) |
| Identity and traits | mostly | XSD `key`/`keyref`, SQL keys. Uniqueness in UDON is already a document-layer menu; traits are an AND-filtered classification with thinner precedent |
| **Prose / text runs** | **yes, in the lineage nobody here cites** | XSD/RELAX NG mixed content, DTD, Schematron, TEI/DocBook/JATS all constrain prose-and-structure interleaving. The *data*-schema lineage (JSON Schema, protobuf, CUE) does not — and that is the lineage this whole corpus reasons from. §1.3 |
| **Comments** | rare, but for a **contingent** reason | Other formats discard comments before validation, so there is nothing to validate. UDON *keeps* them as first-class model items (MODEL §5), which makes the question newly askable. And partial precedent exists: `#[warn(missing_docs)]`, javadoc/godoc requirements are schemas over comments enforced by tooling |
| **Verbatim bodies** | **yes — by delegation** | The label in `!:sql:` is already a dispatch point ("passes to the host uninterpreted", CORE §10.1). A schema need not know SQL, only name a checker. Shipped precedent: **JSON Schema's `contentMediaType` + `contentSchema`**, tree-sitter language injection, doctests, fenced-code linting. Open questions are narrower: who resolves label→checker; whether a body failure reports at body-relative or document-relative coordinates; whether byte-exactness fights a checker that normalizes |
| **Dynamics** | **inputs yes, outputs rarely** | Schemas over template *inputs* ship today — Helm's `values.schema.json`, Terraform variable types. What is rare is proving the *output* conforms for all inputs; Dhall's type system is the nearest thing. §5.2 |
| Envelopes / dialect-typed values | yes, as constraint | XSD facets over simple types, `contentSchema`. Constrainable but per §4.2 never interpretable by the schema |
| References `@` | yes as a tradition, awkward here | ID/IDREF, `keyref`, foreign keys are mature. UDON's wrinkle: `@` is an *inert selector* whose resolution is a host menu, so "must resolve" presupposes a resolution mode the core deliberately leaves unchosen |
| **The document as a whole** | **no — and this is structural** | There is no implicit root element (MODEL §1); top-level nodes are true siblings, and a root-level `:key` is a Warning kept as document text because "attributes are edges of elements; there is no phantom owner" (L1). So **a whole-document schema has no node to attach to** — the declaration has nowhere to live. This is an instance of the element-centric / root-silent defect class, arriving in schema territory, and it is a large part of why PRAGMA is hard rather than merely undecided |

**What survives of the original point, stated at its real size:** not "nobody has solved
these," but that the *estate and its inputs* are reasoning exclusively from record-shaped
formalisms, and the document-shaped lineage that already handles prose, mixed content,
and rule-over-tree assertions (Schematron especially) is uncited here. That is a
redirection with an address, which is more useful than the overclaim it replaces.

**Still genuinely thin:** comments (contingent precedent only), and the output half of
dynamics.

### 5.2 The computed-document duality

A schema over a pre-expansion document and one over its post-expansion result are
different objects. The demand corpus **has** seen the seam and deliberately declined to
design across it: a template is *interrogated* for its required context before it is
built, and "the interrogation's answer is itself a small schema" — but one describing the
document's **inputs**, not its output shape. A static schema over the rendered document
says nothing about whether the render will succeed. The two evaluation sites are logged
as "unification pressure, deliberately not acted on," because "unifying before the demand
picture says when each is expected will just invent a prettier wrong boundary."

Per §5.1 the input half is shipped practice elsewhere, which I had wrongly written off.
Open: which object does a verdict mean? Can a template be *proved* to emit conforming
output for all inputs? What does the guarded edit validate when the edited node sits
inside a currently-false `!if`? This connects to the living-documents seed's ascribed
include ("assuming it is compliant with my schema and version") — a schema check at a
slot, pre-expansion.

### 5.3 Prose, beyond the tier question

The estate's one direct attempt (a markdown-structure DSL: headings by
level/pattern/cardinality) is **designed-only and blocked**. The corpus sweep found no
chapter covering head-line lint, narrative ordering, or required sections — and
`RESIDUALS.md` doesn't list it as a known gap, so it is a blind spot rather than a
scoping decision.

The most useful decomposition I found (testimony, Appendix C.2) is that "schema over
prose" means six different things — genre · outline constraints · embedded data islands ·
inline structured phrases · semantic roles · machine-checkable claims — landing on
*genre + outline + roles + reference integrity*, "almost never sentence grammar of
truth." Its failure mode is worth carrying because it is what an ambitious estate would
build: "'every claim must have evidence subtree' sounds good and produces cargo-cult
headings with empty content to pass CI."

Two UDON-specific notes (*proposed*): UDON has no *island-boundary* problem — prose and
structure interleave by geometry, so the boundary is the **content base** (CORE §7.2),
already precise and addressable. Against that: UDON's text is deliberately **opaque** at
the core (§7.1), and the markdown concern map already assigns the `doc` element
vocabulary to the **schema layer** — so "schema over prose" and "the `doc` schema" are the
same question arriving from two directions, and neither map cites the other. Unrouted.
There is also a shipped counter-position: Obsidian deliberately keeps frontmatter
properties to "small, atomic bits," refusing rich structure there.

---

## 6. Ceiling, audit, probes

### 6.1 The ceiling

*Evidenced, measured:* roughly **70% of silent failures were caught only by human
product-use, not by 4,286 tests**. "Validation catches malformation, not plausible
wrongness… a value can validate perfectly and still be false."

So every capability here is a *malformation* capability — a guarded edit that refuses
non-conforming mutations still accepts a conforming lie. The corpus's own answer is not
more schema but *stated intent* as something a verifier checks the diff against ("is this
correct" isn't checkable; "does this match what it claims to do" is). And the flagship
demand — the schema-guarded edit — **has never been built or measured**; its own honest
edges say so. Its strength is convergence of independent kinds asking for it, which is
genuinely strong and is not the same as proven.

A live dissent worth carrying: are rich paths strictly *necessary* for guarded mutation,
or one targeting mechanism among several? A weaker-but-sooner guard — exact-match
targeting plus post-edit conformance check — might exist, in which case a much simpler
schema kind gets further than the flagship demand assumes.

### 6.2 The Arch-Schema instinct, made checkable

The superset ambition has a dual that is finite and enumerable: **can the canonical form
express what each existing formalism expresses, and project back out with named losses?**
Rows for a first pass — JSON Schema (composition, conditionals, `contentSchema`) ·
Protobuf (field-number identity, reserved discipline, compatibility as a *designed*
property) · CUE (partial values) · **RELAX NG / XSD / Schematron (mixed content and
rule-over-tree assertions — per §1.3 the unmined lineage)** · grammars (error recovery as
a product) · Ash/rowan resources (lifecycle, projections) · Schemacop (a compact
requiredness vocabulary).

Conversion targets split in a way that pushes back on §3: JSON and YAML take a schema
*optionally*; **protobuf, Avro, SQL DDL, GraphQL SDL take it mandatorily** — so
`udon-to-protobuf` cannot exist without emitting a `.proto`. And modalities project
unequally: resource-shaped goes to `.proto` nearly mechanically, constraint-shaped
reasonably, grammar-shaped awkwardly, **example-shaped not at all without inference**. If
schema-required targets are wanted, the cheap modalities can't be the *source*.

**A third direction, from O5.** This map had projection running two ways — outward
(canonical → target artifacts) and inward-absorb (an existing formalism → canonical, the
superset audit above). O5 adds a third that is neither: **inward-demand**, where a
consumer's need *creates* the canonical field. Joseph's DB-stack ideal, verbatim: *"let
the front-end say what it needs to store / recover, and do the right inference for the
local object store, the API, the model object on the server, and the db schema change in
the db — all based on what a privileged coding session running says it needs instead of
essentially writing the same thing in 5 different languages when you're not even sure yet
if you want to keep it."*

Read against §1.0 this is a specific answer to a question I had left as an open option
space — *when is the constraint authored?* The answer: **at the moment of consumer
demand, recorded once, projected everywhere.** It is also §1.0's refinement 2 arriving
from the other side: the adjudicator is precisely the thing that makes the payment
**accumulate** instead of being re-derived by each consumer in its own language. The
five-languages complaint is the projection matrix run consumer-to-canonical, and the
"not even sure yet if you want to keep it" clause is what makes cheap contraction (O4)
a precondition rather than a nicety — demand-driven growth is only safe if retraction is
also cheap. O4 and O5 are two halves of one mechanism.

The caution that must travel with this: if generation is treated as authoritative, the
schema gets pressured to erase what the target cannot represent — and for UDON that
erasure has a name, it is exactly the prose/comment/interleaving tiers of §5.1. *"The
generated model becomes the hidden 'real' language, and authored documents become merely
serialization."* The answer is a per-feature capability matrix naming what each target
loses, and accepting that some schema features are editor-only or documentation-only as
long as the system says so.

**The uncomfortable possible finding:** if the audit shows the spine must be executable to
span the rows, then "obtuse canonical, digestible exposures" is vindicated in a specific
and costly way — the canonical form would not be inert data. Worth knowing before it is
assumed either way.

### 6.3 Probes

1. **Dogfood.** `core/generator/*.descent.udon` — 4,180 lines of UDON with no schema, in
   this repo, defining a *grammar* in UDON. Ask what schema those files would want.
   Declarations like `|type[Element] BRACKET` are already in §3.3's shape.
2. **Tail-of-file.** Write the vivarium corpus's de-facto schema three ways — annotated
   prototype, external constraint artifact, and the procedure `bin/check` already is.
   Measure authoring cost and what each catches. The cheap test of §3.3's premise, with a
   live and willing consumer.
3. **Prose.** Take one prose-heavy document with regions (an ASF segment with its
   `## Working Notes`) and try to state the region rules as a schema — **first in
   Schematron or RELAX NG**, per §1.3, since the point of that redirection is that it may
   already be expressible.
4. **Duality.** Ask a verdict of one computing document both pre- and post-expansion,
   before a fixture pins an answer by accident.
5. **The superset audit** (§6.2).
6. **Hallway testing, borrowed.** The estate ran 20+ naive-agent challenges against a
   schema surface and found agents **converge on inventing the same missing vocabulary**
   independently — a validated instrument for whatever surface UDON proposes. *(Note
   that O6's vivarium episode — an agent with almost no UDON exposure producing a
   conforming dense record from `grep '|decision'` plus one exemplar — is this
   instrument having been run by accident, with a positive result. Worth re-running
   deliberately.)*

7. **The §1.1 falsifier.** Take any schema proposal that wants to shape, coerce,
   default-into, or prune a document and see whether its friction is predicted by
   "non-invasive judge over a lossless model." That is the test that would tell us
   whether §1.1 is a model or a summary.
8. **The extraction probe (O6) — the cheapest and most grounded on this list.** Run a
   de-facto-schema extractor over the live UDON documents on this machine (the vivarium
   corpus, `core/generator/*.descent.udon`, the `design/examples/` corpus, whatever
   CONSUMERS.md registers) and report per element: attributes required-vs-always-present-
   vs-rare, children and their cardinality, ordering tendencies, and convention pickup
   (attributes-first-and-sameline so grep works; `|impact` prose separated from other
   children) — **plus layout** (A.2): one-file-many-records vs file-per-record vs
   file-with-regions, and where region boundaries actually fall, since that is the third
   component of the de-facto schema and the one carrying write-transaction consequences. Three things it tests at once: whether extraction really is near-mechanical
   in UDON (§1.0's vocabulary-vs-statistics claim); whether the extracted schema is
   *recognizable* to the corpus's authors, which is the only real check on
   false-requirement inference; and — by running it twice over time — whether drift
   detection works as the silence-breaker. It needs no schema layer, no ratification, and
   no enrollment, so it can run before anything on this map is decided.

---
---

# Appendices

*Support, evidence detail, archaeology. Cited from the body; skippable.*

## Appendix A — the scaffolding, in detail

### A.1 Job

Guide · accept/refuse · migrate · describe & discover · generate · project · authorize ·
**negotiate responsibility**. The last is least conventional and possibly most relevant
here: a schema can say who owns a concept, what is stable vs experimental, what a local
author may extend, and — when the end-users are automated editors — **what is safe to
automate and what requires a decision**. Testimony framed the stakes as "the most
dangerous thing for an automated editor is not a missing scalar type; it is an invisible
social contract."

Capabilities the demand corpus names, with register — a sampling of what is *cited*, not
the capability universe:

| Capability | Register |
|---|---|
| Schema-guarded edit (validate inside the write, atomic, mutation-free refusal) | *evidenced*; the corpus's only four-kind convergent lock — design intent + the *absence* across all shipped editors + a measured YAML stress test + external MCP fault data |
| Conformance as a machine verdict a gate consumes | *evidenced*; four chapters converge on the shape |
| Verdicts located at a path | *evidenced* |
| No silent retype; duplicates kept in order | *evidenced* — **already discharged by core law** |
| Read-time migration without a flag-day | *evidenced*, **shipped** |
| Tool-definition export (resource → agent-tool JSON) | *evidenced*, **shipped** |
| Two-outcome refusal — `.rejected` (submitter erred) vs `.needs-review` (the system's *own* uncertainty); collapsing them "would mislabel system-uncertainty as user-error" | *evidenced*, **shipped** (relata ingest) |
| Skeleton generation so an agent conforms *without reading the schema* | *evidenced*, **designed-only** |
| Head-line lint over a live corpus | *evidenced* (vivarium) |
| Strictness profiles (casual/careful/critical) orthogonal to schema shape | *evidenced* as an open question, twice stated |
| Three-valued absence — "nothing to say" / "unavailable" / "hidden", which `required: true` collapses | *evidenced* |
| Fragment-local "what's allowed here"; patch/diff validation | **testimony only** — all three substrates, top want, no corpus chapter. Thin support, real demand |
| Nearest-conforming counteroffer; repair confidence (mechanical vs needs-judgment) | *proposed* |
| Schema-aware structural merge | *proposed* |
| Corpus-example discovery ("show me three real instances") | testimony — needs **no formal schema at all** |

### A.2 Scope

Document · **region within a document** · collection · cross-document. Verdict shape:
whole-doc boolean · at a path · fragment · diff/transaction. The region row has the
estate's one worked instance (Appendix B.2), and the report's four requirements for a
cluster-aware schema — declared parts with addresses, per-part rules and admission,
per-part lifecycle, assembly semantics — read as a near-direct sketch of what a UDON
schema must say about regions.

**O6 has a third component beyond vocabulary and statistics: layout.** A document's
de-facto schema also declares *what belongs adjacent in the same file versus what belongs
in a separate but required file for the same record*. Joseph's three live examples are
three different answers, two of them in one repo — verified on this machine 2026-07-28:

| Layout | Live instance | Driver |
|---|---|---|
| **One file, many records** | vivarium `DECISIONS.decision-log.udon` — 124 records in 1,391 lines | append-only + easy grep |
| **File per record** | vivarium `core/src/` — 98 files; also relata entries, ASF terminology | records with independent lifecycles |
| **File with regions** | ASF segments — half canon, half `## Working Notes`, "discarded by the build process by default and… totally different change rules" | one lifecycle, mixed canonicity and authority |

**A selection principle falls out, which this map previously lacked** — A.2 listed the
options with no account of what chooses among them (*proposed*): **co-locate by default;
separate where mutation or authority differs.** Records immutable once written can share
a file cheaply, because there is no mutation to collide; records edited independently
want separate files; a *single* record whose parts have different change rules or
canonicity wants regions. The third case is already ratified in this estate's own prose —
X4 holds that `## Working Notes` is "not bound by the rules that bind body prose" — so
layout-as-schema is not a new idea here, only an unnamed one.

**Why this is not filing convention: the file is the atomicity unit.** The estate's
durability primitive is `safe_write` over a whole file (report §3.1), so file boundaries
are **write-transaction boundaries**, and layout is the decision about what can be written
atomically together and what two agents can edit without collision. That makes layout
inseparable from the guarded edit — the corpus's #1 demand — rather than a presentation
concern. It also puts a visible tension on the one-file-many-records answer: under
`safe_write` semantics two concurrent appenders to `DECISIONS.decision-log.udon` can lose
one of the two writes, and the field report records *four agents* writing to that file in
a single day. I have no evidence a collision occurred — only that the affordance
protecting against it is absent, which is the strength the claim should carry.

### A.3 Horizon

1. **Lexical/syntactic** — deterministic, immediate, should work on incomplete documents.
   *For UDON this is entirely core's already.*
2. **Local structural** — checkable from node or document alone.
3. **Semantic/cross-reference** — needs more context; creates editor friction if treated
   like syntax errors.
4. **Environmental/policy** — the file exists in *this* repo, the version is deployed,
   permission is held. Real constraints, but not intrinsic properties of a document.

### A.4 Authority

Ascription: producer self-description (`_schema: …/2.0.0`, **shipped**) ·
**consumer-side ascription** (Joseph's include sketch — "assuming it is compliant with
*my* schema and version"; Dhall's typed imports are shipped prior art) · ambient
(directory-as-table, filename designator) · none. **This is PRAGMA.**

**On the filename designator (`filename.<namespace>.udon`), re-marked by Joseph as
still-liked but genuinely open from a needs perspective.** Under O6 it reads as *naming
the debt before its shape is known* — a promissory schema name, and his own framing is
exactly that: "I expect this to be converging onto an orderly and transferable schema at
some point soon and even have a name for it; even before knowing what 'it' is." It is
worth noting this is not a placeholder but a working mechanism: in the O6 episode the
agent knew the genre from `.decision-log.udon` before reading a single record, so the
designator did real ascription work with no schema existing to ascribe. A name that
precedes its definition and still functions is how nominal typing bootstraps generally —
which is an argument for the affordance surviving the open question about its form.

Rule strength: *illustrative → recommended → deprecated → required → forbidden* — "a
schema can record confidence and policy strength; not every useful bit of structure
deserves to make a file fail validation." All three testimony substrates arrived at some
version of this and none knew a format supporting it.

World-openness: closed · open · graded. Per §1.1, open is UDON's native posture.

**What a verdict object might carry** (*proposed*, from §4.8 plus testimony): rule
identity · path · what was found · what was expected (a small set) · **which horizon** ·
severity on its own scale (*invalid / incomplete / unresolved / deprecated / discouraged
/ informational / policy-dependent*) · **provenance — which authority said so**, because
if a field is prohibited by a base schema, overridden by a role, and tightened by repo
policy, an inspectable chain is the difference between schema composition and arbitrary
tool behavior · **repair confidence**.

### A.5 Time

Snapshot · versioned · versioned-with-declared-relation. Appendix B.3 has the estate's
shipped/designed split; the implemented-vs-pending distinction is explicitly recorded in
the source — read it before citing any of it.

### A.6 The tactic layer

**Substrate** (UDON itself · external formalism · host code · nothing): testimony's
concern is that an external formalism "cannot faithfully represent 'document as
literature + data' if the host formalism assumes records and arrays only," and that the
external artifact "rots faster than the format itself, because it's maintained by a
different discipline on a different cadence." *(Note §5.1's correction narrows this:
some external formalisms — the document lineage — represent exactly that.)*

**Executability**: the pivot (§3.2).

**Projection** (§6.2): surfaced by Joseph's schemacop pointer. Rowan's resource is a
*source* kind with four shipped targets — agent-tool definitions, JSON Schema, Schemacop
DSL/object, per-store schemas. The report generalizes: "if the schema is the single
source of truth, the agent interface is a projection of it." Documented cost: per-store
**escape hatches** (triggers) "where native constraints can't express the full intent,"
making RDBMS migrations "best-effort projection of the true schema." Projection is lossy
by construction.

**Unit** — document, or *role*? Testimony proposed a **document role / resource kind**: a
named, versioned description of what a document (or region) is trying to be, owning its
shape, description, examples, version, validation profile, template, migration hooks,
extensibility points, and declared authority. Noted because a context-free agent asked
what the unit should be **invented the resource-shaped kind** — the same shape rowan
ported from Ash and the same shape A.2's cluster requirements describe.

## Appendix B — estate evidence

**B.1 Kinds stack.** The autopax ADR system carries three schema kinds simultaneously on
one record type: typed frontmatter (constraint), a prose-stated structural schema
(required `## Preamble` / `## ADR` headings), and convention (banner-flagged deprecation)
— report §11. A single `AgentCard` resource is at once a class-schema and addressed two
ways whose validation paths diverge (§8.5).

**B.2 Convention-as-schema, failing.** `strip_working_notes` recovers a region boundary by
`rindex` over rendered prose, resting on an unenforced "trailing section" convention — "a
segment with a stray `## Working Notes` mid-body… silently truncates the record" (report
§12.4, ll. 2226–2277). The region is invisible to the schema, unaddressable,
unvalidatable separately, its cardinality accidentally fixed at one. And the asymmetry:
**the kept region has a schema; the discarded region does not** — "backwards from a
durability standpoint."

**B.3 Time, precisely.** *Shipped:* `was:` renames, upcast blocks, schema history, differ,
decision log, `evolve` with mutex (ll. 818–831 gives the implemented/pending split).
*Designed-only:* RDBMS expand-contract with triggers, `.archema/transitions/`, `as_of`
temporal queries, agent-annotation syntax. *Contraction:* Expand → Monitor → Contract →
historical awareness forever, and Contract is **store-split** — "RDBMS drops the column
and trigger; YAML and JSONL take no action" (ll. 984–986). "In a document store there is
nothing to contract… The cost of an old address never expires, and neither does its
resolution" (ll. 991–994).

> **Reinterpreted under O4 (§1.0).** The *observation* stands — nobody contracts in the
> document stores surveyed. The *interpretation* does not: the report treats this as the
> nature of document stores, but it contradicts the report's own §0 thesis that a
> directory of documents **is a table**, under which an old attribute across the
> directory's documents simply *is* the column. Contraction is well-defined there and
> merely untooled — a bulk mutation with no transaction and no gate. Read these lines as
> a symptom of missing affordance, not as a structural law, and do not cite them for the
> latter. *Backward translation:* the corpus warns it "silently drops
new-only data," reintroducing "exactly the duplicate-key failure class one layer up."

**B.4 Migration lives in the class.** `upcast from:` blocks composed across
`known_versions`; "storage is never rewritten; the transform happens on the way out"
(§6.2, ll. 861–886). No constraint-language-only schema in the estate has an equivalent.

**B.5 The live wound.** Vivarium field report, 2026-07-28, after a full day of use with no
tooling: "conformance is currently imitation, not validation — every one of us wrote rows
by pattern-matching the tail of the file." Also the counter-position: build the linter
"the day attribute drift first bites someone — not before." *(Caution recorded with the
source: the consumer's stop-gap tooling validates the demand class, not its own shape.)*

## Appendix C — testimony

De-novo, three substrate families (Claude, grok, codex), context-free, 2026-07-28.
Transcripts sit beside this file; the shared prompt is `denovo-prompt.txt`. **One
support-kind** — three substrates raise the testimonial leg, they do not arm a
convergent lock. Codex explicitly declined the first-hand-experience premise and framed
its answer as synthesis of recurring failure modes; preserved rather than smoothed.

**C.1 What all three said independently:** kinds-first is the wrong first cut · validity
is not binary and needs a severity/lifecycle vocabulary · examples are first-class and
will be trusted over the formal schema regardless of what ships · partial and mid-edit
documents are the normal state · schema over prose means genre, outline, roles and
reference integrity, never a grammar of truth.

*Worth noting against C.1's apparent strength:* all three reason from the record-shaped
lineage (§1.3). Their agreement about what is "unsolved" partly reflects a shared blind
spot, not only a shared observation — which is exactly why testimony is one support-kind
and not three.

**C.2 Schema over prose**, six meanings: genre/document-type · structural outline
constraints · embedded data islands · inline structured phrases · semantic roles ·
machine-checkable claims (IDs, cross-references).

**C.3 One outward convergence:** grok independently re-derived UDON's already-ruled
`Dialects ≠ Schemas` boundary — "schema may **constrain** a syntactic type but must not
**reinterpret** it… `format: date-time` as a semantic hijack."

## Appendix D — Ash, current state (checked 2026-07-28)

Checks the resource-shaped row against the living ancestor rather than rowan's snapshot.
Ash is at 3.31.0, steady incremental 3.x, no rewrite.

- **Projection is now a named API.** `Ash.Info.manifest` (v3.25.0, 2026-05-17) is an
  explicit filterable introspection surface whose stated purpose is to be a basis other
  code generators consume — the mechanism §6.2 depends on.
- **The estate's migration claim holds, with a footnote.** No built-in read-time
  upcasting; nothing like rowan's declared-rename ledger. AshPostgres' generator detects a
  plausible rename and *asks you* — a generation-time heuristic prompt, not a durable
  lineage consulted later. `AshEvents` carries real event versioning but for the event log
  only, opt-in and separate.
- **The lossy boundary, named from outside.** Derivation's value "specifically depends on
  staying inside Ash's own data layer"; a manual/non-Ecto data layer "removes much of
  Ash's 'derive the rest' automation." And Ash "doesn't automatically extract or organize
  existing logic" — *it organizes, it does not excavate*. Uncomfortable for a notation
  whose documents live in other people's repos.
- **The declarative surface is still annexing** — policies now reach into aggregates and
  composite types; a pipelines DSL composes action logic. No visible ceiling on how much
  of "what the resource means" the schema absorbs.
- **Unanticipated:** Ash's highest-velocity 2026 work is making resources legible to AI
  agents. `AshAi` ships prompt-backed actions where **an action's declared return type
  becomes the JSON schema constraining an LLM's structured output**, plus resource-derived
  tool-calling at the domain level and MCP servers. `usage_rules` is a cross-package
  convention for shipping machine-readable "what an agent should know to use this
  correctly," synced into the consuming project's `AGENTS.md`/`CLAUDE.md`. Both are
  declarations projecting **agent-facing artifacts** as first-class outputs.

*Gaps:* no documented account of where AshGraphql/AshJsonApi generation gets lossy for
specific type shapes (union/polymorphic is a lead inferred from a bugfix entry, not a
finding), and no worked example of Spark DSL state exported to a **non-Ash** formalism.
The second matters most to §6.2.

## Appendix E — prior art, and carve-out detail

**The document-schema lineage (§1.3 — the unmined one):** RELAX NG (compact syntax,
interleave, mixed content) · XSD mixed content and `xs:any processContents` ·
**Schematron** (rule-over-tree assertions in XPath, co-occurrence constraints, and
human-authored error messages — arguably the closest existing thing to "hard constraint
and soft lint in one artifact") · DTD content models · TEI / DocBook / JATS as worked
document-genre schemas. None of this is cited anywhere in the estate's schema material or
the demand corpus.

**The record-shaped lineage (well-covered here already):** Schemacop (Joseph's named
inspiration, shipped as a rowan export target — mine the vocabulary, not the host
language) · CUE (partial-value unification; ancestor of §3.3) · JSON Schema (including
`contentMediaType`/`contentSchema`, §5.1; and its `oneOf` error problem as a *negative*
result — nobody has solved explaining a disjunction failure) · Protobuf (mine the
compatibility discipline, not the message model) · Dhall (typed, hash-pinnable imports —
consumer-side ascription, shipped) · Ash and rowan (Appendix D) · rowan's `was:`/upcast
machinery (read the implemented/pending split first) · relata's ingest membrane (the
two-outcome refusal) · autopax ADR-010's markdown structure DSL and
`schema.generate_example()` (blocked and unbuilt) · tree-sitter (not as schema — §4.1
forecloses that lane — but for **error recovery as a normative product**, and for
**language injection** as the delegation precedent in §5.1) · Helm `values.schema.json`
and Terraform variable types (schemas over template inputs, §5.2) ·
`core/generator/*.descent.udon` (Probe 1).

**Named unread:** `~/src/rowan/docs/msc/plan-recursive-embedded-schemas.md` and
`exploration-graph-resource-unification.md` — flagged by the doc-store report's own author
as its two highest-value unread documents, both plausibly bearing on nested/recursive
schema. Nobody has checked them, including this seed.

**Carve-outs, detail.** **PRAGMA** — the authority axis; a schema design will force it,
but it is open because the binding surface depends on schema and dialect pictures that
don't exist, so the dependency runs both ways. **PATHS** — schema addressing *is* paths.
**DIALECT-DEF** — §4.2's boundary is only enforceable once "what a dialect is" exists.
**ANNOT** — annotation vocabulary is already called schema-owned (CORE §12.5). **MIXIN** —
a host experiment; building on mixin semantics would promote an experiment to law by the
back door. **ML** — if `[…]`/strings turn out to be sugar for dialect-typed captures, the
schema's value-constraint vocabulary is shaped by the capture mechanism. **IND/IND-2** —
skeleton generation needs an indentation unit immediately.

---

## Working Notes

*(Unconstrained side-car per DECISIONS X4 — open work and routing, not a log.)*

- **O6 folded in:** §1.0 gains the authoring-payment-at-birth completion and the
  vocabulary-vs-statistics sharpening; §3.1's convention row demoted from peer-modality
  to *the floor* (the other five redeem it); the extractor's structural limit named
  (observation yields vocabulary, never closure — which pairs with the §1.1 correction,
  since intent supplies closure and closure is cheap here); drift-detection named as the
  actual silence-breaker; probe 8 added. **Where I pushed back:** the extractor observes
  documents, not readers, so it extends the governed region's write-side reach and not
  its read-side reach — contraction in a wild corpus stays a judgment call. The estate
  hit the same wall (its monitor tracks writes only) and accepted it, which is precedent
  rather than proof.
- **The O6 specimen is now filed and verified.** `specimen-vivarium-decision-2026-07-28.md`
  is **byte-identical** to the record in `~/src/arch/vivarium/DECISIONS.decision-log.udon`
  (checked, not assumed — a transcription defect had been flagged and fixed upstream). It
  supports the vocabulary-vs-statistics claim well: the conventions it picks up are
  exactly the *statistical* kind — sameline attribute order, identity-as-full-sentence-
  slug, `|impact` as one dense block, `|ref` as a `·`-separated list ending in a
  `DECISIONS[slug]` cross-reference — over a vocabulary that was never guessed because the
  markers declare it.
- **Citation-class correction (2026-07-28, last pass).** Earlier drafts cited O1–O7 as
  "steward marks" in the decisions ledger. They are Joseph's pre-validation brainstorms
  and now live at `../../primary/DISCUSSION-THOUGHTS.udon` with per-item status. I did
  a pass over every O-citation asking the §4 question of my own cites — *does my material
  warrant this, or am I leaning on who said it?* Result: **O1, O4, O6, O7 are
  independently warranted here** (three corpus payment-instances predating O1; the
  directory-is-a-table contradiction; the field report plus the verified specimen; two
  shipped embryos), so those now lead with the evidence and treat the brainstorm as its
  seed. **O5 is genuinely split** — its *necessity* half is argued by the
  contraction-conjunction derivation, its *acceptability* half is unvalidated preference,
  and they should not travel together. **O2 and O3 supply usable tests** anyone can run
  independently of who proposed them. The O4→O7→O2→O5 composition is now marked as the
  weakest-supported thing in the document, because a chain is only as warranted as its
  links.
- **Worth recording as the night's own lesson landing twice:** the ledger's *form*
  laundered a brainstorm into law, and the brainstorm it laundered most consequentially
  was O3 — whose content is precisely that unreasoned records shouldn't carry authority.
  I reproduced the failure by citing it, which is a reminder that register discipline
  fails at the point of *transcription*, not at the point of reasoning.
- **O7 folded in, and it caught a second inference error of mine.** §3.2's judgment tier
  said "permanent," sliding from *per-item cost is irreducible* (true) to *the migration
  can't be completed* (non sequitur). That is the same error shape as the open-world one
  two rounds ago — reasoning correctly about a mechanism's limit and then over-extending
  to a conclusion the limit doesn't license. Two instances now; worth watching for as a
  pattern in my own output rather than treating each as a one-off. The composition of
  O4→O7→O2→O5 into a single mechanism is mine and is the part most in need of checking.
- **The anti-gaming clause is the non-obvious requirement** on any census: this repo's
  compliance gate already carries it ("never by editing fixture expectations toward
  parser output"), and a burn-down count creates exactly that pressure — reach zero by
  reclassifying rather than adjudicating. Whoever builds O7 should port the clause, not
  just the counter.
- **The layout observation is folded in** (A.2, and the Scope×Time note in §2). Two of
  Joseph's three layout answers were verifiable in one repo, so the table carries live
  instances rather than types. **Two things there are mine and want checking:** the
  selection principle (co-locate by default; separate where mutation or authority
  differs) and the claim that layout is a *write-transaction* decision because
  `safe_write` makes the file the atomicity unit — which, if right, means the
  one-file-many-records answer has a concurrent-append exposure that the vivarium corpus
  is currently running on (four agents, one file, one day; no evidence of harm, no
  affordance against it either).
- **O4/O5 landed after the O1 pass** and are folded in: §1.0's accumulation problem now
  has its discharge route (affordable contraction), plus the observability boundary and
  the governed/wild two-regime consequence, both mine; §3.2's up/down row re-derived
  along mechanical/lossy/judgment, with the judgment tier surviving as the honest
  residue of the old "mirage" claim; B.3 carries a reinterpretation banner; §4 gained the
  `was:`-has-no-owner boundary finding; §6.2 gained inward-demand as a third projection
  direction. **The argument I'd most want checked** is that "nothing to contract"
  contradicts the report's own directory-is-a-table thesis — if that holds, O4 is
  established more strongly than by the affordability claim alone, and one line of the
  estate's schema material is simply wrong rather than merely dated.
- **A correction I got wrong and have kept visible** (§1.1): "open-world is the native
  posture" conflated enforcement-by-removal with expressing closure. Caught in review,
  not by me. Fixing it produced a better finding than the error concealed — closure is
  unusually *cheap* under a non-invasive judge — which is an argument for keeping
  corrections in place rather than silently patching them.
- **O1/O2/O3 landed after drafting** and are folded in: §1.0 is new and sits above the
  rest of the map; §4.7 is repriced under O3 with a reasoned-vs-convenient sort of the
  whole table; §5.1 gained the document-as-a-whole row (root-silence meets schema);
  §3.1 gained the when-do-you-pay reading. The three refinements in §1.0 and the
  monotonic-accumulation problem are mine and are where I'd most want pushback.
- **On O2 applied to this directory:** `pass-1-explication.md` assessed as safely
  deletable (assessment recorded in its own banner). Retained only because it was
  explicitly asked for. My recommendation is to delete it after comparison — by O2's
  own tension it is currently on the noise side, not the don't-rederive side.
- **Three revisions on 2026-07-28**, all from Joseph's reads, all corrections I think
  were right: (1) conclusions to the front and ~⅔ demoted to appendices; (2) superlatives
  and authoritative register stripped — twelve instances of "sharpest/strongest/most
  X" removed, because conclusive language at an explication stage decreases confidence
  rather than earning it; (3) the §5.1 tier table rebuilt with per-row reasoning after
  he challenged the `!:sql:` cell. That third one changed three answers and produced
  §1.3, which is the only genuinely new thing this pass found — worth noting that it came
  from a challenge to an over-assertion, not from my own reasoning.
- **On the stage question directly:** §1 now separates the one candidate for an intrinsic
  model (§1.1) from the scaffolding (§1.2). I'd rather be told the candidate is also just
  a summary than have it pass unchallenged. Probe 7 is the falsifier I'd run against it.
- **§1.1's honest weakness:** it is assembled from four constraints that were decided
  separately. It is possible the coherence I'm seeing is the ordinary coherence of one
  author's taste across four decisions (the estate has a standing caution about exactly
  this — agreement within a single-author corpus is coherence, not corroboration). I
  don't know how to distinguish those from inside, which is itself worth saying.
- **What I kept in the body against the demotion instinct:** fragment-local and
  patch-validation capabilities (A.1) rest on testimony alone with no corpus chapter, but
  they're the top want of every substrate asked — kept visible with the thinness named
  rather than buried. Same for the five meanings of "has type X": testimony-sourced, but
  vocabulary the rest of the document uses.
- **C.1's shared blind spot** is now flagged in the appendix: three substrates agreeing
  about what's unsolved partly reflects all three reasoning from the record lineage. That
  weakens a convergence I had previously presented at face value.
- **§3.3 vs §4.5's internal collision:** CORE §5.4 offers `?` as both schema-optional and
  grammar-0-or-1 in one sentence. Four characters oversubscribed before anyone spends
  them.
- **The `doc`-schema collision (§5.3) is unrouted.**
- **A structure I didn't adopt but might be right:** the demand corpus organizes this
  territory as a **dependency-ordered question list**, each branch naming what it
  forecloses. If a next artifact is wanted, that ordering is my recommendation —
  `priorities-and-spike-agenda.md`'s schema-probe section is its seed.
- **Not chased:** the two named-unread rowan documents; ASF terminology §12.1; the
  `_schema` vs `_schema_version` adapter inconsistency; and now the whole document-schema
  lineage of §1.3, which deserves a real pass rather than the paragraph it gets here.
- **Unanswered and not papered over:** whether the schema document is itself a UDON
  document governed by a schema.

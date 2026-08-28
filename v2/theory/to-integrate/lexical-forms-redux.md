# Lexical forms redux — material, deferral, and stance (2026-08-27)

**Register: pre-validation proposal** (DISCUSSION-THOUGHTS discipline — incomplete by design; nothing ruled). Vocabulary is the addressing theory's (`../../references/def/`) — reference, referent, intended-cardinality, resolve, dereference, binding, match, scope, origin, resolution, mediated step — used, never restated. **This file ignores the current surface syntax entirely**; mapping today's syntax onto this frame is later, separate work. *(Supersedes three same-day drafts; git holds them.)*

---

## 1. Two kinds of item, one composition rule, one annotation mechanism

**The composition rule.** A document is items in ordered contexts: every interior — an element's content, an edge's content, a run of prose — is an ordered sequence of items, of any kind. Prose is not a separate world: it is such a sequence in textual clothing, mostly text runs with other items interleaved. There is no second composition mechanism anywhere.

**The kinds.** Every item is one of:

- **Material** — determined at writing, present where it sits: a *thing* (node: "here is a thing"), a *fact* (edge: "here is a fact about the thing"), or *text* (an opaque run of prose).
- **Deferred** — recorded material whose determination happens at use, not at writing. The genus name is def-reference's own: "This allows deferral. Determination is deferred and the world may change in the meantime; that gap is constitutive, not incidental." Two species:
  - a **reference** — a proxy for its referents (def-reference, whole and unmodified); determination is resolution;
  - a **generator** — produces material that does not exist yet; determination is evaluation. Not a reference: it operates **on** referents without standing for any. Joseph's ratifying formulation: *"Directives are deferred generators of the atomic parts, often using resolved referents as their primary prerequisite"* (2026-08-27) — the atomic parts being the material kinds, and "often" doing the same honest work it does in def-reference.

*("Proxy" belongs to the reference alone, as def-reference uses it; this note's earlier drafts stole it for the genus, which both diluted it and threatened to re-define reference in its own definiens's terms. A candidate third species — **construed**: a span whose value its own content determines under a named vocabulary, as with typed literals — may be real or may reduce to reference-into-a-vocabulary; deliberately unresolved, and the least load-bearing.)*

**Annotation.** Any item — material or deferred — can *have an annotation*: uninterpreted material addressed to the document's maintainers instead of the document's consumer. An annotation is a saying with a different recipient — the same opacity as text, aimed at the maintainer — attachable to any item or standing in a content position. Its interior is carried, never interpreted: an annotation "containing structure" contains the *spelling* of structure, which is exactly what makes annotations safe. It contributes nothing to the document's own assertion.

That is the whole ontology. Everything the current language spells as seven unrelated constructs is deferred material; everything hard about pipelines and templates is about *when each deferred item is used, and how*.

## 2. What varies about a deferred item

**2.1 Its species** — reference or generator (§1): whether determination consults the world or produces into it. Duals: the reference pulls what exists; the generator makes what doesn't, usually from pulled inputs.

**2.2 Its stance** — what a given *use* of it does. Def-reference already carries the vocabulary: the artifact is *written* once and may be *used* multiple times, at different times, and the events are plain verbs — a reference is written, then resolved or dereferenced. A use either:

- **holds** — no event; the deferred item itself is the material at hand, traveling onward as an artifact;
- **determines** — resolves or dereferences a reference; evaluates a generator (*evaluate* is this note's one verb past def/'s pair) — always from an origin, as of a moment ("an 'untimed' answer is either a fiction or an unstated claim that the world has held still").

The deferred item carries neither origin nor moment; **each use supplies its own.** The same item, used from two origins or at two moments, legitimately yields different material. What it *may* carry, because the writer declared it, is its posture toward origins: written origin-relative, it is *meant* to be re-aimed by whoever uses it; written origin-agnostic (a universal origin — the absolute path), it reaches the same referent from anywhere. Origin-sensitivity is the writer's recorded intent; the origin itself is the use's.

And the writing-to-use gap need not be long or even cross a document boundary to be constitutive: a node defined once and referenced seven times below it for DRY convenience is seven uses, each a distinct determination — which is exactly what makes the DRY safe (edit the node once; every use re-determines).

**2.3 For references only:** connection mechanism (binding vs match — kind follows maintenance, never spelling) and intended-cardinality. Composite references mix mechanisms: a path is bindings walked, a filter a match run partway along.

## 3. Hold is the load-bearing stance

Determining — resolving, dereferencing, evaluating — is what everyone designs for. **Hold is the neglected stance, and it is where the hard problems have been living.**

A held deferred item is data: storable, copyable, embeddable in generated material, bindable as a value, used later — elsewhere, by someone else, against a world that has moved. Everything commonly filed under "quoting," "escaping," "raw," "inert," and "template-writing-templates" is the hold stance appearing at some level and getting a bespoke local fix: a character held back from the recognizer; bytes held for a later vocabulary; a reference kept as a value instead of reached through; a generator kept as material instead of run — the last being the whole of templating a template.

One operator, one definition: **keep this item in deferred form; hand the artifact onward.** A use un-holds by exactly one level when it determines. Hold-depth = number of uses the artifact passes through held.

Open, stated rather than settled: whether hold composes without bound or saturates; whether hold-depth and origin-passage are one number or merely correlated.

## 4. Misses, cardinality, and the shape of failure

Intended-cardinality — a {min,max} range declared at writing, belonging to the reference and not to whatever later processes it — is what gives a miss its meaning, with no new machinery. Per def-reference's own examples: zero against {1,1} — the writer's model of the world is currently wrong; three against {1,1} — the reference narrowed insufficiently; zero against {0,N} — simply the current answer. The count-against-range comparison supplies a *meaning* for every outcome, including ones outside those examples (one against {2,5} is as classifiable as any); what response any meaning warrants — loud, quiet, deferred — belongs to the processor, never to the reference.

The connection mechanisms fail in complementary ways — a binding through its maintenance (dangle, collide), a match through the world's motion — and both failure modes are properties of the reference relation, not of any pipeline processing it. A document system that keeps everything gets its resolution-miss semantics free from this layer: no miss requires dropping material, every miss arrives already meaning something, and severity policy stays where it always was — with the consumer.

## 5. Pipelines are stance schedules

A processing pipeline — directories of source material becoming a queryable logical store — is nothing but a **schedule of uses**: which deferred items get determined at which stage, from which origin, as of which moment — and which are held past that stage. Consequences, each dissolving a question that looks hard when asked globally:

- **"Early or late evaluation?" is not a pipeline property** — it is per-item stance. "Uncooked" is a property of an item, not of a stage.
- **"Outer vs inner" template material is one mechanism at two origins**: material written to be determined *here* vs *later, from there* differs only in hold-depth and intended origin. No second parser, no second construct family.
- **A store may hold deferred items at rest.** Referents are never pipeline material — they are resolution *results*, each justified by its resolution-path. A store keeping held references (with their intended-cardinality) and resolving per-query is choosing a later as-of moment — the honest default, since the world moves between writing and use.
- **Inclusion loops are mediated steps**, with their termination discipline already stated in def-resolution: a mediated step's sub-resolution may not use the step it enables.

## 6. The surface this predicts

Stated as a budget, not as spellings. A surface adequate to this frame needs:

1. Its **material marks** — a thing-mark, a fact-mark, bare prose — plus the one composition rule everywhere (so prose-with-items-inside is the rule working, not an exception needing syntax).
2. **One deferred family**, whose head says the species (a path → reference; a generator name → generator; a vocabulary tag → construed, if that species survives). Not seven construct families — the species cells at each position are spellings *derived* from one scheme, or the old enumeration is back.
3. **One hold mark**, working uniformly at every level — character, span, reference, generator. If quoting needs a different device per level, the surface has failed this frame.
4. **One annotation mark** — attachable to any item or standing in a content position, its interior opaque by definition (no second grammar inside it).
5. **No spelling that fixes origin or moment** — those belong to uses and schedules (§5); syntax that hard-codes "determines now, from here" smuggles a stance decision into the grammar. What the surface *does* carry is the writer's declared origin-posture (relative vs universal-origin), since that is part of the reference itself.
6. **Miss meaning from declared cardinality**, not per-construct error rules — the surface carries the {min,max}; response policy stays with consumers.

Count it: two material sigils, prose, one deferred family, one hold mark, one annotation mark. Whether the current surface can be read as an approximation of this — and what each divergence costs, frequency-weighted — is exactly the later work this file does not do.

## 7. Provenance

2026-08-27 session: whole first-hand read of the 0.10.0-alpha.1 spec suite, both lexical-forms records ([[lexical-forms-discussion-2026-08]], [[lexical-forms-matrix-2026-08-11]]), and all six `references/def/` entries. Joseph's contributions carried here: the reference-held-as-value articulation (seed of §3's hold); the pipeline-sketch discussion (`../../notebook-sketch-pipeline.md`) behind §5; "references … ARE the only thing we need to have everywhere" behind §1's reference species; the cardinality-of-purpose correction ("often", not definitionally-absent); the three §1-correcting objections (annotation; generators operate on referents but are not references; prose carries structure within it); the annotation correction (attached uninterpreted material addressed to the maintainer — not a channel bit re-addressing live items, which would put resolving references inside annotations that exist to be inert); the use/site correction (def/'s own written-once-used-many vocabulary replacing this note's coined "site"/"act"); and the proxy reconciliation (proxy is reference's definiens in def-reference and is not the genus — the genus is *deferral*, def-reference's own invariant word, with reference and generator as species). The def/ layer is the vocabulary authority; where this note reaches past it (generators; hold; stance schedules), the reach is flagged and the def/ layer owes nothing to it — though a future def-generator entry beside def-reference, under the shared deferral genus, is the natural landing if the species split holds.

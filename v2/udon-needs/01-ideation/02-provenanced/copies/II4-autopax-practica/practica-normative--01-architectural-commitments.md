---
source: 01-architectural-commitments.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/practica/docs/02-normative/01-architectural-commitments.md
source_commit: 938fb79ed9bd58b34374eb1122d86bb95fd817e8
categories: [normative, architectural-commitments, coordination-substrate]
why_included: >
  Composed May 20 2026. Cluster 01 of six: tiered normative claims for how an agent-coordination substrate should be architected.
---

# Cluster 01 — Architectural commitments

How the system must be structured. The claims in this cluster shape decisions about what the data model contains, what type-signed boundaries exist between subsystems, and which structural commitments must be made at initial implementation rather than deferred to later migration.

The claims rest on (a) paper 1's convergence on Practica's structural identity ([[../../msc/practica-structural-identity]]); (b) paper 2's convergence on intent and action as different content layers ([[../../msc/practica-intent-action-layers]]); and (c) operata's pre-theory engineering precedent for the data-model decomposition. The cross-cutting frame from [[../02-normative]] (durable layer as *agency-granting conditions*) is the structural backdrop these commitments serve.

---

## A1 — Plumbing/intelligence split is the architectural form

**Practica should be architected as a deterministic *plumbing layer* (state tracking, scheduling, format enforcement, persistence, structural-invariant enforcement) separable from an *intelligence layer* (where LLM sub-agent judgment operates). Both layers are first-class; neither is hidden inside the other.**

Why this is forced: a coordination system whose components are Class 3 (Coupled) substrates — agents whose belief-update and goal-conditioning are entangled in a single forward pass — cannot recover the directed-separation guarantees of a Class 1 system at the component level. The structural separation must live *above* the component layer, at the system level. The plumbing layer is what does this structurally: it imposes type-signed commitments the intelligence layer cannot self-enforce. Paper 1 establishes this through three independent identifications — AAT's wrapping construction (formal); a family of LLM-agent engineering patterns including Anthropic's TodoWrite, Kim et al.'s LLMCompiler, and operata's explicit naming of the principle; and Bungay's *"art-not-science"* framing applied at the architectural level.[^a1-source]

What this does not specify: which language; which storage substrate; specific schema choices; how rich the intelligence layer can be. The commitment is to the *separation* and to the *type-signed enforcement* at the boundary. Implementation has degrees of freedom.

*Tier:* Convergent — paper 1's three-tradition convergence. AAT side at discussion-grade synthesis; engineering side *convicted-of-shape* via three independent instances; honest scoping in paper 1 §7 carries forward. Cross-references: A2 (below) is the content-layer separation that operates *on* the plumbing/intelligence split; A4 (below) is a structural invariant the plumbing layer enforces; F1 in [[05-failure-mode-defaults]] requires the plumbing layer to remain recoverable when the intelligence layer is unavailable.

[^a1-source]: [[../../msc/practica-structural-identity]] §3–§6 — the structural identification, the engineering convergence, and the four shared commitments (S1)–(S4) the convergence reduces to. The AAT-formal home segments cited there include `~/src/agentic-systems/01-aat-core/src/der-class-coercion-via-wrapping.md` (the wrapping construction, derived under (C1)–(C3) admissibility) and `~/src/agentic-systems/01-aat-core/src/der-class-coercion-in-composition.md` (the composition-level result: the wrapped system is a valid AAT composite agent inheriting persistence-template at the wrapper level). Operata's explicit naming is at `~/src/operata/docs/exp/2025-11-26-operata-system.md` §"LLM agent patterns reveal the plumbing/intelligence split": *"This separates 'what to do' (agent intelligence) from 'when to do it' (CLI/scheduler determinism)."*

---

## A2 — Intent and Realization are type-separated resources

**The plumbing layer's data model holds *Intent* and *Realization* as structurally distinct resources, with type signatures that prevent intent from carrying execution-trace content and prevent realization from carrying goal content.**

Why this is forced: the alignment-autonomy 2×2 (paper 2) identifies *intent* (the what and why, binding across actors, aligned, persistent) and *action* (the what and how, free per actor, derived from current state, transient) as structurally different *kinds of content*, not endpoints of a single trade-off. A data model that holds both in the same resource type forces actors to read both together and prevents stable alignment on the intent layer alone. Operata's *Cognitive Modes* working note records the friction this collapse creates empirically; the friction is structural rather than cosmetic. Paper 2's convergence — across military-doctrine (Moltke 1869's *Befehl* / *Direktive* distinction), AAT formalism (`der-action-selection`: $a_t = \pi(M_t, G_t)$, derived each cycle, not stored), and operata engineering — is the substantive backing.[^a2-source]

What this does not specify: the resource schema beyond the type-separation commitment; the storage representation; the specific UX affordances around each resource. Operata's worked Intent/Realization schema (see A6 below) is one instantiation among possible decompositions.

*Tier:* Convergent — paper 2's three-tradition convergence. AAT side at *exact within scope* for the foundational claim (`der-action-selection`). The engineering-side instance (operata) is *convicted of the shape* at 30/30 BDD-green at abandonment. Cross-references: A5 (below) is the deeper structural commitment that prevents action from being stored; D1 in [[03-content-discipline]] is the UX discipline that operates on the Intent type; C3 in [[02-coordination-affordances]] is the protocol that re-animates inherited Intent.

[^a2-source]: [[../../msc/practica-intent-action-layers]] §3–§5 — three independent identifications of the structural cut. AAT side: `~/src/agentic-systems/01-aat-core/src/der-action-selection.md` ($a_t = \pi(M_t, G_t)$; status *derived*, *exact* within Section I scope; *"Action is a function of the agent's complete internal state … under Section I scope … this gives: $a_t = \pi(M_t)$ … When the internal state lifts to $X_t = (M_t, G_t)$ for purposeful agents, the same structural argument gives $a_t = \pi(M_t, G_t)$"*). Engineering side: `~/src/operata/docs/glossary.md` — *"Intent: A desired state or outcome; the core unit of Operata. Unlike traditional 'tasks' which describe actions, intents describe states we want to achieve. … Realization: What actually happened when working on an intent. Captures the gap between expectation and reality."*

---

## A3 — LOCUS-vs-Personal is a first-class architectural axis

**Project-scoped (LOCUS) coordination and individual-scope (Personal) focus are *independent systems with a sync layer*, not a shared database with role-based filtering.**

Why this is forced: operata's F1 finding was reached after living the alternative (the *"two views of one database"* framing) and recording the ambiguities it produced — in Perspective semantics, in Effort ownership, in storage-model assumptions. The conflation produced specific downstream failures that the F1 reframing names. Operata's own voice: *"Previous sessions conflated these as 'two views of one database' when they're actually two independent systems that sync."* The architectural commitment is that the two systems are *different kinds of objects* with their own data models, lifecycles, and storage substrates, and that synchronization between them is a deliberate boundary operation rather than a default lookup.

This also maps onto an AAT-side architectural distinction. LOCUS-practica is the *composite agent system* (multiple actors coordinating through shared state). Personal-practica is the *single-agent strategy substrate* (one actor, their own intent and effort and focus). These are different AAT objects — different architecture-class plus different construction requirement — so different architectural objects at the engineering level is structurally consistent.[^a3-source]

What this does not specify: the sync-layer protocol; whether Personal-practica is hosted with LOCUS-practica or separately; the conflict-resolution policy when both systems carry related state; the role-based reflection mechanism. The commitment is to the *axis* being first-class at the architecture level.

*Tier:* Engineering-grounded — operata F1 verbatim, named pre-AAT through engineering necessity — with AAT-architectural correspondence at the LOCUS-vs-Personal-substrate distinction. The four-perspective discipline from [[../../msc/03-perspectives]] is relevant here: the same architectural choice may be reasoned about under any of four registers (theory-general, build-process, external-user, product-aspirational), and the axis cuts across all four. Cross-references: A6 (below; the resource model lives on whichever side of this axis it belongs to); L3 in [[06-limits-and-positioning]] (Personal-practica's value depends on individual tolerance for self-direction, not just team culture).

[^a3-source]: `~/src/operata/TODO.md` §"Scope & Dual Nature": *"Operata serves two distinct but related purposes that will likely be **independent systems with a sync layer**, not a shared database. … Previous sessions conflated these as 'two views of one database' when they're actually two independent systems that sync. This explains ambiguity in: Perspective …; Effort ownership (`owner_id` vs `locus_id`); Storage model."* The full LOCUS taxonomy in operata's TODO (CARTA, STATIO, ACTUS, OPERATA, VERA, PRAXES, LEXICON, INSTRUMENTA, PERCEPTA, SIGNA) treats Practica/OPERATA as one face of a broader LOCUS-level structure; Practica inherits this architectural framing.

---

## A4 — DAG-with-cycle-detection from day one

**Effort dependencies are represented as a directed-acyclic-graph with explicit cycle-detection enforced in the plumbing layer from initial implementation. Tree-with-planned-migration-to-DAG is forbidden by structural commitment, not by stylistic preference.**

Why this is forced: two structural facts (paper 1 §6.3 traces them carefully). First, non-trivial coordination domains often have cross-cutting structure — efforts relate to multiple parent efforts simultaneously, and a tree-shaped model cannot represent this. Second, tree-to-DAG is a *structural* migration, not a parametric one — it changes the data-model class, breaks existing queries, requires schema migration. Structural migrations of deployed systems are exactly where engineering momentum dies; operata is the engineering precedent for this failure mode (the migration was *recognized* and *unshipped*). The combination forces the cost upfront: pay it when there is no deployed state to migrate, rather than pay the deferred cost of migrating once deployed state exists.

The cycle-detection requirement is similarly forced. A DAG without cycle-detection is a directed graph; the structural commitment to acyclicity is what makes the model class a DAG rather than a DG. The intelligence layer can construct cycles inadvertently — an intent supporting a parent that supports it indirectly — and the structural invariant must be enforced at the plumbing-layer level because the intelligence layer cannot reliably self-enforce. AAT's `def-strategy-dag` (acyclicity proved via directed temporal order over finite horizon; Markov factorization under causal sufficiency) is the theorem-forced backing.[^a4-source]

What this does not specify: the DAG representation (adjacency list, join table, edge collection, graph database); the cycle-detection algorithm (DFS with coloring, topological sort, incremental SCC tracking); the user-facing affordances for cross-cutting links (typed edges, weighted links, free-form annotations); whether a *primary parent* relation is retained for tree-display purposes. The commitment is to DAG-with-cycle-detection in the plumbing layer at day one.

*Tier:* Convergent — engineering-precedent of failure (operata) + AAT theorem-forced uniqueness of DAG structure (`def-strategy-dag` + `deriv-graph-structure-uniqueness`). Cross-references: A1 (above; the plumbing layer is where cycle-detection lives); F6 in [[05-failure-mode-defaults]] (deep chains in a valid DAG are still structurally fragile and the system must warn).

[^a4-source]: [[../../msc/practica-structural-identity]] §6.3 — the supersession trace for E5. Engineering precedent: `~/src/operata/TODO.md` §"Intent Graph: Tree → DAG Migration" — the proposed `IntentEdge` join table with cycle-detection, *"Prerequisite: Archema M:M conventions … Before migrating Intent to a graph, investigate and solidify Archema's support …"* (recognized, planned, unshipped). AAT-side: `~/src/agentic-systems/01-aat-core/src/def-strategy-dag.md` and `~/src/agentic-systems/01-aat-core/src/deriv-graph-structure-uniqueness.md` — acyclicity proved (directed temporal order over finite horizon); Markov factorization proved under causal sufficiency via the Causal Markov Condition theorem.

---

## A5 — State-not-action spine

**The plumbing layer does not hold an *"action queue"* / *"task list"* / *"session log"* as a separate first-class resource alongside Intent. Actions are derived from state at each cycle by the local actor, not stored as durable artifacts.**

Why this is forced: AAT's `der-action-selection` derives this at *exact within scope* tier: action is a function of the agent's complete internal state, derived each cycle, never stored. The state is the durable object; the action is the cyclical instantiation of the policy at the current state. A stored action queue would be either redundant (recoverable from state) or stale (representing an action the current state would not generate). Operata's *Cognitive Modes* working note recorded the engineering friction: trying to hold execution-mode content (*"what will I do next, in what order?"*) in the intent graph created friction the engineering reached for a *"Session"* resource to resolve — unresolved at abandonment. The friction is structural; the resolution AAT prescribes is *no stored action layer*.[^a5-source]

This is the commitment most prone to violation in practice. The intuition to add a stored task list, pinned actions, or session-record-as-action-source is strong; many existing tools enshrine it. Resist. Where execution-ordering is needed, it is derived from state at the moment of execution (e.g., a *ready* computed state on intents — see operata's *ready* and *blocked* views).

What this does not specify: how *ready*-ness is computed; whether per-actor execution traces (Realizations) are append-only or revisable; how the plumbing layer presents *what to do next* without storing it. The commitment is to the absence of a stored action layer alongside Intent.

*Tier:* Convergent — AAT-exact (`der-action-selection`) + engineering-friction-witness (operata Cognitive Modes). The convergence is sharp because the AAT side derives the structural fact and the engineering side empirically hit the friction trying to violate it. Cross-references: A2 (above; Realization is *not* the stored action layer — it is the after-the-fact execution trace); D1 in [[03-content-discipline]] (intent specification leaves execution-derivation to the local actor); C3 in [[02-coordination-affordances]] (the backbrief is how the successor declares what they will derive from state in service of intent).

[^a5-source]: `~/src/agentic-systems/01-aat-core/src/der-action-selection.md` — status *derived*, *exact*, *deps-verified* stage. *"This is not imposed on the system but follows from #form-agent-model: $M_t$ is defined as the agent's compressed, complete internal record, and action depends on what the agent retains — i.e., on $M_t$. Any deterministic or stochastic dependence of action on history *through* the model is captured by $\pi(M_t)$."* Operata-side: `~/src/operata/TODO.md` §"Cognitive Modes: Intent vs Action" — *"Intent-oriented framing … is excellent for planning … But execution requires a different cognitive mode … Forcing execution into the intent graph creates friction."* Three proposed Session-shaped resolutions, none settled at abandonment. The harvest's E4 entry treats this convergence as *"the forced state-not-action spine"* and names the *"instinct to add a stored task-list / pinned-actions / session-record-as-action-source"* as the structural anti-pattern.

---

## A6 — The four-resource baseline (Intent / Realization / Perspective / Effort)

**The starting data model is the four-resource decomposition operata reached engineering-first — *Effort* (bounded initiative with origin, intent, temporal span), *Intent* (desired state), *Realization* (what happened versus expected), *Perspective* (per-actor focus). The four are first-class; each has its own type signatures and lifecycle.**

Practica inherits this model with explicit sharpening per the foundational frame from [[../02-normative]]: *Realization* supports generational re-authoring (it is the substrate the successor sub-agent re-animates from, not just a log of past events); *Intent* supports COG re-attending (see D5 in [[03-content-discipline]] — the intent record's COG slot is a *recurring* site of attending, not stored content); *Effort* supports explicit agency-scope tagging (active vs. passive per LIA1 from the harvest). The four-resource baseline is the *starting* model; the sharpening is a deliberate inheritance-with-modification rather than a fresh design.

Why this is forced: operata reached the four-resource model through engineering necessity and reached 30/30 passing BDD specs against it at abandonment — the engineering contract held under test. The decomposition is convicted-of-shape: operata empirically discovered that these four resource-kinds carve coordination state at structurally meaningful boundaries (intent vs realization, sovereign-per-actor vs shared-project-scope). The AAT-side convergences (S1 alignment-autonomy, U1 Auftragstaktik bandwidth, M1 wrapping) map onto specific resources in the decomposition; the engineering arrived at structurally aligned categories without the AAT formalism.[^a6-source]

What this does not specify: the schema of each resource beyond the type-signature commitments named in A2 and A5; relationships between resources beyond what operata's contract established; what additional resources Practica adds. The commitment is to the *baseline* and to the *sharpening directives* above; deviations from operata's specifics require explicit justification.

*Tier:* Engineering-grounded — operata's worked engineering model with BDD-contract verification at the time of abandonment. The AAT-side correspondences are convergent evidence but do not derive the specific decomposition; the decomposition itself is engineering-prior-to-theory and inherited as such. Cross-references: A2 (above; Intent/Realization type-separation); A3 (above; Perspective and Effort split sovereign-per-actor vs shared-project-scope along the LOCUS axis); D5 in [[03-content-discipline]] (Intent inherits the COG slot as a recurring-attending site).

[^a6-source]: `~/src/operata/docs/glossary.md` §"Core Domain" — the four resources defined precisely. *"Effort: A bounded initiative with origin, intent, and temporal span. Intent: A desired state or outcome; the core unit of Operata. … Realization: What actually happened when working on an intent. Captures the gap between expectation and reality, supporting the principle of preserving intent. Perspective: Contextual focus—who's looking and what matters to them."* `~/src/operata/TODO.md` §"Current State (2025-12-06)" confirms the 30/30 BDD-green status at abandonment. The harvest's E7 entry treats this baseline as *"the engineering crystallization that arrived at the same shape AAT later derives — and that operata reached without the AAT formalism."*

---

## What this cluster does not specify

These six commitments fix the *structural form* of the system. They are silent on:

- **Implementation specifics.** Which language, storage substrate, persistence format, schema dialect. The commitments are structural; the implementations have degrees of freedom.
- **UX affordances.** How users interact with the architecture — surface design, command vocabulary, presentation of cross-cutting links — is shaped by [[02-coordination-affordances]] and [[03-content-discipline]] but not specified here.
- **What the system observes about itself.** Diagnostic and monitoring surfaces are in [[04-diagnostic-surfaces]].
- **Defaults that resist failure modes.** The architectural commitments make certain failure modes harder to enter; the explicit anti-patterns and stress-resistant defaults are in [[05-failure-mode-defaults]].
- **What the system cannot promise.** The conditions under which the architecture's value is bounded — cultural soil, modular-safety failures, sandbox transport, moral hazard — are in [[06-limits-and-positioning]].

The six commitments here are tight, but they are not the whole of 02-normative. A reader implementing only these will get a *structurally sound shell*; the rest of the cluster files fill in the coordination, content, observation, and resistance behaviors that make the shell into a coordination substrate that actually amplifies the work it holds.

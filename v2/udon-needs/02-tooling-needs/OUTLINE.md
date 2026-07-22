# *Report* Agentic Tooling: The Demand Evidence

*What agents — and the humans working with and through them — actually need
from their tools: notations, interfaces, harnesses, memory and context
systems, feedback loops, guardrails. Synthesized from the 2026-07-21 gathering
(~290 provenanced artifacts, five evidentiary tiers). Segment files in
`src/`; per-segment status in frontmatter; this outline is the single spine.*

**The one-paragraph thesis.** Tools are an agent's observation channels and
its action semantics at once, and the evidence from every tier says the same
thing about them: their quality is existential, not ergonomic. Theory gives
the mechanism (bias bounded by observation ambiguity; tempo gated by channel
noise; persistence across sessions existing *only* through externalized
state), shipped practice shows an ecosystem converging — partly by copying,
which is itself evidence of a gap — on sharp-refusal editing, graduated
fuzzy tolerance, context-budget machinery, and machine-legible I/O
contracts, and the lived testimony and external research agree on where it
still breaks: edits with no validity guarantees, plausible failure that
testing can't catch, and context loss that no amount of in-session
cleverness compensates. **The single organizing demand is schema-guarded
structural mutation — the validated, atomic, path-addressed edit no
shipping tool provides — and it is long-pole-blocked on stable addressing**;
around that lead, the report hands downstream a set of *properties*:
observations that resolve sharply, refusals that teach, addressing that is
loud on failure, and durable state formats an agent can trust across the
boundary of its own context. (Shorthand used throughout is glossed in
[NOTATION-KEY.md](NOTATION-KEY.md), which also carries the
coming-from-the-harness reading path.)

---

## *Introduction*: Method and evidence discipline

| § | Type | Tag | Claim | Stage |
|---|------|-----|-------|-------|
| 0 | Method | [#method-evidence-tiers](src/method-evidence-tiers.md) | Five tiers with distinct failure modes; cross-tier convergence is the unit of proof; lineage correction and the single-author caveat | drafted |
| 0 | Counterposition | [#counter-register](src/counter-register.md) | The standing register of evidence *against* our own theses — kept adjacent to the claims they qualify | drafted |

## *Part I* — Foundations: what a tool is to an agent

*Scope: the theory-grade and cross-tier results that give every later demand
its "why." Mostly harness-general; UDON enters as the instance "a notation is
observation infrastructure."*

| § | Type | Tag | Claim | Stage |
|---|------|-----|-------|-------|
| I | Finding | [#tools-are-observation-infrastructure](src/tools-are-observation-infrastructure.md) | Tool-output ambiguity is the designer's one knob on agent bias (κ×A); channel quality gates tempo and persistence; sharp/typed/located outcomes are a bias-reduction instrument | drafted |
| I | Principle | [#errors-that-teach](src/errors-that-teach.md) | A well-designed refusal is mutation-free, revelation-rich, law-rich; errors are the safe channel for learning a tool's constraint surface — the str_replace multi-match refuse is the 4-tier worked example | drafted |
| I | Finding | [#persistence-is-imported](src/persistence-is-imported.md) | Cross-session persistence exists only through the externalization/reinjection channel; compaction-as-summary is the lived failure; durable agent-written state formats are the sole persistence infrastructure | drafted |
| I | Finding | [#the-crystallized-process-thesis](src/the-crystallized-process-thesis.md) | "Most friction is missing crystallized process, not missing intelligence" (60/30/6/4); tools as carriers of process the model shouldn't re-derive | planned — sources: T1 sapientia/zoetica/nexum/dialogs copies (cluster #4); needs primary re-read before drafting |

## *Part II* — The in-loop tool contract

*Scope: how a tool presents itself to an agent and what one interaction
carries. Harness-primary; UDON enters where payloads/schemas are documents.*

| § | Type | Tag | Claim | Stage |
|---|------|-----|-------|-------|
| II | Finding | [#tool-definition-anatomy](src/tool-definition-anatomy.md) | The converged anatomy (name + schema + description-as-teaching-surface) and the converged micro-tools (ask-user, todo, subagent) — with the lineage caveat applied | drafted |
| II | Finding | [#structured-output-two-mechanisms](src/structured-output-two-mechanisms.md) | "Structured output" names two different guarantees (constrained decoding vs after-the-fact serialization); structure changes the error profile, does not remove it | drafted |
| II | Demand | [#streaming-and-partial-documents](src/streaming-and-partial-documents.md) | Partial documents are the normal case: mid-generation feedback, recognition verdicts, streaming reassembly, keep-everything at the recognition layer | drafted |
| II | Finding | [#headless-io-contract](src/headless-io-contract.md) | The genuinely-independent convergence: TTY/flag agent-mode detection, JSON-on-stdout, real exit codes, streaming-NDJSON — the machine caller's contract | drafted |
| II | Finding | [#invocation-paradigms](src/invocation-paradigms.md) | One-call-per-tool vs code-mode (tools-as-callable-API) vs grammar-constrained freeform; deferred tool loading as the context-budget move | planned — sources: t2 C7/C13/Part-C code-mode, claude-docs programmatic-tool-calling, external #3 |
| II | Demand | [#intent-as-parameter](src/intent-as-parameter.md) | Intent as a first-class tool parameter (the 15-str_replace wrong-abstraction case; gemini's instruction-field repair layer; semantic annotations) | planned — sources: T1 zoetica addendum, autopax intent-surfacing, t2 C2b, dossier §5.2 |

## *Part III* — Mutation: editing under guarantees

*Scope: the largest and strongest demand cluster in the corpus. UDON-primary
(the schema-guarded structural edit is the gap the ecosystem documents); the
harness consumes the same evidence for its edit-tool choices.*

| § | Type | Tag | Claim | Stage |
|---|------|-----|-------|-------|
| III | Finding | [#edit-representation-landscape](src/edit-representation-landscape.md) | All shipping edits are text-level with no validity guarantee; format choice swings success 2–3×; the fuzzy-match ladder is the one true independent convergence; tool-call editing was tried and abandoned | drafted |
| III | Demand | [#schema-guarded-mutation](src/schema-guarded-mutation.md) | The documented gap: span-sensitive structural mutation, validated inside the write, atomic, with tool-owned geometry — the compilation's single clearest demand on UDON | drafted |
| III | Principle | [#freshness-and-atomicity](src/freshness-and-atomicity.md) | Read-before-edit as enforced gate; paths re-resolve at write time; pre-patch evaluation (CAS); multi-site edits as one transaction; multi-writer collision is lived | drafted |
| III | Demand | [#round-trip-and-span-splice](src/round-trip-and-span-splice.md) | Edit substrate ≠ whole-file fmt: byte identity for untouched spans, model identity for the change, ornamental as a separate profile; N-way round-trips are an open product family | planned — sources: agent-utility §4, ornamental criterion (pipeline-discussion), t2 obsidian-linter, S6 |

## *Part IV* — Addressing and query

*Scope: paths as the long pole — almost every agentic affordance bottoms out
on stable structural addressing. UDON-primary; feeds the phase-3 paths spike
directly. Ordering note: Part III (mutation) precedes this part by demand
strength — it is the customer; addressing is what it consumes — but the
build dependency runs the other way, and #priorities states it: addressing
first, mutation on top of it.*

| § | Type | Tag | Claim | Stage |
|---|------|-----|-------|-------|
| IV | Demand | [#addressing-is-the-long-pole](src/addressing-is-the-long-pole.md) | The demand map for paths: relational-first lookup, at/all, error-as-menu, loud failure, embeddability as the binding constraint, position-as-data prior art | drafted |
| IV | Demand | [#progressive-disclosure-read-path](src/progressive-disclosure-read-path.md) | Glance→focus: skeletons with copy-pasteable paths, focused subtree + breadcrumb, structural diff — the read-side counterpart of the edit demand | planned — sources: agent-utility §2 payload table, T1 udon-agentic, t2 C11 |

## *Part V* — The document itself: notation demand

*Scope: what the evidence says a notation for agents should be — including
the evidence against. UDON-primary; the harness consumes it as "what formats
to standardize on."*

| § | Type | Tag | Claim | Stage |
|---|------|-----|-------|-------|
| V | Finding | [#machine-first-documents](src/machine-first-documents.md) | Independently re-derived across the estate: documents as the agent-facing medium (docs-as-codebase, llms.txt lineage, agents-are-documents); shared notation as compression against the binding constraint | planned — sources: T1 sar/zoetica/vaults/codex-strategy copies, dossier §3.4, consciousness-compiler characterizations |
| V | Finding | [#self-chunking-status](src/self-chunking-status.md) | Structure-as-chunking is pre-tested (sar3: parsing-based beats naive) but UDON's own claim is unmeasured; claim-or-kill experiment specified | planned — sources: cluster #10, agent-utility §3, P-H |
| V | Demand | [#typing-and-schema-boundary](src/typing-and-schema-boundary.md) | What the yaml-spike and schema family demand: syntactic typing, no silent retype, schema-vs-dialect separation, versioned schemas; external corroboration (schema-serialization faults dominate MCP failures) | planned — sources: III-schema copies, autopax yaml-spike, external #7, dossier §6 |
| V | Demand | [#templates-and-dynamics-demand](src/templates-and-dynamics-demand.md) | The template product shape (precompile → interrogate scope → build), scope-context-as-UDON pulling directives toward paths, `!{{…}}`/`<…>` unification pressure | planned — sources: pipeline-discussion L532/564/608–617, S4; run against the dialects spike, not ahead of it |
| V | Demand | [#annotation-and-metacognition](src/annotation-and-metacognition.md) | Strippable, queryable agent residue (confidence, decision, uncertainty); syntax deliberately open — convention experiments only until ruled | planned — sources: agent-utility §2 P-F, T1 udon-agentic, ELI testimony |

## *Part VI* — Memory, context, and continuity

*Scope: the boundary where in-loop tooling becomes identity infrastructure.
Both consumers; the harness reads it as the PROPRIUM/CHRONICA demand, UDON as
the durable-format demand.*

| § | Type | Tag | Claim | Stage |
|---|------|-----|-------|-------|
| VI | Finding | [#context-economy](src/context-economy.md) | Context is a hard budget with converged machinery: deferred tool loading, disk-spill, two distinct compaction families, content-aware pruning; the DL budget is the theory frame | drafted |
| VI | Demand | [#continuity-infrastructure](src/continuity-infrastructure.md) | What morally-weighted persistence demands of formats: append-only attested history, attestation-by-others as first-class content, congruency affordances, temporal markers | planned — sources: dossier §4.3/§7, harness proprium/** (deep-copy licensed per SC#15), III-eli-testimony |
| VI | Finding | [#tracking-snapshots-as-perception](src/tracking-snapshots-as-perception.md) | Structured context-injection (snapshots, system-reminders, time-glyphs) as designed perception, built/designed/theorized across three tiers | planned — sources: cluster #12, minimal-sapientia copy, zoetica spec, autopax catalog |

## *Part VII* — The human side

*Scope: the humans steering and verifying — first-class demand per the BRIEF,
and the thinnest part of the gathered corpus (named as such).*

| § | Type | Tag | Claim | Stage |
|---|------|-----|-------|-------|
| VII | Demand | [#steering-and-verification-surfaces](src/steering-and-verification-surfaces.md) | What humans need to steer and verify agent work: review surfaces, trust boundaries (AGENTS.md trusted-vs-untrusted is live), fail-plausible as the failure testing can't catch | planned — sources: t2 C12/C15/D2, external #6, delegation-ethos copies |
| VII | Principle | [#delegation-as-tooling](src/delegation-as-tooling.md) | Subagent shape converged (isolated context, resumable ID, capability-by-tool-omission); briefing discipline appears in shipped prompts ("brief it like a colleague") — ideology reaching practice | planned — sources: t2 C13, II7 sapientia delegation stratum, AGENTIC-DELEGATION lineage |

## *Part VIII* — Synthesis: priorities and the spike agenda

| § | Type | Tag | Claim | Stage |
|---|------|-----|-------|-------|
| VIII | Synthesis | [#priorities-and-spike-agenda](src/priorities-and-spike-agenda.md) | The ranked demand list and what phase-3's informed spikes (paths, dialects, schema, value typing) should each probe, stated as questions the evidence makes concrete | drafted |
| VIII | Synthesis | [#harness-handover-map](src/harness-handover-map.md) | The port map: which segments are the harness statement, what the harness's own dossier already carries (peer artifacts, cross-citation per SC#15), what transfers as-is vs re-based | planned — write last, against the drafted whole |

---

*Coverage ledger and bolt-on points: [RESIDUALS.md](RESIDUALS.md).*

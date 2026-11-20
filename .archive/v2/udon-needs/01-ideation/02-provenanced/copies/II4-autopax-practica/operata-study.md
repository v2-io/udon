---
source: operata-study.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/practica/msc/operata-study.md
source_commit: 938fb79ed9bd58b34374eb1122d86bb95fd817e8
categories: [operata, intent-realization, soft-claiming, GOAP, pointer]
why_included: >
  May 19 2026. Familiarization study of the abandoned ~/src/operata engineering system (Intent/Realization/Perspective/Effort resource model, soft-claiming, GOAP back-planning) -- the concrete origin behind the practica theory. Points to ~/src/operata/docs/ as a further mining spot (flagged, not chased by this pass).
---

# operata study — the engineering-side origin of Practica (rev 2, 2026-05-19)

**What this is.** Familiarization with `~/src/operata/` — the abandoned late-2025 engineering attempt that foreshadowed the theory; the *concrete* side of Practica's origin. Joseph's steer: "may not play exactly into 01 — will definitely have a big impact on 03 — but become familiar now because it will influence emphasis in 01." Durable channel for that familiarity. Supersedable; present-truth each rev. **Status:** load-bearing picture complete and verified; honest bounds at end.

## Provenance (git-verified) + the §9 date-error finding

First commit `633e4bb` **2025-12-06**, last `624f840` **2025-12-14** (25 commits, all Dec 2025); design from **2025-11-14**. MVP `2025-12-06`, ~8 days polish (UI/TaskID/BDD/Archema-unify/Graphviz/Chiridion), abandoned `2025-12-14` → ~5mo untouched. Ruby on **Archema** (resource-oriented, multi-backend: SQLite-canonical/YAML-frontmatter/JSONL/Memory); `ops`/`dx` CLIs; 30/30 Cucumber BDD passing at abandonment.

- **Finding A-9 (Axis-A, 01-theory §9):** §9 says operata "built **Dec 2024**" — verified **Dec 2025**. Load-bearing (the pre-theory gap *is* the convergence argument). → reflect into 01-rewrite-plan; correct in rewrite.

## Convergence-independence — RESOLVED, and stronger than feared (upgrades rev-9 R-c)

`operata-principles` (2025-11-14) is an explicit cross-disciplinary **engineering** synthesis (HTN/GOAP, Auftragstaktik, GTD, PARA, Zettelkasten, Malone–Crowston coordination theory, event-sourcing/CQRS, BDI). operata predates TFT (2026-02-27) by ~3mo, AAT by ~5. **Independent of the theory: VERIFIED** (could not be fitted to a non-existent AAT). **Not independent of the program** (a PROPRIUM component per `where-operata-fits-in`, ELI-aware, post-Sept-2025-substrate) — the honest scope. §9 should *assert* AAT-independence (verified) and *scope* it ("independent of the theory; within the program"), not hedge it. This is framework-coherence's keystone, not a corroboration aside.

## Resource model → AAT (01 §9 claims verified faithful at source + actual `.rb`)

| operata | grounding | AAT | status |
|---|---|---|---|
| **Intent** = "states we want, **not actions** … back-planning" (`intent.rb`, GOAP backward-chaining) | the forced **state-not-action** inversion | `#der-recursive-update` / `#der-action-selection` (§2 spine) | **VERIFIED** — strongest convergence, on the forced-exact part |
| edges **prepares/decomposes/supports**, acyclic directed | HTN/coordination-theory engineering choice | `#def-strategy-dag` / `#deriv-graph-structure-uniqueness` | **VERIFIED + correctly tiered** (convergent-choice corroboration) |
| **Realization** = goal-blind "what happened vs expected" (`delta` enum) + `propagate` upward; a *distinct resource* from Intent | the W₁ goal-blind belief-write boundary; sat-gap/control-regret 2×2; orient-cascade routing | `#der-class-coercion-via-wrapping` (W₁); `#def-satisfaction-gap`/`#def-control-regret` | **VERIFIED** — operata structurally separated goal-blind write (Realization) from goal-conditioned want (Intent), pre-theory |
| **Perspective** = per-actor focus, no global ordering; Schwerpunkt/Auftragstaktik | built-in pre-AAT (Principle 6 + glossary) | `#def-shared-intent`/`#hyp-auftragstaktik-principle` | **VERIFIED faithful** |
| **Effort** = bounded initiative; PARA actionability; temporal; **personal vs LOCUS-linked** | the PRINCIPIA-OPERATA vs LOCUS-practica split | composite/scope container | **strong §1 corroboration** (see next) |

## The four sharpest findings (these drive the 01-emphasis + 03-impact Joseph flagged)

**F1 — operata's TODO §"Scope & Dual Nature" is a *pre-theory naming* of 01-theory §1's exact thesis, and names the prior conflation error.** Verbatim: *"Operata serves two distinct but related purposes that will likely be **independent systems with a sync layer**, not a shared database"* (LOCUS-level vs Personal); *"Previous sessions conflated these as 'two views of one database' when they're actually two independent systems that sync. This explains ambiguity in: Perspective … Effort ownership (owner_id vs locus_id) … Storage model."* → **01 §1 emphasis correction:** §1 frames this as "the dissonance Joseph could not name." operata's Dec-2025 TODO shows the dissonance *was named in the engineering*, with its exact downstream symptoms, *then* the theory grounded it. Rewrite §1 should cite operata's TODO as the prior naming and present the theory as the *grounding/resolution* of an already-surfaced engineering distinction — that is stronger and more honest than "theory first named it."

**F2 — operata hit the state-vs-action tension in practice and left it open; AAT's §2 resolves it by theorem.** TODO §"Cognitive Modes: Intent vs Action": *"Intent-oriented framing is excellent for planning. But execution requires a different cognitive mode … Forcing execution into the intent graph creates friction."* Proposed (unresolved at abandonment) a stored **Session** action-ordering layer. AAT §2: action is *derived from state each cycle, never stored* (`#der-action-selection`, exact). → operata *empirically discovered the exact tension AAT's forced spine resolves*, and was reaching for a *possibly-wrong* fix (a stored Session-state) when it stopped. **03 directive:** Session/execution-order is derived-per-cycle, not a stored first-class action-state — AAT says why. **01 §2/§9 emphasis:** the engineers hit the forced-spine tension in practice; the theory is its resolution. Prime assumptions-ledger entry (build-friction → theory-resolved).

**F3 — operata knew it needed an acyclic *graph* but shipped a *tree*; abandoned mid-migration.** TODO §"Intent Graph: Tree → DAG Migration": single `parent_id` tree, but "docs say directed graph"; planned `IntentEdge` join table with **cycle-detection ("enforce DAG")**, blocked on Archema M:M support. → AAT `#deriv-graph-structure-uniqueness` *proves* the acyclic-directed structure operata recognized it needed. **03:** DAG-with-acyclicity + cycle-detection = theorem-forced invariant; operata's tree was a known-inadequate implementation choice it was migrating away from (record the lineage).

**F4 — operata suffered its own continuity-death and named the bootstrap-safety requirement.** TODO "Lost State (from prior session) … before database was accidentally wiped"; "Why not dogfood operata with operata yet? If a bug in operata prevents you reading your task list, you can't see what to fix" → stable/unstable separation required. → operata *literally experienced* the D1/W₀ "lost ledger" failure the theory formalizes (`#hyp-the-three-deaths` D1; the 38-open/1-done W₀ rot of 01 §3). **Vivid concrete instance for 01's D1/continuity emphasis**, and a **03 process invariant** (bootstrap/dogfooding-safety: the tracker must not be able to destroy its own ability to recover — the durable-artifact-is-the-channel thesis, learned the hard way in the engineering).

**Synthesis (the §9 reframe Joseph's steer points at):** operata ran on engineering-first principles until it hit exactly three questions — (a) is this LOCUS or Personal (the §1 distinction), (b) state-graph vs action-execution (the §2 forced spine), (c) tree vs acyclic-DAG (`#deriv-graph-structure-uniqueness`) — *then stopped*. **AAT is the resolution of operata's terminal open questions.** That is the framework-coherence keystone; §9 should be re-emphasized from "cross-coherence corroboration" to that.

## Implications for 03-concrete (the big one)

operata is a **pre-existing, largely-working draft of 03's concrete side + a populated assumptions/tensions ledger**:
- Concrete model (Effort/Intent/Realization/Perspective; `relationship`/`status`/`kind`/`delta` enums; soft-claiming-not-locking; `ready`/`blocked` status-propagation = AND-only L0 over `prepares`; UUID8; Archema multi-backend; `ops` CLI; personal-vs-LOCUS) → 03 three-tier classification: **theorem-forced** (state-not-action; goal-blind Realization separation=W₁; acyclic DAG+cycle-detection per F3), **convergent-choice** (prepares/decomposes/supports edge-typing — operata's HTN choice as the *recorded rejected/alternative-considered lineage* against AAT's derived structure; AND-only-no-credence status-prop as operata's simple instance of AAT's AND/OR), **free** (CLI surface, UUID8, storage substrate, slug-IDs).
- `operata-principles` §"Productive Tensions and Design Trade-offs" (Completeness↔Simplicity, Structure↔Emergence, History↔Clarity, Visibility↔Overload, Freedom↔Coordination, each with a resolution) **is a ready-made draft for 03's first-class assumptions ledger** — mine directly.
- The abandonment + F1–F4 are the highest-value ledger entries: real build-friction whose resolution the theory supplies (exactly the convergence-as-evidence / build-drives-theory loop 03 is designed around).
- Process precedent: README's "fix friction in the substrate (Archema), not the app" + "proof-of-concept for the substrate" discipline → a 03 process-invariant candidate (practica's still-open language/substrate decision should inherit this).

## Reinforcing (final reads: the research-synthesis + the BDD behavioral contract)

- **F5 — the plumbing/intelligence split, pre-theory (a new §3-convergence point).** `operata-system` (2025-11-26 engineering research) independently lands on *"CLI as deterministic plumbing layer (TodoWrite pattern) … separates 'what to do' (agent intelligence) from 'when to do it' (CLI/scheduler determinism)"* + the `where-operata-fits-in` auxilia degrees (deterministic 60% / linguistic / reasoning / high-order). This is a concrete pre-AAT foreshadowing of the **W₁ goal-blind-deterministic-substrate / goal-conditioned-intelligence separation** (`#der-class-coercion-via-wrapping`) — a second independent convergence locus for 01 §3, alongside the Realization/Intent split. Pure engineering-first (HTN/GOAP/blackboard/CRDT/UUID7/LLM-agent-patterns; zero AAT) — **convergence-independence now triple-confirmed** (principles + system-research + glossary).
- **F3 sharpened:** the tree-vs-DAG compromise was *known from day one*, not a late discovery — `operata-system` §"Graph structure requires explicit cross-cutting links" states pure trees can't model cross-cutting and recommends DAG-with-soft-links up front. The tree impl was a deliberate MVP compromise against a recognized requirement; AAT later *proves* the acyclic-directed necessity.
- **The BDD features are the concrete "largely working" contract (03 ground-truth).** 30/30 passing at abandonment: effort CRUD/archive, intent lifecycle (new→start→realize/abandon, primitive), and **back-planning status-propagation working end-to-end** ("Completing preparations unblocks parent" — the AND-over-`prepares` forward pass, executable and green). 03's process invariants can be grounded in (and improve on) this already-specified, already-passing behavioral contract rather than specified from scratch.

## Honest bounds

**Read (complete load-bearing picture, verified):** `operata-principles`; `operata-system` (research synthesis); 4 resource docs + actual `.rb`; `glossary`; `architecture-notes`; `where-operata-fits-in`; `operata.rb` (schema/wiring); `TODO.md` (richest — F1–F4); `README`; `development-plan`; all 5 `.feature` files (behavioral contract); git provenance + log.
**Not read (genuinely lower marginal value — free-tier / settled-convergence / substrate detail; will not change F1–F6 or the resource→AAT map):** `HTN-GOAP-deep-dive` (1077, convergence-from already triple-settled), `make-right-thing-easiest`, `storage-exploration` (03-free-tier substrate detail), CLI command `.rb` (free-tier surface), `config`/`task_id`/`ui`, sys docs. A pass worthwhile only if 03 needs CLI/storage-decision specifics.

**Reflect into 01-rewrite-plan:** A-9 (date error); rev-9 R-c upgrade (AAT-independence verified+scoped, not a hedge); §1-emphasis correction per F1; §9 reframe (keystone, not aside); F2/F4 as 01 §2/§8 emphasis + 03-ledger seeds.

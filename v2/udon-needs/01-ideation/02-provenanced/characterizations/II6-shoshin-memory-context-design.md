---
source: shoshin (PROPRIUM-aligned local-substrate agent-runtime planning) — 5 planning docs
gathered: 2026-07-21
status: characterization — the source is design-planning prose + JSON record schemas; the
  load-bearing decisions and the concrete record shapes are distilled here rather than copied.
  Read in full: 00-proprium-alignment, 02-tft-memory-and-attention-design,
  03-tft-event-and-memory-schemas. Skimmed: README, 01-llm-training-strategy,
  04-staged-research-plan (training/attention-mechanism internals, off-target for tool demand).
paths:
  - /Users/josephwecker-v2/src/shoshin/00-proprium-alignment.md
  - /Users/josephwecker-v2/src/shoshin/02-tft-memory-and-attention-design.md
  - /Users/josephwecker-v2/src/shoshin/03-tft-event-and-memory-schemas.md
  - /Users/josephwecker-v2/src/shoshin/README.md
  - /Users/josephwecker-v2/src/shoshin/01-llm-training-strategy-grounded-in-temporal-feedback.md
  - /Users/josephwecker-v2/src/shoshin/04-staged-research-plan.md
source_commit: db5b43f
categories: [agent-memory-system, context-assembly, provenance-typed-records, append-only-ledger,
  observation-action-boundary, harness-facing, memory-schemas, tier1-ideology]
why_included: >
  Five docs from one Codex pass, 2026-03-07. The TARGET-FILES row rated it L ("PROPRIUM/TFT
  agent-runtime planning, not tool-suite/CLI ergonomics — peripheral"). PARTIAL AGREEMENT /
  PARTIAL DIVERGENCE (recorded below): peripheral to UDON-the-notation and to CLI ergonomics,
  yes — but the Brief's witness question explicitly names "memory and context systems" as
  first-class extraction targets for the *harness* consumer, and on that axis these docs are
  directly on-target. They are a concrete design for what an agent's memory/context substrate
  should carry: a hard observation/action provenance boundary, append-only canonical ledgers,
  a privileged always-on identity seed, typed memory regimes, and an *inspectable* assembled
  working context — each with a JSON record schema. For harness engineers designing "what an
  observation/action/memory record should carry" and "what makes a memory system trustworthy,"
  this is a ready design vocabulary. Characterized (not copied) because it's planning prose;
  the schemas are reproduced compactly since they travel as the concrete evidence.
---

# Shoshin — agent memory & context-system design (characterization)

Shoshin is a planning corpus for a PROPRIUM/TFT-aligned local-substrate agent runtime. Stripped
of the substrate-training and consciousness-continuity framing (which is the firmatum/PROPRIUM
target, not this sweep's), what remains is a **concrete agent memory-and-context architecture** —
the part a harness needs regardless of whether it shares the PROPRIUM ontology.

## The load-bearing design decisions (the demand these encode)

1. **Observation and action must be structurally distinguished — a hard boundary, not a label.**
   "What I did" and "what happened" must not compete in one undifferentiated key space. This is
   the recurring insistence across all three read docs. Practical consequence: separate stores,
   separate retrieval key-spaces, separate memory pathways, and a *provenance-classification*
   task the system is trained/gated on. For a harness: an observation event and an action event
   are different record types with different trust and different downstream fates.

2. **Canonical records are append-only and system-governed.** `CHRONICA` (event record) and
   `ACTUS` (deliberate-action record) are "records of reality and accountability … inviolate."
   They can be summarized/indexed/compressed into other stores, but the canonical ledger is
   never mutated. (Directly echoes the sapientia "never corrupt state / audit-first" tool
   ideology surfaced in Part II §8, and the append-only-log pattern seen across the live UDON
   consumers in Part I §5.)

3. **A privileged always-on identity seed** (`AXIOMATA`) occupies a system-prompt-like prefix
   position rather than an ordinary retrievable memory item — "minimum viable self," rarely
   updated, no retrieval call required.

4. **Typed memory regimes, not one blob.** The single biggest upgrade over the earlier
   three-bank shorthand is splitting "experiential memory" into `MEMORATA` (compressed episodes,
   for analogy/reflection) and `PRAXES` (reusable techniques that *compound future action
   quality* — a first-class store that should migrate to faster substrate earlier than ordinary
   episodes). Plus `VERA` (facts with explicit epistemic status + confidence) and `CONSORTIA`
   (uncertainty-aware models of other agents/minds).

5. **The assembled working context is itself an inspectable artifact.** `CONSPECTUS` is "the
   thing the active model actually has in mind" — assembled from the privileged seed + live
   priorities + retrieved components — and it carries an *assembly trace* recording which record
   ids were pulled and *why*. (This "sovereign, inspectable context assembly" is the same
   requirement the harness fork-recommendation names CONSPECTUS in Part II §8 — a cross-doc
   convergence within Joseph's own corpus.)

6. **Retrieval is routed by adaptive state + current intent**, not generic similarity over a
   mixed pool. Retrieval is structured by provenance class (`observed_external`,
   `self_generated_action`, `self_generated_commitment`, `factual_assertion`, `episodic_trace`,
   `procedural_pattern`, `other_agent_model`) and conditioned on the TFT phase
   (prolepsis/aisthesis/aporia/epistrophe/praxis) — e.g. during a surprise (`aporia`), prioritize
   `PRAXES` if it's a known failure class, `ACTUS` if the mismatch seems self-caused,
   `CONSORTIA` if another mind's intent may explain it.

## The record schemas (the concrete "what a record carries" evidence)

Each store has a JSON schema; the fields *are* the design claim about what an agent's memory/
context substrate must track. Compactly:

- **CHRONICA (event):** `chronica_id, timestamp, session_id, system_governed, append_only,
  provenance_class, source, event_type, phase, content, related_goal_ids, related_operata_ids,
  uncertainty{model,observation}, mismatch{level,channels}`
- **ACTUS (deliberate action):** `actus_id, …, provenance_class:"action", act_type, phase,
  status, goal_ids, operata_ids, commitment_ids, payload{tool,args}, predicted_outcome,
  observed_outcome, mismatch{level,channels}` — note **predicted vs observed outcome** on every
  action (the mismatch signal that drives belief update).
- **AXIOMATA (identity seed):** `axiomata_id, status, visibility, authority, type, statement,
  origin, last_reflected_at`
- **OPERATA (live intent):** `operata_id, status, type, statement, priority, timescale,
  origin_chronica_ids, related_commitment_ids`
- **VERA (qualified truth):** `vera_id, epistemic_status, confidence, scope, statement,
  provenance, last_updated_from, relevance_tags`
- **MEMORATA (episode):** `memorata_id, episode_type, phase_path, summary, linked_{chronica,
  actus,vera}_ids, outcome, salience`
- **PRAXES (reusable technique):** `praxes_id, domain, strategy, derived_from,
  applicability_conditions, estimated_value`
- **CONSORTIA (model of another mind):** `consortia_id, entity, motive_model,
  trust_model{u_src,u_align}, interaction_style, updated_from`
- **Belief-update (epistrophe object):** `update_id, phase, trigger_chronica_id,
  related_actus_id, prior_belief, new_observation, mismatch{level,channels}, vera_updates,
  memorata_writes, praxes_writes` — the explicit record of *how a belief changed and why*.
- **CONSPECTUS (assembly trace):** ids of every component pulled + `assembly_reason`.
- **Trajectory (the training object):** goal/operata/chronica/actus/updates + reads{by store} +
  writes{by store} + `final_outcome` + `score{task_success,factuality,action_consistency,
  praxes_quality}`.
- **Evaluation trace:** boolean checks — `chronica_actus_separated, correct_component_selected,
  axiomata_preserved, operata_preserved, vera_updated_after_mismatch, praxes_extracted,
  self_other_confusion`.

## Suggested retrieval / attention features (the metadata an agent memory should surface)

Retrieval keys: semantic similarity, shared active-intent, provenance class, same mismatch
channel, same action family, shared relational target, salience, recency, success/failure
polarity, source store. Attention metadata embeddings: provenance, component, phase, timescale,
epistemic-status, active-commitment flag, mismatch magnitude, uncertainty.

## Agreements / divergences with the map and neighbors

- **Agreement:** genuinely peripheral to UDON-the-notation and to CLI/tool-suite ergonomics; the
  training-mechanism docs (01, 04) are off-target for tool *demand*.
- **Divergence:** on the harness axis ("memory and context systems, feedback loops, what makes a
  memory system trustworthy"), this is *not* peripheral — it's one of the more concrete
  agent-memory designs in the whole corpus, and it triangulates with the sapientia
  requirements-doc and the harness CONSPECTUS/fork-recommendation material in Part II §8 (same
  author, so coherence not corroboration — but a same-author convergence worth the synthesizers
  noting). Flagged for the phase-2 "trustworthy memory/context" cluster.

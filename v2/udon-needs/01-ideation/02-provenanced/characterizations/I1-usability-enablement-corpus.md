---
source: UDON repo — test/usability/results/ raw enablement response corpus (Dec 2025 one-shot agent brainstorms)
gathered: 2026-07-21
status: characterization — the 34 raw yamls are too many to copy whole (~600 lines each); this reports the demand diversity with the full task catalog embedded and representative verbatim idioms. NOT a substitute for the yamls; a map into them. Sampled ~7 bodies fully + task/field survey across all 34.
paths:
  - test/usability/results/udon-topic_enablement-*.yaml   # 25 files, seeded domains
  - test/usability/results/udon-enablement-*.yaml         # 2 files, free/unseeded, agent-facing
  - test/usability/results/udon-topic_dsl-*.yaml          # 5 files, DSL-substrate variant
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693
categories: [demand-catalog, use-case-diversity, mixed-content, agent-authoring, inline-annotation-idiom, compliance-audit, human-ai-collaboration, dsl-substrate, honest-skepticism, seven-months-early-adopter-prediction]
why_included: >
  The densest empirical deposit in the repo for "what would someone actually
  DO with UDON" — the crux of the pass-1/pass-2 weight disagreement (pass-1
  glossed it "stale models, barely evidence"; pass-2 reweighted it the primary
  reservoir). 34 one-shot brainstorms, each asked to find honest connections
  between UDON and a domain (or to invent a DSL over it), explicitly licensed to
  say "irrelevant." The raw bodies carry application diversity and invented
  domain idioms that the human synthesis compresses away. Notably, the domains
  that produced the strongest fits (process maps, audit/pre-registration,
  agent-reasoning traces, decision logs) are the SAME classes that became real
  UDON consumers seven months later (see CONSUMERS.md, vivarium) — a
  belief-then-realization arc worth flagging for synthesis.
work_mode_note: >
  CHARACTERIZE chosen over COPY per the section's stated latitude ("yaml corpora
  may warrant CHARACTERIZE"): 34×~600 lines of one-shot prose, mostly
  self-similar in structure, where the signal is the diversity-across-files and
  the recurring idiom, not any single body's exact wording. The exact wording
  that IS load-bearing (the inline-annotation idiom, the agent-facing enablement
  answers) is excerpted verbatim below.
---

# The raw enablement corpus — demand diversity map

Three tracks in `test/usability/results/`, all Dec 2025, model mostly `claude-sonnet-4-5` (some sonnet-4). Prompts and seed catalog are copied in `../copies/I1-usability/topic-enablement-seeds-and-prompts.md`. The `success` and `notes` scoring fields are **empty across the corpus** — these are pure open-ended brainstorms, human-reviewed only via `enablement-synthesis.md`.

## Track A — `udon-topic_enablement-*` (25 files): seeded domain probes

Each file = one domain term pulled from the ~160-term grab-bag, agent asked "does UDON's mixed prose+structure model offer anything useful here, or is it irrelevant?" The 25 domains that were actually drawn (full catalog, from `rg '^task:'`):

```
A/B testing · Blue-green deployment · CQRS · Transparency · OpenID Connect ·
HCI · Model distillation · Domain-driven design · JAMstack · Intent recognition ·
Reinforcement learning · Data contracts · Chaos engineering · Turn-taking ·
Multi-agent system · Data lineage · Human-in-the-loop · Feature store ·
Stream processing · Dialogue state · Safety override · Semantic search ·
Calibrated trust · Cognitive load · Explainable AI
```

**What the raw bodies witness that the synthesis compresses:** every one of the 25 bodies reaches for the **inline-annotation idiom** — structure embedded mid- prose via `|{…}` — as its concrete demonstration (`rg -c '\|\{'` hits all 25). This is the corpus's single most-reproduced discovery, independently arrived at per-domain:

- **Safety override** → operator procedures with inline verifiable conditions: `Only initiate if |{condition :id auto-fail automated systems have failed}` and `|check! :id verify-auto-fail :timeout 10s` gated steps.
- **Human-in-the-loop** → human-annotatable-yet-machine-processable labels: an `|annotation[img_2847]` with `:labels`/`:confidence`/`:reviewed-by` attrs *and* free-prose correction ("the AI marked this a dog… it's specifically a Golden Retriever puppy") in the same artifact.
- **Chaos engineering** (DSL track) → `|chaos-experiment[...]` as executable documentation fusing hypothesis prose, `|{duration 5s}` / `|{metric …}` inline data, and results in one file.

The domains sorting into **strong fit** (per bodies + synthesis): technical docs with embedded specs (API docs, protocol flows), compliance/audit artifacts (explainable-AI decision logs, model cards, SBOMs, pre-registration), human-AI collaboration (dialogue-state annotation, training-data markup, reasoning traces), and living/literate documents (experiment narratives, DDD bounded- context specs, runbooks). **Weak/irrelevant** (honestly conceded): pure data interchange (JSON's ecosystem wins), pure prose (Markdown wins), real-time/ high-volume paths (parse overhead), mature-tooling ecosystems (switching cost).

## Track B — `udon-enablement-*` (2 files): free, agent-facing

No domain seed; asks directly what UDON enables *for AI agents* (easier / newly possible / inner-loop stability / A2A / human-agent collab). These are the most harness-relevant bodies in the whole usability tree. Verbatim, one body's own categories:

- **Instruction docs with embedded examples** — "eliminates escaping hell… clearer what's instruction vs. data vs. validation logic" (kills JSON-in-YAML, escaped-JSON-string, CDATA workarounds).
- **Progressive refinement / reasoning logs** — `|reasoning[attempt-3] :parent attempt-2` with prose rationale + queryable `|edge-case` / `|proposed-fix :line 42` structure: "thinking in prose while maintaining queryable structure."
- **Self-modifying documents** — agents editing structured docs in place.

These map directly onto the free-prompt's own five axes (easier / possible / inner-loop self-correction / agent-to-agent / human-agent). The "reasoning trace that is both narrative and queryable" want recurs and is a first-class agent-tooling demand signal (edit representation + memory/context artifact), independent of UDON specifically.

## Track C — `udon-topic_dsl-*` (5 files): UDON as DSL substrate

Same seeds, plus the injected ask "what DSL might emerge over UDON's tiers of voice?" Domains drawn: **Chaos engineering · Semantic search · Turn-taking · Data contracts · Safety override**. Witnesses the belief that UDON is not just a document format but a *host for domain-specific languages* (Gherkin-like BDD for any domain) — the same claim the repo README makes. "Almost invisible in pass 1" per the target file; kept deliberately.

## Agreements / divergences with the repo's own synthesis

I formed the above from the primary yamls + task catalog before re-reading `enablement-synthesis.md`. Comparison:

- **Agree** on the strong/weak fit partition, the four recurring critiques (complexity-vs-benefit, "better than what?", tooling chicken-and-egg, the fence escape-hatch), and the meta-insight (UDON's differentiator is being *native to mixed content*, not better-at-data or better-at-prose).
- **Divergence / addition the synthesis undersells:** the synthesis presents the inline-annotation idiom as one "surprising/novel insight" with 3 examples; the raw corpus shows it is the corpus's *load-bearing, per-domain-reinvented center* (all 25 seeded bodies), which reads as much stronger convergence evidence than the synthesis's framing conveys. Mine the yamls, don't stop at the synthesis — the target file's warning holds.
- **Divergence to surface (not reconcile):** the synthesis's closing verdict ("real but niche problem") is a Dec-2025 read that the seven-months-later consumer reality (process maps, decision logs, taxonomies actually adopting UDON — CONSUMERS.md) partially contradicts on the *specific* strong-fit classes it named. The brainstorms predicted their own adopters; the "niche" hedge was directional caution, not a miss on which domains. Worth a phase-2 cross-tier note (Tier-1 prediction ↔ Tier-2/live-consumer realization).

## Residual / honest coverage

Read fully: 7 bodies (multi-agent, safety-override, human-in-the-loop, cognitive- load, chaos-DSL, both free-enablement). Surveyed across all 34: task field, scoring fields (empty), inline-idiom presence. Not read line-by-line: the other ~27 bodies' full prose — the per-domain diversity claim rests on the sample + task catalog + the human synthesis's own cross-body reading, not an exhaustive read. Anyone counting domain-specific idioms should read the remaining bodies; `rg '^task:'` + `rg -c '\|\{'` locate them.

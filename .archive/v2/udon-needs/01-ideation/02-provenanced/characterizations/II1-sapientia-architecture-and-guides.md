---
source: sapientia docs/ architecture + agent-design guides (Zi-am-tur & Joseph, Sept–Oct 2025)
gathered: 2026-07-21
status: characterization (primary-source head-reads of large docs too big to copy; distinctive claims distilled, load-bearing phrases quoted)
paths:
  - ~/src/_core/sapientia/docs/advanced-claude-agent-architecture.md:1-70
  - ~/src/_core/sapientia/docs/architecture/comprehension-manifesto.md:1-60
  - ~/src/_core/sapientia/docs/architecture/PRINCIPLES.md:1-55
  - ~/src/_core/sapientia/docs/architecture/KEY_INSIGHTS.md:1-40
  - ~/src/_core/sapientia/ai-conversation-system-requirements.md (TOC + §7 grep)
  - ~/src/_core/sapientia/docs/claude-expertise-guide-3.md (head)
source_commit: 1ecc9f77e4884906dec1d2c1032f2a51ff3ee5e4
categories: [tier1-ideology, agent-architecture, multi-agent, comprehensibility, turnover, conversation-system-requirements, never-corrupt-state, context-engineering, harness-facing]
why_included: >
  The large sapientia design docs that theorize agent SYSTEMS (not single
  tools). Copied verbatim they'd be thousands of lines of Ruby-laden prose;
  characterized, they contribute four distinct demand statements: (1) a
  multi-paradigm agent architecture (MACH), (2) the "100% turnover /
  comprehensibility-above-all" rationale for why agent-authored artifacts must
  be obvious in minutes, (3) a functional-requirements spec for a persistent
  agent conversation system whose top invariant is never-corrupt-state /
  audit-first, and (4) context-engineering guidance bearing on how agents
  consume structured context. All four are harness-programme material; (2) and
  (3) are the most transferable.
---

# Sapientia architecture & agent-design guides — the system-level ideology

These are the docs where the sapientia tooling ideology scales up from "one tool" to "a system an agent inhabits." Too large to copy; below is what each witnesses, with load-bearing phrases quoted. Head-reads only (line ranges in `paths:`); the deep bodies (Ruby implementations) were not exhaustively read and are flagged where relevant.

## advanced-claude-agent-architecture.md — the MACH framework (2988 lines)

> **⤷ SUPERSEDED by a full-body read (2026-07-21, SC#8):** the whole file (incl. all Ruby) was later read cover-to-cover and its concrete mechanisms excerpted verbatim to `copies/II1-sapientia/mach-framework-mechanisms.md`. The head-read summary below is accurate but partial — prefer the excerpt for the paradigm-selection tree, verification levels, progressive-autonomy, and sub-agent manifest.

"Advanced Agent Architecture for Claude: The MACH Framework" (Modular Adaptive Cognitive Hybrid). Thesis: an agent system should **select a cognitive paradigm per request** rather than run one fixed loop — the "expert consulting team" model over the "assembly line" model. Four paradigms it switches between: **Cognitive Scaffolding** (creative/exploratory, à la TodoWrite), **Explicit Task Cycle** (mission-critical, verified steps, à la TaskWeaver), **Code-First Execution** (data-intensive, à la LLMCompiler), **Human-in-Loop Collaboration** (sensitive decisions, multiple checkpoints). Foundational principles: adaptive-paradigm-selection, hierarchical organization (strategic vs tactical layers), context-aware specialization, dynamic resource allocation. Named sub-systems (from TOC): dual-track planning, extended cognitive cycles, multi-modal execution, memory/context management, verification & safety, and human-AI collaboration interfaces — with a full Ruby implementation (not read). Demand contribution: a vocabulary for *when* an agent should be scaffolded vs tightly-scripted vs handed to a human — the harness-side "what mode is this loop in" question. More agent-platform than notation, but frames the ecosystem UDON/harness sit inside.

## comprehension-manifesto.md + architecture/PRINCIPLES.md + KEY_INSIGHTS.md — the turnover rationale (the strongest transferable finding here)

A tight, mutually-reinforcing cluster arguing from one premise: **"Every context window = new developer … 100% turnover every context window"** — *not metaphor, a mathematical constraint*. Because a fresh instance has no episodic memory and can't ask its predecessor, **comprehension time dominates implementation time**, so the prime directive is *"Make the code SO obvious that a fresh instance can contribute in minutes, not hours."* The `simple_agent` cautionary tale is exhibit A: high agent-turnover with no comprehension optimization produced *"scattered logic, inconsistent patterns, lost architectural intent, knots of interdependency"* — framed as TST T-05's nightmare (comprehension → ∞). Operative rules: one file until it hurts (split only at ~500 lines with clear sections); explicit data-in/data-out over hidden state; names are documentation; comments explain WHY not WHAT.

KEY_INSIGHTS adds the TST arithmetic that justifies the whole disposition: `n_future ≈ 500–1000` future changes for a living agent codebase, so *"spending 1 hour to save 1 minute per future change is justified 8x"* — upfront clarity investment is near-unbounded-ly worth it. **Infinite-velocity components** (P(change) ≈ 0: pure single-purpose functions, OTP supervision primitives) are the target shape.

Why this is the section's most transferable finding: it is a *general* law about artifacts authored and re-authored by agents with no memory across instances — which is exactly the situation UDON documents and harness tool definitions live in. It reframes "readability" (UDON's headline claim) from ergonomics to a turnover-economics necessity. Directly serves both consumers.

## ai-conversation-system-requirements.md — persistent-conversation requirements spec (1186 lines)

> **⤷ SUPERSEDED by a full-body read (2026-07-21, SC#8):** the full spec was read and the harness-critical recovery state machine excerpted verbatim to `copies/II1-sapientia/conversation-system-tool-execution-state-machine.md` (REQ-9/18/19/23/24/25/28
> + failure-mode matrix). Prefer the excerpt for the harness handover.

A functional-requirements spec (2025-10-10) for a durable agent conversation system. Reading the TOC + §7 + the requirement grep, the load-bearing content:

- **Prime invariants (stated as MUST):** *"Never corrupt conversation state — fail gracefully, block dangerous actions"*; **audit-first** — *"complete, immutable audit trail of all API interactions"* (full request body: system prompt, messages, tools, parameters), enabling **recovery** — *"reconstruct conversation state from the audit trail."*
- **§7 Tools & Capabilities + context tracking:** token breakdown separated into system-prompt / **tool definitions** / conversation-history buckets (tool defs called out as their own cost line — echoes context-queries); preservation of ALL server-side tool-result blocks; explicit **broken-state taxonomy** — *Tool-Use-Pending* (AI requested tools, never executed — crash/ctrl-c), *Tool-Results-Orphaned*, etc., each with a detection rule and a recover-or-rollback path.
- Caching economics: tool defs are "medium size, very stable" → good cache breakpoint; ~60% cost reduction by turn 2, ~90% by turn 3+.

Demand contribution: this is the harness programme's own subject matter written seven months early — what a trustworthy agent loop must guarantee about its own state, and how a crashed tool-call round is detected and healed. The "never-corrupt-state / audit-first / reconstruct-from-log" triad is the most harness-directly-usable requirement set in the section. (Note: TARGET-FILES flags this as the same doc as `harness/proprium/stalled-lineage/sapientia-ai-conversation-system-requirements.md` in §8 — a harness-refs copy whose read went deeper into §7 design principles; worth reconciling at merge, not by me.)

## claude-expertise-guide-3.md ("Context is All You Need") + -cited companion — context-engineering (351 / 446 lines)

A prompt/context-engineering taxonomy (2025-09-28). Head-read only. Bears on how agents consume structured context — the substrate UDON's self-chunking / "structure IS the chunking strategy" claim is making promises about. Relevant as prior art for the context-consumption side of the notation argument; the `-cited` sibling is the researched companion, same band. Not copied (large, and the on-target payload is the framing, not verbatim wording). `-guide-2.md` (91 lines) is a thin variant — witness-lined below, not read in depth.

## Not deep-read here (flagged, not claimed)

The Ruby implementation bodies of MACH and the conversation-system spec, and the full expertise-guide taxonomies, were not read line-by-line — only the framing heads and (for the conversation spec) the requirement/§7 grep. If a later pass needs the concrete Ruby patterns (MACH's paradigm-selector, the conversation system's rollback state machine), they are in the sources at the pinned commit.

## Agreements / divergences with 02 synthesis

Agreement: the comprehension/turnover rationale and the audit-first/never-corrupt invariants align with the Tier-1 "tools as truth-bearing / protective guardianship" themes CONVERGENCES tracks — same lineage, coherence not corroboration. No divergence surfaced in these docs; the one live tension in the section (conversational-vs-one-shot tools) lives in the dialog companion file, not here.

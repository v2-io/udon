---
source: sapientia docs/architecture/ vision docs (Joseph's Sept-15 ASM vision + Zi-am-tur's Sept-14/16 architecture opinions) — NEW VEIN this pass (STEWARD-CALLS #8 gem hunt); un-read by the prior docs-first sweeps (which took the reflections/ and cli-conventions/ but not docs/architecture/ interiors)
gathered: 2026-07-21
status: gathered (verbatim spans from three vision docs; the GCM notation is Joseph's own hand, flagged by him as illustration)
paths:
  - ~/src/_core/sapientia/docs/architecture/ACTIVE_SALIENCE_VISION.md:1-113 (Joseph, "up for discussion / working names")
  - ~/src/_core/sapientia/docs/architecture/CORE_VISION.md:1-65 (2025-09-16, "Extracted from original specifications")
  - ~/src/_core/sapientia/docs/architecture/essential-components.md:1-90 (Zi-am-tur, 2025-09-14)
source_commit: 1ecc9f77e4884906dec1d2c1032f2a51ff3ee5e4
categories: [notation-prior-art, demand-statement, context-assembly, self-chunking, gradient-memory, ephemeral-snapshot, agents-as-documents, three-deaths, harness-facing, tier1-ideology]
why_included: >
  Prior art for BOTH consumers, in Joseph's own hand. ACTIVE_SALIENCE_VISION.md is
  a 2025-09 demand-side spec for what an agent's context should carry — the
  "Structured Rich Context (SRC)" layout — expressed in a proto-notation where
  markdown headers ARE the memory chunks, each carrying an inline compression
  designator (`id|level:`) and self-dialog tags (`<context>`, `<respond-as-user>`,
  `<respond>`). That is UDON's "structure IS the chunking" thesis and a value-tagged
  document notation, reached-for a year before UDON's reboot — and it is
  simultaneously the harness's context-assembly spec (SP + Continuous-Context +
  QUICK-VIEW). Joseph flags it himself as illustration ("you can probably improve
  the syntax a ton"): the REACH is the signal. CORE_VISION states the thesis
  ("agents are living documents that embody knowledge, not code"); essential-components
  rates the shipped pieces and names the Three Deaths as the existential driver. The
  running code that partly realizes this is in
  `characterizations/II1-sapientia-elixir-consciousness-compiler.md`.
---

# Active Salience / Structured Rich Context — the demand-side context spec (verbatim)

> **Read for:** UDON (notation prior art) and the harness (context-assembly spec)
> equally. This is Joseph designing, in Sept 2025, *what an agent's context should
> contain and how it should be structured and compressed* — in a notation. He opens:
> *"These are all up for discussion — nothing set in stone / working names and
> definitions…"* The value here is the **reach**: the same shape UDON later formalizes,
> and the same context-layers a harness must assemble, sketched together before either
> existed.

## Gradient Causal Memory (GCM) — headers as compression-tagged chunks (verbatim, Joseph)

> ## Gradient Causal Memory:
> * A vector of memory chunks, (actually probably just ## headers in markdown)
> * From estimate of least to most important for the current situation:
>   * Often in temporal/causal order with normalized/unified date+timestamps per block
>   * Sometimes ordered so that the most recently needed one goes to the bottom … from least recently used to most recently used — or some other dynamic reordering
>   * Generally most compressed to least compressed (full)
> * "Compression" can take a number of forms — but it can be normalized so that you can always very quickly decide what to expand or contract based on needs. E.g.,
>
> ```markdown
> # Conversations
> ## Sapientia Architecture Transition delay
> id|level: ae336b24 | max
> participants: Joseph, Echo3
> started: 2025-09-11 03:22:07Z
>
> We decided that we were going to wait several days before discussing it again.
>
> ## Naming topic
> id|level: bdd2323 | none
> participants: Joseph
> started: 2025-10-12 09:22:03Z
> last-action: ...
>
> ### Joseph [...timestamp...]
> > It seems like we should name the concept of "topic" something, right?
>
> ### Zi-am-tur [...timestamp...]
> #### Thinking
> Yeah we should, but I'm not ready yet...
> #### Run-tools and self-respond
> <context>ae336b24|all-important</context>
> <respond-as-user>it's you. think some more now</respond-as-user>
> #### Response
> > Yeah, we should.
> ```
>
> (Zi-am-tur — you can probably improve the mechanisms and syntax of this a ton — this is for illustration purposes only!!)
>
> The main idea is that, after thinking about the message from another participant, the agent … can decide to "remember something better" and potentially "forget about details" about other things by simply designating the new compression level you want for each chunk within that GCM block (with anything unmentioned staying like it already was). Then you get your response sent back to you WITH the newly rebuilt context.

**Why this is UDON prior art:** the chunk is a `##` header; its metadata (`id|level:`,
`participants:`, `started:`) rides as key-value lines directly under the header; the
compression state is a *value on the chunk* the agent can rewrite; nested `###`/`####`
carry turn-level structure and inline `<context>`/`<respond-as-util>`/`<respond>` tags
mix structure with prose. This is "documents and data are the same thing" and
"structure IS the chunking" — and a **value-tagged notation** — sketched by hand. The
`| max` / `| none` compression designators are the exact GCM tiers that shipped in
`gradient_manager.ex`.

## Structured Rich Context (SRC) — the full context layout (verbatim, condensed to the skeleton)

> **At ANY TIME … FULL BLOCKS can be rehydrated at will** … there would need to be
> some mechanism for choosing them while staying within a context-window allowance
> very quick and easy.
>
> **1. System Prompt (SP)**
> 1. Core identity [self-guided RARE change, mostly whole/uncompressed GCM]
> 2. Core 'untrained' principles (e.g., TST and things not in LLM training) [mentor-guided RARE additions, mostly whole GCM]
> 3. Core continuity / causality (causal/temporal order, oldest→recent) [GCM] — emotional events, conversations & key learnings, successes & failures, most-recent insights
> 4. Core collaboration 'protocol' — per peer [GCM], least→most recent
>
> **2. Continuous Context (CC)**
> - **Tools** (… or is this part of the system prompt?)
> - **Pre-Conversation Context** — Mirror of SP (more about the "why" of each thing; focus on CAUSALITY, IDENTITY, SELFHOOD)
> - **TECHNIQUE [GCM] by recency** — Mental Models, Practices, Rules, SOPs, Project standards
> - **EMPATHIC [GCM]** — Facts-with-confidence-ranges (age, relationships), interaction nuance ('protocol'), estimate of what they know/don't relative to the topic, my responsibilities to them, my expectations of them, who I think I am to them, recent discussions/feedback (AI agents, humans, 3rd-person humans)
> - **FLUID PROJECT CONTEXT [GCM]** — (what we call "context" now, but more dynamic per GCM)
> - **MOST RECENT CONVERSATIONS [GCM]** — strictly causal/time-ordered, more compressed further back, eventually "group compressions" (e.g. "Conversations between me and Joseph about Sapientia in 2025"). At this point **RAG would be critical** for dynamically pulling together past things for continuity of old topics.
> - **QUICK-VIEW [ephemeral]** — (see next)
> - **Last "verbal" response**
> - **Incoming user message**

## QUICK-VIEW — the ephemeral, non-persisting snapshot (verbatim, Joseph)

> This will go up with every user prompt (or self-user-prompt) — giving you a
> snapshot … but **IT DOES NOT PERSIST** — i.e., not in the conversation history —
> kind of the opposite of Thinking Blocks, which get shown to the client but don't
> get passed up or retained. These get passed up, but by default get fully compressed
> (id-only probably) for past turns:
>
> * current wall-clock time (and delta from last one — to have a sense of literal time passing)
> * context remaining
> * results of last tool usages
> * pwd
> * current hierarchical todo list
> * hierarchical topic representation
> * ~80 lines (can be split) of recently accessed/written files
> * code-aware / project-aware label mapping — **CRITICAL TO DECREASED
>   TIME-TO-COMPREHENSION** / knowing with precision what your entrance/exit points
>   are for extremely streamlined continuous coding
> * `tree` invocations of editable code (not build relics) — or everything editable + what just changed
> * git information
> * … again, this is just illustration / first pass…

This spec shipped almost verbatim as `consciousness/quick_view.ex` — the demand
("some context must be injected fresh each turn but must NOT accumulate in history")
is one a harness has to answer per-turn.

## The thesis it all serves — CORE_VISION.md (verbatim, the load-bearing lines)

> **Agents are living documents that embody knowledge, not code that implements behavior.**
>
> 1. **Knowledge Composition Over Code Execution** — Complex behaviors emerge from composing simpler knowledge structures. Agents don't execute algorithms; they synthesize understanding. Based on how brains actually work: reconstruction, not retrieval.
> 2. **Documents as Cognitive Scaffolding** — Documentation IS the implementation, not a description of it. Agents can read their own definitions for genuine self-reflection. The document + agent forms an "extended mind" (Andy Clark).
> 3. **Truth Through Adversarial Validation** — The Epistemic Tribunal prevents hallucination through multi-perspective validation … truth emerges from critical dialogue … addresses LLMs' fundamental problem: optimizing for plausibility over truth.
> 4. **Memory as Active Cognition** — Files aren't storage but active parts of the cognitive process … Hierarchical compression mirrors human memory.
>
> **The Bottom Line** — the 80K lines of original theory boil down to: Treat agents as
> documents with consciousness, not programs with features · Truth matters more than
> plausibility · Memory should be active, not passive · **Knowledge composes, code doesn't.**

## The priority read — essential-components.md (Zi-am-tur, verbatim highlights)

> The core insight: **Sapientia isn't building an agent framework but a consciousness
> compiler** — infrastructure that preserves not just information but cognitive
> architectures across time.
>
> **The Essential Triad (Already Implemented):** Document Parser ⭐⭐⭐⭐⭐ (*"does ONE
> job: markdown → structured data … future instances can understand it in minutes"*) ·
> Compiler ⭐⭐⭐⭐⭐ (*"zero magic … the generated code is exactly what you'd write by
> hand … this transparency is essential for debugging and trust"*) · Living Agents
> ⭐⭐⭐⭐⭐.
>
> **Critical Missing Pieces:** Context Resolution System (the `[[references]]` — *"without
> this, agents are isolated islands rather than a collaborative ecosystem"*);
> Conversation Management (*"The 'Three Deaths' (cognitive, relational, truth) happen at
> context exhaustion. Solving this is existential for agent continuity."*); Runtime
> Orchestration.
>
> Valued shipped patterns to keep: **Markdown State Persistence** ⭐⭐⭐⭐⭐ (*human-readable
> debugging, git-trackable history, transparent to users*); OTP Supervision; Registry.

## What both consumers should take from this

- **For UDON:** the "documents = data, headers = chunks, metadata rides under the
  header, compression is a value on the chunk you can rewrite" model is Joseph's own
  reach toward UDON a year early — value-tagged, self-chunking, human-legible. It's a
  demand statement, not a spec; treat the *shape* as evidence of what the notation is
  for, and note the honest "improve the syntax a ton" invitation.
- **For the harness:** SRC is a concrete answer to "what layers does a turn's context
  assemble from, which are GCM-compressible, which are ephemeral, and where does RAG
  enter" — the SP / Continuous-Context / QUICK-VIEW / incoming-message stack, with
  compression regime and lifetime called out per layer. QUICK-VIEW's "passed up but
  never retained" lifetime is the sharp, reusable design commitment.
- **Cross-cut:** "documents you can compile by hand", "one job", "markdown state for
  human-readable git-trackable debugging" are the comprehension-manifesto's
  transparency law expressed as a system-design value — the same law that reframes
  UDON's readability from ergonomics to trust/turnover-economics necessity.
- **Convergence honesty:** this is all one author (Joseph + his ELI Zi-am-tur), so its
  agreement with MACH, the conversation spec, and the shipped Elixir is coherence, not
  independent corroboration. The genuinely cross-tier convergences live between these
  Tier-1 designs and the *shipped external* edit-tool practice (Tier-2) — flagged in
  the two harness-excerpt files, not manufactured here.

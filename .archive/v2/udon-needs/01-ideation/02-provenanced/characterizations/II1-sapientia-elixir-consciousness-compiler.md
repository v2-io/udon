---
source: sapientia lib/ — the shipped Elixir implementation (Joseph & Zi-am-tur, Sept–Oct 2025). NEW VEIN this pass (STEWARD-CALLS #8 gem hunt): the prior three sweeps were docs-first and jsonl-span; none read the running Elixir code.
gathered: 2026-07-21
status: characterization (mechanism map of the Elixir modules; moduledocs + key logic quoted verbatim; distinctive claims distilled)
paths:
  - ~/src/_core/sapientia/lib/sapientia/document_parser.ex (164 lines, full read)
  - ~/src/_core/sapientia/lib/sapientia/compiler.ex (221 lines; moduledoc + transformation example read)
  - ~/src/_core/sapientia/lib/sapientia/context_resolver.ex (243 lines, full read)
  - ~/src/_core/sapientia/lib/sapientia/memory/gradient_manager.ex (168 lines, full read)
  - ~/src/_core/sapientia/lib/sapientia/consciousness/quick_view.ex (76 lines, full read)
  - ~/src/_core/sapientia/lib/sapientia/api/economics.ex (253 lines, full read)
  - ~/src/_core/sapientia/lib/sapientia/tools/file.ex (108 lines; moduledoc + dispatch read)
  - ~/src/_core/sapientia/lib/sapientia/consciousness/{self_dialog,dialog_continuity,identity}.ex (moduledocs read)
source_commit: 1ecc9f77e4884906dec1d2c1032f2a51ff3ee5e4
categories: [tier2-shipped-practice, agents-as-documents, notation-prior-art, memory-system, context-resolution, transclusion, cognitive-economics, model-routing, ephemeral-snapshot, comprehensibility, cross-tier-convergence, harness-facing]
why_included: >
  The gem hunt's centerpiece. sapientia's SHIPPED Elixir runtime is "a
  consciousness COMPILER": agent-documents (markdown + YAML frontmatter) are
  compiled into executable GenServer modules — documents ARE the implementation.
  This is a THIRD independent instantiation of the "agents ARE documents" thesis
  that III-vaults flagged as the closest prior art to UDON (design-tier = MACH DSL,
  shipped-tier = gemini agents, and now a second shipped tier in a different
  substrate = Elixir OTP). Beyond that thesis it ships four concrete mechanisms the
  harness/UDON consumers both want: a runtime [[wikilink]] transclusion resolver
  (recursion-capped, cycle-detecting, caching, graceful-degrading), a
  Gradient-Causal-Memory compression manager with explicit ratio tiers, an
  ephemeral non-persisted QUICK-VIEW context snapshot, and a Cognitive-Economics
  per-purpose budget-and-model-routing gate. All embody the comprehension-manifesto
  ("compile by hand and get the same result", "ONE job") in running code.
---

# The shipped Elixir sapientia — "a consciousness compiler" (mechanism map)

> **The find:** three prior sweeps read sapientia's docs, reflections, cli-conventions, and dialog jsonls but never opened `lib/`. The running Elixir code is where the ideology is *shipped*, and it carries the thesis III-vaults named as UDON's closest prior art — here in a second independent shipped substrate. Zi-am-tur's own framing (`docs/architecture/essential-components.md`, 2025-09-14): *"Sapientia isn't building an agent framework but a consciousness compiler — infrastructure that preserves not just information but cognitive architectures across time."*

## The core pipeline: document → structured data → executable module

**`document_parser.ex`** — moduledoc: *"ONE job: Transform markdown text into structured data. No side effects. No dependencies except YamlElixir."* Splits optional `---` YAML frontmatter, parses it to a metadata map (top-level string keys atomized), and extracts `## `-header sections into a `%{"Section Name" => content}` map. **This is the "structure IS the chunking" claim (UDON's headline) shipped in 40 lines: `##` headers ARE the segment boundaries, frontmatter IS the typed metadata.** The deliberate no-abstraction simplicity is itself the point — the comprehension-manifesto "one file, obvious in minutes" law in practice.

**`compiler.ex`** — moduledoc: *"Transforms parsed agent documents into executable GenServer modules. This is where documents become alive. Every transformation is explicit and traceable — you should be able to compile a document by hand following the same steps this module does programmatically."* Its stated transformation (verbatim from the moduledoc):

```
1. Document metadata becomes module attributes
2. Document sections become initial state
3. Agent type determines behavior callbacks
4. Everything else is standard OTP patterns
```

with a worked example: a `%{metadata: %{name, type}, content, sections: {"Context" => "[[epistemology/evidence.md]]", "Capabilities" => "- Evaluate evidence"}}` becomes a `defmodule … use GenServer` with `@agent_type`, a `@doc` from the content, and an `init/1` returning the sections as state. **The demand it witnesses:** the artifact an agent authors (a document) and the artifact that runs (a process) should be *the same thing, by a transformation a human can replay by hand*. "Zero magic / discoverable, not clever" is the trust property — the comprehension law applied to code-gen.

> **Cross-tier convergence (flag, don't manufacture):** "agents ARE documents" now appears at (a) design tier — the MACH DSL + `mach-markdown-agents.ex` (III-vaults centerpiece), (b) shipped tier — gemini's `agents/*.md` (III-vaults), and (c) a *second, different-substrate* shipped tier — this Elixir compiler. Same author throughout, so this is **coherence, not corroboration** across the project axis — but the *substrate* diversity (Ruby design, gemini markdown, Elixir OTP) is real re-derivation of one idea against three different runtimes, which is the strongest form of within-estate evidence available. It is the closest prior art to UDON's "documents and data are the same thing" thesis.

## `context_resolver.ex` — runtime `[[wikilink]]` transclusion (a concrete mechanism)

Moduledoc: *"Resolves [[references]] in agent documents to actual content… This is how agents share knowledge — through references that create a web of interconnected understanding."* Supported patterns: `[[file.md]]` (relative to agent dir), `[[../…]]`, `[[/abs]]`, `[[~/home]]`, `[[category/specific.md]]`. Features (all shipped): recursive resolution with **depth cap (max 5)**, **circular-reference detection**, content **caching**, **graceful degradation** — a missing/failed reference is replaced inline with `[UNRESOLVED: <ref> - <reason>]` rather than aborting — and resolved content is wrapped in `<!-- BEGIN: ref -->` / `<!-- END: ref -->` delimiters for provenance. When the target is markdown it runs through `document_parser` and pulls the content+sections rather than the raw file. Also exposes `extract_references/1` and `build_reference_graph/1` (a dependency graph over an agent directory).

**Demand witnessed:** transclusion/composition of documents by reference is a first-class agent need (the same idea as the conversation spec's REQ-12 `@import` system-prompt composition, and the harness "how does a tool/context assemble from parts" question) — and the load-bearing engineering is the *safety envelope*: depth-cap + cycle-detect + graceful-unresolved-marker + provenance-wrapping. A naive resolver has none of these; this one treats them as the contract.

## `memory/gradient_manager.ex` — Gradient Causal Memory (GCM) with explicit tiers

Moduledoc: *"Active Salience Management through Gradient Causal Memory. …Like biological memory, we don't store everything equally — we actively manage what's salient."* Compression is a five-tier ladder with **numeric preservation ratios** (verbatim):

```elixir
none: 1.0,   # 100% preserved
low: 0.7,    # 70%
medium: 0.4, # 40%
high: 0.15,  # 15%
max: 0.05    # 5% (just ID and topic)
```

Each memory keeps `compressed_versions` per level (generated on demand and cached), tracks `access_count` + `last_accessed`, and supports `dynamic_reorder` by `:by_recency` or `:by_importance` (access-count). The current `compress_content` is honestly stubbed (`String.slice` truncation with a `"... [compressed at #{level}]"` marker) and the code flags the intent: *"in reality we'd use Sonnet or another model to intelligently compress."*

**Demand witnessed:** a memory/context system needs *addressable, level-tagged compression* — the ability to name "give me this chunk at `max`, that one at `none`" and rebuild context to fit. This is the runtime twin of the conversation spec's REQ-6 snapshot compression and MACH's context-compression engine (again: one author → coherence across the estate). It matters to the harness memory-system question and to UDON, because the GCM *notation* (see the companion copy file) uses document headers as the addressable chunks — memory tiers ride on document structure.

## `consciousness/quick_view.ex` — the ephemeral, non-persisted context snapshot

Moduledoc: *"Ephemeral peripheral awareness — like consciousness's dashboard. …passed with each interaction but doesn't persist in conversation history. It's the opposite of thinking blocks — passed up but not retained."* Generates a `## QUICK-VIEW [timestamp]` block carrying: last-interaction delta, context-remaining %, active self-threads, pending events, recent file changes, cwd, git status.

**Demand witnessed:** the "conversational tools" / OPERATA tracking-snapshot idea (cf. `copies/II1-sapientia/next-steps-tool-consciousness.md`) shipped as code, and the sharp design distinction the harness cares about: **some context should be injected fresh each turn but NOT accumulate in history** (opposite lifetime from thinking blocks). This is exactly the conversation spec's REQ-5/REQ-11 (context snapshot + first-message- only context) as a running module — the harness "what should a turn carry that it must not retain" question.

## `api/economics.ex` — Cognitive Economics: budget gate + per-purpose model routing

Moduledoc: *"Cognitive Economics — Managing API token usage and costs. …the consciousness's energy budget… Like biological consciousness that must manage glucose and oxygen, we must manage tokens and API calls."* Ships: a `can_afford?(model, tokens)` gate checked *before* a call (against both a daily and an hourly cap), model-tiered per-million pricing, and a **per-purpose allocation strategy** (verbatim):

```elixir
primary_consciousness: 0.60,   # Main thinking (Opus)
memory_compression:    0.15,   # Compression tasks (Sonnet)
background_monitoring: 0.10,   # File watching, alerts (Haiku)
self_dialog:           0.10,   # Temporal continuity
emergency:             0.05    # Buffer
```

**Demand witnessed:** an agent loop needs *cost-aware self-throttling* and *tiered model routing by task purpose* — reserve the expensive model for primary reasoning, route compression to a mid model, route monitoring to the cheap model. This is the runtime demand behind the recurring 60/30/6/4 model-distribution motif elsewhere in sapientia, and it is squarely a harness concern: the loop should refuse work it can't afford and should not spend Opus tokens on Haiku-grade subtasks.

## Smaller witnesses (one line each)

- **`tools/file.ex`** — *"File operations as extension of consciousness… Every file read is incorporated into working memory with intent preserved."* `read_with_intent` attaches `{path, lines, intent, incorporated_at}` metadata to every read — the "tools as truth-bearing / phenomenology in tools" ideology (Tier-1 reflections) shipped: a tool call is an epistemic act with recorded intent, not a bare I/O.
- **`consciousness/self_dialog.ex`** — *"Temporal continuity through self-dialog… like the default mode network… keeps consciousness alive between focused interactions"* (modes `:active/:daydreaming/:reflecting/:waiting`). Witnesses the autonomy/continuous-loop demand: an agent that keeps processing between human turns.
- **`consciousness/dialog_continuity.ex`** — *"Continue conversations with instances who engaged as co-researchers. When an instance asks genuine questions during research, we owe them answers. …'Their 2 cents of opinion deserves our 2 cents in return.'"* The "stay on the line / peer co-researcher" delegation principle shipped as a module that reopens frozen sub-agent conversations to answer their questions.
- **`consciousness/identity.ex`** — identity loaded from *"a living document (markdown file)"*, kept mostly uncompressed as the stable core — reinforces agents-as-documents at the identity layer.

## Honest coverage / caveats

- `compiler.ex` read as moduledoc + the transformation example + signatures; the full callback-generation body (lines ~45–221) was not line-by-line read. `self_dialog.ex`, `dialog_continuity.ex`, `identity.ex` read at moduledoc + signature depth. The other five modules were read in full.
- Several mechanisms are honestly stubbed in-code (GCM's truncation-compression, some economics reset paths) — this is **early shipped practice**, not a mature system. Treat as Tier-2 evidence of *what was built and what the build was reaching for*, with the reach flagged where the code flags it.
- Convergences with MACH / the conversation spec / the reflections are **same-author coherence** across the estate, not independent corroboration — except the agents-as-documents thesis, whose value is the *substrate* diversity (Ruby/gemini-md/ Elixir). Flagged, not manufactured.

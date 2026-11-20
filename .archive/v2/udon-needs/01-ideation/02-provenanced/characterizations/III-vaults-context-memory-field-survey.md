---
source: >
  Characterization of the vault's large 2025 field-survey reports (multi-agent
  orchestration, RAG, agent-framework landscape). These are broad third-party/
  synthesized surveys Joseph gathered as research substrate, not his own design
  writing — so the extraction is the demand-bearing FINDINGS that bear on agent
  tooling, not a summary of the whole (much of which is enterprise-market and
  framework-comparison generic that "restates what the field already carries").
gathered: 2026-07-21
status: characterization — findings pull + cross-tier flags; not authoritative
paths:
  - ~/vaults/multi_agent_practices_2025.md                    # (2961 lines)
  - ~/vaults/clean_split/*.md                                 # (13 per-topic splits of the above + Obsidian index)
  - ~/vaults/RAG/comprehensive-rag-implementation-guide.md    # (63 KB)
  - ~/vaults/RAG/multistage-rag-report.md                     # (19 KB)
  - ~/vaults/RAG/{rag-glossary,_rag_conversation_summary}.md
  - ~/vaults/earlier-unsorted/agentic-coding.md               # (+ agentic-coding-2.md variant)
source_commit: source_mtime 2025-08-20/21 (vault is not a git repo)
categories: [tier-fieldknowledge, context-management, memory-mechanisms, file-as-memory, context-compaction, mcp-tool-integration, orchestrator-worker, rag-chunking, self-chunking, framework-landscape, cross-tier-convergence]
why_included: >
  These surveys locate the field's Aug-2025 frontier on the exact tool-design
  problems UDON and the harness address: externalized memory, context compaction,
  tool-integration standards (MCP), sub-agent orchestration, and retrieval
  chunking. Two findings are genuine external (non-Joseph) witnesses that
  triangulate with shipped practice — the highest-value content here — and are
  called out below. The framework-landscape and enterprise-deployment material is
  registered as context, not mined deeply.
---

# Context, memory, and retrieval — the Aug-2025 field frontier (vault field-survey)

**Witness question.** What do these surveys witness about what agents need from their tools? A consistent answer: agents need **externalized, document-shaped memory and context** — the context window is not enough, and files/documents are where cognition gets offloaded, compacted, retrieved, and shared. Every mechanism below is a document/tool problem UDON or the harness inherits.

## 1. `multi_agent_practices_2025.md` + `clean_split/` — orchestration & memory survey

A broad "Best Practices 2025" survey (executive summary, glossary, ~15 topic sections; the `clean_split/` dir is the same report chopped per-topic with an Obsidian `[[wikilink]]` index — cleaner to mine; a dup copy also lives at `gemini/foundation/multi-agent-systems/`, skip). Most of it (market sizing — "$2.58B→$24.50B by 2030"; AutoGen/CrewAI/LangGraph comparison; enterprise deployment case studies; benchmark headline numbers) is field-survey context. The **tool-design-relevant deposits**:

- **★ File-System-as-Memory (Manus AI, the "todo.md pattern") — external witness.** The survey's strongest finding: Manus AI (March 2025, SOTA on GAIA) treats "the file system not as passive storage but as active, persistent, directly operable memory that agents manipulate through natural file operations" — *"externalized cognition."* Its famous `todo.md` technique exploits transformer **recency bias**: "By constantly rewriting the todo list, Manus is reciting its objectives into the end of the context. This pushes the global plan into the model's recent attention span, avoiding 'lost-in-the-middle' issues and reducing goal misalignment" (a typical task = ~50 tool calls). This is a **cross-tier convergence** with the shipped Claude Code TodoWrite contract and the cognitive-tools analysis (see `copies/III-vaults/todowrite-cognitive-scaffolding-excerpt.md`): three independent vantage points — a non-Anthropic field system (Manus), Anthropic's shipped tool, and a third-party analysis — all land on *the maintained document IS the agent's working memory / attention anchor.* That is UDON's demand-side case for an agent-facing document format, made by the field, not by Joseph.

- **Semantic context compaction.** "Modern context compression goes beyond simple truncation to implement semantically-aware compression that preserves decision- relevant information": relevance-scoring, different strategies for facts vs. reasoning vs. interactions, lossless-vs-lossy by criticality, restoration metadata, "maintain sufficient detail for accountability and debugging." A demand for structure-aware, reconstructable compression — adjacent to UDON's self-segmenting / structure-is-the-chunking claim.

- **MCP as the tool-integration standard** ("13,000+ servers"): the survey frames Model Context Protocol as the interoperability layer — context for why the two claude-tools artifacts here center on MCP.

- **Sub-agents & handoff, orchestrator-worker** ("5.76x faster execution"): dynamic spawning, handoff protocols, isolated contexts — the topology the gemini 7-agent system (see lineage characterization) instantiates.

- **Embedded research-session residue** (lines ~2100-2142): a live "Current Research Objectives / Knowledge Accumulated This Session / Questions for Further Investigation / Context for Next Session" block — an artifact of the agent that BUILT this report using file-as-memory to survive across sessions. Minor, but a self-referential witness of the very pattern.

## 2. RAG guides — the chunking pain UDON positions against

`comprehensive-rag-implementation-guide.md` (full build guide) + `multistage-rag- report.md` (query-routing, "Reasoning Agentic RAG," reranking/cross-encoders, pgvector, an Elixir/OTP architecture angle) + glossary + source-conversation. Extraction altitude: these are how-to field knowledge, registered not deep-mined. The **one demand-relevant thread**: they document the heuristic-chunking problem (where to split, sliding windows, chunk-boundary quality, reranking to recover from bad chunks) that UDON's README claims to dissolve ("UDON documents self-segment for retrieval-augmented generation … the author's intent about semantic boundaries is encoded in the structure itself"). So they are the **pain-side evidence** for UDON's self-chunking positioning — worth pairing with `design/positioning.md` (Part I §3) at synthesis, as the problem these guides labor over and UDON claims to pre-empt. (Note: this is a Joseph-selected framing, not a claim the RAG guides themselves make; flagged as inference, not their text.)

## 3. `earlier-unsorted/agentic-coding.md` (+ `-2.md`) — 2025 framework landscape

"The State of AI Agent Building Tools and Development Platforms in 2025": market dynamics, foundational-model agent infra, visual builders, pricing models, a 48+ framework tiered summary table with adoption numbers. Almost entirely orientation/ landscape context — registered as the era's competitive map, not mined for demand signal. Its one use to the compilation: dating what agent-building tooling looked like when Joseph was gathering (mid-2025), i.e. the backdrop against which the "documents-are-agents" bet (lineage characterization) was being made.

## Agreements / divergences with existing 02 material

Formed from the primaries before consulting `syntheses/CONVERGENCES.md` and the tier-2 digest. **Agreement:** the file-as-memory / todo-as-attention convergence reinforces the todo/cognitive-scaffolding thread the compilation already tracks (shipped-harness side). **Divergence / addition worth surfacing:** the Manus `todo.md` finding is a genuinely *external* (non-Joseph, non-Anthropic) leg of that convergence — most of the corpus is single-author, and the convergence discipline warns that intra-author agreement is only coherence; this one is real cross-source triangulation and should be weighted accordingly by phase-2. The RAG-guides-as- UDON-self-chunking-evidence pairing is my inference, not asserted by the sources — flagged as such so synthesis can accept or drop it deliberately.

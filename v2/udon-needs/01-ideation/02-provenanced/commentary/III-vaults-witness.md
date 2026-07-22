---
source: >
  Witness lines for Part III ~/vaults/** rows whose signal is one-to-a-few
  sentences (existence/shape is the evidence), plus pointers to the copies/
  characterizations where a row got fuller treatment. The vault is a
  pre-sapientia research burst (Aug 2025); non-git, so pins are source_mtime.
gathered: 2026-07-21
status: commentary — witness lines; not authoritative
paths:
  - ~/vaults/**
source_commit: source_mtime Aug 2025 (vault is not a git repo; ~/vaults/gemini subtree is git f8a6ec99a9749f3fce763c6bdb9cb95a75ca8496)
categories: [tier1-ideology, tier2-shipped-practice, agent-tooling, witness]
why_included: coverage-legible witness for the rows that resolved short.
---

# Part III — ~/vaults/ witness lines

Rows given full treatment elsewhere (not repeated here): claude-code-tools, gemini agent-defs + CLAUDE.md, MACH markdown-agents + gemini methodology (→ `characterizations/III-vaults-agents-as-documents-lineage.md`); multi_agent_practices + clean_split + RAG + agentic-coding (→ `characterizations/III-vaults-context-memory-field-survey.md`); claude-tools philosophy, TodoWrite, prompt-engineering rules, truthfulness prompts (→ `copies/III-vaults/*-excerpt.md` and `truthfulness-prompts.md`).

## Cross-model / cross-substrate tool-use

- **`~/vaults/Operations/claude+gemini.md`** (M) — a CLAUDE.md snippet that teaches Claude to shell out to the **Gemini CLI** (`gemini -p`, `--all_files`) for large-codebase analysis that "might exceed context limits." Two witnesses: (1) cross-model delegation as a *tool-use pattern* (one agent invokes another substrate's larger context window as a tool); (2) the **`@`-file/directory inclusion syntax** (`@src/main.py`, `@src/ @tests/`, `@./`) — a document- reference sigil for pulling files into an agent prompt, notable prior art adjacent to UDON's own `@`-embed thinking (`spec/TODO-AUX.md`'s `@{…}` embed; `@`-inert ruling). The context-window-as-binding-constraint here is the same pain the file-as-memory / compaction findings answer.

## Meta-methodology: mining knowledge for agents to consume

- **`~/vaults/research_frontier_synthesis.md`** (M) — "knowledge arbitrage" strategy: systematically find works "containing knowledge not well-represented in LLM training data" (temporal gaps post-2022, cross-domain synthesis blindness, implementation-detail gaps) and feed them via a **Human-as-RAG** workflow (AI-guided discovery → targeted extraction → synthesis). Witness: the demand isn't just tools-for-agents but *curated corpora* as agent substrate — which is what the whole vault, and this very compilation, are.
- **`~/vaults/knowledge_gap_assessment_prompt.md`** (M) — the companion prompt operationalizing the above (a template for scoring a source's LLM-gap value). Same witness, tool-shaped.
- **`~/vaults/conversation AI Agent Knowledge Base Integration.md`** (M, 951 lines) — requirements-gathering conversation for an agent knowledge base (RAG over ~100 books / ~400 papers). Witness: the texture of *specifying* a retrieval system's needs before building — an early demand-elicitation artifact. Not deep-mined (largely a working conversation); registered as requirements texture.

## MACH — further agent-notation design-thinking (extends the lineage)

- **`~/vaults/MACH-old-approaches-to-sapientia/MACH-new-DSL-design.md`** (M) — a proposed "MACH Flow DSL": agents referenced by file (`from: ./agents/ skeptical_analyst.md`), `hot_reload: true`, `trust_decay: 0.02/hour`, per-domain `epistemology:` overrides, `runtime: adaptive`. The design premise — "developers should describe flows of reasoning… like adjusting the course of a river rather than rebuilding a machine" — is the same documents-are-live-config thesis in the lineage characterization, pushed toward a flow/orchestration notation. A design-thinking witness for an agent-orchestration DSL.
- **`~/vaults/MACH-old-approaches-to-sapientia/{MACH-framework-comprehensive,-volume-2,-volume-3}.md`** (M, ~68-70 KB each) + `mach-elixir-dsl.ex`, `hybrid-mach-system.ex`, `epistemological-hybrid-system.ex`, `MACH-discussion-Elixir Multi-Agent DSL Design.md` (54 KB) — a three-volume "Complete Guide to AI Agent Architecture" plus Elixir DSL implementations. Witness: sustained multi-agent-architecture design-thinking predating sapientia; the epistemology-as-first-class-config motif recurs. Registered as the design corpus behind the markdown-agents artifact; not individually mined (supply-heavy, single-author, largely superseded by the shipped gemini system and later ASF theory).

## Agent-facing prompt-template library (M)

- **`~/vaults/Operations/{persona-prompt, prompt-for-further-sapientia-features, marketing-prompt}.md`** (M) — a small library of reusable agent-facing prompt templates (the truthfulness one is excerpted separately as demand text). Witness: prompts treated as durable, versioned artifacts (documents) rather than one-shot strings — the same "the prompt/instruction is a document" motif as the agent-defs. persona-prompt is short (33 lines); the set is registered, not each copied.

## L — framework/epistemic substrate (the "why" layer)

- **`~/vaults/Principles/`, `~/vaults/Operations/__*.md` (framework/epistemology essays), `~/vaults/temporal-software-theory-distilled.md` (795 lines), `~/vaults/gemini/foundation/`** (L) — the design-rationale substrate behind the agent-facing tooling (first principles, epistemological architecture, the A²O² cycle referenced by gemini/CLAUDE.md, temporal-software-theory as the ASF/AAT ancestor). Witness only at this altitude: the agent tools above re-derive against this layer. Note `temporal-software-theory-distilled.md` is the pre-TFT ancestor of the ASF theory tier (the ASF dossier is the authoritative Tier-4 source; this is its archaeology). Mine only if phase-2 needs the rationale layer; otherwise the theory tier already carries it.

## Dry wells (checked, not re-swept — confirming the TARGET-FILES caution)

- `~/vaults/sapientia/` — empty (confirmed).
- `~/vaults/gemini/{elixir-otp,apps}/`, `~/vaults/Operations/images/`, `~/vaults/microlearning/`, `Obsidian-Workflow/`, `earlier-unsorted/` personal files, housekeeping/scratch (`scratch.md`, `TODO-resources.md`, `promissory_note.md`, `Software in use.md`) — corpus/deps/personal/vault-tooling, no agent-tooling demand signal.
- `~/vaults/clean_split/` dup at `gemini/foundation/multi-agent-systems/` — skipped per TARGET-FILES (same content).

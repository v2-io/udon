---
source: >
  Characterization across three ~/vaults artifacts that independently embody the
  "documents ARE the agent config" pattern — the closest prior art to UDON's core
  thesis found in Part III. Read the primary sources first; this report distills
  the mechanism and the cross-tier convergence.
gathered: 2026-07-21
status: characterization — mechanism map + verbatim load-bearing excerpts; not authoritative
paths:
  - ~/vaults/MACH-old-approaches-to-sapientia/mach-markdown-agents.ex        # (whole; 807 lines Elixir)
  - ~/vaults/gemini/agents/*.md                                             # (7 shipped subagent defs)
  - ~/vaults/gemini/methodology/ANALYSIS_OUTPUT_TEMPLATE.md                 # (output contract)
  - ~/vaults/gemini/methodology/analysis_linter.rb                         # (machine enforcement; 39647 bytes)
source_commit: >
  ~/vaults/gemini is git f8a6ec99a9749f3fce763c6bdb9cb95a75ca8496; MACH .ex is
  non-git, source_mtime 2025-08-25 (vault is not a git repo)
categories: [tier1-ideology, tier2-shipped-practice, cross-tier-convergence, agent-as-document, schema-on-agent-output, prior-art-udon-thesis, hot-reload, delegation, output-contract, grammar-constrained-generation]
why_included: >
  This is the single most on-thesis cluster in Part III. Three artifacts, two
  tiers, one author — but the convergence is stronger than same-author coherence
  because one is a DESIGN (Tier-1 ideology, Aug 2025) and two are BUILT AND SHIPPED
  (Tier-2 practice) — and all three land on "an agent is a document: structured
  frontmatter + prose body, validated against a schema." That is UDON v2's demand-
  side thesis ("documents and data are the same thing") re-derived in the agent-
  tooling domain seven-to-eleven months before UDON's 2026 reboot. The compilation's
  highest-value content is cross-tier convergence; this is one, and it points at both
  consumers at once: UDON (the notation for such documents) and the harness (the tool
  that loads, hot-reloads, delegates-to, and validates such agents).
---

# The "agents are documents" lineage — MACH design ↔ gemini shipped ↔ output-contract enforcement

**The witness question answered up front.** What do these artifacts witness about
what agents (and their operators) need from tooling? They witness a convergent
demand for **the agent definition and the document to be the same object** — a
file with structured metadata in frontmatter and natural-language instructions in
the body, that a runtime can parse, index, validate, hot-reload, and delegate to.
Every piece of that (parse / index / validate / hot-reload / delegate) is a tool
requirement, and each recurs across the three artifacts below.

## 1. MACH.MarkdownAgents — the designed prior art (Tier-1 ideology, `mach-markdown-agents.ex`)

An Elixir GenServer system whose entire premise is agents defined in external
markdown files with YAML frontmatter, hot-reloaded on file change. The plumbing
(GenServer/`Code.compile_quoted`/FileSystem watcher) is supply-side and not the
signal; **the design decisions are.** The load-bearing witness, verbatim from the
`AgentDefinition` moduledoc — the shape it reaches for:

```yaml
---
name: MarketAnalyst
version: 2.3.1
expertise:
  - market_analysis
  - trend_forecasting
paradigms:
  rapid_scan:
    when: "task.urgency == 'high' and task.accuracy_requirement < 0.8"
    confidence: 0.85
  deep_analysis:
    when: "task.accuracy_requirement >= 0.9"
    confidence: 0.95
tools:
  - name: web_search
    provider: mcp://search.company.com
memory:
  type: cognitive
  workspace: /var/mach/agents/market_analyst
  retention_days: 30
---

# Market Analyst Agent
I am a specialized market analysis agent focused on providing actionable
market intelligence...
```

Design decisions that are demand signals for a notation + harness:

- **The body is dual-purpose**: "the frontmatter contains structured configuration
  while the markdown body serves as both documentation and agent instructions."
  (This is exactly UDON's "structure and prose coexist naturally.")
- **Agent self-awareness**: the running agent "literally reads its own markdown to
  understand its purpose" — the document is not just config consumed once, it is
  live context the agent references during execution.
- **Hot-reload with safety**: file-change → validate → backup → hot-swap → rollback-
  on-failure. The *validation* step is a schema check on frontmatter
  (`SchemaValidator` requires `name`/`version`/`expertise`; `CompatibilityValidator`
  forbids silently removing a capability; `DependencyValidator` checks referenced
  agents exist). Editing the document is a governed operation — a convergence with
  UDON's tool-mediated-edit / gatekeeper thinking (`design/udon-guarantees.md`).
- **Teams are documents too** (`TeamDefinition`): frontmatter lists members and a
  `workflows:` step-list; hierarchy and coordination pattern (`consensus`,
  `min_agreement: 0.7`) live in the same document genre.
- **Indexing the corpus**: `AgentRegistry` builds `tags`, `capabilities`,
  `dependencies`, `file_index` maps — i.e. the document set is queried by
  capability/tag. (Convergence with UDON's greppable-first-line / `[key]` identity-
  density demand from Part I §5.)

## 2. The gemini "Principled Researcher" — the SAME pattern, shipped (Tier-2 practice)

A real, built 7-agent Claude Code system (`~/vaults/gemini`). Each agent is a
markdown file with frontmatter — but now in the *actually shipped* Claude Code
subagent schema, not a designed one:

```
---
name: research-coordinator
description: MUST BE USED to orchestrate FP-v2.0 multi-agent analysis. Use PROACTIVELY for coordinating…
tools: Read, Write, Edit, Bash, TodoWrite, LS, Grep, Glob, Task
model: sonnet
---
You are the Research Coordinator for the Principled Researcher project…
```

The two exemplars are copied verbatim (`copies/III-vaults/gemini-agent-{research-
coordinator,content-extractor}.md`); the roster and orchestration are copied at
`gemini-CLAUDE-orchestration.md`. The five agents not individually copied
(claim-analyzer, fp-grounding-agent, citation-researcher, quality-validator,
output-formatter) are the same genre. Harness-relevant witnesses:

- **Tool-restriction is frontmatter** — each agent's `tools:` line is an allow-list;
  workers get tighter lists than the coordinator. (A tool-permissioning model
  expressed *in the document*.)
- **Model-tier per agent** — `model: haiku|sonnet|opus` pins cost/capability to role
  in the same metadata block.
- **`description:` is a routing trigger** — "MUST BE USED … Use PROACTIVELY before X"
  is not documentation, it is the dispatch contract the orchestrator reads to decide
  when to delegate. Metadata that *drives control flow*.
- **Hard delegation contract in prose** — the coordinator's body: "YOU ARE FORBIDDEN
  FROM reading EPUB files directly … YOU MUST ALWAYS USE THE TASK TOOL TO DELEGATE."
  The document encodes the multi-agent topology.
- **Structured blocked-state** — every agent carries an Error Escalation Protocol
  with a fixed report format (`## CONTENT EXTRACTION FAILURE REPORT / Status: BLOCKED
  / Blocking Issue / Attempted Solutions / Escalation Level`). This is a first-class
  witness for the harness question "what should a refusal/observation carry": these
  operators felt the need and hand-rolled a schema for it.
- **Honest deprecation** (the brief prizes these): `gemini/CLAUDE.md` line 138 —
  "Agents not working great and currently can't invoke other agents well at all.
  Need to fix it." Lived friction: subagent-invocation reliability was the binding
  constraint of the built system.

## 3. Output-contract enforcement — a machine-checkable schema imposed ON agent output

Where §1–2 make the agent a document, `methodology/` makes the agent's *output* a
validated document. `ANALYSIS_OUTPUT_TEMPLATE.md` defines a "hybrid XML boundaries +
Markdown content" structure ("for optimal human readability AND agent parsing" —
both consumers, stated) with required sections; `analysis_linter.rb` (a 39 KB Ruby
program, `VERSION = '2.0.0'`) enforces it. The linter is a strong, specific witness:

- **Required sections + minimum lengths** — `REQUIRED_SECTIONS` (13 named blocks),
  `MIN_SECTION_LENGTHS` (e.g. `empirical_validation => 600` chars) to reject
  superficial output. A structural conformance gate on generated text.
- **A hallucination blocklist** — `HALLUCINATED_PRINCIPLES = ['FP-014', … 'Bus
  Factor', 'Coordination Overhead', …]`: enumerated things "agents sometimes invent,"
  detected and rejected. The tool encodes *known agent failure modes* as lint rules.
- **Controlled vocabularies** — `VALID_SOURCE_TYPES`, `VALID_AUTHORITY_TIERS`,
  `VALID_FIRST_PRINCIPLES` (exactly FP-001..FP-013, "never invent others").

This is grammar-constrained-generation's demand stated from the practice side: the
operators could not trust free-form agent output, so they built a validator and made
passing it a **quality gate** ("All analyses must pass linter validation … All
linter warnings must be reviewed"). It converges directly with UDON's
`GRAMMAR-CONSTRAINED-GENERATION.md` and schema-validation lanes (Part I §3) — theory
(guaranteed-valid generation) ↔ practice (bolt a Ruby linter on and gate the loop).

## The convergence, stated as demand (for the phase-2 synthesizers)

Three artifacts, one demand with several facets, each a tool requirement:

| Facet | MACH (design) | gemini (shipped) | linter (enforcement) | UDON/harness answer |
|---|---|---|---|---|
| Agent = frontmatter + prose body | ✓ | ✓ | — | UDON: structure+prose in one doc |
| Metadata drives control flow | `paradigms.when`, `tools` | `description`, `tools`, `model` | — | typed attributes as dispatch contract |
| Corpus indexed by capability/tag | `AgentRegistry` | roster in CLAUDE.md | — | greppable identity keys (Part I §5) |
| Editing the doc is governed | validate→backup→hot-swap→rollback | (CLAUDE↔STATUS sync rule) | lint gate on output | tool-mediated edit / gatekeeper |
| Output is a validated document | `SchemaValidator` on frontmatter | fixed failure-report format | required sections, blocklist, vocab | grammar-constrained generation |
| Blocked/refusal has a shape | `{:error, reason}` tuples | `## FAILURE REPORT` format | hard-reject vs warning | what an observation/refusal carries |

**Caveat (Tier-2 lineage, honest):** MACH and gemini share one author, so their
agreement is coherence, not independent corroboration — but the split across a
*designed-and-not-run* system and a *built-and-shipped-and-partly-broken* one, plus
the fact that gemini uses Anthropic's externally-defined Claude Code subagent schema
(not a shape Joseph invented), makes this stronger than intra-author echo. The
genuinely independent leg is the shipped Claude Code schema itself (see the verbatim
tool contract in `copies/III-vaults/claude-code-tools-systemprompt.md`), whose Task-
tool framing of stateless-subagent delegation these agents are built on top of.

## Agreements / divergences with existing 02 material

I formed the above from the primary sources before reading `syntheses/CONVERGENCES.md`.
On cross-check: this lineage is a **new cross-tier cluster** for the vaults substrate —
the harness-invivo digest and CONVERGENCES focus on the 2026 shipping harnesses and the
UDON repo; the Aug-2025 vault's "agents-as-markdown-documents" prior art (MACH + the
built gemini system) is upstream of all of them in time and is not, as of this write,
represented as its own cluster there. **Surfacing it as a divergence-worth-noting:** if
phase-2 is dating the emergence of the documents-are-agent-config idea in Joseph's
programme, this Aug-2025 vault is the earliest concrete instance found in Part III, and
it predates the UDON reboot by ~11 months. No contradiction with existing syntheses;
an addition to their timeline.

---
source: rowan (Ruby port of Ash) — docs/exp/documentation-tool-research-and-comparison.md
  + docs/msc/starlight-spike.md
gathered: 2026-07-21
status: gathered — partial excerpts from two rowan docs. The doc-tool comparison is ~322
  lines / 38KB (survey of RDoc/YARD/Docusaurus/Astro Starlight); only its dual-audience
  *thesis* and the llms.txt/concatenated-markdown mechanics are copied — the Ruby-specific
  pipeline (YARD extraction, CI stages, hosting) is elided as rowan tooling choices.
paths:
  - /Users/josephwecker-v2/src/rowan/docs/exp/documentation-tool-research-and-comparison.md:1-181
  - /Users/josephwecker-v2/src/rowan/docs/msc/starlight-spike.md:1-49
source_commit: 0ecf61a
categories: [tier1-ideology, dual-audience, agent-as-consumer, documentation-format,
  llms-txt, token-efficiency, structured-plaintext, self-chunking-adjacent]
why_included: >
  Dec 2025. DIVERGENCE FROM THE TARGET-FILES MAP, surfaced deliberately: the row rated these
  L and "rowan-specific documentation choices, not agent-tool ideology — mention only." On
  reading the primary source, the doc-tool comparison's framing chapter is squarely
  agent-tooling ideology — it names, in its own vocabulary, the exact demand-side thesis this
  compilation exists to evidence: the "Dual-Audience" split between human aesthetic consumption
  and the "Agentic Consumer," the claim that legacy HTML docs are "actively hostile to this new
  consumer," that "agents thrive on explicit schema," and the llms.txt / concatenated-markdown
  answer. That it arrives independently, in a Ruby-docs context by a different research pass, is
  cross-context re-derivation of UDON's own self-chunking / structured-plaintext pitch — the
  kind of restatement-across-contexts the Brief explicitly wants. Kept as a copy, not a mention.
---

> **Editorial + divergence note.** The map said "mention only." I disagree after reading:
> the *framing* of both files is on-target agent-tooling ideology, and I've copied the
> load-bearing spans. What I left behind (the YARD-vs-RDoc extraction plumbing, the CI/CD
> pipeline stages, GitHub-Pages hosting) genuinely *is* rowan-specific and out of scope — so
> the map wasn't wrong about the bulk, only about the framing chapters. Surfacing the
> divergence rather than reconciling it, per the extraction method for CHARACTERIZE-adjacent
> rows.

---

# The Dual-Audience Documentation Architecture (rowan, Dec 2025)

## The thesis (verbatim, condensed)

> The contemporary software landscape has bifurcated the consumption model. We have entered
> the era of "Dual-Audience Documentation" … serving two distinct masters with diametrically
> opposed requirements. The first master is the modern human developer, whose expectations for
> UX have been elevated by high-fidelity interfaces … "thoughtful and beautiful display."
>
> The second, and increasingly critical, master is the **"Agentic Consumer" — Large Language
> Models and autonomous software agents.** Unlike the human user, the agent is indifferent to
> CSS transitions, responsive grids, or color theory. **It requires high-density, semantically
> structured plaintext. It demands token efficiency, logical concatenation of disparate
> concepts, and standard discovery protocols like llms.txt.** The traditional HTML outputs of
> legacy tools, laden with navigational markup and presentational clutter, are **actively
> hostile to this new consumer, introducing noise that degrades the context window and
> hallucinatory potential of AI models.**

> For an agentic workflow, [unstructured comment parsing] is a significant liability. **Agents
> thrive on explicit schema; they perform better when told "This text is a parameter
> description" rather than "This text is part of a comment block."** [Legacy] output often
> conflates these distinct semantic elements into a single HTML blob, obscuring the structure
> needed for high-quality llms.txt generation.

> **Fragmentation is Fatal:** If documentation is split across 100 small files, an agent (using
> RAG) might only retrieve 5 of them, missing critical context about how Class A inherits from
> Class B.

## The mechanics named (verbatim, condensed)

**The llms.txt Standard** — "the robots.txt for the AI era." Serves discovery ("I exist, and
here is what I am") + concatenation (points to **llms-full.txt**, the *entirety* of the docs in
a single concatenated Markdown stream).

**Concatenated Markdown Architecture** — lets an agent ingest the entire library in one pass,
enabling "global reasoning" — the agent can relate a config option in Module X to a runtime
behavior in Class Y because both are present in the same context window. Delimiter guidance:
XML-style tags or clear headers (`# FILE: … / # END FILE`) so the agent can distinguish file
boundaries within the concatenated stream.

*(Elided: the Ruby-specific "Stellar Ruby" pipeline — YARD extraction, Astro/Docusaurus build,
GitHub-Pages deploy — as rowan tooling choices.)*

---

# Starlight Spike — the dual-output restatement (rowan, 2025-12-05)

Same thesis, stated as an architecture decision:

> Archema documentation needs to serve multiple audiences:
> 1. **Humans** — beautiful, navigable docs with search, dark mode, code highlighting
> 2. **Agents** — structured, machine-parseable content (markdown, YAML, JSON)
> 3. **Maintainers** — single source of truth that generates both

**Dual-Output Architecture** — one source (MDX/YAML) emits both the human HTML site *and*
machine-readable artifacts for agent consumption:
```
Source (MDX/YAML)
  ├──► Starlight HTML (human consumption)
  └──► Static exports (agent consumption)
       ├── /api/lexicon.yaml
       ├── /api/lexicon.json
       ├── /api/resources/*.json   (tool definitions)
       └── /api/docs.json          (full docs as structured data)
```

> **Compilation note.** This "one source → human view + agent view" split is the same shape
> UDON pitches at the *document* level (structure that is simultaneously prose-readable and
> machine-structured, self-chunking for RAG). Here it appears at the *docs-site* level,
> independently derived. A cross-context echo worth the synthesizers noting when they build the
> master thesis's "structured-plaintext for the agentic consumer" cluster.

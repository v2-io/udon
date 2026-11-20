---
source: /deep-research commission 2026-07-21 — external agentic-tooling landscape (8 areas), adversarially verified (3-vote per claim)
gathered: 2026-07-21
status: synthesis — EXTERNAL evidence tier (Tier 5: published research + shipped practice outside the estate). Vote counts and confidence per claim; follow the links before load-bearing use.
categories: [external-evidence, aci, edit-formats, structured-output, notation, memory-context, schema-guard, mcp, failure-modes]
why_included: >
  The triangulation tier the internal corpus could not provide: independent
  of the estate single-author caveat AND of the harness-lineage caveat.
  Contrarian findings deliberately sought and kept.
---

# External evidence — agentic tooling demand & research (mid-2024 → 2026-07)

## Synthesis summary

The external evidence base strongly supports agent-first interface design: SWE-agent (NeurIPS 2024) established empirically that LM agents are a distinct user category whose performance changes measurably with interface design, and 2026 work extends this into edit-format evidence (line-number diffs catastrophically fail; structure-aware diffs match or beat whole-file at >30% lower cost) and vendor practice (OpenAI's custom V4A apply_patch grammar). Contrarian findings matter for the notation/harness program: structured function-calling modes produce a different, sometimes worse error profile than free-text prompting (BFCL: ~77.5 vs ~21 incorrect calls in the multiple-call category), and small-model failures split ~68% omission / ~32% malformed calls attributed to insufficient schema grounding — supporting schema-guarded design but cautioning against assuming structure alone fixes reliability. Failure-mode studies converge on non-linear compounding with task length, non-composing sub-skills, family-specific (not scale-explained) tool discipline, and a distinctive 'fail-plausible' mode where errors become confident false output that tests never catch ex-ante. The MCP ecosystem's first fault taxonomy shows configuration and schema-serialization mismatches dominate real-world tool failures, with unbounded response size (5K→250K token inflation) as a documented cost hazard — direct demand evidence for bounded, schema-checked, agent-legible formats.

## Verified findings

### 1. [high confidence · vote 3-0 x3]

LM agents are a distinct user category: purpose-built agent-computer interfaces measurably improve performance over human-oriented interfaces. SWE-agent's ACI (compact file viewer, guarded edits, concise feedback) achieved 12.5% SWE-bench / 87.7% HumanEvalFix pass@1, far exceeding prior non-interactive SOTA, with ablations showing each ACI design choice changes behavior and solve rate.

*Evidence note:* Peer-reviewed (NeurIPS 2024) primary source; three unanimous 3-0 verified claims merged (thesis, headline numbers, ablation evidence). Numbers are 2024-era but the design finding has been reinforced by subsequent practice, not superseded.

- https://arxiv.org/abs/2405.15793

### 2. [high confidence · vote 3-0 x6, plus one 3-0]

Edit-representation evidence converges: diff-style formats are far more token-efficient than whole-file rewrites, but reliability is the binding constraint — aider measures edit-format compliance separately from correctness and defaults unfamiliar models to whole-file as the easiest format to emit; number-indexed line diffs catastrophically underperform (MinUniDiff 14.07% vs FullCode 57.07% pass@1, 7B model); structure-aware diffs close the gap (FuncDiff 70.88% vs 69.38% on EditEval) and adaptive format selection (AdaEdit) cuts latency/cost >30% on long code at accuracy parity. OpenAI ships apply_patch using a custom V4A structured-diff format rather than str-replace or unified diffs.

*Evidence note:* Seven unanimous verified claims merged across three independent source types (benchmark maintainer, peer research, vendor shipped tool). Caveats: the 14%/57% and 70.88% figures are from fine-tuned Qwen2.5-Coder-7B, not frontier models; aider's old edit leaderboard is superseded by polyglot; FuncDiff margin is thin (1.5pt, single cell).

- https://aider.chat/docs/leaderboards/edit.html
- https://arxiv.org/html/2604.27296
- https://developers.openai.com/api/docs/guides/tools-apply-patch

### 3. [medium confidence · vote 2-1]

Structured output does not eliminate errors — it changes the error profile. BFCL (ICML 2025) found dedicated function-calling modes produced substantially MORE incorrect calls than free-text prompting in the multiple-function-call category (~77.5 vs ~21 incorrect calls among successfully decoded responses). A contrarian negative result for assuming structured tool-call protocols are strictly more reliable.

*Evidence note:* 2-1 vote; verifier traced the figure to the peer-reviewed BFCL ICML paper and found independent corroboration (MCPVerse arXiv:2508.16260). Scoped to one category and to counts among decoded responses — not an overall error rate.

- https://arxiv.org/pdf/2607.05775
- https://openreview.net/pdf?id=2GmDdhBdDk

### 4. [high confidence · vote 3-0 x3]

Tool-invocation failures split into omission and malformation, with schema grounding implicated: in small open-weight models, ~68% of sampled failures are omission (answering in prose instead of calling the tool) and ~32% malformed calls (wrong tool names, invalid JSON, hallucinated parameters), attributed by the authors to insufficient schema grounding; NoisyToolBench separately shows models fabricate missing required parameters rather than asking clarifying questions, attributed to the next-token-prediction objective. Direct evidence for schema-guarded invocation and clarification-affordance design.

*Evidence note:* Three unanimous claims merged; verbatim quotes verified in primaries. Critical scope caveat: the 68/32 split is from qwen2.5:3b/7b and Functionary-Small only — large models (qwen2.5:32b, GPT-4.1) show ~0% errors in the same study. Attributions are author hypotheses, not isolated causes. A related claim that initialization failure is THE primary bottleneck was refuted 0-3.

- https://arxiv.org/pdf/2601.16280
- https://arxiv.org/pdf/2607.05775
- https://arxiv.org/abs/2409.00557

### 5. [high confidence · vote 3-0 x4]

Agent reliability degrades structurally, not additively: across 27 papers / 19 benchmarks (2023–2026), failures compound non-linearly with task length, sub-skill competence does not compose into end-to-end success, and additional scaffolding does not uniformly help. Tool-use faithfulness is unsaturated (best of 19 models: 86.33% Clean Tool-Use Rate on ToolFailBench), aggregate scores hide distinct failure modes (Tool-Skip, Result-Ignore, Output-Fabrication, Unnecessary-Tool-Use), and tool discipline is model-family-specific rather than scale-explained (Llama-3.1-70B vs Qwen2.5-72B: 89pp gap in control-task accuracy; Llama calls tools on 77.73% of no-tool tasks).

*Evidence note:* Four unanimous verified claims merged; all quotes verified in primaries with independent corroboration (ReliabilityBench pass@k collapse). Caveats: both are July 2026 preprints (not yet peer-reviewed); ToolFailBench is single-author with overlapping CIs among top models; the family comparison uses 2024-era model releases.

- https://arxiv.org/pdf/2607.05775
- https://arxiv.org/pdf/2607.04686

### 6. [medium confidence · vote 3-0 x3]

Production agents fail 'plausibly' and testing infrastructure cannot predict it: in an 8-week production runtime study (22 postmortemed incidents), ~70% of silent failures were caught by a human observing the product as a user and ~none by unit tests; 4,286 tests + 827 governance checks prevented 0 of 15 novel incidents ex-ante though ex-post regression tests blocked 87% of recurrences ('audits are regression engines, not prediction engines'); the distinctive 'fail-plausible' mode transforms internal errors into coherent false output (an HTTP error log synthesized into a confident fabricated analysis).

*Evidence note:* Three unanimous verified claims merged, all verbatim-checked, with independent contemporaneous echoes (arXiv:2606.09863, 2606.09071). Confidence capped at medium because all three rest on a single-system, single-author, non-peer-reviewed case study; the claims are properly scoped to that system.

- https://arxiv.org/html/2606.14589v1

### 7. [high confidence · vote 3-0 x2, 2-1 x1]

First large-scale MCP fault taxonomy (407 labeled issues from 3,282 bug issues across 385 server repos) shows configuration dominates: Server/Tool Configuration 31.74%, Server/Host Configuration 28.64%, Server Setting 27.45%, with Documentation and General Programming under 7% each. Tool Call/Execution is the largest fault subcategory (63/419, ~15%), including schema-serialization mismatch (Pydantic BaseModel wrappers unparseable by many LLM clients, breaking every invocation until explicit fields were exposed). Unbounded tool-response size is a measured shipped hazard: full embedding vectors inflated responses ~5K→250K+ tokens (50x cost); Response Size and Continuation Control faults trigger retry/continuation cascades.

*Evidence note:* Three verified claims merged (two 3-0, one 2-1 on the 'largest subcategory' granularity point); all figures verified against the primary PDF and the embedding case traced to a real GitHub issue. Caveats: v1 preprint from an established SE group (Khomh); scope is Python-SDK MCP servers; GPT-4o-mini used upstream in filtering (F1 0.77) though the taxonomy was manually derived.

- https://arxiv.org/pdf/2603.05637
- https://github.com/getzep/graphiti/issues/610

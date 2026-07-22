---
source: ~/src/_ref/_arch/sar3/{LSP_ENRICHMENT_RESULTS.md, COMPLETION_SUMMARY.md} — the measured output of the enriched Ruby chunker (10 categories of semantic metadata, coverage % over 85 methods, one real sample chunk)
gathered: 2026-07-21
status: gathered (verbatim excerpt of the coverage table + one sample chunk; both source files are ~370-420 lines, remainder = narrative + more samples, not copied)
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/sar3/LSP_ENRICHMENT_RESULTS.md:1-45
  - /Users/josephwecker-v2/src/_ref/_arch/sar3/COMPLETION_SUMMARY.md:1-60
source_commit: (non-git) source_mtime 2025-11-16
categories: [self-chunking, chunk-metadata-payload, rag-embeddings, measured-coverage, agent-memory-context, tier2-shipped-practice]
why_included: >
  The MEASURED counterpart to the aspirational sar3-lsp_chunking_concept.md: run over a
  real 4,491-line agent runtime (minimal-sapientia), the enriched chunker extracted 10
  categories of semantic metadata across 85 methods → 86 chunks, with honest per-category
  coverage (visibility/scope/complexity 100%; callees 98%; callers 93%; param-types 64%;
  instance-vars 58%; symbol-refs 45%). This is what a self-describing unit of context
  ACTUALLY carries in practice, including the honest gaps (return-type + doc extraction
  "when available"). Grounds UDON's README claim that structure yields embed-ready
  semantic units — here is the concrete payload shape and its real coverage numbers,
  measured, not asserted. For the harness consumer: a field-tested schema for a
  retrieval/memory chunk's metadata, with realistic extraction-coverage expectations.
---

> **Editorial.** These two files report the same run from two angles (results vs
> completion summary). Note the substrate is meaningful: the chunker was run over
> `minimal-sapientia.rb` — the 4,491-line agent-runtime that the harness-invivo
> sweep separately characterizes — so this is an agent's-own-codebase being made
> retrievable by structure. The "LSP" framing is partly overstated (see the
> sibling honest post-mortem sar3-AST_VS_LSP_REALITY.md: much of this is Solargraph
> over AST, not full LSP); the coverage numbers below stand regardless of the label.

## Measured metadata coverage (10 categories, 85 methods) — from LSP_ENRICHMENT_RESULTS.md

| Category | Coverage | Value stated |
|---|---|---|
| Visibility (public/private/protected) | 85/85 (100%) | API boundary vs internal |
| Scope (instance vs class) | 85/85 (100%) | `self.` vs instance |
| Rich parameter info (arg/optarg/kwarg/kwoptarg/splat/block) | 54/85 (64%) | signatures beyond names |
| Callers (what calls this) | 79/85 (93%) | usage patterns / entry points |
| Callees (what this calls) | 83/85 (98%) | dependencies / method flow |
| Complexity rating (low→very high, by call count) | 85/85 (100%) | attention-worthy methods |
| Instance-variable tracking | 49/85 (58%) | state dependencies |
| Symbol references | 38/85 (45%) | config keys / event names |
| Return-type inference | (when available) | — |
| Documentation extraction | (when available) | — |

Output artifact: `lsp_chunks.json` — **86 chunks, 3.2 MB**, ready for RAG / semantic
search / doc generation / complexity analysis.

## One real enriched chunk (verbatim, from COMPLETION_SUMMARY.md)

```json
{
  "name": "make_api_call",
  "path": "MinimalSapientia#make_api_call",
  "type": "Method",
  "line_start": 3662,
  "line_end": 3963,
  "line_count": 302,
  "context": "Visibility: private\nScope: instance\nParameters: messages, original_message (optional), retry_count (optional), server_retry_count (optional)\nCalled by: resume_conversation, send_message, make_api_call, handle_tool_use (4 total)\nCalls: now, check_thinking_status, <<, []=, join, ... (64 total)\nComplexity: very high\nUses instance vars: @api_key, @audit_dir, @current_temperature, ...",
  "code": "...",
  "metadata": {
    "visibility": "private",
    "scope": "instance",
    "parameters": [],
    "callers": [],
    "callees": [],
    "complexity": "very high",
    "instance_variables": []
  }
}
```

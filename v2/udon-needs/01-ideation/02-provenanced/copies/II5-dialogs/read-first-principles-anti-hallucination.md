---
source: Claude Code raw transcript (fa2d8124…), sapientia-zi-am-tur-session cache — designing a batch-analysis pipeline's agent/system prompts
gathered: 2026-07-21
status: gathered excerpt (verbatim turns from a 734-line jsonl session; the load-bearing signal is concentrated at :663 + :673/:704, not the whole implementation span)
paths:
  - ~/src/_core/eli-migration-prep/to-review/sapientia-zi-am-tur-session/cc-raw/fa2d8124-850d-4cfc-837e-07560949dbbd.jsonl:663-704
  - "…fa2d8124…jsonl:663 (Joseph's design principle) · :673, :704 (the crystallized anti-hallucination measures)"
source_commit: 6c2b4c036b67aa8bbc58efc008422ac15ecfc523 (eli-migration-prep @ HEAD, 2026-07-21)
categories: [tooling-for-agents, prompt-as-tool, anti-hallucination, first-principles-reading, early-seam, guardrails]
why_included: |
  Early (2025-08-27, pre-September-seam) tooling-for-agents design reasoning, stated as
  a general principle by Joseph and then engineered into a tool's contract: agent
  instructions must be *emphatic about actually reading the full first-principles,
  otherwise the agent hallucinates what it thinks first principles look like*. The rest
  of the span (664–704) is the implementation churn of baking that into a batch prompt —
  low-signal — but the principle at :663 is a durable demand: a tool/harness that hands
  an agent a spec must FORCE (and verify) a genuine read, because the default failure is
  confident reconstruction from generic priors. This is the same failure the UDON
  programme's own AGENTIC-DELEGATION file names ("a title your model expands into a
  confident reconstruction … phenomenologically indistinguishable from having read the
  thing") — an independent, year-earlier statement of it.
---

> **Why gathered.** A load-bearing tooling-for-agents principle stated a year before the
> UDON programme independently re-derived it: instructions/tools that merely *reference*
> a first-principles document get hallucinated reconstructions of it; the fix is to make
> the tool emphatic about — and verify — an actual read. Cross-tier/cross-era echo of
> the same lesson the repo's own delegation discipline carries.

<!-- excerpt fa2d8124…jsonl:663 — Joseph -->
**Joseph (:663):**
> Note how the agent instructions currently are very emphatic about actually reading the
> full first-principles. Otherwise the agent hallucinates what it thinks first principles
> look like.

<!-- excerpt fa2d8124…jsonl:673, :704 — the assistant crystallizing it into the tool's prompt -->
**Assistant (:673, :704) — engineering the principle into the batch tool's contract (verbatim fragments):**
> - "**DO NOT HALLUCINATE** what you think first principles should be"
> - "**ONLY USE** FP-001 through FP-013 as defined in the uploaded document"
> - "Any analysis that uses generic software principles instead of FP-001 through FP-013 is INVALID"
> - Measures: a "STOP sign at the beginning — Forces attention before any work"; "Clear
>   statement that without reading first, analysis is INVALID."

*Design shape distilled: the tool does not trust that a referenced document was read; it
(a) makes the read a gating precondition, (b) names the specific failure (falling back to
generic SOLID/DRY/"separation of concerns" priors), and (c) marks output produced without
the read as INVALID rather than merely lower-quality.*

<!-- provenance note -->
*Span 664–704 is largely Edit/Grep/TodoWrite implementation churn on
`3-compose-production-batch.py`; only the turns above carry design signal. Verified via
`json.loads` of the jsonl, 2026-07-21. (:663 verification also independently logged in the
dialogs.md sweep.)*

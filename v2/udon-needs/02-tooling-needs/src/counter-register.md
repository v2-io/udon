---
slug: counter-register
type: counterposition
evidence: [T2, T3, T5]
status: standing-register (each row carries its own weight)
stage: drafted
consumers: both
depends: [method-evidence-tiers]
sources:
  - ../../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # singletons
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # Part D
  - ../../01-ideation/02-provenanced/syntheses/external-landscape-2026-07.md  # findings 3, 5, 6
  - ../../01-ideation/STEWARD-CALLS.md  # #6
---

# The counter-register: evidence against our own theses

The previous chapter promised that counter-evidence would ride beside the
claims it qualifies rather than sinking into footnotes. This chapter is
that promise kept — a standing register, one row per counter-result, each
naming the thesis it pushes against and how much weight it carries. **A
downstream decision that touches one of these theses should cite the
counter-row, not just the supporting chapter.**

| # | Counter-evidence | Qualifies | Weight |
|---|---|---|---|
| 1 | **Structured notation failed to speed comprehension on one model family.** A 2025 experiment (internally called "sar2") gave agents the same content in an aligned, structured notation and in conventional prose, then measured comprehension: the headline result favored structure dramatically (100% vs 60% immediate comprehension) — but the effect **failed to reproduce on 1 of 4 model families tested**, and that same family processed the structured form *more slowly*. The project's owner ruled it carried as important evidence: confounding factors are suspected in the original, and both the result and its gaps feed any future house-style work and experiment design. | Any "structured notation improves agent comprehension" claim | A single experiment — but the only *measured* test of the thesis anywhere in this report's evidence, so it outranks any amount of design conviction |
| 2 | **Obsidian's deliberate anti-nesting stance.** The most widely deployed notes application chose, on purpose, to forbid nesting and rich markup in its document properties: "properties are meant for small, atomic bits… human and machine readable." That is a considered, shipping counter-position to letting an attribute's value be a whole structure. | UDON's model in which an attribute may hold a full node, not just a scalar | An argument to answer, not wave off: their constraint serves a UI-simplicity goal UDON doesn't share — but the answer should say *why* the goals differ |
| 3 | **Structured output modes do not simply reduce errors.** A public function-calling benchmark (Berkeley's BFCL) found *more* incorrect calls under structured modes than free text in its multiple-call category — structure changed the error *profile* rather than shrinking it. | Any naive "structure improves reliability" claim | Medium confidence (one category, mixed replication) — a scoping discipline, not a refutation of structure |
| 4 | **One prominent tool abandoned JSON tool-call editing.** The aider project's own code contains `RuntimeError("Deprecated")` where edits-as-JSON-function-arguments were tried and killed after models kept mangling the structured arguments. | Any plan to route edits through JSON tool-call arguments | Scoped by row 11: strong *within* the Claude/OpenAI-lineage ecosystem this report mostly samples; not a universal law |
| 5 | **Validation doesn't catch plausible wrongness.** In one closely documented production system, ~70% of silent failures were caught by a human *using* the product and essentially none by its 4,286 tests ("audits are regression engines, not prediction engines") — failures surfaced as confident, well-formed, wrong output. | Any claim that schema or validation layers *catch* agent failure — they catch malformation, not plausible wrongness; this also bounds the [observation-infrastructure chapter](tools-are-observation-infrastructure.md)'s sharpest-possible-signals story: a value can validate perfectly and still be false | Medium (single-system case study) but echoed contemporaneously; human-verification surfaces exist because of exactly this |
| 6 | **One shipping harness treats its own instruction file as untrusted.** kimi-code applies injection-precedence rules to AGENTS.md — a live, security-motivated disagreement with the rest of the ecosystem, which treats such files as trusted instructions. | The instruction-file trust model in the [tool-anatomy chapter](tool-definition-anatomy.md) | Live disagreement, unresolved; security-relevant |
| 7 | **Scaffolding does not uniformly help.** An external survey spanning 27 papers found agent sub-skills failing to compose, improvement failing to compound linearly, and tool discipline varying by model family in ways scale does not explain. | Any "better tooling fixes reliability" framing, and any tool contract assumed to be model-agnostic (the [edit-landscape chapter](edit-representation-landscape.md)'s per-family routing finding is the shipped echo of this) | High confidence, preprint-era caveats noted |
| 8 | **The self-chunking pitch is unmeasured.** UDON's public claim that its structure "self-chunks" for retrieval has no measurement behind it; the nearest experiment (a code-retrieval study, internally "sar3") supports parsing-based chunking *in general*, not this notation's version of it. A claim-or-kill experiment is specified in the [self-chunking chapter](self-chunking-status.md). | The README-level self-chunking pitch | An absence-of-evidence row: the thesis is live, the *claim* is currently over-dressed |
| 9 | **Tools cannot talk back mid-call.** In every transport this report examined, a tool gets one shot — it cannot pause its own execution to ask a clarifying question (a limit that both recorded design discussions and an agent's own self-correction account ran into). Designs that assume interactive confirmation inside a tool call must survive this or state the transport they're assuming. | Any design assuming conversational tools | A realism check; transport-dependent |
| 10 | **A parseable prefix is not a streaming protocol** (dissent entered by a GPT-family reviewer, 2026-07-22). A format whose partial payloads parse honestly still provides no framing, sequencing, cancellation, or multiplexing; newline-delimited JSON solves *transport*, prefix-parsing solves *payload validation*, and neither replaces the other without a protocol experiment nobody has run. | Any "UDON can serve the NDJSON role natively" claim ([headless I/O chapter](headless-io-contract.md), [streaming chapter](streaming-and-partial-documents.md)) | Practitioner-architecture reasoning, no measurement either way; adopted as this report's working framing |
| 11 | **JSON tool-call editing is alive and primary elsewhere** (dissent entered by a Gemini-family reviewer, 2026-07-22). In the Gemini/Antigravity ecosystem, structured tool-call editing with schema validation at the tool layer is the default and it succeeds; the aider abandonment (row 4) reads from there as an artifact of particular model families and eras, not a law about agents. | The [edit-landscape chapter](edit-representation-landscape.md)'s abandonment framing | Materially scopes a shipped-practice conclusion; the first counter-weight in this register from outside the model family that produced most of the report's other evidence |

Rows 1–2 and 8 bear most directly on UDON; rows 3–7 and 9–11 on harness
design; all travel with both consumers. Rows 10 and 11 carry their
reviewer's model family on purpose: nearly everything else in this report
was written, shipped, or lived by one ecosystem, and these two rows are
what evidence from outside it currently looks like.

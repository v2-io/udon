---
slug: invocation-paradigms
type: finding
evidence: [T2, T5]
status: 3-way-convergent (code mode; incl. one official vendor instance) + lineage-annotated shapes
stage: drafted
consumers: harness-primary
depends: [tool-definition-anatomy, context-economy, structured-output-two-mechanisms]
sources:
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C7, C10, Part C code-mode
  - ../../01-ideation/02-provenanced/copies/harness-workshop/ai-cli-tools-source-assessment.md  # §7 convergent innovation
  - ../../01-ideation/02-provenanced/syntheses/external-landscape-2026-07.md  # finding 3
---

# Invocation paradigms: per-call JSON, code mode, and constrained freeform

**Claim.** Three ways for a model to invoke tools now coexist in shipped
practice, and they distribute the reliability burden differently. The
choice among them — like edit formats (#edit-representation-landscape) — is
turning out to be model-conditional and workload-conditional, not a solved
default.

1. **One JSON call per tool per turn** — the installed base. Every schema
   loaded costs context (mitigated by deferred loading, #context-economy);
   every call is a round-trip; arguments arrive as streamed JSON fragments
   the harness must reassemble and guard (C10: five independent
   implementations of tolerant reassembly, including auto-repair of
   unclosed strings). Reliability burden: on the model's schema adherence —
   exactly where T5 found the error profile lives (fabricated parameters,
   omission; #structured-output-two-mechanisms).
2. **Code mode — tools as a callable API in a sandbox.** The model writes a
   small program that calls host tools as functions (opencode: acorn-parsed
   JS sandbox; codex: embedded V8; Anthropic's programmatic-tool-calling is
   the official third instance). The census calls it out as *convergent
   innovation* — two independent implementations plus a vendor — and it is
   the newest paradigm in the corpus. What it buys: orchestration logic
   (loops, conditionals, intermediate variables) moves from N round-trips
   of tool-call ping-pong into one artifact; intermediate results never
   transit the context window. What it costs: the reliability burden moves
   to *program correctness* in a sandbox, and observability of individual
   steps has to be rebuilt (the per-call teaching-refusal channel,
   #errors-that-teach, now fires inside a program run).
3. **Grammar-constrained freeform** — codex's lark-constrained apply_patch:
   the tool input is not JSON at all but a domain grammar the decoder
   cannot violate. The strongest guarantee tier available (malformation
   becomes impossible rather than detected), currently applied only where
   the payoff is highest (edits).

Deferred tool loading (C7, lineage-corrected to ~3 independent arrivals)
cuts across all three: name-only registration with on-demand schema fetch
is what makes large catalogs viable at all.

## What it generates

- **For the harness:** treat the paradigm as a routing decision, not an
  identity — the same census shows grok-build shipping *rival tool suites
  in parallel* to A/B them. The evidence-backed default: per-call JSON for
  sparse tool use, code mode for orchestration-heavy work where
  intermediate results are bulky (its context-economy payoff is exactly
  family-3 pruning without the small model), constrained freeform wherever
  a domain grammar exists and malformation is expensive.
- **For UDON:** two openings. (a) In code mode, tool *results* become
  values in a program, not context text — a format with an honest
  programmatic surface (typed values, stable paths) is more valuable
  there, not less. (b) Constrained freeform is the precedent for
  grammar-constrained *UDON emission* from the descent grammar — the same
  guarantee tier, applied to the notation itself
  (#structured-output-two-mechanisms names the experiment).

## Honest edges

Code mode is new enough that its failure modes are folklore, not data — no
BFCL-equivalent exists for it yet, and the observability regression is my
inference from its structure, not a measured finding. The three-way
"convergence" includes one vendor whose designs the ecosystem demonstrably
copies (lineage discipline applies forward: expect the count to inflate).

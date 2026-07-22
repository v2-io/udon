---
slug: counter-register
type: counterposition
evidence: [T2, T3, T5]
status: standing-register (each row carries its own weight)
stage: drafted
consumers: both
depends: [method-evidence-tiers]
sources:
  - ../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # singletons
  - ../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # Part D
  - ../01-ideation/02-provenanced/syntheses/external-landscape-2026-07.md  # findings 3, 5, 6
  - ../01-ideation/STEWARD-CALLS.md  # #6
---

# The counter-register: evidence against our own theses

Kept as a first-class segment so the monograph cannot quietly firm up its
own caveats. Each row names the thesis it qualifies and where the full
context lives. **A downstream decision that touches one of these theses
should cite the counter-row, not just the supporting segment.**

| # | Counter-evidence | Qualifies | Weight |
|---|---|---|---|
| 1 | **SAR alignment-speed non-reproduction** — the notation-alignment comprehension gain failed to reproduce on 1 of 4 model families, with an honest latency counter-result. Joseph's ruling (SC#6): carry as important evidence; confounds suspected; feeds eventual house-style discussion + experiment methodology. | Any "aligned/structured notation improves agent comprehension" claim | Single experiment, but the corpus's only *measured* internal test of the thesis — outranks any amount of design conviction |
| 2 | **Obsidian's deliberate anti-nesting Properties stance** — no nesting, no markdown-in-properties, *intentionally*: "properties are meant for small, atomic bits… human and machine readable." A widely-deployed, considered counter-position to attribute-values-as-nodes. | UDON's edge-may-terminate-at-a-node model | An argument to answer (their constraint serves a UI/simplicity goal UDON doesn't share — but say why, don't wave it off) |
| 3 | **BFCL: structured modes ≠ fewer errors** — more incorrect calls than free-text in the multiple-call category; error *profile* changes. | Naive "structure improves reliability" | Medium confidence (2-1, one category) — scoping discipline, not refutation of structure |
| 4 | **aider's tool-call editing abandonment** (`Deprecated`) | Any plan to route edits through JSON tool-call arguments | Strong; corroborated by ecosystem-wide absence of the pattern |
| 5 | **Fail-plausible + tests-don't-predict** — ~70% of silent production failures caught by a human *using* the product, ~none by 4,286 tests ex-ante ("audits are regression engines, not prediction engines"); errors become confident false output. | Any claim that schema/validation layers *catch* agent failure (they catch malformation, not plausible wrongness); also qualifies #tools-are-observation-infrastructure's A≈0 story — validity ≠ truth | Medium (single-system case study) but echoed contemporaneously; the harness's human-verification surfaces exist because of exactly this |
| 6 | **kimi-code: AGENTS.md is untrusted data** — injection-precedence rules vs the ecosystem's trusted-instruction consensus. | The instruction-file trust model (#tool-definition-anatomy) | Live disagreement, unresolved; security-relevant |
| 7 | **Non-composing sub-skills / non-linear compounding** (T5, 27 papers): scaffolding does not uniformly help; tool discipline is model-family-specific, not scale-explained. | Any "better tooling fixes reliability" framing; also model-agnostic tool-contract assumptions (#edit-representation-landscape's routing finding is the shipped echo) | High confidence, preprint-era caveats noted |
| 8 | **Self-chunking is unmeasured** for UDON specifically — sar3's pre-test supports parsing-based chunking generally; UDON's own claim has no measurement. Claim-or-kill experiment specified in #self-chunking-status. | The README-level self-chunking pitch | Absence-of-evidence row: the thesis is live, the *claim* is currently over-dressed |
| 9 | **One-shot tool constraint** — tools can't call back mid-execution (dialogs + anamnos): interactive-confirmation and mid-edit-clarification designs must survive this reality or state their transport assumption. | Any design assuming conversational tools | Realism check; transport-dependent |

Rows 1–2 and 8 are UDON-facing; 3–7 and 9 harness-facing; all travel with
both consumers under the BRIEF's say-so-where-they-diverge rule.

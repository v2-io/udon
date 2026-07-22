---
slug: tools-are-observation-infrastructure
type: finding
evidence: [T4, T2, T1]
status: theorem-grade-conditional (T4 core) + cross-tier-convergent (implications)
stage: drafted
consumers: both
depends: [method-evidence-tiers]
sources:
  - ../01-ideation/02-provenanced/syntheses/asf-dossier.md   # §2.1–2.3, §3
  - ../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # clusters 5, 6, 11
  - ../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C5, C11
---

# Tools are an agent's observation infrastructure — and their quality is existential

**Claim.** A tool's outputs are observations; the *ambiguity* of those
observations is the one designer-controllable knob in a theorem-grade law
bounding how much an agent's goals can distort its beliefs. Channel quality
gates adaptation speed regardless of loop speed; below a threshold set by the
environment's drift rate, the agent doesn't work inefficiently — it fails to
persist. "Tool-interface quality" is therefore an existential quantity, not a
throughput or ergonomics quantity.

## The evidence

**T4 (conditional theorems, premises named in the segments cited by the
dossier):**

- **The κ×A bias law** — belief bias in a coupled (LLM) agent is bounded by
  (architectural coupling κ) × (observation ambiguity A). κ ≈ 1 by
  construction for anything logogenic and cannot be engineered away; **A is a
  property of observation design**. The theory's own lever statement: the
  practical move is "not reducing κ … but reducing A: more tests, more
  precise metrics, more structured outputs, less reliance on interpretive
  judgments." Canonical A≈0 observations: a test passing or failing, a
  compiler error with a specific message, a file's existence. Motivated
  reasoning is formalized as the high-κ×high-A corner — ambiguity in an
  agent-facing format is the opening through which goal-conditioned
  distortion enters, not mere friction.
- **Tempo gating** — T = Σ ν·η*, and η* collapses under observation noise:
  *you cannot outrun a bad observation channel by iterating faster.* Worse,
  bad channels *hide miscomprehension* (high noise + spuriously-low model
  uncertainty drives the update gain toward zero: the agent stops updating
  even when wrong). And correlated channels overcount: more telemetry ≠ more
  adaptation; only structurally independent channels sum.
- **Persistence threshold** — T > ρ/‖δ_critical‖. Round-trips-per-orient-step
  set loop tempo; a tool loop too slow for the environment's drift rate is a
  viability failure, not a performance failure.
- **The interventional gate** — every tool call is a do() intervention, and a
  loop earns Pearl Level-2 status only when the tool's action-mechanism is
  known (C3) — which is an *interface property*, established by precise
  action semantics and law-teaching refusals (#errors-that-teach).

**T2 (shipped practice instantiating the same physics, mostly without the
theory):** the ecosystem's converged "prefer dedicated tool over shell
equivalent" tables (7 sources, near-verbatim: Read not cat, Edit not sed —
"keeps raw stdout out of the conversation") are A-reduction in the wild;
the entire context-management subsystem family (#context-economy) is the
DL-budget constraint handled empirically.

**T1:** the agentic-ux principles state the same rules as design ideology —
"tool loop = epistemic organ (deterministic, honest readout)"; "drive
observation ambiguity toward zero (codes, counts, paths — not interpretive
prose in the result channel)." Cross-tier with T4 this is the corpus's
strongest foundations-level convergence; noted honestly: T1 and T4 share an
author, so the load-bearing independence is T4↔T2↔T5, not T1↔T4.

## What it generates

- **For UDON:** a notation whose parse/validation outcomes are sharp (binary,
  typed, located) is a bias-reduction instrument *in a formal sense* — the
  self-describing pitch for schemas turning "does this look right?" into
  pass/fail. Structural validation is a new near-zero-noise, near-zero-cost
  channel added to the agent's Level-2 portfolio at the cheapest tier.
- **For the harness:** channel *independence* matters as much as channel
  count (tests + typecheck + runtime probe genuinely add tempo; three views
  of one state don't); and there is a runnable eval here — the dossier's
  operational estimator for A (probe the same observation under multiple
  goal-primings, measure interpretation divergence) has apparently never
  been run on a real format. A candidate experiment for either consumer.

## Honest edges

The T4 results are conditional (named sub-scopes; the dossier carries them);
the persistence framing transfers to real harnesses only insofar as "drift"
is meaningful for the task environment. Nothing here says structure is
sufficient — see #counter-register (structured modes change the error
profile rather than removing it).

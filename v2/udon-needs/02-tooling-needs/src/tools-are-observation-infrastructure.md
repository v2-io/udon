---
slug: tools-are-observation-infrastructure
type: finding
evidence: [T4, T2, T1]
status: theorem-grade-conditional (T4 core) + cross-tier-convergent (implications)
stage: drafted
consumers: both
depends: [method-evidence-tiers]
sources:
  - ../../01-ideation/02-provenanced/syntheses/asf-dossier.md   # §2.1–2.3, §3
  - ../../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # clusters 5, 6, 11
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C5, C11
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

**From the formal theory (conditional theorems; [the theory report](../reports/theory-of-agentic-tooling.md) reproduces the
theory survey whole, with each result's premises):**

- **The κ×A bias law** — belief bias in a coupled (LLM) agent is bounded by
  (architectural coupling κ) × (observation ambiguity A). Plainly: κ
  measures how much the agent's *goals* are wired into how it processes
  what it sees (for an LLM, one forward pass does both, so κ ≈ 1 by
  construction and cannot be engineered away); A measures how much of an
  observation's meaning is left open to interpretation the agent's goals
  could bend. The product bounds how wrong wanting-something can make the
  agent's beliefs. Since κ is immovable, **A — a property of observation
  design — is the one knob anyone gets.** The theory's own lever statement: the
  practical move is "not reducing κ … but reducing A: more tests, more
  precise metrics, more structured outputs, less reliance on interpretive
  judgments." Canonical A≈0 observations: a test passing or failing, a
  compiler error with a specific message, a file's existence. Motivated
  reasoning is formalized as the high-κ×high-A corner — ambiguity in an
  agent-facing format is the opening through which goal-conditioned
  distortion enters, not mere friction.
- **Tempo gating** — an agent's adaptation tempo is loop speed times
  update quality, summed over its channels (the theory writes it T = Σ ν·η*),
  and the update-quality term collapses under observation noise:
  *you cannot outrun a bad observation channel by iterating faster.* Worse,
  bad channels *hide miscomprehension* (high noise + spuriously-low model
  uncertainty drives the update gain toward zero: the agent stops updating
  even when wrong). And correlated channels overcount: more telemetry ≠ more
  adaptation; only structurally independent channels sum.
- **Persistence threshold** — tempo must exceed the environment's drift
  rate, scaled by how much mismatch the agent can survive (the theory's
  T > ρ/‖δ_critical‖). Round-trips-per-orient-step set loop tempo; a tool loop too
  slow for the environment's drift rate is a viability failure, not a
  performance failure. And persistence is priced: it demands a *sustained*
  information intake rate — "survival is not a state you achieve once; it
  is a sustained burn rate" — so observation channels must supply real
  capacity or persistence fails regardless of how good the correction
  logic is. The diagnostic gift of the same chapter: **confident wrongness
  is a structural-failure signature, not a tuning failure** — persistent
  mismatch with *systematic structure* in the residuals means the model is
  the wrong kind of object, and no amount of tuning (or telemetry volume)
  helps.
- **The interventional gate** — every tool call is a do() intervention in
  Pearl's sense: the agent *sets* something in the world rather than
  passively observing it, which is what makes tool-loop data causal
  (Level-2, "what happens if I do X") rather than merely correlational
  (Level-1, "what tends to co-occur"). A chat window is Level-1; a bash
  terminal is Level-2. But the upgrade is *earned*, gated on the loop
  knowing the tool's action-mechanism — the map from "I called this" to
  "that happened" (the theory's condition C3) — which is an *interface
  property*, established by precise action semantics and law-teaching
  refusals (the [next chapter's](errors-that-teach.md) subject).

**From shipping practice (the same physics instantiated, mostly without
the theory):** the ecosystem's converged "prefer dedicated tool over shell
equivalent" tables (7 sources, near-verbatim: Read not cat, Edit not sed —
"keeps raw stdout out of the conversation") are A-reduction in the wild;
the entire context-management machinery ([a later chapter](context-economy.md)) is the
description-length budget handled empirically.

**From the first-principles design work:** a 2025 statement of design
principles for agent-facing interfaces lays down the same rules as ideology, years before the theory formalized them — "tool loop =
epistemic organ (deterministic, honest readout)"; "drive observation
ambiguity toward zero (codes, counts, paths — not interpretive prose in the
result channel)." This is the report's strongest foundations-level
agreement — noted honestly: the design principles and the theory share an
author, so the load-bearing independence is between **the theory and the
shipped ecosystem**, which arrived at the same rules separately; the design
work is the same mind saying it earlier. (No external study directly
tests the bias law itself; published evidence corroborates neighboring
claims, not this one.)

## What it generates

- **For UDON:** a notation whose parse/validation outcomes are sharp (binary,
  typed, located) is a bias-reduction instrument *in a formal sense* — the
  self-describing pitch for schemas turning "does this look right?" into
  pass/fail. Structural validation is a new near-zero-noise, near-zero-cost
  channel added to the agent's Level-2 portfolio at the cheapest tier.
- **For the harness:** channel *independence* matters as much as channel
  count (tests + typecheck + runtime probe genuinely add tempo; three views
  of one state don't); and there is a runnable eval here — the theory's own
  operational estimator for ambiguity (probe the same observation under
  multiple goal-primings, measure interpretation divergence) has apparently
  never been run on a real format. A candidate experiment for either
  consumer.

## Honest edges

The theory results are conditional (their named sub-scopes travel with
them); the persistence framing transfers to real harnesses only insofar as
"drift" is meaningful for the task environment. Nothing here says structure is
sufficient — see the [counter-evidence chapter](counter-register.md) — structured modes
change the error profile rather than removing it.

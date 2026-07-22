---
source: 04-diagnostic-surfaces.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/practica/docs/02-normative/04-diagnostic-surfaces.md
source_commit: 938fb79ed9bd58b34374eb1122d86bb95fd817e8
categories: [normative, diagnostic-surfaces, observability, tool-relevant]
why_included: >
  Composed May 20 2026. Cluster 04: diagnostic-surface norms -- what a coordination substrate must make observable. Highly tool-relevant (what an agent and its human need to see to trust and steer).
---

# Cluster 04 — Diagnostic surfaces

What the system reveals. The claims in this cluster shape decisions about what observable signals Practica makes legible to its actors — about themselves, about each other, about the composite they constitute, about the events arriving from outside. Diagnostic surfaces are the *control* side of the command/control architectural separation (D4 in [[03-content-discipline]]); they are what makes coordination decisions informed rather than blind.

The claims here rest primarily on the AAT-side machinery in the harvest's M / P / U / CV / LIA clusters. Most are at AAT discussion-grade or claims-verified tier; specific numerical thresholds need verification at the home segments before driving design constants. The diagnostic surfaces are *structurally necessary* under AAT but *implementation-flexible* at the level of specific representations.

---

## G1 — Per-direction monitoring; aggregate metrics hide directional failures

**Practica's monitoring surfaces are *per-direction* across the dimensions of state being tracked (cost, schedule, quality, scope, risk, team-morale, customer-satisfaction, etc.), not aggregate. Composite scores that average across dimensions are forbidden as primary indicators because they systematically hide directional failures.**

Why this is forced: AAT's `result-per-dimension-persistence` and `deriv-matrix-persistence-condition` establish that multi-dimensional persistence is a *min*-operation across directions — bandwidth-per-direction, not aggregate bandwidth, is the binding constraint. No Shannon-type aggregation across dimensions can compensate for one direction being capacity-starved. The canonical persistence condition for anisotropic systems is the matrix-Loewner check $\Sigma_\infty \prec D_\delta$. *A composite that looks healthy in aggregate can be structurally failing along one specific dimension that's dragging persistence below threshold* — the weak direction is the bottleneck; aggregate metrics mask exactly the signal that matters. There is an adversarial corollary worth surfacing: opponents who identify the weak direction concentrate disturbance there, amplifying the mismatch ratio asymmetrically while aggregate metrics still look acceptable.[^g1-source]

What this does not specify: which dimensions are tracked (this is domain-dependent); the representation of per-direction state (numerical scales, color-coded, qualitative); whether aggregate views are *supported but secondary* or *forbidden entirely* (likely the former — aggregates can be useful summaries when the per-direction breakdown is also visible). The commitment is to *per-direction as primary*, *aggregate as secondary or derived*.

*Tier:* Convergent within AAT — robust-qualitative from the per-dimension persistence result; specific numerical thresholds at home-verify tier. Cross-references: D4 in [[03-content-discipline]] (per-direction monitoring is *control*; D4 says it cannot auto-update intent); G5 below (per-direction monitoring is also adversarial defense, not just diagnostic clarity); F2 in [[05-failure-mode-defaults]] (force re-examination of long-confident efforts often surfaces a per-direction failure aggregate metrics had hidden).

[^g1-source]: `~/src/agentic-systems/01-aat-core/src/result-per-dimension-persistence.md` and `~/src/agentic-systems/01-aat-core/src/deriv-matrix-persistence-condition.md`. The harvest's P2 entry: *"multi-dimensional persistence is a min-operation across directions — bandwidth-per-direction, not aggregate bandwidth, is the binding constraint. Per-coordinate evaluation is unsafe under cross-dimensional correction; the canonical persistence condition for anisotropic systems is the matrix-Loewner check $\Sigma_\infty \prec D_\delta$. No Shannon-type aggregation across dimensions can compensate for one direction being capacity-starved."*

---

## G2 — Composite-scope observation is structurally distinct from per-sub-agent observation

**Practica supports *composite-scope* observation — observation acting at the level of the whole effort or whole composite — as architecturally distinct from per-sub-agent observation. Per-sub-agent metrics, even summed or averaged, cannot determine whether the composite is cooperatively or adversarially coupled.**

Why this is forced: AAT's `disc-identifiability-floor` Instance 3 (composed in `impl-composition-machinery`) establishes that the coupling-sign bit ($\gamma\lt0$ cooperative vs $\gamma\gt0$ adversarial) is *structurally unidentifiable from component marginals*. Liberzon 2003 common-Lyapunov-nonexistence is the external no-go. The unique broadly-available escape is interventional access at the composite scope — *Mode 2* per the harvest's CA4: perform a $do$-intervention on one sub-agent, observe response of another. **An effort can be performing well per sub-agent while *the composite is sabotaged* by coupling dynamics invisible at the component level.** This is uncomfortable design: most tracking tools aggregate per-actor metrics; the AAT result says aggregate-of-individual-metrics structurally cannot reveal the coupling sign. Practica must therefore support an observation mode that *acts at the composite scope* — not just collects from individual scopes.[^g2-source]

A related claim from `der-loop-interventional-access` (LIA1 in the harvest): agency scope is a structural prerequisite — $\lvert\mathcal{A}\rvert \geq 2$ with at least one action having causal effect. Without it, the sub-agent is a *passive observer* and structurally cannot generate Level-2 (interventional) data. Practica's intent records for sub-agents should make agency-scope explicit — *active* sub-agents (≥2 actions, causal effect) generate Level-2 data; *passive observers* (monitors, dashboards, reporting roles) generate only Level-1 (observational) data. The two are structurally different and should be tagged as such in the data model.

What this does not specify: the specific interventional protocols (how does a composite-scope observer "act on one sub-agent"?); the conditions under which interventions are available (operationally, this depends heavily on the deployment); the format of composite-scope reports. *Audit-surfaced refinement:* composite-scope observation has its own implementation conditions worth making explicit per context — interventions need to be actually available, responses need to be identifiable, and the standard causal-inference conditions (positivity, adjustment/sequential-ignorability, measurement, transport) need to hold. The commitment is to the *architectural distinctness*, not to a specific intervention protocol.

*Tier:* Convergent within AAT (`disc-identifiability-floor` + `der-loop-interventional-access`) — claims-verified for the no-go; the escape conditions need source verification per deployment. Cross-references: A1 in [[01-architectural-commitments]] (the plumbing layer supports the composite-scope view as a first-class object); G3 below (trust calibration uses composite-scope evidence); G5 below (signed coupling per relationship is what composite-scope observation makes visible).

[^g2-source]: `~/src/agentic-systems/01-aat-core/src/disc-identifiability-floor.md` (Instance 3) + `~/src/agentic-systems/01-aat-core/src/impl-composition-machinery.md` (M3 in the harvest) + `~/src/agentic-systems/01-aat-core/src/der-loop-interventional-access.md` (LIA1 in the harvest). Harvest M3: *"You cannot determine composite health (cooperative vs. adversarial coupling) from individual sub-agent behavior alone. … An effort can be 'performing well per sub-agent' while the composite is sabotaged by coupling dynamics invisible at the component level."* Harvest LIA1: *"Agency scope is a structural prerequisite: $\lvert\mathcal{A}\rvert \geq 2$ with at least one action having causal effect. Without it, the sub-agent is a passive observer and structurally cannot generate Level-2 data."*

---

## G3 — Trust as three-source decomposition

**Practica's data model represents trust per relationship as a *three-source decomposition*: (a) channel uncertainty $U_o$ (transmission medium, protocol clarity); (b) source-competence uncertainty $U_{\text{src},j}$ (receiver's uncertainty about sender's model calibration); (c) teleological-alignment uncertainty $U_{\text{align},ji}$ (receiver's uncertainty about whether sender's communications serve receiver's interests). A single flat *"trust score"* is forbidden because flattening loses the information needed to choose the right intervention.**

Why this is forced: AAT's `hyp-communication-gain` (harvest U3) extends the single-agent gain $\eta^\ast = U_M / (U_M + U_o)$ to inter-agent channels by adding the two additional terms. The three sources have different *improvement paths*: $U_o$ (channel) is improvable by *infrastructure* (better transmission medium, clearer protocols); $U_{\text{src},j}$ (source competence) is improvable by *source improving its model* OR by *receiver via calibration tracking over time*; $U_{\text{align},ji}$ (relationship/objectives) is *game-theoretic* — the load-bearing variable for cooperation-vs-adversarial. A sub-agent with a poor channel (high $U_o$, fixable with protocols) is structurally different from one whose model is poorly calibrated (high $U_{\text{src}}$, needs evidence-tracking), which is different from one whose objectives may not align (high $U_{\text{align}}$, requires structural separation or external intervention). Flattening into a single trust score loses exactly the information needed for the right intervention.[^g3-source]

A related claim (harvest U4): trust calibration is itself an AAT process — agent $i$'s estimates of $U_{\text{src},j}$ and $U_{\text{align},ji}$ constitute a *trust meta-model* subject to AAT's apparatus (mismatch, gain, structural inadequacy at the meta-level). Trust assessments must therefore be *Bayesian-update-style with explicit calibration tracking*, NOT threshold-based or static. A flat *"trusted / not-trusted"* flag systematically miscalibrates the way the three-source decomposition predicts. There is also a *risk-asymmetric* discipline worth surfacing for high-stakes interactions: use a *conservative quantile* of the trust posterior rather than the mean. High-trust relationships should build slowly and break quickly *structurally*, because the decision-side risk-asymmetry favors slow accumulation and fast erosion.

What this does not specify: how the three uncertainty sources are represented in the schema; the specific Bayesian update protocols; what evidence updates which source (a calibration miss on a prediction probably updates $U_{\text{src}}$; a misaligned action probably updates $U_{\text{align}}$; a transmission error updates $U_o$); how the conservative-quantile discipline is operationalized. The commitment is to the *three-source decomposition* and to *Bayesian-update-style calibration* rather than threshold-based.

*Tier:* AAT discussion-grade hypothesis (`hyp-communication-gain` is at hypothesis tier; the three-source decomposition itself is the load-bearing claim; the specific functional form is structural-not-derived). Cross-references: C5 in [[02-coordination-affordances]] (refuse-with-reason events are evidence for $U_{\text{align}}$); G2 above (composite-scope observation is one source of evidence about coupling-sign which is evidence about $U_{\text{align}}$); G5 below (signed-coupling per relationship is evidence about $U_{\text{align}}$).

[^g3-source]: `~/src/agentic-systems/01-aat-core/src/hyp-communication-gain.md` — *"three-source decomposition with three distinct uncertainty sources and three different improvement paths."* The harvest's U3 and U4 entries develop the decomposition and the calibration-as-AAT-process implications. The harvest's *audit-surfaced implication* on U4: *"for any practical risk-asymmetric trust policy in practica … the loss/decision function should be made explicit per decision context, not embedded as a hidden default."*

---

## G4 — Four-regime event taxonomy

**Practica's event-classification model has four qualitatively distinct regimes — *informative update*, *magnitude shock*, *structural shock*, *ambient noise* — with each regime routing to a different repair path. A single *"alert" / "notification" / "incident"* category is forbidden because flattening loses the information needed for the structural-vs-tactical distinction.**

Why this is forced: AAT's `der-interaction-channel-classification` (harvest CV2) establishes that the same signal from emitter $A$ lands on recipient $B$ as one of four things, determined by three independent boundary conditions in $B$'s existing AAT quantities. The four regimes route to four repair paths: *informative updates* → tempo investment (the system can absorb the update at its current adaptive rate); *magnitude shocks* → sector-radius / capacity engineering (the event exceeds the system's current capacity; the system must grow capacity); *structural shocks* → model-class expansion (the event's structure is not representable in the current model class — P3 territory); *ambient noise* → filtering / infrastructure response (low-information accumulating events). Events arriving from outside or from peer sub-agents are not undifferentiated; the four-regime classification supports four distinct interventions.[^g4-source]

What this does not specify: the specific classification protocol (automatic? actor-tagged? hybrid?); the thresholds that separate regimes (these are tier-dependent and may need verification at the home segment); the interaction between regime classification and trust calibration (a structural shock from a low-$U_{\text{align}}$ source is different from the same shock from a high-$U_{\text{align}}$ source). The commitment is to the *four-regime distinction* being supported; the specific protocol has room. *Audit-surfaced refinement:* the repair mapping for magnitude shocks drifts slightly in the hub from the home segment (home has sector-radius/capacity, hub has gain-investment); the hub's *"ambient noise → no response"* is too strong (ambient noise contributes variance and slowly drains reserve, so filtering or infrastructure response is appropriate when aggregate ambient load is material). Practica should state the four-regime classification crisply and route repair through the home segment for magnitude-shock and ambient-noise specifics.

*Tier:* AAT claims-verified for the four-regime classification structure; specific repair-routing details are at home-verify tier. Cross-references: G3 above (event regime classification interacts with trust calibration — the regime tells you which uncertainty source to update); G5 below (the signed-coupling structure determines whether a given event from a peer counts as informative or as adversarial shock); F2 in [[05-failure-mode-defaults]] (structural shocks often surface as long-confident efforts hitting their structural limits).

[^g4-source]: `~/src/agentic-systems/01-aat-core/src/der-interaction-channel-classification.md`. The harvest's CV2 entry develops the four-regime classification and the repair-routing implications. *Audit-surfaced implications* in the harvest CV2 entry note the hub-to-home drift on magnitude shocks and the over-strong *"ambient noise → no response"* characterization.

---

## G5 — Signed coupling per relationship

**Practica's data model represents *coupling* per relationship as a *signed* quantity — cooperative ($\gamma < 0$, reduces effective disturbance) or adversarial ($\gamma > 0$, amplifies effective disturbance) — with per-direction signed values ($\gamma_{i\to j}$ need not equal $\gamma_{j\to i}$). A single *"trust score"* or *"relationship strength"* is forbidden for the same reason as G3's flattening; here additionally because flat-strength flattens the *direction* of the coupling.**

Why this is forced: AAT's `der-team-persistence` and `der-adversarial-destabilization` (harvest CV1) decompose the effective disturbance for sub-agent $i$ as $\rho_i^{\text{eff}} = \rho_{i,\text{env}} + \sum_j \gamma_{j \to i}^{\text{adv}} \mathcal T_j - \sum_j \gamma_{j \to i}^{\text{coop}} \mathcal T_j$ — adversarial entries amplify effective disturbance, cooperative entries reduce it. *Persistence and destabilization are the same inequality read in opposite directions*; cooperation and adversarial dynamics share machinery and what distinguishes them is the *sign* per relationship pair. Per-direction is structurally necessary (asymmetric couplings exist; $\gamma_{i\to j}$ and $\gamma_{j\to i}$ can have different signs and magnitudes); a monolithic relationship-strength score flattens exactly the dynamics that matter.[^g5-source]

*Audit-surfaced refinement* (harvest CV1): the direct mapping from observed cooperative-$\gamma$ to high-trust ($U_{\text{align}}\to 0$) is too tight in the hub — coupling sign is *evidence about* alignment, not identical to it. This matches G3's three-source decomposition: trust updates from coupling-sign evidence under a model, not as a direct read-off. The signed coupling per relationship is therefore part of the *evidence* the trust meta-model consumes, not a substitute for the trust decomposition.

What this does not specify: how $\gamma$ is estimated (interventional Mode-2 access — see G2 — is the canonical AAT-side approach; cheaper heuristics may be used per context); the schema representation; the cadence of update; the interaction with anti-goals (a peer who frequently triggers your anti-goals is exhibiting adversarial-shaped coupling, even without intent). The commitment is to the *signed per-direction representation* of coupling per relationship.

*Tier:* AAT claims-verified for the signed-coupling decomposition; specific estimation protocols are at home-verify tier. Cross-references: G2 above (Mode-2 interventional access is how $\gamma$ becomes identifiable); G3 above (signed coupling is evidence about $U_{\text{align}}$, not a substitute); G4 above (the four-regime event taxonomy interacts with signed coupling — an event from a $\gamma > 0$ peer is more likely a shock than an informative update).

[^g5-source]: `~/src/agentic-systems/01-aat-core/src/der-team-persistence.md` + `~/src/agentic-systems/01-aat-core/src/der-adversarial-destabilization.md`. Harvest CV1: *"Cooperative and adversarial coupling are one signed-coupling structure, not two theories. … Persistence and destabilization are the same inequality read in opposite directions. … The tool's data model should make the sign visible per relationship — and per direction ($\gamma_{i\to j}$ need not equal $\gamma_{j\to i}$)."*

---

## G6 — Per-actor causal-identification regime (A / B / C)

**Practica tags efforts and sub-agents with their *causal-identification regime* — Regime A (intervention-rich; software / laboratory; strong causal claims supported), Regime B (partial intervention; organizational; hedged causal claims), Regime C (observation-only; correlational claims only). The diagnostic-claim register the system supports calibrates to the regime, not to the surface activity.**

Why this is forced: AAT's `der-loop-interventional-access` + `scope-edge-update-causal-validity` (harvest LIA2) establishes that even granted the loop's interventional character (CA1), the *strength of usable causal identification* from that data varies by domain. Data character is one thing; identifiable causal estimates are another. Software-development efforts sit in Regime A — interventions cheap, observations clean, fast feedback — and Practica can support strong causal claims about cause-and-effect of changes. Organizational-change efforts sit in Regime B — interventions exist but partial, observations noisy, feedback slow — and Practica's claims must be hedged. Pure forecasting / analysis efforts sit in Regime C — observation-only — and Practica supports only correlational claims. A regime-A effort can carry stronger claims than a regime-C effort even when the surface activity (a sub-agent recording a finding) looks identical.[^g6-source]

What this does not specify: the regime-tagging UX (auto-detected from effort type? actor-declared? hybrid?); the specific claim-register changes per regime (different verbs? different confidence markers? different audit affordances?); how regime can change mid-effort (a regime-B effort may have regime-A sub-efforts within it). The commitment is to the *regime distinction* being expressible and to the *claim register calibrating to regime*.

*Tier:* AAT discussion-grade — `der-loop-interventional-access` is exact for the interventional character; the A/B/C regime classification is a synthesis with empirical-domain characterization. Cross-references: A6 in [[01-architectural-commitments]] (Effort resource carries the regime tag); D4 in [[03-content-discipline]] (the command/control distinction interacts with regime — a regime-A effort's control surface is more decision-relevant than a regime-C effort's); G2 above (composite-scope Mode-2 access is regime-dependent).

[^g6-source]: `~/src/agentic-systems/01-aat-core/src/der-loop-interventional-access.md` + `~/src/agentic-systems/01-aat-core/src/scope-edge-update-causal-validity.md` (referenced in the harvest's LIA2 entry). Harvest LIA2: *"Strength of causal identification varies by domain: Regime A (intervention-rich, software / laboratory), Regime B (partial intervention, organizational), Regime C (observation-only). … Operationally: when a sub-agent claims 'this change caused that result', the tool's confidence in that claim should be regime-dependent."*

---

## What this cluster does not specify

The diagnostic surfaces here are *what the system observes and reveals*. They are silent on:

- **Where the diagnostic state lives in the architecture.** Some diagnostic state belongs to the plumbing layer (G1 per-direction monitoring, G6 regime tags); some belongs to relationship structures (G3 trust, G5 signed-coupling). The architectural commitments are in [[01-architectural-commitments]].
- **What operations the diagnostic state participates in.** Trust updates participate in C1 soft-claiming and C5 refuse-with-reason interactions; event classification feeds C3 backbrief; signed-coupling shapes who can effectively coordinate with whom. The operations are in [[02-coordination-affordances]].
- **What content the diagnostics observe.** Per-direction monitoring observes dimensions chosen per D3's three-level vocabulary; trust updates evaluate communications against D6's six-section briefing template. The content is shaped by [[03-content-discipline]].
- **Defaults the diagnostics inform.** Force re-examination of long-confident efforts (F2) uses per-direction signals and structural-shock detection; the toxic-cycle resistance (F4) requires recognizing dashboards-of-aggregates as anti-pattern. The defaults are in [[05-failure-mode-defaults]].
- **What diagnostic surfaces cannot promise.** Causal-identification limits in non-software regimes; the sandbox-to-deployment transport limit; cultural-soil-bounded honesty in trust reporting — these honest limits are in [[06-limits-and-positioning]].

The diagnostic surfaces are the *control* layer per D4's command/control architectural separation. They make coordination decisions informed. They do not — and must not — auto-update the command layer (intent); their job is to reveal, not to decide.

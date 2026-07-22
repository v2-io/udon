---
source: 03-content-discipline.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/practica/docs/02-normative/03-content-discipline.md
source_commit: 938fb79ed9bd58b34374eb1122d86bb95fd817e8
categories: [normative, content-discipline, minimum-sufficient-set]
why_included: >
  Composed May 20 2026. Cluster 03: content-discipline norms (what content the substrate should and should not hold).
---

# Cluster 03 — Content discipline

What the system holds and how. The claims in this cluster shape decisions about the *form* of intent and related content — specification level, commit readiness, vocabulary, the architectural separation between command and control, and the canonical structural shape of an intent record.

The architectural commitments from [[01-architectural-commitments]] settled *what kinds of resources exist*. The coordination affordances from [[02-coordination-affordances]] settled *what operations the system supports*. This cluster settles *what the content of those resources looks like*. The claims rest on (a) Moltke-via-Bungay's directive form (minimum-sufficient-set, 70%-right, three-level vocabulary, briefing template); (b) Bungay's command-vs-control distinction; (c) the foundational reframe's *agency-granting conditions* reading of intent (COG as recurring-attending site).

---

## D1 — Minimum-sufficient-set discipline as the intent-capture UX default

**Practica's intent-capture UX makes the *minimum-sufficient-set discipline* — *all but only what subordinates cannot determine for themselves to achieve a particular purpose* — the natural state. Specifically: the UX surfaces *what is known* and *what is deliberately left for the sub-agent* separately; intents are committable in incomplete states; the UX does not gate save-or-commit on field-completeness.**

Why this is forced: under the central cut of the alignment-autonomy 2×2 (paper 2), action is derived from state by the local actor at the moment of action. The intent-author cannot know what the action-taker will know; the intent-author cannot specify what should be left for the action-taker without making that explicit. Moltke's 1869 rule is precise about both ends mattering — *include what subordinates cannot determine, but also only what they cannot determine*. Over-specification binds the action-taker to a plan that may be invalidated by changing conditions; under-specification forces back-and-forth. The discipline is *minimum-sufficient relative to the subordinate's existing knowledge state*, not minimum-absolute. A UX that demands completeness on intent capture (every field filled before save; all subtasks enumerated before commit) enforces over-specification structurally. Paper 2 §7.4 traces this as conditional entailment of the central cut applied to Practica's UX surface.[^d1-source]

What this does not specify: the specific UX affordances (field-by-field commit; structured templates with optional sections; freeform with structural prompts); the minimum schema for what counts as an intent (this is domain-dependent); how *"deliberately left for the sub-agent"* is visually distinguished from *"empty because not yet considered"*. The commitment is to the *discipline* — incomplete-commits supported, what-is-deliberately-open visible, no completeness gating — as the UX default. Surface choices have room.

*Tier:* Convergent — Moltke 1869's primary military-doctrine identification + the central cut from paper 2. Cross-references: A2 in [[01-architectural-commitments]] (the discipline operates on the Intent resource); C2 in [[02-coordination-affordances]] (two-levels-up visibility lets the action-taker know what context they already have access to, which is the basis for *"what cannot be determined from existing knowledge"*); D2 below (70%-right commits is the operational stopping criterion for this discipline).

[^d1-source]: [[../../msc/practica-intent-action-layers]] §7.4 — the entailment trace. Moltke 1869 *Guidance for Large Unit Commanders*, quoted in Bungay Ch 3 (`~/src/_ref/books/Art-of-Action/parts/03-elements-of-a-solution.md` line 89): *"The rule to follow is that an order should contain all, but also only, what subordinates cannot determine for themselves to achieve a particular purpose."* The harvest's S3 entry treats this as *the* directive-form discipline.

---

## D2 — 70%-right intent commits — completeness is not gated

**Practica accepts intent commits at *70%-right* — the explicit stopping criterion from Moltke's apparatus. The UX does not gate commit, save, or downstream operations on perceived completeness; incompleteness is a first-class state, not a defect.**

Why this is forced: D1's minimum-sufficient-set discipline only operates if commits are not blocked on completeness. Moltke's 70% rule is the operational stopping criterion: push past 70% only when you *know* the additional specification reduces ambiguity for the receiver, not when you *feel* the intent is "not quite ready." The instinct to refine past 70% is the same instinct D1 names as over-specification — it adds detail the receiver could determine for themselves, binding them to a plan that may not survive the conditions they will face. Bungay's Ch 3 treatment: *"Von Moltke did not have to wait to develop a perfect plan. He could go with one that was 70 percent right, because the organization would deal with the other 30 percent. He did not need to know everything, he simply needed to be directionally correct."* The UX commitment is structural: gating commits on completeness is the affordance-side of the over-specification anti-pattern.[^d2-source]

What this does not specify: the format in which incompleteness is marked (open fields, *"known/open/deliberate"* tagging, freeform notes); whether the system suggests what *could* be specified further; the interaction with C3's backbrief (a receiver may surface *"I cannot derive this from what you've given me"* as a backbrief response, triggering iteration). The commitment is to *no completeness gating*; the specific incompleteness-handling has room.

*Tier:* Bungay's military-doctrine identification with engineering-relevant operationalization. Not directly derived in AAT but consistent with the action-from-state structure and the minimum-sufficient-set discipline. Cross-references: D1 above (this is its operational stopping criterion); F4 in [[05-failure-mode-defaults]] (gating commits on completeness is one specific instance of the toxic-cycle's *"more detailed instructions"* anti-pattern).

[^d2-source]: Bungay Ch 3 develops the 70% rule (working paper at `~/src/practica/msc/s3-working/03-elements-of-a-solution.md` §1.9). The harvest cites this as the explicit stopping criterion that distinguishes Moltke's directive form from typical planning advice.

---

## D3 — Three-level vocabulary: Strategy / Execution / Tactics

**Practica's vocabulary distinguishes three levels of work: *Strategy* (binding direction, why, long horizon), *Execution* (judgment-rich, situation-dependent, what), and *Tactics* (standardized procedures, routine, how). The two-level collapse (strategy + tactics, with execution-layer work falling into one or the other) is forbidden by the data-model commitment; the three-level distinction is supported at the resource level.**

Why this is forced: Bungay Ch 7 §1–5 develops the three-level model and traces the canonical failure of two-level thinking — the Somme, 1 July 1916, 60,000 casualties — to the absence of an explicit execution layer. Most existing task-tracking tools and management vocabularies collapse to two levels (Strategy = goals/OKRs; Tactics = tasks), with the execution layer where judgment-rich, situation-dependent, non-routine work lives implicitly distributed across the two or absent entirely. Practica's data model must support all three because the work that Practica is designed to coordinate (serial sub-agents under context-turnover; novel cross-cutting efforts) is largely *execution-layer work* — neither pure strategy nor pure tactics. Without explicit execution-layer support, Practica reverts to a two-level tool that mis-serves its primary use case.[^d3-source]

What this does not specify: how the three levels are represented in the resource schema (separate types? typed fields? configurable proportionality?); how transitions between levels are tracked (a strategy may decompose into execution-level efforts; tactics may emerge from repeated execution patterns); how the proportionality C6 names is encoded. The commitment is to the *three-level distinction* being expressible; the implementation has room.

*Tier:* Bungay's military-doctrine identification (Ch 7, the executive trinity and three-level vocabulary; the Somme as canonical failure of two-level thinking). The harvest's S10 entry summarizes this and notes operata's Effort resource may be the natural home for execution-layer content. Cross-references: A6 in [[01-architectural-commitments]] (the four-resource baseline includes Effort, which is the candidate execution-layer home); C6 in [[02-coordination-affordances]] (configurable proportionality operates on this three-level distinction); D6 below (the six-section briefing template operates within strategy and execution levels).

[^d3-source]: Bungay Ch 7 (`~/src/_ref/books/Art-of-Action/parts/07-leadership-that-works.md`) §1–5; the Somme failure is at §1.2. Working paper synthesis at `~/src/practica/msc/s3-working/07-leadership-that-works.md` §1.5: *"Business has historically lacked the operations/execution level. Two-level thinking → strategy comes down as plans; gap is filled with 'targets, initiatives, workplans' layered onto day-to-day activity. … Three-level thinking carves out an explicit execution layer between strategy (intent) and tactics (SOPs) — 'exploiting advantage through independent thinking obedience.'"*

---

## D4 — Command and control architecturally distinct: intent never auto-completed from metrics

**Practica's intent layer and metrics layer are architecturally distinct. Metrics never *auto-update* intent; the dashboard does not imply that good metrics = good strategy; target-renegotiation when targets and intent conflict is a first-class operation in which targets change, not intent.**

Why this is forced: Bungay Ch 6 develops the central-heating analogy. *Command* is an act of will *based on considerations outside the system it commands* (you decide 18°C feels comfortable). *Control* is the ability to adjust by monitoring and acting on what's monitored. *"No act of command can be derived from any act of control even in principle, no matter how sophisticated the system."* For Practica, this means the intent layer (command) cannot be derived from the metrics layer (control). A system that auto-completes intent from observed performance, or that treats *"the metrics look good"* as evidence that the intent is right, has collapsed the architectural distinction the structural cut requires. Joe's bonus-target story (Bungay Ch 5) is the worked failure case — targets that conflict with intent must trigger *target renegotiation*, not silent drift of intent toward whatever the metrics say. The harvest's S9 entry treats this as *one of the deepest tool-design claims in the source*.[^d4-source]

What this does not specify: how the architectural distinction is visible in the UX (separate panels? separate operations? warning when targets/intent conflict?); the protocol for target renegotiation; the interaction with G1 in [[04-diagnostic-surfaces]] (per-direction monitoring is *control*; D4 says metrics-as-control cannot auto-complete intent-as-command). The commitment is to the *architectural distinctness* — no auto-derivation from metrics to intent.

*Tier:* Bungay's military-doctrine identification (Ch 6 central-heating analogy). Engineering-grounded design intuition with Joe's worked failure case from Ch 5. Cross-references: A1 in [[01-architectural-commitments]] (the plumbing/intelligence split is the architectural substrate that holds intent and metrics separately); D5 below (COG-as-recurring-attending requires intent to be re-authored by the human, not auto-updated); G1 in [[04-diagnostic-surfaces]] (per-direction monitoring is the control surface that D4 says cannot auto-update intent).

[^d4-source]: Bungay Ch 6 (`~/src/_ref/books/Art-of-Action/parts/06-the-effects-gap.md`) — the central-heating example. The harvest's S9 entry: *"Command and Control are architecturally distinct; intent (command) cannot be derived from metrics (control). … No act of command can be derived from any act of control even in principle, no matter how sophisticated the system."* Joe's bonus-target failure mode is from Ch 5.

---

## D5 — COG as a recurring site of attending, not stored content

**Practica's intent record carries a *Center of Gravity (COG)* slot — the answer to *"what is the basis of competition / decisive differentiator for this work?"* — and the slot is structurally a *site of recurring attending*, not a stored value. Each backbrief (C3) includes the receiving generation's *current articulation* of the COG, implicitly checked against the prior generation's. Drift between successive articulations is *information*, not noise.**

Why this is forced: Bungay Ch 4 develops the COG concept through the boiler-company anecdote — *"the enormous difference between knowing that something is important and realizing that it is the basis of competition."* The Managing Director's 30 years of pattern-recognition crystallized into a realization six executives with the same facts did not have. COG is *agent-knowledge* in the foundational-reframe sense (substrate-reflexive information does not bridge to it by accumulation; it must be re-realized by each agent who attends to it). For Practica's serial sub-agents under context-turnover: storing the COG as content does not transmit it; the receiver must do their own labor of attending to make the dead fact quick thought. Therefore the COG slot is structurally a *site of recurring attending*, not stored content. Three honest readings of drift between articulations are first-class: (1) the underlying basis-of-competition has shifted; (2) the prior articulation was over-fitted to its context; (3) the successor's attending is still forming. All three are practica-grade learning; none should be flattened by enforcing consistency. **Recursion worth naming explicitly:** Practica's own COG (per harvest S8) is *agency-granting conditions for animation across context-turnover* — the foundational reframe is Practica's own COG; the recursion is that Practica's COG is the thing Practica must enable in its users.[^d5-source]

What this does not specify: the format of the COG slot (single field, structured, freeform); the cadence of articulation (per-backbrief, per-cycle, on-request); how drift between articulations is surfaced (diff view, audit log, explicit comparison). The commitment is to the COG being a *recurring-attending site*, not a *stored value*; how the recurring attending is structurally invited has room.

*Tier:* Convergent — Bungay Ch 4 + foundational reframe from the harvest. Not directly derived in AAT; consistent with the substrate-vs-agent distinction and the agency-granting frame. Cross-references: A6 in [[01-architectural-commitments]] (the COG slot lives on the Intent resource); C3 in [[02-coordination-affordances]] (the backbrief is the operation that re-articulates COG); the foundational reframe in [[../02-normative]] (COG-as-recurring-attending is one of the cleanest operationalizations of the agency-granting-conditions frame).

[^d5-source]: Bungay Ch 4 (`~/src/_ref/books/Art-of-Action/parts/04-the-knowledge-gap.md`) develops the COG concept and the boiler-company anecdote. The harvest's S8 entry: *"Center of gravity cannot be transmitted; it must be re-realized. … COG is itself agent-knowledge, not substrate-knowledge … For practica's intent record: the COG slot is a site of recurring attending, not stored content. Every backbrief includes the receiving generation's current articulation of the COG, implicitly checked against the prior generation's. Drift between successive articulations is information, not noise."* The recursion (Practica's own COG = agency-granting conditions) is developed in the foundational-reframe section of [[../../msc/02-normative-harvest]].

---

## D6 — Six-section briefing template as the canonical intent shape

**Practica's intent record schema follows the six-section structure from Bungay's Appendix (drawn from Moltke 1869): *(1) Context*; *(2) Higher Intent* — one level up, two levels up; *(3) My Intent* — what + *in order to* + why, plus measures; *(4) Implied Tasks* with responsibility, timing, and main effort highlighted; *(5) Boundaries* — freedoms AND constraints AND anti-goals; *(6) Backbrief* — recurring three-state question.**

Why this is forced: the six-section template is the operationalization of every other discipline in this cluster. Section 1 (Context) requires distinguishing *known / probable-uncertain / not-known-but-relevant* — the minimum-sufficient-set discipline (D1) made operational at the situational level. Section 2 (Higher Intent) implements C2's two-levels-up visibility structurally. Section 3 (My Intent) requires both the binding intent and the measures (D4's command/control distinction made visible — measures are control-layer, intent is command-layer; both present, not conflated). Section 4 (Implied Tasks) names the *main effort* explicitly — Schwerpunkt as priority signal among multiple legitimate intents. Section 5 (Boundaries) is the tripartite freedoms + constraints + anti-goals structure C4 names. Section 6 (Backbrief) makes C3's three-state alignment check structurally part of the artifact, not a separate document. The template is therefore not one design choice among many — it is *the operationalization* of the other claims in this cluster, made into a single canonical artifact shape.[^d6-source]

What this does not specify: the literal field names; whether sections can be omitted under minimum-sufficient-set discipline (the discipline says *include what cannot be determined*; if a section is wholly inferable, it may be omitted); how the template is presented in the UX (a form? structured fields? a markdown template?); the interaction with shorter informal intent captures (a quick intent commit may be a degenerate case of the template with most sections empty). The commitment is to the *structural form* — the six sections as the canonical shape — not to a specific UX surface.

*Tier:* Bungay's military-doctrine identification (Appendix, drawn from Moltke 1869). The harvest's S6 entry treats this as *the candidate canonical intent artifact shape*. Cross-references: D1 (minimum-sufficient-set operates on Section 1); D4 (command/control distinction operates between Sections 3 and 3-measures); C2 (Section 2 is the two-levels-up visibility); C3 (Section 6 is the backbrief structurally); C4 (Section 5 is the tripartite boundaries); D5 (COG often appears in Section 3 or as a meta-annotation across the template).

[^d6-source]: Bungay Appendix (`~/src/_ref/books/Art-of-Action/Art-of-Action.md` §Appendix) lays out the six-section template in full; Bungay's working notes attribute the structural form to Moltke 1869's directive practice. The harvest's S6 entry treats this as the *candidate canonical intent artifact shape*. Working paper synthesis at `~/src/practica/msc/s3-working/07-leadership-that-works.md` §1.19.

---

## What this cluster does not specify

The content disciplines here govern *what intent and related content look like*. They are silent on:

- **Where the content lives.** The data-model substrate is in [[01-architectural-commitments]] (Intent resource type, type-separation from Realization, etc.).
- **What operations the content supports.** The first-class operations (backbrief, refuse-with-reason, soft-claiming) are in [[02-coordination-affordances]]; the disciplines here shape *what those operations carry*, not *what those operations are*.
- **What the system reveals about content quality or drift.** Trust-tracking, COG-drift surfacing, regime classification — these diagnostic surfaces are in [[04-diagnostic-surfaces]].
- **Defaults that resist content-discipline failure modes.** The toxic-cycle triple (more-info / more-instructions / more-controls), anti-centralization-under-stress — these are in [[05-failure-mode-defaults]].
- **What the content disciplines do not promise.** The cultural-soil constraint, the form-vs-content moral-hazard limit, the configurable proportionality C6 names — these honest limits live in [[06-limits-and-positioning]].

The disciplines here are the *grammar* of intent content; they need the architecture (cluster 01) as substrate, the operations (cluster 02) to carry them, the diagnostic surfaces (cluster 04) for accountability, and the defaults (cluster 05) for resistance to misuse.

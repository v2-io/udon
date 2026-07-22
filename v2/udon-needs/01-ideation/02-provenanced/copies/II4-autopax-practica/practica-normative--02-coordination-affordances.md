---
source: 02-coordination-affordances.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/practica/docs/02-normative/02-coordination-affordances.md
source_commit: 938fb79ed9bd58b34374eb1122d86bb95fd817e8
categories: [normative, coordination-affordances, soft-claiming, two-levels-up, backbrief, tool-relevant]
why_included: >
  Composed May 20 2026. Cluster 02 (vetted in full): soft-claiming not locking, two-levels-up visibility, backbrief. The most tool-relevant of the six normative clusters -- these are affordances a coordination tool must actually expose.
---

# Cluster 02 — Coordination affordances

How actors interact through the system. The claims in this cluster shape decisions about which operations are first-class (have their own type signatures, lifecycle, and persistence guarantees) versus which emerge as derived behaviors. Coordination is the domain where the architectural commitments from [[01-architectural-commitments]] meet the structural reality that the actors are serial — they do not co-exist; each arrives cold, acts in a single session, ends.

The claims here rest on (a) paper 2's convergence on the alignment-autonomy 2×2 and the cascade structure that makes it operational at scale; (b) paper 1's identification of bootstrap-recovery and graceful-handoff as forced by serial context-turnover; (c) Moltke-via-Bungay's operational mechanisms (cascade with backbrief, freedoms-within-bounds, anti-goals, refuse-with-reason); (d) operata's engineering-side soft-claiming-not-locking choice.

---

## C1 — Soft-claiming over hard locking

**Concurrency-control in Practica uses *soft claims* — status-based signals of intent to work on something — rather than *hard locks* that require a holder to release.**

Why this is forced: under serial context-turnover, any locking mechanism that requires a holder to release the lock is structurally broken because the holder is a sub-agent whose session will end. The next sub-agent inherits a stale-locked state; the coordination structure has degraded. Soft-claiming is the coordination form that does not depend on holder persistence. A status field (*"agent X is working on this"*) carries information about intent; coordination decisions are made by *other actors reading the signal*, not enforced by the signal itself. The signal degrades gracefully when the holder vanishes — the next sub-agent reads the status, can verify the holder is no longer active by external means, and proceeds without needing to release anything formally. Paper 1 §6.2 traces this as a conditional entailment of the structural identification; operata's glossary names the soft-claiming pattern explicitly and operata's `operata-system` design document develops it at length.[^c1-source]

What this does not specify: how the status is represented (single field, CRDT-merged metadata, etc.); how stale signals are detected; the conflict-resolution policy when two agents claim the same item; whether human-in-the-loop arbitration is invoked. The commitment is to *signal-not-exclusion* as the coordination form; the specific signaling mechanism has room.

*Tier:* Convergent — paper 1's conditional entailment + operata's engineering precedent + the broader LLM-agent design space's convergence on optimistic-locking-at-commit patterns. Cross-references: A1 in [[01-architectural-commitments]] (the plumbing layer holds the status signal; the type-signed separation is what makes the signal goal-blind for reading purposes); F1 in [[05-failure-mode-defaults]] (bootstrap-recovery is what allows the next agent to even read the stale signal in the first place).

[^c1-source]: [[../../msc/practica-structural-identity]] §6.2 — the entailment trace. `~/src/operata/docs/glossary.md`: *"Soft Claiming: Status-based signal that an agent is working on something without hard locking."* Operata's design document `~/src/operata/docs/exp/2025-11-26-operata-system.md` §"Multi-agent coordination favors soft claiming" develops the pattern in detail with reference to CRDT-based coordination, blackboard architectures, and git's optimistic-locking-at-commit model as the family the choice belongs to.

---

## C2 — Two-levels-up intent visibility at the data-model level

**Practica's intent-record schema supports reading the parent intent (one level up) and the parent's parent intent (two levels up) from any current intent. The visibility is structural — embedded in the data model — not merely a query convenience.**

Why this is forced: the cascade structure (Bungay Ch 3, AAT `der-orient-cascade`) is what makes intent-alignment-at-scale tractable for non-trivial coordination. Direction is short at the top and adds appropriate specification at each level down. For a subordinate to act in service of higher intent when the situation changes — to make Moltke's *"what would my superior order me to do if he were in my position and knew what I know?"* — the subordinate must be able to *see* the higher intent. Mellenthin's two-levels-up rule (operationalized in Bungay Ch 3) is structurally precise: one level is not enough when the immediate parent may itself be wrong about the larger context; three levels is no additional help (constraints from three levels up are too abstract to inform a specific decision); two levels is the structural minimum that supports independent re-decision under situational change. Paper 2 §7.2 traces this as a conditional entailment of the central cut applied to serial sub-agents.[^c2-source]

What this does not specify: whether visibility is by direct field references, by query traversal, by denormalized inheritance, or by other schema choices. Whether more than two levels can be visible (the entailment requires *at minimum* two; more is not forbidden). Whether the affordance is automatic for the receiving agent or actor-requested. The commitment is to *the higher-intent visibility be available at the data-model level*; surfacing it is a UX choice.

*Tier:* Convergent — Bungay's military-doctrine identification + AAT's cascade-ordering result + serial-sub-agent conditions. The AAT side at *claims-verified* (`der-orient-cascade`'s ordering is exact). Cross-references: A2 in [[01-architectural-commitments]] (Intent type-separation is the precondition); C3 below (backbrief uses the two-levels-up visibility); D5 in [[03-content-discipline]] (the COG slot in the intent record makes the highest-level guidance visible across the cascade).

[^c2-source]: [[../../msc/practica-intent-action-layers]] §7.2 — the entailment trace. Bungay Ch 3 (`~/src/_ref/books/Art-of-Action/parts/03-elements-of-a-solution.md`) develops the cascade structure; the Mellenthin attribution is in Ch 3 with the *"two-levels-up"* operational principle. AAT-side: `~/src/agentic-systems/01-aat-core/src/der-orient-cascade.md` — *"$M_t \to A_O \to \Sigma_t \to O_t$. The ordering is not a design choice — it's a consequence of which quantities require which others"* (status *claims-verified*).

---

## C3 — Backbrief as a recurring first-class operation

**Practica supports *backbrief* as a first-class operation on intents. A backbrief is a structured artifact in which the receiving actor (a) restates the intent in their own words, (b) declares the planned action they intend in service of the intent, and (c) makes the three-state determination: *No — brief still valid* / *Yes — change tasks, intent valid* / *Yes — change what we're trying to achieve, escalate*.**

Why this is forced: the backbrief is what makes the cascade structure operational rather than merely asserted. Without it, intent-cascade is one-way: each level passes intent downward and hopes for alignment; misalignment is discovered only when execution fails. With it, alignment is confirmed *before* execution and misalignment surfaces when it can still be corrected at low cost. For Practica's serial sub-agents under context-turnover, the backbrief is structurally even more load-bearing than in Moltke's instance — the cold-arriving successor's backbrief is *the only way* the system has of verifying that the inherited intent has been animated correctly in the new context. The handoff is not a transfer of state; it is an invitation to re-author. The backbrief is the protocol of re-authoring, and the protocol must be a *recurring* operation — *has the situation changed?* must be answerable repeatedly, not just at receipt. Paper 2 §7.3 traces this as conditional entailment of the cascade structure applied to serial sub-agents; the foundational reframe from [[../02-normative]] (durable layer as agency-granting conditions) makes the *re-authoring* reading load-bearing.[^c3-source]

What this does not specify: the format of the backbrief (free text, structured fields, mixed); the cadence of the recurring check (per-cycle, per-trigger, per-elapsed-time); the escalation mechanism for the third branch; how the backbrief is presented to upstream actors for review. The commitment is to the *operation* — restate, declare action, three-state determination — supported as a first-class artifact tied to a specific intent. Form has degrees of freedom.

*Tier:* Convergent — Bungay's military-doctrine identification (backbrief as Fig. 9 alignment-gap mechanism; three-state form from Ch 6 change-of-mission protocol) + the foundational reframe's generational-re-authoring reading + paper 2's serial-sub-agent entailment. Cross-references: C2 above (backbrief uses two-levels-up visibility); A2 in [[01-architectural-commitments]] (the backbrief operates on the Intent resource); D6 in [[03-content-discipline]] (the six-section briefing template carries the backbrief slot structurally).

[^c3-source]: [[../../msc/practica-intent-action-layers]] §7.3 — the entailment trace. Bungay Ch 3 names backbriefing as the Fig. 9 alignment-gap mechanism; Bungay Ch 6 (`~/src/_ref/books/Art-of-Action/parts/06-the-effects-gap.md`) develops the three-state *change-of-mission protocol*; Bungay's Appendix puts the backbrief as the sixth (recurring) section of the standard six-section briefing template (see D6 in [[03-content-discipline]]). Foundational reframe documented in [[../../msc/02-normative-harvest]] §"Foundational claim — what practica's durable layer structurally *is*" — *"the backbrief is the protocol of re-authoring"*.

---

## C4 — Anti-goals as first-class intent content

**Practica's intent-record schema includes *anti-goals* — explicit *"do not let this happen"* content — as a first-class slot, distinct from constraints (boundaries on means) and from positive intent (states to achieve).**

Why this is forced: a tripartite content structure (positive intent + constraints + anti-goals) is required for the alignment-autonomy 2×2 to operate. Without anti-goals, the receiving actor has *positive intent* (what to achieve) and *constraints* (what is permitted vs forbidden in means), but does not have *what specific states must not arise as side effects*. Moltke's 30 August 1870 directive — analyzed in Bungay Ch 5 — included explicit anti-goal content (*"do not let this happen"* about the Mouzon area, conditional anti-goal about the Belgian border) distinct from both his positive aim and the boundaries-on-means. The tripartite form makes *freedom of decision within bounds* meaningfully exercisable: the actor knows what to achieve, the limits on means, and which states to actively prevent — three different kinds of information, each load-bearing for autonomous local decisions. Joe's failure case (Bungay Ch 5 worked example): treating *"freedoms / constraints"* as *"good things vs bad things"* loses the anti-goal layer, and the actor reverts to checking each candidate action against a list rather than exercising judgment against the structure.[^c4-source]

What this does not specify: whether anti-goals are typed differently from positive intent in the schema, or just tagged; whether anti-goals carry their own escalation paths when violated; the interaction between anti-goals and constraints (an anti-goal may imply constraints; some constraints may be redundant given anti-goals). The commitment is to the *three-way distinction* being expressible at the data-model level; the specific representation has room.

*Tier:* Bungay's military-doctrine identification of the tripartite structure; the AAT-side correspondence is less direct (the structure is consistent with `der-orient-cascade`'s objective-revision-last discipline but not specifically derived). Cross-references: A2 in [[01-architectural-commitments]] (anti-goals live in the Intent resource alongside positive content); D1 in [[03-content-discipline]] (anti-goals follow the minimum-sufficient-set discipline — name only the states the actor cannot determine should be prevented from local context); C5 below (refuse-with-reason often invokes anti-goal violation as the reason).

[^c4-source]: Bungay Ch 5 (`~/src/_ref/books/Art-of-Action/parts/05-the-alignment-gap.md`) worked example of Moltke's 30 August 1870 directive. The harvest's S11 entry summarizes: *"Anti-goals as first-class intent content, distinct from constraints and from positive intent. Bungay Ch 5, the Buzancy directive analysis: Moltke's 30 Aug 1870 directive included explicit 'do not let this happen' content — the Mouzon anti-goal (don't get held up by a French rearguard there) and the Belgian-border conditional anti-goal."* Joe's failure case (Bungay Ch 5): first attempt at *"freedoms / constraints"* was *"good things vs bad things"*, which was wrong — the right form is limits-of-authority + conditions-to-meet + actions-within-those-limits + *states to actively prevent*.

---

## C5 — Refuse-with-reason as a first-class operation

**Practica supports *refuse-with-reason* — a structured operation in which an actor declares they are not executing the inherited intent (or are deviating from a specific declared task) and supplies the reasoning that connects their deviation back to the higher intent. The operation is first-class, not an exception path or freeform comment.**

Why this is forced: under Moltke's *selbstständig denkender Gehorsam* (independent thinking obedience), the subordinate's freedom is at the action layer — *how* to obey — and not at the intent layer — *whether* to honor the intent. But the situation may invalidate the specific task that was declared in service of the intent. The 1888 Field Service Regulations canonized the operational case: *"a failure to act or a delay is a more serious fault than making a mistake in the choice of means."* Action is preferred; the question is whether the action serves the intent. When a subordinate diverges from the declared task because the situation has changed, the *refusal* must be visible to upstream actors and must be tied to the higher intent. Without the structured refusal, the actor either silently complies (loses the latitude the system requires) or silently diverges (loses the alignment-verification the system requires). The operation must be first-class because freeform comments do not allow structured propagation up the cascade. Bungay Ch 3 develops the von der Goltz / Colombey 1870 case as the canonical instance — divergence in service of higher intent, structurally legible upstream.[^c5-source]

What this does not specify: the format of the refusal; the escalation policy when the divergence implicates the higher intent (this is where C3's three-state backbrief kicks in); the interaction with anti-goals (a refusal often invokes an anti-goal violation as the structural reason); the trust-accounting consequences (see G3 in [[04-diagnostic-surfaces]]). The commitment is that the operation exists and is structurally tied to the inherited intent.

*Tier:* Convergent — Bungay's military-doctrine identification (von Schlichting + Colombey + 1888 FSR) + the alignment-autonomy 2×2 at the individual scale (intent binding, action free with structured legibility). Not directly derived in AAT; consistent with the action-as-function-of-state structure. Cross-references: C3 above (the three-state backbrief is the structured escalation when refusal implicates intent); F3 in [[05-failure-mode-defaults]] (the *"failure to act > mistake of means"* default makes refusal-with-action preferable to silent compliance); G3 in [[04-diagnostic-surfaces]] (refusals are evidence for the alignment dimension of trust).

[^c5-source]: Bungay Ch 3 develops the *selbstständig denkender Gehorsam* synthesis from von Schlichting; the 1888 Field Service Regulations canonized *"a failure to act or a delay is a more serious fault than making a mistake in the choice of means."* The 14 August 1870 Colombey incident — Brigadier von der Goltz attacks against First Army orders in service of Moltke's higher intent; the 1910 tactical manual retrospectively names it *"one of the finest examples of spontaneous action taken within proper bounds."* Working paper synthesis at `~/src/practica/msc/s3-working/03-elements-of-a-solution.md` §1.8, §1.11.

---

## C6 — Configurable strategy / execution / tactics proportionality

**Practica supports configurable proportionality between the three levels of work — strategy (intent), execution (judgment-rich situational work), tactics (standardized procedure) — per team domain. The defaults are adjustable; the tool does not impose one ratio.**

Why this is forced: Bungay Ch 7 Fig 22 makes the structural observation that the proportions of strategy / execution / tactics differ by business type. A pub-restaurant chain has a large tactical realm (uniform procedures, manuals, school-leaver staff) with a small execution layer and a small strategy held centrally. A consulting firm has a small tactics layer (some SOPs), a large execution layer (each client unique, creativity at a premium), strategy held by partners. The proportions are themselves a *strategic design choice* — not a discovery the tool can make for the team. Practica's defaults must therefore be *adjustable by the team's domain*, not hard-coded for one shape. A regulated-industry deployment should default toward more tactical / SOP weighting; a research deployment toward more execution weighting; the tool should expose the dial. Without configurable proportionality, Practica either over-imposes tactical structure (frustrating execution-heavy work) or under-imposes it (failing regulated-industry adoption).[^c6-source]

What this does not specify: which dimensions of the proportionality are configurable (default weights of UX affordances? capacity of each layer? template choices?); how the configuration is exposed (per-LOCUS setting, per-Effort setting, both); whether the configuration evolves (a team's proportions may shift as their domain matures). The commitment is to *the proportionality being adjustable*; the specific surface for adjustment has room.

*Tier:* Engineering-grounded design intuition with Bungay's empirical-historical observation as backing. No direct AAT derivation. Cross-references: D3 in [[03-content-discipline]] (the three-level vocabulary, S/E/T, is what the proportionality operates on); L3 in [[06-limits-and-positioning]] (the cultural-soil constraint includes the team's expectations about the right S/E/T ratio).

[^c6-source]: Bungay Ch 7 (`~/src/_ref/books/Art-of-Action/parts/07-leadership-that-works.md`) Fig. 22 develops the proportionality observation. Working paper synthesis at `~/src/practica/msc/s3-working/07-leadership-that-works.md` §1.6: *"Pub restaurant chains: large tactical realm (uniform procedures, manuals, school-leaver workers chopping vegetables); small execution; small but vital strategy held by a competent center. Consulting firms: small tactics (some SOPs for slide formats, payment terms); very large execution (each client unique, creativity at a premium); strategy held by partners. The percentages of staff in each realm differ; this is itself a strategic design choice."* The harvest's S10 entry treats the three-level vocabulary; the proportionality observation is an extension.

---

## What this cluster does not specify

The coordination affordances here are *operations* and *visibility commitments* — the verbs and reads the system supports. They are silent on:

- **The architectural commitments these operations require.** The data-model substrate is in [[01-architectural-commitments]] (Intent / Realization separation, plumbing layer, etc.). The operations here operate *on* that substrate.
- **The content discipline that governs what intent and backbrief records contain.** Minimum-sufficient-set, 70%-right commits, three-level vocabulary, COG as recurring-attending site — these are in [[03-content-discipline]] and shape the content the operations carry.
- **What the system reveals about coordination state.** Trust-tracking, signed-coupling, event-classification — the diagnostic surfaces that interpret coordination behavior — are in [[04-diagnostic-surfaces]].
- **Defaults that resist coordination failure modes.** Failure-to-act-vs-mistake-of-means, anti-centralization-under-stress, resistance to the toxic-cycle triple — these are in [[05-failure-mode-defaults]].
- **What coordination cannot promise.** Cultural-soil prerequisites, the moral-hazard limit, sandbox-transport limits — these are in [[06-limits-and-positioning]].

The operations here are the *grammar* of coordination; they need the architecture (cluster 01) as substrate, the content discipline (cluster 03) for legibility, the diagnostic surfaces (cluster 04) for accountability, and the defaults (cluster 05) for resistance to misuse.

---
source: practica-intent-action-layers.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/practica/msc/practica-intent-action-layers.md
source_commit: 938fb79ed9bd58b34374eb1122d86bb95fd817e8
categories: [intent-action-separation, coordination, interface-philosophy, cross-tier, backbrief, minimum-sufficient-set]
why_included: >
  May 20 2026. The sharpest agent-coordination interface-design statement in the estate. Intent (what/why, binding, persistent) and action (what-to-do/how, free, transient, derived) are different CONTENT layers, not a trade-off axis. Four UX/data-model entailments: type-separated Intent/Realization, two-levels-up intent visibility, backbrief as a first-class recurring operation, minimum-sufficient-set discipline as the intent-capture UX default. Itself a genuine cross-tier triangulation -- military doctrine (Moltke/Auftragstaktik) x AAT formalism x engineering (operata) read against each other, with tiers named honestly. Directly load-bearing for both UDON (structure-carries-intent) and the harness (what a task/handoff object must hold).
---

# Intent and Action as Different Content Layers: A Convergence Across Military Doctrine, Formal Theory, and Engineering Practice

**Abstract.** Practica is being built to coordinate composite work whose actors include serial language-model sub-agents under context-turnover and a human collaborator who may not be present in real-time. This paper takes up the question of what kind of *content* such a coordination substrate must hold. The conventional answer in task-tracking systems is *tasks* — units that fold *what we want* and *what to do* into the same kind of object. We argue the conventional answer collapses two structurally distinct content layers and produces friction that working systems eventually have to resolve. The structural fact: *intent* (the *what* and *why* of work, binding across actors, alignable, persistent) and *action* (the *what to do and how* of work, free per actor, derived from current state, transient) live at different content layers, related as orthogonal axes rather than as endpoints of a single trade-off. We read three independent identifications of this structural cut against each other: (a) the military-doctrine tradition (Moltke's 1869 *Guidance for Large Unit Commanders*, refined as *Auftragstaktik* / *mission command*, synthesized by Bungay in 2011 as the explicit 2×2 reframing); (b) AAT formalism (three sister derivations on a shared Section II substrate — `der-action-selection`'s state/action layering, `der-orient-cascade`'s resolution-ordering, `hyp-auftragstaktik-principle`'s bandwidth-allocation hypothesis); (c) engineering precedent (operata's pre-theory Intent / Realization data-model separation, and the unsolved *Cognitive Modes* friction the engineering recorded when trying to collapse the layers). Four normative implications for Practica fall out as conditional entailments: *type-separated Intent and Realization at the data-model level*; *two-levels-up intent visibility*; *backbrief as a recurring first-class operation*; *minimum-sufficient-set discipline as the intent-capture UX default*. The argument is comparative-descriptive; the entailments are conditional throughout; tier limits on the underlying claims (AAT's bandwidth-allocation prediction is at hypothesis grade; operata is convicted-of-shape, not validated-by-production; military doctrine is empirical-historical) are named honestly. The paper is the second in a small series; the first (`practica-structural-identity.md`) addressed Practica's *architecture* (the plumbing/intelligence split); this one addresses *what the architecture coordinates* (the content structure).

**Scope and audience.** Same as the companion paper. This is a comparative-descriptive piece for highly-literate but general peers; mild AAT familiarity is assumed; primary sources are cited by markdown footnote with local file paths and supporting quotes. Reading the companion paper first is helpful but not required.

---

## 1 — Introduction

A system like Practica must coordinate work where the actors are imperfect — serial LLM sub-agents under context-turnover, a human collaborator, none of them with full state of the others' history. *What kind of content does such a system hold?* The conventional answer in task-tracking systems is *tasks* — units of work, assigned to actors, with descriptions and statuses, intended to be completed in a specified order. The conventional answer treats *what to do* and *what to achieve* as variants of the same kind of content. The paper takes up the question of whether that answer is right.

The hypothesis examined here: *intent* (the *what* and the *why*, binding across actors, aligned vertically and horizontally, persistent across context-turnover) and *action* (the *what to do and how*, free per actor, derived from current state, transient) are structurally different *kinds of content*. They are not two ends of a single trade-off axis; they are properties of different layers. A task-tracking system that collapses them into a single content layer reaches for the friction that operata recorded as *cognitive-mode tension*; a coordination system that holds them at different layers does *not* face the same friction structurally.

The hypothesis has been independently identified across three traditions: military doctrine (Moltke's 1869 *Guidance for Large Unit Commanders*, refined into *Auftragstaktik* / *mission command*, synthesized for management practice by Bungay in 2011); AAT formalism (the derived result $a_t = \pi(M_t, G_t)$ — action is a function of state, derived each cycle, never stored); and engineering precedent (operata's Intent vs Realization data-model separation, reached pre-theory through engineering necessity). The three traditions arrived at the same central cut by very different paths.

This paper reads the three identifications against each other. §3 develops the military-doctrine version. §4 develops the AAT-formalism version, being explicit that AAT contributes three sister derivations on a shared Section II substrate rather than three independent corroborations of the 2×2. §5 develops the engineering version through operata. §6 names what the three traditions share and where the convergence stops. §7 traces normative implications for Practica's design under the convergence — specific directives that fall out as conditional entailments under the central cut. §8 names the limits and concludes.

This paper is the second in a small comparative-descriptive series on Practica's structural foundations. Paper 1 (`practica-structural-identity.md`) addressed Practica's *structural identity* — what it IS architecturally, namely a truthification scaffold with a plumbing/intelligence split. This paper addresses *what Practica coordinates* — the kind of content the plumbing layer holds. The two papers are independent in argument; their conclusions reinforce each other. Reading paper 1 first is helpful but not required for the convergence claim here.[^paper-series]

## 2 — The alignment-autonomy question (the conventional framing and the 2×2 alternative)

Most task-tracking systems implicitly take a position on the alignment-autonomy question. The position is rarely articulated; it is encoded in the data model and the affordances. A system with rich task-assignment, mandatory ordering, and strict completion-tracking encodes *high alignment with low autonomy* — the system specifies what each actor does and verifies that the actor did it. A system with loose work-claiming, freeform descriptions, and no enforcement encodes *high autonomy with low alignment* — actors choose what to do, and the system records the choices without coordinating them.

Both positions can be made to work for narrow domains. The strict-alignment regime works for well-understood routine work where the situation does not change and actors do not need to adapt. The loose-autonomy regime works for small co-located teams with high mutual trust and low coordination overhead. Both regimes break down under the conditions Practica is designed to coordinate: serial sub-agents under context-turnover, with the situation genuinely changing across cycles, where neither strict-alignment (the situation will outrun any pre-specified plan) nor loose-autonomy (no co-location, no shared real-time state) is viable.

The conventional framing treats this difficulty as a *trade-off*. The question is presented as: *how much alignment do we sacrifice for autonomy, or vice versa, given our coordination need?* The trade-off is presented as a single axis — visually, a line from "high alignment, low autonomy" at one end to "low alignment, high autonomy" at the other — with the practical question being where along the line a given organization or system should sit. Bungay's Figure 7 (§3.4) is the canonical visualization of this framing; he presents it as the strawman before introducing the alternative.

### 2.1 The 2×2 alternative

The alternative framing — Bungay's Figure 8, drawing on Moltke's 1869 doctrine — treats alignment and autonomy as *orthogonal axes*. Alignment is achieved around *intent* (the what and why); autonomy is granted around *action* (the how). The two axes do not compete for the same content. The top-right corner — high alignment AND high autonomy together — is reachable *because the two axes refer to different content layers*. Moltke's apparatus, refined over the Prussian and later German general staff tradition between 1857 and 1888 and consolidated in the 1869 *Guidance*, occupies this corner: *high alignment on intent, high autonomy on action.*

The 2×2 is not a stylistic preference for high-autonomy organizational cultures. It is a recognition that the trade-off framing misreads the structure. *Alignment and autonomy are not opposites at the same content layer; they are properties of different content layers.* Once the structural separation is made explicit, the trade-off framing collapses — the question is no longer "how much of each" but "what content goes at which layer."

### 2.2 Why the question matters specifically for Practica

For a single-user task-tracker, the alignment-autonomy question can be deferred or finessed: the user is both the intent-holder and the action-taker, and the friction of collapsed layers is borne entirely by them. For a multi-actor coordination system, the question is harder but still has familiar resolutions when the actors persist (long-term human teams; long-running services).

For Practica's specific conditions — *serial LLM sub-agents whose state does not persist beyond a single session, plus a human collaborator who may not be present in real-time* — the alignment-autonomy question becomes structurally load-bearing. The actors do not persist; the intent must. The actors cannot coordinate in real-time; the intent must support coordination *across* them rather than *among* them. The intent must be readable by a successor sub-agent who arrives cold, with no access to the deliberation that produced it; the actions must be derivable from current state by an actor with situation-specific information the intent-holder did not have. Under these conditions, the trade-off framing is not just misleading; it is *operationally impossible*: there is no shared persistent actor that could sit at any specific point along the trade-off axis.

The 2×2 framing supplies the structural resolution. Intent — held in durable, sharable, alignable form — coordinates across actors and across context-turnover. Action — derived per-actor, per-moment, from current state — adapts to situations the intent-holder did not foresee. The system's structural job is to hold the intent layer stably and to support deriving the action layer locally. This is the structural job paper 1 identified as the *truthification scaffold*; this paper makes the *content* of that scaffold explicit.

### 2.3 Preview of the argument

The next three sections (§3–§5) develop the three independent identifications of the 2×2 structure. §3 covers the military-doctrine tradition (Moltke 1869 → Bungay 2011), citing primary text where possible and acknowledging Bungay as the synthesis. §4 covers the AAT formalism, being explicit that AAT contributes a chain (one foundational claim plus two derived consequences) rather than three independent identifications. §5 covers operata's engineering precedent — the Intent / Realization data-model separation and the unsolved Cognitive Modes friction.

§6 reads the three traditions against each other, addresses the convergence count honestly (three traditions, not six loci), and traces what the convergence is and is not.

§7 takes up the normative implications. Under the central cut, several design choices that look like independent preferences become *entailments* — specific affordances and defaults that fall out of the 2×2 when applied to serial sub-agents under context-turnover. The trace is conditional throughout: if the central cut holds, the implications follow under specific conditions. §8 names the limits and concludes.

[^paper-series]: Paper 1 at `~/src/practica/msc/practica-structural-identity.md`. The two papers share scope (Practica's structural foundations) but cover different axes — paper 1 on architecture (the plumbing/intelligence split); paper 2 on content (the alignment-autonomy 2×2). The same audience scope applies: highly-literate but general peers; mild AAT familiarity assumed; primary sources cited via markdown footnotes with file paths and supporting quotes.
## 3 — The military-doctrine identification (Moltke 1869 → Bungay 2011)

The earliest identification of the alignment-autonomy 2×2 in any tradition this paper draws on is Helmuth von Moltke the Elder's 1869 *Guidance for Large Unit Commanders*. The doctrine that grew from it — known after the 1890s as *Auftragstaktik* and after the 1991 Gulf War as *mission command* — has been refined and partially-transferred across a hundred and fifty years of military practice. Stephen Bungay's 2011 *The Art of Action* is the synthesis of the doctrine for business-management practice; Bungay is the source we will cite most directly, but we should be clear that Bungay is *carrying Moltke forward* rather than originating the principle. The military-doctrine identification is one tradition with two voices: Moltke as primary, Bungay as synthesis. They are not two independent loci.

### 3.1 The Moltke 1869 directive form

The most distilled statement of the principle is from Moltke's 1869 *Guidance*. Bungay quotes it directly[^moltke-1869-rule]:

> "The rule to follow is that an order should contain all, but also only, what subordinates cannot determine for themselves to achieve a particular purpose."

The rule is bidirectional. Over-specification is a failure mode: an order that includes detail the subordinate could have inferred from context wastes coordination bandwidth and binds the subordinate to a plan that may be invalidated by changing conditions. Under-specification is also a failure mode: an order that omits something the subordinate cannot determine forces costly back-and-forth, or worse, leaves the subordinate to guess wrongly.

The discipline is *minimum-sufficient-set relative to the subordinate's existing knowledge state*. This is sharper than the more common "be high-level" advice that is sometimes attributed to Moltke. Both ends matter. The order must contain what the subordinate cannot determine — and nothing more.

### 3.2 *Befehl* and *Direktive*: the intention/task distinction

Moltke distinguished two kinds of communication downward: a *Befehl* (order, specifying action) and a *Direktive* (directive, specifying intention plus task)[^meckel-1877]. The standard wartime form was the *Direktive*. Bungay quotes the 1877 elaboration by Wilhelm von Meckel, one of Moltke's officers:

> "The first part of the directive was to give the subordinate freedom to act within the boundaries set by the overall intention. The intention was binding; the task was not."

*The intention was binding; the task was not.* This sentence is, as the working paper analyzing Bungay's chapter put it, the cleanest one-line summary of the apparatus. It carries the structural separation directly: *intention* (the *what* and the *why*) is held at one content layer and binds subordinates; *task* (the specific action) is held at a different content layer and does not bind. A subordinate is required to honor the intention but free to choose differently from the task if conditions change.

### 3.3 *Selbstständig denkender Gehorsam* — independent thinking obedience

The cultural formulation of the same structure comes from General von Schlichting, one of Moltke's acolytes, who coined the term *selbstständig denkender Gehorsam* — *independent thinking obedience*[^schlichting]. Bungay's description carries the structural claim:

> "A soldier did not have the choice whether to obey, but he was left free to choose *how* to obey."

The phrase is not a compromise between obedience and independence; it is a synthesis in which *both* are present at full strength, but at *different layers*. The soldier does not choose whether to honor the intention (binding); the soldier does choose how to act (free). The 1888 Field Service Regulations made the operational counterpart official: *"a failure to act or a delay is a more serious fault than making a mistake in the choice of means."* Action under uncertainty was preferred to delay; mistakes in the choice of means were structurally cheaper than the absence of action.

### 3.4 Bungay's 2×2 reformulation (Figs. 7 → 8)

The central conceptual move in Bungay's chapter on the doctrine — and arguably his most important contribution to the principle's transfer to management practice — is the rejection of the *alignment-versus-autonomy trade-off axis* in favor of an *orthogonal 2×2*[^bungay-reframing]. Bungay's framing:

> "Faced with a situation in which junior officers had a high degree of *autonomy*, in the sense that they were prone to take independent action, but the organization's actions were not *aligned*, because direction was not getting through from the top, most of us would think about the problem as a trade-off like that in Figure 7."

Figure 7 is the strawman: alignment and autonomy at opposite ends of a single line, with the only choice being where to sit along the line. Increasing alignment requires sacrificing autonomy; increasing autonomy requires sacrificing alignment. This is the conventional management framing of the question.

Bungay then identifies the move Moltke made:

> "Von Moltke's insight is that there is no choice to make. Far from it, he demands *high* autonomy and *high* alignment *at one and the same time*. He breaks the compromise. He realizes quite simply that the more alignment you have, the more autonomy you can grant. The one enables the other. Instead of seeing them as the end-points of a single line, he thinks about them as defining two dimensions, as in Figure 8."

Figure 8 is the 2×2: alignment as the vertical axis, autonomy as the horizontal, with the top-right corner — high-alignment and high-autonomy together — as the regime Moltke's doctrine occupies. The corner is reachable *because the two axes are not competing for the same content*. Bungay states this explicitly:

> "The insight is that alignment needs to be achieved around intent, and autonomy should be granted around actions. Intent is expressed in terms of *what to achieve and why*. Autonomy concerns the actions taken in order to realize the intent; in other words, about *what to do and how*."

Intent (binding, aligned) lives at one content layer; action (free, autonomous) lives at another. The 2×2 is not a stylistic preference for high-autonomy cultures; it is a recognition that the conventional trade-off framing has been misreading the structure all along. *Alignment and autonomy are not opposites; they are properties of different content.*

### 3.5 The cascade structure and backbriefing

The 2×2 is not self-implementing. Moltke's apparatus included a *cascade structure* — direction was short and high-level at the top, with each successive level adding the specification appropriate to that level's scope, and details of execution remaining verbal or local at the lowest levels[^cascade-structure]. Each level had to understand the intent at least one level above its own — what the working paper on Ch 3 calls *two-levels-up understanding*, drawing on Mellenthin's 1980 articulation: the person who receives an order must think at least one level above the one at which it was given.

The mechanism that maintained alignment across the cascade was the *backbrief*[^backbrief]. A subordinate, having received an intent, restated it in their own words and declared the action they planned to take in service of it. The senior level used the backbrief to verify alignment *before* execution — not after, when the cost of misalignment would have already been paid. The backbrief is a structural check; Bungay's later chapter (Ch 6) makes its recurring form explicit as a three-state question: *has the situation changed? No (continue) / Yes (change tasks, intent valid) / Yes (escalate, intent itself needs revision).*

The backbrief is one of two operational mechanisms (along with the cascade itself) that *make* the alignment-autonomy 2×2 implementable at scale. Without the backbrief, intent alignment is asserted but not verified; without the cascade, the level-of-detail problem is unsolved (over- or under-specification at every level).

### 3.6 The empirical record

The historical record of the doctrine's operational effect is part of what makes the principle hard to dismiss. The 1866 Königgrätz and 1870 Sedan campaigns demonstrated the doctrine's effectiveness against larger, more conventionally-organized opponents. Bungay quotes the 1888 Field Service Regulations as canonizing the cultural complement; he cites the 1910 tactical manual's retrospective characterization of the 1870 Colombey incident — where Brigadier von der Goltz attacked against his First Army's orders, in service of Moltke's higher intent — as *"one of the finest examples of spontaneous action taken within proper bounds."*

The doctrine has been refined and partially-transferred since: the British Field Marshal Bagnall's 1980s adoption (via the Higher Command and Staff Course), the NATO doctrine of *mission command* by the 1991 Gulf War, Jack Welch's 1981 reformulation as *"planful opportunism"* at GE. The depth of adoption varies by unit and organizational culture — Bungay flags this explicitly as the cultural-soil constraint: deepest in special forces, USMC, Royal Marines, submarine service; shallower in regular army units even after deliberate adoption[^cultural-soil].

The empirical record is what it is: a partial-transfer history of a doctrine that works under certain cultural and trust conditions. The structural insight (intent and action live at different layers) is independent of the transfer story; the *transfer story* tells us when adoption is likely to land and when it will produce a dead form.

### 3.7 The status of the military-doctrine identification

A clear scoping marker before §4 takes up the AAT formalism. The military-doctrine identification is *empirical and historical*. Moltke did not derive the 2×2 from first principles; he discovered it through operational practice with the Prussian army between 1857 and 1888 and consolidated it in the 1869 *Guidance*. Bungay's synthesis is a *historicization* and *application* of the doctrine for management practice — Bungay is not making the structural identification fresh; he is recognizing it in Moltke's apparatus and reformulating it as a 2×2 that business audiences can engage with.

This matters for the convergence argument in §6 in two ways. First, the military-doctrine identification is *not derived from a formal apparatus*. It comes from operational experience, codified into doctrine, refined over a century-plus of practice. The strongest claim that can be made for it is *empirical*: the doctrine has worked, repeatedly, under specifiable conditions. Second, Moltke and Bungay are *not two independent loci*. Bungay carries Moltke forward; the lineage is acknowledged in Bungay's own attributions. Counting them separately would inflate the convergence count without adding evidentiary weight. They are *one* tradition with two voices.[^one-tradition]

[^moltke-1869-rule]: Bungay 2011, *The Art of Action* Ch 3 (`~/src/_ref/books/Art-of-Action/parts/03-elements-of-a-solution.md` line 89, footnote 18) quoting Moltke 1869, *Guidance for Large Unit Commanders*: *"The rule to follow is that an order should contain all, but also only, what subordinates cannot determine for themselves to achieve a particular purpose."* The bidirectional discipline — neither over- nor under-specify — is what the working paper on this chapter calls the *minimum-sufficient-set discipline*.

[^meckel-1877]: Same source, Ch 3 (line 163), describing Wilhelm von Meckel's 1877 elaboration of the *Befehl* / *Direktive* distinction: *"Above all, the senior commander was not to tell his subordinate *how* he was to accomplish his task, as he would if he were to issue an order. The first part of the directive was to give the subordinate freedom to act within the boundaries set by the overall intention. The intention was binding; the task was not. A German officer's prime duty was to reason why."*

[^schlichting]: Same source, Ch 3 (line 159), describing von Schlichting's *selbstständig denkender Gehorsam*: *"A soldier did not have the choice whether to obey, but he was left free to choose *how* to obey. … One of von Moltke's acolytes, General von Schlichting, coined the phrase *selbstständig denkender Gehorsam* — 'independent thinking obedience.' The moral and emotional basis of Auftragstaktik was not fear, but respect and trust."* The 1888 Field Service Regulations canonized the operational consequence: *"a failure to act or a delay is a more serious fault than making a mistake in the choice of means."*

[^bungay-reframing]: Same source, Ch 3 (lines 111–127), the Figure 7 → Figure 8 reframing. *"Faced with a situation in which junior officers had a high degree of *autonomy* … but the organization's actions were not *aligned*, because direction was not getting through from the top, most of us would think about the problem as a trade-off like that in Figure 7. … Von Moltke's insight is that there is no choice to make. Far from it, he demands *high* autonomy and *high* alignment *at one and the same time*. He breaks the compromise. … The insight is that alignment needs to be achieved around intent, and autonomy should be granted around actions."* The 2×2 (Fig. 8) shows alignment as the vertical axis, autonomy as the horizontal, with the top-right (high alignment + high autonomy) as the regime Moltke's doctrine occupies.

[^cascade-structure]: Same source, the cascade structure is developed across Ch 3 with detailed treatment in Ch 5. Mellenthin's two-levels-up principle: the person who receives an order must think at least one level above the one at which it was given. The working paper on Ch 3 (`~/src/practica/msc/s3-working/03-elements-of-a-solution.md` §1.6) synthesizes the cascade mechanics.

[^backbrief]: Bungay Ch 3 treats backbriefing as the alignment-gap mechanism in *directed opportunism* (Fig. 9). The three-state form (no / yes-change-tasks / yes-change-objective) is from Ch 6's *change-of-mission protocol*; the strategy-briefing template in the book's Appendix puts the backbrief as the sixth (and recurring) section of the standard intent form.

[^cultural-soil]: Same source, Ch 3 (closing pages), the cultural-soil constraint: mission command is most deeply rooted in special forces / USMC / Royal Marines / submarine service / Nelsonian RN tradition; shallower in regular army units even after deliberate adoption. The named barriers are *risk aversion and careerism*. The cultural prerequisite is trust — across the hierarchy, both up and down — and trust requires constant work to build and is fragile.

[^one-tradition]: This is the first place I think the surface conditional voice undersells the conclusion. I would think it is hard to refute that Moltke and Bungay are one tradition, not two — Bungay explicitly cites and builds on Moltke; the structural insight (intent/action at different layers) is attributed to Moltke directly; the 2×2 reformulation is Bungay's contribution but operates on Moltke's material. The convergence count should reflect this honestly: military doctrine is *one* tradition with two voices, not two independent identifications. Treating them as separate would inflate the count without adding evidentiary weight, and I think that move is fairly defensible — but I want to flag the strength here in case a reader is tempted to count them separately.
## 4 — The AAT formalism (three sister applications of one substrate)

The Adaptation and Actuation Theory side of the convergence is *not* three independent identifications of the alignment-autonomy 2×2. It is three *applications of the same shared substrate* — Section II's agent-model structure ($X_t = (M_t, G_t)$; directed separation between belief-update and goal-conditioned work; action-as-function-of-state) — reaching three different specific conclusions: the existence of the state/action layer separation; the forced resolution-ordering of mismatch types; the IB-derived bandwidth-allocation priority for inter-agent communication. The three are sister derivations on a common foundation, not a strict chain of consequences. They share substrate but reach distinct results from distinct premises within the formalism. Honesty about this internal structure matters for §6's convergence count, and matters for how strongly the AAT side weighs against the military-doctrine identification.

### 4.1 `der-action-selection`: the foundational claim

The foundational AAT result for the alignment-autonomy structure is the statement that action is a function of the agent's complete internal state. In Section I scope (where $M_t$ is the entire internal state), this is[^action-selection-source]:

$$a_t = \pi(M_t)$$

For purposeful agents (Section II scope), the state lifts to $X_t = (M_t, G_t)$ — model substate plus goal substate — and the same argument gives:

$$a_t = \pi(M_t, G_t)$$

The status of this claim is *exact within Section I scope*[^action-selection-tier]. Not discussion-grade. Not hypothesis. The derivation is direct: $M_t$ is defined as the agent's complete internal record (by the form-agent-model commitment); action depends on internal state; therefore action is a function of $M_t$. Any deterministic or stochastic dependence of action on history *through the model* is captured by $\pi$. The Section II lift is exact under the same completeness argument applied to the lifted state.

The structural content for paper 2's purposes is in the words *function of*. Action is *derived from* the agent's state at each cycle; it is *not* a separate object that is stored and retrieved. The state is the durable thing; the action is the cyclical instantiation of $\pi$ at the current state. *State and action are at different content layers, by AAT's definition*. The state layer carries belief and goal; the action layer is the result of applying $\pi$ to the state layer.

This is the AAT statement of the structural separation that the military-doctrine identification (§3) reaches empirically through Moltke's *Befehl / Direktive* distinction. *The intention was binding; the task was not* (§3.2) is the operational consequence of $a_t = \pi(M_t, G_t)$ for a composite system: the state (objectives, models, situational understanding) is what coordinates; the action (specific tasks) is derived locally per actor from local state. The intention layer is shareable and shareable-stably; the task layer is derived per actor per moment and not durable. AAT supplies the formal version; Moltke supplies the operational version.[^foundational-strength]

### 4.2 `der-orient-cascade`: the resolution-order result

The orient-cascade is a separate AAT result, resting on directed-separation and the information-dependency between mismatch types rather than directly on `der-action-selection`. The two segments share the Section II substrate but the cascade's derivation does not flow *from* action-selection; both flow *from* the underlying agent-model structure. AAT's orient-cascade segment (verified in paper 1, §3.5) establishes[^orient-cascade-source]:

$$M_t \to A_O \to \Sigma_t \to O_t$$

Each step's input depends on the prior step's output. *You cannot evaluate strategy quality with a broken reality model* (step 3 requires step 1). *You cannot distinguish "locally bad strategy" from "locally unattainable goal" without both satisfaction-gap and control-regret* (step 3 requires step 2). *You should not revise the objective until you've verified that improving the model, the policy class, and the horizon cannot close the gap* (step 5 requires steps 3–4 plus escalation substeps).

The cascade ordering is *exact* — it is a logical consequence of which quantities appear in which formulas. Status: *claims-verified* tier in AAT's canon. What is not derived is the *timing* — how long the agent should spend on each step before proceeding.

For the alignment-autonomy 2×2: the cascade gives the *operational priority* of revisions. *Objective-revision is structurally the last resort*. This rhymes precisely with Moltke's discipline (*"the intention was binding; the task was not"*) and with the 1888 Field Service Regulations (*"a failure to act or a delay is a more serious fault than making a mistake in the choice of means"*) — both place the intent/objective layer as the most durable, with task/action revisions taking priority and objective revisions reserved for the case when the cascade has exhausted alternatives.

The cascade and action-selection are *sister results* on the same Section II substrate: action-selection answers *what action is* (a function of state); the cascade answers *which part of state to revise* when mismatch appears. The two questions are distinct; the two derivations are distinct; what they share is the Section II agent-model structure that makes both questions well-posed. *The cascade is not an independent corroboration of the alignment-autonomy 2×2*; it is what the same substrate says about resolution-order. The convergence-count clarification in §6 builds on this distinction.

### 4.3 `hyp-auftragstaktik-principle`: the bandwidth-allocation hypothesis

The third AAT segment in the cluster is the most explicitly Auftragstaktik-shaped. It applies the information-bottleneck framework to inter-agent communication bandwidth allocation and produces a qualitative prediction[^auftragstaktik-source]:

$$B_O \gt B_\Sigma \gt B_M$$

In words: for a composite agent with limited inter-agent bandwidth, invest in *objective sharing* first, *strategy coordination* second, and *model synchronization* third. *"Bits with longer shelf life and higher coordination value per bit should be transmitted first."* Objectives change slowly and enable autonomous coordination (sub-agents who share objectives can independently choose compatible strategies). Models change fast and provide diminishing coordination value (two agents with the same model but different objectives still conflict).

*The status of this claim is sharply weaker than the prior two.* It is *discussion-grade hypothesis*, draft stage. The source itself states this explicitly: *"Max attainable: empirical."* The formal IB derivation has not been completed. The priority ordering is a qualitative prediction *grounded in* the IB framework, *supported by* military-organizational evidence, but *not derived* under realistic cost functions.

There is also an explicit *regime-reversal* condition. From the canonical source:

> *"When the environment is genuinely ambiguous and local observations are insufficient (fog of war, novel codebase, unprecedented market conditions), model synchronization may be worth more than objective sharing — sub-agents who share the same wrong model at least err consistently, which is sometimes better than each having a different wrong model."*

The ordering is regime-conditional. Under conditions where local observations are insufficient, the ordering may flip — model-sync may dominate objective-sharing. *The priority is a prediction under specific regime assumptions*, not a universal truth about composite coordination.

This matters substantively for paper 2's convergence claim in §6. The convergence between AAT's hypothesis and the military-doctrine tradition's $B_O > B_\Sigma > B_M$ priority is *not* "AAT derives what Moltke discovered." Both are *empirical-grade* claims at present: AAT's IB-mechanism is a hypothesis supported by the same military-organizational evidence Moltke observed; Moltke's observation is a historical-empirical conclusion drawn from operational practice. The two sides converge on the *conclusion*, but they do not yet converge on a *derivation*. A future paper that closes the IB derivation under realistic cost functions would strengthen the convergence; until then, what is shared is the empirical conclusion and a plausible mechanism.

### 4.4 The within-AAT structure: three applications of shared substrate

The three AAT segments are sister applications on a common foundation, not three independent identifications:

- **State / action layering:** `der-action-selection` ($a_t = \pi(M_t, G_t)$) — *exact within scope*. Action is a function of complete internal state, derived each cycle, not stored. State and action live at different content layers by AAT's definition. This is the AAT statement most directly relevant to the alignment-autonomy 2×2's central cut.

- **Resolution-order:** `der-orient-cascade` (model → attainability → strategy → objective, ordered by information dependency) — *claims-verified*. The cascade names which part of state to revise when mismatch appears, and proves the ordering forced. Distinct derivation from action-selection; same Section II substrate.

- **Bandwidth-allocation:** `hyp-auftragstaktik-principle` ($B_O > B_\Sigma > B_M$) — *discussion-grade hypothesis*, regime-conditional. The IB framework applied to inter-agent communication produces a priority for what gets shared first. Distinct derivation from both action-selection and the cascade; same Section II substrate.

All three rest on the Section II agent-model structure (state $X_t = (M_t, G_t)$, directed separation between belief-update and goal-conditioned work, action-as-function-of-state). What they share is that substrate; what they do *with* the substrate is different in each case — articulate the structural cut (action-selection), order revision (cascade), or allocate bandwidth (IB hypothesis). The three are not three independent corroborations of the alignment-autonomy 2×2; they are three readings of the same underlying structure that each contribute different content to the 2×2's structural picture.

The fact that AAT has multiple sister applications reaching different conclusions from the same substrate is evidence that the *substrate* is doing real work — it supports analytical entry points from multiple directions within the formalism — but it is *not* evidence that three independent traditions identify the alignment-autonomy 2×2 structure. The substrate is one thing; the three derivations are not three traditions.

The internal multiplicity within AAT reflects the shared substrate's analytical reach, not three independent identifications of the alignment-autonomy 2×2. §6 takes up the cross-tradition convergence with this in mind.

### 4.5 The implicit/explicit fluency dimension (a related structural observation)

A side observation from the action-selection segment that bears on paper 2 indirectly. The discussion in `der-action-selection` distinguishes *implicit* action selection (model-embedded — Boyd's *implicit guidance and control*, trained intuition, organizational standard operating procedures) from *explicit* deliberation (Boyd's *Decide* step — planning, simulation, model-based deliberation)[^implicit-explicit]. The distinction is discussion-grade — qualitative properties that follow from the formalism but are not formally derived.

For paper 2's purposes, the implicit/explicit dimension *adds texture* to the action layer. The 2×2 says action is free per actor; the fluency dimension says action can be free-and-implicit (model-embedded reflex) or free-and-explicit (deliberated step). Both are at the action layer; both are derived from state; neither is stored independently. The fluency dimension matters for a practical system because it suggests *when deliberation is worth its tempo cost* — when implicit action is sufficient versus when explicit deliberation is needed. For a system with serial LLM sub-agents under context-turnover, this question becomes operational: most sub-agent moves should be implicit-from-state (the durable state should support implicit action); explicit deliberation should be reserved for moments where the stakes warrant it.

This is a normative implication that goes into §7. Naming it here so the AAT-side picture is complete.

[^action-selection-source]: `~/src/agentic-systems/01-aat-core/src/der-action-selection.md` — primary canonical home. Status: *derived*, *exact*, *deps-verified* stage. *"Action is a function of the agent's complete internal state. Under Section I scope … where $M_t$ is the entire internal state — this gives: $a_t = \pi(M_t)$ … When the internal state lifts to $X_t = (M_t, G_t)$ for purposeful agents (`#form-complete-agent-state`), the same structural argument gives $a_t = \pi(M_t, G_t)$ — action conditions on the complete internal state, which now includes the purposeful substate."*

[^action-selection-tier]: Same source, Epistemic Status: *"*Exact* within Section I scope. The derivation follows from #form-agent-model's completeness commitment: if $M_t$ is the agent's complete internal state (by definition), then action — which depends on internal state — is a function of $M_t$. The Section II generalization $a_t = \pi(M_t, G_t)$ is exact within Section II scope by the same argument applied to the lifted state $X_t$."*

[^foundational-strength]: I would think this correspondence is fairly hard to refute. AAT derives — from a completeness commitment on the agent's internal state — that action is a function of state. Moltke arrives empirically at the operational form: intentions (state) bind; tasks (action) do not. The two sides reach the same structural conclusion from very different starting points (one from formal completeness, one from operational practice). The conditional voice on the surface text understates how clean this particular alignment is — both directly converge on *state-as-binding, action-as-derived* — but I want to keep the conditional voice for tier discipline. The convergence on the *structural cut* is firmer than the convergence on the *priority ordering* (§4.3), which sits at hypothesis grade.

[^orient-cascade-source]: `~/src/agentic-systems/01-aat-core/src/der-orient-cascade.md` — canonical home, status `claims-verified`. *"$M_t \to A_O \to \Sigma_t \to O_t$. The ordering is not a design choice — it's a consequence of which quantities require which others."* The cascade ordering is *exact*; the 2×2 diagnostic (satisfaction-gap × control-regret) routes revisions in cascade order; objective-revision is structurally the last resort. Verified independently in paper 1 (`practica-structural-identity.md`) §3.5.

[^auftragstaktik-source]: `~/src/agentic-systems/01-aat-core/src/hyp-auftragstaktik-principle.md` — canonical home, status *discussion-grade* hypothesis, draft stage. The $B_O > B_\Sigma > B_M$ prediction is qualitatively motivated by the IB framework and supported by military-organizational evidence; the formal derivation has not been completed. *"Max attainable: empirical. The priority ordering is a qualitative prediction grounded in the IB framework and supported by extensive military-organizational evidence (Bungay's analysis of Clausewitz, Wehrmacht doctrine, modern mission command). But it is not derived — the IB optimization would need to be solved explicitly with realistic cost functions to confirm the ordering."* Regime-reversal: *"When the environment is genuinely ambiguous and local observations are insufficient (fog of war, novel codebase, unprecedented market conditions), model synchronization may be worth more than objective sharing — sub-agents who share the same wrong model at least err consistently, which is sometimes better than each having a different wrong model."*

[^implicit-explicit]: `der-action-selection.md` Discussion: *"Implicit (model-embedded): When $\pi(M_t)$ can be evaluated cheaply — the model has internalized effective action-selection for the current situation. This is Boyd's implicit guidance and control (Orient→Act, bypassing Decide) … Explicit (deliberative): When the situation is novel, the action space is large, or the stakes demand verification — the agent engages in internal simulation, using the model to predict outcomes of candidate actions before selecting. This is Boyd's explicit Decide step …"* The implicit/explicit distinction itself is *discussion-grade* — a qualitative property that follows from the formalism. The structural pressure toward implicit action (faster mode preferred under the persistence condition's tempo penalty) is grounded in `#der-deliberation-cost`.
## 5 — The engineering identification (operata's Intent / Realization separation)

The engineering side of paper 2's convergence is operata's pre-theory data-model crystallization. The same operata that appears in paper 1 (as the named-precedent of the plumbing/intelligence split) here serves a different function: its core resource decomposition *enacted* the alignment-autonomy 2×2 by data-model construction, with the structural separation visible in the resource definitions themselves. Operata's documentation does not articulate the separation as "intent-binding-and-aligned versus action-free-and-autonomous" — the doctrinal vocabulary is not operata's. But the structural commitment is in the data model.

### 5.1 The two resources that matter for paper 2

Operata's domain model defines four resources — Effort, Intent, Realization, and Perspective[^operata-resources]. Two are load-bearing for paper 2: **Intent** and **Realization**.

> *Intent: A desired state or outcome; the core unit of Operata. Unlike traditional "tasks" which describe actions, intents describe states we want to achieve. This inversion enables back-planning.*
>
> *Realization: What actually happened when working on an intent. Captures the gap between expectation and reality, supporting the principle of preserving intent.*

The structural separation is in the type signatures. *Intent* holds a desired state — *what we want to achieve* — and is amenable to being held stably across actors and across time. *Realization* holds *what happened* — execution trace from one specific cycle, by definition per-actor and transient. *Intent* records do not carry execution traces. *Realization* records do not carry goal content. The data model enforces the separation.

The semantic content of each resource maps directly onto the alignment-autonomy 2×2 from §3:

- *Intent* is the **binding, aligned** content. It is shareable across actors. It can be aligned vertically (parent intents constrain child intents) and horizontally (peer intents around a shared higher-level intent). It is durable; the same intent can persist across many cycles and across many serial sub-agents.
- *Realization* is the **free, autonomous** content. Each actor's realization is per-actor; it is the record of what that actor did and what happened, not constraint on others. It is transient; realizations accumulate as the trace of execution, but no realization binds future actors.

This mapping is operationally tight. Operata's data model is the AAT-style state-not-action structure (§4.1) realized as a CRUD schema. It is also the Moltke/Bungay *intent binding / task free* structure realized as a CRUD schema. The mapping was reached *without operata explicitly engaging either tradition* — by the engineering pressure of building a system that needs to support back-planning (start from desired state; find what enables it) while also supporting honest reporting of what actually happened.

### 5.2 The "Cognitive Modes" tension: engineering meeting the structure honestly

A second piece of operata's documentation matters more than the first for paper 2's argument, because it shows operata *encountering* the structural separation through engineering necessity rather than recognizing it in advance. Operata's TODO contains an entry titled *Cognitive Modes: Intent vs Action*[^operata-cognitive-modes]:

> *"The tension: Intent-oriented framing ('what states need to exist?') is excellent for planning and understanding dependencies. But execution requires a different cognitive mode ('what will I do next, in what order?'). Forcing execution into the intent graph creates friction."*

Three proposed resolutions are listed; none were settled before operata's abandonment.

The substantive content for paper 2: operata *discovered* that the intent layer and the action layer are *cognitively distinct* through the friction of trying to make one layer carry both kinds of content. The intent-oriented framing was the right register for *planning* (back-planning, dependencies, what-needs-to-be-true); a different register was needed for *execution* (what-to-do-next, sequencing). The friction was not a UX problem solvable by polish; it was a structural fact about the kinds of content the system held.

This is exactly the failure mode the alignment-autonomy 2×2 names. Trying to hold intent and action at the same content layer creates the conflict that Moltke's *Befehl / Direktive* distinction resolved by separation. Operata met the structural fact through engineering pressure; the resolution operata reached toward — separate cognitive modes for separate content — is the same resolution Moltke and Bungay identified in different vocabulary.

The honest texture matters here. *Operata did not solve the friction.* It named the tension; it sketched three possible resolutions (a Session/Plan layer; a lightweight wrapper; an Intent `approach` field); it left the question open at abandonment. The engineering identification is *evidence that the structural separation is real* (a system that tried to ignore it hit measurable friction), but it is not evidence that operata had a refined design for handling the separation. The data-model separation between Intent and Realization is real and worked; the cognitive-mode separation between planning and execution remained an unresolved engineering problem.

### 5.3 What the engineering side establishes

A short summary before moving to §6.

The operata engineering identification establishes:

- That the *data-model separation* between desired-state and what-happened is reachable by engineering necessity, without needing either AAT's formal apparatus or military-doctrine vocabulary. Pre-theory crystallization is possible because the structural fact is real.
- That when a working system *attempts* to collapse intent and action into a single layer (e.g., by treating both as variants of "task"), it *encounters* friction — the *Cognitive Modes* working note is the friction recorded in operata's own voice. The friction is itself empirical evidence that the structural separation is not optional.
- That the data-model side is the *easier* of the two separations: holding Intent and Realization as type-separated resources is engineering-tractable. The harder separation — *cognitive-mode* separation between planning and execution — is unsolved by operata at abandonment and remains open.

What the engineering side *does not* establish:

- That operata's specific decomposition (Effort + Intent + Realization + Perspective) is the *right* decomposition. Other engineering choices are possible. What is established is that *some* type-separated decomposition is forced.
- That operata's design has been validated by sustained production. As noted in paper 1, operata was abandoned at 30/30 BDD-green; the engineering contracts held under test, but the system did not operate under sustained real-world use. *Convicted of the shape*, not *validated by production* — the same scoping as paper 1.[^engineering-scoping]

The convergence reading in §6 should weigh the engineering identification accordingly: real evidence of structural shape; bounded evidence of design correctness.

[^operata-resources]: `~/src/operata/docs/glossary.md` §"Core Domain": *"Effort: A bounded initiative with origin, intent, and temporal span. Intent: A desired state or outcome; the core unit of Operata. Unlike traditional 'tasks' which describe actions, intents describe states we want to achieve. This inversion enables back-planning. Realization: What actually happened when working on an intent. Captures the gap between expectation and reality, supporting the principle of preserving intent. Perspective: Contextual focus—who's looking and what matters to them."* The data-model separation between Intent and Realization is enforced at the resource definition level — Intent records do not carry execution traces; Realization records do not carry goal content.

[^operata-cognitive-modes]: `~/src/operata/TODO.md` §"Cognitive Modes: Intent vs Action": *"The tension: Intent-oriented framing ('what states need to exist?') is excellent for planning and understanding dependencies. But execution requires a different cognitive mode ('what will I do next, in what order?'). Forcing execution into the intent graph creates friction. … Three potential directions (to be discussed, chosen from, or integrated): 1. Session/Plan layer — First-class execution-order concept … 2. Lightweight wrapper — Session references intents but doesn't own them … 3. Intent `approach` field — Bridges the state→action gap."* Open at abandonment.

[^engineering-scoping]: Same convicted-of-shape / not-validated-by-production scoping as paper 1, §4.6 of `~/src/practica/msc/practica-structural-identity.md`. Operata's 30/30 BDD-green status at abandonment is non-trivial — the engineering contracts held under test — but sustained production use would have exposed integration failure modes and edge cases that pre-production engineering does not surface. The data-model separation between Intent and Realization is verified at the contract level; the broader design has not been validated by sustained use.
## 6 — The convergence

Three traditions reach the alignment-autonomy 2×2 by different paths. *Military doctrine* (Moltke 1869 → Bungay 2011) arrived empirically through a century-plus of operational practice; the doctrine names *intent binding, task free* as the operational structure that makes large-scale composite coordination tractable. *AAT formalism* (`der-action-selection`) derived the structure formally from a completeness commitment on the agent's internal state — action is a function of state, not stored. *Engineering* (operata's Intent / Realization data-model separation) reached the structural cut by the friction of trying to build a coordination system that could not collapse the two layers.

What the three traditions share, where they differ, what the convergence is and is not — these are this section's content.

### 6.1 What the three traditions share

The shared content is more compact than paper 1's four structural commitments. The alignment-autonomy 2×2 reduces to a single structural fact stated in each tradition's vocabulary:

| Tradition | Statement of the same structural fact |
|---|---|
| Military doctrine (Moltke / Bungay) | *"The intention was binding; the task was not."* Intent (what + why) aligned; action (how) free. |
| AAT formalism | $a_t = \pi(M_t, G_t)$ — action is a function of the complete internal state, derived each cycle. State and action live at different content layers by completeness. |
| Engineering (operata) | Intent (desired state) and Realization (what happened) are type-separated resources. Intent records do not carry execution traces; Realization records do not carry goal content. |

Three vocabularies; one structural cut. *Intent is durable, sharable, and binds. Action is per-actor, per-moment, and derived from current state.* The three traditions agree on this central content. They differ on what they each *add* beyond the central content — §6.2 traces the specifics.

### 6.2 Specific correspondences (and asymmetries)

The correspondences across the three traditions, with the asymmetries flagged:

| Concept | Military doctrine | AAT formalism | Engineering (operata) |
|---|---|---|---|
| The structural cut | Intent / Task (Meckel 1877) | State / Action (`der-action-selection`) | Intent resource / Realization resource |
| The cut's status | Empirical-doctrinal; operationally proved over 150 years | Derived from completeness, *exact within scope* | Data-model enforcement; engineering-pre-theory |
| Specification discipline | *"All but only what subordinates cannot determine"* (Moltke 1869) | Minimum-sufficient-set is implicit in $\pi(M_t)$'s economy | *"Inversion enables back-planning"* — Intent describes states, not actions |
| Resolution-order discipline | Cascade with backbrief; objective revision last | `der-orient-cascade` proves the ordering forced by information dependency | Not articulated; would have lived in the unbuilt Session layer |
| Bandwidth-allocation priority | *$B_O > B_\Sigma > B_M$* (empirical, military-organizational evidence) | *$B_O > B_\Sigma > B_M$* (IB-hypothesis, regime-conditional) | Not explicit in operata's documentation |
| Regime-reversal conditions | Not explicit in 1869 *Guidance*; partially implicit in cascade fallback | Explicit: under genuine ambiguity, model-sync may dominate objective-sharing | Not addressed |
| Cultural / trust prerequisite | Explicit: "the cultural-soil constraint" (Ch 3 closing) | Not addressed directly | Implicit in the team-collaboration assumption; not articulated |

Several asymmetries matter. The military-doctrine tradition has the *richest operational vocabulary* — the cascade, backbriefing, freedoms and constraints, the 70% rule, the cultural-soil constraint. AAT supplies the *firmest derivation* of the central cut (exact within scope) but adds less operational detail. Engineering supplies the *cleanest data-model realization* of the central cut but has the weakest articulation of resolution and cultural-soil conditions. Each tradition has texture the others lack. *The convergence is on the central cut; the differential texture is where the traditions complement each other.*

The bandwidth-allocation priority — the $B_O > B_\Sigma > B_M$ ordering — is in a different category from the central cut. It is shared by the military-doctrine tradition (operationally) and AAT (as hypothesis), but *both are empirical-grade in their current form*. The military-doctrine claim is grounded in operational practice; the AAT claim is grounded in IB-framework reasoning supported by the same operational evidence. The convergence on this priority is weaker than the convergence on the central cut, and §6.4 addresses its regime-conditional limits.

### 6.3 Why the convergence is meaningful evidence

Three reasons. They are similar to paper 1's §5.4 but adapted for this convergence.

**First: disjoint-failure-modes across the three traditions.** Military doctrine's failure modes are about historical contingency (would a different military culture have arrived at a different structure?) and operational selection (did the doctrine survive because it works, or because Prussia/Germany was already structurally advantaged?). AAT's failure modes are about formal-derivation choices (does the completeness commitment on internal state import the conclusion, or is it earned from independent assumptions?). Engineering's failure modes are about framework-author preferences and tooling constraints (would different framework authors have chosen different decompositions?). The three sets of failure modes are largely disjoint — what would lead one tradition astray would not lead the others astray. When three methods with disjoint failure modes converge on the same central cut, the cut is more likely structurally forced than method-artifactual.

**Second: the central cut is non-obvious.** Many task-coordination systems collapse intent and action into a single content layer ("tasks" carry both purpose and procedure). Many management writing-style guides treat alignment and autonomy as a single trade-off axis (Bungay's Figure 7 strawman is real — it is what most management-practice writing actually does). Many engineering attempts at coordination tools start with a unified data model and discover the friction later (operata's *Cognitive Modes* working note is the friction recorded). *The 2×2 reframing is not what working systems default to; it is what they reach for after the failures of the unified-layer framing become visible.*

**Third: the convergence has design content.** §7 traces specific normative implications that fall out of the central cut — the data-model separation between intent records and execution traces; the two-levels-up intent visibility from the cascade structure; the six-section briefing template that operationalizes the minimum-sufficient-set discipline; the backbrief as the recurring alignment-verification mechanism; anti-goals as first-class content. These design implications are coherent as a set *because* they all flow from the central cut. The convergence has predictive content: certain design choices that look like independent preferences become entailments under the structural identification.

### 6.4 Where the convergence stops

Three limits, named honestly before §7 takes up the normative implications.

**The bandwidth-allocation priority is regime-conditional.** The $B_O > B_\Sigma > B_M$ ordering is the convergence's weakest link. Both the military-doctrine tradition and AAT acknowledge regime-reversal conditions — under genuine ambiguity (fog of war; unprecedented conditions; novel domains), model-synchronization may dominate objective-sharing. The convergence on this priority is on the *typical regime*, not on a universal ordering. Paper 2 must carry this when drawing normative implications from the priority — it is a default, not a universal.

**The structural cut is silent on cultural prerequisites.** Bungay's cultural-soil constraint (§3.6) is real and load-bearing: mission command does not transfer into organizations whose existing culture cannot support it. The AAT formalism does not address cultural prerequisites; operata's engineering identification does not articulate them. The central cut is *necessary* for composite coordination under conditions like Practica's; it is not *sufficient*. A team adopting tooling built on the cut will get value bounded above by the cultural soil's tolerance for trust, honest mistakes, and freedom-within-bounds.

**The cut does not specify implementation.** Three traditions agree on the central separation but disagree on (or are silent about) specific implementations. Moltke's six-section briefing template is one operationalization; operata's four-resource decomposition is another; AAT does not prescribe a specific implementation. The convergence is on *what the system must structurally distinguish*; it is not on *what the implementation must look like*. §7 traces normative implications carefully — naming what follows structurally versus what is one specific instantiation among several.

## 7 — Normative implications for Practica (conditional)

If the central cut — *intent binding-and-aligned at one content layer, action free-and-autonomous at another, derived from state each cycle* — captures a structural fact about composite coordination, then several design directives for Practica fall out as *entailments* rather than independent preferences. This section traces four: *type-separated intent and realization resources at the data-model level*; *two-levels-up intent visibility*; *backbrief as a recurring first-class operation*; *minimum-sufficient-set discipline as the intent-capture UX default*.

The traces follow paper 1's pattern (§6): conditional voice throughout; the entailments hold *if* the structural identification holds; what each entailment does and does not specify is named explicitly.

### 7.1 Type-separated Intent and Realization at the data-model level (N1)

**The design directive.** Practica's plumbing-layer data model must hold *Intent* records and *Realization* records as structurally distinct resources, with type signatures that prevent intent from carrying execution-trace content and prevent realization from carrying goal content.

**The entailment.** Under the central cut, intent and action live at different content layers (§3.4, §4.1, §5.1). A data model that puts both kinds of content at the same layer — e.g., a single *Task* resource holding "what we want" and "what we did" as fields of the same object — forces actors to read both kinds of content together and prevents stable alignment on the intent layer alone. Operata's *Cognitive Modes* working note (§5.2) is the friction this collapse creates: trying to hold planning content and execution content in the same cognitive register fails for non-trivial coordination, and the failure mode is structural rather than cosmetic.

The type-separation directive follows because *the layers serve different functions* (alignment-and-coordination on the intent layer; per-actor-derivation on the realization layer) and because *the failure mode of collapsed layers is empirically observed* (operata) and *structurally predicted* (the AAT-formalism statement that action is derived from state, not stored — putting them at the same layer asserts that action is durable like state, which contradicts the foundational claim).

**What this does not specify.** The specific schema (operata's Intent / Realization / Perspective / Effort is one decomposition; not the only viable one). The specific storage substrate (SQLite, append-only log, content-addressed objects, git-tracked plain text — all compatible with the structural commitment). The specific UX affordances (the directive constrains the data-model commitment; the surface presentation has degrees of freedom). The directive requires *type-separated resources with no shared content schema between intent and realization*; the implementation has room.

### 7.2 Two-levels-up intent visibility (N2)

**The design directive.** Practica's intent-record schema must support reading the parent intent (one level up) and the parent's parent intent (two levels up) from any current intent. The visibility is structural — embedded in the data model — not merely a query convenience.

**The entailment.** The cascade structure (§3.5) is what makes intent-alignment-at-scale tractable. Direction is short at the top and adds appropriate detail at each level down. For a subordinate to act in service of higher intent when the situation changes — to make Moltke's "what would my superior order me to do if he were in my position and knew what I know?" — the subordinate must be able to *see* the higher intent. Mellenthin's two-levels-up rule is operationally precise: one level is not enough when things change (the immediate parent may be wrong about the larger context); three levels is no additional help (the constraints from three levels up are too abstract to inform a specific decision); two levels is structurally just right.

The directive follows from the cascade structure applied to serial sub-agents. A successor sub-agent who arrives cold must be able to reconstruct alignment without access to the deliberation that produced it; the data-model commitment makes the higher intent legible to the cold-arriving sub-agent without requiring oral handoff. AAT's `der-orient-cascade` (§4.2) gives the formal version: the cascade ordering is forced by information dependency; the visibility-of-higher-intent is what allows a cold-arriving actor to participate in the cascade at all.

**What this does not specify.** Whether visibility is by direct field references, by query traversal, by denormalized inheritance, or by other schema choices. Whether more than two levels can be visible (the entailment requires at minimum two; more is not forbidden). Whether the affordance is automatic or actor-requested. The directive requires *the higher-intent visibility be available at the data-model level*; surfacing it is a UX choice.

### 7.3 Backbrief as a recurring first-class operation (N3)

**The design directive.** Practica must support *backbrief* as a first-class operation on intents. A backbrief is a structured artifact in which the receiving actor (a) restates the intent in their own words, (b) declares the planned action they intend to take in service of the intent, and (c) makes the three-state determination from Bungay's Ch 6 *change-of-mission protocol*: *no — brief still valid* / *yes — change tasks but objective valid* / *yes — change what we're trying to achieve, escalate*.

**The entailment.** The backbrief is the alignment-verification mechanism that makes the cascade structure operational (§3.5, §4.2). Without it, intent-cascade is assertion-without-verification: each level passes intent downward and hopes for alignment; misalignment is discovered only when execution fails. With the backbrief, each level confirms alignment *before* execution and surfaces misalignment when it can still be corrected at low cost. For Practica's serial sub-agents under context-turnover, the backbrief is even more load-bearing than in the military-doctrine instance: the cold-arriving sub-agent's backbrief is *the only way* the system has of verifying that the inherited intent has been animated correctly in the new context. The handoff is not a transfer of state; it is an invitation to re-author. The backbrief is the protocol of re-authoring.

The three-state determination is the part that makes the backbrief a recurring operation rather than a one-time check. *Has the situation changed?* must be answerable repeatedly, with the three options branching the system's response: continue, revise tasks within unchanged intent, or escalate the intent itself for revision (cascade-up to the level whose intent is implicated).

**What this does not specify.** The format of the backbrief (free text; structured fields; mixed). The cadence of the recurring check (per-cycle; per-trigger; per-elapsed-time). The escalation mechanism for the third branch. The directive requires the *operation* — restate, declare action, three-state determination — be supported as a first-class artifact tied to a specific intent. The form of the artifact has degrees of freedom.

### 7.4 Minimum-sufficient-set discipline as the intent-capture UX default (N4)

**The design directive.** Practica's intent-capture UX must make the *minimum-sufficient-set discipline* — *all but only what subordinates cannot determine for themselves to achieve a particular purpose* — the natural state. Specifically: (a) intents are committable in incomplete states (Moltke's *70%-right* rule); (b) the UX surfaces *what is known* and *what is deliberately left for the sub-agent*, separately, so that under-specification is visible; (c) the UX does not require all fields to be filled before save.

**The entailment.** Under the central cut, action is derived from state by the local actor at the moment of action (§4.1). The intent-author cannot know what the action-taker will know; the intent-author cannot specify what should be left for the action-taker without making that explicit. The minimum-sufficient-set discipline is what makes the cut workable in practice: over-specification binds the action-taker to a plan that may be invalidated by changing conditions; under-specification forces back-and-forth.

A UX that demands completeness on intent capture (every field filled before save; all subtasks enumerated before commit) enforces over-specification structurally. Moltke's 1869 rule (§3.1) is explicit that both ends matter: include what subordinates cannot determine, *but also only* what they cannot determine. The 70%-right rule is the operational stopping criterion. For a UX, this translates to: an intent is committable as soon as the minimum-sufficient-set is captured; further refinement is allowed but not required.

The visible separation of *what is known* and *what is deliberately left open* is the operational form. A field marked *"deliberately left for the sub-agent"* is structurally different from a field that is *"empty because not yet considered"* — the first is a deliberate latitude; the second is an unfinished intent. The UX should distinguish them.

**What this does not specify.** The specific UX affordances (field-by-field commit; structured templates with optional sections; freeform with structural prompts; etc.). The minimum schema for an intent (what makes the minimum-sufficient-set; the answer is domain-dependent). The directive requires the *discipline* — incomplete-commits supported, what-is-deliberately-open visible, no completeness gating — as the UX default. The specific interface has room.

### 7.5 What the four directives do not cover

A brief scoping note before §8 takes up limits.

The four normative implications above are not exhaustive. The Ch 3 working paper §4 (Applicability) lists several other directives that follow from the same central cut: a *Think-Do (Learn-Adapt) cycle* as the natural cadence (corresponding to AAT's orient cascade run repeatedly); *anti-centralization-under-stress defaults* that resist the user's instinct to over-specify when things look bad; *refuse-with-reason as a first-class operation* allowing a sub-agent to surface "I am not doing this; here is what I am doing instead; here is why it still serves the higher intent"; *configurable proportionality of strategy / execution / tactics levels* per team domain. Each of these can be traced as a conditional entailment under the central cut. Paper 2 names four because they are the most structurally load-bearing for the central cut; a fuller normative-implications treatment would extend the trace.

Two of these — the cadence directive and the refuse-with-reason operation — interact with paper 1's structural identification (§6 of paper 1) more directly than with paper 2's central cut. The cadence is shaped by the persistence-inequality and Brooks's-Law tempo cost from paper 1; the refuse-with-reason operation requires the type-signed boundaries between belief-update and goal-conditioned work from paper 1's (S1). Tracing them belongs in a future paper that reads the two structural foundations together, not in this paper's scope.

The directives this paper traces all share a property: they are *structural commitments* of the data model and the supported operations. They are not UX preferences; they are *what the data model must enforce* if the central cut is to operate. Surface UX has freedom; the structural commitments do not.
## 8 — Honest limits and conclusion

This paper has presented a comparative-descriptive reading of three traditions' independent identifications of the alignment-autonomy 2×2, addressed the convergence count honestly, and traced four normative implications for Practica as conditional entailments. The voice has been calibrated throughout. This closing section names the limits more directly than the body sections have, so the reader can locate where the paper's argument stops and where future work would need to continue.

### 8.1 What the military-doctrine side does not establish

Two limits.

*The doctrine is empirical-historical, not formally derived.* Moltke did not derive the 2×2 from first principles; he discovered it through Prussian-army operational practice between 1857 and 1888 and consolidated it in the 1869 *Guidance*. Bungay's 2011 synthesis historicizes the doctrine for management practice without supplying a formal derivation. The military-doctrine identification's strongest claim is *empirical*: the doctrine has worked, repeatedly, under specifiable conditions. A reader who wants a formal derivation must look to the AAT side (§4); the military-doctrine side supplies operational evidence and articulated mechanism (cascade, backbrief, freedoms and constraints), not a derivation.

*The cultural-soil constraint is load-bearing.* Bungay's Ch 3 closing pages name the constraint: mission command does not transfer into organizations whose existing culture cannot support it. The named barriers are *risk aversion* and *careerism*. The cultural prerequisite is *trust* across the hierarchy, both up and down, and trust requires constant work to build and is fragile. Practica deployed in an organization without that cultural soil will produce a *dead form* — the apparatus in place, the structural separation in the data model, the affordances available — but without the trust substrate, the form will not animate. This is not a problem the structural identification can solve; it is a limit of when the structural identification can be acted on.

### 8.2 What the AAT side does not yet establish

The AAT segments cited in §4 are at different tiers.

- `der-action-selection` is at *exact within Section I scope*, *deps-verified* stage. This is the strongest AAT result this paper draws on. The structural cut between state and action is firmly grounded.
- `der-orient-cascade` is at *claims-verified* (verified in paper 1, §3.5). The cascade *ordering* is exact; the *timing* is not derived.
- `hyp-auftragstaktik-principle` is at *discussion-grade hypothesis*. The $B_O > B_\Sigma > B_M$ ordering is a qualitative prediction grounded in the IB framework, supported by military-organizational evidence, but *not derived* — the source explicitly notes that *the IB optimization would need to be solved explicitly with realistic cost functions to confirm the ordering*.

The aggregate AAT-side claim — that the alignment-autonomy 2×2 follows from foundational AAT machinery — rests at the *strongest* tier of `der-action-selection` for the structural cut, and at the *weakest* tier of `hyp-auftragstaktik-principle` for the bandwidth-allocation priority. Future work that closes the IB derivation under realistic cost functions would lift the bandwidth-priority claim to derived tier; until then, that part of the AAT side remains empirical.

A second limit: the AAT formalism is silent on cultural prerequisites. The Section I and Section II machinery operate on adaptive agents under specified conditions; *cultural fit*, *organizational trust*, and similar conditions are outside the formalism's scope. The AAT side strengthens the structural cut and adds derivation-rigor; it does not address when the cut is adoptable.

### 8.3 What the engineering side does not establish

The same convicted-of-shape / not-validated-by-production scoping as paper 1. Operata's 30/30 BDD-green status at abandonment is non-trivial — the engineering contracts held under test — but sustained production use would have exposed integration failure modes and edge cases that pre-production engineering does not surface. The data-model separation between Intent and Realization is verified at the contract level; the broader design has not been validated by sustained operational use.

A more specific limit, recorded in operata's own voice: the *Cognitive Modes* tension between intent-oriented framing and execution-mode framing was *named* but *unresolved* at operata's abandonment. Three possible resolutions were sketched; none were chosen. Operata's engineering identification is therefore evidence that the friction is real and structural, *not* evidence that operata had a refined design for handling it. A successor implementation of Practica that ships the Intent / Realization separation may inherit the same friction unless it also resolves the planning-vs-execution cognitive-mode question that operata left open.

### 8.4 What the convergence does not promise

The convergence is at the level of *the central structural cut*. It is *not* at the level of:

- Specific decomposition of the intent layer (operata's Effort + Intent + Perspective is one decomposition; not the only viable one).
- Specific implementation of the backbrief (free text; structured fields; mixed; cadence and escalation choices are all open).
- Specific representation of cross-cutting intent links (two-levels-up visibility can be by reference, by query traversal, by denormalization).
- Specific UX affordances for the minimum-sufficient-set discipline.

The convergence is on *what the system must structurally distinguish*; it is not on *what the implementation must look like*. §7's four normative implications are *structural commitments* — what the data model must enforce — not UX specifications.

The convergence also does not promise that Practica, built on these commitments, will succeed. Success depends on execution, on the cultural soil (§8.1), on whether the team adopting Practica is ready for the kind of work the central cut requires. The 2×2 is *necessary* for composite coordination under Practica's conditions; it is not *sufficient*.

### 8.5 Conclusion

A working hypothesis: *intent* (binding, aligned across actors, persistent across context-turnover) and *action* (free per actor, derived from state, transient) live at structurally different content layers. The 2×2 framing of alignment and autonomy is not a stylistic preference for high-autonomy cultures; it is a recognition that the conventional trade-off framing has been misreading the structure. The hypothesis has been examined by reading three independent identifications of the central cut against each other — the military-doctrine tradition (Moltke 1869 → Bungay 2011); AAT formalism (`der-action-selection` as foundational, plus two derived consequences); and engineering precedent (operata's Intent / Realization separation, reached pre-theory through engineering necessity).

The convergence count is *three traditions*, with internal multiplicity in the AAT side that reflects the shared substrate's analytical reach rather than three independent corroborations of the 2×2.

Four normative implications fall out as conditional entailments under the central cut: *type-separated Intent and Realization at the data-model level*; *two-levels-up intent visibility*; *backbrief as a recurring first-class operation*; *minimum-sufficient-set discipline as the intent-capture UX default*. Each is structurally derived under the cut; each leaves implementation choice open. The conditional voice on the entailments is not stylistic; it reflects the dependence on the structural identification holding.

This paper's contribution is the comparative reading and the conditional normative trace. It does *not* derive the structural identification from first principles (parts of the AAT side are still at hypothesis tier); it does *not* validate the engineering precedent through sustained production (operata abandoned at 30/30 BDD-green); it does *not* substitute for the cultural-soil prerequisite (the doctrine works only where trust is present and protected).

A successor — agentic or human, reading this in days or in years — has three directions of useful work. *Close the IB derivation under realistic cost functions*, which would lift the bandwidth-priority claim from hypothesis to derived. *Implement the four normative directives* in a Practica-shaped system shipping to production, and learn what additional structure the planning-vs-execution friction (operata's *Cognitive Modes* tension) requires. *Extend the normative trace* to the other directives §7.5 named — cadence, refuse-with-reason, configurable proportionality, anti-centralization-under-stress — which fall out of the central cut but also interact with paper 1's structural identification and would benefit from a combined reading.

A final reflexive note on the paper-series. Paper 1 identified Practica as a truthification scaffold; paper 2 identifies what such a scaffold *coordinates*. The two papers are independent in argument but converge in conclusion: Practica's structural job (paper 1) is to hold content in a particular way (paper 2). Neither paper alone is complete; together they sketch the load-bearing parts of what a Practica-shaped coordination system must do. Future work that lifts both papers' tier — or that refines them by reading them together — would extend the structural account further than either paper does alone.

The convergence, again, does not promise Practica's success. It identifies the structural commitments a Practica-shaped system must make. *Whether to make those commitments, and how to honor them under the cultural-soil conditions of any specific deployment, are choices that remain.* The paper's discipline has been to name those choices clearly enough that the choosing can be done with full information about what is being chosen.

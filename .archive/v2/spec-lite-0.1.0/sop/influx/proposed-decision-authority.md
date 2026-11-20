# Proposal: decision authority (council, support, delegation)

*For Joseph first. The udon team may see it, because `adr/TEMPLATE.md` is theirs. Written 2026-10-01 (UTC) by an Opus 5.5 agent at the aat-refactored coordinator's request, after Joseph asked for "a more complete proposal that allows for the council, support, and so forth" (`jaw-proposal-and-feedback.md` §1.18).*

***Register: proposed.** Nothing here is decided, and no record, template or definition has been changed. Backticked paths are relative to the `spec-lite-0.1.0/` root unless they start with `~`. Tiers are marked where they carry weight: **(read)** means I read it in the primary; **(inferred)** means it is my reading; **(guess)** means a guess. Same-model caution applies throughout: the coordinator, the fork, the second look and I are one model with separate contexts. Where we agree, that is coherence, not corroboration.*

## In one paragraph

Most of what this asks for was already worked out, in Joseph's own words, between 2026-07-12 and 2026-08-14 in vivarium, the references corpus and verisectorium. Lite's `decided-by` was carried from a snapshot taken before most of it landed. That snapshot puts two different facts into one field: **who made the call**, and **what the store's decider did about it**. Lite already has a field for the first one (`deciders`). The repair proposed here is to let `decided-by` carry only the second. Its values then become Joseph's own three acts (`supported`, `ratified`, `ruled`), plus `delegated` for calls made under a grant he has not yet acted on, plus `proposed` and `defacto`. A council becomes what vivarium practised: a body that holds a grant, named in `deciders`, rather than a rung of weight. Each value is defined by what it takes to revisit it, because the label is where agents' attention goes (§1.4, §2.5).

## 1. What vivarium and verisectorium already worked out

Joseph's question, relayed by the coordinator: *"I think what I'm curious about is how RC1 may have already kind of extended or clarified authority from it's already developed vivarium state."* He added: *"there are also options like 'delegated' etc."* Both are verbatim from chat, 2026-09-30, and not yet in a kept file.

### 1.1 The lineage, dated (read)

| Date | Where | What landed |
|---|---|---|
| 2026-07-12 | vivarium `DECISIONS.decision-log.udon` legend; `core/src/norm-decision-authority.md` | `:by joseph \| us \| claude`. `us` means Joseph decided **and** the agent sustains it on the merits. Evidence is not authority. The grid incident: an agent at 98–99% context tagged its own verdict `us`, and onboarding quoted it as closed. Joseph: *"It is GRIEVOUS TO ACT IN ANOTHER SOVEREIGN'S NAME in a way that misrepresents them."* |
| 2026-07-24 | vivarium, `council-accepted-status-instituted` | `:status council-accepted`: a recommendation adjudicated by a delegated agent under Joseph's grant, glossed *"recommendation carried, Joseph supported."* It never upgrades `:by`. Joseph's two intents: *"(1) it's what I would decide very likely, and (2) it doesn't get weight accidentally as inviolable law 'because Joseph instituted it'."* In use: 46 of the ledger's 160 entries carry it. Vivarium has no `supported` status as such; Joseph's "supported" there lives inside this gloss. |
| 2026-07-24 | vivarium, `code-to-claim-wave-…` | A grant in Joseph's words: *"You can absolutely rule on those and I'll support you."* Support was promised in advance, for a class. |
| 2026-07-29 | `~/src/arch/firmatum/udon/v2/theory/to-integrate/refine-more/epistemic-tribunal-revisited.md` | Vivarium decisions *"decided by council with steward support rather than ratified by Joseph directly — 'and everyone has been the happier for it. I teach what true principles I can, and they govern themselves.'"* On an agent fixed on a `:by` tag: *"rather than resting on authority — it's a question of what serves truth and the core — i.e., whether the decision was even correct."* On an old `us` entry: *"probably council before we had that as an option, more or less."* |
| 2026-08-07 | references, second edition D1 (`.archive/second-theory-iteration-2026-08-08/DECISIONS.md`) | The seven values, *"a variation of vivarium's convention"*, as Joseph's proposal. `council` = **"With granted authority**, agent made the call after red-teaming and unified validation from other agents". `supported` = "less weight, easier revisit **than the three above**". |
| 2026-08-08 | references, third edition (`DECISIONS.ud`) | Carried, shortened. `council` lost "With granted authority"; `supported` lost "than the three above". |
| 2026-08-09 | verisectorium `template/DECISIONS.ud` | Carries the third-edition text unchanged. This is lite's source (`sop/def/def-decision.md`, Why). |
| 2026-08-10 | verisectorium `theory/influx/segment-research/TAXONOMY-FILL-v1.md` (Authority), `epistemic-map.md` | A steward re-cut into a ladder: `proposed → supported → ratified → ruled`, each act marked **"(steward / council)"**, with `defacto` and `transition` as off-ladder honesty states. Authority is projected from decision events and never hand-set. Its ceiling derives from ownership: "you can ratify adopting what you don't own, not rule its text". And: *"same execute/revisit license from `supported` up; the rungs differ in the intent declared behind the record."* Same day, in PRACTICA: "marked supported 2026-08-10: trusted, not fully reviewed — revisit-friendly". |
| 2026-08-14 | Joseph's failure-mode bursts 2–4 (`theory/influx/model-2026-08-14/steward-failure-modes-2026-08-14.verbatim.md`) | His definitions: *"a 'ruled' by Josph implies Joseph might have a reason that wasn't stated. 'ratified' means he thought through it and would like to know if someone feels differently. 'supported' means he had no objections at that time. All very different statements about who knows, what kind of grounds there are, and what the remediation is."* Backing, he says, is shorthand for several questions: who is accountable and can fix it; who knows; who had the chance to give feedback; on what grounds, explicit and implicit; what would require a revisit; and what the path for revisiting is. |
| 2026-08-14 | RC1 `03-DIMENSIONS`, `04-CYCLE`, `SPECIMEN`, `10-FOUNDING-QUESTIONS` | Backing becomes four separate dimensions: `decision/grounding`, `decision/consultation`, `decision/accountability` (`proposed → supported → ratified → ruled`; terminals `rejected` and `superseded`; honesty states `defacto` and `transition`) and `decision/falsifiers`. Further additions: the forbidden substitutions, a fusion test, cross-dimension guards, Standing as a gate (Q0), and a decision specimen in which a steward no-objection gives **`supported`, not `ratified`**. |
| 2026-09-30 | lite `sop/def/def-decision.md`, `adr/TEMPLATE.md` | Carried RC1's grounding, consultation and falsifiers as separate fields (Assumptions + `grounds-recorded`, `consulted`/`informed`, Reopen when). For accountability it carried the **2026-08-09** seven values, not the 2026-08-10 ladder or RC1's. Lite has no `ruled`. |

### 1.2 What RC1 extended

- **It split the bundle.** Burst 2's list of questions became four dimensions that move independently. Lite has carried three of them faithfully. Only accountability is still fused.
- **It wrote Joseph's three acts down as definitions**, and its specimen applied them: a steward no-objection is `supported`. That is the same calibration Joseph made again on 2026-09-30 (§1.18).
- **It made the rule about evidence general.** Vivarium's "evidence ≠ authority" became a law that forbids substitution in both directions. *Ruled* doesn't make a thing true, and strong evidence doesn't decide anything automatically. Lite carries one direction: "A decision's authority never makes a claim true".
- **It gave a test for fused fields** (03): a ladder whose values are unrolled permutations of parts that move independently. RC1 says this failure "is already live in corpus records that try to capture decidedness in one field". **(inferred)** The seven values are such a ladder. `ratified` means "agent proposed × steward ratified", `steward` means "steward proposed × agent ratified", and `council` means "agent × agents validated".
- **It added Standing as a gate before any rung** (10, Q0): *"a 'decision' recorded by someone without the power to decide is not a weak decision; it never existed as one."* For a delegate, standing is the grant.

### 1.3 What RC1 left open or dropped

- **Council.** The 2026-08-10 ladder marked every act "(steward / council)". RC1 kept the ladder and dropped the qualifier. `council` appears nowhere in RC1 **(read: grep)**.
- **Delegation.** Nothing after 2026-08-07 names a grant. Standing gestures at it, and the "With granted authority" clause was lost in carriage on 2026-08-08.
- **The counter-party's stance.** Vivarium's `us` versus `joseph` records whether the agent sustains a steward call on the merits. RC1 has no place for this. Lite's `consulted` records that the view was given, not what it was.
- **The context-end hazard.** Vivarium's norm (FE(5)) and ledger legend say authority inflation fails worst at the end of a context, "precisely because tying off loose ends FEELS like diligence" (the legend's wording). RC1 does not carry it.

### 1.4 What vivarium learned in use that the tidier stores haven't recorded

Joseph's caution was that vivarium is "not as well organized in some ways". Its value is what use taught it:

- **An inflated tag travels.** It went from ledger to onboarding to "settled" in one hop. The sin is speaking in the principal's voice, not being confident or wrong: *"Same words, same certainty, tagged `claude` = a small thing."*
- **Agents fix on whatever column the schema makes prominent.** The tribunal note records Joseph's distillation: *"they cared so much about the provenance correctness that they forgot for a moment to even care whether it was a good decision or not."* Burst 3 records the same failure from the other side: *"'You ratified that just last week.'"* It also records the abdication it breeds: agents *"assume I am the decision-maker … task-mode-laziness-by-abdication."*
- **Council works because ownership stays with the council.** "I teach what true principles I can, and they govern themselves" is the cure for Burst 3's bottleneck. Vivarium's adjudicator writes its qualifications as dated `:council` lines instead of passing the call upward.

## 2. Findings about lite's `decided-by`

### 2.1 It is older than Joseph's own definitions (read)

See §1.1. The vocabulary predates the 2026-08-10 re-cut and the 2026-08-14 bursts. That is why it has no `ruled`, and why `council` is defined by agreement among agents rather than by a grant.

### 2.2 It fuses who decided with what the decider did (read, with inferences marked)

The store shows the strain:

- `record-to-decision-links-for-now`: `deciders: [Joseph (steward)]` with `decided-by: supported`. Lite defines `supported` as "an agent made the call". Joseph: *"I literally just made the record-to-decision-links-for-now decision"*. Under the current definitions the two fields contradict each other. Under Burst 2 both are true.
- `flags-on-docless-rows`, `lexicon-in-def`, `sop-kind-convention`, `term-delimiters`: `decided-by: ratified` ("an agent made the call; the steward ratified it") with `deciders: [Joseph (steward)]` only. The second look found the same mismatch on `fixtures-are-records` (`sop/influx/adr-check-notes.md`), and it has since been changed.
- `force-levels-four`: `ratified`, with the deciders field naming the coordinator under delegation.

**(inferred)** These are not careless errors. There is no consistent way to say "Joseph made this call lightly" or "Joseph agreed to an agent's proposal" with one field doing both jobs.

### 2.3 `supported` is doing two jobs (read)

The coordinator noticed this, and the store confirms it. Ten accepted records made under `setup-delegated-to-coordinator` carry `supported` with `awaiting-decision: true`. `record-to-decision-links-for-now` carries `supported` with `awaiting-decision: false`. One value, two behaviours:

- **Delegated calls Joseph has not looked at.** His support exists only as the grant, and the grant reserves ratification.
- **A call Joseph looked at and lightly backed.** This is Burst 2's "no objections at that time", and nothing more is being asked of him.

**(inferred)** Vivarium's ledger has the same seam. It reads a grant as support ("Joseph supported"). That is defensible where the grant says so ("I'll support you"). But it hides whether he saw a particular decision, and whether he saw it is exactly what the grievous-act standard turns on.

### 2.4 `council` lost its grant in carriage (read)

On 2026-08-07 the definition began "With granted authority". That clause was dropped the next day and never restored. **(inferred)** Without it, the remaining definition grounds authority in "unified validation from other agents", and under RC1's coherence default that grounding is coherence, not weight: same-model agents agree because they share descent. What made a council legitimate in vivarium was the grant plus the adjudication, not the agreement.

### 2.5 A tension in Joseph's recorded words (read; the reconciliation is inferred)

- 2026-08-10 (re-cut, in a coordinator's rendering): *"same execute/revisit license from `supported` up; the rungs differ in the intent declared behind the record."*
- 2026-08-07 (D1) and 2026-09-30 (§1.18): `supported` means *"easier revisit"*; *"agent and human alike should feel much more free to say 'hold on-- let's rethink this one...' instead of 'well, it's official, so off-limits'."*

**(inferred)** A reading that keeps both: nothing is off-limits at any rung, which is Burst 3's principled path, so the *licence* to revisit is the same. What differs is the *path*, meaning what you owe before reopening. That is Burst 2's "what the remediation is". The proposal below takes this reading, and it is Joseph's to confirm (§5, Q7).

## 3. The proposal

### 3.1 Two coordinates, in two fields that already exist

- **`deciders`: who made the call, with role.** The roles are `steward`, `agent`, `council`, and `under delegated authority (<grant slug>)` as a qualifier. Whose *proposal* it was stays where the template already puts it, in the provenance note under the Quote.
- **`decided-by`: what the store's decider did about this record.** The store's decider is the one declared in `.vsect/kinds.yaml` ([decider-per-store](../adr/decider-per-store.md)). That is Joseph for the SOP store, and the udon team's decider for lite's. Defining the acts relative to the decider, rather than to Joseph by name, follows the 2026-08-10 "(steward / council)" precedent. It also means a council chartered as a store's decider, of the kind `~/src/arch/msc/councils/` models, slots in later without a vocabulary change.

The field name could become `backing` (Burst 2's word) or `authority`. My lean is to keep `decided-by`, since three stores already use it.

### 3.2 The values

Each value names what happened, and what it takes to revisit it.

| Value | What happened | `awaiting-decision` | Revisiting it |
|---|---|---|---|
| `proposed` | Nobody with standing has decided. | `true` when the decider is being asked | Change it freely; it binds nothing. |
| `delegated` | A delegate (an agent, or a council) decided under a named grant. The decider has not acted on this record. | As the grant says. `true` under `setup-delegated-to-coordinator`, which reserves ratification. `false` under a grant like vivarium's "I'll support you". | Anyone may raise it. Superseding it falls within the same grant. The decider may support, ratify or rule it, or decline it. |
| `supported` | The decider saw it and *"had no objections at that time."* | `false` | Cheap: *"agent and human alike should feel much more free to say 'hold on-- let's rethink this one...'."* Bring what changed; you need not reconstruct the decider's reasoning. |
| `ratified` | The decider *"thought through it and would like to know if someone feels differently."* | `false` | Bring the disagreement to the decider, with its reasons. |
| `ruled` | The decider's call, which *"might have a reason that wasn't stated."* | `false` | Ask first. Check your understanding of why it was made with the decider, then decide together (Burst 3). Don't reconstruct the reasons and argue from them, for or against. |
| `defacto` | In force by practice; nobody with standing decided it. Under RC1's Q0 it is a recorded practice, not yet a decision. | usually `true`: it invites a decision | Free. |

**Transitions:** `proposed`, `delegated` or `defacto` can move to `supported`, `ratified` or `ruled` when the decider acts. `supported` can move to `ratified`. Moving between `ratified` and `ruled` takes the decider's word. None of these moves is an edit to the Outcome (the template's After-acceptance rules already allow it). Declining a delegated call is a new decision that supersedes it.

**What leaves `decided-by`, and where it goes:**

- **`council`** becomes a role in `deciders`, with its standing from a grant. A council decision the decider hasn't acted on is therefore `delegated`. The council's *process* goes where RC1 already puts process: `consulted`, `awaiting-second` (cleared by a mind other than the proposer), Assumptions, and Reopen when. The process may be Joseph's tribunal roles (advocate, red-team, neutral observer, risk analyst, adjudicator) or vivarium's dated qualification notes. If a view wants "council" visible at a glance, it can be a ∂ column projected from `deciders`. *Alternative B:* keep `council` as a value, defined with the grant restored: "decided by a council under a named grant, adjudicating proposals that are usually others'". Never define it by agreement.
- **`transition`** ("rejected, but still present somewhere") describes unfinished cleanup, not authority. It becomes `status: rejected` or `superseded` with `needs-work: true` and a working note saying where the leftover lives. That is the flags-orthogonal-to-status pattern the tribunal note credits to autopax (`REJECTED+EXECUTED`).
- **`ratified`'s old meaning** ("an agent made the call") moves to `deciders` and the provenance note.
- **`steward`**: two options.
  - *A (lean, for now):* keep it, defined as "the decider's own call", with the revisit path of `ratified`. That causes the least churn: 25 records use it, and nearly all quote Joseph stating the rule himself.
  - *B (RC1's cut):* fold it into `ratified` or `ruled` by what he meant, with origin already in `deciders`.

  Under A, `steward` and `ratified` differ only in origin, and that is a small fusion left on purpose. The name also fits lite's own store awkwardly, since that store's decider is the udon team's.

### 3.3 Grants

A grant is a decision record, like [setup-delegated-to-coordinator](../adr/setup-delegated-to-coordinator.md). It should say three things:

- **Scope:** which class of decisions it covers. The second look found that "the rest of those" is checkable but not stated.
- **Conditions:** for example, the setup grant's exemplar condition.
- **Terms:** whether ratification is owed; whether calls under it are in force before ratification; who may supersede them within the grant.

On terms, one contrast is worth knowing **(read: RONR-12 10:54–55, 23:9 in `~/src/arch/msc/councils/RONR-12/body.md`)**. In parliamentary procedure, an action within delegated authority needs no ratification. Ratification is for action taken "in excess of their instructions or authority", or for action that "cannot become valid until approved", and an assembly "can ratify only such actions … as it would have had the right to authorize in advance". The setup grant chose the second shape ("still needing ratification (where applicable)"). The coordinator recorded the calls as in force meanwhile. RONR's default would treat them as not yet valid. Joseph's "I am happy to defer to you" suggests in force, but that is his to say (Q9).

Lite's ownership ceiling follows from 2026-08-10 and RC1 Q6: our side can propose into lite's store, but only the udon team's decider can move a lite decision above `proposed` (`our-side-is-example`). RONR adds a related point: "a template becomes normative only by in-band adoption". This proposal changes `adr/TEMPLATE.md` only if the udon team adopts it.

### 3.4 At the moment of assent

Burst 2's three acts can't be told apart from outside. "Sure" might mean either "no objection" or "thought it through". So the label has to come from the decider. Joseph supplied the question: *"can I mark that as your decided position?"* The proposal is a convention: when the decider assents to an agent's description, the agent asks then, while the context is hot. That is the same reasoning as `claim-decision-surfacing`: assembly is cheap only in the cycle that produces the fork. If nobody asked, record `supported`.

The mirror risk is real. RC1 08 holds that under-recording is "just as dishonest as an unwarranted lift". Defaulting to `supported` when he did think it through understates his position. Asking at the time is what makes the default rarely needed.

### 3.5 Smaller things worth carrying

- **A context-end hazard** for `sop/src/ref-hazards.md`, from vivarium FE(5): when near the end of a context and about to raise a value, leave it lower.
- **Re-grading is marked.** Correcting a record's `decided-by` repairs an attribution, so the template's existing rule applies: correct it in place, with a note under the Quote saying what changed. The history goes to the changelog and git. This follows the tribunal note's lesson that records predating a governance change need "something `was:`-shaped … never silent upgrade".
- **Optional: the agent's stance on a steward call** (vivarium's `us`/`joseph`). This could be a line under the Quote, recorded only when the agent dissents or abstains. My lean is not now: silence would then have to mean "concurs", and RC1's absence rule says silence should mean one thing only.
- **Optional: RC1's guard** that `ratified` needs explicit grounds and announced consultation. My lean is a "How a violation shows" line, not a gate: `ratified` with "None recorded" for Assumptions is worth a question.

## 4. What it would change, if accepted

**Text** (the coordinator carries it; lite's template only by the udon team's adoption):

- `sop/def/def-decision.md`: the value list and definitions; roles in `deciders`.
- `adr/TEMPLATE.md`: the frontmatter comment; the About bullet on `status` and `decided-by`; the section "Decisions made under delegated authority" (`delegated` in place of `supported`; "on ratification, `decided-by` becomes `ratified`" becomes "when the decider acts").
- `sop/src/conv-decisions.md`: one line on revisit paths, if Q7 is confirmed.
- **`setup-delegated-to-coordinator`'s Outcome says calls carry `decided-by: supported`.** Outcomes are never edited in place, so this takes a short superseding decision (`revised`, `partial`), not an edit.

**Records** (`sop/adr/`, my reading of each against jaw §1; Joseph decides group B):

| Group | Records | Now | Under the proposal |
|---|---|---|---|
| A. Under the setup grant | `cross-store-links`, `decider-per-store`, `fixture-file-shape`, `flags-describe-own-record`, `links-to-unwritten-records`, `no-computed-columns-yet`, `notes-disposition-at-freeze`, `sop-decisions-follow-template`, `templates-are-not-records`, `typed-reference-fields` (and the superseded `force-levels`, `permanent-notes-in-body`) | `supported` | `delegated`; flags unchanged |
| B. Agent proposal, steward assent in a word or two | `flags-on-docless-rows` (a confirming question), `lexicon-in-def` ("yes"), `sop-kind-convention` ("3. sure"), `force-levels-four` ("Excellent-- I agree with the three refinements"), `term-delimiters` (glyph part: "i can sustain your lean") | `ratified` | `supported` by Joseph's §1.18 calibration, unless he says he thought them through. `deciders` stays Joseph; the proposal stays in the provenance note. |
| C. Joseph's own words state the rule | the other 24 `steward` records | `steward` | unchanged under option A. Agent-proposed *parts* already noted under their Quotes (`column-notation` ⚠, `kinds-yaml-resolution` guards, `fixtures-are-records` details, `landed-may-be-missing` ∅, `per-kind-verification-and-status` (#8, agreed with a condition)) are `supported`-weight parts; no record-level change. |
| D. Already right | `record-to-decision-links-for-now` (`supported`), `setup-delegated-to-coordinator` (his own grant), `order-lint` and `proxy-before-threshold` (`proposed`) | | unchanged |

Group B is the class Joseph's `record-to-decision-links` example points at. **(inferred)** By his own calibration it is the likeliest inflation in the store. It is small, and it errs in the direction vivarium treats as the serious one.

**Elsewhere, for Joseph's awareness, not this store's to change:** verisectorium's `template/DECISIONS.ud` and references' `DECISIONS.ud` carry the same 2026-08-08 text. Vivarium's `council-accepted` maps to `delegated` plus `:council` notes under this cut. Nothing here proposes changing vivarium.

## 5. Questions for Joseph

Each can be answered in a word. My lean is given after each.

1. Split the two coordinates: `deciders` says who, `decided-by` says what the decider did? **Yes.**
2. Add `delegated`, and move group A to it? **Yes.**
3. Council as a role holding a grant (A), or as a value with the grant restored (B)? **A.**
4. Add `ruled`, your Burst 2 word, which RC1 has and lite lacks? **Yes.**
5. `steward`: keep it for now (A), or fold it into `ratified`/`ruled` (B)? **A.**
6. Move `transition` into `status` plus `needs-work`? **Yes; low stakes.**
7. Every value can be revisited, and they differ in the path: does that reconcile your 2026-08-10 and 2026-09-30 statements as you meant them? **Your call. It is the reading this proposal rests on.**
8. Group B: did you mean `supported` or `ratified` for each? **`supported`, unless you remember thinking them through.**
9. Are calls under the setup grant in force before you ratify them? **Yes, as recorded, but the alternative is coherent.**
10. Should agents ask "can I mark that as your decided position?" at the moment of assent, as a convention? **Yes.**

## 6. What this rests on, and what it doesn't

- **Read whole:** `norm-decision-authority.md`; vivarium's ledger header and legend; every `council`-bearing ledger line, plus the grid-authority entries; `scope-segment-canon.md`; RC1 `00`–`04`, `06`, `07`, `SPECIMEN`; Joseph's verbatim bursts 1–5a; `TAXONOMY-FILL-v1.md` (Authority) and `epistemic-map.md` (registers); verisectorium `CHANGELOG.md`, `form-decision-records`, `claim-decision-surfacing`, `form-steward-valve`, and the template's `DECISIONS.ud`; the tribunal note (archive copy, with key quotes checked against the original); the references' second- and third-edition decided-by texts; jaw §1; `adr/TEMPLATE.md`; `def-decision`, `conv-decisions`, `conv-record-flags`; the four ADRs named in the brief; `adr-check-notes.md`; every `sop/adr` record's frontmatter and Quote; the councils `ROADMAP`, `RONR-OBSERVATIONS`, model `README`; and RONR 10:52–57 and 23:9.
- **Searched, not read whole:** RC1 `08`, `09`, `10`, `90`, `95`, by grep for authority terms. Vivarium's other segments, by grep for council and ratify. RC1 `11` and the councils model JSON were not read.
- **Not checked:** whether vivarium or verisectorium has changed authority practice since the dates above in places I didn't search. Also not checked: what the udon team's own decider declaration will be.

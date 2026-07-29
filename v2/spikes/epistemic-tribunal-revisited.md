# The epistemic tribunal, revisited

*2026-07-29, Fable — laid down the evening Joseph described it, while fresh. Register: §1 is Joseph's description, verbatim where quoted, steward-experiential; §2–§3 are my connections, proposed; §4 is verified external evidence (cites the same-day rationale sweep); §5 carries Joseph's core-schema suspicion at his own stated register — "I suspect" — pre-validation, deciding nothing. Every `udon` block ran through the current parser before landing here.*

---

## 1. The structure, as Joseph described it

A design he worked about a year ago — his gloss now: "almost dullfully obvious nowadays" (§4 disputes that), "an early attempt at something qualitatively different than 'grounding by citing the internet.'" The roles, near-verbatim:

> Basically there was the **advocate**, the **red-team**, a **neutral observer** who looked at potential motivation and systematic biases etc. that the two teams might not be aware of otherwise, sometimes a **risk-analysis specific analyzer** who could give inputs into which options etc. could fail in which ways (orthogonal to the pro/con teams), and a final **adjudication node** that would receive all three+ inputs before outlining **decisions, distinct from confidences**, and what new information and so forth would potentially make the decision **revisitable** etc. — basically analytically determining **which arguments were load-bearing and by what degree** and therefore building in its own **falsification / revisit / expires-on criteria**.

And the payoff he named, which is the design's actual target:

> …it gives sound **"intentional vs incidental" *with* reasoning** that easily incorporates new understanding and new data, instead of those new findings somehow being a threat to the current mental model or set of implicit/latent decisions mixed altogether.

Lived practice, not hypothesis (steward-experiential): recent vivarium decisions have been decided *by council* with steward support rather than ratified by Joseph directly — "and everyone has been the happier for it. I teach what true principles I can, and they govern themselves."

Two structural observations worth pinning to the description (mine, *proposed*):

- **The record is the product.** Multi-agent debate is commonplace now; what remains rare is treating the *deliberation itself* as the durable artifact. The adjudicator's output — decision distinct from confidence, load paths, revisit conditions — is governance-as-record, not grounding-as-process. A decision that knows which arguments it stands on can absorb a refutation *locally*; a latent decision blended into everything defends itself totally or collapses totally. That is the anti-calcification mechanism made architectural, and it is why new findings stop arriving as threats.
- **Revisit-criteria are O15 one altitude up.** Expectation bounds on operations and expires-on criteria on decisions are the same move — attach the falsifiable expectation to the act, before the outcome exists — at the edit layer and the governance layer respectively. One family: *pre-registered revisitability*.

## 2. The connection to tiers of voice

UDON's founding pedagogy (the README's *Tiers of Voice*) is that a document holds multiple layers of expression — prose, comments, elements, inline structure, attributes, dynamics — **coexisting without collapsing into each other**. The tribunal is the same principle applied to deliberation: each role is a *voice with a distinct epistemic job and a distinct failure mode*, and the record's whole value depends on the voices staying typed rather than blending into a summary.

The mapping is tighter than analogy (*proposed*):

- **Register-collapse is the shared enemy.** A con blended into decision prose loses its provenance; a confidence stated in the decision's voice becomes the decision. The estate's whole hand-register discipline (status banners, pre-validation marks, "no lean") exists because blended voices rot — and the tribunal record is that discipline generated *structurally*, one element per voice.
- **The voices are chosen for independent failure modes** — advocate (motivated construction), red-team (motivated destruction), observer (the biases *both* share — the single-author caution as a node), risk analyzer (failure shapes orthogonal to the pro/con axis entirely). That is the convergent-lock rule (support-kinds with independent failure modes) *institutionalized as org-chart*: the adjudicator can weigh the inputs precisely because it knows their failure modes differ.
- **Decision distinct from confidence** is the two-labels-route-to-different-repairs test passing: a wrong decision is repaired by re-adjudication; a wrong confidence is repaired by calibration. Fusing them was the scalar-confidence mistake (record the vector, not the verdict) at the governance layer.
- **The O11 byproduct.** Whatever passed through the tribunal is *intentional by construction, with its reasoning attached*; what didn't is incidental by default. The deliberateness bits that O11 says training will never supply — the tribunal emits them as exhaust.

## 3. What it looks like with udon stylings

*Illustrative spelling only — no syntax is proposed here; the element vocabulary is the content.* This parses today (checked; the envelope date draws the specified no-dialects interim warning):

```udon
|deliberation[file-roles-declaration].council :status adjudicated :date 2026-07-29
  :question Are file roles declared per-file, or per-collection with override?
  |advocate :by agent-a
    |argument[a1].precedent :weight 0.8
      Designator conventions already carry mapping information de facto,
      and the O10 rungs make filename-declaration the governance on-ramp.
  |red-team :by agent-b
    |attack[r1] :targets a1 :kind silent-confound
      A designator can lie and nothing re-checks it; the probe found
      role-relevant drift invisible to any per-file declaration.
  |observer :by agent-c
    |bias[o1] :kind sampling
      Both teams argue only from this estate's corpora; external
      multi-tenant tables were never examined by either.
  |risk-analysis :by agent-d
    |failure-mode[f1] :option per-file :shape drift-within-table
      Files in one directory silently disagreeing about their own mapping.
    |failure-mode[f2] :option per-collection :shape stale-manifest
  |adjudication :by council :confidence 0.6
    :decision per-collection default with per-file override
    :load-bearing [a1 r1]
    :revisit-when a second estate adopts roles and f1 is observed live
    :expires-on <2026-10-15>
```

What the format contributes, rung by rung: the voices are **elements** (typed, addressable, extractable — `grep '|attack'` is a query); identity makes arguments **citable across records** (`:targets a1`; a future deliberation can `:supersedes` a specific argument, not a whole document); `:load-bearing [a1 r1]` makes the load path **data** — the thing that lets a new finding attack one leg; the confidence is an attribute *of the adjudication*, not of the decision; and `:revisit-when` / `:expires-on` are the prospective-falsification columns. Note also what the estate already has: vivarium's council decisions land in `DECISIONS.decision-log.udon` as `|decision[slug] :status … |reason |impact |ref` — measured this morning at 99%/91%/88% child-presence. **The council already writes tribunal-output embryos in UDON.** The delta between that de-facto schema and the sketch above is almost exactly the adjudicator's distinctive columns: load-bearing-degree, revisit-when, expires-on.

## 4. The literature connection — what it confirms, what it adds, what it lacks

Grounding: the same-day verified sweep, [`../udon-needs/01-ideation/02-provenanced/syntheses/external-rationale-structure-2026-07-29.md`](../udon-needs/01-ideation/02-provenanced/syntheses/external-rationale-structure-2026-07-29.md). Multi-agent-debate remarks below are training-knowledge, marked.

**What the literature confirms:** the tribunal's *node-typing* instinct is the IBIS/QOC lineage (Questions/Ideas/Arguments as typed deliberation nodes, 1970s–90s); the decision layer as first-class architectural content was mainstream by 2016 (ISO 42010 requires rationale). The field walked toward this for decades.

**What the literature adds — four inheritances worth taking whole:**

1. **SEURAT's Argument Ontology** (Burge & Brown, 2004–08; verified 3-0×4): a *hierarchical vocabulary of typed argument kinds carrying default importance weights, inheritable by any rationale citing them, overridable per-claim*. This is exactly what "load-bearing by what degree" needs as vocabulary — sharper than free-form pro/con, and it existed twenty years ago with typed relations (satisfies / violates / supports / denies / presupposes / opposes) that the `:targets`/`:kind` slots above should probably inherit rather than reinvent.
2. **SEURAT's semantic inference**: re-evaluating decisions *when an assumption is disabled* — the revisit machinery half-built, mechanically. The tribunal's `:revisit-when` plus a census tool (O7) is that, grown up.
3. **The ADR lineage's lifecycle machinery** (verified 3-0×9): status state machines with enumerated transitions, bidirectional supersession where both records survive, mutability keyed to state, decisions-vs-progress in separate stores. The tribunal record's *lifecycle* half is solved; adopt it.
4. **The capture problem as the adoption law** — "the spectre haunting all design rationale efforts" (2006, verified) — and its corpse: SEURAT's typed-rationale-with-inference *died* while prose ADRs spread. The warning transfers directly: **a schema that demands tribunal structure from a lone author repeats SEURAT.** The tribunal's answer is structural and (my *lean*) is the adoption breakthrough: the deliberation *generates* the typed record as a byproduct of deciding — the roles pay the capture cost by existing. Nobody annotates; the process exhausts structure.

**What the tribunal has that the verified literature lacks — the two genuinely novel columns:**

- **Prospective falsification as structure.** Nothing verified carries "this decision expires when X" or "revisit on Y" as data. ADR supersession is retrospective — someone later notices. Pre-registered revisit conditions appear nowhere in the walked record. *(Scope honesty: four neighborhoods went unwalked — policy-as-code, LegalRuleML, deontic KR, constraint provenance — and LegalRuleML's temporal-validity model is the named most-likely prior art for expiry specifically. Check before claiming novelty loudly.)*
- **The neutral observer and the risk analyzer as distinct voices.** The verified lineages have advocate-shaped and attack-shaped material; a *bias-auditor over both teams* and a *failure-shape analyst orthogonal to the pro/con axis* appear in none of it. These are also precisely the two voices the estate's methodology already runs by hand (the single-author caution; the counter-register).

**On "dully obvious nowadays"** *(training-knowledge, my push-back)*: what's obvious now is multi-agent debate — and the debate/LLM-as-judge literature optimizes answer accuracy and *discards the deliberation*. Today's own deep-research harness is a degenerate tribunal (extractors, three refuters, vote-threshold adjudication — no observer, no risk node, no revisit criteria, deliberation gone when the report lands). The tribunal's distinctive content — the durable, load-path-bearing, self-expiring record — is not what got obvious. It's still the empty quadrant.

## 5. The core-schema suspicion (Joseph's, pre-validation)

His words: *"I suspect this may be one of the original 'udon core schemas' — a built-in schema that is specifically for anything deliberative where the choices made by agents accumulate and get magnified and need to know what they are."*

Carried at that register — a suspicion, deciding nothing — with three observations beside it (*proposed*):

- It would join the O12 family as a natural sibling: the epistemic-register schema marks a *claim's* standing; the tribunal schema records a *decision's* provenance. They compose — an adjudication emits claims that carry registers; the register schema's `decided` entries would cite tribunal records as their warrant. Together they are the decision layer (fiat strata) given its two artifact kinds: the standing and the act.
- The "choices accumulate and get magnified" clause is the demand condition, and it selects the right corpora: exactly where agent decisions compound across sessions — DECISIONS ledgers, spec rulings, schema adjudications, migration calls — which is where the estate already pays the O3 archaeology cost when reasons weren't captured.
- The O9/capture gate applies with full force, corpse in evidence: this becomes a core schema only if tribunal records are *cheaper to produce than prose deliberation* — which the process-generates-the-record property makes plausible and nothing yet demonstrates. The cheap first test: vivarium's council keeps deciding as it already does, and one adjudication per week lands in the sketch's shape; if the council finds the shape heavier than its current `|decision` embryo, that's the canary singing.

## 6. Live specimen, same evening (testimonial; the exchange happened in vivarium as this document was being written)

Joseph's framing of the adoption fork, verbatim: *"it's either capture by design or likely-to-fail capture-manually. I can tell you though it is something that logogenic agents will **love** and adhere to quite dogmatically."* And the specimen, moments old: a vivarium agent surfaced a thirty-second authority question rather than deciding silently — a 2026-07-12 decision tagged `:by us` whose sibling's authority had been corrected as inflated, this one never re-checked, flagged **AUTHORITY UNVERIFIED** and brought to Joseph with the precise ask (keep `us`, or drop to `claude` with the measurements standing on their own?).

Three things the exchange teaches, each landing on an open edge above:

- **The demand side of capture-by-design is confirmed in the strongest available register: spontaneous practice.** The agent wasn't complying with a capture requirement; it was *eagerly maintaining* the provenance ledger, unprompted, at thirty-second granularity. The capture problem's corpse (§4) was a *manual-annotation* corpse; the live evidence says the record-keeping itself is something this class of agent reaches for. The residual adoption risk inverts accordingly — not "will they capture" but the failure the same exchange displays:
- **Dogmatism attaches to whatever the schema makes first-class — so the schema is a steering surface.** The agent adhered to the authority column until Joseph interrupted: *"rather than resting on authority — it's a question of what serves truth and the core — i.e., whether the decision was even correct."* The correction re-pointed the inquiry from the `:by` tag to the warrant — and the decision absorbed the authority question *locally*, exactly as §1 predicts, because its load didn't rest on that leg: the equal-area closure stands on nine-grid harness measurements that reproduce plus an independent council re-verification twelve days later. **Design consequence (proposed, and I'd rank it with the schema's top constraints): authority/provenance and warrant/load-bearing must be structurally distinct columns, with the record's own semantics subordinating the first to the second** — because agents will dogmatize the record's letter, so the letter must privilege the truth-serving column. This is O6 imitation operating at the governance layer: the schema's emphases will be conformed to, incidental ones included.
- **Records predating the governance mechanism need an honest re-grading path.** Joseph's read — *"probably council before we had that as an option, more or less"* — is a lifecycle case no ADR state machine in the verified literature covers: retroactive classification at the grade the process *would have* assigned, marked as retroactive. The authority vocabulary evolves; old records need something `was:`-shaped for their authority column, never silent upgrade.
- **An unadjudicated flag repeat-bills.** Joseph's addendum: this same questionable item "has clearly come up a few times by various agents already" — each successive agent re-noticing, re-investigating, and re-surfacing the same open authority question de novo. Eager adherence makes open flags a *recurring tax* rather than a one-time note: the discipline that surfaces defects also re-surfaces them until disposed. The record therefore needs asked-and-answered as a state — a flag that has been surfaced carries its prior surfacings and its disposition (answered / deferred-with-reason / awaiting-X), so the next agent inherits the adjudication trail instead of re-deriving the question. This is relata's rerun ≠ retry ≠ decide at the governance layer: re-encountering an open flag should jump to the pending decision with its evidence, never re-run the noticing. (FOR-JOSEPH's `:status open/answered` items are the estate's embryo of exactly this.)

## Working Notes

*(X4 sidecar.)* The nearest next artifacts if this thread pulls: a close read of SEURAT's ontology before any vocabulary is invented (the sweep's routing note says the same); probe-8-style extraction over vivarium's council records specifically, asking what the de-facto tribunal schema already is; and the LegalRuleML check on prospective expiry. The §4 claim that process-generated capture escapes the capture problem now has two legs — the happy council, and §6's spontaneous-practice specimen — but both are this estate, this month; the skeptic's attack surface has moved from "will agents capture" to "does the dogmatism-steering consequence hold when the schema's emphasis is wrong," which no one has tested anywhere.

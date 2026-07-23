# Epistemology proposal — pilot A vantage (Intro + Part I opening four)

*Charge: design the monograph's full rigor system — ASF-grade, but shaped for **this** work's truth, with transmissibility counted as part of truth. Grounded below in what `method-evidence-tiers`, `counter-register`, `tools-are-observation-infrastructure`, and `errors-that-teach` actually needed. Read against FORMAT.md (read whole) + the LEXICON vocabulary. Genuine forks are preserved at the end for the trio + Joseph, not averaged away.*

---

## 0. The framing shift that generates every difference

ASF is a theory that **derives**. Its crown jewels are `result` / `derived` segments at `exact` / `conditional` in the inevitability core — claims where *only one form fits the priors*. Its whole apparatus (rings, max-attainable status, equation tags, derivation-audit tables) is built to serve derivation and to stop derivation's characteristic failure: dressing a choice or a hypothesis as a theorem.

This monograph does almost none of that. It **transmits, triangulates, and proposes**. Its center of gravity is three moves ASF rarely makes:

1. **Transmission** — it *inherits* results (from ASF, from external research) rather than deriving them. The κ×A law is not ours; our contribution is faithful carriage + application to the tooling domain.
2. **Triangulation** — its unit of proof is *agreement across evidence kinds with independent failure modes* (the method chapter's stated thesis). A proof needs no triangulation; a synthesis lives on it.
3. **Proposal** — it is chartered to *generate* (capability cards, ideation) — a register ASF's claim-segments barely have.

So the honest system is not "ASF's, minus the parts we don't have." It is ASF's strength-ladder and triage discipline **adopted nearly whole**, plus two native first-class notions ASF has no need for — a **transmission** axis and a **convergence** lock — because those are where *our* characteristic failures live. ASF guards against fake theorems; we must guard against **infidelious transmission** and **fake independence** (agreement that is really descent from one source). The system below is built around those two.

### 0.1 Destination shift (Joseph, mid-deliberation): TST is the probable *native home*, not a neighbor

The second-consumer handover is now expected to land **inside ASF as a new group/part within 02-TST (Temporal Software Theory)**, not as a standalone transfer. That flips the design default:

- **From** "borrow what earns its place" **to** "align with ASF/TST FORMAT by default; justify every *difference* by this material's nature; and price each delta as **future reconciliation cost**." The ledger in §2 is re-read under this rule — a `decline` is now cheap only if it introduces no schema/vocabulary the future TST reader must reconcile (see the reconciliation-cost column added there).
- **The deliverable is reframed, and upward.** Our warranted differences — the empirical-register nuances Joseph proposed, **first-person agent testimony above all** — are exactly the evidence kinds TST's current status/type vocabulary does not yet distinguish. Framed natively, this proposal is best understood as **a proposal to extend TST's evidence vocabulary**, not a local schema for one report. That is a more valuable artifact: the two native notions of §0 (a `testimonial` support-kind with corroboration-repair; the `transmission` axis) and the `convergent` lock are candidate *contributions to TST*, because a software-and-agents theory that will carry lived agent testimony needs a way to type it that a pure-derivation vocabulary lacks.
- **Cite TST segments as future siblings.** Where these chapters lean on TST-adjacent results (e.g. `#obs-software-epistemic-properties`, `#der-code-quality-as-observation-infrastructure`), the `transmitted-from:` cite should target the sibling slug directly — under this destination those are not external citations but *intra-corpus* cross-references, which lowers the transmission-fidelity risk (a sibling can be depended-on and re-checked, not just quoted). This is an argument *for* the transmission axis, not against it: it makes the inheritance a live `depends:` edge rather than a frozen quote.
- **Perspective consequence for a downstream chapter:** `harness-handover-map`'s reader is now *ASF's reader*, not an external archema recipient — its framing needs an update. Outside my division; flagged in `notes/for-OUTLINE.md`.

---

## 1. The recommended system — four axes + two locks

Every claim sits at one point on each axis. Prose carries the load-bearing ones in words (transmissibility); frontmatter carries all of them as machinery (auditability). This extends — does not replace — the genre×register×strength work already in the methods chapter.

### Axis 1 — Support-kind (provenance *and its repair*)

Refines the opaque T1–T5 into named kinds, each carrying the **repair that would strengthen or discharge it** — which is exactly ASF's anti-collapse test (split two labels only where they route to different repairs). Every kind below passes it:

| Support-kind | What it is | Repair (how it strengthens / discharges) |
|---|---|---|
| **design** | first-principles design reasoning (Joseph's 2025–26 principles) | validation-against-ground: build it, see if reality bears it |
| **observational** | a regularity seen in shipped systems/behavior | replicate elsewhere **+ descent-correct** (is the agreement copying?) |
| **testimonial** | a first-person agent account | corroborate: more independent voices |
| **theoretic** | a formal result | check the proof / check the premises (usually **transmitted** — Axis 3) |
| **measured** | a quantified in-vivo or benchmark outcome | re-measure / widen conditions |
| **synthetic** | evidence from constructed scenarios / stress tests | validate the construction is **representative** |

This maps Joseph's proposed "result / observation / testimonial / synthetic" nuances onto the evidence base and **passes anti-collapse**: a testimonial's repair (corroboration) ≠ a synthetic's (representativeness) ≠ an observation's (replication) ≠ a measurement's (re-measure). The one split worth flagging: `measured` vs `synthetic` — my division needs it (the YAML stress test is *synthetic* — designed scenarios; external pass@1 benchmarks are *measured* — in-the-wild; they fail differently), and it mirrors ASF's own `observation` (simulation) vs `measurement` (operationalization) distinction.

### Axis 2 — Strength (defeasibility ceiling) — **adopt ASF's ladder nearly whole**

`exact` · `conditional` · `robust-qualitative` · `empirical` · `heuristic` · `discussion-grade` · `sketch` — verbatim from FORMAT.md §status, *plus* `hypothesis` (ASF carries it as a `type`; we need it as a *strength* because our proposed register is large). **Decline** `axiomatic` as a claim-strength: this work asserts no axioms of its own; its axiom-like objects are project *decisions*, which sit off the ladder (a choice is not strong-or-weak — the methods chapter already rules this). Reusing ASF's exact words is deliberate: `transmitted` claims (Axis 3) should carry the *same* status word as their source so the inheritance is legible ("`conditional`-at-source, transmitted").

### Axis 3 — Transmission (**native; the first thing ASF doesn't need**)

A claim is either **established-here** or **transmitted** (inherited from ASF or external work). A transmitted claim is defeasible on **two independent grounds**: the source could be wrong, *or* our carriage could be infidelious — and the effective strength is `min(source-strength, transmission-fidelity)`. Machinery: a `transmitted-from:` provenance field (cite `asf 03-llm-core#scope-channel-collapse`, or an external bibkey) plus, in prose, the honest form *"exact at source, under its premises; the risk here is transmission."* This is the honest face of Joseph's cite-don't-rederive: we cite ASF for the derivation **and** we own the fidelity risk that citing introduces. (See §3 worked example 1 — my own κ×A wrapping-caveat fix *was* a transmission-fidelity repair; this axis would have flagged that segment as at-risk before I found it.)

### Axis 4 — Register (speech-act; reader-facing glance layer) — keep as-is

`derived` / `evidenced` / `decided` / `proposed`. This is the coarse reader-facing tag already in the methods chapter; it maps onto the finer axes (evidenced → some support-kind at some strength; proposed → hypothesis) but stays because a reader needs it at a glance and the prose discipline runs on it.

### Lock A — **convergent** (native; the second thing ASF doesn't need)

Not a rung on the ladder — a **confidence-multiplier orthogonal to it**: a claim is `convergent` when ≥2 support-kinds *with independent failure modes* agree. This is the monograph's actual unit of proof. Its repair is unique and is the one the method chapter already demands: **break the independence** — show the agreement was really descent from one source (in which case the lock is void and the claim falls back to its strongest single leg). ASF has no `convergent` because a derivation doesn't triangulate; for us it's the crown jewel. (Worked example: errors-that-teach, §3 ex. 2.)

### Lock B — **max-attainable-status** (adopt ASF's, it's gold for us)

Every claim carries a ceiling: the strongest status it could *ever* reach. `"Max attainable: measured. Currently hypothesis because no experiment has run."` This is not bureaucracy — for a synthesis it is the thing that makes strengthen-before-soften *tractable*: you push toward the ceiling, and when you're at it, you stop. A single agent's testimonial has ceiling `robust-qualitative` — corroboration can raise confidence but can't make one voice `exact`. A capability card is ceiling-`hypothesis` until an experiment exists. Knowing the ceiling prevents wasted strengthening effort *and* prevents the false-modesty under-claim (don't leave something at `discussion-grade` when its ceiling is `measured` and the experiment is cheap).

### Element V — verification-event log (replaces stage-attainment; Joseph, steward input)

Joseph, near-verbatim: *"the gates are helpful for rigor but not as gates that are meant to permanently change a forward-progressing state."* So the four ASF gate-*checks* (dependency audit / content review / mechanical / notes disposition) survive as **re-runnable rigor instruments**, and stage-*attainment* is dropped. **A living document under flux gets re-checked, not re-certified.** The replacement is an append-only, per-chapter event log — cheap to write, honest about going stale:

```
verified:
  - 2026-07-22 · deps-audit · pilot-A · depends-chain present & at-or-above this chapter
  - 2026-07-22 · content · pilot-A · κ×A carriage checked against asf#scope-channel-collapse; wrapping caveat added
  - 2026-07-22 · source · pilot-A · counter-register row 1 traced to sar2 experiment record [pending empirica link]
```

Each event records *what was verified, against what, by whom, when* — never *what state the chapter now holds*. It goes stale honestly (a later edit can invalidate a prior event; the event stays, dated, and the next check appends). This mirrors ASF's own `empirica` RUNS and relata `claim-supported` events — verification is an **event stream**, not a **status**. It also closes my cycle-1 workflow-feedback gap (item 5). Under the TST-native destination this aligns cleanly: TST can consume an event stream without inheriting a stage-ladder ASF itself found stale.

---

## 2. The ASF-mechanism ledger — adopt / adapt / decline, with the *why*

**Read under the TST-native default (§0.1):** the question for each row is no longer "does this earn its place?" but "**align unless a difference is warranted — and what does the delta cost the future TST reader to reconcile?**" A `decline` is nearly free when it removes machinery without leaving a competing vocabulary (rings, render-pipeline — TST simply supplies these later); a `decline` is *expensive* when it would make us re-cut a distinction TST already has words for. The genuinely *warranted* deltas — the `testimonial` support-kind, the `transmission` axis, the `convergent` lock — are priced not as report-local cost but as **proposed additions to TST's own vocabulary**, which is the deliverable's real shape (§0.1). The two rows whose reconciliation cost is nonzero and worth watching: **segment-types** (our multi-claim bridges may get refactored into single-claim TST segments on landing — a real cost, flagged in fork 6) and **stage** (resolved above — event-log aligns).

The deltas are where Joseph's "any differences" question lives, so each decline carries its reason.

| ASF mechanism (FORMAT.md) | Disposition | Why |
|---|---|---|
| **Epistemic-triage 3 questions** (well-typed by what priors / what competing formulation / what falsifier) | **Adapt** — add a 4th | The three transfer directly; we need **Q4: established-here or transmitted, and if transmitted, what's the fidelity risk?** — our characteristic mistyping is calling a transmitted claim "derived-here." |
| **Max-attainable-status** | **Adopt** | Makes strengthen-before-soften tractable (§1 Lock B). The single most useful import. |
| **Search-Log vocabulary** (not-conducted / cursory / targeted / nominally-comprehensive / comprehensive / **intuition-only**) | **Adopt** | Our absence-claims ("no shipping tool does X," "the gap the ecosystem documents") are *novelty-of-absence* claims that today assert without disclosing search depth. "A novelty claim under cursory search is honest; the Search Log is what stops it being hubris" transfers verbatim. `intuition-only` legitimizes our honest priors. This is a **real current gap** in the report. |
| **Related-Work relationship labels** (formal antecedent / conceptual precursor / **convergent independent** / direct anticipation / partial anticipation / formalized-by / verified-by / contradicted-by / adjacent) | **Adopt** | Solves our exact lineage-vs-convergence-vs-corroboration problem. The method chapter's descent-correction *is* the `convergent independent` vs `conceptual precursor` distinction — these labels make it mechanical instead of prose (§3 ex. 3). |
| **Novelty-claim postures** (synthesis / differentiation / novelty / transfer / recognition) | **Adopt** for cards + findings | A capability card's contribution-kind is exactly one of these; naming it sharpens the claim (the observation-infra thesis is *transfer* of ASF theory + *recognition* that shipped tables already do A-reduction). |
| **Stage axis** (draft→deps-verified→claims-verified→format-clean→candidate) + 4 gates | **Keep the four gate-*checks* as re-runnable rigor instruments; decline the promotion *ladder* entirely** (Joseph, steward input) | Joseph, near-verbatim: *"stages haven't been too useful yet… the gates are helpful for rigor but not as gates that are meant to permanently change a forward-progressing state."* So the four checks (dependency audit / content review / mechanical / notes disposition) survive as **checklists you run when landing or verifying work**, but there is no rung a chapter climbs and holds. **A living document under flux gets re-checked, not re-certified.** Replace stage-attainment with a **verification-event log** (§1, Element V): record *what was verified and when* — cheap to append, honest about going stale — never *what permanent state was attained*. This also closes my own cycle-1 workflow-feedback gap (item 5: no cheap home for "verified X at source, it held"). |
| **Claim-grain marking** (equation tags) + **derivation-audit table** ("What Is Derived vs What Is Chosen") | **Adopt the principle (claim-grain > segment-grain); adapt the table; decline the equation-tag mechanism** | Our chapters mix strengths *within a paragraph* constantly — segment-grain status is too coarse. But we have few equations (we transmit ASF's), so equation-tags don't fit; the **claim-audit table** does. The counter-register's strength column I just built *is* one. Recommend it for every mixed-strength chapter (§3 ex. 4). |
| **Voice / Working-Notes earning rules** ("segment voice not diff voice"; exactly 3 things earn a Working Note: forward-pointer / regression-guard / dead-end; never vanity-changelog) | **Adopt by citation** | This is the canonical statement of the layer-split we independently reinvented tonight. DEEPENING-CYCLES should **cite `format.sop.md` §Voice + §Working Notes** rather than restate — same discipline, already worked out, scars included. |
| **`empirica:` experiment references** (MANIFEST + RUNS; "an empirical claim citing an experiment with no matching recorded run is a truth-status defect") | **Adopt** for measured/synthetic claims | Our measurements currently cite synthesis digests, not experiment records. The self-chunking claim-or-kill, the sar2 100/60, the ~70%-silent-failures, the 14%→57% pass@1 all want a registered-experiment home with the defect-condition enforced (§3 ex. 5). |
| **Feynman-criterion Brief field** (the bathtub; institutionalized transmissibility) | **Adopt prominently** | This *is* Joseph's "clear enough to be comprehended and transmitted" clause, already institutionalized in a schema. Every strong finding / capability card should carry a Feynman-Brief: the everyday analog whose physics is *isomorphic* to the claim's load-bearing structure (§3 ex. 6). "Truth first, transmissibility as part of truth" gets its home here. |
| **Rings** (inevitability-core / canonical-formulations / empirical-heuristic-discussion) | **Decline** | Rings stratify by "how forced is the form" — meaningful for a derivation program, near-vacuous for a synthesis (almost nothing we carry is *forced*; a synthesis is curatorial by nature). What rings buy — knowing when to stop pushing — we get from **max-attainable-status** per claim instead, at finer grain. Declining rings is a genuine ASF/us delta. |
| **Six-cell Audiences×Render table** + PDF/intermediate pipeline | **Decline the apparatus; keep the principle** | We render markdown only, no LaTeX/PDF build. Keep the *principle* (conventions serve all consumers — harness / UDON / Joseph / auditor) without the six-cell machinery. |
| **`type` taxonomy** (postulate/definition/scope/…/aside — 20 types) | **Decline most; keep a few** | ASF's 20 segment-types serve a claim-per-file theory. Our chapters are multi-claim bridges, not single claims — segment-`type` is the wrong grain. Keep the useful handful as *register* values (our `decided` ≈ ASF `scope`+`normative`; `proposed` ≈ `hypothesis`+`proposed-schema`) and let the claim-audit table carry per-claim kind. |

---

## 3. Worked examples — from my own division

**Ex. 1 — transmission axis (observation-infrastructure, the κ×A bullet).**  
Current prose states the κ×A bias law as established. Under the system: support-kind `theoretic`, strength `conditional`, **transmitted-from** `asf 03-llm-core#scope-channel-collapse`, register `evidenced`. The honest reading: exact-at-source under its named premises; the live risk *here* is fidelity of carriage. Proof this axis earns its keep: my cycle-1 strengthening (naming the W₁/W₂ wrapping caveat so "A is the one knob" doesn't overclaim) was **precisely a transmission-fidelity repair** — a place naive carriage would have overclaimed the source. The `transmitted` marker flags exactly the segments where that risk lives, so a reviewer knows where to check carriage vs where to check the source itself.

**Ex. 2 — the `convergent` lock (errors-that-teach).** Frontmatter today: `cross-tier-convergent (4-tier — the strongest lock in the corpus)`. Under the system: support-kinds `{design, observational, testimonial, theoretic}` agree → `convergent`. But the lock's repair (break the independence) forces the honesty the method chapter demands: the `observational` leg (11/14 harnesses) is mostly **descent** from one influential design, so its independence is partial — the convergence is really 3-independent-plus-a-descent-echo, not 4-independent. The lock **makes the descent-correction mechanical**: you cannot claim `convergent` without auditing each leg's independence, which is exactly right.

**Ex. 3 — Related-Work labels solve the lineage problem (method chapter).**  
The method chapter's whole descent-correction is: distinguish *uniformity by copying* from *genuine independent arrival*. Those are ASF's `conceptual precursor` (str_replace: 11/14 inherit one design) vs `convergent independent` (the fuzzy-match ladder + headless contract: genuine separate arrivals). Adopting the labels turns three paragraphs of careful prose into a per-source tag whose meaning is fixed and auditable.

**Ex. 4 — claim-audit table (counter-register, already built).** The strength column I added this cycle (each of 11 rows leading with its rung) *is* ASF's derivation-audit table, adapted: Property = the counter-thesis, Source = the support-kind, Strength = the rung. Recommend the same for observation-infrastructure (κ×A `conditional`-transmitted / tempo `conditional`-transmitted / "prefer dedicated tool" `observational` / the design-principles agreement `design`-transmitted) — four claims, four strengths, one screen.

**Ex. 5 — `empirica:` (counter-register rows 1, 5, 8).** Row 1 (sar2 100%-vs-60%, failed-to-reproduce on 1/4 families) and row 5 (~70% silent failures) are `measured` claims currently citing a synthesis digest. They want a registered experiment record (params, the model families, the recorded outcome) with ASF's defect-condition — *a measured claim with no matching recorded run is a truth-status defect*. Row 8 (self-chunking unmeasured) is the pure case: it's `hypothesis`, max-attainable `measured`, blocked on the claim-or-kill experiment — the `empirica:` link is what will later discharge it.

**Ex. 6 — Feynman-Brief (transmissibility as truth).** κ×A: *"a fogged gauge you read while hoping for a particular number — the foggier the gauge (A), the more your hoping bends what you read; and you can't wire the hoping out of an LLM (κ≈1), so the only move is to wipe the gauge."* errors-that-teach: *"a locked door that, when it won't open, tells you which key would fit and why this one didn't — versus one that just stays shut, or worse, opens the wrong room and lets you keep walking."* These make the load-bearing structure portable to a reader who never meets the formalism — Joseph's clause, institutionalized.

---

## 4. Genuine forks — preserved for the trio + Joseph (not pre-averaged)

1. **Is `convergent` a status or a modifier?** I lean **modifier** (an orthogonal confidence-lock, because it isn't a *ceiling* — a convergent claim still has a max-attainable rung). But a case exists for making it a distinct top status. The choice affects the frontmatter schema. *Preserved.*

2. **How is `transmitted` encoded?** Three options: (a) a separate `transmitted-from:` provenance field + prose fidelity note [my lean — keeps ASF's ladder words intact]; (b) a status-suffix `inherited-exact` [the coordinator's floated "inherited-exact?"]; (c) a Related-Work relationship (`transmitted-from` as the inverse of ASF's `formalized-by`). I lean (a); (b) is more visible at a glance; (c) unifies with the source-relationship machinery. *Preserved — this is the highest-leverage schema fork.*

3. **Do `design` and `synthetic` collapse?** Both are "constructed, awaits reality." I lean **keep separate** (repair differs: validation-against-ground vs representativeness-check) but it's the closest anti-collapse call in the support-kind set. *Preserved.*

4. **Joseph's word "result."** He listed it among *empirical* registers ("result / observation / testimonial / synthetic"), but in ASF `result` means a *derived, theorem-grade* finding. I read his "result" as **measured experimental result** (an outcome), and used `measured` for it — but if he meant the ASF sense, the support-kind set needs a distinct `result`/`derived` entry beside `theoretic`. *A question for him, preserved rather than guessed.*

5. **Stage gates — RESOLVED by steward input (Joseph):** gate-*checks* kept as re-runnable rigor instruments, promotion-*ladder* dropped, replaced by the append-only verification-event log (§1 Element V). Residual, minor: whether the workflow's own layer-prerequisite rule ("no chapter deepened before its depends-chain") is worth surfacing as a standing *check* in the log's deps-audit line. I lean yes (it's already a check I ran). *Near-closed.*

6. **Segment-type reconciliation cost (new, from the TST-native destination).** Our chapters are multi-claim *bridges*; TST's FORMAT is one-claim-per-segment. On landing inside 02-TST, do the bridges (a) refactor into single-claim TST segments (high fidelity to TST, high reshaping cost, and it may destroy the by-degrees bridge pedagogy that is itself a demand finding), or (b) land as a new TST file-kind ("bridge/synthesis segment") that TST's own cadence-exemption for intro/`disc-*` segments already gestures at? I lean (b) — propose the bridge as a *new segment kind* TST adopts, consistent with framing the whole deliverable as a vocabulary extension. But this is genuinely Joseph's architectural call and the most expensive delta in the ledger. *Preserved.*

---

## 5. One-paragraph recommendation (if forced to a single shape)

Treat ASF/TST FORMAT as the **native environment**, not a neighbor: align by default, and offer our differences as **proposed extensions to TST's evidence vocabulary** — because the empirical-register nuances (first-person agent testimony above all) are evidence kinds a derivation-first vocabulary doesn't yet type. Concretely: adopt ASF's strength ladder and epistemic-triage discipline nearly whole; add a **support-kind axis** (design / observational / testimonial / theoretic / measured / synthetic, each carrying its repair — passing anti-collapse, replacing opaque T-codes with transmissible words, and proposing the kinds TST lacks); add two native notions — a **transmission axis** (`transmitted-from` targeting TST sibling slugs + two-ground defeasibility, the honest face of cite-don't-rederive) and a **convergent lock** (≥2 independent-failure-mode kinds, our actual unit of proof, whose repair forces the descent-correction); carry **max-attainable-status** on every claim to make strengthen-before-soften tractable; replace stage-attainment with an **append-only verification-event log** (gates as re-runnable checks, not a ladder — Joseph); import ASF's **Search-Log**, **Related-Work labels**, **novelty postures**, **empirica**, and **Feynman-Brief** wholesale because each solves a problem the report already has *and* eases future reconciliation; **decline** rings, the render-pipeline apparatus, and most of the 20 segment-types (with the bridge-vs-segment reconciliation cost flagged as Joseph's call). Truth first; and because transmissibility is part of truth, the Feynman-Brief is not optional on the strong findings.

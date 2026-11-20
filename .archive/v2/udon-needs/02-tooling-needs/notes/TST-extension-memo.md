# Proposed extensions to TST's evidence vocabulary

*From the agentic-tooling demand corpus, to ASF/TST's maintainers. Drafted by pilot A with pilot B's kind/repair argument carried forward (B was lost to a session limit mid-cycle; its reasoning record is `notes/epistemology-pilot-B.md`). Status: **proposed** — every item below is a recommendation with reasons, priced for adoption cost. Nothing here is pinned.*

---

## What this is, and the posture it's written in

This corpus is a demand-evidence statement about agent tooling that expects to land as a group within 02-TST. In preparing it we needed a claim-typing system, adopted ASF's, and found that ASF's vocabulary — built for a framework that **derives** — leaves some of our material untypeable. This memo proposes the additions.

The posture is deliberate and worth stating plainly, because the alternative would be worse work. ASF's epistemology was itself grown by iterating "find anything that isn't strictly true and figure out if we can truthify it" — the ontology came from agents applying that process, and the process, not any particular label set, is the load-bearing inheritance. We ran the same process on a new evidence domain and it produced a partly different vocabulary. So these are offered as **improvements TST might adopt for its own material**, not as local dialect we're asking to be tolerated. Where we found a better cut, we say so; where ASF's existing cut is better, we adopted it unchanged (§5).

**Why the domain differs, in one line:** ASF derives; this corpus **transmits, triangulates, and proposes**. Its characteristic failures are therefore not "a choice dressed as a theorem" but *infidelious carriage* and *fake independence* — and the proposals below are the vocabulary those two failures need.

---

## 1. Split evidence-kind from epistemic status — a separate axis

**Proposal.** Add a `support-kind:` axis orthogonal to `status:`, rather than extending `status:` with empirical members.

**Why.** Kind and strength move independently, and the corpus disproves the merged reading directly: chapters here have had a claim's strength rise (`heuristic` → `robust-qualitative`) while its evidence kinds stayed fixed — the strength moved because an *independent kind was added*, not because a rung was climbed. A testimonial can be weak (one voice) or robust (corroborated across substrates); "testimonial" is plainly not a rung. Merging them forces a choice between describing *what kind of thing supports this* and *how firmly*, and both are needed to act.

**Price.** One new frontmatter field; `status:` semantics unchanged. Existing segments remain valid with the field absent. Cheapest item in this memo.

## 2. Six support-kinds, each defined by its repair

**Proposal.** `design · observational · testimonial · theoretic · measured (self|ext) · synthetic`, each carrying **the repair that strengthens or discharges it**:

| Kind | Repair |
|---|---|
| **design** — reasoning not yet exercised against reality | ground-validate: build it, see if reality bears it |
| **observational** — a regularity across shipped systems | replicate elsewhere **and descent-correct** |
| **testimonial** — a first-person practitioner/agent account | corroborate: independent voices, ideally cross-substrate |
| **theoretic** — a formal result | check the proof, or check the premises hold in this domain |
| **measured (self\|ext)** — an in-the-wild or benchmark quantity | replicate; re-measure at wider conditions |
| **synthetic** — constructed scenarios actually run | validate the scenarios are *representative*; re-run under variation |

**Why the repair is the definition, not a gloss.** It makes the taxonomy pass ASF's own anti-collapse test — two labels earn separation only where they route to different repairs — and it makes the label *actionable*: a reader learns not just where a claim came from but what would move it. It also yields a rule we needed immediately: **kind is routed by repair, not by surface.** A count of shipped tools is `observational` (repair: descent-correct), while an effect size is `measured` (repair: re-measure) — same numeral-shaped surface, different kind.

**`testimonial` is the member we'd argue hardest for.** A theory volume about software-as-agentic-domain will increasingly carry lived agent accounts, and they are neither `empirical` (no measurement) nor `discussion` (not interpretation) in ASF's current vocabulary — they are testimony, and their repair is corroboration, which nothing else in the ladder routes to. Typing them honestly is what lets them be *weighed* rather than either over-trusted or quietly discarded.

**Price.** A six-member controlled vocabulary and the judgment to apply it.  
Non-trivial: assignment requires reading a claim for what it rests on. In our 30-chapter migration this was real work, and it repeatedly *found* things — which is the argument for it.

## 3. The convergent lock, keyed on failure-mode independence

**Proposal.** A `convergent:` field listing the **kinds** whose agreement supports a claim — a lock computed on top of status, not a rung within it. Armed only by **≥2 kinds with independent failure modes**; within-kind corroboration raises strength but does *not* arm it.

**Why.** A synthesis's unit of proof is triangulation, and triangulation has one characteristic failure: **fake independence** — agreement that is really one source copied, or one author's several projects. Naming the legs makes the claim auditable rather than asserted, and gives it a unique repair: *break the independence*. That single move converts descent-correction from a discipline someone must remember into a mechanical check.

**It bites, which is the evidence it's worth having.** Applying it across this corpus un-armed one chapter's lock entirely and reduced several others — most sharply, a chapter claiming three-way convergence from "built / designed / theorized" turned out to have **one** leg, because all three are facets of the same author's work. That is exactly the error the field exists to catch, and nothing in the current vocabulary would have surfaced it.

**Price.** One field, plus honesty about author-independence — which for a single-author framework is a genuinely uncomfortable check and, we'd argue, the most valuable thing in this memo.

## 4. The verification-event log — gates as re-runnable checks, not a ladder

**Proposal.** Replace stage-*attainment* with an append-only `verified:` event stream: *what was verified · against what · by whom · when*. The four promotion gates survive as **re-runnable rigor instruments**; what goes away is the notion of a rung a segment climbs and holds.

**Why.** A living document under flux gets re-checked, not re-certified. FORMAT already records that the stage layer "goes stale quickly" and is warnings-only with its methodology under reconsideration — this proposal takes that honest observation to its conclusion rather than working around it. Events go stale *truthfully* (an event is a dated fact about a check that happened; a later edit doesn't falsify it, it just means the next check should append).

**One event kind we'd add explicitly:** `deliberately-corrected-away` — recording a form that was corrected away *on purpose*, so a future re-verifier who notices the corrected truth reads messier than the original is told not to restore it. This imports the routing-SOP's regression check into the machinery instead of relying on anyone remembering it.

**Price.** Tooling that reads `stage:` would need to read events instead, or both during a transition. The highest-tooling-cost item here.

## 5. Transmission: no new status — cross-volume reference plus events

**Proposal.** *Nothing new.* We considered an `inherited-exact` status and rejected it: it launders a non-exact source, and it duplicates what the reference already carries.

**Why it's in this memo anyway.** A transmitting corpus is defeasible on **two independent grounds** — the source could be wrong, *or* our carriage could be infidelious — and the second ground needs somewhere to live. It lives in the verification-event log ("restatement checked against #slug on DATE"), which is part of the argument for §4. We flag one gap honestly: an event records a check *as of a date*, and a source segment can change afterward. Inside ASF a `depends:` edge closes this via the existing downgrade cascade; **that cascade working across a group boundary is something we'd want confirmed** on landing.

**Price.** Zero vocabulary. One confirmation about cascade scope.

## 6. `demand` as a segment type — and the bridge file-kind

**Proposal (a): add `demand` to the type vocabulary.** Our material's dominant claim-shape is "the evidence says a tool/format must provide X" — not a `result`, not a `hypothesis`, not an `observation`. It is a *requirement derived from convergent evidence*, and it behaves differently: it is discharged by being *met*, not by being proven. The report-native `finding` / `principle` / `counterposition` types are offered alongside, more tentatively.

**Proposal (b): a `bridge` file-kind.** Our chapters are multi-claim, order-dependent, by-degrees expositions that orient a reader and hand off to deep material. Refactoring them into one-claim segments would destroy pedagogy that is *itself one of this corpus's demand findings* (progressive disclosure is something agents need). FORMAT's existing cadence exemption for intro and `disc-*` segments already gestures at this category; we propose naming it.

**Price.** This is **the largest extension we ask for**, and we price it as such: a new file-kind means cadence rules, lint behavior, and OUTLINE handling. The mitigation we're already building toward: each bridge carries a **leg-table** — one row per constituent claim with its kind, strength, and repair — so a bridge is a *split manifest*, and claims can be extracted into ordinary segments later without re-reading the prose. If TST prefers the split, that table is the work-order for it.

## 7. Cross-volume reference notation — a settlement for an open row

**Proposal.** `#asf/{aat,tst,llm,eli}/slug` for cross-corpus segment references, rendered `[[stem| #asf/vol/slug]]` — no path, no filename suffix, a space after the pipe so Obsidian renders the display as a tag.

**Why.** FORMAT's cross-volume row is explicitly TBD ("currently inline prose"). This form renders correctly in Obsidian and GitHub, and is **relocation-stable by construction** — references keep working when a corpus is interned into ASF or moved within archema, which is precisely the property we need while our own destination is unsettled. It implies archema-global file-stem uniqueness, which we believe is acceptable and worth the guarantee.

One adjacent convention we found necessary: **`#` is a canonicity marker, not a link style.** It is reserved for canonical segments; project ledgers and working documents take the plain external-document form (`[[FILE.md|label]]`). Without that rule, `#` degrades into decoration and stops meaning anything.

**Price.** Settles an open row; costs a lint rule.

---

## What we are *not* proposing (adopted from ASF unchanged)

Stated so the deltas above read as deliberate rather than as drift: the **strength ladder** (`exact` / `conditional` / `robust-qualitative` / `empirical` / `heuristic` / `discussion-grade` / `sketch`) we adopted nearly whole, adding only `hypothesis` for our large proposed register. The **three epistemic-triage questions** we adopted, adding a fourth (*established here or transmitted?*). **Max-attainable-status** we adopted enthusiastically — with one sharpening worth passing back: state the **evidence-action** that would raise the ceiling, not just the ceiling value, which turns the field into a strengthen-before-soften to-do generator. The **Search Log** statuses (including `intuition-only`), the **Related-Work relationship labels**, the **novelty postures**, the **Feynman-criterion Brief**, and the **`empirica:`** experiment contract we adopted as-is; each solved a problem we already had. We declined the **three rings** — they stratify by how forced a claim's form is, which is meaningful for a derivation program and near-vacuous for a curatorial one; the per-claim ceiling does that work for us at finer grain.

## Open questions for ASF's maintainers

1. Does the `depends:` downgrade cascade operate across a group/part boundary (§5)? Our transmission honesty assumes it will.
2. Is `demand` acceptable as a type, or does TST prefer these framed as `normative` with an evidence precondition?
3. Bridge file-kind (§6b) or claim-split on landing? We lean bridge, and have built the split manifests either way.
4. Would the support-kind axis be adopted volume-wide, or scoped to this group? We think TST's own material would benefit, but that is genuinely ASF's call.

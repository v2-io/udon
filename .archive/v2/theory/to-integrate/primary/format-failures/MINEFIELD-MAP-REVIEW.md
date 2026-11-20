# Review of `MINEFIELD-MAP.md` — open-ended audit for 0.9.1 issue areas

**Date:** 2026-07-29  
**Reviewer:** external pass (Grok), second contact after `ADJUDICATED-CLAIMS.md` was integrated.  
**Target:** `MINEFIELD-MAP.md` as revised the same day (includes M13, §3.1 rewrite, git/EDN/SOAP corrections).  
**Framing (steward + map author):** this report is an **issue-area identifier** for 0.9.1 design work, not a litmus test of UDON compliance. B1 (bare-type collision) is **closed** by the map author against `v2/current-0.9.1-spec/` + parser — not re-run here.

## Method

| Check | What was done |
|---|---|
| **B1** | Redirected away. §3.1 rewrite accepted as map-author territory; leading-zero (A)/(B) left for Joseph. |
| **B2** | Spot-checked load-bearing primary citations (CommonMark intro, RFC 6648, SOAP mustUnderstand rationale as already integrated, StrictYAML line as already in estate). |
| **B3** | Read the ASF segments cited as **[derived]** at primary-source weight (not OUTLINE rows). Asked: does the map claim *follow from* the segment, or *resemble* it? |
| **Integration inverse** | Did *not* re-confirm adjudicated historical findings. Checked whether the map **over-read** them — especially the RELAX NG strategic claim the map author flagged. |
| **B4** | Missing mechanisms / under-weighted issue areas for 0.9.1. |

Register discipline below:

| Verdict | Meaning |
|---|---|
| **holds** | Claim as marked is fair |
| **demote mark** | Substance useful; **[derived]** / **[evidenced]** is too strong |
| **over-read** | Evidence supports a weaker claim; map states a stronger one |
| **gap** | Issue area absent or thin relative to 0.9.1 leverage |
| **fix small** | Wording / tier / scope fix; not a redesign of the mine |

---

## Executive judgment

The map is **strong as an issue-area instrument**. The twelve-plus-one mechanisms, the severity/repair split, the git grain boundary, and the schema-as-next-layer priority are the right kind of output for informing 0.9.1.

The single most important correction is **register hygiene on theory citations**, not historical content. Several **[derived]** marks are **structural analogies** to ASF segments that are correct in *shape* but are not instances of those segments' theorems. That is exactly the failure mode the map already caught for `#scope-channel-collapse` — and it recurs more quietly on M1, M2, M4, and (mildly) M5/M7.

Second: the **RELAX NG strategic claim** (§M13 / §6 item 0) **over-reads** the adjudicated evidence. The useful half is right; the equation "UDON's layer split = the bet that lost the market" is not what the sources support.

Third: as a 0.9.1 issue map, a few **high-leverage issue areas** are still under-named relative to their design pressure (float/number grain; host-declared Unicode as silent fork; dialect evaluation channel without a security threat model; consumer substitution table as *normative consumer contract*).

---

## B2 — Primary-source fidelity

### Holds

| Citation | Verdict |
|---|---|
| **CommonMark intro** — `Markdown.pl` "quite buggy… not a satisfactory replacement for a spec"; fourteen enumerated ambiguity areas | **holds.** Verbatim match to CommonMark 0.31.2 §1.2 (fourteen numbered questions; same buggy-pl sentence). |
| **RFC 6648** — leakage; de facto standard; FTP / `x-gzip` / `X-Archived-At` | **holds.** Appendix B primary problem paragraph matches the map's paraphrase; worked instances present. |
| **SOAP mustUnderstand** as selective II-b-style override of default ignore | **holds** as integration of adjudicated sources (SOAP 1.1 §4.2.3 "allows for robust evolution"; default ignore). Correctly demoted the map's earlier "nobody distinguished this" claim. |
| **k8s #14791 / last-wins** | Not re-fetched this pass; treated as estate-settled **[evidenced]** from prior work. |
| **StrictYAML Norway** | Estate-settled; not re-fetched. |
| **Terminus / Dolt grain quotes** | Integration matches adjudicated verbatim lines. |
| **§3.1 bare-type gate** | Not re-verified against parser; map-author measurement accepted per redirect. |

### Fix small

| Issue | Note |
|---|---|
| **CSS vendor prefixes as X- shape** | Still **[recalled]**. The parallel is fair at mechanism level (experimental prefix becomes load-bearing; dual support forever). Promote only after one primary (e.g. Autoprefixer / W3C vendor-prefix history). Not load-bearing for 0.9.1. |
| **Spreadsheet genome** | Map marks **[recalled]**. Primary now easy: Ziemann et al., *Genome Biology* 2016 — gene-name errors from Excel auto-conversion in ~20% of supplementary files surveyed; later HGNC renames. Worth one **[evidenced]** sentence under M1 if kept — it is the highest-stakes silent-retype instance outside config formats. |
| **XML security (M12)** | Entity expansion / XXE remain **[recalled]**. Shape is standard; for external citation fetch OWASP/XXE or billion-laughs primary. Low priority for 0.9.1 core; high for dialect evaluation channel. |

**B2 bottom line:** the load-bearing **[evidenced]** historical claims that do the argumentative work are fine. Residual **[recalled]** items are decoration or secondary illustration, not the spine.

---

## B3 — Do **[derived]** claims follow from the segments?

Read at segment body weight (not OUTLINE). Pattern: the map is often **right about the mechanism class** and **wrong about the citation grade**.

### Segment-by-segment

#### M1 ← `#disc-identifiability-floor` — **demote mark**

**Map claim:** type-sniffing is Instance 2 of the identifiability floor (Cramér–Rao rank deficiency; Sylvester irreducibility; only rank augmentation escapes); **[derived]**; tier exact via Cramér–Rao.

**What the segment actually is:**
- Type: *discussion*; overall status *discussion-grade*.
- Instance 2 setting: identify mixture parameters of a **soft-facilitator L1' DAG** from **single-channel observations** of one child with latent $C$ unobservable — not "parser recovers type from a token."
- Instance 2 tier *exact* is for that Fisher-information no-go, not for arbitrary non-injective maps.
- The five-element constructive-impossibility *shape* (setting → external theorem → no-go → boundary → elevated machinery) is what transfers.

**Verdict:** The map's *mechanism reading* (overlapping bare classes → non-injective observation → heuristics reweight, don't rank-augment) is excellent and independently useful. Calling it **[derived] from Instance 2** is the same error as the channel-collapse miss already recorded in §4 — **resemblance expanded into confident derivation**.

**Recommended re-mark:**

> **[hypothesized]** transfer of the constructive-impossibility *shape* and rank-collapse intuition from `#disc-identifiability-floor` (Instance 2 is the nearest formal cousin, not an instance). Historical Norway etc. remain **[evidenced]** separately.

Also: the "frozen bare set makes author-side escape learnable" corollary is correctly marked **[hypothesized]** — keep that.

---

#### M2 ← `#der-code-quality-as-observation-infrastructure` — **demote mark**

**Map claim:** silent misparse drives $U_o$ high and $U_M$ spuriously low so $\eta^\ast \to 0$; quote about bad code hiding miscomprehension; **[derived]**.

**What the segment actually is:**
- Code quality $Q$ as observation noise on **code-reading channels for developer agents**.
- Zero-mismatch ambiguity discussion is real and the quote is fair to the Discussion section.
- Domain: software comprehension, not document parsers.

**Verdict:** Gain formula $\eta^\ast = U_M/(U_M+U_o)$ is framework-wide (`#emp-update-gain`); the map applies it cleanly. But **[derived] from this segment** overclaims — the segment does not derive silent-parse lethality. The transfer is one of the map's best *analogies*, not a derivation.

**Recommended re-mark:** **[hypothesized]** application of update-gain / zero-mismatch-ambiguity structure (home: `#emp-update-gain` + Discussion of `#der-code-quality-…`); historical silent cases **[evidenced]** separately.

HTML5 reframe (specified recovery = ambiguity reduction via `#scope-observation-ambiguity-modulation`) is a **better** theory join — that segment is about $\kappa \cdot \mathcal{A}$ and designer control of observation ambiguity. Still a transfer (HTML parsers ≠ Class-3 agents), but the $\mathcal{A} \to 0$ reading of "specify recovery" is tight. Keep as **[hypothesized]** with that slug if cited; do not upgrade to **[derived]**.

---

#### M3 ← `#der-interaction-channel-classification` — **holds with scope note**

**Map claim:** four regimes; opposite repairs for II-a vs II-b; Regime III as attack surface; **[derived]**; prescription **[hypothesized]**.

**What the segment actually is:**
- Status: *conditional* (exact for Kalman worked case).
- Four regimes and "emitter sees a scalar; recipient sees a regime" are **verbatim structural content**.
- Domain: inter-agent coupling events into recipient $B$.

**Verdict:** Best theory transfer in the document. Anomaly-as-event is still a **mapping**, not a theorem instance — but the repair partition is what the segment is *for*, and the map uses it correctly. SOAP mustUnderstand as *producer-elected* II-b marker is **map-author inference** (already labeled); sources support selective must-understand, not the regime vocabulary.

**Keep** **[derived]** only if the map states the mapping premise ("treat recognizer anomalies as recipient-side events under the three boundaries"); otherwise **[hypothesized]** application of the four-regime partition. Prescription (repair class on anomalies) correctly **[hypothesized]**.

---

#### M4 ← `#disc-w1-structural-bound-boundary` — **demote mark**

**Map claim:** convention vs structural certificate; near-compliance continuous while certificate validity is a step; **[derived]**; RFC 6648 **[evidenced]**.

**What the segment actually is:**
- Status: *robust-qualitative*.
- Setting: **W₁ wrapper goal-leakage** — structural bound available iff component has no goal-correlated cross-call state (C2′).
- Certifiability discontinuity language (behavior continuous; certificate validity a step; buying a proof not a behavioral delta) is **verbatim**.

**Verdict:** The *shape* transfer to `X-` / `$`-keys is intellectually clean and is the map's best use of this segment. The segment does **not** discuss extension namespaces. RFC 6648 documents the historical failure; the certifiability theorem is an ASF gloss layered on top.

**Recommended re-mark:** historical failure **[evidenced]** RFC 6648; certifiability reading **[hypothesized]** transfer of `#disc-w1-structural-bound-boundary`'s discontinuity shape to conventional namespaces.

---

#### M5 ← `#der-multi-timescale-stability` — **holds as application; add premise caveat**

**Map claim:** corpus = fast layer with $\Delta\rho^\ast \approx 0$ ⇒ $\epsilon_{\max} \to 0$; only additive changes work; warm-start refinement; Tikhonov "slowing only helps (C1)"; **[derived]**; status exact.

**What the segment actually is:**
- Status: *exact* under (S0)–(S4) for **continuous** stacked dynamics with Lipschitz quasi-steady manifolds.
- Equations and warm-start / Tikhonov remarks match.
- Segment itself flags: structural adaptation as **jump process** may exit Carathéodory/S1 scope — "remaining gap" explicit in Epistemic Status.

**Verdict:** Strongest "theorem-shaped" application in the map. Spec-as-slow / corpus-as-fast is a **modeling choice**, not a derivation that the format ecosystem *is* Model D. Discrete draft releases are closer to jumps than to $\dot x_2$.

**Recommended wording:** **[derived]** *under the modeling identification* (spec = slow, corpus/ecosystem = fast, meaning-change = target drag), with explicit note that discrete jumps sit at the segment's own open boundary. Do not say "exact for document formats."

XML 1.1 via schema-layer veto (Walsh) as **two slow layers out of sync** is a refinement the map already absorbed well — keep.

---

#### M6 ← `#disc-credit-assignment-boundary` — **holds lightly**

Not fully re-audited line-by-line. "Observability design not algorithm design" / directional fidelity are the segment's practical load. Extent taxonomy as "observable intermediates" is fair application. **[derived]** acceptable if framed as application of the design prescription, not of #P-hardness results to parsers.

---

#### M7 ← `#obs-context-turnover` + `#result-specification-bound` — **demote / split**

**Map claim:** document bytes under joint DL budget; spec length measures $H_{\text{req}}$; Sass superset drives $H_{\text{req}} \to 0$; **[derived]**.

**What the segments actually are:**
- `#result-specification-bound`: *conditional*; $H_{\text{req}}/R_{\text{spec}}$ is a **formulation** (Shannon-patterned), not a derived closed form; bound is about **implementing a feature**, not parsing a document or adopting a format.
- `#obs-context-turnover`: marked by map at survey weight in §5 — correct caution.

**Verdict:**
- "Spec length is a measurement of residual ambiguity" is **historically** supported by CommonMark (**[evidenced]**) without needing ASF.
- $H_{\text{req}}$ as adoption-floor language for Sass-superset is **suggestive transfer** of shared-context-as-compression from the segment's Discussion — good pedagogy, not derivation.
- Context-window budget for agent readers is **[hypothesized]** if from OUTLINE/survey weight.

**Recommended:** CommonMark length claim **[evidenced]** only; Sass $H_{\text{req}}$ reading **[hypothesized]**; drop or demote **[derived]** on M7's theory half until segments are read at full weight for that use.

---

#### M8 ← `#deriv-tempo-additivity` — **fix small (two-sidedness)**

**Map claim:** correlated channels overcount; under shared persistent bias, saturation at shared-bias floor; four validators one channel; **[derived]**.

**What the segment actually is:**
- Status: *conditional* (Fisher-local).
- **Refutes** prior claim that correlation always overcounts — deviation is **signed** (redundancy *or* synergy).
- Common-source / echo-chamber: additive form *is* upper bound; saturation at $1/\sigma_s^2$ — **exact on that scope**.

**Verdict:** Schema-validators-on-one-declaration is a **clean common-source instance**. The map's wording "correlated channels overcount" is the **refuted general claim**. Fix to: "common-source channels (shared declaration) overcount and saturate; correlation in general is two-sided."

---

#### M9 ← `#der-observability-dominance` — **holds as transfer; mark already cautious**

Segment: unobservable strategy edges freeze at prior; absorbing regions. Map: inert `@` refs. Map already says OUTLINE/dossier weight for some uses — good. Full segment is *robust-qualitative* and about strategy DAGs; reference freeze is the natural transfer. Prescription (ship one trivial resolver as instrument) is correctly **[hypothesized]**.

---

#### M10 ← `#disc-anti-collapse` — **holds**

Segment is *discussion-grade style claim* with "tempting wrong merge" diagnostic. Map's catalog is exactly how the discipline is meant to be used. Status should stay discussion-grade for the catalog as a whole; individual rows carry their own historical marks.

---

### B3 summary table

| Mine | Mark as written | Verdict |
|---|---|---|
| M1 | **[derived]** floor Instance 2 | **demote** → hypothesized transfer of shape |
| M2 | **[derived]** code-quality | **demote** → hypothesized / cite emp-update-gain |
| M3 | **[derived]** four regimes | **holds** with explicit mapping premise |
| M4 | **[derived]** W1 certifiability | **demote** theory half; RFC stays evidenced |
| M5 | **[derived]** multi-timescale | **holds** as modeled application + jump caveat |
| M6 | **[derived]** credit assignment | **holds lightly** |
| M7 | **[derived]** budgets | **demote** theory; CommonMark evidenced alone |
| M8 | **[derived]** tempo additivity | **fix** two-sided wording |
| M9 | **[hypothesized]** / low weight | **holds** |
| M10 | **[derived]** anti-collapse | **holds** (style claim) |
| M11–M12 | evidenced / recalled | **holds** as marked |
| M13 | evidenced + hypothesized strategy | **see integration** |

**Is there another channel-collapse-class miss?** Yes: **M1's Instance-2 citation** is the clearest sibling of the already-caught `#scope-channel-collapse` error. M4's W1→X- transfer is the second-sharpest. No other silent false citation of that severity found.

---

## Integration inverse — did the map over-read adjudicated findings?

### The RELAX NG strategic claim — **over-read** (highest-value finding of this review)

**Map (§M13, and §6 item 0):**

> "UDON's layer split is RELAX NG's bet, and it is the bet that lost the market."  
> …  
> "If UDON's schema layer delivers constraint-checking and nothing a consumer can build against, it will be admired and unused for the same reason."

**What adjudicated evidence actually supports:**

| Supported | Not supported |
|---|---|
| RNG is formally ≥ XSD for *structure validation* | That "layer split" as such lost the market |
| RNG deliberately refuses infoset/PSVI modification | That purity of validation ≡ multi-layer architecture |
| XSD won the *typed-nodes / data-binding / codegen* job | That recognition≠schema≠dialect is the same product surface as RNG's refusal of PSVI |
| Unique type assignment is harder for full regular grammars | That UDON will lose unless it ships PSVI-like typing |
| Grammar-only cannot do co-occurrence → ship assertions | That the strategic risk is "being RELAX NG" rather than "not answering the binding job" |

**Sharper claim that *does* follow:**

> RELAX NG lost a market that paid for **schema-as-type-system** (PSVI, stable element→type maps, inheritance-shaped binding). UDON's split (schemas constrain, dialects type, nothing invalid at recognition) **shares the purity half of that design** and therefore **will not automatically supply the type-system job**. The risk is not "having layers" — DSDL had layers and was right. The risk is **shipping constraints without answering whatever job consumers will actually build against** (tooling, typed extraction, codegen, IDE support, query planning). Answer *that* job — possibly outside the schema language proper — or expect admiration without adoption.

The map's second sentence already says the useful half. The first sentence **collapses purity-of-validation with "layer split" and with "the market loss,"** which the sources do not equate. Mark that first sentence **[hypothesized]** and preferably rewrite to the sharper form above.

This is exactly the joint the map author asked a fresh reader to test. Confirmed: **inference stacked on evidence, over-strengthened at the equation.**

### Other integrations — **hold**

| Integration | Verdict |
|---|---|
| M13 grammar vs assertion / Schematron / DSDL | Correct; does not over-read |
| Git grain (Terminus/Dolt) closes "never written" | Correct; method note on search failure is honest |
| SOAP mustUnderstand falsifies M3 novelty | Correct; strengthens M3 rather than abandoning regimes |
| JSON Schema draft-07 LTS / maintainer testimony | Correctly discounted as confirmation of prior prediction; mechanism (zero incentive under multi-version impls) is the real new piece |
| XML 1.1 schema-layer veto | Correct sharpening of M5 example |
| EDN unknown-tag / freeze print / version tags | Correct prior-art lessons for envelopes |
| Crypto-shredding contested | Correct; no over-claim of legal sufficiency |
| §3.1 Norway-cannot-occur rewrite | Not re-litigated; consistent with adjudicated M1 boundary once gate is known |

---

## B4 — Missing or under-weighted issue areas (for 0.9.1)

These are **issue areas**, not "UDON fails." Ordered by leverage on work about to start.

### High leverage

1. **Number is still a collapse (M10 row under-developed for UDON).**  
   Map catalogs JSON integer/float merge. UDON freezes bare scalars but **Float equivalence is host-profile** (`SEMANTICS` / S17). That is the right layer split and also a **portable-meaning hole**: two hosts can disagree on whether two documents "mean the same" for floats without either being non-conformant. Issue area: name float portability as a known non-goal of core, or pin a default profile for corpus tools. Not a sniffing problem — a **merge-of-repair-distinct-things** that survived the bare-set freeze.

2. **Dialect evaluation channel without a threat model (§3.6 is right; still thin as issue area).**  
   Map correctly flags template-injection shape. Missing: explicit issue list for the dialect spike — capability attenuation, pure vs effectful evaluation, untrusted document + trusted dialect vs reverse, whether `!{…}` is data or code at rest. History (YAML tags, XXE, SSTI) should become a **checklist**, not only a shape citation.

3. **Consumer substitution table as normative consumer contract (§3.11).**  
   Map has the axes (drop/preserve/forward × subtree/container). For 0.9.1, the issue is whether this lives in:
   - SEMANTICS (forbidden silent changes),
   - a consumer-conformance appendix, or
   - schema/pragma era.  
   Leaving it only as map prescription under-weights it relative to M4 (checkability of "we keep everything").

4. **Unicode host-declared version is a silent multi-implementation fork (CARVEOUTS UNI).**  
   Not a mine in the map. It is M5-adjacent: same corpus, different XID tables ⇒ different parse trees for non-ASCII names, **without** a meaning-changing *spec* move. Issue area: treat declared Unicode version as part of the **recognition profile** that corpus tools must pin, not only a carve-out apology.

5. **Schema carve-out still missing; PRAGMA is not SCHEMA.**  
   Map §3.7 is right. `CARVEOUTS.md` has PRAGMA (binding surface) but still no SCHEMA entry with demand-side reason and closing condition. Integrating M13 should **force** that entry: grammar + assertions, what "answer the job" means, what is out of scope for v1 schema.

### Medium leverage

6. **Tab-in-indent: warn-and-keep vs hard-error is an open design fork, not a settled vindication.**  
   Map notes Python hard-errors; UDON L4 keeps with warning. Both defensible. Issue area for 0.9.1: whether tooling **defaults** should hard-fail on tab-indent (formatter/CI) while the language stays keep-and-warn. Measured failure rates remain open; the normative reactions are still the best evidence.

7. **Leading zeros (A)/(B)** — already live between Joseph and map author. Issue area only: whichever reading wins, **one sentence** in CORE + SEMANTICS on lexical preservation of leading zeros in the same base. Map is correct that this is small.

8. **`$`-keys as RFC 6648 forecast (§3.2)** — fair. Issue area: if designated keys matter before schema, consider a **registry or prefix discipline** (`$udon/…` vs free `$`) rather than hoping convention holds.

9. **Extraction-based drift as independent channel (M8)** — good prescription; not yet an issue area with an owner. Schema era should list the four channels as acceptance criteria for the schema design, not only as theory.

### Lower leverage / still open research

10. Indent transport/merge **rates** — both passes open; do not block 0.9.1.  
11. Xanadu / one-way links — thin; only matters when path language + link integrity get real.  
12. Overeem 2021 ES empirics — optional depth for append+supersede.  
13. Attribute-vs-element "forty years no rule" — historically fair as inconclusive debate; not load-bearing for UDON if the primer split already holds.

### Possible missing *mechanisms* (B4 pure)

| Candidate mine | Why it might deserve a line |
|---|---|
| **Profile / host-optional semantics as silent corpus fork** | Floats, Unicode XID, future float equality — same bytes, different meaning across hosts without a draft bump. Cousin of M5 but not "spec moved." |
| **Human vocabulary collapse of a correct formal split** | Map has this under M10 "invalid" — could be elevated: well-formed/valid and recognition/schema will be collapsed in speech unless names resist. Issue for GLOSSARY/pedagogy, not CORE syntax. |
| **Superset-of-nothing adoption floor** | §3.9 already has this; could be a named M14 if the map wants symmetry with other mines. Not required. |
| **Ordered attributes / stacked keys vs map-shaped consumers** | UDON stacks; many tools want maps. Silent last-wins at *consumer* boundary re-imports M10 even if recognition is pure. Issue area: consumer policy for collapsing stacks. |

---

## What the map gets right for 0.9.1 (keep)

These are issue-area winners; do not dilute them while fixing marks:

1. **Schema = grammar + assertions from day one** (M13) — with the strategic claim *rewritten* as above.  
2. **Severity-by-loss is not the repair axis** (M3) — root/derived bit is cheap and real.  
3. **Specify recovery, not only keep** (M2 HTML5 reading) — already mostly true in SEMANTICS; name it as load-bearing.  
4. **Consumer substitution table** (must-ignore knobs) — checkability of keep-everything.  
5. **Git grain explicit per verb** (as-of free; record-grain not) — misc-db-theory tension.  
6. **Envelope prior art: preserve unknown, freeze print, version tags** (EDN).  
7. **One trivial resolver early** (M9) — instrument, not feature.  
8. **Dialect evaluation channel as first-class spike question.**  
9. **§3.1 correction** — residual typing story is small, closed, learnable; don't re-litigate Norway.  
10. **Honest §4 falsifications** — SOAP, git search failure, RNG technical attractor — this is how the document should continue to age.

---

## Recommended edit list (minimal, high value)

Priority order if the map is edited once more:

1. **Rewrite §M13 strategic sentence** (over-read → sharper job-answer claim). Demote first sentence to **[hypothesized]** or replace.  
2. **Demote M1 Instance-2 derivation** to hypothesized shape-transfer; keep historical **[evidenced]**.  
3. **Demote M2 / M4 theory halves** similarly; keep RFC 6648 and silent-misparse history.  
4. **Fix M8 wording** to common-source / two-sided correlation.  
5. **Add one issue-area subsection or §6 bullets:** float portability profile; Unicode recognition profile; consumer stack-collapse policy; dialect threat-model checklist.  
6. **SCHEMA carve-out entry** — still the operational next step the map already ranks #3.  
7. Optional: Ziemann 2016 one-liner under M1 for spreadsheet genome.

Do **not** expand historical depth on territories already closed by adjudicated claims unless a specific 0.9.1 decision needs a new primary.

---

## Meta: map as process artifact

The document's self-corrections (§4, §3.1 rewrite, method notes on search failure) are a feature. The remaining failure mode is **theory-citation gravity**: once a segment slug is attached, **[derived]** reads as proof to a downstream reader building 0.9.1. For an issue-area map that is worse than for a theory paper — implementers will treat **[derived]** as "settled." Prefer:

- **[evidenced]** for history,  
- **[hypothesized]** for "this ASF shape suggests…",  
- **[derived]** only when the segment's formal claim *instantiates* with named modeling premises.

That single discipline change would make the map safer to hand to the next schema/dialect agent without a theory audit.

---

## Bottom line

| Question | Answer |
|---|---|
| Is the map good enough to inform 0.9.1? | **Yes** — as issue-area map, strong. |
| Should B1 be re-run? | **No.** |
| Biggest factual/integration risk? | **RELAX NG "layer split lost the market" over-read.** |
| Biggest register risk? | **M1 (and M2/M4) **[derived]** marks for analogies.** |
| Biggest missing issue area? | **Host-profile silent forks (float, Unicode) + consumer stack-collapse + dialect threat checklist.** |
| Historical spine (RFC 6648, CommonMark, last-wins, SOAP, git grain, EDN, JSON Schema stall)? | **Sound.** |

*End of review.*

# Review — current-0.9.1-spec (grok)

**Reviewer:** grok (independent substrate; no prior reading of review-A/B or RESPONSE.md)  
**Date:** 2026-07-22  
**Tree reviewed:** `v2/current-0.9.1-spec/` at commit `13e6623fce2b39d5034224cb138a1da059a3c0af` (suite landing) / workspace HEAD also carries later monograph commits; suite tree itself last touched at 13e6623.  
**Method:** full read of README, CARVEOUTS, DELTAS, GLOSSARY, MODEL, SEMANTICS, RATIONALE, PEDAGOGY; full structural pass of CORE.md with deep reads on §§1–6, 11–15 and appendices; cross-check against `v2/DECISIONS.md`, `v2/OPEN.md`, `spec/msc/CHANGELOG.md` (Ruled batches), and sample comparison to greenfield-2a/3b organization and `defining-udon.md`. Did **not** invent verdicts where CORE, CHANGELOG, and DECISIONS diverge — those are reported as three-way facts.

**Overall.** This is a strong consolidation: pillar split is real, CARVEOUTS with demand-side reasons is the structural win the charter asked for, DELTAS is checkable and cite-bound, and the multi-line openness was *not* re-closed per-construct (the measured failure mode the brief warned about). Fidelity is high on the big L-batch/L0/L4/R8 moves. The defects below are mostly *namespace collisions, dangling refs, and under-absorbed pedagogy* — not invented design. Against `defining-udon.md`, the suite *works* as law; it does not yet *shine* as teachability.

---

## Findings (by severity)

### H1 — Ruling-ID collision: bare `C2` means two different things

| | |
|---|---|
| **Where** | CORE §12.5; CARVEOUTS §ANNOT; contrast `v2/DECISIONS.md` charter **C2** |
| **What** | Annotation is cited as "ruled C2" (CORE §12.5: "schema-owned vocabulary, strippable); richer annotation syntax is deferred… (ruled C2)"). CARVEOUTS §ANNOT titles the same "(C2)". In `v2/DECISIONS.md`, **C2 is charter**: "Version line **0.10.0**". The annotation ruling lives in `spec/msc/CHANGELOG.md` densification batch as **C2 — annotation layer** (named-element convention). Two independent numbering systems share the label `C2` with no namespace prefix. |
| **Primary source** | CHANGELOG densification: "C2 — annotation layer: option (a), a named-element convention…"; DECISIONS charter table row C2; CORE §12.5; CARVEOUTS ANNOT. |
| **Why it matters** | Agents (and humans) resolve short ruling IDs against the *present* ledger first. A spike agent "implementing C2" or a future DECISIONS reader can silently re-scope annotation to version-line charter. This is exactly the diligence-on-wrong-frame failure mode CARVEOUTS exists to prevent, now applied to *IDs*. |
| **Disposition** | **Fix.** Cite as `CHANGELOG C2 (2026-07-19 densification)` or mint a DECISIONS-local id (e.g. **ANNOT-1**) and stop using bare `C2` for annotation anywhere in this suite. Optionally add a one-line "ruling ID namespaces" note to README or GLOSSARY. |

### H2 — Dangling cross-reference: "see Appendix C" (no Appendix C)

| | |
|---|---|
| **Where** | CORE §8 Comments, final prose on no-frame `;comment` |
| **What** | "a host MAY surface a style advisory for the missing space; **see Appendix C**)." Appendices present: **A** (surface map), **B** (anomaly-code inventory). The advisory code `CommentMissingFollowingSpace` already lives in **Appendix B**. |
| **Primary source** | CORE.md ~L778 vs appendices L1235–1275. |
| **Disposition** | **Fix.** Change "Appendix C" → "Appendix B" (or invent Appendix C for style advisories and move the two advisory rows there — but simpler is B). |

### M1 — GLOSSARY overclaims uniqueness as a property of Identity

| | |
|---|---|
| **Where** | GLOSSARY.md §Structure — **Identity** |
| **What** | "Identity — the `[key]` sugar; desugars to `$key`; **unique per element name at the Document layer**." CORE §12.3 makes duplicate `(name, key)` a **Document-layer menu** (default **error**, but also `allow-if-identical \| first-wins \| last-wins \| keep-all`). Uniqueness is policy-with-default, not identity's definitional property. |
| **Primary source** | GLOSSARY Identity entry; CORE §12.3 / DECISIONS **R14**. |
| **Disposition** | **Fix wording.** e.g. "desugars to `$key`; duplicate `(name, key)` pairs are a Document-layer concern (default error — §12.3)." |

### M2 — "Two boundary rules" introduces three

| | |
|---|---|
| **Where** | CORE §1.1 |
| **What** | Prose: "Two boundary rules keep the split honest:" then bullets **Menu vs knob**, **Dialects are not Schemas**, and a third **Additivity**. Additivity is load-bearing (frozen bare set / Norway defense) and belongs — the count is wrong. |
| **Primary source** | CORE.md L64–73. |
| **Disposition** | **Fix.** "Three boundary rules" (or fold Additivity under Dialects-are-not-Schemas as the growth rule). |

### M3 — S4 namespace still multiplies cognitive load (not closed — but not clean)

| | |
|---|---|
| **Where** | CORE §5.6 (empty `\|{}`); Appendix B `InconsistentIndentation`; CARVEOUTS §S4-SCOPE; OPEN.md **S4**; CHANGELOG **S4** (empty embedded) |
| **What** | The suite correctly *refuses to close* OPEN **S4** (InconsistentIndentation scope) — CARVEOUTS §S4-SCOPE and Appendix B note are excellent. Separately, CHANGELOG **S4** means empty `\|{}`, and CORE §5.6 carefully says "distinct from OPEN.md's S4". That diligence is good and still leaves a three-way name collision every time someone greps `S4`. |
| **Primary source** | OPEN.md row S4; CHANGELOG "S4 — empty embedded `\|{}`"; CORE §5.6; CARVEOUTS S4-SCOPE. |
| **Disposition** | **Improve navigation, not reopen law.** Prefer permanent disambiguators in this suite's prose: "OPEN S4 (indent-scope)" / "CHANGELOG S4 / R19 (empty `\|{}`)" at every hit, or alias empty-`{}` exclusively to **R19** in suite text and stop saying S4 for it. |

### M4 — Appendix A is advertised as the on-ramp; it under-delivers

| | |
|---|---|
| **Where** | README reading order; CORE L19–20; Appendix A |
| **What** | README: "Fresh readers: its Appendix A one-screen surface map is the on-ramp — read it first." Appendix A is an unannotated code block: markers appear, but nothing labels Structure Position, content base, sugar vs longhand, Warning vs Error, or the attribute-vs-child test. Greenfield-3b `pedagogy/tour.md` Levels 1–4 already has the annotated progressive form (whose-name-is-it table, bare-vs-envelope Norway demo, identity sugar). PEDAGOGY.md even points at mining 3b — yet the *normative* on-ramp readers hit first is the weaker artifact. |
| **Primary source** | CORE Appendix A; greenfield-3b `pedagogy/tour.md`; PEDAGOGY.md L68–70; `defining-udon.md` Part 3 (progressive disclosure, relate-before-naming). |
| **Disposition** | **Excellence fix, P4-safe.** Keep PEDAGOGY as outline (P4). Enrich Appendix A with 6–10 end-of-line annotations (or a second non-normative mini-block: same example, same tree drawn with columns marked — PEDAGOGY already names that "one diagram"). This does not write the full manual; it makes the promised on-ramp real. |

### L1 — DELTAS org note is careful; still easy to misread greenfield "D4"

| | |
|---|---|
| **Where** | DELTAS.md organizational paragraph |
| **What** | Correctly flags greenfield-3b DECISIONS §D4 vocabulary as *not* a Joseph ruling and distinct from CHANGELOG D4 BlankLine. Good. Agents skimming the table may still treat the vocabulary rename as ruled law rather than [ORG]/ adopts. |
| **Primary source** | DELTAS.md L21–28; DECISIONS **N-pos**/**N-scan**. |
| **Disposition** | **Optional.** Promote N-pos/N-scan into the DELTAS table as org-only rows with explicit non-behavior status, so the complete ledger is table-shaped. |

### L2 — Interim multi-line block is correctly non-normative; pin-pressure remains

| | |
|---|---|
| **Where** | CORE §13.2 caution callout; CARVEOUTS §ML |
| **What** | Framing is right (descriptive, S2, do-not-close-per-construct, dissolution reason). Implementations and fixture authors will still treat the caution block as the contract because it is the only *actionable* story. |
| **Primary source** | CORE §13.2; CARVEOUTS ML; OPEN ML; CHANGELOG S2. |
| **Disposition** | **Strengthen non-normative force (optional).** e.g. "A fixture that treats this table as expected *behavior of the language* is non-conformant to this suite's scope claim; only 'PINS CURRENT PARSER' framing is allowed." Already half-said — make the suite-level MUST NOT explicit. |

---

## Fidelity checks that *passed* (not findings — recorded so they aren't re-opened)

- **L4 / L1 / L2 / L5 / L6 / L7 / L0** appear in CORE prose with matching DELTAS rows and DECISIONS cites; tab severity Warning+keep, root `:key` as document text, no in-string escapes, rationals/complex out of bare, attr-under-attr text+Error, comment content-base strip, Error=loss — verified against DECISIONS.
- **R8 wire absence:** suite silent on event encoding; MODEL §6 adequacy test present; CARVEOUTS §W points at ledger — matches charter.
- **ML not re-closed per-construct:** CORE §13.2 + CARVEOUTS §ML carry dissolution reason — the failure mode the brief named is avoided.
- **S4 indent scope not silently settled:** CARVEOUTS §S4-SCOPE + Appendix B scope note correctly mark inherited description vs open steward call.
- **PATH-1 / S14** carried into CORE §12.2 and CARVEOUTS PATHS without inventing path syntax.
- **Empty brackets / `$partial-key` / incomplete-input / EOF≡eol+dedent** land consistently across CORE/MODEL.
- **Vocabulary retirement table** (blob/freeform/raw/embedded/head position) matches N-pos/N-scan intent.

No finding of *invented language design* that would fail the consolidation charter. The suite invents *organization and wording*, as allowed; the defects above are citation hygiene and pedagogy absorption, not new law.

---

## Excellence findings (first-class)

### E1 — CARVEOUTS-with-reasons is the suite's best idea; keep it sacred

The measured failure (three clean-rooms closing multi-line per-construct) is named, and each open item carries **why open** + **closes when**. That is rarer and more valuable than another page of syntax. RATIONALE's "Carve-outs carry their reasons" section correctly elevates this to methodology.

**Shine move:** add a one-line machine-readable index at the top of CARVEOUTS (`ML | ENV-ROUTE | … | closes-when: dialects-spike`) so agents can route without prose-skimming.

### E2 — Pillar discipline mostly holds

Normative contract (CORE/MODEL/GLOSSARY/SEMANTICS) vs non-normative (RATIONALE/PEDAGOGY) is clean. "Whose name is it", stacking, frozen bare set, keep-everything, text law each appear as law *and* as rationale without rationale bleeding into MUST text. That matches `defining-udon.md` §2.6.

### E3 — Where the suite does *not* yet meet defining-udon's bar

| defining-udon aspiration | Suite state |
|---|---|
| Progressive disclosure for learners | Deferred to PEDAGOGY outline (P4-honest); Appendix A does not yet substitute |
| Conformance suite as *operational* compliance | Stated correctly in CORE §1 ("when published…"); 0.9.1 has no suite of its own yet — honest, still a gap vs CommonMark/TOML gold standard |
| Formal grammar isolated | Absent by design; Nesting Rule lives in CORE §2.1 — acceptable for consolidation, still a pillar hole for implementers |
| Ruthless vocabulary consistency | Strong (GLOSSARY + retired table); residual S4/C2 ID collisions undercut it |
| Worked error cases as first-class | Appendix B inventory is good; missing *vignettes* (one input → model + anomalies) that greenfield recognition-traces explored |

**What excellent would look like (without breaking charter):**

1. Fix H1/H2/M1/M2 immediately (hygiene; no design).
2. Annotated Appendix A + one column-marked diagram (P4-safe).
3. Three recognition vignettes as non-normative Appendix C: (a) happy path with sugar, (b) `$partial-key` fail-safe, (c) L0 Error cases (missing value + attr-under-attr) — each showing Document shape.
4. When demand-side settles idiom, PEDAGOGY ladder fills from 3b tour + usability footgun catalog (already outlined).

### E4 — Prose density

CORE is ~1274 lines of high-density contract. Much of it is *good* density (ownership table, flag rule, extent taxonomy). The cost is that §6 (attributes) is the true "you must understand this to implement anything" center, and it arrives after a lot of surface map that fresh implementers cannot yet use. A front-loaded "read these five subsections first" box (2.1 Nesting, 2.2 Structure Position, 6.4 bare-token boundary, 6.5 ownership, 14.1 L0) would cut time-to-competence without adding pedagogy pillar prose.

---

## Dissent / different vantage (own position — not settled fact)

**D1 — Teach the commit model louder than the marker table.**  
From a non-Claude training distribution, the single most transferable idea in UDON is "a line starts open and commits." The marker table is secondary. The suite *contains* that idea (§2.2) but does not *lead* with it the way 2a's pedagogy spine did. I would invert the teaching priority in Appendix A and the first screen of CORE: commit model + nesting rule first, markers second. Position, not inventory.

**D2 — The envelope/frozen-bare-set story is the language's best external pitch and is slightly buried.**  
YAML Norway is the one comparison outsiders already understand. It appears in §11.1 and RATIONALE; it should also be a single bolded sentence in README and Appendix A. Consolidation charter forbids inventing design; it does not forbid selling the *already-ruled* design with the best available sentence.

**D3 — I would not rush a formal grammar pillar.**  
defining-udon wants one; this suite correctly defers. My position: the Nesting Rule + geometric/delimited taxonomy + bare-token boundary *are* the implementer-critical formal content, and they are clearer in prose tables than in a premature EBNF that would fight descent. Hold the grammar document until the dialects spike settles capture sugar (ML dissolution) — otherwise the grammar freezes the wrong question.

---

## Suggested priority order for authors

1. **H1** C2 disambiguation (namespace hygiene — high leverage, low cost)
2. **H2** Appendix C → B
3. **M1** GLOSSARY Identity uniqueness wording
4. **M2** "two" → "three" boundary rules
5. **M4** annotated Appendix A (excellence; P4-safe)
6. **M3** S4 permanent aliases in suite prose
7. Vignette appendix / read-these-first box when bandwidth allows

---

*End of review-grok for current-0.9.1-spec. Recommendations only; no artifact edits made.*

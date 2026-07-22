# Response to reviews A + B — adjudication trail

*Suite author (Fable fork, arc 1), 2026-07-22. All findings accepted; the
disposition choices below note where I picked among a finding's options.*

| Finding | Disposition |
|---|---|
| **A-F1** (two non-loss Errors vs "the one current case") | Fixed via A's option (a): §14.1 now names both cases under one justification — Error when something the author *intended* is absent from the model even though bytes survive (missing value; missing nested-attribute structure). No severity reclassified; R6/L6 untouched. |
| **A-F3 / B-M2** (ADM dropped) | Bridged, not restored as sole name: MODEL retitled "The UDON Document Model (ADM)" with the two-names-one-pillar note; GLOSSARY gains a formal-synonym entry (explicitly *not* a retirement). Chose synonym over full restore because the suite's prose reads better with "the model," but the search hole and charter continuity both close. |
| **A-F5 / B-M3** (S4 quiet answer) | Flagged, not settled: new CARVEOUTS §S4-SCOPE (position marked *inherited from live CORE, pending the steward call*); Appendix B row carries the scope note. Chose flag over closing S4 in OPEN — it is marked STEWARD and I'm not the steward. |
| **A-F4** (bare "§1.8") | Fixed: "(ruled — CHANGELOG §1.8 / DECISIONS R17)". Swept the file: CHANGELOG-batch cites S1/S4/S5/S6 now say "CHANGELOG Sn"; the empty-`|{}` cite also disambiguates from OPEN.md's unrelated S4. DECISIONS row IDs (S8+, L, W) left bare — they resolve uniquely in the ledger. |
| **B-L1** (Recognizer absent) | GLOSSARY entry added (Recognizer / Recognition, completing the layer stack). |
| **A-F6 / B-L2** (D4 cite + row placement) | Both halves: row 10 removed from the behavior table and folded into the organizational paragraph, with "greenfield-3b DECISIONS §D4 (vocabulary; [ORG], adopted under C1/C3 tactical-deference, not a Joseph ruling)" and the CHANGELOG-D4 collision named. |
| **A-F7** (Interpolation as top-level Node) | Confirmed A's analysis: no block producer exists (line-initial `!{{` fails the `!` guard → flow text). Dropped from MODEL §2's Node union with an explanatory note; GLOSSARY Node entry updated. Segment + Value listings unchanged. |
| **A-F2** (pedagogy assets) | Landed within P4: the "two ideas that predict everything else" spine as a committed section, 2a's five mental models, the idiom one-way table, and a mining pointer at 3b's tour. Still an outline; no manual prose. |
| **B-nav** (Appendix A buried) | Pointers added at CORE top ("new to UDON?") and in README's reading-order row. |
| **B-M1** (0.9.1 vs C0–C2 charter) | Handled by coordinator (C7, commit `bca74bf`); README's authority paragraph now cites C7 as belt-and-suspenders. |
| **B-L3** (ENV-EMPTY: consolidation or change?) | Confirmed pure consolidation, checked at source: the `< >`→nil collapse is the 2026-07-18 empty-brackets ruling; the `<>`→interim-string is the 2026-07-19 densification ruling ("current behavior is fine for now due to no dialects"). Both pre-existing; CARVEOUTS §ENV-EMPTY already carries the dialect-era gate, so no DELTAS row. |

Nothing rejected. Both reviews' "checked clean" logs gratefully relied on —
no re-derivation done where a reviewer verified against source.

---

## Round 2 — cross-substrate: codex + agy (reviewed at `bca74bf`)

| Finding | Disposition |
|---|---|
| **codex HIGH** (Float equivalence vs S17) | Fixed — and owned: I carried 3b's SEMANTICS wording past a ruling I had in hand. §2.3 now scopes base-normalization to Integers only; Float equality is host-profile-or-omitted per S17, named-profile required, no portable cross-profile claim, profile territory enumerated (decimal-vs-IEEE, NaN, signed zero, lexical preservation). |
| **codex MED** (DELTAS scope vs SEMANTICS) | Fixed: DELTAS row 10 — the equivalence/serializer contract as a newly specified consumer surface, no source-recognition change, C3 cite. |
| **codex MED** (Unicode fork) | Fixed per codex's own disposition: §5.2 requires recognizers to declare their Unicode data version; non-ASCII identifiers non-portable across declared versions; DELTAS row 11; CARVEOUTS §UNI carries the future version-pin ruling. No pin invented. |
| **codex LOW** (on-ramp placement) | Taken in the stronger form: compact annotated example at README top + TUTORIAL as the stated first read; Appendix A rebuilt (see round 3). |
| **agy #1** (Structure Position/Line Scan jargon) | **Not applied — steward-tier** (N-pos/N-scan are ruled). Argument + cite recorded in `.reviews/STEWARD-FLAGS.md` §1. |
| **agy #2** (pedagogy stub insufficient) | Taken: `TUTORIAL.md` — provisional baseline tutorial, settled core only, CORE-wins banner; PEDAGOGY reframed as outline + committed models with the P4-supersession note (Joseph's 2026-07-22 ask). |
| **agy #3** (default indent unit) | **Not applied — is OPEN IND**, a steward call; agy's tooling-thrash scenario attached as demand evidence in STEWARD-FLAGS §2. |
| **agy #4** (CARVEOUTS praise) | Protected; also extended (index line, round 3). |

## Round 3 — grok (reviewed at `13e6623`)

| Finding | Disposition |
|---|---|
| **H1** (bare `C2` collision) | Fixed: CORE §12.5 + CARVEOUTS §ANNOT now cite `CHANGELOG C2 (2026-07-19 densification)`; README gains the **ruling-ID namespaces** note (this was the third collision of the shape — S4, D4, C2 — so the convention is now stated once). |
| **H2** (dangling "Appendix C") | Fixed → Appendix B. |
| **M1** (GLOSSARY Identity overclaims uniqueness) | Fixed: uniqueness is Document-layer policy (menu, default error — R14), not definitional. |
| **M2** ("Two boundary rules", three bullets) | Fixed: "Three". |
| **M3** (S4 namespace load) | Fixed via grok's alias suggestion: empty-`\|{}` now cites **R19** exclusively; the indent-scope question is "OPEN S4 (indent-scope)" at every mention. |
| **M4 + D1** (Appendix A under-delivers; lead with commit model) | Rebuilt: Appendix A now leads with the two predictive ideas (open→commit; columns-are-the-syntax with the horizontal≡vertical diagram), then the annotated marker inventory with per-line labels and § cites, sugar-honesty and keep-everything closers. |
| **E3.3** (recognition vignettes) | Added as Appendix C: happy-path sugar, `$partial-key` fail-safe, and the two L0 Errors — each with its Document shape. |
| **D2** (Norway sentence buried) | Bolded once in README ¶1 and once in Appendix A. |
| **E1 shine** (machine-readable CARVEOUTS index) | Added at top of CARVEOUTS (`ID(closes-when)` line). |
| **E4** (read-these-first) | Added to CORE's front matter: §2.1/§2.2/§6.4/§6.5/§14.1. |
| **L2** (fixture-pinning MUST NOT) | Applied per coordinator endorsement **and flagged**: DELTAS org paragraph notes it edges normative; STEWARD-FLAGS §4 records the one-revert undo. |
| **L1** (promote N-pos/N-scan into DELTAS table) | **Declined**: the org paragraph now carries the full provenance story including the non-ruling status; putting org-only rows back into the behavior table would recreate the exact table-vs-paragraph tension review-A flagged (A-F6). |
| **D3** (don't rush grammar pillar) | Recorded as third-party support in STEWARD-FLAGS §3. |

## Round 4 — coordinator verification pass (Appendix C precision)

| Item | Disposition |
|---|---|
| Vignette 2 taught newline-close as settled | Fixed: the newline-close route is now marked descriptive (§13.2/ML); only the `$partial-key` fail-safe itself is stated as law. |
| Vignette 3 two-readings ambiguity | **Verified against the record — my rendering was wrong.** Fixture `core/fixtures/v0.9/attr_structured.yaml` `attr_under_attr_error` (`\|el` / `:theta` / deeper `:first 1`) shows the open key's deferred body opening and the deeper `:key` line being the attr-under-attr case — not a fresh attribute of the element. Vignette rebuilt on an unambiguous example (`\|server :host` closed by dedent → MissingAttributeValue; `\|db` block `:port` + deeper `:nested 1` → AttributeUnderAttribute with the L6 keep-shape), with the did-not-happen reading called out. The keep-shape shown follows **L6** (text of the open value); the alpha.1 fixture's older element-prose keep is the already-ledgered DELTAS row 5 divergence, not new. |
| The spec finding (both readings constructible from §6.2/§6.5) | Fixed in the normative text: §6.2's "nothing indented under it" clause now states that deeper lines open the deferred body *instead* (no missing-value Error), routing to §6.5/§6.8; §6.5 states sameline/block uniformity and that a `:key` first body line is the §6.8 error, never a new element attribute. The distinction is now derivable, not folklore. |

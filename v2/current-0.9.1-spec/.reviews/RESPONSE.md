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

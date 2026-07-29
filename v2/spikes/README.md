# v2/spikes — orientation

You're arriving at the ideation/spike layer of UDON's demand-first v2 effort. This
is a reading list, not a work order: what exists, and why each piece mattered to
the sessions that came before you — so you can judge for yourself what to read and
how deeply. It exists because Joseph, reviewing the 2026-07-28 session, judged
that several of these would have best served that session's original reading
list. One piece of recorded experience worth having before you trust a summary or
an index line over a primary: this estate has caught grep-and-window
reconstruction manufacturing confident false versions of skipped reads more than
once, and the 2026-07-28 session found that its secondhand picture of the reports
below had lost things that mattered (evidence weights, tier statuses) in at least
three noticed instances.

## 1. The law and the ledgers

| What | What it is / why it mattered |
|---|---|
| [`../current-0.9.1-spec/`](../current-0.9.1-spec/) — nine files, ~1,500 lines | The language baseline (status per **C8**: semi-frozen, spec-only). CARVEOUTS.md is the register of deliberately-open questions with the demand-side reason each is open — it exists because three clean-room agents, handed the spec without the reasons, diligently closed an open question in a dead framing. Spike work keeps finding its footing there first. |
| [`../DECISIONS.md`](../DECISIONS.md) + [`../OPEN.md`](../OPEN.md) | The live ledgers. The authority is two-tiered in practice: rulings whose carrier prose states a motivation, and reason-less CHANGELOG-era carries — Joseph has said plainly he lacks confidence that the latter reflect more than implementation convenience, and treats them as recheckable when work collides with them. OPEN's banner (his words) explains why its rows are guidance-surface rather than a ruling queue. |
| [`../udon-needs/CLAUDE.md`](../udon-needs/CLAUDE.md) | The standing working license Joseph ratified for demand-side work — research diversion, de-novo testimony, the quality bars. |

## 2. The demand corpus's seven reports (`../udon-needs/02-tooling-needs/reports/`)

The deep treatments the territory seeds cite, with what each carried that proved
load-bearing:

| Report | What it holds |
|---|---|
| `theory-of-agentic-tooling.md` | The ASF/AAT survey — closer to spec-grade than backdrop: the κ×A ambiguity law (structured notation as a formal bias-reduction instrument), error-design-as-language-design (mutation-free, law-rich refusals; atomicity as an epistemic requirement), the reinjection-channel theorem (persistent artifacts as the sole cross-session persistence channel), the description-length budget, and ASF's NOTATION.md as a live precedent of notation carrying epistemic status. |
| `shipping-practice.md` | Fourteen shipped harnesses *and* the lineage disentangle that reprices the counts — the two halves change each other's meaning. Its counting rule: str-replace/apply_patch/todo/ask-user uniformity is common descent, not independent votes; the genuinely independent convergences are the fuzzy-match ladder and the headless I/O contract; and "uniform by inheritance" is itself a sharp statement of the gap UDON targets. |
| `yaml-stress-test.md` | The adversarial quantification behind the write-membrane demand: six corruption scenarios, 100% recovery with backups vs 16% without, and duplicate keys as the one silent, backup-proof failure — the failure UDON's stacking cannot reproduce. |
| `addressing-exploration.md` | The paths demand map: D1–D9, the terminator stress cases, and the trap list (including the stale `design/udon-paths.md` bracket-semantics trap). |
| `agent-utility-exploration.md` | The agent-surface demands beyond addressing: generation/streaming/repair, stage products as public surfaces, the edit critical path, and its §9 harvest list. |
| `the-pattern.md` | The ideology spine: constraint layer + ease gradient ("make the right thing the easiest thing"), DSF-vs-DSL, living documents. |
| `quick-tooling-conventions.md` | The 2025 taproot — predict-failure-before-execution, teaching errors carrying options and confidence, query-for-files-not-answers, the boundary-anchor principle. Manifesto register; the Part-I bridges record what has and hasn't been tested since. |

## 3. The territory maps and measured tables (this directory)

Each seed is possibility-opening and register-marked (*decided* / *evidenced* /
*proposed* / *open*); none closes anything. The tables are measurements under the
ratified framing rule (S2): current-parser behavior in open territory is "PINS
CURRENT PARSER," never language behavior. They were written conclusions-first, so
their first screens carry the findings and their bodies serve as reference.

- [`schema-ideation/`](schema-ideation/) — the deepest map (spine, kinds, decided-law audit, payment-time framing); testimony transcripts and the vivarium specimen sit beside it.
- [`dialects-ideation/`](dialects-ideation/) — "dialect" as four jobs separated by when they act; `concern-map.md` is the MECE reference.
- [`paths-ideation/`](paths-ideation/) — the seed, the 23-domain survey, de-novo testimonies, and `terminator-table.md` (~130 probed cases; the `]` finding).
- [`markdown/`](markdown/) — scope seed, MECE concern map, and the two measured tables (`commonmark-non-conflict-table.md`, `fence-knot-table.md`) with a reproducible harness in `probes/`.
- [`living-documents/`](living-documents/) — the rowan vision, the include primitive, the ascribed AST-graft sketch.
- [`tst-grounding/`](tst-grounding/) — the read of TST's segments against the 2026-07-28 design questions (what the theory supplies, what it doesn't, where its name was borrowed).
- [`doc-store-and-schemas-report.md`](doc-store-and-schemas-report.md) — the four-pass estate review (rowan/autopax/relata/refs/terminology); its §18/§19 are intake lists for paths and the tooling corpus.

## 4. The registers

Each carries header rules stating what its entries are and how they may be cited:

- [`schema-review/DISCUSSION-THOUGHTS.udon`](schema-review/DISCUSSION-THOUGHTS.udon) — Joseph's brainstorms, pre-validation, with per-item assessments. His framing: they embue his experience and must never be silently dropped, but recording does not promote them; they aren't steers unless one is convinced of their principledness. True fiat he marks expressly.
- [`ONLY-IN-UDON.udon`](ONLY-IN-UDON.udon) — distinctive-capability candidates; its rule is that every entry names its nearest-elsewhere, comparison earning what assertion can't.
- [`../FOR-JOSEPH.udon`](../FOR-JOSEPH.udon) — the running decisions-to-run-by-Joseph queue; his answers come back as reactions and fresh brainstorm material rather than YES/NO.

## 5. Cross-repo context that kept mattering

- `~/src/arch/notes/outline-segments-generalization-2026-07-23.md` — the bridge between this repo and TST theory (cluster records, strata on different clocks, layout-follows-co-change). Non-canon, exploratory; its own banner governs.
- [`../../CONSUMERS.md`](../../CONSUMERS.md) — live consumers, plus the stop-gap-tooling section (coordination targets; the section header carries Joseph's framing on why they aren't design input).
- `../udon-needs/01-ideation/02-provenanced/copies/I5-live-consumers/consumer-vivarium-fable-day-report-2026-07-28.md` — the incident-bearing lived-usage field report ("conformance is imitation, not validation").

## The register these artifacts were held to

Recorded here because it was learned expensively, in one day, across five authors
including the coordinator — not as a rulebook but as the calibration Joseph's
reads kept supplying: deliverables here are honest first-passes, and what earned
his trust was conclusions in the first screen, certainty carried in the verb,
corpus-alignment material at aside weight, and one named spine that stays
visible. The failure he caught repeatedly lived in connective prose (summary
sentences borrowing measured cells' authority for unmeasured conclusions),
in superlative ranking (off-topic even when true), and in transcription acts
(where something is recorded confers authority its content may not claim). Two
standing house rules from the repo's own CLAUDE.md apply throughout: divergences
between grammar, parser, and CORE get three-way factual exposition, never a
verdict; and proposals are not ratifications — Joseph alone closes questions.

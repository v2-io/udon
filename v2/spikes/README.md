# v2/spikes — orientation floor + index

You're arriving at the ideation/spike layer of UDON's demand-first v2 effort. This file has two parts with different contracts: **the floor** — the small set you read now, whole, before doing anything — and **the index** — everything else, held as a map you return to *when your work touches it*, not as an onboarding read. The split exists because a full-read orientation was measured (2026-07-29) at roughly two-thirds of a working context: worth it once, for the agent who wrote the synthesis below, but the wrong default. The floor is small on purpose; the index is honest about what each thing is *for* so you can defer it without losing it.

*(Restructured 2026-07-29 at Joseph's direction from the 2026-07-28 all-flat reading list; the glosses survive as index entries.)*

---

## The floor — read now, whole

1. **[`../current-0.9.1-spec/`](../current-0.9.1-spec/)** — the language itself; nine files, ~1,500 lines, ~90 minutes. **Non-negotiable, and first** (Joseph: "I don't think I'll ever feel comfortable with an agent who hasn't gone over the 0.9.1 spec" — this project is, at its core, *that*). Read TUTORIAL → CORE (Appendix A first) → MODEL → the rest. Status per **C8**: semi-frozen, spec-only. Two warnings that survive even a whole read, both measured: **(a) reading buys comprehension, not conformance** — an agent with the whole spec freshly in context still emitted plausible non-canonical constructs the same day (envelopes as element bodies, phase violations), the same imitation-not-validation gap the vivarium field report recorded at low exposure — so verify any UDON you *write* against the parser (`cd ../../core && cargo run --example stdin_parse`) or the highlighter, never against your recall; **(b) current grammar is a fact, not a verdict** — 0.9-era spelling/desugar decisions must not swing open design questions (the O14 discipline; the glob "Never" was exactly that failure).
2. **[`../DECISIONS.md`](../DECISIONS.md) + [`../OPEN.md`](../OPEN.md)** — read the banners and skim the structure (~15 minutes). What you must hold: the authority is two-tiered (rulings whose prose carries a motivation vs reason-less CHANGELOG-era carries — the latter are recheckable on contact, per O3); OPEN's rows are **guidance surface for the territory work, not a pending-ruling queue** (Joseph's banner, verbatim there); proposals are not ratifications, and only Joseph closes questions.
3. **The register rules** (~5 minutes): the header comments of [`schema-review/DISCUSSION-THOUGHTS.udon`](schema-review/DISCUSSION-THOUGHTS.udon) (Joseph's brainstorms are *pre-validation* — recorded so they're never silently dropped, promoted to steers only by earned conviction; fiat will be expressly marked) and [`../FOR-JOSEPH.udon`](../FOR-JOSEPH.udon) (answers come back as reactions, not YES/NO).
4. **The theory's ten claims** — `../udon-needs/02-tooling-needs/reports/theory-of-agentic-tooling.md` **§0 only** (~10 minutes): the ten ASF/AAT results that most constrain or generate tooling design. This is floor because the design discussions here constantly stand on them — *why* sharp typed errors matter (bias is bounded by observation ambiguity, and A is the designer's knob), *why* durable agent-written formats are existential rather than convenient (cross-session persistence exists **only** through the reinjection channel — an exact result), *why* refusal design is language design (errors are the safe channel for learning a system's laws), *why* interface latency is a persistence question, not a UX one — and without §0 you will hear these as house jargon and never know a deeper reason was in play, or where to check it. Each claim's full treatment is one hop away in the same file (that whole report is an index entry below, on-trigger). Two disciplines ride with this: the vocabulary (M_t, δ, η\*, κ×A, tempo/persistence) has precise, tier-labeled meanings — **don't use it decoratively**; and if you lean on a theory result, cite the segment at its stated tier — "the theory grounds this" without the segment is borrowing authority, a failure this estate audits for (the tst-grounding report caught a full day of it).
5. **[`working-synopsis.md`](working-synopsis.md)** (~25 minutes) — the footnoted synthesis of the whole estate as it currently stands: what UDON could be for agents (continuity substrate; register-native writing), doc-stores-as-db with the layered write-governance picture, the paths usage-vector circuit, the arity/expectation axes with their AAT grounding, extraction-first schemas, dialects-as-vocabulary. Floor because it is the live carrier of the current big-picture thinking and the cheapest way to inherit it — **but hold its register**: *proposed throughout, one mind's leans*, evolving in place (check its recent git history for freshness); its footnotes route into everything below, and it has no authority over any primary. If it has been superseded by a more refined artifact since 2026-07-29, read that instead and someone should update this line.
6. **The standing hazards at the bottom of this file** (~2 minutes).

---

## The index — return here on trigger; do not front-load

> **How to use this half.** The glosses below are **hole-markers, not coverage**: a summary line is positive evidence you do *not* hold the content, and this estate has repeatedly caught grep-and-window reconstruction manufacturing confident false versions of skipped reads. Keep a read-ledger (whole / partial / unread) and consult it before claiming orientation over any row. When your work makes a row load-bearing, read its primary **whole** — and weigh it as *input*, not authority: your independent analysis of the spec and the live corpus outranks a prior agent's recorded synthesis wherever they conflict (surface the conflict three-way; don't defer silently). That last rule is measured too: a fully-oriented agent still over-weighted inherited syntheses against its own read until called on it.

### When you start any spike or touch an open question

- [`../current-0.9.1-spec/CARVEOUTS.md`](../current-0.9.1-spec/CARVEOUTS.md) — every deliberately-open item with its demand-side reason and closing condition. **The first read for any spike** (it exists because three diligent agents closed an open question in a dead framing when handed the spec without the reasons).

### When you weigh demand evidence or write for the ASF-bound corpus — the seven reports (`../udon-needs/02-tooling-needs/reports/`)

| Report | Read it when… | What it holds |
|---|---|---|
| `theory-of-agentic-tooling.md` | you frame any claim in AAT terms, or need the formal warrant for a tooling property | the ASF/AAT survey: κ×A ambiguity law, error-design-as-language-design, the reinjection-channel theorem, description-length budget, tier-labeled throughout |
| `shipping-practice.md` | you're about to cite "the ecosystem does X" as evidence | fourteen harnesses *plus the descent disentangle that reprices every count* — uniformity is mostly common descent; the genuinely independent convergences are the fuzzy-match ladder and the headless I/O contract |
| `yaml-stress-test.md` | storage, write-membrane, or duplicate-handling arguments | six corruption scenarios; 100% recovery with backups vs 16% without; duplicate keys as the one silent backup-proof failure |
| `addressing-exploration.md` | paths territory | the demand map: D1–D9, terminator stress cases, the trap list |
| `agent-utility-exploration.md` | agent-surface design (generate/stream/repair/edit) | the §9 harvest list is the densest page of agent-facing demand in the corpus |
| `the-pattern.md` | tool/UX design philosophy | constraint layer + ease gradient ("make the right thing the easiest thing"), DSF-vs-DSL, living documents |
| `quick-tooling-conventions.md` | agent-facing CLI behavior | the 2025 taproot: predict-failure-before-execution, teaching errors, query-for-files; manifesto register — the Part-I bridges say what's been tested since |

The report's own spine — `../udon-needs/02-tooling-needs/OUTLINE.md` — indexes the 30 bridge chapters (convergences, counter-evidence, priorities); read a chapter when its claim is load-bearing, and **always take `counter-register.md` with any thesis you lean on** (it caps claims: the sar2 non-reproduction, validation-doesn't-catch-plausible-wrongness, the cross-family dissents).

### When you enter a territory — the seeds and measured tables (this directory)

All possibility-opening and register-marked (*decided / evidenced / proposed / open*); none closes anything; measurements follow S2 ("PINS CURRENT PARSER," never language behavior); conclusions-first, bodies as reference.

- [`schema-ideation/`](schema-ideation/) — schema territory: the payment-time frame (O1), the non-invasive-judge candidate, the decided-law audit, extraction probes; testimony transcripts + the vivarium specimen beside it.
- [`paths-ideation/`](paths-ideation/) — paths territory: the seed (reach/role axes, anchors, families), the 182-row cross-domain survey, de-novo testimonies, and `terminator-table.md` (~130 probed cases; the `]` finding; the two steward-gating divergences).
- [`dialects-ideation/`](dialects-ideation/) — the four-jobs split (Capture/Recognize/Evaluate/Denote), `concern-map.md` as the MECE reference, `prior-art.md` (tree-sitter/Liquid/Rebol/Dhall).
- [`markdown/`](markdown/) — scope seed, concern map, and the two **measured** tables (`commonmark-non-conflict-table.md`: 652 examples, the non-conflict guarantee held; `fence-knot-table.md`: no fence-length variation exists; `!:label:` is the immune escape hatch) with a reproducible harness in `probes/`.
- [`living-documents/`](living-documents/) — the rowan convergence, the include primitive's fork (reference vs evaluation vs typed AST-graft), the composition gap.
- [`tst-grounding/`](tst-grounding/) — what TST actually carries for the 2026-07-28 design questions, at honest tiers; the P1–P6 transfer table (documents fail P2/P3; a schema checker manufactures the missing P3 channel).
- [`doc-store-and-schemas-report.md`](doc-store-and-schemas-report.md) — the four-pass estate review (rowan/autopax/relata/refs/terminology): the retrofit lesson, designators/resolution ladder/aliases, the write membrane's two-outcome refusal, record-the-vector-not-the-verdict; §18/§19 are the intake lists for paths and the tooling corpus.
- [`working-synopsis.md`](working-synopsis.md) — see the floor's optional entry; also holds the paths usage-vector circuit and the arity/expectation axes (O15) with AAT grounding.

### The registers (cite per their header rules)

- [`schema-review/DISCUSSION-THOUGHTS.udon`](schema-review/DISCUSSION-THOUGHTS.udon) — Joseph's brainstorms O1–O15, verbatim, with per-item assessment; pre-validation, never steers by mere recording.
- [`ONLY-IN-UDON.udon`](ONLY-IN-UDON.udon) — distinctive-capability candidates; every entry must name its nearest-elsewhere.
- [`../FOR-JOSEPH.udon`](../FOR-JOSEPH.udon) — the running decisions-to-run-by-Joseph queue.

### Cross-repo context (read when its subject comes up)

- `~/src/arch/notes/outline-segments-generalization-2026-07-23.md` — the bridge to TST theory (cluster records, strata clocks, layout-follows-co-change); non-canon, its own banner governs; tst-grounding's Appendix A corrects several of its guesses.
- [`../../CONSUMERS.md`](../../CONSUMERS.md) — live consumers + stop-gap tooling (coordination targets, not design input).
- `../udon-needs/01-ideation/02-provenanced/copies/I5-live-consumers/consumer-vivarium-fable-day-report-2026-07-28.md` — the incident-bearing lived-usage report ("conformance is imitation, not validation").
- `../udon-needs/01-ideation/02-provenanced/copies/I3-design-of-record/self-operata-*.md` — the notebook archaeology: the tooling brainstorm + clustering finding; the authenticity/shared-semantic-space and expansion-contraction dialogues.

---

## Standing hazards (each learned expensively; the register these artifacts are held to)

- **Deliverables here are honest first-passes**: conclusions in the first screen, certainty carried in the verb, corpus-alignment at aside weight, one named spine visible. The failures Joseph catches repeatedly: connective prose borrowing measured cells' authority for unmeasured conclusions; superlative ranking; transcription acts conferring authority content doesn't claim (recording ≠ promoting).
- **Divergences between grammar, parser, and CORE get three-way factual exposition, never a verdict**; proposals are not ratifications — Joseph alone closes questions.
- **Present grammar is a fact to price, never the verdict on a design question** (O14) — and wherever you find a lean or prohibition resting on syntax-incumbency, open it rather than inheriting it.
- **Your writing is not conformant because you read the spec** — check it mechanically before it propagates (others will imitate it, incidental choices included — O11).
- **Prior syntheses are inputs**: weigh them against your own primary reads; agreement within this single-author estate is coherence, not corroboration.

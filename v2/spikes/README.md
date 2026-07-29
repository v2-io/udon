# v2/spikes — onboarding

You're arriving at the ideation/spike layer of UDON's demand-first v2 effort. This
README exists because of a measured lesson (2026-07-28): a session that read the
list below *before* working produced categorically better results than sessions
pointed only at the spec — and several of these would have served best on the very
first reading list. Reading order matters less than completeness; the whys tell
you what each is load-bearing for, so you can judge depth yourself. (One caution
from this estate's history before you trust your recall of any of it: an index
line is not the document — grep-and-window reconstruction of a skipped read
manufactures a confident false version. Read the ones you'll lean on whole.)

## 1. The law and the ledgers (always)

| Read | Why |
|---|---|
| [`../current-0.9.1-spec/`](../current-0.9.1-spec/) — whole suite, ~1,500 lines | The language baseline. **Spike agents: CARVEOUTS.md first** — every deliberately-open question with the demand-side reason it is open and what closes it; the register exists because agents without the reasons closed questions in dead framings. |
| [`../DECISIONS.md`](../DECISIONS.md) + [`../OPEN.md`](../OPEN.md) | Live ledgers. Note the authority gradient: rulings whose carrier prose states a motivation are load-bearing; reason-less CHANGELOG-era carries are **recheckable on contact** (surface collisions, don't defer). |
| [`../udon-needs/CLAUDE.md`](../udon-needs/CLAUDE.md) | The standing working license (research diversion, de-novo testimony, quality bars). Applies in spirit to all demand-side work. |

## 2. The demand corpus's seven reports (`../udon-needs/02-tooling-needs/reports/`)

These are the deep treatments the territory seeds cite; secondhand summaries of
them have repeatedly proven lossy in ways that mattered.

| Report | Why it earns a full read |
|---|---|
| `theory-of-agentic-tooling.md` | **Spec-grade, not backdrop.** The κ×A ambiguity law (structured notation as a formal bias-reduction instrument), error-design-as-language-design (mutation-free, law-rich refusals; atomicity as an *epistemic* requirement), the reinjection-channel theorem (persistent artifacts are the *sole* cross-session persistence channel), the description-length budget, and ASF NOTATION.md as live precedent of notation-carrying-epistemic-status. |
| `shipping-practice.md` | Fourteen shipped harnesses **plus the lineage disentangle that reprices the counts** — read both halves together. The counting rule: str-replace/apply_patch/todo/ask-user uniformity is common descent, not independent votes; what survives independently is the fuzzy-match ladder and the headless I/O contract. "Uniform by inheritance" is itself the sharpest statement of the gap UDON targets. |
| `yaml-stress-test.md` | The adversarial quantification behind the write-membrane demand: six corruption scenarios; 100% recovery with backups vs 16% without; **duplicate keys as the one silent, backup-proof failure** — the wound UDON's stacking structurally cannot have. |
| `addressing-exploration.md` | The paths demand map (D1–D9, the terminator stress cases, the trap list — including the stale `design/udon-paths.md` bracket-semantics trap). |
| `agent-utility-exploration.md` | Every agent-surface demand that isn't addressing: generation/streaming/repair, stage products as public surfaces, the edit critical path, the §9 harvest list ("the densest single page of agent-facing demand"). |
| `the-pattern.md` | The ideology spine: constraint layer + ease gradient ("make the right thing the easiest thing"), DSF-vs-DSL, living documents. |
| `quick-tooling-conventions.md` | The 2025 taproot — predict-failure-before-execution, teaching errors with options+confidence (the ancestor of the adjudication-menu idea), query-for-files-not-answers, the boundary-anchor principle. Manifesto register; the Part-I bridges say what has and hasn't been tested since. |

## 3. The territory maps and measured tables (this directory)

Each seed is possibility-opening, register-marked (*decided*/*evidenced*/*proposed*/*open*),
and closes nothing. The tables are measurements; their framing rule is ratified
(S2): current-parser behavior in open territory is **PINS CURRENT PARSER**, never
language behavior.

- [`schema-ideation/`](schema-ideation/) — the deepest map (spine + kinds + decided-law audit + payment-time framing); its testimony transcripts and the vivarium specimen sit beside it.
- [`dialects-ideation/`](dialects-ideation/) — "dialect" as four jobs separated by when they act; `concern-map.md` is the MECE reference.
- [`paths-ideation/`](paths-ideation/) — the seed, the 23-domain survey, de-novo testimonies, and `terminator-table.md` (~130 probed cases; the `]` finding).
- [`markdown/`](markdown/) — scope seed, MECE concern map, and the two measured tables (`commonmark-non-conflict-table.md`, `fence-knot-table.md`) with reproducible harness in `probes/`.
- [`living-documents/`](living-documents/) — the rowan vision, the include primitive, the ascribed AST-graft sketch.
- [`doc-store-and-schemas-report.md`](doc-store-and-schemas-report.md) — the four-pass estate review (rowan/autopax/relata/refs/terminology); §18/§19 are intake lists for paths and the tooling corpus.

## 4. The registers (read the header rules before citing)

- [`schema-review/DISCUSSION-THOUGHTS.udon`](schema-review/DISCUSSION-THOUGHTS.udon) — **Joseph's brainstorms, pre-validation.** They embue his experience and must never be silently dropped, but recording does not promote them; cite as "discussion-thoughts (pre-validation)", never as rulings. True fiat he marks expressly.
- [`ONLY-IN-UDON.udon`](ONLY-IN-UDON.udon) — distinctive-capability candidates; every entry must name its nearest-elsewhere; comparison earns the claim, never assertion.
- [`../FOR-JOSEPH.udon`](../FOR-JOSEPH.udon) — the running decisions-to-run-by-Joseph queue (expect reactions and new brainstorms back, not YES/NO).

## 5. Cross-repo context that keeps mattering

- `~/src/arch/notes/outline-segments-generalization-2026-07-23.md` — the bridge between this repo and TST theory (cluster records, strata on different clocks, layout-follows-co-change). Non-canon, exploratory; its own banner governs.
- [`../../CONSUMERS.md`](../../CONSUMERS.md) — live consumers + the stop-gap-tooling register (coordination targets, **not design input**).
- `../udon-needs/01-ideation/02-provenanced/copies/I5-live-consumers/consumer-vivarium-fable-day-report-2026-07-28.md` — the incident-bearing lived-usage field report ("conformance is imitation, not validation").

## Register discipline (learned the hard way, repeatedly, 2026-07-28)

Deliverables here are honest first-passes, not authoritative reports: conclusions
in the first screen; the verb carries the certainty; corpus-alignment material at
aside/appendix weight; one named spine that stays visible. The recurring failure
lives in the *connective prose* — summary sentences and section headers borrowing
measured cells' authority for unmeasured conclusions — and in *transcription acts*
(where something is recorded confers authority its content may not claim). Where
grammar, parser, and CORE disagree: report the three-way facts, never a verdict.
Proposals are not ratifications; Joseph alone closes questions.

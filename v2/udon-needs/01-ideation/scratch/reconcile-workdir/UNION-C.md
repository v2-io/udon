---
source: reconciliation pass — cluster C
inputs:
  - 01-reconciled-target-files/MERGED-six-maps.md (grok's six-map path union)
  - 02-provenanced-copies/grok-early-pass/sources-udon-repo-design-ux.md
  - 02-provenanced-copies/grok-early-pass/sources-live-consumers.md
date: 2026-07-21
status: flat, spawnable target-file union — supersedes pointer-only treatment of these three files
note: |
  Per Joseph's steer, nothing from these three source files survives here
  only as a "go read MERGED-six-maps.md" pointer — every target path they
  name is pulled up into rows below, with the two provenanced-copies files'
  ✔-copied/not-yet-copied distinctions preserved. MERGED-six-maps.md is
  itself already a six-way union with a rich internal apparatus (weight-
  disagreement ledger §1, reading order §2, dry wells §12, gap ledger §13,
  quick-open cards §15) — that apparatus has real standalone value, so I've
  kept pointers to specific MERGED §-numbers in the Why column rather than
  re-typing all of it, but every *path* is a real row here, not a pointer.
---

# UNION-C — design/UX/utils, usability+scenarios, live consumers

**What this cluster covers.** Three source files with a lot of internal
overlap: the six-map merge (broad, everything in the repo + adjacent
estates, organized by weight band) and two narrower "early pass" files that
had already started actually copying bodies into `extracts/` — one for
in-repo design/UX/utils targets, one for live external `.udon` consumers.
Below, I've re-cut all three by **area** rather than by source file, so a
path named once in `sources-live-consumers.md` and again (with different
notes) in `MERGED §5` becomes one row with both annotations. Weight bands
are grok's pass-1/pass-2 reconciled stance from `MERGED §1`, normalized to
H/M/L; where the original band or the pass-1/pass-2 *disagreement* itself
carries information, it's kept in the Why column — that disagreement (buried
empirical gold vs. well-known design spine) is the single most useful thing
this cluster's sources found, and it's worth an extraction agent seeing it
directly rather than through a pointer.

---

## 1. Usability corpus (`test/usability/`) — primary empirical reservoir

This tree is the crux of the pass-1/pass-2 disagreement (`MERGED §1`, §3a):
pass-1 agents glossed it as "stale models/spec — still evidence" and barely
listed it; pass-2 reweighted it as the **densest empirical deposit** in the
repo for "what would someone actually use UDON for" — ~27 topic-enablement
runs that reportedly predicted July-2026 adopters (process maps, vivarium
narratives, audit/pre-registration) seven months early. Mine raw yaml
bodies, not just the synthesis.

| Target path | Prio | Why / what to extract |
|---|---|---|
| `test/usability/results/udon-topic_enablement-*.yaml` (~25–27 files) | H | Seeded creative-application diversity; `task:` field = domain catalog. Raw diversity > synthesis — read the yamls, not just the digest. `MERGED §3a` |
| `test/usability/results/udon-enablement-*.yaml` (2 files) | H | Free/unseeded "what might UDON enable (incl. agents)" runs |
| `test/usability/lib/topic_enablement.rb` | H | `TOPICS[]` seed list + prompt design — explains what was asked |
| `test/usability/lib/usability_tester.rb` (`enablement_prompt` method) | H | Agent-workflow / A2A / human-agent-collab framing; invites skepticism from the model |
| `test/usability/results/udon-topic_dsl-*.yaml` (5 files) | M | DSL-substrate sibling track (chaos engineering etc.) — "almost invisible in pass 1," worth deliberately not re-losing |
| `test/usability/enablement-synthesis.md` | M | Human compression of topic_enablement (strong/weak fit, novel patterns) — **index, not substitute**; don't double-count against the raw yamls above |
| `test/usability/lib/realistic_tests.rb` (TASKS hash) | M | Genre briefs: frontmatter+prose, experiment report, config+comments, conversation log, recipe — read task defs before bulk result yamls |
| `test/usability/lib/context_comparison.rb` (TASKS hash) | M | Genre briefs: config, mixed tutorial, org chart, inline science, blog schema, HTML email template |
| `test/usability/results/udon-realistic-*.yaml`, `udon-context_comparison-*.yaml` | M | Sample after reading the task defs above, not before |
| `test/usability/results/AGENT_FEEDBACK.md` | L | Aggregated FEEDBACK blocks; friction-heavy — sample for "what I wanted / what hurt," not a use-catalog. Grok's design-ux file flags it as "large, noisy — sample, not whole dump" |
| `test/usability/lib/validated_tests.rb` + `udon-validated-*.yaml` | L | Feature-expectation scoring of authoring tasks |
| `test/usability/lib/test_definitions.rb` | L | Learning-curve ladder + stress/translate defs |
| `test/usability/results/udon-invention-*.yaml`, `udon-learning_curve-*.yaml`, `udon-interpretation-*.yaml` | L | Redesign / onboarding / comprehension contrast runs — **not** a use catalog, treat as contrast only |
| `test/usability/analyze_embeddings.rb`, `embed_sentences.rb`, `analyze_chunks.rb` | L (mining aid) | Could re-cluster enablement responses if the embedding DB still exists (unconfirmed — `MERGED §13.5`) |
| `test/usability/ETHICS.md`, `test/usability/run` | L (provenance) | How agents were treated in the experiment; experiment menu — context for reading the rest of the tree |

Named topic_enablement seed sample (not exhaustive, from `MERGED §3a`): A/B
testing, CQRS, transparency, HCI, OpenID Connect, model distillation,
JAMstack, DDD, reinforcement learning, stream processing, feature store,
human-in-the-loop, cognitive load, turn-taking. Full catalog obtainable via
`rg '^task:' test/usability/results/udon-topic_*.yaml`.

Related meta-evidence (not a substitute for the yamls themselves):
`_archive/REVIEW-JULY-2026.md` enablement/onboarding sections (~L163–208,
~L179–192) — underweighted raw application diversity relative to synthesis,
same failure mode as pass-1 here.

**Dry well / caution:** don't treat `enablement-synthesis.md` and all the P0
yamls as independent sources for counting purposes — the synthesis indexes
the yamls, it isn't a second corpus.

---

## 2. Day-in-the-life scenarios (`test/scenarios/`)

Commissioned 2026-07-16; already speaks in the product's own vocabulary
(skeleton/at/all/diff/patch/CAS/append). All three source files agree this
tree is under-mined relative to the design essays.

| Target path | Prio | Why / what to extract |
|---|---|---|
| `test/scenarios/README.md` | H | Op vocabulary; provisional path syntax; `.gap` = explicit affordance gap marker — read first, per `sources-udon-repo-design-ux.md` and `MERGED §3b` |
| `test/scenarios/features/01-understanding.scenarios.udon` | H | Morning-read journeys |
| `test/scenarios/features/02-diffing.scenarios.udon` | H | Diff journeys |
| `test/scenarios/features/03-modifying.scenarios.udon` | H | Write/patch; schema-guard-before-write shape |
| `test/scenarios/features/04-multi-agent.scenarios.udon` | H | Contention, handoff, concurrent-ledger scenarios |
| `test/scenarios/corpus/*.udon` (7 files, named in §5 below) | M | CORE-0.9 idioms of live genres — mirrors real consumer documents |
| `test/scenarios/bin/verify` | L | Corpus clean-parse contract (tooling, not demand text) |

**Mining tip carried from `MERGED §3b`:** prefer `.gap` scenarios and `|gap`
children first — they name wanted capabilities the current packet doesn't
cover, which is exactly the shape of a demand signal.

`sources-udon-repo-design-ux.md` had this whole tree still in its
"high-value not yet copied" queue (suggested: copy README + 01–04 feature
heads, or the whole dir later) — **not yet copied**, open.

---

## 3. Design-of-record & lived wishlists (in-repo, demand-facing)

Pass-1 strength; pass-2 treats these as "already well-known — skip detail,"
i.e. keep as the design-of-record band rather than re-mining as if freshly
discovered. `sources-udon-repo-design-ux.md` had already copied several of
these into `extracts/` — marked below.

| Target path | Prio | Why / what to extract |
|---|---|---|
| `TOOLING-WISHLIST.md` | H | ✔ copied → `extracts/TOOLING-WISHLIST.md` (whole). Joseph 2026-07-19: events, AST, roundtrip, to-json, fmt |
| `TODO-UTILS.md` | H | ✔ copied → `extracts/TODO-UTILS.md` (whole). Accessors, coerce, serialize, skeleton/paths, **udon guard**, mixin expansion |
| `ux/TODO-AGENT-UX.md` | H | ✔ copied → `extracts/TODO-AGENT-UX.md` (whole). Cheat-sheets, harness rebuild, agentic suite, GBNF; edit-tool is the critical path |
| `ux/TODO-HUMAN-UX.md` | M | Not yet copied (`sources-udon-repo-design-ux.md` suggests whole — it's short). Editor/Obsidian/soft-wrap/LSP/tree-sitter keep-or-not decisions |
| `spec/TODO-AUX.md` | H | Not yet copied (suggested whole — short). Paths + schema + patch aux; `@{…}` embed; rowan named as a waiting customer |
| `spec/TODO-SPEC-CORE.md`, `spec/TODO-SPEC-OTHER.md`, `spec/TODO-TEXT-WIRE.md` | M | Open wording / pragma-schema-bind / text-reconstruction questions — `MERGED §4a` |
| `core/TODO-CORE-PARSING.md`, `core/TODO-PARSER.md` | M | Residuals that block downstream utility products (spans, serializer) |
| `TODO-META.md`, `TODO-PUBLISHING.md` | L | Literate fusion, fixtures-as-UDON, crates/outward docs |
| `tools/descent/TODO-DESCENT.md` (+ standalone `~/src/descent/TODO.md` — may drift from the submodule pin) | L | Generator needs; DESC-as-UDON |
| `design/agentic-ux-principles.md` | H | ✔ copied → `extracts/agentic-ux-principles.md` (whole). The WHY layer the agent tools re-derive against |
| `design/udon-agentic.md` | H | ✔ copied (head only, ~220 of ~1200 lines) → `extracts/udon-agentic-head.md`. **Body still open** — design-of-record tool suite (glance/focus/propose/apply/…) |
| `design/UDON-AGENT-TOOLS.md` | M | ✔ copied (head only) → `extracts/UDON-AGENT-TOOLS-head.md`. **Body still open.** Dec-2025 brainstorm; the "Tier-1 merge" idea isn't fully absorbed yet |
| `design/AGENT-CONTEXT-PROTOCOL.md` | M | Not yet copied — suggested as an excerpt if ACP texture is still missing after the tools-head extract. Agent-friction phenomenology; propose/validate/apply |
| `design/UDON-AS-ACP-FORMAT.md` | M | ✔ copied → `extracts/UDON-AS-ACP-FORMAT.md` (whole). UDON as agent-context packaging |
| `design/udon-guarantees.md` | M | ✔ copied → `extracts/udon-guarantees.md` (whole). Soft/hard guarantees, gatekeeper, tool-mediated edit |
| `design/GRAMMAR-CONSTRAINED-GENERATION.md` | M | ✔ copied → `extracts/GRAMMAR-CONSTRAINED-GENERATION.md` (whole). Guaranteed-valid generation |
| `design/positioning.md` | H | ✔ copied → `extracts/positioning.md` (whole). Agent-voice "who for" — dumb-pipe vs. comprehending-agent litmus; also relevant to §6 below |
| `design/udon-paths.md` | L | Not copied — flagged as pointer-only ("stale spelling, but surviving at/all ideas"); the paths spike re-read (§8 below) is a better source than this file directly |
| `design/udon-ast.md` | M | Not yet copied — suggested excerpt of skeleton/SourceInfo sections. Streaming fragments |
| `design/schema-notes-2026-07.md` | M | ✔ copied → `extracts/schema-notes-2026-07.md` (whole). Short: surfaces, freezes, forks |
| `design/schema-workbench-2026-07.md` | M | Not yet copied — suggested excerpt or whole if schema work becomes a phase-2 focus. Long survey → rowan + corpus; "first waiting customer" |
| `design/udon-schema-exploration.md` | L | Not copied — pointer only, if workbench/notes above don't already supersede it. Older single-source-of-truth vision |
| `design/file-naming.md` | L | Not yet copied (suggested whole, small). `*.<designator>.udon` conventions |
| `design/composite-types.md`, `design/markdown-layers.md`, `design/markup-feature-matrix.md` | L | Type system / four MD user situations / 26-markup competitive-jobs compare |
| `design/semachrome.md`, `design/desc-design-principles.md`, `design/descent-experience-2026-07.md` | L | Coloring model; dialect-author friction texture |
| `spec/msc/adjudication-2026-07-paths-and-silences.md` | M | Path forks packet — positional identity, embeddability questions |
| `design/README.md` | L | Status banners / superseded markers — orientation for the whole `design/` tree |

**Lower for demand (listed so it isn't "rediscovered" as a miss):**
`design/attribute-model-*` (+ proposal-2/3 + substrates) — supply-side,
mostly ratified into CORE 0.9.

---

## 4. Genre seeds — `design/examples/`

| Target path | Prio | Why / what to extract |
|---|---|---|
| `design/examples/schema-dsl.udon` | M | Schema-as-document genre |
| `design/examples/ash-like-{billing,inventory,support}.udon` | M | Resource/domain DSL, rowan-adjacent |
| `design/examples/archema-operata.udon`, `design/examples/operata-intent-graph.udon` | M | Operata / intent-graph genre (intent-graph has a Ruby escape hatch worth noting) |
| `design/examples/practices-gotchas.udon` | M | Authoring hazards, both agent- and human-facing |
| `design/examples/docbook-fo-table.udon`, `design/examples/docbook-graphics.udon`, `design/examples/mathml-to-latex.udon` | L | Transform/round-trip genre |
| `design/examples/cheatsheet.udon`, `design/examples/comprehensive.udon`, `design/examples/minimal.udon` | L | Pedagogy ladder / usability stimuli |

`sources-udon-repo-design-ux.md` flagged this whole subtree as "pointers or
a small set" rather than a full copy — still open, not yet extracted.

---

## 5. Live consumers — external `.udon` documents and loaders

Grounds demand in actual documents and code that load UDON today, not just
design essays. `sources-live-consumers.md` is almost entirely this section;
folded in with `MERGED §5` (which adds the scenario-corpus mirrors and a
couple of program-level TODO/charter rows).

### 5a. Registry & scan mechanics

| Target path | Prio | Why / what to extract |
|---|---|---|
| `CONSUMERS.md` | H | ✔ copied → `extracts/CONSUMERS.md` (whole). Live inventory, migration surfaces, **unused feature surface**, candidate future classes |
| `bin/find-consumers` | L | Discovery / re-scan mechanics — not re-run this cycle; CONSUMERS.md's 2026-07-16 scan is treated as the live-doc authority for now |

**Unused features** (consistent across both maps): no `@`, no `|{…}`, no
freeform fences, no `<…>`, no `:key?` yet in real documents — claimed
affordances not yet pulled into real work; a genuine product-vs-overbuild
signal.

**Candidate future classes** (watchlist, not yet live `.udon`): ADRs,
Axiomata, Signa, Operata, Memorata, A2A agent communications,
mentoring-feedback, Loci, descent grammars (already UDON). These are stated
*intended* use classes from drained planning notes, not files to extract.

### 5b. Live `.udon` documents

| Target path | Prio | Why / what to extract |
|---|---|---|
| `~/src/archema-io/vivarium/doc/PROCESS.udon` | H | ✔ copied (head) → `extracts/consumer-vivarium-PROCESS-head.udon`. Safe-subset authoring contract; hybrid structure+prose; sigil/reflow friction; waits on CLI |
| `~/src/archema-io/vivarium/DECISIONS.decision-log.udon` | H | ✔ copied (head) → `extracts/consumer-vivarium-DECISIONS-head.udon`. Largest append-only concurrent log in the wild; dense date attrs |
| `~/src/archema-io/asf/msc/meta-process-review-2026-07-07/PROCESS-MAP-v0.udon` | H | Not yet copied. Process-map founding document; MECE / health tags |
| `~/src/archema-io/vivarium/LEXICON.udon` | M | Not yet copied. Dictionary genre: identity, relations, `!:md:` embedded tables |
| `~/src/archema-io/vivarium/tabularium/terrestris.ordinum.udon` | M | Not yet copied. Machine-read law-data; versioned phases |
| `~/src/autopax/taxonomy.udon` | M | Not yet copied. Nested taxonomy; multi-value-attribute comma hazards across 0.8→0.9 |

### 5c. Consumer-host process / loaders / program demand

| Target path | Prio | Why / what to extract |
|---|---|---|
| `~/src/archema-io/vivarium/crates/vivarium-world/src/ordinum.rs` | H | Hand-rolled parser awaiting libudon — arguably the cleanest real library-consumer demand signal in the estate |
| `~/src/archema-io/vivarium/tabularium/README.md` | M | Schema-by-filename convention (`*.ordinum.udon`); `stdin_parse` used until a real CLI exists |
| `~/src/archema-io/vivarium/FORMAT.md` | M | Cross-doc path schemes into LEXICON/DECISIONS |
| `~/src/archema-io/vivarium/doc/plan/regula-conformance-design.md` | M | Upcoming `.regula.udon` profiles / conformance rigor |
| `~/src/archema-io/vivarium/doc/toolchain.md`, `ARCHITECTURE.md`, `ASSUMPTIONS.md`, `CLAUDE.md` | M | Toolchain / agent-operating-surface documents |
| `~/src/archema-io/vivarium/core-segment-candidates-2026-07-14.md`, `feedback-from-asf.md` | L | Meta tooling-lift, still open |
| `~/src/archema-io/asf/msc/meta-process-review-2026-07-07/` tree, incl. `09-tooling-automation-capability-utilization-{findings,reflection}.md` | M | Findings/reflections pair, tooling-utilization angle |
| `~/src/archema-io/asf/msc/meta-process-review-2026-07-07/SESSION-LOG-2026-07-14.md` | L | The session that produced/used the process map |
| `~/src/archema-io/asf/msc/markdown-first-pipeline.md`, `build-markdown-design.md`, `FORMAT.md`, `LEXICON.md` | L | Adjacent markdown-pipeline competitor to UDON — contrast material |
| `~/src/archema-io/TODO.md` | H | Explicit program-level demand: Rust linters on udon-core, decision-log tools, archterm YAML→udon, "agentic udon tooling within days" |
| `~/src/archema-io/CHARTER-DRAFT.md`, `~/src/archema-io/charter/concept-matrix.md` | L | Cross-repo format-candidate framing |
| `~/src/autopax/TAXONOMY.md` | L | Markdown twin of `taxonomy.udon` above — useful as a contrast pair |
| `~/src/autopax/docs/ADR/` (esp. 008 yaml/schemas, 010 MD-parse, 002b signum, 012–013 instrumenta) | L | Candidate ADR-as-UDON class + schema history |
| `~/src/autopax/sessions/2025-01-16-yaml-and-schemas-exploration.md` | L | Session texture behind the ADRs above |

### 5d. Scenario-corpus mirrors of live genres

Under `test/scenarios/corpus/` (cross-ref §2 above — same files, noted here
because they specifically mirror the live documents in §5b/§5c): `archema.
concept-matrix.udon`, `asf-processes.process-map.udon`, `operata.domain.
udon`, `operata-live.workspace.udon`, `terrestris.ordinum.udon`, `vivarium.
decision-log.udon`, `vivarium.lexicon.udon`. These encode what the team
*believed* agents would do with those genres more than they encode syntax
per se — useful as a belief/expectation artifact distinct from the live
originals.

**Need classes distilled from this whole section** (from
`sources-live-consumers.md`, still open, not path-level — worth an
extraction agent holding these as a checklist while reading §5b/§5c):
safe-subset + lint/fmt CLI; schema=root-type=filename-designator pattern;
`[key]` identity density for greppable first lines; date attrs today as
unvalidated strings awaiting the temporal dialect; append-friendly docs (no
forced single root wrapper); real library parsing for runtime instead of
hand parsers; raw dialects (`!:md:`, `!:sh:`) embedded in structured docs.

**Dry wells (checked, not fruitful):**
- No `*.udon` files found under `~/src/operata` — the name appears only in
  `design/examples/operata*.udon`, not as a live consumer.
- `ops/` — no hits in the capped live-consumer search pass.

---

## 6. Cross-cutting notes carried from `MERGED-six-maps.md`'s own apparatus

These aren't extraction targets themselves — they're navigational aids
`MERGED-six-maps.md` built that are worth an extraction agent's awareness,
since that whole file is being folded into per-area sections here rather
than read directly:

- **`MERGED §1`** (weight-disagreement ledger) is the single highest-value
  table in that file — it's the source for most of the H/M/L calls above
  and the "already well-known, don't re-mine as discovery" framing for §3.
- **`MERGED §2`** (suggested reading order) roughly matches the section
  order used here: usability P0 → scenarios → lived wishlists → demand
  spikes → live consumers → genre seeds → historical → design-of-record →
  ideology → library contracts → search portals.
- **`MERGED §12`** (intentionally dry / deprioritized) lists repo-wide dry
  wells beyond this cluster's scope (ops/, eli/**, embeddings/, neurips/,
  logos/, vox/, core/target/**, greenfield full-SPEC rewrites, invention-
  track usability, quarantine extracts) — not re-listed here since they're
  outside this cluster's three areas, but worth the spawner knowing they
  were already checked off elsewhere in the six-map merge.
- **`MERGED §13`** (honest gaps admitted) — the `.attic`/`declang` trail
  under `_ref/udon` unconfirmed on disk, a possibly-gone embedding-analysis
  DB, and an unfinished `find *.udon` sweep outside CONSUMERS roots are the
  three gaps most relevant to this cluster's areas specifically.

Sections of `MERGED-six-maps.md` **not** folded into this cluster's areas
(out of scope for UNION-C, belongs to other clusters' unions): §7 (library/
streaming/API surfaces — supply-side), §8 (historical archaeology —
udon-c/libudon/udon-ruby/original-2011), §9–10 (rowan/autopax/operata
schema-versioning + agentic-tooling ideology — explicitly Fable's
territory per both provenanced files), §11 (search portals).

---

## Open question for the merge

`sources-udon-repo-design-ux.md` and `sources-live-consumers.md` both
predate `MERGED-six-maps.md` (both "gathered 2026-07-21," early-pass) and
already did real copying work into `extracts/` — I've preserved every
✔-copied marker above so the spawner knows which rows are "verify the
extract is current" vs. "extract fresh." If another cluster also touched
`extracts/` for overlapping paths (e.g. `design/positioning.md` also shows
up in MERGED §3c as a "use thesis" reference), worth a merge-time check
that we're not describing the same extract twice under different framing.

I'll stay available for merge questions.

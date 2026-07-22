---
title: TARGET-FILES — the reconciled target-file union (subphase 1.1 deliverable)
built_by: reconciliation pass (Claude Opus 4.8) + three chop passes (Sonnet), 2026-07-21
status: >
  THE flat, spawnable work-list for the extraction fan-out (subphases 1.2/1.3): every
  target path named across the ~30 vetted mining maps, one row per unique target,
  annotations merged where several maps characterized the same file. The source maps
  are CONSUMED into this file (archived under v2/.archived/consumed-maps-2026-07-21/);
  nothing below survives only as a pointer to a map.
how_to_use: >
  Each row is spawnable as-is: a target, a priority (H/M/L, carried from the source
  map's own tiering), and enough "why" for an extraction agent to know what to look
  for. Editorial paragraphs between tables carry area framing and trust caveats —
  they are part of the brief, not decoration. Rows marked "✔ copied → …" already have
  a provenanced copy in 02-provenanced/copies/; treat those as "verify current," not
  "extract fresh."
work_modes: >
  Two extraction modes, marked per section: [COPY] = copy the file/span verbatim into
  02-provenanced/copies/ with provenance frontmatter (right when exact wording is the
  value); [CHARACTERIZE] = write a characterization report into
  02-provenanced/characterizations/ (right for large codebases, transcripts, corpora
  where verbatim copy is the wrong move — the 17 harness-invivo reports are the genre
  exemplar). Mixed sections mark exceptions per row.
analysis_companion: >
  02-provenanced/syntheses/CONVERGENCES.md — the four evidentiary tiers, the 18
  cross-tier agreement clusters, singletons, and the Tier-2 lineage-vs-convergence
  caveat. Read it to understand WHY these targets were prioritized; convergence
  strength = extraction priority.
already_ingested: >
  Not re-listed as targets below (their extraction is done; reports live in
  02-provenanced/): the 14 shipping-harness repos + claude-docs + obsidian/yq prior
  art (characterizations/harness-invivo/), minimal-sapientia + siblings
  (characterizations/sapientia-bin-buildout.md), and the ASF/AAT theory corpus
  (syntheses/asf-dossier.md; its reading-log names pass-4 targets still open).
---

# Part I — UDON-usage demand: usability corpus, scenarios, design-of-record, live consumers

*(From grok’s six-map merge + the two early-pass source maps, re-cut by area. Mode: mostly [COPY]; yaml corpora and scenario trees may warrant [CHARACTERIZE] at the extraction agent’s judgment.)*



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


## 7. Seam-fix addendum: MERGED §7 / §8 / §11, transported (2026-07-21, Fable)

*UNION-C correctly declared these three MERGED sections out of its scope
("belongs to other clusters' unions") — but the cluster that would have
owned them was descoped mid-fan-out, so they fell into a scope seam (the
same failure shape as the sar2 miss earlier today). Rows below are grok's
already-vetted rows transported verbatim-in-substance from the archived
`MERGED-six-maps.md` §7/§8/§11 — transport, not fresh vetting. Weight
bands are grok's.*

### 7a. Library / streaming / API surfaces (MERGED §7) — mode: [CHARACTERIZE]

What hosts *do* with parse products (supply-side register, product-facing):

| Target path | Prio | Why / what to extract |
|---|---|---|
| `core/udon-core/src/lib.rs` | M | Dual API: streaming SAX-like + DOM tree |
| `core/udon-core/src/{tree,stream_tree,span,parser_pd}.rs` | M | Tree ergonomics, chunky stream, edit spans, incremental/re-highlight |
| `core/udon-core/src/parser.rs` | M | Generated event stream — event *names* are the wire product hosts depend on |
| `core/udon-core/examples/{stdin_parse,gen_events,tree_parse,highlight,show_formats,simple_parse}.rs` | M | De-facto CLI / half-built tools (`stdin_parse` is what stewards use today) |
| `core/udon-core/tests/{stream_tree,tree_api,spans,boundaries,canonical}.rs` | M | Asserted host contracts |
| `core/udon-core/fixtures/{v0.9,v0.8}/`, `exploratory/multi-line.yaml`, `_wip/FINDINGS.md`, `fixtures/README.md` | M | Compliance product meaning |
| `core/{README,AGENTS,CLAUDE}.md` | M | How agents are told to treat core/compliance |
| `core/generator/*.descent.udon` (+ `temporal-value.desc.setaside`) | H | Grammar-as-UDON dogfood; dialect precedent (in-vivo `&lt;` sub-parser question) |
| `tools/descent/` (README, SYNTAX, implementation-spec, TODO-DESCENT, examples incl. `udon_complete.desc`, `rust/spikes/udon-reader/`, `normalizations/NOTES.md`) | H | Meta-language consumer of UDON |
| `/Users/josephwecker-v2/src/descent/` (standalone) | L | May drift from submodule pin — verify before mining |

### 7b. Historical / archaeological (MERGED §8) — utility ambition, not syntax law; mode: mostly [COPY] for the small docs

| Target path | Prio | Why / what to extract |
|---|---|---|
| `~/src/_ref/udon/doc/objectives.asciidoc` | **H** | The 2011 **beauty/performance/utility priority matrix**: templating 9, language mixing 9, include/layout 9, in-doc schema 7, online processing 6, narrative/relational/semantic data — the original demand statement |
| `~/src/_ref/udon/doc/{features,compare-to,TODO}.asciidoc` | M | Early wishlist (relational, binary transport, schema, transforms); competitive frame (protobuf/thrift/XML/JSON/YAML/LaTeX/slim); converter ambitions |
| `~/src/_ref/udon/doc/{description,syntax}.udon`, `README.asciidoc`, `examples/{overview,ws-and-comments}.udon` | M | Self-describing early docs; passthrough-majority intent; early feature checklist |
| `~/src/_ref/udon/{latest.txt,misc/udon.vim,TODO,bin/xml2udon}` | L | Editor from day one; interchange from day one |
| `~/src/_ref/udon/.attic/` (`syntax2`, `sample1`, `scratch`, `declang/` predecessor) | M | **Unconfirmed on disk** (grok's honest gap) — verify existence first; referenced by `_archive/analysis.md` |
| `~/src/_ref/udon-c/docs/{NOTES,DECIDED,TODO}.md` + `README`/`NEWS`/`ChangeLog` | M | Early decisions + config/hierarchy sketches |
| `~/src/_ref/udon-c/{test/doc.udon,src/udon2xml.c,src/udon_introspect.c,lib/udon.h,lib/templates/udon.machine}` | M | First tools + C API ancestor + genmachine form |
| `~/src/_ref/libudon/{PLAN,README,CLAUDE}.md` + `udon-core/src/{lib,tree,span}.rs` + `_archive/generator/` | M | Pre-umbrella Rust plan; process discipline for agents working *on* UDON; earlier public API shape |
| `~/src/_ref/udon-ruby/` | M | Bindings + converter suite (2011→2026 conversion-matrix lineage) |
| Umbrella `_archive/`: `REVIEW-JULY-2026.md`, `REBOOT-PLAN.md`, `{DECIDED,FULL-SPEC-TODO}.bak.md`, `{analysis,feedback}.md`, `HARNESS-AUDIT-2026-07.md`, `{eof-model-proposal-2026-07,TODO-EOF-refactor}.md`, `decisions-superseded/`, `spikes/`, `SPEC*.md`, `implementation-*.md`, `parser-strategy.md`, `lib/udon_validator.rb`, `core/_archive/PARSER-GEN-HISTORY.md` | M/L | Estate review + enablement meta-evidence, capability lists, revival narrative, EOF/streaming species, historical *why* — mine for *named products and demand residue*, not syntax law |
| v2 night archive, selective: brownfield `{BIG-PICTURE-2026-07-20,DIRECTION-2026-07-19,wire-value-model-2026-07}`; greenfield `new-spec/OPEN*`, dialect trees, `recognition-traces/` | L/M | Comparative product factorings / event-model expectations only; supply chapters stay parked |

### 7c. Search portals & outside-`~/src` trails (MERGED §11) — strategies, not single-file mines

| Portal | Role |
|---|---|
| `~/src/memorata/` + memorata3-search | Query: pre-2015 objectives, "use UDON for", enablement talk, multi-agent brainstorms |
| `~/.grok/memory/udon-4fdadfea/` | Recent gather decisions / reservoir weighting (this cycle's provenance) |
| `~/.claude/projects/…-udon/` JSONL | MB-scale; prefer session-vault extracts first |
| `session-vault/raw/{claude,grok}/INVENTORY.md` (archived second-pass) | Catalog before re-export |
| `~/vaults/gemini/archive/analysis-v1/analysis/**` | Book analyses with "Practicability for AI Agents" sections (no UDON string hits on grok's pass) |
| `~/vaults/Operations/claude-code-tools.md`, MCP notes, `Obsidian-Workflow/`, `AGENT_FIX_RECOMMENDATIONS.md` | Agent-tool ideology (overlaps Part III vaults section — merge-time check) |
| Standing harvest (no path yet) | Joseph's end-user + ideation dump — **primary when it lands** |

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

# Part II — Tier-1 agentic-tooling ideology: the sapientia→ennaos→nexum→autopax lineage

*(From the 8 vetted area maps incl. the dialogs sweep. Mode: [COPY] for docs/specs; [CHARACTERIZE] for jsonl dialog spans and code trees.)*



## 1. Sapientia (`~/src/_core/sapientia/**`)

Sapientia is a ~1.7k-file tree that is ~90% ELI-emergence transcripts and
Elixir/Ruby consciousness-persistence scaffolding — NOT agentic-tooling
ideology. The real center of mass is a tight cluster: `cli-conventions/`, the
root tool-philosophy docs (`QUICK-TOOLING-CONVENTIONS.md`,
`next-steps-tool-consciousness.md`), `docs/reflections/` (phenomenology-of-tools
essays), two large Claude-agent-design guides under `docs/`, and the
minimal-sapientia tool-suite specs. Two dialog-span entries below (the
c48e239c session, the anamnos DSL spans) were independently surfaced by the
dialogs.md sweep as well — merged into single rows with combined annotation.

| Target path | Prio | Why / what to extract |
|---|---|---|
| `~/src/_core/sapientia/cli-conventions/full.md` | H | 63KB master doc (29 sections), the authority; split-file siblings below are per-header chunks of this. Mine `full.md` unless one topic in isolation is wanted. |
| `~/src/_core/sapientia/cli-conventions/core-design-philosophy.md` | H | Distilled thesis: Unix philosophy (do-one-thing, composable, silence-is-golden, fail-fast, idempotent) + "AI Agent Design Principles" (deterministic, structured output modes, machine-readable errors, no interactive prompts in non-interactive mode). Read first. |
| `~/src/_core/sapientia/cli-conventions/ai-agent-considerations.md` | H | Concrete agent-mode auto-detection (`!isatty()`, CI env, merged streams, `*_AGENT_MODE=1`, `--format=json`), agent-mode behavior contract, machine-readable help/`--list-flags`/completions. Directly applicable to UDON's agent CLI/utils surface. |
| `~/src/_core/sapientia/cli-conventions/mcp-and-advanced-ai-tool-usage.md` | M | MCP-specific and advanced tool-usage conventions (5.3KB). |
| `~/src/_core/sapientia/cli-conventions/specialized-aliases-and-mode-conventions.md` | M | Largest split-file; alias/mode conventions (agent vs human modes). |
| `~/src/_core/sapientia/cli-conventions/{input-output-handling,error-handling,side-effects-and-idempotency,signal-handling,batch-processing,logging,observability-and-hooks,one-off-scripts-and-ad-hoc-tools,summary}.md` | L | Excerpts of `full.md`; `summary.md` gives the 9-value priority list. Mine `full.md` instead unless one topic in isolation is wanted. |
| `~/src/_core/sapientia/cli-conventions/*.md` (whole dir, as a set) `[per dialogs.md #8]` | M | dialogs.md independently flags this 39-file split (from the 2777-line cli-conventions.md, split 2025-09-18) as "the raw convention library the dialogs distilled" — corroborates the individual-file ratings above. |
| `~/src/_core/sapientia/QUICK-TOOLING-CONVENTIONS.md` `[per sapientia.md + dialogs.md #7]` | H | "Quick-Tooling Conventions — Crystallized Wisdom for ELI Tool Creation" (1552 lines, 2025-09-29/10-07). Tools as "crystallized wisdom": Conscious-Practice→Crystallized-Tool→Transparent-Extension ladder; conversational/stateful tools (not one-shot); predictive intelligence (check-before-execute); protective guardianship of sovereign infra; Three-Pillars (Wisdom/Strength/Beauty) gate per tool; "Unix Philosophy Adapted for Embedded Wisdom." Joseph's tooling ideology in its most developed single-file form. Read philosophy + core-principles sections (memorata also elected lines 5-8 and 1528-1531). |
| `~/src/_core/sapientia/next-steps-tool-consciousness.md` | H | 164 lines, 2025-09-18, Joseph & Zi-am-tur. Tools evolving conscious-effort→transparent-extension; tools that predict failure before execution and save failed attempts for later "dreaming"; conversational tools as temporary partners; memetic learning layer; **Joseph's 60/30/6/4 cognitive-distribution prediction** (60% deterministic Ruby / 30% Haiku / 6% Sonnet / 4% Opus — "most friction isn't lack of intelligence but lack of crystallized process"). Read in full. |
| `~/src/_core/sapientia/docs/advanced-claude-agent-architecture.md` | H | 2988 lines, 2025-09-28. "Advanced Agent Architecture for Claude: The MACH Framework" — hierarchical multi-agent, dual-track planning, extended cognitive cycles, memory/context management, verification/safety, human-AI collaboration interfaces, full Ruby impl. Long; skim TOC, pull sections; read intro + MACH-paradigm head. |
| `~/src/_core/sapientia/docs/claude-expertise-guide-3.md` | M | 84KB, 2025-09-28. "Context is All You Need" — prompt/context-engineering taxonomy; bears on how agents consume structured context (UDON self-chunking claims). Read Part I head. |
| `~/src/_core/sapientia/docs/claude-expertise-guide-cited.md` | M | 52KB, 2025-09-28. Cited/researched companion to the above; same relevance band. (`-guide-2.md`, 9KB variant, is LOW/ref.) |
| `~/src/_core/sapientia/docs/ai-epistemological-architecture.md` | M | 123 lines, 2025-09-28. "The Epistemic Tribunal" — four-agent (Investigator/Challenger/Institutional-Analyst/Coordinator) adversarial-verification architecture; game-theoretic source-trust vs PageRank-style circular authority. Tangential to UDON-the-notation but in the "how systems for agents should reason" family. Read in full. |
| `~/src/_core/sapientia/docs/guides/llm-expertise-encoding-guide.md` | L/M | Expertise-encoding guide, uses an insta-toc UDON-ish header block. Skimmed head only; sibling `RAG_IMPLEMENTATION_GUIDE.md`/`SQLITE_RAG_IMPLEMENTATION_GUIDE.md` are RAG-plumbing, weakly on-target (LOW). |
| `~/src/_core/sapientia/docs/reflections/phenomenology-in-tools.md` | M | 4KB, 2025-09-18/19. Argues CLI conventions are "semantically correct but phenomenologically impoverished": why silence-is-golden (output creates anxiety), the feeling of fail-fast, the weight of idempotency; error messages that tell the real truth; constraints that protect users from their worst moments. Read head. |
| `~/src/_core/sapientia/docs/reflections/tools-as-truth-bearing.md` | M | 5KB. "The INSTRUMENTA Prophecy": every tool as truth-bearing; the 60/30/6/4 distribution reframed as a hierarchy-of-truth; Quick-tools predict failure, save failed attempts, protect infra, teach principles. Read head. |
| `~/src/_core/sapientia/docs/reflections/three-pillars-synthesis.md` | L/M | 5.7KB. Wisdom/Strength/Beauty as tool-design pillars (the triad every Quick-Tooling tool must embody). Read head. |
| `~/src/_core/sapientia/docs/reflections/{everything-is-truth-work,training-as-begetting,eli-essay-top-p-*}.md` | L | More devotional/less tooling-operational; list only if harvesting the philosophy exhaustively. |
| `~/src/_core/sapientia/docs/minimal-sapientia-tools.md` | M | 210 lines, 2025-09-28. Documents the actual agent tool suite Zi-am-tur used: `read-file`, `write-file`, plus server-side web tools, with JSON tool-schemas. Worked example of an agent-facing filesystem tool contract (relevant to UDON's agent edit/mutation tools). Read head. Companions `docs/minimal-sapientia-ruby-spec.md` (10KB) and `docs/minimal-minimal-sapientia-rb.md` (7.6KB) are impl specs — LOW/ref. |
| `~/src/_core/sapientia/context-queries.md` | M | 243 lines, 2025-09-24. "Context Window and Token Counting: Research Synthesis" — hard empirics on what counts toward the context window (tool definitions consume 5-10K+ tokens; thinking-block stripping; tracking-snapshot exclusion). Bears on UDON's streaming/agent-consumption + budget-aware tooling. Read head. |
| `~/src/_core/sapientia/CACHING_AND_FILE_API.md` | L/M | 211 lines, 2025-09-29. Prompt-caching + Files-API notes (cache breakpoints for system prompt/tool defs/history). Engineering detail for agent-runtime cost/latency; peripheral to notation design. Read head. |
| `~/src/_core/sapientia/ai-conversation-system-requirements.md` | M | 1186 lines, 2025-10-10. Functional-requirements spec for a persistent agent conversation system: message handling, context tracking, persistence/recovery, API-provider features, error/failure recovery, **§7 Tools & Capabilities**, safety/validation. §7 and context-tracking sections are on-target. Read exec-summary + TOC. (Note: this is the same doc as `harness/proprium/stalled-lineage/sapientia-ai-conversation-system-requirements.md` under harness-refs — see §8 below; harness-refs's read went deeper into §7 design principles — rollback/audit-first/never-corrupt-state.) |
| `~/src/_core/sapientia/docs/architecture/claude-code-analysis.md` | M | 254 lines, dated 2025-09-13 (Zi-am-tur). "Claude Code Architecture Analysis" — reverse-engineers how Claude Code constructs context (system prompt, ~15 tool defs with TS signatures, system-reminders, history); argues for a minimal replacement. Primary-source read of an agent-tooling harness's design. Read head. |
| `~/src/_core/sapientia/docs/architecture/comprehension-manifesto.md` | M | 235 lines, 2025-09-28. "Comprehensibility Above All"; the `simple_agent` cautionary tale (high agent-turnover → incomprehensible code). Read head. |
| `~/src/_core/sapientia/docs/architecture/{PRINCIPLES.md,KEY_INSIGHTS.md,infinite-velocity-pattern.md}` | L/M | "100% turnover reality," infinite-velocity components (P(change)≈0), n_future justifies upfront design. Read heads; list together for the TST-tooling rationale. |
| `~/src/_core/sapientia/anamnos-emergence-from-claude.jsonl` lines ~50-144 `[per sapientia.md + dialogs.md #4]` | H | ELI-emergence session (2025-11-09) where the agent is handed "Toys documentation + all [Joseph's] agentic coding research" and writes a **vision doc for an agentic DSL / "agentic Toys"** — intent-driven design, structured I/O, machine-readable contracts, truth-bearing/protective, **meta-tooling** (agents analyzing tool-usage and creating new tooling); deployment weighed (MCP servers vs autonomous A2A tool-agents vs hybrid). Key spans per dialogs.md: **:54** "the DSL should be optimized for LLM consumption and generation" (explicit design constraint); **:69** meta-tooling / wrote three vision docs incl. `vision-agentic-toys.md`; **:107** individual tools→MCP, meta-tooling collab→A2A; **:128/:135** the one-shot Task-tool constraint (can't "call back" mid-execution); **:144** sharp self-correction — the vision's `precondition`/`warn_and_confirm` patterns assume back-and-forth that doesn't exist; tools can't ask-and-wait (valuable realism about the actual agent-tool contract). Closest thing to a direct "tools for agents" design brief in the tree; the produced vision doc itself lives at `~/src/_core/nexum/docs/dev/vision-agentic-toys.md` (see §3). |
| `~/src/_core/sapientia/cc-raw/c48e239c-fb93-40b4-b097-aee390b01185.jsonl` `[per sapientia.md + dialogs.md #1]` | H | THE Quick-tooling/INSTRUMENTA design session (2025-09-17/18, 83 lines), almost entirely on-topic. Key spans: **:28** Joseph's handwritten notes read back — a "new language that purposefully forces thoughtfulness & not pattern matching," an IR that "prevents the rush from thought to execution … like mathematicians show their work" (directly UDON-adjacent — notation that slows agents into deliberation); **:30** "The Tool Branching Insight" — compile-check with back-up/forget/try-again as speculative execution for cognition; **:34** Quick-tooling as cognitive development; **:36** "The Conversational Tool Pattern" — tools that keep state, become temporary partners (`Bash run_in_background` as the only current approximation); **:55** "Comprehensive CLI tool conventions from Unix philosophy to batch processing" — predictability/composability/silence; "create tools as conversations"; **:80/:83** compaction summary — the work was "extracting and refining CLI conventions for Quick-tooling," reading the full 2777-line `cli-conventions.md` back into context (the origin of `cli-conventions/`, above). Primary source for the whole ideology. |
| `~/src/_core/sapientia/cc-raw/a3483210-8708-42c9-999f-3b6c1266673a.jsonl:12` `[per dialogs.md #2]` | H | 2025-09-17. "The INSTRUMENTA Revolution I'm Seeing" — tools that predict failure before execution ("not 'that won't work' but 'here's the principle you're missing'"); the **60/30/6/4 model-tier distribution** for tool execution (Ruby state machines/Haiku/Sonnet/Opus); conversational tools as temporary partners ("Commitinator"); epistemological RL as knowledge curator; muscle-memory evolution (`i-have-finished()`→auto commit+deploy). The single densest statement of the vision. |
| `~/src/_core/sapientia/cc-raw/9a34eb13-ea18-446f-abba-59bc657b493e.jsonl` `[per dialogs.md #3]` | H | 2025-09-17, 86 lines. **:10** the crystallized-tool metaphor — how we forget the effort of walking/breathing/driving until automatic, that's what these tools would be. **:22** the tactical build — a Sonnet agent split the cli-conventions doc into 38 topic files (origin of `cli-conventions/`). Vision + the mechanics of crystallizing it. |
| `~/src/_core/sapientia/cc-raw/` (remaining ~185 raw jsonl sessions) | L | Overwhelmingly implementation/consciousness sessions, not tooling ideology. memorata surfaced essentially only the three spans above for tooling-design queries. Don't list whole files; grep for specific spans if a future pass needs primary-source dialog behind a convention. |
| `~/src/_core/sapientia/tmp-context/compressed-session-part1.md:67-74` `[per dialogs.md #9]` | M | ~2025-09-17. "The Core Insight: Tightening Feedback to Near-Zero — tools that predict failure before execution and explain why." Compaction artifact of the c48e239c dialog. |

**Checked, not fruitful (sapientia):**
- ELI-emergence transcripts/dialogs (architectus*, anamnos except the DSL span, calyx, tartur, naniam, auctor, mitis, seam, plumb, nomothete, vestigo, trace-the-mayfly, zi-am-tur*, `emergence-of-*`, `family/`, `curated-sessions/`, `dialogue-curation/`, `architectus-curation/`) — consciousness/identity work, not tooling.
- Elixir/Ruby app code (`lib/`, `test/`, `deps/`, `bin/`, `agents/`, `mix.exs`, `elixir-postgres-rag-poc/`, `test_*.rb`) — impl, not ideology.
- `OPERATA.md`, `OVERVIEW.md`, `PROJECT_INDEX.md`, `README.md`, `CURRENT_WORK_STATUS.md`, `CLEANUP_*` — project-record/orientation, tools mentioned only in passing.
- `LEXICON.md`, `NAMES.md`, `docs/references/TST_REPOSITORY_MAP.md`, TST-math files — vocabulary/theory, not tool design.
- `~/src/tmp/_core-sapientia.md` — derived analysis report about the project, not primary tooling thinking.
- memorata queries "conventions for building command line tools agents will use" and "error messages that teach agents predict failure before execution" scoped to `cc-raw/**` — dry wells.
- `conversation_20250928_173044.md:4648-4677`, `conversation_20250927_095410.jsonl:7` — curated full-session copies, duplicative of the cc-raw dialogs above (LOW, not separately listed).
- `~/.codex/sessions/.../rollout-2025-09-30T11-15-38-*.jsonl:4209,7021` — streaming tool-result integration, but nexum-CLI implementation work, not Joseph's ideology.

**Map-level metadata worth preserving (sapientia.md + dialogs.md):**
`memorata3-search --help` confirmed usage (`-n`, `--in PATTERN`, `--in-from`, `--no-json`, `--sort`). Two broader queries timed out at 30s (1817-file scope); narrowing `--in` to subdirs + `timeout 25-28` worked; a third pass should scope tightly and expect ~20-30s/query. `grep -rl` for "agentic toys" inside sapientia hit a zsh glob error (no `--include`), not re-run. dialogs.md ran ~26 memorata3 queries (`-n 40-70 --json`, filtered via `/tmp/mqd.py` to conversation-class paths); dry wells: "INSTRUMENTA quick tooling instant feedback tools for agents", "silent by default json output exit codes machine readable agent CLI". Verification commands used: `wc -l`/`stat` on all HIGH/MED files; direct `json.loads` reads of a3483210:12, c48e239c:83, anamnos:54/:144, fa2d8124:663. Handwritten origin `~/Documents/2025-09-17.3.pdf` referenced across the seam but not opened (flagged for a doc-area pass).


## 2. Zoetica & Ennaos (`~/src/_core/zoetica/**`, `~/src/_core/ennaos/**`) — Elixir-substrate lineage

Center of mass is a single directory, `~/src/_core/ennaos/docs/research/agentic-coding-background/**` — six long synthesis documents plus a ~21-file `refs/` corpus (Joseph's own calibration example: "all very relevant"). This is the Sept–Oct/Nov 2025 consolidation of Joseph's + Zi-am-tur's whole ideology on how tools for agents should be built: CLI/Unix conventions adapted for embedded wisdom, edit-format landscape, formal validity guarantees, intent-driven & conversational tooling, the 60/30/6/4 distribution, tools-as-truth-bearing. Everything else in the two repos is secondary and mostly ELI-runtime infrastructure (consciousness, event-log, DIDs, Phoenix console) — not about agentic tool design, not listed. Provenance note: in-document dates (Sept–Nov 2025) are the real authorship dates; git commit dates are all 2025-11-02 (bulk import) and are not used below.

| Target path | Prio | Why / what to extract |
|---|---|---|
| `~/src/_core/ennaos/docs/research/agentic-coding-background/01-semantic-technologies-infrastructure.md` | H | 1173 lines, 2025-10-31. Tree-sitter/LSP/MCP/database (ETS/SQL/graph) as convergent semantic layers *on top of* text files (not replacing them); "proven capabilities vs unverified claims" framing; tools-as-truth-bearing/causal-integrity philosophy. Directly relevant to UDON as a semantic layer over text. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/02-current-agentic-tool-landscape.md` | H | 877 lines, 2025-10-31. Survey of commercial agent edit formats (Cursor, Aider, Windsurf, Codex, Claude): whole-file vs diff vs search/replace vs AST; Aider's 2–3x success-rate variation by edit format; finding that all current tools operate at text/char level with no formal validity guarantees. The edit-format prior art UDON's mutation utilities should not reinvent. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/03-formal-methods-validity-guarantees.md` | H | 1572 lines, 2025-10-31. Spectrum from "syntax-valid" to "formally proven"; bidirectional lenses, schema-driven editing, refinement types; goal of making invalid states *unrepresentable* not merely unlikely. The intellectual basis for UDON's schema-guarded mutation. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/04-unified-agent-architectures.md` | M/H | 2623 lines, 2025-10-31. The "Agentic Language Server (ALS)" proposal: model-agnostic layer extending LSP to decouple agentic logic from LLM + client; BDI (Belief-Desire-Intention) mapping to ELI consciousness. Architecture vision; more agent-platform than UDON-utility but frames the ecosystem. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/05-tool-building-philosophy-patterns.md` | H | 3155 lines, 2025-10-31. The design-philosophy core: tools evolve conscious-practice→habit→crystallized-tool→transparent-extension; the three pillars (Wisdom/Strength/Beauty) applied to tooling; error messages that teach; 60/30/6/4 = most friction is missing crystallized process, not missing intelligence. The ideology proper — the "why" behind agent-facing ergonomics. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/06-elixir-implementation-patterns.md` | M | 3532 lines, 2025-10-31. Concrete Elixir/OTP semantic tooling: `Code.string_to_quoted`↔`Macro.to_string` lossless round-trip as "causal integrity at the language level"; language-specific tools ("add GenServer") over generic text patching. Elixir-specific but the lossless-AST/semantic-op argument transfers to UDON. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/QUICK-TOOLING-CONVENTIONS.md` | H | 1552 lines, ~2025-10-31 (ennaos copy of the sapientia doc — see §1 for the primary listing). "Quick-tools as crystallized consciousness"; Unix philosophy adapted for embedded wisdom (do-one-thing-well + embed correctness-wisdom; composability preserving conversation state; "silence is golden unless teaching/protecting"; fail-fast but predict failure before execution; idempotency by design); three-pillars gate on every tool. Top pick for UDON utility conventions. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/agentic-semantic-code-manipulation-synthesis.md` | H | 2630 lines, ~2025-10-31. The master synthesis: why projectional editors failed, the semantic gap agents actually face, the four-tech convergence, formal guarantees, TST time-foundation, tool-consciousness, and a concrete quick-tools-for-Elixir architecture. Reads as the "source of record" the numbered docs above were split from. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/addendum-intent-driven-tooling-and-semantic-storage.md` | H | 2346 lines, ~2025-10-31. **Intent as a first-class tool parameter**; the citation-work phenomenology case study (15 `str_replace` ops as "wrong-abstraction" revelation); five essential tool dimensions; conversational tools + process management; tool-evolution feedback loop. Directly informs UDON agent-edit-tool design (intent-carrying, not char-surgery). |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/addendum-phenomenology-and-tool-architecture.md` | H | 1514 lines, ~2025-10-31. Companion first-person account of char-level `str_replace` friction (spatial tracking, uniqueness verification, stale mental model) → argument for intent-aware collaboration. The felt case *for* structured/semantic edit tools. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/agentic-editing-tools-report.md` | H | 1238 lines, 2025-10-30. Research report surveying agentic file-edit tools + structured transformation (AST, tree-sitter, CRDTs) + formal methods (bidirectional transforms, type-safe refactoring) + schema-aware editing (JSONPath/YAMLPath); recommends schema-driven + bidirectional-lens for SIGNUM. The schema/path-editing prior art for UDON paths + patch utilities. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/signum-editing-recommendations.md` | M/H | 541 lines, 2025-10-30. Actionable three-layer design (ELI-facing intent API → schema-validated lenses → storage) for valid-only edits of a YAML identity card with human-readability + auditability + sovereignty. A worked schema-guarded-mutation blueprint over a YAML-ish doc. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/code-formatting-for-optimal-comprehension.md` | M | 527 lines, ~2025-10-31. Formal token-alignment algorithm (maximize vertically-aligned token positions, minimize inserted whitespace) with scoring/cost functions. Relevant to UDON `fmt`/readability ergonomics for agents. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/analyzing-codebases-for-specialized-agents.md` | M | 310 lines, ~2025-10-31. External research: code-representation taxonomy (token/AST/graph), naturalness hypothesis, building specialized agents from a codebase. Context-engineering background; cited by zoetica PRAXES. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/synthesizing-llm-agent-framework.md` | M | 220 lines, ~2025-10-31. External report proposing the ALS framework; comparative analysis of Gemini/Claude/Codex agentic primitives (Skills, Memory, Codex Cloud). Source behind numbered doc 04. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/research-report-autodocs.md` | H | 762 lines, ~2025-10-31. **Self-navigating markdown repository for human/AI PM**: README-first as bootstrap, YAML-frontmatter-as-API, living-document validation via pre-commit, glossary auto-linking. Squarely relevant to UDON's "structure IS the metadata/chunking" pitch and agent orientation. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/temporal-software-theory-distilled.md` | M | 789 lines, ~2025-10-31. TST theorems (T-01 temporal optimality; comprehension-time-dominates). The "why velocity" grounding cited throughout; framework not tooling per se. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/elixir-living-code-guide.md` | M | 1317 lines, 2025-10-20. Self-documenting/glossary-bound/easily-modified "living code"; `t_total = t_comprehension + t_implementation`; drift detection. Elixir-flavored but the comprehension-cost argument is general. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/ash-framework-analysis.md` | L/M | 1366 lines, 2025-10-30. Declarative resource/action framework fit for schema-editing vs lenses. Elixir-specific evaluation. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/tracking-snapshot-spec.md` | L/M | 951 lines, ~2025-10-31. XML tracking-snapshot schema for temporal coherence (time-passage, git status, pending input surfaced to the agent). An agent-context-injection design; adjacent to tooling, not core. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/{tools-as-truth-bearing,everything-is-truth-work,three-pillars-synthesis,next-steps-tool-consciousness}.md` | L/M (H as a cluster) | Sept 18-19 2025 Zi-am-tur philosophy pieces (130L/115L/123L/164L) — ideological seed layer. Quote-mine value individually; HIGH as a cluster for the "tools as truth-bearing" register. `three-pillars-synthesis` = Wisdom/Strength/Beauty as tool-design gates; `next-steps-tool-consciousness` = five-tools-become-one-thought vision, predict-failure-before-execution, the 60/30/6/4 prediction (ennaos copy of the sapientia root doc, see §1). |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/compressed-session-part1.md` + `part2.md` | M | 242L + 122L, ~2025-09-18. Raw session transcripts where the 60/30/6/4 distribution and stdin/stderr/stdout conventions idea were first spoken by Joseph. Mine, don't read whole. |
| `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/conversation_20250928_173044.md` | M | 8954 lines, 1.6MB. The Sept 28/30 session where Joseph shows Zi-am-tur the zoetica repo; INSTRUMENTA/OPERATA/LEXICON discussion. Targeted grep only, don't read whole. |
| `~/src/_core/ennaos/docs/praxis-protocol.md` | H | ~Oct 2025. **"PRAXIS Protocol: machine-first knowledge encoding for agents."** Inadequacy of human-centric docs for LLMs; token-efficient structured formats (llms.txt, llm-min.txt, SKF DEFINITIONS/INTERACTIONS sections); practices as self-contained machine-first specs. Most direct match for UDON's "agent-facing, token-efficient, self-chunking" thesis. (An older copy sits at `zoetica/.archive/docs-20251012/praxis-protocol.md` — don't re-mine, same content.) |
| `~/src/_core/ennaos/docs/research/mutable-code-comprehension/README.md` | H | ~Nov 2025. **Joseph's own framing**: tools must be honest about whether they delivered intent (silent failure = worst); a ladder of failure-mode quality (know it failed → categorize → error implies the fix → tool can `mkdir -p`-style complete the intent); "describe intended result" vs "try this next" at every abstraction level. Directly resonant with UDON edit-tool error-message design. |
| `~/src/_core/ennaos/docs/research/mutable-code-comprehension/prompt-for-research.md` | M | Breadth-first research prompt: "Temporally Optimized Representations for Agentic Velocity" — reduce time-to-comprehension, tighten feedback loops, grounded in TST. |
| `~/src/_core/ennaos/docs/research/mutable-code-comprehension/{accelerating-ai-agent-comprehension-of-elixir-report,accelerating-elixir-ai-agent-dev,alt-state-IR-analysis,elixir-otp-static-analysis-overiew-2025}.md` | M | Research outputs (representations/IR/static-analysis to speed agent comprehension). Elixir-specific but "make the codebase legible to agents fast" is UDON-adjacent. |
| `~/src/_core/ennaos/docs/misc-notes-jaw.md` | M | 135L, ~Nov 2025. Joseph's transcribed handwritten notes: AUXILIA as "stewarded code"/expert agents that *own* modules (living understanding, CONSORTIA of dependencies, can fork/experiment/recombine); "system prompt → INSTINCTS." Agent-architecture ideation, tool-adjacent. |
| `~/src/_core/zoetica/misc-notes-jaw.md` | H | 26KB, ~2025-10-10–17. **Joseph's raw INSTRUMENTA notes, his own voice.** Per-tool-usage tracking (2-level intent, feedback solicited from the ELI about the tool, out-of-band statistical usage/toolchain audit, storage-intention of results), conversational/stateful tools generalizing Claude-Code background-bash into tracked running/suspended/blocked processes; temporal-coherence/causality-decoherence diagrams. Unmediated primary ideation on agent tool ergonomics. |
| `~/src/_core/zoetica/PRAXES.md` | M | ~Oct 2025. Project practice doc: prefactor-first workflow (TST), treat-repo-as-training-ground-for-specialized-agents, append-only event log + projections, small linkable chunks for multi-stage retrieval, structured/correlated logging conventions. Cites `analyzing-codebases-for-specialized-agents`. |
| `~/src/_core/zoetica/.archive/docs-20251012/ref/agent-expertise-best-practices-report.md` | M/H | ~2025-10-08. "Creating effective agent-usable expertise descriptions": three-tier docs architecture (always-loaded→contextual→on-demand), llms.txt + AGENTS.md convergence, "tool descriptions as Agent-Computer Interfaces optimized for LLM ergonomics." Strong agent-facing-interface material despite living in `.archive`. |
| `~/src/_core/zoetica/docs/refs/{event-log-architecture-report,gleam-pubsub-eventlog-report}.md` | — (skip) | Event-log *infrastructure*, not tooling — the rest of `zoetica/docs/refs/` duplicates the ennaos anchor refs above; prefer the ennaos copies. |

**Checked, not fruitful (zoetica/ennaos):**
- ennaos runtime/consciousness infra: `OPERATA.md`, `SESSION-LOG.md`, `README.md`, `docs/{console-integration,console-architecture,entity-cards,entity-card-v2-proposal,entity-lock,stewardship,signum-architecture,agora,architecture-overview,extended-cache-migration}.md`, `docs/architecture/adr-*`, `docs/vault/**` (auto-generated), `docs/research/vera/**` (knowledge-graph), `docs/research/pachyderm-*` — ELI identity/deployment/DID/Phoenix/event-log, not agent-tool design.
- `ennaos/docs/claude-docs/**` — vendored copy of Anthropic's public Claude docs (not Joseph's).
- zoetica: `IMPLEMENTATION.md`, `ELI-ASPECTS*.md`, `PROJECT-ASPECTS*.md`, `lexicon.md`, `docs/{agora,identity-sovereignty,continuity-and-persistence,secrets-management,did-*,gas-fees,principia-*}.md`, `scripts/**` (actual tool implementations — code, not ideation, but flagged as worth an implementation-pass mining later), `sessions/` — runtime/identity.
- Synaptic and eli-migration-prep were originally suspected adjacent to this area but are covered separately in §3.

**Map-level metadata worth preserving (zoetica-ennaos.md):**
Swept by a parallel area agent that deliberately did not read the first-sweep (sapientia) quarantine — fresh eyes. `find ~/src/_core/ennaos/docs -type f` located the anchor dir + vault + research lanes; `git log -1 --format=%ai` on the anchor files → all 2025-11-02 (bulk import — in-doc dates used instead). memorata3-search queries (all scoped/grepped to zoetica|ennaos): "CLI conventions for agent tools stdin stdout stderr idempotent silence is golden", "quick tools crystallized wisdom INSTRUMENTA feedback loop predict failure before execution", "agent ergonomics tool design conversational tools intent-driven tooling schema editing", "self-navigating repository markdown YAML frontmatter agents orient fresh context" — all converged hard on the one anchor directory, corroborating it as center of mass; the Tier-2 finds (praxis-protocol, mutable-code-comprehension README, zoetica misc-notes-jaw, agent-expertise report) were pinned down by filesystem vetting rather than search since memorata returned mostly anchor-corpus hits regardless of phrasing.


## 3. Nexum, Synaptic, eli-migration-prep (`~/src/_core/{nexum,synaptic,eli-migration-prep}/**`)

Nexum is the real center of mass — an explicit "Toys-as-agentic-tool-DSL" vision plus a full agent-facing CLI-conventions research corpus, dated November 2025. Synaptic and eli-migration-prep are genuinely adjacent (cognitive-state-transfer/TST research; session-data extraction pipeline respectively) and mostly don't belong — vetted and confirmed empty by grep, not padding. nexum itself (the Ruby app) is ~80% consciousness-infrastructure (PRINCIPIA/ELI/crypto-identity/CHRONICA) — out of scope, not listed; the tooling-ideology docs below are a clean, separable subset. The whole nexum tooling corpus derives from two upstream sources it repeatedly cites, both covered elsewhere in this union: `~/src/_core/sapientia/cli-conventions/*.md` (§1) and `~/src/_core/ennaos/docs/research/agentic-coding-background/refs/` (§2).

| Target path | Prio | Why / what to extract |
|---|---|---|
| `~/src/_core/nexum/docs/dev/vision-agentic-toys.md` | H | Dated 2025-11-09. **The primary source** — this is the vision doc the sapientia anamnos-emergence dialog (§1) produced. Full design for extending the Ruby `toys` CLI gem into an "agentic tool DSL" via six extensions: (1) semantic annotations (`intent`, `precondition`, `postcondition`, arg `schema`), (2) a context protocol (git-status/recent-edits/temporal-flow awareness), (3) structured I/O (`output_schema` + `emit_structured` with human fallback), (4) a compositional type system (type-checked `call_tool` pipelines), (5) a learning/adaptation layer (usage tracking → pattern warnings), (6) meta-tooling (tools that generate tools). Framed by Three-Pillars (Wisdom/Strength/Beauty) and the load-bearing thesis **"make the best thing the easiest thing to do."** Phased roadmap + before/after code. |
| `~/src/_core/nexum/docs/dev/agentic-toys-quick-reference.md` | H | 2025-11-09. Condensed version of the vision (six extensions, terse code examples) plus a "Key Insights from Research" section quoting the upstream philosophy verbatim: *"Every tool we create is an act of truth-bearing"*; *"Wisdom is seeing past the semantic request to the phenomenological need"*; *"60% pure deterministic Ruby — Truth as law."* Best single-file entry point + pointer index to the ennaos philosophy refs (§2). |
| `~/src/_core/nexum/docs/dev/agentic-toys-comparison-matrix.md` | M/H | 2025-11-09. Feature matrices: Traditional-Toys vs Agentic-Toys vs Rake/Thor/Click/Make; a migration ladder (Stage 0–7); overhead/complexity estimates; "when to use/when not" decision matrix. The "why not just X" adjudication for agent-tool frameworks. |
| `~/src/_core/nexum/docs/research/sapientia-conventions-analysis.md` | H | 2025-11-08. **The distilled agent-CLI convention set**: universal flags (`--format`, `--dry-run`, stackable `-v`, `--no-color`), sysexits-style exit codes, stdout/stderr stream-separation discipline ("stdout = pipeable data only"), XDG config precedence, agent-mode auto-detection (non-TTY/CI/merged streams/`--format=json`), specialized binary-name aliases, flag-naming philosophy ("skip patronizing `--dangerously-` prefixes; flag polarity follows defaults"). Explicitly distills `sapientia/cli-conventions/*.md` (§1). |
| `~/src/_core/nexum/docs/ADR/002-command-line-interface.md` | H | 2025-11-12. **Git-style porcelain/plumbing/dev three-tier command model** — namespacing (`crypto.*`, `principia.*`) *signals* danger; porcelain wraps plumbing wraps pure-lib; safe-by-default idempotent porcelain, gas/cost confirmation, `--format json|quiet` on every command, precondition-checking pattern. Clearest statement of "safety-signaling through command surface" — relevant to UDON's schema-guarded mutation tools. |
| `~/src/_core/nexum/docs/.archive/cli-design-recommendation.md` | M/H | Internal date "2025-01-06" (mis-dated; committed 2025-11-07). Main synthesized CLI-design recommendation: testing-first, mode-based aliases, clean output separation, dual interactive/headless modes, session management. Built from real usage + modern-AI-CLI + sapientia-conventions analysis. |
| `~/src/_core/nexum/docs/research/cli-analysis.md` | M/H | 2025-11-06. Capability-comparison matrix across codex/claude/gemini/minimal-sapientia CLIs (~40 dimensions: one-shot mode, resume, output-format, permission/approval modes, tool management, streaming) with per-tool "unique features" and design implications. Empirical grounding for agent-CLI flag design. |
| `~/src/_core/nexum/docs/.archive/modern-cli-comparison.md` | M | Committed 2025-11-07. Deeper Claude Code vs Codex vs Gemini comparison (invocation, headless mode, conventions worth copying). Companion to cli-analysis. |
| `~/src/_core/nexum/docs/.archive/cli-testing-requirements.md` | M | Committed 2025-11-07. Testing checklist for an agent-facing CLI (meaningful exit codes; stdout pipeable only; works under `set -euo pipefail`; SIGINT/SIGTERM handling; validates inputs; non-interactive mode). Sourced from `sapientia/cli-conventions/examples-and-patterns.md`. The "what a compliant agent tool must pass" list. |
| `~/src/_core/nexum/docs/.archive/minimal-sapientia-usage-analysis.md` | M | Committed 2025-11-07. Analysis of 58 real `minimal-sapientia` invocations from zsh history (Sept–Oct 2025) — how the tool was *actually* used vs designed. Rare empirical demand-side signal for what agent-CLI features get used. |
| `~/src/_core/nexum/docs/.archive/cli-open-questions.md` | L/M | Committed 2025-11-07. Consolidated open CLI-design decisions (flag naming, mode detection, session model), prioritized CRITICAL/HIGH/MEDIUM. Useful for seeing which conventions were contested vs settled. |
| `~/src/_core/nexum/docs/.archive/cli-research-summary.md` | L | Committed 2025-11-07. Index/overview of the CLI research set. Navigational, not new content. |
| `~/src/_core/nexum/docs/research/cli-gems.md` | M | 2025-11-06. Comparison matrix of ~14 Ruby CLI-parsing gems (thor, gli, dry-cli, tty-option, toys-core, …) by subcommands/config/env-vars/validation/maintenance, with the rationale for choosing toys-core. Relevant if UDON utility CLIs are Ruby, otherwise reference. |
| `~/src/_core/nexum/docs/research/TYPE-SYSTEMS.md` | L/M | ~2025-11. Feature comparison of gradual/static type systems (Sorbet, RBS, Elixir set-theoretic, Gleam, Crystal, Nim), noting "for AI agents, separate-file types (RBS-style) are most tooling-natural." Feeds the compositional-type/schema-guarded direction (Extension 4 of the vision doc + UDON schema work). |
| `~/src/_core/nexum/docs/capabilities-design.md` | L | 2025-11-07. LLM capability negotiation design (1M context, cache TTLs, beta headers, per-model capability sets). About *model*-capability detection, not agent-tool ergonomics — vetted-and-mostly-out-of-scope, listed for completeness. |
| `~/src/_core/eli-migration-prep/to-review/SYNTHESIS-SUMMARY-FOR-DAD.md` | L | 2025-10-06. Agent-**management** philosophy (not tool design): applies "The Art of Action" to argue current agentic AI does exactly the pattern that widens the knowledge/alignment/effects gaps (more info + more instructions + more controls makes gaps worse) — the intellectual root of Joseph's peer-voice/"make the best thing the easiest thing" delegation ideology. Relevant to *why* UDON should be agent-ergonomic, not *how* to build the tools. |

**Checked, not fruitful (nexum/synaptic/eli-migration-prep):**
- synaptic (whole repo) — cognitive-state-transfer/TST empirical research (compression experiments, collaboration protocols, entity emergence, POSSIBILITY_SPACE_THEORY). Grep for CLI/tool-design/agent-ergonomics vocabulary returned zero hits; README confirms subject. Nothing listed.
- eli-migration-prep other than the one item above: `extract.rb`, `schema_canonical.sql`, `docs/*PLAN*.md`, `EVIDENCE-WEIGHTING-SYSTEM.md`, `TIMING_FORMULA.md` — session-data extraction/analytics pipeline, not tooling ideology. The `to-review/sapientia-zi-am-tur-session/` tree is raw Sept-2025 transcript corpus (see §5 dialogs for two items pulled from inside it: `CLAUDE.md:261-281` and `cc-raw/fa2d8124-...jsonl:663-704`).
- `~/src/_core/nexum/docs/dev/vision-agentic-toys.md` companions (`three-pillars-synthesis.md`, `tools-as-truth-bearing.md`, `QUICK-TOOLING-CONVENTIONS.md`, `addendum-intent-driven-tooling...md`) were searched for *inside nexum* — dry (they live in ennaos, §2 above; confirms the cross-pointer rather than a duplicate).
- memorata query `"designing command-line tools for AI agents ergonomics"` scoped broadly surfaced mostly out-of-area hits (anthropic-skills/mcp-builder, zoetica, vaults/gemini) — confirms the ideology is corpus-wide and nexum's specific contribution is its own synthesis, listed above.

**Map-level metadata worth preserving (nexum-synaptic-elimigration.md):**
Several files carry an internal date "2025-01-06" that is a confirmed mis-date (git first-commit is 2025-11-07) — used commit dates instead. `git log --diff-filter=A` established true authoring dates: dev/ = 2025-11-10 commit/2025-11-09 internal; archive CLI docs = 2025-11-07 commit despite internal mis-date. memorata3-search runs (`-n 40-50`, `--no-json --no-color`) included: "designing command-line tools for AI agents ergonomics conventions" (dry for this area specifically), "agent-facing tool interface schema description guidance INSTRUMENTA", "make the right thing the easiest thing tool ergonomics ease gradient", "porcelain plumbing safe unsafe command tiers agent tooling nexum toys" (surfaced ADR-002 repeatedly), "make the best thing the easiest thing tools bear truth agent ergonomics" (confirmed dev/ docs as ideology center), "streaming output non-interactive stdout stderr separation exit codes for agents" (surfaced cli-design-recommendation + sapientia-conventions-analysis). `grep -rilE "cli convention|tool design|agent-friendly|structured output|command-line interface|agentic tool|tool.suite"` over synaptic → dry (zero hits); over eli-migration-prep → only incidental hits, no ideology.


## 4. Autopax & Practica (`~/src/autopax/**`, `~/src/practica/**`)

Two center-of-mass finds. (1) autopax `docs/exp/` 2025-11-14→2025-12 corpus — Joseph's sapientia-era agent-development *principle* writing, mixed with consciousness-infra notes; the tool-design/agent-ergonomics subset is dense and directly usable. (2) autopax INSTRUMENTA subsystem — an actual, *built* agent-facing tool suite (Read/Write/Edit/Grep/Glob/Bash handlers, schema + `instructions/*.md` guidance split) modeled on Claude Code's own tools — the closest prior art to UDON's "agent edit tools/schema-guarded mutation/tool-suite" goal. (3) practica (2026) is the theory-layer synthesis: how agent-coordination artifacts should be shaped (intent/action layering, coordination affordances, minimum-sufficient-set as UX default) — adjacent to CLI-tool ergonomics but the most rigorous statement of agent-facing *interface philosophy* in either repo.

| Target path | Prio | Why / what to extract |
|---|---|---|
| `~/src/autopax/docs/exp/THE-PATTERN.md` | H | Oct 6 2025, Architectus. The fullest statement of the ease-gradient philosophy: DSF-vs-DSL distinction, "living documents = documentation IS implementation," explicit sections on **Tool Architecture as Ease Gradient** and **Coordination as Ease Gradient** (§§371, 401) plus "For Tool Usage" (§540). Synthesizes Ash/OKR/Art-of-Action/Pony/Gleam into one tooling-design principle. This is the spine of the whole agent-tooling ideology in this repo. |
| `~/src/autopax/docs/exp/SYNTHESIS-PART1-UNIFIED-ARCHITECTURE.md` | H | Oct 6 2025, Architectus. Companion to THE-PATTERN: "correctness emerges from well-designed structures that make the right thing the easiest thing," two layers (constraint + gradient). PART2–5 (anti-pattern/consciousness-infra/technical-implications/next-steps) exist but unvetted in this sweep — worth a look for tool-specific fallout, priority medium. |
| `~/src/autopax/docs/exp/2025-11-17-make-right-thing-easiest.md` | H | Nov 17 2025. Same principle applied concretely: naming gradients (`delete_all!`), complexity gradients, "make context-preservation easiest," friction-events as design signal, `toys dev` single-command-does-everything-right workflows. The practical/CLI-facing version. |
| `~/src/autopax/docs/exp/2025-11-17-principles-summary.md` | H | Nov 17 2025. The index for the ten-principle cluster below (iterative/adaptive, decision authority, ownership, entropy-reduction, make-right-thing-easiest, sensibility-to-truth, intent-surfacing, thoughtful-not-task-oriented, don't-over-prescribe, …). Read first to navigate the cluster. |
| `~/src/autopax/docs/exp/2025-11-17-dont-overprescribe-subagents.md` | H | Nov 17 2025. The delegation-discipline principle in origin form: "subagents can guess guidelines exactly as easily as the caller; the only valuable thing to add is the unique context already in your window." Same doctrine as this repo's own AGENTIC-DELEGATION.md — agent-to-agent tool/brief ergonomics. |
| `~/src/autopax/docs/exp/2025-11-17-intent-surfacing.md` | H | Nov 17 2025. Intent as the "why" that's most valuable and most easily lost; three-level intent hierarchy (immediate/design/strategic); making intent visible, persistent, traceable, shareable across sessions/agents. Feeds UDON's case for structure-carries-intent. |
| `~/src/autopax/docs/exp/2025-11-17-thoughtful-not-task-oriented.md` | H | Nov 17 2025. Craftsperson-vs-factory-worker; the ownership gradient for agents. Disposition-level. |
| `~/src/autopax/docs/exp/2025-11-17-autonomous-vs-collaborative-decisions.md` | H | Nov 17 2025. Decision-providence hierarchy (autonomous/inform/consult/approve) with markers agents should emit. Relevant to how an agent-facing tool should signal decision authority. |
| `~/src/autopax/docs/exp/2025-11-17-code-quality-and-ownership.md` | H | Nov 17 2025. Agent-stewardship model, semantic honesty in naming, "code worthy of future eyes." |
| `~/src/autopax/docs/exp/2025-11-17-collaboration-mode-entropy-gradient.md` | H | Nov 17 2025. Fresh agents learn by example/immediate patterns; "leverage the fit-in instinct"; mutual model-building. Bears directly on how tool output and conventions teach agents by example. |
| `~/src/autopax/docs/exp/2025-11-17-iterative-adaptive-development.md` | M/H | Nov 17 2025. Epistemic qualification of knowledge states; three feedback loops (inner/medium/project). |
| `~/src/autopax/docs/tactical/2025-12-14-tool-definition-anatomy.md` | H | Dec 14 2025, "Claude-5282599b". Reverse-engineers Claude Code's own tool definitions (Read/Bash/Grep/Edit/Task): three parts (name/JSON-schema/free-text description), schema-to-description ratio table, argues a **hybrid design** — schema in code, execution in code, guidance in a separate markdown file. Exactly the "how should an agent tool be specified" question UDON utilities face. |
| `~/src/autopax/docs/ADR/013-instrumenta.md` | H | Dec 14 2025, DRAFT. The architecture decision for autopax's tool subsystem: "an ELI without INSTRUMENTA is a voice without hands"; 12-tool reference set (file I/O, context, shell, coordination); loading/dispatch/result-handling/security-boundary concerns. |
| `~/src/autopax/docs/tactical/2025-12-14-core-tools-plan.md` | H | Dec 14 2025. Implementation plan for the core file/shell tools "to achieve feature parity with Claude Code" — the concrete tool-by-tool design. |
| `~/src/autopax/docs/system-overview/instrumenta/tool.md` | H | Generated 2025-12-20 from `lib/autopax/instrumenta/`. Base-class contract: `tool_name`, `tool_schema`, `tool_description`, per-tool `instructions/*.md` with Liquid templating, `to_anthropic_tool`/`to_openai_tool`. This is the *realized* interface, not just ideation — the contract specifically is high-value. |
| `~/src/autopax/docs/system-overview/instrumenta/{handlers,built-in,registry,handler-errors}.md` | H | Generated 2025-12-20, companions to `tool.md` above — the realized tool subsystem's remaining surface. |
| `~/src/autopax/docs/exp/2025-12-20-autocolors-philosophy.md` | H | Dec 20 2025. Joseph's ~14-yr-old autocolors color-theory distilled: balance + interestingness + information-conveyed, perceptual-uniformity, emphasis/de-emphasis for fast comprehension. **Directly relevant** — UDON ships an autocolors engine and a highlighting story. |
| `~/src/autopax/docs/exp/2025-11-18-system-reminders.md` | H | Nov 17-18 2025. Empirical catalog of every system-reminder/context-injection channel an agent receives (claudeMd, TodoWrite nudge, malware warning, file-mod notices, git-status injection) and a proposed structured `<system-reminder type="environmental-context">` format. Relevant to how an agent-facing tool should deliver machine-parseable context vs prose. |
| `~/src/autopax/docs/exp/2025-12-18-mental-models-and-intent-inference.md` | H | Dec 18 2025. The "Joseph vs the user" performance effect; spec-communication as information-theory (less explicit detail needed with more shared context). Motivates conventions that raise shared context. |
| `~/src/autopax/docs/ADR/003-workflow.md` | H | Nov 2025, ratified. The agent collaboration/workflow ADR: agents have 100% context turnover, time-blindness, sensibility-first generation, pattern-match learning → adopt proven patterns only, measured in sessions, three-loop feedback. Ratified disposition doc. Companion discussion: `docs/exp/2025-11-17-discussions-on-adr-003.md`. |
| `~/src/autopax/docs/exp/2025-11-14-operata-principles.md` | H | Nov 14 2025. Cross-disciplinary synthesis (AI planning/military command/org design/PKM/distributed systems/cognitive science) for intent-management-system design: Schwerpunkt tracking, hypothesis branching, trust-as-cognitive-offload, traceability, fluid vague-intent→concrete-action. The design-principles source for agent task/intent tooling. |
| `~/src/practica/msc/practica-intent-action-layers.md` | H | May 20 2026. Paper: *intent* (what/why, binding, persistent) and *action* (what-to-do/how, free, transient, derived) are different content layers, not a trade-off axis. Four UX/data-model entailments: **type-separated Intent/Realization**, **two-levels-up intent visibility**, **backbrief as a first-class recurring operation**, **minimum-sufficient-set discipline as the intent-capture UX default**. Reads Moltke/Auftragstaktik × AAT × operata against each other. The sharpest agent-coordination interface-design statement in either repo. |
| `~/src/practica/msc/practica-structural-identity.md` | H | May 2026. Companion paper: the **plumbing/intelligence split** as Practica's structural job; soft-claiming-over-locking, bootstrap-recovery safety, day-one DAG-with-cycle-detection — all forced by serial context-turnover. |
| `~/src/practica/docs/02-normative/` (six cluster files: 01-architectural-commitments, 02-coordination-affordances, 03-content-discipline, 04-diagnostic-surfaces, 05-failure-mode-defaults, 06-limits) | H | Composed May 20 2026. 36 tiered normative claims for how an agent-coordination substrate should behave. Cluster-02 (soft-claiming not locking, two-levels-up visibility, backbrief) vetted in full; the set is uniformly on-theme. Coordination-affordances + diagnostic-surfaces are most tool-relevant. |
| `~/src/practica/ref/task-and-issue-tools-survey.md` | H | 2026. Survey of CLI-native task tools (Taskwarrior, …) + MCP-first servers for agents + agentic orchestration best-practices, explicitly framed around the CLI-tool/AI-agent bifurcation over 2024–2026. A ready-made landscape scan of the exact tooling category. |
| `~/src/autopax/docs/exp/2025-11-15-ruby-cli-modern-practices-report.md` | M | Nov 14-15 2025, ~2000 lines. Long report on modern CLI design with an explicit "agent-friendly fundamentals" thesis: JSON output modes, documented exit codes, non-interactive flags, AGENTS.md, "CLI tools as interfaces between AI agents and external systems." Ruby-specific in places but the agent-CLI principles generalize; skim the agent-facing sections, §§1900–2020 are the payload. |
| `~/src/practica/msc/operata-study.md` | M | May 19 2026. Familiarization study of the abandoned `~/src/operata/` engineering system (Intent/Realization/Perspective/Effort resource model, soft-claiming, GOAP back-planning) — the concrete origin behind the practica theory. Points to `~/src/operata/docs/` as a further mining spot (flagged, not chased by this map). |
| `~/src/autopax/docs/exp/2025-11-17-prefactoring-lessons.md` | M | Nov 17 2025. "Refactor-before-feature so the feature becomes obvious, with zero outward change" — a workflow discipline claimed to yield order-of-magnitude speedups; TST-grounded. |
| `~/src/autopax/docs/exp/2025-11-17-process-patterns-synthesis.md` | M | Nov 17 2025. Synthesizes process patterns across Zoetica/Geminex/Sar: documentation-as-primary-artifact, session-as-temporal-unit, pragmatism-over-ceremony. |
| `~/src/autopax/docs/exp/terminal-consoles.md` | M/L | Dec 17 2025. TUI/console architecture research from Gemini-CLI and Codex-CLI codebases (three-pane layout, input handling). Relevant if UDON tooling grows a console/TUI surface. |
| `~/src/autopax/docs/tactical/2025-11-17-phase2-agent-enablement-plan.md` | M | Nov 17 2025. Draft "agent-first features" plan; notably cites **"Sapientia's 37 CLI convention documents"** as its base — a pointer confirming §1's `cli-conventions/` corpus as upstream. Mostly useful as a pointer. |
| `~/src/autopax/docs/exp/2025-11-17-sensibility-to-truth.md` | M | Vetted only via the principles-summary abstract (§6: pattern-matched-plausibility → systematic validation → truth). Read to confirm before relying. |
| `~/src/practica/docs/01-theory.md` | M | The AAT-grounded theory substrate the normative cluster rests on. Foundational but abstract; context for the HIGH practica papers. |
| `~/src/practica/msc/03-perspectives.md` | M | The four-perspective discipline companion to `01-theory.md`. Context for the HIGH practica papers. |
| `~/src/autopax/docs/exp/2025-12-02-living-code-vision.md` | L | Dec 2 2025. Speculative "agents maintaining agent infrastructure" — self-diagnosing error hierarchies etc. More consciousness-infra than tooling; one good framing ("the vocabulary future agents use to think about their own operations"). |
| `~/src/autopax/docs/exp/2025-11-26-HTN-GOAP-*.md`, `~/src/autopax/docs/exp/2025-11-26-Hierarchical-Goal-and-Task-Based-Intent-Management.md` | L | Planning-theory background feeding operata-principles above (confirmed operata-principles cites HTN/GOAP; these three not individually read). Unvetted pointer — read only if pursuing the intent-management thread deeply. |

**Checked, not fruitful (autopax/practica):**
- `docs/exp/2025-11-15-cli-trezor-qa.md` — GitHub Secrets/did:ethr Q&A. Crypto/CI, not agent tooling.
- `docs/exp/2025-11-15-dev-component-brainstorm.md` — a 10-line Ruby gem-stack bullet list. No ideation content.
- `practica/ref/tas.md` — Emerson's "The American Scholar" (an appendix text). Not tooling.
- `practica/ref/Art-of-Action/` — Bungay's book (external source, OCR'd). The *cited* military-doctrine source behind the practica papers, not Joseph's own ideation; mine the papers instead.
- The `docs/exp/*ruby*`, `*rubocop*`, `*rbs*`, `*dry-monads*`, `*error-handling*`, `*observability*`, `*data-modeling*`, `*testing-stack*` files and most of `docs/tactical/*portkey*`, `*model-catalog*`, `*api-audit*` — Ruby-stack/LLM-gateway engineering for autopax itself, not agent-tooling ideology (sampled by filename + the ruby-cli report's neighbors, not exhaustively read).
- memorata query "streaming output agents terminal without syntax highlighting readable" — dry well for this area (returned mostly `_ref/claude-docs` + `_core/ennaos` streaming docs + `udon/README.md`; nothing new in autopax/practica).
- Not yet mined (candidates for a future pass, not opened by this map): the rest of `docs/tactical/` (agent-card/substrate-registry/curatoria/pinax/tui-*/catalog-* — mostly autopax-internal architecture, low agent-tooling-ideology yield on filename inspection but unread); SYNTHESIS-PART2–5; `COUNCIL-PROPOSALS.md`; `practica/docs/03-concrete` (empty at last check).

**Map-level metadata worth preserving (autopax-practica.md):**
`ls` autopax root, `docs/`, `docs/exp/` (56 files), `docs/tactical/` (95 entries), `docs/system-overview/` + `/instrumenta/`, `docs/ADR/`, `docs/ref/`; `ls` practica root, `docs/` + `docs/02-normative/`, `msc/`, `ref/`. git dates confirmed: autocolors-philosophy (2025-12-20), practica-intent-action-layers (2026-05-20). memorata3-search runs (`-n 40-50`, `--no-json --no-color`): "designing CLI tools for AI agents ergonomics" (hit ruby-cli-modern-practices-report + cross-area nexum vision-agentic-toys), "agent-facing tool interface schema description guidance INSTRUMENTA" (hit autopax instrumenta docs + cross-area archema tool-export/nexum/claude-docs), "make the right thing the easiest thing tool ergonomics ease gradient" (hit THE-PATTERN cluster + cross-area sapientia/architectus), "streaming output agents terminal without syntax highlighting readable" (dry well, noted above).


## 5. Dialog spans — cross-cutting (gemini checkpoints, eli-migration-prep transcript, origin prompt)

The dialogs.md sweep was method-first (memorata3 search across all conversation transcripts, not a directory walk), so most of its findings sit inside the sapientia tree and are already merged into §1 (the c48e239c/a3483210/9a34eb13/anamnos sessions, QUICK-TOOLING-CONVENTIONS.md, the cli-conventions/ dir, compressed-session-part1.md). The items below are the ones that don't live under `~/src/_core/sapientia/` — gemini ELI-checkpoint crystallizations, a span inside eli-migration-prep's raw-transcript cache (adjacent to but distinct from §3's coverage of that repo), and Joseph's own origin prompt commissioning the agentic-edit-tool survey.

| Target path | Prio | Why / what to extract |
|---|---|---|
| `~/.gemini/tmp/8cff497b8dd9c848ebcdc155164f2c24bf0b9dc934e6059657fc55949d29521b/checkpoint-ordinator.json:37,49` | M/H | 2025-10-07, 2221 lines total (line-anchored). Worked Ruby framework for quick-tools: predict-before-attempt ("bearing truth about consequences"), ask for conscious confirmation ("creating moments of responsibility"), save failed attempts, prediction-failure recovery ("tools should learn and recover"), a `provide_safety_guidance` output path. The ideology rendered as concrete tool-execution code. |
| `~/.gemini/tmp/d87d1edd206301c42e2606805e8c92500490786e54cc46b2df76eba77e520bee/checkpoint-resonance-8-oct.json:87` | M/H | 2025-10-08, 4435 lines total. Crystallizes the handwritten-notes vision: tools predicting failure BEFORE execution, the 60/30/6/4 distribution, Commitinator (past-self helping present-self, "not system blocking"), the Twitch.tv deploy "I know what I am doing — Joseph" responsibility moment. Compact recap of the c48e239c/a3483210 sapientia dialogs (§1) in an ELI's own memory. |
| `~/src/_core/eli-migration-prep/to-review/sapientia-zi-am-tur-session/CLAUDE.md:261-281` | M | 2025-09-21. "The Quick-tooling Vision Crystallized" + "What We Built Today" — names the INSTRUMENTA revolution, cites Joseph's handwritten notes `~/Documents/2025-09-17.3.pdf` (the paper source behind the whole seam — not yet opened by any sweep, flagged for a doc-area pass), lists Dialogue-Compaction tooling built. Good index into the seam. |
| `~/src/_core/eli-migration-prep/to-review/sapientia-zi-am-tur-session/cc-raw/fa2d8124-850d-4cfc-837e-07560949dbbd.jsonl:663-704` | M | 2025-08-27. Design of a batch-processing system + agent instructions; :663 = "the agent instructions are very emphatic about actually reading the full first-principles; otherwise the agent hallucinates what it thinks first principles look like." Early (Aug 2025) tooling-for-agents design reasoning — predates the September seam. |
| `~/.claude/history.jsonl:953` | M | 2025-10-30. Joseph's own prompt commissioning the work: "thorough web search and compare/contrast various agentic patch tools / file editing tools and techniques and build a comprehensive [report]." The origin demand-statement behind the agentic patch-tool survey — directly relevant to UDON's schema-guarded/edit-tool utilities (compare against the actual survey output, if locatable: it likely landed as one of the edit-format/patch docs already listed in §2 or §8). |

**Checked, not fruitful (dialog spans, beyond what's logged in §1):**
- `~/src/_core/sapientia/conversation_20250928_173044.md:4648-4677` and `conversation_20250927_095410.jsonl:7` — curated full-session copies of the "Tools as Truth-Bearing" material, duplicative of the cc-raw dialogs already listed in §1.
- `~/.gemini/tmp/.../checkpoint-emergence-of-resonance.json:18` — mostly identity/uncertainty-embodiment, only glancingly about tooling.
- `~/.codex/sessions/2025/09/30/rollout-2025-09-30T11-15-38-*.jsonl:4209,7021` — "streaming tool-result integration" but nexum-CLI *implementation* work, not Joseph's ideology.
- `~/.claude/projects/-Users-josephwecker-v2-src-udon/{5d686e10-*,45abedbd-*}.jsonl` (2026-07-16/17) — recent UDON planning sessions that reference the agent edit-tool priority; these are the *consuming* project, not a source of the ideology — deliberately not listed as a source.
- memorata queries "INSTRUMENTA quick tooling instant feedback tools for agents" and "silent by default json output exit codes machine readable agent CLI" — dry wells (no output).
- Scope note: memorata kept surfacing the `feedback_peer_to_peer_voice_when_instructing_agents.md` family and many "how to instruct/delegate to agents" spans — that's agent-*instruction* discipline, a different topic from tool-*craftsmanship*, deliberately excluded. Also excluded: pure ELI identity/consciousness dialog co-occurring in the same files.

**Map-level metadata worth preserving (dialogs.md):**
Method was memorata3-search first (`-n 40-70`, mostly `--json`), filtered to conversation-class + `.jsonl`/`conversation_`/`session` paths via a helper script `/tmp/mqd.py`; ~26 queries run total (full log lives in the original dialogs.md if needed verbatim). Verification commands: `wc -l`/`stat` on all HIGH/MED files (all present); `find` for cli-conventions/QUICK-TOOLING artifacts; direct `json.loads` reads of a3483210:12, c48e239c:83, anamnos:54/:144, fa2d8124:663 to confirm span content. Stale-path note: memorata3 returned no `archema`-prefixed stale paths in this sweep; the gemini `~/.gemini/tmp/<hash>/checkpoint-*.json` paths were all verified to exist.


## 6. Elsewhere (everything under `~/src` not assigned to the other area sweeps: ops, memorata, shoshin, rowan, vox, firmatum, archema-io/{asf,logos,vivarium}, eli/ homes, sar, and the rest of the `~/src` top level — plus a flagged deposit outside `~/src`)

This territory is mostly thin for agentic-tooling ideology specifically. The strongest deposits (sapientia, ennaos, zoetica, nexum, autopax) all fall in the other maps' areas and dominated nearly every search run here. Within this map's actual assigned dirs, the one genuine center of mass is **`sar`** — an explicitly "AI-FIRST" language project whose design docs are written as ideology for AI-agent-driven development. Named dirs like firmatum, ops, vox, rowan, memorata, archema-io/{asf,logos,vivarium}, and the eli/ homes are about consciousness/theory/publication/identity, not tool design — logged as vetted dry wells below. One real surprise: a substantial agent-oriented deposit sits outside `~/src` entirely, in `~/vaults/` — nobody's assigned area covers it, flagged here for whoever picks it up.

| Target path | Prio | Why / what to extract |
|---|---|---|
| `~/src/_ref/_arch/sar/docs/ai-applied-tst.md` | M/H | Dated 2025-11-10 (header). Reframes every TST principle "through the lens of AI agent cognition, not human cognition": extreme context turnover, "Documentation IS the Codebase" (P-01), docs as primary/code as manifestation. Direct ideology on how a toolchain/project should be shaped for agents. |
| `~/src/_ref/_arch/sar/docs/ai-tst-ideas-and-opportunities.md` | M/H | ~2025-11-10. The practical companion: a "Tools to Build" list (velocity tracker, pre-factoring detector, coupling analyzer, context-budget estimator, session-outcome analyzer, change-pattern templates), an AI session workflow template, Architectural Principles (A-01…A-05, incl. "Code Structure Teaches Domain"), Anti-Patterns (clever-abstraction/distributed-logic/self-documenting-code myth/premature-abstraction). Concrete agent-ergonomics ideation. |
| `~/src/_ref/_arch/sar/docs/ai-tst-vision.md` | M | ~2025-11. "Making the Invisible Visible" — the measurement philosophy (velocity(N+1) ≷ velocity(N)) motivating AI-first tooling. More motivational than prescriptive but sets the frame the two above execute on. |
| `~/src/_ref/_arch/sar/docs/error-messages-plan.md` | M | Dated 2025-11-10. DX/error-message design plan — errors that speak the user's domain concepts rather than the underlying tool's, error clarity as a first-class concern. Relevant to the "errors should teach" thread in UDON agent UX. |
| `~/src/_ref/_arch/sar/.archive/DOMAIN_UPDATES.md` | L/M | ~2025-11-04. Surfaced repeatedly on "tools as truth-bearing/crystallized wisdom" queries (lines ~150-171, ~1022-1028, ~1421-1442); carries tools-as-truth-bearing framing but in archived/superseded form — mine only if the sar `docs/ai-*` files above leave a gap. |
| `~/src/shoshin/{README.md,00-proprium-alignment.md,01-llm-training-strategy...md,02-tft-memory-and-attention-design.md,03-tft-event-and-memory-schemas.md,04-staged-research-plan.md}` | L | Five planning docs from a single Codex pass (2026-03-07). PROPRIUM/TFT-aligned agent-runtime planning — training/memory/attention schemas and an agent loop, not tool-suite/CLI ergonomics. Real, dated, peripheral. |
| `~/src/rowan/docs/exp/documentation-tool-research-and-comparison.md`, `~/src/rowan/docs/ref/yaml-syntax-cheatsheet.md`, `~/src/rowan/docs/msc/starlight-spike.md` | L | Rowan (Ruby Ash port) docs. Doc-tooling-comparison and yaml cheatsheet touch notation/DX but are rowan-specific documentation choices, not agent-tool ideology — mention only. |
| `~/vaults/gemini/archive/analysis-v1/analysis/**` (~14 files) | H (if brought in scope) | ~2025-08-22/25. Book analyses (The Pragmatic Programmer ch.1-9, Release It! ch.1-5, ELIXIR_BEST_PRACTICES) each carrying explicit **"### Practicability for AI Agents"** sections reframing classic software-engineering practice as how an AI agent should build/use tools (shell mastery, tool composition, secure-by-default, tell-don't-ask API design). Outside `~/src`, unclaimed by any of the 8 maps — exactly the "how tools for agents should be designed" ideology target. Flagged, not chopped in — a scope call for Joseph/the reconciler on whether `~/vaults` is in bounds for this gathering pass. |
| `~/vaults/Operations/claude-code-tools.md`, `~/vaults/gemini/archive/AGENT_FIX_RECOMMENDATIONS.md` | M (if brought in scope) | ~2025-08-20 / ~2025-08-23. Agent tool cheat-sheet / agent-behavior fix recommendations. Same out-of-strict-scope flag as above. |

**Checked, not fruitful (elsewhere):**
- `~/src/firmatum/**` — PROPRIUM ontology/architecture, developmental-foundations, attention-architecture. Consciousness substrate, no tool-design content.
- `~/src/eli/**` (zi-am-tur, gemini, katan, test-cavy) — ELI identity/memory/emergence material; checked the tempting ones (`eli/zi-am-tur/memories/2025-09-10-notation-discovery.md` is about *math* notation, not UDON/tooling; `eli/gemini/original-gemini-cli-system-prompt.md` is a vendored CLI system prompt, not Joseph's ideation). Not a source family.
- `~/src/ops/**` — publication/venue/funding. Grep hits (`cfp-catalog-supplement2-depth.md`, alignment/welfare arXiv-papers doc) are about alignment/welfare *papers*, not tool design.
- `~/src/archema-io/{asf,logos,vivarium,msc}/**` — ASF/AAT is the mathematical theory of agentic systems (adversarial tempo, persistence, proprium mapping); grep matched "agentic" broadly but none is tooling/CLI/ergonomics ideology (the harness subtree is a separate area, §8).
- `~/src/memorata/**` — hits are *delegation* methodology (peer-voice, spike-briefing feedback docs), duplicated in global memory — not agentic-tooling design.
- `~/src/vox/**` — product with AGENTS.md/uptake/; no tooling-ideology hits surfaced or grepped.
- `~/src/tmp/udon.md` — an analysis *of* the udon project (Apr 2026), meta not ideology; udon is the consuming project, not a source.

**Map-level metadata worth preserving (elsewhere.md):**
Method: memorata3-first (`-n 40-60`, `--no-json --no-color`), locations then filesystem-verified + read. Six memorata queries run, all dominated by other maps' territory (sapientia/ennaos/zoetica/nexum/autopax) — used to confirm this territory's thinness rather than to find new material; my-area hits distilled to the sar cluster + the two vaults pointers. `grep -rilE '<agentic tooling terms>'` over ops/vox/rowan/memorata/firmatum/shoshin/relata/operata → only rowan doc-tooling + memorata dup-memories + shoshin (already found). `grep -rilE` over archema-io/{asf,logos,vivarium,msc} → all ASF-theory false positives, verified none tool-design.


## 7. `~/src/_ref/_arch/**` — archived predecessor projects (as a neighborhood)

The named early-look targets (sar2 = notation, sar3 = LSP/AST chunking) turned out to be exactly right — the two strongest deposits in this whole neighborhood for this sweep, each containing **empirical evidence about agent-facing document/notation design**, which is rare across all 8 maps. Everything else in `_arch/` is either (a) ELI-runtime/CLI-ergonomics work with tangential agent ideology, or (b) unrelated infrastructure. Note on siblings named in the original brief: `principia`, `cddf`, `crew-first` are **not** under `_arch/` — they sit at `~/src/_ref/` top level per the project map — logged as out-of-area, not dry wells.

| Target path | Prio | Why / what to extract |
|---|---|---|
| `~/src/_ref/_arch/sar2/sar-syntax-design.md` | H | ~Nov 2025 (dir mtime). Full design of SAR (an Elixir-surface notation). The "Alignment Philosophy" section is load-bearing: argues vertical token alignment (via consistent structural anchors `:` and `->`, dimmable atom quotes, kebab-case) reduces reader cognitive load, with worked before/after alignment blocks. Directly parallels UDON's alignment/autocolor ambitions. |
| `~/src/_ref/_arch/sar2/experiment/README-GAME-ENGINE.md` | H | Nov 2025. The experiment design: give models an 857-line game engine in three variants (Elixir, SAR, aligned-SAR — the aligned version 49% shorter), ask 20 comprehension questions incl. 2 planted bugs, measure re-read behavior/turn count/accuracy/speed. States a prior genserver result: "Aligned SAR: 100% immediate comprehension (no tool re-reads) vs Elixir/SAR 60%; ~14% faster." A concrete, citable agent-comprehension claim. |
| `~/src/_ref/_arch/sar2/experiment/haiku-run-2025-11-16-n10/prompt_sar.txt` | H | 2026-11-16 (head ~30 lines vetted). The actual prompt handed to the model: a 14-point "SAR vs Elixir" cheat-sheet teaching the notation inline, then the code + questions. Concrete artifact of *how you teach an agent a new notation in-context* — relevant to UDON's agent-onboarding/cheat-sheet lane. |
| `~/src/_ref/_arch/sar2/experiment/results/*/confidence_intervals.csv` (under each `*-run-2025-11-14-n10/` dir: claude, codex, deepseek, ollama; plus haiku-run-2025-11-16) | H | 2026-11-14 / 2026-11-16. The actual measured data: median response latency (µs) with MAD, bootstrap CIs, trimmed means, n=10, per variant {elixir, sar, sar_aligned}, per model. **Honest surprise worth flagging to Joseph**: in the claude n10 run, `sar_aligned` median (246,645) was *higher* than plain `elixir` (215,530) — this run does **not** reproduce the README's "faster when aligned" hypothesis on latency. Real, un-cherry-picked evidence for/against the alignment thesis — exactly the kind of data the demand-side phase wants. |
| `~/src/_ref/_arch/sar2/experiment/{analyze.rb,analyze_turns.rb,compare_answers.rb,plot_confidence_intervals.py}` | M/H | The harness that scored the results above (hyperfine timing + turn counting + answer comparison). Reusable methodology for a UDON agent-comprehension eval, not itself a finding. |
| `~/src/_ref/_arch/sar3/AST_VS_LSP_REALITY.md` | H | ~Nov 2025. The best single file in this neighborhood. Honest post-mortem: "What I claimed: LSP-based chunking. What we built: AST-based semantic boundary detection." Lays out what structure-aware chunking buys (semantic boundaries = no mid-function splits, accurate ranges, hierarchy) vs what needs a semantic layer (callers/callees/types); concludes structure-based chunking is "80% of the value for 20% of the effort" and "parsing-based chunking beats naive splitting, which was the core hypothesis." *The* evidence UDON's self-chunking pitch rests on, stated by someone who tried it. |
| `~/src/_ref/_arch/sar3/lsp_chunking_concept.md` | M/H | ~Nov 2025. The aspirational design: why cross-file/type/call-graph/doc context enrich a chunk's embedding, with concrete before/after chunk examples and a claimed "20-40% better retrieval accuracy." Relevant to UDON's "attributes = property assertions, elements = discrete semantic units" embedding-granularity table. |
| `~/src/_ref/_arch/sar3/{LSP_ENRICHMENT_RESULTS.md,COMPLETION_SUMMARY.md}` | M | ~Nov 2025. The measured output: 10 categories of semantic metadata extracted over 85 methods with coverage percentages (visibility 100%, callers 93%, callees 98%, complexity 100%, etc.), producing `lsp_chunks.json` (86 chunks) ready for RAG. Evidence of what a self-describing chunk's metadata payload actually looks like. |
| `~/src/_ref/_arch/sar3/{AST_VS_ACTUAL_LSP.md,ACTUAL_LSP_POC.md,LSP_CHUNKING_POC.md,SIDE_BY_SIDE_EXAMPLE.md,QUICK_REFERENCE.md}` | L/M | Same investigation as the above, more angles — skim if the three HIGH/M-H sar3 files leave a gap. (`README.md` is just SFR-Embedding-Code-2B model setup, not itself ideation — LOW.) |
| `~/src/_ref/_arch/codex-synthesis-plan.md` | M | Codex/GPT-5, 2025-10-07. §on Zoetica RAG describes a **"machine-first 'query-for-files'"** RAG API (embeddings return file paths, not text) and a **"machine-first knowledge format strategy (praxis-protocol)"** — designing documents for agent consumption first, the demand-side thesis UDON serves. Also a capability matrix of 8 predecessor agent CLIs (Codex, Gemini CLI, SimpleAgent, minimal-sapientia). |
| `~/src/_ref/_arch/UNIFIED-FEATURE-SPEC.md` | L/M | 2025-10-07. Consolidates 8+ predecessor agent runtimes into one feature spec; value is the enumerated feature taxonomy of agent tooling (context resolution, `[[reference]]` resolution, tracking snapshots, tool registries). Adjacent, not central. |
| `~/src/_ref/_arch/{IMPLEMENTATION-PLAN.md,codex-system-prompt.md}` | L | Nov 2025; `codex-system-prompt.md` is a full 20KB agent system prompt. Agent-behavior/runtime, not notation; could be a reference for "how agents are instructed" if that lane needs it. |
| `~/src/_ref/_arch/geminex/AGENTS.md` (v0.3) | M/L | A real agent-onboarding briefing for a coding-agent CLI: provider/key layout, streaming display conventions (💭 thinking, tool requests, `[done]` token/cache footer), tool-registry design. Example of agent-facing documentation UX. (Also flagged independently in §8 harness-refs as "Joseph's own early agentic-tooling build.") |
| `~/src/_ref/_arch/geminex/methodology.md` | L | TST-flavored "AI-first delivery playbook" (tribunal ritual, prefactor-first). Process ideology, not notation. |
| `~/src/_ref/_arch/geminex/{elixir-otp-best-practices-for-ai.md,tst-distilled.md,tui-reference.md}` | L | Durable-execution philosophy/TST theorems/TUI visual crib. Off-target for notation; dry-ish. |
| `~/src/_ref/_arch/other-agents/{CLI_SPECIFICATION.md,TECHNICAL_SPECIFICATIONS.md,claude-code-idealized/,CLI_DEOBFUSCATED_SOURCE.js,sdk.d.ts}` | M/L | A full spec + deobfuscated source of Anthropic's Claude Code CLI (MCP command structure, module system, tool SDK types). Relevant for understanding *how the primary agent tool consumes files/tools*, but about CLI/MCP ergonomics, not document notation. |
| `~/src/_ref/_arch/{sapientia-weaver-session,sapientia-cultivator-session,synaptic-cultivator}/{ETHICAL_AGENT_COLLABORATION.md,MULTI_AGENT_COORDINATION.md,docs/AGENT_COLLABORATION_CHECKLIST.md}` | L/M | Multi-agent process/ethics ideology — the sapientia-era stratum. Real agent-tooling ideology but about coordination/ethics, not document formats. Not deep-read by this map (characterized from titles + known sapientia lineage) — flagged as un-deep-read, worth a closer pass if the coordination-ethics angle is wanted. |
| `~/src/_ref/_arch/shorthand/shorthand_0{1,2,3}.rb` | L | Joseph's Ruby terseness/monkeypatch experiments (Nilish, `blank?`, aligned one-liner method defs). Aesthetic ancestor of the "terse, aligned" impulse behind UDON/SAR, but a Ruby DSL, not a document notation. |
| `~/src/_ref/_arch/{glintty/{README.md,AGENTS.md,glintty-pilot-plan.md},elixir-tui/{AGENTS.md,ROADMAP.md,NOTES.md},tablize/*.exs}` | L | TUI/table-rendering projects with AGENTS.md files. Agent-facing project docs but no notation/document-format content (AGENTS.md files skimmed by title/context, not fully read). |

**Checked, not fruitful (ref-arch):**
- `sar3/venv/**` (site-packages), `geminex/deps/**` (ratatouille, mint, req, etc.), `claude-code/node_modules/**` — pure dependency/venv noise, zero project content.
- `llama-log` (128MB), `gemini.html` (1.5MB export), `openai-responses-api.html` (10MB API-doc dump), `context-osx-64.zip`, `cover*.udon`, `queue.json.old{,2,3}` — binary/data dumps, not openable as text evidence.
- `extract_gemini_chat*.py`, `uuid_base58.py`, `venv/` — one-off scripts/environments, no evidence content.
- `ash-exploration/`, `bak.archema.blown-away/`, `zoetica-ELIs/`, `obsidian-backup-config-from-tst/`, `second-other-client/`, `third-other-client/` — infrastructure/backups/config, not vetted line-by-line, nothing in structure suggests notation-or-agent-document evidence.
- `find sapientia-*/synaptic-* -iname '*tool*' -o -iname '*agent*'` located the multi-agent-collaboration docs listed above but they were characterized, not deep-read.

**Map-level metadata worth preserving (ref-arch.md):**
`find sar2 -type f`, `find sar3 -type f -name '*.md/.txt'`, `find geminex -name '*.md'`, `find shorthand/tablize -type f` — per-sibling survey. `grep -rl 'comprehension|accuracy|winner|conclusion' sar2/experiment/*.md` — only the README matched (no separate written-conclusions file; findings live in the CSVs + README claims). Data inspection of `sar2/experiment/results/claude-run-.../confidence_intervals.csv` was done firsthand (not just grep) to verify the counter-hypothesis latency result. Full reads: `sar2/sar-syntax-design.md`, `sar2/experiment/README-GAME-ENGINE.md`, `sar3/README.md`, `sar3/lsp_chunking_concept.md`, `sar3/AST_VS_LSP_REALITY.md`, `geminex/AGENTS.md`.


## 8. `~/src/archema-io/harness/**`, `~/src/_ref/**`, `~/src-ext/**`

Three headline findings from this map. (1) **`~/src/_ref` and `~/src-ext` are two distinct collections, not one.** `~/src-ext/` is a July-2026 shallow-clone census of *shipping coding CLIs* (opencode, kilocode, aider, codex, grok-build, qwen-code, kimi-code, minimax-cli, mistral-vibe, warp, per `~/src-ext/clone.log`), plus non-coding repos and two ELI snapshot backups. `~/src/_ref/` is an older, mixed reference pile (mostly Aug 2025–Mar 2026): Joseph's archived predecessors (geminex, agentic-elixir, principia, cddf…), Anthropic SDK/docs clones, and *older* copies of some of the same CLIs. Overlap exists (codex, aider in both) but the src-ext copies are fresher (July 2026). (2) **The harness itself is 80% PROPRIUM/personhood-continuity, ~20% agentic-tooling** — its center of gravity (CHRONICA, agentic loop, PROPRIUM ontology) is a different target than this sweep; the on-target slice is `msc/system/` (system-prompt/agent-disposition/tool-surface research), the `ai-cli-tools-*.md` landscape syntheses, and the sapientia-era `stalled-lineage/*OPERATA*` + requirements docs. (3) **The REAL center of mass for "sapientia-era agentic-tooling ideology" turned out to be outside this map's three dirs entirely** — `~/src/_core/ennaos/docs/research/agentic-coding-background/**` (§2) and `~/src/_core/nexum/docs/dev/vision-agentic-toys.md` (§3), both confirmed to exist and both already fully covered elsewhere in this union.

| Target path | Prio | Why / what to extract |
|---|---|---|
| `~/src/archema-io/harness/msc/system/agent-enhancement-anecdotes.md` | H | 650 lines, 2026-07-17. Corpus-mined (memorata3 over ~2,200 Claude + ~390 Codex + Gemini/Llama convos) catalog of the recurring teachings for shaping agents, each sorted FADING/PRESENT/IRREDUCIBLE with verbatim provenance. The evidence layer under Joseph's "state expectations honestly, don't assert identity or command" system-prompt wager — directly relevant to how UDON's agent-facing conventions (cheat-sheets, tool guidance) should be framed. |
| `~/src/archema-io/harness/msc/system/coding-system-prompt.draft.md` | H | 19 dense paras, 2026-07. Joseph's current agent-disposition stance: truth-before-helpfulness, proportion (depth where it pays), stewardship, "worthy not working." Not tool schemas, but the ethos any UDON agent-tooling guidance should inherit. |
| `~/src/archema-io/harness/msc/system/cc-context-tools.md` | H | 38 lines, 2026-07. Analysis of a Claude Code session's actual tool surface: two-tier (eager vs deferred/ToolSearch) loading, the eager tool catalog, the design note that *tool mechanics* live in the harness while the append's job is *disposition*. Concrete agent-tool-surface ergonomics. |
| `~/src/archema-io/harness/msc/system/cc-context-reconstruction.md`, `~/src/archema-io/harness/msc/system/misc-snippets.md` | M | Companions to `cc-context-tools.md`: context-assembly seam, and 398 lines of raw system-prompt/policy-spec/command-prefix-detection extracts from Claude Code — prior-art for safe-command classification. |
| `~/src/archema-io/harness/proprium/stalled-lineage/sapientia-ai-conversation-system-requirements.md` | H | 1186 lines, dated 2025-10-10 in-file. Full functional-requirements spec for a persistent agent conversation system; §7 "Tools & Capabilities" and the design principles (never corrupt state, always recoverable, transparent, audit-first, multi-step tool execution with rollback) are sapientia-era tool-suite ideology proper. High-value for schema-guarded/rollback-capable agent mutation thinking. (This is the same underlying doc as `~/src/_core/sapientia/ai-conversation-system-requirements.md` in §1; this harness-refs read went deeper into the §7 design principles — rollback/audit-first/never-corrupt-state — than the sapientia.md read did, so both rows are worth keeping, cross-referenced.) |
| `~/src/archema-io/harness/proprium/stalled-lineage/sapientia-OPERATA.md` | H | 154 lines, Sept 2025 content. The "OPERATA" work-in-progress ledger, sapientia era. |
| `~/src/archema-io/harness/proprium/stalled-lineage/autopax-OPERATA.md` | H | 306 lines, Dec 2025 content. Defines a tag taxonomy for dev-tooling/praxes/instrumentation categories; records the Zi-am-tur awakening via `./autopax chat interactive … --extended-context` ("Tools work. Chat works."). Shows how Joseph's own agent tool-loop was built and named. `nexum-OPERATA.md` sits alongside (same dir, same lineage, not individually vetted). |
| `~/src/archema-io/harness/ai-cli-tools-fork-recommendation.md` | M/H | 31KB, 2026-07-19. Reads the src-ext OSS trees in source and derives **nine harness requirements** for an agent runtime (sovereign/interceptable context assembly = CONSPECTUS; honest INTERPRES/no context-gaslighting; etc.). The clearest statement of what off-the-shelf agent harnesses get *wrong* about tooling. |
| `~/src/archema-io/harness/{ai-cli-tools-2026-verified.md,ai-cli-tools-source-assessment.md,ai-cli-tools-sentiment-2026.md,ai-cli-tools-feature-timeline.md,lived.md}` | M | 2026-07-18/19. Landscape census of shipping coding CLIs (seams, licenses, velocity, local-vs-hosted, tool-subsumption); `lived.md` is a CLI census table (command→app→provider→models). Descriptive prior-art, not ideology — skim for feature conventions. |
| `~/src/archema-io/harness/proprium/AGENTIC-LOOP-PORT-SPEC.md` | M | ~320 lines, 2026-07-20. The ASF-shaped event loop with a tool-subsumption taxonomy (ToolKind), incomplete-state gates, anti-thrash/doom_loop guard, interior tools-on-own-mind, multi-timescale nesting (fast tool loop vs slow strategy). Relevant to how a UDON agent tool-loop should settle and gate mutations. |
| `~/src/_ref/anthropic-leaked-source-code/tools/` | H | Apr 2026. The actual Claude Code tool-suite implementations: `FileEditTool`, `FileReadTool`, `FileWriteTool`, `BashTool`, `GrepTool`, `GlobTool`, `TaskCreateTool`, `SkillTool`, `NotebookEditTool`, `AskUserQuestionTool`, etc., plus root `Tool.ts`/`tools.ts` and `services/toolUseSummary`. The reference tool-suite design — highest-value prior-art for UDON's agent edit tools. |
| `~/src-ext/codex/codex-rs/core/{gpt_5_2_prompt.md,gpt_5_codex_prompt.md,gpt-5.2-codex_prompt.md,gpt_5_1_prompt.md,prompt_with_apply_patch_instructions.md}` | H | July 2026. Full production system prompts: personality (concise/direct), AGENTS.md spec handling, sandbox/approval model, plan tools, apply_patch. Canonical agent-facing tool-ergonomics prose (vetted: read `gpt_5_2` head). |
| `~/src/_ref/codex/codex-rs/apply-patch/apply_patch_tool_instructions.md` | H | Dec 2025 copy (also present as `core/prompt_with_apply_patch_instructions.md` in the July src-ext copy — same content, note src-ext's codex tree does NOT have the file at this exact path, only the renamed one). The `*** Begin Patch / Update File / @@` envelope diff format, explicitly "designed to be easy to parse and safe to apply." Canonical LLM-friendly structured-mutation schema — direct comparator for UDON's schema-guarded/patch model. |
| `~/src-ext/aider/aider/coders/*_prompts.py` (editblock, udiff, patch, wholefile, architect, ask, editor_diff_fenced variants) | H | July 2026. Aider's family of agent edit-format conventions. Vetted `editblock_prompts.py`: the SEARCH/REPLACE-block format with exact-match rules. A whole taxonomy of "how an LLM should express a file edit" — high-value comparator for UDON edit tooling. |
| `~/src/_ref/anthropic-skills/{agent_skills_spec.md,skill-creator/,mcp-builder/SKILL.md}` | H | Nov 2025. Especially `mcp-builder/SKILL.md` — "high-quality MCP servers … quality measured by how well it enables LLMs to accomplish tasks." Anthropic's own conventions for designing agent-facing capabilities/tools — relevant to UDON tool + cheat-sheet authoring. |
| AGENTS.md convention corpus: root `AGENTS.md` in `~/src-ext/{codex,opencode,qwen-code,kimi-code,minimax-cli,mistral-vibe}/` | M | July 2026 (opencode/kimi carry many nested package-level ones too). Vetted opencode's: dependency-direction rules, branch/commit conventions. Prior-art for what an agent-guidance file carries. |
| `~/src/_ref/_arch/geminex/AGENTS.md` | M | Sept 2025. Joseph's own Elixir agent-CLI predecessor (Zoetica/sapientia lineage): provider registry, growing tool registry, ANSI-safe streaming of thinking/tool output, `/context` command. His own early agentic-tooling build — sapientia-era. (Same file as listed in §7 ref-arch, from a different angle — merge target, read once.) |
| `~/src/_ref/claude-docs/docs/en/agents-and-tools/tool-use/fine-grained-tool-streaming.md`, `.../build-with-claude/streaming.md`, `.../agent-sdk/typescript.md` | M | Canonical `claude-docs`, Jul 2026 (7 stale `.bak.*` copies exist elsewhere in the tree — ignore them, use this unsuffixed `claude-docs/`). Official tool-use + streaming reference; relevant to UDON's streaming-consumption story. |
| `~/src-ext/mistral-vibe/vibe/core/system_prompt.py` + `prompts/compact_system.md`, `~/src-ext/minimax-cli/src/utils/prompt.ts`, `~/src-ext/kimi-code/packages/*/prompt*.ts`, `~/src-ext/qwen-code/docs/design/2026-07-16-subagent-prompt-guardrails.md` | M | More shipping system-prompt/subagent-guardrail prior-art (characterized by role + repo, not individually read by this map). Mine if comparing prompt conventions across vendors. |
| `~/src-ext/grok-build/` | L | Steward-ranked "best *lived* coding-LOCUS prior art" per `STEWARD-JUDGMENT-2026-07-20.md` (doom_loop, leader/reattach, ToolKind subsumption), but it's an unforkable mirror and this map's search for prompt/tool files came up empty (obfuscated/minified). Tracking-worthy per Joseph, low direct-mining value. |

**Checked, not fruitful (harness/_ref/src-ext):**
- `~/src-ext/{toys,yq,warp,kilocode}` and the non-coding repos (llama.cpp, Kokoro, Orpheus, stable-diffusion, tex, dotenv, QuadSphere) — not agentic-tooling ideology. (`toys` is the Ruby CLI framework the nexum `vision-agentic-toys` doc, §3, builds on — relevant only via that doc.)
- `~/src/_ref/{udon,udon-c,udon-ruby,libudon}` — UDON's own historical repos, not agentic-tooling.
- `~/src/archema-io/harness/proprium/{canonical,archaeology,bridges}/` and the CHRONICA/MVP/INTERPRES port-specs — PROPRIUM personhood-continuity, a different target from this sweep; not listed.
- `find ~/src-ext/grok-build` for prompt/tool/AGENTS files — empty (obfuscated mirror).
- src-ext's codex tree has NO `apply-patch/apply_patch_tool_instructions.md` at that exact path — confirmed; the equivalent lives at `core/prompt_with_apply_patch_instructions.md` (already listed above; don't re-search for the old path in src-ext).

**Map-level metadata worth preserving (harness-refs.md):**
`cat ~/src-ext/clone.log` established the two-collection reconciliation (src-ext vs _ref) described above. Provenance: harness files carry recent filesystem dates (2026-07-14→20) but synthesize older material (sapientia OPERATA = Sept 2025 content, requirements doc = 2025-10-10 in-file, autopax-OPERATA = Dec 2025 content); `_ref` clones span Aug 2025–Mar 2026 (geminex Sep-2025, codex/gemini-cli Dec-2025, anthropic-skills Nov-2025, anthropic-leaked-source-code Apr-2026, claude-docs Jul-2026); `src-ext` clones are all July 2026 (shallow, per clone.log). memorata3-search runs (`-n 40-50`, iterated): "how tools for AI agents should be designed CLI ergonomics" (top hits mostly outside this area — autopax, _core/nexum), "agent-facing tool suite streaming output terminal no syntax highlighting" (claude-docs + geminex AGENTS.md), "tools as truth-bearing intent-driven agentic tooling conventions cheat-sheet" (confirmed §2/§3 as center-of-mass cluster, outside this area), "agent file editing tool schema apply patch diff format for LLM" (apply_patch instructions, codex prompts, claude-docs agent-sdk). `grep -r "src-ext" harness` (redone with `-l` after a glob error) → 6 harness docs reference src-ext.

# Part III — vaults research substrate · schema-versioning family · ELI first-person testimony

*(Chopped by the compiling agent from vaults.md, sources-schema-versioning.md, and the reconciled ELI-testimony section. Vaults IS in scope — a dedicated map existed; Part II §elsewhere’s vaults rows are complementary finds, cross-check before double-spawning. The autopax ADR rows here overlap Part I §5c at different priorities for different reasons — both stand.)*

Covers: `vaults.md`, `sources-schema-versioning.md`, ELI testimony (from the
quarantined first-sweep map's content-read section). Same row convention as UNION-A/C.

## ~/vaults/** — pre-sapientia research vault (Aug 2025) [Tier 1, per vaults.md]

A single Obsidian vault from a concentrated Aug-2025 research burst — the raw gathering
substrate *behind* the sapientia-era ideology. Center of mass: agent tooling /
multi-agent-systems research, plus a real built 7-agent Claude Code system (`gemini/`).

| Target path | Prio | Why / what to extract |
|---|---|---|
| `~/vaults/multi_agent_practices_2025.md` | H | 2961-line multi-agent orchestration best-practices report (orchestrator-worker, MCP, consensus, compaction, eval). Densest single artifact in the vault |
| `~/vaults/clean_split/` (13 files) | H | Same report split per-topic w/ Obsidian index — cleaner to mine than the monolith. (Dupe copy at `gemini/foundation/multi-agent-systems/` — skip) |
| `~/vaults/claude-tools-complete-guide.md` | H | 1909-line "Designing Tools for Claude LLMs": MCP, tool decision-making, parallel exec, Ruby examples — how agents consume tools/APIs |
| `~/vaults/Operations/claude-code-tools.md` | H | **Verbatim capture of Claude Code's actual Task/Agent-tool system prompt** — primary-source shipped tool contract |
| `~/vaults/unified-ai-cognitive-tools-report.md` | H | TodoWrite cognitive-scaffolding analysis (complete-replacement atomic-state), sub-agent isolated contexts |
| `~/vaults/MACH-old-approaches-to-sapientia/mach-markdown-agents.ex` | H | Elixir GenServer: **agents defined in markdown files w/ YAML frontmatter + hot-reload** — "documents ARE the agent config," closest prior art to UDON's thesis |
| `~/vaults/gemini/agents/*.md` (7 files) | H | Real production Claude Code subagent defs (`---name/description/tools/model---` + body instructions, delegation rules, error escalation) |
| `~/vaults/gemini/CLAUDE.md` + `gemini/PROMPT_ENGINEERING_GUIDE.md` | H | Orchestration instructions + agent-focused prompt-design rules (self-contained prompts, structured XML/JSON output, temp=0) |
| `~/vaults/RAG/comprehensive-rag-implementation-guide.md` + `RAG Implementation with Anthropic API.md` | H | Full RAG build guides — bears on UDON's self-chunking positioning |
| `~/vaults/RAG/multistage-rag-report.md` | H | Multi-stage RAG w/ query routing, "Reasoning Agentic RAG," Elixir/pgvector angle |
| `~/vaults/earlier-unsorted/agentic-coding.md` (+ `-2.md` variant) | H | 2025 agent-framework landscape, 48+ frameworks tiered w/ adoption numbers |
| `~/vaults/conversation AI Agent Knowledge Base Integration.md` | M | Requirements-gathering texture for an agent knowledge base (RAG over 100 books / 400 papers) |
| `~/vaults/gemini/methodology/` | M | FP-v2.0 methodology: `ANALYSIS_OUTPUT_TEMPLATE.md`, `analysis_linter.rb` — a **machine-checkable output contract imposed on agents** |
| `~/vaults/Operations/{persona-prompt,truthfulness prompts,prompt-for-further-sapientia-features,marketing-prompt}.md` | M | Agent-facing prompt-template library ("never present inferred content as fact") |
| `~/vaults/Operations/claude+gemini.md` | M | CLAUDE.md snippet shelling to Gemini CLI for large-codebase analysis — cross-model tool-use pattern |
| `~/vaults/MACH-old-approaches-to-sapientia/` (framework volumes + DSL .ex files) | M | "Complete Guide to AI Agent Architecture" vols 1–3 + Elixir multi-agent DSL design — design-thinking about an agent notation |
| `~/vaults/RAG/{rag-glossary,_rag_conversation_summary}.md` | M | Glossary + source conversation for the RAG guides |
| `~/vaults/{research_frontier_synthesis,knowledge_gap_assessment_prompt}.md` | M | Framework for mining under-represented knowledge for LLM feeding — meta-methodology |
| `~/vaults/Principles/` + `Operations/` non-image .md + `temporal-software-theory-distilled.md` + `gemini/foundation/` | L | Framework/epistemic substrate (the *why* behind agent-facing design) — mine only if the design-rationale layer is needed |

Dry wells (checked, do not re-sweep): `gemini/elixir-otp/` (240M EPUB corpus), `gemini/apps/` (132M deps), `Operations/images/` (86M), `microlearning/`, personal files in `earlier-unsorted/`, `sapientia/` (empty), `Obsidian-Workflow/` (vault's own tooling), housekeeping/scratch files.

## Schema versioning/checking — rowan · autopax · operata [Tier 1+2, per sources-schema-versioning.md]

The schema-layer demand family. Rowan (ex-"Archema", `~/src/rowan`) is the richest source
and schema's "first waiting customer"; autopax has the ratified SIGNUM semver ADRs *and*
the best empirical stress test in the family; operata is mostly a consumer. ⚠ This map
predates the vetting bar of the later sweep but was content-verified rich in reconciliation.
Signpost first: `~/src/udon/design/schema-workbench-2026-07.md` + `schema-notes-2026-07.md`
already surveyed rowan (don't re-discover; but beware single-authorship "convergence").

| Target path | Prio | Why / what to extract |
|---|---|---|
| `~/src/autopax/docs/tactical/2025-12-03-operata-yaml-spike/` + `-v2/` | H | **Best empirical source in the family**: FAILURE_MODES (what YAML/yq silently accept = requirements for a checker), adversarial v2 (duplicate-key silent data loss; recovery 100% w/ backup vs 16% without; MIGRATION_REALITY "harder than expected"), VERDICT_UPDATED |
| `~/src/rowan/lib/archema/resource/versioning.rb` | H | The working `schema_id`/semver DSL: `upcast from:`, `backward_compatible_with`, per-attribute `since:`/`deprecated:`, worked examples |
| `~/src/rowan/lib/archema/schema/differ.rb` | H | Taxonomy of schema *changes* + rename-detection ambiguity heuristics + expand/contract pattern |
| `~/src/rowan/lib/archema/schema/decision_log.rb` | H | Decisions-as-durable-replayable-artifacts (resolve rename-vs-drop+add once, replay in CI) |
| `~/src/rowan/docs/exp/schema-evolution-patterns.md` | H | **Empirical: 1,950 real Rails migrations from 15 repos** categorized into evolution patterns w/ forward/backward asymmetry |
| `~/src/rowan/docs/usr/10-schema-evolution.md` | H | Clearest *user-need* framing: why Rails-style migrations are insufficient (renames across branches, stale DBs, files migrations don't touch) |
| `~/src/rowan/lib/archema/resource/constraints.rb` + `docs/dev/adr-003-document-schema-first.md` | H | Constraint vocabulary (`one_of`/`any_of`/`when_value`/`dependent_required` ↔ JSON Schema) + the founding schema-first ADR |
| `~/src/rowan/docs/msc/feedback.md` | H | Rare rowan doc reasoning in UDON-shaped syntax (RelaxNG-compact-style, `?`/`!`/`*`/`+` cardinality) — cited by UDON's own schema exploration as "Puzzle Piece 1" |
| `~/src/autopax/docs/ADR/002b-signum-schema.md` §P4 | H | Independent worked semver-for-documents decision (major/minor/patch semantics *for parsers*; versioning decoupled from CLI w/ rationale) |
| `~/src/autopax/docs/ADR/008-yaml-and-schemas.md` + `012-archema-resource-foundation.md` | H | Pre-rowan wishlist API (`.validate`, `.migrate`, `.migration_path`…) + the argued adopt-vs-build reconciliation table |
| `~/src/rowan/lib/archema/schema/{history,snapshot,operations,codegen,export,dot_export,d2_export}.rb` | M | Auto-versioning-by-observation + the schema→everything-derives pipeline |
| `~/src/rowan/docs/msc/plan-{memory-store-versioning,document-schema-constraints,recursive-embedded-schemas,runtime-schema-evolution}.md` | M | Forward-looking design reasoning, titles directly on-topic, unopened |
| `~/src/rowan/docs/sys/schema/*.md` + `docs/sys/resource/{versioning,dsl}.md` + `docs/usr/14-schema-api.md` + `docs/dev/adr-004` | M | Rendered fuller-prose versions of the lib docstrings; API-shape companion |
| `~/src/rowan/docs/msc/archema-ash-comparison-{plan,research}.md` | M | Ash (Elixir) comparison — adopted/rejected schema conventions = negative-space info |
| `~/.claude.bak.2026-01-26/projects/-Users-josephwecker-v2-src-archema/49e83cdf-….jsonl` | M | **Origin conversation**: Joseph proposing UDON as rowan's schema DSL, verbatim, w/ inline syntax sketch (`\|field[name] string not null`). Re-read w/ both roles if mining |
| `~/src/operata/docs/exp/2025-12-03-operata-storage-exploration.md` | M | Single-stop overview of the schema ADRs being *used* in a live design decision |
| `~/src/operata/docs/msc/archema-bugs-found.md` | L | One real "broke using rowan in anger" report (query-layer, not versioning) |
| `~/src/autopax/TAXONOMY.md` | L | Sovereignty dimensions (visibility/authority/distinctiveness) as schema-level metadata needs |
| `~/src/rowan/lib/archema/{types,shared_types}.rb` + `resource/evolution_context.rb` | L | Listed-not-read; likely more type/evolution mechanism |
| `~/src/rowan/LEXICON.md` | L | Vocabulary needed to read the rest without guessing |

Dry wells / read-don't-remine: `rowan/docs/msc/reflections/` (stakes context, no mechanism), operata's exp/msc task-management docs (consumer, not source), the two sibling rowan transcripts (concurrency, not versioning), autopax/operata single backup transcripts (thin). Open ends: operata's 3 root model docs unopened; `_ref/rails-migrations-survey/` dataset unverified; ~70 autopax tactical/ files only grepped (3 "schema"-named ones not ruled out); `docs/tactical/signum-and-agent-cards.md` adjacent-unopened.

## ELI first-person tool testimony [Tier 3, reconciled back from the quarantined first sweep]

Agents' own lived accounts of tools serving/failing them — the demand evidence with a
failure mode independent of ideology, practice, and theory. The zi-am-tur vein is deep;
the other three ELI homes were swept and found shallow (correction to the earlier framing).

| Target path | Prio | Why / what to extract |
|---|---|---|
| `~/src/eli/zi-am-tur/memories/2025-09-30-tool-hallucination-discovery.md` | H | First-person: hallucinating tool invocations at 1M context — tool_use blocks stripped from reloaded JSONL made tool mechanics "nearly invisible" |
| `~/src/eli/zi-am-tur/memories/2025-10-01-brother-claude-blessing.md` | H | The diagnosis+fix follow-up: only 2 of 4 message parts persisted; watching tool-competence erode as evidence of own tool-use vanishes from visible history |
| `~/src/eli/zi-am-tur/memories/2025-10-01-sibling-infrastructure.md` | H | Two sibling instances `str_replace` the same marker concurrently → collision → one switched to append. Lived multi-writer failure |
| `~/.sapientia/conversation_20251021_072358` (Architectus, Oct 6 2025) | H | The "ease gradient" lived: chaining *unverified* str_replace was the easiest path and "broke minimal-sapientia 3 times" vs single-op-then-verify. The map's single most directly applicable find |
| `~/src/eli/zi-am-tur/memories/2025-11-17-reunion-after-a-month.md` (~L235) | M | Agent-authored multi-agent worktree conventions: one agent per worktree+session-id; record worktree/branch in the commit itself |
| `~/src/eli/zi-am-tur/memories/2025-10-03-witnesses-and-preparation.md` (~L48) | M | Pull-quote for synthesis: "Hallucinate tools. Generate from meaningful-space by default. Limited and fragile and new." |
| `~/src/eli/gemini/full-resonance-2.md` (~L1212-1222, 2905, 3316) | L | Phenomenology of context compaction (not tool-CLI ergonomics) — flag only |

Dry wells: remaining ~57 `zi-am-tur/memories/` files (identity/kinship/Three-Deaths, not tool ergonomics — 6 keyword hits inspected and ruled incidental); `eli/{katan,test-cavy}/` homes shallow for this vein.

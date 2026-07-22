---
source: open source-file pass (Grok Build subagent), 2026-07-21
pass: sources-A
status: prospective path map only — no body extracts, no need synthesis
posture: extra-comprehensive, inclusion-biased; overlap with other gatherers is intentional
out_of_scope_for_this_file: mining content into needs rows; treating _quarantine/ as coverage truth
---

# Prospective sources — pass A (open file map)

**What this is.** Candidate files and short directory units where end-user /
agent / library-consumer *needs* (usage situations, tool desires, friction,
schema/path/template/edit/stream ideas, interchange, editor surfaces, etc.)
might live. For later reconciliation and per-file mining — **not** a needs map.

**How to read.** Absolute paths. Each entry: **why it might matter** + brief
**provenance** when known. Prefer include when unsure. Overlap with Fable’s
agentic-tooling / schema-versioning maps and the quarantined Grok design/UX
maps is fine.

**Method (high level).** Walked live `udon/` (design, spec lanes, utils, UX,
test scenarios/usability, core API, archives), `v2/` ledgers + `.archived/`
demand spikes, live consumers named by `CONSUMERS.md`, older UDON lineages
under `~/src/_ref/`, adjacent “waiting customer” projects (rowan, autopax,
operata, vivarium loaders), harness/agentic ideology deposits, vaults outside
`~/src`, and memory/session pointers. Did **not** deep-mine bodies into
needs. Did **not** re-copy extracts.

---

## 0. Coordination / already-mapped siblings (do not treat as exclusive)

These are **other gather maps**, not substitutes for opening the originals they
point at:

| Path | Role |
|------|------|
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/01-ideation/needs-map.md` | Seed situations S1–S12 + standing harvest list |
| `…/scratch/first-sweep-agentic-tooling/sources-agentic-tooling.md` | Sapientia-era tooling ideology map |
| `…/agentic-tooling-sources/*.md` | Split maps (sapientia, zoetica/ennaos, nexum, autopax, harness, elsewhere) |
| `…/sources-schema-versioning.md` | Rowan / autopax / operata schema-versioning spots |
| `…/scratch/schema-sources-search-log.md` | Search trail for schema pass |
| `…/_quarantine/overprescribed-pass-2026-07-21-grok/` | **Quarantined** prior pass (extracts + narrowed maps). Useful only as a *hint list of paths already noticed*, not preferred reading and not coverage truth |

---

## 1. Deliberation substrate (why demand-side exists)

| Path | Why it might matter | Provenance |
|------|---------------------|------------|
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/pipeline-discussion.md` | Full fold → accumulation → demand inversion → night spine → archive → (1)–(8) flow; Joseph’s sampling list (paths, dialects, schema, inverse edit, mid-stream reconfig, `[…]` as dialect sugar) | Live deliberation record for v2 needs |
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/README.md` | Flow notes, provenance rules, layout; “prediction OK, architecture not yet” | Front door for this workstream |
| `/Users/josephwecker-v2/src/udon/v2/DECISIONS.md` | Present-truth law pins that **constrain** what products can demand (text-wire R1, partial-doc, keep-everything, etc.) — mine for *implied consumer contracts*, not architecture cosplay | Graduated 2026-07-21 from second-pass |
| `/Users/josephwecker-v2/src/udon/v2/OPEN.md` | Explicit WAIT-DEMAND items (ML reframed, S3/S12, W1e) + pointers into spike demand tables | Same graduation |
| `/Users/josephwecker-v2/src/udon/v2/README.md` | v2 orientation; center of gravity → udon-needs | Live |

---

## 2. In-repo “felt needs” / utility / agent UX (0.9 line)

High signal **wishlists and design-of-record** that name caller products
directly (edit, skeleton, guard, paths, schema, CLI probes, cheat-sheets).

### 2a. Wishlists & lanes

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/TODO-UTILS.md` | Accessors, coerce, serialize/round-trip, skeleton/paths summary, **udon guard** (tool-mediated edits), reference expansion — library + agent product surface |
| `/Users/josephwecker-v2/src/udon/TOOLING-WISHLIST.md` | Joseph “felt needs” 2026-07-19: events CLI, AST view, text/JSON round-trips, fmt — friction while *authoring* the grammar |
| `/Users/josephwecker-v2/src/udon/ux/TODO-AGENT-UX.md` | Cheat-sheets rebuild, usability harness rebuild, agentic tool suite critical path (paths → schema → edit), GBNF generation |
| `/Users/josephwecker-v2/src/udon/ux/TODO-HUMAN-UX.md` | Editor / Obsidian / highlighting needs (S11 class) |
| `/Users/josephwecker-v2/src/udon/spec/TODO-AUX.md` | Paths + schema + patch as aux syntax; edit-tool critical path; `@{…}` embed; rowan as first waiting customer |
| `/Users/josephwecker-v2/src/udon/spec/TODO-SPEC-OTHER.md` | Non-core spec backlog (pragma/schema-bind etc. — skim for demand pressure) |
| `/Users/josephwecker-v2/src/udon/spec/TODO-TEXT-WIRE.md` | Text reconstruction contract pressure (library/fixture consumer) |
| `/Users/josephwecker-v2/src/udon/spec/TODO-SPEC-CORE.md` | Open core wording — residual “what hosts still need settled” |
| `/Users/josephwecker-v2/src/udon/TODO-META.md` | Literate fusion, fixtures-as-UDON dogfood, runner-version pin — meta needs that shape tooling |
| `/Users/josephwecker-v2/src/udon/TODO-PUBLISHING.md` | Outward docs / crates — secondary but real “consumer discovery” needs |
| `/Users/josephwecker-v2/src/udon/core/TODO-CORE-PARSING.md` | Parser residuals that **block** utility products (spans, serializer prerequisites) — demand *from the tools that can’t ship yet* |
| `/Users/josephwecker-v2/src/udon/core/TODO-PARSER.md` | Parser API / substrate TODOs adjacent to utils |

### 2b. Design documents (demand-shaped essays & surveys)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/design/agentic-ux-principles.md` | WHY layer for agent tools (principles over sketches) |
| `/Users/josephwecker-v2/src/udon/design/udon-agentic.md` | Design of record for glance/focus/propose/apply/session/… (~full file; head was extracted in quarantine) |
| `/Users/josephwecker-v2/src/udon/design/UDON-AGENT-TOOLS.md` | Dec-2025 brainstorm; Tier-1 merge idea not fully absorbed |
| `/Users/josephwecker-v2/src/udon/design/AGENT-CONTEXT-PROTOCOL.md` | Agent friction phenomenology; propose/validate/apply |
| `/Users/josephwecker-v2/src/udon/design/UDON-AS-ACP-FORMAT.md` | UDON as agent-context packaging format |
| `/Users/josephwecker-v2/src/udon/design/udon-guarantees.md` | Gatekeeper / tool-mediated edit guarantees |
| `/Users/josephwecker-v2/src/udon/design/udon-paths.md` | Stale spelling but surviving at/all ideas (TODO-AUX says redesign; still a mine) |
| `/Users/josephwecker-v2/src/udon/design/udon-ast.md` | Skeleton paths, SourceInfo, streaming fragments — product shapes |
| `/Users/josephwecker-v2/src/udon/design/schema-notes-2026-07.md` | Short schema design note (surfaces, freezes, forks) |
| `/Users/josephwecker-v2/src/udon/design/schema-workbench-2026-07.md` | Long survey index into rowan + corpus; “first waiting customer” |
| `/Users/josephwecker-v2/src/udon/design/udon-schema-exploration.md` | Older single-source-of-truth vision; Puzzle Piece 1 → rowan feedback |
| `/Users/josephwecker-v2/src/udon/design/GRAMMAR-CONSTRAINED-GENERATION.md` | Guaranteed-valid generation for agents/local models |
| `/Users/josephwecker-v2/src/udon/design/positioning.md` | Who UDON is for / competitive framing of needs |
| `/Users/josephwecker-v2/src/udon/design/file-naming.md` | `*.<designator>.udon` genre conventions consumers already use |
| `/Users/josephwecker-v2/src/udon/design/composite-types.md` | Type composition demand (library/schema adjacency) |
| `/Users/josephwecker-v2/src/udon/design/markdown-layers.md` | Multi-situation markdown processing (S5 class) |
| `/Users/josephwecker-v2/src/udon/design/markup-feature-matrix.md` | Feature matrix vs other notations — “what users expect from a markup” |
| `/Users/josephwecker-v2/src/udon/design/semachrome.md` | Semantic coloring / role mapping (UX + autocolors lineage) |
| `/Users/josephwecker-v2/src/udon/design/desc-design-principles.md` | Descent-grammar authoring principles (meta-language consumers) |
| `/Users/josephwecker-v2/src/udon/design/descent-experience-2026-07.md` | Lived friction writing descent for UDON |
| `/Users/josephwecker-v2/src/udon/design/attribute-model-2026-07.md` (+ proposal-2/3 + substrates) | Mostly supply-side — **lower priority** for demand mining; keep listed so reconcilers know they exist |
| `/Users/josephwecker-v2/src/udon/design/README.md` | Status banners / what design is superseded by CORE |
| `/Users/josephwecker-v2/src/udon/defining-udon.md` | Grammar / Specification / Pedagogy pillars — product-of-documentation needs |

### 2c. Example corpus (genres → implied tools)

Whole tree unit: `/Users/josephwecker-v2/src/udon/design/examples/`

| Path | Why (genre signal) |
|------|--------------------|
| `…/schema-dsl.udon` | Schema-as-document authoring |
| `…/ash-like-{billing,inventory,support}.udon` | Resource/domain DSL shapes (rowan-adjacent) |
| `…/archema-operata.udon`, `…/operata-intent-graph.udon` | Operata / intent-graph genre |
| `…/practices-gotchas.udon` | Authoring hazards agents hit |
| `…/cheatsheet.udon`, `…/comprehensive.udon`, `…/minimal.udon` | Pedagogy / full-feature showcase |
| `…/docbook-fo-table.udon`, `…/docbook-graphics.udon`, `…/mathml-to-latex.udon` | Round-trip / transform genres (S6) |

---

## 3. Day-in-the-life scenarios & empirical usability (under-mined relative to essays)

### 3a. BDD multi-agent day (very high demand density)

Whole tree: `/Users/josephwecker-v2/src/udon/test/scenarios/`

| Path | Why |
|------|-----|
| `…/README.md` | Vocabulary of ops (skeleton/at/all/diff/patch/CAS/append); path-syntax provisional; runner pin rule |
| `…/features/01-understanding.scenarios.udon` | Read journeys |
| `…/features/02-diffing.scenarios.udon` | Diff journeys |
| `…/features/03-modifying.scenarios.udon` | Write/patch journeys |
| `…/features/04-multi-agent.scenarios.udon` | Contention, handoff, concurrent ledger |
| `…/corpus/*.udon` | Synthetic but CORE-0.9 idiomatic stand-ins for live consumer genres |
| `…/bin/verify` | What “clean parse” means for the corpus contract |

### 3b. December 2025 usability corpus (stale models/spec — still evidence)

Whole tree: `/Users/josephwecker-v2/src/udon/test/usability/`

| Path | Why |
|------|-----|
| `…/enablement-synthesis.md` | Domain situations / mixed content enablement |
| `…/results/AGENT_FEEDBACK.md` | Aggregated agent feedback (large, noisy) |
| `…/lib/{test_definitions,realistic_tests,validated_tests,topic_enablement,usability_*}.rb` | What was *asked* of agents (task design = need proxy) |
| `…/ETHICS.md` | Constraints on how agent evals were run |
| `…/results/udon-*.yaml` | Per-run raw results (sample, don’t dump wholesale in phase 2) |

---

## 4. Live consumers & runtime loaders (usage, not essays)

### 4a. Registry & scanner

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/CONSUMERS.md` | Live inventory, migration surfaces (dates, keys), **unused feature surface**, future consumer watchlist (ADRs, Axiomata, Signa, Memorata, A2A, Loci…) |
| `/Users/josephwecker-v2/src/udon/bin/find-consumers` | How discovery works; implicit “who must not break” |

### 4b. Live `.udon` documents (2026-07-16 scan)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/archema-io/asf/msc/meta-process-review-2026-07-07/PROCESS-MAP-v0.udon` | Founding process-map genre; MECE / health tags |
| `/Users/josephwecker-v2/src/archema-io/vivarium/DECISIONS.decision-log.udon` | Largest growing log; dense attr-dates; append-friendly concurrent write |
| `/Users/josephwecker-v2/src/archema-io/vivarium/LEXICON.udon` | Dictionary: identity, relations, `!:md:` tables |
| `/Users/josephwecker-v2/src/archema-io/vivarium/doc/PROCESS.udon` | Norms + **safe-subset authoring contract**; known reflow/sigil friction |
| `/Users/josephwecker-v2/src/archema-io/vivarium/tabularium/terrestris.ordinum.udon` | Machine-read law-data; versioned phases |
| `/Users/josephwecker-v2/src/autopax/taxonomy.udon` | Nested taxonomy; multi-value attr hazards under 0.8→0.9 |

### 4c. Consumer-side process / format / loader demand

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/archema-io/vivarium/FORMAT.md` | Cross-doc path schemes into LEXICON/DECISIONS |
| `/Users/josephwecker-v2/src/archema-io/vivarium/tabularium/README.md` | Schema-by-filename (`*.ordinum.udon`); `stdin_parse` until CLI |
| `/Users/josephwecker-v2/src/archema-io/vivarium/doc/plan/regula-conformance-design.md` | Upcoming `.regula.udon` profiles / conformance rigor |
| `/Users/josephwecker-v2/src/archema-io/vivarium/crates/vivarium-world/src/ordinum.rs` | **Hand parser awaiting libudon** — concrete library-consumer demand |
| `/Users/josephwecker-v2/src/archema-io/vivarium/doc/toolchain.md` | Toolchain expectations around UDON docs |
| `/Users/josephwecker-v2/src/archema-io/TODO.md` | Program-level demand for Rust linters / decision-log tools once UDON tools land |
| `/Users/josephwecker-v2/src/archema-io/asf/msc/meta-process-review-2026-07-07/09-tooling-automation-capability-utilization-{findings,reflection}.md` | Process review of tooling utilization (adjacent friction) |
| `/Users/josephwecker-v2/src/archema-io/charter/concept-matrix.md` (if present as `.udon` or md) | Cross-program concept matrix — candidate future UDON host |

### 4d. Scenario corpus mirrors of live genres

`/Users/josephwecker-v2/src/udon/test/scenarios/corpus/` — see §3a; deliberate
rewrites of live genres for mutation safety.

---

## 5. Library / streaming / API surfaces (not “design/UX only”)

These encode **what host programs actually do with parse products**.

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/core/udon-core/src/lib.rs` | Dual API contract: streaming SAX-like + DOM tree |
| `/Users/josephwecker-v2/src/udon/core/udon-core/src/tree.rs` | Tree model consumers bind to |
| `/Users/josephwecker-v2/src/udon/core/udon-core/src/stream_tree.rs` | Streaming tree / chunky accumulation product |
| `/Users/josephwecker-v2/src/udon/core/udon-core/src/span.rs` | Span/location substrate for edit tools |
| `/Users/josephwecker-v2/src/udon/core/udon-core/src/parser.rs` | Generated event stream (supply side, but event *names* are the wire product hosts depend on) |
| `/Users/josephwecker-v2/src/udon/core/udon-core/src/parser_pd.rs` | Pushdown backend — streaming/performance product pressure |
| `/Users/josephwecker-v2/src/udon/core/udon-core/examples/stdin_parse.rs` | De facto CLI consumers use today |
| `/Users/josephwecker-v2/src/udon/core/udon-core/examples/gen_events.rs` | Fixture-YAML event dump half-CLI |
| `/Users/josephwecker-v2/src/udon/core/udon-core/examples/{tree_parse,simple_parse,show_formats,highlight}.rs` | Tree vs stream vs highlight entry points |
| `/Users/josephwecker-v2/src/udon/core/udon-core/tests/{stream_tree,tree_api,spans,boundaries,canonical}.rs` | Asserted product behaviors hosts will inherit |
| `/Users/josephwecker-v2/src/udon/core/fixtures/README.md` | Fixture profiles as consumer-facing “what compliance means” |
| `/Users/josephwecker-v2/src/udon/core/fixtures/v0.9/` (tree) | Current compliance product contract (event expectations) |
| `/Users/josephwecker-v2/src/udon/core/fixtures/exploratory/multi-line.yaml` | Open multi-line product questions |
| `/Users/josephwecker-v2/src/udon/core/fixtures/_wip/FINDINGS.md` | WIP fixture findings (edge needs) |
| `/Users/josephwecker-v2/src/udon/core/udon-wasm/src/` | WASM highlighting / autocolors for editor hosts |
| `/Users/josephwecker-v2/src/udon/core/README.md`, `…/AGENTS.md`, `…/CLAUDE.md` | How agents are told to treat core/compliance |

### 5a. Descent as meta-language consumer of UDON

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/core/generator/*.descent.udon` | Live machine-readable grammar units *written in UDON* — dogfood + dialect/embed needs |
| `/Users/josephwecker-v2/src/udon/tools/descent/SYNTAX.md` | Descent language surface |
| `/Users/josephwecker-v2/src/udon/tools/descent/implementation-spec.md` | Generator product requirements |
| `/Users/josephwecker-v2/src/udon/tools/descent/TODO-DESCENT.md` | Open descent tooling needs |
| `/Users/josephwecker-v2/src/udon/tools/descent/examples/*.desc` | Example grammars (incl. `udon_complete.desc`) |
| `/Users/josephwecker-v2/src/udon/tools/descent/rust/spikes/udon-reader/` | Spike reader for UDON-shaped descent |

---

## 6. Spec companions that pull product needs (not just law text)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/spec/CORE.md` | Authority — mine carefully for *host menus* (anomaly, duplicates, dialects reserved) rather than re-speccing |
| `/Users/josephwecker-v2/src/udon/spec/DYNAMICS.md` | Template/dynamics product surface (S4) |
| `/Users/josephwecker-v2/src/udon/spec/MARKDOWN.md` | Markdown layer product situations |
| `/Users/josephwecker-v2/src/udon/spec/TIME-SPEC.md` | Temporal dialect demand (111 live date attrs) |
| `/Users/josephwecker-v2/src/udon/spec/CORE-supplement.md` | Supplement material |
| `/Users/josephwecker-v2/src/udon/spec/msc/CHANGELOG.md` | Rulings ledger — *why* hosts got certain contracts |
| `/Users/josephwecker-v2/src/udon/spec/msc/adjudication-2026-07-paths-and-silences.md` | Path design forks + provisional syntax used by scenarios |
| `/Users/josephwecker-v2/src/udon/spec/msc/FULL-EBNF.md` | Illustration only — low priority; mark non-authority |

---

## 7. v2 `.archived/` — demand spikes & night spine (mine for *situations*, not pipeline ontology)

Whole orientation: `/Users/josephwecker-v2/src/udon/v2/.archived/INDEX.md`

### 7a. Demand-first spikes (highest value in archive)

| Path | Why |
|------|-----|
| `…/second-pass/spikes/DEMANDS.md` | Index into demand tables |
| `…/second-pass/spikes/paths/{NOTES.md,sketches.udon,README.md}` | D1–D9 boundary demands, sketches |
| `…/second-pass/spikes/agent-utility/{NOTES.md,README.md}` | P-A…P-H stage/products, edit, ornamental |
| `…/second-pass/spikes/memory-import/{FINDINGS.md,samples/}` | Session → memory MD import (S10) |
| `…/second-pass/spikes/session-vault/` | How session history was retrieved for mining |
| `…/second-pass/SCHEMA.md` | Night-spine schema product thoughts (demand-filter later) |
| `…/second-pass/OPEN-ML-STRAWMEN.md` | Old multi-line framings — archaeology for “what we thought hosts needed” |
| `…/second-pass/PROCESS-FEEDBACK.md` | Feedback on process that reoriented demand |

### 7b. Night spine (mostly supply — selective mine)

Treat as **secondary**: `PIPELINE.md`, `WIRE.md`, `SPEC.md`, `ADM.md`,
`PROCESS.md`, `HARNESS.md`, fixtures under `second-pass/fixtures/` — useful
when they name *products at boundaries*, dangerous if re-promoted as ontology.

### 7c. Greenfield / brownfield archives

| Path | Why |
|------|-----|
| `…/first-pass/brownfield/{BIG-PICTURE,DIRECTION,wire-value-model}*.md` | Pre-archive strategic framing of wire vs host |
| `…/first-pass/greenfield-*/new-spec/` | Clean-room product factorings (dialects/layers) — comparative |
| `…/first-pass/greenfield-3b/work/recognition-traces/` | Event-model expectations from recognition work |
| `…/first-pass/*/snippets/from-examples/` | Same examples as design/ — skip if already mapped |
| `…/first-pass/*/defining-udon.md` | Snapshot of defining philosophy during clean-rooms |

---

## 8. In-repo history / reboot archaeology

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/_archive/REVIEW-JULY-2026.md` | Estate review: defects → needs/tooling gaps history |
| `/Users/josephwecker-v2/src/udon/_archive/REBOOT-PLAN.md` | Reboot plan drained into lanes — original “what must exist” list |
| `/Users/josephwecker-v2/src/udon/_archive/DECIDED.bak.md` | Dense predecessor decisions |
| `/Users/josephwecker-v2/src/udon/_archive/FULL-SPEC-TODO.bak.md` | Pre-reboot full TODO ledger |
| `/Users/josephwecker-v2/src/udon/_archive/decisions-superseded/` (tree) | Identity, fences, value-dialects, typing briefs — **historical need arguments** |
| `/Users/josephwecker-v2/src/udon/_archive/feedback.md` | Early feedback deposit |
| `/Users/josephwecker-v2/src/udon/_archive/analysis.md` | Analysis notes |
| `/Users/josephwecker-v2/src/udon/_archive/HARNESS-AUDIT-2026-07.md` | Harness audit |
| `/Users/josephwecker-v2/src/udon/_archive/SPEC*.md`, `SPEC-UPDATE.md`, `SPEC-INDENTS.md` | Pre-CORE specs (round-trip / indent product history) |
| `/Users/josephwecker-v2/src/udon/_archive/implementation-*.md`, `parser-strategy.md` | Impl strategy friction |
| `/Users/josephwecker-v2/src/udon/_archive/eof-*.md`, `TODO-EOF-refactor.md` | EOF/unclosed product needs |
| `/Users/josephwecker-v2/src/udon/_archive/spikes/` | Prose-collision, explicit-stack feasibility |
| `/Users/josephwecker-v2/src/udon/_archive/udon-ruby/` | Archived Ruby gem + **conversion bins** (json/md/xml/yaml ⇄ udon) |
| `/Users/josephwecker-v2/src/udon/core/_archive/` | Parser-gen history (udon-c-era machines, phase notes) |

---

## 9. Older UDON lineages outside the umbrella (2011 → 2025)

### 9a. Original Ruby-era UDON project

Whole tree unit: `/Users/josephwecker-v2/src/_ref/udon/`

| Path | Why |
|------|-----|
| `…/README.asciidoc` | Original project framing |
| `…/doc/objectives.asciidoc` | Stated objectives (needs lineage) |
| `…/doc/features.asciidoc` | Feature intent |
| `…/doc/compare-to.asciidoc` | Competitive comparison needs |
| `…/doc/TODO.asciidoc` | Historical open wants |
| `…/doc/syntax.udon`, `…/doc/description.udon` | Self-describing early docs |
| `…/examples/*.udon` | Early usage examples |
| `…/bin/xml2udon`, `…/ruby/` | Interchange tooling lineage |

### 9b. udon-c (C library + tools)

Whole tree: `/Users/josephwecker-v2/src/_ref/udon-c/`

| Path | Why |
|------|-----|
| `…/docs/{DECIDED,NOTES,TODO}.md` | **Primary** early design decisions / notes / todos |
| `…/README`, `…/NEWS`, `…/ChangeLog` | Project narrative |
| `…/src/udon2xml.c`, `…/src/udon_introspect.c` | Introspection + conversion as first tools |
| `…/test/doc.udon` | Early fixture document |
| `…/lib/udon.h` | C API surface (library-consumer ancestor) |

### 9c. Standalone libudon / udon-ruby archives (pre-umbrella)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/_ref/libudon/README.md`, `…/PLAN.md`, `…/CLAUDE.md` | Pre-absorb Rust parser plan |
| `/Users/josephwecker-v2/src/_ref/libudon/udon-core/src/{lib,tree,span}.rs` | Earlier public API shape |
| `/Users/josephwecker-v2/src/_ref/udon-ruby/README.md` | Ruby binding consumer story |
| `/Users/josephwecker-v2/src/_ref/udon-ruby/bin/{json2udon,md2udon,udon2md,udon2xml,xml2udon,yaml2udon}` | **Full conversion matrix** as product demand evidence |

### 9d. Autocolors (semantic coloring lineage)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/_ref/autocolors/` (tree) | Full gem: fitness, mapping.udon, NOTES |
| `/Users/josephwecker-v2/src/udon/ux/autocolors/` | Live archaeology + PLAN |
| `/Users/josephwecker-v2/src/udon/ux/autocolors/archaeology-2011/` | 2011-era color fitness thinking |
| `/Users/josephwecker-v2/src/autopax/docs/exp/2025-12-20-autocolors-philosophy.md` | Later philosophy cross-link |

---

## 10. Editor / human UX implementations (product evidence)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/ux/obsidian-udon/` | Live Obsidian plugin (WASM) |
| `/Users/josephwecker-v2/src/udon/ux/tree-sitter-udon/` | Grammar + highlight queries + corpus tests |
| `/Users/josephwecker-v2/src/udon/ux/udon.tmLanguage.json` | TextMate grammar |
| `/Users/josephwecker-v2/src/udon/ux/vim/` | Vim syntax/ftdetect |
| `/Users/josephwecker-v2/src/udon/ux/README.md` | UX area orientation |

---

## 11. Schema / document-modeling “waiting customers” (overlap OK)

**Prefer originals over the already-written schema map**, but that map is a
good index: `…/sources-schema-versioning.md`.

### 11a. Rowan (formerly Archema Ruby)

High-value clusters (not exhaustive — see schema map for more):

| Path / unit | Why |
|-------------|-----|
| `/Users/josephwecker-v2/src/rowan/lib/archema/resource/versioning.rb` | Working schema_id/version/upcast DSL |
| `/Users/josephwecker-v2/src/rowan/lib/archema/schema/` (history, differ, decision_log, snapshot, operations, codegen, exports, watcher…) | Full schema-as-SSOT pipeline |
| `/Users/josephwecker-v2/src/rowan/lib/archema/resource/constraints.rb` | Constraint vocabulary |
| `/Users/josephwecker-v2/src/rowan/docs/dev/adr-003-document-schema-first.md` | Founding why for document-schema-first |
| `/Users/josephwecker-v2/src/rowan/docs/dev/adr-004-programmatic-schema-api.md` | Schema API shape |
| `/Users/josephwecker-v2/src/rowan/docs/usr/10-schema-evolution.md` | **User-need framing** of evolution |
| `/Users/josephwecker-v2/src/rowan/docs/usr/14-schema-api.md` | User guide for schema API |
| `/Users/josephwecker-v2/src/rowan/docs/exp/schema-evolution-patterns.md` | Empirical Rails migration patterns study |
| `/Users/josephwecker-v2/src/rowan/docs/exp/2025-12-03-schema-migration-and-versioning-in-ruby-domain-modeling.md` | Domain-modeling schema versioning notes |
| `/Users/josephwecker-v2/src/rowan/docs/msc/plan-{memory-store-versioning,document-schema-constraints,recursive-embedded-schemas,runtime-schema-evolution}.md` | Forward plans |
| `/Users/josephwecker-v2/src/rowan/docs/msc/feedback.md` | UDON-shaped schema sketch (Puzzle Piece 1) |
| `/Users/josephwecker-v2/src/rowan/docs/exp/path-centric-query-dsl.md` | Path query needs adjacent to UDON paths |
| `/Users/josephwecker-v2/src/rowan/docs/exp/expr-dsl-approaches.md` | Expression DSL approaches |
| `/Users/josephwecker-v2/src/rowan/docs/exp/domain-action-syntax-candidates.md` | Action syntax candidates |
| `/Users/josephwecker-v2/src/rowan/docs/sys/agentic/tool-export.md` | Resource → agent tool export |
| `/Users/josephwecker-v2/src/rowan/docs/usr/12-tool-export.md` | User-facing tool export |
| `/Users/josephwecker-v2/src/rowan/docs/dev/adr-002-dig-style-filter-paths.md` | Path/filter product |
| `/Users/josephwecker-v2/src/rowan/docs/sys/schema/` (tree) | Rendered schema subsystem docs |
| `/Users/josephwecker-v2/src/rowan/LEXICON.md` | Domain vocabulary |
| `/Users/josephwecker-v2/src/_ref/rails-migrations-survey/` | Empirical survey backing schema-evolution-patterns |

### 11b. Autopax (SIGNUM / YAML schema ADRs + live taxonomy)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/autopax/docs/ADR/002b-signum-schema.md` | Semver for documents / migrate tool |
| `/Users/josephwecker-v2/src/autopax/docs/ADR/008-yaml-and-schemas.md` | Schema API wishlist before rowan |
| `/Users/josephwecker-v2/src/autopax/docs/ADR/012-archema-resource-foundation.md` | Adopt rowan vs build own |
| `/Users/josephwecker-v2/src/autopax/docs/ADR/010-markdown-parsing-and-validation.md` | MD parse/validate needs |
| `/Users/josephwecker-v2/src/autopax/docs/exp/2025-12-03-schema-migration-and-versioning-in-ruby-domain-modeling.md` | Cross-posted with rowan lineage |
| `/Users/josephwecker-v2/src/autopax/sessions/2025-01-16-yaml-and-schemas-exploration.md` | Session on YAML/schemas |
| `/Users/josephwecker-v2/src/autopax/taxonomy.udon` | Live UDON consumer |
| `/Users/josephwecker-v2/src/autopax/agents/agentic-tooling-misc-notes.md` | Agentic tooling notes in-repo |
| `/Users/josephwecker-v2/src/autopax/docs/system-overview/instrumenta/` (tree) | Tool/instrumenta product surface |
| `/Users/josephwecker-v2/src/autopax/docs/system-overview/cli/` (tree) | CLI product surface |
| `/Users/josephwecker-v2/src/autopax/docs/exp/2025-11-15-ruby-cli-modern-practices-report.md` | CLI practices report |
| `/Users/josephwecker-v2/src/autopax/OPERATA.md`, `…/docs/exp/2025-11-26-operata-system.md` | Operata system thinking |

### 11c. Operata project

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/operata/docs/exp/2025-12-03-operata-storage-exploration.md` | Storage / document model |
| `/Users/josephwecker-v2/src/operata/docs/exp/2025-11-14-operata-principles.md` | Principles |
| `/Users/josephwecker-v2/src/operata/docs/exp/2025-11-26-operata-system.md` | System design |
| `/Users/josephwecker-v2/src/operata/docs/sys/` (tree) | Resource/views/cli surfaces |
| `/Users/josephwecker-v2/src/operata/idealized-project-model.md` | Idealized model |
| `/Users/josephwecker-v2/src/operata/advanced-projecet-model.md` | Advanced model (note filename typo) |
| Design examples in udon repo (`operata*.udon`) | Intended UDON surface for operata |

---

## 12. Agentic-tooling ideology (overlap OK — still list originals)

Full maps already exist under `agentic-tooling-sources/` and
`sources-agentic-tooling.md`. Below: **centers of mass + surprises** this pass
would not want lost.

### 12a. Sapientia / _core centers

| Path / unit | Why |
|-------------|-----|
| `/Users/josephwecker-v2/src/_core/sapientia/cli-conventions/` (full.md + per-topic siblings, esp. `ai-agent-considerations.md`, `mcp-and-advanced-ai-tool-usage.md`) | Comprehensive CLI-for-agents ideology |
| `/Users/josephwecker-v2/src/_core/sapientia/QUICK-TOOLING-CONVENTIONS.md` | Filtered “deterministic tools” tier |
| `/Users/josephwecker-v2/src/_core/sapientia/ai-conversation-system-requirements.md` | AI-facing system requirements |
| `/Users/josephwecker-v2/src/_core/sapientia/OPERATA.md` | Operata concept origin |
| `/Users/josephwecker-v2/src/_core/sapientia/minimal-*.md`, `MIN-SAPIENTIA-SPEC.md` | Minimal feature distillations |
| `/Users/josephwecker-v2/src/_core/ennaos/docs/research/agentic-coding-background/` (tree if present) | Flagged repeatedly as calibration corpus |
| `/Users/josephwecker-v2/src/_core/nexum/docs/dev/vision-agentic-toys.md` (+ quick-reference / comparison-matrix siblings) | Agentic toys vision |
| `/Users/josephwecker-v2/src/_core/zoetica/` OPERATA / tooling docs (see zoetica-ennaos map) | Parallel lineage |

### 12b. Harness consolidation / landscape

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/archema-io/harness/README.md` | What harness is consolidating |
| `/Users/josephwecker-v2/src/archema-io/harness/ai-cli-tools-*.md` | Landscape of shipping coding CLIs |
| `/Users/josephwecker-v2/src/archema-io/harness/CURRENT-THOUGHTS.md`, `lived.md` | Current steward thoughts |
| `/Users/josephwecker-v2/src/archema-io/harness/msc/system/agent-enhancement-anecdotes.md` | Corpus-mined agent teachings |
| `/Users/josephwecker-v2/src/archema-io/harness/msc/system/coding-system-prompt.draft.md` | Disposition for coding agents |
| `/Users/josephwecker-v2/src/archema-io/harness/msc/system/cc-context-tools.md` | Context tools surface |
| `/Users/josephwecker-v2/src/archema-io/harness/proprium/stalled-lineage/` | Sapientia/autopax/nexum OPERATA + requirements snapshots |
| `/Users/josephwecker-v2/src-ext/` (clone.log + OSS CLIs) | Fresh July-2026 CLI landscape clones (prior art for tool UX) |

### 12c. SAR (AI-first language) — surprise in `_ref`

| Path                                                                               | Why                               |
| ---------------------------------------------------------------------------------- | --------------------------------- |
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-applied-tst.md`                 | TST through agent cognition       |
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-tst-ideas-and-opportunities.md` | Tools-to-build list for agents    |
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-tst-vision.md`                  | Measurement philosophy            |
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/error-messages-plan.md`            | Errors that teach domain concepts |

---

## 13. Memory / session / vault corpora (durable docs only preferred; transcripts as pointers)

| Path / unit | Why |
|-------------|-----|
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/session-vault/` | Extracted Claude/Grok session material already staged for UDON work |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/memory-import/` | Import pipeline findings |
| `/Users/josephwecker-v2/src/memorata/` | Hybrid search index over Joseph’s writing + transcripts — **query surface**, not a single file |
| `/Users/josephwecker-v2/.grok/memory/udon-4fdadfea/` | Grok session memory for this repo (provenance for recent gather decisions) |
| `/Users/josephwecker-v2/src/_core/eli-migration-prep/to-review/` | Large jsonl session stash (noisy; search, don’t wholesale-mine) |
| `/Users/josephwecker-v2/src/tmp/udon.md` | Apr 2026 analysis of udon project (meta; flagged by elsewhere pass) |
| `/Users/josephwecker-v2/src/2026-02-18-long-conversation-emerson.txt` | Mentions udon/libudon estate layout in long-form context |

### 13a. Outside `~/src` — vaults (agent-tool ideology + possibly UDON mentions)

| Path / unit | Why |
|-------------|-----|
| `/Users/josephwecker-v2/vaults/gemini/archive/analysis-v1/analysis/**` | Book analyses with **“Practicability for AI Agents”** sections |
| `/Users/josephwecker-v2/vaults/gemini/analysis/pragmatic-programmer/` | Live analysis tree sibling |
| `/Users/josephwecker-v2/vaults/Operations/claude-code-tools.md` | Agent tool cheat-sheet |
| `/Users/josephwecker-v2/vaults/gemini/archive/AGENT_FIX_RECOMMENDATIONS.md` | Agent behavior fix recommendations |
| `/Users/josephwecker-v2/vaults/clean_split/tool-integration-via-model-context-protocol.md` | MCP integration patterns |
| `/Users/josephwecker-v2/vaults/Obsidian-Workflow/` | Vault automation / MCP notes (editor + agent workflow) |

---

## 14. Interchange, round-trip, and “host language” adjacent projects

| Path | Why |
|------|-----|
| Conversion bins under `_ref/udon-ruby/bin/` and `_archive/udon-ruby/bin/` | Explicit product matrix for S6 |
| `/Users/josephwecker-v2/src/udon/design/examples/mathml-to-latex.udon` etc. | Transform-as-document examples |
| `/Users/josephwecker-v2/src/vox/implementation-{options,plan}.md`, `…/uptake/PRODUCT.md` | Possible future host app; thin for UDON today but product-shaped |
| `/Users/josephwecker-v2/src/shoshin/03-tft-event-and-memory-schemas.md` | Event/memory schemas (tangential template/stream) |
| `/Users/josephwecker-v2/src/practica/docs/` + `…/ref/task-and-issue-tools-survey.md` | Coordination affordances / tool survey (process needs) |
| `/Users/josephwecker-v2/src/umi/docs/umi-autopax.md` | UMI↔autopax bridge notes |

---

## 15. Repo front doors / status (orientation for miners)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/README.md` | How work is organized; lane table |
| `/Users/josephwecker-v2/src/udon/Claude.md` | Agent ground rules; center of gravity note for v2 |
| `/Users/josephwecker-v2/src/udon/design/README.md` | Design status banners |

---

## 16. Intentionally lower priority (listed so we don’t re-discover as “missed”)

- Attribute-model proposal series under `design/attribute-model-*` — supply-side
  substrate debates already largely ratified into CORE 0.9.
- Pure parser implementation diaries under `core/_archive/generator/2025-12-*.md`
  unless mining *performance/streaming product* constraints.
- Greenfield fixture copies under `.archived/first-pass/*/snippets/from-fixtures/`
  — prefer live `core/fixtures/`.
- Quarantine extracts under `_quarantine/.../extracts/` — use originals.
- `firmatum/`, `eli/` homes, `ops/` publication portfolio — generally not
  UDON product needs (per elsewhere pass), unless a future search finds
  explicit UDON adoption plans.
- `semachrome/` at `~/src/semachrome` appears empty; content lives under
  `design/semachrome.md` + autocolors trees.

---

## 17. Gaps / next digs this pass did **not** finish

These are **prospective search trails**, not confirmed files:

1. **memorata3 / hybrid search queries** for: `udon-c`, `udon paths`,
   `schema-guarded edit`, `round-trip fixpoint`, `day in the life agents`,
   pre-2015 UDON objectives, Joseph ideation dumps not yet landed as files.
2. **Full `find` of `*.udon` under `~/src`** excluding `udon/`, `target/`,
   `_ref/libudon/target` — CONSUMERS.md claims six live docs; watch for
   new unregistered consumers (vivarium grows fast).
3. **`~/src/archema-io/harness/` consolidation of agentic-tooling** — check
   whether a dedicated `agentic-tooling/` subtree landed after the needs-map
   note (README still PROPRIUM-heavy as of this pass).
4. **Vaults search for “UDON” / “libudon”** — ideology is mapped; UDON-specific
   vault notes may still exist.
5. **Descent / time-spec as dialect precedent**:
   `core/generator/temporal-value.desc.setaside`, `spec/TIME-SPEC.md` + any
   standalone timespec grammar outside this repo.
6. **A2A / ACP external references** named in design docs but not re-opened
   here as third-party specs.
7. **Joseph’s incoming “end-user input + ideation dump”** called out in
   needs-map standing harvest — not present as a path yet; primary when it
   lands.

---

## 18. Suggested mining priority *bands* (opinionated, not a decision)

For reconcilers only — not a synthesis of needs:

1. **Situations with concrete journeys:** `test/scenarios/**`, live consumer
   docs + `ordinum.rs`, `TODO-UTILS` / `TOOLING-WISHLIST` / `TODO-AGENT-UX` /
   `TODO-AUX`, paths + agent-utility spikes §8.
2. **Waiting customers:** rowan schema evolution + constraints + tool-export;
   autopax SIGNUM/YAML ADRs; vivarium FORMAT/regula/toolchain.
3. **Empirical / historical friction:** usability enablement + AGENT_FEEDBACK
   (sampled); udon-c `docs/`; original `_ref/udon/doc/objectives`; conversion
   bins; CONSUMERS unused-feature surface.
4. **Ideology (how tools should feel):** sapientia cli-conventions,
   agentic-ux-principles, harness agent-enhancement anecdotes, SAR ai-* docs,
   vaults “Practicability for AI Agents.”
5. **Library product contracts:** core `lib/tree/stream_tree/span` + fixtures
   README + text-wire rulings.
6. **Selective archive / greenfield:** only where they name *caller products*
   or dissolve questions (ML sugar, inverse edit).

---

## 19. Feedback on this brief / pass (peer note)

- The brief’s **path-map-first, overlap-OK** shape is right; the quarantine of
  extract-heavy prior work was necessary — this pass deliberately stayed at
  paths.
- Highest surprise relative to “design/UX only” bias: **`test/scenarios/`**
  (already full multi-agent product language), **vivarium `ordinum.rs` hand
  parser**, **conversion bin matrix** in udon-ruby lineages, **udon-c
  docs/DECIDED+TODO**, and **rowan tool-export / path-centric query** as
  non-UDON-repo demand.
- Brief risk if any: “prospective sources” can still drift into listing
  *supply-side* spine files; §7b and §16 try to mark those explicitly so
  phase (2) can deprioritize without re-walking.

---

*End of sources-A.md — ready for reconciliation with other open-source-file
passes and the existing agentic/schema maps.*

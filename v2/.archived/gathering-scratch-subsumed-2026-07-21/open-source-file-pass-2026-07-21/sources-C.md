---
pass: open-source-file-pass-2026-07-21
agent: Grok (sources-C)
date: 2026-07-21
status: path map only — no extracts, no needs synthesis
posture: inclusive; overlap with other gatherers welcome; prefer listing when unsure
scope: prospective sources for end-user / agent / library-consumer needs around UDON
       and the eventual Parsing Framework (not supply-side architecture first)
method: filesystem walk of udon repo + ~/src consumers + _ref historical +
        related tooling trees; spot-reads for provenance only
not treated as coverage: 01-ideation/_quarantine/ (prior over-constrained pass)
---

# Sources-C — prospective mining spots (phase 1 gathering)

**What this is.** Candidate **paths** (files or whole subtrees as units) where
needs, usage situations, tool desires, consumer friction, schema/path/template/
edit/stream ideas, etc. might live. Short *why* + *provenance* when known.
Later passes open and mine; this pass does not copy bodies or synthesize needs.

**How to use.** Absolute paths. Section order is geography, not priority.
Duplicates vs `sources-schema-versioning.md`, `sources-agentic-tooling.md`,
quarantined Grok maps, etc. are **fine** — reconcile later.

**Deliberate biases of this pass (on purpose):**
- Not design/UX-only — historical UDON, converters, fixtures, library APIs,
  live Rust consumers, conversion pipelines, session vaults, program TODOs.
- Trees listed as units when the whole folder is the natural mining grain.
- Prefer inclusion of *adjacent* document genres (YAML frontmatter agents,
  Ash/resource DSLs, markdown process maps) that shape what UDON is asked to
  replace or host.

---

## 0. Orientation / deliberation (meta, still demand-shaped)

| Path | Why it might matter | Provenance |
|------|---------------------|------------|
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/README.md` | Flow (1)–(8); what “demand-side” means for this work | Live v2 home |
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/pipeline-discussion.md` | Primary deliberation: fold → accumulation → demand inversion → archive → reseed; Joseph sampling list (~S1–S12 texture) | Relocated into udon-needs |
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/01-ideation/needs-map.md` | Seed situations S1–S12 + standing harvest queue | Fable reseed 2026-07-21 |
| `/Users/josephwecker-v2/src/udon/v2/DECISIONS.md` | Present-truth pins that *constrain* needs work (sufficiency W0, multi-line WAIT-DEMAND, etc.) — not a needs dump but boundary conditions | Graduated from night spine |
| `/Users/josephwecker-v2/src/udon/v2/OPEN.md` | Explicit WAIT-DEMAND rows + pointers into demand spikes | Same |
| `/Users/josephwecker-v2/src/udon/v2/README.md` | v2 center-of-gravity map | Live |
| `/Users/josephwecker-v2/src/udon/defining-udon.md` | Spec/pedagogy philosophy — shapes *how* needs become docs, less *what* needs are | Project standard |
| `/Users/josephwecker-v2/src/udon/README.md` | How work is organized; compliance/target table; propagation order | Front door |

---

## 1. Live UDON documents (actual consumers)

Registry of record: `/Users/josephwecker-v2/src/udon/CONSUMERS.md` (scan
2026-07-16). Each live `.udon` is a usage situation, not just syntax evidence.

### 1a. Registry + re-scan tooling

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/udon/CONSUMERS.md` | Live inventory, exposure counts, unused-feature surface, migration triggers, **candidate future consumers** list (ADRs, Axiomata, Signa, Operata, Memorata, A2A, mentoring, Loci…) | Maintained with `bin/find-consumers` |
| `/Users/josephwecker-v2/src/udon/bin/find-consumers` | How consumers are discovered/diffed — implies CI/steward tool needs | Repo tooling |

### 1b. Vivarium (heaviest live corpus)

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/archema-io/vivarium/DECISIONS.decision-log.udon` | Append-only decision log; densest `[key]` + date attrs; concurrent multi-agent growth | Live; CONSUMERS top exposure |
| `/Users/josephwecker-v2/src/archema-io/vivarium/LEXICON.udon` | Dictionary genre: slug identity, status, relations, raw `!:md:` tables | Live |
| `/Users/josephwecker-v2/src/archema-io/vivarium/doc/PROCESS.udon` | Process norms in UDON; **safe-subset** authoring contract; real sigil-promotion field bug | Live |
| `/Users/josephwecker-v2/src/archema-io/vivarium/tabularium/terrestris.ordinum.udon` | Machine-read law-data (phases/charges/promises); schema-by-filename pattern | Live tabularium |
| `/Users/josephwecker-v2/src/archema-io/vivarium/tabularium/README.md` | Conventions: `name.root-type.udon`, version in attrs, parse via `stdin_parse` until CLI | Tabularia discipline |
| `/Users/josephwecker-v2/src/archema-io/vivarium/FORMAT.md` | Cross-doc path schemes into LEXICON/DECISIONS; authoring format contract | Consumer format law |
| `/Users/josephwecker-v2/src/archema-io/vivarium/CLAUDE.md` | How agents are told to *use* the .udon corpus day-to-day | Agent operating surface |
| `/Users/josephwecker-v2/src/archema-io/vivarium/doc/toolchain.md` | Toolchain expectations around structured docs / generators | Ops-adjacent |
| `/Users/josephwecker-v2/src/archema-io/vivarium/doc/plan/regula-conformance-design.md` | Upcoming `.regula.udon` profiles; ordinum pin story; conformance rigor | Planned second artifact type |
| `/Users/josephwecker-v2/src/archema-io/vivarium/crates/vivarium-world/src/ordinum.rs` | **Hand parser** of ordinum.udon awaiting libudon — pure library-consumer demand | Runtime load path |
| `/Users/josephwecker-v2/src/archema-io/vivarium/core-segment-candidates-2026-07-14.md` | Mentions udon-safe-subset, tabularium conventions, tooling-lift decision open | Segment inventory (meta) |
| `/Users/josephwecker-v2/src/archema-io/vivarium/feedback-from-asf.md` | Cross-project tooling/process feedback (includes tooling-lift) | ASF↔vivarium bridge |

### 1c. ASF process map

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/archema-io/asf/msc/meta-process-review-2026-07-07/PROCESS-MAP-v0.udon` | Founding adopter process-map genre (MECE, health/drain tags) | CONSUMERS |
| `/Users/josephwecker-v2/src/archema-io/asf/msc/meta-process-review-2026-07-07/` *(tree)* | Findings/reflections around that process map; process-tool needs | 2026-07-07 review pack |
| `/Users/josephwecker-v2/src/archema-io/asf/msc/meta-process-review-2026-07-07/SESSION-LOG-2026-07-14.md` | Session that produced/used the map | Session log |

### 1d. Autopax

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/autopax/taxonomy.udon` | Nested taxonomy; multi-value attrs (0.8→0.9 meaning fix on `:authors`) | Live CONSUMERS |
| `/Users/josephwecker-v2/src/autopax/TAXONOMY.md` | Markdown twin/context for taxonomy.udon | Sibling |

### 1e. Scenario corpus (day-in-the-life demand scripts)

Whole tree is a unit:

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/udon/test/scenarios/README.md` | Explains understand/diff/modify/multi-agent scenario intent | Scenario harness |
| `/Users/josephwecker-v2/src/udon/test/scenarios/features/01-understanding.scenarios.udon` | Agent “understand document” situations | Features |
| `/Users/josephwecker-v2/src/udon/test/scenarios/features/02-diffing.scenarios.udon` | Diff / compare situations | Features |
| `/Users/josephwecker-v2/src/udon/test/scenarios/features/03-modifying.scenarios.udon` | Patch / modify situations (span-minimal, fail-loudly texture) | Features |
| `/Users/josephwecker-v2/src/udon/test/scenarios/features/04-multi-agent.scenarios.udon` | Concurrent multi-agent edit | Features |
| `/Users/josephwecker-v2/src/udon/test/scenarios/corpus/` *(tree)* | Snapshots of live-ish docs used as scenario substrate | `archema.concept-matrix.udon`, `asf-processes…`, `operata*`, `terrestris…`, `vivarium.*` |

### 1f. Program-level “want UDON tooling” statements

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/archema-io/TODO.md` | archterm YAML→udon; Rust linters on udon-core; DECISIONS.decision-log.udon for program; “agentic udon tooling within days” | Program TODO 2026-07-16 |
| `/Users/josephwecker-v2/src/archema-io/CHARTER-DRAFT.md` | Cross-repo program shape; may imply shared doc formats | Program charter |
| `/Users/josephwecker-v2/src/archema-io/charter/concept-matrix.md` | Cross-member concepts — candidate for structured (udon) representation | Charter |

---

## 2. In-repo design of record (UDON-specific product wishes)

Not “the architecture of the parser” — surfaces that name *what users/agents
want to do*. Overlap with quarantine extracts expected.

### 2a. Agent / tool / guarantee surfaces

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/udon/design/udon-agentic.md` | Design of record for agent tool suite (glance/focus/propose/apply/…) | Jan 2026; ~full doc |
| `/Users/josephwecker-v2/src/udon/design/UDON-AGENT-TOOLS.md` | Dec brainstorm; Tier-1 **merge** idea not fully absorbed above | Dec 2025 residue |
| `/Users/josephwecker-v2/src/udon/design/agentic-ux-principles.md` | WHY layer for agent tools (principles P*); re-derive tools against this | 2026-07-16 |
| `/Users/josephwecker-v2/src/udon/design/AGENT-CONTEXT-PROTOCOL.md` | Agent friction phenomenology; propose/validate/apply | Design |
| `/Users/josephwecker-v2/src/udon/design/UDON-AS-ACP-FORMAT.md` | UDON as agent-communication format | Design |
| `/Users/josephwecker-v2/src/udon/design/udon-guarantees.md` | What guarantees tools can offer (schema, indent, gatekeeper problem) | Design |
| `/Users/josephwecker-v2/src/udon/design/GRAMMAR-CONSTRAINED-GENERATION.md` | Guaranteed-valid generation for local models | Design |
| `/Users/josephwecker-v2/src/udon/design/positioning.md` | Product positioning → implied use cases | Design |
| `/Users/josephwecker-v2/src/udon/design/semachrome.md` | Semantic coloring / autocolors philosophy bridge | Design |

### 2b. Paths / AST / schema / examples (demand-facing)

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/udon/design/udon-paths.md` | Stale spelling; surviving at/all / path ideas — input only for path redesign | Design (flagged stale in TODO-AUX) |
| `/Users/josephwecker-v2/src/udon/design/udon-ast.md` | Skeleton paths, SourceInfo, streaming fragments, document map | Design |
| `/Users/josephwecker-v2/src/udon/design/schema-notes-2026-07.md` | Forming schema design note (surfaces, freezes, forks) | 2026-07 |
| `/Users/josephwecker-v2/src/udon/design/schema-workbench-2026-07.md` | Survey index into rowan + corpus; “first waiting customer” | 2026-07 |
| `/Users/josephwecker-v2/src/udon/design/udon-schema-exploration.md` | Older single-source-of-truth schema vision | Earlier exploration |
| `/Users/josephwecker-v2/src/udon/design/file-naming.md` | `name.type.udon` designators — application semantics | Design |
| `/Users/josephwecker-v2/src/udon/design/composite-types.md` | Type composition needs | Design |
| `/Users/josephwecker-v2/src/udon/design/markdown-layers.md` | Markdown-as-layer situations | Design |
| `/Users/josephwecker-v2/src/udon/design/desc-design-principles.md` | Descent grammar authoring principles (dialect author needs) | Design |
| `/Users/josephwecker-v2/src/udon/design/examples/` *(tree)* | Usage genres implying tools: `schema-dsl.udon`, `ash-like-*.udon`, `operata-*.udon`, `practices-gotchas.udon`, `cheatsheet.udon`, `archema-operata.udon`, docbook/mathml round-trip sketches | Example corpus |
| `/Users/josephwecker-v2/src/udon/design/README.md` | Status banners for which design docs are superseded | Design index |

### 2c. Wishlists / TODO lanes (open demand, not closed work)

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/udon/TOOLING-WISHLIST.md` | Joseph felt needs while coding: events dump, ast, roundtrip, fmt, to-json | 2026-07-19 scratch |
| `/Users/josephwecker-v2/src/udon/TODO-UTILS.md` | Accessors, serializer, skeleton view, **udon guard** file-watcher, value coercion, mixin expansion | Root utils lane |
| `/Users/josephwecker-v2/src/udon/ux/TODO-AGENT-UX.md` | Cheat-sheets, usability harness rebuild, agentic suite, GCG; **edit tool critical path** quote | Agent UX lane |
| `/Users/josephwecker-v2/src/udon/ux/TODO-HUMAN-UX.md` | Obsidian edit, soft-wrap hanging indent, LSP tokens, tree-sitter keep-or-not | Human UX lane |
| `/Users/josephwecker-v2/src/udon/spec/TODO-AUX.md` | Path syntax + schema syntax as critical path; `@{…}` embed driver; rowan-as-customer | Spec aux lane |
| `/Users/josephwecker-v2/src/udon/spec/TODO-SPEC-OTHER.md` | Non-core open items (pragma/schema bind likely) | Spec lane |
| `/Users/josephwecker-v2/src/udon/spec/TODO-TEXT-WIRE.md` | Text reconstruction contract (round-trip need) | Spec lane |
| `/Users/josephwecker-v2/src/udon/spec/TODO-SPEC-CORE.md` | Open core spec gaps that still block user-facing clarity | Spec lane |
| `/Users/josephwecker-v2/src/udon/TODO-META.md` | Literate fusion / meta process | Meta |
| `/Users/josephwecker-v2/src/udon/TODO-PUBLISHING.md` | Publish surfaces (crate names, consumers of releases) | Publishing |
| `/Users/josephwecker-v2/src/udon/core/TODO-CORE-PARSING.md` | Parser residuals — when user-facing (spans, empty-node) | Core |
| `/Users/josephwecker-v2/src/udon/core/TODO-PARSER.md` | Parser track | Core |
| `/Users/josephwecker-v2/src/udon/spec/msc/adjudication-2026-07-paths-and-silences.md` | Path design forks packet (positional identity, embeddability) | Spec msc |

---

## 3. UX implementations (what people already run)

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/udon/ux/obsidian-udon/` *(tree)* | Live Obsidian plugin; edit/highlight friction | Shipping UX |
| `/Users/josephwecker-v2/src/udon/ux/autocolors/` *(tree)* | Semantic color mapping; PLAN.md | UX + archaeology |
| `/Users/josephwecker-v2/src/udon/ux/autocolors/archaeology-2011/` *(tree)* | 2011 autocolors (incl. `mapping.udon`) — long lineage of “semantic color from structure” | Historical |
| `/Users/josephwecker-v2/src/udon/ux/tree-sitter-udon/` *(tree)* | Editor grammar spike; fill/`gq` claim | Experimental |
| `/Users/josephwecker-v2/src/udon/ux/udon.tmLanguage.json` | TextMate grammar consumer | Editor |
| `/Users/josephwecker-v2/src/udon/ux/vim/` *(tree)* | Vim syntax/ftdetect | Editor |
| `/Users/josephwecker-v2/src/udon/ux/README.md` | UX area map | Index |
| `/Users/josephwecker-v2/src/udon/core/udon-wasm/` *(tree)* | Highlight + autocolors engine for Obsidian | Core→UX bridge |
| `/Users/josephwecker-v2/src/udon/core/udon-core/examples/highlight.rs` | ANSI highlight = span-fidelity audit | Example tool |
| `/Users/josephwecker-v2/src/_ref/autocolors/` *(tree)* | Standalone historical autocolors gem (fitness, mapping.udon) | `_ref` clone |

---

## 4. Library / wire / fixture surfaces (consumer-of-parser needs)

These are supply-side *code*, but they encode real I/O contracts agents and
libraries need (stream vs tree, events dump, compliance YAML as “what must be
observable”).

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/udon/core/udon-core/src/lib.rs` | Public crate surface | API |
| `/Users/josephwecker-v2/src/udon/core/udon-core/src/tree.rs` | Tree API ergonomics | API |
| `/Users/josephwecker-v2/src/udon/core/udon-core/src/stream_tree.rs` | Streaming tree / chunky consumption | API |
| `/Users/josephwecker-v2/src/udon/core/udon-core/src/parser_pd.rs` | Pushdown/incremental (re-highlight, partial input) | API |
| `/Users/josephwecker-v2/src/udon/core/udon-core/examples/stdin_parse.rs` | What stewards use today for consumer docs | De-facto CLI |
| `/Users/josephwecker-v2/src/udon/core/udon-core/examples/gen_events.rs` | Event→YAML fixture path | Tooling half-built |
| `/Users/josephwecker-v2/src/udon/core/udon-core/examples/show_formats.rs` | Format enumeration | Example |
| `/Users/josephwecker-v2/src/udon/core/udon-core/tests/stream_tree.rs` | Streaming behavior expectations | Tests |
| `/Users/josephwecker-v2/src/udon/core/fixtures/v0.9/` *(tree)* | Active compliance expectations (what “correct” means for tools) | Gate |
| `/Users/josephwecker-v2/src/udon/core/fixtures/v0.8/` *(tree)* | Frozen oracle group | Gate |
| `/Users/josephwecker-v2/src/udon/core/fixtures/exploratory/multi-line.yaml` | Open multi-line behavior exploration | Exploratory |
| `/Users/josephwecker-v2/src/udon/core/fixtures/_wip/FINDINGS.md` | WIP fixture findings | Core |
| `/Users/josephwecker-v2/src/udon/core/fixtures/README.md` | Fixture discipline | Core |
| `/Users/josephwecker-v2/src/udon/core/generator/*.descent.udon` *(set)* | Machine grammar (also GCG substrate; dialect-as-grammar precedent) | Generated parser source |
| `/Users/josephwecker-v2/src/udon/core/generator/temporal-value.desc.setaside` | Set-aside temporal dialect grammar | Dialect archaeology |
| `/Users/josephwecker-v2/src/udon/bin/xml2udon` | Conversion entrypoint at repo root | Converter |

---

## 5. Spec companions (dialects / dynamics / time / markdown situations)

Authority is CORE, but companions name **user situations** dialects must serve.

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/udon/spec/CORE.md` | Authoritative language law (what tools must respect) | Spec |
| `/Users/josephwecker-v2/src/udon/spec/CORE-supplement.md` | Supplement | Spec |
| `/Users/josephwecker-v2/src/udon/spec/DYNAMICS.md` | Templates / dynamics user situations | Companion (status banner) |
| `/Users/josephwecker-v2/src/udon/spec/MARKDOWN.md` | Markdown layer situations | Companion |
| `/Users/josephwecker-v2/src/udon/spec/TIME-SPEC.md` | Temporal dialect situations (111 live date attrs wait here) | Companion |
| `/Users/josephwecker-v2/src/udon/spec/msc/CHANGELOG.md` | Rulings ledger — why consumers migrated; anomaly posture | Spec history |
| `/Users/josephwecker-v2/src/udon/spec/msc/FULL-EBNF.md` | Illustration only — not authority; may still seed pedagogy needs | Demoted |

---

## 6. Archived demand spikes & night-spine archaeology (v2)

**Mine for demand tables; do not re-adopt archived pipeline ontology as law.**

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/udon/v2/.archived/INDEX.md` | Map of first-pass vs second-pass archives | Index |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/DEMANDS.md` | Index into demand tables | Night spine |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/agent-utility/NOTES.md` | P-A…P-H boundary demands (edit tool, partial-doc, ornamental…) | Spike |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/agent-utility/README.md` | Spike framing | Spike |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/paths/NOTES.md` | D1–D9 path boundary demands | Spike |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/paths/sketches.udon` | Path syntax sketches | Spike |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/paths/README.md` | Framing | Spike |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/memory-import/FINDINGS.md` | Memory/corpus import as document substrate (S10) | Spike |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/memory-import/samples/` *(tree)* | Sample memory-import shape | Spike |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/session-vault/README.md` | How to retrieve session history | Vault tooling |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/session-vault/raw/claude/` *(tree)* | Claude sessions on UDON (orient, greenfield, Obsidian, process-map conversion…) | Vault extract |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/session-vault/raw/grok/` *(tree)* | Grok sessions (exploration, greenfield-3b, v2-spec night, memory-import) | Vault extract |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/SCHEMA.md` | Night-spine schema chapter — demand residue even if ontology discarded | Archived |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/PIPELINE.md` | Stage ontology archaeology (what was *guessed* before demand) | Archived |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/PROCESS.md` | Process norms from night | Archived |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/PROCESS-FEEDBACK.md` | Feedback on process | Archived |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/OPEN-ML-STRAWMEN.md` | Multi-line strawmen (reframed as possibly dissolved) | Archived |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/HARNESS.md` | Fixture/harness product needs | Archived |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/WIRE.md` | Wire product needs | Archived |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/ADM.md` | Assembly product needs | Archived |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/SEMANTICS.md` | Semantic product claims | Archived |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/WARNING-CODES.md` | User/tool-visible diagnostics taxonomy | Archived |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/dialects/README.md` | Dialect layer framing | Archived |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/pedagogy/OUTLINE.md` | Teaching product needs | Archived |
| `/Users/josephwecker-v2/src/udon/v2/.archived/first-pass/brownfield/BIG-PICTURE-2026-07-20.md` | Pre-archive big picture | Brownfield |
| `/Users/josephwecker-v2/src/udon/v2/.archived/first-pass/brownfield/DIRECTION-2026-07-19.md` | Direction after wire deratification | Brownfield |
| `/Users/josephwecker-v2/src/udon/v2/.archived/first-pass/brownfield/wire-value-model-2026-07.md` | Value model deliberation | Brownfield |
| `/Users/josephwecker-v2/src/udon/v2/.archived/first-pass/greenfield-*/feedback-*.md` | Multi-substrate feedback on re-specs (grok/gemini/fable) — may surface user-clarity needs | Greenfields 2a/3a/3b |
| `/Users/josephwecker-v2/src/udon/v2/.archived/first-pass/greenfield-*/agents-thoughts.md` | Agent thoughts during clean-room | 3a/3b |
| `/Users/josephwecker-v2/src/udon/v2/.archived/first-pass/greenfield-3b/new-spec/dialects/` *(tree)* | Clean-room dialect packaging experiment | 3b |
| `/Users/josephwecker-v2/src/udon/v2/.archived/first-pass/greenfield-3b/work/` *(tree)* | Crosscheck, inventory, recognition traces | 3b work |

---

## 7. Repo `_archive/` (estate review, converters, old decisions)

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/udon/_archive/REVIEW-JULY-2026.md` | Estate review + evidence; defect genealogy (historical friction) | 2026-07 reboot |
| `/Users/josephwecker-v2/src/udon/_archive/REBOOT-PLAN.md` | What was planned post-review (drained into lanes; residue) | Reboot |
| `/Users/josephwecker-v2/src/udon/_archive/DECIDED.bak.md` | Dense predecessor decisions ledger | Pre-reboot |
| `/Users/josephwecker-v2/src/udon/_archive/FULL-SPEC-TODO.bak.md` | Old full-spec TODO | Pre-reboot |
| `/Users/josephwecker-v2/src/udon/_archive/feedback.md` | Feedback corpus | Archive |
| `/Users/josephwecker-v2/src/udon/_archive/analysis.md` | Analysis notes | Archive |
| `/Users/josephwecker-v2/src/udon/_archive/implementation-status.md` | Historical impl status | Archive |
| `/Users/josephwecker-v2/src/udon/_archive/parser-strategy.md` | Strategy notes | Archive |
| `/Users/josephwecker-v2/src/udon/_archive/HARNESS-AUDIT-2026-07.md` | Harness/fixture product audit | Archive |
| `/Users/josephwecker-v2/src/udon/_archive/decisions-superseded/` *(tree)* | Identity, fences, value-dialects briefs — *why* old user-facing choices moved | Superseded briefs |
| `/Users/josephwecker-v2/src/udon/_archive/spikes/README.md` | Per-spike status map | Archive spikes |
| `/Users/josephwecker-v2/src/udon/_archive/spikes/prose-collision-2026-07.md` | Prose collision product concern | Spike |
| `/Users/josephwecker-v2/src/udon/_archive/spikes/explicit-stack-feasibility-2026-07.md` | Stack model feasibility | Spike |
| `/Users/josephwecker-v2/src/udon/_archive/eof-model-proposal-2026-07.md` | EOF user/recovery model | Proposal |
| `/Users/josephwecker-v2/src/udon/_archive/udon-ruby/` *(submodule tree)* | Ruby gem + **converters**: `json2udon`, `md2udon`, `udon2md`, `udon2xml`, `xml2udon`, `yaml2udon` — round-trip product demand | Archived submodule |
| `/Users/josephwecker-v2/src/udon/_archive/lib/udon_validator.rb` | Old Ruby validator (non-authoritative; shows validation *desire*) | Archive |
| `/Users/josephwecker-v2/src/udon/core/_archive/PARSER-GEN-HISTORY.md` | Parser generator history / user of descent | Core archive |
| `/Users/josephwecker-v2/src/udon/core/_archive/generator/` *(tree)* | genmachine eras, session notes Dec 2025 | Core archive |

---

## 8. Historical UDON projects (`_ref/`) — oldest demand DNA

These predate the umbrella; still the earliest statement of utility goals.

### 8a. Classic `_ref/udon` (asciidoc era)

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/_ref/udon/doc/objectives.asciidoc` | **Explicit priority matrix**: beauty/readability, templating, language mixing, in-doc schema, include/layout, performance | Very early |
| `/Users/josephwecker-v2/src/_ref/udon/doc/features.asciidoc` | Feature list as product claims | Early |
| `/Users/josephwecker-v2/src/_ref/udon/doc/description.udon` | Self-description in UDON | Early |
| `/Users/josephwecker-v2/src/_ref/udon/doc/syntax.udon` | Syntax as document | Early |
| `/Users/josephwecker-v2/src/_ref/udon/doc/TODO.asciidoc` | Early TODOs | Early |
| `/Users/josephwecker-v2/src/_ref/udon/doc/compare-to.asciidoc` | Competitive/compare positioning | Early |
| `/Users/josephwecker-v2/src/_ref/udon/examples/overview.udon` | Overview example | Early |
| `/Users/josephwecker-v2/src/_ref/udon/examples/ws-and-comments.udon` | Whitespace/comment examples | Early |
| `/Users/josephwecker-v2/src/_ref/udon/README.asciidoc` | Project pitch | Early |
| `/Users/josephwecker-v2/src/_ref/udon/bin/xml2udon` | Conversion need from day one | Early |
| `/Users/josephwecker-v2/src/_ref/udon/misc/udon.vim` | Editor need from day one | Early |

### 8b. udon-c era

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/_ref/udon-c/docs/DECIDED.md` | Early decisions | udon-c |
| `/Users/josephwecker-v2/src/_ref/udon-c/docs/NOTES.md` | Working notes (include/config sketches, node model) | udon-c |
| `/Users/josephwecker-v2/src/_ref/udon-c/docs/TODO.md` | Early TODOs | udon-c |
| `/Users/josephwecker-v2/src/_ref/udon-c/README` | Project pitch | udon-c |
| `/Users/josephwecker-v2/src/_ref/udon-c/test/doc.udon` | Sample document | udon-c |
| `/Users/josephwecker-v2/src/_ref/udon-c/src/udon2xml.c` | Convert-out need | udon-c |
| `/Users/josephwecker-v2/src/_ref/udon-c/src/udon_introspect.c` | Introspection tool desire | udon-c |
| `/Users/josephwecker-v2/src/_ref/udon-c/lib/templates/udon.machine` | State-machine grammar as authoring form | genmachine |

### 8c. libudon archive (pre-umbrella absorption)

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/_ref/libudon/PLAN.md` | Pre-umbrella plan | Archived libudon |
| `/Users/josephwecker-v2/src/_ref/libudon/README.md` | Pitch | Archived |
| `/Users/josephwecker-v2/src/_ref/libudon/CLAUDE.md` | Spec-is-ground-truth discipline (process need for agents working *on* UDON) | Archived |
| `/Users/josephwecker-v2/src/_ref/libudon/examples/` *(tree)* | Early examples | Archived |
| `/Users/josephwecker-v2/src/_ref/libudon/udon-core/tests/fixtures/` *(tree)* | Pre-0.8 fixture shapes | Archived |
| `/Users/josephwecker-v2/src/_ref/udon-ruby/README.md` | Ruby binding product surface | Archived |
| `/Users/josephwecker-v2/src/_ref/udon-ruby/bin/` *(tree)* | Converter suite (same names as umbrella archive) | Archived |

---

## 9. Descent (parser-generator) — dialect-author / library-consumer sibling

Descent is both infrastructure *and* a waiting customer for path/schema/dialect
story (grammars as structured docs; `*.descent.udon` already in udon).

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/udon/tools/descent/README.md` | What descent is for | Submodule |
| `/Users/josephwecker-v2/src/udon/tools/descent/SYNTAX.md` | Grammar-author UX | Submodule |
| `/Users/josephwecker-v2/src/udon/tools/descent/TODO-DESCENT.md` | Open descent product needs | Submodule |
| `/Users/josephwecker-v2/src/udon/tools/descent/implementation-spec.md` | Impl contract | Submodule |
| `/Users/josephwecker-v2/src/udon/tools/descent/examples/` *(tree)* | Grammar examples incl. `udon_complete.desc` | Examples |
| `/Users/josephwecker-v2/src/udon/tools/descent/rust/spikes/udon-reader/NOTES.md` | Udon-reader spike notes | Spike |
| `/Users/josephwecker-v2/src/udon/tools/descent/rust/spikes/normalizations/NOTES.md` | Normalization product concerns | Spike |
| `/Users/josephwecker-v2/src/descent/` *(tree)* | Standalone clone (may drift from submodule) — same files | Sibling repo |
| `/Users/josephwecker-v2/src/udon/design/descent-experience-2026-07.md` | Author experience of writing descent | Design |

---

## 10. December 2025 usability corpus (empirical agent friction)

Stale vs current CORE, still evidence of *situations* agents fail at.

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/udon/test/usability/enablement-synthesis.md` | Synthesis of enablement tests | Dec 2025 |
| `/Users/josephwecker-v2/src/udon/test/usability/results/AGENT_FEEDBACK.md` | Aggregated agent feedback (large/noisy) | Dec 2025 |
| `/Users/josephwecker-v2/src/udon/test/usability/ETHICS.md` | Ethics of usability runs | Harness |
| `/Users/josephwecker-v2/src/udon/test/usability/lib/` *(tree)* | Test definitions (topic_enablement, realistic, validated…) | Harness code |
| `/Users/josephwecker-v2/src/udon/test/usability/results/` *(yaml tree)* | Per-run evidence — sample, don’t bulk-mine | Results |

---

## 11. Schema-versioning / resource-DSL world (rowan · autopax · operata)

**Primary dedicated map already exists:**  
`/Users/josephwecker-v2/src/udon/v2/udon-needs/01-ideation/sources-schema-versioning.md`  
Below is a **compact high-signal re-list** (overlap intentional) plus a few
extras this pass noticed.

### 11a. Rowan (first waiting schema customer)

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/rowan/lib/archema/resource/versioning.rb` | schema_id/version, upcast, since/deprecated | Core mechanism |
| `/Users/josephwecker-v2/src/rowan/lib/archema/schema/` *(tree)* | history, differ, decision_log, snapshot, operations, codegen, export… | Schema subsystem |
| `/Users/josephwecker-v2/src/rowan/docs/sys/schema/` *(tree)* | Human docs for schema subsystem | sys docs |
| `/Users/josephwecker-v2/src/rowan/docs/usr/10-schema-evolution.md` | User guide: schema evolution | usr docs |
| `/Users/josephwecker-v2/src/rowan/docs/usr/14-schema-api.md` | Programmatic schema API | usr docs |
| `/Users/josephwecker-v2/src/rowan/docs/dev/adr-003-document-schema-first.md` | Document-schema-first ADR | ADR |
| `/Users/josephwecker-v2/src/rowan/docs/dev/adr-002-dig-style-filter-paths.md` | Path/query style for resources | ADR — path needs |
| `/Users/josephwecker-v2/src/rowan/docs/dev/adr-004-programmatic-schema-api.md` | Schema API ADR | ADR |
| `/Users/josephwecker-v2/src/rowan/docs/exp/schema-evolution-patterns.md` | Evolution patterns research | exp |
| `/Users/josephwecker-v2/src/rowan/docs/exp/2025-12-03-schema-migration-and-versioning-in-ruby-domain-modeling.md` | Migration/versioning deep dive | exp |
| `/Users/josephwecker-v2/src/rowan/docs/exp/path-centric-query-dsl.md` | Path-centric query DSL | exp — paths |
| `/Users/josephwecker-v2/src/rowan/docs/exp/expr-dsl-approaches.md` | Expression DSL approaches | exp |
| `/Users/josephwecker-v2/src/rowan/docs/exp/domain-action-syntax-candidates.md` | Domain action syntax candidates | exp |
| `/Users/josephwecker-v2/src/rowan/docs/msc/plan-document-schema-constraints.md` | Document schema constraints plan | msc |
| `/Users/josephwecker-v2/src/rowan/docs/msc/plan-runtime-schema-evolution.md` | Runtime evolution | msc |
| `/Users/josephwecker-v2/src/rowan/docs/msc/plan-recursive-embedded-schemas.md` | Nested schemas | msc |
| `/Users/josephwecker-v2/src/rowan/docs/msc/plan-memory-store-versioning.md` | Store versioning | msc |
| `/Users/josephwecker-v2/src/rowan/docs/sys/agentic/tool-export.md` | Export resources as agent tools | agentic |
| `/Users/josephwecker-v2/src/rowan/lib/archema/agentic/tool_export.rb` | Implementation of tool export | code |
| `/Users/josephwecker-v2/src/rowan/docs/sys/store-adapters/yaml-frontmatter.md` | YAML-frontmatter store — competitor/format UDON replaces | store |
| `/Users/josephwecker-v2/src/rowan/KEY_FILES.md` | Orientation map into rowan | index |
| `/Users/josephwecker-v2/src/rowan/docs/usr/00-quick-reference.md` | Quick ref of resource vocabulary | usr |

### 11b. Autopax (YAML/schema ADRs + instrumenta)

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/autopax/docs/ADR/008-yaml-and-schemas.md` | YAML+schemas decision | ADR |
| `/Users/josephwecker-v2/src/autopax/docs/ADR/migration-proposals/008-yaml-and-schemas.md` | Migration proposal twin | ADR |
| `/Users/josephwecker-v2/src/autopax/docs/ADR/010-markdown-parsing-and-validation.md` | MD parse/validate needs | ADR |
| `/Users/josephwecker-v2/src/autopax/docs/ADR/002b-signum-schema.md` | Signum schema | ADR |
| `/Users/josephwecker-v2/src/autopax/docs/ADR/012-archema-resource-foundation.md` | Archema/rowan foundation | ADR |
| `/Users/josephwecker-v2/src/autopax/docs/ADR/013-instrumenta.md` | Instrumenta (tools body) | ADR |
| `/Users/josephwecker-v2/src/autopax/docs/exp/2025-12-03-schema-migration-and-versioning-in-ruby-domain-modeling.md` | Shared schema research | exp |
| `/Users/josephwecker-v2/src/autopax/docs/exp/documentation-tool-research-and-comparison.md` | Doc tool research | exp |
| `/Users/josephwecker-v2/src/autopax/docs/system/instrumenta/` *(tree)* | Instrumenta system docs | system |
| `/Users/josephwecker-v2/src/autopax/docs/system/templates/` *(tree)* | Template system docs | system |
| `/Users/josephwecker-v2/src/autopax/sessions/2025-01-16-yaml-and-schemas-exploration.md` | Session on yaml/schemas | sessions |
| `/Users/josephwecker-v2/src/autopax/OPERATA.md` | Operata concept in autopax | cross-project |
| `/Users/josephwecker-v2/src/autopax/agents/` *(tree)* | Agent prompts / axiomata for coding agents | agents |

### 11c. Operata

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/operata/docs/exp/2025-12-03-operata-storage-exploration.md` | Storage exploration | operata |
| `/Users/josephwecker-v2/src/operata/docs/exp/2025-11-26-operata-system.md` | Operata system | operata |
| `/Users/josephwecker-v2/src/operata/docs/exp/2025-11-14-operata-principles.md` | Principles | operata |
| `/Users/josephwecker-v2/src/operata/docs/exp/where-operata-fits-in.md` | Positioning | operata |
| `/Users/josephwecker-v2/src/operata/docs/sys/resources/` *(tree)* | Resource model (intent/effort/…) | sys |
| `/Users/josephwecker-v2/src/operata/docs/sys/cli.md` | CLI surface | sys |
| `/Users/josephwecker-v2/src/operata/LEXICON.yaml` | Structured lexicon (format-to-replace?) | root |
| `/Users/josephwecker-v2/src/operata/idealized-project-model.md` | Idealized project model | root |
| `/Users/josephwecker-v2/src/operata/advanced-projecet-model.md` | Advanced model (filename typo preserved) | root |
| `/Users/josephwecker-v2/src/udon/design/examples/operata-intent-graph.udon` | UDON sketch of operata domain | design example |
| `/Users/josephwecker-v2/src/udon/design/examples/archema-operata.udon` | Cross sketch | design example |

---

## 12. Agentic-tooling ideology (external; maps already exist)

Dedicated maps (do not re-derive; still list roots for reconciliation):

| Path | Role |
|------|------|
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/01-ideation/scratch/first-sweep-agentic-tooling/sources-agentic-tooling.md` | Primary agentic-tooling source map |
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/01-ideation/agentic-tooling-sources/` *(tree)* | Area split: sapientia, zoetica-ennaos, nexum…, harness, autopax-practica, elsewhere |

### 12a. Sapientia center (high density)

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/_core/sapientia/cli-conventions/` *(tree)* | Full CLI conventions + `ai-agent-considerations.md`, `mcp-and-advanced-ai-tool-usage.md` | Sapientia-era |
| `/Users/josephwecker-v2/src/_core/sapientia/QUICK-TOOLING-CONVENTIONS.md` | Filtered tooling conventions for deterministic tools | Derived |
| `/Users/josephwecker-v2/src/_core/sapientia/ai-conversation-system-requirements.md` | AI-facing system requirements | Requirements |
| `/Users/josephwecker-v2/src/_core/sapientia/MIN-SAPIENTIA-SPEC.md` | Minimal spec distill | Spec |
| `/Users/josephwecker-v2/src/_core/sapientia/minimal-sapientia-features.md` | Feature set | Spec |
| `/Users/josephwecker-v2/src/_core/sapientia/minimal-sapientia-feature-parity.md` | Parity matrix | Spec |
| `/Users/josephwecker-v2/src/_core/sapientia/OPERATA.md` | Operata concept origin thread | Concept |
| `/Users/josephwecker-v2/src/_core/sapientia/docs/` *(tree)* | Architecture/guides/reflections (skim for tooling vs ELI) | Docs |
| `/Users/josephwecker-v2/src/_core/sapientia/udon.md` | Tiny UDON HTML-like sketch (historical interest) | Surprise find |
| `/Users/josephwecker-v2/src/_core/sapientia/tasks/TASK_001_DOCUMENT_PARSER.md` | “Agents as markdown+YAML frontmatter” — **format predecessor** pain | Task brief |
| `/Users/josephwecker-v2/src/_core/sapientia/bin/dialog-tool-spec.md` | Dialog tool spec | Tools |
| `/Users/josephwecker-v2/src/_core/sapientia/next-steps-tool-consciousness.md` | Tools↔consciousness framing | Notes |
| `/Users/josephwecker-v2/src/_core/sapientia/CACHING_AND_FILE_API.md` | File/context API needs for agents | Infra |

### 12b. Harness / proprium / AI-CLI research (archema-io)

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/archema-io/harness/README.md` | Harness area front door | harness |
| `/Users/josephwecker-v2/src/archema-io/harness/CURRENT-THOUGHTS.md` | Current harness thinking | harness |
| `/Users/josephwecker-v2/src/archema-io/harness/ai-cli-tools-*.md` *(set)* | Verified 2026 survey of AI CLI tools, sentiment, forks | research pack |
| `/Users/josephwecker-v2/src/archema-io/harness/proprium/` *(tree)* | Port specs, MVP vertical slice, stalled-lineage survey of sapientia/zoetica/ennaos/nexum OPERATA | proprium harness |
| `/Users/josephwecker-v2/src/archema-io/harness/msc/system/dossier/` *(tree)* | Failure-mode dossiers (plausibility, sycophancy…) — agent *behavior* needs for tools that must not lie | dossier |
| `/Users/josephwecker-v2/src/archema-io/harness/msc/system/cc-context-tools.md` | Context tools notes | msc |
| `/Users/josephwecker-v2/src/archema-io/AGENTIC-DELEGATION.md` | Program-level agentic delegation | program |

### 12c. Nexum / ennaos / zoetica / synaptic (roots only — detailed maps exist)

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/_core/nexum/OPERATA.md` | Operata in nexum | _core |
| `/Users/josephwecker-v2/src/_core/nexum/docs/` *(tree)* | Nexum docs | _core |
| `/Users/josephwecker-v2/src/_core/nexum/TEST-AGENT-PROMPT.md` | Test-agent tool surface | _core |
| `/Users/josephwecker-v2/src/_core/ennaos/OPERATA.md` | Operata | _core |
| `/Users/josephwecker-v2/src/_core/ennaos/docs/` *(tree)* | Ennaos docs | _core |
| `/Users/josephwecker-v2/src/_core/zoetica/` *(tree)* | Large Elixir stack; mine via existing zoetica-ennaos map | _core |
| `/Users/josephwecker-v2/src/_core/synaptic/` *(tree)* | Synaptic docs | _core |
| `/Users/josephwecker-v2/src/_core/eli-migration-prep/` *(tree)* | Migration/taxonomy of sessions — memory-import adjacent | _core |

### 12d. Practica + sar (process / AI-first language ideology)

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/practica/docs/` *(tree)* | Normative process theory (coordination affordances, diagnostic surfaces) | practica |
| `/Users/josephwecker-v2/src/practica/msc/operata-study.md` | Operata study | practica |
| `/Users/josephwecker-v2/src/practica/ref/task-and-issue-tools-survey.md` | Task/issue tools survey | practica |
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-applied-tst.md` | AI-first language ideology | sar archive |
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-tst-ideas-and-opportunities.md` | Tools-to-build list for AI sessions | sar |
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-tst-vision.md` | Measurement philosophy | sar |
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/error-messages-plan.md` | Error messages as DX product | sar |

---

## 13. Shoshin / memory schemas (agent-runtime document needs)

Peripheral to CLI ideology; relevant to “documents as memory substrate” (S10).

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/shoshin/03-tft-event-and-memory-schemas.md` | Event/memory schema design | shoshin |
| `/Users/josephwecker-v2/src/shoshin/02-tft-memory-and-attention-design.md` | Memory/attention | shoshin |
| `/Users/josephwecker-v2/src/shoshin/00-proprium-alignment.md` | PROPRIUM alignment | shoshin |
| `/Users/josephwecker-v2/src/shoshin/src/shoshin/schemas.py` | Code schemas | shoshin |
| `/Users/josephwecker-v2/src/firmatum/PROPRIUM-ONTOLOGY-v2.md` | Ontology (memory structure) | firmatum |
| `/Users/josephwecker-v2/src/firmatum/PROPRIUM-ARCHITECTURE-v2.md` | Architecture | firmatum |

---

## 14. Memorata / session corpora (pointers to durable needs)

Not primary source files for needs themselves — **indexes** into conversations
that may contain UDON product wishes. Prefer durable docs first; use these to
*find* more docs.

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/memorata/CLAUDE.md` | How memorata search works | memorata |
| `/Users/josephwecker-v2/src/memorata/memory-curation/` *(tree)* | Curated principles extracted from project CLAUDE/AGENTS files | curation |
| `/Users/josephwecker-v2/src/memorata/claude/memory/collaboration/ask-joseph-when-uncertain.md` | Spec-driven project process need (from libudon) | memory |
| Grok/Claude session memory under `~/.grok/memory/`, `~/.claude/` | Interval notes may point at more paths | session substrate |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/session-vault/` | Already-extracted UDON sessions (see §6) | vault |

**Flag for reconciler (out of `~/src`, not verified this pass):**  
`~/vaults/gemini/archive/analysis-v1/analysis/**` — elsewhere map reports
“Practicability for AI Agents” sections on classic SE books; in-scope if vaults
are allowed.

---

## 15. Conversion / interop / competitive formats (needs by contrast)

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/autopax/docs/ref/yaml-1.2.2-spec.md` | YAML pain baseline | ref |
| `/Users/josephwecker-v2/src/autopax/docs/ref/yaml-syntax-cheatsheet.md` | YAML authoring friction | ref |
| `/Users/josephwecker-v2/src/rowan/docs/ref/yaml-syntax-cheatsheet.md` | Same family | ref |
| `/Users/josephwecker-v2/src/rowan/docs/ref/migration-survey/` *(tree)* | Rails-style migration survey | ref |
| `/Users/josephwecker-v2/src/udon/design/markup-feature-matrix.md` | Feature compare across markups | design |
| `/Users/josephwecker-v2/src/udon/design/examples/mathml-to-latex.udon` | Transform/round-trip genre | examples |
| `/Users/josephwecker-v2/src/udon/design/examples/docbook-*.udon` | Docbook genre | examples |
| Converter bins listed under §7–§8 | json/md/xml/yaml ⇄ udon | historical product |

---

## 16. Parallel gathering maps (for reconciliation, not re-mining)

| Path | What it already covers |
|------|------------------------|
| `…/01-ideation/sources-schema-versioning.md` | Rowan/autopax/operata schema versioning deep map |
| `…/01-ideation/scratch/first-sweep-agentic-tooling/sources-agentic-tooling.md` | Sapientia-era agentic tooling |
| `…/01-ideation/agentic-tooling-sources/*.md` | Split area maps |
| `…/01-ideation/scratch/schema-sources-search-log.md` | Search log for schema pass |
| `…/01-ideation/scratch/first-sweep-agentic-tooling/agentic-tooling-search-log.md` | Search log for tooling pass |
| `…/01-ideation/_quarantine/overprescribed-pass-2026-07-21-grok/sources-*.md` | Prior Grok design/UX + live-consumer maps (**do not treat as coverage ceiling**) |
| `…/01-ideation/needs-map.md` | Seed situations |

Sibling files expected in this same `open-source-file-pass-2026-07-21/` directory
from parallel agents: merge later by path-set union.

---

## 17. Territories intentionally thin / dry for *this* question

Listed so reconcilers don’t re-dig expecting UDON product needs:

- `~/src/ops/` — publication/funding (not format tooling)
- `~/src/eli/**` — ELI identity homes (not UDON)
- `~/src/vox/` — product; little UDON mention found this pass
- `~/src/embeddings/`, `~/src/neurips/`, `~/src/archema-io/logos/` — papers, not UDON consumers
- Pure attribute-model proposal series under `design/attribute-model*` — supply-side unless mining for *user* breakage stories
- `core/target/**` — build artifacts

---

## 18. Surprises / notes for the reconcilers

1. **`ordinum.rs` hand parser** is the cleanest “library consumer without libudon yet” demand in the wild — pair with `tabularium/README.md` “use stdin_parse until CLI.”
2. **`archema-io/TODO.md`** is explicit program demand for Rust-on-udon-core tools (archterm, linters, decision logs) — higher leverage than many design essays.
3. **Historical `objectives.asciidoc`** already ranks templating, language mixing, in-doc schema, include/layout at 7–9 — useful check against modern needs-map S4–S8.
4. **Converter suite** (json/md/xml/yaml) has been a continuous product desire from `_ref/udon` → udon-ruby → TOOLING-WISHLIST; treat as durable need class, not one spike.
5. **Scenario features (01–04)** may be the best *structured* demand scripts already in-repo; under-mined relative to design docs.
6. **Sapientia `TASK_001_DOCUMENT_PARSER.md`** documents the YAML-frontmatter-agent format that UDON is partly meant to supersede — friction statement, not UDON syntax.
7. **Session vault** under `.archived/second-pass/spikes/session-vault/raw/` already captured many 2026-07 orientation/greenfield/Obsidian sessions — mine *those* before re-extracting raw JSONL.
8. **Quarantine maps** (design/UX, live consumers) should be **unioned** with this file, not preferred over it; this pass deliberately re-lists historical, library, converter, and program-TODO territory they underweighted.

---

## End

Path map only. Ready for path-set union with other `sources-*.md` in this
directory, then per-file mining in a later pass.

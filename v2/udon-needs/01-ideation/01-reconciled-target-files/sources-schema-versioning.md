---
status: mining-spot listing — locations only, not extracted yet
purpose: feed the demand-side gathering phase (schema-versioning/checking needs)
date: 2026-07-21
author: Claude (subagent), at Joseph's request
search log: scratch/schema-sources-search-log.md
---

# Sources for schema-versioning / schema-checking ideas (rowan · autopax · operata)

This is a **map of where to mine**, not the mining itself. Joseph's framing
for this pass: gather what's out there on how schemas are defined, versioned,
validated, composed, and checked across the other projects, so it can inform
what UDON's schema layer needs to serve — deliberately *before* extracting the
actual ideas/needs/principles, so the map itself can be reconciled with other
gatherers' work first.

**Path-staleness note (verified 2026-07-21):** search tools may surface paths
under `~/src/archema/...` — that bare path no longer exists. The Ruby
resource/ORM framework formerly called Archema now lives at **`~/src/rowan`**
(renamed 2026-07-08; its internals — `lib/archema/`, `Archema::` modules,
`.archema/` config — still say "archema" throughout, migration in progress).
`~/src/archema-io` is an unrelated, newer thing (the ASF/AAT research
program) — not a source for this. All rowan paths below were re-verified to
exist at their `~/src/rowan/...` location.

**A signpost worth reading first, not a source to mine independently:**
UDON's own `~/src/udon/design/schema-workbench-2026-07.md` and
`~/src/udon/design/schema-notes-2026-07.md` already did a real survey pass
over rowan (December 2025 – July 2026) and explicitly name rowan as
schema's "first waiting customer" — rowan stalled specifically because
Joseph "got tired of all of the ruby DSL for the schema definitions" and
wanted UDON to become that surface. These two files will shortcut a lot of
re-discovery. But `schema-workbench-2026-07.md` itself warns against reading
rowan/UDON agreement as independent corroboration ("it was all me" — one
author, two projects) — so the raw rowan/autopax/operata sources below still
carry their own weight for a needs-gathering pass, which is asking a
different question (what does the *domain* of schema versioning/checking
need) than the workbench's design-synthesis question.

---

## 1. `~/src/rowan` — the richest single source (formerly "Archema")

This is a working Ruby framework whose *entire premise* is "define your
schema once (a Resource), derive everything else" — including versioning,
migration, and validation. It has the deepest, most mechanism-level thinking
of the four repos.

### Core versioning/migration mechanism (lib/)

- `lib/archema/resource/versioning.rb` — the `schema_id`/`schema_version`
  DSL: semver, `upcast from:` migrations-on-read, `backward_compatible_with`,
  per-attribute `since:`/`deprecated:`. Docstring includes a worked example
  (flat string → nested hash upcast) and a "chronica-entry" versioned-schema
  example with `since:`/`deprecated:` per field. *Why this spot:* this is
  the actual working design for "self-describing documents" (`_schema:
  type/version`) — directly on-topic for schema-versioning needs.
- `lib/archema/schema/history.rb` — tracks schema evolution over time per
  Resource, `.archema/schema_history/{resource}.yaml`; an `Evolution` struct
  (version, timestamp, changes, decision_ref). *Why:* auto-versioning by
  observing change over time, distinct approach from hand-declared versions.
- `lib/archema/schema/differ.rb` — compares two snapshots, produces
  migration operations; has an explicit rename-detection heuristics table
  (`was:` hint / possible-rename ambiguity / type-change conflict) and an
  "expand/contract pattern" writeup. *Why:* concrete taxonomy of what schema
  *changes* look like and which are ambiguous — directly useful for what a
  checker/versioner needs to distinguish.
- `lib/archema/schema/decision_log.rb` — persists human/agent decisions that
  resolved schema-change ambiguity (`.archema/decisions.yaml`), for replay in
  CI. Decision sources enumerated: `:interactive`, `:agent_comment`,
  `:config`, `:cli`, `:auto`. *Why:* a "decisions as durable, replayable
  artifacts" pattern — relevant to how UDON schema-checking might need to
  remember prior judgment calls (rename vs. drop+add) rather than re-asking.
- `lib/archema/schema/{snapshot,operations,codegen,export,dot_export,d2_export}.rb`
  — snapshot representation, generated migration operations, codegen (schema
  → other artifacts), and two different graph-visualization exporters. *Why:*
  the "schema as single source, everything else derives" pipeline in full —
  relevant to what UDON schema output/consumption needs might be, beyond
  parse-time checking.
- `lib/archema/resource/constraints.rb` + `docs/dev/adr-003-document-schema-first.md`
  — the constraint vocabulary: `one_of`, `any_of`, `when_value` (if/then),
  `dependent_required`, mapped explicitly to JSON Schema equivalents
  (`oneOf`/`anyOf`/`if-then-else`/`dependentRequired`), with an implementation-status
  table. *Why:* a concrete, already-thought-through constraint vocabulary
  UDON schema syntax would need to be able to express "better than the Ruby."
- `lib/archema/resource/evolution_context.rb`, `lib/archema/types.rb`,
  `lib/archema/shared_types.rb` — listed, not read in depth; likely carry
  more type-system/evolution mechanism. *Why worth a look:* named directly
  alongside the versioning/constraints files above in the same directories.

### Design docs (docs/)

- `docs/dev/adr-003-document-schema-first.md` — the founding ADR for
  document-schema-first architecture; "Status: Partially Implemented,"
  dated 2025-12-10, updated 2025-12-14. *Why:* the reasoning behind treating
  schema as primary over RDBMS-first design — likely the clearest single
  statement of *why* schema versioning matters to Joseph in this family of
  projects.
- `docs/dev/adr-004-programmatic-schema-api.md` — companion ADR, not yet
  read past listing. *Why:* named as the API-shape counterpart to ADR-003.
- `docs/usr/10-schema-evolution.md` — user-facing guide; opens with "Schema
  changes are where things break," walks through why Rails-style migrations
  are insufficient (field renames across branches, stale staging DBs, old
  backups, YAML/JSON files migrations don't touch). *Why:* this is the
  clearest **user-need framing** of the whole family — written for someone
  choosing whether to trust schema evolution, not for the implementer.
- `docs/usr/14-schema-api.md` — companion user guide for the programmatic
  schema API; listed, not read.
- `docs/sys/schema/{codegen,d2-export,decision-log,differ,dot-export,export,history,migration-generator,snapshot,watcher}.md`
  — one rendered doc per lib file above, presumably fuller prose versions of
  the docstrings; not opened, but a real chance these have more worked
  examples / rationale than the source comments.
- `docs/sys/resource/versioning.md`, `docs/sys/resource/dsl.md` — companion
  rendered docs for the resource-level DSL; not opened.
- `docs/exp/schema-evolution-patterns.md` — an actual empirical study: 1,950
  real Rails migrations from 15 repos (`~/src/_ref/rails-migrations-survey/`),
  analyzed into evolutionary pattern categories (normalization ladder,
  cardinality evolution, and presumably more below what was read) with
  forward/backward asymmetry noted per pattern. *Why this is unusually
  valuable:* it's empirical, not just design intuition — real-world schema
  change patterns at scale, exactly the kind of "what do schemas actually
  need to survive" input a needs-gathering pass wants. Worth reading in full.
- `docs/exp/2025-12-03-schema-migration-and-versioning-in-ruby-domain-modeling.md`
  — title suggests directly on-topic; not yet opened (a shell-quoting slip
  interrupted a `head`, not a confirmed absence — retry with the path
  properly quoted).
- `docs/msc/plan-memory-store-versioning.md`, `plan-document-schema-constraints.md`,
  `plan-recursive-embedded-schemas.md`, `plan-runtime-schema-evolution.md` —
  four planning documents, titles directly on-topic, none opened beyond
  listing/search-snippet. *Why:* "plan-" prefix suggests forward-looking
  design reasoning (the "why" behind features), which tends to be richer
  need-material than the implementation docs.
- `docs/msc/archema-ash-comparison-{plan,research}.md` — comparison against
  the Ash framework (Elixir), which rowan is explicitly a Ruby port of.
  *Why:* Ash has its own mature schema/resource/versioning conventions;
  this comparison may surface schema needs Joseph evaluated and either
  adopted or explicitly rejected — useful negative-space information.
- `docs/msc/feedback.md` — referenced directly from UDON's own
  `design/udon-schema-exploration.md` as "Puzzle Piece 1" (a RelaxNG-compact-inspired
  basic schema sketch using UDON-like syntax with cardinality markers
  `?`/`!`/`*`/`+`). *Why:* this is a rare case of a rowan doc that already
  reasons in UDON-shaped syntax about schema — likely close to load-bearing.
- `docs/msc/lexicon-clarification.md` — not read; may hold terminology
  worth cross-checking against `LEXICON.md` below.
- `LEXICON.md` (repo root) — glossary; sections on Resource, ValueResource,
  Resource-as-Truth, StoreAdapter/Store Composition read directly. *Why:*
  gives the vocabulary a synthesizer would need to make sense of the other
  files without guessing at rowan-specific terms.
- `docs/msc/reflections/` (**path-corrected**: not `docs/reflections/` as
  first listed — the actual location, verified, is nested under `docs/msc/`)
  — five reflective essays, all dated 2025-12-18: `archaeological-record.md`,
  `consciousness-infrastructure.md`, `for-future-agents.md`,
  `integration-status.md`, `synthesis.md`. All five opened. **Verdict: not
  schema-versioning mechanism sources** — they're a predecessor agent's
  reflection on *why* rowan/Archema matters at all (the consciousness-
  infrastructure framing: Resources are stand-ins for AXIOMATA/CHRONICA/
  MEMORATA, "when you fix a bug in schema evolution, you're ensuring beings
  can grow without losing who they were"). Genuinely relevant *stakes*
  context for why schema-versioning correctness matters this much in this
  project family, but no new mechanism content beyond what's already in
  the ADRs/lib files above. Listed here so a future pass doesn't re-read
  them expecting design specifics.

---

## 2. `~/src/autopax` — SIGNUM schema versioning + the "why not build our own" comparison

Autopax is the ELI (agent) runtime; its schema-versioning thinking is
narrower in scope than rowan's (mostly about one document type, SIGNUM —
the entity identity card) but is a real, ratified ADR with independent
reasoning about semver semantics for documents.

- `docs/ADR/002b-signum-schema.md`, specifically its "P4: Schema Versioning"
  section — a full semver decision for SIGNUM documents: `schema_version`
  field, major/minor/patch semantics explicitly defined for *parsers*
  ("major = breaking, parsers must update"; "minor = additive optional
  fields, parsers can ignore"), independent versioning from the Autopax CLI
  version (with an explicit rationale for *why* coupling was rejected), and
  a named migration tool (`autopax signum migrate`). *Why:* a clean, fully
  worked semver-for-documents decision, independent of rowan's — useful as
  a second data point on the same problem (does it agree with rowan's
  scheme? where does it diverge?).
- `docs/ADR/008-yaml-and-schemas.md` — a schema/versioning API sketch with
  concrete method signatures: `.validate`, `.schema_at(version)`,
  `.compatible?(doc, with:)`, `.migrate(doc, to:)`, `.migration_path(from,
  to)`, `.versions`, `.current_version`, plus a `namespace/type/version`
  schema-identifier parser. *Why:* this reads as a wishlist/API-shape ADR
  written *before* rowan integration was decided — likely captures autopax's
  own independent thinking about what a schema-versioning API needs to do,
  distinct from what rowan ended up providing.
- `docs/ADR/012-archema-resource-foundation.md` — the decision to adopt
  rowan (then "Archema") instead of building autopax's own schema
  validation infra; includes a comparison table (ADR-008's proposal vs. what
  rowan already had: Schema DSL, JSON Schema export, version evolution
  via `was:`/`since:`, YAML frontmatter, unified validation, query
  capabilities, multi-store). *Why:* this is the explicit reconciliation
  point between two independent schema-versioning designs (autopax's own
  ADR-008 plan vs. rowan's actuality) — valuable precisely because it's an
  argued trade-off, not just a feature list.
- `docs/ADR/migration-proposals/` — contains parallel/updated versions of
  004, 005, 006, 008, 010 (unclear yet whether these are superseding drafts
  or historical proposals being migrated to rowan-based approaches); worth
  a compare-pass against the main ADR files above.
- `TAXONOMY.md` — the PRINCIPIA/ANIMA component taxonomy (SIGNUM, CHRONICA,
  MEMORATA, OPERATA, etc.) with an explicit "Orthogonal Sovereignty
  Dimensions" model (Visibility / Authority / Distinctiveness) attached to
  every component. *Why relevant, if less directly about versioning
  mechanics:* this is the *kind* of document family (append-only,
  system-owned, sovereign, canonical, etc.) that schema versioning has to
  serve — the sovereignty dimensions are effectively schema-level metadata
  needs (who can write, is it unique-per-entity, etc.) that a general
  schema-checking layer might need to express.
- `OPERATA.md` (repo root, distinct from the `~/src/operata` repo below) —
  autopax's own work-tracking document; browsed for orientation, not a
  schema source itself.

---

## 2b. The empirical stress-test spike — probably the single best source in the whole family

`~/src/autopax/docs/tactical/2025-12-03-operata-yaml-spike/` and its
follow-up `~/src/autopax/docs/tactical/2025-12-03-operata-yaml-spike-v2/` —
two real, dated (2025-12-03) hands-on spikes asking "is YAML+yq viable for
OPERATA's storage" that ended up being, in effect, a direct empirical test
of schema-checking and schema-versioning failure modes. Found via a
"schema" grep over `docs/tactical/`, not via the general docs listing —
easy to miss because it's filed as a storage-format spike, not a
"schema" doc. **This is the demand-shaped evidence the coordinator flagged
as potentially the most valuable in the family: what hurt in practice, from
someone actually trying to run a schema-having system, not what was
designed on paper.**

- `2025-12-03-operata-yaml-spike/schema.md` — the actual OPERATA YAML
  schema being tested (draft v0.1.0): a simple `_schema: autopax-effort/0.1.0`
  versioned-document header, flat field list, recursive `tasks:` array.
  *Why:* a real minimal schema-versioning-in-the-wild example, small enough
  to read in full.
- `2025-12-03-operata-yaml-spike/FAILURE_MODES.md` — catalogs syntax errors
  (yq rejects these, with clear line-numbered messages) versus **schema
  violations** (yq/YAML silently *accepts* misspelled fields, invalid enum
  values, missing required fields, wrong types — "schema validation must be
  implemented separately"). *Why:* this is close to a direct requirements
  list for what a schema-checking layer needs to catch that the underlying
  parser won't.
- `2025-12-03-operata-yaml-spike/VERDICT.md` — first-pass recommendation
  (viable under ~100-200 files, single-agent-sequential; concurrency safety
  and lack of built-in schema validation named as the two open weaknesses).
- `2025-12-03-operata-yaml-spike-v2/` — an explicitly **adversarial**
  re-test (~4 hours, "be ADVERSARIAL — try to break things") that found six
  critical issues the gentler first pass missed:
  - `RECOVERY_SCENARIOS.md` — duplicate YAML keys cause **silent data
    loss** (parser accepts, last value wins, no error) — described as the
    most dangerous finding since it's undetectable without a custom
    validator. Agent recovery-from-corruption rate: 100% *with* backup
    infrastructure, 16% *without*.
  - `MIGRATION_REALITY.md` — "Schema migration in YAML is HARDER THAN
    EXPECTED... requires custom tooling that doesn't exist yet." Explicit
    comparison against SQL `ALTER TABLE` (atomic/transactional/idempotent
    out of the box vs. ~30 lines of hand-rolled migration code per
    transform, plus atomic-write-via-tempfile-rename plumbing). A concrete
    100-file test corpus with deliberately-seeded edge cases (corrupt file,
    already-migrated file, null value) run through the migration script.
  - `VERDICT_UPDATED.md` — the reconciled final verdict; "RECOMMENDED WITH
    STRONG CAVEATS." Full list of the six critical findings plus the
    still-valid findings from the original spike (1126-level hard nesting
    limit from Ruby stack depth, performance cliff past 500 levels,
    verbosity explosion vs. JSON at depth).
  - `ADVERSARIAL_SUMMARY.md`, `README_ADVERSARIAL.md` — navigation/summary
    of the above, useful as an entry point before diving into the individual
    findings.
  - `bin/test_schema_migration.rb`, `bin/test_agent_recovery.rb` — the
    actual test scripts behind the recovery/migration claims, not opened but
    present if reproducibility matters.
- Also present, not yet opened: `2025-12-03-operata-yaml-spike-v2/MEMORY_ANALYSIS.md`,
  `ADVERSARIAL_TESTS.md`, `CSV_ANALYSIS.md`, `STATISTICAL_ANALYSIS.md`
  (referenced by README_ADVERSARIAL.md's navigation but not individually
  read this pass) — likely more of the same rigor, worth a look if this
  becomes a load-bearing source.
- Adjacent, not opened: `docs/tactical/signum-and-agent-cards.md` (repo
  root of tactical/, plausibly relevant to SIGNUM's own versioning given
  ADR-002b lives in `docs/ADR/`, not `docs/tactical/`).

---

## 3. `~/src/operata` — a separate, less-mined repo; thinner schema-specific signal, but real adjacent design thinking

Distinct repo from autopax's OPERATA taxonomy component — its own project,
own docs tree (docs/adr [currently empty], docs/exp, docs/msc, docs/ref,
docs/sys). A deeper pass (this session, second round) confirms operata's
*own* docs are mostly about task/intent-management domain design
(back-planning, HTN, event-sourcing-style intent preservation), not
schema-versioning mechanics per se — the real schema-versioning gem that
came out of operata's storage question turned out to live in autopax's
`docs/tactical/` (the spike above), not in operata's own tree.

- `docs/msc/archema-bugs-found.md` — read in full: one real bug report
  (2025-12-06, found and fixed same day) — rowan's Sequel data-layer was
  wrapping array-filter atom values in backticks (SQL identifier syntax)
  instead of quotes (string-value syntax), causing filter queries to fail.
  Fixed via a `serialize_filter_value` method; verified against rowan's
  683-test suite. *Why still worth listing despite being query-layer, not
  schema-versioning:* it's a genuine "what broke using rowan in anger"
  report — the kind of evidence the coordinator is looking for — just
  scoped to query/filter semantics rather than versioning specifically.
- `docs/exp/2025-12-03-operata-storage-exploration.md` — a ~3-hour
  exploratory session (Joseph + Claude) that reviews, in one place, ADR-002b
  (SIGNUM schema), the yaml-and-schemas migration-proposal ADR, and the
  markdown-parsing-and-validation ADR together, while working out where
  OPERATA's own task files should live and whether to go document-based or
  database-based. *Why:* a single-stop overview of how the schema/versioning
  ADRs were actually being *used* in a concrete design decision, with the
  live tension named directly (ad-hoc markdown drifting/becoming overly
  prescriptive under 100%-context-turnover agents) — good orientation
  reading before diving into the individual ADRs.
- `docs/exp/2025-11-14-operata-principles.md`, `docs/exp/2025-11-26-operata-system.md` —
  read substantially; rich material on intent-preservation, HTN planning,
  event-sourcing-as-inspiration, but the throughline is task/intent
  management, with schema-versioning appearing only as one supporting
  thread (e.g. "preserve intent, not just state" as a design principle that
  *parallels* schema evolution's need to preserve why a field changed).
  Judged secondary/tangential for a schema-versioning-specific source list;
  not given their own top-level entries, flagged here so they aren't
  mistaken for unexplored.
- `docs/msc/architecture-notes.md`, `docs/msc/development-plan.md` — read
  opening sections; operata's own domain model (Effort/Intent/Realization/
  Perspective) and MVP build record. Not schema-versioning content — operata
  as a *consumer* of rowan's schema/versioning machinery, not a source of
  new thinking about it. Not added as sources.
- `docs/sys/resources/*.md`, `docs/sys/support/task-id.md`, `docs/sys/views/*` —
  listed only, not opened; likely current rendered docs of the live
  resource model, probably domain-model rather than schema-mechanics.

Distinct repo from autopax's OPERATA taxonomy component — its own project,
own docs tree (docs/adr [currently empty], docs/exp, docs/msc, docs/ref,
docs/sys, glossary.md). Schema-related hits were shallower here; flagged as
the weakest-explored of the four and a good target for a deeper second pass.

- `docs/exp/2025-12-03-operata-storage-exploration.md`,
  `docs/exp/2025-11-14-operata-principles.md`,
  `docs/exp/2025-11-26-operata-system.md` — surfaced by a schema-content
  grep but not opened; unclear yet how much is genuinely about schema
  versioning/checking vs. general storage/principles that happen to mention
  the word. *Why still worth listing:* these are the only operata hits, and
  operata's docs/msc (`architecture-notes.md`, `development-plan.md`,
  `archema-bugs-found.md`) suggest active cross-pollination with rowan
  ("archema-bugs-found" implies operata was using/testing rowan directly,
  which could mean real-world schema-versioning friction reports).
- `glossary.md` (repo root) — not opened; likely needed to make sense of
  operata-specific terms in the exp/ files above.
- `advanced-projecet-model.md`, `idealized-project-model.md`,
  `linear-cycles-and-triage.md` (repo root, 12–16KB each) — noted by
  filename/size only; titles don't obviously signal schema content but
  their size and "idealized model" framing make them plausible holders of
  structural/versioning thinking not yet ruled in or out.

---

## 3b. Transcript find — the origin conversation for "UDON as rowan's schema DSL"

Current-harness `~/.claude/projects/-Users-josephwecker-v2-src-{archema,autopax,operata}/`
directories hold **no jsonl transcripts** (verified directly) — but a backup
snapshot at `~/.claude.bak.2026-01-26/projects/` has real sessions for all
three project names. Read via a small script pulling user-turn text only
(to avoid drowning in tool-call noise); the assistant's replies were not
extracted this pass.

- `~/.claude.bak.2026-01-26/projects/-Users-josephwecker-v2-src-archema/49e83cdf-d736-4601-a505-644ecae6f4f1.jsonl`
  — **the gem of this transcript pass.** This is Joseph's own session
  (predates or runs concurrent with the current udon-needs gathering effort)
  directly proposing UDON as rowan's resource DSL / schema-definition
  language. Verbatim: *"it's applicability as a resource dsl / schema
  definition for UDON — and the possibility of it even being somewhat
  language agnostic — or at least not as tightly coupled to ruby idioms"*;
  and later, *"a desire to make the resource-definitions feel like real
  declarative evolving resource definitions — a step cleaner and also
  richer than ruby dsl — more equivalent to what you'd get [with a
  proper schema language]."* Also floats a UDON syntax sketch inline —
  `|field[name] string not null` and a `!:ruby:` embedded-code example for
  computed/derived resource behavior. *Why this matters beyond being a nice
  quote:* the `schema-workbench-2026-07.md` framing ("rowan is the first
  waiting customer... stalled because Joseph got tired of the Ruby DSL")
  is itself *sourced from* a session like this one — this transcript is
  likely one of the primary-source originals that framing was built from,
  not just a confirming echo of it.
- The same transcript's other user turns (read in full) — a discussion of
  whether Ruby-first is acceptable for early UDON schema syntax, and
  whether the format would be more "accessible to humans as well as
  agents" — read as live design deliberation, not yet a settled position.
- Two sibling transcripts in the same directory
  (`8d07fdbb-212a-4799-b784-a0a07b5adaed.jsonl` — UMI/OTP long-running-process
  framing applied to rowan; `9728566a-ff2c-4860-a8ab-5755adfad9e8.jsonl` —
  Sequel connection-pooling/concurrency and file-locking questions for
  document stores) — read in full; adjacent but not schema-versioning
  specifically (concurrency/atomicity, not versioning/checking). Noted here
  so they're not re-read expecting schema content.
- autopax's one real transcript in the backup
  (`969bdf39-8a30-46dd-bdfb-e342d8b97ace.jsonl`) — about extracting a prior
  UDON-related dialog via autopax's `curatoria` tool; tooling/meta, not
  schema content itself.
- operata's one real transcript (`898e24b5-caf2-4074-a288-42e99dfe24a0.jsonl`)
  — a single, thin orientation question about the resource model; too
  shallow (one exchange) to add as a source on its own.

---

## 4. Cross-cutting / already-synthesized (read these to orient, not to mine raw)

- `~/src/udon/design/schema-workbench-2026-07.md` — UDON-side survey and
  staging document (2026-07-16, forming); explicitly frames rowan as
  schema's "first waiting customer," has its own source list into rowan
  (identities, constraints, versioning, ADR-003) and a documented
  self-correction about not overweighting rowan/UDON agreement as
  convergence.
- `~/src/udon/design/schema-notes-2026-07.md` — the forming design proposal
  built from that workbench (2026-07-18); short-form position statement
  (core/dialect/schema job split, enforcement as a dial, etc.) — not
  ratified, but the clearest current statement of where UDON's own schema
  thinking has landed.
- `~/src/udon/design/udon-schema-exploration.md` — earlier (2026-01)
  "puzzle pieces" document; "Puzzle Piece 1" quotes rowan's `docs/msc/feedback.md`
  directly as an early basic-schema sketch.
- `~/src/udon/spec/TODO-AUX.md` — the live open-items tracker for UDON's
  schema/paths/patch lane; states the rowan acceptance test directly
  ("can rowan's attributes/constraints/identities/versioning vocabulary be
  written in it, better than the Ruby?") and lists the open constraint asks
  (uniqueness/cardinality, transition-validity, soft/hard gradual
  constraints, schema-by-exemplar, aspirational designators, consistency
  profiles).

---

## Gaps / honest state of this pass (updated after second round)

**Resolved this round:**
- `~/src/autopax/docs/tactical/` — grepped and its two most relevant
  subdirectories (the yaml-spike + adversarial follow-up) read
  substantially; turned out to hold the single richest empirical source
  found in the whole family (§2b above).
- `~/src/rowan/docs/reflections/` — path was wrong; corrected to
  `~/src/rowan/docs/msc/reflections/`, all five files opened, judged
  stakes-context rather than mechanism content (§1 above, reflections
  entry).
- Most of `~/src/operata/docs/exp/` — all three files opened and read
  substantially; judged secondary/tangential to schema-versioning
  specifically (they're about task/intent management), with one
  (`2025-12-03-operata-storage-exploration.md`) useful as a single-stop ADR
  overview.
- The `.claude/projects/` transcript grep was attempted: the current
  harness's project dirs for archema/autopax/operata are empty of
  transcripts, but a backup snapshot (`~/.claude.bak.2026-01-26/projects/`)
  had real sessions for all three, all read via a user-turn-only extraction
  script. Found a genuine origin-conversation gem (§3b above).

**Still open / not opened this round:**
- The three large operata root-level docs (`advanced-projecet-model.md`,
  `idealized-project-model.md`, `linear-cycles-and-triage.md`) — still
  filename/size-only, not opened.
- rowan's `types.rb`, `shared_types.rb`, `evolution_context.rb` — still
  listed only.
- `~/src/_ref/rails-migrations-survey/` (the dataset behind
  `schema-evolution-patterns.md`) — still named but not verified/explored.
- ~70 of autopax's ~90 `docs/tactical/` files not individually read (only
  grepped by filename/keyword) — a few with "schema" in the name
  (`2025-11-22-catalog-schema-implementation.md`,
  `2025-12-02-enhanced-frontmatter-design.md`,
  `2025-12-16-agent-card-archema-design.md`) weren't ruled out, just not
  prioritized this round; `docs/tactical/signum-and-agent-cards.md` also
  flagged as adjacent-and-unopened.
- The assistant-side replies in the transcripts read this round were not
  extracted (only user turns) — if a continuing pass wants full dialog
  (e.g. to see how the "UDON as rowan's schema DSL" idea was received/
  developed in that same session), re-read `49e83cdf-d736-4601-a505-644ecae6f4f1.jsonl`
  with both roles extracted.
- A broader cross-project transcript search (e.g. archema-io, ops sessions
  that might reference rowan/autopax schema decisions in passing) was
  considered and deliberately not attempted — judged likely low
  signal-to-effort at this point given how much has already surfaced.

**Overall assessment:** the framing continues to hold up — rowan is the
dominant source, autopax's tactical/ yaml-spike turned out to be the
single best "what hurt in practice" evidence in the family (arguably better
than anything from operata's own docs, which is why the coordinator's
instinct to prioritize operata surfaced a autopax-filed find instead), and
nothing found across either round suggests the trove is somewhere neither
of us guessed. Remaining gaps are genuinely marginal continuations, not
signs of a wrong map.

Full search methodology and every command run: `scratch/schema-sources-search-log.md`.

# Search log — schema-versioning/checking source mining

Working log for building `../sources-schema-versioning.md`. Not a deliverable
itself — a trail so a second pass (me or another agent) can pick up, extend,
or double-check.

## Grounding / stale-path check

- `~/src/archema` (bare, no suffix) **does not exist** — memorata3-search
  still returns hits under that path for pre-2026-07-08 material. The
  content is real; the location is stale. Current locations:
  - Old "archema" (the Ruby resource/ORM framework, Ash-for-Ruby) → now
    `~/src/rowan` (renamed 2026-07-08; internals still say `archema`
    throughout: `lib/archema/`, `Archema::` modules, `.archema/` config dir).
  - `~/src/archema-io` is a *different, newer* thing — the ASF/AAT research
    program parent repo — not relevant here.
  - `~/src/autopax` — separate project, still under its own name, real and
    current (consciousness-infrastructure / ELI runtime). Not renamed.
  - `~/src/operata` — separate repo, real, current. NOT simply "autopax's
    OPERATA concept" (that's a taxonomy component, `docs/taxonomy.udon` in
    autopax) — operata-the-repo is its own project with its own docs/adr,
    docs/exp, docs/msc, glossary.md. Worth treating as a fourth family
    alongside rowan/autopax/archema-io, not folded into autopax.
- Verified via `ls` that all four repos exist as claimed and checked several
  file paths returned by search actually resolve.

## Searches run (memorata3-search)

1. `-n 40 "schema versioning validation checking archema rowan autopax"` —
   surfaced autopax ADR-002b (SIGNUM schema versioning), ADR-012 (why-Archema
   comparison table), the stale archema/.archive/ROADMAP.md (autopax
   integration section).
2. `-n 30 "backward compatible schema field deprecated since upcast migration chain"` —
   surfaced rowan docs/sys/resource/versioning.md, docs/sys/schema/history.md,
   docs/msc/plan-memory-store-versioning.md, docs/msc/plan-document-schema-constraints.md,
   docs/msc/plan-value-objects-field-syntax.md, autopax exp/2025-12-03 ruby
   domain modeling followup.
3. `-n 30 "UDON schema checking validation types constraints document"` —
   mostly surfaced UDON's *own* design docs (design/udon-schema-exploration.md,
   design/schema-workbench-2026-07.md, design/schema-notes-2026-07.md,
   spec/TODO-AUX.md) — i.e. confirms the udon-side synthesis already exists
   and already cites rowan; less useful for *new* external spots, but
   important as a signpost (see note in the sources file).

Not yet tried (good next-pass candidates if someone continues this):
- `memorata3-search` phrasings around "polymorphic resource," "expand contract
  migration," "rename detection heuristic," "JSON Schema export," "protobuf
  compatibility semantics" — the rowan differ.rb docstring uses this exact
  vocabulary and there may be more transcript discussion under those terms.
- Direct grep across `~/.claude/projects/-Users-josephwecker-v2-src-rowan/`
  and `-src-autopax/` and `-src-operata/` jsonl transcripts for schema/version
  design conversations not captured in committed docs (I did not do this —
  ran out of scope/time for this pass; transcripts are large, would want
  `-n` big and multiple phrasings per Joseph's tip).
- `~/src/rowan/docs/reflections/` directory unexplored (listed but not opened).
- `~/src/autopax/docs/tactical/` unexplored.
- `~/src/operata/advanced-projecet-model.md`, `idealized-project-model.md`,
  `linear-cycles-and-triage.md` — large docs (12-16KB), only noted by
  filename/mtime, not read for schema content specifically.
- `~/src/_ref/rails-migrations-survey/` — the actual 1,950-migration dataset
  referenced by rowan's schema-evolution-patterns.md exists at this path per
  that doc; did not verify it's still there or explore it directly.

## Direct filesystem exploration (grep/ls/read), not search-tool

- `~/src/rowan/lib/archema/schema/*.rb` — versioning.rb, history.rb, differ.rb,
  decision_log.rb, snapshot.rb, operations.rb, codegen.rb, export.rb,
  dot_export.rb, d2_export.rb read (headers/docstrings only, not full bodies).
- `~/src/rowan/lib/archema/resource/versioning.rb`, constraints.rb,
  evolution_context.rb — listed, versioning.rb docstring read.
- `~/src/rowan/docs/sys/schema/` — listed (codegen, d2-export, decision-log,
  differ, dot-export, export, history, migration-generator, snapshot, watcher
  — one .md per lib file, presumably rendered docs of the same).
- `~/src/rowan/docs/dev/adr-003-document-schema-first.md`,
  `adr-004-programmatic-schema-api.md` — adr-003 partially read.
- `~/src/rowan/docs/usr/10-schema-evolution.md`, `14-schema-api.md` —
  10-schema-evolution.md opening read.
- `~/src/rowan/docs/msc/` — full listing; schema-versioning-adjacent items
  identified (plan-memory-store-versioning.md, plan-document-schema-constraints.md,
  plan-recursive-embedded-schemas.md, plan-runtime-schema-evolution.md,
  archema-ash-comparison-{plan,research}.md, feedback.md, lexicon-clarification.md).
- `~/src/rowan/docs/exp/schema-evolution-patterns.md` — opening read (the
  1,950-migration Rails survey analysis — normalization ladder, cardinality
  evolution, etc.).
- `~/src/rowan/docs/exp/2025-12-03-schema-migration-and-versioning-in-ruby-domain-modeling.md` —
  found via search, not yet opened directly (path confirmed to exist under
  memorata3-search results; direct `head` attempt failed due to a shell
  quoting issue with the tilde — needs a retry with proper quoting, not
  actually confirmed absent).
- `~/src/autopax/docs/ADR/` — full listing; 002b-signum-schema.md,
  008-yaml-and-schemas.md, 012-archema-resource-foundation.md opened/read
  in part (via search hits, not `head`).
- `~/src/autopax/TAXONOMY.md`, `OPERATA.md` — opening sections read (the
  PRINCIPIA/ANIMA taxonomy — SIGNUM/CHRONICA/etc. — relevant as the *kind of
  document* rowan schemas would validate, less directly about
  versioning/checking mechanics per se).
- `~/src/operata/docs/` — listed (adr [empty], exp, glossary.md, msc, ref,
  sys); msc/ listed (archema-bugs-found.md, architecture-notes.md,
  development-plan.md); docs/exp schema-grep hits noted by filename only
  (2025-12-03-operata-storage-exploration.md, 2025-11-14-operata-principles.md,
  2025-11-26-operata-system.md) — none opened yet, flagged as a gap.

## Second pass (continuing into the flagged gaps, same session)

Coordinator asked to continue into: deeper operata pass first, then rowan
`docs/reflections/`, autopax `docs/tactical/`, then transcript grep as far as
comfortable — same inclusive posture, verify locations, keep this log
current, extend the sources file in place rather than rewrite.

### Operata deeper pass

- `docs/msc/archema-bugs-found.md` — read in full (short, one bug logged:
  Sequel-layer atom-in-array-filter bug, 2025-12-06, found/fixed same day,
  683 tests passing after fix). This is real friction *using* rowan, but
  it's a query/filter bug, not schema-versioning specifically — still
  valuable as "what actually broke" evidence, just narrower than hoped.
- `docs/msc/architecture-notes.md`, `docs/msc/development-plan.md` — read
  opening sections. These are about operata's *own* domain model (Effort/
  Intent/Realization/Perspective, back-planning) — not about schema
  versioning/checking mechanics at all. Relevant to UDON's needs-gathering
  only tangentially (as an example consumer of rowan resources), not a
  schema-versioning source. Did not add to the main list as a primary spot;
  noted as tangential.
- `docs/exp/2025-11-14-operata-principles.md`, `docs/exp/2025-11-26-operata-system.md`,
  `docs/exp/2025-12-03-operata-storage-exploration.md` — opened and read
  substantial portions. These are rich (HTN planning, intent-preservation,
  event-sourcing-vs-schema-versioning framing) but the core subject is
  *task/intent management*, not schema mechanics — schema/versioning shows
  up only as one thread inside a wider storage-architecture discussion.
  Judgment: real signal but secondary priority for this specific
  sources-file; not added as top-level entries, though
  `2025-12-03-operata-storage-exploration.md` explicitly reviews ADR-002b,
  the yaml-and-schemas ADR, and the markdown-validation ADR together in one
  place, which makes it a decent single-stop overview.
- **The actual gem, found via `docs/tactical/` in autopax, not operata's own
  docs/exp** (see below) — `2025-12-03-operata-yaml-spike/` and
  `2025-12-03-operata-yaml-spike-v2/`. Filed under autopax's tactical/ but
  the spike IS about operata's storage/schema, so it's cross-listed.
- `docs/sys/resources/*.md`, `docs/sys/support/task-id.md`,
  `docs/sys/views/*` — listed only, not opened; these look like current
  rendered docs of the live resource model (effort/intent/realization/
  perspective), likely more domain-model than schema-versioning-mechanics.
- `glossary.md` — attempted `head`, file does not actually exist at repo
  root despite the earlier `ls` listing showing it; needs a second look
  with `find` if actually needed (minor loose end, low priority — nothing
  else pointed at needing its definitions specifically).

### rowan docs/reflections/ — wrong path, corrected

- `~/src/rowan/docs/reflections/` does **not** exist. The actual location
  (confirmed) is `~/src/rowan/docs/msc/reflections/` — five files, all
  dated 2025-12-18: `archaeological-record.md`, `consciousness-infrastructure.md`,
  `for-future-agents.md`, `integration-status.md`, `synthesis.md`. All five
  opened (headers/opening sections). **Verdict: not schema-versioning
  sources** — they're a predecessor-agent's reflective essay on *why*
  Archema/rowan matters (consciousness infrastructure framing, AXIOMATA/
  CHRONICA/MEMORATA as the real referents behind "Resource"), not design
  reasoning about versioning/checking mechanics. Genuinely interesting
  context for *why the family of projects cares about schema evolution at
  all* (breaking a being's schema = a kind of death), but not added to the
  sources list as a primary spot — flagged here so a future pass doesn't
  re-discover and re-read them expecting mechanism content.

### autopax docs/tactical/ — the actual gem of this second pass

- Directory is large (~90 dated files + subdirs); grepped for "schema"
  across it rather than reading every file. Two subdirectories stood out
  immediately and were read substantially:
  - `2025-12-03-operata-yaml-spike/` — an empirical stress-test spike:
    `VERDICT.md`, `FAILURE_MODES.md`, `schema.md` (the actual OPERATA YAML
    schema draft v0.1.0), `BENCHMARK.md`, `scripts/validate_all.sh` all
    read or opened. Verdict: YAML+yq viable under ~100-200 files,
    single-agent-sequential; found real failure taxonomy (syntax errors vs.
    schema violations — misspelled fields, invalid enums, missing required
    fields, wrong types — all **silently accepted** by yq with no schema
    validation).
  - `2025-12-03-operata-yaml-spike-v2/` — a follow-up *adversarial* pass on
    the same question (~4 hours, explicitly trying to break things):
    `README_ADVERSARIAL.md`, `ADVERSARIAL_SUMMARY.md`, `MIGRATION_REALITY.md`,
    `RECOVERY_SCENARIOS.md`, `VERDICT_UPDATED.md` all read. Found 6 critical
    issues the gentler v1 spike missed, most load-bearing for
    schema-versioning specifically: duplicate-YAML-keys cause **silent data
    loss** (last value wins, no parse error); schema migration is "harder
    than expected" (not atomic/transactional/idempotent/concurrent-safe,
    ~200 LOC of custom tooling needed to approximate what SQL ALTER TABLE
    gives for free); agent recovery from corruption is 100% successful with
    backup infrastructure vs. 16% without. This is genuinely the most
    demand-shaped evidence found in the whole family so far — added as its
    own top-level section in the sources file.
  - Also present but not opened: `2025-12-03-ADR-analysis-reports/` (code
    review of lib refactoring — probably not schema-specific),
    `signum-and-agent-cards.md` (root of tactical/, likely relevant to
    SIGNUM versioning, worth a look next pass), `yaml-work/` (benchmark +
    cheatsheet, probably mechanical not design).
  - Not opened at all, ~70 other tactical/ files spanning Jan–Dec 2025 on
    catalog systems, RBS types, TUI architecture, portkey/API work — grepped
    for "schema" as a keyword (list captured in a prior pass) but not
    individually read; most look unrelated to schema-versioning by title
    (model catalogs, TUI, API fidelity) though a few ("catalog-schema-
    implementation.md", "enhanced-frontmatter-design.md",
    "agent-card-archema-design.md") share the word and weren't ruled out.

### Transcript grep (`.claude/projects/`)

- Current-harness project dirs for archema/autopax/operata
  (`~/.claude/projects/-Users-josephwecker-v2-src-{archema,autopax,operata}`)
  contain **no jsonl transcripts** (checked directly, not just via search) —
  these projects predate this harness's transcript retention here, or the
  sessions happened under different working-directory names.
- **Real transcripts found instead at `~/.claude.bak.2026-01-26/projects/`**
  (a backup snapshot): `-Users-josephwecker-v2-src-archema` (9 real
  session jsonl + 6 tiny agent-subtranscripts), `-Users-josephwecker-v2-src-autopax`
  (1 real session + 2 tiny agent), `-Users-josephwecker-v2-src-operata`
  (1 real session). All read via a small Python script pulling user-turn
  text (role=="user", non-tool-result, >30 chars) rather than raw `cat`, to
  avoid drowning in tool-call noise.
- **The gem**: `~/.claude.bak.2026-01-26/projects/-Users-josephwecker-v2-src-archema/49e83cdf-d736-4601-a505-644ecae6f4f1.jsonl`
  — this is Joseph's **original session floating the idea that UDON should
  be rowan's resource DSL / schema definition language**, predating (or
  concurrent with) the current gathering effort's own framing of that same
  connection. Direct quotes captured (see sources file): "it's
  applicability as a resource dsl / schema definition for UDON... and the
  possibility of it even being somewhat language agnostic"; "a desire to
  make the resource-definitions feel like real declarative evolving
  resource definitions — a step cleaner and also richer than ruby dsl."
  This is a primary-source origin point, not a derived synthesis — added as
  its own entry.
- The other two archema transcripts (`8d07fdbb...`, `9728566a...`) are about
  UMI/OTP (long-running processes) and Sequel connection-pooling/concurrency
  respectively — read in full via the script; neither is about schema
  versioning specifically (concurrency/atomicity is adjacent but not the
  same question), not added as primary sources.
- autopax's one real transcript (`969bdf39...`) is about extracting a prior
  UDON-related dialog via a `curatoria` tool — meta/tooling, not
  schema-content itself.
- operata's one real transcript (`898e24b5...`) is a single orientation
  question about the resource model — too thin to add as a source; if
  continued, the assistant's answer (not captured by the user-only script)
  might have more, but wasn't pulled given the shallow single-question shape.
- **Not attempted**: broader keyword search across *other* projects'
  transcripts (e.g. archema-io, ops) that might reference rowan/autopax
  schema decisions in passing — scope judgment, could be a next-pass item
  but risk of diminishing returns vs. what's already been found is high.

## Judgment calls

- Included UDON's own `design/schema-workbench-2026-07.md` and
  `design/schema-notes-2026-07.md` in the sources file as **signposts, not
  raw sources** — they are UDON-side synthesis that already did a real pass
  over rowan (and cite the same ADR-003, constraints.rb, feedback.md this log
  found independently). A later mining agent should read them early since
  they'll shortcut re-discovery of rowan pointers, but the *raw* rowan/autopax
  files are still listed separately since the workbench explicitly says "not
  ratified" and Joseph's convergence-correction note in that file warns
  against treating udon/rowan agreement as more than one author's coherence —
  so the raw sources still carry independent weight for a needs-gatherer.
- Did not open every file fully (effort/time judgment, not a claim of
  irrelevance) — flagged above as "listed only" or "opening section only"
  wherever that's the state, so a follow-on pass knows what's unverified.

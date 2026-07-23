# Checkpoint — second-pass source investigation

Started 2026-07-23. Working file; the deliverable is `README.md` in this dir.

## Immediate gaps spotted in the existing report (from directory listings alone)

- rowan has **ADR-001 store-composition**, **ADR-002 dig-style filter paths**,
  **ADR-004 programmatic schema API** — none read by pass 1. ADR-002 and
  `docs/exp/path-centric-query-dsl.md` are *directly* path-relevant and are the
  single biggest miss (the report's §6 "what this means for paths" was written
  without the estate's actual path DSL work).
- rowan `docs/sys/**` — ~50 system docs incl. `schema/{differ,decision-log,
  history,snapshot,watcher,migration-generator,codegen,export,d2-export,dot-export}`
  and `store-adapters/{jsonl,memory,sequel,yaml-frontmatter}` — the implementation
  layer. Pass 1 read only `docs/usr/{09,10}`.
- rowan `lib/archema/**` — 46 files, never opened. Brief says code matters.
- autopax `docs/ADR/migration-proposals/**` — 9 successor ADRs, ~5000 lines.
  These *supersede*. Pass 1 read only the original 008/012.
- autopax ADRs 002b/004/005/010/013 unread.
- relata `TODO-ingest.md` (280KB), `docs/sys/**`, `lib/**` unread.

## Read log

(appended as I go)

### 2026-07-23 reads

- rowan `docs/dev/adr-002-dig-style-filter-paths.md` (97L, Status: **Draft**, 2025-12-09)
  — array-based paths `[:author, :role]` as data-not-syntax; rationale table vs
  string DSL / blocks / AST; "maps naturally to JSON-query/JSONPath".
- rowan `docs/exp/path-centric-query-dsl.md` (1624L) — **THE major miss of pass 1.**
  Four parts: (1) dialect comparison dig/jq/XPath/CSS/SQL/Cypher + path-centric vs
  set-centric expressiveness proof + relational-algebra + category-theory framing +
  "The Inversion" (expressive schema → simple queries) + "escape hatch enriches the
  schema, not the query" + views-as-Resources + cross-store path traversal;
  (2) CQRS/event-sourcing research (Commanded execute/apply; AshEvents actions-as-events,
  replay routing, changed_attributes); (3) domain-action gap + 6 "beyond Ash" observations;
  (4) **empirical hallway-testing findings from 20+ agent challenges** — 12 numbered
  findings + Round 2. This is de-novo agent testimony at scale.

### Corrections established so far (each replaces a pass-1 claim)

1. **autopax ADR-008 is banner-flagged "CAUTION : DO NOT USE"** (`008-yaml-and-schemas.md:3-6`),
   superseded by `migration-proposals/008-yaml-and-schemas.md`. Pass 1 cites the
   deprecated original 5×. ALSO carries a Scope Reduction note (2025-12-15): ADR-012
   moves schema versioning/validation/migration *out* of 008 into Archema; 008 retains
   only YAML conventions + psych-pure + the `_schema` convention. 7 ADRs (003/005/007/
   008/009/010/011) carry the same banner.
2. **ADR-012 is `status: DRAFT`, deciders `[Joseph]`, never accepted.** Pass 1's framing
   ("pivoted to adopt Archema") overstates. `supersedes: ["[[008]]"]` confirmed.
3. **Schema history path**: docs/usr/10 says `.archema/schema_history/user/v1.0.0.yaml`
   (dir per resource); **code** says `.archema/schema_history/<name>.yaml`, one file per
   resource, all evolutions inside (`lib/archema/schema/history.rb:288`). Pass 1 inherited
   the doc.
4. **The yaml_frontmatter store DSL** pass 1 quoted (`store :yaml_frontmatter, path: ->`)
   is the ADR-012 *sketch*. Shipped signature: `store :yaml_frontmatter, directory:,
   extension:, body_attribute:, filename_attribute:, schema_field:`.
5. **`_schema` vs `_schema_version`**: yaml_frontmatter defaults `schema_field: :_schema`;
   jsonl defaults `:_schema_version`. Real inconsistency, not in pass 1.
6. autopax is **dormant** (last substantive commit 2025-12-20); relata is **live**
   (through 2026-07-13). Pass 1 gives no liveness signal.

### More reads
- rowan ADR-001 (store composition, 597L) — 3 perspectives; StoreEntry tuple; ISSUE-053
  roles-are-arbitrary-symbols-with-prefix-inferred-behaviors; Level-1/2/3 resolver
  decision (L3 out of scope); `:readwrite` demotion algebra; `data_layer` deprecation.
- rowan ADR-004 (programmatic schema API) — Erlang/OTP mental model; `sync!`; runtime
  `evolve`; source-code annotations `#>`; cluster coordination.
- rowan `docs/dev/plan-safe-rdbms-evolution.md` (464L) — **the deep evolution doc**;
  expand/monitor/contract/historical-awareness; `.archema/transitions/*.yaml`;
  `# {{replaces: :name}}` agent annotation; `as_of` on data AND schema; full
  Ambler/Sadalage refactoring catalog incl. relationship refactorings; explicit
  implemented-vs-pending list.
- rowan `docs/ref/migration-survey/migration-survey-findings.md` — 23 repos / 6,201
  migrations / 12,072 mutations; expand:contract 5:1; models change 5.1x schema.
- rowan code: yaml_frontmatter.rb (read pipeline order), jsonl.rb (hash chain, tombstones),
  resource/versioning.rb (upcast chains, backward/forward_compatible_with, evolve).
- autopax `docs/ADR/README.md` — **the ADR system is itself a doc-store-as-database**
  (typed frontmatter, status state machine, supersedes/superseded_by, blocked_by/needed_for
  join edges, aliases, immutability-when-decided). Not in pass 1 at all.
- autopax `lib/autopax/resources/agent_card.rb` — shipped resource; `primary_key :name`;
  dual addressing (registry store vs `load_path`).
- relata `lib/relata/designator.rb` — **Kripke rigid-designator framing**, 5 kinds,
  precedence, :unique/:choices/:none, retired-key aliases. The best paths artifact found.
- relata `lib/relata/safe_write.rb` — tmp+fsync+atomic-rename durability primitive.

## STATUS: first pass COMPLETE (2026-07-23)

`README.md` rewritten and extended in place: ~2,180 lines / ~18,600 words,
185 footnotes (all referenced ↔ defined, verified programmatically), 17
sections + a Revision note carrying 10 numbered corrections (C1–C10).

Structure: 0 thesis · 1 two lineages · 2 core pattern · 3 sqlite trade study ·
4 record/resource/FRBR · 5 schema first-class · 6 versioning (deep) · 7 write
membrane · 8 addressing/designators · 9 paths-as-queries · 10 empirical layers ·
11 ADR-system-as-doc-store · 12 schema over prose · 13 tool export ·
14 implementation reality · 15 lite instances · 16 → paths · 17 → agentic
tooling · coverage · footnotes.

Awaiting the cross-check list for a second pass. Highest-value unread, in order:
rowan `docs/msc/plan-recursive-embedded-schemas.md` and
`exploration-graph-resource-unification.md`; relata `TODO-ingest.md` §7 (the
evidence model / single decision rule / calibration); relata
`lib/relata/{evidence_ledger,verification_event,markdown_store,spool}.rb`;
autopax ADR-002b (signum schema) and ADR-005 (semantic model identity).

## PASS 2 COMPLETE (2026-07-23)

README.md now ~3,010 lines / ~26k words / 237 footnotes (all resolve; one deliberate
tombstone). Sections 16–17 are new; pass-1's 16–17 became 18–19.

### The steward correction, and what it opened
C2 stands; **C3 was my error, not pass 1's.** ADR-012's `status: DRAFT` is stale AND its
checklist is a template copy — progress lives in OPERATA, which the ADR README says
explicitly and which I still failed to consult. `autopax-OPERATA.md` records Archema
Phases 0/1/2 DONE. The pivot landed.

### Highest-value new finding (§1.4)
The graft's stall is precisely located: Phases 0–2 (greenfield substrate registry, thin
agent-card replacement) landed 12-15→12-17; Phase 3 (CHRONICA/TRACTUS, blocking item
"verify BLAKE3 hash chain compatibility") never started; 12-17→12-20 is ~100 commits of
TUI work, then the repo stops. chronica/ still has zero Archema refs.
⇒ **A resource layer retrofits cheaply into new/thin subsystems and stalls at the ones
that already work and hold their own integrity invariants — i.e. the ones you needed it
for. Sequence the hardest invariant-bearing subsystem first.**
Dating: nexum (2025-11-06) PREDATES autopax (11-15) — it is a sibling in the
sapientia→zoetica→ennaos→nexum harness lineage, not a consequence. firmatum (2026-02-23)
and shoshin (2026-03-07) DO sit where Joseph placed them.

### Second weighting-shape finding (§1.5)
Three scales of supersession — across documents (banner), across stores (no local
signal), within one document (no signal at all). Pass 1 fell into #1, pass 2 into #2 and
#3. **C11: I cited relata's 8 MB blob-tier framework, which Joseph disavowed 2026-05-19
as "someone took liberties"; §11 #10 calls it "a hallucinated invariant dressed as
principle."** §4.3 rewritten; the footnote is kept as a tombstone.

### Still open / next
- `harness/proprium/` design-of-record set (CHRONICA-PORT-SPEC especially) — the LIVE
  successor to §7's CHRONICA material. Biggest remaining gap.
- relata `TODO-ingest.md` §16's 33 session logs — where §11 items get amended, so the
  likeliest remaining source of stale citations in this report.
- udon-needs body reports + DECISIONS X1–X6; firmatum/ and shoshin/ as repos.

## PASS 3 COMPLETE (2026-07-23) — targeted

1. **CHRONICA question closed (§1.4).** The blocking invariant was neither resolved nor
   worked around: `CHRONICA-PORT-SPEC.md` (2026-07-20) makes autopax's hand-rolled log
   the **"highest-ROI integrity port," "verified by reading,"** and ports its BLAKE3 /
   canonical-JSON / verify-on-load design as the *specification* for an independent Rust
   spine. Archema is absent. Sharpened lesson: *a schema layer that cannot absorb your
   integrity-critical subsystem has not found a hard case; it has found the case that
   will outlive it.* Bonus timing detail: autopax's rich event schema was paused
   2025-12-14 — the day before Archema Phase 0 — and never resumed.
2. **C13 — my §12.2 stage claim was an overclaim.** Corrected against `logos/refs`,
   which is a *fourth*-generation descendant of neurips/refs (adaptation-provenance note,
   2026-05-09) and where `bin/refs lint` IS the pre-submission anonymization gate.
   Rule now: gate-or-warn = deployment stakes × reversibility, not a property of the
   field. §1.5 rule 3 narrowed; enforcement-profile (casual/careful/critical) connection
   drawn.
3. **Standalone pass.** Structural scan found no section leaning without carrying;
   closed two specific artifact gaps (projected-constraint table §5; emitted tool
   definition §13).

Final: ~3,180 lines / ~29,200 words / 247 footnotes; 1 deliberate tombstone.

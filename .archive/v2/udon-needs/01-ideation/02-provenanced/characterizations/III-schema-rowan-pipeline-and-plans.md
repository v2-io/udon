---
source: rowan (ex-Archema) — the schema pipeline suite + forward-looking plan docs + programmatic API guide
gathered: 2026-07-21
status: characterization (heads/doc-comments + plan intros read; full bodies skimmed, not copied — these are mechanism/plumbing whose DEMAND is the shape, not the code)
paths:
  - rowan/lib/archema/schema/{history,snapshot,operations,codegen,export,dot_export,d2_export}.rb
  - rowan/docs/msc/plan-{memory-store-versioning,document-schema-constraints,recursive-embedded-schemas,runtime-schema-evolution}.md
  - rowan/docs/usr/14-schema-api.md
  - rowan/docs/msc/archema-ash-comparison-{plan,research}.md
source_commit: 0ecf61a (rowan)
categories: [schema-as-source-of-truth, auto-versioning-by-observation, derive-everything, runtime-evolution, recursive-schemas, negative-space-ash]
why_included: >
  The M-priority rowan schema rows: the "resources authoritative → everything derives" pipeline, the
  forward-looking design plans (two shipped, two draft), the programmatic API, and the Ash comparison as
  negative-space. Characterized (not copied) because the demand they witness is the ARCHITECTURE, not the
  Ruby. The three H-priority pipeline cores (versioning.rb, differ.rb, decision_log.rb) ARE copied verbatim
  in copies/III-schema/; this report covers the surrounding suite so the section's coverage is honest.
---

# rowan schema pipeline + plans — characterization

> Extraction scope note: doc-comment heads of the seven pipeline `.rb` files and the intros/outcomes of the four plan docs + the 14-schema-api guide were read directly; full bodies were skimmed. The three richest pipeline files (`versioning.rb`, `differ.rb`, `decision_log.rb`) are copied verbatim under `copies/III-schema/` and are not re-characterized here.

## The demand these witness: "resources authoritative, everything else derives by diffing snapshots"

The pipeline is a worked embodiment of *schema-as-single-source-of-truth* — the exact thing UDON's `design/udon-schema-exploration.md` (Puzzle Piece 10: "Derivation Targets") and the "one source, many projections" positioning reach for. The rowan shape:

- **`snapshot.rb`** — captures a resource's schema as a serializable snapshot. "Instead of writing migrations manually, you modify resources and the system diffs snapshots to determine what migrations are needed." Snapshots are the foundation of Ash-style migrations.
- **`differ.rb`** *(copied verbatim)* — diffs two snapshots → operations + conflicts (rename-detection heuristics, `:possible_rename`/`:type_change` requiring human/agent resolution, expand/contract).
- **`codegen.rb`** — "the heart of Ash-style migrations: resources are authoritative, and migrations are derived by diffing snapshots." Generates Sequel migrations from resource-definition changes.
- **`history.rb`** — tracks schema evolution over time in `.archema/schema_history/{resource}.yaml` (snapshots + changes + decision-refs). The foundation for **auto-versioning**: the system infers appropriate version bumps from observed change rather than requiring manual version declaration.
- **`decision_log.rb`** *(copied verbatim)* — durable replayable ambiguity resolutions.
- **`operations.rb`** — the first-class Ruby API for all schema ops; the CLI (`archema migrate`, `schema:check`) is a thin wrapper. (Mirrored in `docs/usr/14-schema-api.md`: `Archema::Schema.snapshot(User)`, `.diff(User)`, etc. — programmatic access for test setup / REPL / custom tooling.)
- **`export.rb` / `dot_export.rb` / `d2_export.rb`** — the *derivation targets*: one schema → **JSON Schema** (editor autocomplete + external validation + Schemacop-for-autopax), **Graphviz DOT**, and **D2** domain-model diagrams (resource-level view, not ERD; Liquid-templated). This is the "schema compiles to everything" demand made concrete: validation formats, editor support, and docs all fall out of the single definition.

**Cross-tier note:** `export.rb` explicitly generates *Schemacop schemas "for Autopax integration"* — the same Schemacop that autopax ADR-008 built its pre-rowan wishlist API around. The derive-everything pipeline is what let autopax ADR-012 retire its own schema stack (adopt-vs-build).

## Forward-looking plans (two shipped, two draft)

- **`plan-runtime-schema-evolution.md`** — ✅ Complete 2025-12-19. `Resource.evolve` for runtime schema mutation on long-running processes; operations: `add_field`, `rename_field`, `split_field`, `merge_fields`, `transform_field`, `remove_field`; automatic minor-version bump; in-memory records upcast on next read. (This is the `evolve` DSL documented in `versioning.rb`.)
- **`plan-memory-store-versioning.md`** — ✅ Complete 2025-12-19. Memory adapter stamps `_schema_version` on create/update; `was:` renames + `upcast from:` applied on read; a cross-adapter consistency test (Memory/JSONL/YAML) — the demand that schema evolution behave **identically across storage backends**.
- **`plan-document-schema-constraints.md`** — Draft. Extends ADR-003's constraint system (the `one_of`/`any_of`/`when_value`/`dependent_required` in `constraints.rb`) toward full JSON-Schema constraint coverage with best-effort RDBMS projection.
- **`plan-recursive-embedded-schemas.md`** — Draft. Naturally-recursive domain models: a tree of Efforts each containing child Efforts, comment threads, org charts. Directly relevant to UDON's self-nesting structure and Puzzle Piece 3/4 (recursive schemas) — an unmet want worth surfacing.

## Ash comparison — negative-space (skimmed)

`archema-ash-comparison-{plan,research}.md` (plan 179L; research 1,619L) set out to produce a citation-backed comparison of rowan vs Elixir's Ash: what rowan genuinely adds beyond Ash, what Ash has that rowan could learn from, what both aspire to but haven't shipped. Adopted-vs-rejected schema conventions here are **negative-space** demand info (what a schema layer deliberately chose NOT to carry from the Ash lineage). Not copied — large, and the on-topic signal is the *fact and axis* of the comparison more than its 1,600 lines. Flag for phase-2 if the "what's genuinely novel vs inherited" question becomes load-bearing.

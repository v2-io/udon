---
source: III-schema extraction commentary (rowan · autopax · operata schema-versioning family)
gathered: 2026-07-21
status: commentary (witness lines, cross-tier convergence flags, one surfaced divergence, and L-row dispositions)
categories: [schema-versioning, cross-tier-convergence, divergence-for-joseph, witness]
why_included: >
  The non-copyable signal from Part III's schema-versioning section: the cross-tier convergences (the
  compilation's highest-value content), one divergence surfaced for Joseph (a TARGET-FILES misattribution),
  and the L-priority witness lines whose existence/shape is the evidence.
---

# III-schema — witness lines & cross-tier notes

## The one divergence to surface for Joseph (TARGET-FILES misattribution)

TARGET-FILES Part III describes `~/src/rowan/docs/msc/feedback.md` as *"Rare rowan doc reasoning in UDON-shaped syntax (RelaxNG-compact-style, `?`/`!`/`*`/`+` cardinality) — cited by UDON's own schema exploration as 'Puzzle Piece 1'."* That is a **misattribution**, verified three ways:

1. The current `rowan/docs/msc/feedback.md` has **one commit** (`git log --follow`) and contains **no** RelaxNG-compact syntax — it is an agent's in-vivo *friction log* (12 issues + praise building the first real SQLite resource). Copied anyway for its genuine value → `copies/III-schema/rowan-feedback.md`.
2. The RelaxNG-compact cardinality syntax (`:author! string`, `:date? date`, `?/!/*/+`, and the `;?` uncertainty marker) actually lives in **`~/src/udon/design/udon-schema-exploration.md`**, §"Puzzle Piece 1: Basic Schema (feedback.md)" — which references a *different, now-absent* `feedback.md`. (That file is a Part I §3 target, i.e. another agent's territory / already registered.)
3. The idea **traces to the Jan-5-2026 origin conversation** where Joseph first sketched it — `|field[tags-by-category]? |{map :string [:integer]}  ; ? (or *,+,!) ... cardinality` and `|field[name] string not null`. Excerpted → `copies/III-schema/origin-udon-as-schema-dsl-EXCERPT.md`.

Net: the "Puzzle Piece 1 feedback.md" and the current rowan feedback.md are **two different files** that happen to share a basename — exactly the duplicate-by-filename trap. No action taken beyond flagging; the cardinality-syntax demand is fully captured (origin excerpt), and the friction-log value is captured (feedback.md copy). Steward call: whether to fix the row's Why is Joseph's / the synthesizers'.

## Cross-tier convergences (flag, don't manufacture — most of this corpus is single-author)

The compilation's highest-value content is agreement *across tiers* (theory ↔ shipped practice ↔ agent testimony), because their failure modes differ. Within this section:

- **CROWN — empirical practice ⟂ the whole schema-checker demand.** The yaml-spike (Tier-2 shipped practice, adversarially stress-tested) *independently generates* the requirements list that rowan's DSL (design ideology) merely asserts: duplicate-key silent data loss, semantic validation yq won't do, migration non-atomicity, backup-required agent recovery. FAILURE_MODES.md's "what YAML silently accepts" table ≈ a spec for what `constraints.rb` + a UDON checker must catch. This is the genuine cross-tier triangulation in the section — the spike didn't read the DSL; it broke real files.
- **The 1,950-migration corpus (Tier-2 empirical) ⟂ the versioning DSL primitives.** `schema-evolution-patterns.md` grounds `versioning.rb`'s `was:`/`since:`/upcast/`evolve` primitives in observed reality (6 evolution ladders, 8.5% asymmetric) rather than intuition. NB the underlying dataset (`_ref/rails-migrations-survey/`) is flagged **unverified** in TARGET-FILES dry-wells — carry that caveat forward.
- **Semver-for-documents, re-derived in THREE places — coherence, NOT corroboration.** rowan (`schema_version`/`backward_compatible_with`), autopax ADR-008 (§Part 3 versioned documents + version-bump-vs-change-semantics table), and autopax ADR-002b (§P4 major/minor/patch *for parsers*, decoupled from CLI) all land on the same `_schema: type/version` self-describing pattern with semver-carries-compatibility semantics. **Single author (Joseph) across his own projects** → this is design coherence, not independent triangulation. Flagged as convergence-of-worth (it shows the idea's stability across contexts), explicitly NOT counted as multi-source corroboration.
- **The adopt-vs-build hinge.** operata-storage-exploration (the session) → autopax ADR-008 (build our own on Schemacop) → autopax ADR-012 (adopt rowan instead) → rowan as schema's "first waiting customer." A single decision trail spanning three repos; the connective document is `operata-storage-exploration.md`.

## L-priority witness lines (existence/shape is the evidence)

- `~/src/autopax/TAXONOMY.md` — **Orthogonal Sovereignty Dimensions** (Visibility: sealed/restricted/open; Authority: system/sovereign/collective; Distinctiveness: how instantiated). Witness: these are **schema-level metadata needs** an agent-facing document format may have to carry per-node — access + write-authority + append-only semantics as first-class schema facets, not afterthoughts. (autopax SHA 033af13.) The Markdown twin `TAXONOMY.md` also appears in Part I §5c at different priority — both stand.
- `~/src/operata/docs/msc/archema-bugs-found.md` — one real "broke using rowan in anger" report (2025-12-06): atom-array filter values wrapped as SQL identifiers (backticks) instead of string values (quotes). Witness: it's a **query-layer** bug, NOT versioning — correctly L/adjacent; confirms the row's own caveat. Value is that it exists (a live consumer hit real bugs and they went upstream, per the "don't work around Archema, fix Archema" DSF ethos in ADR-012). (operata SHA 624f840.)
- `~/src/rowan/lib/archema/{types,shared_types}.rb` + `resource/evolution_context.rb` — listed-not-read in TARGET-FILES; **not opened this pass** (budget). Likely more type/evolution mechanism; carried forward as a known residual, not a dry well.
- `~/src/rowan/LEXICON.md` (591L) — vocabulary aid, **not opened**; useful only as a reading aid for the above, no independent demand signal expected. Residual, low value.

## Honest coverage summary for this section

Copied verbatim (16 files → `copies/III-schema/`): crown yaml-spike ×6 (v1 FAILURE_MODES + VERDICT; v2 VERDICT_UPDATED + ADVERSARIAL_SUMMARY + MIGRATION_REALITY + RECOVERY_SCENARIOS), rowan H ×8 (versioning/differ/decision_log/constraints .rb, 10-schema-evolution, schema-evolution-patterns, adr-003, feedback), autopax ADRs ×3 (002b/008/012), operata storage-exploration, origin-conversation excerpt. Characterized (1): rowan pipeline suite + plan docs + ash-comparison. Witnessed/residual (this file): TAXONOMY, archema-bugs-found, types/shared_types/evolution_context (unopened), LEXICON (unopened). Not fruitful/adjacent: rowan `docs/sys/schema/*.md` + `docs/sys/resource/{versioning,dsl}.md` — verified **auto-generated** (each carries `generated: … source: lib/archema/schema/<file>.rb` frontmatter), i.e. mechanically-derived restatements of the lib `.rb` files already copied verbatim; not separately copied (verbatim-redundancy rule). `docs/dev/adr-004-programmatic-schema-api.md` + `docs/usr/14-schema-api.md` mirror `operations.rb` (the programmatic API) — witnessed via head-read, not copied. Every visit is in the LEDGER.

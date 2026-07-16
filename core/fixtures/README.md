# UDON fixtures — version-scoped compliance groups

Test fixtures live here, grouped by the spec version they target. This lifts
them out of `udon-core/tests/` so the corpus is a first-level, accessible
concern independent of the Rust harness.

```
core/fixtures/
├── v0.9/              ← ACTIVE compliance-fixture group (the harness runs this)
│   └── *.yaml         ← seeded from v0.8; being edited to CORE 0.9.0-alpha.1
├── v0.8/              ← FROZEN, RELEASED. The core-v0.8.0 contract; udon-core passes it.
└── legacy-pre-0.8/    ← FROZEN. Not run. Reference + mining source.
```

## The active group is the compliance definition

`spec/CORE-VERSION` is the operable source of truth for the current version.
**Compliance means "the parser passes the fixtures in the active group
directory."** The harness discovers `*.yaml` in the active group dynamically
(see `../udon-core/tests/common/loader.rs::active_fixture_names`), so cases
added during a rebuild are picked up automatically, without editing the
harness.

The active group is named by the constant `ACTIVE_GROUP` in `loader.rs`. When
the spec advances, add the new group directory and bump that one constant.
The `version_declarations_agree` test in `canonical.rs` asserts that
`CORE-VERSION`, `udon_core::CORE_COMPLIANCE`, and `ACTIVE_GROUP` move
together.

### Expected state right now

`v0.9/` (~380 cases + harness variations; densified 2026-07-16 with EOF/
recovery, legacy-mined regressions, attribute-model combinations, and
cross-feature interplay) was rewritten to the ratified 0.9 attribute model 2026-07-16
(expectations from the spec text, never traced from parser output) and the
grammar burn-down brought the gate **GREEN the same day** — the parser
implements the 0.9 model (flags, boundary rule, blobs, node values, flat
stacking wire with SAVE-based segment re-emission). Densification continues
(EOF/Unclosed* cases, legacy mining, edge combinations) before any
`core-v0.9.0` tag; new cases may re-RED the gate — that stays the honest
signal:

```bash
cargo test -p udon-core --test canonical compliance_gate
```

Two residuals rolled forward from the 0.8 authoring pass also live in this
group's work: mining `legacy-pre-0.8/` for still-valid regression cases
(esp. indentation edge cases, prose-dedentation depth, element-name charset
torture) and densifying edge/combination coverage.

## v0.8/ is frozen and released

The `core-v0.8.0` contract (tag of the same name, 2026-07-15): ~233 cases
derived directly from `spec/CORE.md` 0.8.0, one file per spec area, every
expectation written from the spec text. `udon-core` passes the full group —
the first compliant parser. **Do not edit**; the 0.9 evolution happens in
`v0.9/`.

## legacy-pre-0.8/ is frozen

These 32 fixtures were written against the pre-0.8 model (before the unified
escape model, numbers overhaul, identity `key`/`traits`, and `<…>` typing).
They are **non-compliant by construction** and are **not run** by the harness.

They are kept intact and unmodified for two reasons:

1. **Reference** — how the pre-0.8 model behaved, case by case.
2. **Mining source** — the rebuild lifts still-valid regression cases out of
   here into the active group. That sorting happens in the rebuild; the
   archive is deliberately kept whole (not pre-sorted into valid/invalid).

The switch-over is marked by the git tag `grammar-v0.7`. After that tag there
is no obligation to run legacy — it is archaeology plus a quarry.

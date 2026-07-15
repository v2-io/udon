# UDON fixtures — version-scoped compliance groups

Test fixtures live here, grouped by the spec version they target. This lifts
them out of `udon-core/tests/` so the corpus is a first-level, accessible
concern independent of the Rust harness.

```
core/fixtures/
├── v0.8/              ← ACTIVE compliance-fixture group (the harness runs this)
│   └── *.yaml         ← ~226 spec-derived cases, one file per CORE area
└── legacy-pre-0.8/    ← FROZEN. Not run. Reference + mining source.
```

## The active group is the compliance definition

`spec/CORE-VERSION` is `0.8.0-alpha.1`. **Compliance means "the parser passes
the fixtures in the active group directory"** — and `v0.8/` *is* that group.
The harness discovers `*.yaml` in `v0.8/` dynamically (see
`../udon-core/tests/common/loader.rs::active_fixture_names`), so cases added
during the rebuild are picked up automatically, without editing the harness.

The active group is named by the constant `ACTIVE_GROUP` in `loader.rs`. When
the spec advances (e.g. `v0.9`), add the new group directory and bump that one
constant.

### Expected state right now

`v0.8/` was populated 2026-07-15 with ~230 cases derived directly from
`spec/CORE.md` v0.8.0-alpha.1 (one file per spec area; every expectation
written from the spec text, never traced from parser output). The grammar
burn-down is underway — RED is the honest work-remaining signal, and the
gate prints the live per-file counts:

```bash
cargo test -p udon-core --test canonical v0_8_compliance_group
```

Where CORE is silent on an event-level detail, the case carries a `⚠` comment
naming the reading it encodes, and the silence is filed in
`spec/TODO-SPEC-CORE.md` (see "Silences found while authoring the v0.8
fixtures") — those readings are proposals awaiting Joseph's ratification, and
the affected cases (notably the whole proposed `TypedValue` vocabulary in
`typing_envelope.yaml`) may be edited when he rules.

## legacy-pre-0.8/ is frozen

These 32 fixtures were written against the pre-0.8 model (before the unified
escape model, numbers overhaul, identity `key`/`traits`, and `<…>` typing).
They are **non-compliant by construction** and are **not run** by the harness.

They are kept intact and unmodified for two reasons:

1. **Reference** — how the pre-0.8 model behaved, case by case.
2. **Mining source** — the 0.8 rebuild lifts the still-valid regression cases
   out of here into `v0.8/`. That sorting happens in the rebuild; the archive
   is deliberately kept whole (not pre-sorted into valid/invalid).

The switch-over is marked by the git tag `grammar-v0.7`. After that tag there
is no obligation to run legacy — it is archaeology plus a quarry.

# UDON fixtures — version-scoped compliance groups

Test fixtures live here, grouped by the spec version they target. This lifts
them out of `udon-core/tests/` so the corpus is a first-level, accessible
concern independent of the Rust harness.

```
core/fixtures/
├── v0.8/              ← ACTIVE compliance-fixture group (the harness runs this)
│   └── smoke.yaml     ← trivial placeholder; real cases land in the rebuild
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

`v0.8/` holds a single smoke case with `events: []`, which runs the parser for
panics but asserts no output. The suite is therefore **green-trivial** today.
As real 0.8 cases (with filled-in `events:`) land, the suite is **expected to
go RED** against the still-pre-0.8 parser until the parser itself is rebuilt.
That RED is the correct, honest signal — not a regression to chase.

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

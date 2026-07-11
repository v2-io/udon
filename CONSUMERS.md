# UDON Consumers — live usage registry

Documents in active use outside this repo. **Purpose**: when a syntax
decision lands (REVIEW §7-F), a defect fix changes behavior, or a new tool
becomes available (linter, formatter, paths), this is the list of who must
be migrated or told. Refresh with `bin/find-consumers` and update the table;
last full scan: **2026-07-11**.

## Scan roots

- `~/src/archema-io/**/*.udon` — the ARCHEMA program (will become
  `~/src/archema/` eventually; distinct from `~/src/rowan/`, the former
  ruby ash port that previously held the archema name)
- `~/src/**/*.udon` (depth-limited) — catches consumers outside archema-io
- Excluded: this repo, `~/src/_ref/`, `.git`

## Live inventory (2026-07-11)

| Document | Lines | Decision exposure | Notes |
|---|---|---|---|
| `archema-io/asf/msc/meta-process-review-2026-07-07/PROCESS-MAP-v0.udon` | 489 | **50 `[key]` ids** (decision 1), 6 `?` suffixes (decision 1c), 1 bare date (decision 2), 1 `!` directive | The founding adopter — ASF process map, under active evolution |
| `archema-io/vivarium/LEXICON.udon` | 1151 | **100 `[key]` ids**, **20 bare dates** (decision 2), 3 `!` directives | Largest live document; heaviest temporal exposure |
| `archema-io/vivarium/doc/PROCESS.udon` | 178 | 23 `[key]` ids, 1 date, 2 `!` directives | |
| `autopax/taxonomy.udon` | 371 | 51 `[key]` ids, 3 `?` suffixes, 6 dates | Consumer outside archema-io — the scan-wide root earns its keep |

**Aggregate exposure**: 224 `[key]` identities and 28 bare temporal values
across ~2,200 lines. **Nobody uses `@` references, inline `|{…}` elements,
fences, or durations yet** — so decisions 1a (reference sigil) and 8
(fences) currently have *zero* migration cost, while decision 1b
(`$id`/`key` naming: affects how `[key]` surfaces in tooling/AST, not the
document syntax) and decision 2 (temporal) have real but modest exposure.
This is the window: decide before the corpus grows.

## Notification triggers

Ping/migrate consumers when any of these land:

1. **Decision 1 (identity)** — 224 `[key]` sites; syntax itself likely
   stable, but tooling-visible naming changes.
2. **Decision 2 (value-dialects)** — 28 bare dates; if temporal becomes a
   declared dialect, these documents need a pragma line (or the default-on
   profile makes it a no-op).
3. **Temporal validation implementation (defect 3)** — stricter parsing
   could reclassify malformed values; scan before/after.
4. **First tool releases** (`udon-cli` lint/fmt/skeleton) — proactively
   offer to the ASF/vivarium/autopax workflows; the linter's reflow-damage
   heuristics matter most for hand-edited maps.
5. **Parser regeneration or spec backports** — run consumers through the
   parser before/after (`bin/find-consumers --check` parses each and
   reports errors/warnings).

## Discipline

- Re-scan when adopting any §7-F decision (`bin/find-consumers` diffs
  against the inventory above).
- New consumers: add a row with decision-exposure counts (the scan prints
  them).
- This registry is itself a candidate for `.udon` once the linter exists.

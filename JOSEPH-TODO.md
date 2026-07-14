# JOSEPH-TODO — the valve

Only what still needs Joseph. Prune on decision. Last pruned: 2026-07-14.

**Nothing blocks the work.** The ratified decisions are integrated into
FULL-SPEC; the remaining work (Tier-2 parser, companion-spec recasts) needs no
decision from you — it's tracked in `spec/FULL-SPEC-TODO.md`.

## Genuinely needs you

- *(nothing blocking — the numeric-literals calls resolved 2026-07-14; see
  History)*

One thing is **parked, not blocking**: whether bare rational/complex survive in
the core or move into a standard-types `<…>` dialect. Rationals lean dialect;
complex has no lean. Not a call for today — it firms up when the dialect layer
lands, driven by vivarium/ASF needs (uom, significant figures). Tracked in
`design/composite-types.md`.

## Parked (NOT waiting on you)

- Optional `udon fmt` — IF ever built; UDON mandates no canonical form.
- Filename-designator ↔ pragma binding — when the schema layer lands.

## History

All decisions live in FULL-SPEC (authoritative) + git history; the archived
ledger is `decisions/DECIDED.bak.md`, the predecessor briefs in
`decisions/_superseded/`. This session resolved `:[id]` (dropped), mixins
(non-core / experimental), the `'`-string-delimiter (kept), multi-attr block
lines (keep EOL semantics + Warning on stranded `:word`), and completed the full
spec-text integration. Obsidian plugin installed into the shared config and
smoke-tested (works) — its own feedback lives in `editors/obsidian-udon/TODO.md`.

2026-07-14 resolved the numeric-literals calls: `0d`/`0D` explicit-decimal
ratified and recorded (FULL-SPEC "Numbers", FULL-EBNF, and `core/PLAN.md` as a
parser item); rational/complex marked *provisional* with the bare-vs-dialect
question deferred to the dialect layer (rationals lean dialect; complex no lean).
Scientific notation confirmed already complete (spec + grammar agree). The
char-class + Numbers back-fill edits are committed (`d844a72`).

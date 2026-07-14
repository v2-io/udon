# JOSEPH-TODO — the valve

Only what still needs Joseph. Prune on decision. Last pruned: 2026-07-13.

**Nothing blocks the work.** The ratified decisions are integrated into
FULL-SPEC; the remaining work (Tier-2 parser, companion-spec recasts) needs no
decision from you — it's tracked in `spec/FULL-SPEC-TODO.md`.

## Genuinely needs you

- **Confirm "multi-attr block lines."** The old worklist said "legalize (drop the
  warning)", but block attribute values run to end-of-line, so `:a 1 :b 2` on a
  *block* line makes `:a` = `"1 :b 2"`. There is no spec text to change; it reads
  as a parser-warning / cheatsheet matter. What did you intend?
- **Obsidian first-load smoke test** (~30 s, only you can): load
  `editors/obsidian-udon/` into a vault, enable, open a `.udon` file.
- **Optional:** two tiny pre-existing FULL-SPEC gaps (quoted-strings-in-arrays;
  `}`-before-`]`) — close now or leave.

## Parked (NOT waiting on you)

- Optional `udon fmt` — IF ever built; UDON mandates no canonical form.
- Filename-designator ↔ pragma binding — when the schema layer lands.

## History

All decisions live in FULL-SPEC (authoritative) + git history; the archived
ledger is `decisions/DECIDED.bak.md`, the predecessor briefs in
`decisions/_superseded/`. This session resolved `:[id]` (dropped), mixins
(non-core / experimental), the `'`-string-delimiter (kept), and completed the
full spec-text integration.

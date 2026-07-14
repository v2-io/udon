# JOSEPH-TODO — the valve

Only what still needs Joseph. Prune on decision. Last pruned: 2026-07-13.

**Nothing blocks the work.** The ratified decisions are integrated into
FULL-SPEC; the remaining work (Tier-2 parser, companion-spec recasts) needs no
decision from you — it's tracked in `spec/FULL-SPEC-TODO.md`.

## Genuinely needs you

- **Numeric literals — two open calls** (active discussion, from the Ruby-vs-UDON
  comparison): (a) support bare `3-4i` negative-imaginary (recommended — natural
  now that bare temporal is gone); (b) rational form — keep `1/3r` only, as a
  documented Ruby *divergence* (recommended), vs. also adding Ruby's `Nr` suffix.
  `0d` explicit-decimal is decided (**add**). These gate committing the back-fill
  agent's char-class + Numbers edits, currently **uncommitted** on
  FULL-SPEC / FULL-EBNF.

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

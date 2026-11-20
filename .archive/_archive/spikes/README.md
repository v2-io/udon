# Archived spikes (July 2026 reboot, REVIEW §9 spike track)

Both spikes here are **fully integrated** — archived 2026-07-16 as the
historical record, not as pending work.

- **S5 `explicit-stack-feasibility-2026-07.md`** (+ `explicit-stack-proto-2026-07.rs`,
  a single-file `rustc` reproduction) — proved the pushdown backend feasible;
  the backend was then **built** (`core/udon-core/src/parser_pd.rs`, proven by
  `tests/pushdown_differential.rs`) and `StreamingTreeParser` rides it.
  Residuals live in `core/TODO-CORE-PARSING.md` (façade retirement, `--trace`
  plumbing, perf) and the inspectable-stack diagnostics dividend is its own
  item there.
- **S3 `prose-collision-2026-07.md`** (+ `prose_collision_probe.py`,
  `commonmark-spec-0.31.2.json` corpus snapshot) — measured CommonMark
  survival (89.7% / 93.0% with the `!` guard, zero silent mutations) and
  reflow collision rates. The 0.9 Marker Recognition guards adopted its top
  two recommendations (`:`-eating fixed, real `!` letter-guard — re-verified
  by probe 2026-07-16); its span-offset side-finding no longer reproduces;
  the whitespace-only-line side-finding is now in `spec/TODO-SPEC-CORE.md`'s
  silences item. The probe + corpus remain the runnable instrument for the
  open "CommonMark non-conflict as a measured gate" item in
  `core/TODO-CORE-PARSING.md`.

# JOSEPH-TODO — the valve

Everything currently blocking on Joseph, ordered by what it unblocks.
Maintained by coordinating sessions; prune on decision. Last: 2026-07-11.

## Big three (each ~10–15 min: read brief, ratify/adjust)

1. **Identity syntax** — [decisions/identity-syntax-brief.md](decisions/identity-syntax-brief.md)
   Rec: split `@` by semantics (inert typed pointer; transclusion = tooling);
   adopt `key`/`traits` as AST fields; bare `?` suffix.
   *Unblocks:* defect #2 (typed keys), paths impl, ~60-line spec edit,
   un-banning `@` refs in vivarium's PROCESS norms.

2. **Value-dialects / temporal** — [decisions/value-dialects-brief.md](decisions/value-dialects-brief.md)
   Rec: temporal as default-on std dialect over a recognition/typing split;
   two sub-calls flagged (shorthand durations; frozen-core enumeration).
   *Unblocks:* defect #3 (temporal validation as one projection module),
   TIME-SPEC recast as `temporal@1`, pragma spec round.

3. **Fence semantics** — [decisions/fence-semantics-brief.md](decisions/fence-semantics-brief.md)
   Rec: ratify any-line-closes + drop sameline fences + CommonMark info
   strings + fence-promotion-in-prose as deliberate.
   *Unblocks:* defects #10/#11/#14, spec backport, the literate-fusion
   pilot (S6) which was nominated to use exactly this feature.

## Review-shaped

4. **libdescent branch review → merge + push** — `~/src/descent` branch
   `rust-rewrite` (10 local commits; PROGRESS.md is the guided tour).
   Acceptance trio verified: byte-identical udon parser regen · 83/83 suite ·
   self-hosting fixed point (Ruby exited). Riding on the merge: (a) ratify
   **byte-identity retirement** (demote diff_generate to on-demand, promote
   udon-suite + front-end differential as standing contract, then execute the
   improvements ledger); (b) **switch umbrella `regenerate-parser` to
   descent-rs** (removes Ruby from CI); (c) the Ruby-side `SC`/`EX`/`BT`/`TAB`
   alias proposal from session 3.

## Small / mechanical

5. **R8 — crates.io reservation**: `udon-core`, `udon-cli` (verified
   available 2026-07-09; `udon`/`descent` are stranger-squatted).
6. **Obsidian first-load smoke test** (~30 s): copy `editors/obsidian-udon/`
   into a vault's `.obsidian/plugins/udon/`, enable, open any `.udon` file.
   You are the first live load.

## Batchable (lower stakes; one sitting when convenient)

7. **Decision 9 — sigil guards**: now data-backed (S3 in review §3/§7-F.9):
   colon-fix already done (data-loss half); call the `!` letter-guard
   (+3.3 pts CommonMark survival) and the `;` guard (aesthetics only — zero
   corpus incidence).
8. **Decision 3 — StreamingParser fate**: S5 settled feasibility; rec is
   delete the façade now, build the explicit-stack backend when a streaming
   consumer is concrete.
9. **Decisions 4–7**: markdown subset (Layer 1 of design/markdown-layers.md);
   escape unification (`\` vs `'`); reference augmentation; BlankLine/Warning
   spec status. Plus the multi-attr-block-line Warning behavior (editor-agent
   find, decision-5 family).

## Not yet ripe (parked, no action)

- fmt policy calls (row-leading pipes in .desc tables; alignment
  normalization) — when `udon fmt` exists.
- descent-Rust crate name — when publishing nears.
- Filename-designator ↔ pragma binding — when the schema layer lands
  (design/file-naming.md records the deliberate deferral).

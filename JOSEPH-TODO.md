# JOSEPH-TODO — the valve

Everything currently blocking on Joseph, ordered by what it unblocks.
Maintained by coordinating sessions; prune on decision. Last: 2026-07-11.
Each item carries the coordinator's recommendation (⭢) with one-line
reasoning — they are inputs, not defaults; nothing proceeds on them without
your ratify.

## Big three (each ~10–15 min: read brief, ratify/adjust)

1. **Identity syntax** — [decisions/identity-syntax-brief.md](decisions/identity-syntax-brief.md)
   **D1a RATIFIED 2026-07-11** (`@` = inert typed pointer; ambiguity-erroring
   shorthand) → see decisions/DECIDED.md. Remaining sub-calls:
   ⭢ **1b**: `key`/`traits` as AST fields — *dissolves `$id`-vs-`id`;
   tree.rs already models identity as a field.* ⭢ **1c**: bare `?` suffix —
   *matches live ASF usage.* Plus one rider from ratification: confirm the
   **key-scope enforcement layer** rec (Document-layer errors on duplicate
   `(type,key)` definitions; event layer stays stateless) — DECIDED.md has
   the reasoning.

2. **Value-dialects / temporal** — [decisions/value-dialects-brief.md](decisions/value-dialects-brief.md)
   ⭢ **Adopt Option B** (temporal as default-on std dialect over the
   recognition/typing split); sub-calls: keep shorthand durations,
   grandfather rational/complex/hex into the frozen core.
   *Because:* the 29 live bare dates make opt-in silently destructive, and
   the recognition/typing split means the surface grammar never has to move
   again — accretion solved permanently, defect #3 becomes one module.

3. **Fence semantics** — [decisions/fence-semantics-brief.md](decisions/fence-semantics-brief.md)
   ⭢ **Adopt the brief's bundle**: any-line-closes, drop sameline fences,
   CommonMark info strings, fence-promotion-in-prose ratified as deliberate.
   *Because:* it's the one coherent CommonMark-shaped story; migration cost
   is exactly zero (no live consumer uses fences) and sameline fences never
   worked anyway — dropping spec text, not behavior.

## Review-shaped

4. **libdescent branch review → merge + push** — `~/src/descent` branch
   `rust-rewrite` (10 local commits; PROGRESS.md is the guided tour).
   Acceptance trio verified: byte-identical udon parser regen · 83/83 suite ·
   self-hosting fixed point (Ruby exited). Riders:
   (a) **byte-identity retirement** — ⭢ ratify; *the plan's own logic:
   oracle was the ratchet, not the goal, and it has now fully done its job.*
   (b) **switch umbrella `regenerate-parser` to descent-rs** — ⭢ yes, but
   sequenced: merge+push first, then one CI cycle running BOTH generators
   in the drift gate before Ruby is dropped from it; *a compiler swap on the
   critical path earns a one-cycle overlap, and Ruby stays available
   on-demand as the historical oracle regardless.*
   (c) `SC`/`EX`/`BT`/`TAB` grammar aliases — ⭢ approve; *same
   oracle-guarded class as #7 quote-aliases, which came back byte-identical.*

## Small / mechanical

5. **R8 — crates.io reservation**: `udon-core`, `udon-cli`.
   ⭢ Do soon; *five-minute task, and the `udon`/`descent` names are already
   lost to squatters — same story, avoidable this time.*
6. **Obsidian first-load smoke test** (~30 s): `editors/obsidian-udon/` →
   vault `.obsidian/plugins/udon/`, enable, open a `.udon` file.
   ⭢ Whenever you next have Obsidian open; *you're the first live load —
   everything else was verified headlessly.*

## Batchable (lower stakes; one sitting when convenient)

7. **Decision 9 — sigil guards**: ⭢ **adopt the `!` letter-guard, skip the
   `;` guard**; colon data-loss already fixed. *The data decided: the
   letter-guard buys +3.3 pts CommonMark survival (every image line); the
   `;` guard's motivating idiom has zero corpus incidence.*
8. **Decision 3 — StreamingParser fate**: ⭢ **delete the façade now**,
   build the explicit-stack backend when a streaming consumer is concrete.
   *A structurally-wrong API is worse than an absent one, and S5 made the
   rebuild a known 2–3 week job instead of a research question.*
9. **Decisions 4–7 + one editor-find**:
   - Markdown subset — ⭢ adopt a Djot-inspired enumeration as Layer 1;
     *naming the subset is cheap and renderer conformance is undefined
     without it (the layer taxonomy already scopes it).*
   - Escape unification — ⭢ `\` everywhere, `'` accepted-with-lint-warning
     through 1.0; *one mechanism is teachable, and feedback.md's own vote
     already went this way — but `'` is in live docs, so deprecate gently.*
   - Reference augmentation (`|[header].highlighted`) — ⭢ no (references
     immutable); *augmentation is tooling-layer work, and immutability keeps
     the ReferenceIndex semantics trivial.*
   - BlankLine/Warning events — ⭢ spec them; *both are now load-bearing
     for round-trip and diagnostics — impl-defined status would re-open the
     genealogy gap we just closed.*
   - Multi-attr block lines (accepted-with-Warning today) — ⭢ legalize;
     *the cheatsheet teaches the idiom; warning on what the onboarding
     artifact models punishes learners for learning.*

## Not yet ripe (parked, no action)

- fmt policy calls (row-leading pipes in .desc tables; alignment
  normalization) — when `udon fmt` exists.
- descent-Rust crate name — when publishing nears.
- Filename-designator ↔ pragma binding — when the schema layer lands
  (design/file-naming.md records the deliberate deferral).

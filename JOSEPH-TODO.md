# JOSEPH-TODO — the valve

Only what still blocks on Joseph. Decided items are removed (full record in
**decisions/DECIDED.md**). Each open item carries the coordinator's
recommendation (⭢) with one-line reasoning — inputs, not defaults. Prune on
decision. Last pruned: 2026-07-11.

## Closed since inception → decisions/DECIDED.md
D1a (+refinement) · D1b-partial · D-ATTR-1/2/3 · D-AUTH-1 · D2 / D2-ET /
D2-ET-ext (value-dialects + `<…>` typing, **decision 2 closed**) · D8 /
D8-unify (+refinements, **fences closed** but for one micro-edge below) ·
LEX-1 (head position) · ARCH-1 (bounded lookahead) · D4 (libdescent riders)
· R8 (crates.io reserved) · libdescent Phase-1 merged.

---

## 1 — Identity: formal close (decision 1) → [decisions/identity-model.md](decisions/identity-model.md)
The whole bundle is now consolidated + drafted in identity-model.md
(substrate, recommended host views incl. the `all_attributes` + `key`/
`traits`/`attributes` split, parser/schema knobs). One "ratify
identity-model.md" closes all of:
- **(C) views-over-reserved-attrs model** — ⭢ ratify (the supplement's rec;
  you independently restated it as the substrate/view split).
- **Wire names** — ⭢ `$key`/`$traits`, single family, no aliases (unifies
  wire/API/docs vocabulary; zero migration; retires the id-connotation debate).
- **D1c suffixes** — ⭢ `$?` family (premise inverted — bare `?` only made
  sense in a `$id`-less world, which lost).
- **Key-scope enforcement** — ⭢ Document-layer errors on duplicate `(type,
  key)` definitions; event/streaming layer stays stateless.
- attrs() API surface + fmt normalization — ⭢ park for impl/fmt charter.

## 2 — Batchable syntax decisions (one sitting)
- **Decision 9 — sigil guards** = the head-position predicates (D8-unify
  ref-2). ⭢ adopt the `!` letter-guard (+3.3pts CommonMark survival), skip
  the `;` guard (zero corpus incidence); colon data-loss already fixed.
- **Decision 3 — StreamingParser fate.** ⭢ delete the façade now; build the
  explicit-stack backend when a streaming consumer is concrete (ARCH-1
  confirms the hard part already works at 1-byte chunks).
- **Decision 5 — escapes.** Strongly leaning **remove `'` as escape**
  (→ `\`-only; drops `'` from the head-position set). Sub-call: does
  `'`-as-string-delimiter also go? Migration: scan live `'`-escape usage first.
- **Decision 4 — markdown subset.** ⭢ adopt a Djot-inspired Layer-1
  enumeration (design/markdown-layers.md scopes it).
- **Decision 6 — reference augmentation** (`|[header].highlighted`). ⭢ no,
  references immutable (keeps ReferenceIndex trivial; augmentation is tooling).
- **Decision 7 — BlankLine/Warning events.** ⭢ spec them (load-bearing for
  round-trip + diagnostics).
- **Multi-attr block lines** (accepted-with-Warning today). ⭢ legalize —
  the cheatsheet teaches the idiom.
- **Fence closer micro-edge.** ⭢ closer's leading whitespace is terminator,
  not body; body ends at the newline before the closer.

## 3 — From the authority-compliance audit (decisions/authority-compliance-audit.md)
- **T1 — Reserved suffix-on-class**: FULL-SPEC reserves `.class?` while the
  supplement shows it valid — the two contradict today. ⭢ reserving
  unallocated *syntax* is legitimate authority-1 (not proscription); resolve
  the contradiction either way.
- **T3 — Dynamics expression grammar**: AUTHORITY says `!`-eval is
  host-owned, FULL-SPEC specs Liquid grammar in core. ⭢ menu/knob reframe:
  core specs the syntax envelope; Liquid moves to a baseline-dialect doc.

## 4 — Mechanical
- **Obsidian first-load smoke test** (~30 s): copy `editors/obsidian-udon/`
  into a vault's `.obsidian/plugins/udon/`, enable, open a `.udon` file.
  You're the first live load; everything else was verified headlessly.

## Discussion-shaped (a conversation, not a ratify)
- **Mixins: rethink or drop entirely.** The `:[base]`-merge question is
  withdrawn pending this. Inputs: subtree inheritance was never defined; the
  ash-like examples lean on mixins; stacking + schema-defaults may subsume
  most mixin use cases.

## Not yet ripe (parked)
- **fmt charter** (when `udon fmt` exists): the canonical-spelling policy for
  every case with >1 equivalent spelling — sugar `[k]`/`.a.b`/`?` vs longhand
  `:'$key'`/`:'$traits'`/`:'$?'`; attribute order; `.desc` row-leading pipes;
  alignment. All pure presentation, zero semantic effect — which is why it
  parks until the formatter exists.
- Filename-designator ↔ pragma binding — when the schema layer lands.

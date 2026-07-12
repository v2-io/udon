# JOSEPH-TODO — the valve

Only what still needs Joseph. Decided items removed (history: DECIDED.md).
Prune on decision. Last pruned: 2026-07-11.

**Bottom line:** *nothing blocks the next real work* — the spec-edit
reconciliation can proceed now on the already-ratified batch (FULL-SPEC-TODO
§A). The items below would be good to fold in while it happens; most are
rubber-stamps.

## Closed → decisions/DECIDED.md
D1a · D1b-partial · D1-terms · **D1-FINAL (identity, decision 1)** · D-ATTR-1/2/3
· D-AUTH-1 (reframed) · D2 / D2-ET / D2-ET-ext (**typing + value-dialects,
decision 2**) · D8 / D8-unify (**fences**) · D9 (sigil markers) · **D-ESCAPE
(remove `'` as escape)** · LEX-1 · ARCH-1 · D4 · R8 · libdescent Phase-1 ·
META-1 (+ AUTHORITY→FULL-SPEC-TODO rename).

---

## Genuine judgment calls (no confident rubber-stamp — your read)
1. **`'` string-delimiter** — `'` is removed as an *escape* (D-ESCAPE ✓); does
   `'`-as-*string-delimiter* (`'foo'`) *also* go, or stay? Genuinely open.
2. **T1 — suffix-on-class** (`.class?`): FULL-SPEC reserves it "for future
   use"; FULL-SPEC-supplement shows it *valid*. They contradict — **allow** or
   keep **reserved**? Pick one.
3. **Mixins — rethink or drop?** A conversation, not a stamp. Inputs: subtree
   inheritance was never spec'd; ash-like examples lean on them; stacking +
   schema-defaults may subsume most uses.

## Rubber-stamps (clear rec — one "go", or flag exceptions)
- **Decision 9 `;` guard** ⭢ skip (zero corpus incidence).
- **Decision 4 — markdown subset** ⭢ Djot-inspired Layer-1 enumeration.
- **Decision 6 — reference augmentation** (`|[header].highlighted`) ⭢ no,
  references immutable.
- **Decision 7 — BlankLine/Warning events** ⭢ spec them.
- **Multi-attr block lines** ⭢ legalize (drop the warning; the cheatsheet
  teaches it).
- **Fence closer micro-edge** ⭢ closer's leading whitespace is terminator,
  body ends at the newline before it.
- **T3 — dynamics grammar** ⭢ menu/knob: envelope syntax in core, Liquid
  expression grammar → a baseline-dialect companion doc.

## Not a decision — queued WORK (was mis-filed as a judgment call)
- **Explicit-stack streaming backend** in `descent-core` — build it (the
  whole point of the descent→Rust rewrite; S5 proved it; vivarium wants it).
  Replaces the broken `StreamingParser` façade (defect #1). ~2–3 wk. Only
  question is priority vs the spec-edit — scheduling, not design.

## Physical (only you can)
- **Obsidian first-load smoke test** (~30 s): `editors/obsidian-udon/` →
  vault `.obsidian/plugins/udon/`, enable, open a `.udon` file.

## Parked (NOT waiting on you)
- Optional `udon fmt` — IF ever built; UDON mandates no canonical form.
- Filename-designator ↔ pragma binding — when the schema layer lands.

# spec-0.10.01 — the material/deferred draft

**Status: PROPOSAL DRAFT, unratified, single-author (one session, 2026-08-27).** A swing at the unified suite, taken so 0.10.0 can rest in peace as the consolidation record. Nothing here is law; `spec-0.10.00/` remains the working base (steward marks C7/C8) until Joseph's pass over this draft's DELTAS rows and ⟨PROPOSED⟩ spellings.

**What it is.** The 0.10.0 language restated on the two-kind ontology — **material** (things, facts, text: determined at writing) and **deferred** (references and generators: determined at use) — with the addressing theory (`../references/def/`) as the vocabulary authority for the deferred half, per `../theory/to-integrate/lexical-forms-redux.md` (the frame) and `../theory/to-integrate/unification-matrix-2026-08-27.md` (the construct-by-construct reconciliation this draft executes).

**The one sentence that shrinks the spec:** *the recognizer holds everything* — determination (resolve, dereference, evaluate, construe) is never recognition's job, so §9-Dynamics' lexical modes, the interpolation form, the bespoke dispatch rules, the ML table, and the resolution-side anomaly rows all leave the core, replaced by one deferred family + citations into machinery def/ defines once.

## Reading order

| File | Role |
|---|---|
| [CORE.md](CORE.md) | The contract. §0 guiding model; §9 (Deferred material) is the new part; material sections are **condensed carries** — 0.10.0 stays the nuance-carrier for unchanged behavior until ratification |
| [DELTAS.md](DELTAS.md) | **Read second.** All ten behavior/surface changes vs 0.10.0, ⟨P⟩-marked where a spelling is minted; the breaking notes |
| [MODEL.md](MODEL.md) | Node/Value kinds under the unification (Generator as element-shape; Capture; HeldReference; Interpolation gone) |
| [GLOSSARY.md](GLOSSARY.md) | Delta-glossary; def/ has primacy for addressing terms |
| [CARVEOUTS.md](CARVEOUTS.md) | Deferrals **with owners** (PATH · HOLD · CAP · EVAL · VOCAB · SCHED) |
| [SEMANTICS.md](SEMANTICS.md) | Carried + five deltas (held-vs-determined is never equivalent) |

Deliberately absent: TUTORIAL/PEDAGOGY (write after ratification — teaching an unratified surface would cement ⟨PROPOSED⟩ spellings by repetition), RATIONALE (the redux + matrix documents *are* the rationale at this stage), wire/event encoding (as in 0.10.0).

## Where a reviewer should push

1. **DELTAS 1/2/5/6** — the four ⟨P⟩ spellings (`@{…}`, parsed generator heads, `@<…>`, cardinality suffixes) are the draft's real bets.
2. **The capture unification's geometric spelling** (CARVEOUTS §CAP) — the one place the draft retains a spelling (`!:kind:`) its own frame calls misfiled.
3. **Anything in a condensed carry that changed meaning without a DELTAS row** — by this suite's own rule, a defect here; say so rather than picking a side.

*Assembled 2026-08-27, same session as the redux/matrix/def-generator arc; single-reader caveat applies to every carry.*

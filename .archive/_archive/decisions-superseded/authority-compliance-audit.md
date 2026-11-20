# Authority-compliance audit — 2026-07-11

Sweep of the umbrella repo against spec/AUTHORITY.md (D-AUTH-1) and the
2026-07-11 ratifications in decisions/DECIDED.md. Every finding is a place
where an artifact assigns a semantic behavior to the wrong authority, or
teaches semantics a ratification has refuted.

**Categories**: (a) prose violation, fixed in this audit's commits ·
(b) violation whose fix rides a named pending decision-execution — listed,
not touched · (c) genuine tension the taxonomy has not resolved — surfaced
below, not forced.

Scope swept: spec/, decisions/ (as law, not target), design/, notes/,
docs/, examples/, test/usability/, editors/, core/ (classify-only),
README.md, CLAUDE.md, CONSUMERS.md, FULL-EBNF. `_archive/` and
`core/_archive/` excluded (archived). REVIEW-JULY-2026.md and
REBOOT-PLAN.md are dated review documents already superseded-by-reference
through DECIDED.md; left untouched.

## Findings

| # | Location | Violation | Cat. | Owner per AUTHORITY.md | Rides |
|---|---|---|---|---|---|
| 1 | README.md:70–74 | Attrs-vs-children table taught "one per key (hash semantics)" and "order doesn't matter" — refuted by ratified stacking + order preservation | **a — fixed** (commit `bf9bf71`) | 1 spec (stacking core); 4 schema (cardinality constraint) | — |
| 2 | examples/practices-gotchas.udon:31 | Same "typed scalars, one per key" teaching in the authoring guide | **a — fixed** | 1 spec / 4 schema | — |
| 3 | examples/cheatsheet.udon:30 | "`@[id]` inserts element" — the refuted transclusion model, in the primary onboarding artifact | **a — fixed** | 1 spec (inert-pointer partition); tooling resolves | — |
| 4 | examples/comprehensive.udon:287, 304, 308 | REFERENCES section taught "Insert entire element (structure + content)" / "Full element insertion" | **a — fixed** | same as #3 | — |
| 5 | notes/analysis.md:664–699 | Historical analysis teaches @-as-insertion and mixin CSS-cascade override | **a — one-line annotation added** (historical doc; no rewrite) | — | — |
| 6 | spec/FULL-SPEC.md:1464–1475 | "`@[id]` -- Insert the entire element (structure and content)" (1466); "Inserts the full \|nav structure here" (1475) — contradicts ratified D1a | **b** | 1 spec forces inert-pointer semantics; 2 parser flag + 3 host defaults own deref (D-ATTR-2) | **D1a spawned spec-edit** (DECIDED.md D1a "Spawned spec-work": rewrite reference section, remove/redirect insertion text) |
| 7 | spec/FULL-SPEC.md:172, 175–180 | `[id]` desugars to `:'$id'`; "Singular identity … unique within scope". Wire name `$id` unratified (converging `$key`/`$traits` single family); "Singular" pre-empts the multi-valued-key rec (spec permits, schema constrains); "within scope" understates the ratified type-scoped `(type,key)` rule | **b** | 1 spec (sugar + permits multi); 4 schema (cardinality) | **D1 bundle**: wire-names sub-call + Model (C) formal ratify + multi-`$key` rec (D-ATTR-2 open list) |
| 8 | spec/FULL-SPEC.md:189–198 | Suffix sugar expands to `:'?' true` etc. — bare-quoted wire names, second sugar family alongside `$id`; D1b ratified single-family convention direction, D1c (`$?` family) reopened | **b** | 1 spec (sugar desugarings; meaning correctly assigned to DSL/schema already) | **D1c** + wire-name convergence |
| 9 | spec/FULL-SPEC.md:219–342 (Attributes) | Spec silent on same-key stacking and the duplicate-definition policy menu — the ratified behaviors (D-ATTR-1, D-ATTR-3 menu + default=error) have no spec text yet | **b** (gap, not mis-assignment) | 1 spec (menu + default) + 2 parser (knob) | **D-ATTR-1 / D-ATTR-3 spec deltas** |
| 10 | spec/FULL-SPEC.md:1414–1449 | Mixins: ":pool 20 ; Override" (1426), "Attribute inheritance (with override)" (1432), "later values override earlier (CSS cascade)" (1448) — overwrite semantics in core, contradicting information-preserving stacking; mixin merge question withdrawn | **b** | — (AUTHORITY row: under rethink/possible removal) | **JOSEPH-TODO 10** (mixin rethink/drop) |
| 11 | spec/FULL-SPEC.md:1479–1489 + examples/{comprehensive:320–329, cheatsheet:31} + ash-like-*.udon | `:[id]` attribute-merge machinery still taught while ownerless | **b/c** | — (under rethink) | **JOSEPH-TODO 10**; see tension T2 |
| 12 | spec/TIME-SPEC.md:284–376 | "Validation and Warnings" assigns temporal validation to **the parser** ("The parser follows ISO 8601 strictly…", "**Behavior:** Warn and reject" at 313/326, warning table 367–376). AUTHORITY row: temporal *validation* is a dialect-owned module (authority 5), not parser-core | **b** | 5 dialects (validation module, `temporal@1`); host projects (3) | **Decision 2** (value-dialects; brief step 2.ii–iii: recast TIME-SPEC header as `temporal@1` std dialect, land validation as projection-layer module) |
| 13 | spec/TIME-SPEC.md:1–7, 213–233, 431–483 | Header frames temporal as "extension to FULL-SPEC" core; Recognition Priority embeds temporal in core scalar typing; "Host Responsibility" promises "we know it's valid" — a promise the unvalidated events currently break (`Duration("P1W2D")` is emitted) | **b** | 1 spec (recognition surface, under the recognition/typing split) + 5 dialects (typing/validation) | **Decision 2** |
| 14 | core/udon-core/src/tree.rs:656–673 | **The accidental third model**: TreeBuilder hijacks bare `:id` / `:class` BareValues into element identity/classes — so `:'$id'` (the spec's own desugar target) is inert while user-namespace `:id` is captured; the inverse of spec. Bonus inconsistency: only the BareValue arm hijacks (`:id 5` Integer is NOT captured, `:id foo` is) | **b** — code, zero changes made | 1 spec (sugar model (C): views over reserved attrs; total-desugaring invariant) | **D1 execution** (wire names + Model (C) ratify) |
| 15 | core/udon-core/src/tree.rs:471–478 | `attr()` = first-match-only, no all-values accessor; silently first-wins at the API while the substrate keeps all attrs. D-ATTR-1 blessed the event stream as truth and requires first-vs-all accessor definition | **b** — code | 1 spec (stacking) + 3 host (API idiom) | **D-ATTR-1 tree-API accessor definition** + attrs()-surface sub-call (D1 bundle) |
| 16 | core/udon-core/src/tree.rs (whole builder) | No duplicate-`(type,key)` detection: ratified Document-layer policy enum (`error\|allow-if-identical\|first-wins\|last-wins\|keep-all` + `warn`, default **error**) is unimplemented | **b** — code | 1 spec (menu + default) + 2 parser/Document layer (knob) | **D-ATTR-3 execution** |
| 17 | core/generator/values.desc + parser.rs | Temporal recognition interleaved in the core value machine with zero validation (defect #3); `YYYY-MM` mis-emits `Date` (no YearMonth) | **b** — code; per the brief, recognition *stays* in the machine under the split, validation/typing move out | 1 spec (recognition) + 5 dialects (typing/validation) | **Decision 2** + defect #3 module |
| 18 | core/examples/comprehensive.udon:286–288, 304, 308 | Same @-insertion comments as #4, in the core copy (NOT a duplicate of examples/ — it also carries stale `!{…}` interpolation and `!raw:` syntax throughout). It is `include_bytes!` bench input (core/udon-core/benches/parse.rs:10) | **a-deferred** — prose, but under core/ (classify-only per audit rules) and a bench corpus; fix in a core-example refresh, not a doc commit | as #3 | D1a spec-edit ridealong |
| 19 | design/udon-ast.md:84, 93 | "One key per element (singular)" stated as data-model law — pre-empts the pending multi-valued-key rec (spec permits ordered identity list; schema constrains cardinality) | **b** (design layer, ahead-of-spec; adjust when rec ratifies) | 1 spec permits; 4 schema constrains | **D-ATTR-2 open rec** (multi-`$key`) |
| 20 | spec/FULL-EBNF.md | No production for `@…[key]` / `@[key]` / `:[key]` references at all — the define/refer partition is authority-1 core and absent from the formal grammar | **b** (gap) | 1 spec | **D1a spec-edit** (grammar should land with the reference-section rewrite) |
| 21 | CLAUDE.md (Orientation / Ground Truth) | Repo orientation never routes readers to spec/AUTHORITY.md or decisions/DECIDED.md — agents are sent to FULL-SPEC text that D1a/D-ATTR-* have partially superseded | flag only (audit did not edit CLAUDE.md) | — | Suggested one-liner in Ground Truth: DECIDED.md supersedes spec text until backports land |

### Compliant — verified, worth recording

- **tree.rs Reference nodes** (772–773): stored inert, never dereferenced —
  already conforms to D1a/D-ATTR-2's "core events never deref".
- **editors/** (README + all three grammars): under-highlight-not-mis-highlight;
  bare values highlighted only when core-typed (number/bool/nil/list — no
  temporal), forward-compatible with decision 2 either way.
- **docs/** (Dec-2025 brainstorms): use `@[…]` with explicit tooling-layer
  `.resolve_references` — compliant with D1a avant la lettre; historical,
  left untouched.
- **design/udon-ast.md** reference model (52, 137–165): `@element[key]` +
  ambiguity-erroring `@[key]` — this is the D1a-ratified model.
- **test/usability/**: teaches "[id] = unique identity", consistent with the
  ratified type-scoped-uniqueness default; results corpus is dated evidence.
- **FULL-SPEC suffix meaning** (196–198): "UDON performs the expansion; the
  meaning is DSL-defined" — a correct authority-1/authority-4 split.

## Genuine tensions (category c)

**T1 — Is reserved *syntax-space* proscription?**
spec/FULL-SPEC.md:211–216 reserves suffix-on-class (`|name[id].class?` "NOT
allowed -- reserved for class-level modifiers"). D1b-partial and
AUTHORITY.md ban reserved-**name** fencing ("core preserves … and never
proscribes"); they are silent on reserving a *syntactic position* for
future grammar. Grammar-space management is arguably authority-1's
prerogative (it owns the option-space); fencing-for-future-use is arguably
exactly the proscription instinct the taxonomy rejects. Sharpening the
sting: spec/FULL-SPEC-supplement.md:11 shows `|name[id].class1.class2?`
as a *valid identity shorthand* — the two spec files contradict each other
on the reserved position today. **Question for ratification:** does the
no-proscription principle extend to syntax positions (delete the Reserved
subsection; suffix-on-class becomes ordinary, DSL-interpreted), or does
authority 1 legitimately reserve grammar-space (then AUTHORITY.md should
say so explicitly, and the supplement example needs correcting)?

**T2 — Teaching an ownerless construct.**
Mixins/`:[id]`-merge have owner "—" (under rethink, JOSEPH-TODO 10), yet
they remain load-bearing in teaching artifacts: cheatsheet:31,
comprehensive:320–329, all three ash-like examples, FULL-SPEC:1414–1449.
There is nothing ratified to rewrite them *to*, and rewriting examples to
avoid mixins would pre-judge the drop-vs-rethink discussion. **Question:**
should teaching artifacts carry an explicit "unsettled — see JOSEPH-TODO
10" marker on mixin/merge passages until the discussion lands, or is the
status quo (teach the old model silently) acceptable exposure while
CONSUMERS.md shows zero live mixin use?

**T3 — Who owns the dynamics *expression grammar*?**
AUTHORITY.md assigns "Dynamics (`!`) evaluation" to authority 3 (host),
ratified long-standing. But FULL-SPEC.md:1274–1341 normatively specifies
the expression grammar, operator set, right-to-left evaluation order, and
truthiness table in core — evaluation *semantics* stated with spec-forced
voice ("Only two values are falsy"). The menu-vs-knob principle can house
this ("spec forces the Liquid-baseline option-space; host picks/extends a
dialect") but the behavior table has no row splitting expression-*grammar*
(1?) from expression-*evaluation* (3), and FULL-SPEC never marks the
section as a host-overridable baseline. **Question:** add a behavior-table
row making the Liquid baseline an authority-1 menu with authority-3
dialect selection — or move the grammar/truthiness text out of core spec
into a host-dialect document?

## Counts

- **(a) fixed now:** 5 (README, cheatsheet, practices-gotchas,
  comprehensive example, analysis.md annotation) + 1 deferred-(a) in
  core/ bench corpus (#18).
- **(b) riding pending executions:** 12 findings across 4 riders —
  D1 bundle/spec-edit (#6, #7, #8, #14, #15, #20), decision 2 (#12, #13,
  #17), D-ATTR-1/3 deltas (#9, #16), mixin rethink (#10, #11, #19 partial).
- **(c) genuine tensions:** 3 (T1 reserved-syntax, T2 ownerless mixin
  teaching, T3 dynamics grammar altitude).

**Worst offender:** spec/FULL-SPEC.md — five distinct findings, including
both halves of the identity contradiction the implementations then split
between them (spec teaches insertion the parser never had; tree.rs
implements a hijack the spec never had).

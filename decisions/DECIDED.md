# DECIDED — ratified decisions log

Append-only. Each entry: exact ratified scope, date, follow-up actions
spawned. The briefs stay as evidence; this file is what was *decided*.

---

## D1a — Reference sigil semantics (2026-07-11)

**Ratified (Joseph, verbatim scope):** `@` survives with exactly one
meaning — **inert typed pointer**: `@element[key]` explicit, `@[key]`
shorthand that **errors when ambiguous**. Transclusion/insertion is not a
parser semantic; resolution is tooling-layer.

**Ratified refinement (Joseph, same day):** the decision gives a
*distinctly different form* — in documents, `@` refers to an existing
defined element and `|` (by elimination) is **always defining**, never
selecting/re-opening. Consequences: (1) duplicate `(type,key)` definitions
are definition *collisions* — the Document-layer error is now entailed,
not merely recommended (no TOML-table-style re-open-and-merge reading
exists); (2) the path DSL's `|` *selects* — spec must state the
document-vs-path occurrence-semantics firewall explicitly ("document `|`
defines; path `|` matches").

**Explicitly still open from the same brief:** D1b (`key`/`traits` as AST
fields) and D1c (bare `?` suffix naming) — Joseph inclined but not yet
ratified.

**Spawned spec-work (queued):**
- Spec edit: `@` reference section rewritten to inert-pointer semantics;
  remove/redirect the old `@[id]`-inserts-element text (FULL-SPEC ~"Implicit
  References").
- **Key-scope enforcement text** (raised by Joseph at ratification):
  type-scoped uniqueness `(element-type, key)` is already specified in
  design/udon-ast.md:104-134 with an ERROR example, but the enforcement
  layer was underdefined. Coordinator rec pending Joseph's confirm:
  event/streaming layer never checks (statelessness is what keeps UDON
  streamable); **Document/tree layer errors on duplicate definition by
  default** (DB-pk semantics: duplicate = corruption); `@`-references
  irrelevant to definition-time uniqueness; `@[key]` ambiguity-error is the
  separate reference-time check. Both checks live at Document layer.
- Un-ban `@` references in vivarium's PROCESS norms once spec text lands.

---

## D1b-partial — `$`-names are ordinary names, no proscription (2026-07-11)

**Ratified (Joseph):** `$*` are perfectly reasonable attribute names — the
syntactic sugar (`[key]`, `.traits`, suffixes) just happens to *pair with
some of them*. Model: Ruby symbols / Erlang quoted atoms — because single
quotes are required for anything beyond common constructs, **convention and
convenience pull away from collisions, not proscription**. No reserved
namespace, no fencing, no warnings on "unassigned" `$`-names (there is no
such category). Longhand `:'$key' x` ≡ sugar `[x]` by definition (the
generator-equivalence requirement, now definitional).

**Edge pushed to spec deltas:** sugar + longhand for the same name on one
element is an instance of the *general* duplicate-attribute rule — no
identity-specific law needed.

**Still open in the D1 bundle:** formal (C)-model ratification; wire names
(converging `$key`/`$traits` single-family — Joseph's acceptability range +
coordinator lean agree); D1c suffix family (`$?` et al. under the inverted
premise); attrs() API surface; fmt normalization (parked).

---

## D-ATTR-1 — Attribute value stacking (2026-07-11)

**Ratified (Joseph):** same-key attribute assignment STACKS — required
standard behavior, assignment order guaranteed preserved. Uniform rule for
all attributes (`:'$trait'` style and ordinary alike); entailed by the
sugar model (`.a.b` = two `$trait` assignments) and generalized without
special cases. Consequences blessed with it: the event stream (every Attr
occurrence, in order) is the semantic truth; tree API needs
first-vs-all accessor definition; README's "one per key (hash semantics)"
row is superseded (spec delta).

## D-ATTR-2 — Reference dereferencing (2026-07-11)

**Ratified (Joseph, shape):** deref is never a core-event behavior; a
parser/Document-layer flag, with mode-appropriate defaults (streaming:
never; AST: available opt-in). Hosts choose. (Consistent with D1a.)

**Open with coordinator recs (Joseph to ratify):**
- Duplicate (type,key): default ERROR per D1a entailment; Document builder
  accepts policy `error|first-wins|last-wins|keep-all` (append-stream/log
  use cases are legitimate).
- Equivalent-body duplicates: still error by default, diagnostically
  distinguished ("identical" vs "conflicting"; tree-equality modulo spans);
  `allow-if-identical` as a policy value.
- Multiple `$key` values: uniform stacking — keys are an ordered identity
  list; index registers all; uniqueness per (type, each-value); schema
  layer constrains cardinality (proscription lives in schema, not core);
  sugar stays single-bracket, multi-key via longhand.
- Mixin `:[base]` merge under stacking: APPEND (override becomes a read
  discipline) — real spec change from CSS-cascade text, needs explicit
  vote.
- Conversion mapping for multi-valued attrs (Layer 3): parked with
  converters.

---

## D-ATTR-3 — Unified duplicate-definition policy (2026-07-11)

**Ratified (Joseph):** duplicate `(type,key)` handling collapses to one
Document-layer policy enum: **`error | allow-if-identical | first-wins |
last-wins | keep-all`**, plus an orthogonal **`warn`** modifier addable to
the non-error choices. Default: `error` (per D1a's entailment).
Equivalence for `allow-if-identical` = tree-equality modulo spans.
Spec forces the *menu* and the default; parser/Document layer exposes the
knob.

## D-AUTH-1 — The decision-authority table (2026-07-11)

**Ratified (Joseph, confirmed w/ coordinator refinements):** every semantic
behavior is owned by exactly one of:
**[forced-by-spec · parser/parser-type · host-lang · schema · dialects]**.
Worked instance: stacking + list-typing of ANY attribute (incl. `$key`) is
forced-by-spec core; *disallowing* (e.g., array-valued or multi-valued
`$key`) is SCHEMA's job. Refinements recorded:
- **Menu vs knob**: spec frequently forces the option-space + default
  (e.g., D-ATTR-3's enum) while parser/host picks within it — both columns
  can appear on one behavior, at different altitudes.
- **Dialects vs schema boundary**: dialects own what values *mean/type*
  (recognition/typing, e.g. temporal@1); schema owns what's *allowed*
  (constraints, cardinality, vocabularies). The pragma is the *binder*
  that attaches documents to both — a mechanism, not a sixth authority.
- **Stacking ⊥ array-values** (spec delta): `:x [1 2]` + `:x [3]` stacks
  to two values, the first an array — stacking and list-literals are
  orthogonal multiplicity mechanisms; consumers/schema decide flattening.

## Mixins — PULLED from queue (2026-07-11)

Joseph is considering rethinking or **dropping mixins entirely**. The
mixin-append-under-stacking question is withdrawn unanswered; moved to
JOSEPH-TODO as its own discussion. (Note: mixin subtree-inheritance was
already flagged under-defined in FULL-SPEC — the rethink has a clean slate.)

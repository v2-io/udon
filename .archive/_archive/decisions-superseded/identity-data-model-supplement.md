# Supplement — identity's data model (D1b/D1c returned for study)

**Supplements `identity-syntax-brief.md` §(b)/(c) · written 2026-07-11.**
The original brief studied one answer (element fields, per udon-ast/tree.rs)
and recommended it without weighing the incumbent. This supplement studies
three models against eight invariants, with D1a as fixed ground: `@` = inert
typed pointer; `|` always defines; duplicate `(type,key)` definitions are
Document-layer errors.

## Genealogy of the incumbent (dated per method)

- **2025-12-23** (`3fb7736`, founding commit): SPEC.md introduces `[id]` as
  *"shorthand for an attribute"* — `|element[my-id] → |element :'$id' my-id`.
  The sugar model is the founding framing. No prose rationale for the `$`
  prefix appears in that commit or anywhere in `notes/` (searched
  analysis.md, feedback.md); it arrives fully formed.
- **2026-01-01** (`c0025bd`): carried verbatim into FULL-SPEC.md:170-176.
- **Phase-2 plan** (`notes/implementation-phase-2.md:56-58,694-695`): the
  *implementation design* was also sugar-model — events planned as
  `Attribute { key: "$id" }`, `Attribute { key: "$class" }`.
- **2026-01-14** (`design/udon-ast.md:62-72,169-174`): fields thinking
  (`key`/`traits` as Element fields) appears, with the `$`-prefix explicitly
  marked *undecided* — the fields model is latest-thinking, never reconciled
  against the sugar framing.
- **Phase-3 impl (current)**: drifted to a third thing — grammar
  `udon.desc:172` writes `Attr($id)` unquoted, which descent generates as
  literal `Attr "id"` (`parser.rs:951`; descent's own docs at
  descent/CLAUDE.md:279 show `Attr('$id')` as the quoted-literal form).
  `Attr "class"` likewise (`parser.rs:1005,1011`). TreeBuilder then
  intercepts attrs *named bare `id`/`class`* into Element fields
  (`tree.rs:656-673`) — BareValue only, so typed keys leak (defect #2's
  companion, REVIEW §4 item 4). **Note the accident**: today a hand-written
  `:id foo` silently *becomes* the element's identity, and `:'$id' foo` is
  inert — the exact inverse of the spec, in the unprefixed namespace the `$`
  was evidently meant to protect.
- **Suffixes never drifted**: grammar emits bare `Attr "?"` / `"!"` / `"*"` /
  `"+"` + BoolTrue (`parser.rs:1837-1849`), matching FULL-SPEC:190-193
  (`:'?' true`). Suffixes are already sugar-model in spec *and* impl.

## The three models

- **(A) Sugar/attribute model** (FULL-SPEC's framing): `[x]`, `.t1.t2`, `?`
  are pure syntactic sugar for reserved `$`-prefixed attributes. Substrate:
  element = name + attrs + children, nothing else. `:'$id' x` hand-written
  is *definitionally* the same document as `|…[x]`.
- **(B) Fields model** (the brief's rec): `key`/`traits`/`suffixes` are
  Element fields populated **only** from their syntax positions. A
  hand-written `:'$id' x` is an inert ordinary attribute.
- **(C) Views-over-reserved-attrs hybrid**: substrate is (A) — desugaring is
  total and stated as an invariant — while `key()`/`traits()` accessors are
  *views* reading the reserved attrs. tree.rs keeps its ergonomics as API,
  not as model. (An implementation may materialize the fields as caches; the
  model statement is that they are projections of attrs.)

## Joseph's requirement-revealing case, worked through each model

A db-table → udon generator that tracks nothing specially: it emits
`:'<field-name>'`, prefixing with `$` when the column is the primary key.
When the pk column is named `id`, it emits `:'$id' 3890` — intended to
correspond exactly with hand-written `|asdf[3890]` elsewhere.

- **(A)/(C)** — the equivalence is *definitional*. The generated row is
  addressable by `@asdf[3890]` and by path `|asdf[3890]`; duplicate pk rows
  collide at the Document layer exactly like hand-written duplicates
  (D1a's error); schema validation sees one attribute. Zero identity
  bookkeeping in the generator, which is the design value Joseph names:
  *"a certain safety and appeal to having `[...]` and `.abc.def` and `?` as
  syntactic sugar instead of dictating a more complex inherent model."*
- **(B)** — the equivalence is destroyed, **silently**. The generated
  elements have no key: `@asdf[3890]` fails to resolve, path `|asdf[3890]`
  matches nothing, duplicate pk rows are *not* caught (no keys to collide),
  and no error ever tells the generator's author. To recover, the generator
  must special-case the pk column into bracket syntax — precisely the
  tracking the case stipulates it shouldn't need.

The case also entails a policy the spec must state under (A)/(C): the
generator blindly emits `$user_id` when *that* is the pk name. So
**unassigned `$`-names must be legal and inert at core** — `$` is a reserved
*namespace* in which the spec assigns a few names meaning (`$id`, `$class`,
suffix names), other `$`-names carry no core semantics (dialect/schema layers
may assign them; a linter may flag unknown ones). Rejecting unassigned
`$`-attrs would break the case just as (B) does.

## The eight invariants

Verdict key: ✓ holds naturally · ✓* holds with one explicit spec sentence ·
✗ fails · (—) not applicable.

| # | Invariant | (A) sugar | (B) fields | (C) views |
|---|---|---|---|---|
| 1 | D1a duplicate-definition errors; block-position `:'$id'` as definition-time identity | ✓* | ✓ but narrower | ✓* |
| 2 | Typed keys (defect #2): both spellings one code path | ✓ forced by model | (—) second spelling killed; silent divergence trap | ✓ forced |
| 3 | Paths `[key]` + `@`-resolution match identity however spelled | ✓ | **✗ silent misses** | ✓ |
| 4 | Mixin `:[id]` merge must not transplant identity | ✓* one sentence | ✓ fields don't merge, but junk-`$id` merges | ✓* |
| 5 | Round-trip / fmt normalization | policy question (stated below) | trivial | policy question |
| 6 | Event-model impact | wrong *name* today (`id` → `$id`), 2-line grammar fix | wrong *model* — needs new event types | wrong name, same fix |
| 7 | Schema-layer validation uniformity | ✓ one attr machinery | ✗ dual paths + trap-lint | ✓ |
| 8 | Suffix quartet `?!*+` | already conformant | needs suffixes field + events | already conformant |

### (1) D1a entailments and order-of-events

Under (A)/(C), `:'$id'` in *any* attribute position (sameline or block) is
definition-time identity. The attributes-before-children rule bounds when
identity is final: **known by the close of the element's attribute section**,
i.e. before the first child/prose. The Document layer therefore runs its
`(type,key)` uniqueness check at attr-section close, not at ElementStart —
consistent with D1a's spawned text (event layer never checks; Document layer
errors on duplicate definition). Two new same-element rules are entailed and
must be stated: duplicate `$id` on one element (e.g. `|user[1] :'$id' 2`) is
a Document-layer error, never last-wins; `$id` with no value (BoolTrue) or a
non-scalar value is an error. **Dependency made load-bearing:** defect #9
(attrs-before-children unenforced — REVIEW §4 item 9) must be fixed, or
"identity final before content" has no teeth. Under (B) identity is always
on the definition line — genuinely simpler ordering; it is the model's one
clean structural win, and (C) matches it in practice for the sugar spelling
(which is the only spelling the live corpus uses).

Streaming note: under (A)/(C) a longhand `$id` may arrive as a late block
attr, so a streaming consumer wanting identity-at-ElementStart must buffer to
end-of-attrs. It must do that for *any* block attribute anyway; no new
statefulness is introduced, and the event layer stays semantics-free —
which is *more* streaming-friendly than (B), whose parser must encode the
key/attr distinction into the event vocabulary.

### (2) Typed keys — defect #2

FULL-SPEC:178 already promises brackets follow attribute value rules. Under
(A)/(C) the model *forces* the fix: `value_bracket` (udon.desc:516, currently
raw capture, quotes kept) must route through the shared `/value` dispatch, at
which point `|step[1]` and `|step :'$id' 1` produce the *same event
sequence* (`Attr "$id"` + `Integer "1"`) and converge in one TreeBuilder
path — the equivalence is mechanical, not policed. Under (B) "one code path"
is satisfied only vacuously (the second spelling has no identity semantics),
and the hand-written `:'$id' 1` parses without any diagnostic — the silent
divergence trap.

### (3) Paths and references

udon-paths.md builds `[key]` (line 19, 54, 78, 103) and `@element[key]`
resolution (124-131) on identity. Under (A)/(C): one definition — `[key]` in
a path matches elements whose `$id` attribute equals the (typed) value; a
path can equivalently select the attr itself. Under (B): longhand-spelled
elements are unaddressable — see the generator case. This is the invariant
(B) fails hardest, and it fails without an error surface.

### (4) Mixin `:[id]` attr-merge

Identity must NOT merge under any model — a mixin must not overwrite the
host's key (and would then also trip the D1a duplicate-`(type,key)` error).
Explicitly per model:

- **(A)/(C)**: reserved attrs are attrs, so the merge rule needs one spec
  sentence: **`$`-reserved attributes never merge through `:[id]`**. That
  covers `$id` (identity hijack) and `$class` (classification flows through
  the `.class` mixin channel, FULL-SPEC:1414-1448, not through attr-merge —
  merging `$class` would double-apply it) and suffix attrs.
- **(B)**: fields trivially don't merge — cleaner by construction. But the
  *inert* hand-written `$id` attr in a mixin source **would** merge, planting
  a junk `$id`-named attr on the host; (B) needs its own sentence anyway,
  and the junk is data corruption a reader will misread as identity.

### (5) Round-trip and future `udon fmt` — stated, not solved

Two spellings ⇒ a normalization policy question under (A)/(C):

- *Round-trip* (`parse ∘ serialize = identity`, REVIEW IN-list): needs
  spelling preserved — spans/SourceInfo (`attr_order`,
  `original_whitespace`) are the designed enabler; the reserved attr's
  span points at either the bracket or the longhand attr. No model problem.
- *fmt policy*, open: (i) canonicalize to sugar (`:'$id' x` → `[x]`) — the
  gofmt move, but it rewrites generator-authored documents; (ii) preserve
  author spelling; (iii) canonicalize with an opt-out. This is a fmt-charter
  decision, not an identity-model decision — flagged for the fmt valve.

Under (B) there is nothing to normalize (one spelling), and the inert
`$id` attr round-trips as an attr.

### (6) Event model

Current stream is wrong under every option. Deltas:

- **(A)/(C)**: wrong *name*. `udon.desc:172` `Attr($id)` → `Attr('$id')`;
  `:186-187` `Attr($class)` → `Attr('$class')` (the unquoted `$x` form is
  what silently generated bare `id`/`class`). Suffixes stay as-is (already
  bare-`?` conformant) or move to `'$?'` per (8). Regenerate; update
  fixtures.
- **(B)**: wrong *model*. Attr events cannot carry identity (a hand-written
  `:'$id'` must remain distinguishable), so (B) requires new event types
  (`Key`, `Trait`, `Suffix`) or ElementStart payload — grammar restructure,
  event-vocabulary growth, and every consumer learns two shapes of
  "attribute-like thing."

Plus, all options: the TreeBuilder intercept (`tree.rs:656-673`) currently
fires only on BareValue — typed keys and quoted strings leak into ordinary
attrs. Fix rides with defect #2 regardless of model.

### (7) Schema-layer validation

Under (A)/(C) key/trait constraints are attribute constraints on `$id` /
`$class` — one validation machinery for everything, and
udon-schema-exploration's key-typing needs no special channel. Under (B) the
validator grows a second path for fields, *plus* a diagnostic for the trap
(`attribute named '$id' has no identity semantics — did you mean [key]?`) —
a lint whose existence concedes the spelling is a landmine.

### (8) The suffix quartet

Already sugar-model everywhere (spec `:'?' true`, impl `Attr "?"`), and the
live corpus's 6 bare-`?` uses are surface syntax, unchanged under all
options. The open naming (D1c): the original brief leaned bare-`?` *because*
it recommended dropping `$` — that contingency now reverses. If (A)/(C)
ratifies the `$`-namespace, uniformity argues `$?` `$!` `$*` `$+`
("everything element-syntax desugars to lives under `$`"); minimalism argues
bare `?` etc. is collision-proof already (non-name characters, quoted-only
spelling) and matches current spec+impl (zero churn). Both are coherent
inside (A)/(C); the generator-equivalence property holds either way
(`:'?' true` hand-written *is* the suffix — same definitional move). Genuine
residual taste call for Joseph; the only wrong answer is deciding D1c before
this model decision, since the earlier lean's premise inverted.

## The honest cost of (A)/(C)

Stated so the recommendation isn't a whitewash:

1. **Unspellability**: an attribute literally named `$id` that is *not*
   identity cannot be expressed. That is the definitional consequence (cf.
   `xmlns` in XML). Joseph's case treats it as the intended reading.
2. **Injection surface**: an emitter serializing *untrusted* field names can
   have identity planted by a field named `$id` (the MongoDB `$`-operator
   lesson). Mitigation is one spec sentence of emitter guidance: emitters
   MUST NOT pass untrusted names into the `$` namespace unvetted (reject or
   rename). Core parser behavior is unchanged either way.
3. **Late identity** for the longhand spelling (see invariant 1) — bounded
   by attrs-before-children, and makes defect #9 enforcement load-bearing.
4. **Normalization question** (invariant 5) — real, deferred to fmt.

None of these is structural; each is a sentence of spec text or an existing
defect's fix. (B)'s failures — silent unaddressability, destroyed generator
equivalence, dual validation, junk-merge — are structural and silent.

## Recommendation

**(B) is dominated and should be dropped.** It fails invariants 3 and 7
outright, fails Joseph's generator case silently, and its genuine wins
(early identity, trivially-no-merge, no normalization question) are each
recovered under (C) by a single explicit sentence. The original brief
reached (B) by studying vocabulary and tree.rs ergonomics without testing
the longhand spelling against addressing — this supplement corrects that.

**Between (A) and (C), (C) dominates weakly**: identical substrate,
identical semantics; (C) merely *states* the total-desugaring invariant in
the AST doc and blesses `key()`/`traits()` accessors as views. Leaving the
API story unstated (A-pure) is what let tree.rs's convenience fields get
mistaken for the model in the first place — the brief's own error is the
argument for (C)'s one extra paragraph.

**Recommended: (C)**, with these sub-decisions surfaced (not smuggled):

- **C-1 · Reserved wire names**: `$id`/`$class` (founding spelling, HTML
  adjacency, and the spelling in Joseph's own worked case) vs
  `$key`/`$traits` (matches udon-ast's type-scoped-key vocabulary). Zero
  corpus usage of either — free choice. API accessors are `key()`/`traits()`
  with `id()`/`classes()` aliases regardless (the wire/API split is
  ordinary; cf. HTML `class` / DOM `classList`). Lean: **`$id`/`$class`**,
  on genealogy + the worked case.
- **C-2 · Unassigned `$`-names**: legal, inert at core, available to
  dialect/schema layers; lint may flag unknowns. Entailed by the generator
  case (`$user_id`); must be stated in the spec.
- **C-3 · D1c reopened with inverted premise**: bare `?` (zero churn) vs
  `$?` (namespace uniformity). Taste call, decide after C-1.
- **C-4 · API surface**: does `attrs()` iteration yield reserved attrs?
  Lean yes (model fidelity; a serializer walking attrs reproduces identity)
  with a `user_attrs()` convenience excluding `$`-prefixed; but this is an
  AST-doc detail, not spec.
- **C-5 · fmt normalization**: deferred to the fmt charter (invariant 5).

## Exact deltas for (C)

**Spec (FULL-SPEC.md):**

1. §Identity and Classification (161-183): state desugaring as a *total,
   definitional* invariant — `|e[x]` and `|e :'$id' x` are the same
   document; `.t1.t2` desugars to `$class` with the always-array rule; add:
   duplicate `$id` on one element = error; `$id` requires a scalar value;
   hand-written `:'$class'` accepts an array or repeats-with-append
   (matching per-trait sugar emission).
2. New short section **Reserved Attribute Namespace**: `$`-prefix reserved;
   table of assigned names; unassigned names legal + inert (C-2); emitter
   guidance for untrusted names (cost #2).
3. §Element Suffixes (185-217): record the D1c outcome (C-3); state the
   suffix↔attr equivalence as definitional like identity's.
4. §Implicit References (1412-1489): in the (already-queued) D1a rewrite,
   add "`$`-reserved attributes never merge through `:[id]`."
5. Attribute ordering: promote attrs-before-children from invariant-in-AST-
   doc to enforced spec rule (defect #9) — identity finalization depends on
   it.
6. design/udon-paths.md: one sentence — path `[key]` matches on the `$id`
   attribute, however spelled.
7. design/udon-ast.md (60-175): replace field-model framing: Element
   *conceptually* = name + attrs + children; `key`/`traits` defined as views
   over `$id`/`$class`; delete the three "undecided" hedges (169-174).

**Impl (core/):**

1. `generator/udon.desc:172` → `Attr('$id')`; `:186-187` → `Attr('$class')`;
   suffix lines 421-425 per C-3. Regenerate.
2. `udon.desc:516` `value_bracket`: route through shared `/value` dispatch
   (defect #2) so both spellings hit one code path and keys are typed.
3. `tree.rs:656-673`: intercept matches `$id`/`$class`, fires on all value
   types (not just BareValue); fields kept as materialized views; accessors
   renamed `key()`/`traits()` (+ aliases); `attrs()` policy per C-4.
4. Document layer (with D1a's queued work): `(type,key)` uniqueness checked
   at attr-section close; same-element duplicate-`$id` error; `@[key]`
   ambiguity check unchanged.
5. Fixtures: update expected attr names to `$id`/`$class` (spec-first, per
   core/CLAUDE.md workflow).

**If Joseph instead ratifies (B)** (recorded for completeness, not
recommended): new Key/Trait/Suffix event types + grammar restructure; a
mandatory lint for `$`-spelled pseudo-identity; udon-paths and the reference
resolver documented as *not* seeing longhand identity; the generator case
accepted as broken by design. The FULL-SPEC desugaring text (170-176,
187-194) would be deleted rather than corrected.

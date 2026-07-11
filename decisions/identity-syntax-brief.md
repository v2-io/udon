# Decision brief — identity-syntax bundle (valve decision 1)

**Spike S2a · written 2026-07-11 · feeds REBOOT-PLAN Phase 1, item 1.**
Sources verified against primary files and live probes this session; the
review's summaries were spot-checked, not trusted. Blocks defect #2 (typed
IDs), the paths implementation (U6), and the un-banning of references in the
live corpus.

## Reconstructed context

Three sub-decisions, frozen mid-evolution in January (genealogy class C —
three artifacts, three answers):

- **(a) Reference sigil.** `spec/FULL-SPEC.md:1450-1489` defines `@[id]` as
  *"insert the entire element"* (transclusion) and `:[id]` as attribute
  merge. `design/udon-ast.md:135-165` (Jan 14 — the latest thinking) defines
  `@element[key]` as an **inert typed pointer** with type-scoped keys and an
  ambiguity-*erroring* `@[key]` shorthand. `notes/feedback.md:139-152` votes
  to drop `@` entirely (`|[id]` insert + `:[id]` merge; "keeps sigil count at
  4"). `design/udon-paths.md:120-138,222` builds its resolution operator on
  `@` (`@user[alice]:email`, `:customer@` follow-ref), under the philosophy
  *"path syntax reuses [document syntax] — no new symbols"*
  (udon-paths.md:6). `design/udon-schema-exploration.md` leans on `@[Type]`
  pervasively (lines 160-171, 304, 357, 508) and lists reference-syntax as
  its open question #1 (line 612).
- **(b) Key-attribute naming.** Spec says `[id]` expands to `:'$id'`
  (FULL-SPEC.md:170-176, `$`-prefix explicitly undecided at
  udon-ast.md:169-170); the implementation emits an `Attr` named `id`
  (`core/udon-core/src/tree.rs:60,353` field `id`; **[verified by probe]**
  the event stream for `|[header]` is `Attr "id"` + `BareValue "header"`);
  udon-ast.md:62-72 says `key`/`traits` with `id`/`class` as aliases, backed
  by the most-developed thinking in the estate (udon-ast.md:74-134):
  key = singular identity with existence beyond tree position, traits =
  plural classification, `(element-name, key)` unique per-type like a table
  primary key.
- **(c) Suffix-attr naming.** `|field?` → `:'?' true`, with `?` vs `$?`
  undecided (FULL-SPEC.md:187-194, udon-ast.md:173-174).

**The conflation at the heart of (a):** three distinct semantics currently
share one sigil — (1) transclusion/insert (FULL-SPEC's `@[id]` at element
position), (2) attribute merge (`:[id]`), (3) inert typed pointer
(udon-ast's `@user[1]` as attr value; schema's `-> @[User]`; paths'
resolution). feedback.md's proposal covers (1) and (2) but leaves (3) —
the semantics ASF/vivarium/schema actually need — homeless: there is no
`|`-shaped spelling for "this attribute's value *points at* that element."

**New finding [verified by probe this session]:** `|[header]` already
parses today as an *anonymous element carrying identity* — legal syntax the
spec itself uses (`|.db-defaults[base-db]`, FULL-SPEC.md:1482, the mixin
example). So feedback.md's `|[id]`-as-insertion is **ambiguous against
existing syntax**, not a free simplification: at element position, `|[x]`
cannot mean both "define anonymous element keyed x" and "insert the element
keyed x." The sigil-economy argument loses most of its force here.

Also **[verified]**: the parser emits identical inert `Reference` events for
`@[header]` at element position and `@[mit]` as attr value — the impl never
committed to transclusion semantics; references are already pointers as
implemented.

## The live corpus (migration evidence, greps 2026-07-11)

Four real documents, ~2,200 lines: `archema-io/vivarium/LEXICON.udon` (1,151),
`archema-io/vivarium/doc/PROCESS.udon` (178),
`archema-io/asf/.../PROCESS-MAP-v0.udon` (489), `autopax/taxonomy.udon` (371).

- **Heavy `|element[key]`** — hundreds of instances, the corpus's backbone.
- **Traits in live use** — `|callout.note`, `|callout.warning` (taxonomy.udon:50,181).
- **Bare `?` suffix in live use** — `|process[coherence-stewardship]?`
  (PROCESS-MAP-v0.udon:57; 6 instances).
- **Zero `@`-references, zero `$`-attrs, zero explicit `:key`/`:id` attrs.**
- PROCESS.udon:100-110 (norm `udon-safe-subset`) **explicitly bans
  @-references pending this decision.** The accumulating cost is therefore
  not future migration — it is present *avoidance*: authors are working
  around a core affordance, and the paths/schema/agentic layers are gated.

Consequence: **document-level migration cost is ~zero under every option.**
The bracket/dot/suffix surface the corpus uses is unchanged in all of them.
The costs live in spec text, the AST API, and which downstream designs
survive intact.

## Options

**A1 — keep `@` as spec'd (insert semantics).** No spec edit. Leaves the
conflation: schema's `-> @[User]` would read as "insert a User here," which
is incoherent; paths and udon-ast semantics contradict the spec text.
Migration: zero docs; incoherence debt compounds.

**A2 — drop `@` (feedback.md).** `|[id]` insert, `:[id]` merge. Sigil count
stays 4. Costs: (i) the verified `|[id]` ambiguity above — resolvable only
by banning anonymous keyed elements, which the spec's own mixin idiom uses;
(ii) pointer-as-value has no spelling (`:customer @user[1]` → nothing
natural); (iii) udon-paths either loses its resolution operator or `@`
becomes a path-only symbol, breaking "paths = UDON linearized";
(iv) schema type-references need a new design. Migration: zero docs;
two settled-in-shape design docs partially invalidated.

**A3 — split by semantics (recommended).** `@` survives with exactly one
meaning: **inert typed pointer** — `@element[key]` explicit, `@[key]`
shorthand that *errors* when ambiguous (udon-ast.md:148-162). It is never
transclusion. `:[id]` attribute-merge stays as spec'd. Element-position
`@[key]` parses to the same inert Reference node (what the impl already
does); whether a host *resolves* it as transclusion is a tooling/dialect
behavior, not core semantics — the same recognize-in-core/resolve-in-tools
posture Joseph already endorsed for references (REVIEW §7-A, the EX(?) row).
Each sigil keeps one meaning: `|` structure, `:` attributes, `@` pointer.
Five sigils with one meaning each beats four sigils with overloading — and
the paths language, schema exploration, and ReferenceIndex design all
survive verbatim.

**(b) Naming — recommend `key`/`traits`** (udon-ast), with `id`/`class` as
documented accessor aliases (udon-ast.md:69-71 already plans this).
Rationale: type-scoped uniqueness *needs* "key" vocabulary — "id" implies
the global uniqueness UDON deliberately doesn't have; the review ranks
key/traits among the language's six proven strengths (§3.5). The `$`-prefix
question **dissolves**: identity should be an element *field*, not an
attribute sharing the user namespace — which is how tree.rs already models
it (`Element { id, classes, .. }`). Drop FULL-SPEC's "expands to `:'$id'`"
attribute-expansion framing entirely; then there is no collision to prefix
against. Impl cost: rename accessors, adjust the identity event (currently
`Attr "id"`), fold in the defect-#2 typed-key fix (bracket values are
currently captured raw, quotes included) — same code, one pass.

**(c) Suffix — recommend bare `?` (`!`, `*`, `+`).** Consistent with
dropping `$`; suffix chars can't collide with bare attr names (non-name
characters); live ASF usage is already bare-`?`. `$?` only made sense in a
`$id` world. Whether suffixes land as a `suffixes` element field (like
key/traits) or reserved attr names is an AST detail U4 can settle.

## Recommendation

**A3 + `key`/`traits`-as-fields + bare suffixes, decided as one bundle.**

Honest uncertainty: (1) Whether Joseph wants element-position insertion
(the `@[header]` template idiom, FULL-SPEC.md:1469-1477) to stay even as a
host behavior — document-mode templating is a real use-case; A3 preserves
the syntax and defers the semantics, so nothing forecloses. (2) The
4-vs-5-sigil question is ultimately taste; the strengthened form of
feedback.md's economy argument is "one meaning per sigil," which A3
satisfies better than A2 does once the `|[id]` ambiguity is on the table.
(3) Reference augmentation (`@[header].highlighted`, valve decision 6) and
`:customer@` follow-syntax in paths remain open downstream — nothing here
forecloses either.

## Next action

Joseph ratifies (a)/(b)/(c) in one pass — a yes/adjust on each line of the
recommendation suffices. Then, same week: spec edit (FULL-SPEC §Identity +
§ID Reference, ~60 lines); U4 typed-key + identity-event fix in `core/`;
update PROCESS.udon's safe-subset norm to un-ban `@`-references (or keep the
ban until resolution tooling exists — resolution is still unimplemented);
paths implementation (U6) proceeds on `@` with confidence.

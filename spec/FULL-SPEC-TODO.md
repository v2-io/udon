# FULL-SPEC-TODO — the worklist to bring FULL-SPEC current

A plain punch-list of the real edits not yet applied to **`FULL-SPEC.md`**
(which is the spec), plus the parser-impl work each edit implies. Check an item
off when it lands *in FULL-SPEC* (or in the parser, for impl items).

> **Discipline, learned the hard way (see the .bak files' META-1):** read the
> FULL-SPEC section before editing it. Several items below are the spec *already
> being right* while the impl (or a since-archived brief) was wrong — those are
> tagged `[defect]` (impl fix, no spec change) or `[reconcile]` (spec text
> disagrees with itself), not `[change]`.

*Rebuilt 2026-07-12 from a clean read of FULL-SPEC + Joseph's actual decisions.
The dense predecessor ledgers are archived at `decisions/DECIDED.bak.md` and
`spec/FULL-SPEC-TODO.bak.md` — reference only (e.g. the core-vs-host-vs-schema-
vs-parser-vs-dialect ownership discussion lives there), **not** authoritative.*

Line numbers below are FULL-SPEC.md at the time of writing; re-grep before editing.

---

## Open decisions

**None** — all resolved (2026-07-13):
- `:[id]` attribute-merge → **removed**; "merge that element's attributes" is
  now just the *merge* resolution mode of `@` (parser/host-defined). ✅ spec.
- Mixins → **not core**; documented as an *experimental parser/host behavior*,
  alongside a new Anonymous Elements section. ✅ spec.
- `'` as a string / name / key delimiter → **kept** (only the head-position
  *escape* role is being removed).

## Status of this integration pass (2026-07-13)

**Landed in FULL-SPEC** (committed to main): identity model + desugaring +
specially-designated `$`-names + suffix-chars-in-traits + Host Views + Anonymous
Elements; References & Mixins (`@` inert, `:[id]` removed, mixins experimental)
+ Duplicate Definitions; Attribute Stacking (+ ⊥ array-literals);
Core-minimalism framing; Escapes (`'` → `\`); Freeform fences; Head Position
(lexicon term + two faces) + Marker Recognition guards (`!`/`@`/`:`/`;`) +
Bounded-Lookahead appendix.

**Remaining spec-text (this pass):** Explicit typing `<…>` (+ bare-scalar rule;
TIME-SPEC noted, rewrite deferred); rubber-stamps (reference-augmentation = no,
BlankLine/Warning, multi-attr legalize); then the terminology sweep (`id`→`key`,
`class`→`traits` in the remaining prose/examples).

**Extractions — own companion specs (2026-07-13 decisions):** Dynamics/Liquid →
baseline-dialect doc; Markdown → its own spec (udon-as-markdown /
markdown-passed-through / markdown-parsed); Temporal → TIME-SPEC recast as
`temporal@1` (deferred).

**Deferred to Tier-2 (parser/grammar, not this pass):** `:id` hijack fix,
`:`-attrs-before-children enforcement, Document-layer duplicate check,
head-position `!{{}}` defect, wire-names, stacking/traits accessors.

## Identity: `id`→`key`, `class`/`classes`→`traits`  `[change + impl]`

- [ ] Rename the *vocabulary* everywhere: `id`→`key`, `class`/`classes`→`traits`
      (surface syntax `[…]` and `.x` is unchanged — only the names change).
- [ ] State the desugaring once: `[k]`→`$key`, `.a.b`→stacked `$traits`,
      suffixes `?!*+`→`$?`/`$!`/`$*`/`$+`.  `[reconcile]` the spec's own
      inconsistency — :173 desugars `[id]`→`:'$id'` (with `$`) but :190–193
      desugar suffixes→`:'?'` (no `$`). Unify on `$`-prefixed names.
- [ ] `$` is an ordinary name char — **specially-designated, not reserved**. No
      `$id`/`$class` aliases: only `$key`, `$traits`, `$!`/`$+`/`$?`/`$*`. Any
      other `$name` is a legal attribute (quoting friction, not proscription,
      deters collisions).
- [x] `|` **defines**, `@` **refers** — **landed**: References & Mixins section
      reframes `@` as an inert pointer (transclude / merge-attributes /
      leave-inert are host resolution modes; `@[key]` errors if ambiguous), adds
      Anonymous Elements, documents Mixins as experimental/non-core, and removes
      `:[id]`.
- [ ] Duplicate `(element, key)` **definition** → Document-layer error, policy
      `error | allow-if-identical | first-wins | last-wins | keep-all` (+`warn`).
      Event/streaming layer never checks it.

## Attributes  `[change]`

- [ ] Same-key attribute values **stack**, order preserved — uniform for all
      attributes (`$traits` is just the common case). Ensure the spec teaches
      stacking, not "one per key / hash semantics".
- [ ] Stacking ⊥ array-literals: `:x [1 2]` then `:x [3]` = two stacked values,
      the first an array. Two independent multiplicity axes; say so once.
- [ ] Bare trait values may contain `* ! ? +` (`.foo?` = trait `"foo?"`, no
      quotes). Drop the "Reserved (suffix on class)" block (:211–216).
      *(D-TRAIT-SUFFIX, 2026-07-12; element-level end-suffix uses the space form
      `.trait ?` already at :208.)*

## Explicit typing `<…>`  `[change — net-new section]`

- [ ] Add the `<…>` typing envelope: `<type:…>` / `<dialect:type:…>`; an
      unlabeled `<…>` is offered to the declared dialects in declared order,
      first-claim-wins, all-decline → error. FULL-SPEC has **no** mention of it
      today — this is a new section near Value Types.
- [ ] Bare typing = **frozen core scalars only** (int / float / bool / nil /
      string / list). Every dialect type — **including all temporal and ISO
      dates** — requires `<…>`. Recast TIME-SPEC as the `temporal@1` dialect.
      *(This is what makes accretion structurally impossible.)*

## Fences / freeform  `[change + reconcile]`  (:1154–1189)

- [ ] Opener is **not** a fence after prose — only in head/scan position.
      Rewrite :1160 ("need not be at line start / can follow other content")
      and the :1164 example, which shows a prose-position opener (wrong).
- [ ] Closer = **any-indent** line starting ` ``` `, and must be followed by a
      newline (trailing whitespace before it silently ignored). Replaces :1179
      ("opening indent or less").
- [ ] Rest of the opening line → body (info-strings come free; retires the
      multi-word-lang truncation, defect #14).
- [ ] **Spec-prose caution** (not a parser Warning event): the leading
      whitespace of an *indented* closer IS part of the body output; only the
      whitespace to the *right* of the closer is silently trimmed.
- [ ] Keep — already correct: indent→parent (:1159), content-after-``` = body
      (:1161), recommend closer at opening indent (:1178).

## Head position + recognition  `[gap-fill]`

- [ ] Name **"head position"** as a first-class lexicon term in Positional
      Contexts (:32) — the state where prose-vs-block is still undetermined
      (block-line-start and sameline-condensed scan are its two faces).
- [ ] Give `:`, `;`, `!` their recognition predicates — FULL-SPEC only writes
      `|`'s (:157). `!` is structural before an identifier or `:` (`!if`,
      `!:lang:`); `!{…}` is **prose-level**, not structural. `;` guard = skip
      (zero corpus incidence).
- [ ] `!` letter-guard: `!` + non-(identifier/`:`) → prose (fixes `![img]`,
      `!=`, `!(`). `[change]`
- [ ] Non-normative appendix: bounded lookahead (≤ ~3 chars, single-level, no
      deep backtrack) — why descent fits and PEG isn't needed.

## Escapes  `[change]`

- [ ] Remove `'` as a head-position **escape** → `\` becomes the sole escape
      (block + sameline/embedded; `\` already works at block level today, just
      marked "discouraged alternate" at :126–129 — invert that). Rewrite the
      "One escape prefix" table (:96–100), Block-Level Escape (:104–129), and
      the semicolon-escape examples (:426–428, :500–508). A line starting `'`
      then a marker becomes plain prose. Scan live `'`-escape usage first.
      **Does NOT touch** `'` in the `|` follow-set (:158) or `'...'` strings /
      names / keys (:143) — those are the string-delimiter role (kept). *(Earlier
      draft wrongly bundled the follow-set drop into this item; that would have
      broken quoted element names `|'name'`.)*

## Core-minimalism framing  `[change — short new section]`

- [ ] One short section: the core is deliberately small; it fixes syntax + core
      semantics and leaves **projection** (host), **constraint** (schema), and
      **exotic typing** (dialect) to consumers; it may fix an option-*space*
      while a consumer picks within it (menu-vs-knob). Distill from the .bak;
      do **not** rebuild the five-authority routing table (that was the drift).

## Parser impl (beyond the plain desugaring)

- [ ] Wire-names are `$key`/`$traits`/`$?…`, no aliases.
- [ ] `traits` **view** is always a list (`[]`, `["a"]`, `["a","b"]`) — a
      tree/accessor normalization (the event stream just emits N `$traits`
      attrs), not a parser-event behavior. The one *fixed* view rule; lives at
      the tree layer / udon-utl, with the stacking accessors below.
- [ ] Fix the `:id` hijack: a bare `:id foo` currently sets identity; it must be
      an ordinary attribute. Emit `$key` (not `Attr("id")`).  `[defect]`
- [ ] Enforce `:`-attributes-before-children (:1591–1598 already spec's it).
      `[defect #9]`
- [ ] Document-layer duplicate-`(element,key)` check per the policy above.
- [ ] Head-position `!{{value}}` currently wraps in a block Directive — should
      surface as prose + Interpolation.  `[defect]`
- [ ] Stacking accessors: `attr` (scalar / last) + `attr_all` (list).

## Rubber-stamps (recommendations; one "go" clears the batch)

- [ ] markdown subset → Djot-ish Layer-1 enumeration
- [ ] reference augmentation → no (references immutable)
- [ ] BlankLine / Warning events → spec them
- [ ] multi-attr block lines → legalize (drop the warning; the cheatsheet
      teaches it)
- [ ] dynamics / Liquid expression grammar → a baseline-dialect companion doc,
      not core

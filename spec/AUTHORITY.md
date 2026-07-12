# UDON Decision Authority — who owns which semantics

**Spec-level, normative.** Ratified 2026-07-11 (decisions/DECIDED.md
D-AUTH-1). Every semantic behavior in the UDON ecosystem is owned by
exactly one of five authorities; a tool, spec section, or document that
assigns a behavior to the wrong authority is *wrong even if its output
looks right*.

## The five authorities

| Authority | Owns | Character |
|---|---|---|
| **1. Spec (forced)** | Core syntax + semantics every conformant parser must implement identically: sugar desugarings, stacking, order preservation, syntactic typing of core scalars, the define(`|`)/refer(`@`) partition, event vocabulary | Non-negotiable; conformance-corpus enforced |
| **2. Parser / parser-type** | Mode- and layer-dependent knobs *within spec-forced menus*: duplicate-definition policy, deref availability, buffer/limit tuning, error-recovery depth | Streaming vs Document layers legitimately differ |
| **3. Host language** | Value projection (Date → chrono/Time/…), coercion targets, dynamics-dialect evaluation (`!` semantics), API idiom | Begins where events/tree end |
| **4. Schema** | Constraint and proscription: cardinality (single-`$key`), type restriction (no array-valued `$key`), required/optional, element vocabularies, validation | **Proscription lives here, never in core** |
| **5. Dialects** | What bare-value patterns *mean/type* (e.g. `temporal@1`), markdown subset selection, future value grammars | Recognition/typing, not constraint |

**The pragma** (future) is the *binder* attaching a document to its schema
and dialects — a mechanism, not a sixth authority.

**Implicitly-declared dialects** — the *set of dialects active without an
explicit declaration* (e.g. whether temporal is on by default) is owned by
authorities **2 (parser/parser-type) + 3 (host)**, not spec-forced. The
spec forces the envelope syntax and the dispatch *semantics*; the host/parser
choose the default-active set. (Ratified 2026-07-11, D2-ET.)

## Structural principles

- **Menu vs knob**: the spec frequently forces an option-*space* and its
  default while authority 2 or 3 picks within it. Both may appear on one
  behavior at different altitudes; neither may invent options outside the
  menu.
- **Core preserves; schema constrains; tooling resolves; convention
  deters.** Core semantics never destroy information (stacking not
  overwriting; inert references not transclusion) and never proscribe
  (no reserved-name fencing — quoting friction and convention deter
  collisions).
- **Dialects ≠ schema**: meaning/typing vs allowed/required. A value can
  be typed by a dialect and forbidden by a schema; the two never trade
  jobs.
- **Content-markers vs the attribute-marker** (D9): at head position,
  `|`/`!`/` ``` `/`;`/`@` are *content markers* — they interleave with content
  and disambiguate by character-guard (letter/name-start = marker, else
  prose; `!` = `|`). `:` is *phase-restricted* — an attribute only before any
  child/text (attributes-before-children); after content it is prose. The
  attribute-marker rule is a structural truth (metadata precedes content),
  not a lookahead.
- **One special-start set, recognized at *head position*, one rule**
  (D8-unify + LEX-1): *head position* is the state — spanning block-line-start
  and sameline-condensed scan — where prose-vs-block is still undetermined.
  The markers
  `|` `:` `!` `;` `@` triple-backtick `'` are recognized identically at
  block-line-start and in sameline-condensed scan, and are literal in
  free-text (modulo Markdown/escapes). Comments are the exemplar. Each
  construct declares its marker and inherits recognition — no per-construct
  special-casing.
- **The `<…>` envelope is the visible core/dialect boundary** (D2-ET-ext):
  bare value = core scalar or string, always; dialect typing *always* wears
  `<…>`. No bare value is ever dialect-typed — so adding a dialect can never
  retype an existing document. Accretion is structurally impossible.

## The behavior table (living; grows with DECIDED.md)

| Behavior | Owner | Status / notes |
|---|---|---|
| Attribute value stacking, order-preserved | 1 spec | **Ratified** D-ATTR-1; uniform, incl. `$`-names |
| Stacking ⊥ array-literals (two multiplicity axes) | 1 spec | Ratified w/ D-AUTH-1; flattening is consumer/schema |
| Sugar desugarings (`[k]`→`$key`-style, `.t`, suffixes) | 1 spec | **Ratified** D1-FINAL; model (C), total-desugaring into **specially-designated** (not reserved) `$`-attrs; `traits` view always-list |
| `\|` defines / `@` refers partition | 1 spec | **Ratified** D1a |
| `$`-names: ordinary, no proscription | 1 spec | **Ratified** D1b-partial |
| Duplicate `(type,key)` policy menu + default=error | 1 spec (menu) + 2 parser (knob) | **Ratified** D-ATTR-3: `error\|allow-if-identical\|first-wins\|last-wins\|keep-all` + `warn` |
| Reference dereferencing | 2 parser (flag) + 3 host (defaults) | **Ratified** D-ATTR-2; core events never deref |
| Multi-valued `$key` (identity aliases) | 1 spec permits; 4 schema constrains | **Ratified** D1-FINAL (stacked aliases; cardinality = schema) |
| `<…>` explicit-typing envelope | 1 spec (envelope) + 5 dialects (labels) | **Ratified** D2-ET; `>`-terminated, `<type:…>`/`<dialect:type:…>` ladder |
| Unlabeled `<…>` dispatch | 1 spec (semantics) | **Ratified** D2-ET: declared dialects in declared order, first-claim-wins, all-decline → error |
| Set of implicitly-declared (default-active) dialects | 2 parser + 3 host | **Ratified** D2-ET (new authority row); temporal-as-implicit leaning-yes, open |
| Bare value typing = frozen **core scalars only** | 1 spec | **Ratified** D2-ET-ext: int/float/rational/complex/bool/nil/string/array; nothing else bare-types |
| ALL temporal (dates/times/durations/shorthand) | 5 dialects, **`<…>`-only** | **Ratified** D2-ET-ext: no bare form; unbracketed temporal-looking text = plain string |
| Temporal *validation* (reject `P1W2D` etc.) | 5 dialect-owned module | Rides decision 2; not parser-core |
| Cardinality/type restriction (e.g. single `$key`) | 4 schema | Principle ratified via D-AUTH-1 worked instance |
| Head-position guards: content-markers (`\|`/`!`/etc.) char-guard vs `:` phase-restricted | 1 spec | **Ratified** D9; `!`=`\|` letter-guard; `:` = attrs-before-children (defect #9 enforcement); `;` skip |
| Fence open/close/body (any-indent `\`\`\``; rest-of-open-line→body; exact capture) | 1 spec | **Ratified** D8; column sets parent (departs Markdown); info-strings + #14 subsumed |
| Sameline fence shorthand (`\|a \|b \`\`\``) | 1 spec | **Ratified** D8-unify; fence is a member of the special-start set — recognized in sameline-condensed position like every marker; prose backticks untouched |
| Markdown prose subset | 1 spec names it; 4/5 select | Decision 4 pending; Layer 1 of design/markdown-layers.md |
| Doc-schema vocabulary (`\|h1`…) | 4 schema | Layer 2; D4b pending |
| Rendering/conversion policy | 3 host / tooling | Layers 3–4 |
| Dynamics (`!`) evaluation | 3 host | Ratified long-standing (templating decision) |
| Mixins | — | **Under rethink/possible removal** (JOSEPH-TODO 10) |

Maintenance rule: when DECIDED.md gains an entry, this table gains or
updates a row in the same commit.

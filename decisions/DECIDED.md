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

---

## D4 — libdescent riders (2026-07-11)

**Ratified (Joseph), all three:** (a) **byte-identity retired** — udon's
suite + the front-end differential become the standing contract;
diff_generate demoted to on-demand; the improvements ledger is now
executable. (b) **Generator swap approved with sequencing** — merge+push
first, one dual-generator CI cycle, then Ruby leaves the drift gate
(remains available on-demand as historical oracle). (c) **Grammar aliases
approved and EXTENDED**: beyond `SC`/`EX`/`BT`/`TAB`, longhand descriptive
named aliases are allowed for all special characters — `<tab>`,
`<right-square-bracket>`, `<any-newline>`, etc. — authoring agents choose;
vocabulary lives in descent-rs; semantic-class names (e.g. `<any-newline>`
covering \n and \r\n) are part of the design space. Validation by the
new toolchain: Joseph assesses the probability of libdescent being less
principled/stable than the Ruby version as very low, and the instruments
agree. Branch merge review delegated to coordinator, instruments-based,
exceptions-only reporting.

---

## D2-ET — Explicit typing envelope + dialect dispatch (2026-07-11, partial)

**Ratified (Joseph):**
- **`<…>` explicit-typing envelope adopted** (spike: zero measured collisions
  across 35k lines). Attribute-value position; `>` terminates. Labels ladder
  `<type:…>` / `<dialect:type:…>`.
- **D4c non-collision confirmed**: the descent `<SQ>`/`<tab>`-style aliases
  live in `.desc` **bracket-key** position, never in an attribute *value* —
  different syntactic slot, no conflict (as it was before, so nothing regresses).
- **Shorthand is NOT evicted** — *reverses the spike's evict-to-explicit-only
  rec.* Bracketing keeps shorthand first-class: `<5m>`, `<30s>`, `<+30d>`
  remain writable, just inside the envelope.
- **Unlabeled `<content>` dispatch semantics**: the declared dialects attempt
  recognition **in declared order; first to claim wins; if all decline →
  error.** (This is the unlabeled-dispatch rule; spec-forced semantics.)
- **NEW authority**: the *set of implicitly-declared (default-active)
  dialects* is a host / host+parser decision (authorities 2+3), **not**
  spec-forced. Added to AUTHORITY.md.

**Open (correctly a host question — Joseph leaning YES):** is **temporal**
implicitly-declared (active without an explicit dialect declaration)? This is
an udon-core/host call, not an udon-syntax call.

**Residual the coordinator surfaces for a crisp answer:** bare (un-bracketed)
recognition scope when a dialect is active — does bare `5m` type, or is the
envelope required for the ambiguous-shorthand subset while *bare* recognition
stays limited to unambiguous forms (dates/datetime)? ⭢ **bare = unambiguous
forms only; `<…>` = full dialect range incl. risky shorthand** — preserves
least-surprise in both directions (bare `2026-07-11` types; bare `5m`
doesn't; `<5m>` does). Decouples "temporal is active" (host) from "which of
its forms are bare-recognized" (spec-forced recognizer set).

---

## D2-ET-ext — Temporal is bracket-only; the core/dialect line becomes visible (2026-07-11)

**Ratified (Joseph, leaning *past* the coordinator rec):** ALL temporal
values require the `<…>` envelope — **including ISO date/time/datetime
forms**. There is **no bare temporal recognition at all**. Unbracketed
`2026-07-11`, `14:30`, `P1Y`, `5m` are **plain text** (bare string), unless
they happen to match a frozen **core** scalar (`2026` stays an Integer).

**The principle:** bare-value syntactic typing is limited to the frozen
**core scalar set** (int / float / rational / complex / bool / nil / string
/ array — authority 1). **Dialects never bare-recognize; dialect-typed
values always wear `<…>`.** The envelope is thus the *syntactically visible
boundary* between core (authority 1) and dialect (authority 5): bare =
core-scalar-or-string, always; `<…>` = you have left core.

**Accretion: permanently closed.** A new dialect (temporal now, anything
later) can never retype an existing bare value — dialects don't touch bare
space. The bare-value grammar is frozen at the core scalars and never grows.

**Three non-sniffing ways to type a date:**
1. `<2026-07-07>` — inline explicit (unlabeled → default-dialect dispatch)
2. `<date:2026-07-07>` — inline explicit, labeled
3. `:created 2026-07-07` + schema `created: date` — typing by *declaration*;
   host projects the string (authority 4+3, not core).

**Migration reframed** (corrects the spike's "zero migration"): the 29 live
bare dates become **plain strings** — non-breaking today (nothing consumes
them as typed Dates yet), lazily upgradable (bracket, or declare schema).
Strings-until-typed, not broken.

**Implementation implication (execution, not ratified here):** bare temporal
recognition in `core/generator/values.desc` (the Jan-9/13 work) relocates
OUT of bare-value parsing into the `<…>` dialect processor — a substantial
core-parser simplification; defect #3 (bare temporal validation) becomes
moot in bare context. The recognition logic moves; it isn't lost.

**Decision 2 now effectively CLOSED.** Remaining low-stakes: temporal in the
*default* dispatch set (host; leaning yes) + the two label-ladder forks
(dialect-first; parallel aliases).

---

## D8 — Fences / freeform blocks (2026-07-11)

**Ratified (Joseph) — the core rule** (supersedes the decision-8 brief's
(a)/(b1)/(c); unifies them into one rule):
- **Open**: any line whose first non-space content is ` ``` ` opens a
  freeform block. Its indent (the `` ` `` column) follows the indent stack
  and sets the block's structural parent — a deliberate departure from most
  Markdown (fences need *not* be column-1), *required* because the column is
  how UDON knows which element parents the block. **Everything after ` ``` `
  on the opening line is captured as the start of the body** — so
  language/info-strings come free, no separate info-string grammar (retires
  spike-defect #14, multi-word truncation, by construction).
- **Close**: any line whose first non-space content is ` ``` ` closes it
  (the "any-line-closes" rule — unifies with (a)). Should be followed by a
  newline; trailing whitespace before that newline may be silently ignored.
- **Indent**: set by the opener; same-indent closer *recommended* (not
  required) so a reader mid-long-block can recover the parent's column.
- **Body capture = exact, no dedent** (consistent with "freeform breaks out
  of indentation entirely"). **Documented side-effect (Joseph):** content
  and closer indentation is *part of the result* — you cannot casually
  indent for aesthetics without it landing in the body. (spike-defect #15,
  blank-lines-dropped, is an impl bug to fix under this rule.)

**Proposed — Joseph leaning toward, NOT yet final — sameline fence shorthand:**
In sameline element-scan position (after `|element`, scanning for the next
reserved indicator `|`/`:`/`!`/`;` and **not yet in free-text/prose mode**),
` ``` ` is *also* recognized as a fence opener — same semantics as a
line-start fence, child of the current innermost inline element:

```
|a |b ```rust        ≡ (structurally)   |a
  some rust                                 |b
```                                            ```rust ...

```
This **supersedes the brief's "drop sameline fences" rec** — and *resolves*
the brief's collision worry: recognition is element-scan-position **only**,
so prose backticks (`` `code` ``, Markdown) are untouched (in free-text mode
` ``` ` is not a fence opener). The two forms are *structurally* equivalent
(freeform child of `|b`); body bytes differ because different whitespace is
typed (exact-capture).

**Authority:** fence syntax + open/close/body-capture = **spec-forced**
(authority 1).

**Open micro-edge for confirmation:** the closing fence line is the
*terminator* — its own leading whitespace is consumed (not body); the body
ends at the newline preceding the closer. ⭢ confirm this boundary reading.

---

## D8-unify — Block-mode special starts: one set, two positions, one rule (2026-07-11)

**Ratified (Joseph) — a unification, not a new feature.** UDON has exactly
one recognition rule for structural markers; the D8 sameline fence shorthand
is simply an instance of it, not a special case.

- One set of **block-mode special starts**: `|` `:` `!` `;` `@` triple-backtick
  and the escape `'` (the grammar's `:dispatch` set — see udon.desc).
- Recognized **identically in two positions**: *block* (line start, after
  indentation) and *sameline-condensed* (scanning after an element for the
  next token). Same set both places — sameline scanning is not a reduced or
  special variant.
- In **free-text / prose mode** the same characters are literal (subject to
  Markdown meaning + escape rules).
- **Comments are the worked exemplar**: `;` distinctly starts a comment in
  block/sameline position and is plain prose in free-text — the
  already-ratified `;` context-sensitivity. Every other marker (elements,
  attrs, directives, references, fences) obeys the identical rule.

**Refinement (Joseph's confirming example, 2026-07-11):** recognition is
**head/scan-position only**. `|a |b hey there ```ruby` is **not** a fence —
the token `hey` after `|b ` commits the line to prose, ending scan position,
so the later triple-backtick is literal text. One asymmetry to note (so the
`;`-parallel isn't over-read): `;` additionally has a *sameline-trailing*
comment role (`|p text ; comment`) — a `;`-specific rule, NOT part of the
head-position special-start set. Fences and the other markers have only the
head-position role. Once a fence *does* open at head position, freeform
capture runs to the closer — no marker interaction inside the body.

**Refinement 2 (Joseph, 2026-07-11) — recognition is a per-marker predicate,
not the lead char.** "Block-mode?" is decided by a short lookahead predicate
per marker, a few characters, not the first character alone:
- `|` is a marker only if followed by a letter / `[` / `.` / `{` / `'` — `|`
  + space is prose (the established pipe guard; Markdown-table safe).
- **triple**-backtick opens a fence; one or two backticks do not (→ prose /
  Markdown inline code).
- `:` `!` `;` `@` each carry their own marker-vs-prose predicate — **these
  ARE decision 9 (sigil guards)**: the guards *are* the predicates. (The
  colon-eating fix, defect #12, is one such predicate landing wrong today.)
So D8-unify and decision 9 are one mechanism from two sides.

**Escape member pending decision 5 (Joseph strongly leaning REMOVE `'`):**
the set currently lists `'` (block escape); Joseph is now "pretty sure" `'`
goes as an escape (→ `\`-only). That drops `'` from the head-position set — a
line starting `'` becomes plain prose. Open sub-distinction: `'`-as-escape
(head position) vs `'`-as-**string-delimiter** (`'foo'`, value context) — the
removal Joseph named is the escape role; whether the string-quote role also
goes is a separate call. Migration check before removal: scan live consumers
for `'`-escape usage (`bin/find-consumers`).

**Consequence:** the D8 sameline fence shorthand is **promoted proposed →
RATIFIED** — treating a fence as a special-start makes it recognized in
sameline-condensed position automatically; *not* doing so would make fences
the lone inconsistent exception. The parser's `.desc` `:dispatch` state
already encodes this set; the spec states the unification **once** and each
construct inherits recognition (shrinks both the spec prose and the mental
model). Authority: spec-forced (authority 1); a structural principle.

---

## LEX-1 — "Head position": a prominent, first-class lexicon term (2026-07-11)

**Ratified (Joseph):** *head position* is a load-bearing spec term and must be
prominent in the lexicon, not implicit.

**Definition:** the parser state — at a line's **head** (after indentation)
OR in **sameline-condensed scanning** (immediately after an element, before
any prose has begun on that line) — where it is **still undetermined whether
the next token is block-structural or prose**. The D8-unify special-start
predicates fire *exactly and only* here; the first token that fails all of
them commits the line to prose (free-text mode) and ends head position.

- **Spans both block (line-start) and sameline positions** — it is the
  meta-state *over* them, not a third sibling context.
- **This is the concept that unifies three rules into one**: D8-unify
  (special-start recognition), decision 9 (sigil guards = the per-marker
  predicates), and `;`/comment context-sensitivity are all "what happens at
  head position." State the rule once, at head position.
- **Canonical term** — supersedes the ad-hoc "block mode / scan position /
  sameline-condensed scan" phrasings used in prior entries.
- **Spec placement (flagged for the FULL-SPEC edit):** must appear
  prominently in the "Positional Contexts (Vocabulary)" table alongside
  block / sameline / inline / embedded — arguably *before* them, since it is
  the state in which the others are chosen.

---

## ARCH-1 — Bounded lookahead is a grammar invariant; pending-lookahead is suspendable state (2026-07-11)

**Observation (Joseph), recorded as a durable design invariant.**

- **UDON is deliberately bounded-lookahead.** Disambiguating head position
  (and every marker predicate) rarely needs more than ~2–3 characters, and
  never multi-level backtracking. This is *why* the state-machine / descent
  approach is the right tool — and why PEG (packrat, unbounded
  backtracking/memoization) is unnecessary. **Constraint on all future
  syntax:** new constructs must stay within bounded lookahead, single-level.
  A syntax that needed deep backtracking would force abandoning descent.
  - **Health check — every decision this session passes:** special-start
    predicates (`|`+1, triple-backtick=3, `@[`=2, `!{`/`!:`=2), the `<…>`
    typing envelope (`<`=1, scan to `>`), define/refer — all ≤3 chars,
    single-level. We have not designed ourselves out of the architecture.

- **Streaming consequence.** When a chunk boundary lands *mid-disambiguation*
  — a head-position marker seen, its disambiguating follower not yet arrived
  — those bytes are held in **suspendable parser state**, not emitted:
  ElementStart-vs-Text cannot be emitted until disambiguated. This is exactly
  the suspendable-state class the **S5 explicit-stack prototype already
  validated** (the escape-across-boundary `pending_skip` and
  `TERM(-1)`-into-carry-buffer cases); head-position lookahead generalizes it.
  **Requirement on decision 3 (StreamingParser / explicit-stack backend):**
  the reified state must include the pending-lookahead buffer. (S5 already
  demonstrated this works at 1-byte chunks — so the requirement is met, not
  merely stated.)

---

## D1-terms — "specially-designated" (not reserved); `$traits`; traits always-list (2026-07-11)

**Ratified (Joseph):**
- **Terminology**: the `$`-attributes the sugar desugars into
  (`$key`/`$traits`/`$?`…) are **specially-designated**, *not reserved* —
  consistent with D1b-partial (no reserved namespace; any `$`-name is a legal
  ordinary attribute). "Reserved" is banned as the term (it implies fencing
  we don't do). Corrected across identity-model.md / AUTHORITY.md.
- **`$traits`** is the trait designation (over `$trait`); each `.t` adds a
  stacked value.
- **The `traits` view is always a list** — `[]` / `["a"]` / `["a","b"]`,
  regardless of count — for app-dev simplicity (matches udon-ast).

**Flagged impl nuance (general case):** whether an ordinary *single-valued*
stacked attribute presents as scalar or 1-element list (`:x v` → `v` vs
`["v"]`) is the **attrs() API surface** call — a host/impl decision. Traits
is the ratified always-list exception; the general default is likely
`.attr` (scalar/last) + `.attr_all` (list).

---

## D1-FINAL — Identity model ratified in full (2026-07-11) — DECISION 1 CLOSED

**Ratified (Joseph): `decisions/identity-model.md` in its entirety.** The
package:
- **Model (C)**: `element = name + ordered attributes + children`;
  identity / traits / suffixes are **views**, not model.
- **Total desugaring (invariant)**: `[k]`→`$key`, `.t`→stacked `$traits`,
  `?`/`!`/`*`/`+`→`$?`… into **specially-designated** (not reserved)
  `$`-attributes (any `$`-name stays a legal ordinary attribute).
- **Wire names**: `$key` / `$traits` / `$?` — single family, no aliases.
  `$traits` (not `$trait`); the **`traits` view is always a list**.
- **Multi-key aliases** via stacking (spec permits; schema constrains
  cardinality).
- **Key-scope enforcement**: duplicate `(element-name, $key)` **definition**
  → Document-layer error by default (policy-configurable, D-ATTR-3);
  event/streaming layer stateless.
- **Recommended host views** (authority 3, *not forced*): `all_attributes`
  (flat/raw, incl. designated) + distinct `{key, traits, attributes}`
  (attributes = non-designated).
- **Parser/host knobs — durably specified (§3), ratified**: deref flag +
  mode-default (D-ATTR-2); duplicate-policy enum (D-ATTR-3); view
  exposure/naming; key-multiplicity surface; designated-attr hiding;
  single-stacked scalar-vs-list = **host call with recommended default**
  (`.attr` scalar/last + `.attr_all` list; traits always-list).
- **Schema** (authority 4): cardinality, type-restriction, required/optional,
  vocabularies.
- **No canonical-form question** (UDON mandates none; `udon fmt` optional).

**Executable next:** identity spec-edit (~1 page) + the U4 impl (typed-key
fix defect #2, the `Attr("id")`→`$key` event correction, view accessors, the
Document-layer duplicate check). Decision 1 — the hardest, most-contested
surface — is closed.

---

## D9 — Head-position markers: content-markers (char-guard) vs the attribute-marker (phase-restricted) (2026-07-11)

**Ratified (Joseph), and it resolves decision 9 (sigil guards):** the
head-position markers split into two kinds, not one guarded set.

- **Content markers** — `|` (element), `!` (directive), ` ``` ` (fence),
  `;` (comment), `@` (reference): **interleave freely with content** (they
  can appear after text), and are disambiguated by a **character-guard** at
  head position — a letter / name-start after the sigil = marker; space or
  non-name = prose. **`!` structural (head-position block-directive)
  follow-set: identifier-char OR `:`** — `!if`/`!for` (identifier), `!:lang:`
  (colon, raw code block — Joseph's nuance; a *pure* letter-guard would have
  **broken** `!:lang:`). `![img]`/`!=`/`!(`/`! ` → prose. **`!{…}` is NOT
  structural** (correction — I over-added `{`; Joseph): it is an **inline
  interpolation / inline-directive at PROSE level**, and may be the very
  first thing in a prose line — `!{` at head → *prose* (containing the inline
  construct), not a block directive. (Level distinction: `|{…}` embedded
  elements ARE structural, but `!{…}`/`;{…}` are prose-level annotations —
  the brace-form is not uniformly structural.) **Defect to fix**: the current
  parser wraps a head-position `!{{value}}` in a block `DirectiveStart/End`
  (treats it structural) — it should surface as prose + `Interpolation`.
  (Directive syntax stays — dialect-defined
  templating still needs it; the earlier "templating is a dialect" decision
  removed the *evaluator*, not the head-position directive syntax.)
- **The attribute marker** — `:` — is **phase-restricted, not
  char-guarded**: an attribute *only while the element has no children/text
  yet* (attributes-before-children). Once content starts, `:` at head is
  prose. **Verified live:** `:one for the ages` after a text line currently
  mis-parses as `Attr('one')` — this is **defect #9**, and *enforcing #9 is
  implementing the `:` rule* (one fix, not two). The name-start char-guard
  within the attribute phase is defect #12 (already fixed).
- **`;` guard:** ⭢ **skip** — zero corpus incidence (S3); cosmetic only.
- **Indentation:** markers are at head position only at the content-head
  column; a line indented *past* content-base is prose continuation
  regardless of its first char (verified).

**Why this is the deep version:** attributes are element *header* metadata
(they precede content); everything else (elements, directives, fences,
comments, refs) is content that interleaves. So `:` being phase-restricted
isn't an ad-hoc guard — it's that structural truth. Decision 9 becomes:
adopt the `!` letter-guard (done), enforce defect #9 for `:` (impl), skip `;`.

**Clarification (Joseph, 2026-07-11, verified) — the `:` phase-restriction
is PER-ELEMENT**, not per-document. Each element opens a *fresh* attribute
phase; `:` is an attribute while *that element* has no children/text yet,
and prose after. Opening a new child/sibling element resets the phase.
Content markers interleave freely at head position — worked & verified:

- **Ex1** (`|` interleaves; per-element phase):
  ```
  |p
    hello there
    |a :src http://google.com THE BEAST
    , how are you doing?
  ```
  → `p`: [Text "hello there", **Element a** (`:src` is a's attr — a's phase
  is fresh though p has content), Text ", how are you doing?"]. Mixed
  content: the element sits inline in the prose flow, prose resumes as its
  sibling.

- **Ex2** (`!` directives interleave):
  ```
  |p
    good
    !if beastlike == true
      enough
    !else um, ok
    enough for now...
  ```
  → `p`: [Text "good", Directive if(body Text "enough"), Directive else(Text
  "um, ok"), Text "enough for now..."].

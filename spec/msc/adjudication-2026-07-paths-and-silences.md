# Adjudication packet — path syntax + 0.9 silences (2026-07-16)

Session material for Joseph. One item at a time, examples first, a
recommendation on each; rulings get recorded inline here during the session,
then drained (CORE / TODO-AUX / fixtures / changelog) and this file archived.
Prepared by the 2026-07-16 session (Claude) from a full read of
`design/udon-paths.md` against ratified CORE 0.9. Not re-opened here:
anything already in the changelog's rulings ledger.

Status vocabulary: **ratified** / settled-provisional / leaning / open.

---

## Part A — Path syntax (design fresh; `design/udon-paths.md` is input, not law)

Joseph, 2026-07-16 (mid-session): *"we'll want to use the path syntax for
references in udon itself, or some subset, we think. Feel free to develop
the underlying parser as you go — it would be awesome if it's a simple
descent grammar again... udon-paths.md is old and stale and you have zero
need to care at all about what it says (or you can use it as your starting
point, no problem)."*

So the frame is: design the syntax fresh with the doc as raw material, and
prototype the parser (descent-grammar leaning) alongside. What survives
from the doc on its merits: paths reuse UDON's own prefixes ("a path is
UDON, linearized"), traits AND-filter, `at` = exactly-one-or-error /
`all` = explicitly plural — the fail-on-ambiguity contract the agentic
edit tool needs.

### P0 — The unification driver: references ⊂ paths

CORE's ratified reference form is *already* a single path segment:
`@licence[mit].realized` = `(element, key, traits)` = exactly the
element-segment AST (`name? key? traits?`), and the planned structured
reference wire (`ReferenceStart`/`Name`/`Attr "$key"`/`Attr "$traits"`)
is its encoding. Unification is nearly free by construction. Two design
consequences to keep in hand:

- **The subset question — genuinely open**: what do in-document references
  get? Today: one segment, no attrs/wildcards/descent ("notably absent by
  design"). For the record (Joseph, 2026-07-16): references were **never
  nailed down as zero-or-one vs multiple** — and CORE agrees: "matching
  multiplicity is consumer-side" is ratified, and a trait-only `@.realized`
  is plural by design. So no determinism principle constrains the subset;
  if wildcards/`||`/indices stay out of *references*, the reason must be
  something real (value-boundary syntax budget, conservatism-until-need),
  not uniqueness. Candidate floor: multi-segment absolute paths
  (`@config|database[primary]`); ceiling: the whole path language. The
  full syntax is available to tools (at/all, skeleton, edit tool) either
  way.
- **Document-embeddability is a hard constraint the standalone framing
  never had**: reference-paths must parse inside documents under bounded
  lookahead with clean terminators at value boundaries — e.g. what
  `@config|database` does to the sameline scan (`|` mid-token vs `|` at a
  boundary), where a reference-path ends in value position, in arrays, in
  embedded `|{…}`. **This is what the descent prototype exists to force
  into precision** — build the grammar, let it surface the terminator
  questions, bring the sharp ones back here.

Ruling (direction): _________

### P1 — THE collision: positional `[0]` vs typed identity `[0]`  ⚠ biggest call

The doc: "Numeric indices are positional, string keys are identity-based.
`|user[0]` = first user, `|user[alice]` = user with key alice."

CORE 0.9 (Identity, ratified): the value inside `[...]` follows normal
attribute-value rules — **`[1]` is the integer 1**, `["01"]` the string
"01". So `|step[1]` in a *document* is an identity (integer key 1), and a
path `|step[1]` must be able to address it. The doc's positional rule makes
`[integer]` mean something a document's own identity can never mean — it
breaks the "paths look like the UDON they navigate" principle at exactly the
place identity lives.

Options:
- **(a) Brackets are identity only; positional access leaves the syntax
  for v1** — `all()` returns document order, so hosts index results
  (`doc.all("|item")[0]`); a positional *syntax* returns later (with the
  patch/edit work) if evidence demands, under a visually distinct form.
- (b) A distinct positional marker now (e.g. `[#0]` / `#0` — new symbol,
  against the doc's own no-new-symbols principle, but honest about being a
  different kind of thing).
- (c) Doc's rule (integers positional) + quoted/`<…>` forms for integer
  identities — rejected out of hand? it silently shadows legal identities.

**Recommendation: (a).** Identity purity keeps the load-bearing principle
intact; the edit tool addresses by identity/skeleton anyway; positional
syntax can be added compatibly later, never removed.

Ruling: _________

### P2 — Attribute segments under the 0.9 model (stacking + node values)

The doc predates stacking-as-the-rule and node-valued attributes. Three
sub-calls, one coherent posture available:

```udon
|el :x 1 :x 2                ; stacked — x = [1, 2]
|api
  :headers
    |header[auth] :value Bearer
```

- `at("|el:x")` over a stacked attribute → recommend **last value** (the
  ratified host-view scalar convention); `all("|el:x")` → every value in
  order. `at` stays exactly-one *path match*; multiplicity of *values* is
  the attr's own semantics, not path ambiguity.
- Navigation continues into node values naturally:
  `|api:headers|header[auth]:value` (already in the doc — keep).
- The doc's `:attr:value` / `:attr:nested` forms (pre-0.9 "complex attr"
  relics): `:value` as a pseudo-accessor **dies**; `:attr:attr2` is only
  legal as "attribute of the node-valued attr" (i.e. sugar for stepping
  into the node) — recommend requiring the explicit node step
  (`:headers|header…`) and dropping `:attr:attr2` chaining in v1.

Recommendation: as above (last / all-in-order / explicit node step).

Ruling: _________

### P3 — `|.trait`: anonymous-only, or any-element-with-trait?

```
|.defaults        ; document: an ANONYMOUS element carrying .defaults
|*.deprecated     ; path doc: any element with .deprecated
|.intro           ; path: ambiguous today — anonymous only, or any?
```

Mirror-the-document says `|.intro` selects **anonymous** elements with the
trait (exactly what that spelling *defines* in a document), and `|*.intro`
is the any-element form — both stay available, no ambiguity.

**Recommendation: `|.trait` = anonymous-only; `|*.trait` = any.**

Ruling: _________

### P4 — Charset + typed key matching (alignment, not really a fork)

The doc's grammar has `identifier := [a-zA-Z_][a-zA-Z0-9_-]*` (pre-0.9) and
untyped `value` keys. Recommend: paths inherit CORE's rules verbatim —
names are Unicode identifiers (XID_Start; continue XID_Continue + `-` +
`/`; quoted `'weird name'` for the rest), and bracket contents follow the
normal value rules with **typed equality** (`[1]` matches the integer-1 key,
`["1"]` the string — same scanner, same types as the document side).

Ruling: _________

### P5 — `||` recursive descent (author-flagged for user-testing)

Doc semantics are XPath-`//`-shaped and already support element-less
continuations: `||[primary]`, `||.deprecated`, `||:author` (any depth).
Recommend: **confirm as written**, and route the author's user-testing flag
into the usability-harness rebuild (path-comprehension tasks) rather than
blocking the syntax. One addition: the doc's orphan-reference example uses
`||@*`, which its grammar never defines — either add `@*` (any reference)
or cut the example.

Ruling: _________

### P6 — Reference segments inside paths (now a P0 corollary)

- Leading `@user[alice]` = **definition lookup** (type-scoped key index on
  the Document — not "resolution" in the host-mode sense); `@[alice]`
  errors when ambiguous across types (same rule as CORE resolve-time).
  Under P0 this is literally "a reference, evaluated" — one mechanism.
- Trailing `:customer@` = **follow the reference stored in the attr**; the
  path continues *at the resolved definition* (`|order[123]:customer@:email`).
- Multiplicity inherits, it is not re-legislated: a reference may match
  multiple definitions (consumer-side multiplicity, ratified in CORE) —
  following one under `at()` errors on plural, under `all()` fans out.
  Unresolvable = path error (fail-loudly), never a silent empty.

Recommendation: adopt these clauses; specify them as the path-side
semantics of the unified reference form.

Ruling: _________

### P7 — Addressing prose, comments, raw bodies (the edit tool will ask)

The syntax addresses elements/attrs/traits/refs only; the skeleton shows
`(prose 28 lines)` but no path can point *at* a paragraph, comment, or raw
body. The edit tool's v1 need is real but API-shaped.

**Recommendation: defer syntax; expose positionally via API on the parent**
(children include Text/Comment/Raw nodes in order — tree.rs already holds
them), and revisit a text-segment syntax together with patch syntax, which
will show what shape edits actually demand.

Ruling: _________

### P8 — Wildcards are whole-segment; no globs (confirm)

`|*`, `[*]`, `:*` — yes; `|foo*` (glob) — no, not a thing, and `*` being an
element-suffix character in documents makes globs permanently confusable.
State it explicitly in the spec text.

Ruling: _________

### P9 — Deliberate absences (confirm as design, so nobody "fixes" them)

No parent-step (`..`), no predicates/filters beyond traits+keys, no
arithmetic — matching CORE references' "notably absent by design" posture.
The escape valve for complex queries is the host language over `all()`.

Ruling: _________

---

## Part B — 0.9 spec silences (from TODO-SPEC-CORE; each needs ruling or explicit deferral)

### S1 — Multiple element suffixes (`|field?!`)

Grammar today: one suffix per identity position (after `?`, a second suffix
char falls to prose). The desugar model would make stacking free
(`:'$?' true` + `:'$!' true`, order preserved), and schemas own the meaning
anyway. **Recommendation: allow stacking** — it removes a silent surprise
(`|field?!` currently half-parses) for zero model cost.

Ruling: _________

### S2 — Multi-line `[...]` arrays

Today: newline inside `[…]` → `UnclosedArray` error (items so far kept).
**Recommendation: explicit deferral** — single-line arrays are the 0.9
contract; multi-line wants the deferred-block + stacking machinery that
already exists (`:key` + deeper lines), and a future ruling can lift it
compatibly.

Ruling: _________

### S3 — Unclosed identity bracket at EOF (`|el[unclosed`)

Not in the EOF table. **Recommendation: mirror the quoted-string row** —
captured content becomes the key + `Error UnclosedIdentityKey` (working
name), element closes via the universal implicit closer. Fixture it.

Ruling: _________

### S4 — Empty embedded `|{}`

Grammar today: parses silently as an empty anonymous embedded element
(EmbeddedStart/End). That is coherent — anonymous elements are first-class.
**Recommendation: bless current behavior**, one CORE sentence + fixture.

Ruling: _________

### S5 — Interpolation inside element keys

Probed 2026-07-16: `|div[!{{id}}]` already emits `Attr "$key"` +
`Interpolation` (whole-value). **Recommendation: pin it** — one sentence in
Identity ("a key that is entirely `!{{…}}` is an Interpolation value; the
host evaluates") + fixture; *mixed* key text stays with the multi-part
question (C1).

Ruling: _________

### S6 — Whitespace-only lines in prose

Parser today: empty line → `BlankLine`; spaces-only line → residual
`Text " "` (consumers treating Text as has-content trip on it). Every event
carries a span, so no bytes are lost either way.
**Recommendation: whitespace-only prose lines emit `BlankLine`** (span
covers the whitespace — round-trip safe); freeform blocks keep exact `Text`
(already ruled — exact preservation is their contract).

Ruling: _________

---

## Part C — Two queued quick calls (not silences, same session)

### C1 — Multi-part interpolation wire (`pre!{{x}}post`)

Today: whole-value interpolation works both positions; mixed parses as one
`BareValue`. DYNAMICS' old `ArrayStart` sketch contradicts the flat wire.
**Recommendation: re-emitted `Attr` segments** — `Attr "x"` / `Text "pre"` /
`Attr "x"` / `Interpolation "x"` / `Attr "x"` / `Text "post"` — exactly the
blob/stacking mechanism, zero new wire concepts; hosts that care recombine.
(Element keys mixed the same way via re-emitted `Attr "$key"`.)

Ruling: _________

### C2 — Annotation-layer syntax (agent metacognition)

The Dec sketch `|{@ …}` is invalid under 0.9. Options: (a) a named element
convention (`|{note :confidence 0.7 …}` — zero new syntax, schema owns the
vocabulary); (b) a reserved trait family (`|{n.meta …}`); (c) new syntax
(a real sigil — highest cost, cleanest strippability). No strong
recommendation — this one is a taste call; (a) is the do-nothing-safe
default that tooling can strip by schema.

Ruling: _________

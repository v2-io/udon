# Decision brief — explicit typing of attribute values (gates decision 2)

**Spike S-ET** · drafted 2026-07-11 · status: **awaiting Joseph's call**
Sources verified for this brief (read, not trusted): spec/AUTHORITY.md,
decisions/DECIDED.md (D1a/D1b/D-ATTR-1..3/D-AUTH-1/**D4** aliases),
decisions/value-dialects-brief.md, spec/FULL-SPEC.md (§Attributes,
§Value-Terminator-Rules, §Unified-Inline-Syntax, §Code-and-Raw-Content,
§Dynamics, §Value-Types), spec/TIME-SPEC.md, CONSUMERS.md,
core/generator/{udon.desc,values.desc}, and **empirical parser probes** built
from `core/target/release/examples/stdin_parse` (release build, exit 0).
Corpus measured: the 5 live consumer `.udon` + 14 repo `examples/*.udon`.

## The question (Joseph, near-verbatim)

Should attribute values support **explicit typing** — (1) explicit type
annotation (implicit types also expressible explicitly), (2) explicit
bracketing like `<u64:0xf902>`, `<P12D>` (unlabeled = "not plain text, a
dialect should handle it"), `<interval:…>`, `<time:interval:…>` (dialect+type
prefixes for increasing specificity), or (3) reuse of existing syntax
carve-outs? `<>` is an example, not a requirement — pick what conflicts least.
**Key affordance he identified: only attribute-value bare-text collapses on
whitespace; prose blocks are untouched.** So the collision surface for any
envelope is *precisely the one place the corpus never puts angle brackets.*

## The three coordinating-session findings — verified, two corrected

- **(a) inline-raw `!{:kind: …}` is forbidden as an attribute value → option 3
  is "reserved-empty."** *Reserved-empty: confirmed. "Zero new grammar":
  FALSE — corrected.* Probed: `:key !{:u64: 0xf902}` today emits
  `BareValue("!{:u64:")` + stray `Text("0xf902}")` — the sameline/embedded
  value tokenizer **space-splits at the label's trailing space** and never
  enters brace-counting. There is even a live in-the-wild instance —
  `examples/ash-like-billing.udon:80` `:fallback !{:ex: "Money.zero(:USD)"}` —
  which **mis-parses today**. So lifting the ban is not free: it requires
  routing value-context into the inline-raw brace-counter (real, if localized,
  grammar work). The upside: that mis-parsing live line is a genuine *demand
  signal* for typed/raw values.

- **(b) D4 descent aliases (`<tab>`, `<any-newline>`, `<SQ>`) already use
  `<…>` inside `.desc` bracket-keys → convergence AND collision.** *Confirmed,
  and sharper than stated.* `.desc` files are UDON-family (`|c[<SQ>]`,
  `|state[:num_sign]`, `|type[Date]`); there are **36 real `[<X>]`
  identity-brackets** in the parser's own grammar source (udon.desc 34,
  values.desc 2), e.g. `|c[<SQ>]`, `|c[<0-9 '_'>]`. Probe: `|el[<SQ>]` emits
  `Attr($id)` + `BareValue("<SQ>")` today — a bare-string id. **Crucial scope
  finding: `[<…>]` identity-brackets occur *only* in the descent grammar, never
  in any of the 19 corpus `.udon` documents.** (The only `[…<…>…]` hits in
  documents are XPath predicates like `[position()>1]` inside mathml/docbook
  *raw* content and one prose `[… -> …]` — not identity-brackets.) So making
  `<…>` the dispatch marker converges the descent aliases into "an instance of
  a `descent`/`charclass` value-dialect" (elegant) but **would retype the
  descent grammar's own `$id`s** — a collision confined to one internal,
  fully-controlled corpus we regenerate anyway. Feature-with-a-migration, not a
  landmine.

- **(c) Explicit marking lets the implicit recognition set freeze small.**
  *Confirmed and load-bearing — this is the strongest reason to say yes.* If
  risky shorthand can be spelled explicitly, the implicit machine can freeze at
  {dates, ISO datetimes, ISO durations} and **evict** the ambiguous shorthand
  (`5m`, `30s`, `+30d`) to explicit-only. This dissolves value-dialects-brief
  open-item #1 (the temporal/temporal-shorthand profile split) — see *Revised
  decision 2* below.

## Candidate syntaxes (all probed against the live parser)

| # | Candidate | Today's parse of the token in value position | Verdict |
|---|---|---|---|
| C1 | **`<…>` envelope** `<u64:0xf902>` `<P12D>` `<interval:2025/2026>` | whole token → `BareValue` (unclaimed) | **survivor** |
| C2 | **lifted `!{:kind: …}`** | space-splits / mis-parses (see (a)) | raw-sibling, not primary |
| C3 | **backtick** `` `P12D` `` | `` BareValue("`P12D`") `` (unclaimed) | viable, but overloads MD code |
| C4 | **`~`-sigil** `~u64:0xf902` | `BareValue("~u64:0xf902")` (unclaimed) | viable, no terminator, ~ overloads |
| C5 | **annotation-only** (no envelope; a sibling `:key.type` or `$type` attr) | n/a — pure attribute convention | complement, not substitute |

## Measured collision table (19 files, whitespace-collapsing value contexts only)

Denominator note: raw counts (183k `:`-tokens, 28k `[…]`) are dominated by
XSLT/MathML *raw content* in two docbook/mathml examples; CONSUMERS.md's
curated live figures (224 `[key]` ids, 28 bare dates across the 4 real
consumers) are the honest denominator. Collisions counted below are in true
**bare-value / bracket-key** position.

| Candidate | Bare-value collisions in corpus | Where the char *does* live (untouched) | Residual risk class |
|---|---|---|---|
| **C1 `<…>`** | **0** (`:k <…>`, `:op <`, `:op <=`, `[<id>]` in docs = 0) | prose arrows `->`/`<->`, prose math `\|A\|<2`, comments `; <xsl…>`, quoted `"<x>"`, MD code spans, XPath in raw blocks — **all outside value tokenization** | relational-operator *values* (`:op <=`) — 0 today, plausible in a future rule/policy DSL |
| **C2 `!{…}`** | 14 `!{`-in-value sites — **13 are live** interpolation/directive (`!{{env.X}}`, `!{now}`), 1 is the mis-parsing raw `!{:ex: …}` | dynamics namespace (in active use) | shares the `!{` prefix with interpolation; disambiguated only by 2nd char |
| **C3 `` ` ``** | 0 in value position | prose code spans (heavy) | no closing-terminator rule; MD-code overload |
| **C4 `~`** | 2 soft (`:forms ~ logical time`, cheatsheet `:tilde-value ~` = nil) | prose, paths (`~/`), YAML-nil idiom | no terminator; nil-sigil overload |
| bracket-key `[<X>]` | **0 in documents; 36 in `.desc` grammar** | descent char-class aliases only | internal-only; regenerated corpus |

**Headline:** across ~35k lines, **zero** bare attribute values collide with
the `<…>` envelope. Joseph's affordance is exactly why — every `<`/`>` in the
corpus sits in prose, comments, quotes, or raw blocks, none of which the value
tokenizer touches.

## Per-candidate: ergonomics + feasibility

- **C1 `<…>` (recommended primary).** Ergonomics: reads as a type-cast, scans
  cleanly on the real cases — `<u64:0xf902>`, `<P12D>`, `<interval:2025/2026>`,
  `<time:interval:…>`, `<lat:40.7>`, `<5m>` (evicted shorthand made explicit).
  Feasibility: **localized.** In value contexts, a leading `<` opens an
  "envelope" sub-scan that runs to the matching `>` and emits one typed event
  (`TypedValue{label, content, span}`); `>` is the terminator, interior bytes
  are opaque bare text (space-collapse is the dialect's business, not the
  machine's). No interaction with number/temporal states (those never begin
  with `<`). Streaming cost: one state, one terminator — cheaper than the
  temporal sub-machine already resident. It does **not** disturb the frozen
  scalar/temporal recognizer; it sits *before* it as a first-byte branch.

- **C2 `!{:kind: …}` (keep as the raw sibling, not the typed primary).**
  Different job: opaque, brace-counted, verbatim, multi-brace-tolerant —
  ideal for `!{:json: {…}}` / `!{:regex: [a-z]{3,5}}` / the `!{:ex: …}` case.
  Fixing it for values means wiring the existing inline brace-counter into
  value context (moderate). Recommendation: **do fix it** (the live
  mis-parse is a bug regardless) but scope it to *raw opaque* content, and let
  C1 own *typed scalars*. The two unify cleanly: `<dialect:type:val>` = typed
  bare-text envelope; `!{:kind: …}` = raw opaque envelope. Same 2nd-char
  dispatch discipline FULL-SPEC already uses for `!{`.

- **C3 backtick / C4 `~`.** Both parse as unclaimed today, but neither has a
  natural closing terminator (`<…>`'s `>` is the decisive advantage), and both
  are heavily overloaded (MD code; home-dir/approx/nil). No corpus advantage
  over C1. **Drop.**

- **C5 annotation-only.** `<…>` already *is* explicit annotation (the label is
  the annotation). A separate sibling-attribute form (`:port 8080 :port.type
  u16`) is strictly more verbose and splits one value across two attributes —
  bad under D-ATTR-1 stacking. Keep the affordance "implicit types are also
  expressible explicitly" **inside** C1: `<int:42>` ≡ `42`, `<date:2026-07-07>`
  ≡ `2026-07-07`. **Fold into C1, don't ship separately.**

## The label grammar — `<type:…>` vs `<dialect:type:…>`

Specificity laddering by **colon-delimited identifier prefixes**, least-to-most
specific left-appended:

- `<content>` — **unlabeled**: "not plain text; a declared dialect should type
  this" (Joseph's unlabeled-dispatch case). Host/dialect-set decides.
- `<label:content>` — **one label**: a type *or* a dialect name (they share a
  flat namespace — see Authority mapping).
- `<dialect:type:content>` — **two labels**: increasing specificity, e.g.
  `<time:interval:2025/2026>`.

**Termination rules (per context, all resolved):**
- Envelope closes at the **first unescaped `>`**. Interior is opaque bare text.
- Label segments are `[A-Za-z][A-Za-z0-9_-]*` **identifier-led**; label parsing
  stops at the first segment that isn't identifier-led. This resolves the
  colon-in-content wrinkle: `<time:14:30:00>` → dialect=`time`, content=
  `14:30:00` (because `14` is digit-led, not a label). No lookahead needed.
- A literal `>` inside content: quote the whole value (`":op >="`) or let the
  dialect define an escape. Corpus need: **zero**.
- Interaction with interpolation `!{{…}}`: orthogonal — `!{` opens dynamics,
  `<` opens typing; a value beginning `<` never enters interpolation and vice
  versa. Mixed `<u64:!{{x}}>` is a dialect-interior question (defer; no demand).
- Array items / embedded: `<…>` respects the same terminators as any bare value
  *plus* its own `>`; since the machine is in envelope-scan until `>`, the outer
  `]`/`}`/space terminators are suspended inside the envelope (correct — a
  `<interval:2025/2026>` array item must survive its own `/`).

## Recommendation

**Adopt C1 `<…>` as the explicit-typing envelope for attribute values, with
the colon-laddered label grammar above; keep/repair `!{:kind: …}` as the
distinct raw-opaque sibling; fold "explicit spelling of implicit types" into
C1.** Confidence **high** on C1-over-{C3,C4} (terminator + zero collision),
**high** on the C1/C2 division of labor (typed vs raw), **medium** on the two
forks below.

**Honest two-fork residue (needs Joseph):**
1. **One-colon label namespace.** `<u64:…>` — is `u64` a *type* (in the flat
   type table) or a *dialect*? Fork A: flat shared namespace, longest-match
   against declared dialects then types (simple, tiny ambiguity risk). Fork B:
   require dialects to always be the *first* segment, so one-colon is *always*
   type (`<u64:…>`), dialect needs two (`<time:interval:…>`). **Lean B** — it
   makes `<time:interval:…>` vs `<interval:…>` mean exactly what Joseph's
   examples imply and removes the ambiguity. Cheap to fix now, expensive later.
2. **Unify descent aliases under `<…>` now, or keep parallel?** Convergence is
   real (finding b) but the collision is the descent grammar's own `$id`s.
   **Lean: keep parallel for now**, note the convergence in the spec, and let
   the descent-DSL adopt a `charclass` value-dialect *if/when* it re-generates
   — don't couple this decision to a parser-internal refactor.

## Revised decision 2 (Option B) if explicit typing lands

Explicit typing **strengthens** value-dialects-brief's Option B and retires its
weakest sub-call:

- **Freeze the implicit recognizer smaller.** Implicit (default-on `temporal@1`
  std profile) = {`Date`, `YearMonth`, ISO `DateTime`, ISO `Duration`}. **Evict
  the ambiguous shorthand** (`5m`/`30s`/`+30d`) from implicit recognition;
  spell them explicitly `<5m>` / `<dur:5m>` / `<rel:+30d>` (or ISO `<P5M>`).
  This **replaces** brief open-item #1 (the temporal vs temporal-shorthand
  profile split) — no profile split needed; the envelope *is* the opt-in.
- **Migration story for the 29 live dates: still zero.** Every live temporal
  value is a full `YYYY-MM-DD` Date (CONSUMERS.md: 28 dates, all ISO) — all
  stay implicitly recognized. No document gains a pragma, no `<…>` required.
  Explicit typing is **additive**: it gives authors a *way up* (pin/disambiguate
  a risky value) without imposing a *tax* on the common case.
- **What TIME-SPEC becomes.** Header recast (per brief) as "the `temporal@1`
  value-dialect, std profile." Shorthand-duration section demoted from
  "recognized bare" to "spellable via `<…>` (explicit) or ISO." Defect #3
  (validation) still lands as the projection-layer dialect module; explicit
  `<dur:…>` gives that module a second, unambiguous entry point.
- **The retype-bait cases** (`:version 0.0.1`, `:status first-pass`) gain a
  clean escape that isn't quoting: `<semver:0.0.1>` says "type me" and
  `"0.0.1"` says "don't" — explicit typing gives the freeze a *pressure-release
  valve* the pure-implicit design lacked.

## Authority mapping (per spec/AUTHORITY.md)

| Facet | Owner | Rationale |
|---|---|---|
| **The `<…>` envelope syntax itself** (delimiters, terminator, label-ladder grammar, event `TypedValue`) | **1 Spec (forced)** | It's core surface syntax every conformant parser must recognize identically — same tier as list `[…]` / inline `!{…}`. |
| **The label vocabulary** (`u64`, `interval`, `time`, `semver`, …) — what a label *means/types* | **5 Dialects** | "What bare-value patterns mean/type" is dialects' charter verbatim; `temporal@1` is the first resident. |
| **Unknown-label handling** | **1 Spec forces the menu + default; 2/3 pick the knob** | Menu: `error \| pass-through-as-typed-string \| warn`. **Default: pass-through** (emit `TypedValue{label,content}` with content verbatim; host/dialect-set may not know the label yet) — core preserves, never proscribes (AUTHORITY §Structural principles). A schema (**4**) may *forbid* unknown labels; core must not. |
| **Projection** of a `TypedValue` to a host type | **3 Host** | Begins where events end (Date→chrono/Time), same as today's temporal events. |
| **Whether a given value is *allowed*/required to be typed** | **4 Schema** | Proscription lives in schema, never core. |

Note: this keeps the two-kinds distinction the value-dialects brief drew —
**value dialects** (type a token, this brief) vs **interpretation dialects**
(`!dialect archema/resource`, a subtree lens, schema-exploration piece 12) —
cleanly apart. `<…>` is value-dialect surface only.

## Uncertainty ledger

- Relational-operator *values* (`:op <=`) are the one plausible future
  collision for C1. Zero in corpus, but a UDON-hosted rule/policy DSL (Ash-like
  policies already appear in examples) could want them. Mitigation: such a value
  is quoted (`:op "<="`) or the policy dialect owns `<…>`. Low but non-zero.
- The `!{:kind:}` repair is orthogonal but should ship *with* this so `<…>` and
  `!{…}` are specified as a matched pair, not two half-answers.
- Everything here is on the **default-on Option B** assumption; if Joseph picks
  Option C (opt-in), `<…>` becomes even more valuable (it's the manual override
  the opt-in world needs) but the migration math changes (per brief).

## Concrete next action

1. Joseph ratifies: **C1 `<…>` yes/no**; label-namespace **Fork 1 (lean B)**;
   descent-unify **Fork 2 (lean parallel-for-now)**; and confirms the
   **implicit-recognizer eviction of shorthand durations** (this is the
   decision-2 coupling).
2. On yes, in order: (i) one-page spec section — `<…>` envelope grammar +
   `TypedValue` event + unknown-label menu/default; pair it with the
   `!{:kind:}`-in-value repair; (ii) values.desc: add the first-byte `<`
   envelope-scan state (localized; does not touch scalar/temporal states);
   (iii) recast TIME-SPEC per *Revised decision 2*; (iv) AUTHORITY.md behavior
   table gains the four rows above in the same commit (maintenance rule).
3. No live-document migration. Descent grammar (`.desc`) migration, if Fork 2
   ever flips to "unify," rides the next generator regeneration — not this
   decision.

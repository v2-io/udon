# TODO — EOF handling: positional / delimited

> **This file is the single design of record for how UDON handles end of
> input.** It supersedes `../design/eof-model-proposal-2026-07.md` (historical
> exploration — its aggregate-event and residual-buffer vehicles are rejected
> below; keep only for archaeology). Where any other file in the repo describes
> EOF differently, this file wins.
>
> **Status (2026-07-18):** framing settled with Joseph in conversation
> (2026-07-17); doc rewritten to this positional/delimited form. Not yet in CORE
> text, the grammar, or descent. This is the whole picture an implementer needs
> to move; the mechanics live in the lane trackers
> (`../core/TODO-CORE-PARSING.md`, `../tools/descent/TODO-DESCENT.md`).

## Short form

> Every UDON construct closes in exactly one of two ways. **Positional**
> constructs close on *geometry* — end of line, dedent, or EOF (EOF is just "a
> newline followed by a maximal dedent"). **Delimited** constructs close when the
> parser scans for and finds a printed *end-sequence* it was waiting for (`"`,
> `]`, `}`, `}}`, `` ``` ``, `>`). At end of input every open frame closes
> innermost-first: positional frames close silently (an ordinary end); a
> still-open **delimited** frame is the *only* thing that makes EOF "unexpected"
> — it keeps its content-so-far, emits an `Unclosed*` anomaly citing where it
> **opened**, and flushes its End. Nothing is ever discarded. That is the whole
> model.

## Why this was ever confusing (read once)

The distinction is old and boring — it is **lexical vs syntactic vs semantic**:

- **Delimited** ≈ the matched-delimiter layer (the classic reason a parser needs
  a stack). Roughly lexical/scanner.
- **Positional** ≈ the structural / indentation layer. Syntactic.
- **"needs a value" / "needs 3 children" / schema constraints** ≈ semantic — a
  *different layer entirely*, and **not part of this mechanism**.

Normal languages keep these in separate passes (Python's lexer even emits
synthetic `INDENT`/`DEDENT` tokens so its parser never sees raw indentation).
UDON *cannot* separate them: a byte's meaning depends on live parse state —
`head position`, the content-base, whether prose has begun — so indentation and
marker-recognition can't be a preprocessing pass. Everything was therefore fused
into one byte-level recursive-descent grammar (descent). **The fusion did not
merge the layers; it erased their labels.** A semantic check
(`MissingAttributeValue`) ended up in the same list of `|eof` arms as a lexical
check (`UnclosedStringValue`), so they *looked* like one kind of thing — and
agents kept inventing unified theories ("obligations," aggregate EOF events) to
explain a mess that was only ever missing labels. **This refactor is
layer-recovery:** recover the erased distinction as a classification over the
grammar's functions, and keep semantics firmly out.

## The governing principle (litmus test)

**This mechanism is allowed to know only about characters and cursor geometry.**
If a decision needs to know anything else — was a value supplied? are there three
children? does it match the schema? — it is *not* part of this mechanism.

- Unclosed `]`: needs only "did `]` arrive before EOF/newline?" → characters +
  geometry → **in** (delimited).
- `MissingAttributeValue`: needs "was a value supplied?" → semantic content →
  **out**. The attribute+value pair is **positional**; it closes on geometry and
  runs its own local check *at that close*. The check rides on the close; it is
  not the closing mechanism.
- Cardinality / schema / dialect: same species, one layer up — the consumer
  checks when it receives the clean close event and raises its own error. →
  **out**.

If you find yourself wanting this mechanism to track "obligations" or
"expectations" richer than *a specific character before a specific geometric
boundary*, you are re-erasing the layer line. Stop. There will be all sorts of
other errors in UDON; they are not this mechanism's job.

## The cut

| | **Positional** | **Delimited** |
|--|----------------|---------------|
| **Closes on** | geometry — end of line, dedent, EOF | a printed end-sequence the parser scans for |
| **Examples** | elements, directives, line comments, prose/text blocks, deferred attribute bodies, bare-token finish | `"…"` `'…'`, `[…]`, `\|{…}`, `;{…}`, `!{{…}}`, `` ``` `` freeform, `<…>`, identity `[…]` |
| **EOF is** | an ordinary end (≡ newline + maximal dedent) — close silently | **unexpected iff still open** — keep content + `Unclosed*` (entry-site span) + End |
| **Anomaly at EOF** | none by itself | that construct's code — Error, or **Warning** for `<…>` and freeform |

**Line-bound delimited** (`[…]`, `<…>`, identity `[…]`): a delimited construct
whose scan is *also* cut short by a newline. The newline there is **not** a hard
end — it is the same *soft failure* as EOF (the closer never came), producing the
same `Unclosed*`. So for these, **newline ≡ EOF**. (Whether `[…]` is line-bound
or may span lines is a live UX choice — one flag on that one construct, not a
philosophy. See Open work.)

The symmetry worth holding: **for positional constructs EOF is an instance of
newline+dedent; for line-bound delimited constructs newline is an instance of
EOF.** Each borrows the other's terminator — which is how the ~89 hand `|eof`
arms *and* the scattered `\n → unclosed` arms both collapse into "which kind is
this, and (if delimited) is newline also a boundary."

## Position vs the existing spec

CORE's current "End of input" section already produces the *right outcomes* — it
just presents them as a table of per-construct special cases instead of deriving
them from the one cut. The rewrite: collapse that table into "each construct is
positional or delimited" + the one rule; keep every outcome and anomaly code;
keep *"a missing final newline is never, by itself, an anomaly"* (that is exactly
EOF ≡ newline for positional). One row is **added**: unclosed identity `[…]` at
EOF (delimited; currently silent and absent from the table).

**Where this contradicts current 0.9 spec text, change the spec.** The pre-1.0
text is not precedent. The only bar for keeping a current behavior is a
*user-facing* reason the general model would not already serve — *"the spec
already says X for this case"* is **not** such a reason. Worked examples of the
bar:

- Unclosed `<…>` staying a **Warning** *survives* the bar: it degrades to the
  same string a dialect-less `<…>` already produces under `NoDialectsLoaded`, so
  erroring would be the inconsistency.
- The freeform-vs-quote severity split does **not** obviously survive it (a
  forgotten `` ``` `` can swallow the rest of the file into the fence, yet is a
  Warning; an unclosed quote swallows nothing more at EOF, yet is an Error). If
  severity varies at all, re-derive it on a real axis — blast-radius /
  recovery-ambiguity — or make the delimited class uniform. Do not inherit
  today's split as if it encoded a decision.

## Things that look like they matter but do not

- **"Delimited frames unwind before positional ones."** Tempting, and *mostly*
  true — but **do not build on it; it may be false.** The likely counterexample
  is already on the table: a multi-line `[…]` (delimited) containing an element
  (positional) puts a positional frame *inside* a delimited one. It does not
  matter, because (a) each frame's anomaly cites its **own** entry site —
  self-locating, order-independent — and (b) well-nested event emission (inner
  End before outer End) falls out of innermost-first stack unwind regardless of
  kinds. So **no structural invariant about kind-nesting is load-bearing** — do
  not prove one, do not depend on one.
- **Cascades are correct, not a bug.** Nested delimited at EOF emits one
  `Unclosed*` per open frame (`[[["x`<EOF> → three). That is honest
  keep-everything. Collapsing the cascade to just the innermost (the "real"
  mistake) *for display* is a host choice, not a core one.

## Grammar / descent direction (layer-recovery, not a new flag)

Prefer **inferring** positional vs delimited from each function's *exit
structure* over an authored boolean (descent's existing "Inferred EXPECTS" sketch
is the seed). Concretely, classify the edges that **leave** a function:

- **closer-accept** — consumes a printed end-sequence, then returns.
- **geometric-accept** — returns on dedent/newline/EOF with *no* anomaly.
- **failure** — returns on a geometric end *with* an anomaly.

Then: **delimited** iff it has ≥1 closer-accept and *no* geometric-accept;
**positional** iff it has any geometric-accept. **Failure exits are generated,
not authored** — the author writes two accept-shapes; the generator synthesizes
the failure (keep content + anomaly + entry-site + End) when a geometric end
meets an unpaid closer.

Consequences:

- **Bugs become static checks.** A function with a closer-accept *and* a bare
  geometric-accept (no anomaly) is an *inconsistent machine* — precisely the
  `embedded` any-phase EOF-drop bug. The generator should reject it (or rewrite
  the stray geometric exit into a failure). "Forgot `|eof` on this phase" can no
  longer silently drop content.
- **Arrange each function as one shape or the other** (behavior-preserving): a
  *layout body* (only geometric accepts) or a *matched body* (closer-accept +
  generated failure) — not "layout until we forget `|eof`." The combinator that
  opens the span *is* the kind.
- **Record the entry site** (opener char + line:col) when a delimited frame
  opens, for the "unclosed `\|{` started at 3:4" message. It must live in
  **suspendable/frame state**, not a transient local, so it survives a chunk
  boundary in the pushdown backend (the reified stack already makes this
  natural).
- **Delete the ~89 hand `|eof` arms** once the generator emits positional
  default-end + delimited failure-unwind. Manual `|eof` remains only for true
  overrides (hopefully ~zero).

## Explicitly rejected — do not resurrect

- **Aggregate `unexpected-eof` event with a residual buffer / list of unclosed
  groups** — breaks streaming (anomaly after End), fights the 0.9 flat wire,
  makes EOF special on the wire when CORE says Ends flush like a dedent.
- **Residual buffer → unexpected-eof text payload** — destroys typing; makes "no
  trailing newline" anomalous; contradicts newline-equivalence.
- **A closer-sequence table in CORE or descent** — the grammar already owns the
  exit language; a second copy will drift.
- **"All `Unclosed*` are Warnings"** (or all Errors) — severity is per-construct
  code vocabulary; see the user-facing-reason bar above.
- **Modeling `MissingAttributeValue` / cardinality / schema as part of this
  mechanism** — semantics; out, by the litmus test.

## Open work

Suggested order: (1) static classification pass over the current grammar; (2)
arrange `embedded` (and siblings) into clean layout/matched shape — behavior-
preserving; (3) descent codegen for the default-end / failure-unwind + entry
site; (4) delete redundant `|eof` arms and re-derive the fixtures; (5) rewrite
CORE text last, once the runtime matches.

**Spec (`CORE.md` — also `TODO-SPEC-CORE.md`):**

- [ ] Rewrite "End of input" to the one rule + one composition sentence
      (innermost-first, the frame stack); collapse the per-construct table into
      kind + existing codes/severities.
- [ ] Add unclosed identity `[…]` at EOF (delimited); confirm the code name.
- [ ] One sentence distinguishing positional *context* from positional
      *construct* (see Vocabulary), embed as the teaching example.
- [ ] Decide line-bound vs multi-line `[…]` (one flag; UX call, not a second EOF
      model).

**Grammar / udon-core (also `../core/TODO-CORE-PARSING.md`):**

- [ ] Arrange `embedded` (and siblings) into clean layout/matched shape; kill the
      any-phase EOF drop (`eof_recovery::eof_unclosed_embedded_with_open_attr`).
- [ ] Fix the bare-marker-at-EOF discard (EOF ≡ newline for pending guards → a
      trailing `|` / `@` / `!` / `:` resolves as prose, not unexpected EOF).
- [ ] Record entry site on delimited enter (interim hand-wiring until descent
      provides it).
- [ ] Re-derive the composition / EOF fixtures as plain derivations (drop the ⚠
      "special-case" readings).

**Descent (also `../tools/descent/TODO-DESCENT.md`):**

- [ ] Static pass classifying each function positional/delimited from exit
      structure; list inconsistent machines.
- [ ] Generate positional default-end + delimited failure-unwind + entry-site
      recording.
- [ ] Reject (or require an explicit override for) a function that mixes a
      closer-accept and a geometric-accept.

## Vocabulary — so "positional" does not confuse

"Positional" is used three ways in the repo; only the middle one is this doc's:

- positional **context** — a recognition *locus* (block / sameline / inline /
  embedded / head). CORE "Positional Contexts."
- positional **construct** — *this doc's sense*: closes by geometry.
- positional / **ordered** — children / array *order* matters (sequence vs map).
  If it ever confuses, say "ordered."

A delimited construct still has ordinary positional rules *inside* it (embed
content is positional inside a delimited embed). No conflict: "delimited"
describes how the span *ends*, not what happens within it.

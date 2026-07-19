# TODO — EOF handling: positional / delimited

> **This file is the single design of record for how UDON handles end of
> input.** It supersedes `../design/eof-model-proposal-2026-07.md` (historical
> exploration — its aggregate-event and residual-buffer vehicles are rejected
> below; keep only for archaeology). Where any other file in the repo describes
> EOF differently, this file wins.
>
> **Status (2026-07-18): LARGELY REALIZED — now a design record, not a to-do.**
> The framing is **in CORE** (End of input / Anomaly posture / Line-boundedness /
> Emission order were rewritten to it) AND **in descent** (both backends generate
> the EOF handling from a positional/delimited classification — landed out of the
> fixtures-first order by Joseph's explicit call, merged to `main`). So the
> forward-looking prose below ("collapse that table," "add the row," "delete the
> ~89 arms") reflects the pre-landing PLAN — much of it is done: ~34 arms deleted,
> CORE already collapsed to the one rule, embed/gap-9/bare-marker bugs fixed,
> vocabulary normalized (`UnterminatedFreeform` → `UnclosedFreeform`). The
> implemented shape + residuals: [`../design/eof-descent-classification.md`](../design/eof-descent-classification.md),
> `../tools/descent/TODO-DESCENT.md`, `../core/TODO-CORE-PARSING.md`. This doc
> stays as the design record (the *why* of the layer-recovery); read those three
> for the *state*. (The **"Grammar / descent direction"** section below is what
> other trackers used to call "Addendum A.")

## Short form

> Every UDON construct closes in exactly one of two ways. **Positional**
> constructs close on *geometry* — end of line, dedent, or EOF (EOF is just "a
> newline followed by a maximal dedent"). **Delimited** constructs close when the
> parser matches the printed *end-sequence* it's waiting for (`"`,
> `]`, `}`, `}}`, `` ``` ``, `>`). At end of input every open frame closes
> innermost-first: positional frames close silently (an ordinary end); a
> still-open **delimited** frame is the *only* thing that makes EOF "unexpected"
> — it keeps its content-so-far, emits an `Unclosed*` **warning** citing where it
> **opened**, and flushes its End. Any frame still open at EOF also flips the
> parse *result* to non-success (the input was incomplete). Nothing is ever
> discarded. That is the whole model.

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
  not the closing mechanism. (Same for the **OPEN** case — `:key` awaiting its
  value on a deeper line: the body's *extent* is geometric, so it is positional;
  the "did a value arrive?" check is semantic-at-close. An unpaid value is never
  a delimiter, so an OPEN attr is never "delimited.")
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
| **Closes on** | geometry — end of line, dedent, EOF | a printed end-sequence the parser matches |
| **Examples** | elements, directives, line comments, prose/text blocks, deferred attribute bodies, bare-token finish | `"…"` `'…'`, `[…]`, `\|{…}`, `;{…}`, `!{{…}}`, `` ``` `` freeform, `<…>`, identity `[…]` |
| **EOF is** | an ordinary end (≡ newline + maximal dedent) — close silently | **unexpected iff still open** — keep content + `Unclosed*` (entry-site span) + End |
| **Anomaly at EOF** | none by itself | per-construct **Warning** (content kept), citing entry site — *and* the document result flips to non-success (see *Severity — two levels*) |

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

## Severity — two levels (ruled 2026-07-18)

Severity means one thing applied at two scopes. **Warning = content was kept;
Error = something is gone.** By that test every unclosed-delimited case is
keep-everything (the string survives as `StringValue`, the array keeps its items
+ `ArrayEnd`, the embed its content + `EmbeddedEnd`), so:

1. **Per construct: uniformly `Warning`.** As each still-open delimited frame
   unwinds at EOF it emits its `Unclosed*` **warning**, in-band, citing its entry
   site — nothing was lost by the parse. This retires the current CORE split
   (some `Unclosed*` are `Error`, `<…>`/freeform are `Warning`); that split was
   pre-refactor confusion, not a decision. The code is unchanged
   (`UnclosedStringValue`, …); only its severity normalizes to Warning.

2. **Per document: one incomplete-input result.** A delimited frame *still open
   at true EOF* means the input is not a whole document — data was lost upstream
   of us (a truncated file / cut stream) or in the author's intent (the closer
   they meant to type). So the **parse result turns non-success** (`Result::Err`
   / non-zero CLI exit): one terminal "Unexpected EOF — input incomplete."

**Scope precisely — "open at *true* EOF," not "any delimiter that failed."** A
line-bound construct that failed on a *newline* mid-document (`[1 2⏎…`) already
closed on that newline; its frame is off the stack long before EOF, the document
reaches a clean end with an empty stack, and it is a plain Warning, **zero exit**.
Only a frame on the stack when input runs out feeds the document result. The
distinction that earns its keep: *structurally complete document with a local
defect* (warning only) vs *truncated document* (warning + non-success) — the same
missing `]`, genuinely different situations, and CI wants to tell them apart.

**The document result is a *result*, not a wire event.** It carries nothing (no
residual buffer), is computed after the in-band warnings have flushed, and is the
parse's outcome — which is exactly what keeps it clear of the rejected
aggregate-`unexpected-eof` vehicle (below). Cost is one bit at the driver: after
the final unwind, is any frame on the reified stack delimited? If yes, the result
is incomplete.

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
already says X for this case"* is **not** such a reason. Severity is the worked
example: the fix was not to defend today's per-construct `Error`/`Warning` split
but to replace it with a principled two-level model — see *Severity — two levels*
above.

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
  `embedded` any-phase EOF-drop bug. The generator should **reject** it by
  default (rewriting the stray exit into a failure only under an explicit
  override) — rejecting keeps grammar-cleanup loud rather than papering over a
  function that may not want to be delimited at all. "Forgot `|eof` on this
  phase" can no longer silently drop content.
- **Inference must handle non-trivial closers** — parameterized closers
  (`quoted :q`, identity `:close`), multi-byte / path closers (`}}`, the freeform
  fence line), and closer-in-callee where the BRACKET sits on the caller (embed):
  classify at the *activation root* (opener → End), counting a callee's
  hard-return toward hard success when the callee cannot itself soft-return.
  Fuller mechanics: `../tools/descent/TODO-DESCENT.md`.
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
- **Collapsing severity to a single level** — neither "all `Unclosed*` are
  Errors" nor one blanket Warning with no document signal. The ruling is *two*
  levels: per-construct **Warning** (content kept) + a document-level
  incomplete-input **result** (non-zero exit). See *Severity — two levels*.
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
      kind + codes.
- [ ] Fold in the two-level severity ruling (see *Severity — two levels*):
      relabel every per-construct `Unclosed*` to **Warning**, and add the
      document-level incomplete-input **result** (non-zero exit) fired iff a
      delimited frame is open at true EOF. Also reconcile CORE's "Anomaly
      posture" ladder, which today calls unclosed constructs an "error event"
      while insisting they keep everything — the two-level split says which half
      is which (content kept = warning; structure incomplete = the result).
- [ ] Add unclosed identity `[…]` at EOF (delimited); confirm the code name — a
      **new** anomaly surface for consumers (nothing errored there before), so
      fixture it when it lands.
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

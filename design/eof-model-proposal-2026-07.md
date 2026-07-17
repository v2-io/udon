# EOF as a generated concern — a proposal to descent, motivated by udon

> **Status: proposal, not ratified.** Joseph's idea (2026-07-16), developed
> with Claude in the same session; recorded here so it survives the
> conversation. It touches neither `spec/CORE.md` nor the grammar. It wants
> Joseph's ruling on the model, and then descent's owner on the mechanism.
> Register: the collaboration's — reasoning included, so nobody re-derives it.

## Why this came up

Two fixtures went RED on 2026-07-16 during the v0.9 densification pass, and
they turned out to share one cause:

- `dynamics_syntax::flag_then_raw_block_is_child` — the sameline-scan `!`
  guard is implemented in `30-udon.values.descent.udon`'s value-boundary
  states but not in `10-udon.elements.descent.udon`'s `:check_sameline_bang`.
- `eof_recovery::eof_unclosed_embedded_with_open_attr` — `UnclosedEmbedded`
  fires from `60-udon.embedded.descent.udon`'s `embed_content:main` `|eof`
  arm, the **only** `|eof` arm in that unit. The `embedded` function's own
  `:post_identity` / `:pre_content` / `:check_attr` states have none, so an
  EOF reached in the identity/attribute phase returns silently. Probe:
  `|p |{a :href x` — a complete, ordinary attribute — closes with **zero
  anomaly**, exactly as if it had seen its `}`.

Both are holes in hand-written per-state coverage. Joseph, on reading the
second: *"I've always felt EOF handling in the descent grammar was one of
its weakest areas."*

The measurement backs that up. In the ten active grammar units:

| | count |
|---|---|
| `|eof` arms total | **90** |
| …that emit an anomaly | **10** |
| …that are pure boilerplate (`TERM \| Event(USE_MARK) \| return`) | **80** |

Eighty repetitions of one sentence (30 in values, 25 in prose, 16 in
attributes), and the bugs live precisely in the states where someone did
not repeat it. This is uniformity-by-discipline where uniformity-by-
construction is available.

## The model

Joseph's framing, verbatim (2026-07-16): at EOF there are two things to
account for —

- **what remains in the buffer undifferentiated**
- **the expectations that remain unmet from stuff that has opened**

They are orthogonal, and each of today's bugs proves the other is needed:

| | fact | today's example | what handles it |
|---|---|---|---|
| (a) | a capture is open; bytes are held and unemitted | `\|p some \|{em abc` — `abc` pending | a **remainder** event (`Rest` / `UnexpectedRemainder`) carrying the bytes + span |
| (b) | a construct opened and its delimiter never came — *even if its capture resolved cleanly* | `\|p \|{a :href x` — buffer empty, `}` missing | an anomaly **per unwinding frame that was awaiting a delimiter** |

The first half alone was the initial sketch ("if there isn't anything
undifferentiated queued up… we're golden?"). It cannot be the whole rule:
`|p |{a :href x` and `|el[unclosed` both have empty buffers and both are
unclosed — under (a)-only, the very bug that prompted this would be
*blessed as clean*.

### The event shape (Joseph, 2026-07-16 — the refinement)

```
[unexpected-eof]
   - [undifferentiated in buffer]
   - [unclosed-groups]   (each with the exact location where the group BEGAN)
```

*"Seems like everything the subsequent stages could want."* It does — and
it is better than the per-frame-anomaly sketch it replaces, for a reason
worth naming: **the group list dissolves the composition question
entirely.** The four ⚠ readings the densification pass had to invent
(`|p |{a x |{b y`, `|el :xs [1 [2`, `|el :xs ["a`, `|p |{a :href`) were all
artifacts of trying to express a *set* of unmet expectations as a
*sequence* of anomalies. As a list, there is no ordering to rule, no
innermost-first sentence to write, and nothing for a grammar to get wrong.
The `spec/TODO-SPEC-CORE.md` composition silence doesn't get answered; it
stops existing.

The start-location half is the actionable one: the message a human or agent
needs is never "something broke at EOF" but *"you opened `|{` at 3:12 and
never closed it."* EOF is where it was noticed; the group's opening is where
it gets fixed. (Native form note: the parser's currency is **spans** — every
event carries one, and `span.rs` is wired — so the group list naturally
carries opening *spans*, with line/column being the host's rendering of
them. Same information, one less thing for the core to track.)

**Clean-EOF test, refined:** no event iff the buffer holds nothing
undifferentiated **and** no groups are open. `|p |{a :href x` fails the
second condition with an empty buffer — which is exactly the bug this
model needs to catch, and does.

## What it buys

1. **The bug class disappears.** No state can forget an `|eof` arm, because
   states no longer carry them.
2. **The composition question stops existing** (see the event shape above):
   a set of unmet expectations is expressed as a *set*. No ordering rule,
   nothing for a grammar to get wrong, four ⚠ fixtures become plain.
3. **CORE's "End of input" table collapses** from seven behavior rows to
   one event plus a definition of *group* (delimiter-scoped construct).
   The `Unclosed*` code vocabulary is no longer hand-curated in a table the
   grammar must match by discipline — the group *kind* is carried in the
   list, and that is how the table and the grammar drifted apart in the
   first place.
4. **~80 lines leave the grammar**, and the units get easier to read: the
   value scanner's ~15 number states stop repeating four terminator rows
   *plus* an eof row.
5. **It fits the ratified posture unchanged.** "Errors are events in the
   stream; drop/halt/reject is AST-/app-layer configuration"
   (CORE, Anomaly posture). This proposal changes *who generates* the
   events, not what they mean or who decides about them.

## What descent would need to know

The one new fact per construct: **delimiter-scoped or scope-scoped?** CORE
already draws exactly this line, in ratified text:

> "A construct whose content is already coherent closes *silently*; a
> construct still awaiting a **delimiter** closes with its captured content
> emitted plus an `Unclosed*` anomaly."

So elements/directives/comments (indentation-scoped) unwind silently;
quoted strings, arrays, embeds, inline comments, interpolations, envelopes
(delimiter-scoped) report. Descent is already halfway there — the BRACKET
type declaration and the `:close` / `:bracket` param convention encode
closers informally. The natural shape is to lift the closer into the type
declaration so the generator can synthesize both halves.

## Open questions (genuinely open — not rhetorical)

- **Where does the event sit relative to the flushed `End`s?** The
  universal implicit closer (ratified) flushes every pending `End`,
  innermost-first. The single-event shape wants the *complete* group list,
  which — in the recursive backend, whose stack is Rust's and cannot be
  introspected — can only be assembled *as each frame returns*. That
  implies the event fires **after** the unwind, at the outermost frame: a
  closing summary. Consequence: the undifferentiated bytes arrive after the
  `End`s of the constructs they came from, so a consumer places them by
  **span**, not by stream position. That is fine (every event carries a
  span) but it is a real change in how a consumer reads the tail of a
  stream, and it should be a conscious choice rather than a side effect of
  the mechanism. The alternative — remainder emitted in place, group-list
  summary at the end — costs a second event and buys positional placement.
  The pushdown backend could do either (its stack is reified); the
  recursive one constrains the design, so pick for both.
- **Does the Warning/Error split survive?** Today's table is not uniform on
  purpose: an unterminated **freeform fence** is a *Warning* ("the body is
  coherent; the author likely forgot the closer") and an unclosed `<…>`
  envelope is a *Warning* (string pass-through), while unclosed
  string/array/embed/comment/interpolation are *Errors*. One
  `[unexpected-eof]` event collapses that: severity becomes either a
  per-group field, or — more consistent with the ratified anomaly posture
  ("drop/halt/reject is AST-/app-layer configuration") — **derived by the
  consumer from the group kind**. The second reading is cleaner and matches
  "make it the AST parser's and the application coder's problem," but it
  does move a judgment that CORE currently makes. Worth ruling explicitly.
- **What is a "group"?** The list carries delimiter-scoped constructs only;
  indentation-scoped ones (elements, directives, comments, deferred
  attribute values) close silently and coherently, and must *not* appear —
  otherwise every document ends with a list of its own open elements. CORE
  already draws this line in prose; the proposal turns it into a per-type
  property the generator reads.
- **Non-bracket captures have no `Start` event.** A remainder inside a
  quoted string inside an array (`|el :xs ["a`) is positionally ambiguous
  to a consumer: it can see the `ArrayStart` but nothing marks that a quote
  opened. The group list resolves it — the quote is *in the list*, with its
  opening span — which is another argument for the single-event shape:
  the list is the only place the full open-set is expressible.
- **Newline-unclosed vs EOF-unclosed.** They currently differ on the wire
  (`arrays.yaml::array_unclosed_is_error` omits `ArrayEnd`;
  `eof_recovery::eof_unclosed_array` flushes it — both green), and CORE has
  no row for the newline case at all (tracked in
  `core/TODO-CORE-PARSING.md`). If EOF handling becomes generated, the
  newline case is the obvious next question: same mechanism with a
  different terminator, or genuinely different?
- **Cost.** Every construct gaining a generated eof path is a code-size and
  possibly dispatch change in both backends. The house discipline applies:
  criterion before/after pair on the descent bump (`core/CLAUDE.md`).

## If it lands

Route: descent feature request (`tools/descent/TODO-DESCENT.md` — its
current open list is state templates, the `st` frame-field validator, and
state-line `MARK`, and this is adjacent to all three) with the udon-side
payoff recorded here. The udon-side follow-through: delete the 80 boilerplate
arms, keep whatever per-construct exceptions survive, re-derive the EOF
fixtures against the generated behavior, and close the composition silence
in `spec/TODO-SPEC-CORE.md` with the sentence the mechanism now guarantees.

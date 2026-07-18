# EOF as a generated concern — a proposal to descent, motivated by udon

> **Status: historical exploration (2026-07-16) — superseded as design of
> record by [`../spec/TODO-EOF-refactor.md`](../spec/TODO-EOF-refactor.md)
> (2026-07-17).** Probe facts and bug measurements below remain useful;
> the aggregate-event vehicle, residual-buffer-as-anomaly, and "two facts"
> framing are **not** what to implement. The settled model:
> **positional** vs **delimited** constructs; unexpected EOF only for
> still-open delimited activations; grammar owns closers; entry site for
> diagnostics.
>
> **Original status note (kept for archaeology):** proposal, not ratified —
> Joseph's idea (2026-07-16), developed with Claude, then reviewed by two
> agents independently. **Every factual claim below is probe-verified**; an
> earlier draft carried two that were not, and both were false (see
> *Corrections*).
>
> **Scoping ruling (Joseph, 2026-07-16): the model waits for the dialect
> boundary; the bugs do not.** His words: *"I don't think we can answer the
> EOF question completely in 0.9 because I highly suspect we will be
> turning over parsing of embedded/inline stuff to dialects."* This is
> exactly right, and it bites on the load-bearing part: **the group
> vocabulary is what depends on the dialect boundary.** Of the seven
> delimiter-scoped constructs in CORE's EOF table, at least three are
> already dialect-bound or dialect-candidates — interpolation (DYNAMICS
> owns the expression), `<…>` envelopes (dialects *are* the envelope's
> point), and `|{…}` embedded, which CORE already hedges twice (the
> framed-`;`-in-embeds note defers "once the dialect layer and embedded
> behavior are more fully fleshed out"; the inline-raw nailing defers
> "until dialects/templating settle"). Deeper still: if a dialect owns the
> *inside* of `|{…}`, "unclosed" splits — core knows the `|{` opened and no
> `}` came (boundary brace-counting), but only the dialect knows whether
> the content was *coherent*, which is the fact-(b) property itself. A
> per-construct property cannot be finalized while its construct list is
> being renegotiated.
>
> **What that frees for 0.9:** both bugs below are fixable from
> **already-ratified text**, with no model decision and no new spec —
> the bare-marker drop by *"EOF is newline-equivalent everywhere a rule
> says 'followed by a newline'"* + *"nothing is ever discarded at EOF"*
> (`|` + `\n` → `Text "|"`, therefore `|` + EOF → `Text "|"`), and the
> `UnclosedEmbedded` drop by the EOF table's embed row, which is already
> unconditional. Fix the data loss on ratified ground; defer the model to
> where it can be answered once instead of twice.

## Why this came up

`eof_recovery::eof_unclosed_embedded_with_open_attr` went RED during the
2026-07-16 densification pass. `|p |{a :href x` — an embed with a
complete, perfectly ordinary attribute, missing its `}` — parses
**byte-identically to `|p |{a :href x}`**. Forgetting the closer is
perfectly silent. The anomaly lives in exactly one place:
`60-udon.embedded.descent.udon`'s `embed_content:main` `|eof` arm — the
only `|eof` arm in that unit. The `embedded` function's own
`:post_identity` / `:pre_content` / `:check_attr` states have none, so an
EOF reached in the identity/attribute phase returns silently while
`EmbeddedEnd` still fires from the BRACKET type.

Then the review found the same shape, worse and wider — **a bare marker as
the final byte of input is silently discarded**:

| input | at EOF | with a trailing `\n` |
|---|---|---|
| `\|` | **0 events** | `Text "\|"` |
| `@` | **0 events** | `Text "@"` |
| `!` | **0 events** | `Text "!"` |
| `:` | **0 events** | `Text ":"` |
| `!{` | **0 events** | `DirectiveStart`/`End` |

Add any byte after the marker (`|1`, `@ x`, `:-)`) and it parses fine — so
the trigger is precisely **a guard left pending at EOF**. This violates two
ratified sentences simultaneously: *"Nothing is ever discarded at EOF"* and
*"a missing final newline is never, by itself, an anomaly (EOF is
newline-equivalent everywhere a rule says 'followed by a newline')."*

Joseph, on the first bug: *"I've always felt EOF handling in the descent
grammar was one of its weakest areas."* The construction is the complaint —
EOF is hand-written per state, and the bugs live where someone forgot to
write it. But the honest counterweight, probe-verified by the fresh review:
**7 of CORE's 8 EOF rows behave correctly today** (string, array,
embedded-content, interpolation, envelope, freeform, silent-close). As a
claim about *behavior*, "weakest area" overstates; as a claim about
*construction*, it holds.

## The measurement (corrected)

In the ten active grammar units: **89 `|eof` arms**, composed as —

| kind | count | note |
|---|---|---|
| emit content and return | ~51 | the "boilerplate" — but see below |
| carry an anomaly | **12** | the delimiter-scoped constructs |
| **emit nothing** | **16** | ***these are the bare-marker bug sites*** |
| pure transitions (`>> :finish`, `>> :tok_kw`, …) | 5 | control flow, not emission |
| carry `result = BLOB` bookkeeping the caller needs | 5 | |

The content-emitting arms are **uniform in shape but not in type** — they
span **12 distinct constructors** (Text, BareValue, Integer, Float,
StringValue, Reference, Interpolation, RawContent, BoolTrue, Attr,
KEYWORDS, Nil). "One sentence retyped 80 times" was the wrong reading: the
*variable is the type decision itself*, and that decision is what
keep-everything depends on. A generator can synthesize it — it knows what
each state captures — but the wrong fix (one generic remainder event)
would **destroy the typing**. Realistically removable: **~55–60 arms**,
with the transition and BLOB arms needing explicit exceptions.

## The model: two facts at EOF

Joseph's framing, verbatim: at EOF there are two things to account for —
**what remains in the buffer undifferentiated**, and **the expectations
that remain unmet from stuff that has opened**. They are orthogonal, and
each of today's bugs proves the other is needed:

| | fact | today's bug | resolution |
|---|---|---|---|
| (a) | a **guard** is pending — bytes consumed, no decision reached | `\|` at EOF → 0 events | **resolve the guard as if at a newline** → ordinary typed events (`Text "\|"`), *no anomaly* |
| (b) | a construct opened and its delimiter never came — *even if its capture resolved cleanly* | `\|p \|{a :href x` ≡ `\|p \|{a :href x}` | per-frame anomaly at unwind, carrying the **opening span** |

**Fact (a) needs generation, not an event.** Both reviews converged here,
by different routes. Newline-equivalence is *already ratified*: `|` + `\n`
→ `Text "|"`, so `|` + EOF must also be `Text "|"` — ordinary prose. If
(a) surfaced as a `Rest` blob under an anomaly umbrella, then **a normal
document that merely lacks a trailing newline becomes anomalous** —
contradicting the very sentence that makes the fix obvious. Every
constructible (a) case resolves into one of two places: ordinary prose
(`|` → `Text`), or a group that opened and now needs a fact-(b) anomaly
(`|{` → `EmbeddedStart` + `UnclosedEmbedded`).

## The event shape: superseded

Joseph's sketch (2026-07-16) was an aggregate:

```
[unexpected-eof]
   - [undifferentiated in buffer]
   - [unclosed-groups]   (each with the location where the group BEGAN)
```

The **start-location insight in it is correct and independently valuable** —
today every anomaly spans the EOF point, not the opener, and no fixture
caught that. The message a human or agent needs is never "something broke
at EOF" but *"you opened `|{` at 3:12 and never closed it."*

The aggregate *vehicle*, however, does not survive review. Both reviewers
rejected it independently, on four grounds:

1. **It breaks the streaming invariant.** Today `Error UnclosedEmbedded`
   arrives *before* `EmbeddedEnd` — an AST builder sees it with the node
   still on its stack. A closing summary means every consumer commits and
   flushes the node, *then* learns it was unclosed, and must retro-patch by
   span into an already-closed subtree. That is not "place by span"; it
   inverts the natural build order for every consumer, against CORE's
   "Streamable, incremental parsing."
2. **It contradicts the flat wire ratified hours earlier.** 0.9: *"The wire
   stays flat… all multiplicity is expressed by re-emitting the `Attr`…
   No new event types."* A nested group list cuts directly against the
   principle the attribute model just landed on — and serialized as
   repetition, the entries' order becomes the same question, relocated
   inside the event.
3. **It makes EOF special at the wire** in the name of making it uniform in
   the grammar — while CORE's ratified sentence is that EOF is *not*
   special: pending `End`s flush "exactly as a full dedent would fire them."
4. **The recursive-backend argument cuts the opposite way from how the
   first draft used it.** Each frame knows *its own* group without
   introspecting anything, so **per-frame anomalies are the trivially
   generable thing**; it is the complete-list summary that the recursive
   stack makes hard. In-place is the cheap option, not the expensive one.

**Better vehicle for the same insight: widen the anomaly's span to
`opener..EOF`.** Zero wire change, keeps the streaming invariant, works
identically in both backends, and answers the "non-bracket captures have no
`Start` event" problem outright — the span *is* the opener's location.

## What the proposal becomes

- **(a)** EOF joins every state's **terminator class**, so a pending guard
  resolves exactly as it would at a newline. `:kw_boundary` already writes
  `|eof`, `'\n'`, `:bracket`, `<';`' BS>` as four arms with *identical
  bodies* — it already treats them as one class; it just says so four
  times. Descent is half-there already: its README documents *"Inferred
  EOF: default behavior derived from context"* — **the 89 arms are
  overrides of an inference that already exists**, keyed on function return
  type rather than terminator class. This deletes more than the original
  claim (the redundant terminator rows *plus* the eof row) and makes fact
  (a) definitionally impossible.
- **(b)** *"awaiting a delimiter"* becomes a per-construct property; the
  generator synthesizes the unwind. Innermost-first falls out of recursion
  for free, both backends identical, and `|p |{a :href x` is fixed
  *regardless of which state EOF lands in* — the bug killed at the root
  rather than patched per state.
- **The `Unclosed*` codes and their severities stay in CORE.** (See
  *Corrections*.)

## Corrections to the first draft (all probe-verified)

1. **"Two REDs share one cause: EOF" — false, and it was the load-bearing
   premise.** `dynamics_syntax::flag_then_raw_block_is_child` is **not an
   EOF bug**: its input is `"|el :go? !:sh:\n  echo hi\n"` — trailing
   newline, and it fails identically with a whole element after it. Its
   cause is state coverage: `10-udon.elements…:check_sameline_bang`
   dispatches only on `'{'` while its twin `30-udon.values…:kwb_bang`
   dispatches on `<XLBL_START ':' '{'>`. Two hand-written copies of "what
   may follow `!`", one incomplete. **Generated EOF would not touch it.**
   The motivating evidence is *one* EOF bug (plus the bare-marker family),
   not two — and the false pairing is what aimed the generalization at EOF
   rather than at **state coverage**, where both bugs actually live.
2. **"Newline-unclosed and EOF-unclosed differ on the wire" — false.**
   Both emit `Error UnclosedArray` + `ArrayEnd`, identically. The first
   draft relayed a prior author's in-fixture comment that nobody probed.
   The real question hiding there is different: `array_unclosed_is_error`
   presumes arrays are **single-line**, an un-ruled silence (only envelopes
   are stated single-line) — routed to `spec/TODO-SPEC-CORE.md`.
3. **"CORE's table collapses to one row plus a definition of *group*" —
   overstated.** If severity is consumer-derived from group kind, CORE must
   still enumerate the kinds *and* their severities somewhere, or hosts
   diverge: the table moves into a payload vocabulary, it does not vanish —
   and moving it out of CORE into the generator cuts against the house rule
   that CORE is the sole authority.
4. **"Severity should become consumer-derived" — probably wrong.** The
   posture says the app decides the *reaction* (drop/halt/reject) while
   *"the core fixes the code vocabulary."* The Warning/Error split **is**
   the ladder's (a)-vs-not-(a) distinction — a fence warns *because its
   body is coherent*. That is a core judgment, not host verbosity. Noted
   honestly: the split is *also* not clean today (a fence body is a Warning
   for being coherent, but `["a`'s `"a"` is equally coherent and is an
   Error), so ruling it consumer-derived would **export an incoherence**
   rather than resolve it. Settle the principle first.

## Open questions (genuinely open)

- **Is the real generalization *coverage*, not EOF?** The fresh review's
  sharpest point: `TODO-CORE-PARSING.md`'s **generator-verified
  determinism** item is aimed at transition *overlap*; its dual is
  transition *coverage* — which catches **both** of today's REDs, where EOF
  work catches one. Read uncharitably, this proposal is that feature
  rediscovered through an EOF-shaped keyhole and generalized along the
  keyhole's axis rather than the bug's. The two are not exclusive; the
  question is which is the root and which is the instance.
- **What is a "group"?** The property must cover delimiter-scoped
  constructs only; indentation-scoped ones (elements, directives, comments,
  deferred attribute values) close silently and coherently — otherwise
  every document ends by reporting its own open elements. CORE draws this
  line in prose already.
- **Cost.** Both backends gaining generated eof paths is a code-size and
  possibly dispatch change. House discipline applies: criterion
  before/after pair on the descent bump (`core/CLAUDE.md`).

## Two adjacent findings from the reviews (bugs either way)

- **The envelope emits its anomaly *before* its value**, unlike every other
  row — a hand-divergence datum that argues for generation more honestly
  than either RED does.
- **Nested embeds emit an empty `Text{content:[]}`.**

## If it lands

Route: descent feature request (`tools/descent/TODO-DESCENT.md` — adjacent
to its open state-templates and `st`-validator items) with the udon-side
payoff recorded here. Udon-side follow-through: delete the boilerplate arms
that survive the exceptions, re-derive the EOF fixtures against generated
behavior, fixture the bare-marker family (deliberately unfixtured today —
they would be inventing spec before the ruling), and add the RED that
`|p |{a :href x` ≡ `|p |{a :href x}` deserves.

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

## What it buys

1. **The bug class disappears.** No state can forget an `|eof` arm, because
   states no longer carry them.
2. **Composition falls out of the mechanism.** The v0.9 densification had to
   *choose* a reading four times (`|p |{a x |{b y`, `|el :xs [1 [2`,
   `|el :xs ["a`, `|p |{a :href`) — CORE's "End of input" table is
   per-construct and silent on several-open-at-once (tracked in
   `spec/TODO-SPEC-CORE.md`). A generated unwind is innermost-first *by
   construction*, so the proposed spec sentence — "when several constructs
   are open, each closes innermost-first, and each awaiting a delimiter
   carries its own anomaly" — becomes a **description of what the generator
   does** rather than a rule the grammar must remember to obey.
3. **The `Unclosed*` vocabulary becomes derived** from frame identity
   instead of a hand-curated table that the grammar matches by discipline —
   which is how the table and the grammar drifted apart in the first place.
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

- **Non-bracket captures have no `Start` event.** A remainder inside a
  quoted string inside an array (`|el :xs ["a`) is positionally ambiguous
  to a consumer: it can see the `ArrayStart` but nothing marks that a quote
  opened. The frame-identity half of (b) resolves this — but it means the
  anomaly, not the remainder, carries the "what was open" information.
  Worth confirming that's the right division.
- **Both backends.** The pushdown machine has a reified stack (cf. the
  agent-facing-diagnostics item in `core/TODO-CORE-PARSING.md`), but the
  recursive backend's stack is Rust's. This should be fine — the eof paths
  are *generated into each function* either way, so neither backend needs
  runtime introspection. Verify before relying on it.
- **Does the remainder event replace the content event, or precede it?**
  Today `|p some |{em abc` emits `Text "abc"` + `Error UnclosedEmbedded`.
  Under the proposal, is it `Rest "abc"` (the remainder *is* the content,
  undifferentiated) or `Text "abc"` + remainder-marker? The first is
  simpler and matches "undifferentiated"; the second preserves what the
  parser actually knew. Joseph's phrasing ("undifferentiated / not emitted
  as event yet") leans toward the first.
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

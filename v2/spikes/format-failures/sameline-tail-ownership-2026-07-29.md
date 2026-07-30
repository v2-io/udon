# Sameline tail ownership — cross-check against Joseph's 2026-07-29 gloss

**Question asked:** when an element-rooted line ends in trailing prose after
an attribute, who owns it — the attribute or the element? Joseph's stated
rule and three examples:

```udon
|el :a this is all value for a
|el :a "this" now this is child of |el
|el :a this \ this is also all child of |el
```

**Finding, stated up front:** no deviation found. Both ruled-text locations
say what Joseph says, and one already-written secondary (`v2/theory/CLAUDE.md`)
already states the rule correctly and quotes his exact 2026-07-29 gloss. I
could not reproduce the "broken 0.8 grammar" hypothesis as the source of any
live confusion — there is no live confusion in the ruled text to explain.
Register: everything below marked **[primary]** was read directly at the
cited line this session; nothing here is recalled from an earlier pass.

## 1. What each artifact says

### `spec/CORE.md` (the 0.9 line) — **[primary]**, "Whose Text Is This? (Ownership)", lines 506–530

```
| Priority | Condition                                            | Owner                              |
| 1        | An attribute to the left still needs a value, or is collecting | That attribute's value  |
| 2        | Else: nearest element on the same line to the left  | Child text of that element (tail)  |
| 3        | Else                                                 | Ordinary column ownership          |
```

Worked example, verbatim (lines 520–526):

```udon
|el :first value :another with some text
; first = "value"; another = "with some text"        (row 1 -- open attr)

|el :first value :another "with" some text
; first = "value"; another = "with"; el prose "some text"   (row 2 -- value done)
```

### `v2/current-0.9.1-spec/CORE.md` — **[primary]**, §6.5 "Ownership of flow values", lines 327–344

Same table, same two rows, same worked example (lines 339–344), byte-for-byte
matching content (light rewording only — "flow value" replaces "text blob" as
the vocabulary tightened between the two suites, but the rule is identical):

```udon
|el :first value :another with some text
; first="value"; another=flow "with some text"          (row 1)
|el :first value :another "with" some text
; first="value"; another="with"; el tail "some text"    (row 2)
```

### Mapping Joseph's three examples onto §6.5 directly

1. `|el :a this is all value for a` — `this` is a bare token; `:a` has not
   finished (no self-terminating shape recognized), so it opens a **flow
   value** that runs to end of line (§6.4's bare-token-boundary rule, "plain
   text … commits a flow value … running to end of line"). Ownership row 1
   applies throughout: `a` is still open, so it absorbs the whole tail.
   Matches Joseph's annotation exactly.

2. `|el :a "this" now this is child of |el` — `"this"` is a quoted string, a
   self-terminating shape (§6.4: `"`/`'` → string, self-terminates). `a`
   finishes immediately with value `"this"`. Per the Collecting paragraph
   (§6.5, quoted below), an element-rooted line's attribute **never collects
   past its finished value** — so the rest of the line falls to ownership
   row 2, the element's tail. Matches.

3. `|el :a this \ this is also all child of |el` — `this` is a bare token
   followed by a space then `\`. `\` is one of the **guard-confirmed
   block-form markers** that end a bare token as a single-token value
   (§6.4, line 304: "`:` opening a key, `\`, a fence, block-form `|`/`@`/`!`
   … — the token stood alone: a single-token value, exactly as if quoted").
   So `a` finishes with value `"this"` (same as case 2 in effect), and the
   scan continues to the `\`. §6.5's "Value-position `\`" paragraph covers
   this explicitly: *"A `\` at a finished value's boundary is the ordinary
   boundary escape — the rest of the line is text, owned by the rows above;
   the `\` sets the text's mode, never its owner."* Owned by the rows above
   with `a` already finished → row 2 → the element. Matches.

All three of Joseph's examples check out against the ruled text as currently
written, in both spec locations, with no gap.

## 2. The two things the brief asked me to settle

### 2a. Does the "Collecting" paragraph's block/element asymmetry actually agree with the worked examples beneath it?

`v2/current-0.9.1-spec/CORE.md` lines 337 (**[primary]**), verbatim:

> **Collecting:** on a **block attribute line** (rooted by `:key`, no element
> on it) the attribute remains the line's collector even after its value
> finishes — further same-line material is a warned extension (§6.7). On an
> **element-rooted line** an attribute never collects past its finished
> value — the element takes the tail (the sameline decompress). This
> asymmetry is the whole difference between the two contexts.

I checked this against the two worked-example rows and against §6.7
("Warned extension", lines 384–391) and found it consistent, not
contradictory — but the consistency turns on the word "collecting" being
used in exactly one sense throughout, worth spelling out because a careless
reading could conflate two things that look similar:

- Ownership-table row 1 has **two** disjuncts: "needs a value" (still open,
  not yet finished — e.g. `:another with some text`, a flow value still
  running to EOL) **or** "is collecting" (already finished, but still the
  line's collector — the block-line-only case the Collecting paragraph
  defines).
- The Collecting paragraph's claim is narrower than it first reads: it is
  entirely about the *second* disjunct (post-finished-value behavior), and
  it says that disjunct is simply **unavailable** on an element-rooted line.
  It says nothing about the first disjunct (still-open flow values), which
  behaves identically in both contexts — an open value keeps growing until
  its own terminator regardless of whether an element sits to the left.

Read that way, row 1 of the worked example (`:another with some text`, all
one flow value) is the *first* disjunct — `another` hasn't finished, full
stop — and says nothing about collecting-after-finish at all. Row 2
(`"with"` finished, `some text` goes to `el`) is the case the Collecting
paragraph is actually making a claim about, and the two agree. I did not
find a textual inconsistency here — my initial concern going in (flagged in
the brief) was that "an attribute never collects past its finished value"
on element-rooted lines might read as in tension with row 1's flow value
absorbing an entire multi-word tail, but row 1 is the *not-yet-finished*
case, not the *collecting-past-finish* case, so there's no tension. If
there is a defect in this area, I'd now locate it as a **clarity** gap
(the table's "or is collecting" packs two different mechanisms into one
disjunct without flagging that they're different) rather than a
**correctness** gap — worth a possible one-clause addition, not a rule
change.

### 2b. Do §4 (escape) and §6.5's "Value-position `\`" paragraph agree on what a `\` does at a finished value's boundary?

`v2/current-0.9.1-spec/CORE.md` §4, lines 127–132 (**[primary]**) enumerates
exactly four named positions for `\`: Structure Position, in-flow before an
inline opener, value-expected position (no token started yet), and
"anywhere else" (literal). A `\` sitting *after* a bare token has already
completed as a finished value (Joseph's example 3) is not named as one of
these four in so many words.

I traced why this isn't actually a fifth undocumented position: §2.2/§2.3's
Structure Position is defined as active "along the left-to-right run through
elements and attributes on that line" (this phrasing is quoted correctly at
`v2/theory/CLAUDE.md:80`, itself citing `CORE.md` §2.1/§2.2 — I did not
re-derive it from `CORE.md` §2 directly in this pass, so mark this one link
**[secondary, high confidence]** rather than primary), not just at line
start. So the scan position right after a bare token finishes as a value is
still Structure Position, and §4's Structure Position row ("consumed; the
rest of the physical line is prose text") already covers it. §6.5's
"Value-position `\`" paragraph (line 356, **[primary]**) restates that
specific consequence locally rather than cross-referencing §4 by name — a
missed cross-reference, not a disagreement. I found the two consistent in
substance; the only defect I'd name is that §6.5 could say "(Structure
Position, §4)" instead of re-deriving the behavior in place, which would
make the fifth-position question I initially had not arise for the next
reader either.

## 3. Where the deviation hypothesis doesn't seem to have materialized

Joseph's hypothesis was that someone read 0.8-lineage grammar/parser
behavior instead of the 0.9 spec text. I looked for a live artifact
embodying the wrong rule and didn't find one:

- `core/TODO-CORE-PARSING.md` has no open item referencing sameline
  tail/ownership behavior at all (**[primary]**, grep across the file).
- `v2/current-0.9.1-spec/DELTAS.md` has no entry for this area (**[primary]**,
  grep — DELTAS.md's own stated contract is that an unlisted behavior
  difference between the 0.9 line and the consolidated suite is itself a
  defect in the suite; there being nothing to list is consistent with the
  two texts actually agreeing, which is what direct comparison in §1 above
  also shows).
- `v2/theory/CLAUDE.md` (written earlier today, before this brief) already
  states the rule correctly, with Joseph's exact quote already inline
  (lines 233–236, **[primary]**) — including a self-correction ("I first
  wrote this up as a trap, which was wrong — it is the rule working") and
  an explicit flag that the Collecting-paragraph consistency question (§2a
  above) was open and being checked separately. This document is that
  check, and it closes clean.
- `v2/spikes/format-failures/UDON-PRIMER.md` doesn't make a competing claim
  about tail ownership at all — its one relevant line (97) just states that
  "a multi-word tail is a flow value," which is compatible with everything
  above and doesn't take a position on the block/element asymmetry.
- The CHANGELOG's 2026-07-19 DERATIFICATION entry for the flat event wire
  (`spec/msc/CHANGELOG.md` lines 18–31, **[primary]**) confirms
  attribute-vs-element ownership is a real, previously-fragile area — the
  flat wire literally could not express it, which is presumably close to
  the kind of gap Joseph's hypothesis is reaching for — but that defect was
  in the *wire encoding*, already deratified and being redesigned, not in
  the *text-model rule* in §6.5 itself, which reads as stable and correctly
  stated in both places I checked it.

So my best-supported answer, held open to being wrong: **(c)** — there's no
deviation in the ruled spec text at either location, and the "someone read
the 0.8 grammar" scenario, while a reasonable thing to worry about in
general (0.8-lineage artifacts are explicitly non-authoritative per this
project's own standing memory), doesn't appear to have left a trace in
anything I checked. I did not go spelunking in the 0.8-era grammar/generator
files to characterize what *they* actually do — that would be pure
archaeology at this point given (a)–(c) above, and I'd rather flag it as
unpursued than pad this out with a check that wouldn't change the answer.

## Open items for Joseph, not resolved by me

- Whether the two clarity gaps in §2a/§2b are worth a small textual
  addition to `CORE.md` (both suites) — a one-clause note distinguishing
  the two senses of "or is collecting" in the ownership table, and a
  cross-reference from §6.5's Value-position-`\` paragraph back to §4's
  Structure Position row. Neither changes any parsed result; both are
  purely legibility for the next reader. I'd rather he decide whether
  that's worth the edit than propose the wording myself.
- If he still has a specific document or session in mind that showed the
  wrong behavior, that artifact would be worth naming directly — I searched
  broadly but reactively (grep across the suites named in the brief plus
  the parser TODO lanes) rather than exhaustively across every session
  transcript, so absence-of-evidence here is bounded by what I actually
  searched.

I'll stay available if either of you wants a follow-up pass — happy to chase
the 0.8-grammar archaeology for real if it turns out to matter, or to draft
the two clarity additions if Joseph wants them.

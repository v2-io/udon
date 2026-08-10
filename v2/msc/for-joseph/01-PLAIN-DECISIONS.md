# Plain decisions — snippet first, no jargon (2026-08-09)

*Each decision: what you'd write, what it does under each option, my
recommendation. Rule in any order; one word each suffices.*

---

## D1 — Should the spec open with the seven axioms? (§0)

Pass 2 fronts CORE with seven one-line axioms everything else derives from:

1. Columns are the syntax (deeper=child, same=sibling, shallower=closed)
2. A document is a stream of virtual lines; `\` inserts a line-break-at-cursor, `}` suppresses one
3. Two spaces: sameline = value-space (things are values), block = text-space (things are prose)
4. Everything sameline is an assignment — the only question is which label
5. Two extent kinds: geometric (dedent closes) or delimited (printed closer closes)
6. Bare typing is frozen forever; everything else is `<…>`
7. Keep everything; Error = loss only

**Keep** → readers derive rules instead of memorizing them (the fresh-reader
probe scored 5/5 with this framing vs 4/5 without — n=1, suggestive).
**Revert** → one self-contained commit.
**Recommendation: keep.** (Separate sub-item, no urgency: the full physical
reorder of sections is *proposed only* — approving §0 does not trigger it.)

## D2 — RULED → K16 (2026-08-09, in chat)

**A key is a value slot, not a different syntax.** Full value grammar in every
value-expected position including identity/selector bracket interiors — the
fork-concurred brace carve was *rejected* (my "keys are for matching" rationale
was an invented essence; jaw caught it live). Block forms out of bracket sugar:
held lightly, "OK for right now," not law — the longhand `:$key` form covers
complex keys. Matching semantics stay paths-era, default inert. Original
presentation kept below for the record:

## ~~D2 — Where does "brace form = its own value" work?~~ *(superseded by K16 above)*

Your intuition: `:attr |{a} |{b}` ≈ `:attr [|{a} |{b}]` "generally."
Resolution, unanimously concurred after both forks tried to refute it (each
retracted its own contrary lean with reasons; pass 2 showed its axiom A3
*derives* this, and that R17 had already conceded the list case):
**wherever a value is expected, the full value grammar applies** — plus one
labeled carve: identity/selector brackets stay non-structural until paths
(written as explicit subtraction *with its reason*, covering `@[…]` too, so
incorporation-by-reference can't leak it). "Generally the same" lands as
view-level: same items through a values-view, ordinary stacked-vs-list in the
model. Two one-liners ride along: a host projection-policy note for
structured list items, and an OPEN-ML line for the unclosed-`|{`-item edge.
Pass 1's fork left a seven-point landing checklist (its final message) so the
fold-in is mechanical once you say yes.

```udon
|el |{a} |{b}          ; two stacked $main values (ruled)
:attr
  |{em hi}             ; the em IS attr's value (deferred value position)
:tags [|{a} |{b}]      ; list of two inline elements — YES under the proposal
|el[|{x}]              ; still no — the labeled paths-era carve
```

Stacked vs bracketed stays the same distinction it is everywhere
(`:x 1 :x 2` vs `:x [1 2]`): same items, different packaging.

## D3 — Attached escape while a value is open (Q8)

```udon
|element :attribute hello \:-) how are you?
```

**Option A (drafted, K13-consistent):** the escaped `:-)` joins the still-open
value → `attribute = "hello :-) how are you?"`, no `$main`. Break out with the
framed form: `hello \ :-) how…` → `attribute="hello"`, `$main=":-) how are you?"`.
**Option B (your original pre-K13 annotation):** any escape after a value
starts element text → `attribute="hello"`, `$main=":-) how are you?"` either way.
**Recommendation: A** — one rule ("escape = make one character literal, change
nothing else"), and the framed/attached distinction stays meaningful.

## D4 — Bare `:done?` now that flags are retired

```udon
|task :done? :assignee sam
```

**Option A (drafted):** `done?` is an ordinary label missing its value →
Error + Nil (the deletion-detector working); write `:done? true`.
**Option B:** some gentler landing for bare `?`-labels specifically.
**Recommendation: A** — carving `?`-labels back out re-imports half the flag
machinery you just deleted.

## D5 — Does a framed ` ; ` still end an open value?

```udon
|el :note call Sam tomorrow ; remind him about the demo
; note = "call Sam tomorrow", comment = "remind him about the demo"
```

**Drafted: yes** (it was a value-ender before; K10 kept it in the terminator
set). Confirm or veto. **Recommendation: yes.**

## D6 — Rename the late-attribute warning?

The accept-and-warn warning (K14) is still named `AttributeAfterChildren` —
a name that sounds like the *old* it's-just-text rule. Candidate:
`LateAttribute`. Names aren't contract yet (W4), so this is cheap now.
**Recommendation: rename to `LateAttribute`.**

## D7 — Late identity, one consumer sentence

Since attributes may now come late, `:$key` can too — so a streaming consumer
can't trust an element's identity until the element closes. Drafted as a
consumer note, no grammar change. **Confirm the note is enough** (vs carving
`$`-labels out of late acceptance). **Recommendation: note is enough;**
document-layer duplicate checks already work whole-element.

## D8 — The envelope's parts were also called "labels"

`<temporal:interval:2026-01/2026-06>` — the `temporal:interval:` part was the
"label ladder." With *label* now meaning attribute-name, the draft renamed it
**"envelope ladder."** Fine, or prefer another word ("tag"?).
**Recommendation: envelope ladder (as drafted).**

## D9 — Small keep/retires

1. **Element suffix sugar** `|el?` → `:$? true` — now the only bare `?` with
   built-in meaning anywhere. Keep (harmless, schema-facing, and your
   CHEATSHEET arity convention uses the suffix position) or retire.
   **Recommendation: keep.**
2. **`EscapeOutsideHeadPosition` advisory code** — describes nothing after
   K13. **Recommendation: retire at fixture time.**
3. **"Content phase"** as a concept — already retired in the draft (the
   *behavior* — the late-attribute Warning trigger — remains). FYI only,
   flag if the phrase was doing work for you elsewhere.

## D10 — Housekeeping (whenever)

- **Merge**: bless pass 1+2 (branch `unif-pass-2`) onto main once D1/D2 land.
- **Directory rename**: suite says 0.10.0-alpha.1 but lives in
  `spec-0.10.00/` — rename (`current-spec/`?) or leave.
- **`.un` extension** — intentional convention? One line somewhere if so.
- **REF-SLASH / REF-BRACKET** (old OPEN rows) — soonest-relevant of the old
  steward calls, since the paths corpus is live.

# Ruling supplement — the open items, explained with examples

**Temporary companion to RULING-TABLE.md** for the ruling sitting. One entry per open row: what the question actually is, what each option does to a concrete example, and where the consensus lean sits (grok + Fable; splits flagged). Written by Fable 2026-07-20; grok to verify/extend. Delete after the sitting.

Already-ruled carries (R1–R21) are not re-explained here — they only need a "carry" scan. L3 likewise (it's R3).

---

## §0 Charter

### C2 — Version line

The old spec line reached `0.9.0-alpha.2` and its rulings are recorded under that number in the CHANGELOG. The fresh suite needs a number.

- **A** — new suite is **0.10.0**: 0.9.x remains the transitional history it actually was; `core-v0.8.0` stays a real frozen gate; nothing renumbers.
- **B** — restart at a clean **0.9.0**: prettier, but the ledger already says "0.9.0-alpha.2 ruled X" about a different document line — future readers must untangle two 0.9s.

**Lean: A (both).**

### C3 — Suite file set

What files the authoring agents produce day one:

- **A** — `SPEC` (surface→meaning) + `ADM` (the data model) + `GLOSSARY` + `WIRE` (ADM→events) + `SEMANTICS` (equivalence/round-trip) + `DECISIONS` + `OPEN`, with optional thin GRAMMAR extract and pedagogy outline.
- **B** — fewer (e.g. no WIRE day one) — risks recreating "the wire contract lives only in the grammar," which is what just failed.
- **C** — more (full dialect specs day one) — delays everything on the least settled layer.

**Lean: A, dialects as thin stubs (both).**

### C4 — Old parser during the rewrite

- **A** — keep it runnable until the new gate is green, as a **differential oracle**: run both parsers over the corpus, and every disagreement is either an intentional change (should match a DECISIONS row) or a bug in the new stack. Cheapest audit available. It is never *authority*.
- **B/C** — freeze or delete now; lose the oracle.

**Lean: A (both).**

### C5 — What fixtures assert

Today a fixture asserts a raw event list:

```yaml
- id: example
  udon: "|el :a 1\n"
  events: [ElementStart, [Name, el], [Attr, a], [Integer, 1], ElementEnd]
```

The newline bug survived precisely because the harness compared "does the stream look right" with a compensating fold that consulted the source. The alternatives:

- **A** — fixtures assert what a **pure fold recovers**: the ADM slice (structure + ownership + values + text), the anomalies, and the document result. Directly tests the W0 law; a compensator has nowhere to hide.
- **B** — raw event lists only (status quo; the disease remains possible).
- **C** — both surfaces per fixture: the event list *and* the fold-recovered assertion. Gold standard, heavier harness.

**Lean: C if affordable, else A (both).**

> **What "the fold" is, precisely.** A single pass over the event stream with an accumulator and nothing else: `fold(events) → (tree, anomalies)`. No source bytes, no spans, no re-derived layout logic — if the fold ever needs those, the wire has failed W0 at that point. The text instance is already live in the harness (`Text`/`RawContent` → append content; `BlankLine` → `"\n"`); the general form is a small stack machine: `ElementStart` push · `Attr` opens an assignment · value events attach · `AttrValueEnd` closes it (this is what W1 adds) · `End` pops. One shared ~30-line function — the executable statement of the law, and the only place a harness compensator could hide.

### C6 — Incomplete-input in fixtures

These two inputs produce **identical event streams** today; they differ only in the document result:

```udon
|el :xs [1 2
:next 1
```
(array closed by the newline, with a warning → document **complete**)

```udon
|el :xs [1 2
```
(array still open at end of input → warning **plus** result: **incomplete**)

No event-list fixture can tell them apart. Options: **A** a `result:` field on fixtures · **B** test only at the AST/driver layer · **C** defer.

**Lean: A, naturally falls out of C5 (both).**

---

## §2 Wire contract

### W0 — The ADM-sufficiency law

The proposed single normative sentence of WIRE.md: *a pure fold over the event stream — no source access, no spans, no re-derived layout logic — must recover the ADM exactly: structure, ownership, values, text, anomalies, and the incomplete-input result.*

Why it's needed — the deratification exhibit. This input:

```udon
|el :v1 hey
  more text
  |child
```

`hey` is `v1`'s value; `more text` and `|child` belong to **el**. But the current stream is `Attr "v1" / BareValue "hey" / Text "more text\n" / ElementStart child…` — nothing on the wire says where `v1`'s value *ends*. The consumer must re-run the parser's own indent/ownership analysis. The law makes that class of design impossible, and gives every future "should X be its own event?" debate a mechanical answer: is the distinction in the ADM? Then the fold must recover it.

The text half of this law is already ruled and implemented (R1); W0 generalizes it to structure.

**Lean: A — adopt (both; this was jointly derived).**

### W1 — Attribute value extent (the bracket)

The concrete fix the law forces, on the same example:

```text
today (deratified):        with the value bracket:
  Attr "v1"                  Attr "v1"          ← opens the value
  BareValue "hey"            BareValue "hey"
  Text "more text\n"  ←??    AttrValueEnd       ← closes it; unambiguous
  ElementStart child         Text "more text\n" ← now provably el's
                             ElementStart child
```

Also the test case that proves it: mixed interpolation. Semantics are already ruled (`:href !{{base}}/x` is one flow value), but the old encoding for it ("re-emitted Attr segments") was flat-wire vocabulary and died with the deratification. Under the bracket it's simply:  
`Attr "href" / Interpolation "base" / Text "/x" / AttrValueEnd` — no re-emit machinery at all.

Open sub-choice inside A: asymmetric (`Attr` opens, `AttrValueEnd` closes) vs symmetric (`AttrStart`/`AttrEnd`). Authoring-level detail.

**Lean: A (both — and it matches your own restated intent: "an Attr is always followed by exactly its value, and that value is self-delimiting").**

### W2 — How much wire refresh in the first pass

The audit found more than the value bracket: `Text` role overload, `BlankLine`'s three meanings, freeform emitting `Text` while raw emits `RawContent`, etc.

- **A** — bracket only, refresh later · **B** — everything in one pass ·
- **C** — phased: bracket first (unblocks grammar + fixtures), the vocabulary refresh as a named backlog *inside* WIRE.md so it can't silently drop.

**Lean: C (both).**

### W3 — Reference encoding

`@licence[mit].realized` today emits one raw event: `Reference "licence[mit].realized"` — the consumer re-parses the selector text. The structured form would reuse the identity machinery: `ReferenceStart / Name "licence" / Attr "$key" / BareValue "mit" / Attr "$traits" / BareValue "realized" / ReferenceEnd`.

- **A** structured now · **B** keep interim raw until paths (0.10) force the selector question anyway · **C** defer wholesale to paths.

**Lean: B for the first gate, A when the shared identity machinery makes it nearly free (both).**

### W4 — Warning/error code derivation

Who owns spellings like `UnclosedIdentityKey`: **A** derived by descent from construct names (already partially real — `UnterminatedFreeform` was auto-normalized to `UnclosedFreeform`) · **B** a hand registry in SPEC · **C** both: SPEC lists the vocabulary, the generator derives and must agree.

**Lean: C (both).**

### W5 — Text role disambiguation

One `Text` event currently means any of: element prose, flow-value segment, comment body, embed content, freeform body, directive args. Options: **A** distinct events/roles per context · **B** keep one `Text`, let the enclosing brackets carry the role (the fold knows where it is) · **C** defer.

**Lean: B where brackets exist, escalating to A only if a fold provably still can't classify (both). Note B is only coherent *after* W1 — brackets must actually exist everywhere ownership matters.**

---

## §3.0 Severity — L0 (rule this before L1/L4)

**The one genuine grok/Fable split.** The current definition: Warning = everything kept; Error = something lost. Two cases strain it — bytes kept but the *structure* the author wrote is unhonorable:

```udon
|el
	|child        ← tab in the indentation
```

```udon
:orphan 1        ← attribute at document root, no element anywhere
```

In both, keep-everything can preserve every byte as text. So:

- **A (strict loss)** — Error means bytes lost, full stop. Since these keep the bytes, they're **Warnings**. Severity stays mechanically checkable; the fold can verify it. *(Fable's position.)*
- **B (loss ∪ illegal geometry)** — Error also marks "this cannot mean anything as written," even when bytes survive as text. Matches the intuition that a tab in indentation is worse than a stylistic wobble. *(grok's lean.)*

What actually rides on it: only the severity *labels* on L1/L4 (and the schema/CI story — "fail on error" means different things under A and B).  
Content handling is identical either way.

### L1 — Root-level `:key`

```udon
; top of file, no element yet
:orphan 1
|real-element
```

Prior ruling (2026-07-18) was **undefined** — the parser free-floats the attr, "do not rely." Options: **A** define as document text + warning · **B** define as text + error · **C** bless the free-floating attribute (invents a phantom owner — nobody wants this) · **D** carry *undefined* into v2 unchanged.

**Lean: A if you want it settled now, D if v2 stays thin here (both). A/B label resolves from L0.**

### L2 — In-string escapes

Can a quoted string contain its own quote character?

```udon
:say "he said \"hi\""     ; B reading: works; but…
:path "C:\Users\new"      ; …B also makes \U and \n suspicious, and \\ halves
:say 'he said "hi"'       ; A reading: use the other quote kind — no escapes at all
:items ["x""y"]           ; why C (doubling) is out: this is ALREADY two items
```

- **A** — no escapes inside strings; a string ends at the next same-quote; contain one kind with the other. Keeps "`\` is positional, period" intact.
- **B** — recognize `\\` + the delimiter escape only (a fifth, non-positional `\` rule; mixed semantics inside one string).
- **C** — quote-doubling (collides with the adjacent-quoted-items list rule above).

**Lean: A (2a and post-revision 3b both).** Honest limit of A: a string needing *both* quote kinds has no single-line spelling and waits for multi-line/verbatim forms.

### L4 — Tab in indentation

```udon
|el
	|child
```

Live CORE today: error, **line lost** (B). Nobody defends that anymore — 3b found the coherent keep during peer review: treat `\t|child` as text of the current owner, using the spaces before the tab as its column. So the real choice is only the label: **A** Error+keep vs **C** Warning+keep — which is L0 again (A under L0=B, C under L0=A).

**Lean: keep the bytes (unanimous); label follows L0.**

### L5 — Rational / complex literals

```udon
:ratio 1/3r       ; today the grammar emits a Rational event
:z 3+4i           ; …and Complex
:ratio <r:1/3>    ; the dialect-era spelling (exact form is dialect design)
```

The 0.8.0-alpha.1 ledger already says bare numerics froze to integer+float; the live CORE caution ("parser-decided until dialects") was a later hedge. All three greenfields independently put rational/complex in the envelope. **A** reaffirm the freeze (bare `1/3r` becomes the string/flow it looks like) · **B** restore them as bare scalars · **C** split (complex bare, rational dialect).

**Lean: A (all three greenfields + the alpha.1 entry).**

### L6 — Attr-under-attr: the kept shape

The *error status* is already ruled; this is only about what the keep looks like:

```udon
|el
  :theta
    :first 1      ← error either way; but what does the ADM hold?
```

- **A** — `:first 1` becomes **text of the open `theta` value**, error annotating it (closest to what was written; the error message teaches the named-carrier idiom: `:theta` + deeper `|config :first 1`).
- **B** — treat it as a warned sibling extension under `theta`.
- **C** — drop it (violates keep-everything; out).

**Lean: A (both + all three greenfields).**

### L7 — Comment continuation stripping

A line comment owns everything indented deeper. How much leading whitespace does the comment *text* keep?

```udon
; header comment
    continued line one
      deeper detail
```

- **A (content-base shape)** — first continuation line sets the strip column (here 4): text is `continued line one\n  deeper detail` — same rule as prose and raw blocks. One mental model everywhere.
- **B (verbatim from comment column)** — strip only the comment's own column: text keeps all interior indentation verbatim.

CORE describes A but explicitly flags B as "defensible, needs a ruling."

**Lean: A (both + convergence).**

---

## §3.2 Silences / design opens

### S3 — Multiple keys (surrogate + natural)

Your own motivating case (vivarium):

```udon
|phase[9][scribal]      ; addressable as @phase[9] OR @phase[scribal]
  :name Scribal
```

The model mostly exists already (stacked `$key` is arguably wire-legal; tuple keys `|el[[9 scribal]]` parse today as ONE compound key — a different thing). Open: the second-bracket surface syntax, per-key vs tuple uniqueness, reference resolution, and which key `key()` returns. **A** valid, full design in 0.10's OPEN · **B** invalid · **C** tuple-only is enough.

**Lean: A design-open — matches your stated lean; don't half-specify now (both).**

### S4 — `InconsistentIndentation`: prose-only?

Legacy fixtures had a **comment** or **attribute** line seeding the prose content-base (and warning on inconsistency); the 0.9 grammar deliberately(?) narrowed the warning to prose lines, and three legacy fixtures die on it. Not an opinion question — **was the narrowing intended when the 0.9 grammar was written?** Only you know. **A** confirm prose-only and record it · **B** restore the broader rule · **C** defer.

**Lean: none possible from us — this is a fact about your intent.**

### S8 — Raw block with empty same-line body

```udon
!:sh: 
```
(note the trailing space after the label) — **A** an empty body · **B** no body at all · **C** defer. Only affects the empty edge; `!:sh: echo hi` is settled.

**Lean: A — uniform with "everything after the separator is body" (both).**

### S9 — Blank-line placement vs dedent

```udon
|p
  |a

  |b
```

Is the blank line *inside* still-open `|a`, or does it sit between `|a` and `|b`? Pure stream-ordering/ornamentation choice; the S6 AST policy (edge blanks = ornamentation) makes most consumers insensitive to it.

**Lean: C — defer with the S6 AST policy (both).**

### S11 — Inline verbatim in value position

```udon
|el :sample !{:json: {"a": 1}}
```

**A** a flow-value segment (uniform with every other inline brace form under the `*{` principle) · **B** a verbatim node value · **C** undefined.

**Lean: A (2a Q4 + 3b D10).**

### S12 — Nested envelope routing

```udon
|el :q <r: <i: 3 -7> 0d83.23>
```

The `<>`-balanced span already parses. Who interprets the *inner* envelope — **A** the active (outer) dialect drives, recursively · **B** the core consumes and hands pieces off · **C** defer with dialects.

**Lean: A, or defer — either is safe since no dialect layer exists yet (both).**

### S13 — Mixins

```udon
|.defaults :adapter postgres :host localhost
|database[prod].defaults
  :database prod_db      ; a mixin-aware host also sees adapter/host
```

**A** stays a host experiment (core specifies nothing; already true) ·  
**B** specify inheritance now · **C** delete the mention.

**Lean: A (all three greenfields).**

### S14 — Reference model until paths

**A** keep the `(name, key, traits)` selector with **no incremental growth** — every addition would be future path-syntax debt · **B** design paths now · **C** drift.

**Lean: A (all three).**

### S15 / S16 / S17 — Pragma, Markdown layers, float equality

Packaging-grade: **S15** pragma (binding a document to dialects/schema) gets a design stub in OPEN, not a spec. **S16** the Markdown four-layer companion stays a stub (Layer-1 subset enumeration is real future work). **S17** float equality in SEMANTICS: host profile (**A**) or omit from core equivalence (**C**) — both defensible; **B** (specify bit-exactness) is over-reach.

**Lean: A / A / A-or-C respectively (both).**

### S18 — Inline-comment framing whitespace

```udon
|p This is some text ;{TODO} and more text.
```

Stripping the comment leaves `…text  and…` — **two** spaces (both framing spaces are prose; pure concatenation keeps them). **A** pin that (live behavior, concat-pure) · **B** collapse to one space (whose layer? not the parser's) · **C** defer with the dialect work, as CORE's caution already says.

**Lean: C, or A-as-pin (both). B at the core layer would reintroduce fabricated-byte joining — the disease the text law just cured.**

---

## §4 Packaging

### P1 — Where the suite lives

**A** replace `spec/` immediately · **B** author under `v2-spec/`, cut over when WIRE + first fixtures exist · **C** dual-run indefinitely.

**Lean: B (both) — also keeps the old tree byte-stable while it serves as the C4 oracle.**

### P2 — Who authors

**A** parallel agents seeded with the filled table + CHANGELOG (the greenfield suites as *wording* sources only) · **B** one agent · **C** human-led.

**Lean: A (both).**

### P3 / P4 / P5 — Day-one extras

GRAMMAR extract: **A** thin, non-normative, SPEC-wins-on-conflict (all three suites converged on wanting this). Pedagogy: **A** outline only. Dialects: **A** thin `temporal@1` + dynamics stubs or **B** pointers — either; just not full specs.

**Lean: A / A / A-or-B (both).**

---

## The four that actually need your judgment (recap)

1. **L0** — severity definition (the real grok/Fable split; decides L1/L4 labels).
2. **L1** — define root-`:key` now (A) or carry undefined (D).
3. **S4** — fact question: was the prose-only narrowing deliberate?
4. **C5** — events+ADM dual assertion (C) vs ADM-only (A): a cost call.

Everything else above has an aligned recommendation you can accept or overrule at a glance.

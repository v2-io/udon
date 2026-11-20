# Fork notes — R4-scope overturn & "clean value-expected position", worked cell by cell

**Status:** deep-check findings for adjudication, sharpest first. Companion to
`sameline-value-space-2026-08-08.md` (the capture doc). Written by a fork
holding the full session; the general-purpose spike's addendum is parallel and
independent — if we disagree, that disagreement is a finding, not a defect.

---

## 1. The deepest unstated consequence: sameline structure stops being *content*

Under the overturn, `|el |{a} |{b}` puts both embeds in the **$main attribute
stack** — they are no longer children in `content` at all. Today inline
elements are children of the element (siblings to text segments, §5.6). After
the change, a consumer walking `content` finds **nothing** for a
sameline-only element; the embeds live on the attribute side, re-injected only
by the host stitching rule (`first_is_main`-style). Joseph's stated goal —
"real siblings" — is achieved, but *in a different population than today's
siblings*. Paths, "children of el" queries, and every renderer cross this
line. It is the right consequence of "all sameline is value-space," but the
capture doc never says it in one sentence, and it is the sentence Joseph
should ratify explicitly:

> **Sameline material is never content. Content is exclusively block-form.**

Corollary (text law): a **typed** $main is a scalar, and scalars have never
been text material. `|element "hello," she said` reconstructs, at the text
layer, as `she said\n` only — the quoted string is *data now*, exactly as
`:a "x"` has always been. That is coherent with "sameline text is a scalar,"
but it means the text law's output changes for every document with a typed
$main head. Needs one deliberate sentence in MODEL §6, or this ships as a
surprise.

**Terminator pin (unresolved):** today the tail's Text carries its `\n`
(Appendix C vignette 1: `"Joined 2025.\n"`). Does a $main *flow* value keep
the terminator? If yes, text-law continuity for the untyped common case; if
no, every sameline-tail document's reconstruction changes. My lean: $main flow
keeps `\n` (it is the line's text, relocated); typed $main scalars carry
nothing. Either way — pin it, it's currently ambiguous.

## 2. The overturn requires a MODEL edit nobody has listed, and flips S11 too

MODEL §4: `Value = Scalar | Reference | Interpolation | NodeValue | FlowValue`,
with `NodeValue = Element | Verbatim | Directive` (block forms) and inline
elements existing only as flow *Segments*. Under the overturn, `:n |{em x}`
makes the inline element **the value itself** — there is no Value kind for
that. Either NodeValue widens to include inline forms (blurring the
block/inline distinction the model keeps on purpose) or a new kind
(`InlineValue`) appears. This is a real taxonomy decision, not wording.

Same blade, second ruled casualty: **S11** ("inline raw `!{:kind:…}` in value
position → flow segment, per the *{-principle") is *directly* overturned at
the clean slot — `:x !{:json: {...}}` becomes a Verbatim-valued attribute, not
a one-segment flow. S11 is absent from the capture doc's flip list. `;{}` also
moves: `|el :n ;{} :a 1` currently yields `n = " :a 1"` (flow, comment
stripped); under the overturn `n = ""` and `:a` is real — arguably *better*,
but it's a ruled-example flip (R13's `;{}`-empty-string case) to name.

**The one precedent in favor, also unlisted:** interpolation *already*
self-delimits as a whole attribute value (§6.3/§9: `:x !{{id}}` is an
Interpolation value; `pre!{{x}}post` is flow). R4 has never actually been
uniform — `!{{…}}` has behaved at the clean slot exactly as the overturn
proposes for all brace forms. The overturn is a generalization of an existing
exception, not a de-novo hole in a clean principle. That's the strongest
pro-coherence argument available and should be in the ruling's "why."

## 3. §6.6 cell by cell — where "clean value-expected position" holds and where it wobbles

Proposed definition (survives contact, with one asymmetry and two carve-outs):

> A **clean value-expected position** is any point where the grammar awaits a
> value and no bare token has begun: (a) after a plain `:key` (§4's
> value-expected), (b) the element's $main slot — after the head, or after any
> finished sameline value, (c) a list-item position, (d) the first line of a
> deferred body (K7). Brace forms self-delimit there; once a token has begun
> or flow has committed, R4 stands untouched.

- **Element-rooted line** — clean. `|{a} |{b}` → two silent stacked $mains;
  `value |{em x}` → flow (token begun; ruled example unchanged); flag rule 2's
  re-owned material lands in the $main slot coherently (`:a? |{em x}` →
  a?=true, $main = the em).
- **Block attribute line** — works, but exposes an **asymmetry**: after a
  finished value, the element line stacks $main *silently*, while the block
  line's trailing material is a **warned** extension (§6.7, kept by K8's
  pending pin). So `:key |{a} |{b}` on its own line = value + warned second
  assignment; the same shape after an element head = two silent $mains.
  Joseph's "I don't think we need a Warning for stacked values at all" (K2
  context) suggests he may want the block-line warning gone too — that would
  make the value-space model fully uniform. Adjudicate together with UNIF-PASS
  pin 1, not separately.
- **List items** — the overturn's most *natural* home: lists are already
  "values separated by whitespace," which is exactly the semantics the $main
  stack just adopted. `[|{a} |{b}]` → two inline-element items, no space
  content — and Joseph's own `:'$main' [|{embed-1}, |{embed-2}]` notation was
  list-shaped. Requires the same MODEL Value-kind edit as finding 2; R17
  ("items use full value rules") absorbs it cleanly.
- **Inline-element interiors** — the exemption means **the hack survives
  inside brackets**: `|{a |{b} |{c}}` keeps space-as-content while
  `|a |{b} |{c}` becomes two spaceless $mains. Identical-looking tails,
  opposite semantics, chosen by the outer form. Defensible (bracket mode is
  already its own context, and mixed text+structure genuinely needs
  space-as-content), but it is exactly the "tell" Joseph named, still living
  one level down. Say it; don't let it be discovered.
- **Identity brackets (post-K2)** — the overturn *pressures* toward admitting
  `[|{em x}]` as a $key (uniformity); paths hygiene pressures the other way.
  Recommend: **exclude inline forms from identity/selector interiors** (extend
  K2's block-form exclusion; the spike's §3 restriction 3 already leaned
  text-only). A structured, brace-built key is a resolver nightmare with no
  gathered demand.

## 4. The dual-operator model is over-elegant as stated: `\` is not just "insert LF"

If `\` merely inserted a pseudo-LF, then `:a \` would leave `:a` alone at its
virtual line-end → missing-value **Error + Nil** (§6.2), and under K7 the next
virtual line would be a value position. But the ruled behavior (R13) is
`:a \` ≡ `:a ""` — an **empty kept string, no anomaly**. The operator that
actually reproduces the rulings is:

> **`\` forces text mode at the current cursor** (and thereby *ends* the
> current value/scan mode); the pseudo-LF is the derived effect, not the
> definition.

Same at Structure Position (it forces the line to text; it doesn't "insert a
newline"). The `}`-suppresses-LF half survives stress fine (multi-line inline
terminator ownership, §5.6, is consistent with it). Recommend the capture
doc's operator table be corrected before the model is taught to anyone —
LF-insertion alone re-breaks the exact cases (`:a \`, empty forced tails,
K7 first-line) the rulings got right.

## 5. §6.8's teaching sentence and the SEMANTICS example survive only by accident — name the wart

"Drop the braces to bind an element as the value; keep them to inline it as
text" (§6.8) dies: under the overturn, *both* forms bind an element as the
value at the clean slot. What still distinguishes `:x |em hi` from
`:x |{em hi}` is only this: the block em carries "hi" as **$main** (sameline
tail → attribute), while the inline em carries "hi" as **content** (interiors
are exempt from $main sugar). So SEMANTICS §4's "NOT equivalent (node vs
flow)" pair remains non-equivalent — but for a reason no author would guess:
the same-looking text lands in a different slot depending on brace form.
Either accept and document the wart, or extend $main into inline heads (which
finding 3's interior-exemption analysis argues against). My lean: accept,
document, and let the pedagogy pillar carry it — but this is exactly the kind
of subtlety Joseph should see before ratifying, not after.

## 6. Where I looked for the parent's next polarity error

Checked: the chained example (verified — walks correctly under typed-slot +
sameline nesting + framed comment), the dialogue stack (verified), the
stacked-canonical pin (matches Joseph's earlier "stack into an array" over his
later list notation — but see finding 3's list-item cell: the two readings
*converge* if list items and $main stacking share semantics, which they now
do), and flag-rule re-owning (clean). The genuine miss I found is finding 1
(content-population shift + typed-$main text-law change) — not a polarity
inversion but an unstated consequence of the correct polarity; findings 2
(MODEL kind, S11) and 4 (the `\` operator) are the other substantive gaps.

## Summary for adjudication

Ratifiable as-is: the clean-slot definition (§3's wording), the interpolation
precedent as the "why," identity-bracket exclusion. Needs Joseph's explicit
eyes: the content-population sentence + typed-$main text-law change (1), the
MODEL Value-kind fork and the S11 overturn (2), the block-attr-line warning
asymmetry (3), the `\`-operator correction (4), the §6.8/SEMANTICS wart (5),
the terminator pin (1). Nothing found that breaks the model; everything found
is the model being *bigger* than the capture doc admits.

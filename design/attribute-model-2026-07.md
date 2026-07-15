# The Attribute Model — hash & array, edges & nodes

**Status: PROVISIONAL — converged brainstorm, 2026-07-15, Joseph + Claude
(session ending that night; this document is the durable carrier).** Nothing
here is ratified into CORE yet. It records a model that emerged whole over
one long conversation, the reasoning at each fork, what it would supersede,
and the questions still open. When ratification comes, this document is the
input; CORE is the output; this file then becomes history.

Registers used below: **settled-provisional** (both of us converged, pending
formal ratification), **leaning** (a recommendation with reasoning, not yet
agreed), **open** (genuinely undecided), and *(Joseph- please look at this)*
(ambiguities noticed while writing this up, with a proposed resolution).

---

## 1. The frame: every element is a hash and an array

The conversation started as an event-shape question ("what does a structured
attribute value emit?") and turned out to be a model question. The old spec
gloss — *"attributes are typed scalars"* plus the README's decision table
("can it be expressed as a typed scalar? then `:attribute`, else `|child`") —
is **XML residue**: XML is the *unusual* format in restricting named slots to
scalars. Every native data model (JSON, YAML, EDN, Lisp plists) lets map
values hold structure. The gloss was almost certainly an overzealous
agent-written generalization, not a design decision.

The truer frame, in Joseph's words: **an element automatically has a
hash-table and an array available.**

- **Attributes are the hash**: labeled edges, where the label is the
  *parent's* perspective ("my `address`", "my `headers`") — not the child's
  self-description. The label is *conserved*: a parent has one of each key,
  and its values accumulate under the already-ratified stacking rule, no
  matter how declarations interleave.
- **Children are the array**: positional, heterogeneous, self-named things.
  A child names *what it is*; an attribute names *what it is to me*.
  Forcing relationship-labels into child names (`|address` on a `|person`)
  conflates the edge with the node and pushes re-keying, dedup, and
  role-search work onto every consumer.

From this perspective, allowing only the array to hold elements is an
arbitrary restriction — the restriction the rest of this document removes.
In graph terms: **attributes are edges named from the parent; elements are
nodes; edges may terminate at leaf values or at nodes.**

One ordering rule relates the two collections and is already law:
hash-before-array (attributes before children).

**Consequences for teaching (settled-provisional):** the README table and
any spec language reframe from *"is it a scalar?"* to *"whose name is it?"*.

---

## 2. The model in five rules

A `:` anywhere enters attribute mode, and the line proceeds in a **uniform
scan**. The old block-vs-sameline attribute split largely dissolves; what
matters is *what the token after the key looks like*:

1. **Typed scalar** (`"…"`/`'…'`, number, `true`/`false`/`null`/`nil`,
   `[…]`, `<…>`) → that is the value — exactly one — and the scan
   continues: further `:attrs`, an `|element`, or a framed `;` comment may
   follow on the line. A prose-shaped token after a typed scalar is an
   **error** (the attribute has its one thing; nothing else on an
   attribute-rooted line can own prose). Deeper lines under a typed-scalar
   attribute are an **error** — except comments (§13.4).
2. **Bare word** → the value is **text**, and text is greedy: the rest of
   the line (the first line still honors the ratified sameline-comment
   frame) plus the whole deeper block — markers literal (§5).
3. **`|element`** → the value is **that node** — no anonymous wrapper; "the
   attribute *is* a veni-vidi-vici." The line continues inside the
   element's ordinary sameline grammar; deeper lines belong to it by the
   normal column rules (§6). Exactly one; a sibling second element at the
   same depth is an **error** ("attribute gets *one* child — stack
   `:alpha`s if you want more").
4. **Nothing** (EOL or comment) → boolean flag, `true` — *unless* a
   deeper-than-this-line block follows, which is form 2 or 3 in block
   position.
5. **`:another`** → the previous attribute was a flag; both true.
   (`:theta :omega` on one block line: theta=true, omega=true — legal
   precisely because the uniform scan replaced run-to-EOL.)

Multiplicity is always stacking; stacks are heterogeneous
(`:a 1` + `:a` ⟨node⟩ + `:a` ⟨text⟩ accumulate on one conserved key — a
labeled heterogeneous array, the mirror of the children array).

**Mnemonic that generates the whole grammar:** *key, then one value-shaped
thing, then the scan continues; prose requires an owner.*

---

## 3. First-character commitment (the typing rule)

Settled-provisional, and the piece that keeps the model honest to UDON's
syntactic-typing principle: **the first character of the value is the
commitment.**

- Digit / sign / quote / `<` / `[` first → a typed value. Two sub-cases:
  - *Within-token* failure (`:count 32849…098-to-1` — a hyphenated
    non-number) → falls through to **text**. Token-local; no lookahead
    beyond the token, which the parser already does today.
  - A **complete** scalar followed by a second bare token
    (`:count 599…e12 apples`) → **error**. The attribute has its value;
    no element on the line can own `apples`; and typing-by-initial-digit
    means we will not do unbounded lookahead to discover the author meant
    prose. The recommended spellings:

    ```
    |el :count "7 apples"        ; quote it
    |el :count \7 apples         ; or escape it — see §5.2
    ```

- Letter (or other non-committing) first → **text mode**, with the lone
  keyword carve-out: `true`/`false`/`null`/`nil` standing *alone* as the
  token are the typed boolean/nil (unchanged from today).

**The blessed asymmetry** (Joseph should confirm knowingly, it was chosen
not inherited): `:alpha true story` is the text `"true story"` (letters
don't commit; keyword only when alone), while `:count 7 apples` is an
error (digits commit). Rationale: prose that begins with a number-word is
common and forgivingly caught by quoting/escaping; prose beginning with a
lone keyword *intending* the keyword plus junk is not a real case. Digits
declare intent; letters are presumed prose.

---

## 4. Ownership: lines are rooted

The one place the uniform scan needs a distinction is *who owns the
value-shaped things on the line*, and it follows from the line's first
sigil:

- On an **element-rooted** line (`|el :a v |child …`), post-attribute
  elements are **children of the element** — the existing sameline
  sibling-scan, deliberately preserved (§6). Prose after the attrs is the
  element's child text (unchanged: `|el :beta 123 this is now child text`).
- On an **attribute-rooted** line (a block line beginning `:key`), there is
  no element on the line; the value-shaped thing after the key belongs to
  **the attribute**, per rules 1–3.
- Once an `|element` opens on either kind of line, **its scan owns the
  remainder** — subsequent `:attrs` on that line are the element's, its
  prose is the element's, exactly as sameline grammar always worked:

  ```
  |el |another :alpha <some val>
        :beta |the-beta-element?[123].super :a :b :c "value for c" this prose is text for the-beta-element
  ```

  Here `:beta` (deeper than `|another`'s line, before its children begin)
  is another attribute of `another`; beta's value is the full inline
  element with its identity, suffix, attrs, and trailing prose — all
  ordinary element grammar rooted in beta's value slot.

---

## 5. Text values

### 5.1 Greedy, uniform, markers literal

A text value takes the rest of its first line **plus the entire
deeper-than-the-attribute-line block**, as text:

```
:attribute-alpha Here is some
    of what I was talking about
    |discussion  That right there.
```

alpha's value is the three lines of text — `|discussion …` **is literal
text**, not an element. This is the same uniform-block shape as the
comment-continuation ruling (2026-07-15): once a block belongs to a text
container, everything deeper is that text. The author who wants structure
interleaved with prose has two one-character escapes: a real child element,
or stacked `:alpha` declarations.

Advisory warning on marker-looking lines inside text values lives at the
**AST layer**, per the warning-placement guideline (§12) — the event parser
would need extra lexical work to notice; the tree builder sees it for free.

Comments: the first line honors the ratified whitespace-framed sameline
comment (`:beta just some prose ; comment`); subsequent block lines follow
block-prose rules — `;` literal. (Settled-provisional, matches ratified
comment semantics exactly.)

Dedentation (leaning): text-value blocks use the ordinary prose machinery —
first deeper line sets the base, deeper-still keeps extra spaces,
shallower-but-still-deeper-than-the-attr warns and rebases. One mechanism,
already implemented, already specified.

*(Joseph- please look at this)* — **blank lines inside a text-value
block**: proposal — interior blank lines are preserved in the text (they're
content; round-trip fidelity, same posture as freeform), and the block ends
only at a line at-or-shallower-than the attribute's column. The alternative
(blank line terminates the value) makes multi-paragraph descriptions
impossible, which defeats a primary use.

*(Joseph- please look at this)* — **what opens a node vs. what is text**:
proposal — only `|element` as the first deeper thing opens a node value;
*everything* else (prose, and also fences, `!` directives, `@` references)
is text, markers literal. Uniform and simple. The tempting exception —  a
```` ``` ```` fence as a "verbatim value" — is already covered by text
values plus the `\` escape, and carving it in would reopen the
which-markers-count question we just closed twice for comments.

### 5.2 The value-position escape

`\` immediately in value position forces the value to text:

```
|el :count \7 apples          ; text "7 apples"
|el
  :count \7 apples            ; same
```

This is the **fourth positional use of `\`** and needs one spec sentence
distinguishing it from the *post-value scan* escape (ratified: `|el |a :v 1 \ tail`
forces the line-tail to element prose). Position disambiguates: value-expected
→ the attribute's text; scan position → the element's prose. Presumably the
value-position escape also implies the greedy deeper block (it's just text
mode with an explicit opener). (Leaning; wants Joseph's nod with the rest.)

---

## 6. Node values

Exactly one element, **no anonymous intermediary** — the attribute's value
*is* the element:

```
:attribute-beta
  |veni-vidi-vici :working 1234     ; beta IS a veni-vidi-vici
```

The disambiguating column rule — and the resolution of what looked like a
footgun — is that node values are **block-deeper-only**:

```
|el :alpha |child something        ; alpha = flag; child of el (sameline sugar)
|el :alpha
  |child something                 ; SAME — attr-line column ⇒ el's child
|el :alpha
      |child something             ; deeper than the attr line ⇒ alpha's node value
```

Sameline stays sibling-scan (nothing existing breaks; sugar stays sugar);
the *only* way to give an attribute a node is to indent past the
attribute's own line. The residual read-ambiguity (flag directly before an
inline element) is addressed socially by the `?` convention (§8), not by
new semantics.

Recursion inside the node is ordinary element parsing — attributes on
elements-within-attribute-values are attributes of that *element*, which was
never the problem. The problem case was only ever attributes hanging on
attributes:

```
:theta :first 1 :second 2     ; sameline: NO — under rule 5 this is
                              ; theta=true, then first=1, second=2 —
                              ; attributes of the PARENT, not of theta
:theta
   :first 1                   ; block: ERROR — "attribute value cannot be
   :second 2                  ; another attribute"
```

"A map with a key whose value is a key" stays out of the model. The
composite-key idea (`:theta` as a namespace for first/second) is **deferred
entirely** — the one-character fix is to name the thing that carries the
attributes (`:theta` + `|config :first 1 :second 2`), and if path-sugar
ever proves necessary it can arrive later as pure desugaring without
touching this model. Meanwhile `/`-in-identifiers (§9) gives conventional
namespacing today: `:address/street 123`.

A second sibling element at node-value depth is an **error** (Joseph,
explicitly: one child; stack the attribute). *(Joseph- please look at
this)* — error *recovery*: proposal — emit the Error event, then parse the
extra element as a stacked second value anyway (data preserved for tooling;
the document is still non-conformant). Alternative is to skip it; parsers
that recover-and-continue have served us well tonight.

---

## 7. Flags and the `?` convention

Valueless-attribute-=-true **stays** (rule 4). The case for removing it
evaporated when sameline kept sibling-scan — every formerly-ambiguous
composition is column- or scan-decided. What remains is a *human* reading
concern, and the lightest fix wins:

- **`?` becomes legal in attribute identifiers** (charset, §9), and
  `:alpha?` is a **naming convention** for boolean flags — no new core
  semantics. The key is literally `"alpha?"` (not sugar-stripped to
  `alpha`: stripping would silently merge the `:alpha?` and `:alpha`
  stacks, which is worse than the cosmetic duplication).
- Advisory warnings live at the **AST layer** per §12:
  - a valueless attribute whose key lacks `?` → "boolean flag without `?`"
  - a `?`-suffixed key carrying a non-boolean value
    (`:theta? a value`) → "`?`-key with text value"

```
|el :alpha? :beta? :theta "yes of course" We shall now see where our greek is
```

(Settled-provisional as convention-not-rule; Joseph floated both and the
convention reading was the lean.)

---

## 8. Typed values live on the map side — the recorded rationale

`<…>` is legal in attribute values and array items, and meaningless in
prose/child positions — now as a *reasoned* asymmetry, in Joseph's framing:

> Attributes keep track of the label from the parent perspective **and**
> its type, implicitly or (soon) explicitly. Children own their own
> semantics: consumers dispatch on what they detect, without knowing it
> beforehand.

A `<symbol: 'a-literal'>` floating in the children array would force every
consumer to type-sniff its own children — the thing the map side exists to
avoid. Types belong where labels belong. (This also retroactively grounds
the earlier envelope-in-array-items fixture ruling: arrays are attribute
values, i.e. map-side.)

---

## 9. Identifier charset expansion

Consolidated proposal (leaning, one ruling when taken):

| Charset | Today | Proposed |
|---|---|---|
| Element **names** | XID + `-` | + `/` (— but NOT `?!*+`: those stay element *suffixes*) |
| **Traits** | XID + `-` + `?!*+` (ratified) | + `/` |
| Attribute **keys** | XID + `-` | + `/` and `?!*+` (enables the `?` convention; symmetry with traits) |

`/` is conventional namespacing with zero core semantics
(`:address/street`, `|acme/widget`, `.acme/experimental`). No structural
conflicts found: no closing tags to match, values already tolerate `/`,
guards and references unaffected; the only soft caveat is dialect-side
expression languages wanting `/` as an operator someday (DYNAMICS uses
Liquid-style filters, so likely moot).

*(Joseph- please look at this)* — keys absorbing `?!*+` in the *continue*
set means `:a?b` is a legal (odd) key, same as traits today. Alternative:
allow `?` only terminally on keys. Proposal: full continue-set symmetry
with traits — one rule, and odd keys are the author's own taste.

---

## 10. Supersession ledger

Ratifying this model **knowingly supersedes**:

1. **The stranded-attribute Warning ruling (2026-07-14)** and its fixture:
   `:bttr 2 :cttr 3` becomes *two attributes*, working as visually
   expected — the uniform scan replaces run-to-EOL.
2. **Block-values-run-to-EOL** as a rule: replaced by first-character
   commitment + greedy text. (Bare-string values with spaces still work —
   they're text values — so the *examples* mostly survive; the *rule*
   changes.)
3. **"Attributes are typed scalars" / the README decision table**: reframed
   per §1.
4. **CORE "Complex Attribute Values"**: replaced by node values (§6) — the
   old section's *example* becomes valid under the new rules with deeper
   indentation, but its silent flag/structure conflation is gone.

And **preserves untouched**: sameline sibling-scan; valueless flags;
stacking uniformity and heterogeneity; attributes-before-children (the
phase rule); all column/hierarchy rules; the sameline-comment lexeme; both
2026-07-15 comment rulings; `$`-designated identity desugaring; the
duplicate-definition policy.

---

## 11. Event & parser implications (parked deliberately)

Recorded so the executing session doesn't re-derive; NOT part of the
ratification:

- **Dual-shape events**: scalar attributes keep `Attr` + value-event
  (zero churn to the existing fixture corpus). Node and text values get a
  bracket pair (working names `AttrStart`/`AttrEnd`) around ordinary
  element events / text lines. TreeStream treats the pair as a container —
  one arm each.
- **Timing**: flag-vs-block is decidable only at the next non-blank line's
  column, so a flag's `BoolTrue` defers by one line (streaming-honest:
  emit when decidable). Same shape as decisions the pushdown backend
  already handles.
- **AST**: `Value::Node(NodeId)` and `Value::Text(...)` join the Value
  enum; `attr("beta")` hands back the veni-vidi-vici directly — no wrapper
  to unwrap, honoring §6.
- The error cases (second sibling element; scalar-then-junk;
  attr-under-attr) want error *codes* and recovery shapes — design with
  the warning ledger (§12) in hand.

---

## 12. The warning-placement guideline (keeper, independent of the rest)

Joseph, verbatim intent: *if you have to do additional lexical/descent work
to get the warning you need, punt to the AST builder. If an event consumer
critically needs it, or the recursive parser already has what it needs
incidentally, stay in the grammar.* And: **keep a ledger** of which
warnings live at which layer.

Opening ledger entries:
- Grammar-level (incidental knowledge): inconsistent prose indentation
  (exists); past-base `\` (pending); scalar-then-junk error (§3).
- AST-level (needs the whole picture): marker-looking lines inside text
  values (§5.1); boolean-convention advisories (§7); flag-attribute
  followed by deeper comment attachment oddities.

This guideline belongs in `core/CLAUDE.md` when the model lands.

---

## 13. Collected open items

1. §3 asymmetry (`true story` text vs `7 apples` error) — bless knowingly.
2. §5.1 blank lines in text values *(Joseph- please look at this above)*.
3. §5.1 node-vs-text opener set *(Joseph- please look at this above)*.
4. §5.2 value-position escape — confirm the fourth escape position + its
   greedy-block behavior.
5. §6 second-element recovery shape *(Joseph- please look at this above)*.
6. §9 `?` placement in keys (terminal vs continue-set).
7. Flag + deeper comment: allowed, attachment semantics deliberately
   unspecified (Joseph) — needs one sentence when written into CORE so the
   non-specification is itself specified.
8. Sameline `:a` valueless at end of an element line followed by `|child` —
   flag + el's child (falls out of §4/§6, but deserves an explicit example
   in CORE because it's the composition people will worry about).

---

## Appendix: the session's examples, kept verbatim-ish

```
|parent
  :attribute-alpha Here is some
    of what I was talking about
    |discussion  That right there.        ; literal text inside alpha's value

  :attribute-beta
    |veni-vidi-vici :working 1234         ; beta IS a veni-vidi-vici

  :theta :first 1 :second 2               ; theta=true, first=1, second=2 (parent's)
  :theta
     :first 1                             ; ERROR — attr value can't be an attr

|el :alpha "only way to have spaces etc." :beta 123 this is now child text ; real sameline comment
|el
  :alpha in block mode quotes are implied ; text value; framed comment still real

|el
  :alpha
    |address                              ; alpha : node value
      ; ...

|el
  :alpha we should probably allow this off
    the bat already--- full prose mode as a 'text' type for :alpha

|el
  :alpha
    |address
    |another                              ; ERROR — one child; stack :alpha

|el |another :wolf sheep (this text is child of |another; no more attrs declarable)

|el |another :alpha <some val>
      :beta |the-beta-element?[123].super :a :b :c "value for c" this prose is text for the-beta-element
      :theta :omega                       ; theta=true omega=true (uniform scan)
      :omega <some-value>
         ; comment allowed here (attachment unspecified)
      :omega another value                ; heterogeneous stacking — valid
      :omega "and if I was to keep going" :beta |betas second value
                                                  whose prose is continuing right here...

|el
  :address/street  123                    ; conventional namespacing, no semantics
  :address/zip     94019

|el :alpha? :beta? :theta "yes of course" We shall now see where our greek is
```

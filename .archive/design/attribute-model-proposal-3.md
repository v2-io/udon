# Attribute model proposal 3 — binding dualism, flags, segment arrays

**Status:** DRAFT for review (2026-07-15/16). Not CORE.  
**Active carrier** for the attribute-model decision.  
**Substrate (decided model floor):**  
[`attribute-model-proposal-3-substrate.md`](attribute-model-proposal-3-substrate.md)  
— frame, binding dualism, prose-shaped text, segment arrays, flags, nodes,
scan, charset, warnings. This document is the **narrative + residual
editorial opens**; prefer the substrate for implementable decided rules.
Archaeology: `attribute-model-proposal-2-substrate.md`.

**Supersedes as active proposal prose:**  
[`attribute-model-proposal-2.md`](attribute-model-proposal-2.md) (keep as
archaeology). July-15 brainstorm:  
[`attribute-model-2026-07.md`](attribute-model-2026-07.md).

---

## 0. How to read this document

| Tag | Meaning |
|-----|---------|
| **[PROPOSED]** | Target CORE behavior if this draft is ratified |
| **[CURRENT 0.8]** | What CORE + today’s parser do now |
| **[OPEN]** | Still needs a call before CORE wording |

Examples are **[PROPOSED]** unless marked otherwise.

### 0.1 One-sentence thesis

**Plain attributes always take a value; flags are spelled `:key?`; trailing
text is a prose-shaped blob whose *owner* is decided by open attr vs
same-line element vs ordinary indent prose; multi-segment values under one
attr are heterogeneous arrays (like stacking), with a strong warning when a
finished value is extended by more same-line text (esp. block line — joining
onto the element line rebinds the tail).**

---

## 1. Semantic `?` and plain attributes

### 1.1 Plain attribute

**[PROPOSED]**

1. After `:key` (not a flag key — §1.2), expect **value material**.
2. Value material is one of substrate S3, or a **text blob** (§2), or a
   **deferred block** (§3).
3. Missing value with no deferred block → **error** `MissingAttributeValue`
   (name TBD) — not implicit boolean true.
4. After the value is *complete* in the sense of §2–§4, the scan continues
   for the appropriate owner.

**[CURRENT 0.8]** Valueless attr → `BoolTrue`.

### 1.2 Flag attribute (`:key?`)

**[PROPOSED]**

1. Key **ends with** `?` for flag behavior. Wire name includes `?` (not
   stripped). Keys may also contain `?` `*` `!` `+` and `/` unquoted
   (charset); only a **terminal** `?` selects flag semantics.
2. Next thing in value position:
   - exactly `true` / `false` / `null` / `nil` (alone) → that is the value;
   - **anything else** (including `|node`, bare words, `:next`, EOL, …) →
     value snaps to **`true`**, and that material is **re-owned** by the
     following scan (not the flag’s value).
3. After the flag is settled, further same-line structure is **not** the
   flag’s body.

```udon
|el :a? true it sure is true
; a? = true; el prose "it sure is true"

|el :a? well it sure is true
; a? = true; el prose "well it sure is true"

|el :a? |beta
; a? = true; |beta child of el

|el :a? false
; a? = false

|button :disabled? :type submit
; disabled? = true; type = submit
```

**[CURRENT 0.8]** No `?` in keys; valueless plain = true.

### 1.3 Plain sameline node binding

**[PROPOSED]** `|el :a |beta` → `a`’s value **is** the node `|beta` (no
block-deeper-only requirement).  
`|el :a? |beta` → flag true; `|beta` child of `el`.

**[CURRENT 0.8]** Both look like flag + child of `el`.

---

## 2. Trailing text blobs

### 2.1 What a text blob is

**[PROPOSED]** Trailing text (including text entered via value-position
`\`) is a **prose-shaped** stream:

- **Inline forms honored** (`|{…}`, `!{…}`, `;{…}`, and normal prose
  escapes for those openers) — same family as element prose, not a second
  “literal-only attr dialect.”
- On a **same-line** blob, a trailing **sameline comment** (` ; …`) is
  still a comment (ratified frame).
- At **0.8 / pre-dialect**, the event stream may emit a **sequence of
  segments** (Text, Interpolation, Embedded, …) under the attribute; hosts
  may flatten text-reducible segments later. Representation under one key
  is an **array of segments** when there is more than one piece (including
  pure multi-Text from line breaks) — same spirit as stacking and
  always-list `traits`.

**Sameline bare values and spaces:** a **mid-line** bare value (more attrs
still to the right) is a **scalar** — no unquoted spaces; quote if the
value needs spaces. **Unquoted multi-word text is only for the last**
trailing value material on the line (end-of-line open-attr text blob).
See substrate §S5.

**User guidance (non-normative):** prefer simple scalar shapes for
readability; mixing is allowed technically via arrays / stacking.

**Future footnote (non-normative):** an array of only text /
text-reducible segments may later be treated as a soft “kind” distinct
from a junk-drawer heterogeneous array — not required for 0.8.

### 2.2 Whose text is this?

**[PROPOSED]** When a text blob starts, choose an owner:

| Priority | Condition | Owner |
|----------|-----------|--------|
| 1 | An attribute to the left still **needs a value**, or is **collecting** segments (§2.3) | **That attribute’s value** (segment list / prose-shaped blob) |
| 2 | Else: nearest **element on the same line** to the left | **Child text** of that element (sameline decompress — attrs phase ends for this line’s tail) |
| 3 | Else | **Ordinary indent/dedent ownership** — child prose of whoever owns that column (standard UDON). **Not an error.** |

Row 3 is normal document prose (the most basic case). There is no
“indent-only prose is illegal” rule.

**Sameline decompress:** after attrs on an element line, trailing text is
that element’s content as if the indent continued under it.

### 2.3 Finished value + more same-line text → warn + segment array

**[PROPOSED]** After an attribute already has a **finished** first value
(any kind: quoted string, number, `<…>`, array, node, …), **more same-line
trailing text** is:

1. **Ingested** as **additional segment(s)** of the **same attribute’s**
   value array (equivalent to an explicit list of those pieces), and
2. Accompanied by a **strong warning**
   (`AttributeValueExtendedByTrailingText` — name TBD).

**Any** finished first piece + trailing text uses this rule (not only
string+text).

**Equivalence:**

```udon
|el
  :attr "first" and here's another one
```

ingests as:

```udon
|el
  :attr ["first" "and here's another one"]
```

plus the warning.

```udon
|el
  :when <7:02pm> and more words
; WARN + when ≈ [<7:02pm>, text "and more words"]
```

**Why warn:** if the author **moves this attr onto the element’s line**,
meaning **changes**:

```udon
|el :attr "first" and here's another one
; attr = "first" only; "and here's another one" is child prose of |el
; (§2.2 row 2 — same-line element). Not a segment array on the attr.
```

The warning is: “legal array extension on the block line; **backspacing /
joining onto the element line rebinds the tail as element prose**.”

### 2.4 Deeper text / second value after a finished value

**[PROPOSED]** Same policy as multi-value elsewhere (stacking spirit):

```udon
|el
  :but-this-one <7:02pm>
    extra deeper text
```

Finished value, then **deeper** material that would be a **second value**
without a new `:key` → **strong warning** + still **ingest as another
segment / implicit array member** (same as second node at value depth —
§4). Not silent drop.

(If the author wanted a second declaration, they write another `:key`.)

### 2.5 Deferred block (multi-line by shape)

**[PROPOSED]** If the key line ends with **no finished value** (EOL after
`:key`, or value-`\` opens text — §2.6):

```udon
|el
  :note
    first line
    second line
```

Deeper lines are the value body. Sequential text lines (including blank
lines between them) use ordinary **indent/dedent / content-base** rules —
**no new blank-line complication**: blanks are preserved as part of the
text stream / multi-Text segments the same way prose blocks already work.
Naive hosts may concat.

### 2.6 Value-position `\`

**[PROPOSED]** `\` in value-expected position enters text mode (substrate
S6). **First-line extent = rest of the physical line**, and that line does
**not** get the special sameline-comment affordance: a ` ;` on that line is
**literal text** (or ordinary `;` in the blob), not a parsed sameline
comment. (Sameline comments remain available on normal open-attr trailing
text without value-`\`.)

### 2.7 Open attr + trailing text (clear value)

**[PROPOSED]**

```udon
|el
  :this-one-is-ok-too because this text clearly is the value for the attribute ; comment
```

Open attr needs value → trailing text **is** the value; sameline comment
OK. No “extension” warning (value was not finished before the text started).

```udon
|el
  :also this one
    continued deeper
```

Open attr; first-line text + deeper text = one multi-line text value
(segments array). Good.

---

## 3. Worked demo (Joseph)

```udon
|e :attr v |child
             :another-attr?

             :and-another-one [1 <u64:123>] :this-one-is-ok-too because this text clearly is the value for the attribute ; and this is a comment

             :also this one
                this form is just as good and should be allowed under the
                premise that multiple sequential texts are equivalent to their concatenation

             :but-this-one <7:02pm>
               ; finished value + deeper second value → strong WARN + array segment
               extra deeper text

             :this-one-though <1M> and here is some dangling text ; strong WARN + segment array
                                                                  ; (join onto element line would rebind tail as prose)
             This text is unambiguously a child of child.
   :this will get a warning but is normal text because additional attributes for |e were foreclosed when |child changed the phase to children...
   And thisHere's the thing about that child that just got defined... This is unambiguously its text...
```

| Construct | **[PROPOSED]** |
|-----------|----------------|
| `\|e :attr v \|child` | `e`; `attr`=`v`; `child` under `e` |
| `:another-attr?` | flag true on `child` |
| `:and-another-one […] :this-one-is-ok-too because… ; comment` | array value finished; open attr gets trailing text value; comment OK |
| `:also this one` + deeper lines | multi-line text value (segments) |
| `:but-this-one <…>` + deeper text | **§2.4** — **strong warn** + ingest as further segment / array member |
| `:this-one-though <1M> and here is some dangling text` | **§2.3** — **strong warn** + value ≈ `[<1M>, text "and here…"]` (not silent child prose of `child`) |
| Pure prose line under `child` | child prose |
| `:this will get a warning…` at `e`’s child column after phase change | **warning**; treat as **prose** of `e` (attrs of `e` foreclosed when `\|child` opened children phase) |
| Further prose at child indent | child prose |

**Contrast — block extension vs sameline (the warn pair):**

```udon
|e
  :attr "first" and here's another one
; WARN + attr ≈ ["first", "and here's another one"]

|e :attr "first" and here's another one
; attr = "first"; "and here's another one" is child prose of |e
; (same-line element — §2.2 row 2). Moving the block form here changes meaning.
```

---

## 4. Uniform scan, multi-attr lines, second values

**[PROPOSED]** After a **finished** value, `:next` starts another attribute
of the **current owner** (parent element, or node if inside a node value):

```udon
|el :first value :another with some text
; first  => "value"              (mid-line bare scalar — no spaces)
; another => "with some text"  (end of line — unquoted spaces OK)
; model: <|el>{ first: "value", another: "with some text" }

|el :first "sorry, got to quote" :second but not this one necessarily...
; first  => "sorry, got to quote"   (mid-line scalar with spaces → quotes)
; second => "but not this one necessarily..."  (end of line)

|el :first value :another "with" some text
; first   => "value"
; another => "with"            (finished quoted string)
; "some text" => child prose of |el   (§2.2 row 2 — same-line element)
```

```udon
|el
  :a 1 :b 2
; a=1; b=2

|el :a |node :k "v" more
; a = node; node has :k = "v"; "more" is node prose (inside node scan)
```

**Second node at value depth** (and deeper second values generally):
**strong warning** + still **ingest as another array member** under that
key (implicit array / stacking spirit) — not drop, not hard-fail-only.

**[CURRENT 0.8]** Block run-to-EOL can swallow `:b 2` into one bare string.

---

## 5. Phase change and late `:`

**[PROPOSED]** Unchanged CORE spirit, made explicit with the demo:

Once an element has entered **children** phase (e.g. a child element
appeared), a later line-initial `:` at a column that would have been an
attr of an *ancestor* is **not** that ancestor’s attribute — it is prose
(or structure of whoever owns that column), with a **warning**
(attr-looking after phase foreclosure).

---

## 6. Event / AST sketch (implementation note)

Not CORE prose; for implementers:

> **Superseded 2026-07-16 by the ratified flat stacking wire** (CORE "Event
> Encoding (0.9 Wire)"): no `AttrStart`/`AttrEnd`; every `Attr` carries one
> value; all multiplicity = re-emitted `Attr`. Kept as archaeology.

1. **Attr container:** scalar stay `Attr` + one value event when simple.
2. **Segment array:** when a key has multiple segments (stacking, §2.3
   extension, multi-line text, inline forms inside a text blob), emit
   `AttrStart` / segment events / `AttrEnd` (names TBD) or equivalent
   ordered multi-value under one key — same host view as stacking.
3. **Flags:** `BoolTrue` / `BoolFalse` / `Nil` as today for settled flags.
4. **Warning codes (sketch):**  
   - `AttributeValueExtendedByTrailingText` — §2.3 (finished + same-line tail)  
   - `SecondAttributeValue` — §2.4 / second node (strong warn + still ingest)  
   - phase-late attr-looking prose — warn only, pull in as normal text

---

## 7. Supersession (proposal 3 + substrate)

Ratifying substrate + this proposal into CORE knowingly supersedes:

1. Implicit valueless = true (except via `:key?` or explicit true).
2. Sameline sibling-scan after **plain** `:a |beta` (becomes node value).
3. Block-deeper-only for node values.
4. Run-to-EOL as the only block-attr story (uniform scan + binding dualism).
5. “Attributes are only scalars” gloss.
6. Proposal-2 “identical both roots, parent always owns tail” over-unification.
7. Proposal-era “attr text is fully literal / no inline forms” as a hard
   rule — replaced by prose-shaped blobs + segment arrays.

**Preserves:** stacking; attrs-before-children; hierarchy; sameline
comments; identity `$` sugar; core scalars; `<…>` interim; substrate frame.

---

## 8. Migration notes

| Old habit | New |
|-----------|-----|
| `:disabled` flag | `:disabled?` or `:disabled true` |
| `\|el :a \|b` meaning child | write `:a? \|b` for flag+child; plain `:a \|b` means node value |
| Mid-line scalar with spaces | **quote** it; unquoted multi-word text only at **end of line** |
| Block `:attr "x" more` | strong **warn** + segment array; or quote all / deferred block |

---

## 9. Open items (proposal 3 only)

Most prior P3-* items are **decided** (this pass). Residual:

| ID | Issue | Status |
|----|--------|--------|
| P3-6 | Block `!directive` as attr node value | **Defer to DYNAMICS** |
| P3-7 names | Exact warning **code** strings in CORE table | Editorial at promotion — behaviors decided (§2.3/§2.4 warn+ingest; phase-late `:` warn-only, pull in as normal text) |

**Closed this pass:**

| ID | Decision |
|----|----------|
| P3-1 | Any finished value + same-line trailing text → segment array + strong warn |
| P3-2 | Withdrawn — indent prose is normal UDON (§2.2 row 3), not an error |
| P3-3 | Value-`\`: rest of line; **no** sameline-comment special-case on that line |
| P3-4 | Second value/node: strong warn + ingest as array member |
| P3-5 | Terminal `?` = flag behavior; `?` `*` `!` `+` `/` allowed in keys unquoted |
| P3-8 | Blank lines: ordinary indent/prose rules; no new complication |

---

## 10. Appendix — short [PROPOSED] gallery

```udon
; flags
|el :ready? :count 3
|el :ready? false

; multi-attr: mid-line bare scalar (quote if spaces); end-of-line text may have spaces
|el :first value :another with some text
; first => "value"; another => "with some text"

|el :first "sorry, got to quote" :second but not this one necessarily...
; first => "sorry, got to quote"; second => "but not this one necessarily..."

; finished quote then el prose
|el :first value :another "with" some text
; first => "value"; another => "with"; el prose "some text"

; plain node value (sameline)
|api :headers |header :name Content-Type :value application/json

; open attr + trailing text + sameline comment
|el
  :title The full title goes here ; TODO

; finished + trailing on BLOCK line → strong WARN + segment array
|el
  :attr "first" and here's another one
; ≈ :attr ["first" "and here's another one"] + WARN

; same shape on ELEMENT line → different meaning
|el :attr "first" and here's another one
; attr="first"; el prose "and here's another one"

; deferred multi-line text (blanks OK under normal indent rules)
|el
  :body
    line one

    line two with |{em emphasis}

; finished + deeper second value → strong WARN + array segment
|el
  :when <7:02pm>
    extra

; finished + same-line trailing on block line → strong WARN + array
|el
  :when <1M> and dangling
```

---

## 11. Ratification path

1. Residual: P3-6 defer; P3-7 code names at CORE promotion.  
2. Promote substrate + this proposal into CORE Attributes.  
3. Fixtures: fill `events: []` only after wording lands.  
4. Grammar: `?` keys; plain missing value; sameline node value; §2.2–2.4;
   segment arrays + warns.  
5. Keep proposal-2 as archaeology.

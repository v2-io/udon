# Attribute model — substrate (proposal 3)

**Companion to** [`attribute-model-proposal-3.md`](attribute-model-proposal-3.md)
(binding narrative, residual editorial opens).  
**Archaeology:** [`attribute-model-proposal-2-substrate.md`](attribute-model-proposal-2-substrate.md)
(pre–proposal-3; **do not use** — literal-only text, “parent owns both roots,”
hard second-node error are out of date).

**Status:** Decided model substrate for CORE, aligned with proposal 3
rulings. Residual items that remain only editorial or deferred (warning
*code names*, block `!directive` as value → DYNAMICS) are noted at the end;
they are not open model forks.

Registers:

| Tag | Meaning |
|-----|---------|
| **[PROPOSED]** | Target CORE under proposal 3 + this substrate |
| **[CURRENT 0.8]** | Contrast only |

---

## S1. Frame: hash and array

**[PROPOSED]** An element automatically has a **hash** and an **array**:

- **Attributes (hash):** labeled edges from the *parent’s* perspective.
  Labels are conserved. Values under one key **stack** (order preserved;
  heterogeneous) — including multi-segment values produced by one
  declaration (§S5, §S6).
- **Children (array):** positional, heterogeneous, self-named. A child
  names *what it is*; an attribute names *what it is to me*.

In graph terms: **attributes are edges; elements are nodes; edges may
terminate at leaf values, nodes, or ordered value arrays.** Restricting
attributes to scalars was XML residue.

**Teaching:** not “scalar → attr / structure → child,” but **whose name is
it?**

**Already law (unchanged):** attributes before children (phase rule);
column hierarchy (`pop while col ≤ base`); sameline-comment lexeme;
identity `$` sugar; core bare scalars; `<…>` interim envelope.

---

## S2. Uniform scan

**[PROPOSED]** A `:` enters attribute mode. After each key, the parser
collects that attribute’s **value material** (possibly multi-segment —
§S5–S6), then the scan continues for the **current owner** (parent element,
or the interior of an open node value).

```udon
|el :first value :another with some text
; first  => "value"
; another => "with some text"
```

```udon
|el
  :a 1 :b 2
; a=1; b=2   (not run-to-EOL swallow of ":b 2")
```

**[CURRENT 0.8]** Block bare values often run to EOL (one string).

**Mnemonic:** *key, then value material (possibly multi-segment), then
continue; every text blob needs an owner (§S4).*

---

## S3. Value taxonomy

**[PROPOSED]** A value is one of, or an **ordered array of**, these kinds:

| Kind | Forms |
|------|--------|
| **Scalar** | quoted string, number, `true`/`false`/`null`/`nil` alone, `[…]` list, `<…>` envelope |
| **Reference** | `@…` (selector; inert at core) |
| **Interpolation** | `!{{…}}` |
| **Node** | `\|element`, `!:lang:` raw, freeform `` ``` `` (once accepted as the value) |
| **Text blob** | prose-shaped stream (§S5) |

**Attributes do not get their own map** (no attr-under-attr hash nesting).
Maps-of-maps use a **node** value:

```udon
:theta
  |config :first 1 :second 2
```

**Types live on the map side** (attr values / array items). `<…>` is
meaningful in value position.

**`@` as attribute value** is first-class (parent labels what the pointer
is *to it*).

**Block `!directive` as node value:** deferred to DYNAMICS (not in this
substrate).

---

## S4. Whose text is this? (binding)

**[PROPOSED]** When a **text blob** starts, ownership is:

| Priority | Condition | Owner |
|----------|-----------|--------|
| 1 | Attribute to the left still **needs a value**, or is **collecting** segments (§S6) | That attribute’s value |
| 2 | Else: nearest **element on the same line** to the left | **Child text** of that element (sameline decompress) |
| 3 | Else | **Ordinary indent/dedent** — prose of whoever owns that column (standard UDON). Not an error. |

**Sameline decompress:** after attrs on an element line, trailing text is
that element’s content (attrs phase ends for this line’s tail).

```udon
|el :attr "first" and here's another one
; attr = "first"; "and here's another one" is child prose of |el  (row 2)
```

```udon
|el
  :title The full title goes here ; TODO
; open attr → trailing text is the value; sameline comment OK  (row 1)
```

---

## S5. Text blobs (prose-shaped)

**[PROPOSED]** Attribute (and element) text blobs are **prose-shaped**:

- **Inline forms honored:** `|{…}`, `!{…}`, `;{…}`, with normal prose
  escapes for those openers (same family as element prose).
- **Not** a separate “literal-only attr dialect” (that was a rejected
  intermediate draft).
- Same-line trailing **sameline comment** (` ; …`) is a comment **except**
  on value-position `\` lines (§S8).
- At 0.8 / pre-dialect, events may be a **sequence of segments** (Text,
  Interpolation, Embedded, …) under one attribute key. Hosts may flatten
  text-reducible segments later.

**Sameline bare values and spaces (critical):**

On an **element-rooted same line**:

- A **mid-line** bare value (more attributes still to the right) is a
  **scalar**: no unquoted spaces. If the value needs spaces, **quote** it.
- **Only at the end of the line** may unquoted multi-word text appear —
  the last open attr’s trailing text blob (rest of line).

```udon
|el :first value :another with some text
; first  => "value"              (mid-line bare scalar — no spaces)
; another => "with some text"  (end of line — unquoted spaces OK)

|el :first "sorry, got to quote" :second but not this one necessarily...
; first  => "sorry, got to quote"   (mid-line scalar with spaces → quotes)
; second => "but not this one necessarily..."  (end of line)

; NOT a mid-line bare scalar with spaces:
; |el :first value with spaces :another x
; "value" finishes first as a bare scalar; "with spaces" starts el prose
; (attrs phase ends) — :another is not a second attr.
```

There is **no** general “quote-optional spaces on sameline” except
**at the end of the line**.

**User guidance (non-normative):** prefer simple shapes; mixing is allowed
via segments / stacking.

**Future footnote (non-normative):** arrays of only text /
text-reducible segments may later be a soft “kind” distinct from mixed
junk-drawer arrays.

**Multi-line / blanks:** ordinary indent, dedent, and content-base rules —
no special blank-line policy. Sequential text lines under one open text
value are multi-Text / concat-equivalent.

---

## S6. Multi-segment values (stacking spirit)

**[PROPOSED]** One key may hold an **ordered array** of value pieces:

### S6.1 Explicit stacking

Repeated `:key` declarations stack (already CORE).

### S6.2 Finished value + more same-line trailing text

After a **finished** first value (any kind), more same-line trailing text:

1. Is **ingested** as further segment(s) of the **same** key’s value array  
   (equivalent to e.g. `:attr ["first" "and here's another one"]`), and  
2. Emits a **strong warning** (`AttributeValueExtendedByTrailingText` —
   final code name at CORE promotion).

```udon
|el
  :attr "first" and here's another one
; WARN + attr ≈ ["first", "and here's another one"]
```

**Why warn:** joining onto the element line **changes** meaning:

```udon
|el :attr "first" and here's another one
; attr="first"; el prose "and here's another one"  — not a segment array
```

### S6.3 Second value / node without a new `:key`

Finished value, then **deeper** material (or a second sibling node at value
depth) that would be another value without a new `:key`:

- **Strong warning**, and  
- Still **ingest** as another array member (implicit array / stacking
  spirit) — not silent drop.

```udon
|el
  :when <7:02pm>
    extra deeper text
; WARN + when ≈ [<7:02pm>, text "extra deeper text"]
```

To declare a second value deliberately, write another `:key`.

### S6.4 “Exactly one node” as authoring default

**[PROPOSED]** Preferred shape is **one** node value per declaration (no
anonymous wrapper — the attr *is* that node). A **second** sibling node at
the same value depth is the S6.3 case (warn + array), not a hard reject
without ingest.

---

## S7. Flags (`:key?`)

**[PROPOSED]**

1. **Terminal `?`** on the key selects flag semantics. Wire name includes
   `?` (not stripped). Keys may contain `?` `*` `!` `+` `/` unquoted;
   only **terminal** `?` is the flag marker.
2. Next in value position:
   - `true` / `false` / `null` / `nil` alone → that value;
   - **anything else** → flag = **`true`**, material **re-owned** by the
     following scan (not the flag’s body).
3. After the flag is settled, further same-line structure is not the flag’s
   value.

```udon
|el :a? |beta
; a? = true; |beta child of el

|el :a? well it sure is true
; a? = true; el prose "well it sure is true"
```

**Plain attrs** never use implicit valueless true — missing value without a
deferred body → **error** `MissingAttributeValue` (name TBD).

---

## S8. Value-position `\`

**[PROPOSED]** `\` in **value-expected** position (plain attr still needs a
value; no value token started):

- Consumed; enters **text** mode (§S5).
- **First-line extent = rest of the physical line.**
- That line does **not** get the special **sameline-comment** affordance:
  ` ;` is not a parsed sameline comment there (literal / part of the blob
  rules as ordinary text).

Distinct from:

- head-position `\` → force line to prose (CORE);
- mid-**prose** `\` before `|{` / `!{` / `;{` → escape opener (CORE;
  applies inside prose-shaped blobs too);
- post-value scan on an **element line** after a finished value → row 2
  ownership (el prose), not a fourth inventiveness.

---

## S9. Nodes as attribute values

**[PROPOSED]**

1. **Plain** `:a |beta` (sameline) → `a`’s value **is** `|beta` (no
   block-deeper-only requirement).
2. **Flag** `:a? |beta` → `a?` true; `|beta` child of the element.
3. Once a node is **accepted** as an attribute value, **its scan owns its
   interior** (attrs, prose, children).

```udon
|el :a |the-node :k "v" more
; a = the-node; k="v"; "more" is prose of the-node
```

4. **No attr-under-attr maps** — deeper `:key` under an attr that is not
   inside a node value is an error (“attribute value cannot be another
   attribute”). Use a node carrier.

---

## S10. Deferred block (multi-line by shape)

**[PROPOSED]** Key line ends with no finished value (EOL after `:key`, or
value-`\` opening text open for continuation) → deeper lines are the value
body under ordinary indent/dedent. Blanks preserved per normal prose rules.

```udon
|el
  :body
    line one

    line two with |{em emphasis}
```

---

## S11. First-character commitment (typed path)

**[PROPOSED]** For bare material starting a **typed** value:

| First character | Path |
|-----------------|------|
| Digit, sign, `"`, `'`, `<`, `[` | Typed scalar path |
| Letter / other | Text-blob path (§S5), unless keyword alone |

1. Within-token failure on typed path → fall through to text (token-local).
2. Keywords `true`/`false`/`null`/`nil` typed only as the **entire** first
   finished token.
3. After a **finished** typed/quoted/keyword value, further same-line bare
   text is **not** “scalar forbids words” — ownership is §S4 / §S6.2
   (element-line decompress vs block-line segment extension + warn).

```udon
|el :count 7 apples
; count=7; "apples" is el prose (§S4 row 2) — 7 finished; not mid-line bare text

|el
  :count 7 apples
; WARN + count ≈ [7, text "apples"]  (§S6.2)

|el :count 7 :more x
; count=7; more="x"  — after finished typed value, :more starts next attr
```

---

## S12. Phase change and late `:`

**[PROPOSED]** Once an element has entered **children** phase, a later
line-initial `:` that would have been an attribute of an *ancestor* is
**not** that attribute — treat as **normal text/prose** of whoever owns the
column, with a **warning only** (attr-looking after phase foreclosure).

---

## S13. Identifier charset

**[PROPOSED]**

| Charset | Rule |
|---------|------|
| Element **names** | XID + `-` + `/` — **not** `?!*+` as name continue (those remain element *suffixes*) |
| **Traits** | XID + `-` + `?!*+` + `/` |
| Attribute **keys** | XID + `-` + `/` + `?!*+` unquoted; **terminal `?`** = flag semantics (§S7) |

`/` is conventional namespacing with **zero** core semantics.

---

## S14. Warning-placement guideline

**[PROPOSED]** (Joseph’s rule, independent of flag policy):

> If you need extra lexical/descent work only to emit a warning, put it on
> the **AST** builder. If an event consumer critically needs it, or the
> recursive parser already has the fact incidentally, keep it in the
> **grammar**. Keep a ledger of codes per layer.

| Layer | Behaviors (codes named at CORE promotion) |
|-------|-------------------------------------------|
| Grammar | `InconsistentIndentation`; missing plain-attr value **error**; … |
| Grammar or AST | §S6.2 trailing-text extension **strong warn**; §S6.3 second value **strong warn**; phase-late `:` **warn** |
| AST | Optional marker-looking advisories inside long text, etc. |

Past-base `\` → `EscapeOutsideHeadPosition` at AST (already ratified in CORE
posture).

---

## S15. Event / AST sketch (non-normative)

- Simple single-segment scalar: `Attr` + one value event (low churn).
- Multi-segment / stacking / inline-in-text: ordered multi-value under one
  key (`AttrStart`…`AttrEnd` or equivalent).
- `Value::Node`, segment arrays; `attr("k")` / `attr_all("k")` host views.
- Flags: `BoolTrue` / `BoolFalse` / `Nil` when settled.

---

## S16. Supersession (substrate 3)

Ratifying this substrate (with proposal 3 narrative) supersedes:

1. Implicit valueless = true (except `:key?` / explicit true/false/nil).
2. Sameline sibling-scan after plain `:a |beta`.
3. Block-deeper-only node values.
4. Run-to-EOL as the sole block-attr rule.
5. “Attributes are only scalars.”
6. “Attr text is fully literal / no inline forms.”
7. “Parent always owns tail on both roots” (proposal-2 over-unification).
8. Hard fail without ingest for second value/node (now warn + array).

**Preserves:** stacking; attrs-before-children; hierarchy; sameline
comments (except value-`\` lines); identity `$` sugar; core scalars; `<…>`
interim.

---

## S17. Residual (not model forks)

| Item | Disposition |
|------|-------------|
| Warning **code** exact strings | Editorial when writing CORE table |
| Block `!directive` as attr node value | Defer to DYNAMICS |
| Host API names (`attr` / `attr_all`) | Implementation |

---

## S18. Cross-check examples (decided shapes)

```udon
|el :first value :another with some text
; first=>"value" (mid-line bare scalar); another=>"with some text" (end of line)

|el :first "sorry, got to quote" :second but not this one necessarily...
; first quoted mid-line scalar; second end-of-line trailing text with spaces

|el :first value :another "with" some text
; first=>"value"; another=>"with"; el prose "some text"

|el
  :attr "first" and here's another one
; WARN + ["first", "and here's another one"]

|el :attr "first" and here's another one
; attr="first"; el prose "and here's another one"

|el :a |beta
; a is the node beta

|el :a? |beta
; a?=true; beta child of el

|el
  :when <1M> and dangling
; WARN + [<1M>, text "and dangling"]
```

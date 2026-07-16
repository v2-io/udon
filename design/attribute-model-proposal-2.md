# Attribute model proposal 2 — semantic `?` and unified binding

> **Superseded as active carrier by
> [`attribute-model-proposal-3.md`](attribute-model-proposal-3.md).**  
> Archaeology only — intermediate drafts (over-unified tails, greedy text).

**Status:** ARCHIVES. Substrate still decided:
[`attribute-model-proposal-2-substrate.md`](attribute-model-proposal-2-substrate.md).

---

## 0. How to read this document

### 0.1 Example and claim tags

Every behavioral claim and example is tagged. Do not mix registers.

| Tag | Meaning |
|-----|---------|
| **[PROPOSED]** | Desired settled CORE behavior **if this proposal is ratified** |
| **[CURRENT 0.8]** | What CORE + today’s event parser actually do now |
| **[FORK NOT TAKEN]** | The design-v1 path: implicit valueless=`true` + sameline sibling-scan + block-deeper-only node values + `?` as *convention only*. Documented only for contrast. |
| **[OPEN]** | Still needs Joseph / a ruling before CORE wording |

### 0.2 The load-bearing switch (this proposal’s thesis)

**[PROPOSED]** Trade away **implicit valueless = true**.

| Kind of key | After the key |
|-------------|---------------|
| **Plain** `:key` | Always takes **exactly one** value-shaped thing (substrate S3). Missing value → **error** (or deferred deeper block — §3). |
| **Flag** `:key?` | Key is literally `"key?"`. Valueless → boolean **true**. Remainder of the parent scan does **not** bind to this attr. Explicit `true` / `false` / `nil` allowed. |

Consequence for the headline composition:

```
|alpha :a |beta
|alpha :a? |beta
```

| Spelling | **[PROPOSED]** | **[CURRENT 0.8]** | **[FORK NOT TAKEN]** (design v1) |
|----------|----------------|-------------------|----------------------------------|
| `\|alpha :a \|beta` | `a`’s value **is** `\|beta` | `a`=true; `\|beta` child of `alpha` | same as current (sibling-scan) |
| `\|alpha :a? \|beta` | `a?`=true; `\|beta` child of `alpha` | `a?` is bare text key or odd parse (no `?` in keys yet) | `a?` convention flag; `\|beta` child of `alpha` |

**Only** the `?` form still cares that the line is element-rooted when the
next thing is a node: the flag is done; the node attaches to the **parent**.
Plain `:a` never has that split — sameline and attribute-rooted use the
**same** binding rule.

### 0.3 Why now

1. Binding dualism (sameline sibling-scan vs block-deeper-only) is the main
   cost of keeping implicit true; the rest of the model shrinks if we drop it.
2. Late migration of every silent flag in the corpus is expensive; agents
   mint `:disabled`-style flags freely under **[CURRENT 0.8]**.
3. Map-valued attributes are the point of the redesign; `|alpha :a |beta`
   should read as a map edge, not as HTML-ish flag + free child.

---

## 1. Normative rules (proposed CORE)

These are the complete binding rules under the switch. Substrate supplies
value taxonomy, text greediness, one-node-per-declaration, no attr-under-attr,
line-rooting interior, etc.

### 1.1 Plain attribute

**[PROPOSED]**

1. After `:key` (key does **not** end with `?` as the flag marker — see §1.3),
   the parser expects **exactly one** value-shaped thing (substrate S3).
2. That thing is the attribute’s value — on **element-rooted** and
   **attribute-rooted** lines alike.
3. Value-shaped includes: scalar, `@ref`, `!{{…}}`, `|element`, `!:lang:`,
   freeform fence, or bare text (extent **[OPEN]** §1.6).
4. After the value is complete, the scan continues for the **current owner**
   (parent element, or the node if the value was a node whose scan is still
   open — substrate S8).
5. If no value is available on the key line and no **deferred block**
   (§1.6.0) supplies one → **error** `MissingAttributeValue` (name TBD),
   not boolean true.

**Deferred block (value after the key line):** if the plain key is followed
by EOL (or only a sameline comment), look at the next **non-blank** line:

- deeper than the attribute’s column → that block is the value (text or
  one node / raw / fence per first opener — details §1.6);
- at or shallower → **error** (missing value).

Blank lines between the key line and the value block are decoration and are
skipped for the binding decision (blank-inside-text still **[OPEN]** P2-11).

### 1.2 Flag attribute (`?`)

**[PROPOSED]**

1. A key that is spelled with a **flag marker** `?` (see §1.3) is a **flag
   attribute**. The wire key is the full spelling (e.g. `"disabled?"`),
   **not** stripped to `"disabled"`.
2. **Value rule (bool only, with default true):** after the flag key, look at
   the next token in value position (if any):
   - If it is exactly the keyword **`true`**, **`false`**, or **`null`/`nil`**
     (alone as that token) → that is the attribute’s value.
   - **Anything else** — including `|node`, `@ref`, bare words, `"…"`,
     another `:attr`, or end of the binding window — does **not** bind as the
     flag’s value. The flag is set to **`true`**, and that material is
     **re-owned by the parent scan** (element prose, child node, next attr, …).

```udon
|el :a? true it sure is true
; a? = true; el.children prose starts "it sure is true"

|el :a? well it sure is true
; a? = true  ("well" is not true/false/nil → default true, parent owns "well…")
; el.children prose starts "well it sure is true"

|el :a? |beta
; a? = true; |beta is child of el   — NOT an error, NOT a's node value

|el :a? false
; a? = false

|el :a? :type submit
; a? = true; type = submit

|button :disabled? :type submit
; disabled? = true; type = submit
```

There is **no** error class “non-boolean value on `?`-key” that swallows
`|node` or prose into the flag. Non-bool material never *is* the flag’s
value; the flag snaps to `true` and parsing proceeds.

### 1.3 What counts as a flag key

**[PROPOSED]** Minimal rule sufficient for the switch:

- An attribute key whose **final character** is `?` is a flag key.
- The key string includes the `?`.

**[OPEN]** Interaction with substrate S10 if `?!*+` are full continue-set:
`:a?b` would be a single key `"a?b"` (not a flag unless we define flag as
“ends with ?”). Terminal-`?` definition stays clear: flag iff key ends with
`?`. Prefer defining flag as **ends with `?`** regardless of continue-set.

**[PROPOSED]** Element suffixes (`|field?` → `:'$?' true`) are **unchanged**
and unrelated: different position, different desugar. Teaching note only.

### 1.4 Uniform multi-attr lines

**[PROPOSED]** Under uniform scan + semantic `?`:

```
:theta? :first 1 :second 2
; theta? = true; first = 1; second = 2  (all on parent)
```

```
:plain |node :after 1
; plain's value is |node; :after is attribute of |node (node owns scan)
```

```
:plain 1 :other 2
; plain = 1; other = 2
```

```
:plain :other 2
; ERROR on plain (missing value); other = 2  [recovery: continue]
```

**[FORK NOT TAKEN]** treated `:theta :first 1` as theta=true, first=1 without
errors on plain keys.

**[CURRENT 0.8]** block line `:theta :first 1` is one bare value
`" :first 1"` or similar run-to-EOL swallow.

### 1.5 One node; stack to repeat

**[PROPOSED]** (substrate S7, restated in binding context)

```
|el
  :a
    |one
    |two          ; ERROR — second node at value depth; stack :a instead
```

```
|el
  :a |one
  :a |two         ; OK — stacked values on key "a"
```

### 1.6 Text-value **extent** — **[OPEN]** (not substrate)

Substrate S5 only nails: text is a value kind; **body fully literal** (no
inline forms, no in-text escapes). **How much of the first line** a
letter-first bare value takes, and **how multi-line text is opened**, are
open here.

#### 1.6.0 Vocabulary: “deferred block”

**Deferred block** = the attribute’s value is **not completed on the key’s
line**; it is taken from **deeper-indented following lines** (after optional
blank decoration). Examples of the *shape* (extent policy still open):

```udon
|el
  :note
    first line of the value
    second line still in the value
```

```udon
|el
  :note \starts on the key line…
    …and may continue deeper once multi-line entry is defined
```

Contrast **same-line value** (finished before newline):

```udon
|el :note a-single-token
|el :count 7
```

“Deferred” names the **when** (value body after the key line), not a third
value type.

#### 1.6.1 Recommended default — **identical on both roots** (not ratified)

**[OPEN — recommended]** Element-rooted and attribute-rooted use the **same**
first-line bare-text rule. There is no “implied quotes only on block lines.”

1. **Letter-first bare value = one space-delimited token** (same as
   **[CURRENT 0.8]** sameline bare values).
2. After that token finishes — and after **any** finished non-text value
   (quoted string, number, keyword, …) — the **rest of the line is owned by
   the parent element**: further `:attrs`, child nodes, or prose.
3. Multi-word / multi-line text needs a **visible** form: quotes,
   **deferred block** (§1.6.0), or value-`\` entry (extent after `\` still
   to pin; recommend rest-of-line as that text value so `\7 apples` works).

```udon
|el :summary val and this starts the text for el so :this-is-part-of-the-text yes
|el
  :summary val and this starts the text for el so :this-is-part-of-the-text yes
; BOTH: summary = "val"
; BOTH: el owns "and this starts the text for el so :this-is-part-of-the-text yes"
;       (":this-is-part-of-the-text" is literal characters in el prose)
```

```udon
|el :summary short :status ok
|el
  :summary short :status ok
; BOTH: summary = "short"; status = "ok"
```

```udon
|el :s "a b c d" e :still-text f
; s = "a b c d"; el prose starts "e :still-text f"

|el
  :s "a b c d e" e :still-text f
; SAME ownership pattern: s = finished string; el owns bare tail as prose
; (not a second text value for :s; not an attr-rooted-only ERROR)

|el
  :s "a b c d e" :xyz trailing text for :xyz value
; s = finished string; xyz gets value starting "trailing…" (parent scan)
```

**Multi-line text** only with visible entry (deferred block or value-`\`),
not silent deeper absorption after a completed one-token line value.

**Inside any text body:** fully literal (substrate S5). No in-text escapes.

**Multi-word bare without quotes:** only the first token is the value; the
rest is el prose (or a following `:attr`). To put spaces in the value use
quotes or a deferred block — not rest-of-line absorption on attr-rooted.

#### 1.6.2 Uniform greediness — **rejected as default** (kept for archaeology)

Earlier draft: letter-first text = rest of line on **every** root, including
`|el :a hello world` → `a="hello world"`. **Problems (peer review):** silent
swallow of `:status ok` on element-rooted multi-attr lines; silent
reinterpretation of existing docs; first character deciding type *and*
extent; contradiction with “markers literal” if in-text `|{` escapes were
allowed. **Not** the working default. May be reconsidered only with a
full confidence corpus.

#### 1.6.3 Backslash positions (high-level; body literal)

| Position | Effect |
|----------|--------|
| **Value-expected** `\` | Enter text mode (S6); extent per §1.6.1 once settled |
| **Inside text body** | Literal `\` only (S5) — **no** opener escapes |
| **Post-value scan** (after finished non-text) | Force rest of line to **element** prose (ratified family) |
| **Head / line-start** | Force line to prose (ratified) |

```udon
|el :a \hello world     ; value-\ → text (extent open / recommended: "hello world")
|el :a hello \world     ; if a="hello" + prose: \ in prose; if greedy text: \ in text = literal
|el :a 1 \ still        ; a=1; el prose via post-value \
|el :a? \hello          ; a?=true; parent then \ → prose "hello"
```

### 1.7 After a *finished* value — who owns the rest?

**[PROPOSED]** When the attribute’s value is complete (one bare token,
finished scalar/string/keyword/ref/interpolation, or a node whose interior
scan has ended), the **rest of the line is owned by the parent element** —
on **both** element-rooted and attribute-rooted lines. Further `:attrs`,
child nodes, or prose attach to the parent (or to an open node value if
still inside one).

```udon
|el :a 1 still prose
|el
  :a 1 still prose
; BOTH: a=1; el owns "still prose"
```

| Context | Rest of line after finished value |
|---------|-------------------------------------|
| Element- or attribute-rooted attr on `\|el` | **parent `\|el`** |
| Inside an open node value | **that node** |

**Not** an attr-rooted-only orphan error for bare tails after a finished
value — that would split the two roots again.

### 1.8 Sameline vs block — unified matrix

**[PROPOSED]**

| Input | Result |
|-------|--------|
| `\|el :a \|beta` | `a` = node beta |
| `\|el :a? \|beta` | `a?` = **true**; beta **child of el** |
| `\|el :a? true it sure is true` | `a?` = true; el prose `"it sure is true"` |
| `\|el :a? well it sure is true` | `a?` = **true**; el prose `"well it sure is true"` |
| `\|el :a? false` | `a?` = false |
| `\|el :a @x[k]` | `a` = reference |
| `\|el :a? @x[k]` | `a?` = true; `@x[k]` owned by **parent** scan (ref child of el if guard fires) |
| `\|el :a` + deeper `\|beta` | `a` = node beta |
| `\|el :a?` + deeper `\|beta` | `a?` = true; beta child of el |
| `\|el :a` + deeper prose | deferred-block text (recommended) |
| `\|el :a?` + deeper prose | `a?` = true; prose child of el |
| `\|el :a 1 still prose` | `a` = `1`; el prose `"still prose"` |
| `\|el` / `:a 1 still prose` | **same** — `a` = `1`; el owns `"still prose"` |
| `\|el :a \|node :k "v" more text` | `a` = node; `:k`=`v`; node prose `"more text"` |
| `\|el :a hello world` | **[OPEN / recommended]** `a="hello"`, el prose `"world"` (both roots) |
| `\|el :a hello :status ok` | **[OPEN / recommended]** two attrs (both roots) |
| `\|el` / `:summary val and more…` | **[OPEN / recommended]** `summary="val"`, el owns tail (same as el-rooted) |
| `\|el :disabled? :type submit` | disabled?=true; type=submit |
| `\|el :disabled :type submit` | **error** on disabled (missing value) |

### 1.9 Node value owns the scan (concrete line)

**[PROPOSED]**

```udon
|el :a |the-node-value-of-a :some-attr "some" more text
```

| Piece | Owner |
|-------|--------|
| `:a` | plain attr of `el` |
| `\|the-node-value-of-a` | **value of `a`** (the node *is* the value) |
| `:some-attr` | attr of **`the-node-value-of-a`** |
| `"some"` | finished string value of `:some-attr` |
| `more text` | **child prose of `the-node-value-of-a`**, not of `el` |

Bare letter-first without quotes (`:some-attr some more text`) would make
`:some-attr`’s value the greedy text `"some more text"` (no separate node
prose) — same rule as §1.6, applied inside the node’s scan.

### 1.10 Explicit freeform after valued attr (preserved)

**[PROPOSED]** Unchanged from ratified intent: after a **complete** scalar
value, sameline freeform is not “the attr’s value” — scan has moved on to
the line owner. Fixture spirit of `freeform_sameline_after_attrs` remains:
`|a |b :k v ``` ` → fence is b’s child, not k’s value.

```
|a |b :k v ```fence
; k = v (scalar); fence child of b  — [PROPOSED] same as [CURRENT] intent
```

---

## 2. Contrast gallery (same inputs, three registers)

Use this section when reviewing; do not treat **[CURRENT]** or **[FORK NOT
TAKEN]** as target behavior.

### 2.1 Headline

```udon
|alpha :a |beta
```

| Register | `a` | `beta` |
|----------|-----|--------|
| **[PROPOSED]** | value = element beta | (is the value) |
| **[CURRENT 0.8]** | BoolTrue | child of alpha |
| **[FORK NOT TAKEN]** | BoolTrue | child of alpha |

```udon
|alpha :a? |beta
```

| Register | `a?` | `beta` |
|----------|------|--------|
| **[PROPOSED]** | BoolTrue | child of alpha |
| **[CURRENT 0.8]** | (no `?` in keys — not this spelling) | — |
| **[FORK NOT TAKEN]** | BoolTrue (convention) | child of alpha |

### 2.2 Config flags

```udon
|button :disabled :type submit
```

| Register | Meaning |
|----------|---------|
| **[PROPOSED]** | **Error** on `:disabled` (missing value). Write `:disabled?` or `:disabled true`. |
| **[CURRENT 0.8]** | disabled=true, type=submit |
| **[FORK NOT TAKEN]** | same as current |

```udon
|button :disabled? :type submit
```

| Register | Meaning |
|----------|---------|
| **[PROPOSED]** | disabled?=true, type=submit |
| **[FORK NOT TAKEN]** | same if `?` allowed in keys |

### 2.3 Structured headers (the old “complex attr” example)

```udon
|api
  :headers
    |header :name Content-Type :value application/json
```

| Register | Meaning |
|----------|---------|
| **[PROPOSED]** | `headers`’ value **is** the `\|header` node (deeper block). No BoolTrue. |
| **[CURRENT 0.8]** | `headers` BoolTrue; `\|header` child of `api` |
| **[FORK NOT TAKEN]** | deeper ⇒ node value for headers (form 4); same *intent* as proposed for *block*, but sameline still dual |

### 2.4 Uniform scan vs run-to-EOL

```udon
|el
  :bttr 2 :cttr 3
```

| Register | Meaning |
|----------|---------|
| **[PROPOSED]** (+ substrate) | bttr=2, cttr=3 (two attrs) |
| **[CURRENT 0.8]** | bttr = bare `"2 :cttr 3"` |
| **[FORK NOT TAKEN]** | same as proposed (uniform scan) |

### 2.5 After finished value — both roots, parent owns tail

```udon
|el :a 1 still prose
|el
  :a 1 still prose
```

| Register | Meaning |
|----------|---------|
| **[PROPOSED / recommended]** | **both:** `a=1`; el owns `"still prose"` |
| **[CURRENT 0.8]** | el-rooted same; attr-rooted may still run-to-EOL today |

### 2.5b Bare text extent **[OPEN]** — both roots same

```udon
|el :a hello world
|el
  :a hello world
```

| Register | Meaning |
|----------|---------|
| **[OPEN / recommended]** | **both:** `a="hello"`; el owns `"world"` |
| **[CURRENT 0.8]** | el-rooted same; attr-rooted today is run-to-EOL (may differ) |
| **Uniform greediness (rejected)** | `a="hello world"` |

```udon
|el :s "a b c d" e :still-text f
|el
  :s "a b c d e" e :still-text f
```

| Register | Meaning |
|----------|---------|
| **[OPEN / recommended]** | finished string value; **el** owns the bare tail as prose (both roots) |
| *not* | second text value for `:s` / forced ERROR on attr-rooted only |

```udon
|el :a? well it sure is true
```

| Register | Meaning |
|----------|---------|
| **[PROPOSED]** | `a?` = **true**; el prose `"well it sure is true"` |

### 2.6 Block-deeper-only — abolished under this proposal

```udon
|el :alpha |child something
```

| Register | Meaning |
|----------|---------|
| **[PROPOSED]** | alpha’s value is `\|child` (with prose “something” inside child if attached that way) |
| **[FORK NOT TAKEN]** | alpha=true; child of el — **required** dualism |
| **[CURRENT 0.8]** | same as fork not taken |

```udon
|el :alpha
      |child something
```

| Register | Meaning |
|----------|---------|
| **[PROPOSED]** | alpha’s value is child (deeper) — **same rule** as sameline |
| **[FORK NOT TAKEN]** | alpha’s value is child (only deeper path worked for nodes) |

---

## 3. Migration from [CURRENT 0.8]

**[PROPOSED]** Mechanical expectations:

1. Every valueless plain attr used as a flag → add `?` or give `true`.
2. Every place authors relied on `|el :a |b` meaning sibling → either
   write `:a? |b` (flag + child) or accept `:a |b` as map edge (usually
   what map-shaped docs wanted).
3. Block “structured” attrs that today emit BoolTrue + children → become
   true node values (fixtures flip; tree `attr("headers")` returns node).
4. Identity suffix sugar `$?` etc. unchanged (already explicit true).
5. Charset: allow `?` in keys before semantic flags work in the grammar.

**Corpus / agents:** prefer teaching `:flag?` in cheatsheets immediately when
this lands; grepping bare valueless attrs is a finite migration.

---

## 4. Event & streaming implications (under this switch)

Implementation notes, not CORE prose. Builds on substrate S12.

**[PROPOSED]**

1. **Plain attr + sameline node:** can emit `AttrStart` / node events /
   `AttrEnd` without waiting for a later line (value complete on the line).
2. **Plain attr + EOL:** do **not** emit BoolTrue; wait for next non-blank
   line’s column — then either open value or error missing value.
3. **Flag attr:** emit BoolTrue when valueless (immediately if next is
   clearly not a deferred deeper value — e.g. next is `:`, `|`, prose at
   same column, or EOL with following non-deeper line). Streaming: may defer
   one line when EOL and next line might be deeper **[OPEN]** whether flags
   ever take deeper blocks as values (proposal: **no** — deeper after
   `:a?` is always parent’s child/prose; only plain attrs defer).
4. **Tree:** `attr("headers")` → node; `attr("disabled?")` → bool;
   `attr("disabled")` absent unless spelled without `?`.

**[FORK NOT TAKEN]** needed BoolTrue defer for “flag vs deeper node value”
on the **same** plain key. This proposal splits that by spelling (`?` vs
plain), so plain’s defer is only “value not yet seen,” never “flag vs node.”

---

## 5. Open issues (proposal-2 scope)

Surface these for chat / next iteration. Substrate opens are listed in the
substrate doc §S13 and are not repeated in full.

### 5.1 Must-decide before CORE (binding)

| ID | Issue | Lean in this draft |
|----|--------|--------------------|
| P2-1 | After `:a?`, can a **sameline** `@ref` or `\|el` attach as parent child while still on the element line? | **Yes** — flag complete; sameline scan continues as element-owned (same as today after a valued attr). |
| P2-2 | Do flags ever accept a **deeper block** as value? | **No** — same as §1.2: non-bool material never binds to the flag; deeper is parent’s. |
| P2-3 | Plain `:a` then another `:b` with no value for `a` | **Error** on `a`; parse `b` (recover-and-continue). |
| P2-4 | Plain `:a` EOL, next non-blank shallower | **Error** missing value. |
| P2-5 | Blank lines between plain `:a` and deeper value | Skip blanks for binding; **[OPEN]** max distance advisory at AST (`DistantAttributeBlock`). |
| P2-6 | ~~non-bool on `?`-key as error~~ | **Decided (§1.2):** only true/false/nil bind; else flag=true and parent owns the rest. |
| P2-7 | Error code names | `MissingAttributeValue`, `OrphanTextAfterAttributeValue`, `SecondAttributeNode`, … |
| P2-10 | Bare-text **extent** (el-rooted token vs rest-of-line; multi-line entry) | **[OPEN]** — recommended default §1.6.1; uniform greediness rejected as default §1.6.2 |
| P2-11 | Blank lines inside multi-line text | preserve vs terminate |
| P2-12 | Second node at value depth — recovery | Error+stack-parse vs skip |
| P2-13 | Key charset: terminal `?` only vs `?!*+` continue-set | flags need at least terminal `?` |
| P2-14 | Block `!directive` as attr node value | defer to DYNAMICS (recommended) |
| P2-15 | Flag/attr + deeper `;` comment attachment | one CORE sentence |

### 5.2 Should-decide with charset (substrate + this)

| ID | Issue | Lean |
|----|--------|------|
| P2-8 | Flag = key **ends with** `?` | Yes |
| P2-9 | Terminal-only `?` vs full `?!*+` continue-set on keys | Terminal-only is enough for flags; full continue is taste/symmetry — **Joseph** |

### 5.3 Explicitly out of scope / deferred

- Block `!directive` as attribute node value → DYNAMICS.
- Composite path sugar for nested maps → later desugar only.
- Changing element suffix `?` meaning.
- Full event encoding of references (selector tuples) — orthogonal; CORE
  interim raw `Reference` payload can stay until that work lands.

### 5.4 Flag + deeper comment

**[OPEN]** (from design v1) `:omega <val>` then deeper `; comment` —
allowed; attachment unspecified. Needs one CORE sentence: either
“comments at this depth attach to the parent element” or “to the
preceding attribute declaration as annotation” or “implementation-defined
with no semantic effect on values.”

---

## 6. Supersession ledger (full model = substrate + this proposal)

Ratifying **both** documents into CORE knowingly supersedes:

1. Implicit valueless = true (**[CURRENT 0.8]** and **[FORK NOT TAKEN]**).
2. Sameline sibling-scan after a **plain** attribute key when the next
   token is value-shaped (`|`, `@`, …).
3. Block-deeper-only rule for node-valued attributes.
4. `?` as convention-only flag naming (becomes semantic marker).
5. Everything in substrate S11 (run-to-EOL, scalar-only gloss, complex-attr
   underspec).

**Preserves:** stacking; attrs-before-children; hierarchy; comments;
identity `$` sugar; duplicate-definition policy; freeform-after-valued-attr
intent; core scalars and `<…>` interim.

---

## 7. Worked appendix — [PROPOSED] only

All examples below are **desired CORE** under this proposal. Not current
parser output.

```udon
; --- flags ---
|button :disabled? :type submit
|button :disabled? true :type submit
|button :disabled? false

; --- plain always binds ---
|alpha :a |beta
|alpha :a |beta :x 1
; a is beta; beta has :x 1

|alpha :a? |beta
; a? true; beta child of alpha

|api
  :method POST
  :headers
    |header :name Content-Type :value application/json
    |header :name Authorization :value Bearer token
; ERROR on second |header if both under one :headers without stacking:
; one node per declaration — stack :headers for two header nodes:

|api
  :method POST
  :headers
    |header :name Content-Type :value application/json
  :headers
    |header :name Authorization :value Bearer token

; --- text ---
|el
  :note Here is some
    of what I was talking about
    |discussion literal pipe text

; --- flags: bool only or default true + parent owns rest ---
|el :a? true it sure is true      ; a?=true; el prose "it sure is true"
|el :a? well it sure is true      ; a?=true; el prose "well it sure is true"
|el :a? |beta                     ; a?=true; beta child of el

; --- typing / after finished non-text ---
|el :count 7                    ; OK integer
|el :count 7 still el prose     ; count=7; el prose
|el
  :count 7 still el prose       ; SAME — count=7; el owns tail
|el :count "7 apples"           ; string scalar

; --- bare text extent [OPEN / recommended] — both roots identical ---
|el :a hello world
|el
  :a hello world
; both: a="hello"; el owns "world"

|el :summary short :status ok
|el
  :summary short :status ok
; both: two attrs

|el :s "a b c d" e :still-text f
|el
  :s "a b c d e" e :still-text f
; both: finished string; el owns bare tail as prose


; --- node value owns scan ---
|el :a |the-node-value-of-a :some-attr "some" more text
; a = the-node; some-attr = "some"; "more text" is prose of the-node

; --- uniform scan ---
|el
  :bttr 2 :cttr 3         ; two attrs

; --- no attr-under-attr ---
|el
  :theta
    |config :first 1 :second 2

; --- namespacing ---
|el
  :address/street 123
  :address/zip 94019

; --- stacking heterogeneous ---
|el
  :omega <some-value>
  :omega another value
  :omega "and more" :beta |node
```

---

## 8. Relationship to prior artifacts

| Artifact | Role after this draft |
|----------|----------------------|
| `attribute-model-2026-07.md` | Archaeology + provenance; §7.5 is the fork this proposal *takes* |
| `attribute-model-proposal-2-substrate.md` | Switch-invariant CORE-bound material |
| `attribute-model-proposal-2.md` (this file) | Semantic `?` + unified binding + migration + opens |
| `spec/CORE.md` Complex Attribute Values | Stays “not settled” until ratification copies from here |
| `spec/TODO-SPEC-CORE.md` structured-attr item | Points at this pair when Joseph advances it |

---

## 9. Suggested ratification path

1. Walk §5 open table (P2-1…P2-9) + substrate S13 in chat; edit this draft.
2. When no **[OPEN]** remains on binding, promote rules §1 into CORE
   “Attributes” (replace scalar gloss, complex-values, run-to-EOL, implicit
   true).
3. Promote substrate sections into CORE in the same commit family.
4. Fixture rebuild: flags, structured attrs, uniform multi-attr block lines,
   sameline `:a |b`.
5. Grammar: `?` in keys; plain missing-value error; bind sameline node to
   plain attr; AttrStart/End when ready.
6. Mark `attribute-model-2026-07.md` superseded-by-proposal-2.

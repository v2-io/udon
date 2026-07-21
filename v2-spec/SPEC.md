# UDON Language Specification (0.10 / v2-spec)

**Status:** **provisional skeleton** — surface recognition → ADM contract prose.  
**Not** a full encyclopedia; not the live `spec/CORE.md`.  
**Authority:** [DECISIONS.md](DECISIONS.md) wins on conflict. Multi-line /
line-bound policy and exact wire/event encoding → [OPEN.md](OPEN.md) (**ML**,
**W1e**). Do **not** invent pins for OPEN items here.  
**Companions:** [GLOSSARY.md](GLOSSARY.md), [ADM.md](ADM.md), [PIPELINE.md](PIPELINE.md),
[SEMANTICS.md](SEMANTICS.md), [WIRE.md](WIRE.md) (event stream under **W0**/**W1d**;
encoding detail OPEN **W1e**), [GRAMMAR.md](GRAMMAR.md) (non-normative extract).  
**Version line:** **0.10.0** (**C2**).  
**Wording mines (not law):** `../spec/msc/greenfield-2a/new-spec/SPEC.md`,
`../spec/msc/greenfield-3b/new-spec/CORE.md`.

The key words **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHOULD**,
**SHOULD NOT**, **RECOMMENDED**, **MAY**, and **OPTIONAL** are to be
interpreted as described in RFC 2119.

---

## 1. Conformance

### 1.1 What conformance means

A **conforming recognizer** MUST:

1. Map every finite UTF-8 input to an ADM instance (or equivalent recoverable
   encoding) plus anomaly records per [ADM.md](ADM.md) and this document.
2. Implement **keep-everything** wherever this contract defines a keep path
   (**R11**).
3. Recognize all markers, value forms, and sugar desugarings specified here.
4. Treat dialect *meaning* as optional: it MUST recognize Envelope and Dynamics
   *syntax*; it MAY leave bodies unresolved when no Dialect is loaded.
5. When a canonical fixture suite is published for a claimed version, pass that
   suite. Fixtures assert **events and assembly/ADM product** where useful
   (**C5**); incomplete-input is a **recognition-verdict**, not an event
   (**C6**, **R2**). Until a suite ships, this prose is the design commitment.

A conforming recognizer is **not** required to implement any Dialect, Schema,
mixin expansion, Reference resolution mode, or Markdown interpretation.

**Passing the fixture suite (when published) is the operational definition of
compliance.** Prose and suite are maintained together; a demonstrated
divergence is a defect in one of the two, resolved by ruling — never by
implementation behavior alone.

### 1.2 Versioning

This specification carries semantic version **0.10.0** (**C2**). A conformance
claim names the version whose fixture suite it passes. Host tools version
independently and declare the core range they obey.

### 1.3 Recognition product

Recognition yields a **Document** (content forest + anomalies + result) as in
ADM §1. Normative suite packaging (**D-pack**, **C5**, **C6**):

```text
Document := { content, anomalies, result: complete | incomplete-input }
```

Engines MAY expose equivalent APIs if information-equivalent to that triple.

---

## 2. Architecture

### 2.1 Core vs Host / Dialect / Schema

| Layer | Fixes | Does not |
|-------|--------|----------|
| **Core** | Markers, geometry, bare scalars, stacking, sugar desugaring, extents, anomaly recognition | Projection, constraint, exotic typing meaning |
| **Dialect** | Meaning of non-core values / dynamic forms (e.g. `temporal@1`) | Constraint (“allowed keys”) |
| **Schema** | Cardinality, vocabularies, application policies | Typing bare space |
| **Host** | Dialects loaded, reference resolution, native projection, document-layer knobs | Redefining Core syntax |

**Menu vs knob:** Core MAY fix an option *space* and a default; a Consumer MUST
pick within the space and MUST NOT invent options outside it (**R11**, **R14**).

**Dialects are not Schemas.** A Dialect types; a Schema constrains. They MUST
NOT trade jobs. Bare recognition is frozen (**R21**, **L5**); loading a Dialect
MUST NOT retype bare scalars.

### 2.2 Pipeline (pointer)

Bytes → **Recognition** (events + recognition-verdict) → **Assembly** (ADM) →
**Resolution** → **Evaluation**. Stage names and **sufficiency / no-reachback**
(**W0**) are in [PIPELINE.md](PIPELINE.md). This document is the surface → ADM
contract; it does not define wire event spellings (**W1e** OPEN).

### 2.3 Streaming

UDON is **bounded-lookahead**: every Structure Position Guard resolves with a
small fixed number of characters and no deep backtracking. New syntax SHOULD
preserve that bound. Chunk boundaries are **not** end of input.

---

## 3. Source text, lines, columns

### 3.1 Encoding

A document is a sequence of Unicode scalar values encoded as **UTF-8**.

### 3.2 Lines

A **line** is a maximal run of characters terminated by U+000A (LF) or by end
of input. A final line need not end with newline. Line terminators are part of
text material where §7 and the ADM text law (**R1**) say so.

### 3.3 Columns and indentation

- **Column** is zero-based count of leading U+0020 SPACE before content.
- Indentation MUST use spaces only for structural meaning.
- **Tab in indentation (**L4**):** the line’s structural contribution is
  best-effort; content is **kept** as text of the current owner (spaces before
  the tab used as column). Severity is **Warning** under **L0** (bytes kept).
  The line is **not** discarded. A tab *inside* Text, values, or comments is
  ordinary content.
- Consistent sibling indent is RECOMMENDED style, not a language rule.

### 3.4 Nesting Rule

Open structural items form a stack, each with a **Base Column** (column of the
introducing marker, e.g. `|`).

When a new structural line begins at column `c`:

```text
pop while stack non-empty and c ≤ top.base_column
then open the new item under the resulting top (or Document if empty)
```

| Relation | Meaning |
|----------|---------|
| Greater column than parent Base | Child |
| Same column | Sibling (parent closed first) |
| Lesser column | Close ancestors until relation holds |

**Sameline nesting:** later markers on the same line behave as if each began on
its own line at its actual column.

**Prose interior exception:** once an Element has an established **Content
Base**, a line indented *deeper than that Content Base* is Text interior —
markers there are literal. Structure resumes only at columns ≤ Content Base
(§7).

### 3.5 Structure Position

**Structure Position** (2a: *open position* — same hinge) is the state in which
Markers are recognized:

1. At the beginning of a line’s content when the line is at a **structural
   column** (not prose interior), and
2. During the **Line Scan** on an element-rooted line: left-to-right through
   Elements and Attributes before prose commits.

The first bare prose word (or other non-marker commitment) **commits** the
remainder of that physical line to Text: later marker characters are literal,
**except** a whitespace-framed sameline comment (` ; `, §8).

---

## 4. Markers and Guards

Structure begins only with a **Marker** at Structure Position:

| Marker | Opens |
|--------|--------|
| `\|` | Element (or Inline Element if `\|{`) |
| `:` | Attribute (while owner not yet in Content Phase) |
| `!` | Dynamics / Verbatim opener |
| `;` | Comment (context table §8) |
| `@` | Reference |
| `` ``` `` | Fence |

Each Marker has a **Guard** (bounded lookahead). Guard fails ⇒ character is
ordinary Text.

| Marker | Guard (summary) |
|--------|-----------------|
| `\|` | Followed by `XID_Start`, `[`, `.`, `{`, `'`, or flag `?` `!` `*` `+`. Else Text (Markdown tables: `\| ` is text). |
| `!` | Followed by identifier character or `:`. Forms like `![img]`, `!=`, `!(` are Text. |
| `@` | Followed by `[`, `.`, or identifier-start. Lone `@` is Text. |
| `:` | Phase-gated: Attribute only while owner can still take attributes, and followed by a Key (bare or quoted). Bare `:` without Key → Text. |
| `;` | Per §8 position table. |
| Fence | Three U+0060 at Structure Position; not after prose commit; not deeper than Content Base. |

---

## 5. Elements and sugar

### 5.1 Shape

```text
Element := { name?: String, attributes: [Assignment], content: [ContentItem] }
```

No parallel identity/trait fields — sugar desugars to designated attributes
(ADM §2).

### 5.2 Names

Bare Name: first char `XID_Start`; continuation `XID_Continue` or `-` or `/`.
`/` is conventional namespacing with **zero** Core semantics. Other characters
require single quotes: `|'weird name'`. Flag suffix chars are **not** name
characters. Unicode version for `XID_*` is a Host choice.

### 5.3 Identity and traits (sugar)

```udon
|element[key].trait1.trait2
```

| Surface | Desugars to |
|---------|-------------|
| `\|el[k]` | `\|el :'$key' k` |
| `\|el.a.b` | two `$traits` Assignments, values `a` then `b` |

- Bracket interior uses normal value recognition (`[1]` integer; `["01"]` string).
- Traits stack (ordered `$traits` assignments), not one list.
- **Identity contiguity:** after a space, `.trait` is not sugar
  (`|p .gitignore is a file` has no traits).
- Bare trait continue-set additionally includes `?` `!` `*` `+` so `.foo?` is
  trait `foo?`.

**Unclosed identity (**R5**):** if `]` never arrives, assign under
**`$partial-key`** (not `$key`) + Warning. Consumers resolving identity or
References MUST treat `$partial-key` as non-identity. Multi-line fate of
unclosed `[` → OPEN **ML** (do not invent line-bound vs multi-line here).

### 5.4 Designated attributes

Targets: `$key`, `$traits`, `$partial-key`, `$?`, `$!`, `$*`, `$+`.

**Designated, not reserved:** any `$…` key is legal longhand (usually quoted
because `$` is not a bare-key character).

### 5.5 Flag suffixes (**R18**)

Trailing `?` `!` `*` `+` on element identity desugar to designated boolean
true (`$?` etc.). Multiple suffixes stack (`|field?!`). Valid positions: after
name, after key, or space-separated at end. Touching a trait binds to the trait
(`|el.bar?` → trait `bar?`; `|el.bar ?` → trait `bar` + `$?`).

Meaning of flag suffixes is Schema/Dialect; Core only expands.

### 5.6 Anonymous Elements

Name MAY be absent: `|[k]`, `|.trait`, `|?`. Core assigns no special meaning.
Mixin treatment is a **Host experiment** — Core specifies nothing required
(**S13**).

### 5.7 Inline Elements `|{…}`

Within Text or Flow: brace-balanced; interior Line Scan + Attributes with `}`
as additional bare-token terminator (unconsumed). Nested structure inside MUST
use brace form only (no block `|name` inside). Empty `\|{}` is a valid empty
anonymous embedded Element (**R19**). Framed ` ; ` inside `|{…}` is **out for
now** — bare `;` is literal (**R20**). Multi-line span of `|{…}` → OPEN **ML**.

---

## 6. Attributes

### 6.1 Labeled edges

Attributes are ordered labeled edges from an Element. Value kinds: Scalar,
Reference, Interpolation, Node Value, Flow Value (ADM §3).

Appear **sameline**, **block**, or inside Inline Elements. One value grammar;
terminators and tail ownership differ by context (§6.8).

### 6.2 Root-level `:key` (**L1**)

A line-initial `:key` with **no owning Element** MUST produce a **Warning** and
be kept as **document-level Text** (including the leading `:`). It MUST NOT
appear as a free-floating Attribute in the ADM. Portable meaning: **none** —
do not rely on root attrs as data.

```udon
:orphan v
; → document Text (bytes kept, including ':') + Warning — not an Attribute
```

### 6.3 Keys and Flag Keys

Bare Key: `XID_Start` then `XID_Continue` plus `-` `/` and `?` `!` `*` `+`.
Other characters: single quotes. Terminal `?` selects **Flag Key** semantics;
the key string **includes** the `?` (`:ready?` ≡ `:'ready?'`).

**Plain keys always take a value.** Plain `:key` with no value material →
Assignment with value **Nil** + **Error** (**R6**; absent intended value under
**L0**). Presence flags use `?`.

#### Flag rule

After `:key?`, next token in value position:

1. Alone at boundary: exactly `true` / `false` / `null` / `nil` → that value.
2. Anything else → flag is **true**; material is **re-owned** by the continuing
   scan (not a warned extension).
3. Deeper material under a finished flag follows ordinary finished-value rules.

### 6.4 Line Scan and Bare Token Boundary

After `:`, collect the Attribute’s value, then continue the Line Scan for the
current owner. Block lines may carry multiple Attributes:

```udon
|el
  :a 1 :b 2
```

Most shapes self-announce (`"`, digit, `<`, `[`, `@`, block `|`, …). A
committed numeric that fails mid-token falls through to bare token.

**Bare Token Boundary.** After an unquoted token, next non-space character:

| Next | Effect |
|------|--------|
| Guard-confirmed **Boundary Marker** (block `:` `\|` `@` `!`, Fence, value/boundary `\`, framed ` ; `) | Token finishes as single-token value; scan continues |
| Anything else, including **inline brace forms** | Commit **Flow Value** from this token |

A character that *looks* like a marker but fails its Guard is **not** a
Boundary Marker (e.g. `:3`, `|~`, `!=` after a bare token → Flow).

**Inline-Brace Principle (**R4**):** `|{` `!{` `;{` (and anticipated `@{`) are
**never** Boundary Markers. They commit Flow and participate as inline
segments:

```udon
|el :n value |{em x} :a 1
; one Flow for n — trailing ":a 1" is text inside the flow, not a second attr
```

**Keywords** `true` `false` `null` `nil` type only when alone at boundary;
otherwise they begin Flow:

```udon
|el :a true :b true story
; a → boolean true; b → flow "true story"
```

### 6.5 Ownership of Flow Values

| Priority | Condition | Owner |
|----------|-----------|--------|
| 1 | Attribute still needs a value, or is **collecting** | That Attribute |
| 2 | Else nearest Element on the line | That Element’s Content (Content Phase begins) |
| 3 | Else | Ordinary column ownership (not an Error) |

**Collecting:** on an **Attribute-rooted line**, the Attribute remains
collector after a finished value → further same-line material is **warned
extension**. On an **Element-rooted line**, a finished Attribute never
collects the tail — the Element takes it.

```udon
|el :a 1 rest
; element-rooted: finished :a; "rest" is Element Content (not attr extension)

|el
  :a 1 more
; attribute-rooted finished value: "more" is warned extension (further Assignment)
```

**Deferred value:** Key line ends with no finished value → deeper lines form
the value body under Nesting / Content Base rules.

```udon
|el
  :note
    first line
    second line
; :note has no same-line value → deeper lines form the value body
```

**Value-position `\`:** where a plain Attribute still needs a value and no
token has started, `\` is consumed → Flow text mode for that value; framed
sameline comment disabled on that line.

### 6.6 Node Values (**R4**)

Block-form Element, block Verbatim, or Fence in value position → **Node
Value** (the Attribute *is* that node; no wrapper). Brace form is Flow:

```udon
|el :x |em hi      ; x is Element em
|el :x |{em hi}    ; x is Flow with inline em
```

**One-way door:** once a Node Value opens on a line, its scan owns the rest of
that line.

**Attr-under-attr (**L6**, **R6**):** a deeper line that is itself `:key`
directly under an Attribute (not inside a Node Value) is **Error**; the line
is ingested as **Text of the open value** (keep-everything).

```udon
|el
  :outer
    :inner x
; :inner line is Text of outer's open value + Error (not a nested Attribute)
```

### 6.7 Stacking and warned extension (**R6**, **R9**)

Same Key repeated ⇒ ordered **Stacking** of Assignments (heterogeneous Values
allowed). **No last-wins.** Orthogonal to List literals:

| Surface | Model |
|---------|--------|
| `:x 1 :x 2` | Two Assignments |
| `:x [1 2]` | One Assignment, List value |

**Warned extension:** material after a finished value on an Attribute-rooted
line (same line or deeper) → further Assignment under that key + **Warning**.
Never a nested multi-segment Value kind; never silently dropped. Flags are
exempt same-line (flag rule re-owns).

### 6.8 Contexts and terminators

| Context | Extra bare terminators | Tail after finished value |
|---------|------------------------|---------------------------|
| Element-rooted line | (space, newline) | Element Content |
| Attribute-rooted line | (space, newline) | further assignment + Warning |
| Inside `\|{…}` | `}` unconsumed | Inline Element content |
| List item | `]` unconsumed | *(no tails)* |

### 6.9 Content Phase and late `:`

Attributes MUST precede Content of the same Element in surface construction
order. Sameline tails that become Content **do** enter Content Phase. A later
line-initial `:` that would have been an Attribute of an Element already in
Content Phase is **Text** of the column owner + **Warning**.

```udon
|el
  prose first
  :late v
; :late is Text + Warning (Content Phase already open) — not an Attribute
```

---

## 7. Flow, Text, Content Base

### 7.1 Flow

**Flow** is the one prose-shaped model: ordered segments (Text, Inline Element,
Interpolation, Inline Directive, Inline Verbatim, Inline Comment) shared by
element prose, flow values, and inline interiors. Core treats prose as
**opaque Text** — no Markdown parsing (**S16**: companion stub, not day-one
Layer-1 in Core).

Any line not opening a Marker at Structure Position is Text of the column
owner.

### 7.2 Content Base and dedentation

1. Sameline Text on the Element line does **not** establish Content Base.
2. First indented content line establishes **Content Base**.
3. Later lines at column ≥ Content Base: strip Content Base spaces; extra
   spaces remain in Text.
4. Later lines still inside the Element but column < Content Base: **Warning**,
   re-base Content Base to the new column, continue.
5. Lines deeper than Content Base are prose interior (markers literal).

Each prose line’s terminator is part of Text; stripped indentation is geometry
only (**R1**).

### 7.3 Blank lines

Inside Element Content between text lines: Text newline. At pure structure
boundaries, ornamental disposition follows [PIPELINE.md](PIPELINE.md) criterion
and SEMANTICS; **S9** defers BlankLine vs dedent *placement* — consumers MUST
NOT rely on stream order alone for ornamentation.

**Blank/ws two-layer (**R15**):** non-protruding blank/ws → blank/text channel;
past content-base → prose. Detail of wire names is WIRE’s job.

### 7.4 Text law (pointer)

Document text reconstructs by pure in-order concat of text-bearing units
(**R1**). Full invariant: ADM §5. Inline comments contribute no Text;
framing whitespace: preserve both framing spaces on strip until dialects
revisit (**S18**).

### 7.5 Inline forms

| Form | Meaning |
|------|---------|
| `\|{name …}` | Inline Element |
| `!{{expr}}` | Interpolation — ends at first `}}` |
| `!{name …}` | Inline Directive (UDON-parsed body) |
| `!{:kind:…}` | Inline Verbatim |
| `;{…}` | Inline Comment (no Text contribution) |

Escapes: `\` immediately before `|{` `!{` `;{` in flow makes the opener
literal (§9).

---

## 8. Comments

| Form | Surface | Notes |
|------|---------|--------|
| Line / block | `;` at Structure Position | Geometric; participates in Nesting Rule |
| Continued | deeper lines under a line comment | Entirely comment until dedent; first continuation sets strip column (**L7** content-base shape) |
| Sameline framed | whitespace + `;` + (whitespace or EOL) | Allowed after prose commit; disabled in `\`-forced text |
| Inline | `;{…}` | Only comment form inside ordinary prose flow / inside `\|{…}` |

Comments MUST be retained in the ADM; Consumers MAY strip in a view. Comment
bodies are inert.

Where `;` is literal: prose deeper than Content Base; unframed sameline prose;
value-`\` text; bare `;` inside `|{…}`; unframed attribute value content.

---

## 9. Escape (`\`)

Position alone disambiguates — no set of escapable characters:

| Position | Effect |
|----------|--------|
| Structure Position | Consume `\`; rest of physical line is Text; sameline comments disabled; inline forms still active |
| Immediately before inline opener `\|{` `!{` `;{` | Consume `\`; opener literal |
| Value-expected (plain Attribute needs value) | Consume `\`; enter Flow text mode (§6.5) |
| Anywhere else | Literal `\` (Host MAY interpret `\n` etc.; Core does not) |

Leading literal backslash doubles: Structure Position `\` + content `\` → one
`\`. Consumed Structure Position `\` occupies no column for Content Base: text
after it backs into the `\` column.

A `\` deeper than established Content Base is not Structure Position → literal.

**In-string escapes (**L2**):** Core defines **none**. A quoted string closes
at the next occurrence of its own quote character; interior bytes including
`\` pass through. Embed the other quote kind to include a quote. Positional
`\` rules above stay pure. `'` is never an escape; it delimits strings /
names / keys.

```udon
|el :s "a\nb"     ; value is five chars: a \ n b — not a newline
|el :t "it's"     ; single quote is content inside double quotes
```

---

## 10. Verbatim

One family, three forms — body never UDON-parsed:

| Form | Surface | Body geometry |
|------|---------|----------------|
| Block | `!:label:` | Dedent to first content line’s column (raw base); ends at line column ≤ directive Base Column. Body MAY begin same line after closing `:` |
| Fence | `` ``` `` | Byte-exact; no dedent; no Marker interpretation. Closer: line whose first non-space is `` ``` `` |
| Inline | `!{:kind:…}` | Brace-balanced; optional single space after label’s `:` is separator |

- Block Verbatim and Fences MAY be Node Values.
- **S8:** `!:label:` with empty same-line body → **empty body** (not “no body”).
- **S11:** Inline raw `!{:kind:…}` in value position → **Flow segment**
  (inline-brace principle).
- Multi-line policy for delimited forms → OPEN **ML** where not already
  geometric.

---

## 11. Dynamics (syntax only)

Core recognizes `!` family syntax; Dialect/Host supplies meaning ([dialects/](dialects/)
stubs; **P5**).

| Form | ADM |
|------|-----|
| `!name …` at Structure Position | Directive (`raw=false`); deeper body UDON Content by Nesting Rule |
| `!:label:` | Block Verbatim (`raw=true`) |
| `!{{expr}}` | Interpolation; expression unparsed; ends at first `}}` |
| `!{name …}` | Inline Directive |
| `!{:kind:…}` | Inline Verbatim |

Any directive name is accepted at recognition. Expression language, filters,
control-flow meaning are **not** Core.

**Micro-edges (**R13**):** UnclosedInlineDirective/Raw edges as ruled;
nameless `!{` at EOF → prose Text `"!{"` (not an unclosed directive shell).

---

## 12. References

`@` is an **inert selector** at Core. Model shape (ADM §3.6; **S14** keep
tuple until paths force growth):

```text
Reference := { name?, key?, traits: [String] }
```

| Surface | Selector (sketch) |
|---------|-------------------|
| `@[mit]` | `(absent, mit, [])` |
| `@licence` | `(licence, absent, [])` |
| `@licence[mit].realized` | `(licence, mit, [realized])` |
| `@.realized` | `(absent, absent, [realized])` |

- Traits filter matches; they do not modify the referent.
- No suffixes, Attributes, or predicates on References in Core.
- `@` has equal footing with `|` in Line Scan and value position (value vs
  content child).
- Wire encoding of references: interim raw after `@` for first gate (**W3**);
  not specified further here.
- Unclosed identity in selector: align with **R5** / `$partial-key` discipline;
  multi-line fate → OPEN **ML**.

**Resolution** is Host menu (illustrative): `leave-inert` (default) |
`transclude` | `merge-attributes`. Core does not resolve.

**Duplicate definitions (**R14**):** same Name + same Identity Key is a
document-layer concern. Menu: `error` | `allow-if-identical` | `first-wins` |
`last-wins` | `keep-all` (+ optional warn); default **error**. References play
no part in uniqueness.

Multiple keys / uniqueness / @ resolution detail → OPEN **S3** (WAIT-DEMAND;
paths spike).

---

## 13. Values, scalars, lists, envelope

### 13.1 Syntactic typing

Type comes from written syntax. The **frozen bare scalar set** is closed —
**nothing is ever added** to bare recognition (**R21**, **L5**).

### 13.2 Bare type table

| Syntax | Type |
|--------|------|
| `"…"` or `'…'` | String |
| Integer forms (§13.3) | Integer |
| Float forms (§13.3) | Float |
| `true` / `false` alone | Boolean |
| `null` / `nil` alone | Nil |
| `[…]` | List |
| `<…>` | Envelope (dialect hand-off) |
| otherwise | String (single token) or Flow |

Bare dates are **strings** (**R7**). Rational/complex → dialect/envelope when
specified (**L5**). `TRUE` / `True` are strings.

### 13.3 Numbers

**Integer:** optional `+`/`-`; `_` between digits ignored.

| Base | Prefix |
|------|--------|
| Decimal | none or `0d`/`0D` |
| Hex | `0x`/`0X` |
| Octal | `0o`/`0O` |
| Binary | `0b`/`0B` |

Leading `0` + more decimal digits is decimal (`0755` = 755), not octal.

**Float:** fractional part and/or exponent (`3.14`, `1e10`, `1.5e-3`). Float
semantic equality is Host profile, not Core bit-law (**S17**).

### 13.4 Strings

`"…"` and `'…'`. Close at next same quote; no Core in-string escapes (**L2**).
Multi-line span → OPEN **ML**. Unclosed at true EOF → Warning + incomplete-input
when still open (**R2**).

### 13.5 Booleans and Nil

Lowercase only; alone at boundary. **Absent / Nil / False / True** are four
distinct presence states (plain missing value is Nil+Error, not “absent key”).

### 13.6 Lists (**R16**, **R17**)

Space-delimited items; each under **full value rules** (refs/interps allowed);
**no Flow** inside. Empty closed identity/brackets → **nil key** (not empty
list); `[ ]` → **empty array** (**R16**). Quoted item end allows adjacent items
(`["x"y]` two items). Multi-line → OPEN **ML**.

### 13.7 Envelope `<…>`

In value position, bare `<` opens Envelope; matching `>` (depth-counted) closes
it. Quote a leading `<` string. Body carried until a Dialect claims it.

**Label ladder (illustrative; pin detail with dialects):** unlabelled
`<content>` → `<type:content>` → `<dialect:type:content>`.

Empty `<>` interim: BareValue + NoDialectsLoaded posture (**R13**); exact
anomaly coding → warning registry (**W4**). Nested envelope routing → OPEN
**S12**.

With no Dialect loaded, recognition still captures extent (keep-everything);
loading a Dialect later retypes without re-parsing bare space.

---

## 14. Extents and end of input

### 14.1 Geometric vs Delimited

| Class | Closes by | Examples |
|-------|-----------|----------|
| **Geometric** | EOL, dedent, or EOF | Element, block Directive/Comment/Verbatim, deferred value, block prose |
| **Delimited** | Matching end-sequence | Quotes, `]`, `}`, `}}`, `>`, fence closer, identity `[…]` |

### 14.2 Multi-line / line-bound policy

**Deliberately open for 0.10 design proper (**R3**, OPEN **ML**).** Geometric
constructs already span by geometry. Which delimited forms are multi-line vs
line-bound is **WAIT-DEMAND** — strawmen exist in greenfields and spikes; this
skeleton MUST NOT pin them. Authors MUST NOT rely on either reading until
DECISIONS lands a pin.

### 14.3 End of input (**R2**)

At **true** end of input, close open constructs innermost-first:

- **Geometric:** close **silently**. Missing final newline alone is not an
  Anomaly. EOF ≡ eol + full dedent for remaining edges (**R13**).
- **Delimited still open:** keep captured content; Warning citing opener;
  close construct. Document `result` = **incomplete-input** if any delimited
  extent was still open at true EOF.

Streaming chunk boundaries are not EOF.

### 14.4 Unclosed emission order (**R12**)

Content → `Unclosed*` → `End` (uniform). **Event names provisional until WIRE**
— do not treat old flat Attr wire as law (**R8** deratified).

### 14.5 Wire pointers (not this document)

| Decision | Holds |
|----------|--------|
| **W0** | Sufficiency / no-reachback at stage boundaries |
| **W1d** | Attribute values are **self-delimiting** (explicit value extent); inference-only extent stays void (**R8**) |
| **W1e** | Exact Attr value **event encoding** — OPEN |
| **W2**–**W5** | Phased wire refresh, interim refs, warning codes, Text role preference — see DECISIONS |

This SPEC does **not** list wire events.

---

## 15. Anomalies

### 15.1 Severity (**L0**, **R11**)

| Severity | Meaning |
|----------|---------|
| **Warning** | Content kept; may not match author intent |
| **Error** | Something was **lost**, or a more specific rule names Error for *absent intended value* (e.g. plain `:key` → Nil+Error under **R6**) |

If every author-visible byte is kept as structure or Text, severity MUST be
**Warning** unless a more specific rule names Error for absent intended value.

Recognition **continues** through anomalies. Halt / drop / reject is
**Consumer menu**, never a second silent recognition mode (**R11**).

### 15.2 Keep-everything

Where a coherent keep exists, a Recognizer MUST capture content and SHOULD
prefer Warning over silent drop. Silent drop of author-visible material is
non-conformant.

### 15.3 Representative cases

| Situation | Severity | Keep shape | Cite |
|-----------|----------|------------|------|
| Unclosed delimited at EOF | Warning (+ incomplete-input) | Partial content | **R2** |
| Unclosed identity `[` | Warning | `$partial-key` | **R5** |
| Trailing text on Attribute-rooted finished value | Warning | Further stacked Assignment | **R6** |
| Late `:` after Content Phase | Warning | Text | §6.9 |
| Plain `:key` missing value | Error | Attribute with Nil | **R6**, **L0** |
| Root-level `:key` | Warning | Document-level Text | **L1** |
| Attribute under Attribute | Error | Text of open value | **L6** |
| Tab in indentation | Warning | Best-effort text of owner | **L4**, **L0** |
| Inconsistent prose indent | Warning | Re-base Content Base | §7.2 |
| Empty forced-text `:a \` | — | Empty string | **R13** |

Warning codes: SPEC vocabulary + generator derivation (**W4**); exact registry
not frozen in this skeleton.

### 15.4 Incomplete-input (**R2**, **C6**)

`result: incomplete-input` is a **document-level verdict**, not a wire event.
Warnings/errors alone do not flip it — only delimited extents still open at
true EOF do.

Fixture cases that need this fact MUST carry a **`result`** field; do not
encode incomplete-input as a stream event. Interior-close vs at-EOF unclosed
twins may share events and differ only in `result` — see
[FIXTURES.md](FIXTURES.md) §3 (wire-twin pattern).

---

## 16. What this document deliberately excludes

| Concern | Where |
|---------|--------|
| Full wire event vocabulary / Attr encoding | WIRE; OPEN **W1e** |
| Multi-line per-construct pin | OPEN **ML** |
| Path language / multiple keys surface | OPEN **S3**; paths spike |
| Nested envelope routing | OPEN **S12** |
| Pragma / filename designator | **S15** stub only |
| Markdown Layer-1 | **S16** companion stub |
| Mixin expansion | **S13** Host experiment |
| Schema validity | Schema judges ADM |
| Pedagogy, rationale essays | Optional companions (**P4**) |
| Live `spec/CORE.md` accretion | Record/oracle only (**C4**, **P1**) |

---

## 17. Design principles (normative constraints)

1. **Attributes before Content** for each Element (Content Phase).
2. **Spaces only** for structural indentation; tabs kept under **L4**.
3. **Syntactic typing** with frozen bare set and Envelopes.
4. **Stacking, not last-wins**, for Attributes.
5. **Bounded lookahead** for Markers.
6. **Sugar is Designated Attributes**, not parallel model fields.
7. **References inert at Core.**
8. **Keep-everything** where a coherent keep exists (**R11**).
9. **Error = loss** (plus explicit absent-value Errors) (**L0**).

---

## Annex A — Quick surface map (non-normative)

```udon
; comment
|element[key].trait :attr value
  :block-attr multi word value
  Prose with |{em inline} and !{{interp}}.
  !:python:
    print("| not udon")
  ```
  byte-exact
  ```
  @other[key]
```

---

## Annex B — Document map

| Doc | Role |
|-----|------|
| [DECISIONS.md](DECISIONS.md) | Present law ledger |
| [OPEN.md](OPEN.md) | Live questions only |
| [GLOSSARY.md](GLOSSARY.md) | Stable vocabulary |
| [ADM.md](ADM.md) | Recognition product shape |
| [PIPELINE.md](PIPELINE.md) | Stages, sufficiency, ornamental |
| [SEMANTICS.md](SEMANTICS.md) | Equivalence layers (skeleton) |
| [dialects/](dialects/) | Thin stubs (**P5**) |
| [WIRE.md](WIRE.md) | Events under **W0**/**W1d**; encoding **W1e** |
| [FIXTURES.md](FIXTURES.md) | C5/C6 profile + verdict design notes |
| [fixtures/](fixtures/) | 0.10 design corpus (no harness yet) |
| [GRAMMAR.md](GRAMMAR.md) | Non-normative mechanical extract |

---

## Annex C — Presence states (normative sketch)

| State | Meaning |
|-------|---------|
| **Absent** | Key not present among Assignments |
| **Nil** | Key present, value Nil (`null`/`nil`, or missing plain value + Error **R6**) |
| **False** | Boolean false |
| **True** | Boolean true (incl. bare flag presence) |

These four MUST remain distinct. Flag bare presence → True, not Absent.

---

## Authoring queue (remaining)

1. Close OPEN **ML** construct table when demand harvest lands — then expand §14.2.
2. Warning code registry alignment (**W4**) with descent.
3. Envelope label ladder + empty-`<>` anomaly coding with dialects.
4. ~~Fixture probes / YAML corpus~~ → [FIXTURES.md](FIXTURES.md) · [fixtures/](fixtures/).
5. ~~Structure Position / Line Scan names~~ → **N-pos** / **N-scan** (GLOSSARY + SPEC).
6. ~~More SPEC worked examples for L1 / L6 / R4~~ (partial).
7. Harness later (assert `adm` + `result` without source reachback). Do **not** re-densify fixtures without a closed-law gap.

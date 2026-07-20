# UDON Core Language Specification

**Universal Document & Object Notation**  
**Status:** normative (middle pillar)  
**Companion documents:** [GLOSSARY.md](GLOSSARY.md), [MODEL.md](MODEL.md), [SEMANTICS.md](SEMANTICS.md), [DECISIONS.md](DECISIONS.md)

This document is the legal contract for UDON *surface recognition*: how source
text maps to the Abstract Document Model. It does not teach idiomatic style
(see `pedagogy/`) and does not define Host projection, Schema constraint, or
Dialect evaluation beyond what Core must recognize.

---

## 1. Conformance

### 1.1 Requirement language

The key words **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY**
in this document are to be interpreted as described in RFC 2119.

### 1.2 What a conformant recognizer does

A conformant **Recognizer** MUST:

1. Map any finite UTF-8 input to an ADM instance plus Anomaly list per this
   specification and [MODEL.md](MODEL.md).
2. Implement Keep-Everything wherever this document defines a keep path.
3. Recognize all Markers, Value forms, and sugar desugarings specified here.
4. Treat Dialect *meaning* as optional: it MUST recognize Envelope and Dynamics
   *syntax*; it MAY leave bodies unresolved when no Dialect is loaded.

A conformant Recognizer is **not** required to implement any particular
Dialect, Schema, mixin expansion, or Reference resolution mode.

### 1.3 Compliance tests

When a canonical fixture suite is published for a version of this contract,
passing that suite is the operational definition of recognition compliance.
Until then, this prose is authoritative.

---

## 2. Architecture

### 2.1 Core responsibilities

Core fixes:

- Structure markers and Structure Position recognition
- Indentation geometry and the Nesting Rule
- Frozen Core Scalar Set and List / Envelope / Flow / Node Value *syntax*
- Attribute Stacking and order preservation
- Element sugar (`[key]`, `.trait`, flag suffixes) → Designated Attributes
- Geometric vs Delimited extent, including end of input
- Anomaly classification (Warning vs Error) for recognition

### 2.2 What Core deliberately leaves open

| Concern | Owner |
|---------|--------|
| Projection (validated string → native value) | Host |
| Constraint (cardinality, vocabularies, “allowed keys”) | Schema |
| Exotic typing meaning | Dialect |
| Reference resolution mode | Host (menu in §12) |
| Mixin inheritance | Host (experimental; not required) |
| Duplicate `(name, key)` policy | Document layer (menu in §12) |
| Markdown interpretation of Text | layers above Core |

**Menu vs knob:** Core MAY specify a finite option space and a default. A
Consumer MUST choose within that space and MUST NOT invent options outside it.

**Dialects are not Schemas.** A Dialect says what a value means; a Schema says
what is allowed. They MUST NOT trade jobs.

### 2.3 Streaming

UDON is a **bounded-lookahead** language: every Structure Position Guard
resolves with a small fixed number of characters and no deep backtracking.
New syntax SHOULD preserve that bound so incremental recognition remains
possible. Chunk boundaries are not end of input.

---

## 3. Document geometry

### 3.1 Lines and columns

- Input is a sequence of lines separated by U+000A (newline). A final line
  need not end with newline; end of input is newline-equivalent for Geometric
  Constructs (§13).
- **Column** is the count of leading U+0020 SPACE characters before content.
- **Tabs in indentation are Errors.** A tab that participates in leading
  indentation of a line MUST produce an Error; that line’s structural
  contribution is best-effort (Keep-Everything: treat content after the tab
  as prose of the current owner when a coherent keep exists). A tab *inside*
  Text, values, or comments is ordinary content.

### 3.2 Nesting Rule

Open structural items (Elements, block Directives, block Comments as geometric
participants, block Verbatim) form a stack, each with a **Base Column**.

When a new structural line begins at column `c`:

1. While the stack is non-empty and `c ≤ top.base_column`, close the top item.
2. Open the new item as a child of the new top (or as a Document top-level item
   if the stack is empty).

Consequences:

- **Greater column** than parent Base Column ⇒ child.
- **Same column** ⇒ sibling (parent closed first by step 1).
- **Lesser column** ⇒ ancestor closed until the relation holds.

**Sameline nesting:** Elements appearing later on the same line are treated as
if each began on its own line at its actual column (the column of its `|`).
The Nesting Rule applies with those columns.

**Exception — prose interior:** once an Element has an established **Content
Base** for block prose, a line indented *deeper than that Content Base* is
prose interior (literal Text), not a new structural child, even if it begins
with a Marker-looking character. Structure resumes only at columns `≤`
Content Base (see §7).

### 3.3 Structure Position

**Structure Position** is the state in which Markers are recognized. It is
entered:

1. At the beginning of a line’s content when that line is at a **structural
   column** (not inside prose interior), and
2. During the **Line Scan** on an Element-rooted line: left-to-right through
   Elements and Attributes before any prose Text begins.

At Structure Position, and only there, these Markers are candidates:

| Marker | Opens |
|--------|--------|
| `\|` | Element (or Inline Element if `\|{`) |
| `:` | Attribute (while Element is not yet in Content Phase) |
| `!` | Directive or Verbatim opener |
| `;` | Comment (per §8) |
| `@` | Reference |
| `` ``` `` | Fence |

Each Marker has a **Guard** (§4). If the Guard fails, the character is ordinary
Text.

The first bare prose word (or other non-Marker commitment) **commits the line
to prose** for the remainder of that physical line: later Marker characters are
literal Text, **except** a whitespace-framed sameline comment (` ; `, §8).

### 3.4 Style (non-normative)

A consistent indent step (commonly 2 spaces) aids readers. It is not required
for recognition.

---

## 4. Marker recognition (Guards)

All Guards use bounded lookahead.

### 4.1 Element `|`

`|` opens an Element only when followed by one of:

- a Unicode identifier-start character (`XID_Start`)
- `[` `.` `{` `'`
- a flag suffix character `?` `!` `*` `+` (anonymous flagged Element)

Otherwise `|` is Text (Markdown table rows like `| col |` remain safe).

`|{` opens an **Inline Element** (brace form) even at line start: the line is a
flow/content line whose first segment may be that inline form.

### 4.2 Dynamics `!`

`!` at Structure Position opens a block Directive or block Verbatim when
followed by an identifier character or `:`. Forms such as `![img]`, `!=`, `!(`
are Text.

Inline `!{…}` forms are prose-level (not this Structure Position block rule);
see §10–§11.

### 4.3 Reference `@`

`@` marks when followed by `[`, `.`, or an identifier-start character.
`@` has equal structural footing with `|` in the Line Scan and in value
position (Reference as Attribute value vs Reference as Content child).

### 4.4 Attribute `:`

`:` opens an Attribute only while the owning Element has not entered Content
Phase, and only when followed by a Key (bare or quoted). A bare `:` without a
Key is Text. After Content Phase, a line-initial `:` at an ancestor Attribute
column is Text with a **Warning** (§5.9).

### 4.5 Comment `;`

`;` opens comments per §8 (context-dependent).

### 4.6 Fence

Three U+0060 GRAVE ACCENT characters open a Fence at Structure Position.
They do not open a Fence after the line has committed to prose, nor deeper
than an established Content Base (prose interior).

---

## 5. Elements

### 5.1 Shape

An Element is **Name (optional) + ordered Attributes + ordered Content**.
There are no separate identity/trait fields in the model; sugar desugars to
Designated Attributes ([MODEL.md](MODEL.md)).

### 5.2 Names and bare identifiers

A bare Name is a Unicode identifier:

- first character: `XID_Start`
- continuation: `XID_Continue` or U+002D HYPHEN-MINUS `-` or U+002F SOLIDUS `/`

Hyphenated names (`my-element`) and slash namespacing (`acme/widget`) are
first-class; `/` has **zero** Core semantics.

Characters outside that set end a bare Name. To include them, use single
quotes: `|'weird name'`.

Which Unicode version supplies `XID_*` is a Host/implementation choice; Core
requires only “Unicode identifier” behavior.

### 5.3 Identity and Classification sugar

```udon
|element[key].trait1.trait2
```

| Surface | Desugars to |
|---------|-------------|
| `\|el[k]` | `\|el :'$key' k` |
| `\|el.a.b` | `\|el :'$traits' a :'$traits' b` |
| `\|el?` | `\|el :'$?' true` (and analogously `!` `*` `+` → `$!` `$*` `$+`) |

The interior of `[…]` uses normal value recognition (so `[1]` is integer `1`,
`["01"]` is string `"01"`).

**Unclosed `[`:** if `]` never arrives, the captured value is assigned to
**`$partial-key`** (not `$key`), with a Warning. Same for a Reference selector
key.

**Designated, not reserved.** Any `$`-name is a legal Key. Because `$` is not
a bare-name character, longhand uses quotes (`:'$key' …`). Generators that only
emit Attributes can still produce identities.

**Traits stack:** each `.trait` is a separate `$traits` assignment (Stacking).

A bare `.trait` continuation set additionally includes `*` `!` `?` `+` so that
`.foo?` is the trait string `foo?`. Flag suffixes that must apply to the Element
rather than the trait use space-separated form or appear before the trait:

```udon
|el.bar?         ; traits: ["bar?"]
|el.bar ?        ; traits: ["bar"], $? = true
|el?.bar         ; $? = true, traits: ["bar"]
```

**Identity contiguity:** after a space, `.trait` is not identity sugar
(`|p .gitignore is a file` has no traits).

### 5.4 Flag suffix positions

Suffixes bind to Element identity:

```udon
|name?
|name?[key]
|name?[key].trait
|name[key]?
|name[key].trait ?
```

Meaning of `?` `!` `*` `+` is Schema/Dialect territory; Core only expands them
to boolean true Designated Attributes.

### 5.5 Anonymous Elements

A Name MAY be absent:

```udon
|[k]
|.some-trait :adapter pg
|?
```

### 5.6 Inline Elements `|{…}`

Within Text or Flow Values, `|{…}` opens an Inline Element:

- Brace-balanced; closes at matching `}`.
- Interior Line Scan and Attributes follow Element rules with `}` as an
  additional bare-token terminator (unconsumed).
- Nested structure inside MUST use brace form only (**bracket mode**): block
  form `|name` is not opened inside `|{…}`.
- **[GREENFIELD]** Inline Elements MAY span multiple lines. Continuation-line
  indentation is geometry (not content); each line’s terminator is part of
  content delivery (Consumers that want a single string concatenate).
- Intervening Text between sibling inline Elements (including a single space)
  is real Content.

---

## 6. Attributes

### 6.1 Labeled edges

Attributes are labeled edges from the Element’s perspective. Children are
positional and self-named. Heuristic (*non-normative*): *whose name is it?* —
relationship to parent ⇒ Attribute; what the thing is ⇒ child Element.

Attributes appear **sameline**, **block**, or inside Inline Elements. Value
grammar is uniform; terminators and tail ownership differ by context (§6.6).

**[GREENFIELD]** An Attribute at Document root (no owning Element) is an
**Error**. The line is kept as Document-level Text (including the leading `:`)
so bytes are not lost. Do not rely on free-floating Attributes.

### 6.2 Keys and Flag Keys

Bare Keys use `XID_Start` then `XID_Continue` plus `-` `/` and `?` `!` `*` `+`.
Other characters require single quotes: `:'weird key'`.

A **terminal `?`** on the Key selects **Flag Key** semantics. The Key string
**includes** the `?` (`:ready?` and `:'ready?'` are the same Key).

**Plain Attributes always take a value.** A plain `:key` with no value material
(end of line and no Deferred Value body) is an **Error**; the Attribute is
still recorded with **Nil** value (annotated reason). Presence flags use `?`.

#### Flag rule

After `:key?`, examine the next token in value position:

1. Exactly `true`, `false`, `null`, or `nil` **alone** → that is the flag’s value.
2. **Anything else** (bare word, `|node`, `:next`, end of line, …) → the flag
   is **true**, and that material is **re-owned** by the continuing Line Scan
   (never the flag’s body). No multi-segment warning for this re-owning.
3. Deeper lines under a finished flag follow the finished-value multi-segment
   rule (§6.7).

### 6.3 Value Kinds

An Attribute assignment’s value is one of:

| Kind | Forms |
|------|--------|
| **Scalar** | quoted string, number, boolean, nil, List `[…]`, Envelope `<…>` |
| **Reference** | `@…` |
| **Interpolation** | `!{{…}}` |
| **Node Value** | block-form Element, block Verbatim `!:label:`, or Fence |
| **Flow Value** | prose-shaped text, including values that begin with or contain inline brace forms |

Types live on the map side (Attribute values and List items). Envelopes are
meaningful in value position only.

A block-form `|name` in value position is a **Node Value**. The brace form
`|{…}` in value position is a **Flow Value** segment (Inline-Brace Principle).

### 6.4 Line Scan and Bare Token Boundary

After `:`, recognition collects that Attribute’s value, then continues the
scan for the current owner. Block lines may carry multiple Attributes:

```udon
|el
  :a 1 :b 2
```

Most value shapes self-announce (digit → number, `"` → string, `<` → Envelope,
`[` → List, `@` → Reference, block `|` → Node Value). A committed numeric pattern
that fails mid-token (e.g. `12ab`) **falls through** to an ordinary bare token
without unbounded lookahead; the Bare Token Boundary then applies at its end
(`:x 12ab :y 3` → `x="12ab"`, `y=3`; `:x 12ab more` → Flow Value `"12ab more"`).
A bare word is decided by:

**Bare Token Boundary.** After an unquoted token, the next non-space character:

- **Boundary Marker** → token finishes as a single-token value; scan continues.
  Boundary Markers are block-form Markers (`:`, block `|`, block `@`, block `!`,
  Fence, value-position or boundary `\`) and framed sameline ` ; `.
- **Anything else**, including an **inline brace form** → commit a **Flow Value**
  beginning with this token, running to end of line or framed comment (unless
  value-`\` text mode, §6.5 / §9).

**Inline-Brace Principle.** `|{` `!{` `;{` (and anticipated `@{`) are never
Boundary Markers. They commit Flow Value and participate as inline segments.
`;{…}` contributes no text to the value. Example: `:n value |{em x} :a 1` is one
Flow Value for `n` (trailing `:a 1` is text).

**Keywords:** `true` `false` `null` `nil` are typed only when the token finishes
alone at a Boundary Marker or end of line. Otherwise they begin a Flow Value
(`:alpha true story` → text `"true story"`).

### 6.5 Ownership of Flow Values

When a Flow Value starts, owner priority:

| Priority | Condition | Owner |
|----------|-----------|--------|
| 1 | An Attribute to the left still needs a value, or is **collecting** | That Attribute |
| 2 | Else nearest Element on the same line | That Element’s Content (Content Phase begins) |
| 3 | Else | Ordinary column ownership (not an Error) |

**Collecting:** on an **Attribute-Rooted Line**, the Attribute remains collector
even after its value is finished; further same-line material is multi-segment
ingested with Warning (§6.7). On an **Element-Rooted Line**, a finished
Attribute never collects the tail — the Element takes it (sameline decompress).

#### Deferred Value (multi-line body)

If the Key line ends with no finished value, deeper lines form the value body
under ordinary Nesting / Content Base rules (blank lines like prose):

```udon
|el
  :body
    line one

    line two with |{em emphasis}
```

#### Value-position `\`

Where a plain Attribute still needs a value and no token has started, `\` is
consumed and enters **text mode**: the value is a Flow Value; the rest of the
physical line is included; sameline comment framing is disabled on that line.
Owner rules unchanged.

```udon
|el :count \7 apples     ; count = text "7 apples", not integer 7
```

### 6.6 Contexts and terminators (bare tokens)

| Context | Extra bare terminators | Tail after finished value |
|---------|------------------------|---------------------------|
| Element-rooted line | (space, newline) | Element Content |
| Attribute-rooted line | (space, newline) | multi-segment + Warning |
| Inside `\|{…}` | `}` unconsumed | Inline Element content |
| List item | `]` unconsumed | *(no tails)* |

Framed ` ; ` opens a sameline comment on Element and Attribute lines except in
value-`\` text mode. Unspaced `;` may be part of a token
(`:url https://example.com/a?q=1;s=2`).

Inside Inline Elements, bare `;` is literal; only `;{…}` comments
(**[GREENFIELD]** affirmation of intended long-term rule; framed sameline
comments inside `|{…}` are not required).

**List items:** no Flow Values; quote strings with spaces. `}` is not a List
terminator. Quoted item end allows adjacent items: `["x"y]` is two items.

### 6.7 Stacking and multi-segment ingest

Same Key repeated ⇒ ordered Stacking of assignments (heterogeneous Values
allowed). Orthogonal to List literals:

```udon
|el :x 1 :x 2         ; two assignments
|el :x [1 2] :x [3]   ; assignments: List[1,2] then List[3]
```

After a value is finished, additional material under that Key on an
Attribute-Rooted Line (same line or deeper) is ingested as further segments /
stacked values with a **Warning**, never silently dropped. Flags are exempt
from same-line extension (Flag rule re-owns instead).

Preferred warning-free multi-value style: write the Key again (Stacking) or use
an explicit List.

### 6.8 Node Values

Block form binds a Node Value; brace form is Flow text:

```udon
|el :x |em hi      ; x is Element em
|el :x |{em hi}    ; x is Flow Value with inline em
```

Once a Node Value opens on a line, its Line Scan owns the rest of that line
(**One-Way Door**). Put outer Attributes *before* the node-valued Attribute, or
use a Deferred block.

**No Attribute-under-Attribute:** a deeper line that is itself `:key` directly
under an Attribute (not inside a Node Value) is an **Error**; the line is
ingested as Text of the open value (Keep-Everything).

### 6.9 Content Phase and late `:`

Attributes MUST precede Content of the same Element in the model’s construction
order from the surface. Sameline tails that become Content **do** enter Content
Phase. A later line-initial `:` that would have been an Attribute of an Element
already in Content Phase is Text of the column owner, with a **Warning**.

---

## 7. Prose and Content

### 7.1 Prose

Any line not opening a Marker at Structure Position is prose Text of the
current owner. Core treats prose as **opaque Text** (no Markdown parsing).

Prefer Markdown spelling for simple emphasis when a Schema/renderer supports
it; reserve `|{…}` for attributed or non-Markdown structure (*non-normative*
guidance).

### 7.2 Prose Dedentation

1. Sameline Text on the Element line does **not** establish Content Base.
2. The first indented content line establishes **Content Base** (author’s choice
   within the valid range).
3. Later lines at column ≥ Content Base: strip Content Base spaces; extra spaces
   remain in Text.
4. Later lines still inside the Element but column < Content Base: **Warning**,
   set Content Base to the new column, continue.

Valid indented columns lie between the parent’s Base Column (exclusive) and any
inline child’s Base Column (inclusive).

Each prose line’s line terminator is part of Text; stripped indentation is
geometry only.

### 7.3 Blank lines

Inside Element Content, blank lines are Text newlines. At pure structure
boundaries, a normalizing Document layer MAY treat blanks as ornamental
(SEMANTICS).

### 7.4 Fences and dedentation

Fence bodies are **not** prose-dedented (§10).

---

## 8. Comments

### 8.1 Forms

| Form | Surface | Notes |
|------|---------|--------|
| Line / block | `;` at Structure Position | Participates in Nesting Rule (geometric) |
| Continued | more-indented lines under a line comment | Entirely comment Text until dedent to comment column; first continuation line sets strip column (Content Base shape) |
| Sameline framed | whitespace + `;` + (whitespace or EOL) | Allowed even after prose commit; disabled in `\`-forced text |
| Inline | `;{…}` | Brace-balanced; only comment form inside ordinary prose flow |

Comments MUST be retained in the ADM; Consumers MAY strip in a view.

### 8.2 Where `;` is literal

Block prose deeper than Content Base; unframed sameline prose; value-`\` text;
inside `|{…}` except `;{`; attribute values when not framed as sameline comment.

### 8.3 Escaping a leading semicolon

A Structure Position `\` forces the line to prose, so `\; …` yields Text
starting with `;`.

---

## 9. Escape (`\`)

Position alone disambiguates four uses:

| Position | Effect |
|----------|--------|
| Structure Position | Consume `\`; rest of physical line is prose Text; sameline comments disabled; inline forms still active and escapable |
| Immediately before inline opener `\|{` `!{` `;{` in prose/flow | Consume `\`; opener becomes literal |
| Value-expected (plain Attribute needs value) | Consume `\`; enter text mode Flow Value (§6.5) |
| Anywhere else | Literal `\` (Host MAY interpret `\n` etc.; Core does not) |

A leading literal backslash doubles: first `\` forces prose (Structure
Position), second is content → `\\` yields `\`.

Consumed Structure Position `\` occupies no column for Content Base: text after
it backs into the column where the `\` sat for indent purposes.

A `\` deeper than an established Content Base is not Structure Position; it is
literal (no required Warning at recognition; Host tooling MAY warn).

`'` is not an escape; it delimits strings/names/keys. Inside quoted strings,
`\` follows string rules (§11.3).

---

## 10. Verbatim

One family, three forms — body never UDON-parsed:

| Form | Surface | Body geometry |
|------|---------|----------------|
| Block | `!:label:` | Dedent to first content line’s column (raw base); ends at line column ≤ directive Base Column. Body MAY begin on the opener line after the closing `:` |
| Fence | `` ``` `` | Byte-exact; no dedent; no Marker interpretation. Closer: line whose first non-space content is `` ``` ``, any indent; trailing spaces before newline ignored. Indent before closer is already body if present |
| Inline | `!{:kind:…}` | Brace-balanced; optional single space after label’s `:` is separator, not content |

Block Verbatim and Fences MAY be Node Values. Prefer `!:lang:` for ordinary
code samples; Fences for true byte-exact capture.

**[GREENFIELD]** Inline Verbatim MAY appear in value position as a Flow Value
segment (uniform with other inline brace forms). When used as an entire value
via block form, it is a Node Value as today.

---

## 11. Values (Frozen Core and syntax)

### 11.1 Syntactic typing

Type comes from syntax. Bare recognition is a **closed** Frozen Core Scalar Set.
All other typed values use the Envelope.

### 11.2 Numbers

**Integer** (optional leading `+`/`-`; `_` between digits ignored):

| Base | Prefix | Example |
|------|--------|---------|
| Decimal | none or `0d`/`0D` | `42`, `1_000_000`, `0d42` |
| Hex | `0x`/`0X` | `0xFF` |
| Octal | `0o`/`0O` | `0o755` |
| Binary | `0b`/`0B` | `0b1010` |

A leading `0` followed by decimal digits is decimal (`0755` = 755), not octal.

**Float:** fractional part and/or exponent: `3.14`, `1e10`, `1.5e-3`.

**[GREENFIELD]** Bare rational (`1/3r`) and complex (`3+4i`, `5i`) are **not**
Core scalars. Write them in a Dialect Envelope when that Dialect exists (e.g.
`<r:1/3>`, `<c:3+4i>` — exact spelling is Dialect-defined). Until then, those
spellings are ordinary bare strings / Flow Values if they appear unquoted.

### 11.3 Strings

`"…"` and `'…'` are strings. **[GREENFIELD]** Strings MAY span lines; interior
newlines are content. Unclosed at end of input → Warning + Incomplete Input
flag (§13).

Escape sequences inside quotes: `\\` `\"` or `\'` (matching delimiter) MUST be
recognized; other `\` + char is literal pair unless a future revision extends
the set (Host MUST NOT invent Core escapes).

Unquoted bare text that is not another scalar is a string or Flow Value per
§6.4.

### 11.4 Booleans and Nil

- Boolean: `true` / `false` only (lowercase), alone at boundary.
- Nil: `null` and `nil` (equivalent), alone at boundary.
- Flag Key bare ⇒ true.
- Absent Key ≠ Nil ≠ False (four-way distinction).

### 11.5 Lists

`[ item item … ]` space-delimited; each item full Value rules except Flow Value.
**[GREENFIELD]** Lists MAY span lines; newlines between items are whitespace.
Unclosed at EOF → Warning + Incomplete Input.

### 11.6 Envelope `<…>`

In value position, bare `<` opens an Envelope; matching `>` (depth-counted)
closes it. To start a string with `<`, quote it.

**[GREENFIELD / affirmed]** Envelopes MAY span lines; newlines are content.

Label Ladder: `<content>`, `<type:content>`, `<dialect:type:content>`.

Unlabelled envelopes are offered to declared Dialects in order; first claim
wins; if none claim, Error (or Warning if no Dialects loaded — keep text).

Nested `<>` balance is required; routing of nested typed values is Dialect
concern.

**Temporal:** all temporal values require Envelope; bare `2026-07-11` is string
`"2026-07-11"`. See [dialects/temporal.md](dialects/temporal.md).

---

## 12. Dynamics and References (Core syntax only)

### 12.1 Dynamics syntax

| Form | ADM |
|------|-----|
| `!name …` at Structure Position | Directive (`raw=false`); body UDON Content by Nesting Rule |
| `!:label:` | Verbatim block (`raw=true`) |
| `!{{expr}}` | Interpolation; ends at first `}}` |
| `!{directive …}` | Inline Directive; UDON-parsed interior |
| `!{:kind:…}` | Inline Verbatim |

Any directive name is accepted at recognition; meaning is Dialect/Host.

Expression language, truthiness, filters, and control-flow *meaning* are
specified in [dialects/dynamics.md](dialects/dynamics.md) (baseline Dialect).

### 12.2 References

Surface → Selector `(name, key, traits)`:

| Surface | Selector |
|---------|----------|
| `@[mit]` | `(absent, mit, [])` |
| `@licence` | `(licence, absent, [])` |
| `@licence[mit]` | `(licence, mit, [])` |
| `@.realized` | `(absent, absent, [realized])` |
| `@licence[mit].realized` | `(licence, mit, [realized])` |

Traits filter matches; they do not modify the referent. No suffixes, Attributes,
or predicates on References in Core.

References are **inert** at Core. Host resolution **menu**:

`transclude` | `merge-attributes` | `leave-inert` (default)

`@[key]` alone MAY be ambiguous across names; recognition still succeeds; resolve
time MAY Error.

### 12.3 Duplicate definitions

Two Elements with the same Name and same Identity Key are a **duplicate
definition**. This is Document-layer, not streaming recognition.

**Menu** (default **error**):  
`error` | `allow-if-identical` | `first-wins` | `last-wins` | `keep-all`  
optional `warn` modifier.

### 12.4 Mixins (non-core)

A Host MAY treat an Anonymous Element that carries only Classification (and
Attributes) as a mixin when another Element lists the same trait. Core sees only
what is written. Conformant systems need not implement mixins.

---

## 13. Extent and end of input

### 13.1 Geometric vs Delimited

- **Geometric:** Element, block Directive, block Comment, Deferred Value,
  block Verbatim, block prose — closed by end of line, dedent, or end of input.
- **Delimited:** quoted strings, Lists, Inline Elements, inline comments,
  Interpolation, inline Directive/Verbatim, Envelope, Fence, identity `[…]`.

### 13.2 Multi-line policy

**[GREENFIELD]** All Delimited Constructs MAY span multiple lines. Interior
newlines are content (or item whitespace inside Lists) unless a construct’s
section says otherwise. Geometric Constructs already span by geometry.

This replaces the source’s “deliberately undefined for most delimited forms.”

### 13.3 End of input

At true end of input, close all open constructs innermost-first:

- **Geometric:** close silently (EOF ≡ newline for this purpose). Missing final
  newline alone is not an Anomaly.
- **Delimited still open:** keep captured content; emit a **Warning** citing the
  open site; close the construct. Each open delimited frame yields its own
  Warning.

If any Delimited Construct was still open at true EOF, the Document also
carries **Incomplete Input** = true (Document-layer non-success signal).
Streaming chunk boundaries are not EOF.

---

## 14. Anomalies

### 14.1 Severity

| Severity | Meaning |
|----------|---------|
| **Warning** | Content kept; may not match author intent |
| **Error** | Loss or illegal geometry (e.g. tab in indent); recognition continues |

### 14.2 Keep-Everything

Where this specification defines a keep representation, a Recognizer MUST use
it and SHOULD prefer Warning over Error. Silent drop of author-visible material
is non-conformant.

Document rejection, halt, or “fail the build on warnings” are Consumer policies
on top of recognition results — **menu** left to Host/Document layer, not a
second silent recognition mode.

### 14.3 Representative cases

| Situation | Severity | Keep shape |
|-----------|----------|------------|
| Unclosed delimited | Warning (+ Incomplete at EOF) | Partial content |
| Unclosed identity `[` | Warning | `$partial-key` |
| Trailing text on Attribute-rooted finished value | Warning | Multi-segment / stack |
| Late `:` after Content Phase | Warning | Text |
| Plain `:key` missing value | Error | Attribute with Nil |
| Attribute under Attribute | Error | Text ingest into open value |
| Tab in indentation | Error | Best-effort line keep |
| Inconsistent prose indent | Warning | Rebase Content Base |

---

## 15. Design principles (normative constraints)

1. **Attributes before Content** for each Element (Content Phase rule).
2. **Spaces only** in indentation.
3. **Syntactic typing** with a frozen bare set and explicit Envelopes.
4. **Stacking, not last-wins**, for Attributes.
5. **Bounded lookahead** for Markers.
6. **Sugar is Designated Attributes**, not parallel model fields.
7. **References inert at Core.**

---

## Appendix A — Quick surface map (non-normative)

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

## Appendix B — Implementer note: Nesting Rule (non-normative)

An implementation may maintain an explicit stack and “pop while
`new_column ≤ top.base_column`.” That phrasing is an implementation technique
for §3.2, not a second normative API.

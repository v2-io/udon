# UDON Glossary

**Status:** normative for terminology.  
Every formal noun used in this suite is defined here. Synonyms from older
material that are **retired** are listed at the end so they do not re-enter
the contract by accident.

**Policy:** mechanical / recognizer terms (Structure Position, Line Scan,
Bare Token Boundary, Nesting Rule, …) are defined here so CORE can use them
precisely, but they **SHOULD NOT** be the primary vocabulary of pedagogy or
Host-facing API docs. Prefer Element, Attribute, Content, Value, Document.
See [GRAMMAR.md](GRAMMAR.md) for the implementer-oriented restatement of
mechanical rules.

Terms are sorted case-insensitively within groups.

---

## 1. Architecture

| Term | Definition |
|------|------------|
| **Core** | The syntax and core semantics every conformant recognizer MUST implement identically: markers, geometry, frozen scalars, stacking, sugar desugaring, extent rules, anomaly recognition. |
| **Dialect** | A layer that says what a non-core value or dynamic form *means / types* (e.g. `temporal@1`, baseline `!` expressions). Distinct from Schema. |
| **Schema** | Constraint: what is *allowed* or *required* (cardinality, vocabularies, duplicate policies for application meaning). Never Core. |
| **Host** | The environment that consumes a recognition result: supplies Dialects, resolves References, projects typed strings to native values, chooses Document-layer policies. |
| **Consumer** | Any layer above recognition (Host, document builder, Schema, application). |
| **Document layer** | The Consumer that assembles a whole Document and enforces document-wide rules (e.g. duplicate definition policy). |
| **Recognition** | The mapping from source text to Abstract Document Model instances plus Anomaly records. Independent of any particular parser implementation. |
| **Menu vs knob** | Core MAY fix an option *space* and a default; a Consumer picks within that space (a knob). A Consumer MUST NOT invent options outside the menu. |

---

## 2. Document structure

| Term | Definition |
|------|------------|
| **Document** | An ordered sequence of top-level Content items (Elements, Directives, Comments, Verbatim blocks, prose segments, blank-line text) at column 0. |
| **Element** | A named (or anonymous) structural node: optional **Name**, ordered **Attributes**, and ordered **Content**. Surface form begins with `\|`. |
| **Name** | The element type label (e.g. `database` in `\|database`). Optional; absent ⇒ **Anonymous Element**. |
| **Attribute** | A labeled edge from an Element: a **Key** and one or more **Value** assignments under that key, in source order (**Stacking**). Surface form begins with `:`. |
| **Key** | The attribute’s label. Distinct from **Identity Key** (`$key`). |
| **Content** | The ordered body of an Element: interleaved **Text**, child Elements, References, Directives, Comments, Verbatim, blank lines. |
| **Child** | A content item that is itself an Element (or Reference treated as a structural peer). Children are positional and self-named. |
| **Identity** | What makes an Element uniquely *this* instance within its type: the designated attribute `$key`, usually written with `[…]` sugar. |
| **Identity Key** | The value of `$key`. |
| **Classification / Trait** | What *kinds* of thing an Element is: values of the designated attribute `$traits`, usually written with `.trait` sugar. Plural, ordered, stacked. |
| **Designated Attribute** | An ordinary attribute whose name the sugar targets (`$key`, `$traits`, `$?`, `$!`, `$*`, `$+`). Designated, not reserved — any `$`-name is legal. |
| **Anonymous Element** | An Element with no Name (`\|[k]`, `\|.trait`, `\|?`). |
| **Flag Suffix** | Trailing `?` `!` `*` `+` on an Element identity, desugaring to designated boolean attributes. |
| **Flag Key** | An attribute Key ending in `?`, selecting presence/boolean semantics. |

---

## 3. Values

| Term | Definition |
|------|------------|
| **Value** | What an Attribute assignment carries. One of the **Value Kinds**. |
| **Value Kind** | Scalar, Reference, Interpolation, Node Value, or Flow Value — or an ordered array of segments under one Key (via Stacking or multi-segment ingest). |
| **Scalar** | Quoted string, number, boolean, nil, List, or typing Envelope. |
| **Frozen Core Scalar Set** | The closed set of types recognized bare from syntax alone. Nothing is ever added to bare recognition. |
| **List** | A `[…]` value: space-delimited items, each typed by the normal value rules. No Flow Values inside. |
| **Envelope** | The `<…>` form carrying a Dialect-typed value in value position. |
| **Label Ladder** | Envelope specificity: unlabelled `<…>`, type-labelled `<type:…>`, dialect-and-type-labelled `<dialect:type:…>`. |
| **Node Value** | An Attribute value that *is* an Element, Verbatim block, or Fence (block form, no anonymous wrapper). |
| **Flow Value** | A prose-shaped value: a sequence of Text and inline-form segments that resolves to text after Consumer processing. |
| **Segment** | One piece of a Flow Value or of a multi-segment attribute assignment (text, interpolation, inline element, …). |
| **Stacking** | Repeated same-Key attributes accumulate as an ordered list of assignments, never last-wins. Orthogonal to List literals. |
| **Absent / Nil / False / True** | Four distinct presence states for attributes — see CORE. |
| **Syntactic Typing** | Type is determined by syntax, not by sniffing string content. |

---

## 4. Geometry and recognition contexts

| Term | Definition |
|------|------------|
| **Column** | Zero-based count of leading spaces on a line (before content). Tabs in indentation are Errors. |
| **Base Column** | The column where an Element’s `\|` sits; nesting compares new lines against Base Columns on the open stack. |
| **Content Base** | The column where an Element’s indented prose first starts; used to strip (dedent) subsequent prose lines. |
| **Nesting Rule** | A new structural line attaches by: greater column ⇒ child; same column ⇒ sibling; lesser column ⇒ close ancestors until the rule holds. Formally: close open items while `new_column ≤ top.base_column`, then open the new item. |
| **Structure Position** | The state in which markers are recognized: at the start of a line’s content (at a structural column), or during the **Line Scan** along an Element line through Elements and Attributes before prose begins. |
| **Line Scan** | Left-to-right pass on an Element-rooted line (and similarly inside inline Elements) collecting Attributes and nested structure until prose commits. |
| **Block** | A construct on its own indented line. |
| **Sameline** | A construct on the Element’s definition line. |
| **Inline** | A construct within prose or Flow Value text (brace forms). |
| **Marker** | A Structure-Position special start: `\|` `:` `!` `;` `@` or triple-backtick Fence. |
| **Guard** | The short, bounded lookahead that decides whether a character opens a Marker. |
| **Boundary Marker** | A block-form Marker (or framed sameline comment, or value-position `\`) that ends a bare token as a finished single-token value. Inline brace forms are never Boundary Markers. |
| **Bare Token Boundary** | After an unquoted value token, the next non-space character decides “finished scalar” vs “start of Flow Value.” |
| **Inline-Brace Principle** | No inline brace form (`\|{`, `!{`, `;{`, and anticipated `@{`) is ever a Boundary Marker; meeting one commits a Flow Value. |

---

## 5. Ownership and extent

| Term | Definition |
|------|------------|
| **Element-Rooted Line** | A line that contains an Element. After a finished Attribute value, trailing material becomes that Element’s Content. |
| **Attribute-Rooted Line** | A line rooted by `:key` with no Element on it. The Attribute remains the line’s collector; trailing material after a finished value is multi-segment ingested with a Warning. |
| **Ownership** | Priority rules deciding who receives trailing text: open Attribute needing/collecting a value; else nearest Element on the line; else ordinary column ownership. |
| **Deferred Value** | A value body on deeper indented lines under a Key that finished the key line without a complete value. |
| **Geometric Construct** | Extent from geometry: end of line, dedent, or end of input. |
| **Delimited Construct** | Extent from a matched end-sequence (quotes, brackets, braces, `>`, fence close, …). |
| **One-Way Door** | Once a Node Value opens on a line, later Attributes and content on that line bind to the *node*, not the outer Element. |

---

## 6. Text, comments, verbatim, dynamics

| Term | Definition |
|------|------------|
| **Prose / Text** | Non-marker content belonging to an Element (or Document). Opaque to Core Markdown interpretation. |
| **Prose Dedentation** | Stripping each prose line’s leading spaces down to Content Base so source can indent while text stays clean. |
| **Comment** | `;…` line or block comments, framed sameline ` ; `, or inline `;{…}`. Carried to the Consumer; not discarded by recognition. |
| **Escape (`\`)** | Position-disambiguated: Structure Position forces rest of line to prose; before inline opener escapes it; value-expected position enters text mode; elsewhere literal. |
| **Verbatim** | Opaque body never UDON-parsed: block `!:label:`, Fence `` ``` ``, inline `!{:kind:…}`. One family, three forms. |
| **Fence** | Triple-backtick Verbatim form: byte-exact body, no dedent, no marker interpretation inside. |
| **Dynamics** | The `!` family: Directives, Interpolation, Verbatim openers. Core recognizes syntax; a Dialect gives meaning. |
| **Directive** | `!name …` (block) or `!{name …}` (inline): name host-defined; body UDON-parsed unless raw/Verbatim form. |
| **Interpolation** | `!{{expr}}`: expression unparsed by Core; Host evaluates. |
| **Reference** | `@…`: an inert selector at Core; Host resolves. |
| **Selector** | The tuple `(name, key, traits)` a Reference matches against. Traits filter; they do not augment the target. |

---

## 7. Anomalies

| Term | Definition |
|------|------------|
| **Anomaly** | A Warning or Error produced during recognition. |
| **Warning** | Content was kept; something may not match author intent. |
| **Error** | Something was lost or could not be represented cleanly (e.g. tab in indentation); recognition continues unless the Consumer stops. |
| **Keep-Everything** | Where a coherent representation exists, recognition MUST capture all source bytes as structure or text, preferring Warnings over silent drop. |
| **Incomplete Input** | Document-level non-success when a Delimited Construct remains open at true end of input. |

---

## 8. Retired synonyms (do not use in normative text)

| Retired | Use instead |
|---------|-------------|
| freeform | Fence |
| embedded (element) | Inline Element |
| positional (close-axis) | Geometric |
| text blob / blob | Flow Value (or Text) |
| head position | Structure Position |
| sameline scan (as jargon dump) | Line Scan |
| AST layer (in the contract) | Document layer / Consumer |
| wire / event stream (in the contract) | *(out of scope for this suite)* |
| raw (as free noun) | Verbatim (name the form: block / fence / inline) |
| parse / parser (as subject of rules) | Recognition / recognizer — except in non-normative implementer notes |

Older design notes and the scrubbed source may still use retired terms; this
suite does not.

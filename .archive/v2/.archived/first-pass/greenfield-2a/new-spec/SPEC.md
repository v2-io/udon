# The UDON Language Specification

**Universal Document & Object Notation — greenfield draft (2a)**

**Normative.** This document is the contract between the UDON language and implementers. It defines which character sequences are UDON, what each construct means in terms of the Abstract Document Model (ADM.md), and what a conforming implementation is required to do — on well-formed and malformed input alike. It is deliberately dry; teaching material lives in the pedagogy layer, and design rationale in RATIONALE.md. Terminology is fixed by GLOSSARY.md; a formal term not defined there is not used here.

The key words MUST, MUST NOT, REQUIRED, SHALL, SHOULD, SHOULD NOT, RECOMMENDED, MAY, and OPTIONAL are to be interpreted as described in RFC 2119.

---

## 1. Conformance

### 1.1 What conformance means

An implementation is a **conforming UDON parser** iff:

1. It produces, for every input, a representation from which the ADM is recoverable without loss (ADM.md).
2. It implements the anomaly contract of §11 — in particular the keep-everything requirement and the two-level severity model.
3. It passes the canonical conformance fixture suite for the spec version it claims. *(No suite ships with this draft; until one is published for a given version, this clause is a design commitment, not a checkable requirement — the `../snippets/` corpus is the natural seed.)* **Passing the fixture suite is the definition of compliance**; the prose of this document and the suite are maintained together, and a demonstrated divergence between them is a defect in one of the two, to be resolved by ruling — never by an implementation's behavior.

A conforming parser is NOT required to implement any dynamics dialect (§8), any typing dialect (§10.4), reference resolution (§9), or Markdown interpretation (§6.5). Those are consumer layers.

### 1.2 Versioning

The specification carries a semantic version. A conformance claim names the version whose fixture suite it passes. Components above the core (parsers, schema tools, renderers) version independently and declare the core range they obey.

### 1.3 What the core fixes, and what it leaves to consumers

The core fixes **syntax** and **core semantics**: recognition, the bare scalar set, attribute stacking and order, definition (`|`) vs. reference (`@`), the envelope syntax, and the anomaly contract. Everything else is deliberately a consumer's:

- **Projection** — how a host turns a validated string into a native value.
- **Constraint** — what is allowed or required. This is a **schema**'s job; proscription never lives in the core.
- **Exotic typing** — what envelope contents mean. This is a **dialect**'s job. A dialect types; a schema constrains; they never trade jobs.

Two boundary rules keep the split honest:

- **Menu vs. knob.** Where consumer choice exists, the core fixes the option space and the default; a consumer picks within the menu and MUST NOT invent options outside it.
- **Additivity of dialects.** Dialects act only inside envelopes (§10.4); bare recognition is frozen. Loading a dialect can therefore never retype an existing document.

---

## 2. Source text

A UDON document is a sequence of Unicode scalar values encoded as UTF-8. A **line** is a maximal run of characters terminated by a line terminator or by end of input. Line terminators are part of the document's text material where §6 and ADM §4 say so; they are never structure by themselves.

---

## 3. Lines, columns, and recognition

### 3.1 Indentation and columns

**Indentation** is the run of space characters (U+0020) before a line's first other character. Columns are counted from 0.

- Indentation MUST consist of spaces only. A tab anywhere in a line's indentation is an anomaly: the line's structural column cannot be honored, so the line is taken as **text of the current column owner** (using the spaces before the tab as its column), with a **warning** — a coherent keep exists, so by §11.2's own definition this is not an error. A tab elsewhere is ordinary content. *(Peer-review credit: the earlier draft declared the line lost, inheriting the source's posture; greenfield-3b found the keep.)*

Hierarchy is by column. For any two structural lines:

1. **Deeper column ⇒ child.** A node beginning at a column greater than an open node's column is inside it — with one exception: a line indented deeper than an established content base (§6.2) is inside that *text*, and is text.
2. **Same column ⇒ sibling.** To be inside an element you must be at a strictly greater column than the element's own marker.
3. **Shallower column ⇒ dedent.** Every open node whose column is ≥ the new line's column closes, innermost first.

Elements introduced mid-line (§5.4) occupy their true columns: a line of nested elements is equivalent, for all hierarchy purposes, to the same elements written on successive lines at those columns. Once a node has closed, its former column has no residual meaning.

A consistent sibling indent is RECOMMENDED style; it is not a rule of the language.

### 3.2 Markers

Structure begins only with a **marker**:

| Marker | Introduces |
|---|---|
| `\|` | element (§4) |
| `:` | attribute (§5) |
| `!` | dynamic: directive, verbatim, interpolation (§7, §8) |
| `;` | comment (§6.4) |
| `@` | reference (§9) |
| ```` ``` ```` | fence (§7.3) |

One further character is special at recognition points: the escape `\` (§3.5). Any line that does not begin structure is text belonging to its owner (§6).

### 3.3 Open position and committing to text

Markers are recognized at **open position** and only there. A line is open:

- at its start, at a structural column (this recurs on *every* line — structure, text, and fences interleave freely); and
- along **the scan** (§5.4): the run through elements and attributes on a line, until the first content word.

The first content word **commits** the line to text: from there to end of line every marker character is literal, with exactly one exception — the **framed sameline comment** (§6.4): a `;` with whitespace before it and whitespace or end-of-line after it opens a comment even after commitment. Nothing else survives commitment; this single rule is what keeps Markdown tables, `:-)`, mid-text `!`, and after-text backticks literal.

Inside flow, the **inline forms** (§6.3) are recognized independently of open position — they are flow's own structure, not line structure.

### 3.4 Guards

At open position each marker is confirmed by a **guard** — a bounded lookahead of a few characters. If the guard fails, the character is literal text and the line's fate is decided as if the character were any other.

- **`|`** marks an element when followed by: an identifier-start character (§4.1), `[`, `.`, `'`, `{`, or a flag-suffix character (`?` `!` `*` `+`). Otherwise literal — in particular `| ` (pipe-space) is always text, which preserves Markdown tables. A `|{` at open position opens an inline element as the first segment of a flow line; it participates in hierarchy at its column like any content.
- **`!`** marks a dynamic when followed by an identifier character or `:` (`!if`, `!:lang:`). So `![img](x.png)`, `!=`, `!(` are text. (`!{…}` forms are inline forms, recognized in flow — not at open position.)
- **`@`** marks a reference when followed by `[`, `.`, or an identifier. `@` alone, or before anything else, is text.
- **`:`** is **phase-gated** rather than character-guarded: it marks an attribute only while its owner can still take attributes (§5.8). A `:` not followed by a key character is text.
- **`;`** marks a comment per the position table in §6.4.
- ```` ``` ```` marks a fence at any open position (§7.3).

The guard bound is a language constraint, not an implementation note: every recognition decision in UDON resolves within a few characters, single-level, with no unbounded backtracking. New syntax MUST stay inside this bound. (Its consequence is streamability: a chunk boundary mid-guard simply waits for the missing characters; a document parses identically whole or byte-by-byte.)

### 3.5 The escape `\`

`\` is UDON's only escape. Its meaning is fixed entirely by **position**; there is no set of escapable characters to memorize.

1. **At open position** — consumed; the rest of the physical line is text. Whatever the next character would have been (`|`, `:`, `!`, `;`, `@`, a fence, or nothing special), it is literal. The resulting text is dead to line-level structure but alive to inline forms (§6.3); the framed sameline comment does **not** apply within it — that affordance is surrendered (a framed ` ; ` there is literal).
2. **In flow, immediately before an inline opener** (`|{`, `!{`, `;{`) — consumed; that opener is literal; flow continues normally.
3. **At value position** (§5.5) — consumed; the value becomes flow text (same surrendered-comment posture as 1).
4. **Anywhere else** — a literal backslash. `C:\Users\me`, a trailing `\`, `\w` mid-word: all pass through. Any escape-sequence reading (`\n`, line-joining) belongs to host layers, never the core.

A literal leading backslash therefore doubles: `\\x` → text `\x` (the first is consumed at open position, the second is already text). A consumed open-position `\` occupies no column for text purposes: the text after it backs into the `\`'s own column, and — being the line's first content — that column becomes the content base (§6.2), which makes a `\`-anchored first line the idiom for indenting a whole text block:

```udon
|el |another
   \     all of this is output indented,
         and deeper lines need no marker;
```

A `\` that begins a line's content *deeper than an established content base* is not at open position — the whitespace before it was already text — so it is literal, silently (rule 4).

Inside quoted strings, `\` follows the string form's own rules (§10.2), not this section. `'` is not an escape anywhere.

### 3.6 Block and sameline

A construct is **block** when it stands on its own line (an attribute line, a deferred value, a child element line) and **sameline** when it rides an element's definition line. The value grammar is identical in both; what differs is only (a) the bare-token terminator sets and (b) who owns trailing material — both specified in §5.

---

## 4. Elements

### 4.1 Names

```udon
|name
```

A bare element name is a Unicode identifier: the first character MUST have `XID_Start` (letters; not digits, `_`, or `-`), and each subsequent character MUST have `XID_Continue` or be `-` or `/`. Kebab-case is first-class; `/` is conventional namespacing with no core semantics. Any other character ends the name; names containing other characters are single-quoted: `|'weird name'`. Which Unicode version supplies the properties is a host decision; the rule (UAX #31 identifiers, plus `-` `/`) is the core's.

Flag-suffix characters (`?` `!` `*` `+`) are **not** name characters for elements — a trailing one is a flag suffix (§4.4).

### 4.2 Identity and traits

```udon
|element[key].trait1.trait2
```

- **Identity** `[key]`: what makes this element *this one*. The bracket content is a value by the normal value rules (§10) — `[1]` is the integer 1, `["01"]` the string `"01"`, `[abc-123]` the string `abc-123`.
- **Traits** `.trait`: what kinds of thing it is — plural, stackable, order-preserving. A bare trait value is an identifier as in §4.1 whose continue-set additionally includes `?` `!` `*` `+` (so `.foo?` is the trait `foo?`); other characters take quotes (`.'ns.kind'`).

**Both are sugar.** An element is nothing but name + attributes + content; identity and traits desugar to designated attributes:

| Written | Means |
|---|---|
| `\|el[k]` | `\|el :'$key' k` |
| `\|el.a.b` | `\|el :'$traits' a :'$traits' b` |

Two traits are two `$traits` assignments (stacking, §5.7), not one list.

**Identity is contiguous** with the name (plus one optional trailing space-separated flag suffix, §4.4). A `.trait` after a space is not identity — it is text (`|p .gitignore is a file` has no traits).

**Unclosed identity → `$partial-key`.** If the `]` never arrives (end of input; or an interior line terminator, per this version's line-boundedness, §11.5), the captured value desugars under **`$partial-key`**, not `$key`, with a warning citing the opener. The distinct name is a fail-safe: a consumer reading `$key` — or resolving a reference — automatically excludes a truncated identity instead of acting on it. The partial value is kept. The same rule applies to the key of a reference selector (§9).

### 4.3 Designated attributes

`$key`, `$traits`, `$partial-key`, and the flag-suffix targets are **designated, not reserved**: ordinary attribute keys that the sugar targets. Because `$` is not a bare-key character, writing one longhand takes quotes (`:'$key' v`) — friction by convention, not proscription. A generator that only writes attributes can emit `:'$key' 3890` and produce a document indistinguishable from `|el[3890]`. Every `$`-key is legal, including ones no sugar targets.

### 4.4 Flag suffixes

A trailing `?` `!` `*` `+` on the element identity desugars to a designated boolean attribute:

```udon
|field[name]?    ; ≡ |field[name] :'$?' true      (likewise $! $* $+)
```

The core performs only the expansion; meaning belongs to the consuming schema or dialect. Valid suffix positions — after the name, after the key, or space-separated at the very end:

```udon
|name?[key].trait     |name[key]?     |name[key].trait ?
```

Because suffix characters are trait characters (§4.2), a suffix character touching a trait belongs to the trait: `|el.bar?` has trait `bar?`; `|el.bar ?` has trait `bar` and `$?` true; `|el?.bar` has `$?` true and trait `bar`.

The `$?` key ends in `?` and is therefore itself a flag key (§5.3); the sugar and the longhand mean the same thing by construction.

### 4.5 Anonymous elements

The name is optional. `|[k]`, `|.trait`, `|?` are elements with no name, ordinary in every other respect. The core attaches no meaning to namelessness; consumers may (RATIONALE describes the mixin experiment).

---

## 5. Attributes

### 5.1 The two-sided element

Every element has attributes (a labeled, ordered edge list) and content (a positional node sequence). An attribute's key names what its value is *to the element* (`my author`, `my timeout`); a child names what it *is*. That — whose name is it? — is the design test, not "scalars vs. structure": an attribute's value may be a scalar, a list, flow, or a whole node (§5.6).

Attributes appear sameline, block, and inside inline elements, with one value grammar throughout.

An attribute at document root (a line-initial `:key` with no owning element) is **undefined in this version** (OPEN-QUESTIONS Q1).

### 5.2 Keys

An unquoted key is a Unicode identifier (`XID_Start` start) whose continue-set is `XID_Continue` plus `-`, `/`, `?`, `!`, `*`, `+`. Anything else takes single quotes (`:'weird key'`). `/` is conventional namespacing, core-inert.

### 5.3 Flag keys

A key whose **final** character is `?` selects flag (presence/boolean) semantics; quoted or bare, the same name is the same attribute (`:ready?` ≡ `:'ready?'`). A `?` elsewhere in a key is just a character.

**Plain keys always take a value.** A plain `:key` with no value material is an **error**; the assignment still stands with value Nil (keep-everything — the error explains the Nil). Presence flags are spelled with `?`.

**The flag rule.** After `:key?`, the next token in value position decides:

1. Exactly `true`, `false`, `null`, or `nil`, alone at its boundary — that is the flag's value, consumed.
2. Anything else — a bare word, a node, another `:key`, end of line — the flag is `true`, and that material is **re-owned by the continuing scan** (it is never the flag's body, never a warned extension, never warned).
3. A flag's value always finishes on its own line; deeper material under a flag key is the ordinary finished-value case (§5.7).

```udon
|el :a?                        ; a? = true
|el :a? false                  ; a? = false
|el :a? |beta                  ; a? = true; |beta is el's child
|el :a? well it sure is true   ; a? = true; el text "well it sure is true"
```

The stored key includes the `?` (round-trip fidelity).

### 5.4 The scan

A `:` passing its phase gate begins an attribute; after the key, its value material is collected; then **the scan** continues for the current owner — uniformly, on sameline and block lines alike (a block line is *not* one value running to end of line):

```udon
|el
  :a 1 :b 2        ; two attributes
```

Most value shapes announce their extent from their first character — digit or sign → number; `"`/`'` → string; `<` → envelope; `[` → list; `@` → reference; block-form `|name` → node — and self-terminate. A committed token that goes wrong mid-way (`12ab`) falls through, token-locally, to a bare token and takes the boundary decision like any other.

### 5.5 Bare tokens, the boundary decision, and flow values

A **bare token** holds the scan provisionally open at its end. The next non-space character decides:

- **A guard-confirmed block-form marker** — `:` opening a key, `\`, a fence opener, block-form `|` / `@` / `!` (`|name`, `|[k]`, `|.t`; `@name`, `@[k]`, `@.t`; `!name`, `!:lang:`), or a framed ` ; ` — the token stood alone: it is a single-token value, exactly as if quoted, and the scan continues. A marker character that **fails its guard** (§3.4) is not a boundary: `:3`, `|~`, `!=`, a lone `|` — each is plain text and commits the flow value along with the token before it.
- **Anything else** — plain text *or any inline form* — the line commits a **flow value** starting with this token, running to end of line (or a framed ` ; `), owned per §5.5.1.

**The inline-form principle.** No inline form (`|{…}`, `!{…}` in all three readings, `;{…}`, and any future `@{…}`) is ever a boundary marker or a mode exit. Inline forms are flow-level: meeting one at a bare-token boundary commits the flow value, and the form fires *inside* it as a segment, exactly as in prose. Hence:

```udon
|el :n value |{em x} :a 1
; n = the flow  value ⟨"value " |{em x} " :a 1"⟩ — no :a attribute exists
```

To bind an element as the value, drop the braces (§5.6). A flow value may also *begin* with an inline form: `:n |{em x}` (flow), `:n ;{}` (the empty-string idiom — flow whose text is empty), `:n !{{x}}` alone (an interpolation value, the one-segment degenerate).

Boundary subtlety at `;`: a framed ` ; ` (space before; space/EOL after) finishes the token and opens a comment; `;{` is an inline form (commits flow); an unframed `;x` is literal (commits flow).

**Keywords at the boundary.** `true` / `false` / `null` / `nil` type only when they finish alone; followed by text they are the first word of flow (`:alpha true story` → the string-flow `"true story"`).

Flow values are prose-shaped — the same flow as §6.1, not a second literal dialect: inline forms fire, prose escapes apply, a trailing framed ` ; ` is a comment (except after a value-position `\`, which surrenders it).

#### 5.5.1 Ownership

When a flow value commits, its owner is decided by priority:

| # | Condition | Owner |
|---|---|---|
| 1 | An attribute to the left still needs a value, or is collecting | that attribute's value |
| 2 | else: the nearest element on the line to the left | that element's content (its tail — this *enters the element's content phase*, §5.8) |
| 3 | else | ordinary column ownership: text of whoever owns the column. Not an anomaly. |

**Collecting:** on a **block attribute line** (rooted by `:key`, no element on it) the attribute remains the line's collector even after its value finishes — further same-line material is a warned extension (§5.7). On an **element-rooted line** an attribute never collects past its finished value — the element takes the tail. This asymmetry is the whole difference between the two contexts.

```udon
|el :first value :another with some text
; first="value"; another=flow "with some text"          (row 1)
|el :first value :another "with" some text
; first="value"; another="with"; el tail "some text"    (row 2)
```

#### 5.5.2 Deferred values

If a key line ends with no finished value, the deeper lines under it are the value's body, under the ordinary column and content-base rules — a plain multi-line flow value, or a node (§5.6):

```udon
|el
  :body
    line one

    line two with |{em emphasis}
```

Consecutive text lines under one open value are one multi-line text value (concatenation, per the text law).

#### 5.5.3 Value-position `\`

A `\` where a plain attribute still awaits a value (no token started) is consumed and the value becomes flow text: `|el :count \7 apples` → `count` = `"7 apples"`. The rest of that physical line is the value's first extent and gives up the framed-comment affordance; deeper lines may continue it as a deferred value. A `\` at a *finished* value's boundary is the ordinary boundary escape: the rest of the line is text, owned by the §5.5.1 rules (element tail on an element line; warned extension on a block attribute line) — the `\` sets the text's mode, never its owner.

### 5.6 Node values

An attribute's value may **be** a node — the block-form element, block verbatim, or fence — with no wrapper:

```udon
|api :headers |header :name Content-Type :value application/json
|el
  :beta
    |veni-vidi-vici :working 1234
|el :script !:sh: make build
```

- Once the node opens, **its scan owns the rest of the line**: subsequent attributes, values, and text belong to the node, not the outer element. There is no return to the outer element on that line (put outer attributes first, or defer the node). This follows from the scan; it is restated because it is the most common authoring surprise.
- **Block form binds; brace form is text.** `:x |em hi` → `x` is the `|em` node. `:x |{em hi}` → `x` is flow containing an inline element (§5.5). Drop the braces to bind a node; keep them to inline text.
- **No attribute-under-attribute.** A deeper line that is itself `:key` directly under an open attribute value (not inside a node value) is an **error**; maps-of-maps take a named node carrier (`:theta` + deeper `|config :first 1 :second 2`). The kept shape is the offending line as text of the open value, the error annotating it (kept-shape ruling: OPEN-QUESTIONS Q2).
- One node per declaration is the warning-free shape; to attach several, stack the key (§5.7). A second sibling node at the value's depth is a warned extension.
- To set a flag *and* give the element a child node, use a flag key: `|el :a? |beta` (§5.3).

### 5.7 Stacking and warned extension

**Stacking.** Same-key assignments accumulate, ordered, heterogeneous — `:x 1 :x 2` is two assignments (`x = [1, 2]` through a list view). Stacking is uniform for every attribute; last-wins does not exist. Stacking and list values are orthogonal: `:x [1 2] :x [3]` is two assignments whose values are lists. What is *allowed* (e.g. single-valued `$key`) is schema, never core.

**Warned extension.** Material arriving after a key's value is already finished — same-line trailing text on a block attribute line, or a deeper second value / sibling node / text under a finished value — is kept as a further assignment under that key, with a **warning**; never dropped, never fatal:

```udon
|el
  :attr "first" and here's another one   ; WARN; attr ≈ ["first", "and here's…"]
  :when <7:02pm>
    extra deeper text                    ; WARN; when ≈ [<7:02pm>, "extra…"]
```

The warning marks a real refactoring hazard: joining that block line onto the element line would change ownership (row 2: the tail becomes the *element's*). Deliberate multiplicity is written by stacking the key or using a list. Flags are exempt on the same line (flag rule 2 re-owns), but follow the ordinary finished-value rule for deeper material.

### 5.8 Attributes precede content (phase gate)

All attributes of an element come before any of its content. Once content has begun — a child, text, or a sameline tail (row 2) — a later line-initial `:` at what would have been an ancestor's attribute column is **text** of whoever owns that column, with a **warning** (text that looks like an attribute). A `:` before any content is an attribute; this is the phase gate of §3.4.

```udon
|el :a 1 and a tail
  :b 2          ; WARN — el is past its attribute phase; ":b 2" is el's text
```

### 5.9 Lists

```udon
|server :ports [8080 8443 9000] :tags [api public]
```

`[…]` in value position is a list: items space-delimited, each typed independently by the **full** value rules — numbers, strings, envelopes, nested lists, references, interpolations. No flow inside a list: a bare item is one token; quote items with spaces. A quoted item's closing quote ends the item (`["x"y]` and `["x""y]"` shapes yield two items each, as `["x" y]` does).

### 5.10 Contexts and terminators

One value grammar; contexts differ only in bare-token terminators and tail ownership:

| Context | Bare-token terminators | Tail after a finished value |
|---|---|---|
| Element line (sameline) | space, EOL | element's content (row 2) |
| Block attribute line | space, EOL | warned extension |
| Inline element `\|{…}` | space, EOL, `}` (unconsumed) | inline element's content |
| List item | space, EOL, `]` (unconsumed) | *(items have no tails)* |

- A framed ` ; ` opens a comment on element and block-attribute lines (never inside `\`-forced text). An unspaced `;` is token content (`:url …/a?q=1;s=2`).
- Inline-element attributes are element-line rules plus `}`; `}` is not consumed. Inside `|{…}` there are no framed comments — a bare `;` is literal; only `;{…}` comments there (revisit: OPEN-QUESTIONS Q3).
- `}` is not a terminator inside `[…]`: an inline element's closing `}` must follow the `]`; a `[` unclosed at the `}` is an unclosed list (content kept, warning).

---

## 6. Text and flow

### 6.1 Flow

**Flow** is the one prose-shaped content model: a sequence of segments — text runs, inline elements, interpolations, inline directives, inline verbatims, inline comments — that resolves to text once each segment's layer processes it. Flow has three homes with one rule set: element content ("prose"), flow values (§5.5), and inline-form interiors.

Any line that does not begin structure is flow text belonging to its column owner. Text is opaque to the core: Markdown inside it is not interpreted (§6.5), `#` and `<` and `|`-space have no meaning there, and text carries its line terminators (ADM text law).

Sameline text (an element's tail) does not establish a content base; block text does (§6.2).

### 6.2 The content base and dedentation

Text written under an element is dedented automatically:

1. The element's sameline tail, if any, establishes nothing.
2. The first indented text line establishes the **content base** — the author's choice of column, anywhere strictly inside the parent (deeper than the parent's marker; at most an inline child's column when one exists).
3. Each subsequent line at ≥ the base contributes its text with base-many leading spaces removed; extra indentation beyond the base is preserved as text.
4. A line shallower than the base but still inside the element **warns** and re-bases: the base becomes the shallower column and parsing continues. (Per-line delivery means earlier lines were stripped by the old base; the warning marks the inconsistency.)
5. A line indented deeper than an established base is *inside the text*: markers there are literal (§3.1 exception). Structure resumes at or left of the base.

Blank lines within flow follow the ADM text law: between two text lines they are text (a newline); elsewhere they are ornamental.

A comment `;` **at** the content base is a comment, interleaving with the text; deeper it is literal (§6.4). Verbatim bodies use the same first-content-line base shape (§7.2) — except fences, which strip nothing.

### 6.3 Inline forms

All markers have a brace-delimited inline form, recognized inside flow; the character after the opener disambiguates with no lookahead:

| Form | Meaning |
|---|---|
| `\|{name … content}` | inline element |
| `!{{expr}}` | interpolation (§8) — ends at the **first** `}}` |
| `!{name …}` | inline directive; body is UDON flow |
| `!{:kind: …}` | inline verbatim (§7.2) |
| `;{…}` | inline comment; contributes no text |

- **Inline element.** Name, identity, traits, suffixes, and attributes work as in §4–§5 (terminators per §5.10); content runs to the balancing `}`. Inside `|{…}` only inline forms may nest — the block form `|name` does not exist there. An inline element is a child of its containing element, a sibling of the surrounding text segments; intervening text between two inline forms — including a single space — is real content.
- **Multi-line inline elements** are permitted: continuation indentation is geometry (skipped); each content line carries its terminator; the opener line's terminator belongs to the form when its line ends inside the braces. Consumers concatenate for a single string — exact by the text law.
- **Brace counting.** `|{…}`, `;{…}`, `!{…}`, and `!{:kind:…}` close on the balancing `}` (nested balanced `{}` allowed). `!{{…}}` alone closes on the first `}}`. Unbalanced-brace content belongs in block forms.
- Escapes: `\` before `|{`, `!{`, or `;{` in flow makes the opener literal (§3.5).

### 6.4 Comments

`;` comments by position:

| Position | Behavior |
|---|---|
| Line start, structural column | line comment |
| After a finished value (framed ` ; `) | line comment |
| In sameline text (framed ` ; `) | line comment |
| In block text at the content base | line comment |
| In block text deeper than the base | literal |
| In `\`-forced text (any) | literal |
| Inside `\|{…}` (bare) | literal — only `;{…}` comments there |
| In flow, as `;{…}` | inline comment |

The frame for a sameline comment is whitespace **before** the `;` and whitespace or end-of-line **after** (`x ; c` comments; `x ;c`, `1;2` do not; a trailing `x ;` is an empty comment).

Comments are **carried, not discarded**: they appear in the model (ADM §2) and consumers decide their fate. Comment content is inert — never interpreted.

A line comment **owns everything indented deeper than it** — markers, structure, fences, everything — until a line at or left of its column. The first continuation line sets the comment's strip column (content-base shape); this is what lets one `;` silence an entire block, including structure that is itself failing to parse. Comments participate in the column hierarchy like any node (a comment at column 0 closes everything open).

### 6.5 Markdown

Text may contain Markdown; the core does not interpret it. Which subset renderers honor, the Markdown-equivalent element vocabulary, and conversion are companion-layer concerns (see MARKDOWN companion). Style guidance (prefer Markdown over inline elements for simple formatting) is pedagogy, not this contract.

---

## 7. Verbatim

**Verbatim** is content never parsed as UDON: one family, carrying a `form` and an optional `label` around an exact body, in three geometries:

| Form | Syntax | Extent | Dedent |
|---|---|---|---|
| block | `!:label:` | geometric (dedent) | to the body's first-line column |
| fence | ```` ``` ```` | delimited (closing fence) | none — byte-exact |
| inline | `!{:label: …}` | delimited (balanced `}`) | n/a |

### 7.1 Block form

```udon
|example
  !:elixir:
    def hello do
      IO.puts("world")   ; not UDON — captured exactly
    end
```

The colon-wrapped label is passed to the host uninterpreted. The body is every deeper line, dedented to the **first content line's column** (deeper indentation preserved as body); a line at or left of the directive's column ends the block. The body MAY begin on the directive line itself — `!:sh: echo hi` captures `echo hi` — with whitespace after the closing `:` as separator; a same-line body does not establish the strip column (the first indented line does). This applies uniformly, including as a node value (`|el :script !:sh: make build`).

### 7.2 Inline form

```udon
|p The response was !{:json: {"status": "ok", "count": 42}} as expected.
```

Brace-counted (balanced `{}` allowed); one space after the label's closing `:` separates and is not body. Unbalanced braces need the block form. The inline form in attribute-value position is undefined this version (OPEN-QUESTIONS Q4).

### 7.3 Fence

A fence opens at any open position — line start or in the scan after elements and attributes — and never after the line has committed to text. Its indentation sets its structural parent; everything after the opening backticks on that line begins the body (an info label for free). The body is captured byte-exactly: no dedentation, no marker interpretation, blank body lines are literal newlines.

A line whose first non-space content is ``` closes the fence, at any indentation (whitespace right of the closer is trimmed; the closer must be followed by its line end). Indentation *of* the closing line's start was already body on the preceding lines — put the closer at column 0 unless that indent is wanted in the body.

Not fences: backticks after text has begun on the line; backticks deeper than an established content base.

---

## 8. Dynamics (syntax only)

The `!` marker introduces **dynamics**. The core recognizes four forms and carries them; their meaning is a host dialect's (the baseline Liquid-style dialect is specified in the DYNAMICS companion; a conforming parser needs none of it):

- `!name …` at open position — a **directive**. Any name (the core does not enumerate); the head-line remainder is carried unparsed; deeper content is parsed as UDON and closed geometrically.
- `!:label:` — block verbatim (§7.1).
- `!{{expr}}` — an **interpolation**: expression carried unparsed.
- `!{name …}` / `!{:label: …}` — inline directive (UDON-parsed body) / inline verbatim.

Interpolations may appear in flow, as whole attribute values, inside lists, and inside identity brackets. A mixed literal-and-interpolation value (`pre!{{x}}post`, `!{{base}}/path`) is a **flow value** — text and interpolation segments, the ordinary flow model, whole-value interpolation being the one-segment case.

Directives nest by column like elements; a dedent closes them. `!else` / `!elif` chains are dialect semantics over adjacent directives, not core structure.

---

## 9. References

`@` names an element defined elsewhere. A reference is an inert **selector** `(name?, key?, traits)`:

| Written | Selector |
|---|---|
| `@[mit]` | `(∅, mit, [])` |
| `@licence` | `(licence, ∅, [])` |
| `@licence[mit].realized` | `(licence, mit, [realized])` |
| `@.realized` | `(∅, ∅, [realized])` |

- Traits are **selection criteria** — they filter which definition matches; a reference never decorates or mutates its target. Deliberately absent: suffixes, attributes, predicates, nesting. To vary content, define a new element. (The tuple model is provisional pending a path syntax — OPEN-QUESTIONS Q5.)
- `@` has equal footing with `|` wherever it can appear: in value position it is the attribute's value; at a boundary or as a block line it is a reference **child** of the element.
- The core recognizes; it never resolves. Resolution modes (leave inert — the default; transclude; merge attributes) are a consumer menu. Key-only `@[k]` resolution errors, ambiguity, and multiplicity are resolve-time, consumer-side concerns.
- `|` always **defines**. Two same-named elements sharing a key are a duplicate *definition* — never a re-open or merge. Duplicate policy is a document-consumer concern over `(element-name, key)` with menu `error | allow-if-identical | first-wins | last-wins | keep-all` (+ optional warn), default `error`. References play no part in uniqueness.

---

## 10. Values and types

UDON types by **syntax**, never by sniffing. The **bare scalar set** is closed — frozen forever; everything else is written in an envelope (§10.4).

### 10.1 Type table (bare)

| Syntax | Type |
|---|---|
| `"…"` or `'…'` | String |
| `42`, `1_000_000`, `0xFF`, `0o755`, `0b1010`, `0d42` | Integer |
| `3.14`, `1e10`, `1.5e-3` | Float |
| `true`, `false` (lowercase, alone) | Boolean |
| `null`, `nil` (alone; equivalent) | Nil |
| `[…]` | List |
| `<…>` | Envelope (dialect-typed) |
| otherwise | String (single token) or flow |

`TRUE`, `True` are strings. A bare `2026-07-11` is the string `"2026-07-11"` — temporal values live in the envelope, via the `temporal@1` dialect.

### 10.2 Scalars

**Numbers.** Integers in four bases with explicit `0`-prefix qualifiers (`0x` `0o` `0b` `0d`; bare digits are decimal — a leading `0` before more decimal digits is decimal, so `0755` = 755). Optional leading `+`/`-`; `_` permitted between digits of any base, value-neutral. Floats are decimal with a fractional part, an exponent (`e`/`E`), or both; a decimal token with neither is an Integer. (Rational `1/3r` and complex `3+4i` literals are **not** in the bare set this draft; candidates for a standard-types dialect — OPEN-QUESTIONS Q6.)

**Strings.** `"…"` and `'…'` quote. A string closes at the next occurrence of its own quote character; interior bytes pass through untouched (`\` is not an escape inside strings — §3.5 does not apply there). Whether any interior escape for the quote character itself exists is deliberately undefined this draft (OPEN-QUESTIONS Q11); to contain one quote kind, use the other. The bare fallback: an unquoted single token that is nothing else is a String.

**Booleans and Nil.** Lowercase only; typed only when the token finishes alone at its boundary (§5.5).

**Absent vs. Nil vs. false vs. true** are four distinct states: key not present; key present with explicit no-value; boolean false; flag present bare or explicit true. (A plain key with no value is none of them — it is the missing-value error, §5.3.)

### 10.3 Lists

Per §5.9. Items are typed independently by these same rules, envelope and reference and interpolation items included.

### 10.4 The envelope

Every non-core type is written inside `<…>` in value position — attribute values and list items alike; in text or inside quotes `<` is ordinary:

```udon
:when <2026-07-11>        ; unlabelled
:size <u64:0xf902>        ; type-labelled
:span <temporal:interval:2026-01/2026-06>   ; dialect-and-type-labelled
```

- A bare value beginning `<` opens the envelope; the **matching** `>` (depth-counted — nested envelopes parse) closes it. Quote a literal leading `<` (`"​<not a type>"`).
- Envelopes span line terminators: an interior newline is content; unclosed at end of input → content kept, warning (§11).
- **Label ladder:** unlabelled `<…>` → type-labelled `<type:…>` → dialect-and-type `<dialect:type:…>`.
- **Unlabelled dispatch:** offered to the document's declared dialects in declared order; first claim wins; if all decline, an **error**. No sniffing race. Which dialects are active by default is a host choice.
- With no dialect loaded, a conforming parser still parses the envelope's extent, carries the value as its lexical form with a warning, and loses nothing; loading the dialect later retypes the same document identically minus the warning.
- Nested-envelope routing (who hands inner typed values to whom) is a dialect-layer question, deliberately open (OPEN-QUESTIONS Q7).

The envelope is the visible core/dialect boundary: bare means frozen core scalar or string; `<…>` means a dialect answers. Dialects never touch bare space, so adding one can never silently retype a document.

---

## 11. Anomalies and end of input

### 11.1 Extents

Every construct closes one of two ways:

- **Geometric extent** — from geometry: end of line, dedent, or end of input. Elements, attributes and their deferred values, comments, directives, block verbatim, text blocks.
- **Delimited extent** — only at a matching printed end-sequence: strings, lists, identity brackets, inline forms, interpolations, envelopes, fences.

### 11.2 The anomaly contract

Responses to malformed input form a ladder: (a) warn and keep everything; (b) warn and drop; (c) error and drop; (d) error and halt; (e) reject.

- A conforming parser MUST respond at level (a) — **keep-everything** — wherever a coherent (a) exists. Known coherent keeps include: warned extension, marker-restored flow fallback, base re-basing, pass-through of late `:` as text, and unclosed delimited extents (content kept, opener cited).
- **Severity is two-valued and defined by loss.** *Warning*: everything kept. *Error*: something lost. An error MUST NOT halt the parse; nothing after an error point may be silently discarded. (No unavoidable error case is currently known: every enumerated anomaly, tab-in-indentation included, has a coherent keep.)
- Levels (b)–(e) are not parser behavior. Whether accumulated anomalies justify dropping or rejecting is consumer policy over the complete model (menu vs. knob).
- Anomalies never suppress content and content never suppresses anomalies: the model carries both.

### 11.3 End of input

At end of input every open construct closes, innermost first:

- A **geometric** construct closes by its ordinary rule, **silently** — EOF is newline-equivalent; a missing final newline is never by itself an anomaly.
- A still-open **delimited** construct keeps everything that arrived, closes, and yields **one warning citing where it opened**; nested open constructs yield one warning each, unwinding innermost-first.

For streaming input, "end of input" is the producer's explicit signal, never a chunk boundary.

### 11.4 The incomplete-input result

A delimited extent still open at true end of input additionally marks the **document** result `incomplete-input` (ADM §1): the input is presumed truncated or unfinished. This is a per-document result — surfaced by the consuming layer as non-success — not a per-construct signal. Only frames open *at* end of input feed it; a delimited construct closed early by an interior newline (per §11.5) leaves a complete document.

### 11.5 Line-boundedness (this version)

Multi-line is settled for three delimited forms: inline elements `|{…}`, fences, and envelopes `<…>`. For the rest — strings, lists, identity brackets, interpolations, inline comments, inline directive/verbatim forms — spanning a line terminator is **deliberately undefined in this version** (OPEN-QUESTIONS Q8): implementations vary and authors MUST NOT rely on either reading. The expectation is that most will be made multi-line once verified safe; any form instead made illegal will warn at the terminator rather than silently change meaning.

---

## Annexes

- **ADM.md** — the Abstract Document Model (normative).
- **GLOSSARY.md** — terminology (normative).
- **OPEN-QUESTIONS.md** — items deliberately undefined in this draft, each numbered, with the decision space (normative as to *what is undefined*).
- **RATIONALE.md** — design rationale (non-normative).
- Companions: DYNAMICS (baseline `!` dialect), TEMPORAL (`temporal@1`), MARKDOWN (the four layers). Each is a consumer-layer contract; none is required for core conformance. **No clean-room companion rewrites ship in this draft** — the scrubbed inputs remain the reference, and where the old TIME-SPEC's bare-recognition model contradicts this contract, **§10.4's envelope-only rule wins**; only the value grammar *inside* the envelope survives from that document.

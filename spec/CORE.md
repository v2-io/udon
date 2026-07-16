# UDON Full Specification

**Universal Document & Object Notation**
*Version 0.8.0 -- 2026-07-15 · rebooted lineage, see [CHANGELOG](CHANGELOG.md)*
*File: `spec/CORE.md` (formerly `spec/FULL-SPEC.md`, renamed 2026-07-14). The sole source of truth.*

This document merges and supersedes:
- SPEC.md
- SPEC-INDENTS.md
- SPEC-UPDATE.md

It is intended to be the single comprehensive, authoritative spec.

---

## Overview

UDON is a unified notation for data, documents, and configuration. It combines
structured elements with natural prose, optimized for both human readability and
machine parsing.

Key properties:
- Indentation-based hierarchy (no closing tags)
- Markdown-compatible prose within elements
- Streamable, incremental parsing
- Syntactic typing (not sniffing)

**Parser behavior notes:**

- **Comments, blank lines, warnings.** Comments, blank lines (a `BlankLine`
  event), and recoverable anomalies (a `Warning` event) are all emitted as
  events by the main parser, alongside the structural ones. What consumers do
  with them (AST inclusion, filtering, etc.) is up to the host.
- **Text granularity.** A `Text` event carries **no** guarantee of being a
  complete text run. Escapes and (later) chunk boundaries may split one line's
  prose into several `Text` events; consumers concatenate. Compliance fixtures
  express text maximally collapsed per line; the harness folds same-line
  adjacent Texts (span gap contains no newline) so expectations are
  rhythm-independent.
- **Warnings are codes, not ratified strings.** A `Warning` event's payload is
  a **warning code** from the table below (PascalCase, matching
  `ParseErrorCode` style). The human-readable text a host surfaces, and
  *whether* a given warning is emitted in a given circumstance, are
  parser/host decisions (menu-vs-knob: the core fixes the code vocabulary;
  hosts pick voice and verbosity). Event-parser fixtures match codes.

### Warning codes

| Code | Description | Typical layer *(non-normative)* |
|------|-------------|----------------------------------|
| `InconsistentIndentation` | Prose (or comment continuation) line less indented than the established content-base; base rebases to the new column | event |
| `NoDialectsLoaded` | A `<…>` typing envelope was recognized but no dialects are bound; value passed through as the plain string `"<…>"` | event |
| `EscapeOutsideHeadPosition` | A leading `\` deeper than an established prose content-base looks like force-prose escape but is not head position (literal passthrough) | **AST** — not the event parser's inner loop |
| `CommentMissingFollowingSpace` | Optional advisory: a `;` that opened a comment without the both-sides frame where that frame applies | host (advisory) |

Further codes may be added when the attribute model and other layers land
(e.g. `UnmarkedBooleanFlag`, `ValuedBooleanKey`, `MarkerInTextValue`,
`DistantAttributeBlock`). Codes that die with a model change are removed from
this table, not kept as soft ghosts.

---

## The Core, and What It Leaves Open

UDON's core is deliberately small. It fixes the **syntax** and the **core
semantics** every conformant parser must implement identically: the sigils and
head-position recognition, the core scalar types, attribute stacking and order
preservation, `|` (define) / `@` (refer), the `<...>` typing-envelope *syntax*,
and the event vocabulary. Everything else it **deliberately leaves to the
consumer**:

- **Projection** -- how a *host* turns a validated string into a native value
  (a date string into a `Date`, etc.). The host's call.
- **Constraint** -- what is *allowed* or *required* (cardinality, vocabularies,
  "no array-valued `$key`"). A **schema**'s job. Proscription lives here, never
  in the core.
- **Exotic typing** -- what non-core value patterns *mean*. A **dialect**'s job
  (recognition and typing, e.g. `temporal@1`) -- distinct from constraint.

Two boundaries keep this honest:

- **Menu vs. knob.** The core may fix an option-*space* and a default while a
  consumer picks within it (the duplicate-definition policy fixes
  `error | first-wins | ...` and defaults to `error`; a builder chooses). A
  consumer may never invent an option outside the menu.
- **Dialects are not schemas.** A dialect says what a value *means / types*; a
  schema says what is *allowed*. They never trade jobs. A future **pragma**
  binds a document to its dialects and schema.

This is why temporal typing, the `!` dynamics language, and the prose Markdown
subset each live in their own companion specs, not here: the core recognizes
their *syntax* (the `<...>` envelope, the `!` prefix, prose), but what they
*mean* is a dialect or host concern layered on top.

---

## Positional Contexts (Vocabulary)

The parser operates in different contexts that affect parsing behavior:

| Term | Meaning | Example |
|------|---------|---------|
| **block** | On its own indented line | `:key value` as child of element |
| **sameline** | On the element definition line | `|el :key value Content` |
| **inline** | Embedded in prose/text flow | `|{em text}`, `;{comment}`, `!{dir}` |
| **embedded** | Inside `|{...}` delimiters | Synonym for inline element context |
| **head** | Start of any line (at a structural column), *or* sameline scan through elements/attributes -- before prose begins | where `\|` `:` `!` `;` `@` and fences are recognized |

### Head Position

**Head position** is the state in which the parser has not yet decided whether
what comes next is a structural marker or prose. It is **re-entered at the start
of every line**, and it has two faces:

- **block-line start** -- the beginning of a line, at a structural column. This
  is head position on *every* line, including lines that follow prose lines
  (`|a`'s child `|b`, a fence, and a prose line can freely interleave). A line
  indented *deeper* than the current prose's column, though, is inside that
  prose -- not head position.
- **sameline scan** -- the run along an element line through elements *and
  attributes* (`|a |b :k v ...`), still looking for the next marker. Elements
  and attributes keep the scan open; the first *prose* word ends it.

At head position, and *only* there, the special-start markers are recognized:
`|` (element), `:` (attribute), `!` (directive), `;` (comment), `@` (reference),
and triple-backtick (freeform). Each is recognized by a short **guard** -- a few characters
of lookahead (see Marker Recognition, the `!` guard, and the marker sections).
The instant a guard fails -- typically when the first prose word arrives -- the
line **commits to prose** *for that line*: head position ends, and any later
occurrence of those characters on it is literal text -- **with one exception**:
a **sameline comment** (see Comments) may follow prose. A `;` framed by
whitespace on both sides (space before; space or end-of-line after) opens a
line comment even after the line has committed to prose; any other `;` is
literal. This one state, plus that single named carve-out, is what keeps
Markdown tables, `:-)`, a mid-prose `!`, and after-prose backticks all safe
from being read as structure while `|li Item one ; TODO` still reads
naturally.

### Block vs Sameline

```udon
|article
  :author Alice                    ; block attribute
  :date 2024-12-31                 ; block attr (bare = string; temporal is moving to a `<…>` dialect)

|section :name intro :role lead    ; sameline attributes
  This is block prose that can span
  multiple lines with consistent indentation.

|p Sameline prose here |{em with inline element} and more
```

**Block context:**
- Attributes on their own indented lines
- Prose that sets the indent-column for continuation
- Values can contain spaces without quoting

**Sameline context:**
- Attributes/content on the element definition line
- Prose that does NOT set indent-column
- Values are space-delimited (quote for spaces)

### Inline Elements (Context Reminder)

Inline elements use `|{...}` syntax and appear within prose:

```udon
|p Click |{a :href /home here} to continue.
```

Inside `|{...}`:
- Element identity follows same rules
- Sameline attributes work the same way
- Content terminates at `}` (brace-balanced)
- Nested `|{...}` allowed (not `|name` block form)

---

## Core Syntax

### Prefixes

Four special characters at line start (after indentation):

| Prefix | Domain | Purpose |
|--------|--------|---------|
| `|` | Structure | Elements and nodes |
| `:` | Attributes | Key-value metadata |
| `!` | Dynamics | Evaluation, control flow, interpolation |
| `;` | Comments | Comment lines / inline comments |

**One escape prefix:**

| Prefix | Purpose |
|--------|---------|
| `\` | At head position, forces the rest of the line to prose (see Escape) |

Anything else is **prose content** belonging to the parent element.

The four prefixes above are the structural-content markers; two further markers
are also recognized at head position: `@` (a reference to a defined element) and
triple-backtick (a freeform block). See Head Position.

### Escape (`\`) -- Forcing Prose

A backslash at **head position** -- the start of a line's intended column (after
indentation), or in the sameline scan through elements and attributes before
prose begins (see Head Position) -- is **consumed** and forces the rest of the
physical line to prose, read verbatim as full text. Whatever the first character
*would* have been (`|`, `:`, `!`, `;`, `@`, a triple-backtick fence, or nothing
special), a head-position `\` makes the line prose. At head position there is no
set of "escapable" characters to memorize -- the escape is defined by *position*
alone. (In prose flow, `\` escapes one small, exact set of inline openers --
see below.)

````
\|element            ->  |element            ; would-be element -> prose
\:not-an-attr        ->  :not-an-attr        ; would-be attribute -> prose
\@name see this      ->  @name see this      ; would-be reference -> prose
\```not a fence      ->  ```not a fence      ; would-be fence -> prose
\![img](pic.jpg)     ->  ![img](pic.jpg)     ; never special -- harmless
\\path\to            ->  \path\to            ; literal leading backslash (below)
````

**Sameline, too.** Head position runs through elements and attributes, so a `\`
reached before any prose has begun forces the remainder to prose on the current
element:

```
|element |another :val [234 19] \ how wonderful ; it is
```

`another` gets `:val [234 19]`, then child prose ` how wonderful ; it is` -- the
leading space is kept (the `\` consumes only itself) and the `;` is literal, not
a comment.

**In prose, `\` escapes an inline-form opener.** The only structure inside prose
flow is the inline forms, so a `\` immediately before an opener -- `|{`, `!{`, or
`;{` (the `!{` covering interpolation, directive, and raw, which all begin `!{`)
-- is consumed and makes that opener literal; prose continues normally:

```
|p see \|{em x}     ->  literal "|{em x}", prose continues
|p price \!{cost}   ->  literal "!{cost}" (not a directive/interpolation)
|p wink \;{x}       ->  literal ";{x}" (not an inline comment)
```

**Any other `\` is literal.** A `\` not at head position and not before an inline
opener -- mid-value, trailing, or before ordinary text -- is emitted literally,
with any escape-sequence reading (`\n`, `\t`, a trailing `\` as a line-join, ...)
left to the host/app layer:

```
|p Windows path C:\Users\me    ->  prose "Windows path C:\Users\me"  ; \U \m untouched
|p wrap this line \            ->  prose "wrap this line \"          ; trailing \ to host
|a hello \world                ->  "hello" begins prose, "\world"    ; literal
```

A **literal leading backslash doubles**: the first `\` forces prose and is
consumed, the second is already prose and passes through -- `\\` -> `\`
universally (even `\\hello` -> `\hello`).

**The consumed `\` takes up no column.** Being the line's first non-space
character, a head-position `\` also sets the prose block's content-base: the text
after it backs up one column into the `\`'s position, and that column becomes the
current indent level (see Automatic Prose Dedentation). This gives a clean way to
indent a whole prose block with its interior spacing intact -- and only the
**first** line needs the `\`; it anchors the base, and the rest follows the
ordinary dedentation rules:

```
|the-element |another
   \     Here all of this is output with the lines indented,
         even though this more-indented line needs no marker -- cleaner --
      here too, with a smaller indent (still past the base column);
  this line dedents past the base: a Warning (`InconsistentIndentation`) fires
  and the base resets to it.
```

**Past-base `\` (not head position).** If a `\` begins a line's content but sits
*deeper* than an already-established prose content-base, the whitespace before
it is already prose, so the `\` is **not** at head position: it is passed
through **literally**. The event parser does not warn here (its inner loop is
byte-pulling, not stylistic inspection). An AST-layer host may emit
`EscapeOutsideHeadPosition` when it cares.

```
|element
  \  start some prose      ->  "  start some prose"    ; \ at head pos -> forces prose
    \some more prose        ->  "  \some more prose"    ; \ past the base -> literal
```

(The precise column bookkeeping -- the consumed `\` taking up no column for
indent-level and subsequent head-position purposes -- is a grammar-level detail
to settle when the parser catches up.)

`'` is **not** an escape -- a line beginning `'|`... is prose starting with an
apostrophe (`'` remains a string / name / key delimiter, see Value Types). Inside
quoted strings (`"..."` / `'...'`), `\` follows the string's own escaping, not
this rule.

---

## Elements

Elements are the structural backbone:

```
|element-name
```

**Element recognition rule:** `|` is only an element marker when followed by
one of: a letter, `[`, `.`, `{`, or `'`. Otherwise `|` is treated as prose
(preserves Markdown table compatibility).

### Marker Recognition

At head position each marker is recognized by a short guard; if the guard fails,
the character is prose. `|`'s guard is above. The rest:

- **`!`** (directive) marks when followed by an **identifier character or `:`**
  -- `!if`, `!for`, `!:lang:`. So `![img]`, `!=`, `!(` are prose. (`!{...}` is a
  *prose-level* inline form -- interpolation or inline directive -- not a
  head-position block directive.)
- **`@`** (reference) marks when followed by `[` or an identifier -- `@[key]`,
  `@element[key]`. What a consumer *does* with the reference is its choice (see
  References and Mixins).
- **`:`** (attribute) is **phase-restricted** rather than char-guarded: a `:` is
  an attribute only while the element has no child content yet; once any text or
  child element has appeared, a line-initial `:` is prose (see Attributes Before
  Children). A `:` not followed by a name also falls back to prose intact.
- **`;`** (comment) marks per the Comments table (line comment at root /
  sameline / after attribute values; literal in block prose).
- **triple-backtick** (freeform) -- see Triple-Backtick Escape.

Every guard is a few characters of bounded lookahead (see Bounded Lookahead).

### Identity (Keys) and Classification (Traits)

```
|element[key].trait1.trait2
```

- `[key]` -- **Identity**: what makes this element *this* element. Unique
  within its element type, referenceable via `@`.
- `.trait` -- **Classification**: what *kinds* of thing it is. Plural,
  stackable, order-preserved.

**These are sugar.** An element is nothing but a **name + ordered attributes +
children**; there are no separate identity, trait, or suffix fields in the
model. `[key]`, `.trait`, and the suffixes below all *desugar* into ordinary
attributes whose names are specially designated:

| You write | Desugars to |
|-----------|-------------|
| `\|el[k]` | `\|el :'$key' k` |
| `\|el.a.b` | `\|el :'$traits' a :'$traits' b` |
| `\|el?` | `\|el :'$?' true` |

The value inside `[...]` follows the normal attribute-value rules -- every type
is available: `[1]` is the integer `1`, `["01"]` the string `"01"`,
`[abc-123]` the string `abc-123`.

**Specially-designated, not reserved.** `$key`, `$traits`, and the suffix names
are ordinary attribute names that the sugar happens to target -- nothing is
fenced off. *Any* `$`-name is a legal attribute; because `$` is not a bare-name
character, writing one longhand takes quotes (`:'$key' ...`), and that friction
-- convention, not proscription -- is what keeps sugar and hand-written
attributes from colliding (the Ruby-symbol / Erlang-atom pattern). So a
generator that only knows how to emit attributes can write `:'$key' 3890` and
have it *be* an identity, indistinguishable from the hand-authored `|el[3890]`.

**Traits stack.** Each `.trait` appends to `$traits`, order preserved -- two
traits are two `$traits` attributes, not one list value (same-name attribute
values stack; order is kept). Classification doubles as lightweight typing even
when no behavior is attached to it.

**Bare-name characters.** A bare element name -- and a bare `.trait` value -- is
a Unicode identifier. The first character must carry the Unicode **`XID_Start`**
property (ASCII `A`-`Z` / `a`-`z` plus the corresponding non-ASCII
identifier-start letters; digits, `_`, and `-` are *excluded* from this first
position). Each following character must carry **`XID_Continue`** *or* be a
hyphen `-` -- so digits, `_`, `-`, and identifier-continue marks may extend a
name, and kebab-case is first-class (`|my-element`). Any character outside that
set -- a space, `.`, `[`, `:`, `$`, other punctuation -- ends the bare name; to
put such a character *in* a name or trait, single-quote it (`|'weird name'`,
`.'ns.kind'`). A bare `.trait` additionally absorbs the suffix characters
`* ! ? +` (see Element Suffixes), so a trait's continue-set is `XID_Continue`
plus `-` plus `* ! ? +`.

What the core fixes is the *rule* -- a bare name is a Unicode identifier (UAX #31
`XID_Start` to start, `XID_Continue` or `-` to continue). *Which Unicode version*
those properties resolve against is a **parser / host-language decision**, not a
core one: the core says "Unicode identifier," and the host's Unicode support
(the reference parser tracks the `unicode-xid` crate's version) pins the exact
codepoint set. This is the same core-vs-host split drawn in The Core, and What It
Leaves Open.

*(Reference grammar: `XLBL_START` = Unicode `XID_Start`, `XLBL_CONT` =
`XID_Continue` + `-`; see `core/generator/udon.desc` -- `parse_element_identity`,
`name`, `class_name` -- and `tools/descent/characters.md`.)*

### Element Suffixes

Elements may carry suffix flags (`?`, `!`, `*`, `+`) that desugar to
specially-designated boolean attributes:

```
|field[name]?      ->  |field[name] :'$?' true
|field[name]!      ->  |field[name] :'$!' true
|field[name]*      ->  |field[name] :'$*' true
|field[name]+      ->  |field[name] :'$+' true
```

UDON performs only the expansion; the *meaning* is defined by the consuming
schema or dialect:
- a schema might read `?` as optional, `!` as required
- a grammar might read `?` as 0-or-1, `*` as 0-or-more, `+` as 1-or-more

**Suffix positions** (a suffix binds to the element identity):

```
|name?                   ; after the name
|name?[key]              ; after name, before key
|name?[key].trait        ; after name, before key and traits
|name[key]?              ; after key
|name[key]? .trait       ; after key, space before traits
|name[key].trait ?       ; space-separated at the end
```

**Suffix characters inside a trait are part of the trait.** `* ! ? +` are legal
in a bare trait value, so `.foo?` is simply the trait `"foo?"` -- no quoting
needed. This is why an element-level suffix *after* a trait uses the
space-separated form or precedes the trait: a suffix character touching a
`.trait` is consumed by the trait.

```
|el.bar?         ; traits: ["bar?"]
|el.bar ?        ; traits: ["bar"], $? = true
|el?.bar         ; $? = true, traits: ["bar"]
```

### Anonymous Elements

An element's **name is optional.** A pipe may be followed directly by a key, a
trait, or a suffix, producing an element with no name:

```
|[k]                      ; anonymous, key k
|.some-trait              ; anonymous, trait "some-trait"
|.some-trait :adapter pg  ; ...and carrying attributes
|?                        ; anonymous, just a suffix flag
```

An anonymous element is an ordinary element in every respect -- it simply has
no name, and carries whatever key, traits, attributes, and children it is
given. No special meaning attaches to namelessness at the core level; a
consumer may give one (see Mixins).

### Host Views (Recommended)

The wire form carries the specially-designated attributes as-is. Like Markdown,
YAML, or Liquid parsers, each host picks its own surface idiom -- but the spec
**recommends** a default shape so switching hosts feels familiar. Both views
derive from the same substrate:

- **`all_attributes`** -- every attribute in document order, *including* the
  `$`-designated ones. The round-trip / "exactly what's there" view.
- **`key` / `traits` / `attributes`** -- the ergonomic split: `key` is the
  value(s) of `$key`; `traits` is the values of `$traits`, **always a list**
  (`[]`, `["a"]`, `["a", "b"]` -- even for a single trait); `attributes` is
  every *non*-designated attribute. Suffix flags surface off `$?` and friends.

`traits`-always-a-list is the one normalization a host applies beyond the plain
desugaring; everything else is a straight read of the attribute stream.

---

## Attributes

Attributes are key-value pairs:

```
|element :key value :another-key another value
```

Attributes can appear in two contexts:
- **Sameline**: on the element definition line
- **Block**: on their own indented line

Attribute values are context-sensitive:
- **Block** values run to end of line; ` ;` starts a comment
- **Sameline** values are space-delimited; quote for spaces
- **Embedded** values are space-delimited; `}` also terminates the value

When an attribute has no value (followed immediately by `:`, newline, or a
context terminator), it is treated as boolean true.

**Empty/missing values:** The parser emits `BoolTrue` for attributes without a
value:

```udon
|button :disabled :type submit
; disabled -> BoolTrue, type -> "submit"
```

### Inline Lists

Square brackets for list values:

```
|server :ports [8080 8443 9000] :tags [api public]
```

- Space-delimited within brackets
- Quoted strings for values with spaces: `["hello world" foo bar]`

### Attribute Stacking

When the same attribute key appears more than once on an element, the values
**stack** -- they accumulate as an ordered list of assignments, in source
order. Stacking is the uniform rule for *every* attribute; last-wins /
"one per key" is **not** how UDON attributes behave.

```
|el :x 1 :x 2        ; x = [1, 2]  (both kept, in order)
```

The event stream is the truth: each `:key` occurrence emits its own `Attr`, in
order. This is also what makes the trait sugar work -- `.a.b` desugars to two
`$traits` assignments (see Identity and Classification).

**Stacking and list values are orthogonal** -- two different multiplicity axes.
A list literal `[...]` is *one* value that happens to be a list; stacking is
*multiple* assignments of the same key. They compose:

```
|el :x [1 2] :x [3]   ; x = [[1, 2], [3]] -- two stacked values, the first a list
```

A host may offer a single-value accessor (scalar / last) beside a list
accessor (all values); the `traits` view is always a list (see Host Views).
What is *allowed* -- e.g. forbidding a multi-valued `$key` -- is a schema
concern, never core: the core stacks and list-types any attribute uniformly.

### Complex Attribute Values

Authors often write an attribute with no same-line value and put structure on
the following indented lines:

```
|api-endpoint
  :method POST
  :headers
    |header :name Content-Type :value application/json
    |header :name Authorization :value Bearer token
```

Attribute followed by newline+indent = structured value -- **as authoring
intent**. Event shape, ownership, and flag/value policy are **not settled
in this version**. Active design carriers (not yet CORE):
`design/attribute-model-proposal-3-substrate.md` (decided model floor) and
`design/attribute-model-proposal-3.md` (narrative). Do not treat the
current parser's emission as the contract.

### Value Terminator Rules

Different contexts have different terminator sets for **unquoted values**.

#### Block Attribute Values

```udon
|el
  :key value with spaces allowed here
  :url https://example.com/path?q=1;s=2
  :note this has a semicolon too ; but THIS is a comment
```

Terminators: `\n` or ` ;` (space followed by semicolon)

- Values extend to end of line
- Spaces allowed without quoting
- `;` preceded by space starts comment
- `;` without preceding space is part of value

Because the value runs to end-of-line, a *block* line holds **one** attribute:
`:bttr 2 :cttr 3` makes `:bttr` = the string `"2 :cttr 3"`, not two attributes.
For multiple attributes, use the element (sameline) line (`|el :a 1 :b 2`) or
separate block lines. A stranded ` :name ` inside a block value is still part of
that value; a host may warn about the likely mistake, but the event parser is
not required to (advisory emission is host-side -- see warning-code posture).
(A future attribute-model reconception may replace run-to-EOL with a uniform
line scan; until then, one-attribute-per-block-line is the rule.)

#### Sameline Attribute Values

```udon
|el :key1 value1 :key2 value2 ; comment
|el :url https://x.com :role foo
```

Terminators: `\n` or `SPACE`

- Space delimits values
- Use quotes for values with spaces: `:key "hello world"`
- `;` after values starts comment (child of element)
- `:` after space starts next attribute

#### Embedded Attribute Values

```udon
|p Click |{a :href /home :title Home here} now.
```

Terminators: `\n`, `SPACE`, or `}`

- Same as sameline, plus `}` closes the embedded element
- `}` is NOT consumed (returned for proper bracket matching)

#### Array Item Values

```udon
:tags [one two three]
:coords [1.5 2.3 4.1]
```

Terminators: `\n`, `SPACE`, or `]`

- Space separates array items
- `]` closes array (not consumed)
- Context (block vs embedded) doesn't affect array terminators
- `}` is **not** a terminator: inside `[...]` it is a literal character; the
  array closes only on `]` (with no `]`, it ends as an `UnclosedArray` error). A
  `}` meant to close an embedded `|{...}` must come *after* the array's `]`.

**Quoted-item nuance** (a consequence of the terminator rules, not a separate
rule): a quoted string's closing `"` ends its item, so a character immediately
after it -- with no separating space -- begins the next item. Thus `["x"y]` and
`["x""y"]` each yield two items (`["x", "y"]`), the same as `["x" y]`.

### Bare String Terminators (Summary)

These rules apply to **unquoted values** (bare strings, numbers, booleans, nil).

| Context | Terminators | Space? | Notes |
|---------|-------------|--------|-------|
| Block attr | `\n`, ` ;` | In value | Comment needs ` ;` |
| Sameline attr | `\n`, `SPACE` | Terminates | Quote for spaces |
| Embedded attr | `\n`, `SPACE`, `}` | Terminates | Don't consume `}` |
| Array item | `\n`, `SPACE`, `]` | Terminates | Don't consume `]` |

---

## Prose Content

Any line not starting with a prefix is prose belonging to the parent:

```
|article
  :author Joseph

  This is prose content. It can span multiple lines and
  include **Markdown formatting** since we're not using
  `#` for comments anymore.

  - Markdown lists work naturally
  - So do numbered lists:

  1. First item
  2. Second item

  |blockquote
    Nested elements interrupt prose and resume structure.

  Back to prose in the article.
```

**Block prose** sets an indent-column for continuation and preserves literal
semicolons. **Sameline prose** does not set an indent-column and treats `;` as a
comment start.

Since `;` is the comment delimiter, `#` has no special meaning in prose.
Markdown flows naturally.

The parser treats prose as **opaque text** -- it does not interpret the Markdown
inside it. Which Markdown subset conformant renderers honor, how UDON serves as
a Markdown-equivalent schema, and conversion / rendering are all *above the
parse* and specified separately in the `MARKDOWN.md` companion spec (draft).

**Prefer Markdown over inline UDON in prose.** When both could work, use Markdown:

```
; Preferred -- familiar, readable
This has `inline code` and **bold** text.

; Avoid -- over-engineered for simple formatting
This has |{code inline code} and |{strong bold} text.
```

Reserve `|{...}` inline elements for cases where you need attributes or
semantic structure that Markdown cannot express.

Embedded elements can appear within prose using `|{...}`:

```
|article
  :author Joseph

  This paragraph contains |{em emphasized text} and
  |{a :href /reference a reference link} inline with the prose.
```

---

## Comments

Semicolon starts a comment depending on context:

| Context | `;` Behavior | Example |
|---------|--------------|---------|
| Document root | Line comment | `; file header comment` |
| Block prose | **Literal** (not comment) | `use x; do y` |
| Sameline prose | **Sameline comment** (whitespace-framed only) | `|p text ; comment` |
| Block attr line | Line comment (after values) | `:key value ; comment` |
| Sameline attrs | Line comment (after values) | `|el :k v ; comment` |
| Inline/embedded | `;{...}` only | `|{em text ;{note}}` |

**Parser behavior:** Comments are emitted as events, not discarded. The
consuming layer decides whether to keep or strip them.
This enables use cases like documentation extraction, TODO tracking, or
comment-aware transformations.

Line comments may be continued by indentation: **every** more-indented line --
markers and structure included, nothing excepted -- is comment text until a
line at or dedented from the comment's column (ratified 2026-07-15). Comment
content is inert: the parser never interprets it, only carries it. This is
what makes a `;` at the right column comment out an entire block without
touching its lines -- including the primary case of silencing structure that
is itself causing parse errors or warnings.

```
; This would be a comment
  this is still part of the comment
\; But this line is output as text (leading \ forces prose).
```

### Sameline Comments

A **sameline comment** is its own lexical form: a `;` with **whitespace on
both sides** -- a space before it, and a space or end-of-line after it. It is
the one marker allowed after a line has committed to prose (the carve-out
named in Head Position). The frame is the condition:

```
|li Item one ; TODO expand    ; " ; " framed both sides -> comment
|li Item one ;still prose     ; no space after -> the ";still" is literal
|li ratio 1;2 done            ; no space before -> literal
|li trailing wins ;           ; EOL is a valid after-boundary -> empty comment
```

An unframed `;` in sameline prose is simply prose. (`;{...}` is a different
lexeme -- the inline comment -- and needs no whitespace frame.)

### Why Block Prose Differs

Block prose sets an indent-column and captures literal content including
semicolons. This allows code examples, prose with semicolons, etc.

```udon
|pre
  function foo() {
    return x; // semicolon is literal
  }
```

Sameline prose is brief (single line) and commonly followed by comments:

```udon
|li Item one ; TODO: expand this
|li Item two
```

For inline comments within prose, use `;{...}`:

```
|p This has ;{TODO: fix wording} some text that continues.
```

Inline comments use brace-counting to find their end--nested `{}` pairs are
allowed as long as they are balanced. For comments with unbalanced braces, use
line-comment form instead.

### Comments and Indentation

Comments participate in the indent/dedent hierarchy, even though they produce
no structural output beyond comment events.

#### Block Comments

A line starting with `;` is a block comment. It **triggers indent/dedent
behavior**:

```udon
|parent
  |child
   ; this comment is INSIDE |child (one space further right)
  ; this comment is SIBLING of |child (same column = sibling!)
    |grandchild
; this comment closes |grandchild, |child, AND |parent (column 0)
|sibling
```

The comment at column 0 causes three ElementEnd events before `|sibling` is
parsed.

```udon
|element
  Some prose content
  ; comment inside |element - AT the prose base (head position)
  More prose content
```

A `;` *deeper* than the prose base is inside the prose — literal, like any
other marker there (see Head Position; ratified 2026-07-15). Comments
interleave with prose at the base column; `;{...}` annotates within it.

#### Inline Comments

`;{...}` is an inline comment--the only way to comment within prose:

```udon
|p This is some text ;{TODO: improve this} and more text.
```

If a consumer strips comments, the output text would be:
`This is some text and more text.`

#### Escaping Semicolons

To output a literal `;` at line start, lead the line with `\` -- at head
position it forces the line to prose (see Escape):

```udon
\; This line starts with a semicolon in the output
```

Output: `; This line starts with a semicolon in the output`

---

## Literal Semicolons

A `;` starts a comment only in specific positions (see Comments); everywhere
else it is already literal, so most literal semicolons need no escape at all:

| Context | Literal `;` |
|---------|-------------|
| Block prose | Already literal (`code; more code`) |
| Block attr value | Already literal, or quote (`:sql 'SELECT; DROP'`) |
| Sameline prose | Literal unless whitespace-framed (a *sameline comment* needs a space before AND a space/EOL after); `a;b` and `a ;b` are literal |
| Sameline attr values | Literal when not preceded by a space; a ` ;` after the value starts a comment, so quote (`:k "a; b"`) or force the whole tail to prose with a head-position `\` (see Escape) |
| Embedded `\|{...}` | Bare `;` is literal -- only `;{` opens an inline comment |

There is no separate `\;` escape: a `\` that is not at head position is passed
through literally (see Escape). A literal `;` comes from position (no preceding
space, block prose, or embedded) or from quoting; a whole prose tail that must
carry would-be markers is forced to prose with a head-position `\`.

```
|el :key and-this;-is-ok this is prose ; and this is a comment
  this is also prose ; but this is not a comment

!:c:
  // And obviously semicolons anywhere here are ok...
```

---

## Hierarchy (Indentation and Columns)

Indentation determines parent-child relationships. UDON's hierarchy works like
Python's, with an important twist: **inline elements on a single line are
nested just as if they were on separate lines at their column positions.**

### Parser Rule (Authoritative)

The parser uses the following rule for nesting:

**pop while new_column <= stack_top.base_column**

### Style Recommendation (Non-Authoritative)

A consistent indent increment (typically 2 spaces) is recommended for readability,
but is not a parser rule.

Once you choose an indent level for siblings, maintain it:

```udon
; Good - consistent alignment
|one |two |three
     |better
     |better

; Good - consistent alignment
|one |two |three
  |also-good
  |also-good

; Poor form - inconsistent (warn or error)
|one |two |three
     |alpha       ; chose column 5
  |beta           ; but then used column 2
```

Both positions are technically valid siblings of `|two`, but mixing them is
confusing.

### The Column Rules

1. **Greater column = child** (push onto stack)
2. **Same column = sibling** (pop current, push as child of parent)
3. **Lesser column = dedent** (pop until column > top's base_column)

**To be INSIDE an element, you must be at column > element's column.**
**Same column == sibling instead of child.**

### The Rule Visualized

This is a commonly misunderstood aspect of UDON indentation. The next line
gets to choose how far to indent. From an indent of one space vs the parent,
through to (but including) the pipe for the next nested one.

```
|alpha |beta |theta
                    ;<- where to put |gamma depends on who you want it to be siblings with
                    ;   these comments are in fact children of |theta
 ^     ^^    ^
 |     ||    |
 +--+--++----+ sibling of theta
    |         (because indented from beta now instead of just alpha)
sibling of beta
```

```
|parent
  |child        <- column 2
  |sibling      <- column 2: SAME column = SIBLING of child, not inside it!
   |inside      <- column 3: ONE MORE column = INSIDE sibling
```

### Inline Nesting

```
|one |two |three  ; three is child of two, two is child of one
```

Equivalent to:

```
|one
     |two
          |three
```

### Column-Aligned Siblings

When a subsequent line places an element at the same column as a previous inline
element, they become siblings (children of the same parent):

```
|table |tr |td A1
           |td A2       ; same column as |td A1 -> sibling (both children of |tr)
       |tr |td B1       ; same column as first |tr -> sibling (both children of |table)
           |td B2
  |caption Table 1      ; indented from |table -> child of |table
```

The column position determines ancestry: an element becomes a child of whichever
element "owns" that column based on the nesting established above it.

### Sibling After Inline Elements

```
|one |two |three
  |alpha          ; sibling of |two -- child of |one
```

Here `|alpha` at column 2:
- Stack has: `[one@0, two@5, three@10]`
- 2 <= 10? Yes, pop three
- 2 <= 5? Yes, pop two
- 2 <= 0? No, stop
- Push alpha as child of one

### Column Alignment = Sibling

```
|one |two |three
     |alpha       ; same as above -- sibling of |two, child of |one
```

`|alpha` at column 5 (same as `|two`):
- 5 <= 10? Pop three
- 5 <= 5? Pop two (same column = sibling)
- 5 <= 0? No, stop
- Push alpha as child of one

### The Python Perspective

Inline elements are exactly as if they were on separate lines at those columns.

```
|alpha |beta |c |d
```

Equivalent to:

```
|alpha
       |beta
             |c
                |d
```

Now placing `|e` on line 2 is just normal Python-style indent reasoning:
- Same column as `|beta` -> sibling of `|beta`
- Between `|beta` and `|c` -> child of `|beta`, sibling of `|c`
- Same column as `|c` -> sibling of `|c`
- And so on...

The inline notation is just a compact way to write the vertical form. The
column positions are real and determine hierarchy exactly as if each element
had its own line.

### Child of Inline Element (Special Case)

```
|one |two |three
        |alpha   ; child of |two (sibling of |three)
```

```
|one |two |three
          |alpha  ; same -- child of |two, sibling of |three
```

### Multi-line Progression

```
|one |two |three
       |alpha     ; child of |two
     |beta        ; sibling of |two (child of |one)
```

### The Critical Insight

**You only care about the previous line's stack state.**

```
|one |two |three
  |alpha
     |beta      ; child of |alpha, NOT related to |two at all
```

From `|beta`'s perspective, the world looks like:
```
|alpha
   |beta
```

When `|alpha` appeared, it popped `|two` and `|three` off the stack. They're
closed; later column positions that coincide with their old columns are
coincidental.

The stack naturally handles everything. No special inline column tracking is
needed because inline elements are pushed with their actual columns, just as if
they were on separate lines.

### Complex Example: Many Inline Elements

```
|a |b |c |d |e |f |g
         |child-of-c
   |child-of-a
```

Stack after first line: `[a@0, b@3, c@6, d@9, e@12, f@15, g@18]`

For `|child-of-c` at column 9:
- 9 <= 18 (g)? Pop
- 9 <= 15 (f)? Pop
- 9 <= 12 (e)? Pop
- 9 <= 9 (d)? Pop (same column!)
- 9 <= 6 (c)? No, stop
- Push as child of c

Stack now: `[a@0, b@3, c@6, child-of-c@9]`

For `|child-of-a` at column 3:
- 3 <= 9? Pop child-of-c
- 3 <= 6? Pop c
- 3 <= 3? Pop b (same column!)
- 3 <= 0? No, stop
- Push child-of-a as child of a

### Closing Multiple Levels

```
|one
  |two
    |three
      |four
- this prose is sibling to |one
```

The prose at column 0 triggers:
- 0 <= four's column? Pop four
- 0 <= three's column? Pop three
- 0 <= two's column? Pop two
- 0 <= one (0)? Pop one

Three or four ElementEnd events fire in sequence.

---

## Implementation (Non-Normative)

The stack entry needs only:
```rust
struct StackEntry {
    base_column: u16,  // Column where element started (where | was)
    span_start: u32,   // For ElementEnd event
}
```

The algorithm:
```rust
fn handle_new_element(&mut self, column: u16) {
    // Pop while new column <= top's base column
    while let Some(entry) = self.stack.last() {
        if column <= entry.base_column {
            self.emit(Event::ElementEnd { ... });
            self.stack.pop();
        } else {
            break;
        }
    }
    // Push new element as child of current top
    self.stack.push(StackEntry { base_column: column, ... });
    self.emit(Event::ElementStart { ... });
}
```

No special cases. No inline column tracking arrays. The stack handles everything
naturally because inline elements are pushed with their actual column positions.

---

## Automatic Prose Dedentation

UDON automatically strips leading whitespace from prose content based on its
context within elements. This enables readable source formatting while
producing clean output.

### The Rule

1. **Inline content** (same line as element) does NOT establish content_base
2. **First indented line** (line 2) establishes `content_base_column` - user chooses
3. **Subsequent lines at >= content_base**: no warning, extra spaces preserved in output
4. **Subsequent lines at < content_base** (but still within element):
   - Emit warning about inconsistent indentation
   - Update content_base to this new (lesser) column
   - Continue as content of same element

**Valid range for indented content:** between parent's `|`+1 (exclusive) and
any inline child's `|` (inclusive).

### Inline Content Freedom

The user chooses how to indent line 2. All of these are valid with no warnings:

```udon
|element-bigger Here is the first line of stuff
  and here is the second
  and third
 this would warn                                  ; col 1 < col 2, WARNING
and this would be a sibling of |element instead.  ; col 0 = element's col, DEDENT
```

```udon
|element-bigger Here's the first line
                and here's an equally acceptable form
```

```udon
|element-bigger Here's another first line
       This is also just as acceptable
```

### With Nested Inline Elements

```udon
|element-bigger Here's some child text |another-element
                                       |child-of-bigger
               ; ^ sibling to another-element, child of element-bigger
             |also-child-of-bigger     ; WARNING - less indent than line 2
```

```udon
|element-bigger and some child text |and-another inner text here
                              This is also a direct child of element-bigger,
                                  just in a very unconventional spot.
                              ; ^ no warning, but extra leading spaces in output for this line
```

### Basic Example

```udon
|section **The great indent**
  This content is all inner-content of |section,
  and will continue to be inner-content of |section
  until the parser detects a dedent.
```

**Output text:**
```
**The great indent**
This content is all inner-content of |section,
and will continue to be inner-content of |section
until the parser detects a dedent.
```

The inline content (`**The great indent**`) has no leading space. The indented
lines have their 2-space indent stripped.

### Inline Content with Continuation

```udon
|later-part This stuff is inner to |later-part
            and, with a slightly different formatting
            preference-- is indented quite a ways.
```

**Output text:**
```
This stuff is inner to |later-part
and, with a slightly different formatting
preference-- is indented quite a ways.
```

The continuation lines are aligned with "This" (column 12). All 12 leading
spaces are stripped.

### Valid Indentation Range

For prose after inline elements, valid columns are between the parent's `|`
(exclusive) and the inline child's `|` (inclusive):

```udon
|the-parent |on-line-child
            |sibling    ; column 12, same as on-line-child = sibling
                        ; one more column right = child of on-line-child

|the-parent |on-line-child
     |sibling           ; column 5, unorthodox but same semantic as above
```

### Inconsistent Indentation (Warnings)

```udon
|the-parent |on-line-child
      first-line-of-prose...   ; col 6, establishes content_base = 6
   but what about this???      ; col 3 < 6, WARNING, content_base = 3
   ^ this is the new reference ; col 3, no warning
   also not a new warning      ; col 3, no warning
       four extra spaces       ; col 7 > 3, no warning, OUTPUT: "    four extra spaces"
  new warning here             ; col 2 < 3, WARNING, content_base = 2
```

**Output text:**
```
first-line-of-prose...
but what about this???
^ this is the new reference
also not a new warning
    four extra spaces
new warning here
```

The first line was stripped of 6 spaces. When content_base dropped to 3,
subsequent lines were stripped of only 3 spaces. The "four extra spaces" line
preserves 4 spaces because 7 - 3 = 4.

### Streaming Behavior

Prose dedentation happens per-line as content is parsed:
- Each line is stripped of `content_base_column` spaces and emitted immediately
- If a line has fewer leading spaces than content_base, warn and update content_base
- Earlier lines may have been "over-stripped" compared to later lines
- This is intentional: the warning signals the inconsistency to the user

### Exception: Freeform Blocks

Triple-backtick (freeform) blocks preserve exact whitespace - no automatic
dedentation:

```udon
|code
  ```
  def foo():
      return 1
  ```
```

The content inside the backticks is preserved exactly as written.

### Implementation

The stack entry expands to:
```rust
struct StackEntry {
    base_column: u16,           // Column where | was (for hierarchy)
    content_base_column: u16,   // Column where indented prose starts (for dedenting)
    content_base_set: bool,     // Whether content_base has been established (by line 2+)
    span_start: u32,            // For ElementEnd event
}
```

**Inline content** (same line as element) is emitted directly without setting
content_base:
```rust
fn emit_inline_content(&mut self, content: &[u8]) {
    // Inline content doesn't establish content_base
    // Just emit it directly
    self.emit(Event::Text { content, ... });
}
```

**Indented prose** (line 2+) establishes and uses content_base:
```rust
fn emit_indented_prose(&mut self, line: &[u8], line_column: u16) {
    let entry = self.stack.last_mut().unwrap();

    if !entry.content_base_set {
        // First indented line establishes the base (user's choice)
        entry.content_base_column = line_column;
        entry.content_base_set = true;
    } else if line_column < entry.content_base_column {
        // Line 3+: inconsistent dedent - warn and update
        self.warn("Inconsistent indentation");
        entry.content_base_column = line_column;
    }

    // Strip content_base_column spaces from line
    let stripped = &line[entry.content_base_column as usize..];
    self.emit(Event::Text { content: stripped, ... });
}
```

---

## Inline and Embedded Elements

For inline elements within prose, use the embedded form `|{...}`:

```
|p This paragraph has |{em emphasized text} and |{a :href /foo a link} inline.
```

The embedded element:
- Starts with `|{`
- Contains element name, optional key/traits, optional attributes, and content
- Content terminates at `}` (brace-balanced)
- Becomes a child of the containing element (sibling to surrounding text)

Inline elements are embedded elements; this spec uses "inline" for prose
placement and "embedded" for the `|{...}` form.

Multiple embedded elements are siblings:

```
|nav |{a :href / Home} |{a :href /about About} |{a :href /contact Contact}
```

Embedded elements can be nested:

```
|p See |{a :href /doc the |{em official} documentation} for details.
```

### Bracket Mode Rules

**Once in bracket mode, stay in bracket mode.** Inside `|{...}`, you cannot use
inline element syntax (`|element`). All nested elements must also use embedded
form:

```
; Correct -- nested embedded elements
|ul |{li |{a Home} | }|{li |{a About}}

; INVALID -- mixing inline and embedded
|ul |{li |a Home}     ; can't use |a inside |{...}
```

Embedded elements can span multiple lines--indentation inside is ignored, and the
closing `}` ends the element:

```
|p This has |{a :href /docs
   a link that spans
   multiple lines} and continues.
```

**Multiline content delivery.** Content inside a multiline `|{…}` is emitted
as **per-line** `Text` events (continuation indentation skipped), not as one
joined string. Consumers that want a single string concatenate.

**Prose between embedded siblings.** Intervening prose -- including a single
space -- between two `|{…}` forms is real content and is emitted as `Text`
(round-trip fidelity). `|nav |{a A} |{b B}` yields `Text " "` between the two
embedded elements.

---

## Unified Inline Syntax

All prefix characters support a bracket-delimited inline form:

| Syntax | Description |
|--------|-------------|
| `|{element ...}` | Embedded element |
| `!{{expr}}` | Interpolation (double-brace) |
| `!{directive ...}` | Inline directive |
| `;{comment}` | Inline comment |

The character immediately after the prefix determines the parse mode with no
lookahead.

**Note:** `\` at head position forces the whole line to prose; a mid-prose `\`
immediately before an opener (`|{`, `!{`, `;{`) escapes it, making it literal.
See Escape. (`'` is not an escape; it is a string / name / key delimiter.)

---

## Code and Raw Content

### Raw Directives (Block)

Use `!:lang:` for code samples and raw (non-UDON) content:

```
|example
  !:elixir:
    def hello do
      IO.puts("world")
      |> this_pipe_is_elixir_not_udon()
    end
```

The `!:label:` syntax (colon-wrapped label) signals that the body is **not
UDON**--it is captured verbatim. The label (e.g., `elixir`, `sql`, `json`) is
passed to the host for syntax highlighting, execution, or other processing.

The content follows normal indentation rules:
- Indented under the directive
- Not parsed as UDON (no `|`, `:`, `!`, `;` interpretation)
- **Dedented relative to the first content line's column** (the *raw base*):
  that line establishes the strip column; deeper lines keep their extra indent
  as content. A line at or left of the directive's own column ends the block.
  (CORE previously said only "relative to the directive's indent level"; the
  first-content-line base is the exact stripping rule -- same shape as prose
  content-base.)

### Inline Raw Content

For inline raw content, use `!{:kind: ...}`:

```
|p The response was !{:json: {"status": "ok", "count": 42}} as expected.
```

Inline raw uses brace-counting. The parser finds the closing `}` by counting
brace depth. Nested `{}` pairs are fine as long as they're balanced. The form
carries the same **Raw** marker event as the block form. A single space after
the label's closing `:` is a separator (not content) -- so
`!{:json: {"a":1}}` captures `{"a":1}`, not ` {"a":1}`. *(Provisional for 0.8;
tighter nailing deferred until dialects / templating settle.)*

Examples:

```
; Works -- braces are balanced (even nested)
!{:json: {"key": "value"}}
!{:regex: [a-z]{3,5}}

; Fails -- unbalanced brace
!{:text: missing close {}

; Solution -- use block form for unbalanced braces
!:text:
  missing close {here
```

Raw content cannot be an attribute value directly--attributes are typed scalars.

### Triple-Backtick Escape (Freeform)

Triple-backticks break out of indentation sensitivity entirely: the body is
captured exactly -- no prose dedentation, no marker interpretation.

**Opening.** Triple-backticks open a freeform block at **any head position** --
the start of any line (at a structural column), or in sameline scan after
elements and attributes, before prose begins (see Head Position). They are
**not** a fence once prose has begun on the line.

- The backticks' indentation sets the block's structural parent (a child of
  whatever owns that column) -- which is why fences are not column-1-only.
- Everything after the backticks on the opening line begins the body, so an
  info string (`rust`, `rust ignore`) comes for free -- no separate info-string
  rule.

Because head position is re-entered every line, a fence interleaves freely with
prose and child lines -- here it begins at a line start (head position) even
though prose lines preceded it:

```
|a
  here is prose
  |b a child element
  and more prose
  ```text and the fence begins
  still inside the fence
  ``` ; fence ends
```

In sameline scan a fence may follow elements *and* attributes -- attributes keep
the scan open, so `|a |b :k v ` followed by triple-backticks opens a fence whose
body starts after the backticks.

Two cases are **not** fences: (1) after prose has begun on the line -- in
`|a |b but now` + backticks, `but` is prose, so the backticks are literal; and
(2) backticks indented *deeper* than the current prose's column -- they sit
inside that prose, not at head position.

**Closing.** A line whose first non-space content is triple-backticks closes the
block, at **any** indentation, and must be followed by a newline (trailing
whitespace before that newline is ignored). Putting the closer at the opening
indent is **recommended** -- so a reader mid-long-block can recover the parent's
column -- but not required.

> **Caution.** Indenting the closing backticks means their leading whitespace is
> part of the captured body: the body runs to the newline *before* the closer,
> so that indentation was already body. Only whitespace to the *right* of the
> closing backticks is silently trimmed. Put the closer at column 0 if you do
> not want its indent in the output.

Use freeform **only** when:
- Assembling files from multiple sources without indent control
- Working with broken tooling that can't maintain indentation
- The rare case where absolute positioning matters

Do not use triple-backticks as the default for code samples. Use `!:lang:`
for raw code blocks.

---

## Dynamics (`!`) -- a baseline dialect

The `!` prefix marks **dynamics**. The core recognizes the *syntax* and emits
events; what they *mean* is a host-provided **dialect**, not core UDON.

Core forms and the events they emit:

- `!name ...` at head position -> a **Directive** (`!if`, `!for`, ... -- any
  name; see Marker Recognition). Body parsed as UDON.
- `!:lang:` (block) or `!{:kind: ...}` (inline) -> **Raw**, captured verbatim
  (see Code and Raw Content).
- `!{{expr}}` -> an **Interpolation** -- the expression is unparsed; the host
  evaluates it.
- `!{directive ...}` -> an inline directive with a UDON-parsed body.

The **language** inside directives and interpolations -- expressions, operators,
truthiness, control flow (`!if` / `!for` / `!let` / ...), and filters -- is
**not core**. The baseline is a Liquid-style dialect, specified in the companion
[DYNAMICS.md](DYNAMICS.md). A conformant parser recognizes the `!` syntax and
emits the events above; it need not implement any particular dialect.

## References and Mixins

### References (`@`)

`@` refers to an element defined elsewhere. A reference is a **selector
tuple** `(element, key, traits)` -- provisional until a path syntax replaces
this wholesale:

| You write | Selector |
|-----------|----------|
| `@[mit]` | `(null, 'mit', [])` |
| `@licence` | `('licence', null, [])` |
| `@licence[mit]` | `('licence', 'mit', [])` |
| `@.realized` | `(null, null, ['realized'])` |
| `@licence[mit].realized` | `('licence', 'mit', ['realized'])` |

- **Traits are selection criteria**, not augmentation of the target. The older
  "not augmentable" rule survives with this sharper meaning: a reference does
  not decorate or mutate the referent; traits only filter *which* definition
  matches. Matching multiplicity is consumer-side.
- **Notably absent by design:** suffixes, attributes, predicates, nesting.
  To vary the target's content, define a new element.

```
|license[mit]
  MIT License
  Copyright 2025...

|project
  :name MyProject
  :license @[mit]    ; (null, 'mit', [])
```

`@element[key]` is the fully explicit form; `@[key]` is key-only shorthand that
**errors at resolve time** if the key is ambiguous across element types (the
parser still emits the inert reference either way).

**A reference is inert at the core level** -- the parser emits it, it does not
resolve it. *How* a consumer resolves `@` is a host decision. Resolution modes
a host may offer:

- **transclude** -- insert the referenced element's structure and content
- **merge attributes** -- fold in only the referenced element's attributes
- **leave inert** -- keep it as a pointer (the streaming / default behavior)

**Event encoding (interim).** Until the structured encoding lands, the
reference parser emits a single `Reference` event whose payload is the **raw
text after `@`** (`@[mit]` → `"[mit]"`, `@license[mit]` → `"license[mit]"`) --
no information loss, one uniform rule. The planned encoding reuses
element-identity machinery: `ReferenceStart` / `Name` / `Attr "$key"` + value /
`Attr "$traits"` + value / `ReferenceEnd` (typed keys, quoted names/traits,
trait stacking free, symmetric with definition-side identity).

The earlier `:[id]` attribute-merge syntax is **removed**: "merge that element's
attributes" is just the *merge* resolution mode above, chosen by the consumer --
not a second core syntax.

### Duplicate Definitions

Because `|` always *defines*, two elements of the same type sharing a key
(`|user[1]` written twice) is a **duplicate definition** -- never a re-open or
merge. Uniqueness is over `(element-type, key)`.

This is a **Document-layer** concern, never a core parse rule: the streaming
parser is stateless and cannot track document-wide keys. When a document is
assembled, the default is to **error** on a duplicate `(element-type, key)`.
The Document builder exposes a policy, so append-oriented sources (event logs,
concatenated generator output) may choose otherwise:

```
error | allow-if-identical | first-wins | last-wins | keep-all
```

plus an optional `warn`. `allow-if-identical` compares by tree-equality
(ignoring spans). The event/streaming layer never checks this, and
`@`-references play no part in it -- uniqueness is a property of *definitions*,
not references.

### Mixins (experimental -- a parser/host behavior, not core)

We are experimenting with letting an anonymous, trait-only element act as a
**mixin**: attaching its trait to another element makes that element inherit
the mixin's attributes.

```
|.defaults
  :adapter postgres
  :host localhost

|database[prod].defaults
  :database prod_db     ; a mixin-aware host also gives it adapter, host
```

Like reference resolution, **this is a parser/host decision -- not required by
core UDON.** The core sees only what is written (see Anonymous Elements): an
anonymous element carrying a trait and some attributes, and another element
that carries the same trait. Whether a consumer reads a matching trait as
inheritance -- and how it resolves overrides, multiple mixins, or child/prose
inheritance -- is entirely up to that consumer. A parser that does no mixin
resolution is still fully conformant.

---

## Value Types

UDON uses **syntactic typing** -- the syntax determines the type, not value
sniffing.

### Type Table

| Syntax | Type | Examples |
|--------|------|---------|
| `"..."` or `'...'` | String | `"hello"`, `'world'` |
| Integer patterns | Integer | `42`, `1_000_000`, `0xFF`, `0o755`, `0b1010` |
| Decimal patterns | Float | `3.14`, `1_000.5`, `1.5e-3` |
| Rational pattern | Rational *(provisional -- see Numbers)* | `1/3r`, `22/7r` |
| Complex pattern | Complex *(provisional -- see Numbers)* | `3+4i`, `5i` |
| `true`, `false` | Boolean | (lowercase only) |
| `null`, `nil` | Nil | (both equivalent) |
| `[...]` | List | `[1 2 3]`, `[a b c]` |
| `:key` (no value) | Boolean `true` | Flag/presence semantics |
| Anything else | String | Unquoted text |

### Explicit Typing (`<...>`)

The types above are the **frozen core scalar set** -- recognized *bare*, from
their syntax alone. This set is closed: nothing is ever added to bare
recognition. Every other -- every **dialect** -- type is written inside an
explicit **`<...>` envelope** in attribute-value position, where `>` terminates
the value:

```
:when  <2026-07-11>            ; a date -- temporal dialect, not bare
:dur   <5m>                    ; a duration; shorthand stays writable in-envelope
:size  <u64:0xf902>            ; type-labelled
:span  <temporal:interval:...> ; dialect + type
```

**Recognition.** In **value position** -- attribute values and array items
alike (uniform value rules) -- a bare value that begins with `<` opens the
envelope; the matching `>` terminates it. To write a *literal* string value
that begins with `<`, quote it (`:x "<not a type>"`, `["<not a type>"]`).
Outside bare value position -- in prose, or inside quotes -- `<` has no special
meaning.

**Interim behavior -- no dialects yet (this version).** The dialect layer is
not built. Until it lands, a conformant parser still recognizes the envelope
(the `<>`-balanced span, terminating the value at the matching `>`) but emits
warning code `NoDialectsLoaded` and passes the value through as a plain
string -- the full `<...>` lexical form, untouched (`:dur <5m>` is the string
`"<5m>"` plus the warning). Nothing is lost or silently retyped; when dialects
land, the same document parses to typed values and the warning disappears.

**Nesting (forward note, deliberately under-specified).** Typed values will
eventually nest -- a composite whose components are themselves typed, e.g.
`<r: <i: 3 -7> 0d83.23>` (a rational of a complex numerator and a decimal
denominator). When they do, "the matching `>`" is depth-counted -- a
`<>`-balanced span, like the brace-balancing already used for `|{...}` and
`;{...}` -- and there is an implied bracket-stack. *Who* routes the inner typed
values is left open on purpose: it may be an implicit dialect stack that the
active dialect drives, rather than the core grammar consuming and handing off.
This note fixes only that nesting is anticipated and stays `<>`-balanced; it does
not specify the routing, which is likely a dialect concern to settle when
dialects are fleshed out. See `design/composite-types.md`.

**Label ladder.** The envelope may be unlabelled (`<...>`), type-labelled
(`<type:...>`), or dialect-and-type-labelled (`<dialect:type:...>`) -- least to
most specific.

**Unlabelled dispatch.** An unlabelled `<content>` is offered to the document's
declared dialects **in declared order; the first to claim it wins; if all
decline, it is an error.** No sniffing race. *Which* dialects are active by
default is a host/parser choice (see The Core, and What It Leaves Open), not
spec-forced.

This envelope is the **visible boundary between core and dialect**: bare means a
frozen core scalar (or a string); `<...>` means a dialect resolves it. Because
dialects never touch bare space, adding a dialect can never silently retype an
existing document -- accretion is structurally impossible.

**Temporal** is the first standard dialect: *all* temporal values -- dates,
times, datetimes, durations, offsets, ISO forms included -- require the
envelope, and a bare `2026-07-11` is simply the string `"2026-07-11"`. See the
`temporal@1` companion spec (the former TIME-SPEC).

### Numbers

Two numeric types are recognized *bare*, from syntax alone: **integer** and
**float**. An optional leading `+` or `-` signs either, and `_` may be
interleaved between digits of any base for readability (`1_000_000`, `0xFF_FF`)
with no effect on the value. Base prefixes and scientific notation exist so a
literal can mirror its *natural written form* -- the author never has to
translate a value into a different base or notation to write it down.

**Integers** come in four bases, each an explicit `0`-prefix qualifier:

| Base | Prefix | Digit set | Example |
|------|--------|-----------|---------|
| Decimal | *(none)* or `0d` / `0D` | `0`-`9` | `42`, `1_000_000`, `0d42` |
| Hexadecimal | `0x` / `0X` | `0`-`9` `a`-`f` `A`-`F` | `0xFF` |
| Octal | `0o` / `0O` | `0`-`7` | `0o755` |
| Binary | `0b` / `0B` | `0` `1` | `0b1010` |

A leading `0` *followed by more decimal digits* is decimal, not octal --
`0755` is `755`. The explicit `0d` prefix (`0d42`) is the unambiguous way to
*say* "decimal" when it matters.

**Floats** are decimal numbers that carry a fractional part (`.` then digits),
an exponent (`e`/`E`, optional `+`/`-`, then digits), or both: `3.14`, `1e10`,
`1.5e-3`. A decimal token with neither a `.` nor an exponent is an integer.

```
42          1_000_000   0d42   ; Integers (decimal, incl. explicit 0d)
0xFF        0o755       0b1010 ; Hex, octal, binary
3.14        1e10        1.5e-3 ; Floats
```

*(Reference grammar: `core/generator/values.desc` -- `num_dec` / `num_hex` /
`num_oct` / `num_bin`, leading-zero-is-decimal in `num_zero`, floats
`num_float_frac` / `num_float_exp`. `0d` is a small pending grammar addition, a
`d`/`D` arm in `num_zero`.)*

**Rational and complex are provisional.** The grammar today also recognizes bare
`1/3r` / `22/7r` (rational) and `5i` / `3+4i` (complex). At the moment their
status is **parser-decided** -- the grammar recognizes them, and that is where
the decision sits until the dialect layer lands, at which point it gets nailed
down. Both are **current candidates** to move out of the bare core into a
**standard-types `<...>` dialect** (e.g. `<r: 1 3>`, `<i: 3 4>`), where
composition and nesting are clean and operator-free.

A rational is inherently compositional -- two literals over a bar -- so it leans
toward the dialect. A complex has no such lean and could go either way: bare `5i`
is a single number with a suffix (like `0d` or the `e` of scientific notation)
and has a real claim to staying a literal; only the composed `3+4i` (real +
imaginary) pulls toward the envelope. Treat both as not yet frozen. See
`design/composite-types.md`.

### Booleans

```
:enabled true     ; Boolean true
:debug false      ; Boolean false
:flag             ; Boolean true (missing value = true)
```

Lowercase only. `TRUE`, `True`, `FALSE` are strings.

### Nil

Two equivalent spellings:

```
:value null
:value nil
```

### Strings

```
:name "quoted string"       ; Explicit string
:name 'single quotes'       ; Also string
:desc unquoted text here    ; String (fallback)
:truthy "true"              ; String "true", not boolean
:number "42"                ; String "42", not integer
```

### Lists

```
:ports [8080 8443 9000]
:tags [api public internal]
:mixed [1 two 3.0 true]
:quoted ["hello world" foo bar]
:empty []
```

Each element is typed independently by the same rules.

### Absent vs Nil vs False

```
|config
  :debug              ; debug = true (flag present)
  :verbose false      ; verbose = false (explicit)
  :deprecated null    ; deprecated = nil (explicitly unset)
  ; timeout is absent (key doesn't exist)
```

These are distinct:
- **Absent**: Key not present at all
- **Nil**: Key present, value explicitly "no value"
- **False**: Key present, value is boolean false
- **True**: Key present with no value (flag) or explicit `true`

---

## Design Principles

### Attributes Before Children

```
|element[key].trait :attr1 value1 :attr2 value2
  children here
```

Attributes must precede child content. No scattered attributes.

### Strict Whitespace

- Spaces only, no tabs
- Error on mixed indentation

### Streaming Parse

Support callback/event mode for incremental processing:
- Parse as data arrives (LLM streaming)
- Emit complete subtrees as they close
- Pause/resume with state preservation

---

## Examples

For additional authoring guidance, see `examples/practices-gotchas.udon` (in review).

### Configuration

```
|database[primary].postgres
  :host db.example.com
  :port 5432
  :pool 10
```

---

## Parser Naming Convention (Non-Normative)

Parser functions should use this terminology consistently:

| Old Name | New Name | Purpose |
|----------|----------|---------|
| `inline_attr` | `sameline_attr` | Attr on element line |
| `block_attr` | `block_attr` | Attr on own line (unchanged) |
| `bare_string` | `bare_string_block` | Block attr values |
| `bare_string_inline` | `bare_string_sameline` | Sameline attr values |
| (new) | `bare_string_embedded` | Embedded attr values |
| (new) | `bare_string_array` | Array item values |
| `inline_text` | `sameline_text` | Text on element line |
| `embedded` | `embedded` | `|{...}` (unchanged) |

---

## Test Cases (Non-Normative)

The examples in this document should be converted to unit tests. Key scenarios:

1. **Hierarchy tests** (from \"Hierarchy\" section):
   - Inline nesting equivalence
   - Sibling after inline elements
   - Column alignment = sibling
   - Child of inline element
   - Multi-line progression
   - Complex many-inline-elements
   - Closing multiple levels

2. **Prose dedentation tests** (from \"Automatic Prose Dedentation\" section):
   - Inline content freedom (multiple valid indent choices)
   - Nested inline elements with indented siblings
   - Inconsistent indentation warnings
   - Extra spaces preserved in output
   - Blank lines passed through
   - Freeform blocks preserve whitespace

3. **Comment tests** (from \"Comments and Indentation\" section):
   - Block comments trigger indent/dedent
   - Block comment at column 0 closes nested elements
   - Block comment within element stays within element
   - Inline comments `;{...}` stripped from output
   - Head-position `\` forces prose (a leading `\;` outputs a literal `;`)
   - A `\` past an established prose base is literal and warns (not head position)

---

## Bounded Lookahead (Non-Normative)

UDON is deliberately a **bounded-lookahead** grammar. Every head-position guard
resolves with a few characters of lookahead (typically 2-3 -- `|` plus the next
character, three backticks, and so on), single-level, with no deep
backtracking. This is a constraint on the *language*, not merely a property of
one parser: new syntax should stay inside it.

Two consequences:

- **It is why a recursive-descent state machine (descent) fits, and a PEG is
  not needed.** Deep backtracking or unbounded lookahead would force a different
  strategy; keeping the bound small keeps the parser simple and fast.
- **Pending lookahead is suspendable state.** When streaming, a chunk boundary
  can land mid-guard -- a `|` whose next byte has not arrived yet. Those
  un-emitted bytes are held in the parser's saved state and resolved when the
  next chunk arrives; nothing is emitted until the guard decides. This is what
  lets the same small machine parse a whole document or a byte-at-a-time stream.

---

## Implementation Notes (Non-Normative)

- Interpolation in attribute values and element keys is not yet implemented in
  the parser; intended behavior is described in the DYNAMICS.md companion spec.
- Raw directives and freeform blocks are parsed as specified, but host behavior
  (highlighting, execution, etc.) is host-defined.

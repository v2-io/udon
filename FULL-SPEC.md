# UDON Full Specification

**Universal Document & Object Notation**
*Version 0.7-draft -- December 2025*

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

**Parser behavior note:** Comments are emitted as events by the main parser.
What consumers do with them (AST inclusion, filtering, etc.) is up to the host.

---

## Positional Contexts (Vocabulary)

The parser operates in different contexts that affect parsing behavior:

| Term | Meaning | Example |
|------|---------|---------|
| **block** | On its own indented line | `:key value` as child of element |
| **sameline** | On the element definition line | `|el :key value Content` |
| **inline** | Embedded in prose/text flow | `|{em text}`, `;{comment}`, `!{dir}` |
| **embedded** | Inside `|{...}` delimiters | Synonym for inline element context |

### Block vs Sameline

```udon
|article
  :author Alice                    ; block attribute
  :date 2024-12-31                 ; block attribute

|section :id intro :class lead     ; sameline attributes
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
| `'` | Literal -- prevents interpretation of a *block-level* marker |

Anything else is **prose content** belonging to the parent element.

### Block-Level Escape (`'`)

At block level (line start after indentation), apostrophe followed by a
block-marker character (`|`, `;`, `:`, `!`, or `'`) **always** triggers an
escape. The apostrophe is consumed and the following character is output
literally (not parsed as a marker).

**Simple rule:** `'` + one of `|;:!'` → escape, always. No further lookahead.

```
'|element    →  "|element"     ; escaped pipe, output as prose
';comment    →  ";comment"     ; escaped semicolon
':attr       →  ":attr"        ; escaped colon
'!directive  →  "!directive"   ; escaped bang
''more       →  "'more"        ; escaped apostrophe

'hello       →  "'hello"       ; NOT an escape (h is not a marker)
```

If `'` is followed by a non-marker character, it is **not** an escape—the
apostrophe is preserved as normal prose content.

**Alternate:** Backslash (`\`) also works as a block-level escape before the
same marker characters. However, apostrophe is the *preferred* and *documented*
form for block-level escapes. Backslash is supported for consistency with
sameline/embedded contexts but should not be promoted in tutorials or examples.

### Sameline/Embedded Escape (`\`)

Backslash escapes a literal semicolon in **sameline** or **embedded** contexts
(where `;` would otherwise start a comment):

```
|el :key value\;more text ; this part is a comment
|{em text\;more}
```

Block prose does not need escapes for `;` (semicolons are literal there).

**Note:** Inside quoted strings (`"..."` or `'...'`), escape prefixes have no
special meaning—quoted strings handle their own escaping per their delimiter
rules.

---

## Elements

Elements are the structural backbone:

```
|element-name
```

**Element recognition rule:** `|` is only an element marker when followed by
one of: a letter, `[`, `.`, `{`, or `'`. Otherwise `|` is treated as prose
(preserves Markdown table compatibility).

### Identity and Classification

```
|element[id].class1.class2
```

- `[id]` -- Singular identity; referenceable, unique within scope
- `.class` -- Classification/traits; multiple allowed, stackable

The `[id]` syntax is shorthand for an attribute:

```
|element[my-id]     ->  |element :'$id' my-id
|step[1]            ->  |step :'$id' 1
|item[abc-123]      ->  |item :'$id' abc-123
```

The value inside brackets follows attribute value rules--all the same types are
available (integers, strings, etc.).

These are fundamental patterns:
- **Identity**: What makes this thing THIS thing (singular)
- **Classification**: What kinds of thing this is (plural, aspects)

### Element Suffixes

Elements can have suffix modifiers (`?`, `!`, `*`, `+`) that expand to attributes:

```
|field[name]?      ->  |field[name] :'?' true
|field[name]!      ->  |field[name] :'!' true
|field[name]*      ->  |field[name] :'*' true
|field[name]+      ->  |field[name] :'+' true
```

UDON performs the expansion; the meaning is DSL-defined:
- Schema DSL might interpret `?` as optional, `!` as required
- Grammar DSL might interpret `?` as 0-or-1, `*` as 0+, `+` as 1+

**Allowed positions** (suffix attaches to element identity):

```
|name?                   ; After element name
|name?[id]               ; After name, before id
|name?[id].class         ; After name, before id and classes
|name[id]?               ; After id
|name[id]? .class        ; After id, space before classes
|name[id].class ?        ; Space-separated at end
```

**Reserved** (suffix on class -- for future use):

```
|name[id].class?         ; NOT allowed -- reserved for class-level modifiers
|name[id].class!         ; NOT allowed
```

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

### Inline Lists

Square brackets for list values:

```
|server :ports [8080 8443 9000] :tags [api public]
```

- Space-delimited within brackets
- Quoted strings for values with spaces: `["hello world" foo bar]`

### Complex Attribute Values

When an attribute needs structured content, use indentation:

```
|api-endpoint
  :method POST
  :headers
    |header :name Content-Type :value application/json
    |header :name Authorization :value Bearer token
```

Attribute followed by newline+indent = structured value.

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

#### Sameline Attribute Values

```udon
|el :key1 value1 :key2 value2 ; comment
|el :url https://x.com :class foo
```

Terminators: `\n` or `SPACE`

- Space delimits values
- Use quotes for values with spaces: `:key "hello world"`
- `;` after values starts comment (child of element)
- `:` after space starts next attribute

#### Embedded Attribute Values

```udon
|p Click |{a :href /home :class link here} now.
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
- `}` before `]` is malformed (unspecified behavior)

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
| Sameline prose | Line comment | `|p text ; comment` |
| Block attr line | Line comment (after values) | `:key value ; comment` |
| Sameline attrs | Line comment (after values) | `|el :k v ; comment` |
| Inline/embedded | `;{...}` only | `|{em text ;{note}}` |

**Parser behavior:** Comments are emitted as events, not discarded. The
consuming layer decides whether to keep or strip them.
This enables use cases like documentation extraction, TODO tracking, or
comment-aware transformations.

Line comments may be continued by indentation: if a line comment is followed by
a more-indented line that does not start with a prefix, that line is treated as
comment content until dedent.

```
; This would be a comment
  this is still part of the comment
'; But this is output as text.
\; This could output as text too.
```

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

---

## Semicolon Escapes (Sameline / Embedded)

Different contexts use different escape mechanisms for literal `;`:

| Context | Escape Method | Example |
|---------|---------------|---------|
| Block prose | N/A (`;` is literal) | `code; more code` |
| Block attr value | Quote the value | `:sql 'SELECT *; DROP'` |
| Sameline attr/prose | Backslash | `|el :k val\;ue ; comment` |
| Embedded | Backslash | `|{em text\;more}` |

Rationale:
- Block prose preserves literal content (code, etc.) - no escape needed
- Block attr values support quoting naturally (same as spaces)
- Sameline/embedded use backslash (consistent with other escapes)

Backslash escapes are supported but discouraged for general authoring; prefer
block prose or quoted values when possible.

Examples:

```
|el :key and-this\;-is-ok this is prose ; and this is a comment
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

### The Column Rules

1. **Greater column = child** (push onto stack)
2. **Same column = sibling** (pop current, push as child of parent)
3. **Lesser column = dedent** (pop until column > top's base_column)

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

---

## Inline and Embedded Elements

For inline elements within prose, use the embedded form `|{...}`:

```
|p This paragraph has |{em emphasized text} and |{a :href /foo a link} inline.
```

The embedded element:
- Starts with `|{`
- Contains element name, optional id/classes, optional attributes, and content
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

---

## Unified Inline Syntax

All prefix characters support a bracket-delimited inline form:

| Syntax | Description |
|--------|-------------|
| `|{element ...}` | Embedded element |
| `!{{expr}}` | Interpolation (double-brace) |
| `!{directive ...}` | Inline directive |
| `;{comment}` | Inline comment |
| `'|{...}` or `\|{...}` | Escaped (literal text) |

The character immediately after the prefix determines the parse mode with no
lookahead.

**Note:** Apostrophe escaping applies to block-level markers (line start after
indentation). Within prose/sameline contexts, backslash escapes are supported
for literal semicolons and `\|{...}` literals, but are discouraged for general
use.

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
- Dedented on output relative to the directive's indent level

### Inline Raw Content

For inline raw content, use `!{:kind: ...}`:

```
|p The response was !{:json: {"status": "ok", "count": 42}} as expected.
```

Inline raw uses brace-counting. The parser finds the closing `}` by counting
brace depth. Nested `{}` pairs are fine as long as they're balanced.

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

Triple-backticks break out of indentation sensitivity entirely.

**Opening backticks:**
- The indentation of ``` determines the block's structural parent
- Need not be at line start -- can follow other content
- Content after ``` on the same line is part of the freeform block

```
|element and here we go with ```
freestyling it!
no indent rules in here
```

|parent
  |child
    some content then ``` and now we're free
anything goes
back at column 0
    ``` ; closing ideally matches but not required
```

**Closing backticks:**
- Should match opening indent (preferred)
- Not strictly required -- first ``` at opening indent or less closes the block

Use this **only** when:
- Assembling files from multiple sources without indent control
- Working with broken tooling that can't maintain indentation
- The rare case where absolute positioning matters

Do not use triple-backticks as the default for code samples. Use `!:lang:`
for raw code blocks.

---

## Dynamics Extension

The `!` prefix enables evaluation and control flow. The specific dialect depends
on the host environment, with Liquid-style primitives as a common baseline.

### Inline Forms

All dynamic inline forms use `!{...}` with immediate disambiguation:

| Syntax | Form | Description |
|--------|------|-------------|
| `!{{expr}}` | Interpolation | Double-brace for value interpolation |
| `!{:kind: ...}` | Raw directive | Content is opaque, brace-counted |
| `!{directive ...}` | Directive | Content is parsed as UDON (can contain `|{...}`, `;{...}`) |

The second character after `!{` determines the form:
- `{` -> interpolation (`!{{...}}`)
- `:` -> raw directive with colon-wrapped label
- Otherwise -> directive with UDON parsing inside

Non-raw inline directives support nested UDON:
```
!{include |{em emphasized} content}
```

Note: This may change in future to prefer filter-based includes like
`!{{'file.un' | include}}` instead.

### Interpolation

```
|greeting
  Hello, !{{user.name}}!

|link :href !{{base_url}}/users/!{{user.id}}
```

Empty interpolation (`!{{}}`) is valid--the parser emits an Interpolation event
with empty expression content. The host decides how to handle it.

### Filters

```
!{{value | filter1 | filter2 arg}}

!{{name | capitalize}}
!{{date | format "%Y-%m-%d"}}
!{{items | first}}
!{{price | currency "USD"}}
```

### Interpolation in Typed Contexts (Implementation Notes)

**Implementation Status:** Interpolation in attribute values and element IDs is
not yet implemented in the parser. Currently, `!{{...}}` syntax in these
contexts is passed through as literal string content. This section describes
intended behavior.

When an attribute value is entirely an interpolation, the parser emits it as an
interpolation event. The resulting type is **unparsed**--the host must evaluate
it to determine actual type:

```
|div[!{{dynamic_id}}]
|link :href !{{computed_url}}
```

When interpolation is mixed with literal content, the value becomes a
multi-part string. All non-interpolation parts are treated as string segments,
even if they started parsing as numbers:

```
|div[prefix_!{{id}}_suffix]
|link :path !{{base}}/.config
|item[283!{{more}}]
```

**Parser implementation note:** Multi-part values emit as a sequence:
`ArrayStart`, then alternating `StringValue`/`Interpolation` events, then
`ArrayEnd`. If parsing began as a numeric type and hits interpolation, emit
accumulated content as `StringValue` instead.

### Expression Grammar

UDON adopts Liquid's intentionally simple expression grammar.

#### Operators

| Category | Operators | Notes |
|----------|-----------|-------|
| Comparison | `==` `!=` `<>` `<` `>` `<=` `>=` | `<>` is synonym for `!=` |
| Logical | `and` `or` | Right-to-left evaluation |
| Membership | `contains` | Substring or collection membership |

```
!if age >= 18
!if user.verified and user.subscribed
!if tags contains "featured"
```

#### What Expressions Cannot Do

- No parentheses
- No arithmetic (use filters)
- No ternary operator
- No negation operator (use `== false` or `!unless`)

#### Evaluation Order

Logical operators evaluate **right-to-left** with no precedence.

This differs from standard precedence (where `and` typically binds tighter than
`or`). The difference only affects expressions mixing both operators:

| Expression | Right-to-left (Liquid) | Standard precedence |
|------------|------------------------|---------------------|
| `false and true or true` | `false and (true or true)` -> **false** | `(false and true) or true` -> true |
| `true and false or true` | `true and (false or true)` -> **true** | `(true and false) or true` -> true |
| `false or true and false` | `false or (true and false)` -> **false** | `false or (true and false)` -> false |
| `true or false and false` | `true or (false and false)` -> **true** | `true or (false and false)` -> true |

To express `(a or b) and c`, use nested conditionals:

```
!if c
  !if a or b
    Content here
```

#### Truthiness

Only two values are falsy:
- `false`
- `nil` / `null`

| Value | Truthy? |
|-------|---------|
| `false` | No |
| `nil` / `null` | No |
| `\"\"` (empty string) | **Yes** |
| `0` | **Yes** |
| `[]` (empty list) | **Yes** |
| Everything else | **Yes** |

To test for empty values, use explicit comparison:

```
!if title != \"\"           ; Check non-empty string
!if items != empty        ; Check non-empty collection
!if value != blank        ; Check defined and non-empty
```

The `empty` keyword tests if a defined value is empty. The `blank` keyword
tests if a value is undefined OR empty.

### Control Flow

```
!if condition
  Content when true
!elif other_condition
  Alternative
!else
  Fallback

!unless condition
  Content when false

!for item in collection
  |card
    :title !{{item.name}}
    !{{item.description}}

!let local_var = expression
  Content using local_var

!include partials/header
```

**Parser implementation note:** Block directives use the same `raw` flag as
inline directives. The parser does not enumerate directive names--any name is
accepted. The only distinction is colon-wrapped syntax:
- `!:lang:` -> Raw block (raw=true)
- `!if`, `!for`, etc. -> Normal block (raw=false)

### Inline Control Flow

UDON does not currently support inline forms of control flow directives
(`!if`, `!for`, etc.). These remain block-level only, using indentation to
delimit scope.

Syntax for inline control flow (e.g., `!if{cond}{then}{else}`) is under
investigation but not yet specified.

### Key Insight: Indentation Eliminates Closing Tags

```
; UDON -- no closing tags needed
!if logged_in
  |greeting Welcome back!
!else
  |greeting Hello, guest!

; vs Liquid -- closing tags required
{% if logged_in %}
  <div class=\"greeting\">Welcome back!</div>
{% else %}
  <div class=\"greeting\">Hello, guest!</div>
{% endif %}
```

### Host-Specific Dialects

The `!` prefix is intentionally extensible. Hosts may provide:

- **Elixir**: `!{{@assigns.user}}`, EEx-style
- **Python**: `!{{context['user']}}`, Jinja-style
- **JavaScript**: `!{{props.user}}`, JSX-style

---

## Implicit References

### Class as Mixin

A class-only element (no element name) defines inheritable traits:

```
|.defaults
  :adapter postgres
  :host localhost
  :pool 5

|database[production].defaults
  :database prod_db
  :pool 20  ; Override
```

Classes also serve as lightweight classification even when no mixin is defined.

**Note:** The precise behavior for inheriting child elements and prose content
from mixins is not yet fully defined. Attribute inheritance (with override) is
clear; subtree inheritance semantics are still being refined.

### Multiple Inheritance

```
|.logging
  :log-level info

|.caching
  :cache-ttl 3600

|service[api].defaults.logging.caching
  :name api-server
```

Left-to-right application; later values override earlier (CSS cascade).

### ID Reference

Reference elements by identity:

```
|license[mit]
  MIT License
  Copyright 2025...

|project
  :name MyProject
  :license @[mit]    ; Reference by ID
```

**Two forms:**

`@[id]` -- Insert the entire element (structure and content):

```
|template[header]
  |nav
    |a :href / Home
    |a :href /about About

|page
  @[header]          ; Inserts the full |nav structure here
  |main ...
```

`:[id]` -- Merge only attributes from that element:

```
|.db-defaults[base-db]
  :adapter postgres
  :host localhost
  :pool 5

|database :[base-db] :database myapp_prod :pool 20
; Equivalent to: |database :adapter postgres :host localhost :pool 5 :database myapp_prod :pool 20
```

---

## Formal Grammar (EBNF-style)

```ebnf
document      = { line }* ;

line          = indent ( element | attribute | dynamic | comment | prose ) ;

; NOTE: Comment and bare-string termination are context-sensitive
; (block vs sameline vs embedded).

indent        = { SPACE }* ;

; Element recognition: "|" is only an element when followed by one of:
;   - Unicode letter (\p{L}) -- named element
;   - "[" -- anonymous element with id
;   - "." -- anonymous element with class
;   - "{" -- embedded element
;   - "'" -- quoted element name
; Otherwise "|" is prose (preserves Markdown table compatibility)

; Elements with optional suffix modifiers
element       = "|" [ name ] [ suffix ] [ id [ suffix ] ] { class }*
                [ SPACE suffix ] { attribute }* { inline_child }* ;
name          = LABEL | quoted_label ;
id            = "[" id_value "]" ;
id_value      = typed_value | bare_string ;  ; Same as attribute values
class         = "." LABEL ;
suffix        = "?" | "!" | "*" | "+" ;
inline_child  = element | embedded_element | inline_text ;
inline_text   = { CHAR - NEWLINE - "|{" }+ ;

; Embedded elements (for inline use in prose)
embedded_element = "|{" [ name ] [ id ] { class }* { attribute }*
                   { embedded_content }* "}" ;
embedded_content = embedded_element | { CHAR - "|{" - "}" }+ ;

; Attributes with typed values
attribute     = ":" ( LABEL | quoted_label ) [ value ] ;
value         = typed_value | block_value ;
typed_value   = nil_value | bool_value | complex | rational | number
              | list_value | string_value ;
nil_value     = "null" | "nil" | "~" ;
bool_value    = "true" | "false" ;

; Numbers
number        = float | integer ;
integer       = [ "-" ] ( dec_int | hex_int | oct_int | bin_int ) ;
dec_int       = [ "0d" ] DIGIT { DIGIT | "_" }* ;
hex_int       = "0x" HEX { HEX | "_" }* ;
oct_int       = "0o" OCT { OCT | "_" }* ;
bin_int       = "0b" BIN { BIN | "_" }* ;
float         = [ "-" ] DIGIT { DIGIT | "_" }* "." DIGIT { DIGIT | "_" }* [ exponent ] ;
exponent      = ( "e" | "E" ) [ "+" | "-" ] DIGIT { DIGIT }* ;
rational      = [ "-" ] DIGIT { DIGIT }* "/" DIGIT { DIGIT }* "r" ;
complex       = ( number | "" ) ( "+" | "-" ) number "i" | number "i" ;

; Collections
list_value    = "[" { list_item }* "]" ;
list_item     = typed_value ;

; Strings
string_value  = quoted_string | bare_string ;
quoted_string = '"' { CHAR }* '"' | "'" { CHAR }* "'" ;
bare_string   = { CHAR - (SPACE ":") - (SPACE "|") - NEWLINE }+ ;
block_value   = NEWLINE INDENT { line }+ DEDENT ;

; Dynamics -- all inline forms use !{...}
dynamic           = "!" ( interpolation | inline_dynamic | block_directive ) ;
interpolation     = "{{" expression [ "|" filter { "|" filter }* ] "}}" ;
inline_dynamic    = "{" directive_name directive_body "}" ;
block_directive   = directive_name { CHAR }* ;  ; Body determined by indentation
directive_name    = LABEL [ ":" LABEL ] ;
directive_body    = { CHAR - "{" - "}" | "{" directive_body "}" }* ;

; Comments
comment           = ";" ( inline_comment | line_comment ) ;
line_comment      = { CHAR }* ;
inline_comment    = "{" { CHAR - "{" - "}" | "{" inline_comment "}" }* "}" ;
; NOTE: A line comment may be followed by indented continuation lines, which
; are treated as comment content until dedent.

; Other
prose         = { CHAR }+ ;
literal       = "'" CHAR ;
freeform      = "```" { CHAR }* NEWLINE { any_line }* "```" ;

; Terminals
LABEL         = /[\p{L}_][\p{L}\p{N}_-]*/ ;
quoted_label  = "'" { CHAR_NOT_QUOTE | "\\'" }* "'" ;
CHAR_NOT_QUOTE = CHAR - "'" - "\\" | "\\" CHAR ;
DIGIT         = /[0-9]/ ;
HEX           = /[0-9a-fA-F]/ ;
OCT           = /[0-7]/ ;
BIN           = /[01]/ ;
SPACE         = " " ;
NEWLINE       = "\n" | "\r\n" ;
CHAR          = any character except NEWLINE ;
```

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
| Rational pattern | Rational | `1/3r`, `22/7r` |
| Complex pattern | Complex | `3+4i`, `5i` |
| `true`, `false` | Boolean | (lowercase only) |
| `null`, `nil`, `~` | Nil | (all equivalent) |
| `[...]` | List | `[1 2 3]`, `[a b c]` |
| `:key` (no value) | Boolean `true` | Flag/presence semantics |
| Anything else | String | Unquoted text |

### Numbers

Numeric literals follow Ruby conventions: integers, floats, scientific notation
(`1e10`), hex (`0x`), octal (`0o`), binary (`0b`), explicit decimal (`0d`),
rationals (`1/3r`), and complex (`3+4i`). Underscores allowed for readability
(`1_000_000`).

```
42          1_000_000       ; Integers
3.14        1.5e-3          ; Floats
0xFF        0o755   0b1010  ; Hex, octal, binary
1/3r        3+4i            ; Rational, complex
```

**Note:** Plain `0755` is decimal `755` (leading zeros stripped, no implicit
octal). Use `0o755` for octal.

### Booleans

```
:enabled true     ; Boolean true
:debug false      ; Boolean false
:flag             ; Boolean true (missing value = true)
```

Lowercase only. `TRUE`, `True`, `FALSE` are strings.

### Nil

Three equivalent spellings:

```
:value null
:value nil
:value ~
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
|element[id].class :attr1 value1 :attr2 value2
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

## Open Questions

1. **Quoted strings in arrays:** Do they follow the same rules as other typed
   values? Currently: quotes handled before bare_string dispatch.

---

## Implementation Notes (Non-Normative)

- Interpolation in attribute values and element IDs is not yet implemented in
  the parser; intended behavior is described in the Dynamics section.
- Raw directives and freeform blocks are parsed as specified, but host behavior
  (highlighting, execution, etc.) is host-defined.

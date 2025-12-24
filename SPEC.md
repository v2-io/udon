# UDON Specification

**Universal Document & Object Notation**
*Version 0.7-draft — December 2025*

---

## Overview

UDON is a unified notation for data, documents, and configuration. It combines structured elements with natural prose, optimized for both human readability and machine parsing.

Key properties:
- Indentation-based hierarchy (no closing tags)
- Markdown-compatible prose within elements
- Streamable, incremental parsing
- Syntactic typing (not sniffing)

---

## Core Syntax

### Prefixes

Four special characters at line start (after indentation):

| Prefix | Domain | Purpose |
|--------|--------|---------|
| `\|` | Structure | Elements and nodes |
| `:` | Attributes | Key-value metadata |
| `!` | Dynamics | Evaluation, control flow, interpolation |
| `;` | Comments | Ignored by parser |

One escape prefix:

| Prefix | Purpose |
|--------|---------|
| `'` | Literal — prevents interpretation of following character |

Anything else is **prose content** belonging to the parent element.

---

## Elements

Elements are the structural backbone:

```
|element-name
```

### Identity and Classification

```
|element[id].class1.class2
```

- `[id]` — Singular identity; referenceable, unique within scope
- `.class` — Classification/traits; multiple allowed, stackable

The `[id]` syntax is shorthand for an attribute:

```
|element[my-id]     →  |element :'$id' my-id
|step[1]            →  |step :'$id' 1
|item[abc-123]      →  |item :'$id' abc-123
```

The value inside brackets follows attribute value rules—all the same types are available (integers, strings, etc.).

These are fundamental patterns:
- **Identity**: What makes this thing THIS thing (singular)
- **Classification**: What kinds of thing this is (plural, aspects)

### Element Suffixes

Elements can have suffix modifiers (`?`, `!`, `*`, `+`) that expand to attributes:

```
|field[name]?      →  |field[name] :'?' true
|field[name]!      →  |field[name] :'!' true
|field[name]*      →  |field[name] :'*' true
|field[name]+      →  |field[name] :'+' true
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

**Reserved** (suffix on class — for future use):

```
|name[id].class?         ; NOT allowed — reserved for class-level modifiers
|name[id].class!         ; NOT allowed
```

### Attributes

Inline key-value pairs:

```
|element :key value :another-key another value
```

Attribute values run until:
- End of line, or
- Space followed by `:` (next attribute), or
- Space followed by `|` (inline child element)

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

---

## Hierarchy

Indentation determines parent-child relationships:

```
|parent
  |child
    |grandchild
  |sibling-of-child
```

Rules:
- Spaces only (no tabs)
- Consistent indent increment (typically 2 spaces)
- Dedent closes scope automatically

### Inline Children

Multiple elements on one line nest rightward:

```
|a |b |c        ; Equivalent to |a containing |b containing |c
```

### Column-Aligned Siblings

When a subsequent line places an element at the same column as a previous inline element, they become siblings (children of the same parent):

```
|table |tr |td A1
           |td A2       ; same column as |td A1 → sibling (both children of |tr)
       |tr |td B1       ; same column as first |tr → sibling (both children of |table)
           |td B2
  |caption Table 1      ; indented from |table → child of |table
```

The column position determines ancestry: an element becomes a child of whichever element "owns" that column based on the nesting established above it.

### Embedded Elements

For inline elements within prose, use the embedded form `|{...}`:

```
|p This paragraph has |{em emphasized text} and |{a :href /foo a link} inline.
```

The embedded element:
- Starts with `|{`
- Contains element name, optional id/classes, optional attributes, and content
- Closes with `}`
- Becomes a child of the containing element (sibling to surrounding text)

Multiple embedded elements are siblings:

```
|nav |{a :href / Home} |{a :href /about About} |{a :href /contact Contact}
```

Embedded form is also useful for complex inline structures:

```
|p See |{a :href /doc the |{em official} documentation} for details.
```

Here `|{em official}` is nested inside `|{a ...}`.

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

Since `;` is the comment delimiter, `#` has no special meaning in prose. Markdown flows naturally.

**Prefer Markdown over inline UDON in prose.** When both could work, use Markdown:

```
; Preferred — familiar, readable
This has `inline code` and **bold** text.

; Avoid — over-engineered for simple formatting
This has |{code inline code} and |{strong bold} text.
```

Reserve `|{...}` inline elements for cases where you need attributes or semantic structure that Markdown cannot express.

Embedded elements can appear within prose using `|{...}`:

```
|article
  :author Joseph

  This paragraph contains |{em emphasized text} and
  |{a :href /reference a reference link} inline with the prose.
```

---

## Comments

Semicolon starts a comment (Rebol/Lisp style):

```
; This entire line is a comment

|element :attr value  ; Inline comment after content
```

Comments are stripped by the parser.

---

## Literal Escape

Apostrophe prevents interpretation of the next character:

```
'|this-is-not-an-element   ; Renders as: |this-is-not-an-element
':not-an-attribute          ; Renders as: :not-an-attribute
';not-a-comment             ; Renders as: ;not-a-comment
''literal-apostrophe        ; Renders as: 'literal-apostrophe
```

Only needed at positions where prefixes would otherwise trigger parsing.

**Note:** Inside quoted strings (`"..."` or `'...'`), the escape prefix has no special meaning—quoted strings handle their own escaping per their delimiter rules.

---

## Code and Raw Content

### Raw Directives

Use `!raw:lang` for code samples and raw (non-UDON) content:

```
|example
  !raw:elixir
    def hello do
      IO.puts("world")
      |> this_pipe_is_elixir_not_udon()
    end
```

The `!raw:` prefix signals that the body is **not UDON**—it will be captured
verbatim. The language tag after the colon (e.g., `elixir`, `sql`, `json`) is
passed to the host for syntax highlighting, execution, or other processing.

The content follows normal indentation rules:
- Indented under the directive
- Not parsed as UDON (no `|`, `:`, `!`, `;` interpretation)
- Dedented on output relative to the directive's indent level

Inline raw content uses the interpolation syntax:

```
|p The response was !{raw:json {"status": "ok", "count": 42}} as expected.
```

Note: Raw content cannot be an attribute value directly—attributes are typed scalars.

This is the **idiomatic way** to include code samples, SQL, or any non-UDON content.

### Triple-Backtick Escape (Rare)

Triple-backticks break out of indentation sensitivity entirely.

**Opening backticks:**
- The indentation of ``` determines the block's structural parent
- Need not be at line start — can follow other content
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
- Not strictly required — first ``` at opening indent or less closes the block

Use this **only** when:
- Assembling files from multiple sources without indent control
- Working with broken tooling that can't maintain indentation
- The rare case where absolute positioning matters

**Do not use triple-backticks as the default for code samples.** Use `!raw:lang` instead.

---

## Dynamics Extension

The `!` prefix enables evaluation and control flow. The specific dialect depends on the host environment, with Liquid-style primitives as a common baseline.

### Interpolation

```
|greeting
  Hello, !{user.name}!

|link :href !{base_url}/users/!{user.id}
```

### Filters

```
!{value | filter1 | filter2 arg}

!{name | capitalize}
!{date | format "%Y-%m-%d"}
!{items | first}
!{price | currency "USD"}
```

### Control Flow

```
!if condition
  Content when true
!elif other_condition
  Alternative
!else
  Fallback

!for item in collection
  |card
    :title !{item.name}
    !{item.description}

!let local_var = expression
  Content using local_var

!include partials/header
```

### Key Insight: Indentation Eliminates Closing Tags

```
; UDON — no closing tags needed
!if logged_in
  |greeting Welcome back!
!else
  |greeting Hello, guest!

; vs Liquid — closing tags required
{% if logged_in %}
  <div class="greeting">Welcome back!</div>
{% else %}
  <div class="greeting">Hello, guest!</div>
{% endif %}
```

The scope ends when indentation decreases.

### Host-Specific Dialects

The `!` prefix is intentionally extensible. Hosts may provide:

- **Elixir**: `!{@assigns.user}`, EEx-style
- **Python**: `!{context['user']}`, Jinja-style
- **JavaScript**: `!{props.user}`, JSX-style

The parser preserves `!` expressions for host evaluation.

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

Class usage inherits the mixin's attributes and children.

> **Note:** The precise behavior for inheriting child elements and prose content from mixins is not yet fully defined. Attribute inheritance (with override) is clear; subtree inheritance semantics are still being refined.

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

`@[id]` — Insert the entire element (structure and content):
```
|template[header]
  |nav
    |a :href / Home
    |a :href /about About

|page
  @[header]          ; Inserts the full |nav structure here
  |main ...
```

`:[id]` — Merge only attributes from that element:
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

indent        = { SPACE }* ;

; Elements with optional suffix modifiers
element       = "|" [ name ] [ suffix ] [ id [ suffix ] ] { class }*
                [ SPACE suffix ] { attribute }* { inline_child }* ;
name          = LABEL ;
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
attribute     = ":" LABEL [ value ] ;
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

; Dynamics
dynamic       = "!" ( directive | interpolation ) ;
directive     = LABEL { CHAR }* ;
interpolation = "{" expression [ "|" filter { "|" filter }* ] "}" ;

; Other
comment       = ";" { CHAR }* ;
prose         = { CHAR }+ ;
literal       = "'" CHAR ;
freeform      = "```" { CHAR }* NEWLINE { any_line }* "```" ;

; Terminals
LABEL         = /[a-zA-Z_][a-zA-Z0-9_-]*/ ;
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

UDON uses **syntactic typing** — the syntax determines the type, not value sniffing.

### Type Table

| Syntax | Type | Examples |
|--------|------|----------|
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

Numeric literals follow Ruby conventions: integers, floats, scientific notation (`1e10`), hex (`0x`), octal (`0o`), binary (`0b`), explicit decimal (`0d`), rationals (`1/3r`), and complex (`3+4i`). Underscores allowed for readability (`1_000_000`).

```
42          1_000_000       ; Integers
3.14        1.5e-3          ; Floats
0xFF        0o755   0b1010  ; Hex, octal, binary
1/3r        3+4i            ; Rational, complex
```

**Note:** Plain `0755` is decimal `755` (leading zeros stripped, no implicit octal). Use `0o755` for octal.

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
:value null       ; JSON-familiar
:value nil        ; Ruby/Elixir-familiar
:value ~          ; YAML-familiar
```

All parse to the same nil value.

### Strings

```
:name "quoted string"       ; Explicit string
:name 'single quotes'       ; Also string
:desc unquoted text here    ; String (fallback)
:truthy "true"              ; String "true", not boolean
:number "42"                ; String "42", not integer
```

Quoting forces string type. Useful when you need a literal `true` or `42` as text.

### Lists

```
:ports [8080 8443 9000]              ; List of integers
:tags [api public internal]          ; List of strings
:mixed [1 two 3.0 true]              ; Mixed types
:quoted ["hello world" foo bar]      ; Strings with spaces
:empty []                            ; Empty list
```

Each element typed independently by the same rules.

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
- Consistent indent increment

### Streaming Parse

Support callback/event mode for incremental processing:
- Parse as data arrives (LLM streaming)
- Emit complete subtrees as they close
- Pause/resume with state preservation

---

## Examples

### Configuration

```
|database[primary].postgres
  :host db.example.com
  :port 5432
  :pool 10

  |credentials
    :username !{env.DB_USER}
    :password !{env.DB_PASS}

|cache.redis
  :host cache.example.com
  :ttl 3600
```

### Document

```
|article[intro]
  :author Joseph Wecker
  :date 2025-12-22
  :tags [udon notation design]

  |heading UDON: A Unified Notation

  UDON treats documents and data as the same thing—because they are.
  Structure and prose coexist naturally.

  |section
    :title Why Another Format?

    Existing formats force a choice:

    - **JSON/YAML**: Data-first, prose is awkward
    - **Markdown**: Prose-first, data is awkward
    - **XML**: Verbose, closing tags everywhere

    UDON unifies both with minimal syntax.

  !raw:udon
    |example
      :this works
      And so does this prose.
```

### Template

```
; Page layout with dynamics
!include partials/doctype

|html :lang !{locale}
  |head
    |title !{page.title} — !{site.name}
    !for stylesheet in stylesheets
      |link :rel stylesheet :href !{stylesheet}

  |body
    !include partials/nav

    |main
      !if user
        Welcome back, !{user.name | capitalize}!
      !else
        |a :href /login Please sign in

      !{content}

    !include partials/footer
```

---

## Comparison

| Feature | UDON | JSON | YAML | XML | Markdown |
|---------|------|------|------|-----|----------|
| Comments | `;` | ✗ | `#` | `<!-- -->` | N/A |
| Prose-friendly | ✓ | ✗ | ✗ | ✗ | ✓ |
| Data-friendly | ✓ | ✓ | ✓ | ✓ | ✗ |
| No closing tags | ✓ | N/A | ✓ | ✗ | N/A |
| Streaming parse | ✓ | ✓ | ✓ | ✓ | ✓ |
| Typing | Syntactic | Syntactic | Sniffing ❌ | Strings | N/A |
| Templating | `!` | ✗ | ✗ | ✗ | ✗ |

---

## File Extension

`.udon`

---

## History

- **2011**: Original design by Joseph Wecker
- **2012**: C and Ruby implementations
- **2025**: Revival with modern design decisions

---

*Specification authored December 2025*

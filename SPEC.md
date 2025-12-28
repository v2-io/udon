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

### Bracket Mode Rules

**Once in bracket mode, stay in bracket mode.** Inside `|{...}`, you cannot use inline element syntax (`|element`). All nested elements must also use embedded form:

```
; Correct — nested embedded elements
|ul |{li |{a Home} | }|{li |{a About}}

; INVALID — mixing inline and embedded
|ul |{li |a Home}     ; ✗ can't use |a inside |{...}
```

Embedded elements can span multiple lines—indentation inside is ignored, and the closing `}` ends the element:

```
|p This has |{a :href /docs
   a link that spans
   multiple lines} and continues.
```

### Unified Inline Syntax

All prefix characters support a bracket-delimited inline form:

| Syntax | Description |
|--------|-------------|
| `\|{element ...}` | Embedded element |
| `!{{expr}}` | Interpolation (double-brace) |
| `!{directive ...}` | Inline directive |
| `;{comment}` | Inline comment |
| `'\|{...}` or `\\|{...}` | Escaped (literal text) |

This symmetry enables rich inline content while keeping the parser fast—the character immediately after the prefix determines the parse mode with no lookahead.

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

For inline comments within prose, use `;{...}`:

```
|p This has ;{TODO: fix wording} some text that continues.
```

The inline comment uses brace-counting to find its end—nested `{}` pairs are allowed as long as they're balanced. For comments with unbalanced braces, use line-comment form instead.

**Parser behavior:** Comments are emitted as events, not discarded. The consuming layer decides whether to keep or strip them. This enables use cases like documentation extraction, TODO tracking, or comment-aware transformations.

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

### Inline Raw Content

For inline raw content, use `!{raw:kind ...}`:

```
|p The response was !{raw:json {"status": "ok", "count": 42}} as expected.
```

**Inline raw uses brace-counting.** The parser finds the closing `}` by counting brace depth. Nested `{}` pairs are fine as long as they're balanced:

```
; Works — braces are balanced (even nested)
!{raw:json {"key": "value"}}
!{raw:regex [a-z]{3,5}}

; Fails — unbalanced brace
!{raw:text missing close {}

; Solution — use block form for unbalanced braces
!raw:text
  missing close {here
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

### Inline Forms

All dynamic inline forms use `!{...}` with immediate disambiguation:

| Syntax | Form | Description |
|--------|------|-------------|
| `!{{expr}}` | Interpolation | Double-brace for value interpolation |
| `!{raw:kind ...}` | Raw directive | Content is opaque, brace-counted |
| `!{directive ...}` | Directive | Content is parsed as UDON (can contain `\|{...}`, `;{...}`) |

The second character after `!{` determines the form:
- `{` → interpolation (`!{{...}}`)
- `raw:` prefix → raw directive (brace-counted, no UDON parsing)
- Otherwise → directive with full UDON parsing inside

**Parser implementation note:** The parser uses a `raw` flag to distinguish raw
vs non-raw directives. For `!{raw:json ...}`, the directive name is `json` with
`raw=true`. For `!{include ...}`, the name is `include` with `raw=false`.

Non-raw inline directives support nested UDON:
```
!{include |{em emphasized} content}    ; Nested elements parsed
```

*Note: This may change in future to prefer filter-based includes like
`!{{'file.un' | include}}` instead.*

### Interpolation

Double-brace syntax for interpolating values:

```
|greeting
  Hello, !{{user.name}}!

|link :href !{{base_url}}/users/!{{user.id}}
```

The double-brace `!{{...}}` is familiar to Liquid/Jinja/Handlebars users and provides immediate parser disambiguation—no lookahead required.

**Empty interpolation** (`!{{}}`) is valid—the parser emits an Interpolation
event with empty expression content. The host decides how to handle it.

### Filters

```
!{{value | filter1 | filter2 arg}}

!{{name | capitalize}}
!{{date | format "%Y-%m-%d"}}
!{{items | first}}
!{{price | currency "USD"}}
```

### Interpolation in Typed Contexts

Interpolation can appear in attribute values (including element IDs), where
values normally have specific types (integer, float, string, etc.).

#### Wholly Interpolated Values

When an attribute value is entirely an interpolation, the parser emits it as
an interpolation event. The resulting type is **unparsed**—the host must
evaluate the expression to determine the actual type:

```
|div[!{{dynamic_id}}]           ; ID is unparsed interpolation
|link :href !{{computed_url}}   ; href is unparsed interpolation
```

#### Concatenated Values (Multi-Part)

When interpolation is mixed with literal content, the value becomes a
**multi-part string**. All non-interpolation parts are treated as string
segments, even if they started parsing as numbers:

```
|div[prefix_!{{id}}_suffix]     ; String "prefix_" + interp + string "_suffix"
|link :path !{{base}}/.config   ; Interp + string "/.config"
|item[283!{{more}}]             ; String "283" + interp (not integer!)
```

**Parser implementation note:** Multi-part values emit as a sequence:
`ArrayStart`, then alternating `StringValue`/`Interpolation` events, then
`ArrayEnd`. If parsing began as a numeric type and hits interpolation, emit
accumulated content as `StringValue` instead.

### Expression Grammar

UDON adopts Liquid's intentionally simple expression grammar. This simplicity is a feature—expressions are predictable and portable across host implementations.

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

These constraints are intentional, matching Liquid's design:

- **No parentheses** — Cannot group or override precedence
- **No arithmetic** — Use filters: `!{{a | plus: b}}` not `!{{a + b}}`
- **No ternary operator** — Use `!if`/`!else` blocks
- **No negation operator** — Use `!if value == false` or `!unless`

#### Evaluation Order

Logical operators evaluate **right-to-left** with no precedence between `and`/`or`. This is unusual—most languages give `and` higher precedence than `or`, or use left-to-right associativity. Liquid does neither.

```
!if a or b and c      ; Evaluates as: a or (b and c)
!if a and b or c      ; Evaluates as: a and (b or c)
```

**When this matters:** The difference between right-to-left and standard precedence (`and` > `or`) only affects expressions mixing both operators:

| Expression | Right-to-left (Liquid) | Standard precedence |
|------------|------------------------|---------------------|
| `false and true or true` | `false and (true or true)` → **false** | `(false and true) or true` → true |
| `true and false or true` | `true and (false or true)` → **true** | `(true and false) or true` → true |
| `false or true and false` | `false or (true and false)` → **false** | `false or (true and false)` → false |
| `true or false and false` | `true or (false and false)` → **true** | `true or (false and false)` → true |

The first row is the clearest case: standard precedence would yield `true`, but Liquid yields `false`.

To express `(a or b) and c`, use nested conditionals:

```
!if c
  !if a or b
    Content here
```

#### Truthiness

Only two values are falsy:

| Value | Truthy? |
|-------|---------|
| `false` | No |
| `nil` / `null` | No |
| `""` (empty string) | **Yes** |
| `0` | **Yes** |
| `[]` (empty list) | **Yes** |
| Everything else | **Yes** |

To test for empty values, use explicit comparison:

```
!if title != ""           ; Check non-empty string
!if items != empty        ; Check non-empty collection
!if value != blank        ; Check defined and non-empty
```

The `empty` keyword tests if a defined value is empty. The `blank` keyword tests if a value is undefined OR empty.

### Control Flow

```
!if condition
  Content when true
!elif other_condition
  Alternative
!else
  Fallback

!unless condition        ; Negated conditional (equivalent to !if condition == false)
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
inline directives. The parser does not enumerate specific directive names—any
name is accepted. The only distinction is `raw:` prefix:

- `!raw:lang` — Raw block: content is prose-like (no UDON parsing), collected
  until dedent. The language tag (`lang`) is the directive name with `raw=true`.
- `!if`, `!for`, etc. — Normal block: rest of line is the "statement", then
  normal UDON children content until dedent. Name is `if`/`for` with `raw=false`.

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

The scope ends when indentation decreases—no closing tags needed.

### Inline Control Flow

UDON does not currently support inline forms of control flow directives (`!if`, `!for`, etc.). These remain block-level only, using indentation to delimit scope.

Syntax for inline control flow (e.g., `!if{cond}{then}{else}`) is under investigation but not yet specified. For now, use block form or express simple conditionals via host-specific expression syntax where available.

### Host-Specific Dialects

The `!` prefix is intentionally extensible. Hosts may provide:

- **Elixir**: `!{{@assigns.user}}`, EEx-style
- **Python**: `!{{context['user']}}`, Jinja-style
- **JavaScript**: `!{{props.user}}`, JSX-style

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

Classes also serve as lightweight classification even when no mixin is defined.
In that case, they are equivalent to a classification attribute
(`:'$class' [class1 class2 ...]`) with no inherited traits. A class can be
introduced later as a mixin, at which point existing uses gain the mixin's
attributes and children.

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

; Element recognition: "|" is only an element when followed by one of:
;   - Unicode letter (\p{L}) — named element
;   - "[" — anonymous element with id
;   - "." — anonymous element with class
;   - "{" — embedded element
;   - "'" — quoted element name
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

; Dynamics — all inline forms use !{...}
dynamic           = "!" ( interpolation | inline_dynamic | block_directive ) ;
interpolation     = "{{" expression [ "|" filter { "|" filter }* ] "}}" ;  ; Double-brace
inline_dynamic    = "{" directive_name directive_body "}" ;
block_directive   = directive_name { CHAR }* ;  ; Body determined by indentation
directive_name    = LABEL [ ":" LABEL ] ;  ; Optional namespace (e.g., raw:json)
directive_body    = { CHAR - "{" - "}" | "{" directive_body "}" }* ;  ; Balanced braces

; Comments
comment           = ";" ( inline_comment | line_comment ) ;
line_comment      = { CHAR }* ;
inline_comment    = "{" { CHAR - "{" - "}" | "{" inline_comment "}" }* "}" ;  ; Brace-counted

; Other
prose         = { CHAR }+ ;
literal       = "'" CHAR ;
freeform      = "```" { CHAR }* NEWLINE { any_line }* "```" ;

; Terminals
LABEL         = /[\p{L}_][\p{L}\p{N}_-]*/ ;  ; Unicode letters and numbers
quoted_label  = "'" { CHAR_NOT_QUOTE | "\\'" }* "'" ;  ; Single-quoted with \' escape
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

For additional authoring guidance, see [examples/practices-gotchas.udon](examples/practices-gotchas.udon) (in review).

### Configuration

```
|database[primary].postgres
  :host db.example.com
  :port 5432
  :pool 10

  |credentials
    :username !{{env.DB_USER}}
    :password !{{env.DB_PASS}}

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

|html :lang !{{locale}}
  |head
    |title !{{page.title}} — !{{site.name}}
    !for stylesheet in stylesheets
      |link :rel stylesheet :href !{{stylesheet}}

  |body
    !include partials/nav

    |main
      !if user
        Welcome back, !{{user.name | capitalize}}!
      !else
        |a :href /login Please sign in

      !{{content}}

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

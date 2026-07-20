# UDON Dynamics -- the baseline `!` dialect

**A companion spec to CORE.md.** UDON's core recognizes the `!` *syntax*
(directives, interpolation, raw blocks) and emits Directive / Interpolation /
Raw events -- see CORE "Marker Recognition" and "Code and Raw Content".
What those directives and expressions *mean* is a **host-provided dialect**, not
core UDON. This document specifies the **baseline** dialect: a Liquid-style
expression and control-flow language. A host may provide a different `!`
dialect, and a conformant UDON parser needs none of what follows.

*Extracted verbatim from FULL-SPEC.md on 2026-07-13 (core-minimalism: the `!`
language is a dialect, not core). Original section was "Dynamics Extension".*

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

**Parser implementation note:** *(stale wire sketch — do not implement from
this)* This section's `ArrayStart` + alternating `StringValue`/`Interpolation`
+ `ArrayEnd` encoding predates and **contradicts** CORE 0.9's ratified flat
wire (only literal `[…]` arrays on the wire; all multiplicity = re-emitted
`Attr`). The correct shape is **ruled** (2026-07-19, by CORE's inline-brace
principle): a mixed literal+interpolation value is a **text blob** — re-emitted
`Attr` segments (`Text` / `Interpolation` / `Text` …), whole-value `!{{x}}`
being the one-segment degenerate. See CORE "The Scan and the Bare-Token
Boundary" and the Implementation Notes. Whole-value interpolation is
implemented; the mid-token firing for a glued `pre!{{x}}post` is the remaining
grammar work (`core/TODO-CORE-PARSING.md`, "Interpolation: multi-part values").

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

# UDON Formal Grammar (EBNF)

**Extracted from FULL-SPEC.md**
*Version 0.7-draft -- December 2025*

This is the formal grammar for UDON in EBNF-style notation.

---

## Notes on Context Sensitivity

- Prefix interpretation depends on position (block vs sameline vs embedded).
- Bare-string termination varies by context; see bare_string_* rules and notes.
- INDENT/DEDENT are produced by indentation tracking.
- Freeform fences close on the first ``` at opening indent or less.

---

## Document Structure

```ebnf
document      = { line }* ;

line          = indent ( element
                       | block_attribute
                       | block_dynamic
                       | line_comment
                       | block_escape
                       | freeform
                       | block_prose ) ;

indent        = { SPACE }* ;
```

## Elements

```ebnf
; Element recognition: "|" is only an element when followed by one of:
;   - Unicode letter (\p{L}) -- named element
;   - "[" -- anonymous element with id
;   - "." -- anonymous element with class
;   - "{" -- embedded element
;   - "'" -- quoted element name
; Otherwise "|" is prose (preserves Markdown table compatibility)

; Elements with optional suffix modifiers
element       = "|" [ name ] [ suffix ] [ id [ suffix ] ] { class }*
                [ SPACE suffix ] { sameline_attribute }* { inline_child }* ;
name          = LABEL | quoted_label ;
id            = "[" id_value "]" ;
id_value      = bracket_scalar ;
class         = "." LABEL ;
suffix        = "?" | "!" | "*" | "+" ;

inline_child  = element | embedded_element | inline_dynamic_token | inline_comment | inline_text ;
inline_text   = { inline_char }+ ;
inline_char   = inline_escape | ( CHAR - NEWLINE - "|{" - ";" ) ;
inline_escape = "\\;" | "\\|{" ;
```

## Embedded Elements

```ebnf
; Embedded elements (for inline use in prose)
embedded_element = "|{" [ name ] [ suffix ] [ id [ suffix ] ] { class }*
                   [ SPACE suffix ] { embedded_attribute }* { embedded_content }* "}" ;
embedded_content = embedded_element | inline_dynamic_token | inline_comment | embedded_text ;
embedded_text    = { embedded_char }+ ;
embedded_char    = embedded_escape | ( ANY_CHAR - "|{" - "}" - ";" ) ;
embedded_escape  = "\\;" | "\\|{" ;
```

## Attributes

```ebnf
; Attributes by context
block_attribute    = ":" ( LABEL | quoted_label ) [ block_attr_value ] ;
sameline_attribute = ":" ( LABEL | quoted_label ) [ sameline_attr_value ] ;
embedded_attribute = ":" ( LABEL | quoted_label ) [ embedded_attr_value ] ;

block_attr_value    = block_scalar | block_value ;
sameline_attr_value = sameline_scalar ;
embedded_attr_value = embedded_scalar ;

block_scalar    = nil_value | bool_value | complex | rational | number
                | list_value | string_value_block
                | interpolation_token | interpolated_string_block ;

sameline_scalar = nil_value | bool_value | complex | rational | number
                | list_value | string_value_sameline
                | interpolation_token | interpolated_string_sameline ;

embedded_scalar = nil_value | bool_value | complex | rational | number
                | list_value | string_value_embedded
                | interpolation_token | interpolated_string_embedded ;

bracket_scalar  = nil_value | bool_value | complex | rational | number
                | list_value | string_value_bracket
                | interpolation_token | interpolated_string_bracket ;
```

## Numbers

```ebnf
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
```

## Collections

```ebnf
; Collections
list_value    = "[" { list_item }* "]" ;
list_item     = array_scalar ;

array_scalar  = nil_value | bool_value | complex | rational | number
              | list_value | string_value_array
              | interpolation_token | interpolated_string_array ;
```

## Strings

```ebnf
; Strings
string_value_block    = quoted_string | bare_string_block ;
string_value_sameline = quoted_string | bare_string_sameline ;
string_value_embedded = quoted_string | bare_string_embedded ;
string_value_array    = quoted_string | bare_string_array ;
string_value_bracket  = quoted_string | bare_string_bracket ;

; NOTE: Block bare strings terminate at NEWLINE or " ;" (space + semicolon).
; Sameline/embedded terminate at SPACE; embedded and array also terminate at
; "}" and "]" respectively. Closing tokens are not consumed.

bare_string_block    = { CHAR - NEWLINE }+ ;
bare_string_sameline = { CHAR - NEWLINE - SPACE }+ ;
bare_string_embedded = { CHAR - NEWLINE - SPACE - "}" }+ ;
bare_string_array    = { CHAR - NEWLINE - SPACE - "]" }+ ;
bare_string_bracket  = { CHAR - NEWLINE - SPACE - "]" }+ ;

interpolated_string_block    = [ bare_string_part_block ] interpolation_token
                               { bare_string_part_block interpolation_token }*
                               [ bare_string_part_block ] ;
interpolated_string_sameline = [ bare_string_part_sameline ] interpolation_token
                               { bare_string_part_sameline interpolation_token }*
                               [ bare_string_part_sameline ] ;
interpolated_string_embedded = [ bare_string_part_embedded ] interpolation_token
                               { bare_string_part_embedded interpolation_token }*
                               [ bare_string_part_embedded ] ;
interpolated_string_array    = [ bare_string_part_array ] interpolation_token
                               { bare_string_part_array interpolation_token }*
                               [ bare_string_part_array ] ;
interpolated_string_bracket  = [ bare_string_part_bracket ] interpolation_token
                               { bare_string_part_bracket interpolation_token }*
                               [ bare_string_part_bracket ] ;

bare_string_part_block    = { CHAR - NEWLINE }* ;
bare_string_part_sameline = { CHAR - NEWLINE - SPACE }* ;
bare_string_part_embedded = { CHAR - NEWLINE - SPACE - "}" }* ;
bare_string_part_array    = { CHAR - NEWLINE - SPACE - "]" }* ;
bare_string_part_bracket  = { CHAR - NEWLINE - SPACE - "]" }* ;

quoted_string = '"' { CHAR_NOT_DQUOTE }* '"'
              | "'" { CHAR_NOT_SQUOTE }* "'" ;

block_value   = NEWLINE INDENT { line }+ DEDENT ;
```

## Dynamics

```ebnf
; Dynamics
block_dynamic      = "!" ( interpolation | inline_dynamic | block_directive ) ;
block_directive    = raw_block_directive | normal_block_directive ;
normal_block_directive = directive_name { CHAR }* ;  ; Body determined by indentation
raw_block_directive    = ":" directive_name ":" ;

inline_dynamic_token = "!" ( interpolation | inline_dynamic ) ;
inline_dynamic       = "{" ( inline_raw | inline_directive ) "}" ;
inline_raw           = ":" directive_name ":" raw_body ;
inline_directive     = directive_name directive_body ;

interpolation_token = "!" interpolation ;
interpolation     = "{{" expression [ "|" filter { "|" filter }* ] "}}" ;
directive_name    = LABEL [ ":" LABEL ] ;
directive_body    = { ANY_CHAR - "{" - "}" | "{" directive_body "}" }* ;
raw_body          = { ANY_CHAR - "{" - "}" | "{" raw_body "}" }* ;
```

## Comments

```ebnf
; Comments
line_comment     = ";" { CHAR }* ;
inline_comment   = ";{" inline_comment_body "}" ;
inline_comment_body = { ANY_CHAR - "{" - "}" | "{" inline_comment_body "}" }* ;
; NOTE: A line comment may be followed by indented continuation lines, which
; are treated as comment content until dedent.
```

## Other

```ebnf
; Other
block_prose   = { prose_segment }+ ;
prose_segment = embedded_element | inline_dynamic_token | inline_comment | prose_text ;
prose_text    = { prose_char }+ ;
prose_char    = CHAR ;

; Block-level escapes (line start only): escape one marker character
block_escape  = block_escape_prefix block_marker { CHAR }* ;
block_escape_prefix = "'" | "\\" ;
block_marker  = "|" | ";" | ":" | "!" | "'" ;

; Freeform: opening fence may appear after other content on the same line
freeform      = [ freeform_prefix ] "```" { CHAR }* NEWLINE { any_line }* "```" ;
freeform_prefix = { CHAR - NEWLINE }* ;  ; parsed as normal content before the fence
any_line      = { CHAR }* NEWLINE ;
```

## Terminals

```ebnf
; Terminals
LABEL          = /[\p{L}][\p{L}\p{N}_-]*/ ;
quoted_label   = "'" { CHAR_NOT_SQUOTE }* "'" ;
CHAR_NOT_SQUOTE = CHAR - "'" - "\\" | "\\" ANY_CHAR ;
CHAR_NOT_DQUOTE = CHAR - '"' - "\\" | "\\" ANY_CHAR ;
DIGIT          = /[0-9]/ ;
HEX            = /[0-9a-fA-F]/ ;
OCT            = /[0-7]/ ;
BIN            = /[01]/ ;
SPACE          = " " ;
NEWLINE        = "\n" | "\r\n" ;
CHAR           = any character except NEWLINE ;
ANY_CHAR       = any character ;
```

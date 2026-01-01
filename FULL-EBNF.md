# UDON Formal Grammar (EBNF)

**Extracted from FULL-SPEC.md**
*Version 0.7-draft -- December 2025*

This is the formal grammar for UDON in EBNF-style notation.

---

## Known Inconsistencies with FULL-SPEC.md

| # | Issue | Severity | Details |
|---|-------|----------|---------|
| 1 | `literal = "'" CHAR` too broad | High | Should only escape markers (`\|;:!'`), not any char. `'hello` should output `'hello`. |
| 3 | Raw directive `:label:` syntax not captured | High | EBNF shows `LABEL [ ":" LABEL ]` but raw is `!:lang:` with colons on both sides. |
| 4 | Backslash escapes missing | High | `\;` for sameline/embedded, `\` as alternate block escape--not in grammar at all. |
| 5 | `any_line` undefined | Medium | Used in `freeform` production but never defined. |
| 10 | Interpolation in values not shown | Medium | `!{{expr}}` appears in attr values per prose, but EBNF only shows at line level. |
| 11 | Quoted string escapes unspecified | Medium | How to include `"` in `"..."` or `'` in `'...'`? Not defined. |
| 2 | Underscore in element names | Low | EBNF LABEL allows `_` at start; prose says "a letter". |
| 6 | Freeform mid-line start | Low | Prose allows ``` after content; EBNF implies line-start only. |
| 7 | Embedded element suffixes omitted | Low | `|{name?...}` not in grammar--intentional? |
| 8 | Comment production ordering | Low | `";" ( inline_comment \| line_comment )` suggests free choice; context determines which. |
| 9 | Prose context sensitivity | Low | Block vs sameline prose have different `;` rules; EBNF just says `{ CHAR }+`. |

---

## Document Structure

```ebnf
document      = { line }* ;

line          = indent ( element | attribute | dynamic | comment | prose ) ;

; NOTE: Comment and bare-string termination are context-sensitive
; (block vs sameline vs embedded).

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
                [ SPACE suffix ] { attribute }* { inline_child }* ;
name          = LABEL | quoted_label ;
id            = "[" id_value "]" ;
id_value      = typed_value | bare_string ;  ; Same as attribute values
class         = "." LABEL ;
suffix        = "?" | "!" | "*" | "+" ;
inline_child  = element | embedded_element | inline_text ;
inline_text   = { CHAR - NEWLINE - "|{" }+ ;
```

## Embedded Elements

```ebnf
; Embedded elements (for inline use in prose)
embedded_element = "|{" [ name ] [ id ] { class }* { attribute }*
                   { embedded_content }* "}" ;
embedded_content = embedded_element | { CHAR - "|{" - "}" }+ ;
```

## Attributes

```ebnf
; Attributes with typed values
attribute     = ":" ( LABEL | quoted_label ) [ value ] ;
value         = typed_value | block_value ;
typed_value   = nil_value | bool_value | complex | rational | number
              | list_value | string_value ;
nil_value     = "null" | "nil" | "~" ;
bool_value    = "true" | "false" ;
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
list_item     = typed_value ;
```

## Strings

```ebnf
; Strings
string_value  = quoted_string | bare_string ;
quoted_string = '"' { CHAR }* '"' | "'" { CHAR }* "'" ;
bare_string   = { CHAR - (SPACE ":") - (SPACE "|") - NEWLINE }+ ;
block_value   = NEWLINE INDENT { line }+ DEDENT ;
```

## Dynamics

```ebnf
; Dynamics -- all inline forms use !{...}
dynamic           = "!" ( interpolation | inline_dynamic | block_directive ) ;
interpolation     = "{{" expression [ "|" filter { "|" filter }* ] "}}" ;
inline_dynamic    = "{" directive_name directive_body "}" ;
block_directive   = directive_name { CHAR }* ;  ; Body determined by indentation
directive_name    = LABEL [ ":" LABEL ] ;
directive_body    = { CHAR - "{" - "}" | "{" directive_body "}" }* ;
```

## Comments

```ebnf
; Comments
comment           = ";" ( inline_comment | line_comment ) ;
line_comment      = { CHAR }* ;
inline_comment    = "{" { CHAR - "{" - "}" | "{" inline_comment "}" }* "}" ;
; NOTE: A line comment may be followed by indented continuation lines, which
; are treated as comment content until dedent.
```

## Other

```ebnf
; Other
prose         = { CHAR }+ ;
literal       = "'" CHAR ;
freeform      = "```" { CHAR }* NEWLINE { any_line }* "```" ;
```

## Terminals

```ebnf
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

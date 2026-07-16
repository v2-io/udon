# UDON Formal Grammar (EBNF)

> **⚠️ Demoted reference — derived, perpetually lagging, illustration only**
> (ruled by Joseph 2026-07-16, closing the standing adjudication item; moved
> to `spec/msc/` the same week). `spec/CORE.md` is UDON's **sole**
> authoritative definition — not this file, and not the descent grammar or
> generated parser either. This EBNF is a *reading aid* that is regenerated
> on demand and lags CORE between regenerations (it currently reflects
> **0.8.0-alpha.1**; CORE has since moved through 0.8.0 to 0.9.0-alpha.1 —
> the whole attribute model below is stale). **Never cite it as
> corroborating or settling what CORE says** — that misuse is why it was
> demoted.

This is an EBNF-style formal grammar for UDON, derived from `CORE.md` as of
the date above. It is a *reading aid*, not a parseable grammar: UDON is
indentation-sensitive and operates in position-dependent modes (head
position, sameline scan, block, embedded), and a context-free EBNF cannot
capture those modes. Every place the grammar cannot pin down the real rule is
flagged with a `(* NOTE: ... *)` comment. Those notes are the load-bearing
part — they mark exactly where the grammar is an approximation.

**This grammar is illustration only — it cannot produce a parser.** The
reference implementation is generated from the indentation-sensitive,
mode-based state machine in `core/generator/*.descent.udon` (itself
subordinate to CORE). Two rules below were
*precisely* defined in that descent grammar and only approximated here; both have
now been back-filled from it (§5 numbers, §5.1 names/traits), with the
remaining known parser-vs-spec gaps flagged inline:

- Bare-name / bare-trait character class: back-filled to the Unicode
  identifier set (`XID_Start` / `XID_Continue` + `-`) that
  `core/generator/udon.desc` (`parse_element_identity` / `name` / `class_name`)
  and `tools/descent/characters.md` define. See §5.1.
- Numeric-literal grammar: back-filled from `core/generator/values.desc`
  (`num_dec` / `num_hex` / `num_oct` / `num_bin` / `num_float_*` /
  `num_rational_denom` / `num_complex_*`). See the number productions.

---

## 0. Reading Guide — What EBNF Cannot Express Here

UDON's parser is a bounded-lookahead state machine (CORE "Bounded
Lookahead"). Three cross-cutting behaviors sit *outside* the grammar and govern
almost every production below:

```ebnf
(* NOTE: HEAD POSITION is a parser state, not a grammar nonterminal. It is
   re-entered at the start of every line (at a structural column) and runs
   along an element line through elements AND attributes ("sameline scan").
   Markers |  :  !  ;  @  and triple-backtick are recognized ONLY in head
   position, each by a short GUARD (a few chars of lookahead). The instant a
   guard fails -- typically when the first prose word arrives -- the line
   COMMITS TO PROSE for the rest of that line, and those same characters become
   literal text. No context-free production can express "recognized only until
   the first prose word." Wherever a rule below shows a marker, read it as
   "recognized in head position, subject to its guard." *)

(* NOTE: INDENTATION / COLUMNS drive all parent-child nesting via the
   authoritative rule "pop while new_column <= stack_top.base_column"
   (CORE "Hierarchy"). Inline elements on one line (|a |b |c) nest exactly
   as if written on separate lines at their | columns. This grammar shows
   nesting structurally but cannot enforce the column arithmetic; there are no
   real INDENT/DEDENT tokens in the byte stream -- they are computed from
   leading-space counts. Treat INDENT/DEDENT below as pseudo-terminals emitted
   by the indentation tracker. *)

(* NOTE: PROSE DEDENTATION (content_base_column, warnings on inconsistent
   indent) is a per-line output transformation (CORE "Automatic Prose
   Dedentation"), not a syntactic rule. It affects emitted Text content, not
   the grammar. Omitted from the productions; see the spec section. *)
```

---

## 1. Document

```ebnf
document      = { line } ;

(* A "line" is dispatched by what appears at head position after indentation.
   Which alternative fires is decided by the marker guards, not by unbounded
   lookahead. *)
line          = indent line_body NEWLINE ;

line_body     = element_line
              | block_attribute      (* only while element has no children yet *)
              | block_directive
              | interpolation        (* !{{...}} / !{...} may also open a line *)
              | line_comment
              | freeform_open
              | block_escape
              | block_prose
              | blank ;

indent        = { SPACE } ;   (* spaces only; tabs are an error -- CORE "Strict Whitespace" *)
blank         = ;             (* empty line -> BlankLine event *)

(* NOTE: The dispatch above is guard-driven and phase-sensitive, not a clean
   disjunction. A ":" is a block_attribute ONLY before any child/text has
   appeared under the element (see block_attribute); afterward a line-initial
   ":" is prose. A "|", "!", "@", ";", or triple-backtick that FAILS its guard
   falls through to block_prose. EBNF alternation cannot encode this ordering
   or the "attributes before children" phase gate. *)
```

---

## 2. Head-Position Markers and Their Guards

```ebnf
(* Recognized only at head position (line start at a structural column, or in
   sameline scan before prose begins). Each has a guard; guard failure => prose
   for the rest of the line. CORE "Marker Recognition". *)

(* "|" element -- guard: next char is a letter, "[", ".", "{", or "'".
   Any other following char => "|" is literal prose (Markdown-table safety). *)
element_marker_guard   = "|" ( LETTER | "[" | "." | "{" | "'" ) ;

(* ":" attribute -- NOT char-guarded but PHASE-restricted: ":" is an attribute
   only while the element has no child content yet; once text/child appears a
   line-initial ":" is prose. A ":" not followed by a name is also prose. *)
attribute_marker_guard = ":" name_start ;

(* "!" directive -- guard: next char is an identifier char or ":".
   So "![", "!=", "!(" are prose. *)
directive_marker_guard = "!" ( ident_char | ":" ) ;

(* "@" reference -- guard: next char is "[" or an identifier char. *)
reference_marker_guard = "@" ( "[" | ident_char ) ;

(* ";" comment -- recognized per the Comments table: line comment at document
   root / sameline / after attribute values; LITERAL in block prose. *)
comment_marker_guard   = ";" ;

(* triple-backtick freeform -- opens at any head position (line start, or
   sameline scan after elements AND attributes), NOT once prose has begun. *)
freeform_marker_guard  = "```" ;

(* NOTE: These "guard" productions describe LOOKAHEAD PREDICATES, not consumed
   input. They are written as if the guard char is part of the token, but the
   guard is really a test that decides whether the marker is structure or
   prose. The phase restriction on ":" and the "before prose begins" condition
   on all sameline markers are pure parser state, invisible to EBNF. *)
```

---

## 3. Elements

```ebnf
(* An element is: name(opt) + identity/trait/suffix sugar + attributes +
   children. Identity, traits, and suffixes are SUGAR desugaring to
   $-designated attributes ($key, $traits, $?, $!, $*, $+) -- CORE
   "Identity and Classification". The grammar shows surface syntax only. *)

element_line  = "|" element_head { SPACE sameline_attribute }
                                  [ sameline_tail ] ;

(* element_head is the run of name / key / traits / suffixes with NO spaces
   between them (except the space-separated trailing suffix form). *)
element_head  = ( name element_sugar
                | element_sugar_required ) ;

name          = bare_name | quoted_name ;

(* Anonymous element: no name -- "|" is followed directly by key, trait, or
   suffix. CORE "Anonymous Elements". element_sugar_required = at least
   one of key/trait/suffix must be present when the name is absent. *)
element_sugar_required = key trait_suffix_tail
                       | trait trait_suffix_tail
                       | suffix { suffix } ;

element_sugar = [ suffix { suffix } ] [ key ] { trait }
                [ SPACE suffix { suffix } ] ;

trait_suffix_tail = { trait } [ SPACE suffix { suffix } ] ;

key           = "[" attr_value_bracket "]" ;   (* identity: $key *)
trait         = "." trait_value ;                (* classification: $traits, stacks *)
suffix        = "?" | "!" | "*" | "+" ;          (* $? $! $* $+ = true *)

(* NOTE: SUFFIX POSITIONING is ambiguous in EBNF. A suffix binds to the element
   identity and may appear after the name, after the key, or space-separated at
   the very end (CORE "Suffix positions"). Crucially, "* ! ? +" are LEGAL
   BARE TRAIT CHARACTERS, so ".foo?" is the trait "foo?" (no suffix), while
   ".foo ?" (space) is trait "foo" plus a $? suffix. The grammar above lists
   the positions but cannot mechanically resolve "does this trailing ? belong
   to the trait or to the element" without the maximal-munch rule "a suffix
   char touching a .trait is consumed by the trait." Read trait_value as
   greedy over ?!*+. *)

(* NOTE: The value inside "[...]" follows normal attribute-value rules -- every
   scalar type is available ([1] = int 1, ["01"] = string "01", [abc-123] =
   string). It is NOT a restricted identifier. See attr_value_bracket. *)

(* NOTE: WHERE ATTRIBUTES END AND CHILDREN BEGIN is the "attributes before
   children" phase gate (CORE "Design Principles"), enforced by parser
   state, not grammar. Sameline attributes must precede sameline prose/inline
   children; block attributes must precede any child element or prose line. *)
```

### 3.1 Sameline tail (prose + inline children on the element line)

```ebnf
(* After the element head and its sameline attributes, the rest of the line is
   sameline content: prose words and inline (embedded) children, interleaved.
   The FIRST prose word ends the sameline scan (head position). Inline elements
   here use the |{...} embedded form OR bare |name inline nesting. *)
sameline_tail = { sameline_token } [ SPACE line_comment ] ;

sameline_token = embedded_element
               | inline_element          (* |name ... continues nesting *)
               | interpolation
               | inline_comment          (* ;{...} *)
               | inline_raw              (* !{:kind: ...} *)
               | sameline_prose_word ;

(* NOTE: "|name" appearing later on a line is an INLINE ELEMENT that nests by
   column (|a |b |c). But once the first PROSE word has been emitted, a later
   "|" is literal (head position has ended for the line). The grammar shows
   inline_element as freely interleavable; the real constraint is "only while
   still in sameline scan / head position." Inline nesting columns are computed
   from the | positions -- see the INDENTATION note. *)

inline_element = "|" element_head { SPACE sameline_attribute } ;
```

---

## 4. Attributes

```ebnf
(* Key-value pairs. Same-key values STACK (accumulate as an ordered list, in
   source order) -- last-wins is NOT how UDON behaves (CORE "Attribute
   Stacking"). A value-less attribute is boolean true. *)

block_attribute    = ":" attr_name [ SPACE block_attr_value ]
                                    [ SPACE line_comment ] ;
sameline_attribute = ":" attr_name [ SPACE sameline_attr_value ] ;
embedded_attribute = ":" attr_name [ SPACE embedded_attr_value ] ;

attr_name          = bare_name | quoted_name ;
(* $-designated names ($key etc.) are ordinary names but need quoting because
   "$" is not a bare-name char: :'$key' value. CORE "Specially-designated,
   not reserved." *)

(* NOTE: BLOCK vs SAMELINE is a positional distinction (own indented line vs
   on the element line), decided by the parser's context -- not derivable from
   the ":" token alone. The three attribute productions differ ONLY in how
   their bare value terminates (below); the grammar cannot say which one
   applies without knowing the position. *)

(* NOTE: A value-less attribute (":disabled") emits BoolTrue. "No value" means
   the ":" name is immediately followed by a context terminator (newline, next
   ":", "}", "]", or -- sameline -- a space then next marker). Expressing
   "followed immediately by a terminator" requires negative lookahead not
   available in plain EBNF. *)
```

### 4.1 Attribute value terminators (context-dependent)

```ebnf
(* The SAME bare value grammar terminates differently by context -- CORE
   "Value Terminator Rules" / "Bare String Terminators". Terminators are NOT
   consumed. *)

block_attr_value    = typed_value | scalar_value_block ;
sameline_attr_value = typed_value | scalar_value_sameline ;
embedded_attr_value = typed_value | scalar_value_embedded ;
attr_value_bracket  = typed_value | scalar_value_bracket ;   (* inside |name[...] *)

(* Bare (unquoted) string terminators by context:
     block     : NEWLINE or " ;"  (space+semicolon); bare spaces allowed IN value
     sameline  : NEWLINE or SPACE
     embedded  : NEWLINE, SPACE, or "}"   ("}" not consumed)
     array item: NEWLINE, SPACE, or "]"   ("]" not consumed; "}" is LITERAL) *)

(* NOTE: BLOCK VALUE RUNS TO END OF LINE. Therefore a block line holds ONE
   attribute: ":a 2 :b 3" makes :a = the string "2 :b 3", NOT two attributes
   (CORE). A stranded " :name " inside a block value emits a WARNING but is
   still taken to end-of-line. EBNF cannot express "greedy to newline except a
   space-semicolon starts a comment." *)

(* NOTE: The "space + semicolon" block terminator (" ;") means a ";" WITHOUT a
   preceding space is part of the value (":url http://x/a?q=1;s=2"). This
   two-character lookahead terminator is not naturally expressible; scalar_value_block
   below is an approximation. *)
```

### 4.2 Complex (structured) attribute values

```ebnf
(* An attribute followed by newline + deeper indent takes a STRUCTURED value:
   child elements / prose become the value. CORE "Complex Attribute
   Values". *)
block_attribute_structured = ":" attr_name NEWLINE INDENT { line } DEDENT ;

(* NOTE: Whether ":headers" is a bare value or a structured value depends
   entirely on whether the NEXT line is indented deeper -- a purely
   indentation-driven decision the grammar cannot make locally. *)
```

### 4.3 Inline lists

```ebnf
(* Square-bracket list values. Space-delimited; quote items with spaces. *)
inline_list   = "[" { SPACE } { list_item { SPACE } } "]" ;
list_item     = typed_value | scalar_value_array ;

(* NOTE: QUOTED-ITEM NUANCE (CORE): a quoted string's closing quote ENDS
   its item, so a char immediately after it (no space) begins the NEXT item.
   ["x"y] and ["x""y"] each yield two items, same as ["x" y]. This "quote-ends-
   item" behavior means whitespace is not the only item separator; it is a
   consequence of the terminator rules that EBNF sequencing does not show. *)

(* NOTE: "}" is NOT a list terminator: inside [...] a "}" is literal; the list
   closes only on "]" (missing "]" => UnclosedArray error). A "}" meant to
   close an embedded |{...} must come AFTER the array's "]". *)
```

---

## 5. Value Types

```ebnf
(* BARE recognition is the FROZEN CORE SCALAR SET -- recognized from syntax
   alone (CORE "Value Types"). This set is closed; nothing is added to
   bare recognition. Everything else goes through the <...> envelope (section
   5.2). "Anything else" bare = string. *)

scalar_value_block    = nil | boolean | complex | rational | number
                      | inline_list | reference | string_bare_block | quoted_string ;
scalar_value_sameline = nil | boolean | complex | rational | number
                      | inline_list | reference | string_bare_sameline | quoted_string ;
scalar_value_embedded = nil | boolean | complex | rational | number
                      | inline_list | reference | string_bare_embedded | quoted_string ;
scalar_value_array    = nil | boolean | complex | rational | number
                      | inline_list | reference | string_bare_array | quoted_string ;
scalar_value_bracket  = nil | boolean | complex | rational | number
                      | inline_list | reference | string_bare_bracket | quoted_string ;

(* NOTE: TYPE DISPATCH IS SYNTACTIC AND ORDERED-BY-SPECIFICITY, not a free
   disjunction. "42" is Integer, "true" is Boolean, but "TRUE"/"True"/"42x" are
   Strings. The alternatives above must be tried most-specific-first with the
   bare-string fallback LAST; EBNF "|" does not imply that precedence. *)

(* --- frozen core scalars --- *)

nil           = "null" | "nil" ;
boolean       = "true" | "false" ;   (* lowercase only; TRUE/True are strings *)

number        = float | integer ;
integer       = [ sign ] ( hex_int | oct_int | bin_int | plain_int ) ;
sign          = "+" | "-" ;
plain_int     = DIGIT { DIGIT | "_" } ;   (* leading zeros stay decimal: 0755 = 755 *)
hex_int       = ( "0x" | "0X" ) HEX { HEX | "_" } ;
oct_int       = ( "0o" | "0O" ) OCT { OCT | "_" } ;
bin_int       = ( "0b" | "0B" ) BIN { BIN | "_" } ;
float         = [ sign ] DIGIT { DIGIT | "_" } "." DIGIT { DIGIT | "_" } [ exponent ]
              | [ sign ] DIGIT { DIGIT | "_" } exponent ;
exponent      = ( "e" | "E" ) [ sign ] DIGIT { DIGIT | "_" } ;
rational      = [ sign ] DIGIT { DIGIT | "_" } "/" DIGIT { DIGIT | "_" } "r" ;
complex       = [ real_part sign ] unsigned_number "i" ;
real_part     = unsigned_number ;

(* NOTE: Back-filled from core/generator/values.desc (num_dec / num_hex /
   num_oct / num_bin / num_float_frac / num_float_exp / num_rational_denom /
   num_complex_*). "_" may appear between digits of any base. A "0" followed by
   a decimal digit stays decimal (num_zero -> num_dec), so 0755 = 755; octal
   needs the 0o prefix. The "r" on a rational and the "i" on a complex are
   MANDATORY -- drop either and the token falls back to String.
   TWO PARSER-VS-SPEC GAPS: (1) explicit-decimal "0d" is in CORE's intent
   but num_zero has no "d" branch, so bare 0d... currently parses as String
   (Tier-2 catch-up). (2) For an UNSIGNED real, the grammar forms a complex only
   with "+" (3+4i); a bare "3-4i" is diverted into the date probe and falls back
   to String -- only a SIGNED real (via rel_num_dec) accepts a "-" imaginary
   sign. The [ real_part sign ] above is thus an approximation of that quirk. *)

(* --- strings --- *)

quoted_string = '"' { dq_char } '"'
              | "'" { sq_char } "'" ;
dq_char       = escaped_char | ( CHAR - '"' ) ;
sq_char       = escaped_char | ( CHAR - "'" ) ;
escaped_char  = "\" ANY_CHAR ;
(* Inside quoted strings, escape prefixes have no special meaning beyond the
   delimiter's own escaping -- CORE "Note" under Sameline/Embedded Escape. *)

string_bare_block    = { CHAR - NEWLINE }        (* stops at " ;" -- see 4.1 note *) ;
string_bare_sameline = { CHAR - NEWLINE - SPACE } ;
string_bare_embedded = { CHAR - NEWLINE - SPACE - "}" } ;
string_bare_array    = { CHAR - NEWLINE - SPACE - "]" } ;
string_bare_bracket  = { CHAR - NEWLINE - SPACE - "]" } ;
```

### 5.1 Names / keys / traits

```ebnf
bare_name     = name_start { name_char } ;
name_start    = XID_START ;                       (* Unicode XID_Start; no digit / "_" / "-" *)
name_char     = XID_CONT | "-" ;                  (* XID_Continue plus hyphen (kebab-case) *)
ident_char    = XID_CONT | "-" ;
quoted_name   = "'" { sq_char } "'" | '"' { dq_char } '"' ;

trait_value   = bare_trait | quoted_name ;
bare_trait    = trait_start { trait_char } ;
trait_start   = XID_START ;
trait_char    = XID_CONT | "-" | "*" | "!" | "?" | "+" ;   (* absorbs the suffix chars *)

(* NOTE: BARE-NAME / BARE-TRAIT classes back-filled from
   core/generator/udon.desc: name-start = XLBL_START = Unicode XID_Start;
   name-continue = XLBL_CONT = XID_Continue + "-" (functions `name`,
   `class_name`). "$" is NOT an XID char, so $-designated names need quotes.
   PARSER-VS-SPEC GAP: the trait's extra "* ! ? +" chars (CORE "Element
   Suffixes": ".foo?" is trait "foo?") are SPEC INTENT only -- the reference
   `class_name` accepts XLBL_CONT alone, so today ".foo?" parses as trait "foo"
   plus a $? element suffix. Tier-2 parser catch-up; trait_char shows intent. *)
```

### 5.2 Explicit typing envelope `<...>`

```ebnf
(* Every NON-core (dialect) type is written inside a <...> envelope in
   attribute-value position, where ">" terminates the value. CORE
   "Explicit Typing". *)
typed_value   = "<" envelope_body ">" ;

envelope_body = unlabelled_body
              | type_label ":" unlabelled_body
              | dialect_label ":" type_label ":" unlabelled_body ;

unlabelled_body = { CHAR - ">" } ;   (* ">" ends the value *)
type_label      = ident_char { ident_char } ;
dialect_label   = ident_char { ident_char } ;

(* NOTE: LABEL LADDER -- <...> unlabelled | <type:...> | <dialect:type:...>,
   least to most specific. But the label vs body boundary is a DIALECT concern:
   the core only guarantees "<" opens, ">" closes, and the value's INTERNAL
   ":" structure is passed through. "envelope_body" cannot be disambiguated by
   the core grammar because durations like <5m> and <2026-07-11> have no colons
   yet are unlabelled, while <temporal:interval:...> has meaningful colons. The
   split shown is illustrative; the core does not parse inside the envelope. *)

(* NOTE: UNLABELLED DISPATCH -- an unlabelled <content> is offered to declared
   dialects in declared order; first to claim wins; all-decline is an error.
   This is a HOST/runtime resolution, entirely outside the grammar. The core
   recognizes only the envelope SYNTAX. *)

(* NOTE: Does "<" open an envelope ONLY in attribute-value position? CORE
   says the envelope lives "in attribute-value position." A bare "<" in prose
   or a value-less context is presumably literal; the spec does not give an
   explicit guard for "<" the way it does for | : ! @ ;. Flagged as
   spec-underspecified. *)
```

---

## 6. References

```ebnf
(* "@" refers to a defined element by identity. INERT at core level: the parser
   emits a reference and does not resolve it. CORE "References". *)
reference     = "@" [ ref_element_name ] key ;   (* @[key] or @element[key] *)
ref_element_name = bare_name | quoted_name ;

(* NOTE: "@[key]" is shorthand that ERRORS if the key is ambiguous across
   element types; "@element[key]" is explicit. That error is a resolution-time
   (host) concern, not a parse rule. A reference is NOT augmentable -- there is
   no "@[mit].trait"; the grammar reflects this by not allowing a trait tail. *)

(* NOTE: "@" is a head-position marker (guard: followed by "[" or ident) AND
   appears in attribute-value position (":license @[mit]"). The grammar lists
   reference under both scalar_value_* and as a line-level marker; the spec
   shows it primarily as a value. Its full set of legal positions is only
   partially pinned down. *)
```

---

## 7. Embedded / Inline Elements `|{...}`

```ebnf
(* Inline elements in prose. "|{" opens; content terminates at brace-balanced
   "}". Once in bracket mode, STAY in bracket mode -- nested elements must also
   use |{...}, never bare |name. CORE "Inline and Embedded Elements". *)
embedded_element = "|{" element_head { SPACE embedded_attribute }
                        { embedded_content } "}" ;

embedded_content = embedded_element
                 | interpolation
                 | inline_comment          (* ;{...} *)
                 | inline_raw              (* !{:kind: ...} *)
                 | embedded_text ;
embedded_text    = { embedded_char } ;
embedded_char    = "\;" | "\|{" | ( ANY_CHAR - "}" - "|{" - ";" ) ;

(* NOTE: Embedded content terminates at the BRACE-BALANCED "}". Nested "|{...}"
   pairs count toward balance. EBNF recursion shows the nesting but the real
   parser uses brace-counting; multi-line embedded content is allowed and
   INTERNAL INDENTATION IS IGNORED (CORE), which the grammar cannot show. *)

(* NOTE: "Once in bracket mode, stay in bracket mode" -- a bare "|name" inside
   |{...} is INVALID. The grammar enforces this by only offering
   embedded_element (not inline_element) inside embedded_content, but the spec
   states it as a mode rule; there is no separate token that distinguishes the
   two forms other than the "{". *)
```

---

## 8. Dynamics `!` — Directives, Interpolation, Raw

```ebnf
(* The "!" prefix marks DYNAMICS. The core recognizes SYNTAX and emits events;
   the LANGUAGE inside (expressions, !if/!for/!let, filters, truthiness) is a
   host DIALECT (DYNAMICS.md), NOT core. CORE "Dynamics". *)

(* --- block directive (head position) --- *)
block_directive = raw_block_directive | named_block_directive ;

named_block_directive = "!" directive_name { SPACE CHAR } ;  (* body parsed as UDON, by indent *)
directive_name  = ident_char { ident_char } ;

(* --- raw block: body captured verbatim, NOT parsed as UDON --- *)
raw_block_directive = "!:" lang_label ":" ;   (* body is indented lines, verbatim *)
lang_label      = { CHAR - ":" - NEWLINE } ;

(* NOTE: RAW BLOCK BODY (!:lang:) is everything indented under the directive,
   captured verbatim with no |:!; interpretation and dedented relative to the
   directive. The body extent is INDENTATION-DELIMITED, not bracket- or
   token-delimited -- unexpressible in EBNF. *)

(* --- interpolation: expression unparsed, host evaluates --- *)
interpolation   = "!{{" expr_text "}}" ;
expr_text       = { balanced_brace_text } ;

(* --- inline directive: UDON-parsed body --- *)
inline_directive = "!{" directive_name { SPACE } inline_dir_body "}" ;
inline_dir_body  = { balanced_brace_text } ;

(* --- inline raw: verbatim, brace-counted --- *)
inline_raw      = "!{:" kind_label ":" { SPACE } raw_brace_body "}" ;
kind_label      = { CHAR - ":" } ;
raw_brace_body  = { balanced_brace_text } ;   (* nested {} allowed if balanced *)

balanced_brace_text = ( ANY_CHAR - "{" - "}" ) | "{" { balanced_brace_text } "}" ;

(* NOTE: "!" guard: marks only when followed by an identifier char OR ":".
   So "![img]", "!=", "!(" are PROSE. "!{...}" is a PROSE-LEVEL inline form
   (interpolation or inline directive), NOT a head-position block directive --
   the "{" after "!" routes to the inline forms above. *)

(* NOTE: INTERPOLATION and RAW bodies are UNPARSED / VERBATIM. "!{{expr}}"
   double-brace = interpolation; "!{...}" single-brace = inline directive;
   "!{:kind: ...}" = inline raw. The parser distinguishes them by the char(s)
   after "!{" ("{" => interpolation, ":" => raw, else directive) with no
   lookahead -- CORE "Unified Inline Syntax". Brace-counting finds the
   close; an unbalanced brace is an error (use block form instead). EBNF cannot
   express "count braces to find the end." *)

(* NOTE: The internal grammar of expr_text / directive bodies (operators,
   filters "expr | filter", control flow) is DELIBERATELY NOT CORE -- it lives
   in DYNAMICS.md. Shown here as opaque balanced-brace text. *)
```

---

## 9. Comments

```ebnf
(* ";" starts a comment depending on CONTEXT (Comments table):
     document root     -> line comment
     block prose       -> LITERAL (not a comment)
     sameline prose    -> line comment
     block attr line   -> line comment (after values)
     sameline attrs    -> line comment (after values)
     inline/embedded   -> ";{...}" only
   Comments are emitted as EVENTS, not discarded. *)

line_comment    = ";" { CHAR } ;
inline_comment  = ";{" { balanced_brace_text } "}" ;   (* brace-counted end *)

(* NOTE: ";" is LITERAL in block prose but a comment start in sameline prose --
   the same character, disambiguated purely by block-vs-sameline context. EBNF
   cannot select the context. A block-attr / sameline value comment needs a
   preceding space (" ;") in block context; sameline just needs ";" after the
   value. *)

(* NOTE: LINE-COMMENT CONTINUATION -- a line comment followed by a MORE-INDENTED
   non-prefix line is treated as comment content until dedent (CORE
   "Comments"). And block comments participate in indent/dedent (a ";" at
   column 0 can close several elements). Both are indentation behaviors outside
   the grammar. *)
```

---

## 10. Freeform (Triple-Backtick) Blocks

```ebnf
(* Triple-backticks break out of indentation sensitivity entirely: body
   captured EXACTLY, no prose dedentation, no marker interpretation. CORE
   "Triple-Backtick Escape". *)
freeform_open   = "```" { CHAR - NEWLINE } NEWLINE    (* rest-of-line = start of body; info string free *)
                  freeform_body
                  freeform_close ;
freeform_body   = { ANY_CHAR } ;                       (* verbatim, any indentation *)
freeform_close  = { SPACE } "```" { SPACE } NEWLINE ;  (* first non-space content is ``` *)

(* NOTE: OPENING position -- a fence opens at ANY HEAD POSITION: a line start
   (at a structural column) OR in sameline scan after elements AND attributes,
   BEFORE prose begins. "|a |b :k v " + ``` opens a fence. Two non-fences:
   (1) after prose has begun on the line ("|a |b but now" + ``` => literal
   backticks); (2) backticks indented DEEPER than the current prose's column
   (they sit inside that prose). None of these positional conditions are
   expressible in EBNF. *)

(* NOTE: The backticks' indentation sets the block's STRUCTURAL PARENT (child of
   whoever owns that column) -- so fences are not column-1-only. Everything
   after the backticks on the opening line is the body's first content (free
   info string). *)

(* NOTE: CLOSING -- a line whose FIRST NON-SPACE content is triple-backticks
   closes the block, at ANY indentation, and MUST be followed by a newline
   (trailing whitespace before it ignored). CAUTION from spec: indenting the
   closer means its leading whitespace is already part of the captured body
   (body runs to the newline BEFORE the closer); only whitespace to the RIGHT
   of the closing backticks is trimmed. The "first-non-space-is-```" close
   condition and the whitespace-capture rule are not expressible in EBNF. *)

(* NOTE: Prefer "!:lang:" (raw directive) over freeform for code samples; use
   freeform only for assembling files without indent control. Guidance, not
   grammar. *)
```

---

## 11. Escapes

```ebnf
(* "\" is the SOLE escape, in EVERY context (block, sameline, embedded).
   "'" is NOT an escape -- it is a string/name/key delimiter. CORE
   "Block-Level Escape" / "Unified Inline Syntax". *)

(* Block level (line start): "\" + one of | ; : ! \  => escape, always, no
   further lookahead. "\" + non-marker => literal backslash (NOT an escape). *)
block_escape    = "\" block_marker { CHAR } ;
block_marker    = "|" | ";" | ":" | "!" | "\" ;

(* Sameline / embedded: "\" escapes a literal ";" (and "\|{" / "\!{" literals)
   where ";" would otherwise start a comment. *)
(* inline escapes appear inline as: "\;"  "\|{"  "\!{"  -- see embedded_char. *)

(* NOTE: "\hello" is NOT an escape (h is not a marker) -- the backslash is
   preserved as prose. This "escape only before a marker char" rule is a
   one-char lookahead the grammar approximates with block_marker. *)

(* NOTE: Inside quoted strings, "\" follows the DELIMITER's own escaping rules,
   not the block-marker rule (see escaped_char in section 5). *)
```

---

## 12. Prose

```ebnf
(* Any line/segment not starting with a recognized marker is PROSE belonging to
   the parent. The parser treats prose as OPAQUE TEXT -- it does not interpret
   the Markdown inside (that is the MARKDOWN.md companion spec, above the
   parse). *)
block_prose     = { prose_segment } ;
prose_segment   = embedded_element
                | interpolation
                | inline_comment
                | inline_raw
                | prose_text ;
prose_text      = { CHAR } ;   (* opaque; ";" is LITERAL in block prose *)

(* NOTE: BLOCK prose sets an indent-column for continuation and preserves
   literal ";". SAMELINE prose does not set an indent-column and treats ";" as
   a comment. The only structures recognized WITHIN prose are the inline
   bracket forms (|{...}, !{{...}}, !{...}, ;{...}, !{:...:...}); a bare "|" or
   ";" mid-prose is literal because head position has ended. Distinguishing
   block from sameline prose is a parser-state matter, not grammar. *)
```

---

## 13. Terminals

```ebnf
LETTER    = ? Unicode letter (\p{L}) ? ;
XID_START = ? Unicode codepoint with the XID_Start property ? ;   (* bare-name start *)
XID_CONT  = ? Unicode codepoint with the XID_Continue property ? ; (* bare-name continue *)
DIGIT     = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ;
HEX       = DIGIT | "a" | "b" | "c" | "d" | "e" | "f"
                  | "A" | "B" | "C" | "D" | "E" | "F" ;
OCT       = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" ;
BIN       = "0" | "1" ;
SPACE     = " " ;               (* spaces only; TAB is an error *)
NEWLINE   = "\n" | "\r\n" ;
CHAR      = ? any character except NEWLINE ? ;
ANY_CHAR  = ? any character, including NEWLINE ? ;

unsigned_number = float | ( DIGIT { DIGIT | "_" } ) ;

(* Pseudo-terminals emitted by the indentation tracker, NOT present in the
   byte stream: *)
INDENT    = ? increase in leading-space column ? ;
DEDENT    = ? decrease in leading-space column ? ;

(* NOTE: LETTER uses the Unicode letter class per the Dec-2025 EBNF and
   CORE's "letter" language; CORE does not restate the exact code
   point class in the current draft, so \p{L} is carried forward as an
   inference. *)
```

---

## 14. Summary of Imprecision Flags

The `(* NOTE *)` comments above mark every place this grammar is an
approximation. Grouped:

- **Parser-state, not grammar:** head position & marker guards (§0, §2); the
  "commit to prose after first word" rule (§0, §3.1, §12); the "attributes
  before children" phase gate on `:` (§1, §3, §4); block-vs-sameline selection
  for attributes, comments, and prose (§4, §9, §12).
- **Indentation-driven, not grammar:** all nesting / column arithmetic (§0);
  bare-vs-structured attribute values (§4.2); raw-block body extent (§8);
  freeform open/close positions and whitespace capture (§10); line-comment
  continuation and block-comment dedent (§9); prose dedentation (§0).
- **Lookahead/counting the grammar can't express:** value-less attribute
  detection (§4); block value's `" ;"` two-char terminator (§4.1); quote-ends-
  item in lists (§4.3); brace-counted ends for embedded / interpolation / raw /
  inline-comment (§7, §8, §9).
- **Deliberately-out-of-core (dialect/host):** `<...>` envelope-body internal
  structure and unlabelled dispatch (§5.2); reference resolution & ambiguity
  error (§6); the `!` dynamics language — expressions, filters, control flow
  (§8).
- **Back-filled from the descent grammar (`core/generator/*.desc`), now exact:**
  bare-name / bare-trait character classes (§5.1, `udon.desc`); the numeric
  literal grammar (§5, `values.desc`). Two Tier-2 parser-vs-spec gaps remain
  flagged inline: explicit-decimal `0d` (spec intent, no `d` branch in
  `num_zero`) and the trait suffix chars `* ! ? +` (spec intent, `class_name`
  accepts `XLBL_CONT` only).
- **Inferred, not verbatim in current CORE:** `\p{L}` for LETTER (§13);
  whether `<` has a head-position-style guard outside attribute-value position
  (§5.2).

; =============================================================================
; Highlights for UDON (Universal Document & Object Notation)
;
; Design principles (from autocolors):
; - Plumbing (punctuation, delimiters) should recede visually
; - Discriminators (names, keys) should stand out
; - Inner-part coloring: delimiters dimmer than content
; - Warm colors reserved for rare/important tokens
; =============================================================================

; =============================================================================
; Comments (cool, receding)
; =============================================================================

(line_comment) @comment
(inline_comment) @comment

; =============================================================================
; Elements - the structural backbone
; =============================================================================

; Element pipe marker - plumbing, should recede
(element "|" @punctuation.delimiter)
(embedded_element "|{" @punctuation.delimiter)
(embedded_element "}" @punctuation.delimiter)

; Element name - discriminator, should stand out
(element_name
  (identifier) @type)

(element_name
  (quoted_identifier) @type)

; Element ID brackets - plumbing
(element_id "[" @punctuation.bracket)
(element_id "]" @punctuation.bracket)

; Element ID value - discriminator (unique identity)
(element_id
  (bracket_bare_string) @label)
(element_id
  (quoted_string) @label)
(element_id
  (number) @label)

; Element class dot - plumbing
(element_class "." @punctuation.delimiter)

; Element class name - classification
(element_class
  (identifier) @property)

; Element suffix modifiers - special semantic markers
(element_suffix) @operator

; =============================================================================
; Attributes - key-value metadata
; =============================================================================

; Attribute colon - plumbing
(block_attribute ":" @punctuation.delimiter)
(sameline_attribute ":" @punctuation.delimiter)
(embedded_attribute ":" @punctuation.delimiter)

; Attribute key - discriminator
(attribute_key
  (identifier) @property)

(attribute_key
  (quoted_identifier) @property)

; =============================================================================
; Values - typed data
; =============================================================================

; Nil values
(nil_value) @constant.builtin

; Booleans
(boolean) @boolean

; Numbers (all variants - integers, floats, rational, complex)
(number) @number

; Strings
(quoted_string) @string
(block_bare_string) @string
(sameline_bare_string) @string
(embedded_bare_string) @string
(bracket_bare_string) @string
(array_bare_string) @string

; String delimiters - inner-part coloring (dimmer than content)
(quoted_string "\"" @string.delimiter)
(quoted_string "'" @string.delimiter)

; Escape sequences within strings
(escape_sequence) @string.escape

; Lists
(list "[" @punctuation.bracket)
(list "]" @punctuation.bracket)

; =============================================================================
; Dynamics - evaluation and control flow
; =============================================================================

; Block directive bang - marker
(block_directive "!" @keyword.directive)

; Directive name - like a keyword
(directive_name) @keyword.control

; Directive arguments
(directive_args) @variable

; Raw block
(raw_block "!:" @keyword.directive)
(raw_block ":" @keyword.directive)
(raw_block
  (identifier) @label)

; Raw block content (will be injected with language-specific highlighting)
(raw_block_content) @string.special

; Interpolation - dynamic values
(interpolation "!{{" @punctuation.special)
(interpolation "}}" @punctuation.special)
(expression) @variable

; Filters in interpolation
(filter "|" @punctuation.delimiter)
(filter_name) @function
(filter_args) @variable

; Inline directive
(inline_directive "!{" @punctuation.special)
(inline_directive "}" @punctuation.special)

; =============================================================================
; Prose and content
; =============================================================================

; Regular prose text - no special highlighting (default foreground)
(prose_text) @text
(sameline_text) @text
(embedded_text) @text

; =============================================================================
; Escapes
; =============================================================================

; Block-level escape prefix
(block_escape) @string.escape

; =============================================================================
; Freeform blocks
; =============================================================================

(freeform_block "```" @punctuation.delimiter)
(freeform_language) @label
(freeform_content) @string.special

; =============================================================================
; Identifiers (fallback)
; =============================================================================

(identifier) @variable
(quoted_identifier) @variable

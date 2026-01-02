; =============================================================================
; Injections for UDON - Embedded language highlighting
;
; UDON supports embedded languages in several contexts:
; - Raw blocks: !:lang: with indented content
; - Freeform blocks: ``` with optional language tag
; - Prose content: potentially markdown
; =============================================================================

; -----------------------------------------------------------------------------
; Raw blocks: !:elixir:, !:sql:, !:json:, etc.
; The language is specified in the directive
; -----------------------------------------------------------------------------

(raw_block
  (identifier) @injection.language
  (raw_block_content) @injection.content)

; -----------------------------------------------------------------------------
; Freeform blocks with language tag: ```python, ```ruby, etc.
; -----------------------------------------------------------------------------

(freeform_block
  (freeform_language) @injection.language
  (freeform_content) @injection.content)

; -----------------------------------------------------------------------------
; Freeform blocks without language tag - no injection
; (could default to text or markdown)
; -----------------------------------------------------------------------------

; (freeform_block
;   (freeform_content) @injection.content
;   (#set! injection.language "markdown"))

; -----------------------------------------------------------------------------
; Prose content - could inject markdown for formatting
; This is optional and may be too aggressive
; -----------------------------------------------------------------------------

; Uncomment to enable markdown in prose:
; (prose
;   (prose_text) @injection.content
;   (#set! injection.language "markdown"))

; -----------------------------------------------------------------------------
; Common language aliases
; Tree-sitter grammars have specific names; map common aliases
; -----------------------------------------------------------------------------

; These work automatically if the grammar exists:
; - python, ruby, javascript, typescript, rust, go, elixir, sql, json, yaml
; - html, css, markdown, bash, c, cpp, java, kotlin, swift

; Some editors may need explicit mappings for aliases:
; ((raw_block
;    (identifier) @_lang
;    (raw_block_content) @injection.content)
;  (#eq? @_lang "js")
;  (#set! injection.language "javascript"))
;
; ((raw_block
;    (identifier) @_lang
;    (raw_block_content) @injection.content)
;  (#eq? @_lang "ts")
;  (#set! injection.language "typescript"))
;
; ((raw_block
;    (identifier) @_lang
;    (raw_block_content) @injection.content)
;  (#eq? @_lang "rb")
;  (#set! injection.language "ruby"))
;
; ((raw_block
;    (identifier) @_lang
;    (raw_block_content) @injection.content)
;  (#eq? @_lang "py")
;  (#set! injection.language "python"))
;
; ((raw_block
;    (identifier) @_lang
;    (raw_block_content) @injection.content)
;  (#eq? @_lang "sh")
;  (#set! injection.language "bash"))

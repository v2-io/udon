; =============================================================================
; Locals for UDON - Scope and reference tracking
;
; This enables features like:
; - Go to definition for element IDs
; - Find references to IDs
; - Scope highlighting
; =============================================================================

; Elements create scopes
(element) @local.scope
(embedded_element) @local.scope

; Element IDs are definitions (referenceable)
(element_id
  (_) @local.definition.constant)

; Class definitions (when standalone .class element)
(element
  (element_class (identifier) @local.definition.type))

; Directive blocks create scopes
(block_directive) @local.scope

; Variables in interpolation are references
(interpolation
  (expression) @local.reference)

; Directive arguments may contain variable references
(block_directive
  (directive_args) @local.reference)

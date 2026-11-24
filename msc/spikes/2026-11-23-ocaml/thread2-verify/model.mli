type value
type text = string
type attribute
type element_kind = string
type element
type node =
  | Element of element
  | Attribute of attribute
  | Text of text
type ast = node list

val text_val : string -> value
val element_val : element -> value

val make_attr : string -> value list -> attribute
val attr_name : attribute -> string
val values : attribute -> value list
val equal_attribute : attribute -> attribute -> bool

val make_element : kind:element_kind option -> attrs:(string * value) list -> children:node list -> element
val branch : node -> ast
val kind : element -> element_kind option
val attr_names : element -> string list
val attr_values : element -> string -> value list
val children : element -> node list
val is_root : element -> bool
val make_root : meta:(string * value) list -> partial:ast -> element
val document_ast : meta:(string * value) list -> partial:ast -> ast
val equal_element : element -> element -> bool
val equal_ast : ast -> ast -> bool

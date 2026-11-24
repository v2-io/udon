(* Generated from udon_ast.ud — projection: consumer — DO NOT HAND-EDIT *)

# 72 "udon_ast.ud"
(** Source-location metadata optionally attached to AST nodes. *)
type span = {
  source : string;
  line : int;
  col : int;
}

type meta = {
  span : span option;
}

# 85 "udon_ast.ud"
val no_meta : meta
val make_span : source:string -> line:int -> col:int -> span

# 239 "udon_ast.ud"
type element_name = string

# 203 "udon_ast.ud"
type node =
  | Element of element
  | Text of string * meta
  | Attribute of attribute

# 270 "udon_ast.ud"
and element

# 508 "udon_ast.ud"
and attribute = {
  attr_name : string;
  attr_values : value list;
}

# 560 "udon_ast.ud"
and value =
  | VString of string
  | VInt of int
  | VBool of bool
  | VNil
  | VList of value list
  | VNode of node

# 132 "udon_ast.ud"
(** An «AST» is an ordered sequence of zero or more root «nodes». *)
type ast = node list

# 584 "udon_ast.ud"
type partial

# 610 "udon_ast.ud"
type file_metadata = {
  path : string option;
  encoding : string;
}

# 617 "udon_ast.ud"
type document

# 137 "udon_ast.ud"
(** Any single «node» together with its descendants forms a valid «AST» branch. *)
val branch_of_node : node -> ast

(** Content-level equality of two «ASTs» (order-sensitive over root «nodes»). *)
val equal_ast_content : ast -> ast -> bool

(** Metadata-sensitive equality of two «ASTs». *)
val equal_ast_with_meta : ast -> ast -> bool

# 210 "udon_ast.ud"
val text_node : ?meta:meta -> string -> node
val element_node : element -> node
val attribute_node : attribute -> node
val equal_node_content : node -> node -> bool
val equal_node_with_meta : node -> node -> bool

# 274 "udon_ast.ud"
(** Smart constructor for an «element».
    Shorthand helpers [?key], [?traits], and [?main] desugar directly into
    the [$key], [$traits], and [$main] «attributes» — never separate fields. *)
val make_element :
  ?meta:meta ->
  ?name:element_name ->
  ?key:value ->
  ?traits:string list ->
  ?main:string ->
  ?attrs:attribute list ->
  ?children:node list ->
  unit ->
  element

val element_name : element -> element_name option
val element_meta : element -> meta
val children : element -> node list

(** Lookup all values associated with an attribute name, in written order. *)
val attr_values : element -> string -> value list

(** Distinct attribute names present on this «element» (sorted for deterministic observation). *)
val attr_names : element -> string list

(** Convenience observers over the [$key], [$traits], and [$main] attributes. *)
val element_key : element -> value option
val element_traits : element -> string list
val element_main : element -> string option

val equal_element_content : element -> element -> bool
val equal_element_with_meta : element -> element -> bool

# 515 "udon_ast.ud"
val make_attr : string -> value list -> attribute

# 588 "udon_ast.ud"
val make_partial : node list -> partial
val ast_of_partial : partial -> ast

# 621 "udon_ast.ud"
(** Promote a «partial» and file metadata into a «document» whose sole root «node» is «root». *)
val make_document : ?meta:file_metadata -> partial -> document

(** Return the «document's» «root» «element» directly. *)
val root_of_document : document -> element

(** Return the «document's» «AST» — guaranteed to be a singleton list containing only «root». *)
val ast_of_document : document -> ast

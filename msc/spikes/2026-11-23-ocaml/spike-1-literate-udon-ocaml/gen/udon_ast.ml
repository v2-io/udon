(* Generated from udon_ast.ud — projection: implementer — DO NOT HAND-EDIT *)

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

# 239 "udon_ast.ud"
type element_name = string

# 90 "udon_ast.ud"
let no_meta = { span = None }
let make_span ~source ~line ~col = { source; line; col }

# 313 "udon_ast.ud"
module StringMap = Map.Make (String)

# 203 "udon_ast.ud"
type node =
  | Element of element
  | Text of string * meta
  | Attribute of attribute

# 317 "udon_ast.ud"
and element = {
  el_name : element_name option;
  el_attrs : value list StringMap.t;
  el_children : node list;
  el_meta : meta;
}

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

# 594 "udon_ast.ud"
type partial = { partial_nodes : node list }

# 610 "udon_ast.ud"
type file_metadata = {
  path : string option;
  encoding : string;
}

# 633 "udon_ast.ud"
type document = {
  doc_root : element;
}

# 757 "udon_ast.ud"
let rec list_equal eq xs ys =
  match (xs, ys) with
  | [], [] -> true
  | x :: xr, y :: yr -> eq x y && list_equal eq xr yr
  | _ -> false

let map_equal eq m1 m2 = StringMap.equal eq m1 m2

# 767 "udon_ast.ud"
let rec equal_node_content n1 n2 =
  match (n1, n2) with
  | Element e1, Element e2 -> equal_element_content e1 e2
  | Text (s1, _), Text (s2, _) -> String.equal s1 s2
  | Attribute a1, Attribute a2 -> equal_attr_content a1 a2
  | _ -> false

# 776 "udon_ast.ud"
and equal_element_content e1 e2 =
  e1.el_name = e2.el_name
  && map_equal (list_equal equal_value_content) e1.el_attrs e2.el_attrs
  && list_equal equal_node_content e1.el_children e2.el_children

# 783 "udon_ast.ud"
and equal_attr_content a1 a2 =
  String.equal a1.attr_name a2.attr_name
  && list_equal equal_value_content a1.attr_values a2.attr_values

# 789 "udon_ast.ud"
and equal_value_content v1 v2 =
  match (v1, v2) with
  | VString a, VString b -> String.equal a b
  | VInt a, VInt b -> Int.equal a b
  | VBool a, VBool b -> Bool.equal a b
  | VNil, VNil -> true
  | VList xs, VList ys -> list_equal equal_value_content xs ys
  | VNode n1, VNode n2 -> equal_node_content n1 n2
  | _ -> false

# 801 "udon_ast.ud"
and equal_node_with_meta n1 n2 =
  match (n1, n2) with
  | Element e1, Element e2 -> equal_element_with_meta e1 e2
  | Text (s1, m1), Text (s2, m2) -> String.equal s1 s2 && m1 = m2
  | Attribute a1, Attribute a2 -> equal_attr_with_meta a1 a2
  | _ -> false

# 810 "udon_ast.ud"
and equal_element_with_meta e1 e2 =
  e1.el_name = e2.el_name
  && e1.el_meta = e2.el_meta
  && map_equal (list_equal equal_value_with_meta) e1.el_attrs e2.el_attrs
  && list_equal equal_node_with_meta e1.el_children e2.el_children

# 818 "udon_ast.ud"
and equal_attr_with_meta a1 a2 =
  String.equal a1.attr_name a2.attr_name
  && list_equal equal_value_with_meta a1.attr_values a2.attr_values

# 824 "udon_ast.ud"
and equal_value_with_meta v1 v2 =
  match (v1, v2) with
  | VString a, VString b -> String.equal a b
  | VInt a, VInt b -> Int.equal a b
  | VBool a, VBool b -> Bool.equal a b
  | VNil, VNil -> true
  | VList xs, VList ys -> list_equal equal_value_with_meta xs ys
  | VNode n1, VNode n2 -> equal_node_with_meta n1 n2
  | _ -> false

# 149 "udon_ast.ud"
let branch_of_node (n : node) : ast = [ n ]

let equal_ast_content (a : ast) (b : ast) : bool =
  list_equal equal_node_content a b

let equal_ast_with_meta (a : ast) (b : ast) : bool =
  list_equal equal_node_with_meta a b

# 219 "udon_ast.ud"
let text_node ?(meta = no_meta) s = Text (s, meta)
let element_node e = Element e
let attribute_node a = Attribute a

# 326 "udon_ast.ud"
let add_attr_to_map (m : value list StringMap.t) (a : attribute) =
  let existing = Option.value ~default:[] (StringMap.find_opt a.attr_name m) in
  StringMap.add a.attr_name (existing @ a.attr_values) m

let make_element
    ?(meta = no_meta)
    ?name
    ?key
    ?(traits = [])
    ?main
    ?(attrs = [])
    ?(children = [])
    () =
  let m = List.fold_left add_attr_to_map StringMap.empty attrs in
  let m =
    match key with
    | None -> m
    | Some v -> add_attr_to_map m { attr_name = "$key"; attr_values = [ v ] }
  in
  let m =
    match traits with
    | [] -> m
    | ts ->
        let vs = List.map (fun t -> VString t) ts in
        add_attr_to_map m { attr_name = "$traits"; attr_values = [ VList vs ] }
  in
  let m =
    match main with
    | None -> m
    | Some s -> add_attr_to_map m { attr_name = "$main"; attr_values = [ VString s ] }
  in
  { el_name = name; el_attrs = m; el_children = children; el_meta = meta }

let element_name e = e.el_name
let element_meta e = e.el_meta
let children e = e.el_children
let attr_values e k = Option.value ~default:[] (StringMap.find_opt k e.el_attrs)
let attr_names e = StringMap.bindings e.el_attrs |> List.map fst

let element_key e =
  match attr_values e "$key" with
  | v :: _ -> Some v
  | [] -> None

let element_traits e =
  match attr_values e "$traits" with
  | [ VList vs ] ->
      List.filter_map (function VString s -> Some s | _ -> None) vs
  | _ -> []

let element_main e =
  match attr_values e "$main" with
  | VString s :: _ -> Some s
  | _ -> None

# 520 "udon_ast.ud"
let make_attr attr_name attr_values = { attr_name; attr_values }

# 598 "udon_ast.ud"
let make_partial partial_nodes = { partial_nodes }
let ast_of_partial p = p.partial_nodes

# 639 "udon_ast.ud"
let default_file_metadata = { path = None; encoding = "utf-8" }

let make_document ?(meta = default_file_metadata) (p : partial) : document =
  let top_attrs, child_nodes =
    List.fold_left
      (fun (acc_a, acc_c) n ->
        match n with
        | Attribute a -> (a :: acc_a, acc_c)
        | Element _ | Text _ -> (acc_a, n :: acc_c))
      ([], [])
      p.partial_nodes
  in
  let top_attrs = List.rev top_attrs in
  let child_nodes = List.rev child_nodes in
  let meta_attrs =
    let enc = make_attr "$encoding" [ VString meta.encoding ] in
    match meta.path with
    | None -> [ enc ]
    | Some path -> [ make_attr "$path" [ VString path ]; enc ]
  in
  let doc_root =
    make_element
      ~name:"$root"
      ~attrs:(meta_attrs @ top_attrs)
      ~children:child_nodes
      ()
  in
  { doc_root }

let root_of_document d = d.doc_root
let ast_of_document d = [ Element d.doc_root ]

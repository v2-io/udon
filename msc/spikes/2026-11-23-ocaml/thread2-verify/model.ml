module SMap = Map.Make(String)

type text = string
type element_kind = string

type value =
  | VText of string
  | VElement of element
and attribute = { at_name : string; at_values : value list }   (* at_values is never empty *)
and element = {
  el_kind : element_kind option;
  el_attrs : value list SMap.t;                                (* one entry per attribute name *)
  el_children : node list;                                     (* never holds an Attribute *)
}
and node =
  | Element of element
  | Attribute of attribute
  | Text of text
type ast = node list

let text_val s = VText s
let element_val e = VElement e

let make_attr k vs =
  if vs = [] then invalid_arg "an attribute has at least one value";
  { at_name = k; at_values = vs }
let attr_name a = a.at_name
let values a = a.at_values

(* Writing a name again adds its values after those already there. *)
let add_values m k vs =
  let prev = match SMap.find_opt k m with Some p -> p | None -> [] in
  SMap.add k (prev @ vs) m

let make_element ~kind ~attrs ~children =
  if List.exists (function Attribute _ -> true | _ -> false) children then
    invalid_arg "an attribute is not among an element's child nodes";
  { el_kind = kind;
    el_attrs = List.fold_left (fun m (k, v) -> add_values m k [v]) SMap.empty attrs;
    el_children = children }

let branch n = [n]
let kind e = e.el_kind
let attr_names e = List.map fst (SMap.bindings e.el_attrs)
let attr_values e k = match SMap.find_opt k e.el_attrs with Some vs -> vs | None -> []
let children e = e.el_children
let is_root e = (e.el_kind = Some "$root")

(* The attributes among a list of nodes, one per name, and the other nodes in order. *)
let split (nodes : node list) : value list SMap.t * node list =
  List.fold_left (fun (m, rest) n ->
    match n with
    | Attribute a -> (add_values m a.at_name a.at_values, rest)
    | other -> (m, rest @ [other])
  ) (SMap.empty, []) nodes

let make_root ~meta ~partial =
  let part_attrs, part_children = split partial in
  let attrs = List.fold_left (fun m (k, v) -> add_values m k [v]) SMap.empty meta in
  let attrs = SMap.fold (fun k vs m -> add_values m k vs) part_attrs attrs in
  { el_kind = Some "$root"; el_attrs = attrs; el_children = part_children }
let document_ast ~meta ~partial = [ Element (make_root ~meta ~partial) ]

let rec equal_value a b =
  match a, b with
  | VText x, VText y -> String.equal x y
  | VElement x, VElement y -> equal_element x y
  | _ -> false
and equal_values xs ys =
  List.length xs = List.length ys && List.for_all2 equal_value xs ys
and equal_attribute a b =
  String.equal a.at_name b.at_name && equal_values a.at_values b.at_values
and equal_element a b =
  a.el_kind = b.el_kind
  && SMap.equal equal_values a.el_attrs b.el_attrs
  && equal_ordered a.el_children b.el_children
and equal_node a b =
  match a, b with
  | Element x, Element y -> equal_element x y
  | Attribute x, Attribute y -> equal_attribute x y
  | Text x, Text y -> String.equal x y
  | _ -> false
and equal_ordered a b =
  List.length a = List.length b && List.for_all2 equal_node a b

(* An attribute has no position among the nodes beside it, so two ASTs are
   compared by their attributes (by name) and by their other root nodes in order. *)
let equal_ast a b =
  let (aa, ar) = split a and (ba, br) = split b in
  SMap.equal equal_values aa ba && equal_ordered ar br

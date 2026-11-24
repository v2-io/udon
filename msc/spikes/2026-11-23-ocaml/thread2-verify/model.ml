module SMap = Map.Make(String)
type value = VText of string
type text = string
type attribute = string * value
type element_name = string
type element = {
  el_name : element_name option;
  el_attrs : value list SMap.t;
  el_children : node list;
}
and node =
  | Element of element
  | Attribute of attribute
  | Text of text
type ast = node list

let text_val s = VText s
let make_attr k v = (k, v)
let add_attr m (k, v) =
  let prev = match SMap.find_opt k m with Some vs -> vs | None -> [] in
  SMap.add k (prev @ [v]) m
let make_element ~name ~attrs ~children =
  { el_name = name; el_attrs = List.fold_left add_attr SMap.empty attrs; el_children = children }
let branch n = [n]
let name e = e.el_name
let attr_names e = List.map fst (SMap.bindings e.el_attrs)
let attr_values e k = match SMap.find_opt k e.el_attrs with Some vs -> vs | None -> []
let children e = e.el_children
let is_root e = (e.el_name = Some "$root")
let make_root ~meta ~partial =
  let part_attrs, part_children =
    List.fold_right (fun n (a, c) ->
      match n with Attribute kv -> (kv :: a, c) | other -> (a, other :: c)
    ) partial ([], [])
  in
  make_element ~name:(Some "$root") ~attrs:(meta @ part_attrs) ~children:part_children
let document_ast ~meta ~partial = [ Element (make_root ~meta ~partial) ]

let rec equal_element a b =
  a.el_name = b.el_name
  && SMap.equal (=) a.el_attrs b.el_attrs
  && equal_ast a.el_children b.el_children
and equal_node a b =
  match a, b with
  | Element x, Element y -> equal_element x y
  | Attribute x, Attribute y -> x = y
  | Text x, Text y -> x = y
  | _ -> false
and equal_ast a b =
  List.length a = List.length b && List.for_all2 equal_node a b

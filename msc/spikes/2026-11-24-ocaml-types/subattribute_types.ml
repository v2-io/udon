(* udon-core as OCaml types, with attributes that can have attributes.
   A sketch from the 2026-11-24 session, kept from a scratch directory; not the spec.

   It predates two later turns of the same day: "complex node" as the name for what
   the three records share, and the Alloy form in spec/alloy-def/core.md, which is
   the more current statement. What this file has that the Alloy does not is `merge`:
   writing an attribute-name again, and a partial's contents going under a parent,
   as one operation (children append; attributes merge by name, recursively).

   Run:  ocamlc -w -a subattribute_types.ml -o t && ./t     (prints "ok") *)

module M = Map.Make(String)
type 'a by_name = 'a M.t
type text = string
type partial   = { attributes : attribute by_name; children : item list }
and  element   = { kind : string option; attributes : attribute by_name; children : item list }
and  attribute = { attributes : attribute by_name; children : item list }
and  item      = Element of element | Text of text

(* writing a name again, and a partial taking its place under a root, are one operation *)
let rec merge (a : attribute) (b : attribute) : attribute =
  { attributes = M.union (fun _ x y -> Some (merge x y)) a.attributes b.attributes;
    children = a.children @ b.children }

let leaf (xs : item list) : attribute = { attributes = M.empty; children = xs }
(* :font Helvetica  +  :font with sub-attribute size 12 *)
let font1 = leaf [ Text "Helvetica" ]
let font2 : attribute = { attributes = M.singleton "size" (leaf [ Text "12" ]); children = [] }
let font = merge font1 font2
let nothing : attribute = leaf []
let () =
  assert (font.children = [ Text "Helvetica" ]);
  assert (M.mem "size" font.attributes);
  assert (font2.children = []);            (* an attribute with sub-attributes and no values *)
  assert (nothing.children = [] && M.is_empty nothing.attributes);  (* and one with nothing at all *)
  print_endline "ok"

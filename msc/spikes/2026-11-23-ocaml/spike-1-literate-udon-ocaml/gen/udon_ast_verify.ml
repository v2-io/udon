(* Generated from udon_ast.ud — projection: verification — DO NOT HAND-EDIT *)

# 164 "udon_ast.ud"
let inv_branch_is_ast (e : Udon_ast.element) : unit =
  List.iter
    (fun child ->
      let branch = Udon_ast.branch_of_node child in
      assert (List.length branch = 1);
      assert (Udon_ast.equal_ast_content branch branch))
    (Udon_ast.children e)

# 691 "udon_ast.ud"
let inv_document_unique_root (doc : Udon_ast.document) : unit =
  let ast = Udon_ast.ast_of_document doc in
  assert (List.length ast = 1);
  match ast with
  | [ Udon_ast.Element r ] ->
      assert (Udon_ast.element_name r = Some "$root");
      assert (Udon_ast.attr_values r "$encoding" <> []);
      inv_branch_is_ast r
  | _ -> assert false

let auto_387_attributes_unordered () =
# 387 "udon_ast.ud"
  let a1 = Udon_ast.make_attr "role" [ Udon_ast.VString "steward" ] in
  let a2 = Udon_ast.make_attr "active" [ Udon_ast.VBool true ] in
  let e1 = Udon_ast.make_element ~name:"user" ~attrs:[ a1; a2 ] () in
  let e2 = Udon_ast.make_element ~name:"user" ~attrs:[ a2; a1 ] () in
  assert (Udon_ast.equal_element_content e1 e2)

let auto_399_children_ordered () =
# 399 "udon_ast.ud"
  let c1 = Udon_ast.text_node "first" in
  let c2 = Udon_ast.text_node "second" in
  let e1 = Udon_ast.make_element ~name:"seq" ~children:[ c1; c2 ] () in
  let e2 = Udon_ast.make_element ~name:"seq" ~children:[ c2; c1 ] () in
  assert (not (Udon_ast.equal_element_content e1 e2))

let auto_412_shorthands_desugar_to_attributes () =
# 412 "udon_ast.ud"
  let via_shorthand =
    Udon_ast.make_element
      ~name:"user"
      ~key:(Udon_ast.VString "jw")
      ~traits:[ "steward"; "active" ]
      ~main:"Joseph"
      ()
  in
  let via_explicit =
    Udon_ast.make_element
      ~name:"user"
      ~attrs:
        [
          Udon_ast.make_attr "$key" [ Udon_ast.VString "jw" ];
          Udon_ast.make_attr "$traits"
            [ Udon_ast.VList [ Udon_ast.VString "steward"; Udon_ast.VString "active" ] ];
          Udon_ast.make_attr "$main" [ Udon_ast.VString "Joseph" ];
        ]
      ()
  in
  assert (Udon_ast.equal_element_content via_shorthand via_explicit);
  assert (Udon_ast.element_key via_shorthand = Some (Udon_ast.VString "jw"));
  assert (Udon_ast.element_traits via_shorthand = [ "steward"; "active" ]);
  assert (Udon_ast.element_main via_shorthand = Some "Joseph")

let auto_528_repeated_attr_order_preserved () =
# 528 "udon_ast.ud"
  let e1 =
    Udon_ast.make_element ~name:"term"
      ~attrs:
        [
          Udon_ast.make_attr "pos" [ Udon_ast.VString "noun" ];
          Udon_ast.make_attr "pos" [ Udon_ast.VString "verb" ];
        ]
      ()
  in
  let e2 =
    Udon_ast.make_element ~name:"term"
      ~attrs:
        [
          Udon_ast.make_attr "pos" [ Udon_ast.VString "verb" ];
          Udon_ast.make_attr "pos" [ Udon_ast.VString "noun" ];
        ]
      ()
  in
  assert (Udon_ast.attr_values e1 "pos" = [ Udon_ast.VString "noun"; Udon_ast.VString "verb" ]);
  assert (not (Udon_ast.equal_element_content e1 e2))

let auto_841_content_ignores_meta () =
# 841 "udon_ast.ud"
  let m1 = { Udon_ast.span = Some (Udon_ast.make_span ~source:"a.ud" ~line:1 ~col:0) } in
  let m2 = { Udon_ast.span = Some (Udon_ast.make_span ~source:"b.ud" ~line:9 ~col:4) } in
  let e1 = Udon_ast.make_element ~meta:m1 ~name:"item" ~main:"x" () in
  let e2 = Udon_ast.make_element ~meta:m2 ~name:"item" ~main:"x" () in
  assert (Udon_ast.equal_element_content e1 e2);
  assert (not (Udon_ast.equal_element_with_meta e1 e2))

let auto_177_empty_partial_ast () =
# 177 "udon_ast.ud"
  let ast = Udon_ast.ast_of_partial (Udon_ast.make_partial []) in
  assert (ast = []);
  assert (Udon_ast.equal_ast_content ast [])

let auto_442_element_user_with_text () =
# 442 "udon_ast.ud"
  let el =
    Udon_ast.make_element
      ~name:"user"
      ~key:(Udon_ast.VString "jw")
      ~traits:[ "founding" ]
      ~attrs:[ Udon_ast.make_attr "role" [ Udon_ast.VString "steward" ] ]
      ~children:[ Udon_ast.text_node "Hello from UDON." ]
      ()
  in
  assert (Udon_ast.element_name el = Some "user");
  assert (List.length (Udon_ast.children el) = 1);
  assert (Udon_ast.attr_names el = [ "$key"; "$traits"; "role" ]);
  inv_branch_is_ast el

let auto_461_element_anonymous () =
# 461 "udon_ast.ud"
  let a = Udon_ast.element_node (Udon_ast.make_element ~name:"a" ()) in
  let b = Udon_ast.element_node (Udon_ast.make_element ~name:"b" ()) in
  let anon = Udon_ast.make_element ~children:[ a; b ] () in
  assert (Udon_ast.element_name anon = None);
  assert (Udon_ast.attr_names anon = []);
  assert (List.length (Udon_ast.children anon) = 2);
  inv_branch_is_ast anon

let auto_474_element_title_main () =
# 474 "udon_ast.ud"
  let title = Udon_ast.make_element ~name:"title" ~main:"Hello" () in
  assert (Udon_ast.element_name title = Some "title");
  assert (Udon_ast.element_main title = Some "Hello");
  assert (Udon_ast.children title = []);
  assert (Udon_ast.attr_names title = [ "$main" ]);
  inv_branch_is_ast title

let auto_708_three_line_partial_vs_document () =
# 708 "udon_ast.ud"
  let attr = Udon_ast.attribute_node (Udon_ast.make_attr "lang" [ Udon_ast.VString "en" ]) in
  let e1 = Udon_ast.element_node (Udon_ast.make_element ~name:"h1" ~main:"Title" ()) in
  let e2 = Udon_ast.element_node (Udon_ast.make_element ~name:"p" ~main:"Body" ()) in
  let partial = Udon_ast.make_partial [ attr; e1; e2 ] in
  assert (List.length (Udon_ast.ast_of_partial partial) = 3);
  let doc =
    Udon_ast.make_document
      ~meta:{ Udon_ast.path = Some "hello.ud"; encoding = "utf-8" }
      partial
  in
  inv_document_unique_root doc;
  let r = Udon_ast.root_of_document doc in
  assert (Udon_ast.attr_values r "lang" = [ Udon_ast.VString "en" ]);
  assert (Udon_ast.attr_values r "$path" = [ Udon_ast.VString "hello.ud" ]);
  assert (List.length (Udon_ast.children r) = 2);
  assert (Udon_ast.equal_ast_content (Udon_ast.children r) [ e1; e2 ])

let auto_731_empty_document_has_root () =
# 731 "udon_ast.ud"
  let doc =
    Udon_ast.make_document
      ~meta:{ Udon_ast.path = Some "empty.ud"; encoding = "utf-8" }
      (Udon_ast.make_partial [])
  in
  inv_document_unique_root doc;
  let r = Udon_ast.root_of_document doc in
  assert (Udon_ast.children r = []);
  assert (Udon_ast.attr_values r "$path" = [ Udon_ast.VString "empty.ud" ])

# 1 "udon_ast_verify.ml (generated runner)"
let () =
  Printf.printf "Running %d auto-registered checks from udon_ast.ud:\n" 11;
  let passed = ref 0 in
  auto_387_attributes_unordered (); incr passed; Printf.printf "  [PASS] %-4s %-34s (udon_ast.ud:387)\n" "I.e." "attributes-unordered";
  auto_399_children_ordered (); incr passed; Printf.printf "  [PASS] %-4s %-34s (udon_ast.ud:399)\n" "I.e." "children-ordered";
  auto_412_shorthands_desugar_to_attributes (); incr passed; Printf.printf "  [PASS] %-4s %-34s (udon_ast.ud:412)\n" "I.e." "shorthands-desugar-to-attributes";
  auto_528_repeated_attr_order_preserved (); incr passed; Printf.printf "  [PASS] %-4s %-34s (udon_ast.ud:528)\n" "I.e." "repeated-attr-order-preserved";
  auto_841_content_ignores_meta (); incr passed; Printf.printf "  [PASS] %-4s %-34s (udon_ast.ud:841)\n" "I.e." "content-ignores-meta";
  auto_177_empty_partial_ast (); incr passed; Printf.printf "  [PASS] %-4s %-34s (udon_ast.ud:177)\n" "E.g." "empty-partial-ast";
  auto_442_element_user_with_text (); incr passed; Printf.printf "  [PASS] %-4s %-34s (udon_ast.ud:442)\n" "E.g." "element-user-with-text";
  auto_461_element_anonymous (); incr passed; Printf.printf "  [PASS] %-4s %-34s (udon_ast.ud:461)\n" "E.g." "element-anonymous";
  auto_474_element_title_main (); incr passed; Printf.printf "  [PASS] %-4s %-34s (udon_ast.ud:474)\n" "E.g." "element-title-main";
  auto_708_three_line_partial_vs_document (); incr passed; Printf.printf "  [PASS] %-4s %-34s (udon_ast.ud:708)\n" "E.g." "three-line-partial-vs-document";
  auto_731_empty_document_has_root (); incr passed; Printf.printf "  [PASS] %-4s %-34s (udon_ast.ud:731)\n" "E.g." "empty-document-has-root";
  Printf.printf "\nAll %d repeatable checks passed.\n" !passed

open Model

(* from element.md *)
(* E.g. — written order of distinct «attributes» does not distinguish two «elements» *)
let user_a : element =
  make_element ~name:(Some "user")
    ~attrs:[ ("$key", text_val "jw"); ("$traits", text_val "admin"); ("role", text_val "editor") ]
    ~children:[ Text "Active steward" ]

let user_b : element =
  make_element ~name:(Some "user")
    ~attrs:[ ("role", text_val "editor"); ("$key", text_val "jw"); ("$traits", text_val "admin") ]
    ~children:[ Text "Active steward" ]
(* equal_element user_a user_b = true *)

(* from element.md *)
(* E.g. — child «node» order IS observable *)
let anon_ab : element =
  make_element ~name:None ~attrs:[]
    ~children:[
      Element (make_element ~name:(Some "first")  ~attrs:[] ~children:[]);
      Element (make_element ~name:(Some "second") ~attrs:[] ~children:[]);
    ]

let anon_ba : element =
  make_element ~name:None ~attrs:[]
    ~children:[
      Element (make_element ~name:(Some "second") ~attrs:[] ~children:[]);
      Element (make_element ~name:(Some "first")  ~attrs:[] ~children:[]);
    ]
(* name anon_ab = None  &&  equal_element anon_ab anon_ba = false *)

(* from element.md *)
(* E.g. — own-line text lives in `$main`, leaving `children` empty *)
let title_el : element =
  make_element ~name:(Some "title") ~attrs:[ ("$main", text_val "Hello") ] ~children:[]
(* attr_values title_el "$main" = [ text_val "Hello" ]  &&  children title_el = [] *)

(* from element.md *)
(* E.g. *)
let doc_root : element = make_root ~meta:[ ("$file", text_val "hello.ud") ] ~partial:[]
(* name doc_root = Some "$root" *)

(* from root.md *)
(* E.g. *)
let one_el_doc : ast =
  document_ast
    ~meta:[ ("$file", text_val "greeting.ud") ]
    ~partial:[ Element (make_element ~name:(Some "p") ~attrs:[ ("$main", text_val "Hi") ] ~children:[]) ]
(* match one_el_doc with
   | [ Element r ] -> is_root r && List.length (children r) = 1
   | _ -> false *)

(* from root.md *)
(* E.g. *)
let empty_doc : ast = document_ast ~meta:[ ("$file", text_val "empty.ud") ] ~partial:[]
(* match empty_doc with
   | [ Element r ] -> is_root r && children r = [] && attr_values r "$file" = [ text_val "empty.ud" ]
   | _ -> false *)

(* from AST.md *)
(* E.g. — marked restatement of the example above *)
let partial_ast : ast =
  [ Attribute (make_attr "title" (text_val "Notes"));
    Element (make_element ~name:(Some "p") ~attrs:[] ~children:[ Text "Hello" ]);
    Element (make_element ~name:(Some "p") ~attrs:[] ~children:[ Text "World" ]) ]
(* List.length partial_ast = 3 *)

(* from AST.md *)
(* E.g. — same «partial» wrapped as a «document» *)
let doc_ast : ast = document_ast ~meta:[ ("$file", text_val "notes.ud") ] ~partial:partial_ast
(* List.length doc_ast = 1 *)

(* from AST.md *)
(* E.g. *)
let empty_partial : ast = []
let () =
  assert (equal_element user_a user_b = true);
  assert (name anon_ab = None && equal_element anon_ab anon_ba = false);
  assert (attr_values title_el "$main" = [ text_val "Hello" ] && children title_el = []);
  assert (name doc_root = Some "$root");
  assert (match one_el_doc with | [ Element r ] -> is_root r && List.length (children r) = 1 | _ -> false);
  assert (match empty_doc with | [ Element r ] -> is_root r && children r = [] && attr_values r "$file" = [ text_val "empty.ud" ] | _ -> false);
  assert (List.length partial_ast = 3);
  assert (List.length doc_ast = 1);
  assert (empty_partial = []);
  print_endline "ALL 9 THREAD-2 EXAMPLE ASSERTIONS PASSED"

open Model

(* from element.md *)
(* E.g. — written order of distinct «attributes» does not distinguish two «elements» *)
let user_a : element =
  make_element ~kind:(Some "user")
    ~attrs:[ ("$key", text_val "jw"); ("$traits", text_val "admin"); ("role", text_val "editor") ]
    ~children:[ Text "Active steward" ]

let user_b : element =
  make_element ~kind:(Some "user")
    ~attrs:[ ("role", text_val "editor"); ("$key", text_val "jw"); ("$traits", text_val "admin") ]
    ~children:[ Text "Active steward" ]
(* equal_element user_a user_b = true *)

(* from element.md *)
(* E.g. — child «node» order IS observable *)
let anon_ab : element =
  make_element ~kind:None ~attrs:[]
    ~children:[
      Element (make_element ~kind:(Some "first")  ~attrs:[] ~children:[]);
      Element (make_element ~kind:(Some "second") ~attrs:[] ~children:[]);
    ]

let anon_ba : element =
  make_element ~kind:None ~attrs:[]
    ~children:[
      Element (make_element ~kind:(Some "second") ~attrs:[] ~children:[]);
      Element (make_element ~kind:(Some "first")  ~attrs:[] ~children:[]);
    ]
(* kind anon_ab = None  &&  equal_element anon_ab anon_ba = false *)

(* from element.md *)
(* E.g. — own-line text lives in `$main`, leaving `children` empty *)
let title_el : element =
  make_element ~kind:(Some "title") ~attrs:[ ("$main", text_val "Hello") ] ~children:[]
(* attr_values title_el "$main" = [ text_val "Hello" ]  &&  children title_el = [] *)

(* from element.md *)
(* E.g. *)
let doc_root : element = make_root ~meta:[ ("$file", text_val "hello.ud") ] ~partial:[]
(* kind doc_root = Some "$root" *)

(* from root.md *)
(* E.g. *)
let one_el_doc : ast =
  document_ast
    ~meta:[ ("$file", text_val "greeting.ud") ]
    ~partial:[ Element (make_element ~kind:(Some "p") ~attrs:[ ("$main", text_val "Hi") ] ~children:[]) ]
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
  [ Attribute (make_attr "title" [ text_val "Notes" ]);
    Element (make_element ~kind:(Some "p") ~attrs:[] ~children:[ Text "Hello" ]);
    Element (make_element ~kind:(Some "p") ~attrs:[] ~children:[ Text "World" ]) ]
(* List.length partial_ast = 3 *)

(* from AST.md *)
(* E.g. — same «partial» wrapped as a «document» *)
let doc_ast : ast = document_ast ~meta:[ ("$file", text_val "notes.ud") ] ~partial:partial_ast
(* List.length doc_ast = 1 *)

(* from AST.md *)
(* E.g. *)
let empty_partial : ast = []

(* from attribute.md *)
(* E.g. — one «attribute» per «attribute-name»; only the order of its own «values» counts *)
let term_a : element =
  make_element ~kind:(Some "term")
    ~attrs:[ ("pos", text_val "noun"); ("status", text_val "draft"); ("pos", text_val "verb") ]
    ~children:[]

let term_b : element =
  make_element ~kind:(Some "term")
    ~attrs:[ ("status", text_val "draft"); ("pos", text_val "noun"); ("pos", text_val "verb") ]
    ~children:[]

let term_c : element =
  make_element ~kind:(Some "term")
    ~attrs:[ ("pos", text_val "verb"); ("pos", text_val "noun"); ("status", text_val "draft") ]
    ~children:[]
(* List.length (attr_names term_a) = 2
   && attr_values term_a "pos" = [ text_val "noun"; text_val "verb" ]
   && equal_element term_a term_b = true
   && equal_element term_a term_c = false *)

(* from attribute.md *)
(* E.g. — a «value» may be an «element» *)
let person : element =
  make_element ~kind:(Some "person") ~attrs:[ ("name", text_val "Jane") ] ~children:[]

let author : attribute = make_attr "author" [ element_val person ]
(* attr_name author = "author"  &&  List.length (values author) = 1 *)

(* from attribute.md *)
(* E.g. — at the top of a «partial» an «attribute» has no position either *)
let p : node = Element (make_element ~kind:(Some "p") ~attrs:[] ~children:[ Text "Hello" ])
let q : node = Element (make_element ~kind:(Some "q") ~attrs:[] ~children:[])
let title : node = Attribute (make_attr "title" [ text_val "Notes" ])
let lang : node = Attribute (make_attr "lang" [ text_val "en" ])
(* equal_ast [ title; p; lang; q ] [ lang; p; q; title ] = true
   && equal_ast [ title; p; q ] [ title; q; p ] = false *)

(* from attribute.md *)
(* E.g. *)
let tag_twice : ast =
  [ Attribute (make_attr "tag" [ text_val "a" ]); Attribute (make_attr "tag" [ text_val "b" ]) ]

let tag_once : ast = [ Attribute (make_attr "tag" [ text_val "a"; text_val "b" ]) ]
(* equal_ast tag_twice tag_once = true *)
let () =
  assert (equal_element user_a user_b = true);
  assert (kind anon_ab = None && equal_element anon_ab anon_ba = false);
  assert (attr_values title_el "$main" = [ text_val "Hello" ] && children title_el = []);
  assert (kind doc_root = Some "$root");
  assert (match one_el_doc with | [ Element r ] -> is_root r && List.length (children r) = 1 | _ -> false);
  assert (match empty_doc with | [ Element r ] -> is_root r && children r = [] && attr_values r "$file" = [ text_val "empty.ud" ] | _ -> false);
  assert (List.length partial_ast = 3);
  assert (List.length doc_ast = 1);
  assert (empty_partial = []);
  assert (List.length (attr_names term_a) = 2 && attr_values term_a "pos" = [ text_val "noun"; text_val "verb" ] && equal_element term_a term_b = true && equal_element term_a term_c = false);
  assert (attr_name author = "author" && List.length (values author) = 1);
  assert (equal_ast [ title; p; lang; q ] [ lang; p; q; title ] = true && equal_ast [ title; p; q ] [ title; q; p ] = false);
  assert (equal_ast tag_twice tag_once = true);
  print_endline "ALL 13 EXAMPLE ASSERTIONS PASSED"

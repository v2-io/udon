(* checks.ml — Executable Ubiquitous Language Invariants over Generated OCaml ADTs *)
(* Compiled strictly against the generated .mli boundaries: Verisectorium & Udon_spec. *)

module V = Verisectorium
module U = Udon_spec

type finding = {
  severity : [ `Violation | `Unsettled | `Warning ];
  code : string;
  message : string;
}

let severity_tag = function
  | `Violation -> "VIOLATION"
  | `Unsettled -> "UNSETTLED"
  | `Warning   -> "WARNING  "

let print_findings title findings =
  Printf.printf "=== %s ===\n" title;
  if findings = [] then
    Printf.printf "  [OK] 0 findings — Ubiquitous Language invariants hold and outlines are at rest.\n"
  else
    List.iter (fun f ->
      Printf.printf "  [%s] (%s) %s\n" (severity_tag f.severity) f.code f.message
    ) findings

(* ------------------------------------------------------------------------- *)
(* 1. Verisectorium Bounded Context Invariants                               *)
(* ------------------------------------------------------------------------- *)

let check_verisectorium
    (pieces : V.Piece.t list)
    (outlines : V.Outline.t list)
    (acts : V.act list) : finding list =
  let findings = ref [] in
  let add sev code msg = findings := { severity = sev; code; message = msg } :: !findings in

  let piece_by_name name =
    List.find_opt (fun (p : V.Piece.t) -> V.Piece.id_name p.id = name) pieces
  in

  (* Build reverse reliance map: target_name -> (source_name * reliance_kind) list *)
  let dependents_of target_name =
    List.filter_map (fun (p : V.Piece.t) ->
      let hits = List.filter (fun (r : V.reliance) ->
        V.Piece.id_name r.target = target_name &&
        match r.kind with V.For_truth | V.Restates -> true | V.From_source | V.Related -> false
      ) p.relies_on_items in
      if hits = [] then None else Some (V.Piece.id_name p.id)
    ) pieces
  in

  let rec transitive_dependents visited queue =
    match queue with
    | [] -> visited
    | cur :: rest ->
        let nexts =
          dependents_of cur
          |> List.filter (fun n -> not (List.mem n visited))
        in
        transitive_dependents (visited @ nexts) (rest @ nexts)
  in

  (* 1a. Maker != Checker (Note 30 §2) & track refuted/confirmed checks *)
  let refuted_pieces = ref [] in
  let confirmed_non_author = ref [] in
  List.iter (function
    | V.Checked c ->
        let pname = V.Piece.id_name c.about in
        (match piece_by_name pname with
         | Some p when p.author = c.by ->
             add `Violation "maker-is-checker"
               (Printf.sprintf "Piece '%s' (v%d) was checked by its own author '%s' (method: %s)"
                  pname c.version c.by c.method_)
         | Some p ->
             (match c.outcome with
              | V.Refuted ->
                  if not (List.mem pname !refuted_pieces) then
                    refuted_pieces := pname :: !refuted_pieces
              | V.Confirmed ->
                  if c.version = p.version then
                    confirmed_non_author := pname :: !confirmed_non_author)
         | None -> ())
    | V.Made _ | V.Decided _ | V.Reflected_in _ | V.Knowingly_left _ -> ()
  ) acts;

  (* 1b. Refutation outlasts rewrite (Note 30 §7) *)
  List.iter (fun pname ->
    if not (List.mem pname !confirmed_non_author) then
      add `Unsettled "refuted-unresolved"
        (Printf.sprintf "Piece '%s' has refuting evidence with no subsequent independent confirmation" pname)
  ) !refuted_pieces;

  (* 1c. Unsettled grounds & weak choices bearing downstream load (Note 30 §§6, 8, 10) *)
  List.iter (function
    | V.Decided d ->
        let dname = V.Piece.id_name d.about in
        let bad_grounds =
          List.filter (fun g -> List.mem (V.Piece.id_name g) !refuted_pieces) d.grounds
        in
        if bad_grounds <> [] then begin
          let down = transitive_dependents [] [dname] in
          let gnames = String.concat ", " (List.map V.Piece.id_name bad_grounds) in
          let dlist = if down = [] then "none" else String.concat ", " down in
          add `Unsettled "ground-refuted"
            (Printf.sprintf "Decision '%s' (by %s, how=%s) relies on refuted ground(s) [%s]; downstream unsettled: [%s]"
               dname d.by (V.decision_how_to_string d.how) gnames dlist)
        end;
        let is_weak = match d.how with
          | V.Hole_close | V.Inferred | V.Habit -> true
          | V.Ruling | V.Assented | V.Lean | V.Unobjected -> false
        in
        if is_weak then begin
          let down = transitive_dependents [] [dname] in
          add `Warning "weak-decision"
            (Printf.sprintf "Weak choice '%s' (how=%s, by %s) has %d downstream dependent(s): [%s]"
               dname (V.decision_how_to_string d.how) d.by (List.length down) (String.concat ", " down))
        end;
        (match d.words with
         | V.Attributed_not_located a ->
             add `Warning "unlocated-decision-words"
               (Printf.sprintf "Decision '%s' attributed to '%s' without located verbatim source words"
                  dname a.who)
         | V.Located _ -> ())
    | V.Made _ | V.Checked _ | V.Reflected_in _ | V.Knowingly_left _ -> ()
  ) acts;

  (* 1d. Restatement must restate something, and For_truth/Restates graph must be acyclic *)
  List.iter (fun (p : V.Piece.t) ->
    let pname = V.Piece.id_name p.id in
    (match p.kind with
     | V.Restatement ->
         let has_restates = List.exists (fun (r : V.reliance) -> r.kind = V.Restates) p.relies_on_items in
         if not has_restates then
           add `Violation "restatement-without-target"
             (Printf.sprintf "Restatement piece '%s' has no :kind restates reliance" pname)
     | _ -> ());
    (* Cycle detection via DFS from p *)
    let rec dfs path cur =
      match piece_by_name cur with
      | None -> ()
      | Some node ->
          List.iter (fun (r : V.reliance) ->
            match r.kind with
            | V.For_truth | V.Restates ->
                let nxt = V.Piece.id_name r.target in
                if nxt = pname then
                  add `Violation "reliance-cycle"
                    (Printf.sprintf "Cycle in reliance graph: %s -> %s" (String.concat " -> " (List.rev (cur :: path))) nxt)
                else if not (List.mem nxt path) then
                  dfs (cur :: path) nxt
            | V.From_source | V.Related -> ()
          ) node.relies_on_items
    in
    dfs [] pname
  ) pieces;

  (* 1e. Deliverable outlines cannot include On_approval slots (Note 30 §5) *)
  List.iter (fun (o : V.Outline.t) ->
    match o.scope with
    | V.Outline.Deliverable ->
        List.iter (function
          | V.Settled _ -> () (* already proven `Accepted at compile time by phantom type! *)
          | V.On_approval s ->
              add `Violation "deliverable-on-approval"
                (Printf.sprintf "Deliverable outline '%s' (reader: %s) includes on-approval slot for '%s'"
                   (V.Outline.id_name o.id) o.reader (V.Piece.id_name s.piece))
        ) o.children
    | V.Outline.Working -> ()
  ) outlines;

  List.rev !findings

(* ------------------------------------------------------------------------- *)
(* 2. UDON v2 Spec Bounded Context Invariants                                *)
(* ------------------------------------------------------------------------- *)

(* Canonical AST equality per spec/def/element.md L24-L25:
   - Attribute order across distinct names is ignored;
   - Repeated values for the same attribute name preserve written order;
   - Child nodes are strictly ordered. *)
let group_attrs (attrs : U.ast_attr list) : (string * string list) list =
  let tbl : (string, string list) Hashtbl.t = Hashtbl.create 8 in
  List.iter (fun (a : U.ast_attr) ->
    let prev = match Hashtbl.find_opt tbl a.name with Some l -> l | None -> [] in
    Hashtbl.replace tbl a.name (prev @ [a.value])
  ) attrs;
  Hashtbl.fold (fun k v acc -> (k, v) :: acc) tbl []
  |> List.sort (fun (a, _) (b, _) -> String.compare a b)

let rec ast_equal (a : U.ast_node) (b : U.ast_node) : bool =
  match a, b with
  | U.Ast_text t1, U.Ast_text t2 -> t1.main = t2.main
  | U.Ast_element e1, U.Ast_element e2 ->
      e1.name = e2.name
      && group_attrs e1.attrs = group_attrs e2.attrs
      && List.length e1.children = List.length e2.children
      && List.for_all2 ast_equal e1.children e2.children
  | U.Ast_root r1, U.Ast_root r2 ->
      r1.file = r2.file
      && group_attrs r1.attrs = group_attrs r2.attrs
      && List.length r1.children = List.length r2.children
      && List.for_all2 ast_equal r1.children r2.children
  | _ -> false

let check_udon_spec (terms : U.Term.t list) (ast_nodes : U.ast_node list) : finding list =
  let findings = ref [] in
  let add sev code msg = findings := { severity = sev; code; message = msg } :: !findings in

  let term_by_name name =
    List.find_opt (fun (t : U.Term.t) -> U.Term.id_name t.id = name) terms
  in

  (* 2a. Symmetric :dual check *)
  List.iter (fun (t : U.Term.t) ->
    let tname = U.Term.id_name t.id in
    match t.dual with
    | None -> ()
    | Some d_id ->
        let dname = U.Term.id_name d_id in
        (match term_by_name dname with
         | Some other ->
             let back_ok = match other.dual with
               | Some back_id -> U.Term.id_name back_id = tname
               | None -> false
             in
             if not back_ok then
               add `Violation "asymmetric-dual"
                 (Printf.sprintf "Term «%s» declares :dual «%s», but «%s» does not declare :dual «%s»"
                    tname dname dname tname)
         | None -> ())
  ) terms;

  (* 2b. Avoid-word collision check *)
  let canonical_and_syns =
    List.concat_map (fun (t : U.Term.t) ->
      let tname = U.Term.id_name t.id in
      (String.lowercase_ascii tname, tname)
      :: List.map (fun s -> (String.lowercase_ascii s, tname)) t.synonyms
    ) terms
  in
  List.iter (fun (t : U.Term.t) ->
    let tname = U.Term.id_name t.id in
    List.iter (fun (av : U.avoid_entry) ->
      let w = String.lowercase_ascii av.word in
      List.iter (fun (existing, owner) ->
        if existing = w then
          add `Violation "avoid-collision"
            (Printf.sprintf "Term «%s» marks '%s' as |avoid, but it collides with defined term/synonym of «%s»"
               tname av.word owner)
      ) canonical_and_syns
    ) t.avoid_items
  ) terms;

  (* 2c. Full-term completeness (per spec/.kinds/term.kdl) *)
  List.iter (fun (t : U.Term.t) ->
    let tname = U.Term.id_name t.id in
    match t.kind with
    | U.Full_term ->
        if t.invariant_items = [] && t.example_items = [] then
          add `Warning "full-term-thin"
            (Printf.sprintf "Full-term «%s» has neither |invariant nor |example children" tname)
    | U.Inline_term -> ()
  ) terms;

  (* 2d. Verify AST unordered-attribute equality invariant on paired AST samples *)
  (match ast_nodes with
   | a :: b :: _ ->
       if not (ast_equal a b) then
         add `Violation "ast-attr-order-equality"
           "Paired AST samples differing only in attribute order failed canonical AST equality!"
   | _ -> ());

  List.rev !findings

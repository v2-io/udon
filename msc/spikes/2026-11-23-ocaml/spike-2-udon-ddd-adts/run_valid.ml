(* run_valid.ml — Runs Ubiquitous Language invariant checks on the valid UDON stores *)

let () =
  let v_findings =
    Checks.check_verisectorium
      Verisectorium_store.all_pieces
      Verisectorium_store.all_outlines
      Verisectorium_store.all_acts
  in
  Checks.print_findings "Verisectorium Store (data/verisectorium_store.ud)" v_findings;

  let u_findings =
    Checks.check_udon_spec
      Udon_part1.all_terms
      Udon_part1.all_ast_nodes
  in
  Checks.print_findings "UDON v2 Part 1 Lexicon & AST (data/udon_part1.ud)" u_findings;

  (* Print concrete evidence of UDON affordances surviving cleanly into typed OCaml *)
  Printf.printf "\n--- Verified Round-Trip Highlights ---\n";
  let mint = List.find (fun (t : Udon_spec.Term.t) -> Udon_spec.Term.id_name t.id = "mint") Udon_part1.all_terms in
  let mint_pos = Udon_spec.nonempty_to_list mint.pos |> List.map Udon_spec.pos_to_string |> String.concat ", " in
  Printf.printf "  Repeated :pos on |term[mint] -> pos nonempty = [%s]\n" mint_pos;

  let backed =
    List.filter_map (fun (t : Udon_spec.Term.t) ->
      match t.backing with
      | Some pid -> Some (Printf.sprintf "«%s» -> Verisectorium.%s" (Udon_spec.Term.id_name t.id) (Verisectorium.Piece.id_name pid))
      | None -> None
    ) Udon_part1.all_terms
  in
  Printf.printf "  Cross-context :backing links (.mli-verified): %s\n" (String.concat "; " backed);

  match Udon_part1.all_ast_nodes with
  | a :: b :: _ ->
      Printf.printf "  AST attribute-order equality (sample-a #1 == sample-a #2): %b (raw OCaml = is %b)\n"
        (Checks.ast_equal a b) (a = b)
  | _ -> ()

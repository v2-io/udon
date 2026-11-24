(* udon_lit.ml — Prototype Literate UDON v2 Tangler + Verisectorium Auditor for OCaml
 *
 * Zero external dependencies; compiles directly with `ocamlc -g -o udon_lit udon_lit.ml`.
 * Implements:
 *   1. An indentation-sensitive UDON v2 subset parser (elements, [key], .traits, :attrs,
 *      lists [...], quoted strings, ; comments, and N>=3 backtick fences with element-line
 *      openers + first-non-blank-line dedent per spec-lite rule-fence-body-dedent).
 *   2. Multi-projection tangling (.mli, .ml, _verify.ml) with:
 *      - `.shared` single-source transparent types emitted into both .mli and .ml
 *      - `:layout [...]` section ordering (comprehension order -> OCaml declaration order)
 *      - `:join-type-rec` and `:join-let-rec` mutual-recursion joining
 *      - `# <line> "<source.ud>"` OCaml line directives on every chunk
 *      - `:auto-runner true` automatic registration of `I.e.` (.check) & `E.g.` (.test)
 *   3. Verisectorium ubiquitous-language & coverage audit:
 *      - `«term»` resolution against declared `|term[...]` + `:pl` + `:forms` + `«shown|term»`
 *      - `:avoid` word lint in normative prose
 *      - Computed per-term coverage table & decision provenance summary
 *)

(* ---------------------------------------------------------------------------
 * 1. AST & Helpers
 * --------------------------------------------------------------------------- *)

type attr_val =
  | AWord of string
  | AList of string list

type node_kind =
  | Element of {
      name : string;
      key : string option;
      traits : string list;
      attrs : (string * attr_val) list;
      main : string option;
    }
  | Fence of {
      lang : string;
      key : string option;
      traits : string list;
      attrs : (string * attr_val) list;
      body_lines : string list; (* dedented unless .exact *)
      raw_lines : string list;  (* original indentation preserved *)
      body_start_line : int;    (* 1-based line number of first body line in .ud *)
      dedent : int;             (* spaces removed by first-non-blank-line dedent *)
    }
  | Prose of string

type udon_node = {
  kind : node_kind;
  line : int;
  col : int;
  mutable children : udon_node list;
  mutable extra_attrs : (string * attr_val) list;
}

let is_space c = c = ' ' || c = '\t'
let is_blank s = String.trim s = ""

let leading_spaces s =
  let len = String.length s in
  let rec loop i =
    if i < len && s.[i] = ' ' then loop (i + 1) else i
  in
  loop 0

let drop_prefix n s =
  let len = String.length s in
  if n >= len then "" else String.sub s n (len - n)

let starts_with ~prefix s =
  let plen = String.length prefix in
  String.length s >= plen && String.sub s 0 plen = prefix

let count_leading_char c s =
  let len = String.length s in
  let rec loop i =
    if i < len && s.[i] = c then loop (i + 1) else i
  in
  loop 0

let read_lines path =
  let ic = open_in path in
  let rec loop acc =
    match input_line ic with
    | line -> loop (line :: acc)
    | exception End_of_file ->
        close_in ic;
        List.rev acc
  in
  loop []

let write_file path content =
  let oc = open_out path in
  output_string oc content;
  close_out oc

let ensure_dir dir =
  if not (Sys.file_exists dir) then Sys.mkdir dir 0o755

(* ---------------------------------------------------------------------------
 * 2. Header / Attribute Line Tokenizer
 * --------------------------------------------------------------------------- *)

let strip_inline_comment s =
  let len = String.length s in
  let rec loop i in_quote escaped =
    if i >= len then s
    else
      let c = s.[i] in
      if escaped then loop (i + 1) in_quote false
      else if c = '\\' && in_quote then loop (i + 1) in_quote true
      else if c = '"' then loop (i + 1) (not in_quote) false
      else if (not in_quote) && c = ';' && (i = 0 || is_space s.[i - 1]) then
        String.sub s 0 i |> String.trim
      else loop (i + 1) in_quote false
  in
  loop 0 false false

let parse_ident_end s i =
  let len = String.length s in
  let rec loop j =
    if j >= len then j
    else
      match s.[j] with
      | ' ' | '\t' | '[' | ']' | '.' | ':' | '"' -> j
      | _ -> loop (j + 1)
  in
  loop i

let parse_quoted s i =
  (* s.[i] = '"' *)
  let len = String.length s in
  let buf = Buffer.create 32 in
  let rec loop j escaped =
    if j >= len then (Buffer.contents buf, j)
    else
      let c = s.[j] in
      if escaped then (
        Buffer.add_char buf c;
        loop (j + 1) false)
      else if c = '\\' then loop (j + 1) true
      else if c = '"' then (Buffer.contents buf, j + 1)
      else (
        Buffer.add_char buf c;
        loop (j + 1) false)
  in
  loop (i + 1) false

let skip_spaces s i =
  let len = String.length s in
  let rec loop j = if j < len && is_space s.[j] then loop (j + 1) else j in
  loop i

let parse_list_val s i =
  (* s.[i] = '[' *)
  let len = String.length s in
  let rec loop j acc =
    let j = skip_spaces s j in
    if j >= len then (List.rev acc, j)
    else if s.[j] = ']' then (List.rev acc, j + 1)
    else if s.[j] = '"' then
      let v, next = parse_quoted s j in
      loop next (v :: acc)
    else
      let rec scan k =
        if k >= len then k
        else if is_space s.[k] || s.[k] = ']' then k
        else scan (k + 1)
      in
      let k = scan j in
      let tok = String.sub s j (k - j) in
      loop k (tok :: acc)
  in
  loop (i + 1) []

let parse_attr_value s i =
  let len = String.length s in
  let i = skip_spaces s i in
  if i >= len then (AWord "true", i)
  else if s.[i] = '"' then
    let v, next = parse_quoted s i in
    (AWord v, next)
  else if s.[i] = '[' then
    let vs, next = parse_list_val s i in
    (AList vs, next)
  else
    let rec scan k =
      if k >= len then k
      else if is_space s.[k] then k
      else scan (k + 1)
    in
    let k = scan i in
    (AWord (String.sub s i (k - i)), k)

(* Parse `:k1 v1 :k2 v2 ...` until either end-of-line or non-attribute main text *)
let parse_attrs_and_main s i =
  let len = String.length s in
  let rec loop j acc =
    let j = skip_spaces s j in
    if j >= len then (List.rev acc, None)
    else if s.[j] = ':' then
      let k_end =
        let rec scan k =
          if k >= len || is_space s.[k] then k else scan (k + 1)
        in
        scan (j + 1)
      in
      let kname = String.sub s (j + 1) (k_end - j - 1) in
      let next_ws = skip_spaces s k_end in
      if next_ws >= len || s.[next_ws] = ':' then
        loop next_ws ((kname, AWord "true") :: acc)
      else
        let v, after_v = parse_attr_value s next_ws in
        loop after_v ((kname, v) :: acc)
    else
      let rest = String.sub s j (len - j) |> String.trim in
      (List.rev acc, if rest = "" then None else Some rest)
  in
  loop i []

(* Parse an element-like opener: `name[key].trait1.trait2 :attr val ... main` *)
let parse_element_line raw =
  let s = strip_inline_comment raw in
  let len = String.length s in
  let name_end = parse_ident_end s 0 in
  let name = String.sub s 0 name_end in
  let rec parse_mods i key traits =
    if i >= len then (key, List.rev traits, i)
    else if s.[i] = '[' then
      let close =
        match String.index_from_opt s (i + 1) ']' with
        | Some c -> c
        | None -> len
      in
      let k = String.sub s (i + 1) (close - i - 1) |> String.trim in
      let next = if close < len then close + 1 else len in
      parse_mods next (Some k) traits
    else if s.[i] = '.' then
      let t_end = parse_ident_end s (i + 1) in
      let t = String.sub s (i + 1) (t_end - i - 1) in
      parse_mods t_end key (t :: traits)
    else (key, List.rev traits, i)
  in
  let key, traits, after_mods = parse_mods name_end None [] in
  let attrs, main = parse_attrs_and_main s after_mods in
  (name, key, traits, attrs, main)

(* ---------------------------------------------------------------------------
 * 3. Indentation-Sensitive UDON v2 Subset Parser
 * --------------------------------------------------------------------------- *)

let parse_udon path =
  let lines = read_lines path in
  let arr = Array.of_list lines in
  let nlines = Array.length arr in
  let root =
    {
      kind = Element { name = "$root"; key = None; traits = []; attrs = []; main = None };
      line = 0;
      col = -1;
      children = [];
      extra_attrs = [];
    }
  in
  let stack = ref [ root ] in
  let pop_to col =
    let rec loop = function
      | top :: rest when top.col >= col -> loop rest
      | st -> st
    in
    stack := loop !stack
  in
  let current_parent () = List.hd !stack in
  let add_child node =
    let p = current_parent () in
    p.children <- p.children @ [ node ]
  in
  let i = ref 0 in
  while !i < nlines do
    let lnum = !i + 1 in
    let line = arr.(!i) in
    if is_blank line then incr i
    else
      let col = leading_spaces line in
      let trimmed = drop_prefix col line in
      if trimmed.[0] = ';' then
        (* Comment line — skip (and skip deeper lines if comment block) *)
        incr i
      else if count_leading_char '`' trimmed >= 3 then (
        let ticks = count_leading_char '`' trimmed in
        let opener_rest = drop_prefix ticks trimmed in
        let lang, key, traits, attrs, _main = parse_element_line opener_rest in
        let body_start_line = lnum + 1 in
        incr i;
        let raw_rev = ref [] in
        let closed = ref false in
        while !i < nlines && not !closed do
          let bline = arr.(!i) in
          let bcol = leading_spaces bline in
          let btrim = drop_prefix bcol bline in
          let closer_ticks = count_leading_char '`' btrim in
          if closer_ticks >= ticks && is_blank (strip_inline_comment (drop_prefix closer_ticks btrim))
          then (
            closed := true;
            incr i)
          else (
            raw_rev := bline :: !raw_rev;
            incr i)
        done;
        let raw_lines = List.rev !raw_rev in
        let is_exact = List.mem "exact" traits in
        let dedent =
          if is_exact then 0
          else
            match List.find_opt (fun l -> not (is_blank l)) raw_lines with
            | None -> 0
            | Some first -> leading_spaces first
        in
        let body_lines =
          if dedent = 0 then raw_lines
          else
            List.map
              (fun l ->
                if is_blank l then ""
                else
                  let sp = leading_spaces l in
                  drop_prefix (min sp dedent) l)
              raw_lines
        in
        pop_to col;
        let node =
          {
            kind =
              Fence
                { lang; key; traits; attrs; body_lines; raw_lines; body_start_line; dedent };
            line = lnum;
            col;
            children = [];
            extra_attrs = [];
          }
        in
        add_child node)
      else if trimmed.[0] = '|' && String.length trimmed > 1 && not (is_space trimmed.[1]) then (
        let rest = drop_prefix 1 trimmed in
        let name, key, traits, attrs, main = parse_element_line rest in
        pop_to col;
        let node =
          {
            kind = Element { name; key; traits; attrs; main };
            line = lnum;
            col;
            children = [];
            extra_attrs = [];
          }
        in
        add_child node;
        stack := node :: !stack;
        incr i)
      else if trimmed.[0] = ':' && String.length trimmed > 1 && not (is_space trimmed.[1]) then (
        (* Child attribute line attached to parent element *)
        pop_to col;
        let p = current_parent () in
        let attrs, rest_main = parse_attrs_and_main (strip_inline_comment trimmed) 0 in
        let attrs =
          match (attrs, rest_main) with
          | [ (k, AWord v) ], Some m -> [ (k, AWord (v ^ " " ^ m)) ]
          | _ -> attrs
        in
        p.extra_attrs <- p.extra_attrs @ attrs;
        incr i)
      else (
        pop_to col;
        let node =
          { kind = Prose trimmed; line = lnum; col; children = []; extra_attrs = [] }
        in
        add_child node;
        incr i)
  done;
  root

(* Attribute lookup helpers *)
let all_attrs node =
  match node.kind with
  | Element e -> e.attrs @ node.extra_attrs
  | Fence f -> f.attrs
  | Prose _ -> []

let attr_word node k =
  match List.assoc_opt k (all_attrs node) with
  | Some (AWord s) -> Some s
  | _ -> None

let attr_words node k =
  List.filter_map
    (fun (ak, av) ->
      if ak <> k then None
      else
        match av with
        | AWord s -> Some [ s ]
        | AList xs -> Some xs)
    (all_attrs node)
  |> List.flatten

let rec iter_tree ~ancestors f node =
  f ~ancestors node;
  let next_anc = node :: ancestors in
  List.iter (iter_tree ~ancestors:next_anc f) node.children

(* ---------------------------------------------------------------------------
 * 4. Literate Tangler (with # <line> "<source.ud>" & Mutual-Recursion Joining)
 * --------------------------------------------------------------------------- *)

type fence_chunk = {
  chunk_key : string option;
  parent_kind : string;
  parent_key : string option;
  traits : string list;
  section : string;
  body_lines : string list;
  raw_lines : string list;
  body_start_line : int;
  dedent : int;
  fence_line : int;
}

type tangle_spec = {
  target_file : string;
  projection : string;
  match_traits : string list;
  layout : string list;
  join_type_rec : string list;
  join_let_rec : string list;
  auto_runner : bool;
}

let collect_tangle_specs root =
  let specs = ref [] in
  iter_tree ~ancestors:[]
    (fun ~ancestors:_ node ->
      match node.kind with
      | Element e when e.name = "tangle" ->
          let target_file = Option.value ~default:"out.ml" (attr_word node "file") in
          let projection = Option.value ~default:"unknown" (attr_word node "projection") in
          let match_traits = attr_words node "traits" in
          let layout = attr_words node "layout" in
          let join_type_rec = attr_words node "join-type-rec" in
          let join_let_rec = attr_words node "join-let-rec" in
          let auto_runner = attr_word node "auto-runner" = Some "true" in
          specs :=
            {
              target_file;
              projection;
              match_traits;
              layout;
              join_type_rec;
              join_let_rec;
              auto_runner;
            }
            :: !specs
      | _ -> ())
    root;
  List.rev !specs

let collect_ocaml_chunks root =
  let chunks = ref [] in
  iter_tree ~ancestors:[]
    (fun ~ancestors node ->
      match node.kind with
      | Fence f when f.lang = "ocaml" ->
          let parent_kind, parent_key =
            match ancestors with
            | p :: _ -> (
                match p.kind with
                | Element pe -> (pe.name, pe.key)
                | _ -> ("", None))
            | [] -> ("", None)
          in
          let section = Option.value ~default:"main" (attr_word node "section") in
          chunks :=
            {
              chunk_key = f.key;
              parent_kind;
              parent_key;
              traits = f.traits;
              section;
              body_lines = f.body_lines;
              raw_lines = f.raw_lines;
              body_start_line = f.body_start_line;
              dedent = f.dedent;
              fence_line = node.line;
            }
            :: !chunks
      | _ -> ())
    root;
  List.rev !chunks

let rewrite_leading_keyword ~from_kw ~to_kw lines =
  let rec loop done_rewrite acc = function
    | [] -> List.rev acc
    | line :: rest ->
        if done_rewrite then loop true (line :: acc) rest
        else
          let sp = leading_spaces line in
          let t = drop_prefix sp line in
          if t = "" || starts_with ~prefix:"(*" t then loop false (line :: acc) rest
          else if starts_with ~prefix:from_kw t then
            let replaced =
              String.make sp ' ' ^ to_kw ^ drop_prefix (String.length from_kw) t
            in
            loop true (replaced :: acc) rest
          else loop true (line :: acc) rest
  in
  loop false [] lines

let emit_tangle ~source_path ~preserve_indent ~out_dir spec all_chunks =
  let matching =
    List.filter
      (fun c -> List.exists (fun t -> List.mem t spec.match_traits) c.traits)
      all_chunks
  in
  let buf = Buffer.create 4096 in
  Buffer.add_string buf
    (Printf.sprintf "(* Generated from %s — projection: %s — DO NOT HAND-EDIT *)\n"
       source_path spec.projection);
  let auto_entries = ref [] in
  let emit_chunk ~join_mode ~idx c =
    let lines = if preserve_indent then c.raw_lines else c.body_lines in
    let lines =
      match join_mode with
      | `TypeRec when idx > 0 -> rewrite_leading_keyword ~from_kw:"type " ~to_kw:"and " lines
      | `LetRec when idx > 0 ->
          let l1 = rewrite_leading_keyword ~from_kw:"let rec " ~to_kw:"and " lines in
          if l1 <> lines then l1
          else rewrite_leading_keyword ~from_kw:"let " ~to_kw:"and " lines
      | _ -> lines
    in
    if spec.auto_runner && not (List.mem "helper" c.traits) then (
      let kind_label =
        if List.mem "check" c.traits then "I.e."
        else if List.mem "test" c.traits then "E.g."
        else "check"
      in
      let name =
        match (c.parent_key, c.chunk_key) with
        | Some pk, _ -> pk
        | None, Some ck -> ck
        | None, None -> Printf.sprintf "line_%d" c.fence_line
      in
      let fn_name =
        Printf.sprintf "auto_%d_%s" c.body_start_line
          (String.map
             (fun ch ->
               if (ch >= 'a' && ch <= 'z') || (ch >= '0' && ch <= '9') then ch else '_')
             (String.lowercase_ascii name))
      in
      auto_entries := (kind_label, name, c.body_start_line, fn_name) :: !auto_entries;
      Buffer.add_string buf (Printf.sprintf "\nlet %s () =\n" fn_name);
      Buffer.add_string buf
        (Printf.sprintf "# %d \"%s\"\n" c.body_start_line source_path);
      List.iter
        (fun l ->
          if preserve_indent then (
            Buffer.add_string buf l;
            Buffer.add_char buf '\n')
          else (
            Buffer.add_string buf (if is_blank l then "" else "  " ^ l);
            Buffer.add_char buf '\n'))
        lines)
    else (
      Buffer.add_char buf '\n';
      Buffer.add_string buf
        (Printf.sprintf "# %d \"%s\"\n" c.body_start_line source_path);
      List.iter
        (fun l ->
          Buffer.add_string buf l;
          Buffer.add_char buf '\n')
        lines)
  in
  List.iter
    (fun sec ->
      let sec_chunks = List.filter (fun c -> c.section = sec) matching in
      let join_mode =
        if List.mem sec spec.join_type_rec then `TypeRec
        else if List.mem sec spec.join_let_rec then `LetRec
        else `None
      in
      List.iteri (fun idx c -> emit_chunk ~join_mode ~idx c) sec_chunks)
    spec.layout;
  (* Check for any orphan chunks whose section wasn't in layout *)
  let orphans =
    List.filter (fun c -> not (List.mem c.section spec.layout)) matching
  in
  if orphans <> [] then
    Printf.eprintf "[WARN] %s: %d chunk(s) in sections not listed in :layout: %s\n"
      spec.target_file (List.length orphans)
      (String.concat ", " (List.map (fun c -> c.section) orphans));
  if spec.auto_runner then (
    let entries = List.rev !auto_entries in
    Buffer.add_string buf
      (Printf.sprintf "\n# 1 \"%s (generated runner)\"\nlet () =\n" spec.target_file);
    Buffer.add_string buf
      (Printf.sprintf "  Printf.printf \"Running %%d auto-registered checks from %s:\\n\" %d;\n"
         (Filename.basename source_path) (List.length entries));
    Buffer.add_string buf "  let passed = ref 0 in\n";
    List.iter
      (fun (kind_label, name, line, fn_name) ->
        Buffer.add_string buf
          (Printf.sprintf
             "  %s (); incr passed; Printf.printf \"  [PASS] %%-4s %%-34s (%s:%d)\\n\" %S %S;\n"
             fn_name (Filename.basename source_path) line kind_label name))
      entries;
    Buffer.add_string buf
      "  Printf.printf \"\\nAll %d repeatable checks passed.\\n\" !passed\n");
  let out_path = Filename.concat out_dir spec.target_file in
  write_file out_path (Buffer.contents buf);
  (out_path, List.length matching)

(* ---------------------------------------------------------------------------
 * 5. Verisectorium Ubiquitous-Language & Coverage Audit
 * --------------------------------------------------------------------------- *)

type term_info = {
  id : string;
  line : int;
  status : string;
  forms : string list; (* lowercase accepted forms *)
  synonyms : string list; (* lowercase space-normalized synonym phrases *)
  avoids : string list;
  mutable has_mli : bool;
  mutable has_ml : bool;
  mutable has_shared : bool;
  mutable ie_prose : int;
  mutable ie_exec : int;
  mutable eg_prose : int;
  mutable eg_exec : int;
  mutable open_notes : int;
}

type decision_info = {
  dec_id : string;
  dec_how : string;
  dec_by : string;
  dec_at : string;
  dec_has_words : bool;
}

(* UTF-8 helpers for guillemets: « = \xc2\xab, » = \xc2\xbb *)
let guillemet_open = "\xc2\xab"
let guillemet_close = "\xc2\xbb"

let extract_guillemets s =
  let len = String.length s in
  let rec find_sub sub pos =
    let slen = String.length sub in
    if pos + slen > len then None
    else if String.sub s pos slen = sub then Some pos
    else find_sub sub (pos + 1)
  in
  let rec loop pos acc =
    match find_sub guillemet_open pos with
    | None -> List.rev acc
    | Some o -> (
        let start = o + String.length guillemet_open in
        match find_sub guillemet_close start with
        | None -> List.rev acc
        | Some c ->
            let inner = String.sub s start (c - start) in
            (* Support «shown|term» notation per spec/.kinds/term.kdl *)
            let target =
              match String.index_opt inner '|' with
              | Some bar -> String.sub inner (bar + 1) (String.length inner - bar - 1)
              | None -> inner
            in
            loop (c + String.length guillemet_close) (target :: acc))
  in
  loop 0 []

let expand_term_forms base pl extra_forms =
  let b = String.lowercase_ascii base in
  let forms = ref [ b; b ^ "'s" ] in
  (match pl with
  | Some s when starts_with ~prefix:"-" s ->
      let suffix = drop_prefix 1 s in
      forms := (b ^ suffix) :: !forms
  | Some irr -> forms := String.lowercase_ascii irr :: !forms
  | None -> ());
  List.iter (fun f -> forms := String.lowercase_ascii f :: !forms) extra_forms;
  !forms

let is_word_char c =
  (c >= 'a' && c <= 'z')
  || (c >= 'A' && c <= 'Z')
  || (c >= '0' && c <= '9')
  || c = '-' || c = '_'

let contains_whole_word ~needle haystack =
  let h = String.lowercase_ascii haystack in
  let n = String.lowercase_ascii needle in
  let hlen = String.length h in
  let nlen = String.length n in
  let rec loop i =
    if i + nlen > hlen then false
    else if String.sub h i nlen = n then
      let left_ok = i = 0 || not (is_word_char h.[i - 1]) in
      let right_ok = i + nlen = hlen || not (is_word_char h.[i + nlen]) in
      if left_ok && right_ok then true else loop (i + 1)
    else loop (i + 1)
  in
  nlen > 0 && loop 0

let run_verisectorium_audit ~source_path root =
  let terms_rev = ref [] in
  let decisions_rev = ref [] in
  (* Pass 1: collect terms & decisions *)
  iter_tree ~ancestors:[]
    (fun ~ancestors:_ node ->
      match node.kind with
      | Element e when e.name = "term" ->
          let id = Option.value ~default:"<unnamed>" e.key in
          let status = Option.value ~default:"unset" (attr_word node "status") in
          let pl = attr_word node "pl" in
          let extra = attr_words node "forms" in
          let synonyms =
            attr_words node "synonyms"
            |> List.map (fun s ->
                   String.lowercase_ascii (String.map (fun c -> if c = '-' then ' ' else c) s))
          in
          let avoids = attr_words node "avoid" in
          let ti =
            {
              id;
              line = node.line;
              status;
              forms = expand_term_forms id pl extra;
              synonyms;
              avoids;
              has_mli = false;
              has_ml = false;
              has_shared = false;
              ie_prose = 0;
              ie_exec = 0;
              eg_prose = 0;
              eg_exec = 0;
              open_notes = 0;
            }
          in
          terms_rev := ti :: !terms_rev
      | Element e when e.name = "decision" ->
          let dec_id = Option.value ~default:"<unnamed>" e.key in
          let dec_how = Option.value ~default:"unset" (attr_word node "how") in
          let dec_by = Option.value ~default:"unknown" (attr_word node "by") in
          let dec_at = Option.value ~default:"unknown" (attr_word node "at") in
          let dec_has_words = attr_word node "words" <> None in
          decisions_rev :=
            { dec_id; dec_how; dec_by; dec_at; dec_has_words } :: !decisions_rev
      | _ -> ())
    root;
  let terms = List.rev !terms_rev in
  let decisions = List.rev !decisions_rev in
  let known_forms = Hashtbl.create 64 in
  List.iter
    (fun ti -> List.iter (fun f -> Hashtbl.replace known_forms f ti.id) ti.forms)
    terms;
  let term_by_id = Hashtbl.create 32 in
  List.iter (fun ti -> Hashtbl.replace term_by_id ti.id ti) terms;

  (* Pass 2: compute per-term coverage + scan normative prose for «terms» and :avoid words *)
  let unknown_terms = ref [] in
  let avoid_hits = ref [] in
  let total_ie_exec = ref 0 in
  let total_eg_exec = ref 0 in
  let total_open_notes = ref 0 in

  let enclosing_term ancestors =
    List.find_map
      (fun a ->
        match a.kind with
        | Element e when e.name = "term" -> Option.bind e.key (Hashtbl.find_opt term_by_id)
        | _ -> None)
      ancestors
  in
  let in_non_normative ancestors =
    List.exists
      (fun a ->
        match a.kind with
        | Element e ->
            List.mem e.name [ "working-notes"; "discussion"; "historical-context" ]
        | _ -> false)
      ancestors
  in

  let strip_phrase ~phrase haystack =
    let h = String.lowercase_ascii haystack in
    let plen = String.length phrase in
    let hlen = String.length h in
    if plen = 0 then h
    else
      let buf = Buffer.create hlen in
      let rec loop i =
        if i >= hlen then Buffer.contents buf
        else if i + plen <= hlen && String.sub h i plen = phrase then (
          Buffer.add_char buf ' ';
          loop (i + plen))
        else (
          Buffer.add_char buf h.[i];
          loop (i + 1))
      in
      loop 0
  in
  let check_prose_line ~line ~normative text =
    List.iter
      (fun raw_term ->
        let norm = String.lowercase_ascii raw_term in
        if not (Hashtbl.mem known_forms norm) then
          unknown_terms := (line, raw_term) :: !unknown_terms)
      (extract_guillemets text);
    if normative then
      List.iter
        (fun ti ->
          (* Exempt declared synonyms of the same term (e.g. "abstract syntax tree" vs :avoid [tree]) *)
          let cleaned =
            List.fold_left (fun acc syn -> strip_phrase ~phrase:syn acc) text ti.synonyms
          in
          List.iter
            (fun bad ->
              let phrase = String.map (fun c -> if c = '-' then ' ' else c) bad in
              if contains_whole_word ~needle:phrase cleaned then
                avoid_hits := (line, phrase, ti.id) :: !avoid_hits)
            ti.avoids)
        terms
  in

  iter_tree ~ancestors:[]
    (fun ~ancestors node ->
      let et = enclosing_term ancestors in
      match node.kind with
      | Prose s ->
          let normative = not (in_non_normative ancestors) in
          check_prose_line ~line:node.line ~normative s;
          if
            List.exists
              (fun a -> match a.kind with Element e -> e.name = "working-notes" | _ -> false)
              ancestors
          then (
            incr total_open_notes;
            Option.iter (fun ti -> ti.open_notes <- ti.open_notes + 1) et)
      | Element e ->
          Option.iter
            (fun m ->
              let normative =
                (not (in_non_normative ancestors))
                && not (List.mem e.name [ "working-notes"; "discussion"; "historical-context" ])
              in
              check_prose_line ~line:node.line ~normative m)
            e.main;
          (match attr_word node "holds" with
          | Some h -> check_prose_line ~line:node.line ~normative:true h
          | None -> ());
          if e.name = "invariant" then (
            let has_code =
              List.exists (fun c -> match c.kind with Fence _ -> true | _ -> false) node.children
            in
            Option.iter
              (fun ti ->
                if has_code then ti.ie_exec <- ti.ie_exec + 1
                else ti.ie_prose <- ti.ie_prose + 1)
              et;
            if has_code then incr total_ie_exec)
          else if e.name = "example" then (
            let has_code =
              List.exists (fun c -> match c.kind with Fence _ -> true | _ -> false) node.children
            in
            Option.iter
              (fun ti ->
                if has_code then ti.eg_exec <- ti.eg_exec + 1
                else ti.eg_prose <- ti.eg_prose + 1)
              et;
            if has_code then incr total_eg_exec)
      | Fence f when f.lang = "ocaml" ->
          Option.iter
            (fun ti ->
              if List.mem "shared" f.traits then ti.has_shared <- true;
              if List.mem "mli" f.traits then ti.has_mli <- true;
              if List.mem "ml" f.traits then ti.has_ml <- true)
            et
      | Fence _ -> ())
    root;

  (* Print Verisectorium-style Computed Summary *)
  Printf.printf "\n=== Verisectorium Audit: %s ===\n\n" (Filename.basename source_path);
  Printf.printf "DECISIONS (%d recorded)\n" (List.length decisions);
  List.iter
    (fun d ->
      Printf.printf "  %-36s  how=%-7s  by=%-7s  at=%s  verbatim=%s\n" d.dec_id d.dec_how
        d.dec_by d.dec_at (if d.dec_has_words then "yes" else "MISSING"))
    decisions;
  Printf.printf "\nUBIQUITOUS LANGUAGE & PROJECTION COVERAGE (%d terms)\n" (List.length terms);
  Printf.printf "  %-14s %-7s %-11s %-8s %-8s %-5s\n" "TERM" "STATUS" "OCAML" "I.e." "E.g." "OPEN";
  List.iter
    (fun ti ->
      let ocaml_str =
        match (ti.has_shared, ti.has_mli, ti.has_ml) with
        | true, true, true -> "shared+both"
        | true, true, false -> "shared+mli"
        | true, false, true -> "shared+ml"
        | true, false, false -> "shared"
        | false, true, true -> "mli+ml"
        | false, true, false -> "mli-only"
        | false, false, true -> "ml-only"
        | false, false, false -> "prose-only"
      in
      Printf.printf "  %-14s %-7s %-11s %d exec   %d exec   %d\n" ti.id ti.status ocaml_str
        ti.ie_exec ti.eg_exec ti.open_notes)
    terms;
  Printf.printf "\nTOTAL EXECUTABLE CHECKS: %d I.e. invariants, %d E.g. examples | OPEN WORKING NOTES: %d\n"
    !total_ie_exec !total_eg_exec !total_open_notes;

  let unk = List.rev !unknown_terms in
  let av = List.rev !avoid_hits in
  if unk = [] && av = [] then (
    Printf.printf "\nUBIQUITOUS LANGUAGE CHECK: CLEAN (0 undefined «terms», 0 :avoid violations)\n";
    0)
  else (
    if unk <> [] then (
      Printf.printf "\nUNSETTLED — Undefined «term» references (%d):\n" (List.length unk);
      List.iter
        (fun (l, t) -> Printf.printf "  %s:%d: undefined term «%s»\n" source_path l t)
        unk);
    if av <> [] then (
      Printf.printf "\nUNSETTLED — :avoid vocabulary used in normative prose (%d):\n"
        (List.length av);
      List.iter
        (fun (l, bad, owner) ->
          Printf.printf "  %s:%d: avoided word %S (see |term[%s] :avoid)\n" source_path l bad owner)
        av);
    1)

(* ---------------------------------------------------------------------------
 * 6. CLI Entrypoint
 * --------------------------------------------------------------------------- *)

let () =
  let preserve_indent = ref false in
  let out_dir = ref "gen" in
  let audit_only = ref false in
  let source = ref None in
  let args = Array.to_list Sys.argv |> List.tl in
  let rec parse_args = function
    | [] -> ()
    | "--preserve-indent" :: rest ->
        preserve_indent := true;
        parse_args rest
    | "--audit-only" :: rest ->
        audit_only := true;
        parse_args rest
    | "--out" :: dir :: rest ->
        out_dir := dir;
        parse_args rest
    | path :: rest ->
        source := Some path;
        parse_args rest
  in
  parse_args args;
  let source_path =
    match !source with
    | Some p -> p
    | None ->
        Printf.eprintf "Usage: udon_lit [--out DIR] [--preserve-indent] [--audit-only] <file.ud>\n";
        exit 2
  in
  let root = parse_udon source_path in
  if not !audit_only then (
    ensure_dir !out_dir;
    let specs = collect_tangle_specs root in
    let chunks = collect_ocaml_chunks root in
    Printf.printf "Tangling %s (%d OCaml chunks -> %d targets):\n" source_path
      (List.length chunks) (List.length specs);
    List.iter
      (fun spec ->
        let out_path, count =
          emit_tangle ~source_path ~preserve_indent:!preserve_indent ~out_dir:!out_dir spec chunks
        in
        Printf.printf "  -> %-28s (%2d chunks, projection=%s)\n" out_path count spec.projection)
      specs);
  let audit_rc = run_verisectorium_audit ~source_path root in
  exit audit_rc

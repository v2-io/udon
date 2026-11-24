(* Generated from /Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud by udon2ml.py *)
let __udon_pass = ref 0
let __udon_fail = ref 0
let __udon_run_test name f =
  try
    f ();
    incr __udon_pass;
    Printf.printf "  [PASS] %s\n" name
  with exn ->
    incr __udon_fail;
    Printf.printf "  [FAIL] %s: %s\n" name (Printexc.to_string exn)

(* UDON Part 1 AST & Observer-Set Equality — Executable Specification in UDON-OCaml *)
(** Universal Document Object Notation ([UdonAst]) Part 1 Specification.
This literate document defines the abstract syntax tree types, implicit `$root`
[document] construction, layered observer-set equality (`partitioned by`),
recursive invariant validation, and canonical transcript rendering — written
1:1 in UDON and compiled directly to OCaml via `udon2ml.py` + `ocamlc`. *)

# 9 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
module type UDON_AST = sig
  (** The consumer-facing contract for UDON Part 1 [element] and [node] values.
Following PRAXIS.md Rule 1, this signature pins down the observable AST
algebra and invariants without exposing internal sorting or traversal helpers. *)

  (** A typed value carried by an [attribute]. *)
# 14 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  type value =
    | VText of string (** Unquoted or delimited text scalar. *)
    | VInt of int (** Integer scalar. *)
    | VBool of bool (** Boolean scalar. *)
    | VNil (** Explicit nil value. *)
    | VList of value list (** Ordered list of nested [value]s. *)
    | VExplicit of {
        tag : string;
        raw : string;
      } (** An explicit angle-bracketed value `<tag:raw>`. *)
    | VElem of element (** An [element] held directly as an [attribute] value. *)

  (** An unordered named slot on an [element]. Repeated occurrences of the same
name stack into `values` in written order (`element.md` Working Notes). *)
# 33 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  and attribute = {
    attr_name : string;
    values : value list;
  }

  (** A [node] with at most one element-name, unordered [attribute]s, and
ordered child [node]s. Key (`$key`), traits (`$traits`), and sameline
text (`$main`) live as [attribute]s rather than separate record fields. *)
# 39 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  and element = {
    name : string option;
    attrs : attribute list;
    children : node list;
  }

  (** Any vertex in a UDON AST. *)
# 47 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  and node =
    | Element of element (** A structured [element] vertex. *)
    | Text of string (** A prose or text child. *)
    | Comment of string (** A comment preserved in the raw tree; invisible to `ContentOnly` equality. *)
    | Fence of {
        tag : string option;
        exact : bool;
        body : string;
      } (** A fenced verbatim block whose body is never scanned for UDON syntax. *)

  (** A parsed UDON partial: zero, one, or many root [node]s. *)
# 61 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  type partial = node list

  (** A full parsed UDON file: its sole parentless [node] is the implicit
`$root` [element], carrying file metadata as `$`-prefixed [attribute]s. *)
# 64 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  type document = {
    root : element;
  }

  (** Observer-set layers for `partitioned by` AST equality (`PRAXIS.md` Rule 2). *)
# 69 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  type eq_layer =
    | ContentOnly (** Ignores [attribute] order across distinct names and ignores [Comment] nodes. *)
    | ContentAndOrnament (** Ignores [attribute] order across distinct names, but distinguishes [Comment] nodes. *)

  (** Domain invariant violations surfaced by [validate-document]. *)
# 76 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  type violation =
    | RootNotNamedDollarRoot of string option (** The [document]'s top [element] was not named `"$root"`. *)
    | NestedRootElement (** An [element] named `"$root"` appeared beneath the document root. *)
    | EmptyAttrValues of string (** An [attribute] existed with an empty stacked value list. *)
    | UnstackedDuplicateAttr of string (** Two separate [attribute] entries shared the same name instead of stacking. *)

# 87 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  val make_document : file_path:string -> partial:partial -> document

# 88 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  val equiv_element : layer:eq_layer -> element -> element -> bool

# 89 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  val equiv_node : layer:eq_layer -> node -> node -> bool

# 90 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  val validate_document : document -> violation list

# 91 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  val count_nodes : node -> int

# 92 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  val find_by_key : string -> element -> element option

# 93 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  val element_traits : element -> string list

# 94 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  val render_node : node -> string

end

# 96 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
module UdonAst : UDON_AST = struct
  (** Reference implementation of [UDON-AST]. Every helper below is written in
UDON without tuples or raw OCaml escapes. *)

# 100 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  type value =
    | VText of string
    | VInt of int
    | VBool of bool
    | VNil
    | VList of value list
    | VExplicit of {
        tag : string;
        raw : string;
      }
    | VElem of element

# 111 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  and attribute = {
    attr_name : string;
    values : value list;
  }

# 115 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  and element = {
    name : string option;
    attrs : attribute list;
    children : node list;
  }

# 120 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  and node =
    | Element of element
    | Text of string
    | Comment of string
    | Fence of {
        tag : string option;
        exact : bool;
        body : string;
      }

# 129 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  type partial = node list

# 131 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  type document = {
    root : element;
  }

# 134 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  type eq_layer =
    | ContentOnly
    | ContentAndOrnament

# 138 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  type violation =
    | RootNotNamedDollarRoot of string option
    | NestedRootElement
    | EmptyAttrValues of string
    | UnstackedDuplicateAttr of string

  (** Wraps a [partial] into a [document]'s implicit `$root` [element],
attaching `$file` metadata as an [attribute]. *)
# 144 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let make_document ~file_path ~partial : document =
# 147 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    let file_attr = ({ attr_name = "$file"; values = [(VText file_path)] } : attribute) in
    ({ root = ({ name = (Some "$root"); attrs = [file_attr]; children = partial } : element) } : document)

  (* --- Layered Observer-Set Equality (`partitioned by`) --- *)
  (** Elementwise equality over two lists of equal length using comparator `cmp`. *)
# 160 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let rec list_equiv cmp xs ys : bool =
    (match xs with
# 163 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | [] ->
        (match ys with
# 165 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | [] -> true
# 166 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | _ -> false
        )
# 167 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | xh :: xt ->
        (match ys with
# 169 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | [] -> false
# 170 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | yh :: yt ->
            (if (cmp xh yh) then
              (list_equiv cmp xt yt)
            else
              false)
        )
    )

# 175 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let opt_string_eq a b : bool =
    (match a with
# 177 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | None ->
        (match b with
# 179 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | None -> true
# 180 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | Some _ -> false
        )
# 181 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | Some sa ->
        (match b with
# 183 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | None -> false
# 184 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | Some sb -> (sa = sb)
        )
    )

  (** Canonicalizes [attribute] order by `attr-name` so unordered comparison
reduces to exact list comparison while preserving stacked value order. *)
# 186 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let sort_attrs attrs : attribute list =
    (attrs
      |> (List.sort (fun a b -> (String.compare a.attr_name b.attr_name))))

  (** Applies the active [eq-layer] projection to an [element]'s children.
In `ContentOnly` mode, [Comment] nodes are dropped; in `ContentAndOrnament`,
every child participates in written order. *)
# 192 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let filter_children ~layer kids : node list =
    (match layer with
# 197 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | ContentAndOrnament -> kids
# 198 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | ContentOnly ->
        (kids
          |> (List.filter (fun n ->
              (match n with
# 203 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
                | Comment _ -> false
# 204 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
                | _ -> true
              )
            )))
    )

  (** Structural equality on [value]s under the chosen [eq-layer]. *)
# 206 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let rec equiv_value ~layer v1 v2 : bool =
    (match v1 with
# 209 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | VText s1 ->
        (match v2 with
# 211 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | VText s2 -> (s1 = s2)
# 212 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | _ -> false
        )
# 213 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | VInt n1 ->
        (match v2 with
# 215 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | VInt n2 -> (n1 = n2)
# 216 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | _ -> false
        )
# 217 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | VBool b1 ->
        (match v2 with
# 219 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | VBool b2 -> (b1 = b2)
# 220 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | _ -> false
        )
# 221 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | VNil ->
        (match v2 with
# 223 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | VNil -> true
# 224 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | _ -> false
        )
# 225 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | VList xs ->
        (match v2 with
# 227 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | VList ys -> (list_equiv (equiv_value ~layer:(layer)) xs ys)
# 228 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | _ -> false
        )
# 229 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | VExplicit { tag = t1; raw = r1 } ->
        (match v2 with
# 231 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | VExplicit { tag = t2; raw = r2 } -> ((t1 = t2) && (r1 = r2))
# 232 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | _ -> false
        )
# 233 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | VElem e1 ->
        (match v2 with
# 235 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | VElem e2 -> (equiv_element ~layer:(layer) e1 e2)
# 236 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | _ -> false
        )
    )

  (** Compares two [attribute]s: names must match and stacked `values` must
match in written order. *)
# 238 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  and equiv_attr ~layer a1 a2 : bool =
    ((a1.attr_name = a2.attr_name) && (list_equiv (equiv_value ~layer:(layer)) a1.values a2.values))

  (** Compares two [element]s under `layer`: same optional name, same unordered
[attribute]s, and same ordered projected children. *)
# 245 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  and equiv_element ~layer e1 e2 : bool =
# 248 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    let same_name = (opt_string_eq e1.name e2.name) in
# 249 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    let sa1 = (sort_attrs e1.attrs) in
# 250 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    let sa2 = (sort_attrs e2.attrs) in
# 251 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    let same_attrs = (list_equiv (equiv_attr ~layer:(layer)) sa1 sa2) in
# 252 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    let k1 = (filter_children ~layer:(layer) e1.children) in
# 253 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    let k2 = (filter_children ~layer:(layer) e2.children) in
# 254 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    let same_kids = (list_equiv (equiv_node ~layer:(layer)) k1 k2) in
    (same_name && same_attrs && same_kids)

# 257 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  and equiv_node ~layer n1 n2 : bool =
    (match n1 with
# 259 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | Element e1 ->
        (match n2 with
# 261 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | Element e2 -> (equiv_element ~layer:(layer) e1 e2)
# 262 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | _ -> false
        )
# 263 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | Text t1 ->
        (match n2 with
# 265 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | Text t2 -> (t1 = t2)
# 266 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | _ -> false
        )
# 267 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | Comment c1 ->
        (match n2 with
# 269 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | Comment c2 -> (c1 = c2)
# 270 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | _ -> false
        )
# 271 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | Fence { tag = t1; exact = x1; body = b1 } ->
        (match n2 with
# 273 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | Fence { tag = t2; exact = x2; body = b2 } ->
            ((opt_string_eq t1 t2) && (x1 = x2) && (b1 = b2))
# 278 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | _ -> false
        )
    )

  (* --- Recursive Invariant Validator --- *)
  (** Verifies two [attribute] invariants on a single [element]:
every attribute has at least one stacked value, and no two separate entries
repeat the same `attr-name`. *)
# 282 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let check_attr_list attrs : violation list =
# 286 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    let rec loop seen rest =
      (match rest with
# 288 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
        | [] -> []
# 289 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
        | a :: tl ->
# 290 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          let v_empty = (match a.values with
# 292 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
              | [] -> [(EmptyAttrValues a.attr_name)]
# 293 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
              | _ -> []
            ) in
# 294 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          let v_dup = (if (List.mem a.attr_name seen) then
              [(UnstackedDuplicateAttr a.attr_name)]
            else
              []) in
# 298 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          let tail_vs = (loop (a.attr_name :: seen) tl) in
          (v_empty @ (v_dup @ tail_vs))
      ) in
    (loop [] attrs)

  (** Recursively audits an [element] and its descendant [node]s. *)
# 302 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let rec validate_element is_root el : violation list =
# 304 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    let root_v = (if is_root then
        (match el.name with
# 308 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | Some n when (n = "$root") -> []
# 309 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | other -> [(RootNotNamedDollarRoot other)]
        )
      else
        (match el.name with
# 312 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | Some n when (n = "$root") -> [NestedRootElement]
# 313 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | _ -> []
        )) in
# 314 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    let attr_vs = (check_attr_list el.attrs) in
# 315 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    let val_elem_vs = (el.attrs
        |> (List.concat_map (fun a -> a.values))
        |> (List.concat_map validate_value)) in
# 319 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    let child_vs = (List.concat_map validate_node el.children) in
    (root_v @ attr_vs @ val_elem_vs @ child_vs)

# 323 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  and validate_value v : violation list =
    (match v with
# 325 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | VElem e -> (validate_element false e)
# 326 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | VList vs -> (List.concat_map validate_value vs)
# 327 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | _ -> []
    )

# 329 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  and validate_node n : violation list =
    (match n with
# 331 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | Element e -> (validate_element false e)
# 332 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | _ -> []
    )

  (** Validates all Part 1 structural invariants on a [document]. *)
# 334 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let validate_document doc : violation list =
    (validate_element true doc.root)

  (* --- Queries & Transcript Rendering --- *)
  (** Counts every vertex in an AST branch, including the branch root. *)
# 340 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let rec count_nodes n : int =
    (match n with
# 343 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | Text _ -> 1
# 344 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | Comment _ -> 1
# 345 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | Fence _ -> 1
# 346 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | Element e ->
# 347 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
        let sub = (e.children
            |> (List.map count_nodes)
            |> (List.fold_left (fun a b -> (a + b)) 0)) in
        (1 + sub)
    )

# 353 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let find_attr target attrs : attribute option =
    (List.find_opt (fun a -> (a.attr_name = target)) attrs)

  (** Extracts an [element]'s `$traits` [attribute] as a list of trait names. *)
# 356 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let element_traits el : string list =
    (match (find_attr "$traits" el.attrs) with
# 359 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | None -> []
# 360 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | Some a ->
        (a.values
          |> (List.filter_map (fun v ->
              (match v with
# 365 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
                | VText s -> (Some s)
# 366 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
                | _ -> None
              )
            )))
    )

# 368 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let has_key_q want el : bool =
    (match (find_attr "$key" el.attrs) with
# 370 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | None -> false
# 371 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | Some a ->
        (match a.values with
# 373 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | hd :: _ ->
            (match hd with
# 375 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
              | VText k -> (k = want)
# 376 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
              | _ -> false
            )
# 377 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | [] -> false
        )
    )

  (** Depth-first search for the first [element] carrying `$key = want`. *)
# 379 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let rec find_by_key want el : element option =
    (if (has_key_q want el) then
      (Some el)
    else
# 384 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      let rec search_kids ks =
        (match ks with
# 386 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | [] -> None
# 387 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          | hd :: tl ->
            (match hd with
# 389 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
              | Element child ->
                (match (find_by_key want child) with
# 391 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
                  | Some found -> (Some found)
# 392 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
                  | None -> (search_kids tl)
                )
# 393 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
              | _ -> (search_kids tl)
            )
        ) in
      (search_kids el.children))

# 396 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let rec render_value v : string =
    (match v with
# 398 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | VText s -> ("\"" ^ s ^ "\"")
# 399 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | VInt n -> (Int.to_string n)
# 400 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | VBool b -> (Bool.to_string b)
# 401 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | VNil -> "nil"
# 402 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | VExplicit { tag = t; raw = r } -> ("<" ^ t ^ ":" ^ r ^ ">")
# 403 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | VList vs ->
# 404 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
        let inner = (String.concat (" ") (List.map render_value vs)) in
        ("[" ^ inner ^ "]")
# 406 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | VElem e -> (render_element e)
    )

# 408 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  and render_element el : string =
# 409 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    let head = (match el.name with
# 411 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
        | Some n -> ("|" ^ n)
# 412 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
        | None -> "|"
      ) in
# 413 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    let attr_str = (el.attrs
        |> (List.map (fun a ->
# 417 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
            let vs = (String.concat (" ") (List.map render_value a.values)) in
            ((" :") ^ a.attr_name ^ (" ") ^ vs)
          ))
        |> (String.concat "")) in
# 420 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    let kid_str = (match el.children with
# 422 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
        | [] -> ""
# 423 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
        | ks ->
# 424 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
          let rendered = (String.concat ("; ") (List.map render_node ks)) in
          ((" { ") ^ rendered ^ (" }"))
      ) in
    (head ^ attr_str ^ kid_str)

  (** Produces a compact one-line canonical transcript of any [node]. *)
# 428 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  and render_node n : string =
    (match n with
# 431 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | Element e -> (render_element e)
# 432 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | Text s -> ("Text(\"" ^ s ^ "\")")
# 433 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | Comment c -> ("Comment(\"" ^ c ^ "\")")
# 434 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
      | Fence { exact = ex; body = b; _ } ->
# 435 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
        let flag = (if ex then
            ".exact"
          else
            "") in
        ("Fence" ^ flag ^ "(\"" ^ b ^ "\")")
    )

end

(* --- Executable Conformance Tests --- *)
# 443 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
open UdonAst

# 445 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
let mk_attr name vals : attribute =
  ({ attr_name = name; values = vals } : attribute)

# 450 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
let mk_el name attrs children : element =
  ({ name = name; attrs = attrs; children = children } : element)

# 456 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
let () = __udon_run_test "attribute-order-invariance" (fun () ->
  (* Two elements differing only in attribute declaration order must be equal
in both ContentOnly and ContentAndOrnament layers (`element.md` L25). *)
# 459 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let a1 = (mk_attr "role" [(VText "editor")]) in
# 460 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let a2 = (mk_attr "$key" [(VText "jw")]) in
# 461 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let e1 = (mk_el (Some "user") [a1; a2] [(Text "Hello")]) in
# 462 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let e2 = (mk_el (Some "user") [a2; a1] [(Text "Hello")]) in
# 463 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  assert ((equiv_element ~layer:(ContentOnly) e1 e2));
# 464 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  assert ((equiv_element ~layer:(ContentAndOrnament) e1 e2))
)

# 466 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
let () = __udon_run_test "stacked-attribute-values-preserve-order" (fun () ->
  (* Repeated values for the same attribute name preserve written order (`element.md` L46). *)
# 468 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let e1 = (mk_el (Some "item") [(mk_attr "$traits" [(VText "good"); (VText "green")])] []) in
# 469 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let e2 = (mk_el (Some "item") [(mk_attr "$traits" [(VText "green"); (VText "good")])] []) in
# 470 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  assert ((not ((equiv_element ~layer:(ContentOnly) e1 e2))))
)

# 472 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
let () = __udon_run_test "child-order-is-strict" (fun () ->
  (* A parser never reorders an element's child nodes (`element.md` L24). *)
# 474 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let e1 = (mk_el (Some "doc") [] [(Text "first"); (Text "second")]) in
# 475 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let e2 = (mk_el (Some "doc") [] [(Text "second"); (Text "first")]) in
# 476 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  assert ((not ((equiv_element ~layer:(ContentOnly) e1 e2))))
)

# 478 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
let () = __udon_run_test "layered-observer-equality-comments" (fun () ->
  (* ContentOnly ignores Comment nodes; ContentAndOrnament distinguishes them (`PRAXIS.md` Rule 2). *)
# 480 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let e_plain = (mk_el (Some "sec") [] [(Text ("Core claim"))]) in
# 484 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let e_commented = (mk_el (Some "sec") [] [(Comment ("draft note")); (Text ("Core claim"))]) in
# 489 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  assert ((equiv_element ~layer:(ContentOnly) e_plain e_commented));
# 490 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  assert ((not ((equiv_element ~layer:(ContentAndOrnament) e_plain e_commented))))
)

# 492 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
let () = __udon_run_test "document-root-and-invariants" (fun () ->
  (* A document built via make-document satisfies all invariants; mutating its root
or nesting a $root element surfaces exact violations. *)
# 495 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let user_el = (mk_el (Some "user") [(mk_attr "$key" [(VText "jw")]); (mk_attr "$traits" [(VText "admin"); (VText "active")])] [(Text "Joseph"); (Fence { tag = (Some "ocaml"); exact = true; body = "1 + 1" })]) in
# 506 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let doc = (make_document ~file_path:("spec.ud") ~partial:([(Element user_el)])) in
# 507 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  assert (((validate_document doc) = []));
# 508 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  assert (((count_nodes (Element doc.root)) = 4));
# 509 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  assert (((element_traits user_el) = (["admin"; "active"])));
  (match (find_by_key "jw" doc.root) with
# 511 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    | Some found -> (assert (equiv_element ~layer:(ContentOnly) found user_el))
# 512 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
    | None -> (assert false)
  );
  (* Now construct a deliberately broken document with 3 distinct violations *)
# 514 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let nested_root = (mk_el (Some "$root") [] []) in
# 515 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let bad_root = (mk_el (Some "not-root") [(mk_attr "empty" []); (mk_attr "dup" [(VInt 1)]); (mk_attr "dup" [(VInt 2)])] [(Element nested_root)]) in
# 523 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let bad_doc = ({ root = bad_root } : document) in
# 524 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  let vs = (validate_document bad_doc) in
# 525 "/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/spike-3-ocaml-in-udon/udon_part1_spec.ud"
  assert (((List.length vs) = 4));
  (Printf.printf ("    Rendered sample: %s\n") (render_node (Element doc.root)))
)


let () =
  Printf.printf "Summary: %d passed, %d failed\n" !__udon_pass !__udon_fail;
  if !__udon_fail > 0 then exit 1

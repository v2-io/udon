```kdl
term "root" pos=noun pl="-s" {
  avoid "root node" "for this «element»; a root «node» in the plain tree sense is any «node» with no parent, and a «partial» may give many"
  avoid "document" "the «document» is the source; the «root» is the «element» its «AST» has at the top"
  rel is-a term="element" card="{1,1}"
  rel of term="document" card="{1,1}"
}
status draft
```

# «root»
An implicit «element» with the name `$root` that is the only «node» with no parent in an «AST» generated from a full «document» containing metadata about the «document's» file (actual or asserted) as attributes, as the sole parent of the content «partial's» «AST».

## Definition
The «root» is an «element» like any other. Three things set it apart:

- **Nothing in the source writes it.** A «document» gets its «root» by being a «document»; no spelling opens it, closes it or names it.
- **Its «element-name» is `$root`.**
- **It has no parent**, and in a «document's» «AST» it is the only «node» that has none.

What it holds:

- **The «AST» of the «document's» «partial».** Every root «node» of that «partial» is inside the «root».
- **Metadata about the «document's» file**, as «attributes». The file may be an actual one or one that is asserted, as when a string is handed to a parser as a «document».

A «partial» parsed on its own has no «root».

### Auxiliary Model *(draft — pure ML/OCaml notation)*
```ocaml
(* «root» is not a separate type: it is an «element» whose «element-name» is "$root". *)
val is_root : element -> bool
(* I.e. is_root e = (name e = Some "$root") *)

(* Builds the «root» «element» from file metadata (actual or asserted) and a «partial's» «AST».
   Provisional merge lean: top-level «attribute» root «nodes» of the «partial» become «attributes»
   of `$root`, and non-attribute root «nodes» become its ordered child «nodes». *)
val make_root    : meta:(string * value) list -> partial:ast -> element
val document_ast : meta:(string * value) list -> partial:ast -> ast
(* I.e. document_ast ~meta ~partial = [ Element (make_root ~meta ~partial) ] *)
```

## Examples
- A file holding one «element» line: the «AST» is the «root», with that «element» inside it and the file's metadata as «attributes».
  ```ocaml
  (* E.g. *)
  let one_el_doc : ast =
    document_ast
      ~meta:[ ("$file", text_val "greeting.ud") ]
      ~partial:[ Element (make_element ~name:(Some "p") ~attrs:[ ("$main", text_val "Hi") ] ~children:[]) ]
  (* match one_el_doc with
     | [ Element r ] -> is_root r && List.length (children r) = 1
     | _ -> false *)
  ```
- An empty file: the «AST» is the «root» with only the file's metadata.
  ```ocaml
  (* E.g. *)
  let empty_doc : ast = document_ast ~meta:[ ("$file", text_val "empty.ud") ] ~partial:[]
  (* match empty_doc with
     | [ Element r ] -> is_root r && children r = [] && attr_values r "$file" = [ text_val "empty.ud" ]
     | _ -> false *)
  ```

## Historical Context
The opening sentence is Joseph's row in the canonical outline, 2026-11-20. His note on that row, moved here from the outline when this file was made: "def file needs to specify what metadata attributes it has (must,should,may), the behavior of how the partial's attribute nodes get merged with the root's, and children. also probably the other perspective of a pseudo-element at column position -1, and any AST notation convention we use in particular if not already described in «AST»..." Each item is in the Working Notes below.

Earlier, 2026-10-21: "I think most of the discussions have revolved around $root (or something like that) being nothing more than an element with some extra metadata attributes and an indentation column (not sure what the term we'll land on) as -1 or something..." (`.archive/v2/spec-lite-0.1.0/.int/STEWARD-VERBATIM.md`).

The Definition and Examples were drafted by a Claude Fable 5.2 session and Joseph has not read them.

## Working Notes
- Gap: which metadata «attributes» the «root» has, and for each whether a parser ‹must›, ‹should› or ‹may› supply it. Nothing is listed yet.
- Gap: how the «partial's» top-level attributes join the «root's». Lean: they become «attributes» of the «root» unchanged, and the metadata «attributes» have `$` names so that the two cannot collide.
- Gap: the «root's» child «nodes». Lean: the «partial's» root «nodes» that are not attributes, in written order.
- Gap: the other view of the «root», as an «element» written at column −1, so that everything at column 0 or deeper is inside it. Waits on how columns and nesting are defined.
- Gap: how the «root» is drawn in the «AST» notation. A provisional pure ML/OCaml auxiliary sketch and `E.g.` blocks were added above (2026-11-23, unratified) as a Thread 2 trial; waits on deciding the standing notation.
- Open: the opening sentence says "as attributes" in plain words; whether that should read «attributes».

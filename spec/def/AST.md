```kdl
term "AST" pos=noun pl="-s" {
  synonyms "abstract syntax tree"
  avoid "tree" "as a term of its own; the «AST» is the tree"
  rel made-of term="node" card="{0,N}"
  rel root-of-a-document term="root" card="{0,1}" note="exactly one when the «partial» is a «document's»"
}
status draft
```

# «AST»
The "Abstract Syntax Tree" resulting from a «partial» being parsed by a compliant parser, shown in this spec in an implementation-language agnostic notation. It is a directed acyclical graph generally with recursive and self-similar features. As a recursive structure, a branch of the AST can be considered an AST on its own. A «partial» is parsed into any number of root «nodes» (root in the tree sense); a «document's» «AST» has a single root «node», the «root».

## Definition
"AST" has its ordinary meaning: the tree a parser builds from source text. Four things are particular to «Udon's»:

- **It is what the specification pins down.** For a «partial», the «AST» is what every compliant parser gives. Two parsers are compared by comparing their «ASTs» for the same «partial».
- **A «partial» gives any number of root «nodes»**, root in the tree sense: «nodes» with no parent. It may give none, one or many.
- **A «document» gives exactly one**, the «root», and the root «nodes» of the «document's» «partial» are inside it.
- **Any branch is an «AST».** A «node» taken together with everything under it is an «AST» with that «node» as its one root «node». So an «AST» shown in this specification need not say whether it came from a «document», from a «partial» on its own, or from inside some «element».

It is the result for a «partial» that has been parsed in full. What a parser reports along the way while reading a «fragment» is not an «AST» and is not specified here.

### Auxiliary Model *(draft — pure ML/OCaml notation)*
```ocaml
(* «attribute» is given in its own definition. *)
type attribute
(* Provisional stub until «text» has its own definition. *)
type text

type node =
  | Element of element
  | Attribute of attribute
  | Text of text

(* An «AST» is an ordered sequence of zero or more root «nodes». *)
type ast = node list

(* Any single «node» together with everything under it is itself an «AST». *)
val branch : node -> ast
(* I.e. branch n = [ n ] *)

(* Content-level equality of two «ASTs»: order-sensitive over the root «nodes» that are not
   «attributes»; an «attribute» has no position (see «attribute»). *)
val equal_ast : ast -> ast -> bool
```

## Discussion
- Most «ASTs» shown in this specification are those of «partials», given as their root «nodes» with no parent drawn. That is enough, because of the fourth point above.

## Examples
- A «partial» of three lines, an attribute line and two «element» lines at the same column, gives three root «nodes».
  ```ocaml
  (* E.g. — marked restatement of the example above *)
  let partial_ast : ast =
    [ Attribute (make_attr "title" [ text_val "Notes" ]);
      Element (make_element ~kind:(Some "p") ~attrs:[] ~children:[ Text "Hello" ]);
      Element (make_element ~kind:(Some "p") ~attrs:[] ~children:[ Text "World" ]) ]
  (* List.length partial_ast = 3 *)
  ```
- The same three lines as a «document» give one root «node», the «root», with those three inside it.
  ```ocaml
  (* E.g. — same «partial» wrapped as a «document» *)
  let doc_ast : ast = document_ast ~meta:[ ("$file", text_val "notes.ud") ] ~partial:partial_ast
  (* List.length doc_ast = 1 *)
  ```
- An empty «partial» gives no «nodes».
  ```ocaml
  (* E.g. *)
  let empty_partial : ast = []
  ```

## Historical Context
The opening paragraph is Joseph's row in the canonical outline, 2026-11-20, and the model is his, the same day: "AST means AST, a partial gets parsed into any number of udon root nodes (in the tree sense), but a document's AST has a single root node, which is an element with the name $root, whose (non-meta-data) node children are the AST of the content partial." The Definition, Discussion and Examples were drafted from those by a Claude Fable 5.2 session and he has not read them.

## Working Notes
- Gap: the notation. The opening says the «AST» is "shown in this spec in an implementation-language agnostic notation"; none has been chosen. Lean: it gets its own row and segment, after «attribute» and «value» exist, because it has to show what kind of «value» something is and how it was written.
- Open: "directed acyclical graph" or "tree". If no «node» ever has two parents it is a tree, and "graph" may lead an implementer to expect shared «nodes». Lean: say tree. Joseph's wording is kept until he says.
- Open: whether every compliant parser must give the same «AST» for the same «partial» with no exceptions. The earlier quality factors called this a weight, not a veto, because "some rare contexts may unavoidably need different trees" (`.archive/v2/spec-lite-0.1.0/CTQ-FACTORS.md`, note b3). The Definition's first point is written as if there were none.
- Draft auxiliary notation (2026-11-23, unratified): provisional pure ML/OCaml signatures and `E.g.` blocks added above as a Thread 2 trial (keeping the prose examples beside them); whether this becomes the spec's standing AST notation is still open.

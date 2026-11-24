```kdl
term "attribute" pos=noun pl="-s" {
  avoid "key" "in JSON, YAML and TOML a key is the name in a name-and-value pair; here that is the «attribute-name», and the word key is kept for what says which one an «element» is"
  avoid "property" "KDL's and JSON Schema's word for the same thing"
  rel named-by term="attribute-name" card="{1,1}"
  rel has term="value" card="{1,N}" note="ordered"
  rel of term="node" card="{0,1}" note="its parent; none at the top of a «partial»"
}
status draft
```

# «attribute»
A «node» with exactly one «attribute-name» and one or more ordered «values». Its «attribute-name» is its parent's word for those «values», and a parent has at most one «attribute» of each «attribute-name».

## Definition
An «attribute» has two parts and no others:

- **An «attribute-name»**, always. It is the parent's word for what the «attribute» holds: its `author`, its `timeout`. It says what the «values» are to the parent, and nothing about what any of them is in itself.
- **Its «values»**: one or more, kept in the order they were written. They are the «nodes» directly under the «attribute».

Three things follow from the «attribute-name» being the parent's word:

- **One per name.** A parent has at most one «attribute» of a given «attribute-name». Writing the same name again on the same parent does not make a second «attribute»: the new «values» join the «attribute» already there, after the «values» it has.
- **No position.** An «attribute» is not among its parent's ordered child «nodes», and it is neither before nor after anything else its parent holds. The only order an «attribute» has is the order of its own «values».
- **No «attributes» of its own.** An «attribute» holds «values» and nothing else. One of its «values» may be an «element», which has «attributes» of its own; a «value» is never an «attribute».

An «attribute's» parent is an «element», the «root» included. At the top of a «partial» an «attribute» has no parent and is one of the «partial's» root «nodes»; the same three things hold among those root «nodes». In a «document» they are «attributes» of the «root».

The «attributes» named `$key`, `$traits` and `$main` are «attributes» in every respect given here.

### Invariants
- An «attribute» has at least one «value».
- A parser never reorders the «values» of an «attribute».
- Two «attributes» are the same when their «attribute-names» are the same and their «values» are the same, in the same order.
- Where an «attribute» was written among the other things its parent holds makes no difference to the «AST».

### Auxiliary Model *(draft — pure ML/OCaml notation)*
```ocaml
(* Abstract: an «attribute» can be observed only through `attr_name` and `values`. *)
type attribute

val make_attr : string -> value list -> attribute   (* the list is never empty *)
val attr_name : attribute -> string
val values    : attribute -> value list             (* written order *)

(* I.e. the third Invariant:
   equal_attribute a b holds iff attr_name a = attr_name b
   and values a and values b are pairwise equal in order. *)
val equal_attribute : attribute -> attribute -> bool

(* One per name, on an «element»:
   I.e. for every name k in attr_names e, the «element» e has exactly one «attribute» a
        with attr_name a = k, and attr_values e k = values a.
        For any other k, attr_values e k = []. *)

(* No position, at the top of a «partial»:
   I.e. equal_ast compares the «attributes» among two lists of root «nodes» by name,
        and the remaining root «nodes» in order. *)

(* Used by the E.g. blocks of this and the neighbouring definitions. *)
val text_val    : string -> value
val element_val : element -> value
val make_element : name:element_kind option -> attrs:(string * value) list -> children:node list -> element
```

## Discussion
- **Why one per name.** Two decisions already made force it. An «element's» «attributes» have no order among themselves, and the order of the «values» written under one name is kept. If each time a name was written made its own «attribute», two `role` «attributes» on one «element» would have no order between them and the second requirement would be lost. With one «attribute» holding both «values», the order lives inside it.
- **Why always a sequence, even for one «value».** The «AST» then has one shape whether a name was written once or five times, and a consumer that expects exactly one «value» can ask for exactly one and be told when there are none or several.
- **Why no position.** An «attribute» says what something is to its parent. A child «node» says what comes next inside it. Giving «attributes» a place among the children would make every reader of an «element's» contents step over them, and would make two «elements» differ because a writer put `:id` before or after `:class`.
- **What is given up.** Where each «attribute» was written, and how the writings of two different names were interleaved, is not in the «AST». A tool that must reproduce a source exactly needs that from somewhere else.
- **Why it is a «node».** It is a point in the tree with something above it and things below it, and at the top of a «partial» it stands with nothing above it. Nothing more is meant.

## Examples
- A `term` «element» on which `pos` was written twice and `status` once has two «attributes». `pos` has two «values» in the order written, and the same «element» results wherever `status` was written.
  ```ocaml
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
  ```
- An `author` «attribute» whose one «value» is a `person` «element», which has a `name` «attribute» of its own.
  ```ocaml
  (* E.g. — a «value» may be an «element» *)
  let person : element =
    make_element ~kind:(Some "person") ~attrs:[ ("name", text_val "Jane") ] ~children:[]

  let author : attribute = make_attr "author" [ element_val person ]
  (* attr_name author = "author"  &&  List.length (values author) = 1 *)
  ```
- A «partial» with two «attributes» and two «elements» at its top. Moving the «attributes» changes nothing; swapping the two «elements» does.
  ```ocaml
  (* E.g. — at the top of a «partial» an «attribute» has no position either *)
  let p : node = Element (make_element ~kind:(Some "p") ~attrs:[] ~children:[ Text "Hello" ])
  let q : node = Element (make_element ~kind:(Some "q") ~attrs:[] ~children:[])
  let title : node = Attribute (make_attr "title" [ text_val "Notes" ])
  let lang : node = Attribute (make_attr "lang" [ text_val "en" ])
  (* equal_ast [ title; p; lang; q ] [ lang; p; q; title ] = true
     && equal_ast [ title; p; q ] [ title; q; p ] = false *)
  ```
- The same name written twice at the top of a «partial» is one «attribute» with two «values».
  ```ocaml
  (* E.g. *)
  let tag_twice : ast =
    [ Attribute (make_attr "tag" [ text_val "a" ]); Attribute (make_attr "tag" [ text_val "b" ]) ]

  let tag_once : ast = [ Attribute (make_attr "tag" [ text_val "a"; text_val "b" ]) ]
  (* equal_ast tag_twice tag_once = true *)
  ```

## Historical Context
The word is Joseph's, 2026-10-09: "I hope it makes sense in the semantic picture why "attributes" is correct-- describing their function and as shorthand for their behavior and usage." (`.archive/v2/spec-lite-0.1.0/.int/STEWARD-VERBATIM.md`).

The parent's word, one of each, and values accumulating are his, 2026-07-15, offered as "this isn't a decision... this is still pondering": "They are labeled, where the label is the parent's perspective, not the child's perspective. That label is conserved in the sense that the parent just has one of each, and its values accumulate". The order of those values, 2026-07-12: "attribute value stacking (my vote: required standard behavior, order guaranteed to be preserved [of the values assigned to the same attribute, :'$trait' style])". Both as quoted in spec-lite's cards (`.archive/v2/spec-lite-0.1.0/def/def-attribute-name.md` and `def-stacking.md`), not read at their source.

That «attributes» are unordered, and that a «partial's» top-level ones are root «nodes», are his, 2026-11-20, in the canonical outline and in "a partial gets parsed into any number of udon root nodes".

A «value» may be an «element»: "My lean is keep" (2026-10-08). An «attribute» cannot have «attributes»: "nested attributes right now should be a reserved construction that causes an error in lite" (2026-10-08). Both from spec-lite's rule cards `rule-element-values.md` and `rule-nested-attributes.md`.

Always a sequence, with a consumer asking for exactly one, is from his 2026-10-21 message in `STEWARD-VERBATIM.md`, which he framed as wondering: "if you are generically having all attribute' values as vectors, you use the generic 'getter' -- but if you specifically expect one child (or one non-array child?) use a different function that throws an api error".

Spec-lite's cards kept each writing of a name as its own attribute and called the result «stacking». This definition has one «attribute» per name and no such term. The wording of the definition, the three consequences and the reasons in the Discussion are a Claude Fable 5.2 session's, 2026-11-24, drawn from the above; Joseph has not read them.

## Working Notes
- To confirm with Joseph: one «attribute» per name, holding every «value» written under it, in place of spec-lite's one attribute per writing. It follows from two things he has said (unordered; value order kept), and the conclusion is the session's.
- To confirm with Joseph: always a sequence. On 2026-08-09 he described the opposite shape: "Stacking behavior has always been *turns what was just a simple scalar into a list of scalars*. :$key was "the-key", not :$key = ["the-key"] unless there was a second key declared." The 2026-10-21 message is later and is the one followed here.
- To confirm with Joseph: that an «attribute's» «values» are «nodes». It follows from an «attribute» being a «node» with things under it; «value» may want to say it differently.
- Open: when two «attribute-names» are the same name. He has said a quoted name and the same name unquoted are the same (2026-07-16, as quoted in spec-lite's `def-attribute-name.md`); case and Unicode normalization are not settled. Belongs to «attribute-name» or to a rule.
- Open: what else may be attached to an «attribute» without being one of its «values», such as a comment. His 2026-10-20 words set the constraint: "I should be able to attach a comment or metadata about what line I'm on and whether it had blanks before it and the time of day right now without it changing the cardinality or arity of anything structural."
- Open: whether an «attribute» may hold no «values» at all. Written here as never; in spec-lite an attribute written with no value was an error.
- Which «values» written on a line go to which «attribute», and when a line's «attribute» is finished, are rules and are not said here.
- In the Auxiliary Model a list of root «nodes» can hold two entries for what this definition calls one «attribute» (the last Example). `equal_ast` treats the two forms as the same; the type does not prevent the first.
- The E.g. blocks compile and their comments hold against the small model in `msc/spikes/2026-11-23-ocaml/thread2-verify/`. Copying the blocks into that model's test file is still done by hand.

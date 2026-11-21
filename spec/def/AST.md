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

## Discussion
- Most «ASTs» shown in this specification are those of «partials», given as their root «nodes» with no parent drawn. That is enough, because of the fourth point above.

## Examples
- A «partial» of three lines, an attribute line and two «element» lines at the same column, gives three root «nodes».
- The same three lines as a «document» give one root «node», the «root», with those three inside it.
- An empty «partial» gives no «nodes».

## Historical Context
The opening paragraph is Joseph's row in the canonical outline, 2026-11-20, and the model is his, the same day: "AST means AST, a partial gets parsed into any number of udon root nodes (in the tree sense), but a document's AST has a single root node, which is an element with the name $root, whose (non-meta-data) node children are the AST of the content partial." The Definition, Discussion and Examples were drafted from those by a Claude Fable 5.2 session and he has not read them.

## Working Notes
- Gap: the notation. The opening says the «AST» is "shown in this spec in an implementation-language agnostic notation"; none has been chosen. Lean: it gets its own row and segment, after «attribute» and «value» exist, because it has to show what kind of «value» something is and how it was written.
- Open: "directed acyclical graph" or "tree". If no «node» ever has two parents it is a tree, and "graph" may lead an implementer to expect shared «nodes». Lean: say tree. Joseph's wording is kept until he says.
- Open: whether the order of a «partial's» root «nodes» is kept. Lean: yes for those that are not attributes, as for an «element's» child «nodes».
- Open: whether every compliant parser must give the same «AST» for the same «partial» with no exceptions. The earlier quality factors called this a weight, not a veto, because "some rare contexts may unavoidably need different trees" (`.archive/v2/spec-lite-0.1.0/CTQ-FACTORS.md`, note b3). The Definition's first point is written as if there were none.
- The Examples are in words because there is no notation yet.

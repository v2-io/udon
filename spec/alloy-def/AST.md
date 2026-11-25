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
The Abstract Syntax Tree resulting from a «partial» being parsed by a compliant parser: an acyclic, single-parent tree topology over «nodes» where any branch is itself an «AST».

## Definition
"AST" has its ordinary meaning: the tree a parser builds from source text. Four things are particular to «Udon's»:

- **It is what the specification pins down.** Two compliant parsers are compared by comparing the «ASTs» they produce for the same «partial».
- **A «partial» gives a top-level set of unordered «attributes» and an ordered sequence of child «items»** (see «partial»), with no parent «node» above them when standalone.
- **A «document» gives one single root «node»**, the «root», holding the «document's» file metadata and the content «partial's» «attributes» and child «items».
- **Any branch is an «AST».** Any «node» together with everything reachable beneath it via containment (`n.*contains`) is a well-formed «AST» on its own.

## Formal Model (Alloy 6)

`AST.md` owns only the **base sorts** (`Name`, `Kind`, `Node`, `Item`, `Text`) and the **tree topology** (`contains`, acyclicity, single-parent ownership). Each concrete kind (`Element`, `Attribute`, `Partial`, `Root`) defines its own fields and invariants in its own file.

```alloy
module udon_core

-- Nominal base sorts (distinct atoms; never conflated as raw strings)
abstract sig Name {}                     -- «attribute-name»
sig UserName extends Name {}             -- ordinary author-written attribute names
sig MetaName extends Name {}             -- `$`-prefixed system / file-metadata names

sig Kind {}                              -- «element-kind»

-- Core vertex hierarchy: every «node» is either an «item» or an «attribute»
abstract sig Node {}
abstract sig Item extends Node {}
sig Text extends Item {}                 -- provisional until «text» has its own definition

-- Direct containment edge (parent -> contained «node»)
fun contains : Node -> Node {
  (Element <: attributes)
  + (Attribute <: attributes)
  + { e : Element,   i : Item | i in e.children.elems }
  + { a : Attribute, i : Item | i in a.children.elems }
}

-- Any branch rooted at `n` is all «nodes» reachable from `n`
fun branch[n : Node] : set Node {
  n.*contains
}

fact treeTopology {
  -- Acyclic: no «node» contains itself directly or indirectly
  no n : Node | n in n.^contains

  -- Tree, not DAG: every «node» has at most one parent «node»
  -- (Toggle: dropping this single line permits shared-node DAGs.)
  all n : Node | lone contains.n
}
```

### Invariant Checks

```alloy check
-- Every branch is acyclic and contains its own root
check branchIsWellFounded {
  all n : Node | n in branch[n] and no x : branch[n] | x in x.^contains
} for 5 but 4 Int, 3 seq

-- Non-vacuity guard: the model admits a multi-level branch (Element -> Attribute -> Element -> Text)
run witnessDeepBranch {
  some e1, e2 : Element, a : Attribute, t : Text |
    a in e1.attributes and e2 in a.children.elems and t in e2.children.elems
} for 6 but 4 Int, 3 seq
```

## Discussion
- **Why `AST.md` does not list `Element`'s or `Attribute`'s fields:** In an algebraic-type block, mutual recursion forces `item`, `element`, and `attribute` into one file. In Alloy, `AST.md` states only the topology (`Node`, `Item`, `contains`, `treeTopology`), letting each term own its own structure and invariants (`PRAXIS.md` Rule 7).
- **Tree vs. DAG is one line:** Because Alloy models arbitrary graphs by default, choosing tree over DAG is explicit (`all n : Node | lone contains.n`) rather than accidental.

## Working Notes
- Open: whether a compliant parser ‹may› ever share identical sub-nodes (DAG) internally while presenting tree semantics externally. Under `PRAXIS.md` Rule 2, pure structural observer equality makes internal sharing unobservable; keeping `lone contains.n` here models the abstract value tree.
- Open: `MetaName` vs. `UserName` currently partitions `Name` cleanly at the core layer; Part 2 (`udon-kernel`) will pin down whether `$key`, `$traits`, and `$main` belong in `MetaName` or a separate `ShorthandName` subset of `Name`.

```kdl
model "udon-core"
status draft
```

# The core structure
Everything «Udon» text becomes is made of two sorts of «node». A «simple·node» holds only a value. A «complex·node» can have «attributes», in no order and at most one of each «attribute-name», and children, in order. «Elements» and «attributes» are the two kinds of «complex·node».

## The structure, in words

- **«node».** A point in the tree. Every «node» is a «simple·node» or a «complex·node».
- **«simple·node».** Holds only a value. «Text» is the one kind so far.
- **«complex·node».** Can have «attributes» and children. Either may be empty, and both may be.
  - Its **«attributes»** have no order among themselves, and it has at most one of each «attribute-name».
  - Its **children** are in order. Each child is an «element» or a «simple·node».
- **«element».** A «complex·node» with at most one «element-kind». It can be a child.
- **«attribute».** A «complex·node» with exactly one «attribute-name». It is never a child: its parent holds it among its «attributes». What an «attribute» holds is its own children and its own «attributes».
- **A tree.** Every «node» has at most one parent, and no «node» is inside itself.
- **«partial».** A «complex·node» that has no parent yet.

## Formal Model (Alloy 6)

```alloy
module udon_core

sig Name {}        -- an «attribute-name»
sig Kind {}        -- an «element-kind»

abstract sig Node {}

-- A «node» that holds only a value.
abstract sig SimpleNode extends Node {}
sig Text extends SimpleNode {}                   -- provisional; its content is left out

-- A «node» that can have «attributes» and children.
abstract sig ComplexNode extends Node {
  attributes : set Attribute,                    -- in no order
  children   : seq (Element + SimpleNode)        -- in order
}
sig Element   extends ComplexNode { kind : lone Kind }
sig Attribute extends ComplexNode { name : one Name }

-- What a «complex·node» has directly inside it.
fun inside : ComplexNode -> Node {
  attributes + { c : ComplexNode, n : Node | n in c.children.elems }
}

fact Tree {
  -- At most one parent. (Dropping this one line would allow a «node» to be shared.)
  all n : Node | lone inside.n
  -- Nothing is inside itself, at any depth.
  no n : Node | n in n.^inside
  -- A child sits at one position only.
  all c : ComplexNode | not c.children.hasDups
  -- At most one «attribute» of each «attribute-name».
  all c : ComplexNode, n : Name | lone (c.attributes & name.n)
}

-- The «complex·nodes» that have no parent.
fun parentless : set ComplexNode { { c : ComplexNode | no inside.c } }

-- A «node» together with everything under it.
fun branch[n : Node] : set Node { n.*inside }
```

### Check

```alloy check
-- Every «node» is parentless, or is under exactly one parentless «complex·node».
check UnderOneTop {
  all n : Node | no inside.n or (one p : parentless | n in p.^inside)
} for 6 but 3 seq
```

## Examples

Each is something the structure admits. The search under it finds an instance.

- An «element» whose «attribute» holds an «element», which holds a «text».
- An «attribute» with two children in order.
- An «attribute» that only groups other «attributes» and has no children of its own.
- An «attribute» with one child and one «attribute» of its own: a value with something said about it.
- An «attribute» with nothing in it.
- An «attribute» with no parent, which still has its «attribute-name».
- Two «partials» side by side. Nothing here says which comes first.

```alloy eg
run egDeepBranch {
  some e1, e2 : Element, a : Attribute, t : Text |
    a in e1.attributes and e2 in a.children.elems and t in e2.children.elems
} for 6 but 3 seq

run egTwoChildrenInOrder {
  some a : Attribute, disj t1, t2 : Text | a.children = 0 -> t1 + 1 -> t2
} for 5 but 3 seq

run egOnlyGroupsAttributes {
  some a : Attribute | no a.children and #a.attributes >= 2
} for 5 but 3 seq

run egValueWithSomethingSaidAboutIt {
  some a : Attribute | one a.children and one a.attributes and a.children.elems in Text
} for 5 but 3 seq

run egEmptyAttribute {
  some a : Attribute | no a.children and no a.attributes
} for 4 but 3 seq

run egAttributeWithNoParent {
  some a : Attribute | a in parentless and some a.children
} for 4 but 3 seq

run egTwoPartials {
  some disj e1, e2 : Element | e1 + e2 in parentless
} for 4 but 3 seq
```

## An alternative that was set aside

The «attribute-name» could be the name a parent keeps the «attribute» under, in place of something the «attribute» has. "At most one of each name" then needs no rule of its own. It was set aside because an «attribute» with no parent would have no name, and a «partial» may be an «attribute».

```alloy alt
abstract sig ComplexNode extends Node {
  attributes : Name -> lone Attribute,
  children   : seq (Element + SimpleNode)
}
sig Attribute extends ComplexNode {}
```

## Discussion
- **Why it is stated once.** The parts are defined in terms of each other, and the whole is short enough to hold in mind. An «element» and an «attribute» differ in two things only: one has an «element-kind» and can be a child; the other has an «attribute-name» and is held by name.
- **Nothing forbids an «attribute» with nothing in it.** An «attribute» that only groups others has no children, so "at least one child" cannot be required; and once that is allowed, the empty one is allowed too.
- **Order exists only among a parent's children.** Two «partials» have no order between them. Where order among the top-level things of a text comes from is for the part of the specification that says how text is read.
- **"AST" is not one of these types.** It keeps its ordinary meaning: the tree of «nodes» a parser gives.

## Historical Context
The shape is Joseph's, worked out in conversation on 2026-11-24: «attributes» that can have «attributes»; "complex node" for anything that can have both; and neither AST nor «partial» as a type ("it's just our term for a piece of an eventual AST-- with many partials essentially starting as parent-less complex nodes"). His words are in `DECISIONS.kdl`.

This file replaces four of the five definition files another agent wrote for this shadow outline the same day (`AST.md`, `partial.md`, `element.md`, `attribute.md`; the commit before this one has them). Kept from that version: the verifier and its four kinds of block, the «node» hierarchy, the one-line choice between a tree and a shared graph, and the «attribute-name» as something the «attribute» has. Changed: the structure is stated once; nothing here refers to the «root» or to a document; and names are not divided into ordinary and `$` names. The revision is a Claude Fable 5.2 session's. Joseph has not read it.

## Working Notes
- Open: «text», and the other kinds of «simple·node».
- Open, Joseph's: whether an «attribute» with nothing in it is wanted. The structure admits it and he has said this "falls out"; he has not adjudicated it. The history of the question is in `.archive/empty-attributes-chronology-2026-11-24.md`.
- Open: whether an «attribute» may have «attributes» named `$key` or `$traits`, as an «element» may. Nothing here prevents it. For Part 2.
- "Item" and "value" are not terms here. A child is an «element» or a «simple·node», and what an «attribute» holds is its children.
- The check is bounded (six of each thing, sequences up to three long).

```kdl
model "udon-core"
status draft
```

# The core structure
Everything «Udon» text becomes is made of two sorts of «node». A «simple·node» holds only a value. A «complex·node» can have «attributes», in no order and at most one of each «attribute-name», and children, in order. «Partials», «elements» and «attributes» are the three kinds of «complex·node».

## The structure, in words

- **«node».** A point in the tree. Every «node» is a «simple·node» or a «complex·node».
- **«simple·node».** Holds only a value. «Text» is the one kind so far.
- **«complex·node».** Can have «attributes» and children. Either may be empty, and both may be.
  - Its **«attributes»** have no order among themselves, and it has at most one of each «attribute-name».
  - Its **children** are in order. Each child is an «element» or a «simple·node».
- **«partial».** A «complex·node» that is nothing more than its «attributes» and its children. It is what a text read on its own gives: the text's top-level «attributes», and its top-level children in the order written. A «partial» is never inside anything.
- **«element».** A «complex·node» with at most one «element-kind». It can be a child.
- **«attribute».** A «complex·node» that its parent holds under an «attribute-name». It is never a child. What an «attribute» holds is its own children and its own «attributes».
- **A tree.** An «attribute» and a «simple·node» each have exactly one parent. An «element» has at most one. No «node» is inside itself.

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
  attributes : Name -> lone Attribute,           -- by name: at most one of each, in no order
  children   : seq (Element + SimpleNode)        -- in order
}
sig Partial   extends ComplexNode {}             -- nothing more than its attributes and children
sig Element   extends ComplexNode { kind : lone Kind }
sig Attribute extends ComplexNode {}             -- its name is the name its parent holds it under

-- What a «complex·node» has directly inside it.
fun inside : ComplexNode -> Node {
  { c : ComplexNode, n : Node | n in c.attributes[Name] or n in c.children.elems }
}

-- The «attribute-name» an «attribute» is held under.
fun nameOf[a : Attribute] : set Name {
  { n : Name | some c : ComplexNode | c.attributes[n] = a }
}

fact Tree {
  -- An «attribute» has exactly one parent, and one name there.
  all a : Attribute | one attributes.a
  -- A «simple·node» has exactly one parent, and one position there.
  all s : SimpleNode | one children.s
  -- An «element» has at most one parent, and one position there.
  -- (Loosening "one" and "lone" in these three lines is what would allow a «node» to be shared.)
  all e : Element | lone children.e
  -- Nothing is inside itself, at any depth.
  no n : Node | n in n.^inside
}

-- The «complex·nodes» with nothing above them: «partials», and «elements» taken on their own.
fun tops : set ComplexNode { { c : ComplexNode | no inside.c } }

-- A «node» together with everything under it.
fun branch[n : Node] : set Node { n.*inside }
```

### Checks

```alloy check
-- Every «node» is a top, or is under exactly one top.
check UnderOneTop {
  all n : Node | no inside.n or (one t : tops | n in t.^inside)
} for 6 but 3 seq

-- An «attribute» always has exactly one «attribute-name».
check OneNameEach {
  all a : Attribute | one nameOf[a]
} for 6 but 3 seq
```

## Examples

Each is something the structure admits. The search under it finds an instance.

- Joseph's example of 2026-11-24: a «partial» whose children are an «element» of «element-kind» `a` and then a «text», and which has one «attribute», `b`. The «element» has «attributes» and no children.
- An «element» whose «attribute» holds an «element», which holds a «text».
- An «attribute» with two children in order.
- An «attribute» that only groups other «attributes» and has no children of its own.
- An «attribute» with one child and one «attribute» of its own: a value with something said about it.
- An «attribute» with nothing in it.
- An «element» with nothing above it: a branch taken on its own.

```alloy eg
run egJosephsPartial {
  some p : Partial, e : Element, t : Text, b : Attribute |
    p.children = 0 -> e + 1 -> t
    and p.attributes[Name] = b
    and some e.kind and some e.attributes and no e.children
} for 6 but 3 seq

run egDeepBranch {
  some e1, e2 : Element, a : Attribute, t : Text |
    a in e1.attributes[Name] and e2 in a.children.elems and t in e2.children.elems
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

run egElementOnItsOwn {
  some e : Element | e in tops and some e.children
} for 4 but 3 seq
```

## An alternative that was set aside

The «attribute-name» could be something the «attribute» itself has, with a rule that no two of a parent's «attributes» share one. This is the form the other agent's version used. It reads more like a record with a name field. It was set aside because the name is the parent's word for the «attribute», and because held under a name, "at most one of each" needs no rule.

```alloy alt
abstract sig ComplexNode extends Node {
  attributes : set Attribute,
  children   : seq (Element + SimpleNode)
}
sig Attribute extends ComplexNode { name : one Name }
fact { all c : ComplexNode, n : Name | lone (c.attributes & name.n) }
```

## Discussion
- **Why it is stated once.** The parts are defined in terms of each other, and the whole is short enough to hold in mind. The three kinds of «complex·node» differ only in this: a «partial» has nothing but its contents and is never inside anything; an «element» has an «element-kind» and can be a child; an «attribute» is held under a name.
- **Why a «partial» is one of the kinds.** A text's top-level «attributes» need something to belong to, and its top-level children need something to be in order in. Without a «partial», two top-level «elements» would have no order between them.
- **Nothing forbids an «attribute» with nothing in it.** An «attribute» that only groups others has no children, so "at least one child" cannot be required; and once that is allowed, the empty one is allowed too.
- **"AST" is not one of these types.** It keeps its ordinary meaning: the tree of «nodes» a parser gives.

## Historical Context
The shape is Joseph's, worked out in conversation on 2026-11-24: «attributes» that can have «attributes»; "complex node" for anything that can have both; AST not a type. He first set «partial» aside as a type too, then brought it back the same day with the example above: "I think we might need to add partial back into the type then, depending on how pedantic we want to be." His words are in `DECISIONS.kdl`.

This file replaces four of the five definition files another agent wrote for this shadow outline that day (`AST.md`, `partial.md`, `element.md`, `attribute.md`; an earlier commit has them). Kept from that version: the verifier and its four kinds of block, the «node» hierarchy, the «partial» as its own definition, and the note on what would allow a shared «node». Changed: the structure is stated once; nothing here refers to the «root» or to a document; names are not divided into ordinary and `$` names; and the «attribute-name» is the name a parent holds the «attribute» under. The revision is a Claude Fable 5.2 session's. Joseph has not read it.

## Working Notes
- Joseph's sketch of how the example's result might be written, 2026-11-24, with his caution that "our AST notation for the spec docs [is] still … completely undiscussed and open":

  ```
  (partial)
    ├ children
    │ ├ element(kind("a") attributes(...) children([]))
    │ └ text "hello!"
    └ attributes("b" => 909)
  ```

- Open: «text», and the other kinds of «simple·node».
- Open, Joseph's: whether an «attribute» with nothing in it is wanted. The structure admits it and he has said this "falls out"; he has not adjudicated it. The history of the question is in `.archive/empty-attributes-chronology-2026-11-24.md`.
- Open: what happens to a «partial» when its text is read into a parent (a «root», or an «element» it is included under). In words: its «attributes» and children become the parent's. Not modelled here.
- Open: whether an «attribute» may have «attributes» named `$key` or `$traits`, as an «element» may. Nothing here prevents it. For Part 2.
- "Item" and "value" are not terms here. A child is an «element» or a «simple·node», and what an «attribute» holds is its children.
- The checks are bounded (six of each thing, sequences up to three long).

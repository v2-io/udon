```kdl
term "partial" pos=noun pl="-s" {
  rel has term="attribute" card="{0,N}" note="unordered top-level attributes, at most one per attribute-name"
  rel has-child term="item" card="{0,N}" note="ordered top-level child items"
}
status draft
```

# «partial»
The parsed «AST» structure of a complete «Udon» «partial»: zero or more unordered top-level «attributes» (at most one per «attribute-name») and zero or more ordered top-level child «items».

## Definition
Parsing a «partial» produces two top-level collections, matching an «element» without an «element-kind»:

- **Its top-level «attributes»**: unordered, at most one per «attribute-name», carrying user-space «attribute-names» (`UserName`).
- **Its top-level child «items»**: zero or more «items» kept in written order.

When a «partial» stands on its own (not wrapped in a «document»), none of its top-level «nodes» have a parent «node». When a «partial» is the body of a «document», its top-level «attributes» and child «items» sit directly inside the «document's» «root».

### Invariants
- A «partial» has at most one top-level «attribute» of any given «attribute-name».
- A parser never reorders a «partial's» top-level child «items».
- Two distinct «partials» do not share top-level «nodes».

## Formal Model (Alloy 6)

```alloy
sig Partial {
  attributes : set Attribute,            -- unordered top-level «attributes»
  children   : seq Item                  -- ordered top-level child «items»
}

fact partialInvariants {
  -- One top-level «attribute» per «attribute-name»
  all p : Partial, n : Name | lone (p.attributes & name.n)

  -- Top-level author «attributes» use UserName (never system `$`-metadata names)
  all p : Partial | p.attributes.name in UserName

  -- No duplicate atom in top-level children
  all p : Partial | not p.children.hasDups

  -- Top-level nodes of a Partial are parentless when standalone,
  -- or have the wrapping Document's Root as their sole parent
  all p : Partial, x : p.attributes + p.children.elems |
    contains.x = (body.p).root

  -- No node is claimed as top-level by two distinct Partials
  all a : Attribute | lone (Partial <: attributes).a
  all i : Item      | lone { p : Partial | i in p.children.elems }
}
```

### Invariant Checks

```alloy check
-- A standalone Partial's top-level nodes have no parent Node
check standalonePartialHasNoParent {
  all p : Partial | no body.p implies no contains.(p.attributes + p.children.elems)
} for 5 but 4 Int, 3 seq

-- A Partial cannot hold two top-level attributes with the same name
check partialOneAttrPerName {
  all p : Partial | all disj a1, a2 : p.attributes | a1.name != a2.name
} for 5 but 4 Int, 3 seq
```

## Examples

- **An empty «partial»** has no top-level «attributes» and no child «items».
- **A three-line «partial»** (one top-level `title` «attribute» and two `p` «elements») has one unordered attribute and two ordered children.

```alloy eg
-- E.g.: empty partial
run egEmptyPartial {
  some p : Partial | no body.p and no p.attributes and no p.children
} for 4 but 4 Int, 3 seq

-- E.g.: standalone partial with 1 top-level attribute and 2 ordered element children
run egThreeNodePartial {
  some p : Partial, a : Attribute, e1, e2 : Element |
    no body.p
    and p.attributes = a
    and p.children = 0 -> e1 + 1 -> e2
    and some e1.kind and e1.kind = e2.kind
} for 6 but 4 Int, 3 seq
```

## Working Notes
- Replaces `type ast = node list` from `spec/def/AST.md`, which allowed duplicate attribute names and gave top-level attributes a list position.
- Open: whether the English word «partial» should be split between Part 3 (source text) and Part 1 (this parsed structure).
- Open: whether top-level `$key` / `$traits` / `$main` are permitted on a «partial» (depends on whether `$`-shorthand names live in `UserName` or `MetaName`; see `AST.md` Working Notes).

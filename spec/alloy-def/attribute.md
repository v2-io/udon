```kdl
term "attribute" pos=noun pl="-s" {
  avoid "key" "in JSON, YAML and TOML a key is the name in a name-and-value pair; here that is the «attribute-name», and the word key is kept for what says which one an «element» is"
  avoid "property" "KDL's and JSON Schema's word for the same thing"
  rel named-by term="attribute-name" card="{1,1}"
  rel has term="attribute" card="{0,N}" note="unordered sub-attributes, at most one per attribute-name"
  rel has-child term="item" card="{0,N}" note="ordered child values"
  rel of term="node" card="{0,1}" note="its parent; none at the top of a standalone «partial»"
}
status draft
```

# «attribute»
A «node» with exactly one «attribute-name», zero or more unordered sub-«attributes» (at most one per «attribute-name»), and zero or more ordered child «items» (its «values»). Its «attribute-name» is its parent's word for it, and a parent has at most one «attribute» of each «attribute-name».

## Definition
An «attribute» has the exact same container structure as an «element», except that it always has an «attribute-name» instead of an optional «element-kind»:

- **An «attribute-name»** (`one Name`), always. It says what this «attribute» is to its parent, and nothing about what any of its «values» is in itself.
- **Its sub-«attributes»** (`set Attribute`): zero or more unordered «attributes» of its own, at most one per «attribute-name» (supporting concise namespacing and metadata/traits on an «attribute», such as `:distance.meters 12.3` or `:meta :author "Jane"`).
- **Its child «items» / «values»** (`seq Item`): zero or more «items», kept in the order they were written.

Two consequences follow directly:

- **One per name** on any parent («element», «partial», or enclosing «attribute»).
- **No position** among sibling ordered child «items» (because `Attribute` is disjoint from `Item`, sub-«attributes» always live in the unordered `attributes` set, never in `children`).

### Invariants
- An «attribute» has at most one sub-«attribute» of any given «attribute-name».
- A parser never reorders an «attribute's» child «items» («values»).
- An «attribute» cannot contain itself directly or indirectly (covered by `AST.md`'s `treeTopology`).
- An «attribute» may carry zero «values» (e.g., a bare flag or a namespacing «attribute» holding only sub-«attributes»).

## Formal Model (Alloy 6)

```alloy
sig Attribute extends Node {
  name       : one Name,                 -- «attribute-name»
  attributes : set Attribute,            -- unordered sub-«attributes» (<= 1 per name)
  children   : seq Item                  -- ordered child «values» (0 or more)
}

fact attributeInvariants {
  -- One sub-«attribute» per «attribute-name»
  all a : Attribute, n : Name | lone (a.attributes & name.n)

  -- No duplicate atom inside one attribute's ordered children
  all a : Attribute | not a.children.hasDups
}

-- Observer helper: look up a sub-attribute by name
fun subAttrOf[a : Attribute, n : Name] : lone Attribute {
  a.attributes & name.n
}
```

### Invariant Checks

```alloy check
-- Attributes never appear inside ordered child sequences (they live in `attributes`, not `children`)
check attributeNeverInOrderedChildren {
  all a : Attribute | no (a.children.elems & Attribute)
  all e : Element   | no (e.children.elems & Attribute)
  all p : Partial   | no (p.children.elems & Attribute)
} for 5 but 4 Int, 3 seq

-- Sub-attribute nesting is strictly acyclic (inherited from AST.md's `treeTopology`)
check subAttributeAcyclic {
  no a : Attribute | a in a.^(Attribute <: attributes)
} for 5 but 4 Int, 3 seq

-- Sub-attribute lookup is functional (at most one per name)
check subAttributeLookupIsUnique {
  all a : Attribute, n : Name | lone subAttrOf[a, n]
} for 5 but 4 Int, 3 seq
```

## Examples

- **A multi-value «attribute»** (`pos` holding two ordered «text» «values»).
- **An «element»-valued «attribute»** (`author` whose child is a `person` «element» carrying its own `name` «attribute»).
- **An «attribute» with both a sub-«attribute» and a «value»** (e.g., `:distance.meters 12.3`).
- **A value-less namespacing «attribute»** holding only sub-«attributes» (e.g., `:meta :author "Jane" :year "2026"`).
- **A bare «attribute»** with neither sub-«attributes» nor «values» (e.g., a flag).

```alloy eg
-- E.g.: attribute with two ordered text values
run egMultiValueAttribute {
  some a : Attribute, disj t1, t2 : Text |
    no a.attributes and a.children = 0 -> t1 + 1 -> t2
} for 5 but 4 Int, 3 seq

-- E.g.: attribute whose child is an element that has an attribute of its own
run egElementValuedAttribute {
  some aOuter, aInner : Attribute, person : Element |
    aOuter.children = 0 -> person
    and some person.kind
    and aInner in person.attributes
} for 6 but 4 Int, 3 seq

-- E.g.: attribute with both a sub-attribute and a value (e.g. :distance.meters 12.3)
run egSubAttributeWithValue {
  some parent, sub : Attribute, v : Text |
    sub in parent.attributes and parent.children = 0 -> v
} for 5 but 4 Int, 3 seq

-- E.g.: namespacing attribute with 0 values and 2 sub-attributes
run egSubAttributesOnly {
  some parent : Attribute, disj s1, s2 : Attribute |
    parent.attributes = s1 + s2 and no parent.children
} for 6 but 4 Int, 3 seq

-- E.g.: bare flag attribute (0 sub-attributes, 0 values)
run egBareAttribute {
  some e : Element, a : Attribute |
    a in e.attributes and no a.attributes and no a.children
} for 4 but 4 Int, 3 seq
```

## Discussion
- **Structural convergence:** Allowing sub-«attributes» and 0+ child «values» makes `Element`, `Attribute`, and `Partial` share the exact same `{ attributes : set Attribute, children : seq Item }` core. Their only structural differences are their header (`Element`: `lone Kind`; `Attribute`: `one Name`; `Partial`: none) and their placement (`Element` is an `Item`; `Attribute` is a non-`Item` `Node`; `Partial` is a top-level wrapper).
- **Sub-«attributes» remain unordered and unique by name**, so writing `:distance :unit meters :precision exact 12.3` vs. `:distance :precision exact :unit meters 12.3` produces the exact same `Attribute.attributes` set.

## Working Notes
- **Adopted Joseph's 2026-11-24 exploration directly** (allowing sub-«attributes» and dropping the "at least one value" constraint), so this shadow file diverges intentionally from the older draft in `spec/def/attribute.md`.
- Open: case and Unicode normalization rules for when two written «attribute-names» map to the same `Name` atom (belongs to `«attribute-name»` or Part 3 rules).
- Open: whether sub-«attributes» on a `Partial`'s top-level «attributes» are also restricted to `UserName` (currently only top-level `Partial.attributes` enforces `UserName`; nested sub-«attributes» are unrestricted until Part 2 pins down `$`-shorthand names like `$traits`).

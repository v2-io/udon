```kdl
term "element" pos=noun pl="-s" {
  avoid "node" "«node» is the general word for any vertex of an «AST»; an «element» is one kind of «node»"
  avoid "tag" "in HTML and XML a tag is the delimiter written in the source, not the thing it makes"
  rel has term="attribute" card="{0,N}" note="unordered, at most one per attribute-name"
  rel has-child term="item" card="{0,N}" note="ordered"
}
status draft
```

# «element»
An «item» with at most one «element-kind», any number of unordered «attributes» (at most one per «attribute-name»), and zero or more ordered child «items».

## Definition
An «element» has three parts and no others:

- **An «element-kind»** (`lone Kind`), which it may lack. An «element» with none is still an «element».
- **Its «attributes»** (`set Attribute`): everything the «element» is said to have, each under the «element's» own word for it. Because they form a set, they have no order among themselves, and at most one «attribute» carries any given «attribute-name».
- **Its child «items»** (`seq Item`): the «items» written inside it, kept in written order.

### Invariants
- An «element» has at most one «attribute» of any given «attribute-name».
- A parser never reorders an «element's» child «items».
- Two «elements» that differ only in the order their «attributes» were written have the exact same `attributes` set (order is unrepresentable on `Element`).

## Formal Model (Alloy 6)

```alloy
sig Element extends Item {
  kind       : lone Kind,                -- at most one «element-kind»
  attributes : set Attribute,            -- unordered «attributes»
  children   : seq Item                  -- ordered child «items»
}

fact elementInvariants {
  -- One «attribute» per «attribute-name» on any «element»
  all e : Element, n : Name | lone (e.attributes & name.n)

  -- No duplicate atom inside one element's children sequence
  all e : Element | not e.children.hasDups
}

-- Observer helper: look up an element's attribute of a given name (if any)
fun attrOf[e : Element, n : Name] : lone Attribute {
  e.attributes & name.n
}
```

### Invariant Checks

```alloy check
-- Every element's attribute lookup is functional (at most one Attribute per Name)
check elementLookupIsUnique {
  all e : Element, n : Name | lone attrOf[e, n]
} for 5 but 4 Int, 3 seq

-- Swapping two distinct children always yields a distinct child sequence
check childOrderMatters {
  all e1, e2 : Element, disj i1, i2 : Item |
    (e1.children = 0 -> i1 + 1 -> i2 and e2.children = 0 -> i2 + 1 -> i1)
    implies e1.children != e2.children
} for 5 but 4 Int, 3 seq
```

## Examples

- **An anonymous «element»** (`no e.kind`) with no «attributes» and two ordered child «elements».
- **A named «element»** with two distinct «attributes» and one «text» child.

```alloy eg
-- E.g.: anonymous element with two ordered child elements
run egAnonymousElement {
  some e, c1, c2 : Element |
    e not in Root
    and no e.kind
    and no e.attributes
    and e.children = 0 -> c1 + 1 -> c2
    and some c1.kind and some c2.kind and c1.kind != c2.kind
} for 5 but 4 Int, 3 seq

-- E.g.: named element with two unordered attributes and one text child
run egNamedElementWithAttrs {
  some e : Element, disj a1, a2 : Attribute, t : Text |
    e not in Root
    and some e.kind
    and e.attributes = a1 + a2
    and e.children = 0 -> t
} for 6 but 4 Int, 3 seq
```

## Discussion
- **Attribute orderlessness is structural, not an equality hack:** Unlike an OCaml `list` of `(string * value)` pairs—where you must remember to call `equal_element` instead of `=`—Alloy's `set Attribute` cannot encode distinct-attribute order at all.
- **Shimmering shorthand (`$key`, `$traits`, `$main`) stays out of Part 1:** Per `spec/canonical.outline.md` L91, shorthand spellings belong to Part 2 (`udon-kernel`) and Part 3 (`udon-syntax`), not as extra structural parts on `Element`.

## Working Notes
- Open: whether a non-`Root` `Element` may carry `MetaName` attributes directly in source (currently left open on `Element` and restricted only on `Partial` / `Document`, matching `element.md` L117).
- Open: structural value equivalence (`equivElement`) across distinct atoms with identical `kind`, attribute `(name, values)`, and child shapes—deferred until `Text` has content equality or an explicit value-sort model.

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
An implicit «element» with the `$root` «element-kind» that has no parent and is the sole top-level «node» of a «document's» «AST», holding file metadata «attributes» (`MetaName`) merged with the content «partial's» «attributes» and child «items».

## Definition
The «root» is an «element» like any other, with three distinguishing properties:

- **Its «element-kind» is `$root`** (`RootKind`), and no other «element» has that «element-kind».
- **It has no parent**, and therefore can never appear as a child of another «element» or as a «value» of an «attribute».
- **It wraps a «document's» content «partial» and file metadata**: its `attributes` are the union of the «document's» file-metadata «attributes» (`MetaName`) and the content «partial's» top-level «attributes» (`UserName`); its `children` are the content «partial's» top-level child «items» in order.

A standalone «partial» has no «root».

### Invariants
- An «element» is a «root» if and only if its «element-kind» is `$root`.
- A «root» never has a parent «node».
- Because file metadata uses `MetaName` and a «partial's» top-level «attributes» use `UserName` (disjoint subtypes of `Name`), merging the two onto `Root` can never collide on an «attribute-name».
- Every «node» in a «document's» «AST» (`branch[d.root]`) except `d.root` itself has a parent «node».

## Formal Model (Alloy 6)

```alloy
one sig RootKind extends Kind {}         -- the reserved `$root` «element-kind»

sig Root extends Element {}

sig Document {
  root : one Root,                       -- the sole top-level «node» of the document's AST
  meta : set Attribute,                  -- file metadata «attributes» (`$file`, etc.)
  body : one Partial                     -- the content «partial» wrapped by this document
}

fact rootAndDocumentInvariants {
  -- Exact correspondence between Root and RootKind
  all e : Element | e in Root iff e.kind = RootKind

  -- A Root never has a parent Node (cannot be nested as child or attribute value)
  no contains.Root

  -- Every Root belongs to a unique Document; every Partial belongs to at most one Document
  all r : Root    | one root.r
  all p : Partial | lone body.p

  -- Document metadata uses MetaName (disjoint from Partial's UserName)
  all d : Document | d.meta.name in MetaName

  -- Root's attributes merge file metadata and the content partial's top-level attributes;
  -- Root's children are the content partial's top-level children in order
  all d : Document | d.root.attributes = d.meta + d.body.attributes
  all d : Document | d.root.children   = d.body.children
}
```

### Invariant Checks

```alloy check
-- A Root can never appear inside another Element's children or an Attribute's children
check rootNeverNested {
  no e : Element   | some (e.children.elems & Root)
  no a : Attribute | some (a.children.elems & Root)
} for 5 but 4 Int, 3 seq

-- Merging Document file metadata with a Partial's top-level attributes never collides on a Name
check metaAndBodyNeverCollide {
  all d : Document | no (d.meta.name & d.body.attributes.name)
} for 5 but 4 Int, 3 seq

-- Within any Document's AST, d.root is the ONLY node with no parent
check documentHasUniqueRoot {
  all d : Document, n : branch[d.root] | no contains.n iff n = d.root
} for 5 but 4 Int, 3 seq
```

## Examples

- **A one-element «document»**: one `Root` holding one metadata «attribute» (`$file`) and one child «element» (plus a user top-level «attribute» from the wrapped «partial»).
- **An empty «document»**: one `Root` holding only file metadata and no children.

```alloy eg
-- E.g.: document wrapping a partial with one top-level user attribute and one child element
run egOneElementDocument {
  some d : Document, m, u : Attribute, e : Element |
    d.meta = m
    and d.body.attributes = u
    and d.body.children = 0 -> e
    and some e.kind
} for 6 but 4 Int, 3 seq

-- E.g.: empty file -> Root with file metadata and no children
run egEmptyDocument {
  some d : Document, m : Attribute |
    d.meta = m
    and no d.body.attributes
    and no d.body.children
} for 5 but 4 Int, 3 seq
```

## Working Notes
- Gap: which specific `MetaName` atoms (`$file`, encoding, etc.) a compliant parser ‹must› / ‹should› / ‹may› supply on `Document.meta` is not yet enumerated.
- Modeling note: stating `all p : Partial, x : p.attributes + p.children.elems | contains.x = (body.p).root` in `partial.md` together with `d.root.attributes = d.meta + d.body.attributes` here resolved a subtle tension Alloy surfaced immediately—a standalone «partial's» top-level nodes have no parent, while a wrapped «partial's» top-level nodes have `d.root` as their sole parent.

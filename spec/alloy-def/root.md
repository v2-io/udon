```kdl
term "root" pos=noun pl="-s" {
  avoid "root node" "in the plain tree sense any «node» with no parent is a root; this word is for the one a document has"
  rel is-a term="element" card="{1,1}"
}
status draft
```

# «root»
The «element» of «element-kind» `$root` that a document's text is read into, in place of a «partial». It has no parent.

## Definition
The «root» is an «element» like any other. Three things set it apart:

- **Its «element-kind» is `$root`**, and no other «element» has that «element-kind».
- **It has no parent**, and it is never a child.
- **Nothing in the text writes it.** A document's top-level «attributes» are the «root's» «attributes», and its top-level children are the «root's» children, in the order written.

A document's «AST» is its «root» and everything under it. In that «AST» the «root» is the only «node» with no parent.

## Formal Model (Alloy 6)

```alloy
one sig RootKind extends Kind {}         -- the «element-kind» `$root`
sig Root extends Element {}

fact RootIsTheTop {
  all e : Element | e in Root iff e.kind = RootKind
  no inside.Root
}

-- A document's «AST».
fun ast[r : Root] : set Node { branch[r] }
```

### Check

```alloy check
-- In a document's «AST», the «root» is the only «node» with no parent.
check OnlyTheRootIsParentless {
  all r : Root, n : ast[r] | no inside.n iff n = r
} for 6 but 3 seq
```

## Examples

- A «root» with one «attribute» and two children.
- A «root» with nothing in it, as for an empty file.
- A «root» and, beside it, a «partial» from some other text.

```alloy eg
run egRootWithContents {
  some r : Root, a : Attribute, disj e1, e2 : Element |
    r.attributes[Name] = a and r.children = 0 -> e1 + 1 -> e2
} for 6 but 3 seq

run egEmptyRoot {
  some r : Root | no r.attributes and no r.children
} for 4 but 3 seq

run egRootAndAPartial {
  some r : Root, p : Partial | some p.children and no (branch[p] & ast[r])
} for 5 but 3 seq
```

## One way file metadata could be kept

Facts about the file (its path, say) could be «attributes» of the «root» under names that ordinary text cannot use. The other agent's version of this shadow built that in, by dividing names into two sorts. It is shown here as an alternative and is not part of the model, because whether metadata lives in «attributes» at all has not been decided.

```alloy alt
abstract sig Name {}
sig UserName extends Name {}
sig MetaName extends Name {}             -- `$`-names a parser supplies
fact { all c : ComplexNode - Root | c.attributes.Attribute in UserName }
```

## Historical Context
The opening follows Joseph's row in the canonical outline (2026-11-20, reworded 2026-11-24): an implicit «element» with the `$root` «element-kind». Another agent's version of this file also modelled a document, its metadata and the merging of a «partial» into the «root»; this version keeps only what the «root» is, and depends on the core without the core depending on it. The revision is a Claude Fable 5.2 session's. Joseph has not read it.

## Working Notes
- Gap: what metadata a «root» carries, and how.
- Gap: how a document's text comes to be in a «root» where on its own it would give a «partial». In words: what would have been the «partial's» «attributes» and children are the «root's».
- Gap: the kernel form itself, and `$key`, `$traits` and `$main`.

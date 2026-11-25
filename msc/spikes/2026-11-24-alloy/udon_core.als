module udon_core

/*
 * udon-core as it stands on 2026-11-24, with attributes allowed to have
 * attributes of their own. Alloy 6. A sketch for discussion, not the spec.
 *
 * To run (the jar is the one a verisectorium spike fetched; it is not in this repository):
 *   J=/opt/homebrew/opt/openjdk/bin/java
 *   A=~/src/verisectorium/msc/scratch/spike-formal-perspectives-2026-11-10/alloy/tool/alloy.jar
 *   $J -jar $A exec -f -o alloy-out -t text udon_core.als
 */

sig Name {}        -- an attribute-name
sig Kind {}        -- an element-kind
sig Text {}        -- its content is left out here

-- Anything that holds attributes and children: a partial, an element, an attribute.
abstract sig Holder {
  attributes : Name -> lone Attribute,    -- by name: at most one of each, in no order
  children   : seq (Element + Text)       -- in order
}

sig Partial   extends Holder {}
sig Element   extends Holder { kind : lone Kind }
sig Attribute extends Holder {}           -- its name is the name its holder has it under

-- What a holder has directly inside it.
fun inside : Holder -> (Holder + Text) {
  { h : Holder, x : Holder + Text | x in h.attributes[Name] or x in h.children.elems }
}

fact OnePlaceEach {
  -- an attribute is held by exactly one holder, under exactly one name
  all a : Attribute | one attributes.a
  -- an element or a text sits at exactly one position in exactly one holder's children
  all i : Element + Text | one children.i
  -- nothing is inside itself, at any depth
  no h : Holder | h in h.^inside
}

-- It follows that everything is under exactly one partial.
assert UnderOnePartial {
  all x : Attribute + Element + Text | one p : Partial | x in p.^inside
}
check UnderOnePartial for 6 but 3 seq

-- An attribute that only groups other attributes (namespacing): no children of its own.
run Namespacing {
  some a : Attribute | no a.children and #a.attributes >= 2
} for 5 but 3 seq

-- An attribute with a child and an attribute of its own (a value with something said about it).
run ValueWithQualifier {
  some a : Attribute | one a.children and one a.attributes and a.children.elems in Text
} for 5 but 3 seq

-- An attribute holding nothing at all. Nothing here forbids it.
run EmptyAttribute {
  some a : Attribute | no a.children and no a.attributes
} for 4 but 3 seq

-- An element under an attribute, with attributes of its own.
run ElementUnderAttribute {
  some a : Attribute, e : Element | e in a.children.elems and some e.attributes
} for 5 but 3 seq

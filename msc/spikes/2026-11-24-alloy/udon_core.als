module udon_core

/*
 * udon-core as it stands on 2026-11-24 (second sketch). Alloy 6.
 * For discussion, not the spec.
 *
 * Attributes may have attributes. Neither "AST" nor "partial" is a type here:
 * an AST is a tree of these nodes, and a partial is a complex node that has
 * no parent yet (Joseph, 2026-11-24).
 *
 * To run (the jar is the one a verisectorium spike fetched; it is not in this repository):
 *   J=/opt/homebrew/opt/openjdk/bin/java
 *   A=~/src/verisectorium/msc/scratch/spike-formal-perspectives-2026-11-10/alloy/tool/alloy.jar
 *   $J -jar $A exec -f -o alloy-out -t text udon_core.als
 */

sig Name {}        -- an attribute-name
sig Kind {}        -- an element-kind

abstract sig Node {}

-- A node that holds only a value.
abstract sig SimpleNode extends Node {}
sig Text extends SimpleNode {}            -- its content is left out here

-- A node that can have attributes and children.
abstract sig ComplexNode extends Node {
  attributes : set Attribute,                    -- in no order
  children   : seq (Element + SimpleNode)        -- in order
}
sig Element   extends ComplexNode { kind : lone Kind }
sig Attribute extends ComplexNode { name : one Name }

-- What a complex node has directly inside it.
fun inside : ComplexNode -> Node {
  attributes + { c : ComplexNode, n : Node | n in c.children.elems }
}

fact Tree {
  all n : Node | lone inside.n                                    -- at most one parent
  no n : Node | n in n.^inside                                    -- nothing is inside itself
  all c : ComplexNode | not c.children.hasDups                    -- at one position only
  all c : ComplexNode, n : Name | lone (c.attributes & name.n)    -- one attribute of each name
}

-- A partial: a complex node that has no parent yet.
fun partials : set ComplexNode { { c : ComplexNode | no inside.c } }

-- Every node is a partial or is under exactly one partial, or is a text with no parent.
assert UnderOnePartial {
  all n : Node - partials | (n in Text and no inside.n) or one p : partials | n in p.^inside
}
check UnderOnePartial for 6 but 3 seq

-- An attribute with no parent still has its name.
run AttributeAsPartial {
  some a : Attribute | a in partials and some a.children
} for 4 but 3 seq

-- An attribute that only groups other attributes.
run Namespacing {
  some a : Attribute | no a.children and #a.attributes >= 2
} for 5 but 3 seq

-- An attribute holding nothing at all. Nothing here forbids it.
run EmptyAttribute {
  some a : Attribute | no a.children and no a.attributes
} for 4 but 3 seq

-- Two partials side by side: nothing here says which comes first.
run TwoPartials {
  some disj e1, e2 : Element | e1 + e2 in partials
} for 4 but 3 seq

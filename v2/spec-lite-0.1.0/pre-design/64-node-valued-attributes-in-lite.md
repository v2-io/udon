# 64 — Attributes whose value is an element ("structured attributes"): in lite, or out?

*Raised by the history survey (files 50-69), 2026-09-29, second continuation. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The question

0.10.01 lets an attribute's value **be a node**: the value of `:author` is the `|person` element written under it (§6.5, §6.8). Lite exists to stay small and stable. Does lite include node-valued attributes, or only scalar / text / list values, with structure carried by child elements?

```udon
|book :title The Craft
  :author
    |person :name Jane Doe :affiliation Acme
  :publisher |org :name Acme Press
|chapter Introduction
```

```text
document
└ element book
    title  "The Craft"
    author → element person (name "Jane Doe"; affiliation "Acme")     ; a node as the value
    publisher → element org (name "Acme Press")                       ; sameline: one-way door
    └ element chapter …                                                ; a child, positional
```

Without them, the same information is `|book` with `|author`/`|publisher` children (the XML shape) and the child-vs-attribute distinction (whose name is it? cardinality? order?) is all the model carries.

## Why lite must decide

Node values are the largest single reason the "sameline" and "value" questions are hard: they are what makes an attribute line able to open a block (`|header :k v :timeout 30` owned by the inner element, "one-way door"), what makes `:label` under `:label` a special case ("no assignment-under-assignment"), and what makes late assignments possible. Removing them from lite would dissolve much of the 01/05/74 problem space; keeping them keeps the "attributes are edges, elements are nodes, an edge may end at a node" model.

## Alternatives

### A — in lite (0.10.01 §6.8)

Full model; lite inherits the one-way door and the block-value machinery.

### B — out of lite; a `:label` followed by an indented `|element` is an error or plain text

The **udon-xml** flavor Joseph sketched on 2026-01-13: *"limited to forms that can be expressed in XML naturally — e.g., no complex elements as an attribute's value."* Lite = XML-shaped; attributes are scalar/text.

```text
element book
  title "The Craft"
  ├ text ":author\n"  or  anomaly: error, node value not in lite
```

### C — in lite, but only in the block form (`:author` then indented `|person`), not sameline (`:publisher |org …`)

Keeps the labeled-position benefit, drops the one-way-door problem. See [01](01-sameline-element-child-or-value.md).

## Where it has come up

- **Joseph, 2025-12-23** (5548-5549): attribute values are "*typed literals / scalars*"; "is it untyped or able to have arbitrary structure?"; cardinality — "you can't have more than one :tag attribute for an element (it's a hash), whereas it should be an element if order and multiplicity matter (??)".
- **`spec/msc/CHANGELOG.md` 0.8.0**: "Complex Attribute Values (structured attribute event shape) is explicitly unsettled in this version — its reconception is the headline of 0.9."
- **Joseph, 2026-07-15** (line 16325), an explicit "not a decision — pondering": *"At one point I was going to completely deprecate and remove 'structured attributes' — but almost immediately I was running into situations … where they ended up seeming uniquely useful… (1) They are labeled, where the label is the parent's perspective, not the child's; (2) that label is conserved — the parent has one of each, values accumulate however interleaved; (3) children are positional and not associated with any parent-side label… an element automatically has a hash-table available and an array available… it seems a little arbitrary to require that only the array can hold additional elements. I think the gloss in the spec was a bit overzealous."*
- **Joseph, 2026-01-13**: flavors "udon-xml" (no complex elements as attribute values), "udon-md", "udon-template" — lite is a similar carving.
- README "When to use attributes vs child elements" (whose-name-is-it test), which includes the `:author` + `|person` example as canonical.

## Sub-questions

- If out, is the attribute's value grammar then closed (scalar, text, list, `<…>`), letting the "text vs element" ambiguity on the attribute line disappear?
- Duplicate `:label` stacking (see [54](54-duplicate-keys.md)) and node values share machinery; does removing one simplify the other?
- Maps-of-maps in 0.10.01 "take a named node carrier"; if node values are out, is that carrier the only structure, and does that read as a loss for data-shaped documents?

## Interactions

[01](01-sameline-element-child-or-value.md), [05](05-values-across-lines.md), [13](13-ast-shape.md) (attribute value kinds in the tree), [54](54-duplicate-keys.md).

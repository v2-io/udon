---
kind: definition
terms: [document, root-node, meta]
state: [drafted]
per: [implied-root]
depends: []
questions: ["13", "60", "84", "89"]
max: decided
---

# document · root-node · meta

A **document** is what one lite parse produces: a tree with exactly one **root-node**, which the source never spells. Every top-level item in the source is a child of the `root-node`. The `root-node` may carry **meta** supplied by the parser rather than written in the source, such as the filename.

## Terms

- **document:** the tree one lite parse produces, together with its anomalies.
- **root-node:** the implied node every `document` has exactly one of; the source's top-level items are its children.
- **meta:** information about a node that the parser supplies or preserves, as distinct from what the node's source spells. Examples: the filename on the `root-node`, or a node's source line and column.

## Invariants

- Exactly one `root-node` per `document`; no spelling in the source opens or names it.
- A top-level element is always a child of the `root-node`, never the `root-node` itself.

## Examples

- An empty file is a `document` whose `root-node` has no children.
- A file of two top-level `|person` elements is one `document` with two children.

## Working notes

- **Decided:** the implied root, and that the root may carry metadata such as the filename (`implied-root` in `../DECISIONS.md`). The empty-file example is my reading of that decision and is not separately decided (see 89).
- **Open:**
  - whether `meta` is part of the tree or a side layer (13 Q1, 60, and the "layers of the tree" lean in STEWARD);
  - whether top-level `:label` lines become root attributes (04 Q2);
  - documents per file (84 Q1). Under option C, the "two children" example would be two documents.
- `meta` is defined here because the STEWARD leans (`same_line`; source line and column) need a word for it. If 60 lands on "meaning only", this term shrinks to parser-supplied root metadata.

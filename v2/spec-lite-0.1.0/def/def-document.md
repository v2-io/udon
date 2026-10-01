---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: [document, tree, root-node, meta]
per: [implied-root, ast-centric]
depends: []
---

# document · tree · root-node · meta

*A «document» is lite source; parsing it produces one «tree», which is what lite specifies. Every «tree» has one «root-node» that the source never spells, and a node may carry «meta» that the source does not write.*

## Terms

- **document:** a unit of lite source that parsing turns into exactly one «tree». It is what an author writes and what a parser accepts or rejects.
- **tree:** the structure one «document» parses to, which is what lite specifies. It has exactly one «root-node», and every other node in it sits beneath that «root-node».
- **root-node:** the node at the top of every «tree». It is implied: no spelling in the «document» opens, closes, or names it. The «document»'s top-level items are its children, in order.
  - *Distinct from* the addressing theory's root-scope ([[references/def:scope]]), a scope with no enclosing scope. Lite defines no addressing, so how the two relate is not lite's to state.
- **meta:** information attached to a node in the «tree» that the «document» does not spell, such as the filename a parser attaches to the «root-node».

## Invariants

- A «document» and its «tree» are different things, so two «document»s spelled differently can be compared by their «tree»s. Which pairs have the same «tree» is for the rules to say.
- Nothing spelled in a «document» becomes the «root-node». A top-level element is a child of the «root-node», whatever its name.
- «meta» is never spelled. A top-level `:label` line is spelled, so it is never «meta», wherever the «tree» puts it.

## Examples

- A «document» whose only top-level element is named `document`: its «root-node» has one child, an element named `document`, which has a child of its own.

  ![[dat/implied-root.yaml#root_is_never_spelled]]

- A parser reading `notes.udon` may attach the filename `notes.udon` to the «root-node» as «meta». A `:title Notes` line at the top of the same file is not «meta».

## Discussion
- **«document» means the source, not the «tree»,** because that is how the rest of the spec store uses the word: "any «document» a lite parser accepts produces the same tree" ([[obj:reserve-dont-ignore]]), "no accepted «document»'s tree changes" ([[prop:forward-stability]]), and 84's "documents per file". A «document» that *is* its «tree» could not have one. If those uses change, this choice should be revisited.
- **root-scope is written in plain words** with a cross-store link to its record ([[references/def:scope]], per [[sop/decision:cross-store-links]]), so it can't be mistaken for a «…» term of this store. `depends:` doesn't list it, because this record only distinguishes itself from root-scope and uses none of its text.

## Cautions

- In the text notation that the pre-design files and fixtures use, the «root-node» is the first line of each tree, printed `document`. That line names the node after the «document» it belongs to; it is not the «document».

## Working notes

- **Awaiting the udon team's decider:** «document» is defined here as the source, not the parse result, and that choice of meaning is theirs.
- **`per:` cites seeded decisions that are not ADRs yet** (`.old/vsect-init/DECISIONS.md`), so those entries dangle until the udon team converts them.
- **Open questions** bearing on these terms: 84 Q1, 13 Q1, 60, 04 Q2.

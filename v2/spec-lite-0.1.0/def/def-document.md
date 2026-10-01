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

## Why

- **«document» means the source, not the «tree»,** because that is how the rest of the spec store uses the word: "any «document» a lite parser accepts produces the same tree" ([[obj:reserve-dont-ignore]]), "no accepted «document»'s tree changes" ([[prop:forward-stability]]), and 84's "documents per file". A «document» that *is* its «tree» could not have one. If those uses change, this choice should be revisited.
- **Anomalies are left out of these terms.** Parsing also yields a list of anomalies: the fixtures record them beside the tree, and [[prop:determinacy]] says "one tree and one anomaly list". Their place belongs to [[def:anomaly]], not to the definition of «tree».
- **root-scope is written in plain words** with a cross-store link to its record ([[references/def:scope]], per [[sop/decision:cross-store-links]]), so it can't be mistaken for a «…» term of this store. `depends:` doesn't list it, because this record only distinguishes itself from root-scope and uses none of its text.

## Cautions

- In the text notation that the pre-design files and fixtures use, the «root-node» is the first line of each tree, printed `document`. That line names the node after the «document» it belongs to; it is not the «document».

## Working notes

- **Open questions that bear on these terms** (numbers are files in `.int/pre-design/`):
  - **84 Q1, documents per file.** «document» is defined so that every answer fits: one per file (A), split by a separator (B), or one per top-level element (C). Under C, a file of two top-level elements is two «document»s with two «tree»s, not one «root-node» with two children.
  - **13 Q1, 84 Q4, 60: where «meta» lives.** Whether it is part of the «tree» like attributes, a side layer, or kept apart from anything spelled. The term does not depend on the answer; what the «tree» holds does.
  - **60, and the STEWARD lean on node metadata.** Only the «root-node»'s «meta» is decided (`implied-root`). The lean in `STEWARD-2026-09-29.md` would give every node «meta» (source line and column, span, `same_line`). If 60 settles on "meaning only", «meta» covers only what the parser supplies, such as the filename. Either way the definition stands; only what it covers changes.
  - **04 Q2, top-level `:label` lines.** If they become attributes of the «root-node» (option B), 13 Q1 asks whether they are kept apart from parser-supplied «meta». The third invariant says they are different things in either case.
  - **Empty input.** Whether an empty file is a «document» (with a «root-node» and no children) or no «document» at all is recorded as the descriptive fixture case `root_empty_input`, which names 89 as its nearest home. 89 does not list empty input among its forms, so no question file asks it yet.
  - **Anomalies in or beside the «tree».** No question file asks it. It belongs with [[def:anomaly]] and question 12.
- **Where the edge between «meta» and ornament falls** is for [[def:ornament]]. The STEWARD lean orders the layers as "content < content+meta < content+meta+ornament". Source line and column read as «meta» there; spacing and list spelling as ornament. Unverified until that record is drafted.
- **Awaiting the udon team's decider** (`awaiting-decision: true`, [[sop/decision:decider-per-store]]): «document» was redefined here as the source rather than the parse result, and that change of meaning is theirs to confirm. The flag describes only this record ([[sop/decision:flags-describe-own-record]]).
- **`per:` cites decisions that are not ADRs yet.** `implied-root` and `ast-centric` are seeded decisions, rendered in `.old/vsect-init/DECISIONS.md` from Joseph's 2026-09-29 statements. Converting them into `adr/` records is the udon team's. Until then both entries dangle. They are kept as the seed's slugs, not a path to the rendering, so the citation goes live when the ADRs are written. That this record rests on unconverted decisions is derived from `per:`, not carried in its flags.

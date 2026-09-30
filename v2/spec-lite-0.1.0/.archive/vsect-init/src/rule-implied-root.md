---
kind: rule
layer: tree
state: [drafted]
per: [implied-root, ast-centric]
depends: []
questions: ["04", "13", "84", "89"]
fixtures: ../fixtures/rule-implied-root.yaml
max: decided
---

# The implied root node

*Every lite document has exactly one root node, which the source never spells; everything at the top level is its child.*

## Statement

1. A lite parser MUST produce exactly one `root-node` for each `document`.
2. Every top-level item in the source (element, text, comment) MUST be a child of the `root-node`, in source order.
3. No spelling in the source opens, closes, or names the `root-node`. A top-level element named `document` or `root` is an ordinary child.
4. A lite parser MAY attach `meta` to the `root-node` that is not written in the source, such as the filename.

## Open parts, not decided here

- **Representation of root `meta`.** Part of the tree, a side layer, or kept apart from anything written in the file (13 Q1, 84 Q4, 60)?
- **Top-level text indentation** (04 Q1). Does the root behave like any element (the first text line sets the base), start at column 0, or strip per line?
- **Top-level `:label` lines** (04 Q2). Warning plus text (0.10.0 L1), or attributes of the `root-node`? Clause 2 is written so that either answer fits.
- **Documents per file** (84 Q1). Under 84's option C, "several top-level elements are several documents"; that would change clause 1's "for each document" from "per file" to "per top-level element".
- **Empty input** (89). The fixtures record my reading (a root with no children) as descriptive, not canonical.

## Grounds

- Decisions `implied-root` and `ast-centric` in `../DECISIONS.md` (Joseph, 2026-09-29, as recorded in `../influx/README.md`).
- History: 2011 udon-c had an implied root (ID = file path, `:__` metadata). Dec 2025 – Jul 2026 held the opposite ("no implicit root wrapper", for streaming, fragments, and multi-root; `design/udon-ast.md`). The 2026-09-29 decision answers those reasons. Source: `../influx/pre-design/70-survey-index.md` §04.
- **Append-safety (68) depends on this rule staying as written.** A new top-level block appended at EOF becomes one more child, and nothing above it has to be re-closed. That holds only while clause 3 keeps any spelled root from being required.

## Epistemic status

Rule; `max: decided`. Its truth-apt neighbors are checks, not this text: every canonical fixture must parse to one root (fixture agreement, once a parser exists), and no other rule may create a second root (consistency, checked as rules land). Neither check has run.

## Explanation

*(Teaching prose. It describes the statement and never adds to it.)*

Think of the file itself as the outermost element. You never write it; it is always there, and whatever you write at the left margin goes inside it. If you write `|document` at the top, you have not named the root. You have made a child that happens to be called `document`.

## Working notes

- The counter fixture `root_is_never_spelled` is the one most likely to catch a converter that treats a single top-level element as the root (the vivarium `<name>.<root-element-type>.udon` convention does exactly that; see 70-survey §04).

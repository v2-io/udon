---
family: lite
version: 0.1.0
---
# *Specification*: UDON Lite
***The non-dynamic subset of UDON***

**The spec store's main outline.** It has almost no rows yet, on purpose. Lite's records, their names, and how they are grouped are the udon team's to decide. The rows below were written from the SOP side only to show the process: how a row, a record and an outline relate ([[sop/decision:our-side-is-example]]). They are not a proposal of lite's content. How work is done in this corpus is in the SOP store, starting at [`sop/main.outline.md`](sop/main.outline.md).

| Column | Meaning |
|---|---|
| Row-type | `example`: a drafted sample showing a record done to the SOPs; it never lands as it stands. `proposed`: a candidate record, usually with no document yet. The others (`gap`, `template`, `exploratory`, `landed`) are in [[sop/conv:row-type]]. |
| Record | `[[kind:slug]]`, resolved through [`.vsect/kinds.yaml`](.vsect/kinds.yaml). |
| Statement | This view's one-line gloss. For a row with no document, the question its record has to answer. |

This view shows no ※ or ∂ columns until a linter exists to compute them ([[sop/decision:no-computed-columns-yet]]).

---

## Examples

| Row-type | Record | Statement |
|---|---|---|
| example | [[obj:reserve-dont-ignore]] | Any «document» a lite parser accepts produces the same «tree» under every future full version |
| example | [[prin:simplest-grammar-without-surprise]] | Among alternatives that meet the objectives, prefer the simpler grammar or rules, unless it violates least surprise |
| example | [[def:document]] | «document», «tree», «root-node», «meta»: the source, what it parses to, the implied root, and parser-supplied information about nodes |
| example | [[def:typed-value]] | «typed-value» (explicit `<…>` / implicit bare), «type-label» |
| example | [[rule:implied-root]] | Exactly one «root-node», never spelled; top-level items are its children in order; it may carry «meta» |
| proposed | [[prop:forward-stability]] | Do lite's rules meet [[obj:reserve-dont-ignore]]: no accepted «document»'s tree changes under a full parser? |

---

## *Why*

- **What the rows show.**
  - One record of each of five kinds (objective, principle, two definitions, rule), each written to the SOPs, plus a fixture file, [[fixture:implied-root]], which no outline lists.
  - One `proposed` row with no document. [[obj:reserve-dont-ignore]] links to it, and the link resolves to this row, so a linter reports it as *unwritten* rather than as an error ([[sop/decision:links-to-unwritten-records]]).
- **What the `example` records show on purpose.**
  - `per:` cites seeded decisions that are not ADRs yet (`.old/vsect-init/DECISIONS.md`); converting them is the udon team's.
  - The objective's `force` is present and empty: setting it is the udon team's.
  - Open questions sit in each record's working notes, by pre-design number (`.int/pre-design/`).

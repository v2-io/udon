---
family: lite
version: 0.1.0
---
# *Specification*: UDON Lite
***The non-dynamic subset of UDON***

## Working on UDON Lite Specification

How this corpus is worked (record kinds, their fields, row-types, references, decisions, and how outlines like this one work) is in the SOP store, which has its own outline: [`sop/main.outline.md`](sop/main.outline.md). Start there to learn the conventions used below.

### Legend / Key
| Column | Meaning |
|---|---|
| Row-type | `example`: a drafted sample showing a record done to the SOPs; it never lands as it stands. `proposed`: a candidate record, usually with no document yet. The others (`gap`, `template`, `exploratory`, `landed`) are in [[sop/conv:row-type]]. |
| Record | `[[kind:slug]]`, resolved through [`.vsect/kinds.yaml`](.vsect/kinds.yaml). |
| Statement | This view's one-line gloss. For a row with no document, the question its record has to answer. |

This view shows no ※ or ∂ columns until a linter exists to compute them ([[sop/decision:no-computed-columns-yet]]).

### Example Documents

| Row-type | Record | Statement |
|---|---|---|
| example | [[obj:reserve-dont-ignore]] | Any «document» a lite parser accepts produces the same «tree» under every future full version |
| example | [[prin:simplest-grammar-without-surprise]] | Among alternatives that meet the objectives, prefer the simpler grammar or rules, unless it violates least surprise |
| example | [[def:document]] | «document», «tree», «root-node», «meta»: the source, what it parses to, the implied root, and parser-supplied information about nodes |
| example | [[def:typed-value]] | «typed-value» (explicit `<…>` / implicit bare), «type-label» |
| example | [[rule:implied-root]] | Exactly one «root-node», never spelled; top-level items are its children in order; it may carry «meta» |
| proposed | [[prop:forward-stability]] | Do lite's rules meet [[obj:reserve-dont-ignore]]: no accepted «document»'s tree changes under a full parser? |

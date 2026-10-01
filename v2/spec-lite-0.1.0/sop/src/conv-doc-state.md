---
kind: convention
awaiting-second: true
awaiting-decision: false
needs-work: true
per: [doc-state-conforms]
depends: [def:outline, def:record-kinds]
---

# Doc-state

*∂(doc-state) is computed: `missing` · `drafted` · `conforms`. It is exhaustive and recomputed, not a ladder. Later checks sit beside it as separate flags.*

## Statement

- ⟦doc-state⟧ is computed for every row that should have a document:
  - `missing`: no document;
  - `drafted`: a document exists but does not conform to its kind's format;
  - `conforms`: a document exists and conforms.
- Rows that have no document by their nature (`gap`) show `—`.
- It is recomputed on every run and moves in both directions. An edit that breaks conformance moves a row back to `drafted`, which reports a fact and is not a demotion.
- "Conforms" means format-conformant for the row's ⟦kind⟧: the frontmatter fields the kind requires, and its sections in the kind's order (see [[conv:record-cadence]]).
- A further check (links resolve, fixtures pass) becomes its own flag beside doc-state, never another value of it.

## How a violation shows

A hand-typed doc-state; a doc-state value outside the three; a check folded into doc-state as a fourth value.

## Discussion

- Joseph: "either the doc is missing, written but not necessarily formatted correctly, or written and formatted correctly. What am I missing?" and "let's just change it to 'conforms'" (`sop/influx/jaw-proposal-and-feedback.md` §1.2).

## Working notes

- `needs-work: true`: "conforms" needs a per-kind format list the linter can check. [[conv:record-cadence]] holds the first version. Each kind's required fields are now in `.vsect/kinds.yaml` (`requires:`, in both stores); its required sections are not yet.

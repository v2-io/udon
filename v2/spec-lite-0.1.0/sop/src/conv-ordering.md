---
kind: convention
awaiting-second: true
awaiting-decision: false
needs-work: false
per: [order-lint]
depends: [conv:outline, def:record-fields]
---

# Outline order against dependencies

*Undecided for this project. How rows are ordered is partly concern 2 and partly concern 3. This record holds the candidate practice until a linter needs it.*

## Statement (candidate; the decision is open)

- **Concern 3.** For rows that have documents, ∂(order) would check the outline's order against the partial order given by each record's ⟦depends⟧. A row placed before something it depends on would be flagged.
- **Concern 2.** The outline authors two things itself:
  - a deliberate forward reference, which needs a marker on the row;
  - the order of rows that have no document yet (gaps, undrafted proposed rows), since there is no canonical order to check them against.
- **Until this is decided:** order rows by dependency where it's known, and mark any deliberate forward reference in the row's text.

## How a violation shows

A row with a document placed before a row it ⟦depends⟧ on, with no forward-reference marker. Until a linter exists and this is decided, only a reader can find it.

## Why

- Joseph: "Order linting can be considered possibly 2nd concern or 3rd concern or a little of both-- depending on whether or not 'depends-on' or 'prerequisites' or something is in the segments generally" (`sop/influx/jaw-proposal-and-feedback.md` §1.1).
- On this project: "undecided for now-- you can leave it open until we have enough to start needing the outline linter working" (§1.7, item 6).
- ASF's `lint-outline` (`~/src/arch/asf/bin/`) already checks outline order against `depends:`. It is the nearest working precedent.

## Working notes

- The forward-reference marker isn't chosen. When the linter is built, pick one that is cheap to type and easy to grep.

---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "The SOP store's decisions follow the revised decision template"
status: accepted
decided-by: supported
decided: "2026-09-30"
updated: 2026-09-30
deciders: ["aat-refactored coordinator (agent, Opus 5.5), under delegated authority (setup-delegated-to-coordinator)"]
consulted: [spec-lite fork (agent, Opus 5.5)]
informed: [Joseph (steward)]
wording: verbatim
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: []
---

# The SOP store's decisions follow the revised decision template

## Context and Problem Statement

The decision template (`adr/TEMPLATE.md`) was revised on 2026-09-30. It adds the three flags; drops `affects` (mostly empty, otherwise partial and unresolvable) and `drivers-cite` (it duplicated the Drivers links); and moves the reopening reminder after the Reopen-when list. The SOP store's 26 earlier decisions used the earlier template.

## Decision Drivers

* One decision shape across both stores.

## Assumptions

* None recorded.

## Considered Options

* Bring the existing SOP decisions into line with the revised template (chosen)
* Leave them, and apply the template only to new decisions

## Decision Outcome

Chosen: the SOP store's decisions follow the same template as the spec store's, and the 26 existing ones are brought into line:

- the three flags are added: `awaiting-second: true` on all, since no one but their author has checked them yet; `awaiting-decision` false where Joseph decided, true where ratification is pending; `needs-work: false`;
- `affects` and `drivers-cite` are dropped, and their content moves into "What changes" where it carried any;
- the reopening reminder moves after the list.

Outcomes are not edited.

Made under the authority Joseph delegated on 2026-09-30 ([[decision:setup-delegated-to-coordinator]]). It is in force, and awaits his ratification.

### Quote

> If you are looking at everything holistically and thoughfully to be an exemplar for moving the udon work forward which will move verisectorium and the agentic systems framework / theory forward-- I am happy to defer to you for the rest of those and other decisions related to the setup. Just mark decisions as made by you from authority given from me and as still needing ratification (where applicable)
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11)

*How this meets the exemplar condition of the delegation: it holds the SOP store to the template Joseph asked for, and leaves every Outcome untouched so ratification can trust them. The second look checked that for 22 of the 26 (`sop/influx/adr-check-notes.md`).*

### Positive Consequences

* A reader learns one decision shape.

### Negative Consequences

* Edits to accepted records, limited to form and never to outcome.

### What changes

* All 26 earlier records in `sop/adr/` are reformatted.

## Pros and Cons of the Options

### Bring into line (chosen)

* Good, because the flags matter most on the oldest records.

### New only

* Bad, because two shapes would coexist indefinitely.

## Reopen when

* Joseph declines to ratify it.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes


---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Column headers mark ※ (from frontmatter) and ∂ (derived); cells use — · ∅ · ⚠; each view chooses its columns"
status: accepted
decided-by: steward
decided: "2026-09-30"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: [aat-refactored coordinator (agent, Opus 5.5), spec-lite fork (agent, Opus 5.5)]
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: []
---

# Column headers mark ※ (from frontmatter) and ∂ (derived); cells use — · ∅ · ⚠; each view chooses its columns

## Context and Problem Statement

Some outline columns are copies of or computations from canon data and must never be hand-edited. The first proposal was a 🔒 header marker. Joseph noted that a lock doesn't say whether the value comes from frontmatter or from elsewhere (`sop/influx/jaw-proposal-and-feedback.md` §1.1–§1.3, §1.8).

## Decision Drivers

* A reader can tell at a glance which cells are authored and which are generated.
* Distinguish "doesn't apply" from "applies but missing" from "couldn't check".

## Assumptions

* None recorded.

## Considered Options

* 🔒 on read-only headers (Joseph's first idea)
* ※ / ∂ markers (chosen)

## Decision Outcome

Chosen:

- **Headers:** `※(Field)` for a value taken straight from that frontmatter field; `∂(Field)` for a value derived by the linter or vsect, of which ※ is a simplified special case; no marker for columns authored in the outline.
- **Columns are the view's choice.** Each table surfaces the ※ and ∂ columns it wants for easy inspection. Whether a field exists and is measured is a separate question.
- **Cells the linter writes:**
  - `—` where the column doesn't apply to the row's type or kind;
  - `∅` where it applies but is missing;
  - `⚠` where it applies but its inputs couldn't be read (e.g. unparseable frontmatter, or a `per`/`depends` target that doesn't resolve).

### Quote

> Instead of the lock, let's use ∂(Field Name) for derived by the linter and ※(Field Name) for anything that comes from that field name in the frontmatter (a special simplified case of derived). … It's up to the outline / view to decide which ∂ and ※ it wants to surface as a column for *easy inspection* -- which is distinct from whether or not they actually *exist* and are measured etc. etc. … The outline linter / vsect should write a — or something for cells of a row-type or row-kind where the calculated column is not applicable, and a ∅ when it is *applicable* for that kind, but missing...
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.2–§1.3)

*`⚠` was proposed by the fork and accepted by Joseph ("5- sounds good", §1.8), so that part of this decision is `ratified` rather than `steward`.*

### Positive Consequences

* Hand-editing a ※ or ∂ cell becomes a detectable lint failure.
* An unshown field is never mistaken for an absent one.

### Negative Consequences

* Three cell marks to learn.

### What changes

* Outline headers in both stores gain ※ / ∂ markers.

## Reopen when

* A column turns out to be partly authored and partly derived.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes


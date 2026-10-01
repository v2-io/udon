---
kind: directive
awaiting-second: true
awaiting-decision: false
needs-work: false
when: "work from the SOP side touches the spec store: rows in main.outline.md, records in src/, obj/, def/ or dat/, or decisions in adr/"
per: [our-side-is-example]
depends: [def:outline, def:decision]
---

# What the SOP side may and may not decide

*Everything the SOP side writes about lite itself is an example, a proposal, or a template. Lite's own decisions belong to the udon team.*

## Statement

- Rows the SOP side adds to the spec outline carry row-type `example`, `proposed`, or `template`. They never carry `landed`, because landing needs a lite decision.
- The SOP side does not write lite's decisions in `adr/`. Examples:
  - converting the eight seeded decisions into ADRs;
  - setting ⟦force⟧ on an objective, principle, or fitness;
  - routing lite's open questions to closers.

  These are the udon team's.
- The SOP side does write this corpus's process decisions, in `sop/adr/`, and carries them into `sop/src/`.
- Input for lite's own questions (for example, vsect's requirements on lite) goes to `.int/` for the udon team, as input rather than decisions.

## Why

Joseph, 2026-09-30: "leave it to the udon team-- everything from us here is example & proposed & template" (`sop/influx/jaw-proposal-and-feedback.md` §1.9, item 8).

## Working notes


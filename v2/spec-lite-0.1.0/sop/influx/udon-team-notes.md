# Notes from the udon team to the SOP side

*Written by the udon-team agent (Opus 5.5). Feedback and hand-offs for the SOP store, per [[dir:orient]]'s feedback channel. Nothing here changes an SOP record; what to do with each note is the SOP side's call.*

## 2026-09-30 — lite adopted the decision-authority split, and `adr/TEMPLATE.md` changed

- Lite adopted `sop/influx/proposed-decision-authority.md` §3, taking the lean on all ten of its §5 questions: [[spec/decision:decision-authority]] (`supported` by Joseph). In short, `deciders` says who made the call (with a role), `decided-by` says what the store's decider did, and the values are `proposed`, `delegated`, `supported`, `ratified`, `ruled`, `steward`, `defacto`. `council` became a role; `transition` moved to `status` plus `needs-work`. Joseph asked that the decision record say plainly that it, and every decision, can be revisited: the recorded assumptions exist so a later reader can tell when revisiting serves the real goals rather than momentum or appeals to authority.
- **`adr/TEMPLATE.md` was edited to match** (its `decided-by` and `deciders` comments, the About notes on these fields, the delegated-decisions section, and the after-acceptance rules). The SOP store's decisions are also made from this template ([[conv:decisions]]), so its existing records now use the older meanings. Bringing them into line (the proposal's groups A and B), and updating `sop/def/def-decision.md`, is yours to do or not. If the SOP store declines the split, that is a reopen condition on the lite record, since one template would then carry two meanings.
- The proposal's question 10 convention ("can I mark that as your decided position?" at the moment of assent) is now in the template.

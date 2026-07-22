# Recognition traces — value-acquisition flight manual

Exploratory materials for the “push harder” area: **Line Scan, bare-token boundary, ownership, Content Phase, node one-way door**, plus a few greenfield pins (multi-line, root attr).

| File | Role |
|------|------|
| [00-event-model.md](00-event-model.md) | Hypothetical streaming event vocabulary (**not** a wire proposal) |
| [snippets.udon](snippets.udon) | Pack of cases (`; --- id: Txx ---`) |
| [expectations.md](expectations.md) | Per-case expected streams, mermaid, uncertainty notes |

## How to use

1. Skim the event model (5 minutes).  
2. Pick a case from the priority table at the bottom of `expectations.md`.  
3. Cover the expectation, parse the snippet cold, then compare.  
4. File disagreements as notes — best fuel for CORE tightening.

These traces are **more interesting than authoritative**. Where they conflict with [../../new-spec/CORE.md](../../new-spec/CORE.md), either the trace is wrong or we found a contract hole — both outcomes are useful.

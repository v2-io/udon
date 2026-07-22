# Steward flags — review findings that need Joseph, not an editor

*Collected from the cross-substrate review round (2026-07-22) so the
review pass sees them in one place. None applied to the suite; each is a
ruled or steward-tier matter.*

## 1. agy #1 — "Structure Position" / "Line Scan" as parser-jargon bleed

**agy's argument (Gemini, HIGH):** the canonical names expose
state-machine semantics ("scan," "position") in author-facing spec text,
against defining-udon Part 1's isolation principle ("never let parser
implementation jargon bleed into the outer layers"); an author being told
they are in a "Line Scan" is a leaky abstraction. Suggested
author-centric alternatives: "Element Definition Phase," "Inline Context."

**Why not applied:** both names are ledger-ruled — DECISIONS **N-pos**
("canonical name for recognition state: Structure Position") and
**N-scan** ("canonical name: Line Scan"), 2026-07-21. Overturning a ruled
naming is yours. The tension is real, though: the ruling chose 3b's names
for cross-suite consistency; agy is measuring against defining-udon's
isolation bar, which nobody explicitly weighed at ruling time. If
overturned, the suite-wide rename is mechanical (GLOSSARY + ~20 sites).

## 2. agy #3 — default indentation unit for generators (IND)

**agy's argument (MEDIUM):** without a spec-named default unit, different
tools choose different defaults and files thrash indentation under
multi-agent editing. Suggests SHOULD 2-space for automated generation
while humans stay free.

**Why not applied:** this is exactly OPEN item **IND**, explicitly waiting
on editing-tool demand. agy's tooling-thrash scenario is good *demand
evidence* for the IND row (it is the same multi-writer-stability concern
as the scenarios-corpus evidence already cited there) — attached here for
when you rule it, not applied as law.

## 3. grok D3 — third-party support for deferring the grammar pillar

defining-udon nominally wants a formal-grammar pillar; this suite defers
it (Nesting Rule + extent taxonomy + bare-token boundary carried in CORE
prose). grok's independent position: correct call — "hold the grammar
document until the dialects spike settles capture sugar (ML dissolution)
— otherwise the grammar freezes the wrong question." Recorded as
cross-substrate support for the existing packaging choice; no action
needed unless you want the pillar sooner.

## 4. (FYI) grok L2 applied with a flag

The §13.2 fixture-framing MUST NOT (descriptive-only pinning made
enforceable) was applied per coordinator endorsement and flagged in
DELTAS' organizational paragraph for your eye — it edges normative, so
un-apply is one revert if you disagree.

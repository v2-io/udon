# new-spec/ — clean-room UDON specification (greenfield-2a)

A greenfield rewrite of the UDON spec from the scrubbed materials in this directory, structured per `../defining-udon.md`'s three-pillar model. This directory is **pillar 2 — the Official Specification**: the contract, in RFC-2119 language, with the vocabulary consolidated to one name per concept.

## Documents

| File | Status | What it is |
|---|---|---|
| [SPEC.md](SPEC.md) | normative | The language contract: conformance, recognition, elements, attributes, flow, verbatim, dynamics syntax, references, values, anomalies. |
| [ADM.md](ADM.md) | normative | The Abstract Document Model — the data shape a conforming parse produces, including the attribute substrate, the text law, and the anomaly record. |
| [GLOSSARY.md](GLOSSARY.md) | normative | One name per concept; the source of truth for every formal term, plus the retired-synonyms table. |
| [OPEN-QUESTIONS.md](OPEN-QUESTIONS.md) | normative (as to scope) | Everything deliberately undefined, numbered Q1–Q10, with the decision space and a marked drafter's recommendation each. |
| [RATIONALE.md](RATIONALE.md) | non-normative | Why the contract says what it says. |
| [PEDAGOGY.md](PEDAGOGY.md) | non-normative sketch | Pillar-3 outline: the disclosure ladder and the mental models worth teaching. |

## What changed relative to the source spec (the scrub inputs)

Deliberate moves, not drift:

1. **Vocabulary consolidated.** One noun per concept; the jargon table's synonym families (blob/flow, freeform/raw/fence/verbatim, embedded/inline, head/open position, positional/geometric) resolve per the glossary's retired-terms table.
2. **Parser voice removed from the contract.** "The parser pops the stack" became column/ownership rules about what documents *mean*; behavior descriptions became MUST/SHOULD requirements. The stack, HOLD/RELEASE, and event vocabulary appear nowhere — the ADM is the interface.
3. **The ADM is now a first-class normative document** (it did not exist as one). Stacking, the text law, views, and the anomaly record are model facts, not scattered asides.
4. **Rationale and pedagogy extracted** from the normative path.
5. **Deliberate undefineds are numbered** (Q1–Q10) instead of inline caution boxes; the contract text reads clean and each open item has its decision space stated.
6. **One substantive drafting choice:** rational/complex literals are *out* of the bare set in this draft (Q6, with the reasoning). The source spec left them "parser-decided"; a contract can't say that, so this draft places them in the envelope and marks the question open.

## What this is not

- Not pillar 1 (a formal grammar) — the recognition rules in SPEC §3–§5 are written to be mechanically formalizable (every guard is enumerated), but no EBNF/PEG is authored here.
- Not an event/wire model — deliberately out of scope for these clean-room materials; the ADM is written so a streaming encoding can be derived from it (per-line text delivery, innermost-first close, the incomplete-input result) without constraining one.

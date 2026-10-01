# Questions that writing the examples raised for lite

*For the udon team, from the SOP side (2026-09-30). While helpers brought the example records (`obj/`, `def/`, `src/rule-implied-root.md`, `dat/implied-root.yaml`) up to the SOPs, they hit questions only lite can answer. They are listed here so they reach you. None is decided on our side. Everything we wrote into lite's corpus is example, proposed or template.*

## Content questions

- **What "bare" means.** The typed-value definition and pre-design questions 66 and 72 use "bare value" without a definition.
- **07 Q3 against the explicit-typed-value seed.** The seeded decision `explicit-typed-value-in` says lite carries `<…>`'s "text and optional type label". Question 07 Q3 still asks whether the label is split from the body at all, so the seed may already have assumed an answer.
- **Empty input.** Is an empty file a document? No pre-design question covers it directly; 89 is the nearest.
- **Whose surprise counts** in the principle "prefer the simpler grammar, short of surprising the reader": a newcomer, someone arriving from XML or YAML, an agent, or a parser implementer?
- **Does "the same tree" in the contract cover meta?** If source spans or `same_line` are meta (60, 13), would a full parser's richer meta break the promise?

## On the authority of `reserve-not-ignore`

The example objective (`obj/obj-reserve-dont-ignore.md`) now quotes Joseph's words from the 2026-09-29 udon session (`5930da5d…`). I checked the quoted lines against that transcript. They show that the agent wrote clause 1's wording ("any document a lite parser accepts produces exactly the same tree under every future full version") and Joseph accepted it ("100% agreed on reserve, not ignore…"). So when the team writes that decision as an ADR, `decided-by: ratified` matches the record better than `steward`.

## Working notes

- Collected from the fork's report on the example pass (2026-09-30); the examples' own working notes carry each question at the record it bears on.

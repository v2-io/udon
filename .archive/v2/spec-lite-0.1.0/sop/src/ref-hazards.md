---
kind: reference
awaiting-second: true
awaiting-decision: false
needs-work: false
source: the 2026-09-29/30 sessions on aat-refactored and spec-lite-0.1.0; ~/.claude/projects/-Users-josephwecker-v2-src-aat-refactored/memory/; v2/DECISIONS.md (K-row provenance note)
per: []
depends: [def:decision, def:record-fields]
---

# Named hazards

*Failures that have already happened in this corpus or its neighbors, named so nobody has to learn them again. Each has the tell that shows it and the check that catches it.*

## Hazards

| Hazard | Tell | Check |
|---|---|---|
| **An agent's sentence carried as Joseph's words.** A slogan from an agent's research report was attributed to Joseph, used as the warrant for a scope clause, and made a headline (aat-refactored, 2026-09-29). | A quote with no located source; memory-search results treated as proof of authorship. | Locate the verbatim source before attributing, and record ⟦wording⟧ as `verbatim` or `rendering`. |
| **A condition lost between the check and the landing.** A verifier proved a statement "under exogenous future actions"; the text that landed dropped the qualifier and kept the word "exact" (aat-refactored `d60c511`). | Landed wording differs from the wording that was checked. | Diff the landed text against what was verified. Any rewording is checked again, even one judged equivalent. |
| **"Verified" meaning "examined".** A handoff listed chapters as "Verified" after a review that found about fifty defects. | A hand-typed standing word. | Use ⟦verification-level⟧, with an evidence pointer; the standing is computed, never typed. |
| **Fixing only the examples pointed at.** When Joseph challenges a few items, they are examples of a class; fixing only those leaves the rest hidden. | A revision that changes exactly what was named, and nothing else. | Sweep the whole artifact for the class. Say plainly if the sweep shows the work wasn't done seriously. |
| **Freezing without a decision.** A draft was marked "sealed" before anyone had reviewed it. | "Sealed", "frozen", or "final" on something nobody decided. | Freezing is a decision. Propose it; don't record it. |
| **An interpretation becomes load-bearing.** v2's K-rows were an agent's good-faith readings of Joseph's words. When two rows conflicted, weighing row against row made things worse. | Two records conflict, and each rests on someone's rendering. | Go back to the decider: "when you said X, were you also implying Y?" |
| **An undefined core term.** A synthesis used "canon" without defining it, and the steward's proposal got misread. | A load-bearing word written without its delimiters. | Delimit defined terms, and define before relying on them ([[conv:term-delimiters]]). |
| **Statements written from titles.** Outline rows were written from question titles without reading the questions. | A Statement cell for a question nobody read whole. | Say which rows came from titles only, and read the question before writing its rule. |

## Discussion

- Admission test, carried from the verisectorium template's `ref-hazards`: a hazard belongs here once it has recurred, or once it has a nameable tell and a dated occurrence. One-off mistakes don't qualify.

## Sources

- The sources are session records and memory files, not first-person reports from Joseph, except where his words are quoted in `sop/influx/jaw-proposal-and-feedback.md`.

## Working notes


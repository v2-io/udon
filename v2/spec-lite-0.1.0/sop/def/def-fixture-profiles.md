---
kind: definition
awaiting-second: true
awaiting-decision: false
needs-work: false
terms: [profile, canonical, idiomatic, counter, descriptive, reading, expects, exercises, open]
per: [fixtures-are-records]
depends: [def:record-kinds]
---

# profile · canonical · idiomatic · counter · descriptive · reading · expects · exercises · open

*Every ⟦fixture⟧ case has a ⟦profile⟧. ⟦canonical⟧, ⟦idiomatic⟧ and ⟦counter⟧ cases are normative and gate conformance; a ⟦descriptive⟧ case records a question that is still open, and never gates.*

## Terms

- **profile:** the field on every ⟦fixture⟧ case that says whether the case gates conformance and what it is for. It takes one of four values: ⟦canonical⟧, ⟦idiomatic⟧, ⟦counter⟧, or ⟦descriptive⟧.
- **canonical:** normative. A conforming parser must produce exactly this tree and these anomalies.
- **idiomatic:** normative, and written to teach. Typical usage lives here.
- **counter:** normative, and shows a misguided or surprising spelling. Beside the tree lite gives it, the case carries ⟦expects⟧.
- **descriptive:** never gates. It carries a set of ⟦reading⟧s, one tree per open alternative.
- **reading:** one alternative tree in a ⟦descriptive⟧ case, keyed by the question and option it comes from (e.g. `04-Q1-A`).
- **expects:** in a ⟦counter⟧ case, what a reader plausibly thinks the input means: the wrong reading the case exists to correct.
- **exercises:** on every case, the ⟦rule⟧s the case pins, as bare rule slugs (one kind, so no kind prefix).
- **open:** on a ⟦descriptive⟧ case, the pre-design questions whose closing would make it normative. It is part of what a descriptive case is, so it stays a field rather than a working note.

## Invariants

- When a question closes, the matching ⟦reading⟧ becomes the tree, and the case becomes ⟦canonical⟧ or ⟦idiomatic⟧. The change cites the ⟦decision⟧ that closed it.
- ⟦descriptive⟧ cases never gate. Nobody may pick one of their readings as the answer without a decision.
- Every case names the rules it exercises (⟦exercises⟧) and the decisions its tree depends on (⟦per⟧).
- Case ids are stable names inside the ⟦fixture⟧ record and are never reused. They are anchors, like headings: a rule cites the file through ⟦test-fixtures⟧, and prose may transclude one case as `![[dat/implied-root.yaml#root_top_level_label]]`. Prose around a transcluded case is stale once that case changes.

## Sources

- Sources:
  - the profile names idiomatic / comprehensive / descriptive come from `../../../spec-0.10.01/fixtures/README.md`;
  - `counter` is added for Joseph's "examples of misguided usage";
  - `canonical` replaces "comprehensive", because what matters is whether a fixture gates, not how many cases it covers.

## Working notes

- The tree notation in fixtures is the pre-design text form until a machine transcript is decided (question 86).

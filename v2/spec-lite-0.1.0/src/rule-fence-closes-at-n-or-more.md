---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: text
per: []
depends: [rule:fence-opens-with-backticks]
consequences: [rule:fence-closer-trailing-text-is-error, rule:fence-closer-is-a-line, rule:fence-body-not-scanned, rule:fence-line-comments, rule:fence-anywhere-structure, rule:fence-label-no-backtick, rule:fence-opens-with-backticks]
---

# A fence closes at N or more backticks

*A fence of length N closes at the first later line whose first non-space content is N or more backticks.*

## Statement

1. A fence of length N MUST close at the first later line whose first non-space content is a run of N or more backticks.

## Grounds

- Joseph, 2026-10-08: "We should allow nested fences via backtick count >= 3 is my strong preference" (Discussion below).

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

`````udon
````md
```js
x
```
````
`````
```tree
root
  ```md "```js\nx\n```\n"
```

## Discussion

*Carried 2026-10-09 from the decision record `adr/fence-nesting-by-length.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `supported`, 2026-10-08.*

**Context.** With `!:kind:` reserved, the fence is lite's only form for raw content. A fence was exactly three backticks, so the first inner three-backtick line closed an outer fence early, with only one unclosed-fence warning at the end of the file (`v2/theory/to-integrate/refine-more/markdown/fence-knot-table.md`). The spec corpus written in lite will contain examples that contain fences.

**Options considered.**

* Exactly three backticks (0.10.0).
* N ≥ 3, closing at N or more (CommonMark) (chosen).
* Also allow `~~~` fences: not taken, on the agent's recommendation; Joseph didn't address it.

**Drivers.**

* Fences must be able to hold fences (vsect's most binding requirement, `.int/vsect-requirements-on-lite.md`).
* Follow the existing standard where UDON doesn't need to differ: CommonMark 0.31.2 "Fenced code blocks" (copy in `v2/spikes/markdown-probe/`). (**inferred**: the agent's reading of Joseph's "Is there a standard?")

**How firm.** His words: "my strong preference" (nesting by length); "Agree" (the no-backtick label, the agent's proposal from CommonMark). Recorded `supported`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).

## Working notes

- **Joseph's words:**

  > Decision A:  We should allow nested fences via backtick count >= 3 is my strong preference.  Is there a standard? I know, for example, that we will not want to follow markdown's standard (in some versions) of requiring that a fence be at the beginning of a line or the first non-whitespace of a line-- we need its indent (including sameline) to decide whose child it is.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** The CommonMark rule for nesting by length.

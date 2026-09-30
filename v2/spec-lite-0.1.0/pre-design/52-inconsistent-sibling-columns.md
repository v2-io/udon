# 52 — Siblings at different columns: silent, warned, or refused?

*Raised by the history survey (files 50–69), 2026-09-29. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The question

The nesting rule (0.10.0 §2.1: pop while the new column ≤ the top's column, then push) accepts siblings at *different* columns, as long as each lands in the same parent's range. Should lite say anything when structure lines under one parent don't line up?

```udon
|one |two |three
     |alpha        ; col 5: sibling of two (aligned with it)
  |beta            ; col 2: also a child of one — but not aligned with alpha
```

## What the texts say

- **0.10.0** warns only for **text** (and comment-continuation) lines that fall shallower than an established content base (§7.2 rule 4, `InconsistentIndentation`). Whether that warning covers comment-continuation lines is itself open (OPEN **S4**, CARVEOUTS §S4-SCOPE). For **element** lines, nothing: any column that lands in the parent's range is silently fine. "A consistent sibling indent (commonly 2 spaces) is RECOMMENDED style, not a rule."
- **Joseph, 2025-12-24** (in the message that became `SPEC-INDENTS.md`), on the `|beta` case above: *"also sibling of two, but poor form. Either error or warn that it's inconsistent spacing … ideally once the second line has chosen to indent further for alignment, any other sibling lines should be aligned with it."*
- **Joseph, 2025-12-25**, on the text version: *"We only start warning on inconsistencies on line 3"* — the first line below an element chooses the column freely; later lines are checked against it. His examples also show a later element at an in-between column: `|also-a-child of element-bigger, issues warning though.`
- The same message: *"Indented lines get to choose any column between (but not including) parent's '|' and, if there is one the parent's inline child's '|' (inclusive now)."*

## Alternatives

### A — silent (0.10.0 for structure lines)

Only text lines get the shallower-than-base warning.

### B — structure lines get the same treatment as text

The first child line under an element sets that element's child column. A later structure line inside the element at a *different* column is accepted (tree unchanged) with a Warning.

```text
document
└ element one
    ├ element two
    │   └ element three
    ├ element alpha
    └ element beta          ; anomaly: warning, sibling column differs from alpha's (5)
```

Sub-question: does a *deeper*-than-established sibling column ever occur for structure? (A deeper line is a child of the previous sibling, so only the shallower case exists.)

### C — refuse in lite (error), to leave room for a stricter future rule

## Interactions

- [04](04-root-and-top-level-text.md) Q1: the same question for top-level lines, including a document whose first line is indented. Joseph, 2025-12-28: *"dedentation check is relative to the parent, and … nothing is hardcoded for literal column 0 … Tests shouldn't assume udon starts at column 0."*
- [12](12-missing-values-and-what-counts-as-valid.md): whether a warning makes a document not-valid-lite.
- OPEN **IND** / **IND-2** (`v2/OPEN.md`): no ratified default indentation unit for tools that generate UDON.

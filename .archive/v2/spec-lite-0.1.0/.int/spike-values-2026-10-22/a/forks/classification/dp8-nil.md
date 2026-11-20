# DP8: how nil is written

*Classification fork, spike a, 2026-10-22. `<…>`'s own design belongs to the sibling fork that has it; only how nil interacts with classification is here.*

## Options

| | Value nil | The word `nil` as text | `null` | Missing-value message ([[rule:missing-value]], decided) |
|---|---|---|---|---|
| N1 (with Cc) | `nil` (a text classified `#nil`) | `"nil"`, or inside a longer text | text, warning: did you mean `nil`? (as carded) | unchanged: names `nil`, `''`, `\` |
| N2 (with C0) | `<nil>` or `<>` | `nil` | text, warning pointing to `<>` | changes: names `<>` (or `<nil>`), `''`, `\` |
| N3 | both `nil` (classified) and `<>` | `"nil"` | as N1 | as N1 |

## Implications

- **N1 is what [[rule:nil-spelling]] already says**, read through Cc: "`nil` standing alone as a value MUST be nil" holds in the data reading, and the tree keeps the text. Neither decided card changes.
- **N2 changes two decided cards** (nil-spelling and missing-value) and makes nil the only primitive that needs a mark in everyday data: JSON's `null` fields become `<>` everywhere (A5, A9).
- **`<>` as nil (Joseph's lean)** is orthogonal under N1: a second spelling of one value (a small A8 cost), but one that ends itself, which a bare `nil` can't when other material follows on an element's line (`|el <> more` vs `|el nil more`, where the second is one text). N3 is that.
- **K10:** under N1, `:backup nil` is nil, `:word "nil"` is the text, `:e ""` the empty string, `:e \` the empty text. A lone bare `nil` meaning the word is the one spelling that reads differently than a writer might mean, and it is rare (judgment).

## Lean

N1, with `<>` if the `<…>` fork keeps a value bracket (N3). Confidence: high that N2 costs more than it gives, given Cc; the choice between N1 and N3 is the sibling fork's.

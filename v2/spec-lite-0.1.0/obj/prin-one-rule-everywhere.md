---
kind: principle
awaiting-second: true
awaiting-decision: true
needs-work: false
per: []
depends: []
---

# One rule everywhere

*A construct is read by the same rule wherever it appears; prefer extending an existing rule to carving out grammar for one context.*

## Statement

When choosing among alternatives that meet lite's objectives, prefer the one under which a construct is read by the same rule in every place it can appear: a value the same in every value position, the rest of a line the same whether the line began with an element or an attribute, nesting the same at every depth. An alternative that adds grammar for one context needs a reason that context really differs.

## Grounds

- "I don't know why you would carve out extra grammar for 'kind of almost values' in a place that was specifically meant to encapsulate a value." (Joseph, 2026-08-09, on `[key]` interiors; `~/.claude/history.jsonl` 18920)
- "All other treatments turns sameline into a whole set of special formatting and turns attribute sameline into a *separate* set of craziness." (2026-09-29, on `$main`; `.int/pre-design/STEWARD-2026-09-29.md`, from session `5930da5d` 01:55Z)
- "the whole point was to have indent/dedent behavior stay consistent, same with inline stuff." (2025-12-28, 6043)

## How it is used

A decision that leans on it names the rule it reuses, or, if it adds a context-specific rule, the difference in the context that justifies it.

## Epistemic status

A principle; it orders alternatives. It is a sharper form of [[prin:simplest-grammar-without-surprise]], kept separate because it can fail on its own: a rule set can get smaller overall while a construct still reads differently in two places.

## Working notes

- **Awaiting Joseph:** adopting this as a lite principle.
- It bears most directly on line ownership (01, 71, 73, 74) and on value positions (77, 83).

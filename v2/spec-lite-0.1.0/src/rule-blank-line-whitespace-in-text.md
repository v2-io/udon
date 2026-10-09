---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [def:blank-line, def:text, rule:blank-line-sets-no-indent]
consequences: []
---

# On a blank line inside text, whitespace past the left edge is content

*Inside a text or a fence body, whitespace on a «blank-line» that reaches past the left edge is kept; otherwise the line contributes only its newline.*

## Statement

Inside a «text» or a fence body, the whitespace on a «blank-line» that reaches past the left edge MUST be kept as content; a «blank-line» that doesn't reach past it MUST contribute only its newline.

## Grounds

- [[rule:blank-line-sets-no-indent]]: the agent's generalization, which Joseph called "Correct, excellent"; his example below.

## Epistemic status

Chosen. No fixture yet.

## Explanation

Joseph's example; line 3 holds six spaces, two past the left edge:

```udon
|node some $main prose
    child prose section starting...
      
    more prose...
```
```tree
root
  |node
    :$main ‹some $main prose›
    ‹child prose section starting...\n  \nmore prose...›
```

## Working notes

- **Joseph's words** (2026-10-08, `.int/STEWARD-VERBATIM.md`), his example (line 3 holds six spaces):
  > Line 3 there has 6 whitespaces. The reassembled text from the AST would be: "child prose section starting...\n  \nmore prose..."

  The agent generalized it (whitespace past the left edge is content; otherwise only the newline), and he answered "Correct, excellent."

- In a verbatim (`-`) fence every byte is kept, so this card's second half doesn't apply there.
- Blank lines before a fence body's left edge is set: open.

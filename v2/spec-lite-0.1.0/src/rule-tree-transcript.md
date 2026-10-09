---
kind: rule
awaiting-second: true
awaiting-decision: true
needs-work: true
layer: tree
per: [ast-centric, representational-options]
depends: [def:document, def:reading-option]
consequences: []
---

# Fixtures compare trees by their canonical transcript

*A fixture's expected «raw-tree» is written in one canonical printed form, and a parser's tree is checked by printing it in that form and comparing the text byte for byte.*

## Statement

1. A conforming parser's test harness MUST check a fixture by printing the parser's «raw-tree» in the canonical transcript and comparing it byte for byte with the fixture's expected transcript.

## Grounds

- Lite is specified as the tree ([[decision:ast-centric]]); fixtures show the «raw-tree» ([[decision:representational-options]]).
- Both independent notation proposals (`.int/ast-notation-proposal-a.md`, `-b.md`) reached this shape: no implementation parses the notation; each ships a small printer.

## Epistemic status

Proposed, not decided: Joseph agrees with the coordinator's lean but has "remaining issues to consider". Which notation is canonical is not settled.

## Working notes

- **Joseph's words** (2026-10-08/09, `.int/STEWARD-VERBATIM.md`):
  > would you propose or have an agent look at everything and propose a quick syntax/notation for expressing the AST here in chat and in the spec and in the fixtures (all the same ideally if it's elegant enough, but with big or minor differences acceptable if necessary).

  > (also tell the agents they are welcome to use indentation and unicode in their proposals if it makes things more readable etc. I'd prefer that over "json s-expressions" or something verbose and jarring like that)

  > 4. Pondering... I agree with your lean but there are still some remaining issues to consider...
- **The lean:** proposal A (UDON-like lines, text in `‹…›`, an explicit `root` line), with one transcript line per source line for a text spanning several lines. Proposal A §5 holds a draft of the printing rules this card would adopt.
- Open, from both proposals: whether a comment keeps the space after `;`; a text's final newline; number values versus spellings; what positions count. Settled since: traits are names, not text (proposal A prints `:$traits ‹main›`, which is wrong); a fence's `-` is a flag, not part of its label.

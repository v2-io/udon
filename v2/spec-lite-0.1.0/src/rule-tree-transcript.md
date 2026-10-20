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
- **Joseph's constraints on the notation (2026-10-20):**
  - `‹…›` and `<…>` are too alike to tell apart at a glance: "the <> and guillamets are too indisdinguishable visibly to me".
  - `<…>` must not stand for "raw" in the tree: "The problem with <...> representing "raw" instead of "typed value" (that just happens to be raw in some cases in udon) is that those are different things.... I know this is a tree representation distinct from (but somewhat coherent with / analogous to, IIUC) udon itself, but that would be a direct conflict that makes it extra difficult."
  - Lesser-used Unicode brackets are welcome, single-width preferred: "⦅ ⦆, 〚 〛(double-wide so not ideal), ⸨ ⸩, ﹝ ﹞(double-wide also), any of the asian brackets, bracket parts ⎨ :-), ⌈ ⌉ • ⌊ ⌋, ⟮ ⟯ • ⟬ ⟭, ⟦ ⟧, ⦑ ⦒ ⧼ ⧽, ⦓ ⦔, ⸦ ⸧".
  - "We will also need to be careful to distinguish between an **AST list** vs **udon-list-value** (which will also be represented as an AST-list, but which has already caused you and me confusion and disagreement! ;-)"
- **The coordinator's proposal (2026-10-20), for him to weigh.** All of these are single-width (East Asian width Narrow or Neutral, checked against UCD 18):
  - a «text» and its pieces: `⸨…⸩` (double parentheses; round, so unlike `<` and `«`);
  - raw content lite doesn't interpret: `⟬…⟭` (tortoise-shell brackets; angular, so unlike `⸨`);
  - a «delimited-string» value: `"…"`, as now;
  - a UDON list value: `[…]`, UDON's own spelling, and the only meaning `[…]` has in a tree. AST sequences (an element's children, an attribute's items, a text's pieces) never take brackets: they are lines under their owner, or juxtaposition inside `⸨…⸩`;
  - `<…>` never appears as a result: what it produced prints by its kind (`<3>` as `3`; a raw interior as `⟬u64:0xff⟭`), and that it was written with `<…>` is «meta» (form `angle`);
  - `⟦…⟧` is left alone, since the SOP store uses it for its own terms.

- **Backticks** (Joseph, 2026-10-20: "We also have `...` available if we want in the AST..."). The coordinator's lean is to keep them for the fence node only. Tree fragments are quoted inline in spec prose inside backtick code spans, where a backtick in the fragment forces double-backtick spans. A tree line beginning with three backticks would also close the Markdown fence a card's tree sits in. Their best use would be raw content, since everyone reads `` `…` `` as "verbatim".

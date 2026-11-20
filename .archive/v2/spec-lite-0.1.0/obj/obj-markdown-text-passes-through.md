---
kind: objective
awaiting-second: true
awaiting-decision: true
needs-work: false
force:
per: []
depends: []
---

# Markdown in lite prose stays Markdown

*Markdown in lite prose stays Markdown, except at named collisions and with UDON's block indentation in mind; lite never unintentionally parses Markdown as UDON constructs.*

## Statement

1. Markdown written in lite prose MUST stay the same Markdown, except at collisions lite's rules name explicitly, and allowing for UDON's block indentation (a prose block is dedented to its left edge, so Markdown's own indentation counts from there).
2. Lite MUST NOT read a Markdown spelling as a UDON construct unintentionally: every place where it does is a collision named in a rule.

## Grounds

- Joseph's long-standing claim: "Markdown *is* correct UDON" (2025-12-24); "any valid markdown is valid udon prose" (2026-01-14) (`~/.claude/history.jsonl` 5527, 7904).
- Its scope, in his words, which separate the two clauses: "INCLUDES Ability to not conflict with the majority of markdown dialects" and "EXCLUDES (initially) actual parsing of markdown or rather defers it to be a host implementation and/or dialect decision" (2026-07-08, 15379); and "that's a very different thing 'does not conflict' from 'udon-parser will also parse the markdown prose'" (2026-07-23, 17396).

## What discharges it

- the text rules ([[rule:text-blocks]], [[rule:markdown-in-text]]), which name every collision;
- the reserved-spelling rule ([[rule:reserved-spellings]]), whose reach into prose decides one of them;
- fixtures built from Markdown that measure what survives.

## Epistemic status

Chosen, not derived. Checkable by measurement. One measurement exists, made with the old 0.9 parser (an agent's report, 2026-07-28, `v2/theory/to-integrate/refine-more/markdown/commonmark-non-conflict-table.md`): across all 652 CommonMark examples, only the code fence triggered UDON structure, and byte-exact survival was 86.7% inside an element and 76.2% at the top level. It has to be re-run against lite's rules.

## Discussion

- **Known collisions, from the pre-design files:**
  - a Markdown code fence at the text's left edge is a lite fence (11, 87);
  - tight pipe tables `|a|b|` open elements; spaced ones `| a | b |` don't (08);
  - a line-initial `\` is consumed as an escape (82, 87);
  - a line-initial `:word` may read as an attribute (88, 87);
  - a Markdown image `![alt](src)` at a line start is a reserved construct and an error (Joseph, 2026-10-21; [[rule:reserved-spellings]]); mid-line it is text. Escape it with a leading `\\` or indent it past the text's left edge.
- **The sharp one is a conflict with [[obj:reserve-dont-ignore]].** Under [[decision:reserved-is-an-error]], if a prose line starting `@alice said` or `!important` counts as reserved syntax, the whole «document» has no tree. Either lite reserves less in prose than elsewhere, which constrains what full UDON may later do with prose, or this objective names those lines as collisions. That is 09 Q1 and 87, and it is Joseph's call, because the two objectives pull against each other.

## Working notes

- **Statement corrected by Joseph, 2026-10-22** (one reason the objectives aren't ratified: "they are still a bit wrong"). His wording: "Markdown in lite prose stays markdown except at named collisions and with udon block indentation in mind; lite never *unintentionally* parses Markdown as udon constructs." It replaced "reads as text, byte for byte" (dedenting alone changes bytes) and "A lite parser MUST NOT interpret Markdown" (his clause is about Markdown read as UDON constructs, not about whether anything may ever read the Markdown). The slug still says "text".
- **⟦force⟧ is empty: Joseph's call.** The udon team's lean is `required`.

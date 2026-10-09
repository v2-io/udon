---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
terms: [left-edge]
per: []
depends: [def:column, rule:text-left-edge]
consequences: [rule:text-dedent, rule:text-shallower-line, rule:deeper-marker-lines-are-text, rule:blank-line-whitespace-in-text, rule:lone-backslash-line, rule:fence-body-dedent, rule:fence-body-shallower-line, rule:top-level-text-left-edge]
---

# left-edge

*The «left-edge» of a text, or of a fence body, is the «column» its lines are dedented to. Its first non-blank line sets it; a shallower line moves it with a warning; a deeper line is content. The term is a lite drafter's word. Joseph's words for this column are "indent level", "active indent", "leftmost edge" and, in July, "prose-head column"; 0.9 and 0.10 called it "content base".*

## Terms

- **left-edge:** the «column» that a text's lines, or a fence body's lines, are dedented to. Each line loses that many leading spaces, and spaces beyond it are content. It is set by the first non-blank line ([[rule:text-left-edge]], [[rule:fence-body-dedent]]) and moves left, with a «warning», to a shallower line still inside the owner ([[rule:text-shallower-line]], [[rule:fence-body-shallower-line]]). For text it also bounds structure: a line deeper than an established left edge is text even if it starts with a «marker» ([[rule:deeper-marker-lines-are-text]]). *(Working definition, not reviewed with Joseph.)*
  - *Avoid:*
    - **"content base"** / **`content_base`** / **"content-base"**: Dec 2025 `SPEC-INDENTS.md` (`content_base`), 0.9 CORE ("prose content-base"), 0.10.0 §7.2 and GLOSSARY ("the column anchoring a text block's dedentation"). [[rule:framed-comments]] still quotes 0.10.0's "at the content base".
    - **"raw base"**: 0.10.0's name for the same column in a block-verbatim body. Lite has one word for text and fence bodies.
    - **"base column"**: 0.9/0.10.0, a *different* column (an item's marker column; [[def:column]]).
    - **"prose-head column", "prose head position", "the first column of the prose"**: Joseph, July 2026 ([[def:head-position]], sense 3).
    - **"indent level" / "active indent" / "indent-column position"** for this column: Joseph's (see below). Lite's [[def:column]] keeps «indent-level» for a line's own indentation.
    - **"first-inner-sets-indent"**: Joseph's name for the *rule* (2026-10-08), not for the column.

## Invariants

- The «left-edge» is set by text lines only: `$main` sets none ([[rule:text-left-edge]]), and a «blank-line» never sets or moves it ([[rule:blank-line-sets-no-indent]]).
- At the top level of a document that starts with prose, the «left-edge» is column 0 ([[rule:top-level-text-left-edge]], a lean).

## Working notes

- **Not reviewed with Joseph.** "Left edge" appears in about 14 cards, written by the drafters; nothing shows him choosing it. It is close to his own "leftmost edge" (2026-10-09).

### Joseph's words for this column

From `~/.claude/history.jsonl` unless marked otherwise.

- 2025-12-31 (line 6428): "sameline prose doesn't set the indent-column position (only the first block-level line of prose does that)".
- 2026-01-02 (line 6787): "does the prose_dedentation give a warning when the base column changes as per the spec?"
- 2026-07-14 (line 16137): "only the column aligned with the first column of the prose is a head position".
- 2026-07-14 (line 16217): the leading `\` "sets the current indent-level / head-position".
- 2026-07-19 (line 16875): "whitespace past the prose-head column"; "prose that ends at or before the prose head position".
- 2026-10-08 (`.int/STEWARD-VERBATIM.md`): "normal first-inner-sets-indent+warn-on-dedent"; "in udon we only start having clues about intent via special notation on the open (if there are any) and the first line's indent level".
- 2026-10-09: "setting the leftmost edge as the active indent"; "the *leading* escape (at the right indent level)".
- *Reading (mine):* he names this column by what *sets* it ("first line's indent level", "first-inner-sets-indent") or by its role for the next line ("active indent", "head position"), not by a noun of its own. "Leftmost edge" is the nearest he comes to "left edge".

### Precedents (names that dedent algorithms use)

- **YAML 1.2 §8.1.1.1:** "If no indentation indicator is given, then the content indentation level is equal to the number of leading spaces on the first non-empty line of the contents." And: "It is an error for any of the leading empty lines to contain more spaces than the first non-empty line." This is the same first-line rule; YAML's name is "content indentation level". UDON instead keeps a blank line's whitespace past the edge as content ([[rule:blank-line-whitespace-in-text]]).
- **CommonMark fenced code:** "up to N spaces of indentation are removed from each line of the content", where N is the opener's indentation. This uses the opener's column; Joseph ruled that out for UDON ("strip to the fence's column -- which is a complete no-go", 2026-10-08).
- **Other dedent algorithms (from memory):** Python `textwrap.dedent` removes "common leading whitespace"; Ruby's `<<~` heredoc removes the least-indented line's indentation; Java text blocks strip "incidental white space"; Swift multi-line strings strip to the closing `"""`'s column; Kotlin's `trimMargin()` strips to a "margin prefix" (default `|`, a collision with UDON's `|`). The common-minimum rules need the whole block first. Joseph names that as non-streamable (his option 5, 2026-10-08), which is why UDON's rule is first-line-sets.

### Questions about meaning, register and affordance

- **"Edge" has a graph sense in this corpus:** UDON's README says "Attributes are edges, elements are nodes"; 0.10.0 calls an attribute a "labeled edge"; the addressing theory has scope "edges" (`references/def/def-scope.ud`). "Left edge" is geometric, but a reader primed on the graph sense may stumble.
- **"Left" assumes left-to-right text.** In right-to-left prose (Arabic, Hebrew), the indentation of a line sits on the visual right in a bidi editor. "Base", "margin" and "indent" carry no direction.
- **One word for text and fence bodies?** The fence card already uses "left edge" for its body, and the behaviour is the same except the fence's verbatim flag. 0.10.0 split them (content base / raw base). One word suits lite's simplification.
- **Column or line?** "Left edge" reads as a vertical line the text hangs from, which helps a reader picture dedent. "Content base" reads as a number. Joseph's "active indent" reads as a state that changes as lines arrive, which is also true (it moves on a shallower line).

### My own opinion (the drafter's; not a lean of Joseph's)

- «left-edge» is the clearest of the candidates for a reader with no highlighting, and close to his "leftmost edge". Its costs (the graph "edge", left-to-right bias) are mild.
- "Content base" carries 0.10.0's frame and pairs badly with "base column".
- If he prefers his own "indent level" here, [[def:column]] would need a different word for a line's own indentation.

### Cards a change would touch (left unedited)

- About 14 cards use "left edge"; `grep -rln "left edge" src` lists them.
- `src/rule-framed-comments.md` (quotes 0.10.0's "content base" in Context; history, fine to keep).

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- Agree: «left-edge». It is nearly his "leftmost edge", it pictures dedent correctly, and "content base" pairs badly with 0.10's "base column". The graph sense of "edge" is mild because lite has no addressing.

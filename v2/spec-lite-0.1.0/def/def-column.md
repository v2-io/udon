---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
strength: provisional
terms: [column, indent-level]
per: []
depends: [rule:columns-count-spaces, rule:no-break-space-counts-as-space]
consequences: [rule:column-shifting-whitespace-error, rule:whitespace-after-last-marker, rule:sameline-element-is-child, rule:lines-follow-sameline-columns, rule:top-level-columns, def:left-edge]
---

# column · indent-level

*A «column» is how far into its line a character sits, counted in spaces. A line's «indent-level» is the column of its first non-space character. "Indent level" is Joseph's most-used word in this whole territory, and he uses it for four different things.*

## Terms

- **column:** the position of a character on its line: the number of characters before it, where indentation and anything before a later «marker» may contain only U+0020 SPACE, with U+00A0 counted as one ([[rule:columns-count-spaces]], [[rule:no-break-space-counts-as-space]]). Counted from 0 in lite's rules: the root sits at −1 ([[rule:top-level-columns]]), and top-level prose's edge is column 0 ([[rule:top-level-text-left-edge]]). *(Working definition, not reviewed with Joseph. The base is the open point below.)*
  - *Avoid:*
    - **"base column"**: 0.9 CORE and 0.10.0 §2.1, "the column of its introducing marker". It is a column, but "base" also appears in "content base", a different column ([[def:left-edge]]).
    - **"structural column"**: 0.10.0 §2.
    - **"position"** alone for a column: 0.10.0's "Structure Position" is a state, not a number ([[def:head-position]]).
    - **"cursor location"**: Joseph, 2026-08-08, describing pseudo-line-feeds. That is the sameline sense, fine in teaching but not as a term.
- **indent-level:** the «column» of a line's first non-space character. For a sameline element, its *own* column is often called its **true column** (0.10.0 §2.1, lite's cards). *(Working definition. Joseph uses "indent level" more widely; see below.)*
  - *Avoid:*
    - **"indent column", "indent-column position", "parent's indent column"**: Joseph's variants.
    - **"indentation level"**: Python's term, used in some lite cards. It is fine in English, but two spellings for one term is the sameline problem again.
    - **"active indent", "current indent level"**: Joseph's words for the column the next line is judged against. That is the stack's state, not a line's property; see Working notes.
    - **"dent"**: Joseph, "all dent changes in meta" (2026-10-08). It is his informal shorthand.

## Working notes

- **Not reviewed with Joseph.**

### Joseph's words

From `~/.claude/history.jsonl` unless marked otherwise.

- 2025-12-31 (line 6428): "sameline prose doesn't set the indent-column position (only the first block-level line of prose does that)".
- 2026-01-02 (line 6796): "The spec actually recommends that the closing ``` happen at the indent level of the parent".
- 2026-07-12 (line 15834): "the indent level is determined by the indent (as one would expect) of the starting one, and we recommend putting the closing one at the same indent level so if the fence is longer than a screenful the stuff underneath it will have a good idea of where the parent element's indent level is."
- 2026-07-14 (line 16217): "sets the current indent-level / head-position"; (line 16218) "'takes up no column' for the purposes of indent level / subsequent head-positions".
- 2026-10-08 (`.int/STEWARD-VERBATIM.md`): "the "parent's indent column" is (in 1-indexed columns) 0"; "blank lines do *not* change indent levels"; "a fenced-block has meta about [its] first line's indent level"; "the closer … indent level sets new current indent level".
- 2026-10-09: "the *leading* escape (at the right indent level)"; "escaping just a newline (and thereby also setting the indent level...)"; "setting the leftmost edge as the active indent. Or, said another way possibly-- implicit-root at -1 indent and if the first line is prose it has its indent level set to 0."

### Readings of his usage (mine)

"Indent level" covers four things in his text:

1. **A line's own indentation:** "the indent (as one would expect) of the starting one".
2. **A parent's column:** "where the parent element's indent level is".
3. **The column a text block is dedented to:** "first line's indent level", "setting the indent level" by a leading `\`. In lite's cards that is the «left-edge».
4. **The nesting context the next line is judged against:** "sets new current indent level", "active indent". That is the stack's state.

Senses 3 and 4 are why "indent level" overlaps both «left-edge» and his July «head-position» (sense 3 there).

### Precedents

- **Python** ("Indentation"): "Leading whitespace (spaces and tabs) at the beginning of a logical line is used to compute the indentation level of the line, which in turn is used to determine the grouping of statements." And: "The indentation levels of consecutive lines are used to generate INDENT and DEDENT tokens, using a stack". Python's "indentation level" is sense 1, and the stack holds them for sense 4. It is the closest match to Joseph's word.
- **Haskell 2010:** "the indentation of a lexeme is the column number of the first character of that lexeme". A lexeme's column, used mid-line, is exactly a sameline element's true column.
- **YAML** speaks of "indentation" and "the content indentation level" (block scalars). **CommonMark** speaks of "spaces of indentation" and counts tabs to 4-column stops.
- **Column bases differ across tools:** Vim and most compiler diagnostics count from 1, Emacs `current-column` from 0, LSP from 0 in UTF-16 units (all from memory).

### Questions about meaning, register and affordance

- **Base 0 or base 1?** Lite's rules count from 0 (root −1, prose edge 0). Its warning examples print 1-based positions ("Warning at 3:1" in [[rule:top-level-columns]] for a line at column 0; "Warning at 4:10" in [[rule:framed-comment-owns-deeper-lines]]). Joseph has used both ("in 1-indexed columns) 0", 10-08; "implicit-root at -1 indent … set to 0", 10-09). A definition should fix the base for rules and say separately how diagnostics print positions.
- **What does a column count after a non-ASCII character?** Characters, bytes or display width; this is pre-design 79 Q4, open. It matters for sameline columns: in `|p 日本 |em x`, the column of `|em` differs by counting method, and so does which later line is its child.
- **"Level" invites a count of levels** (level 1, 2, 3, as editors say "indent level 2"). UDON has no indentation unit, so a depth count is defined only by the stack. A reader may expect "indent level 2" to mean the second nesting level, not column 2.
- **Is one term carrying four senses tolerable?** Python manages with "indentation level" plus the stack. Lite could keep «indent-level» for sense 1 only, and name the others by what they are: the «left-edge» (3), and the column of the innermost open element (4).

### My own opinion (the drafter's; not a lean of Joseph's)

- Keep «column» with a fixed base, and «indent-level» in sense 1 only. "Indent level" is his everyday word, and Python's precedent makes sense 1 the one readers expect.
- When he says "sets the indent level" about text, the spec should translate that to «left-edge» rather than widen «indent-level».
- The base question is the one most likely to bite a parser author first.

### Cards a change would touch (left unedited)

- Every card with a line:column warning position ([[rule:top-level-columns]], [[rule:framed-comment-owns-deeper-lines]]); whether they print 1-based needs saying.
- Cards that say "indentation level" in their own voice; `grep -rn "indentation level" src`.
- "true column" (12 uses) can stay as teaching wording if «column» is defined.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- **Base:** rules count from 0 (the root at −1, top-level prose at 0), and diagnostics print `line:column` 1-based, as compilers and editors do. Both are already true in the cards; the card should say it once so no one "fixes" one to match the other.
- **«indent-level»:** sense 1 only, a line's own indentation. When he says "sets the indent level" about text, the spec says «left-edge». Python's "indentation level" is the precedent readers bring.
- **Non-ASCII columns** are pre-design 79 Q4 and the `rule:source-lines` gap; they decide `|p 日本 |em x`. That is a rule question for him, not a naming one.

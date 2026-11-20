---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
strength: provisional
terms: [element-line, attribute-line]
per: []
depends: [def:node, def:head-position]
consequences: [def:sameline, rule:framed-comments, rule:text-value-end, rule:leftover-values, rule:top-level-attributes]
---

# element-line · attribute-line

*An «element-line» is a line whose first content, at a «head-position», is an element; an «attribute-line» is one whose first content there is an attribute. They are the two kinds of line that have a «sameline».*

## Terms

- **element-line:** a line whose first non-space content is an element spelled in block form (`|name`, `|[k]`, `|.t`, a quoted name), at a place where structure can start. *(Working definition, not reviewed with Joseph.)*
- **attribute-line:** a line whose first non-space content is an attribute (`:name`), at a place where structure can start. *(Working definition.)*
  - *Avoid, for both:*
    - **"element's line" / "attribute's line"**: lite's drafters, about 17 and 19 cards. The possessive implies one owner. In `|a |b |c` the line holds three elements, and in `:x |em hi` an attribute and an element, so "the element's line" doesn't say which one.
    - **"element-rooted line"** (0.9 CORE, 0.10.0 §6.5) and **"block attribute line"** (0.10.0 §6.5, GLOSSARY). In 0.10.0, "block" here means *on its own line*, the opposite of the old narrow "sameline" ([[def:sameline]]).
    - **"element definition line"**: 0.9 CORE, "On the element definition line".
    - **"node line", "node or attribute started lines"**: Joseph, 2026-10-08 ("Comments: available on node or attribute started lines"). "Node" is now the generic word, and «element» the name for `|name` (ruled 2026-10-09).
    - **"line root"**: 0.10.0's name for what the line's leftover values belong to. That is an ownership claim, not a line kind ([[def:sameline]], Working notes).
    - **"structure line" / "lines that start structure"**: lite's fence cards. It is wider: it also covers comment lines and fence lines.
    - **"a sameline" as a kind of line**: Joseph, 2026-10-09, "on a line that is not sameline". This is the same idea; keeping «sameline» for the region avoids one word naming two things.

## Invariants

- A line's kind is decided by its first content, once. Later elements or attributes on the line don't change it.
- A line deeper than an established text left edge is text even if it starts with `|` or `:` ([[rule:deeper-marker-lines-are-text]]), so it is neither kind.

## Working notes

- **Not reviewed with Joseph.** Joseph, 2026-10-09, on replacing "line scan": "I don't mind saying "element and/or attribute line...." but haven't thought about it to make sure it really covers it well..., and it also might need to wait until we've settled the embed design."

### Joseph's words for these lines

From `~/.claude/history.jsonl` unless marked otherwise.

- 2025-12-31 (line 6428): "attribute+value block lines"; (line 6434) "whether sameline as element or sameline within attribute-block".
- 2026-07-15, Grok session (quoted in pre-design 01): "whether sameline is element-rooted or attribute-rooted".
- 2026-07-30 (line 18175): "block-attribute lines (or something)".
- 2026-09-30T01:55Z (`.int/STEWARD-VERBATIM.md`): "whether the line started with an element or an attribute".
- 2026-10-08: "node or attribute started lines".
- 2026-10-09: "element and/or attribute line"; "a line that is not sameline".
- *Reading (mine):* his recurring shape is "the line started with X". Whatever comes first decides the line's kind, which is what this definition encodes.

### The other kinds of line (for contrast; their names belong to other slices)

- A text line (prose).
- A line that starts with `;` (a comment block's first line; slice E).
- A fence's opening and closing lines (slice E), and a blank line (slice E).
- A line whose first content is `\` is text ([[rule:line-start-escape]]).
- **Not decided: a line whose first content is `|{…}`.** 0.10.0 §3: "A line-initial `|{` opens an **inline element** as the first segment of a flow line". That made it a text line, but the rule awaits the embeds discussion. A line that opens with an element and then has a fence (`|job :script ```sh`) is an element-line.

### Precedents

- **Python** distinguishes "physical line" from "logical line" ("A logical line is constructed from one or more physical lines by following the explicit or implicit line joining rules"). Lite's lines are physical lines; nothing in lite joins them.
- **Haskell 2010** names a line by its first token: "the indentation of a line is the indentation of its leftmost lexeme".
- **Slim** sorts lines by their first character, which its README calls "line indicators" (from memory, not re-checked): `|` is verbatim text ("The pipe tells Slim to just copy the line."), and others mark code or comments. That is the same idea as lite's line kinds, named by spelling, not role.
- **CommonMark** names lines by their role in a block ("paragraph continuation text", "lazy continuation line"), not by their first character.

### Questions about meaning and affordance

- **Is "line" the right unit once embeds are designed?** If `|{a :href / \ Home}` reads like an element-line inside braces, its interior is neither a line nor necessarily on one (Joseph's embed caveat above).
- **Does "element-line" read, to a fresh agent, as "the line of a particular element"** (possessive) or as "a line of the element kind" (classifier)? The hyphenated compound pushes toward the classifier; "element's line" pushes toward the possessive. Without highlighting, the hyphen is the only cue.
- **Top-level attribute-lines** now belong to the «root-node» ([[rule:top-level-attributes]]). The term doesn't change, but "attribute line at the top level" is how that card already says it.

### My own opinion (the drafter's; not a lean of Joseph's)

«element-line» and «attribute-line», defined by the first content, are the plainest names, and they are his own words. Their weak point is not the name but what agents have asked them to carry (ownership). If «sameline» is defined as the rest of such a line, these two terms need no further meaning.

### Cards a rename would touch (left unedited)

- Every card that says "element's line" or "attribute's line"; `grep -rl "element's line\|attribute's line" src` lists them.
- `src/rule-framed-comments.md` ("a line that begins with an element or an attribute").
- `src/rule-fence-opens-with-backticks.md` and `src/rule-fence-line-comments.md` ("structure line", "lines that start structure").

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- Agree: «element-line» and «attribute-line», decided by the line's first content. They are his phrasing ("the line started with an element or an attribute"), and they retire "element's line" / "attribute's line", whose possessive implies one owner.

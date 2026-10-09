---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
terms: [marker]
per: []
depends: [def:head-position, def:block-form]
consequences: [rule:column-shifting-whitespace-error, rule:whitespace-after-last-marker, rule:deeper-marker-lines-are-text, rule:text-value-end]
---

# marker

*A «marker» is the character, or short run of characters, that begins a construct at a «head-position»: `|` for an element, `:` for an attribute, `;` for a comment, three or more backticks for a fence, and the reserved `!` and `@` that lite recognizes only to refuse. The word is agent vocabulary. Joseph's own words for these characters are "sigil", "prefix" and "special starts".*

## Terms

- **marker:** a character or run that, at a «head-position» and passing its guard, begins an element (`|`), an attribute (`:`), a comment (`;`) or a fence (```` ``` ````); or begins a spelling lite reserves (`!name`, `@name`). *(Working definition, not reviewed with Joseph.)*
  - Not markers in this sense: the openers of embedded forms (`|{`, `@{`, `;{`), which are recognized inside text ([[def:embed]], [[def:block-form]]); and `\`, which escapes or ends text ([[def:text-terminator]]).
  - *Avoid:*
    - **"Marker"** as 0.9.1/0.10.0's capitalized formal term ("a character that can begin structure at Structure Position: `|` `:` `!` `;` `@` or a fence opener"). It came with "Structure Position" (greenfield 3b, 2026-07-19). The idea is the same, but the capital signals inherited law.
    - **"prefix" / "Prefixes"**: 0.9 CORE ("Four special characters at line start (after indentation)", a table headed Prefix). It collides with namespace prefixes (`:address/street`), type prefixes (`<u64:…>`) and sign prefixes on numbers.
    - **"sigil"**: Joseph, below. In Perl and Ruby a sigil marks a *name's* kind (`$x`, `@x`), and lite has `$main`, `$key`, so "sigil" there would collide.
    - **"special start(s)", "special-start markers", "head-position character"**: Joseph, July 2026, and 0.9 CORE.
    - **"species mark"**: 0.10.1 for `!` (generators). Not lite.

## Invariants

- A character is a «marker» only at a «head-position» and when its guard passes. Elsewhere, and when the guard fails, it is text (0.10.0 §3: "A marker character that **fails its guard** is ordinary text").
- Columns of «marker»s decide nesting, so whitespace that could shift one is an error ([[rule:column-shifting-whitespace-error]]).

## Working notes

- **Not reviewed with Joseph.** He has not used "marker" for UDON syntax in any prompt found (his only uses are for citation and gap markers).

### Joseph's words for these characters

From `~/.claude/history.jsonl`.

- 2026-01-14 (line 7847): "various `!|;: text`... prefixes in various positions / columns".
- 2026-07-08 (line 15386): "good catch with the wrapping making an inline sigil suddenly structural".
- 2026-07-12 (line 15836): "When in block mode (including sameline condensed) -- the following are special starts...."; (line 15848) "what's the sigil guard stuff talking about?".
- 2026-07-14 (line 16202): "escaping any initial head-position character is valid".
- 2026-07-29 (line 17684): "the structure and the block prefix characters (the noodles of the udon, so to speak)".
- 2026-08-28 (line 20554): "the fourth column worries me if you mean that those sigils have to be escaped no matter where they appear in text".
- 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`): "a *block* form of ;, |, or :"; "hitting a new |... ;... or :... (block) construct".
- *Reading (mine):* he names these characters by *role* ("special starts", "block prefix characters") or by the generic programmer's word ("sigil"), never by a coined term. His latest usage folds the character into the construct: "a block form of ;, |, or :".

### Precedents

- **CommonMark:** "A list marker is a bullet list marker or an ordered list marker."; also "block quote marker". It is the same sense: the characters that open a block. Lite hosts Markdown in prose, so a spec sentence about Markdown's `-` would then use "marker" in two senses.
- **YAML 1.2** calls them "indicator characters" (§5.3, from memory: "Indicators are characters that have special semantics"). **Slim** calls them "line indicators" (from memory).
- **C** calls its lexical punctuation "punctuators". **Perl and Ruby** use "sigil" for name-kind prefixes.
- **Lexer vocabulary** would say a marker *begins a token*, and the guard is a lookahead or predicate (PEG `&`/`!`).

### Questions about meaning, register and affordance

- **Character or construct?** Is the marker `|`, or `|name`? The cards say both: "a space followed by `|name`" ([[rule:text-value-end]]); "starts with a marker such as `|name`" ([[rule:deeper-marker-lines-are-text]]). For a fence it is a run of 3+, and for `;` the guard includes the space after it. Defining the marker as the character plus its guard would make the cards consistent.
- **Do embed openers count?** [[rule:whitespace-after-last-marker]] says whitespace "after the last marker on a line" is content. If `|{` counts as a marker, `|p a⇥b |{em x}` becomes an error. If it doesn't, it's fine. The cards' reasoning ("anything that could shift a later marker's column") suggests only markers whose column matters, which today means only the block forms. That is unstated.
- **Register:** "marker" is neutral and readable. It doesn't suggest a parser state, which is what the Gemini reviewer objected to in "Structure Position" (`v2/OPEN.md` N-jargon). Its risk is the Markdown collision above.

### My own opinion (the drafter's; not a lean of Joseph's)

- The concept is needed (the gap row `rule:markers` and the column cards depend on it), and "marker" is the least loaded word on offer: "prefix" and "sigil" both collide inside lite.
- The open choice is scope. I'd define a «marker» as the character plus guard that begins a «block-form», and say plainly that embedded-form openers are not markers.
- If Joseph prefers his own "sigil", the `$`-name collision is the cost to weigh.

### Cards a change would touch (left unedited)

- `src/rule-whitespace-after-last-marker.md` (title and Statement).
- `src/rule-column-shifting-whitespace-error.md` ("before a later marker").
- `src/rule-deeper-marker-lines-are-text.md` (title and Statement).
- `main.outline.md` gap row `rule:markers`.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- Agree with the drafter: «marker» = the character plus its guard that begins a «block-form» at a «head-position»: `|`, `:`, `;`, a run of 3+ backticks, and the reserved `@`/`!`. Embed openers (`|{`, `@{`, `;{`) are not markers. "Prefix" and "sigil" both collide inside lite (`$main`, namespace prefixes).
- This settles [[rule:whitespace-after-last-marker]]'s unstated scope: `|p a⇥b |{em x}` is fine, because `|{` is not a marker and its column never matters.

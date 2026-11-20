---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
strength: provisional
terms: [text-terminator]
per: []
depends: [def:text, def:sameline, def:block-form, def:framed]
consequences: [rule:text-value-end, rule:space-before-text-end, rule:framed-backslash-frame, rule:backslash-empty-text, rule:inline-element-value-end, rule:embeds-in-text]
---

# text-terminator

*A «text-terminator» is what ends unquoted «text» on a «sameline»: a space followed by an element or attribute in «block-form», a «framed» ` ; `, a «framed» ` \ `, or the end of the line. Inside `|{…}` the `}` also ends it. Embedded forms never do. Joseph used the phrase once, for the backslash, as "our other "text terminator""; he has not ruled it as a term.*

## Terms

- **text-terminator:** anything that ends a «text» running on a «sameline». The list is: a space followed by `|name` or `:name`; a «framed» ` ; `; a «framed» ` \ `; the end of the line; and, inside an inline element, its closing `}` ([[rule:text-value-end]], [[rule:inline-element-value-end]]). The space or spaces before a text-terminator are not part of the text ([[rule:space-before-text-end]]). *(Working definition, not reviewed with Joseph.)*
  - *Avoid:*
    - **"value terminator"**: 0.10.0 GLOSSARY ("what ends an unquoted text value"). It named the value, which in lite is a «text».
    - **"bare-token boundary"**: 0.9 CORE, retired by 0.10.0 in favour of "value terminator". It belongs to the old one-token-then-commit model.
    - **"boundary marker", "mode exit"**: 0.9's inline-brace principle ("No inline brace form is ever a boundary marker or a mode exit").
    - **"context terminator"**: 0.10.0 §6.4 for `}` and `]` ("unconsumed").
    - **"breakout" / "ESC-BREAKOUT"**: `v2/OPEN.md` and Joseph's 2026-08-08 description of the framed `\`'s job, "to break out of attribute-value pairs on sameline". In lite the framed ` \ ` simply ends the text, and what follows is placed by the ordinary rules.
    - **"commit to text mode"**: 0.10.0's framed `\`. That is the opposite job.
    - **"end-sequence"**: 0.10.0 §13, for delimited constructs (strings, `<…>`, fences). Lite's «string» has its own closing quote, which is not a text-terminator.

## Invariants

- No embedded form ends a «text». `|{…}`, `@{…}` and `;{…}` are pieces of it ([[rule:embeds-in-text]]).
- Text-terminators apply only to sameline text. In prose, a `\` after text "is just passed through like everything else except embeds" (Joseph, 2026-10-09).

## Working notes

- **Not reviewed with Joseph as a term.** The list itself is ruled ([[rule:text-value-end]], decided for this version).

### Joseph's words

- 2026-08-08, `v2/DECISIONS.md` K10 (ruled with him, the row text an agent's): "An unquoted text value is a quoted string with a different closing delimiter". Its list of what ends the value included "fence" and the reserved `@ref`/`!name`, which lite's list does not ([[def:head-position]], *A gap this exposes*). This is the "closing delimiter" frame; whose words it was originally is not recorded.
- 2026-08-08 (line 18879, quoted in pre-design 01): "Attaching to the most recent attribute or element is *NOT* the same thing as not watching for new attributes anymore when it's bare text. Why watch for ' ; ' but not ' :' or ' |' or ' !' or ' @' ????"
- 2026-10-08 (`.int/STEWARD-VERBATIM.md`): "*on sameline* text is always assumed to be non-delimited text which ends with a *block* form of ;, |, or : -- whereas embedded forms just stay part of the text".
- 2026-10-09: "We definitely still need backslash as our other "text terminator" in addition to the ones we said earlier-- hitting a new |... ;... or :... (block) construct. That is *different* (maybe significantly) than the previous iterations that treated [\] as the *beginning* of text. This is for sameline only I'm pretty sure."
- 2026-10-09: "If the next thing instead stops the text (including '\'), it was just delimiter+ornamental."
- *Reading (mine):* the frames on record are "closing delimiter" (the August ledger) and "terminator" (his, October), and his verbs are "ends", "stops", "hitting". The October phrase puts the quotation marks around "text terminator" himself, which reads as naming it on the spot rather than citing an existing term.

### What a "terminator" is, item by item

| Ends the text | Consumed? | What it starts |
|---|---|---|
| ` \|name` | no | a sameline element |
| ` :name` | no | an attribute |
| ` ; ` | no; it starts a comment | a comment to end of line |
| ` \ ` | yes, with its frame | nothing; the next material is placed by the ordinary rules |
| end of line | the newline isn't text | the next line |
| `}` in `\|{…}` | it closes the inline element | — |

So only one item, the framed backslash, is a terminator in the C sense (a token that exists to end something and is used up by it). The others are the *start* of the next thing, seen from the text's side. That's a lexer's lookahead, not a terminator.

### Precedents

- **YAML plain (unquoted) scalars**, from memory, YAML 1.2: "Plain scalars must never contain the ": " and " #" character combinations." An unquoted value there ends at a mapping indicator or a space-led comment. This is the closest precedent to lite's rule, and YAML calls it a restriction on the scalar, not a terminator.
- **POSIX shell / bash**, from memory: a *metacharacter* is "a character that, when unquoted, separates words" (`|`, `&`, `;`, `(`, `)`, `<`, `>`, space, tab, newline). Shell words end at `|` and `;` much as sameline text ends at ` |` and ` ; `. The shell calls them separators.
- **C vs Pascal:** `;` *terminates* a statement in C and *separates* statements in Pascal. These are the classic two names, and lite's list is neither: its items mostly *begin* the next construct.
- **Lexer vocabulary:** "delimiter" (a token marking a boundary), "lookahead" (examined but not consumed), "sentinel".

### Questions about meaning, register and affordance

- **Does "terminator" mislead about consumption?** A reader may assume the terminator belongs to, or is eaten by, the text it ends; that is true only of ` \ `. "Text end" or "where text ends" says no more than is true.
- **"Text" in the name, "sameline" missing from it.** The rule applies only to sameline text (and brace interiors), not to prose, which is also «text» ([[def:text]]). "Sameline text end" would carry the scope; it is longer.
- **Is a term needed, or only the rule?** One card ([[rule:text-value-end]]) lists the items, and three or four others refer to "whatever ends a text". Joseph's own October sentence works without a term ("ends with a *block* form of ;, |, or :"). A term helps mainly for the backslash, which is not a block form: he needed a word to group it with them.
- **Brace interiors** (`}`) wait on the embeds design. If `$main` or interior text inside braces changes, so may this list.

### My own opinion (the drafter's; not a lean of Joseph's)

The concept is needed, because several cards say "whatever ends the text". The word "terminator" is his and is readable. Its one cost is the consumption reading, which the table above answers. Two options seem worth putting to him:

- (a) keep «text-terminator», defined by the table, so consumption is explicit;
- (b) speak of "where sameline text ends", with no noun at all.

I lean slightly to (a), because he coined it in the act of grouping `\` with the block forms, which is exactly the job a term does.

### Cards a change would touch (left unedited)

- `src/rule-text-value-end.md` (Grounds quote "text terminator"; title "Sameline text ends at a block form" omits the backslash and the end of line).
- `src/rule-space-before-text-end.md` ("whatever ends it").
- `src/rule-inline-element-value-end.md` ("ends as on an element's line, or at the `}`").

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- Keep «text-terminator», his word, defined by the drafter's table so it's clear only the framed ` \ ` is consumed.
- **The list has grown since this card was drafted:** his 2026-10-09 ruling added a space followed by a fence opener, and the reserved `@name` / `!word` end the text too (as errors). [[rule:text-value-end]] has the current list; this card's Terms line should cite it rather than repeat it.

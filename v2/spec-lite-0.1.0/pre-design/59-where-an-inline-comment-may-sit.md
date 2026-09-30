# 59 — Where may an inline comment `;{…}` sit, and what happens to the value around it?

*Raised by the history survey (files 50–69), 2026-09-29. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The question

[10](10-inline-elements-and-inline-comments.md) Q2 asks whether `;{…}` is in lite at all. If it is, lite also needs to say **where** it is recognized and what it does to material around it. The history shows it written in several positions besides running prose:

```udon
|element ;{inline comment} :attr value            ; (1) on the element's line, between name and attributes
|element :note text ;{TODO: finish} Main prose.   ; (2) inside an unquoted attribute value
|el :n ;{}                                        ; (3) as the whole value
|el[jw ;{why this key}]                           ; (4) inside a [key] bracket
|ele;{hmm}ment :attr value                        ; (5) inside a name
```

## Where it has come up (chronological)

- **2011 DECIDED.md**: an embedded comment form was wanted (`#{…}`, then `|{# …}`), plus *"what about a simplification for line-ending comments though? … probably opens a can of worms..."*
- **Joseph, 2025-12-25**: *"`;{...}` inline comment — the only way to do udon-level comments within prose."*
- **Joseph, 2026-01-02**, listing where comments can happen: *"Either anywhere as inline ;{...} (balanced brackets inside) or potentially, if easier, inline anywhere within prose or on sameline: `|element ;{inline comment} :attr value` (so whether you can do this is undefined- it would be nice if it's not too complicated: `|ele;{hmmmm}ment :attr value ; -> == |element :attr value` -- but events get weird.)"*
- **Joseph, 2026-01-01**, on `|p ;{comment} text`: *"conceptually it should shrink to `|p  text` if the comment were 'extracted' -- which would then render as Text('text') without that extra space."* (vs 0.10.0 / S18: both framing spaces are kept.)
- **Joseph, 2026-07-19** (the `*{` boundary principle): *"the thing that would least surprise me as a user is `|el :n ;{}` === `|el :n ""` and `|el :n ;{<EOF>` -> same but with unclosed comment warning. `|el :n value ;{` == `|el :n "value "` … All *{...} constructs, embeds if you will, are assumed to *reduce to more text* (even if, in the case of the comment, that text is "")."* And: *"*{ should never take someone out of text/prose mode, and if encountered as the beginning of something, should start text/prose mode as if it was literal text."*
- **K9 (2026-08-08)** then made brace forms at a clean value position self-delimiting *values* (for `|{…}`), while mid-flow they stay segments. Whether `;{…}` at a clean value position is a value, nothing, or the start of a text value is not stated in the texts I found.
- **0.10.0 §6.6**: inside `|{…}` only `;{…}` comments (bare `;` literal). **§5.3**: bracket interiors take the full value grammar, so (4) is presumably allowed; (5) is not addressed.

## Alternatives

### A — prose and text values only

`;{…}` is recognized wherever flow is (block text, unquoted text values, inline-element interiors). Elsewhere — (1), (4), (5) — it is ordinary text or an error.

### B — anywhere a flow segment or a value may begin, including (1) and (4); never inside a name (5)

(1) then needs a rule: is `|element ;{c} :attr value` a `$main` value that is only a comment (so `$main ""`?), or is the comment attached to the element with no value produced?

### C — reserved in lite

## Sub-questions

- (3): `:n ;{}` — empty string (Joseph 2026-07-19), or missing value (Error + nil per K6)?
- (2): with the comment removed, does `text ;{…} Main prose.` leave two spaces in the value? (S18: yes, both kept.)

## Interactions

- [10](10-inline-elements-and-inline-comments.md) Q2, [03](03-semicolon-in-prose.md), [13](13-ast-shape.md) Q6.

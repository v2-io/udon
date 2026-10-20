---
kind: rule
awaiting-second: true
awaiting-decision: true
needs-work: false
layer: tree
per: []
depends: [rule:text-value-end]
consequences: []
---

# Backslash escapes on an element's or attribute's line

*Proposed: an attached `\X` escapes one character from a fixed set; any other is an error.*

## Statement

*Proposed by the coordinator, awaiting Joseph.* On an element's or attribute's line, outside «delimited-string»s and opaque spans, an attached `\` MUST be followed by one of `|` `:` `;` `@` `!` `{` `}` `"` `'` `[` `<` `0`–`9` `+` `-` `` ` `` `\`, and gives that character as text; any other character after it MUST be an error.

## Grounds

- Joseph, 2026-10-09: escapes are known where they escape "what would otherwise be a type differentiator (number, quote, <, etc.) or what would otherwise be a block beginning (:,|,;)", and reserved `@` and `!` must be escapable; "don't you think we should do the same thing for backslashes … that we don't know the exact meaning of?"

## Epistemic status

Proposed; not decided.

## Explanation

```udon
|el :count \7 apples :b 2
|el :a hello \:-) there
|post :by \@alice
|el :path C:\Users\me
```
````tree
root
  |el
    :count ‹7 apples›
    :b 2
  |el
    :a ‹hello :-) there›
  |post
    :by ‹@alice›
````
The fourth line is an error: `\U` is not an escape here; quote it, `'C:\Users\me'`.

## Working notes

- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > 2. Oh-- I forgot we changed those to errors inside embeds if not supported. For lite-- don't you think we should do the same thing for backslashes without a right-fence that we don't know the exact meaning of? ([admittedly], your example shows several instances where we *do* know the meaning-- it is escaping what would otherwise be a type differentiator (number, quote, <, etc.) or what would otherwise be a block beginning (:,|,;) so that it starts some text instead. One issue would be sameline @ (without @{...}) -- … so we would need to allow it to be escaped as well-- same with !.
- Reasoning (agent's): sameline text is value-space, so it follows the strict rule of the opaque spans; prose is text-space and stays lenient.
- Open with Joseph: the set, and the strict rule (asked 2026-10-09).

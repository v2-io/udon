---
kind: definition
awaiting-second: true
awaiting-decision: false
needs-work: false
terms: [text, piece, run, embed]
per: []
depends: [def:string, rule:embeds-in-text, rule:inline-comments, rule:main-is-attribute, rule:missing-value, rule:opaque-span-raw-text]
consequences: [def:reading-option, def:node, rule:blank-line-whitespace-in-text, rule:key-holds-a-value, rule:list-items-whitespace-separated]
---

# text · piece · run · embed

*A «text» is an ordered sequence of «piece»s: «run»s of characters and «embed»s. It is what unquoted material on an element's or attribute's line becomes, and what prose becomes.*

## Terms

- **text:** an ordered sequence of zero or more «piece»s. A «text» can be an attribute's value (including `$main`) or, from prose, a child of an element.
- **piece:** one part of a «text»: a «run» or an «embed».
- **run:** a stretch of characters in a «text».
- **embed:** an inline element `|{…}`, a reference `@{…}`, or an inline comment `;{…}`, written inside a «text». An «embed» is always a «piece», "a distinct chunk of distinct text as if it were a word" (Joseph), never a value of its own, even when it is the only thing in a value slot ([[rule:embeds-in-text]]).

## Invariants

- Text on an element's own line is the element's `$main` attribute, never a text child ([[rule:main-is-attribute]]).
- A «text» with no pieces is empty: `:a \` gives an empty «text» ([[rule:missing-value]]).
- Spaces between «embed»s are «run»s: `|nav |{a} |{a}` gives `$main` the pieces `a`, `" "`, `a`.

## Examples

```udon
|p See |{a :href /docs \ the docs} and @{faq}. ;{todo}
|el :n ;{}
```
```tree
root
  |p
    :$main ‹See |{a :href ‹/docs› ‹the docs›} and @{faq}. ;{todo}›
  |el
    :n ‹;{}›
```

## Working notes

- **Joseph's words** (2026-10-09, `.int/STEWARD-VERBATIM.md`):
  > I am under the impression that any embedded construct is meant to be embedded in text/string, and that *on sameline* text is always assumed to be non-delimited text which ends with a *block* form of ;, |, or : -- whereas embedded forms just stay part of the text (which is probably the difference between text and a string-- text has any number of pieces some of which are not strings).

  > I am very comfortable having embeds always be a distinct chunk of distinct text as if it were a word for right now, yes. Don't forget comments show up in the AST--

- Whether a «text» whose only piece is one «embed» may be read as that embed is a reading option, not this definition ([[def:reading-option]]).
- Prose (body lines that aren't structure) is a source region that produces «text»; its own rules are Part V's. Joseph's question whether string, text and prose are clearly defined is awaiting his reply to the coordinator.
- Trees use the notation of `.int/ast-notation-proposal-a.md`, provisionally.

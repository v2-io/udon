---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: [embed, inline-element]
per: [inline-elements-in]
depends: [def:text, rule:embeds-in-text, rule:inline-comments, rule:opaque-span-raw-text]
consequences: [def:text, def:reading-option, rule:space-between-embeds, rule:inline-comments-kept, rule:prose-escaped-embeds]
---

# embed · inline-element

*An «embed» is a brace form written inside a «text»: an «inline-element» `|{…}`, a reference `@{…}`, or an inline comment `;{…}`. It is always a «piece» of its «text», never a value of its own.*

## Terms

- **embed:** an «inline-element» `|{…}`, a reference `@{…}`, or an inline comment `;{…}`, written inside a «text». An «embed» is always a «piece», "a distinct chunk of distinct text as if it were a word" (Joseph), never a value of its own, even when it is the only thing in a value slot ([[rule:embeds-in-text]]).
  - *Avoid:*
    - **"embedded form"** as a second name for the same thing. The rule cards use it (8 files, including the title of `rule:embeds-in-text`) while this definition says «embed». One of the two should go, or "embedded form" should name something else (see the working notes on Joseph's three forms).
    - **"brace form"** (Joseph, 2026-07-19: "brace-form are embeds"; 0.10.0 K9). It names the spelling, not the role, and would also cover `!{…}` and `!{{…}}`, which lite reserves.
    - **"inline form"** (0.9.1/0.10.0: `|{…}`, `;{…}`, `!{{…}}`, `!{…}`, `!{:kind:…}`), **"*{ constructs"** (Joseph, 2026-07-19), **"embedded construct"** (Joseph, 2026-10-08), **"embedded node"** (Joseph, 2026-10-08: "unclosed embedded |,;,@ nodes"; "embedded_node(a...)"): his and the agents' informal names.
    - **"segment"** (0.10.0: "a segment mid-flow").
    - **"emb-comment"**, **"emb-interp"** (Joseph's 2026-07-19 sketch notation).
    - **"inline annotation"** and **"embedded reference"** (0.10.1 for `;{…}` and `@{…}`).
    - **"embed"** for an *instance of embedding* in the vector sense. UDON's own README has "Self-Chunking for RAG/Embeddings" and an "Embedding Granularity" table.
- **inline-element:** an element written `|{…}`, as an «embed».
  - *Avoid:*
    - **"embedded element"** (Joseph's from 2011 ("Embedded element", `<(…)>`) through Dec 2025; retired by 0.9.1's glossary: "embedded (element) → inline element").
    - **"inline children"** (Joseph, Dec 2025, for sameline `|a |b |c`): a different thing, now "sameline elements" ([[rule:sameline-element-is-child]]).
    - **"inserted node child"** (udon-c `DECIDED.md`, 2011: "`|{node ...}` # Inserted Node child - effectively splits text to left and right").
    - **"inline element"** in HTML's sense. In HTML and CSS an inline element is one rendered in the line (`<em>`, `<a>`), as opposed to a block element (`<div>`, `<p>`). In lite, `|{div …}` is an «inline-element» of an HTML block element, and `|em` on its own line is not an «inline-element» of an HTML inline element.

## Invariants

- An «embed» is never a «value» on its own; `:x |{em hi}` gives `x` a «text» whose only «piece» is an «inline-element» ([[rule:embeds-in-text]]).
- An «inline-element» is an element. Only where it sits differs from `|name` written as its own line or later on a line.

## Working notes

- **Not reviewed with Joseph.** Moved here from [[def:text]] on 2026-10-09 so that «embed» and «inline-element» each have a card; their definitions are unchanged. Joseph: "we haven't correctly designed embeds yet or thought through the issues fully" (2026-10-09). Interiors, multi-line embeds and `$main` inside braces are all undiscussed.

- **Joseph's words:**
  > the thing that would least surprise me as a user is … In other words, the right thing to do is definitely treat ;{ as a continuation of the text, and an opening of something that is meant to be reduced to text.  All *{...} constructs, embeds if you will, are assumed to *reduce to more text* (even if, in the case of the comment, that text is "" (not including comment events)).
  >
  > — Joseph, 2026-07-19 (`history.jsonl` 16865)

  > correct -- brace-form are embeds, and are always meant to be reduced to or surrounded by text
  > ;{} is a no-op empty comment embed
  >
  > — Joseph, 2026-07-19 (`history.jsonl` 16906)

  > BTW... a symmetry question (probably a 0.10 question) -- would it make things more symmetrical to have a @{...} embed as well?
  >
  > — Joseph, 2026-07-19 (`history.jsonl` 16870)

  > there are / should be probably three distinct forms of many things. block/geometric, value, and embedded (or maybe it's embedded-value...) distinctly embedded in prose, where at least I have continued to loosely conflate value-form with embedded-form... (this is me thinking out loud, not necessarily asking for any resolution etc.)
  >
  > — Joseph, 2026-08-09 (quoted in `.int/pre-design/10-inline-elements-and-inline-comments.discussion.md`)

  > |{...} inline elements are critical for one of the most obvious use-cases-- xml/html
  >
  > — Joseph, 2026-09-29 (`.int/STEWARD-VERBATIM.md`)

  > I am under the impression that any embedded construct is meant to be embedded in text/string, … whereas embedded forms just stay part of the text
  >
  > — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

  > I am very comfortable having embeds always be a distinct chunk of distinct text as if it were a word for right now, yes.
  >
  > — Joseph, 2026-10-09 (`.int/STEWARD-VERBATIM.md`)

- **Readings of his usage (flagged):**
  - Since 2026-07-16 his noun for the family is "embed" (about a dozen uses: "comments in embeds", "a @{...} embed", "empty comment embed", "embed interiors"), and for the `|{…}` member "inline element" (2026-07-29, 2026-09-29). This card follows that. Before July he said "embedded element".
  - "embedded form" in his 2026-08-09 thinking is a *form category*, one of three ways a construct can be written (block/geometric, value, embedded), not a synonym for the construct. If that holds, "embedded form" would mean "the embedded way of writing something" and «embed» an instance of it. The cards currently use the two as synonyms.
  - His 2026-10-08 "unclosed embedded |,;,@ nodes" calls them nodes. In the tree they are «piece»s of a «text»; whether a «piece» is a node is a slice-D question.

- **Other agents' leans:** 0.9.1 and 0.10.0 chose "inline form" for the family and "inline element" for `|{…}`, retiring "embedded". The 2026-10-09 lite cards chose «embed» (def) and "embedded form" (rule cards).

- **Precedents:**
  - **XML:** "mixed content" is the content model; nothing names the embedded element as a different kind. It is an element.
  - **HTML/CSS:** "inline" vs "block" is a *rendering* category of the element type. The collision above is the largest one in this slice, because XML/HTML is the use case Joseph named for `|{…}`. Also: `<embed>` is an HTML element name, and "an embed" in web usage is embedded media.
  - **CommonMark / Pandoc:** "inlines", every piece of a paragraph, plain text included.
  - **Ruby (Prism, from memory):** `EmbeddedStatementsNode` for `#{…}` inside a string, `EmbeddedVariableNode` for `#@x`. A precedent for "embedded" meaning "inside a string/text".
  - **Racket Scribble:** `@`-expressions inside text bodies, a close cousin of lite's `|{…}` in prose.
  - **Templates (Liquid, Mustache):** "tags" and "output"/"interpolation"; "tag" collides with HTML.

- **Questions of meaning and affordance:**
  - An agent with no highlighting reading «embed» will picture "something embedded in text", which is right. It may also picture an `<embed>` or a vector embedding, which is wrong, and in UDON's RAG-oriented README the second is a live reading.
  - "inline element" reads as HTML's category to anyone who writes HTML. Using it for the *spelling* `|{…}` invites "is `|{div}` allowed?"-style confusion.
  - Does a reference `@{…}` belong in the same family as `|{…}`? It's an «embed» here and an opaque span ([[def:opaque-span]]) too. Being both is fine (one is a role in text, the other a lexical rule), but the two terms classify along different axes and a reader may expect them to partition the forms.

- **Candidates:**
  - For the family: «embed» (his current word); "embedded form"; "inline form" (0.10.0); "brace form" (spelling-based).
  - For `|{…}`: «inline-element» (current); "embedded element" (his older word, retired by an agent); "brace element".

- **My own lean (the vocabulary agent for values and text, Opus 5.5; an opinion):** «embed» for the family, since it is his recent word and names the role. "Embedded form" retired from the rule cards rather than kept as a synonym, unless his three-forms idea wants it for the category. For `|{…}` I lean, weakly, toward "embedded element" over «inline-element», because of the HTML collision in exactly the use case it exists for, and because it then pairs with «embed». It reverses a 0.9.1 retirement that an agent made, not Joseph.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- **«embed»** for the family (his word since July). Retire "embedded form" from rule cards as a synonym; a card that means the family says «embed».
- **`|{…}`: keep "inline element"**, his current word (2026-07-29, 2026-09-29: "|{...} inline elements are critical"). The HTML "inline" collision is real but mild: the spec defines it once, and XML/HTML authors will meet `|{div …}` in examples. I'd not reverse his recent usage for a collision he hasn't objected to.
- His 2026-08-09 "three forms" (block / value / embedded) is thinking out loud; nothing in lite needs a name for the form category yet.

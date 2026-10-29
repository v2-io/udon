---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
strength: provisional
terms: [opaque-span]
per: []
depends: [rule:opaque-span-raw-text, rule:opaque-span-escapes, rule:matched-pairs-need-no-escape, rule:newline-in-opaque-span-is-error]
consequences: []
---

# opaque-span

*An «opaque-span» is one of the delimited forms `@{…}` and `;{…}`, whose text lite carries without attaching meaning, under one rule for nesting, escapes and line ends.*

## Terms

- **opaque-span:** a reference `@{…}` or an inline comment `;{…}`. Its delimiters nest when matched ([[rule:matched-pairs-need-no-escape]]); inside it only `\\` and its own delimiters may be escaped ([[rule:opaque-span-escapes]]); it closes on its own line ([[rule:newline-in-opaque-span-is-error]]); and the «tree» holds the text between its delimiters, escapes resolved, with no meaning attached ([[rule:opaque-span-raw-text]]).
  - *Avoid:*
    - **"box"** (the 2026-09-01 FIX text; lite's pre-design files until 2026-09-29), **"envelope"** and **"explicit-typing envelope"** (0.9–0.10.0), **"capture"**, **"value capture"**, **"held span"** (0.10.1). All were names for `<…>` alone, and some for a wider family. None covers `@{…}` and `;{…}` the way this term does.
    - **"delimited span"**, **"delimited extent"** (0.10.0: anything closed by a printed closer, strings, lists and fences included): wider than this term.
    - **"opaque delimiters"**, **"opaque delimited spans"**, **"typed delimited values"** (Joseph, 2026-10-08): his phrasings of the same idea.
    - **"raw span"** / **"verbatim"**: 0.10.0's "verbatim" is the fence family, whose bodies take *no* escapes; an opaque span takes two.
    - **"span"** alone, which in the cards also means a source span (a node's position, kept in «meta»).

## Invariants

- A `[key]` interior shares the escape and matching rules ([[rule:key-escapes]]) but is not an «opaque-span»: its inside is read as a «value» ([[rule:key-holds-a-value]]).
- A `[…]` list is not an «opaque-span» ([[rule:list-items-whitespace-separated]]).

## Working notes

- **`<…>` is ordinary text (Joseph, 2026-10-29: not reserved, "such as html or xml"):** this card now covers `@{…}` and `;{…}` only. Notes below that discuss `<…>` are history, to move to a context file at the next edit.

- **Not reviewed with Joseph; drafted 2026-10-09.** The term was coined by the coordinating agent on 2026-10-08 and used back by Joseph the same day. Ten card files use it.

- **Joseph's words:**
  > 1. Depends on your definition of "meta" and "spans" and "opaque spans" -- I vote yes, raw text, for typed delimited values (<...>) and references @{...}.
  > …
  > With the opaque delimited spans (typed values and references) -- I think we can adopt an interim convention of matched braces, warn and pseudo-close span on newline, …
  >
  > — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

  > wrt "same tree" -- … Opaque spans for example now will be their own branch in the AST later, among other things.
  > …
  > I'm OK with your lean on the opaque escaping -- note that it is still allowing unescaped *matched* brackets …
  >
  > — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

  > I'm not worried about the string versions but I'm now wondering if, for the other opaque delimiters we might be better off in lite-0.1.0 at least only allowing \\ and \<opening-or-closing-delimiter> and *erroring* on every other backslash use …
  >
  > — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

  > OHH, btw-- I *do* think ;{...} comments, with essentially opaque spans [in between] with the same escape rules (matched {} and \ escape-all) as the others-- which *will* be available in prose.
  >
  > — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

- **Readings of his usage (flagged):**
  - His very first use questioned the word: "Depends on your definition of "meta" and "spans" and "opaque spans"". He took it up the same day, and in four messages used "opaque spans", "opaque delimited spans", "opaque delimiters" and "opaque escaping". So he uses "opaque" freely; "span" he flagged once.
  - In "comments, with essentially opaque spans [in between]" the *span* is the interior, not the whole form with its delimiters. The cards use it for the whole form. Which one the term names (form or interior) matters for sentences like "the span's own delimiters".
  - "Opaque spans … will be their own branch in the AST later" treats them as a group with a future of its own. That supports having a term for the group, not just for each member.

- **What the term groups:** three forms with different roles: a value (`<…>`), a reference (`@{…}`, an «embed», and also a value or key interior), and a comment (`;{…}`, an «embed»). What they share is lexical: how they end, what escapes, no newline, raw text kept. The term is a *lexical* class that cuts across the role-based classes («embed», «value»). That's useful for rules like [[rule:opaque-span-escapes]], and a trap if a reader takes it as a kind of tree node.

- **Precedents:**
  - "opaque" is standard for "carried without being interpreted": opaque types (C), opaque data, opaque tokens (OAuth).
  - "span": in compilers and parsers (Rust's `Span`, tree-sitter ranges) a span is a *source range*, never a construct. In HTML, `<span>` is an inline element, so `|{span …}` is an «inline-element» named span that is not an opaque span.
  - EDN keeps unknown tagged elements as "tag + value" without reading them; CBOR does the same for unknown tags. Both name the *tag*, not the delimited interior.
  - JSON, YAML, TOML and KDL have no such class; their raw forms are strings ("raw strings" in KDL and Rust: `r"…"`, `#"…"#`).

- **Questions of meaning and affordance:**
  - To a reader without highlighting, "opaque span" reads as "a stretch of source I can't see into", which is close. "Span" will be read as a source range by anyone who has written a parser, and that is lite's parser-implementer audience.
  - Is `;{…}` opaque in the same sense? Its interior is a comment's text, kept in the tree. "Opaque" fits; "span" fits less, since a comment is a node-like thing ([[rule:inline-comments-kept]]).

- **Candidates:** «opaque-span» (current); "opaque form" (avoids the source-span sense); "raw form"; "delimited raw text"; no group term, with each card naming its three forms.

- **My own lean (the vocabulary agent for values and text, Opus 5.5; an opinion):** "opaque form", for the whole construct with its delimiters, so "span" stays free for source positions in «meta». "opaque" is the useful half of the word, and Joseph uses it unprompted.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- **Keep "opaque span"**, which he used four times unprompted and builds on ("their own branch in the AST later"). The drafter's "opaque form" avoids the source-span sense; I'd pay for that collision on the other side instead: «meta» says "position", not "span", for where a node came from.
- Define it as the whole form with its delimiters, and say "its interior" where only the inside is meant.

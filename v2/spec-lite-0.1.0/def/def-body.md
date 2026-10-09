---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
terms: [body]
per: []
depends: [rule:fence-body-not-scanned, rule:fence-closer-is-a-line, rule:comment-block-owns-deeper-lines, rule:nested-attributes, rule:nesting]
consequences: [def:fence, def:comment]
---

# body

*A «body» is the lines that belong to a construct below the line it starts on. Lite's cards use the word for three things that behave differently: a «fence»'s lines up to its «fence-closer», a «comment-block»'s deeper lines, and an attribute's indented lines.*

## Terms

- **body:** the source lines after a construct's own line that belong to it rather than to its parent. As the cards use it now:
  - a **fence body**: every line between the «fence-opener»'s line and the «fence-closer», never scanned, ended only by the «fence-closer» ([[rule:fence-body-not-scanned]]);
  - a **comment-block's deeper lines**: every following line indented deeper than the `;`, never scanned, ended by a line at or left of that column ([[rule:comment-block-owns-deeper-lines]]);
  - an **attribute's indented lines** (the gap card `rule:attribute-bodies`): lines indented under an attribute, read as its value(s), ended by dedent; an attribute line there is an error ([[rule:nested-attributes]]).

## Invariants

- A «body» is a region of the «document», not a node. What it becomes in the «tree» differs: a fence's body string, part of a comment's text, an attribute's value(s).
- A «blank-line» never ends a «body» or changes its indentation ([[rule:blank-line-sets-no-indent]]).

## Examples

`````udon
|config
  :motd
    Welcome back.
  ; old
    :timeout 30
  ```sh
  make
  ```
`````

- Line 3 is `motd`'s indented line: parsed, and it becomes the value.
- Line 5 is the comment's deeper line: not parsed, comment text.
- Line 7 is the fence's body: not parsed, and only the closer ends it.

## Avoid

"Joseph" marks his own words; everything else is an agent's or a spec draft's.

- **deferred body, deferred block, deferred value, deferred content** — 0.9 (`spec/CORE.md` "a deferred block"), 0.9.1 ("a deferred value"), 0.10.0 ("deferred body", "takes deferred content"). Joseph, 2026-08-08: "Generally speaking, "deferred" somehow entered the vocabulary and I have no idea what it's supposed to indicate-- I assume it's just saying we're in blockmode instead of on the same line anymore." (`history.jsonl` L18796). "Deferred" also has an unrelated live meaning in the addressing theory (determination is deferred: "Directives are deferred generators", 2026-08-27).
- **assignment body, open body, open assignment body** — 0.10.0 ("`:label` under an open assignment body"). "Assignment" was 0.10.0's word for attribute and never reached lite.
- **value body** — 0.9 CORE, 0.9.1; and [[rule:nested-attributes]] ("A value body that genuinely starts with `:word` text").
- **block attribute, attribute-block, block attr line** — 0.9 CORE ("Block attr line"); Joseph, 2025-12-31: "sameline within attribute-block" (L6434), "attribute+value block lines" (L6428). These named the *attribute's line* when it stood on its own line, not the lines under it. Easy to confuse.
- **Multi-Line Values** — 0.9 CORE heading for the same region.
- **grim attribute** — 2011 (`udon-c/docs/DECIDED.md`: "GRIM ATTRIBUTES — act just like nodes except what would be the 'node-name' isn't a child of the parent but a unique, unordered attribute of the parent"). The ancestor of attribute values on following lines.
- **raw base, content base** (for a body's left column) — 0.10.0. Where a body's text starts is slice B's territory (the cards say "left edge").
- **inner section, inner document, first (inner) line** — Joseph's phrases for a fence body on 2026-10-08 (options 6–9). Descriptive, not candidate terms.
- **comment continuation** — 0.10.0 §8, for a comment's deeper lines (see [[def:comment]]).

## Working notes

- **Not reviewed with Joseph.** Joseph, 2026-10-09: "I haven't looked at any or been asked about any of those things … but the idea that they can just kind of organically be whatever would cause serious trouble really soon if allowed to continue." Every term here is provisional until he rules on it; `.int/lexicon-inventory-2026-10-09.md` lists where each came from.
- **The core question: one word, or one per construct?**
  - *What's shared:* each is the lines below a construct's own line that belong to it.
  - *What differs, and matters to a parser:*
    - how it ends: closer for a fence, dedent for the other two;
    - whether it's scanned: no for fence and comment, yes for the attribute;
    - whether a shallower line can stay inside it: yes, with a warning, for a fence; no for the other two.
  - One word invites a reader to assume one rule. An agent reading "the attribute's body" after a page of "the fence body is never scanned" may assume the attribute's lines aren't parsed either.
  - The cards use "body" about 60 times for fences, a handful for attributes, and once loosely for an element ("swallows `|el`'s whole body", [[rule:framed-comment-owns-deeper-lines]]).
- **Joseph's words, by construct.**
  - *Fence:* "fence body" (2026-10-08, many times: "a fence body's first line", "*transparent to fence body*"), "the fenced body", "body/fenced block". Settled in practice.
  - *Attribute:* 2026-10-09: "I *think* you might mean values as indented child blocks of an attribute? To which I agree there are some remaining items to discuss." (STEWARD-VERBATIM). 2026-08-08: "that's another area where attributes and element bodys/children differ: attributes are assumed to be a typed scalar until proven otherwise, whereas element body parts are assumed to be prose unless proven otherwise..." (L18796). *Reading:* he has used "body" for an *element's* lines ("element body parts", and 2026-08-08 "the body line", L18834), and "child blocks" for an attribute's. "Body" for an attribute's lines is the drafters' word, not his.
  - *Comment:* "comments everything in that block that is indented further" (2026-10-08); "child comments" for lines under a framed `;` (2026-10-09). No "body" from him for comments.
- **Collisions.**
  - **HTML `body`.** Lite's main objective includes XML/HTML ([[obj:represent-xml-html]]). `|html |body |p …` is a likely example, and Joseph has used it ("|html |body |a :href google.com", 2026-08-09, L18912). "The body's children" becomes ambiguous in exactly the documents lite is for.
  - **"child" in "child block".** Joseph's own phrase, but in lite an attribute's values are not «element» children ([[rule:main-is-attribute]]; he ruled out "*text children*", 2026-10-09). "Child block of an attribute" may suggest that the values are children.
  - **"block".** Lite already says "block" for indentation-owned regions ("comment block", "text block", Joseph's "their own block") and "block form" for `|name` vs `|{…}`. More uses of "block" weaken each one.
- **Precedents.** Heredocs and HTTP/email say "body" for what follows a header line. Python's grammar says a compound statement's "clause consists of a header and a 'suite'", the indented part. YAML says "block scalar" for indented scalar content, with "block" meaning the indentation style rather than a region. CommonMark says "content" for a fenced code block's lines. Java text blocks and C# raw strings say "content". None of these uses one word across constructs that close differently, apart from the generic "block".
- **Option sketches, for the coordinator to weigh:**
  1. «body» stays generic, always qualified ("fence body", "attribute body", "comment body"), with the differences stated per construct.
  2. «body» means only the fence body. An attribute's indented lines get their own term (Joseph's "child block", or "value lines", or "indented value"), and a comment's deeper lines are simply part of the «comment-block».
  3. No generic term: "the lines under X", in plain words, everywhere but fences.
- **My lean (this agent's):** option 2. "Fence body" is Joseph's settled usage; the attribute case is still open in substance (he said "there are some remaining items to discuss"), so its name can wait for that discussion rather than inherit "body" from 0.10.0's "deferred body"; and comments don't need a separate word. The HTML `body` collision pushes the same way.
- **Open, from the rules side:** the gap card `rule:attribute-bodies` (pre-design 74, 05) decides what an attribute's indented lines *are* (one text? stacked values? an element?). Its name probably follows from that answer.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- Agree with the drafter's option 2: **«body» only for fences** ("fence body" is his settled usage). A comment-block's deeper lines are just part of the comment-block. An attribute's indented lines wait for that discussion (item "values as indented child blocks of an attribute"), and should not inherit 0.10.0's "deferred body"; his own phrase "child blocks" is the candidate to start from.

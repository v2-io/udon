# Reorganization spike: is the six-part cut right? (2026-10-08)

*A fork of the coordinator, asked by Joseph's standing request ("launch a fork to do a reorg spike and come back with its solid opinion"). Subject: the six-part outline written into `main.outline.md` on 2026-10-08. Register: a proposal. Nothing here is decided.*

## Verdict

The six-part cut is close. The size is about right, and organizing by "what a parse produces" is the right top-level idea. But three of its cut lines put the same rule in two places, and one ordering is backwards. I'd change it in four specific ways, not start over:

1. **Gather every delimited form into one part.** The day's decisions all came in delimited families: opaque spans, quoted strings, `;{…}`, fences, unclosed-is-an-error, newline-is-an-error, and which escapes apply. The six-part cut spreads those across Values (strings, lists, opaque spans) and Text (inline forms, fences). The rules that make them one family — how each one ends, what a newline inside does, what a backslash does, that an unclosed one is an error — would then be stated four or five times. One part shows them side by side. It also makes the differences visible on purpose: strings follow Ruby, spans take "any `\X` gives X", fences close at N or more backticks and are the one form allowed to span lines.
2. **Put each rule's errors in the rule; make the inventory a generated view.** `rule:anomaly-inventory` restates what every rule already has to say. That is the two-places pattern the SOP side has already removed twice (`affects`, `questions:`). Each record gets "Errors" and "Warnings" sections; the inventory becomes a view built from them, as the lexicon is built from `def/` ([[decision:lite-lexicon-in-def]]).
3. **Move the reserved list up next to the markers.** `rule:markers` (Part II) says "what is reserved where", but `rule:reserved-spellings` is in Part VI. Reserved spellings are just markers that lite refuses, so they belong in the same place.
4. **Recognize "bodies" as one thing.** An element's deeper lines and an open label's deeper lines follow the same geometry (K5/K7: an attribute's body is content, like an element's), and Joseph wants one rule for both kinds of line. The six-part cut puts element text in Text and label bodies in Elements-and-attributes. One "Bodies" part covers what lines deeper than an owner hold, including the label-under-open-value error and late attributes.

Small folds that follow:

- **`rule:missing-value`** is one sentence; it goes in the line scan's errors.
- **`rule:repeated-labels`** is a question about tree shape (pre-design 13 Q4), so it goes in the tree definitions.
- **`rule:escapes`** as a normative record would restate the owners' rules. Each form owns its backslash. A companion view, "every backslash in lite", is still worth having for agents.
- **`rule:markdown-in-text`.** Every collision it would list is a consequence of the marker guards, a reserved line start, or the fence rule. Stated as a rule it duplicates them. Make it a companion with counter fixtures. The objective that needs it ([[obj:markdown-text-passes-through]]) asks that the collisions be *named*, and a companion names them.
- **`rule:source-text`** and **`rule:whitespace-and-columns`** both describe the raw line before any UDON rule. Merge them.

## Where to draw the lines between record, fixture and companion

- **Record:** a rule a conforming parser must implement, resting on a decision or a principle. It states the rule once, gives its errors and warnings, and says why.
- **Fixture:** any specific input and its tree or error. Edge spellings (`5.`, `0755`, `|[]`, `<>`) are fixtures, pinned by one sentence in the record that owns them, not a row each. The records carry the principle; `dat/` carries the cases.
- **Companion:** anything that can be derived from the records: the anomaly inventory, the escapes overview, the Markdown collisions, the data mappings, the one-page tour, advice on writing lite. Where it can be generated, it is generated. A companion never introduces a rule.

## Order

Lexical forms before structure, as in any language spec that has a lexer: the line scan treats a quoted string, a list or a `<…>` as one token that ends at its closer. So the delimited forms come before the line, and the line can say "a self-delimiting value (Part III) ends at its closer" without a forward reference.

Fences are the exception. They are delimited, but they are also nodes at a structure position, and their body is a body. The delimited part states their closing rule beside the others, and the Bodies part places them. The alternative is to place the whole fence record in Bodies and have the delimited part point to it; I'd take the first, because the closing rules are where the day's decisions were made.

Some forward references remain: "structure position" is used by fences, markers and comments, and it is defined in the line part. Define it in Part I's vocabulary (`def:node` or a small `def:position`), so the order holds.

## Proposed outline

| Part | Record | What it says | Pre-design |
|---|---|---|---|
| **I — What a parse produces** | `def:document` | «document», «tree», «root-node», «meta» | 84 Q4 |
| | `def:node` | Element (optional name, ordered attributes, ordered children), text, comment, fence; what each carries; `$main`'s place; structure positions | 13, 60, 61 |
| | `def:value` | «typed-value» explicit and implicit, «reference», lists, elements as values; what a repeated label gives a consumer | 65, 66, 72, 13 Q4 |
| | `def:anomaly` | «error» (parsing stops, no tree) and «warning» | 12 |
| | `rule:tree-transcript` | The one written form of a tree, for fixtures and cross-language parsers | 86 |
| **II — Lines and columns** | `rule:lines-and-columns` | UTF-8, BOM, line endings, final newline; «empty-line» and «blank-line»; only U+0020 sets columns, and other whitespace that could shift a column is an error | 63, 79, 80 |
| | `rule:nesting` | The one nesting rule; same-line items at their true columns; blank lines never change it; comment lines and fence closers are lines; where blank lines sit | 52, 55, 90 |
| **III — Delimited forms** | `rule:delimited-forms` | The shared law: every delimited form closes only at its closer; unclosed is an error; a newline inside is an error unless the form says otherwise; matched pairs need no escape | 05 |
| | `rule:quoted-strings` | `"…"` and `'…'` as in Ruby, in values, names and labels | 75 |
| | `rule:lists-and-keys` | `[…]` as a list and as a `[key]`: items, separators, empty, nesting | 83, 89 |
| | `rule:opaque-spans` | `<…>`, `@{…}`, `;{…}`: raw text in the tree, any `\X` gives X | 07, 89 |
| | `rule:inline-elements` | `\|{…}`: its extent, attributes versus interior text, several on one line | 10, 50, 51 |
| | `rule:fence-closing` | Openers of N or more backticks, no backtick in the label, the closer and what may follow it; how this differs from CommonMark | 11 Q3 |
| **IV — The line** | `rule:markers-and-reserved` | What opens what at a structure position; the guards; the bare reserved list and where it applies | 09, 56, 87 (part) |
| | `rule:element-head` | Names, keys, traits, the former suffix characters, anonymous elements, quoted names; duplicate name-and-key pairs | 06, 54, 58, 61, 69, 76, 77 |
| | `rule:line-scan` | Who owns the rest of a line, on element and attribute lines alike: `$main`, where an unquoted value ends, same-line elements as children or an open label's value; a label with no value is an error | 01, 02, 53, 71, 73, 12 Q2 |
| | `rule:bare-values` | The frozen typed set and every edge spelling, pinned by fixtures | 66, 72 |
| **V — Bodies** | `rule:bodies` | What lines deeper than an owner hold, for an element and an open label alike: the left edge, dedent with a warning, deeper marker lines as text, the top level; a label's first body line is typed; a label under an open value is an error; attributes after content warn | 04, 57, 64, 74, 81, 88 |
| | `rule:comments` | `;` blocks and what they own; framed ` ; ` on node lines; mid-text ` ; ` is text; `;{…}` in text | 03, 59, 78 |
| | `rule:fences` | Where a fence opens and whose child it is; the body is never scanned; first-line dedent; `-` for verbatim; indentation in meta | 11 |
| | `rule:text-escapes` | `\` in text and on lines: the line-start escape, the column anchor, `\|{` and its kin | 82 |
| **VI — Files** | `rule:documents-and-files` | One document per file; whether a file says it is lite | 84 |
| **Companions** (derived; not the spec) | `view:anomalies` | Every error and warning, generated from the records | — |
| | `view:backslash` | Every use of `\` in lite, in one place | 02, 82 |
| | `expl:markdown` | What Markdown survives, and the named collisions, each with a counter fixture | 08, 87 |
| | `expl:lite-in-one-page`, `expl:data-mappings`, `expl:common-mistakes`, `expl:writing-lite`, `prop:append-safety` | as in the current outline | 62, 68, 85, 86 |

That's 21 spec records, against 27 in the current cut, with the same coverage.

## What I'm less sure of

- **The order of III and IV.** Lexer first is the textbook order, but a newcomer meets `|el :a 1` before `<…>`. The definitions in Part I already introduce every value kind, so I think the textbook order holds up. If the first draft of `rule:line-scan` keeps needing to explain delimited forms, swap them.
- **Whether `rule:delimited-forms` is a record of its own or the opening section of Part III.** It states a law that each form then applies. As a record, it can be cited (`per:`) and checked. I'd keep it as a record.
- **`rule:text-escapes`.** It may turn out to be two sentences, and it could fold into Bodies. Draft it and see.
- **Size.** Even 21 records may come out at 15–25 pages, about four times JSON's spec. That's the price of mixed content plus indentation, and it is still small. The size check worth running after drafting is Joseph's 2026-08-10 one: if simplification grows the spec, something went the wrong way.

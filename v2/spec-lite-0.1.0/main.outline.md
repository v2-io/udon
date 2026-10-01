---
family: lite
version: 0.1.0
---
# *Specification*: UDON Lite
***The non-dynamic subset of UDON***

# Contributing

How this corpus is worked (record kinds, their fields, row-types, references, decisions, and how outlines like this one work) is in the Standard Operating Procedures (SOP) store, which has its own outline: [`sop/main.outline.md`](sop/main.outline.md). Start there to learn the conventions used for this spec. Some basic templates and info are provided below. There are other examples if desired in `.old/vsect-init/**` although they were written based on some random things in influx (now `.int`) and before the SOPs were fully developed.

### Legend / Key
| Column | Meaning |
|---|---|
| Row-type | `example`: a drafted sample showing a record done to the SOPs; it never lands as it stands.<br>`proposed`: a candidate record, usually with no document yet.<br>The others (`gap`, `template`, `exploratory`, `landed`) are in [[sop/conv:row-type]]. |
| Record | `[[kind:slug]]`, resolved through [`.vsect/kinds.yaml`](.vsect/kinds.yaml). |
| Statement | This view's one-line gloss. For a row with no document, the question its record has to answer. |

This view shows no ※ or ∂ columns until a linter exists to compute them ([[sop/decision:no-computed-columns-yet]]).

### Example Documents

| Row-type | Record | Statement |
|---|---|---|
| example | [[obj:reserve-dont-ignore]] | Any «document» a lite parser accepts produces the same «tree» under every future full version |
| example | [[prin:simplest-grammar-without-surprise]] | Among alternatives that meet the objectives, prefer the simpler grammar or rules, unless it violates least surprise |
| example | [[def:document]] | «document», «tree», «root-node», «meta»: the source, what it parses to, the implied root, and parser-supplied information about nodes |
| example | [[def:typed-value]] | «typed-value» (explicit `<…>` / implicit bare), «type-label» |
| example | [[rule:implied-root]] | Exactly one «root-node», never spelled; top-level items are its children in order; it may carry «meta» |
| proposed | [[prop:forward-stability]] | Do lite's rules meet [[obj:reserve-dont-ignore]]: no accepted «document»'s tree changes under a full parser? |

# The specification

*The skeleton in the order the spec is meant to be assembled: each part uses only what comes before it. Rows are `proposed` until their records are written; `gap` marks a known hole whose records aren't yet named. Numbers in parentheses are the pre-design questions in `.int/pre-design/` that a row's record will have to answer; they move into the record's working notes when it is drafted. Rows will split and merge as records are drafted: reordering or re-cutting a row costs nothing.*

## *Part* 0 — Purpose

*What lite is for. Every later decision is argued from these.*

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[obj:reserve-dont-ignore]] | Any «document» a lite parser accepts produces the same «tree» under every future full UDON |
| proposed | [[obj:data-and-document-layout]] | Is lite usable now as the corpus's alternative to XML/HTML, YAML and JSON, for data and for document layout? |
| gap | | The other objectives, principles and requirements; a principles survey is under way (`.int/principles-survey-2026-10-01.md`) |

## *Part* I — Vocabulary and the tree

*What a parse produces, named before the rules that produce it, because lite is specified as the tree.*

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[def:document]] | «document», «tree», «root-node», «meta» |
| proposed | [[def:node]] | What kinds of node a «tree» holds (element, text, comment, reserved span) and what each carries (13) |
| proposed | [[def:typed-value]] | «typed-value», explicit `<…>` and implicit, and what "bare" means (66, 72) |
| proposed | [[def:anomaly]] | «anomaly», warning, error, keep-shape (12) |
| proposed | [[rule:tree-transcript]] | One written form of the «tree», so fixtures and parsers can be compared mechanically (86) |

## *Part* II — Source text

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:encoding-and-lines]] | What a line is: UTF-8, BOM, CRLF, a final newline, and invalid bytes (79) |
| proposed | [[rule:columns-and-indentation]] | How columns count, including after non-ASCII text; what a tab in indentation does (63, 79 Q4) |

## *Part* III — Structure

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:implied-root]] | Exactly one «root-node», never spelled; top-level items are its children (04, 84, 89) |
| proposed | [[rule:nesting]] | Deeper is a child, the same column a sibling, shallower closes; siblings at different columns (52) |
| proposed | [[rule:blank-lines]] | What a blank line ends, and where it sits in the «tree» (55, 90) |
| proposed | [[rule:comment-lines]] | What a `;` comment line owns: its own line, or the deeper lines under it too (78) |

## *Part* IV — The element line

*Everything from `|` to the end of an element's first line.*

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:element-names]] | Which characters open and continue an element name; case; Unicode (76, 69, 08) |
| proposed | [[rule:suffix-characters]] | What `? ! * +` are once their special status is gone (06) |
| proposed | [[rule:keys-and-traits]] | What `[…]` and `.trait` hold, how many, and duplicate name-and-key pairs (77, 54, 58) |
| proposed | [[rule:anonymous-elements]] | Which spellings open a nameless element, and what the «tree» says for it (61) |
| proposed | [[rule:line-ownership]] | Who owns the rest of a line after the name, on an element's line and on an attribute's line alike (01, 02, 51, 53, 71, 73) |

## *Part* V — Attributes and values

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:attribute-lines]] | Where `:label` lines may sit under an element, and attributes written after content has begun (88, 12 Q3) |
| proposed | [[rule:values-below-the-label]] | Values written on the lines under a label, including elements as values (74, 64) |
| proposed | [[rule:unquoted-values]] | How far an unquoted value runs, and which spaces are part of it (71, 80) |
| proposed | [[rule:quoted-strings]] | Quote kinds, what a string may contain, strings across lines (75, 05) |
| proposed | [[rule:implicit-typing]] | Which bare spellings are numbers, booleans or nil, if any (66, 72) |
| proposed | [[rule:explicit-typed-values]] | Where `<…>` ends, whether it spans lines, what the «tree» carries, where it may appear (07, 89) |
| proposed | [[rule:lists]] | `[…]`: separators, empty, nesting, across lines (83, 05) |
| proposed | [[rule:repeated-labels]] | What a label written more than once gives a consumer (65, 13 Q4) |
| proposed | [[rule:missing-value]] | A `:label` with no value (12 Q2) |

## *Part* VI — Text

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:text-blocks]] | The content base, dedentation, lines that shift left, marker lines inside text, which spaces and line breaks are content (04 Q1, 81, 57, 80) |
| proposed | [[rule:escapes]] | The whole escape set and where each works (82, 02) |
| proposed | [[rule:inline-elements]] | `\|{…}`: its extent, attributes versus interior text, several on one line (10, 50, 51) |
| proposed | [[rule:inline-comments]] | `;{…}` and ` ; ` inside text (03, 10 Q2, 59) |
| proposed | [[rule:fences]] | Lite's only raw form: fences as values, byte-exact or stripped, fences holding backticks (11) |
| proposed | [[rule:markdown-in-text]] | What lite says about Markdown in text, including tables and pipes (87, 08) |

## *Part* VII — Reserved syntax

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:reserved-spellings]] | Exactly which spellings lite refuses, and where: `!`, `@`, interpolation, and any floated or near-miss forms (09, 56, 62, 87) |
| proposed | [[rule:reserved-keep-shape]] | What the «tree» keeps for a refused spelling, and for the lines under it (09 Q2–Q3) |

## *Part* VIII — Validity

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:valid-lite]] | What "a lite parser accepts" means (12 Q1) |
| proposed | [[rule:anomaly-inventory]] | Every anomaly lite reports: trigger, severity, what is kept (12) |
| proposed | [[rule:limits]] | Nesting and size limits, and one-pass reading (91) |

## *Part* IX — Files

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:documents-and-files]] | Documents per file, and whether a file says it is lite (84) |

## *Part* X — Properties of the rule set

*Derived claims about the rules, each refutable by a counterexample and checked by someone other than its author.*

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[prop:forward-stability]] | Do lite's rules meet [[obj:reserve-dont-ignore]]? |
| proposed | [[prop:determinacy]] | Does every input give exactly one «tree» and one anomaly list? |
| proposed | [[prop:equivalences]] | Which different spellings give the same «tree», and which differ only in ornament (60, 85) |
| proposed | [[prop:append-safety]] | Does appending a top-level block ever change what came before? (68) |

## *Part* XI — Teaching and mappings

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[expl:lite-in-one-page]] | The whole of lite, for a newcomer |
| proposed | [[expl:data-mappings]] | How lite trees correspond to JSON, YAML and XML, and what each loses (86) |
| proposed | [[expl:common-mistakes]] | Near-miss spellings from other notations, each with its counter fixture (62) |
| proposed | [[rule:writing-form]] | Whether lite says how tools should write lite (85) |

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
| example | [[def:document]] | «document», «tree», «root-node», «meta»: the source, what it parses to, the implied root, and parser-supplied information about nodes |
| example | [[def:typed-value]] | «typed-value» (explicit `<…>` / implicit bare), «type-label» |
| example | [[rule:implied-root]] | Exactly one «root-node», never spelled; top-level items are its children in order; it may carry «meta» |

# The specification

*Organized by what a parse produces, lexer before structure: each record uses only what comes before it. Rows are `proposed` until their records are written. "Rests on" names the decisions in `adr/` a record will cite in its `per:`; numbers in parentheses are the pre-design questions in `.int/pre-design/` it still has to answer (they move into its working notes when it is drafted). Rows will split and merge as records are drafted; reordering costs nothing. Organization: [[decision:spec-organization-delegated]]; this cut follows the reorg spike in `.int/reorg-spike-2026-10-08.md`.*

*Three kinds of thing, kept apart. A **record** states a rule a conforming parser must implement, once, with its own errors and warnings and why. A **fixture** (`dat/`) is a specific input and its tree or error; every edge spelling is a fixture, pinned by one sentence in the record that owns it. A **companion** is derived from the records, generated where it can be, and never introduces a rule.*

## *Part* I — What a parse produces

| Row-type | Record | Statement | Rests on |
|---|---|---|---|
| proposed | [[def:document]] | «document» (the source), «tree», «root-node», «meta» (84 Q4) | implied-root, ast-centric, forward-compat-aspiration |
| proposed | [[def:node]] | Element (optional name, ordered attributes, ordered children), text, comment, fence; what each carries; where `$main` sits; structure positions (13, 60, 61) | line-ownership-main, sameline-element-is-child |
| proposed | [[def:typed-value]] | «typed-value» explicit and implicit, «reference», lists, elements as values; what a repeated label gives a consumer (65, 66, 72, 13 Q4) | explicit-typed-value-in, term-typed-value, references-in, node-valued-attributes-in, opaque-spans |
| proposed | [[def:anomaly]] | «error» (parsing stops, no «tree») and «warning» (correct lite that may not do what was meant) (12) | errors-stop-parsing, reserved-is-an-error |
| proposed | [[rule:tree-transcript]] | The one written form of a «tree», so fixtures and parsers in different languages compare mechanically (86) | ast-centric |

## *Part* II — Lines and columns

| Row-type | Record | Statement | Rests on |
|---|---|---|---|
| proposed | [[rule:lines-and-columns]] | UTF-8, BOM, line endings, final newline; «empty-line» and «blank-line»; only U+0020 sets columns, and other whitespace that could shift a column is an error (63, 79, 80) | blank-and-empty-lines, column-shifting-whitespace-is-an-error |
| proposed | [[rule:nesting]] | The one nesting rule; items later on a line sit at their true columns; blank lines never change it; comment lines and fence closers are lines; where blank lines sit in the «tree» (52, 55, 90) | sameline-element-is-child, implied-root, blank-and-empty-lines, fence-closer-is-a-line |

## *Part* III — Delimited forms

| Row-type | Record | Statement | Rests on |
|---|---|---|---|
| proposed | [[rule:delimited-forms]] | The shared law: a delimited form closes only at its closer; unclosed is an error; a newline inside is an error unless the form says otherwise; matched pairs need no escape (05) | errors-stop-parsing, opaque-spans |
| proposed | [[rule:quoted-strings]] | `"…"` and `'…'` as in Ruby, in values, names and labels (75) | quoted-strings-like-ruby |
| proposed | [[rule:lists-and-keys]] | `[…]` as a list and as a `[key]`: items, separators, empty, nesting (83, 89) | errors-stop-parsing |
| proposed | [[rule:opaque-spans]] | `<…>`, `@{…}`, `;{…}`: raw text in the «tree», any `\X` gives X (07, 89) | opaque-spans, explicit-typed-value-in, references-in, inline-comments-in-prose |
| proposed | [[rule:inline-elements]] | `\|{…}`: its extent, attributes versus interior text, several on one line (10, 50, 51) | inline-elements-in |
| proposed | [[rule:fence-closing]] | Openers of N or more backticks, no backtick in the label, the closer and what may follow it; how this differs from CommonMark (11 Q3) | fence-nesting-by-length, fence-closer-is-a-line, fence-line-comments |

## *Part* IV — The line

| Row-type | Record | Statement | Rests on |
|---|---|---|---|
| proposed | [[rule:markers-and-reserved]] | What opens what at a structure position, the guards, and the bare list of what lite refuses and where (09, 56, 87 in part) | reserved-list-form, reserved-is-an-error, reserved-line-starts-in-prose, references-in, suffixes-lose-special-status |
| proposed | [[rule:element-head]] | Names, keys, traits, the former suffix characters, anonymous elements, quoted names; duplicate name-and-key pairs (06, 54, 58, 61, 69, 76, 77) | suffixes-lose-special-status, quoted-strings-like-ruby |
| proposed | [[rule:line-scan]] | Who owns the rest of a line, on element and attribute lines alike: `$main`, where an unquoted value ends, same-line elements as children or as an open label's value; a label with no value is an error (01, 02, 53, 71, 73, 12 Q2) | line-ownership-main, sameline-element-is-child, node-valued-attributes-in, errors-stop-parsing |
| proposed | [[rule:bare-values]] | The frozen typed set — integers, floats, booleans, nil — and every edge spelling, pinned by fixtures (66, 72) | term-typed-value |

## *Part* V — Bodies

| Row-type | Record | Statement | Rests on |
|---|---|---|---|
| proposed | [[rule:bodies]] | What lines deeper than an owner hold, for an element and an open label alike: the left edge, dedent with a warning, deeper marker lines as text, the top level; a label's first body line is typed; a label under an open value is an error; attributes after content warn (04, 57, 64, 74, 81, 88) | node-valued-attributes-in, nested-attributes-reserved, blank-and-empty-lines, errors-stop-parsing |
| proposed | [[rule:comments]] | `;` blocks and what they own; framed ` ; ` on node lines; mid-text ` ; ` is text; `;{…}` in text (03, 59, 78) | framed-comments-on-node-lines, inline-comments-in-prose |
| proposed | [[rule:fences]] | Where a fence opens and whose child it is; the body is never scanned; first-line dedent; `-` for verbatim; indentation in «meta» (11) | fence-body-indentation, fence-closer-is-a-line, fence-line-comments |
| proposed | [[rule:text-escapes]] | `\` in text and on lines: the line-start escape, the column anchor, `\|{` and its kin (82) | — |

## *Part* VI — Files

| Row-type | Record | Statement | Rests on |
|---|---|---|---|
| proposed | [[rule:documents-and-files]] | One document per file; whether a file says it is lite (84) | implied-root |

## *Companions* — derived from the records; not the spec

| Row-type | Record | Statement | Rests on |
|---|---|---|---|
| proposed | [[view:anomalies]] | Every error and warning, generated from the records | — |
| proposed | [[view:backslash]] | Every use of `\` in lite, in one place (02, 82) | — |
| proposed | [[expl:markdown]] | What Markdown survives, and the named collisions, each with a counter fixture (08, 87) | — |
| proposed | [[expl:lite-in-one-page]] | The whole of lite, for a newcomer | — |
| proposed | [[expl:data-mappings]] | How lite trees correspond to JSON, YAML and XML, and what each loses (86) | — |
| proposed | [[expl:common-mistakes]] | Near-miss spellings from other notations, each with its counter fixture (62) | — |
| proposed | [[expl:writing-lite]] | Advice for tools and people who write lite: indentation, where closers go, quoting (85) | — |
| proposed | [[prop:append-safety]] | Does appending a top-level block ever change what came before? (68) | — |

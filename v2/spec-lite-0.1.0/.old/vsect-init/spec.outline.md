```
family: lite
version: 0.1.0
```
# *Specification*: UDON Lite
***The non-dynamic subset of UDON***

**Canon view** over `def/`, `src/`, and `fixtures/`. **Register: proposed skeleton (2026-09-30), not adopted.** Each row is one record; most rows are `proposed`, meaning the record does not exist yet and the row's text is the question or intended claim. The kinds, fields, and conventions are argued in [`proposed-verisectorium.md`](proposed-verisectorium.md).

**How to read the columns.** Each column mirrors a frontmatter field of the record it lists, except *Statement*, which is this view's own one-line gloss:

| Column | Field | Meaning |
|---|---|---|
| State | `state` | `proposed` (no file yet) · `drafted` (file exists) · later flags as they are earned; never a promotion ladder |
| Kind | `kind` | what the record does and how it fails; see the proposal's kind table |
| Slug | filename | identity; the prefix names the kind (`obj-` `prin-` `rule-` `prop-` `expl-` `def-`) |
| Statement | *(view's own)* | the rule or claim in one line; for an open row, the question, not a guessed answer |
| Per | `per` | keys of `DECISIONS.md` entries this record rests on |
| Open | `questions` | pre-design question numbers (`influx/pre-design/NN-*`) still open against it |
| Max | `max` | the strongest standing the record can reach: `decided` for choices, `exact` or `conditional` for derived properties |

Fixture counts, check results, and parser agreement are deliberately **not** columns. They are evidence to be computed from `fixtures/` and parser runs (by vsect, later), never typed into a view.

---

## *Part* 0 — Purpose

*What lite is for, and the tie-breakers used to choose among rules that all serve it.*

| State | Kind | Slug | Statement | Per | Open | Max |
|---|---|---|---|---|---|---|
| drafted | objective | [[obj-reserve-dont-ignore]] | Any document a lite parser accepts produces the same tree under every future full version | reserve-not-ignore | 09 12 84 | decided |
| proposed | objective | [[obj-data-and-document-layout]] | Lite is usable now as an XML/HTML, YAML, or JSON alternative for data and document layout | *(README "What lite is for")* | 86 | decided |
| proposed | objective | [[obj-append-safety]] | Should appending a well-formed top-level block never change the meaning of what is already there? | — | 68 | decided |
| proposed | objective | [[obj-one-pass]] | Should a lite document be readable in one pass with bounded lookahead? | — | 91 | decided |
| drafted | principle | [[prin-simplest-grammar-without-surprise]] | Among alternatives that meet the objectives, prefer the simpler grammar, short of surprising the reader | — | — | decided |
| proposed | principle | [[prin-keep-everything]] | Recognition never silently drops author-written bytes; severity is loss (0.10.0 G7, not yet re-decided for lite) | — | 12 | decided |
| proposed | principle | [[prin-syntactic-typing]] | A value's type comes from its spelling, never from its content (0.10.0 G6, not yet re-decided for lite) | — | 66 72 | decided |

## *Part* I — Vocabulary

*The `def/` term-groups. A generated `LEXICON.md` is their view. The addressing theory's terms (`../references/def/`) are cited, not restated.*

| State | Kind | Slug | Statement | Per | Open | Max |
|---|---|---|---|---|---|---|
| drafted | definition | [[def-document]] | `document`, `root-node`, `meta`: one parse, one implied root, parser-supplied information about nodes | implied-root | 13 60 84 | decided |
| drafted | definition | [[def-typed-value]] | `typed-value` (explicit `<…>` / implicit bare), `type-label` | explicit-typed-value-in, references-vocabulary | 07 66 72 | decided |
| proposed | definition | [[def-element]] | element, name, key, trait, inline element, anonymous element | — | 06 61 76 77 | decided |
| proposed | definition | [[def-attribute]] | attribute, label, value, stacking | — | 65 83 | decided |
| proposed | definition | [[def-text]] | text, content base, blank line, prose | — | 55 57 80 | decided |
| proposed | definition | [[def-comment]] | comment and what it owns | — | 78 | decided |
| proposed | definition | [[def-anomaly]] | anomaly, warning, error, keep-shape, valid lite | — | 12 | decided |
| proposed | definition | [[def-reserved-span]] | a refused future spelling and what is kept for it | reserve-not-ignore | 09 | decided |
| proposed | definition | [[def-ornament]] | ornament vs meaning; content < content+meta < content+meta+ornament | — | 60 | decided |

## *Part* II — The tree

*What a parse produces. Lite is specified as this tree (decision `ast-centric`).*

| State | Kind | Slug | Statement | Per | Open | Max |
|---|---|---|---|---|---|---|
| drafted | rule | [[rule-implied-root]] | Exactly one root node, never spelled; top-level items are its children in order; it may carry meta | implied-root, ast-centric | 04 13 84 89 | decided |
| proposed | rule | [[rule-element-fields]] | Are `[key]`, `.traits`, and element-line material designated attributes or dedicated fields? | — | 13 58 | decided |
| proposed | rule | [[rule-element-line-material]] | Where does same-line material live: a `$main` attribute, or first children flagged `same_line`? | — | 01 13 73 | decided |
| proposed | rule | [[rule-attribute-shape]] | How repeated labels appear: ordered pairs, a label-to-list map, or a map with the default read | — | 13 65 83 | decided |
| proposed | rule | [[rule-text-nodes]] | One text node per line, merged runs, or paragraphs; which node owns a blank line | — | 13 55 57 | decided |
| proposed | rule | [[rule-comments-in-tree]] | Are comments nodes in the tree, and what does each own? | — | 13 78 | decided |
| proposed | rule | [[rule-node-meta]] | Which meta a lite tree carries: source line and column, span, `same_line`; what is ornament | — | 60 85 | decided |

## *Part* III — Source text and geometry

| State | Kind | Slug | Statement | Per | Open | Max |
|---|---|---|---|---|---|---|
| proposed | rule | [[rule-encoding-and-lines]] | UTF-8, BOM, CRLF, final newline, and how columns count after non-ASCII | — | 79 | decided |
| proposed | rule | [[rule-indentation]] | Spaces, tabs, and indentation units | — | 63 | decided |
| proposed | rule | [[rule-nesting]] | Deeper is a child, same is a sibling, shallower closes; inconsistent sibling columns | — | 52 81 90 | decided |
| proposed | rule | [[rule-blank-lines]] | What a blank line ends, and where it sits in the tree | — | 55 90 | decided |

## *Part* IV — Elements

| State | Kind | Slug | Statement | Per | Open | Max |
|---|---|---|---|---|---|---|
| proposed | rule | [[rule-element-names]] | Which characters may appear in element names and labels; case; sameness | — | 69 76 | decided |
| proposed | rule | [[rule-keys-and-traits]] | `[key]` contents, multiple keys, `.traits`, duplicates | — | 54 77 | decided |
| proposed | rule | [[rule-suffix-characters]] | `? ! * +` lose special status: ordinary name characters, or reserved? | suffixes-lose-special-status | 06 | decided |
| proposed | rule | [[rule-anonymous-elements]] | Nameless elements | — | 61 | decided |
| proposed | rule | [[rule-inline-elements]] | `\|{…}` is in: its extent, its attributes vs interior text, siblings on one line | inline-elements-in | 10 50 51 | decided |
| proposed | rule | [[rule-line-ownership]] | Who owns the rest of an element's or attribute's line (one scan rule for both line kinds) | — | 01 02 51 53 64 71 73 74 88 | decided |

## *Part* V — Attributes and values

| State | Kind | Slug | Statement | Per | Open | Max |
|---|---|---|---|---|---|---|
| proposed | rule | [[rule-attribute-lines]] | Where attribute lines may sit; values on following lines; element-valued attributes | — | 64 74 88 | decided |
| proposed | rule | [[rule-unquoted-extent]] | How far an unquoted value runs | — | 02 71 | decided |
| proposed | rule | [[rule-quoted-strings]] | Quote kinds, escapes, adjacent strings, strings across lines | — | 05 75 | decided |
| proposed | rule | [[rule-bare-values]] | Which bare spellings are numbers, booleans, or nil, if lite types bare values at all | — | 66 72 | decided |
| proposed | rule | [[rule-explicit-typed-value]] | `<…>` carried as text: where it ends, lines, label split, empty, where it may appear | explicit-typed-value-in | 07 89 | decided |
| proposed | rule | [[rule-lists]] | `[…]`: separators, empty, nesting, lists across lines, sequences of records | — | 05 65 83 | decided |
| proposed | rule | [[rule-missing-value]] | `:label` with no value | — | 12 | decided |
| proposed | rule | [[rule-late-attributes]] | Attribute lines after content has begun | — | 12 88 | decided |

## *Part* VI — Text, escapes, comments, and raw content

| State | Kind | Slug | Statement | Per | Open | Max |
|---|---|---|---|---|---|---|
| proposed | rule | [[rule-text-and-content-base]] | The content base and dedentation; structure inside indented text; which spaces are content | — | 04 57 80 81 | decided |
| proposed | rule | [[rule-escapes]] | The whole escape set | — | 02 82 | decided |
| proposed | rule | [[rule-comments]] | Comment forms and what each owns; ` ; ` in prose; where an inline comment may sit | — | 03 59 78 | decided |
| proposed | rule | [[rule-fences]] | Fences, lite's only raw form: as values, byte-exact vs stripped, fences containing backticks | — | 11 | decided |
| proposed | rule | [[rule-prose-and-markdown]] | Is prose Markdown? Collisions with Markdown | — | 87 | decided |
| proposed | rule | [[rule-pipes-and-tables]] | Pipes in prose and Markdown-style tables | — | 08 | decided |

## *Part* VII — Reserved syntax

| State | Kind | Slug | Statement | Per | Open | Max |
|---|---|---|---|---|---|---|
| proposed | rule | [[rule-reserved-spellings]] | Exactly which `!` and `@` spellings are refused, in which positions (including prose, `[key]`, and floated or near-miss spellings) | reserve-not-ignore | 09 56 62 87 | decided |
| proposed | rule | [[rule-reserved-keep-shape]] | What the tree keeps for a refused spelling, and for the lines indented under it | reserve-not-ignore | 09 | decided |

## *Part* VIII — Validity and anomalies

| State | Kind | Slug | Statement | Per | Open | Max |
|---|---|---|---|---|---|---|
| proposed | rule | [[rule-valid-lite]] | What "a lite parser accepts" means: no anomalies, no errors, or a list of forward-stable anomalies | — | 12 | decided |
| proposed | rule | [[rule-anomaly-inventory]] | Each anomaly: code, trigger, severity, keep-shape, forward-stable or not | — | 12 | decided |
| proposed | rule | [[rule-duplicate-keys]] | Two elements with the same name and key | — | 54 | decided |
| proposed | rule | [[rule-limits]] | Nesting and size limits | — | 91 | decided |

## *Part* IX — Documents and files

| State | Kind | Slug | Statement | Per | Open | Max |
|---|---|---|---|---|---|---|
| proposed | rule | [[rule-documents-per-file]] | One document per file, a separator, or one per top-level element | — | 84 | decided |
| proposed | rule | [[rule-lite-marker]] | How a file says it is lite (none, optional marker, filename, required marker) | — | 84 | decided |

## *Part* X — Properties of the rule set

*Derived claims about the rules. These are the truth-apt part of the spec: each can be refuted by a counterexample, and each needs a derivation or a mechanical check by someone other than its author.*

| State | Kind | Slug | Statement | Per | Open | Max |
|---|---|---|---|---|---|---|
| proposed | property | [[prop-forward-stability]] | The lite rule set meets [[obj-reserve-dont-ignore]]: no accepted document's tree changes under a full parser | — | 09 12 84 | conditional |
| proposed | property | [[prop-determinacy]] | Every input produces exactly one tree and one anomaly list | — | — | exact |
| proposed | property | [[prop-append-safety]] | If adopted: appending a top-level block never changes earlier meaning (needs fail-safes on delimited forms) | — | 68 | conditional |
| proposed | property | [[prop-one-pass]] | If adopted: a lite parser needs bounded lookahead only | — | 91 | exact |
| proposed | property | [[prop-equivalences]] | Which spelling pairs produce the same tree (meaning) and which differ only in ornament | — | 60 | exact |

## *Part* XI — Transcript and mappings

| State | Kind | Slug | Statement | Per | Open | Max |
|---|---|---|---|---|---|---|
| proposed | rule | [[rule-tree-transcript]] | A standard written form of the tree (e.g. JSON), used by fixtures and for comparing parsers | ast-centric | 86 | decided |
| proposed | explanation | [[expl-data-mappings]] | How lite trees map to JSON, XML, and YAML, and what each mapping loses (informative) | — | 86 | — |
| proposed | rule | [[rule-writing-form]] | Does lite say how tools write lite (canonical or preferred form)? | — | 85 | decided |

## *Part* XII — Explanation

*Teaching records. They describe rules and never add to them; each lists the records it describes, and is marked stale when one of those changes. Short explanations may instead sit as a marked section inside a rule file.*

| State | Kind | Slug | Statement | Per | Open | Max |
|---|---|---|---|---|---|---|
| proposed | explanation | [[expl-lite-in-one-page]] | The whole of lite, for a newcomer | — | — | — |
| proposed | explanation | [[expl-for-json-and-yaml-users]] | Lite for someone arriving from JSON or YAML: typical data layout | — | — | — |
| proposed | explanation | [[expl-for-xml-and-html-users]] | Lite for someone arriving from XML or HTML: mixed content, inline elements | — | — | — |
| proposed | explanation | [[expl-common-mistakes]] | The misguided spellings, each paired with its `counter` fixture | — | — | — |
| proposed | explanation | [[expl-reserved-and-why]] | What lite refuses and why a refusal is a promise, not a limitation | reserve-not-ignore | — | — |

---

## *Open questions*

*The pre-design files in `influx/pre-design/` are this corpus's open questions. Each closes into one or more `DECISIONS.md` entries plus the rows above that cite them; the question file then leaves influx by the delete-test. The **closer** column is my proposal for who can close each question, not a routing decision: **steward-purpose** needs Joseph because only what lite is for decides it; **agent-open** can be closed by any agent from the objectives and principles, with Joseph free to override; **awaiting** closes once the named question does.*

| Q | Question | Rows | Closer (proposed) | Standing |
|---|---|---|---|---|
| 01 | `\|a \|b`: child or value? | rule-line-ownership, rule-element-line-material | steward-purpose | lean recorded in STEWARD (`$main` reaffirmed; `same_line` meta) |
| 02 | Escape inside an open value | rule-unquoted-extent, rule-escapes | awaiting 01 | open |
| 03 | ` ; ` in prose | rule-comments | steward-purpose | open |
| 04 | Top-level text and `:labels` | rule-implied-root, rule-text-and-content-base | steward-purpose | root decided; Q1/Q2 open |
| 05 | Values across lines | rule-quoted-strings, rule-lists | awaiting 68 | open |
| 06 | Suffix characters | rule-suffix-characters | steward-fact (confirm the recollection) | direction decided |
| 07 | `<…>` exact rules | rule-explicit-typed-value | agent-open | in: decided; details open |
| 08 | Pipes and tables | rule-pipes-and-tables | steward-purpose | undecided ("left for later") |
| 09 | Reserved syntax | rule-reserved-spellings, rule-reserved-keep-shape | steward-purpose | contract decided; extent open |
| 10 | Inline elements and inline comments | rule-inline-elements, rule-comments | agent-open | in: decided; details open |
| 11 | Code blocks | rule-fences | steward-purpose | open |
| 12 | Anomalies and "valid lite" | rule-valid-lite, rule-anomaly-inventory, rule-missing-value, rule-late-attributes | steward-purpose | open |
| 13 | Tree shape | Part II rows | steward-purpose | AST-centric and root decided; Q1–Q6 open; leans in STEWARD |
| 50–69 | first survey's questions | as listed in the rows above | mostly agent-open | open |
| 67 | what live UDON documents actually contain (a census) | evidence for rule-line-ownership, rule-comments, rule-reserved-spellings; a candidate regression corpus for `fixtures/` | — | report (evidence), not a question |
| 70 | survey index | — | — | report, not a question |
| 71–91 | second survey's questions | as listed in the rows above | mostly agent-open | open |

## *Working Notes (outline-level)*

- **Conservation check (2026-09-30).** Every pre-design question number 01–13 and 50–91 appears in at least one row's Open column above, except 67 (a census of live documents) and 70 (an index). Both are reports, and the Open questions table routes them as evidence. I checked this with a script over the Open column (after un-escaping `\|`), not by eye. A question that fits no row would mean a missing row or a missing kind. I found none, but I read only the question *titles* for most of 50–91 (the proposal's coverage section says which I read whole), so a mis-placement inside a row is possible.
- **Group A** (STEWARD's name: 01, 02, 51, 53, 64, 71, 73, 74, 88) is one question about line ownership seen from several sides. It is one row, [[rule-line-ownership]], rather than nine, and [[rule-element-line-material]] records only where the result lives in the tree.
- **Ordering** is dependency order as far as it is known: the tree (II) comes before the syntax that produces it, because lite is AST-centric. If that reads backwards to a newcomer, the explanation view can teach in the other order. Teaching order and spec order are both views.
- Rows are only as good as their Statement column. Every `proposed` Statement is phrased as the question it has to answer, so no row asserts an answer that nobody has decided.

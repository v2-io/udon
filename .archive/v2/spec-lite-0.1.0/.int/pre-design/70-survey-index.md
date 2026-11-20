# 70 — Broad history survey: index (files 71–91)

## Who wrote this, and how

**Written by** Claude (Opus 5.5), 2026-09-29, as one of two independent broad-history surveys (the other numbers its files 50–69). **Brief:** surface nuance already worked through in UDON's past that files 01–13 miss; nothing found is treated as binding; new question files carry no leans.

**Read whole:** `v2/WHERE-THINGS-STAND-2026-09-27.md`; `spec-lite-0.1.0/README.md` and `pre-design/01–13`; `v2/spec-0.10.00/CORE.md`; `v2/DECISIONS.md`; `v2/OPEN.md`; `v2/msc/for-joseph/01-PLAIN-DECISIONS.md`; `v2/spec-0.10.00/{CARVEOUTS.md, working-notes/UNIF-PASS-QUESTIONS.md}`; `v2/JOSEPH-FOR-0.10.01-FIX.md` (an agent's text); `v2/INBOX-REQUESTS.md`; `v2/spec-0.10.01/{DELTAS.md, NUANCE-AUDIT.md, working-notes/AUDIT-2026-09-01.md, working-notes/spelling-grid.md}`; `v2/spec-0.09.01/udon-0.9.1-primer.md`; `v2/theory/to-integrate/refine-more/thoughts-on-multiline-array.md`; `v2/theory/to-integrate/primary/sameline-value-space-2026-08-08.md`; `design/examples/practices-gotchas.udon`; `design/file-naming.md`; `TOOLING-WISHLIST.md`; the 2011 originals `~/src/_older/udon-c/docs/{DECIDED,NOTES}.md`, `~/src/_older/udon/{doc/objectives.asciidoc, examples/overview.udon, examples/ws-and-comments.udon, doc/syntax.udon}`.

**Read in part:** `spec/msc/CHANGELOG.md` (rulings sections, lines 60–500); `spec/TODO-SPEC-CORE.md`; `_archive/SPEC.md` (0.7-draft, lines 41–380, 894–1123); `_archive/SPEC-INDENTS.md`; `design/udon-ast.md`; `~/src/_older/udon/.attic/syntax2.udon` (lines 255–360); `v2/.archived/INDEX.md`; `v2/.archived/second-pass/RULING-SUPPLEMENT.md` (L1–L7, S9); the grok night-session record `v2/.archived/second-pass/spikes/session-vault/raw/grok/019f67df-orientation.md` (lines 1500–1710); `v2/theory/to-integrate/refine-more/markdown/commonmark-non-conflict-table.md` (§§1–3); `_archive/spikes/prose-collision-2026-07.md`; `v2/udon-needs/02-tooling-needs/reports/yaml-stress-test.md` (headings, risk 6); `TODO-UTILS.md` (conversion/fmt); `bin/xml2udon`; `~/src/_older/udon-ruby/bin/json2udon`; `core/udon-core/src/parser.rs` (column counting).

**memorata-search** (classes `human-user agent-to-human document subagent-final-response`, or `--joseph`; 10 results each) on: sameline child vs `$main`; column-aligned siblings; semicolon in prose; root node / filename / top-level attributes; comment continuation; unquoted value extent; deferred attribute body; number edge cases; key/traits as id/class; element-name characters; tabs; Markdown tables; fences as attribute values; `<…>` closing in code; inline-element whitespace / HTML; nameless elements; JSON mapping; empty/nil/missing; blank lines; trailing whitespace; reserved/forward-compatible syntax; default indent unit; `\` column anchor; spaced traits; late attributes; `@` and `!` in prose; the one-way door; re-basing; file extension / pragma; YAML-style sequences; quoted names; Unicode identifiers; flags; streaming; lite/subset/XML-YAML-JSON; canonical JSON; Markdown in prose; namespaces; CRLF/BOM; quote escapes; commas in lists. Joseph's own words with layout intact were then re-taken from `~/.claude/history.jsonl` (memorata drops indentation and newlines); every multi-line UDON example quoted in 71–91 was re-read from its source file.

**Old parser, as labeled evidence only** (`core/target/debug/examples/dump_events`, 0.9-lineage, not an oracle): probed CRLF, non-ASCII columns, whitespace runs, number edges, and element-line typing. Results are marked "evidence only" where cited.

**Not read / not reachable:**
- `_archive/feedback.md` — its raw transcript contains model-thinking blocks; skipped per the platform caution. (It is the Dec-2025 first-contact review; `REVIEW-JULY-2026.md` quotes it.)
- Raw `.jsonl` session transcripts — not opened. Where memorata quoted a transcript, the quote is labeled with its source line.
- Most of `v2/udon-needs/01-ideation/`, `v2/references/`, `v2/theory/src/`, the 0.9 fixtures, the 0.10.01 fixtures, and `design/` beyond the files named above. Absence claims below are scoped to what was searched.

## Chronological list of past adjudications and discussions relevant to lite

Dates are when the text says it happened; "Joseph" marks his words, otherwise the source is an agent's or a spec's text.

| When | What | Where | Bears on |
|---|---|---|---|
| 2011 | Implied root node; its ID is the file path, name the basename; `:__` metadata attributes; not output in conversions | `_older/udon-c/docs/DECIDED.md` | 04, 13, 84 |
| 2011 | Values stop at "space plus `[|#.!:]`"; once text starts on a line, pipes are literal | same | 71 |
| 2011 | `\|one\|two\|three` ⇒ nested; `\|one \|two` + next line `\|three` at `\|two`'s column ⇒ siblings | same | 01, 08 |
| 2011 | `\| ` (pipe-space) begins a simple text value; `\|list \| one \| two` lists | same; `udon/examples/overview.udon` | 08, 83 |
| 2011 | `:` allowed in names and keys; namespaces `\|ns:type` / `\|ns/element` | DECIDED.md; `.attic/syntax2.udon`; overview.udon | 76 |
| 2011 | "Grim attributes": attribute whose value is a node; free text value on the next line | DECIDED.md | 74 |
| 2011 | Undecided: free text where indentation does not apply ("yaml-like? heredoc-like?"); `\|am I a node?` inside text | DECIDED.md | 11, 81 |
| 2011 | Comments with aligned continuation lines | overview.udon | 78 |
| Dec 2025 | 0.7-draft: sameline value = one token, block attribute value to end of line; valueless `:key` = true; `;` literal in block prose; `'` escape; `[id]`→`$id`; nil also `~`; rationals/complex bare | `_archive/SPEC.md` | 71, 72, 03, 82 |
| 2025-12-22 Joseph | "canonical 'json representation'" question; "missing … a clean syntax for lists. Maybe it doesn't need one?" | history.jsonl 5455, 5405 | 86, 83 |
| 2025-12-23 Joseph | corrects the `\|table \|tr \|td A1 \|td A2` example: same-line `\|td`s are not siblings; "embedding blocks in text doesn't necessarily give us a syntax (yet) for same-line-siblings" | history.jsonl 5470 | 01, 10 |
| 2025-12-24 Joseph | "prefer markdown in prose … we may need to consider markdown parsing as part of the core parsing" | history.jsonl 5567 | 87 |
| Dec 2025 | Prose dedentation; re-base with warning; "valid range" for text after a same-line child | `_archive/SPEC-INDENTS.md` | 01, 81, 73 |
| 2025-12-28 Joseph | `!:json:` block with automatic dedent is "the preferred way to have json snippets"; shallower continuation warns | history.jsonl 6059 | 11, 81 |
| 2026-01-01 Joseph | drop `~` as nil | memorata, libudon 31853cab…:8447 | 72 |
| 2026-01-02 Joseph | comment block semantics "just like the other block types … except a lot less to do inside it"; the same session's (agent) notes: block-prose `;` literal, line-start `;` a comment | memorata, libudon 31853cab…:9969, 9717 | 78, 03 |
| 2026-01-02 Joseph | `\|li.menu-item \|a :href /about About` = the three-line block form | history.jsonl 6973 | 01, 73, 13 |
| 2026-01-13 Joseph | flavors "udon-xml" (no complex attribute values), "udon-md"; "what the equivalent of the 'DOM' looks like"; "Can anything … in sameline form and inline form be implemented in pure block-like form?" | history.jsonl 7831–7832 | 13, 74, 86, 87 |
| Jan 2026 | `udon-ast.md`: no implicit root; key/traits with id/class aliases; `(name, key)` unique per type; typing only in attribute values | `design/udon-ast.md` | 04, 13, 73, 77 |
| 2026-07-11 Joseph | filename `<name>.<schema/type>.udon`, application-level | `design/file-naming.md` | 84 |
| 2026-07-14/15 | 0.8: `id`/`class` retired as wire names; bare numbers frozen to integer+float; all dates in `<…>`; `\` replaces `'`; spaced traits dropped | CHANGELOG | 72, 77, 82 |
| 2026-07-15/16 | 0.9 attribute model: values may be nodes; bare-token boundary rule (one token or to end of line); flags `:key?`; missing value = error + nil | CHANGELOG | 71, 74, 12 |
| 2026-07-17/19 | EOF: geometric vs delimited; `$partial-key`; empty brackets; `:a \` = ""; `\|{}` valid; text-wire recast; blank-line two layers; root `:key` "undefined" | CHANGELOG | 05, 12, 13, 89, 90 |
| 2026-07-20 Joseph | one token, then the element owns the rest of the line (markers there literal); a value started on the label's line continues on deeper lines; deeper text after a finished value is an error | grok night session L1572–1706 | 71, 74 |
| 2026-07-21 | L0 error = loss; L1 root `:key` → warning + text; L2 no in-string escapes; L4 tabs; L7 comment strip | `v2/DECISIONS.md` | 04, 12, 75, 78, 79 |
| 2026-07-28 | CommonMark measurement: only fences collide; ROOT-BASE and SEMI-BASE divergences; line-initial `\`, `@`, `!word`, `:key`, tight tables | `commonmark-non-conflict-table.md` | 03, 04, 08, 09, 87 |
| 2026-07-29 Joseph | "lean into the stacking … call it an array"; "a regulator that no one asked for"; file kinds atomic / multi-document / snippet with top-level `:attributes` | `thoughts-on-multiline-array.md`; history.jsonl 17797 | 74, 83, 84, 04 |
| 2026-08-07/09 | K1–K16 (multi-key, key = value slot, no attribute-of-attribute, explicit nil, first-line typing, `$main`, K10 value extent, K12 labels, K13 `\` split, K14 late attributes, K15 stacking flavors) | `v2/DECISIONS.md` | 01, 02, 06, 12, 13, 71–77, 82 |
| 2026-08-09 | D1–D11 left open (D3 escape join, D4 `:done?`, D9 keep suffix sugar, D11 late-attribute equivalence) | `msc/for-joseph/01-PLAIN-DECISIONS.md` | 02, 06, 12, 88 |
| 2026-09-01 | 0.10.1 audit: A2 forgotten `]`, A4 `\|a \|b`, A6 end-of-line comment vs body, D1 `<http://x>`, D12 numbers, D13 adjacent strings | `spec-0.10.01/working-notes/AUDIT-2026-09-01.md` | 01, 05, 07, 72, 75, 78 |

## Nuance the existing files 01–13 may want

### 01 — `|a |b`: child or value
- Joseph, 2025-12-23 (history.jsonl 5470), verbatim:
  ```text
    |table |tr |td A1 |td A2
           |tr |td B1 |td B2    ; |tr is sibling of first |tr (same column)
      |caption Table 1          ; |caption is child of |table (indented from |table)
  ```
  "You mean:"
  ```text
    |table |tr |td A1
               |td A2
           |tr |td B1
               |td B2    ; |tr is child of |table, so sibling of first |tr (same column)
      |caption Table 1   ; |caption is *also* child of |table (indented from |table)
  ```
  "What I'm now realizing, though, is that embedding blocks in text doesn't necessarily give us a syntax (yet) for same-line-siblings..." — column-aligned siblings (0.7 §Column-Aligned Siblings; `practices-gotchas.udon`) only work if a same-line `|b` has a real column.
- Joseph, 2026-01-02 (history.jsonl 6973): the one-line `|li.menu-item |a :href /about About` written as equal to a three-line block form with `|a` as a child (quoted in 73).
- 2011 DECIDED.md: `|one|two|three ==> |{one |{two |{three}}}` (tight pipes nest) and the column rule for a following line.
- `sameline-value-space-2026-08-08.md` derives the nesting from the "pseudo-line-feed" model: "`|{a} |{b}` are **siblings** while `|a |b` **nest** — the `}` closed a before b opened."
- `SPEC-INDENTS.md` "Valid Indentation Range": text on a following line between the parent's column and the same-line child's column belongs to the parent — a rule that needs the child's column.
- Under B, the question "what column does a `$main` node value have?" decides whether the table idiom survives.

### 02 — escape inside an open value
- D3 records that option B was Joseph's own pre-K13 annotation; option A is the K13-derived reading.
- 0.10.1 spelling grid note 6: `:a \7 hundred :b 2` vs `:a \ 7 hundred :b 2` — one space changes whether `:b` is live; "a real visual hazard … under discussion."
- 0.9 (2026-07-15): `\`-forced text stayed "alive to inline forms"; 0.10.0's wording ("dead to markers") may or may not include `|{`. See 82.

### 03 — ` ; ` in prose
- 0.7-draft comments table: block prose `;` literal; a Jan 2026 parser note (memorata, 31853cab…:9717) makes the line-start / mid-line split explicit — "`;` in block prose … is LITERAL, not comment, but line-starting `;` IS a block comment." A session summary from the same day (agent-written, memorata 31853cab…:10694) records: "Removed 'document root' distinction - mid-line `;` is always literal in prose."
- `_archive/SPEC-UPDATE.md` "Why Block Prose Differs": code samples with `;` in block prose.
- 2011 DECIDED.md: an end-of-line comment inside free text was considered and set aside ("meh... probably opens a can of worms").
- CommonMark report §3.2: ` ; ` is routine in French typography.

### 04 — root and top-level text
- 2011 had an implied root with parser-supplied ID/name and `:__` metadata, and asked "No way (from document) to set classes? — use :class-name true instead? No way to set id from source file? use :id?" — i.e. top-level attributes as root attributes, considered 15 years ago.
- Dec 2025 – Jul 2026 the opposite was held: "No implicit root wrapper" for streaming, fragments, multi-root (`udon-ast.md`; greenfield "Forest"; 0.9.1 primer property 1). Those reasons are the ones the implied-root decision now answers.
- Joseph 2026-07-29: a "snippet" file kind "could, for example, have :attributes at the topmost level before normal children" (84).
- ROOT-BASE, measured: the old parser discards all leading whitespace on top-level text lines silently, and 5 indented Markdown fences became UDON fences because of it.
- Vivarium's convention `<name>.<root-element-type>.udon` ("the root element type is the schema") treats the single top-level element as the document's root; with an implied root it becomes the root's only child.

### 05 — values across lines
- 0.10.1 audit A2 (forgotten `]` swallows the document) and D4 (a quoted string inside a `[key]` whose `]` is missing: which closes first?), D14 (`;{` spanning).
- Joseph 2026-07-29 multi-line bracket sketch, and his "stacking" alternative that removes most of the demand for multi-line lists (`thoughts-on-multiline-array.md`; file 74).
- 2011 DECIDED.md asked the same question for a quoted directive: "if it has a newline that is outdented … but the closing quote hasn't occurred yet, are we still in the string?"

### 06 — suffix characters
- 0.7-draft reserved a suffix directly on a class (`.class?`) "for future use"; 0.10.0 made `?` part of the trait (`.bar?`).
- `_archive/decisions-superseded/identity-syntax-brief.md` recommended bare suffixes because "live ASF usage is already bare-`?`."
- 0.10.1 (misfire) reused `? * +` as reference cardinality (`@tags*`); its audit A3 found `@user.admin?` ambiguous with trait `admin?`. If suffixes become name characters in lite, future cardinality spellings lose them.
- D9: CHEATSHEET arity convention uses the suffix position. 0.10.1 audit D11: `|el?foo`.

### 07 — the `<…>` box
- 0.8 interim: the no-dialect value was "the plain string `"<…>"`" — brackets included — which bears on Q3 (what the tree carries).
- 0.10.1 audit D1: `<http://x>`, `<2026-01-01T10:00:00>`: is `http`/`2026-01-01T10` a label? Only safe if a label must be an identifier.
- Joseph 2026-07-18 grammar hint (CHANGELOG): drop the envelope's single-line warning if multi-line is simpler — "a convenience, not a spec requirement."
- HTML-ish prose: `a<b` and `x > 3` in prose must stay text (0.10.0 §11.6: `<` is ordinary in text).

### 08 — pipes and tables
- 2011: tight `|one|two|three` was deliberate nesting syntax; `| ` was a text-value marker.
- CommonMark report N2, measured: in `|a|b|` / `|-|-|` / `|1|2|` only the header row becomes structure — the delimiter and number rows fail the guard.

### 09 — reserved syntax
- **Line-start `@` and `!word` in ordinary prose** (CommonMark report N3/N4): `@alice said…`, `!important`. 0.10.0 read these as a reference / a directive; under "reserve, don't ignore" lite would refuse them — ordinary Markdown/social prose becomes not-valid-lite. Mid-line they are text (0.10.1 spelling-grid note 7: "`email me @joseph` … pass through untouched"). See 87.
- R13: a nameless `!{` at end of input is text; 0.10.1 audit D5: is `!{}` valid like `|{}`?
- `[@{key}]`, `[!{{id}}]` are 0.10.0 key spellings — reserved inside `[…]` too (77).
- Old design docs used `|!dsl[...]` and `|{@ ...}` shapes that are text under today's guards (memorata, udon 5d686e10…:617).

### 10 — inline elements and inline comments
- Joseph 2025-12-23 (above): the need for same-line siblings is what `|{a} |{b}` answers.
- 2011 DECIDED.md embedded forms: `|{node}`, `:{attribute …}` (an inline attribute affecting the parent), `!{-directive}`.
- `;{}` at a value slot: 2026-07-19 ruling `:n ;{}` ≡ `:n ""` (Joseph) vs 0.10.1 DELTAS 11 (missing value, error).
- `practices-gotchas.udon`: "Inline elements are siblings of surrounding text, not part of it … it affects downstream renderers."
- A line-initial `|{` "participat[es] in hierarchy at its column" (0.10.0 §3); 0.10.1 dropped this (audit C6).

### 11 — code blocks
- 2011 "IMPORTANT UNDECIDED: best, simplest way to have free text where indentation does _not_ apply … yaml-like? heredoc-like? directive only?"; overview.udon had `` |`data `` for unparsed line data.
- Joseph 2025-12-28 (history.jsonl 6059), layout as typed: the `!:json:` block "would, in fact, be the preferred way to have json snippets in udon", with this warning case:
  ```text
  !:json:
      { "starting out": 123,
    "this causes a warning": 567 }
  ```
  In lite `!:kind:` is reserved, so lite has no indentation-closed raw block at all.
- `practices-gotchas.udon`: "Prefer !:lang: for code blocks. Reserve triple-backticks for rare cases where indentation cannot be controlled" — the opposite of lite's position.
- 0.10.1 audit C4: 0.10.0 requires the closing fence line to end right after the backticks (```` ```rust ```` is not a closer).
- CommonMark report: a Markdown fence at the text's left edge becomes a UDON fence (27 of 652 examples embedded).

### 12 — anomalies and validity
- YAML stress test (Dec 2025): truncated writes and duplicate keys were the failure modes that mattered; duplicates were silent and unrecoverable.
- 2011 DECIDED.md §PARSER: "Warnings w/ severity as a separate structure … Ability to suppress specific warning messages."
- Fresh-reader probe (UNIF-PASS Q3): a zero-context reader expected bare `done?` to mean true.
- Joseph 2026-07-20 wanted "error or strong warn" for dangling text after a finished value (74).
- `v2/INBOX-REQUESTS.md`: tiny parsers "would need to warn when there are constructs … that it encounters that it won't parse."
- New anomaly sources raised in 71–91: CR in lines, BOM, invalid UTF-8, mixed attribute columns, limits.

### 13 — AST shape
- `udon-ast.md` (Jan 2026): `Element = {name, key, traits, attrs, children}` with `id`/`class` aliases; text between inline elements makes `[Text, Element, Text]` children.
- 0.9.1 primer: "`:x 1 :x 2` and `:x [1 2]` are *never* equivalent, at any layer" — later softened by K15's default read. Q4's alternatives span that change.
- `TOOLING-WISHLIST.md`: an AST view should show "`all_attributes` vs the ergonomic `key/traits/attributes` split … where a consumer gets surprised."
- Joseph 2026-01-13's "DOM" question and the sameline-vs-block question (73).
- D11: whether where a late attribute was written matters for sameness.
- 86: a standard JSON transcript of the tree would double as the fixture format.

## New question files

| File | Question |
|---|---|
| [71](71-how-far-an-unquoted-value-runs.md) | How far an unquoted value runs (one token / to next marker / to end of line) — five historical answers |
| [72](72-which-bare-words-are-numbers-booleans-nil.md) | Which bare spellings are numbers, booleans, nil; edge spellings |
| [73](73-is-the-element-line-a-typed-value.md) | Is the element's own line typed (`\|price 42`, `\|q "hi," she said`)? |
| [74](74-attribute-values-on-following-lines.md) | Attribute values on the lines below the label; elements as attribute values |
| [75](75-quoted-strings.md) | Quoted strings: both quote kinds, escapes, adjacent strings |
| [76](76-names-and-labels-which-characters.md) | Characters in element names and labels (XML/HTML/JSON names; Unicode; case; label sameness) |
| [77](77-identity-keys-and-traits.md) | `[key]` and `.trait`: contents, multiples, nameless elements, duplicates, id/class |
| [78](78-what-a-comment-owns.md) | What a comment owns (continuation lines; end-of-line comments; column-0 comments) |
| [79](79-line-endings-encoding-and-columns.md) | CRLF, BOM, invalid UTF-8, final newline, columns after non-ASCII text |
| [80](80-which-spaces-are-content.md) | Which spaces and line breaks are content |
| [81](81-structure-inside-an-indented-text-block.md) | `\|x` deeper than the text's left edge; text lines that shift left |
| [82](82-escaping-in-lite.md) | The whole escape set for lite |
| [83](83-lists-and-sequences.md) | `[…]` details (commas, `[]`, nesting); sequences of records |
| [84](84-files-documents-and-version-marking.md) | Documents per file; file kinds; marking a file as lite |
| [85](85-canonical-writing-form.md) | Does lite say how tools should write lite? |
| [86](86-mapping-to-json-xml-yaml.md) | Mapping lite trees to JSON/XML/YAML; a standard JSON transcript of the tree |
| [87](87-markdown-in-prose.md) | Is prose Markdown; Markdown collisions, incl. line-start `@`/`!` under reservation |
| [88](88-where-attribute-lines-may-sit.md) | Attribute-line columns; what starts "content" for late attributes |
| [89](89-empty-and-degenerate-forms.md) | `\|` alone, `[]`, `<>`, `""`, lone `:` / `;` |
| [90](90-what-a-blank-line-ends.md) | Whether a blank line ends a comment, an attribute value, anything; where it sits |
| [91](91-one-pass-reading-and-limits.md) | One-pass (bounded lookahead) reading in lite; nesting and size limits |

## Notes for whoever reads next

- The repo's `CLAUDE.md` and `README.md` point at `~/src/_ref/udon/` and `~/src/_ref/udon-c/`; those paths don't exist. The 2011 repos are at `~/src/_older/udon/` and `~/src/_older/udon-c/` (also `~/src/_older/udon-ruby/`, `~/src/_older/libudon/`, and a copy under `~/src/.moved-and-integrated/udon/`).
- memorata drops indentation and newlines from what it returns, so UDON quoted from it is unreliable; `history.jsonl` keeps Joseph's typed layout.
- Several items in 71–91 are small (89, 90, 91); they are here because each is a place two lite parsers could disagree.
- The single most consequential cluster I saw: **71 + 73 + 74 + 01** are one design question seen from four sides — what the rest of a line belongs to — and it has been answered differently in 2011, Dec 2025, Jul 15, Jul 20 and Aug 8 2026.

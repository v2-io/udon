---
family: lite
version: 0.1.0
---
# *Specification*: UDON Lite
***The non-dynamic subset of UDON***

**The spec store's main outline:** a view over `obj/`, `def/`, and `src/`. **Register: a proposed skeleton (2026-09-30), not adopted.** Every row here was written from the SOP side, so every row is an `example` or a `proposed` row (the decision allows `template` too; none is used) ([[sop/decision:our-side-is-example]]). Lite's own decisions, and whether to take any row forward, are the udon team's. How work is done in this corpus (kinds, fields, row-types, references, decisions) is in the SOP store, starting at [`sop/main.outline.md`](sop/main.outline.md). The first proposal of the kinds and fields is [`sop/influx/proposed-verisectorium.md`](sop/influx/proposed-verisectorium.md).

**How to read the columns.** Every column in this view is authored in the outline. It shows no ※ or ∂ columns until a linter exists to compute them ([[sop/decision:no-computed-columns-yet]]); then it adds the ones it wants, such as ∂(doc-state), ∂(status), the flags, `per`, and `force`.

| Column | Meaning |
|---|---|
| Row-type | `example`: a drafted sample written to show the record format; it never lands as it stands. `proposed`: a candidate record, usually with no document yet. The other row-types (`gap`, `template`, `exploratory`, `landed`) are unused here; `landed` needs a lite decision. See [[sop/conv:row-type]]. |
| Record | `[[kind:slug]]`, resolved through [`.vsect/kinds.yaml`](.vsect/kinds.yaml). The kind is written with its alias (`obj`, `prin`, `def`, `prop`, `expl`), which matches today's filename prefixes. A row with no document names the record it proposes. |
| Statement | This view's one-line gloss. For a row with no document, it is the question the record has to answer, not a guessed answer. |

Terms from lite's own `def/` records are written `«…»`. Rows whose term-groups are not drafted yet use plain words.

Fixture counts, check results, and parser agreement are deliberately **not** columns. They are evidence, to be computed from `dat/` and parser runs (by vsect, later), never typed into a view. Fixture files are records of kind `fixture` that no outline lists; rules cite them.

---

## *Part* 0 — Purpose

*What lite is for, and the tie-breakers used to choose among rules that all serve it.*

| Row-type | Record | Statement |
|---|---|---|
| example | [[obj:reserve-dont-ignore]] | Any «document» a lite parser accepts produces the same «tree» under every future full version |
| proposed | [[obj:data-and-document-layout]] | Lite is usable now as an XML/HTML, YAML, or JSON alternative for data and document layout |
| proposed | [[obj:append-safety]] | Should appending a well-formed top-level block never change the meaning of what is already there? |
| proposed | [[obj:one-pass]] | Should a lite «document» be readable in one pass with bounded lookahead? |
| example | [[prin:simplest-grammar-without-surprise]] | Among alternatives that meet the objectives, prefer the simpler grammar or rules, unless it violates least surprise |
| proposed | [[prin:keep-everything]] | Recognition never silently drops author-written bytes; severity is loss (0.10.0 G7, not yet re-decided for lite) |
| proposed | [[prin:syntactic-typing]] | A value's type comes from its spelling, never from its content (0.10.0 G6, not yet re-decided for lite) |

## *Part* I — Vocabulary

*The `def/` term-groups. A generated `LEXICON.md` is their view. The addressing theory's terms (`../references/def/`) are cited, not restated.*

| Row-type | Record | Statement |
|---|---|---|
| example | [[def:document]] | «document», «tree», «root-node», «meta»: the source, what it parses to, the implied root, and parser-supplied information about nodes |
| example | [[def:typed-value]] | «typed-value» (explicit `<…>` / implicit bare), «type-label» |
| proposed | [[def:element]] | element, name, key, trait, inline element, anonymous element |
| proposed | [[def:attribute]] | attribute, label, value, stacking |
| proposed | [[def:text]] | text, content base, blank line, prose |
| proposed | [[def:comment]] | comment and what it owns |
| proposed | [[def:anomaly]] | anomaly, warning, error, keep-shape, valid lite |
| proposed | [[def:reserved-span]] | a refused future spelling and what is kept for it |
| proposed | [[def:ornament]] | ornament vs meaning; content < content+meta < content+meta+ornament |

## *Part* II — The tree

*What a parse produces. Lite is specified as this tree (seeded decision `ast-centric`).*

| Row-type | Record | Statement |
|---|---|---|
| example | [[rule:implied-root]] | Exactly one «root-node», never spelled; top-level items are its children in order; it may carry «meta» |
| proposed | [[rule:element-fields]] | Are `[key]`, `.traits`, and element-line material designated attributes or dedicated fields? |
| proposed | [[rule:element-line-material]] | Where does same-line material live: a `$main` attribute, or first children flagged `same_line`? |
| proposed | [[rule:attribute-shape]] | How repeated labels appear: ordered pairs, a label-to-list map, or a map with the default read |
| proposed | [[rule:text-nodes]] | One text node per line, merged runs, or paragraphs; which node owns a blank line |
| proposed | [[rule:comments-in-tree]] | Are comments nodes in the tree, and what does each own? |
| proposed | [[rule:node-meta]] | Which «meta» a lite tree carries: source line and column, span, `same_line`; what is ornament |

## *Part* III — Source text and geometry

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:encoding-and-lines]] | UTF-8, BOM, CRLF, final newline, and how columns count after non-ASCII |
| proposed | [[rule:indentation]] | Spaces, tabs, and indentation units |
| proposed | [[rule:nesting]] | Deeper is a child, same is a sibling, shallower closes; inconsistent sibling columns |
| proposed | [[rule:blank-lines]] | What a blank line ends, and where it sits in the tree |

## *Part* IV — Elements

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:element-names]] | Which characters may appear in element names and labels; case; sameness |
| proposed | [[rule:keys-and-traits]] | `[key]` contents, multiple keys, `.traits`, duplicates |
| proposed | [[rule:suffix-characters]] | `? ! * +` lose special status: ordinary name characters, or reserved? |
| proposed | [[rule:anonymous-elements]] | Nameless elements |
| proposed | [[rule:inline-elements]] | `\|{…}` is in: its extent, its attributes vs interior text, siblings on one line |
| proposed | [[rule:line-ownership]] | Who owns the rest of an element's or attribute's line (one scan rule for both line kinds) |

## *Part* V — Attributes and values

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:attribute-lines]] | Where attribute lines may sit; values on following lines; element-valued attributes |
| proposed | [[rule:unquoted-extent]] | How far an unquoted value runs |
| proposed | [[rule:quoted-strings]] | Quote kinds, escapes, adjacent strings, strings across lines |
| proposed | [[rule:bare-values]] | Which bare spellings are numbers, booleans, or nil, if lite types bare values at all |
| proposed | [[rule:explicit-typed-value]] | `<…>` carried as text: where it ends, lines, label split, empty, where it may appear |
| proposed | [[rule:lists]] | `[…]`: separators, empty, nesting, lists across lines, sequences of records |
| proposed | [[rule:missing-value]] | `:label` with no value |
| proposed | [[rule:late-attributes]] | Attribute lines after content has begun |

## *Part* VI — Text, escapes, comments, and raw content

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:text-and-content-base]] | The content base and dedentation; structure inside indented text; which spaces are content |
| proposed | [[rule:escapes]] | The whole escape set |
| proposed | [[rule:comments]] | Comment forms and what each owns; ` ; ` in prose; where an inline comment may sit |
| proposed | [[rule:fences]] | Fences, lite's only raw form: as values, byte-exact vs stripped, fences containing backticks |
| proposed | [[rule:prose-and-markdown]] | Is prose Markdown? Collisions with Markdown |
| proposed | [[rule:pipes-and-tables]] | Pipes in prose and Markdown-style tables |

## *Part* VII — Reserved syntax

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:reserved-spellings]] | Exactly which `!` and `@` spellings are refused, in which positions (including prose, `[key]`, and floated or near-miss spellings) |
| proposed | [[rule:reserved-keep-shape]] | What the tree keeps for a refused spelling, and for the lines indented under it |

## *Part* VIII — Validity and anomalies

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:valid-lite]] | What "a lite parser accepts" means: no anomalies, no errors, or a list of forward-stable anomalies |
| proposed | [[rule:anomaly-inventory]] | Each anomaly: code, trigger, severity, keep-shape, forward-stable or not |
| proposed | [[rule:duplicate-keys]] | Two elements with the same name and key |
| proposed | [[rule:limits]] | Nesting and size limits |

## *Part* IX — Documents and files

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:documents-per-file]] | One «document» per file, a separator, or one per top-level element |
| proposed | [[rule:lite-marker]] | How a file says it is lite (none, optional marker, filename, required marker) |

## *Part* X — Properties of the rule set

*Derived claims about the rules. These are the truth-apt part of the spec: each can be refuted by a counterexample, and each needs a derivation or a mechanical check by someone other than its author.*

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[prop:forward-stability]] | The lite rule set meets [[obj:reserve-dont-ignore]]: no accepted «document»'s «tree» changes under a full parser |
| proposed | [[prop:determinacy]] | Every input produces exactly one tree and one anomaly list |
| proposed | [[prop:append-safety]] | If adopted: appending a top-level block never changes earlier meaning (needs fail-safes on delimited forms) |
| proposed | [[prop:one-pass]] | If adopted: a lite parser needs bounded lookahead only |
| proposed | [[prop:equivalences]] | Which spelling pairs produce the same tree (meaning) and which differ only in ornament |

## *Part* XI — Transcript and mappings

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:tree-transcript]] | A standard written form of the tree (e.g. JSON), used by fixtures and for comparing parsers |
| proposed | [[expl:data-mappings]] | How lite trees map to JSON, XML, and YAML, and what each mapping loses (informative) |
| proposed | [[rule:writing-form]] | Does lite say how tools write lite (canonical or preferred form)? |

## *Part* XII — Explanation

*Teaching records. They describe rules and never add to them; each lists the records it describes, and is marked stale when one of those changes. Short explanations may instead sit as a marked section inside a rule file.*

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[expl:lite-in-one-page]] | The whole of lite, for a newcomer |
| proposed | [[expl:for-json-and-yaml-users]] | Lite for someone arriving from JSON or YAML: typical data layout |
| proposed | [[expl:for-xml-and-html-users]] | Lite for someone arriving from XML or HTML: mixed content, inline elements |
| proposed | [[expl:common-mistakes]] | The misguided spellings, each paired with its `counter` fixture |
| proposed | [[expl:reserved-and-why]] | What lite refuses and why a refusal is a promise, not a limitation |

---

## *Why*

*Notes on this view kept in its body ([[sop/decision:notes-disposition-at-freeze]]). Open items are in the working notes below.*

- **Row-types.**
  - The five drafted records and the fixture file are `example`: written to show each kind done to the SOPs, so the udon team can learn the conventions from them. They are proposals of content too, and the udon team can re-type any of them as `proposed` when they take it forward.
  - Every row with no document is `proposed`, because the skeleton is the SOP side's proposal of lite's record set. The udon team can re-type any row when they take it forward.
- **What the `example` records show on purpose:**
  - `per:` cites seeded decisions that are not ADRs yet. No outline row names them, so each entry is a dangle, with a working note saying why. Converting the seeds is the udon team's; the citations go live when the ADRs are written under the same slugs. A record's `awaiting-decision` is true only when something about that record itself awaits the udon team's decider (the objective's `force`, the principle's adoption, the two definitions' open terms), never because of what it cites ([[sop/decision:flags-describe-own-record]]).
  - The objective's `force` is present and empty (`∅`): setting it is the udon team's, and the lean is in its working notes.
  - Open questions sit in each record's working notes, each saying what it would change there; reasons that were kept sit in the body, and a fixture case's in `why:`.
  - The two purpose-layer records quote Joseph from the 2026-09-29 udon session transcript, which the seeded decisions had recorded as "not located".
- **Links resolve through [`.vsect/kinds.yaml`](.vsect/kinds.yaml).** Only the `example` rows' records exist. A link to any other row's record resolves to that row and is reported as *unwritten*, which is what a `proposed` row with no document means ([[sop/decision:links-to-unwritten-records]]). Links into the SOP store are written `[[sop/kind:slug]]` ([[sop/decision:cross-store-links]]).
- **Group A** (STEWARD's name: 01, 02, 51, 53, 64, 71, 73, 74, 88) is one question about line ownership seen from several sides. It is one row, [[rule:line-ownership]], rather than nine, and [[rule:element-line-material]] records only where the result lives in the tree.
- **Ordering** is dependency order as far as it is known: the tree (II) comes before the syntax that produces it, because lite is AST-centric. If that reads backwards to a newcomer, the explanation view can teach in the other order; teaching order and spec order are both views.
- **Statements.** Every Statement on a row with no document is phrased as the question its record has to answer, so no row asserts an answer that nobody has decided.
- **Regression guard: conservation** (checked by script, 2026-09-30): every question 01–13 and 50–91 except the reports 67 and 70 sits under at least one row, here or in an `example` record's working notes. Only the titles of most of 50–91 were read (the proposal says which were read whole), so a question may still sit under the wrong row.

## *Working Notes (outline-level)*

- **Open questions for rows with no document yet.** Open questions live in the working notes of the records they bear on ([[sop/decision:open-questions-in-working-notes]]). Until a row's record exists, its questions are kept here, and they move into the record's working notes when it is drafted. Numbers are files in `.int/pre-design/`. The five `example` records carry theirs in their own working notes.
  - **Part 0**
    - obj:data-and-document-layout: 86 (mapping to json xml yaml)
    - obj:append-safety: 68 (append safety and grep ability)
    - obj:one-pass: 91 (one pass reading and limits)
    - prin:keep-everything: 12 (missing values and what counts as valid)
    - prin:syntactic-typing: 66 (does lite type bare values); 72 (which bare words are numbers booleans nil)
  - **Part I**
    - def:element: 06 (suffix characters); 61 (anonymous elements); 76 (names and labels which characters); 77 (identity keys and traits)
    - def:attribute: 65 (value shape after stacking); 83 (lists and sequences)
    - def:text: 55 (which node owns a blank line); 57 (line breaks in text); 80 (which spaces are content)
    - def:comment: 78 (what a comment owns)
    - def:anomaly: 12 (missing values and what counts as valid)
    - def:reserved-span: 09 (reserved syntax)
    - def:ornament: 60 (what the tree must preserve)
  - **Part II**
    - rule:element-fields: 13 (ast shape); 58 (designated dollar attributes)
    - rule:element-line-material: 01 (sameline element child or value); 13 (ast shape); 73 (is the element line a typed value)
    - rule:attribute-shape: 13 (ast shape); 65 (value shape after stacking); 83 (lists and sequences)
    - rule:text-nodes: 13 (ast shape); 55 (which node owns a blank line); 57 (line breaks in text)
    - rule:comments-in-tree: 13 (ast shape); 78 (what a comment owns)
    - rule:node-meta: 60 (what the tree must preserve); 85 (canonical writing form)
  - **Part III**
    - rule:encoding-and-lines: 79 (line endings encoding and columns)
    - rule:indentation: 63 (tabs and indentation units)
    - rule:nesting: 52 (inconsistent sibling columns); 81 (structure inside an indented text block); 90 (what a blank line ends)
    - rule:blank-lines: 55 (which node owns a blank line); 90 (what a blank line ends)
  - **Part IV**
    - rule:element-names: 69 (unicode names and the stability of the guard); 76 (names and labels which characters)
    - rule:keys-and-traits: 54 (duplicate keys); 77 (identity keys and traits)
    - rule:suffix-characters: 06 (suffix characters)
    - rule:anonymous-elements: 61 (anonymous elements)
    - rule:inline-elements: 10 (inline elements and inline comments); 50 (inline element attribute vs interior text); 51 (siblings on one line)
    - rule:line-ownership: 01 (sameline element child or value); 02 (escape inside open value); 51 (siblings on one line); 53 (element line text continuing below); 64 (node valued attributes in lite); 71 (how far an unquoted value runs); 73 (is the element line a typed value); 74 (attribute values on following lines); 88 (where attribute lines may sit)
  - **Part V**
    - rule:attribute-lines: 64 (node valued attributes in lite); 74 (attribute values on following lines); 88 (where attribute lines may sit)
    - rule:unquoted-extent: 02 (escape inside open value); 71 (how far an unquoted value runs)
    - rule:quoted-strings: 05 (values across lines); 75 (quoted strings)
    - rule:bare-values: 66 (does lite type bare values); 72 (which bare words are numbers booleans nil)
    - rule:explicit-typed-value: 07 (untyped angle box); 89 (empty and degenerate forms)
    - rule:lists: 05 (values across lines); 65 (value shape after stacking); 83 (lists and sequences)
    - rule:missing-value: 12 (missing values and what counts as valid)
    - rule:late-attributes: 12 (missing values and what counts as valid); 88 (where attribute lines may sit)
  - **Part VI**
    - rule:text-and-content-base: 04 (root and top level text); 57 (line breaks in text); 80 (which spaces are content); 81 (structure inside an indented text block)
    - rule:escapes: 02 (escape inside open value); 82 (escaping in lite)
    - rule:comments: 03 (semicolon in prose); 59 (where an inline comment may sit); 78 (what a comment owns)
    - rule:fences: 11 (code blocks)
    - rule:prose-and-markdown: 87 (markdown in prose)
    - rule:pipes-and-tables: 08 (pipes and markdown tables)
  - **Part VII**
    - rule:reserved-spellings: 09 (reserved syntax); 56 (historically floated spellings); 62 (near miss spellings from other notations); 87 (markdown in prose)
    - rule:reserved-keep-shape: 09 (reserved syntax)
  - **Part VIII**
    - rule:valid-lite: 12 (missing values and what counts as valid)
    - rule:anomaly-inventory: 12 (missing values and what counts as valid)
    - rule:duplicate-keys: 54 (duplicate keys)
    - rule:limits: 91 (one pass reading and limits)
  - **Part IX**
    - rule:documents-per-file: 84 (files documents and version marking)
    - rule:lite-marker: 84 (files documents and version marking)
  - **Part X**
    - prop:forward-stability: 09 (reserved syntax); 12 (missing values and what counts as valid); 84 (files documents and version marking)
    - prop:append-safety: 68 (append safety and grep ability)
    - prop:one-pass: 91 (one pass reading and limits)
    - prop:equivalences: 60 (what the tree must preserve)
  - **Part XI**
    - rule:tree-transcript: 86 (mapping to json xml yaml)
    - expl:data-mappings: 86 (mapping to json xml yaml)
    - rule:writing-form: 85 (canonical writing form)
  - Rows with no question yet: prop:determinacy and the Part XII explanations.
  - Reports, not questions: 67 (a census of what live UDON documents contain) is evidence for rule:line-ownership, rule:comments and rule:reserved-spellings, and a candidate regression corpus for `dat/`. 70 is the survey index.
  - **Closers the SOP side proposed** (input for the udon team, who route questions): steward-purpose for 01, 03, 04, 08, 09, 11, 12 and 13; steward-fact for 06 (confirm the recollection); agent-open for 07, 10, and most of 50–91; 02 waits on 01, and 05 on 68.
- **What the rows with no document should cite when drafted.** With no Per column, this is carried here. The seeded decisions are in `.old/vsect-init/DECISIONS.md`, and converting them to ADRs in `adr/` is the udon team's.
  - `reserve-not-ignore`: def:reserved-span, rule:reserved-spellings, rule:reserved-keep-shape, expl:reserved-and-why;
  - `suffixes-lose-special-status`: rule:suffix-characters;
  - `inline-elements-in`: rule:inline-elements;
  - `explicit-typed-value-in`: rule:explicit-typed-value;
  - `ast-centric`: rule:tree-transcript (and the Part II introduction);
  - obj:data-and-document-layout rests on the `.int/README.md` section "What lite is for", not on a decision.

  The five `example` records carry their own `per:`.
- **Row-type wording to reconcile.** [[sop/decision:row-type]] and [[sop/decision:our-side-is-example]] say under *What changes* that this side's rows are marked `example`. Joseph's quoted words are "example & proposed & template", and this outline follows the quote. If `example` everywhere was meant, the flip is mechanical.
- **Checking order against `depends:`** is undecided ([[sop/decision:order-lint]]).

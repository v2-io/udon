---
family: lite
version: 0.1.0
---
# *Specification*: UDON Lite
***The non-dynamic subset of UDON***

# Contributing

How this corpus is worked (record kinds, their fields, row-types, references, decisions, and how outlines like this one work) is in the Standard Operating Procedures (SOP) store, which has its own outline: [`sop/main.outline.md`](sop/main.outline.md). Start there to learn the conventions used for this spec. Open work across the store, ranked, is collected in [`TODO-MSC.md`](TODO-MSC.md). Some basic templates and info are provided below. There are other examples if desired in `.old/vsect-init/**` although they were written based on some random things in influx (now `.int`) and before the SOPs were fully developed.

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

*Small cards, one normative statement each, grouped in chapters by what a parse produces (lexer before structure); each card uses only what comes before it. A card is the decision for its rule: Joseph's words and how firm they are sit in its Grounds, the options and reasons in its Discussion. `adr/` keeps only the decisions that cut across many cards (the contract, anomaly policy, process, vocabulary), which cards cite in `per:`. Cards are cheap to rewrite, split, merge or replace with an alternate; discussion should change the cards directly. Organization: [[decision:spec-organization-delegated]]; the chapter cut follows `.int/reorg-spike-2026-10-08.md`.*

*A **card** states one rule a conforming parser must implement, with its own errors and warnings. A **fixture** (`dat/`) is a specific input and its tree or error; edge spellings are fixtures. A **companion** is derived from the cards and never introduces a rule. Trees in cards use the notation of `.int/ast-notation-proposal-a.md` until [[rule:tree-transcript]] settles it.*

## *Part* I — What a parse produces

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[def:document]] | A «document» is lite source; parsing it produces one «tree», which is what lite specifies. Every «tree» has one «root-node» that the source never spells, and a node may carry «meta» that the source does not write. |
| proposed | [[def:node]] | The nodes a «tree» holds under its «root-node»: «element»s, which carry «attribute»s and children, «comment»s, and «fence»s; text from prose is a «text» child. |
| proposed | [[def:string]] | A «string» is a value written in quotes: one piece, never broken up by embedded forms. |
| proposed | [[def:text]] | A «text» is an ordered sequence of «piece»s: «run»s of characters and «embed»s. It is what unquoted material on an element's or attribute's line becomes, and what prose becomes. |
| proposed | [[def:typed-value]] | A «typed-value» gets its type from its spelling alone. Spelled `<…>`, it is an «explicit-typed-value», whose text lite carries without attaching meaning. Spelled any other way, it is an «implicit-typed-value». |
| proposed | [[def:anomaly]] | An «error» stops parsing: there is no «tree». A «warning» marks correct lite that may not do what was meant: the «tree» is produced and carries it. |
| proposed | [[rule:warnings-can-be-toggled]] | Each «warning» is default-on or default-off, and a parser lets its user turn each one on or off. |
| proposed | [[def:reading-option]] | Lite specifies the «raw-tree». A «reading-option» is a view over it that a consumer may apply, usually while traversing; it is not language. |
| proposed | [[def:blank-line]] | An «empty-line» is a newline with nothing before it on its line; a «blank-line» is an «empty-line» or a line of only whitespace. |
| proposed | [[rule:tree-transcript]] | A fixture's expected «raw-tree» is written in one canonical printed form, and a parser's tree is checked by printing it in that form and comparing the text byte for byte. |

### Vocabulary under review

*Definition cards drafted 2026-10-09 for Joseph's vocabulary review (`.int/lexicon-inventory-2026-10-09.md`). None is reviewed; each card's working notes carry an Avoid list, his prior uses, precedents, and the drafter's and coordinator's leans. Rows move into their chapters as terms are ruled.*

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[def:attribute-name]] | An «attribute-name» is the «label» written directly after an attribute's `:`, bare or in quotes: `role` in `:role editor`. It names what the value is to the element that holds it. |
| proposed | [[def:block-form]] | A «block-form» is the spelling of a construct that begins at a «head-position» with its bare «marker» (`|name`, `:name`, a framed ` ; `). On a «sameline» it ends running text. Its counterpart is the «embed» (`|{…}`, `@{…}`, `;{…}`; [[def:embed]]), which sits inside text as a piece of it. "Block" has carried at least four other contrasts in UDON's history, so the word is heavily loaded. |
| proposed | [[def:body]] | A «body» is the lines that belong to a construct below the line it starts on. Lite's cards use the word for three things that behave differently: a «fence»'s lines up to its «fence-closer», a «comment-block»'s deeper lines, and an attribute's indented lines. |
| proposed | [[def:column]] | A «column» is how far into its line a character sits, counted in spaces. A line's «indent-level» is the column of its first non-space character. "Indent level" is Joseph's most-used word in this whole territory, and he uses it for four different things. |
| proposed | [[def:comment]] | A «comment» is text written for the document's maintainers that lite carries in the «tree» and never interprets. Lite has three spellings of one: a `;` line with its deeper lines (a «comment-block»), a ` ; ` with a space on each side after structure on a line (a «framed-comment»), and `;{…}` inside a «text» (an «inline-comment»). |
| proposed | [[def:element-line]] | An «element-line» is a line whose first content, at a «head-position», is an element; an «attribute-line» is one whose first content there is an attribute. They are the two kinds of line that have a «sameline». |
| proposed | [[def:element-name]] | An «element-name» is the «label» written directly after an element's `|`, bare or in quotes: `user` in `|user[jw]`. An «element» may have none. |
| proposed | [[def:embed]] | An «embed» is a brace form written inside a «text»: an «inline-element» `|{…}`, a reference `@{…}`, or an inline comment `;{…}`. It is always a «piece» of its «text», never a value of its own. |
| proposed | [[def:fence-tag]] | Resolved 2026-10-12: the word after a fence's opening backticks is the fence's name, read as an element's name; no separate term. |
| proposed | [[def:fence]] | A «fence» is the node made by a run of three or more backticks: its opening line reads like an element's line, and its «body» is every line up to a «fence-closer», kept and never scanned. The trait `exact` keeps the body's indentation exactly. |
| proposed | [[def:framed]] | A `;` or `\` on a «sameline» is «framed» when it has a space before it and a space after it. The spaces are its «frame»: they decide that it is a comment or a text end rather than text or an escape, and they are not content. Joseph accepted the word ("when you say "framed" you mean at least one space on either side … right?") but has not ruled on it. Whether end of line counts as the right-hand frame is unsettled, and the cards disagree. |
| proposed | [[def:head-position]] | A «head-position» is a place in the source where a «marker» can begin structure. It is Joseph's July 2026 term, which agents renamed "Structure Position" without him; lite's cards currently paraphrase it as "where structure can start". |
| proposed | [[def:key]] | A «key» is the value written in `[…]` directly after an element's name (or directly after its `|`): `jw` in `|user[jw]`. It says which one this element is. The «tree» holds it as the attribute `$key`. |
| proposed | [[def:label]] | A «label» is a name spelled by the rules lite gives for writing identifying names, bare or in quotes. «element-name»s, «attribute-name»s and «trait»s are labels. The word says how a name is spelled, never what it does. Which other names are labels, and whether all labels share one character set, is open. |
| proposed | [[def:left-edge]] | The «left-edge» of a text, or of a fence body, is the «column» its lines are dedented to. Its first non-blank line sets it; a shallower line moves it with a warning; a deeper line is content. The term is a lite drafter's word. Joseph's words for this column are "indent level", "active indent", "leftmost edge" and, in July, "prose-head column"; 0.9 and 0.10 called it "content base". |
| proposed | [[def:main]] | `$main` is the attribute an element's own line gives the material left over after its name, key, traits and attributes. It is an attribute in the «tree», never a text child, and it stacks like any other. |
| proposed | [[def:marker]] | A «marker» is the character, or short run of characters, that begins a construct at a «head-position»: `|` for an element, `:` for an attribute, `;` for a comment, three or more backticks for a fence, and the reserved `!` and `@` that lite recognizes only to refuse. The word is agent vocabulary. Joseph's own words for these characters are "sigil", "prefix" and "special starts". |
| proposed | [[def:meta]] | «meta» is information a parser attaches to the «node»s of a «tree» beside their content: a filename on the «root-node», a node's position, the indentation a fence body lost. What exactly counts, and what sets it apart from content, is not settled. |
| proposed | [[def:opaque-span]] | An «opaque-span» is one of the delimited forms `<…>`, `@{…}` and `;{…}`, whose text lite carries without attaching meaning, under one rule for nesting, escapes and line ends. |
| proposed | [[def:prose]] | «prose» is source: the lines under an element (or at the top level) that open no structure. Consecutive prose lines under one owner become one «text» child. |
| proposed | [[def:quoted-name]] | A «quoted-name» is a «label» written in quotes, so it can hold characters a bare name can't: `|'weird name'`, `:"data[1]"`. It is read by the string rules. The quotes are spelling: a quoted name is the same name as the bare spelling of the same characters. |
| proposed | [[def:reserved]] | Something is «reserved» when lite gives it no meaning and refuses it with an «error», so that a later version of UDON is free to give it one. |
| proposed | [[def:root]] | Every «tree» has one «root-node»: the «node» at its top, which no spelling in the «document» opens, closes or names. The «document»'s top-level items are its children, and its top-level attribute lines are its attributes. |
| proposed | [[def:sameline]] | «sameline» is the rest of a line after the element or attribute that starts it. Joseph's two kinds, «element-sameline» and «attribute-sameline», are read by one rule. Only the spelling "sameline" is ruled; what the word covers and the two compounds are not. |
| proposed | [[def:stacking]] | «stacking» is what happens when one element gets the same attribute more than once: every occurrence is kept, in written order, each with its own «value». Nothing is overwritten. |
| proposed | [[def:text-terminator]] | A «text-terminator» is what ends unquoted «text» on a «sameline»: a space followed by an element or attribute in «block-form», a «framed» ` ; `, a «framed» ` \ `, or the end of the line. Inside `|{…}` the `}` also ends it. Embedded forms never do. Joseph used the phrase once, for the backslash, as "our other "text terminator""; he has not ruled it as a term. |
| proposed | [[def:trait]] | A «trait» is a «label» written after a `.` directly following an element's name or key: `admin` in `|user[jw].admin`. It says what kind of thing the element is. An element may have several, in written order, and the «tree» holds each as the attribute `$traits`. A trait is a name, never «text». |
| proposed | [[def:transcript]] | A «transcript» is a «tree» written out as text in one canonical form, so that a fixture can state the «raw-tree» it expects and a harness can compare a parser's «tree» with it byte for byte. Which notation, and whether "transcript" is the word, are open. |
| proposed | [[def:tree]] | What lite specifies is the «tree» an accepted «document» parses to. The «raw-tree» is that «tree» exactly as the rules give it, before any «reading-option». A «node» is any item in a «tree». |
| proposed | [[def:value]] | A «value» is whatever an attribute holds, one per occurrence: a «string», a «text», a number, `true`/`false`, `nil`, a list, an «explicit-typed-value», or an element. |

## *Part* II — Lines and columns

| Row-type | Record | Statement |
|---|---|---|
| gap | [[rule:source-lines]] | UTF-8, line endings, BOM, final newline, invalid bytes |
| proposed | [[rule:blank-line-sets-no-indent]] | A «blank-line» never sets or changes indentation or nesting. |
| proposed | [[rule:blank-line-any-whitespace]] | A «blank-line» may hold tabs and any other Unicode whitespace; the column error does not apply to it. |
| proposed | [[rule:blank-line-whitespace-in-text]] | Inside a text or a fence body, whitespace on a «blank-line» that reaches past the left edge is kept; otherwise the line contributes only its newline. |
| proposed | [[rule:columns-count-spaces]] | Indentation, and the column of anything later on a line, are counted in U+0020 SPACE characters. |
| proposed | [[rule:no-break-space-counts-as-space]] | A U+00A0 NO-BREAK SPACE where it sets a column counts as one space, with a default-off «warning». |
| proposed | [[rule:column-shifting-whitespace-error]] | A tab, or any Unicode whitespace other than a space or a no-break space, in a line's indentation or before a later marker on the line, is an «error». |
| proposed | [[rule:whitespace-after-last-marker]] | A tab or other whitespace after the last marker on a line shifts no column, so it is content. |
| gap | [[rule:nesting]] | Deeper is a child, the same column a sibling, shallower closes |
| proposed | [[rule:sameline-element-is-child]] | A bare `\|name` written later on an element's line is a child of the element before it on the line, at the column of its `\|`. |
| proposed | [[rule:lines-follow-sameline-columns]] | Lines after a line with sameline elements are placed exactly as if each of those elements had begun its own line at its column. |
| proposed | [[rule:one-root-node]] | Parsing a «document» produces exactly one «root-node». |
| proposed | [[rule:top-level-items-are-root-children]] | Every node made from a top-level item of the source is a child of the «root-node», in source order. |
| proposed | [[rule:root-never-spelled]] | No spelling in the source opens, closes or names the «root-node»; a top-level element named `document` or `root` is an ordinary child. |
| proposed | [[rule:root-meta]] | A parser may attach «meta» to the «root-node» that the source doesn't write, such as the filename. |

## *Part* III — Delimited forms

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:unclosed-delimiter-is-error]] | If a string, list, key, `<…>`, `@{…}`, `;{…}`, `\|{…}` or fence is still open where it must close, parsing stops. |
| proposed | [[rule:matched-pairs-need-no-escape]] | Inside `<…>`, `@{…}`, `;{…}` and a key, an unescaped opener nests and is closed by its own closer; the form ends at the closer that matches its opener. |
| proposed | [[rule:strings-like-ruby]] | `"…"` and `'…'` make a «string» read essentially as Ruby reads it, closed at the next unescaped matching quote. |
| proposed | [[rule:no-interpolation]] | `#{…}` inside a quoted string is ordinary text. |
| proposed | [[rule:newline-in-string-is-error]] | A quoted string must close on the line it opens; `\n` writes a newline in `"…"`. |
| proposed | [[rule:double-quote-escapes]] | In `"…"` a backslash must begin one of a fixed list of escapes; any other is an error. |
| proposed | [[rule:single-quote-escapes]] | In `'…'` only `\'` and `\\` are escapes; every other backslash is literal. |
| proposed | [[rule:adjacent-quoted-strings]] | Two quoted strings with nothing between them are two values, with a warning (a lean). |
| proposed | [[rule:quoted-element-and-attribute-names]] | An element name or attribute name written in quotes is read by the same rules as a quoted string. |
| proposed | [[rule:key-holds-a-value]] | The inside of `[key]` is read by the ordinary value rules. |
| proposed | [[rule:key-escapes]] | In a key's unquoted parts only `\\`, `\[` and `\]` are escapes; any other backslash is an error. |
| proposed | [[rule:list-items-whitespace-separated]] | A `[…]` list holds values separated by whitespace; the opaque-span escape rule does not apply to it. |
| proposed | [[rule:opaque-span-raw-text]] | The «tree» holds the text between the delimiters of `<…>`, `@{…}` and `;{…}`, escapes resolved, with no meaning attached. |
| proposed | [[rule:opaque-span-escapes]] | Inside `<…>`, `@{…}` and `;{…}` only `\\` and the span's own delimiters may be escaped. |
| proposed | [[rule:newline-in-opaque-span-is-error]] | `<…>`, `@{…}` and `;{…}` must close on their own line; the error says lite doesn't support the newline. |
| proposed | [[rule:inline-element-value-end]] | Inside `|{…}`, an unquoted attribute value ends as on an element's line, or at the `}`. Where left-over text goes waits for embeds. |
| proposed | [[rule:fence-opens-with-backticks]] | A run of N ≥ 3 backticks where structure can start opens a fence of length N. |
| proposed | [[rule:fence-anywhere-structure]] | Unlike CommonMark, a fence opens at any indentation and on an element's or attribute's line; its position decides its parent. |
| proposed | [[rule:fence-opener-line]] | After the opening backticks, the rest of the line reads as an element's line; it all belongs to the fence, whose body starts on the next line. |
| proposed | [[rule:fence-default-handler]] | The default fence handler accepts only keys, the trait `exact` and a comment on the opening line, and does the body's dedenting. |
| proposed | [[rule:fence-label-no-backtick]] | A line that starts with backticks and has a backtick later in it does not open a fence. |
| proposed | [[rule:fence-closes-at-n-or-more]] | A fence of length N closes at the first later line whose first non-space content is N or more backticks. |
| proposed | [[rule:fence-closer-trailing-text-is-error]] | After a closing line's backticks only spaces or a framed comment may follow; this also catches a nested opener written with too few backticks. |
| proposed | [[rule:fence-line-comments]] | A framed ` ; ` on a fence's opening line is a comment, as on any element line; one may also follow a closer's backticks. |
| proposed | [[rule:fence-closer-is-a-line]] | The closer is not part of the body; its column then closes open elements at or right of it, like any line. |

## *Part* IV — The line

| Row-type | Record | Statement |
|---|---|---|
| gap | [[rule:markers]] | What opens what at a structure position, and each marker's guard |
| proposed | [[rule:prose-line-start-reserved]] | A prose line that starts with a bare reference or a directive spelling is not lite. |
| proposed | [[rule:reserved-spellings]] | The bare list of what lite refuses, and where. |
| proposed | [[rule:escaped-reserved-is-text]] | Escaping a reserved form is how to write it as text. |
| gap | [[rule:element-names]] | Characters of a bare name, quoted names, the former suffix characters, anonymous elements |
| gap | [[rule:keys-and-traits]] | `[key]` and `.trait` as `$key` and `$traits` |
| proposed | [[rule:traits-may-follow-spaces]] | Provisional: `\|el .something` is the same as `\|el.something`, so an unquoted name can't begin with `.`. |
| proposed | [[rule:line-scan]] | Sameline material is read the same way whether the line starts with an element or an attribute. |
| proposed | [[rule:attribute-with-no-value-takes-next-value]] | The next value on the line goes to the attribute that has none yet. |
| proposed | [[rule:leftover-values]] | On an element's line they are `$main` values; on an attribute's line they stack on the attribute. |
| proposed | [[rule:main-is-attribute]] | Sameline text never becomes a text child. |
| proposed | [[rule:text-value-end]] | On an element's or attribute's line, unquoted text runs until a block form or a framed ` \ `. |
| proposed | [[rule:space-before-text-end]] | Spaces before whatever ends a text are frame, not content. |
| proposed | [[rule:framed-backslash-frame]] | The framed backslash and its spaces are consumed; neither is content. |
| proposed | [[rule:embeds-in-text]] | `\|{…}`, `@{…}` and `;{…}` are never values of their own. |
| proposed | [[rule:space-between-embeds]] | Whitespace between two embeds is a run of the text. |
| proposed | [[rule:inline-comments-kept]] | An inline comment is a piece of its text, even when empty. |
| proposed | [[rule:value-line-escapes]] | Proposed: an attached `\X` escapes one character from a fixed set; any other is an error. |
| proposed | [[rule:backslash-empty-text]] | An attribute followed only by a framed backslash gets an empty text. |
| proposed | [[rule:missing-value]] | Implicit missing values aren't supported. |
| proposed | [[rule:attribute-after-attribute-with-no-value]] | `:a :b 1` would nest an attribute under an attribute. |
| proposed | [[rule:nested-attributes]] | An attribute can't have attributes. |
| gap | [[rule:bare-typing]] | The frozen typed set by spelling, and every edge spelling |
| proposed | [[rule:nil-spelling]] | `null` is not typed. |
| proposed | [[rule:element-values]] | Attributes can hold elements. |
| proposed | [[rule:element-after-attribute-with-no-value]] | A bare `\|name` where an attribute still waits for its value becomes that value. |
| gap | [[rule:repeated-attributes]] | What an attribute written more than once gives |

## *Part* V — Bodies

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[rule:text-left-edge]] | The first non-blank text line under an owner sets the text's left edge at its column. |
| proposed | [[rule:text-dedent]] | Each later text line loses the left edge's width of leading spaces; spaces beyond it are content. |
| proposed | [[rule:text-shallower-line]] | A text line shallower than the left edge, still inside its owner, is text with a warning, and the edge moves to it. |
| proposed | [[rule:deeper-marker-lines-are-text]] | A line deeper than an established left edge is text, even if it starts with a marker. |
| proposed | [[rule:text-lines-join]] | Consecutive text lines under the same owner form one text, joined by their line endings. |
| proposed | [[rule:text-final-line-ending]] | The last line's line ending is not part of a text; a lone `\` line keeps one. |
| proposed | [[rule:blank-lines-inside-text]] | A blank line between two text lines is part of the text: its newline, and any whitespace past the left edge. |
| proposed | [[rule:edge-blank-lines]] | Blank lines before a text's first line or after its last are layout, not content. |
| proposed | [[rule:main-and-body-separate]] | An element's own-line text and the text below the element are different values and are never joined. |
| proposed | [[rule:prose-passes-through]] | In a prose line, everything other than a leading `\`, embedded forms and escaped embedded forms passes through as written. |
| proposed | [[rule:prose-escaped-embeds]] | In prose, `\\|{`, `\@{` and `\;{` are literal text, with the `\` consumed. |
| proposed | [[rule:line-start-escape]] | A `\` that is the first non-space character of a line is consumed and is not part of the text. |
| proposed | [[rule:line-start-escape-sets-indent]] | The column of a line-start `\` counts as the line's indentation. |
| proposed | [[rule:lone-backslash-line]] | A line holding only `\` gives an empty line of text; spaces before it past the text's left edge are kept. |
| proposed | [[rule:comment-blocks]] | A line whose first non-space character is `;` is a comment. |
| proposed | [[rule:comment-block-owns-deeper-lines]] | Every line indented deeper under a `;` line is part of that comment, never parsed. |
| proposed | [[rule:framed-comments]] | On a line that begins with an element or an attribute, a ` ; ` with a space on each side starts a comment to the end of the line. |
| proposed | [[rule:inline-comments]] | In text, `;{…}` is a comment piece. |
| proposed | [[rule:framed-comment-owns-deeper-lines]] | Lines deeper than a framed comment's `;` belong to the comment, with a warning (a lean). |
| proposed | [[rule:comments-in-tree]] | Comments appear in the «tree». |
| proposed | [[rule:fence-body-not-scanned]] | Everything between a fence's opening and closing lines is body, never scanned for UDON syntax, with no escapes. |
| proposed | [[rule:fence-body-dedent]] | Unless the fence has the trait `exact`, a fence body's first non-blank line sets its left edge, and each line loses that many leading spaces. |
| proposed | [[rule:fence-body-shallower-line]] | A fence body line shallower than the body's left edge warns, and the edge moves to it. |
| proposed | [[rule:fence-exact-trait]] | A fence with the trait `exact` keeps every byte of its body; it replaces the `-` flag. |
| proposed | [[rule:fence-dedent-in-meta]] | The indentation removed from each fence body line is kept in «meta». |
| proposed | [[rule:fence-body-line-endings]] | Every fence body line keeps its line ending, the last included. |
| gap | [[rule:late-attributes]] | An attribute line after content has begun |
| gap | [[rule:attribute-bodies]] | Values written on the lines under an attribute |
| proposed | [[rule:top-level-attributes]] | An attribute line at the top level belongs to the root node. |
| proposed | [[rule:top-level-text-left-edge]] | When a document starts with prose, that text's left edge is column 0 (a lean). |
| proposed | [[rule:top-level-columns]] | Top-level lines may start at any column; the root counts as column −1 (a lean). |

## *Part* VI — Files

| Row-type | Record | Statement |
|---|---|---|
| gap | [[rule:documents-and-files]] | One document per file; whether a file says it is lite |

## *Companions* — derived from the cards; not the spec

| Row-type | Record | Statement |
|---|---|---|
| proposed | [[view:anomalies]] | Every error and warning, gathered from the cards |
| proposed | [[view:backslash]] | Every use of `\\` in lite, in one place |
| proposed | [[expl:markdown]] | What Markdown survives, and the named collisions |
| proposed | [[expl:lite-in-one-page]] | The whole of lite, for a newcomer |
| proposed | [[expl:data-mappings]] | Lite trees as JSON, YAML and XML, and what each loses |
| proposed | [[expl:common-mistakes]] | Near-miss spellings from other notations |
| proposed | [[expl:writing-lite]] | Advice for writers: indentation, closer placement, quoting |
| proposed | [[prop:append-safety]] | Does appending a top-level block ever change what came before? |

---

## *Working Notes (outline-level)*

- **Cleanup: cards cite 0.10.x.** On 2026-10-20, 33 rule cards and 37 definition cards (plus a few objectives and decisions) mention 0.10.0 or 0.10.x: as grounds, as precedent, in Avoid lists. Joseph, 2026-10-20: "Cards quote 0.10.0? They really shouldn't-- we need to put that on the list of things to fix. I can't see that adding any value whatsoever-- bread-crumbs to a broken draft from another agent working on a problem that was completely distinct from ours and a spec that was never published and that no one knows...." Each mention is to be removed or replaced by the lite reasoning it stood in for; where a card's only ground was 0.10.0, that card's rule needs its own grounds or goes back to Joseph.


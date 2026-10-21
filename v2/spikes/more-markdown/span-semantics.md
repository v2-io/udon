# Semantic span modifiers: meaning → distinction → markup

*2026-10-21, third draft. Joseph asked whether the meanings an inline span can carry ("other voice", "title", "defined term", "acronym" …) could be listed with the forms they usually take, perhaps through an intermediate layer of visual distinctions. He then asked for the meaning table to be fleshed out, with sub-groupings like the one for "signposting" below, and for a domain column, with "general" enough for most rows.*

There are three layers:

1. **Meaning**: why the span is set apart. This set is open: every field adds its own. Table B groups the meanings into families, and the families into broad groups.
2. **Distinction**: the visible contrast used to set the span apart. This set is small and close to closed, about thirty (Table A).
3. **Markup**: how each format writes a distinction. This is a lookup per format.

The layering has precedent. TEI P5 sorts its phrase-level highlighting elements into `hi` (typographically distinct, with no function stated, the rendering recorded in `@rend`) and `model.emphLike`, which is typographically distinct *and* carries a function: `emph`, `foreign`, `distinct`, `mentioned`, `soCalled`, `term`, `gloss`, `title`, `code`, `ident`. That class membership was checked against the TEI class pages ([model.highlighted](https://digitalhumanities.unl.edu/resources/schemas/tei/TEIP5.2.0.2/doc/tei-p5-doc/en/html/ref-model.highlighted.html), [model.emphLike](https://digitalhumanities.unl.edu/resources/schemas/tei/TEIP5.2.0.2/doc/tei-p5-doc/en/html/ref-model.emphLike.html)). HTML does the same in two steps: the element carries the meaning, and the browser's default stylesheet, overridable by CSS, carries the distinction.

**Provenance.** Checked against primaries: the HTML Living Standard's definitions of `<i>`, `<b>` and `<u>` (fetched 2026-10-21) and the TEI class membership above. Everything else is from my own knowledge and wasn't checked: the other TEI elements, the LaTeX and ANSI cells, and every convention. Conventions are tagged with the guide or field I believe states them: CMOS = Chicago Manual of Style, ISO = ISO 80000, HGNC = the human gene naming committee, Leiden = the Leiden conventions for editing ancient texts. Read the tags as "check here", not as citations.

## Table A: distinctions and their markup

| Distinction | Markdown | HTML (element whose default this is / CSS) | LaTeX | Plain text | ANSI terminal |
|---|---|---|---|---|---|
| **Slant, weight, face** | | | | | |
| Italic | `*x*` | `<em>` `<i>` `<cite>` `<dfn>` `<var>` / `font-style: italic` | `\textit`, `\emph` | `_x_`, `/x/` | SGR 3 |
| Roman inside italic (the toggle) | — | `em em { font-style: normal }` | `\emph` toggles by itself | — | — |
| Bold | `**x**` | `<strong>` `<b>` / `font-weight` | `\textbf` | `*x*` | SGR 1 |
| Monospace | `` `x` `` | `<code>` `<kbd>` `<samp>` / `font-family: monospace` | `\texttt` | `` `x` `` | — (already monospace) |
| **Case and capitals** | | | | | |
| Small caps | — (Pandoc `[x]{.smallcaps}`) | `font-variant: small-caps` | `\textsc` | UPPERCASE | — |
| All caps | type it | `text-transform: uppercase` | `\MakeUppercase` | type it | type it |
| Initial capitals | type them | type them | type them | type them | type them |
| **Lines** | | | | | |
| Underline | raw `<u>` | `<u>` `<ins>` / `text-decoration: underline` | `\underline`, `\uline` (ulem) | `_x_` | SGR 4 |
| Wavy underline | — | `text-decoration-style: wavy` | `\uwave` (ulem) | — | SGR 4:3 (some terminals) |
| Strikethrough | `~~x~~` | `<del>` `<s>` / `text-decoration: line-through` | `\sout` (ulem) | `~x~`, `-x-` | SGR 9 |
| Change bar in the margin | — | `border-left` on the block | `changebar` | `\|` in the margin | — |
| **Color and fill** | | | | | |
| Highlight (background) | `==x==` (Obsidian, Pandoc) | `<mark>` / `background-color` | `\hl` (soul) | — | SGR 7 (reverse) or a background color |
| Foreground color | — | `color` | `\textcolor` (xcolor) | — | SGR 30–37, 38;5;n |
| Blacked out (redaction) | `███` (characters) | `background` equal to `color`; the text removed | `\censor` (censor) | `███`, `[REDACTED]` | `███` |
| **Size and position** | | | | | |
| Smaller | — | `<small>` / `font-size: smaller` | `\small` | — | SGR 2 (faint) is the nearest |
| Raised or lowered | `^x^` `~x~` (Pandoc) | `<sup>` `<sub>` | `\textsuperscript`, `\textsubscript` | `^x`, `_x`, Unicode `¹ ₂` | Unicode `¹ ₂` (few characters) |
| Letterspacing | — | `letter-spacing` | `\textls` (microtype), `\so` (soul) | s p a c e d | — |
| **Enclosure and markers** | | | | | |
| Quotation marks | type `“ ”` | `<q>` (default quotes) / CSS `quotes` | `\enquote` (csquotes) | `"x"` | `"x"` |
| Brackets, slashes and other paired symbols | type them | CSS `::before` / `::after` | type them | type them | type them |
| A marker before or after (`*`, `†`, `/s`, a dateline dash) | type it | type it, or CSS `::before` | type it | type it | type it |
| Box | raw `<kbd>` | `border` | `\fbox`; `\keys` (menukeys) | `[Ctrl]` | SGR 7 |
| Emphasis dots (CJK) | — | `text-emphasis` | CJK packages (not checked) | — | — |
| Annotation above (ruby) | — | `<ruby>` `<rt>` | `\ruby` (ruby) | `漢字(かんじ)` | as plain text |
| **Behavior** | | | | | |
| Expansion on demand | — | `title`, `popover` | `\footnote`, a glossary | a parenthesis | a parenthesis |
| Link affordance | `[x](url)` | `<a>` (underline and color) | `\href` (hyperref) | `x <url>` | OSC 8 hyperlink |
| Concealed until revealed | `\|\|x\|\|` (Discord, comrak) | `<details>`, `filter: blur()` | — | `spoiler: …`, ROT13 | SGR 8 |
| Present only for assistive technology | — | a visually-hidden CSS class | tagged-PDF alternate text | — | — |
| None: metadata only | — | an attribute (`lang`, `<time datetime="…">`, `<data value="…">`) | — | — | — |

## Table B: meanings, grouped

Bold rows are groups. Italic rows are families within a group. **Domain** is the field a row's convention belongs to. *General* covers ordinary prose (English-language publishing, the web), which is enough for most rows. A domain row either adds a meaning only that field has, or gives a general meaning the distinction that field uses instead. For example, a defined term is italic or bold in general prose, but in a contract it takes initial capitals. Language is a separate parameter and stays in the conventions column (titles in Chinese text, quotation marks by language). "Usual distinction" is the common default; the conventions column says where a style guide or a sub-kind changes it.

| Meaning | Domain | Example | Usual distinction | Conventions and variants | HTML / ARIA | TEI |
|---|---|---|---|---|---|---|
| **1. Stress and salience** | | | | | | |
| *Emphasis: changes how the sentence is said* | | | | | | |
| Stress | general | I *said* no. | italic | italic inside italic flips to roman; German has traditionally letterspaced; CJK uses emphasis dots | `<em>` | `emph` |
| Contrast | general | not *this* one, *that* one | italic | | `<em>` | `emph` |
| Intensity, shouting | fiction, online chat | “NO.” | all caps, or bold | | `<strong>`, or none | `emph` with `@rend` |
| *Importance: changes how seriously it's taken* | | | | | | |
| Importance | general | the deadline is **Friday** | bold | | `<strong>` | `emph` with `@rend` |
| Warning in running text | general | **Do not** unplug it during the update. | bold | | `<strong>` | `emph` |
| Urgency | general | **Now** accepting submissions | bold | | `<strong>` | `emph` |
| *Signposting: prominence without stress* | | | | | | |
| Lead-in, run-in head | general | **Setup.** Install the package … | bold, or small caps | a run-in head is a heading inside the paragraph | `<b>` | `hi`; `head` if it's a heading |
| Lede opening words | journalism | ᴛʜᴇ ꜰɪʀꜱᴛ ᴡᴏʀᴅꜱ of a feature | small caps | magazines | `<b>`; CSS `::first-line` | `hi` |
| Dateline | journalism | NEW YORK — | all caps, or small caps, with a dash after | | none | `dateline` |
| Byline | journalism | By Jane Doe | none, or smaller | | `<address>`, or none | `byline` |
| Keyword for skimming | general | key words in an abstract; bold terms in a textbook summary | bold | HTML's own example for `<b>` | `<b>` | `hi` |
| Inline label | general | **Note:** this applies to … | bold | often stands in for a callout block | `<b>` | `label` |
| Part of speech, usage label | lexicography | *n.*, *archaic* | italic | | `<i>` | `pos`, `usg` |
| Product names in a review | general | the **Canon R5** focuses faster | bold | HTML's own example for `<b>` | `<b>` | `name` |
| Affordance cue | software | type **look** to look around | bold | actionable words in text-driven software (HTML's example) | `<b>` | `hi` |
| Speaker label | general | **Q:** … **A:** … | bold, or small caps | transcripts, interviews | `<b>`; `<dt>` in a `<dl>` | `speaker` |
| Speaker name | drama | HAMLET. | small caps, or all caps | | `<b>`, or a class | `speaker` |
| *Relevance: marked by a later reader* | | | | | | |
| Search hit | software | results for ==udon== | highlight | | `<mark>` | `hi` |
| Reader's highlight | general | a passage someone flagged | highlight | the mark isn't the author's | `<mark>`; ARIA `mark` | `hi` |
| Emphasis added to a quotation | general | “… *all* persons …” (emphasis added) | italic, or highlight, plus a note | the note says whose mark it is | `<mark>`, or `<em>` with a note | `hi` with `@resp` |
| Current position | software | the step you're on; the word being read aloud | highlight | | `aria-current`; `<mark>` | — |
| **2. Voice and register** | | | | | | |
| *Another voice* | | | | | | |
| Thought, inner speech | general | *Not again*, she thought. | italic | HTML's definition of `<i>` | `<i>` | `said`, `hi` |
| Dream, flashback, telepathy | fiction | | italic | | `<i>` | `hi` |
| Sound, onomatopoeia | fiction | the door went *thunk* | italic | | `<i>` | `hi` |
| Text within the story (a sign, a text message, a letter) | fiction | a sign read NO ENTRY | small caps, all caps, italic or monospace | varies a great deal | `<i>`, or `<samp>` for a screen | `q` with `@type` |
| Action in chat or roleplay | online chat | \*waves\* | italic (asterisks render as italic) | Discord and similar | `<i>` | `stage` |
| *Language* | | | | | | |
| Foreign word or phrase | general | a certain *je ne sais quoi* | italic, with a language tag | CMOS: words naturalized in English stay roman | `<i lang="…">` | `foreign` |
| Naturalized loanword (the contrast) | general | café, karaoke | none | | `lang` only if it matters | — |
| Transliteration | general | *shalom* | italic | | `<i>` | `foreign` |
| *Words about words* | | | | | | |
| A word mentioned, not used | general | the word *run* has many senses | italic, or quotation marks | CMOS prefers italic | `<i>` | `mentioned` |
| A letter as a letter | general | a lowercase *a* | italic | | `<i>` | `mentioned` |
| Gloss or translation of a word | linguistics | *perro* ‘dog’ | single quotes | | — | `gloss` |
| Ungrammatical example | linguistics | \*he goed | a marker before (`*`) | | none | — |
| Reconstructed form | linguistics | \*wódr̥ | a marker before (`*`) | historical linguistics | none | — |
| *Distancing* | | | | | | |
| So-called, scare quotes | general | the “improvements” broke it | quotation marks | | — | `soCalled` |
| Tone indicator | online chat | that went well /s | a marker after | `/s` sarcastic, `/j` joking | — | — |
| *Register* | | | | | | |
| Archaic, dialect, nonstandard | general | *thou*, *y'all* | italic, or quotation marks | | `<i>` | `distinct` |
| Slang or jargon set apart | general | what they call “shrinkflation” | quotation marks | | — | `distinct`, `soCalled` |
| Coinage at first use | general | what I'll call *signposting* | italic, or quotation marks | after first use it's plain | `<i>`; `<dfn>` if defined | `term` |
| *Asides and directions* | | | | | | |
| Side comment, small print | general | prices exclude tax | smaller | | `<small>` | `hi` |
| Legal text, disclaimer | general | | smaller | | `<small>` | `hi` |
| Parenthetical aside | general | — like this — | parentheses or dashes | | — | — |
| Interpolation in someone else's words | general | “he [the mayor] said …” | square brackets | | — | `supplied`, `add` |
| Stage direction | drama | [*Exit, pursued by a bear*] | italic in brackets or parentheses | | `<i>` | `stage` |
| **3. Names and titles** | | | | | | |
| *Titles of works* | | | | | | |
| Standalone work | general | *Moby-Dick*, *The Godfather*, *Nature* | italic | CMOS: books, films, albums, plays, periodicals, long poems, paintings | `<cite>` | `title level="m"` (monograph), `level="j"` (journal) |
| Contained work | general | “The Raven”, “Hey Jude” | quotation marks | CMOS: articles, chapters, short poems, songs, episodes | `<cite>` (no separate element) | `title level="a"` (analytic) |
| Unpublished work | general | a dissertation title | quotation marks | CMOS | `<cite>` | `title level="u"` |
| Series | general | the Oxford History of England | none | CMOS | `<cite>`, or none | `title level="s"` |
| Sacred text | general | the Bible, the Qur'an | none | CMOS | none | `title` |
| Generic part of a work | general | the preface, chapter 3 | none (lowercase) | | none | — |
| Software, app, website | general | Wikipedia, Photoshop | none | CMOS | none | `name` |
| Book title in Chinese text | general | 《紅樓夢》 | the paired marks 《 》, or a wavy underline | language: Chinese | `<cite>` | `title` |
| Case name | law | *Marbury v. Madison* | italic | | `<cite>`, `<i>` | `title` |
| Statute name | law | the Clean Air Act | none | | none | `title` |
| *Names of things* | | | | | | |
| Vessel (ship, aircraft, spacecraft) | general | the *Titanic*, USS *Enterprise* | italic | CMOS; the prefix stays roman | `<i>` | `name` |
| Named entity (person, place, organization, event) | general | Ada Lovelace | none | named-entity markup is metadata | microdata, RDFa | `persName`, `placeName`, `orgName` |
| Proper name in Chinese text | general | an underlined name | underline (proper name mark) | language: Chinese; HTML's own example for `<u>` | `<u>` | `name` with `@rend` |
| Surname in a bibliography | bibliography | LOVELACE, Ada | small caps | French and some bibliographic styles | none | `surname` |
| Divine name | religious texts | the LORD | small caps | KJV and others, for the Tetragrammaton | none | `name` with `@rend` |
| Genus and species | biology | *Homo sapiens* | italic | higher ranks (Hominidae) stay roman | `<i>` | `name` |
| Gene symbol | biology | *BRCA1* (gene) | italic | HGNC: the human protein is written upright, BRCA1 | `<i>` | `name` |
| **4. Terms and definitions** | | | | | | |
| *Defining* | | | | | | |
| Term at its defining use | general | a group is *abelian* if … | italic; bold in textbooks | | `<dfn>`; ARIA `term` | `term` |
| The definition text | general | | none | | ARIA `definition` | `gloss` |
| Defined term at its definition | law | the “**Licensee**” | initial capitals, with bold or quotation marks | | `<dfn>` | `term` |
| Headword | lexicography | **run** | bold | | `<dfn>`, `<b>` | `orth`, `form` |
| Character's first appearance | screenplay | JOHN, 40s, enters | all caps | | none | `name` |
| *Using a defined term* | | | | | | |
| Later use of a glossary term | general | | none, or a link | | `<a>`; DPUB `doc-glossref` | `term` with `@ref` |
| Later use of a defined term | law | the Licensee shall … | initial capitals | | none | `term` with `@ref` |
| *Shortenings* | | | | | | |
| Acronym, pronounced as a word | general | NASA | none; small caps in some book styles | | `<abbr>` | `abbr` |
| Initialism | general | FBI | none; small caps in some book styles | | `<abbr>` | `abbr` |
| Abbreviation with a period | general | approx., Dr. | none | | `<abbr>` | `abbr` |
| Expansion at first use | general | World Health Organization (WHO) | a parenthesis | | `<abbr title="…">` | `expan`, `choice` |
| *Indexing* | | | | | | |
| Index entry | general | | none (an invisible marker) | | — | `index`, `term` |
| Tag for retrieval | online chat, note-taking | #udon | a marker before | Obsidian, social media | `<a rel="tag">` | `term` |
| **5. Code and notation** | | | | | | |
| *Code* | | | | | | |
| Code fragment | software | `x += 1` | monospace | | `<code>` | `code` |
| Identifier | software | the `parse` function | monospace | | `<code>` | `ident` |
| Literal value or string | software | set it to `"auto"` | monospace | | `<code>` | `code` |
| File, path, command, option, environment variable | software | `~/.zshrc`, `--force`, `$HOME` | monospace | | `<code>` | `ident` |
| URL, email address | general | | none, monospace or a link | | `<a>` | `ref`, `ptr` |
| Placeholder to replace | software | `cp ‹source› ‹dest›` | italic monospace, or angle brackets | | `<var>` inside `<code>` | — |
| Optional or repeated part in a syntax summary | software | `ls [-l] file…` | square brackets, an ellipsis | man pages, BNF | — | — |
| *Interaction* | | | | | | |
| A key or a key combination | software | Ctrl+C | monospace, or a box per key | | `<kbd>`, nested for combinations | `hi` |
| Menu path | software | File ▸ Save As | bold, with separators | | `<kbd>` with `<samp>` inside | `hi` |
| Interface label | software | click **Save** | bold | software documentation style guides | — | — |
| Text the user types | software | type `yes` | monospace; bold monospace in terminal transcripts | | `<kbd>` | `code` |
| Program output, error message | software | `permission denied` | monospace | | `<samp>` | `code` |
| *Mathematics and science in prose* | | | | | | |
| Variable | mathematics | let *n* be | italic | ISO: quantity symbols italic | `<var>`; MathML `<mi>` | — (`hi`) |
| Named function or constant | mathematics | sin, log, e | none (upright) | ISO | MathML `<mi mathvariant="normal">` | — |
| Vector, matrix | mathematics | **v**, **A** | bold | ISO: bold italic for vectors | MathML | — |
| Unit symbol | sciences | 5 km, 21 °C | none, with a thin space | ISO / SI: never italic | `<data>` | `measure` |
| Statistical symbol | statistics | *p* < .05, *N* = 40 | italic | APA | `<var>` | — |
| Chemical formula | chemistry | H₂O, CO₂ | lowered digits | | `<sub>` | `formula` |
| Isotope | chemistry | ¹⁴C | a raised number before | | `<sup>` | `formula` |
| *Music in prose* | | | | | | |
| Dynamic mark | music | *ff*, *p* | bold italic | | `<i>` | — |
| Chord symbol | music | C⁷, Gmaj7 | raised extensions | | `<sup>` | — |
| **6. Quotation and reference** | | | | | | |
| *Quoting* | | | | | | |
| Inline quotation | general | she said “not yet” | quotation marks | the marks depend on the language: `“ ”`, `« »`, `„ “`, `「 」` | `<q>` | `q`, `quote` |
| Quotation inside a quotation | general | “… ‘like this’ …” | the other kind of quotation mark | | nested `<q>` | nested `q` |
| Dialogue | fiction | | quotation marks; a dash in some languages | | `<q>`, or none | `said` |
| Quoted text with an error kept | general | it’s affect [*sic*] | [*sic*] after | | — | `sic`, `corr`, `choice` |
| Omission from a quotation | general | “we hold … that” | an ellipsis, sometimes bracketed `[…]` | | — | `gap` |
| *Citing* | | | | | | |
| Author-date citation | scholarship | (Lovelace 1843) | parentheses | | `<a>`; DPUB `doc-biblioref` | `ref`, `bibl` |
| Numbered citation | scholarship | [12], or a superscript ¹² | brackets, or raised | | `<a>`; DPUB `doc-biblioref` | `ref` |
| Citation signal | law | *See*, *Cf.* | italic | Bluebook | `<i>` | — |
| *Notes* | | | | | | |
| Footnote or endnote reference | general | …the claim.³ | raised number or symbol | symbols `* † ‡` in some styles | `<a>` in `<sup>`; DPUB `doc-noteref` | `ref`, `note` |
| Back-link from a note | general | ↩ | a marker | | `<a>`; DPUB `doc-backlink` | `ptr` |
| *Cross-references* | | | | | | |
| Internal reference | general | see Figure 3 | link affordance on screen; none in print | | `<a>` | `ref` |
| Page reference | general | see p. 12 | none | | `<a>` | `ref` |
| "See" and "see also" in an index | general | *see* Typography | italic | CMOS | — | `ref` |
| Cross-reference to another entry | lexicography | see RUN | small caps | | `<a>` | `xr` |
| External link | general | | link affordance | | `<a>` | `ref`, `ptr` |
| Note link by name | note-taking | [[Typography]] | link affordance | Obsidian, wikis | `<a>` | `ref` |
| Mention of a person or account | online chat | @joseph | a marker before, plus a link | | `<a>` | `rs`, `persName` |
| **7. Editorial and textual** | | | | | | |
| *Revision* | | | | | | |
| Deleted | general | ~~was~~ | strikethrough | | `<del>`; ARIA `deletion` | `del` |
| Inserted | general | is | underline, or a color | | `<ins>`; ARIA `insertion` | `add` |
| Substituted | general | ~~was~~ is | strikethrough, then underline | CriticMarkup `{~~old~>new~~}` | `<del>` + `<ins>`; ARIA 1.3 draft `suggestion` | `subst` |
| No longer accurate | general | ~~$40~~ $25 | strikethrough | | `<s>` | `del` with `@type` |
| Changed since the last version | technical documentation | | a change bar in the margin, or a highlight | manuals, standards | `<ins>`, or a class | `@change` |
| *Review* | | | | | | |
| Comment anchored to a span | general | | highlight, with the comment out of line | | ARIA 1.3 draft `comment`; `aria-details` | `note` with `@target` |
| Flagged as misspelt | general | teh | wavy underline (red) | HTML's own example for `<u>` | `<u>` | `sic` |
| Flagged by a grammar or style checker | software | | wavy underline (blue or green) | | `<u>` | — |
| Still to come | journalism, software | the figure is TK | all caps, or highlight | journalism: TK; code: TODO, XXX | `<mark>` | `gap` |
| *Scholarly editions* | | | | | | |
| Lost and restored by the editor | textual scholarship | ἀν[θρώπ]ων | square brackets | Leiden | — | `supplied reason="lost"` |
| Added by the editor to correct an omission | textual scholarship | ⟨a⟩ | angle brackets | Leiden | — | `supplied reason="omitted"` |
| Superfluous in the source | textual scholarship | {a} | curly braces | Leiden | — | `surplus` |
| Erased in the source | textual scholarship | ⟦a⟧ | double square brackets | Leiden | — | `del rend="erasure"` |
| Abbreviation expanded by the editor | textual scholarship | d(ominus) | parentheses; italic expanded letters in diplomatic editions | Leiden | — | `expan`, `ex` |
| Unclear reading | textual scholarship | ạ, or [?] | a dot under the letter, or a question mark | Leiden | — | `unclear` |
| Added above the line in the source | textual scholarship | ⸢word⸣ | half brackets, or raised | | — | `add place="above"` |
| **8. Reading aids** | | | | | | |
| Ruby, furigana | general | 漢字 with かんじ above | annotation above | language: Japanese, Chinese | `<ruby>` `<rt>` | `choice`; TEI ruby |
| Pronunciation respelling | lexicography, journalism | noo-MON-yuh | a stressed syllable in capitals | | none | `pron` |
| Phonemic, phonetic, spelling notation | linguistics | /p/, [pʰ], ⟨p⟩ | slashes, brackets, angle brackets | | none | `pron` |
| Syllable division | lexicography | ex·am·ple | a middle dot | | none | `hyph` |
| Stress mark for learners | language teaching | молоко́ | an accent | language: Russian | the character | — |
| **9. Data carried with the text** | | | | | | |
| Date or time | general | the meeting on 21 October | none | | `<time datetime="…">` | `date`, `time` |
| Number or measured value | general | 3.5 × 10⁸ m/s | none, with a thin space before units | | `<data value="…">` | `num`, `measure` |
| Language of a span | general | | none | | `lang` | `@xml:lang` |
| Text direction isolated | general | | none | | `<bdi>` | — |
| Coordinates, identifiers (ISBN, DOI) | general | | none | | `<data>`; `<a>` | `idno` |
| **10. Status, access and reveal** | | | | | | |
| *Status* | | | | | | |
| Badge | software | `beta`, `new`, `deprecated` | a box, with a fill | | a styled `<span>` | `label` |
| Deprecated name | software | ~~`oldFunc()`~~ | strikethrough, or a warning color | | `<s>` | `hi` |
| Pass, fail, state | software | ✓ passing, ✗ failing | color, with a symbol | WCAG: color can't be the only signal | none | — |
| *Revealing and hiding* | | | | | | |
| Spoiler | online chat | | concealed until revealed | | `<details>`, or a styled span | — |
| Expansion or tooltip | general | | expansion on demand | | `title`, `popover` | `note` |
| Redaction | law, government | the account ███████ | blacked out | the text should be removed, not just covered | none | `gap reason="redacted"` |
| *Accessibility* | | | | | | |
| Text for assistive technology only | general | "(opens in a new tab)" | present only for assistive technology | | a visually-hidden class | — |
| Decoration hidden from assistive technology | general | | none (a visual-only mark) | | `aria-hidden="true"` | — |
| Text alternative for an inline icon | general | ★ (rated 4 of 5) | none (alternate text) | | `alt`, `aria-label` | `figDesc` |

**Domains used:** general · fiction · online chat · note-taking · software · technical documentation · journalism · scholarship · textual scholarship · bibliography · lexicography · linguistics · language teaching · law · government · drama · screenplay · music · mathematics · statistics · sciences · chemistry · biology · religious texts.

## What the table shows

- **The groups split in two by what an unmarked rendering loses.** Groups 1–4, 6 and 7 lose meaning when the mark is dropped. Groups 9 and 10, and parts of 5, lose data or behavior instead: dates, languages and states have no distinction at all. Formats with nothing but visible marks (Markdown, plain text) can't carry those.
- **The mapping goes both ways, many-to-many.** Italic is the usual distinction for about thirty of the meanings above, and small caps for about ten. Going the other way, one meaning takes different distinctions by sub-kind (standalone versus contained titles), by language (stress, quotation marks, titles in Chinese), by domain (defined terms: italic or bold in general, initial capitals in law) and by house style.
- **So the distinction layer takes parameters**: language, domain, a style guide, and context, because nesting flips italic to roman. The markup layer needs none: it's a plain lookup per format.
- **Most domain rows reuse a general family.** About half the rows are domain rows, but only two families hold nothing else: scholarly editions and music in prose. Every other domain row fits a family that general rows share, and differs only in the distinction it chooses. That fits Joseph's suggestion that "general" is enough for most meanings, with domain refinements where they're wanted.
- **Enclosure is the busiest distinction outside running prose.** Scholarly editions, linguistics and syntax summaries do almost everything with paired symbols, each pair meaning something different.
- **The vocabularies differ in fineness.** HTML has about twenty phrase elements and one `<cite>`. ARIA and DPUB add roles for some of the rest. TEI has an element for nearly every row. Markdown has `*x*` and `**x**` for all of it.

## Not settled

- **The edge of "pure semantic".** `<b>` and `<small>` are defined by purpose, but the purpose is close to the look. I've put them in, as HTML does.
- **The domain rows are a sample.** They show the pattern, not a full list for any field.
- **Domain or language?** I treated language (Chinese titles, Russian stress marks) as a separate parameter from domain, because the same field writes differently in different languages. They could be one column.
- **Style guides disagree** (Chicago, APA, AP, the Microsoft guide), and none of the conventions here were checked against one.
- **Where speaker labels belong.** They're filed under signposting, but they could equally be their own family under voice.

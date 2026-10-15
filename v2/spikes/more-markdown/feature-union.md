# The union of features across the lineages

*2026-10-14. A synthesis, not a research finding. Organized by capability, not by syntax: two dialects that do the same thing with different glyphs count as one feature, and a genuine difference in what can be expressed gets its own numbered set (as with the vocabularies of callouts and admonitions in §6). Bespoke Obsidian plugins are left out, and so are renderers that only draw a fenced code block (charts, queries, buttons, diagrams).*

**Lineage codes:** CM = CommonMark core · GFM = the GFM spec plus what github.com renders · GL = GitLab · OB = Obsidian core · PD = Pandoc (with Quarto and R Markdown) · DJ = Djot · MY = MyST (with reStructuredText and Sphinx) · MK = Markdoc · MX = MDX · AD = AsciiDoc · KM = kramdown, MultiMarkdown and PHP Markdown Extra · DF = docs frameworks (Docusaurus, VitePress, Starlight).

**Evidence:** unmarked items are in the feature matrix and its research notes. Items marked † come from my own knowledge (mostly AsciiDoc and reStructuredText, which the research covered only as comparators) and are unverified.

## 1. Document and metadata

- **Front-matter block** — YAML (GFM, GL, OB, PD, MY, MK, MX via plugin); TOML or JSON (GL); Pandoc `%` title block (PD); `Key: value` header (KM); `:name: value` attribute entries in the header † (AD).
- **Document variables substituted into text** — `{name}` † (AD); `|name|` † (MY/rST); `[%var]` (KM); `{% $var %}` (MK); `{expr}` (MX); `%{placeholder}` (GL, behind a flag).
- **Conditional content** — `ifdef::`/`ifeval::` † (AD); `{% if %}` (MK); JavaScript (MX); content shown only for some output formats (PD/Quarto).
- **Include a whole file** — `include::` † (AD); `{include}` (MY); `{% partial %}` (MK); `::include{}` (GL); `{{file}}` (KM); `import` (MX); `![[Note]]` (OB).
- **Include part of a file** — by tagged region or line range † (AD); `{literalinclude}` with line ranges (MY); a heading or block of a note (OB).
- **Comments** — line and block forms: `<!-- -->` (CM family, PD), `%%…%%` (OB), `{% … %}` (DJ), `{/* */}` (MX), `//` and `////` † (AD), `..` † (MY/rST), `%` (MY).

## 2. Sections and outline

- **Headings** — ATX `#` (all Markdown); setext underlines (CM; removed in DJ and MK); multi-line headings (DJ); `= Title` levels † (AD).
- **Heading identifiers** — automatic slugs (GFM, GL, PD, DJ); explicit `{#id}` (PD, DJ, MK, KM); `(label)=` (MY); `[[id]]` or `[#id]` anchors † (AD).
- **Section numbering, and unnumbered sections** — a document option (PD `{-}`, AD `:sectnums:` †, Quarto).
- **Table of contents** — an inline marker (GL `[[_TOC_]]`, KM `{{TOC}}`, AD `toc::[]` †) or a whole-document option (PD, AD †, DF).
- **Thematic break** (all); **page break** `<<<` † (AD).
- **Parts and chapters** — book document type † (AD); Jupyter Book chapter structure (MY).

## 3. Text flow and typography

- **Hard line breaks** — two trailing spaces (CM family, PD); trailing backslash (CM, PD, DJ); a mode where every newline breaks (GitHub comments, OB default, PD option); `+` at line end † (AD).
- **Line blocks** (verse, addresses) — `|` lines (PD, rST †); `[verse]` blocks † (AD).
- **Non-breaking space** — backslash-space (DJ, PD).
- **Smart quotes** (PD, DJ, KM; AD's typographic quotes †).
- **Smart dashes and ellipsis** (PD, DJ, KM).
- **Symbol replacements** — `(c)`, `(tm)`, `->`; Markdoc's typographer handles a few; AD's arrow and copyright replacements † are the broadest.

## 4. Inline semantics

- **Emphasis and strong** — two conventions for the same feature: `*em*` / `**strong**` (CM family, PD, MK, MX) versus `_em_` / `*strong*` (DJ, AD †, Slack).
- **Strikethrough or delete** (GFM, GL, OB, PD, DJ `{-x-}`, KM).
- **Insert / underline** (DJ `{+x+}`, GL inline diff, AD `[.underline]` †, HTML elsewhere).
- **Highlight**, plain (OB, PD `mark`, DJ `{=x=}`, KM CriticMarkup, AD `#x#` †); **highlight with color** (OB 1.14).
- **Superscript and subscript** (PD, DJ, AD †).
- **Small caps** (PD `[x]{.smallcaps}`, DJ via class).
- **Keyboard, menu and button macros** — `kbd:[]`, `menu:[]`, `btn:[]` † (AD); `<kbd>` HTML elsewhere.
- **Inline code**, plain (all); **with a language for highlighting** (PD `{.lang}`, MY role).
- **Inline math** (GFM, GL, OB, PD, DJ, MY, AD `stem:[]` †).
- **Abbreviations defined once, expanded on hover** (KM, PD `abbreviations`, MkDocs).
- **Index terms** — `((term))` † (AD); `{index}` (MY).
- **Generic inline span carrying attributes** — `[text]{.class}` (PD, DJ); roles (MY); annotations (MK); `[.role]#text#` † (AD).
- **Spoiler** (Discord, Reddit; OB only via plugins).
- **Ruby annotation** (HTML; OB only via plugins).
- **Emoji and symbol shortcodes** (GFM, GL, PD option, DJ `:name:`).
- **Raw inline content for one output format** (PD, DJ `{=html}`, AD `pass:[]` †).

## 5. Links and references

- **Inline links** (all).
- **Reference links**, two kinds: resolved against definitions anywhere in the document (CM family, PD) versus recognized by shape only (DJ).
- **Autolinks**, two kinds: in angle brackets (CM; removed in MX) versus bare URLs (GFM, GL, OB; PD option).
- **Wikilinks**, two orders: target first (OB, MediaWiki) versus label first (GL, Gollum).
- **Links to headings by their text** (PD, DJ, OB `[[#Heading]]`, MY).
- **Anchors on arbitrary blocks** (OB `^id`, MY `(label)=`, AD `[[id]]` †, DJ and PD through attributes).
- **Cross-references with automatic numbering** — "Figure 3" (MY `{numref}`, Quarto `@fig-x`, AD `<<id>>` with captions †; PD only through filters).
- **Citations rendered by a citation style, with a generated bibliography** (PD, MY, Quarto; AD bibliography extension †; KM `[#key]`).
- **Footnotes**, three kinds: a reference with a separate definition (GFM on github.com, GL, OB, PD, DJ, MY, KM, AD `footnote:[]` †); inline, with the note written in place (PD, OB); margin notes or sidenotes beside the text (Tufte-style layouts; OB only via plugins).
- **Mentions and platform references** — `@user`, `#123` (GFM, GL). Note that `@key` is a citation in PD and MY.
- **Tags** (OB `#tag`).

## 6. Callouts and admonitions

Two different syntaxes for set-apart notes that share a vocabulary. A **callout** marks a block quote: `> [!NOTE]`. An **admonition** is a labeled paragraph or a labeled block.

- **6a. Callouts** — `> [!type]` on the first line of a block quote: DocFX/GitHub, GL, OB, PD `alerts`.
- **6b. Admonition paragraphs** — a label starts the paragraph: AD `NOTE: text` †. The informal version, a bold label (`**Note:**`, or `> **Note**` in a quote), is what models write when asked in plain words; it renders as ordinary bold text everywhere.
- **6c. Admonition blocks** — a labeled container: AD `[NOTE]` over a `====` block †, MkDocs and Python-Markdown `!!! note` (`???` collapsible), Docusaurus and VitePress `:::note`, MY `:::{note}` and rST `.. note::` †, Quarto's `.callout-*` divs.
- **Vocabulary, across both forms:** a fixed five (note, tip, important, warning, caution: GitHub, PD `alerts`, AD's DocBook set †); a larger built-in set with non-warning kinds such as todo, bug, example, question and abstract (OB's 13 types plus aliases, MY's set with attention, error, hint, seealso, DF's info and danger); custom types the author defines (OB through CSS, MY `{admonition}` with a class, DF custom keywords, VitePress custom names).
- **Other dimensions:** a custom title (OB, GL callouts; MY, DF, Quarto blocks; not GitHub); collapsible (OB `+`/`-`, MkDocs `???`, MY dropdown, Quarto); nesting (OB, MY); placement inside a list item (not on GitHub); an icon (OB, Quarto).

## 7. Other block containers

- **Block quote**, plain (all); **with attribution** — author and source † (AD `[quote, author, source]`); **nested** (all); **fenced** `>>>` (GL).
- **Generic container with class or attributes** — `:::` divs (PD, DJ), `[NAME]` blocks with `====` or `--` † (AD), HTML `<div>` elsewhere.
- **Sidebar and example blocks** — `****` and `====` † (AD); `{sidebar}` (MY).
- **Collapsible section** — `<details>` (GFM, GL, most); `[%collapsible]` † (AD); `{dropdown}` (MY).
- **Tabs** — `{tab-set}` (MY), DF tab components, VitePress `::: code-group`.
- **Multi-column or grid layout** — `{grid}` (MY), MX components; not in core Markdown.
- **Figures with captions** — a lone image becomes a figure (PD); `{figure}` (MY); a titled image † (AD); captions for any block (Quarto).
- **Block alignment** — attributes or classes (PD, DJ, AD †); HTML `align` (GFM).
- **Raw block for one output format** (PD, DJ, MY, AD passthrough blocks †); **literal blocks** with no processing † (AD `....`).

## 8. Lists

- **Bullet and ordered lists** (all), with a starting number (CM).
- **Fancy numbering** — letters, roman numerals, parentheses (PD, DJ; AD `[lowerroman]` †).
- **Auto-numbered markers** `#.` (PD).
- **Example lists** numbered across the whole document, referable by label (PD).
- **Task lists**, three levels of capability: two states (GFM and most); more states (OB any character, GL `[~]`); metadata such as dates and priorities (OB only via plugins).
- **Definition lists** (PD, DJ, GL, KM, MY, AD `term::` †), including several definitions per term (PD).
- **Question-and-answer lists** † (AD `[qanda]`).
- **Field lists and option lists** † (rST; MY `fieldlist`).
- **Joining blocks into one list item** — `+` continuation † (AD); indentation elsewhere.

## 9. Code

- **Fenced code**, backtick and tilde (CM family; DJ has backtick only); **indented code** (CM; removed in DJ and MX).
- **Language tag** (all); **fence attributes** such as id, classes, line numbers, highlighted lines and filename (PD, MX/DF, MY options, AD `[source,py,linenums]` †).
- **Numbered callouts inside code**, explained below the block — `<1>` markers † (AD; unique to AsciiDoc in this set).
- **Code included from a file**, with line ranges or tags (MY `{literalinclude}`, AD `include::` with tags †).
- **Executable code cells** (Quarto and R Markdown ` ```{python} `, MY `{code-cell}`).
- **Interactive session blocks** — doctest † (rST).

## 10. Tables

- **Pipe tables** (GFM, GL, OB, PD, DJ, MY, MK; MX via plugin) and **column alignment** (all pipe-table dialects).
- **Headerless tables** (PD simple and grid tables, DJ, AD †); **more than one header row** (DJ); **footer rows** (KM `=` separator, AD `%footer` †).
- **Captions** (PD `Table:`, DJ `^`, AD titled table †, MY directives).
- **Column widths** — relative widths from dash lengths (PD) or `cols="1,3"` † (AD).
- **Column and row spans** (PD grid tables, AD cell specifiers like `2+|` †, MMD, HTML elsewhere).
- **Block content in cells** (PD grid tables, AD `a|` cells †, MY `{list-table}`, MK `{% table %}`); **line breaks in cells** (`<br>` in GFM, a trailing backslash in PD grid tables).
- **Per-cell alignment and style** † (AD cell specifiers such as `^.^|`).
- **Row headers** (AD `[cols="h,1"]` †; HTML).
- **Nested tables** † (AD `!===`).
- **Tables from data** — CSV or DSV (AD `format=csv` †, MY `{csv-table}`); list-shaped tables (MY `{list-table}`, MK `{% table %}`).

## 11. Media and math

- **Images** with alt text (all); **size and attributes** (OB `|300`, PD `{width=}`, AD `image::[width=]` †, HTML elsewhere).
- **Light and dark variants** (GFM `#gh-dark-mode-only`, `<picture>`).
- **Video and audio** (OB `![[x.mp4]]`, AD `video::` † including YouTube, HTML elsewhere).
- **Display math** (GFM, GL, OB, PD, DJ, MY, AD `stem` blocks †); **numbered and labeled equations** (MY, Quarto `{#eq-}`, PD through filters); **bare LaTeX environments** (PD `raw_tex`); **two math delimiter families**: `$` versus `\(…\)` (the split also shows up in what models emit).

## 12. Editorial markup

- **Tracked-change marks** — CriticMarkup's add, delete, substitute, highlight and comment (KM natively; OB via plugins); GL's inline diff; DJ's insert and delete.
- **Comments hidden from output** (§1); **visible annotations or tooltips** (HTML `title`; OB via plugins).

## 13. Extension mechanisms

These are capabilities of the language itself, distinct from the features above.

- **Generic attributes on any element** (DJ; PD on most elements; MK annotations; AD block attribute lines †).
- **Named directives and roles** with arguments (MY, rST †).
- **Named tags** (MK `{% %}`); **block and inline macros** `name::target[attrs]` and `name:target[attrs]` † (AD); **shortcodes** (Hugo, Quarto).
- **Embedded host language** (MX: JSX, ESM, expressions).
- **Raw passthrough by output format** (PD, DJ, AD †).
- **Fence info strings dispatched to renderers** — the de facto extension point everywhere. Left out of the matrix by design, because it falls back to a plain code block.
- **Post-parse filters** (PD Lua filters, AD extensions †) — outside the syntax.

## What the non-Markdown lineages add

The research covered these lineages only as comparators, so all of this is marked † above. Read as a set, they add the capabilities a technical-documentation format needs and Markdown mostly lacks:

- callouts inside code blocks;
- conditional content;
- includes of tagged regions;
- document attributes substituted into the text;
- rich table cell specifiers (spans, alignment, styles, nested tables);
- question-and-answer, field and option lists;
- sidebars;
- quotes with attribution;
- index terms;
- page breaks;
- a fixed admonition vocabulary.

If any of these matter for udon, they would merit an AsciiDoc column, and possibly a reStructuredText one, in the matrix.

## 14. Beyond the lineages: LaTeX templates and Obsidian plugins

*Added 2026-10-15. Features none of the lineages above provide as syntax, but that people commonly expect from a document system: from LaTeX document classes and packages (named in parentheses), and from Obsidian community plugins that add syntax without a fenced code block. Margin notes, index terms, page breaks and tracked changes are already listed above.*

**From LaTeX templates**
- **Abstract** set apart from the body (`abstract`).
- **Title block** with authors, affiliations and keywords (`\maketitle`, `authblk`).
- **Theorem-like environments**, numbered: theorem, lemma, definition, with a proof ending in an end-of-proof mark (`amsthm`).
- **Epigraph** with attribution at a chapter opening (`epigraph`).
- **Pull quote** repeating a line in larger type.
- **Framed or boxed text** (`mdframed`, `tcolorbox`).
- **Algorithms in numbered pseudocode**, with a caption (`algorithm2e`, `algorithmicx`).
- **Subfigures**: images side by side with sub-captions (a) and (b) and an overall caption (`subcaption`).
- **References to page numbers** that update automatically (`\pageref`).
- **Generated lists of figures and tables** (`\listoffigures`).
- **Appendices** labelled with letters (`\appendix`).
- **Acronyms spelled out on first use, with a generated list** (`acronym`, `glossaries`).
- **Units and quantities** typeset correctly (`siunitx`).
- **Chemical equations** (`mhchem`).
- **Editorial to-do notes in the margin** (`todonotes`).
- **Line numbers for reviewers** (`lineno`).
- **Drop caps** (`lettrine`).
- **Hyphenation hints** for long words (`\-`).
- **Automatically numbered paragraphs**, as in contracts (`enumitem`, numbered paragraph styles).

**From Obsidian community plugins (non-fence syntax)**
- **Colored text** (Text Color, Extended Markdown Syntax).
- **Subtext lines**: smaller, muted text under a line (Extended Markdown Syntax).
- **Inline badges** (Badges).
- **Inline data fields** that queries can read, `key:: value` (Dataview).
- **Key-value lists** displayed as aligned pairs (Key-Value List).
- **Side-brace grouping** of lines with a label (SideBrace).
- **Table formulas** computing a cell (Advanced Tables, Power Tables).
- **Callouts on single list items**, set by a marker character (List Callouts).
- **Templates** that fill in a date or title when a note is created (Templater).
- **Inline icons from an icon set** (Iconize, Icon Shortcodes).

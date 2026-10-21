# Document idioms across Markdown, semantic HTML and LaTeX

*2026-10-21. One row per idiom, a union of the three sources, so the gaps in each show up. Asked for by Joseph to see "what common html idioms are missing in markdown a lot of the time and vice versa", with common LaTeX as the third source.*

**Where each column comes from.** The *Markdown* cells come from this spike's `feature-union.md`, `feature-table.md` and `feature-support.md`, whose comrak and pandoc support was tested on 2026-10-15. Each cell gives the most common syntax among the dialects that have the feature. Most *HTML* cells for features the spike covers are its `feature-support.md` HTML column. The HTML-only rows, the ARIA and DPUB-ARIA additions, and the whole *LaTeX* column come from my own knowledge. I didn't check them against the specs. Against the TeX Live 2025 install on this machine I checked only three things: that the less common packages named below are installed (about thirty-five of them, e.g. menukeys, etaremune, awesomebox, catchfilebetweentags, pdfcomment); that `\textsubscript` is in the kernel; and that graphicx accepts `alt=` but ignores it unless tagging support is loaded.

**Notation.** `<q cite="…">` is a `q` element with a `cite` attribute; `<cite>` on its own is the `cite` element. A bare attribute name such as `<ol reversed>` is a boolean attribute.

**Marks.** Each of the three letter columns rates one source.
- **M**: ● CommonMark or GFM, or rendered on github.com · ◐ in some major dialect (Pandoc, Obsidian, MyST, Djot, GitLab, Markdoc, MDX) or a popular plugin · ○ only as raw HTML · – none.
- **H**: ● a dedicated element or attribute · ◐ an ARIA or DPUB-ARIA role, or a documented convention · ○ ad hoc (a div or span with CSS, JS or a build step) · – none.
- **L**: ● the kernel or the standard classes · ◐ a common package (named in the cell) · ○ built by hand · – none.

| Idiom | M | H | L | Markdown | HTML | LaTeX |
|---|:-:|:-:|:-:|---|---|---|
| **Document and metadata** | | | | | | |
| Title, author, date | ◐ | ● | ● | front matter `title:` `author:` | `<title>`, `<meta name="author">`; visible `<h1>` in `<header>` | `\title` `\author` `\date` `\maketitle` |
| Subtitle | ◐ | ● | ◐ | Pandoc `subtitle:` | `<hgroup>` (`<h1>` + `<p>`); DPUB `doc-subtitle` | `\subtitle` (KOMA classes) |
| Keywords, description | ◐ | ● | ◐ | front matter keys | `<meta name="keywords">`, `<meta name="description">` | hyperref `pdfkeywords=`; `hyperxmp` |
| Abstract | ◐ | ◐ | ● | Pandoc `abstract:` | `<section role="doc-abstract">` | `abstract` environment |
| Author affiliations | – | ○ | ◐ | — (depends on the template) | ad hoc | `authblk` |
| Comment | ● | ● | ● | `<!-- -->` (Obsidian `%%…%%`) | `<!-- -->` | `%` |
| Variables in text | ◐ | ○ | ● | `{% $var %}` (Markdoc), `{{x}}` (templating) | ad hoc (templating) | `\newcommand\x{…}` |
| Conditional content | ◐ | ○ | ◐ | `{% if %}` (Markdoc); Quarto per-format content | `hidden`; otherwise ad hoc | `ifthen`, `etoolbox` |
| Include another file | ◐ | ○ | ● | `![[Note]]` (Obsidian), `{include}` (MyST) | `<iframe>` (embeds, doesn't merge); ad hoc | `\input`, `\include` |
| Include part of a file | ◐ | ○ | ◐ | `![[Note#Heading]]`; MyST `literalinclude` | ad hoc | `catchfilebetweentags`; `\lstinputlisting[firstline=…]` |
| Document language | ◐ | ● | ◐ | Pandoc `lang:` | `<html lang="…">` | `babel`, `polyglossia` |
| **Structure and outline** | | | | | | |
| Headings | ● | ● | ● | `#` … `######` | `<h1>`–`<h6>` | `\section` … `\subparagraph` |
| Explicit section container | ◐ | ● | – | Pandoc `--section-divs`, `:::` | `<section>`, `<article>` | — (sections are implied by `\section`) |
| Parts and chapters | ◐ | ◐ | ● | MyST / Jupyter Book structure | `<section>`; DPUB `doc-part`, `doc-chapter` | `\part`, `\chapter` |
| Front, main and back matter | – | ◐ | ● | — | DPUB `doc-cover`, `doc-dedication`, `doc-foreword`, `doc-preface`, `doc-introduction`, `doc-prologue`, `doc-epilogue`, `doc-conclusion`, `doc-afterword`, `doc-acknowledgments`, `doc-credits`, `doc-errata`, `doc-colophon` | `\frontmatter` `\mainmatter` `\backmatter` (book) |
| Credit for third-party content | – | ◐ | ○ | — | DPUB `doc-credit` | by hand, in the caption |
| Section numbering | ◐ | ○ | ● | Pandoc `-N`, `{-}` to opt out | CSS counters | automatic; `\section*` unnumbered |
| Heading ids | ● | ● | ● | automatic slugs (github.com); `{#id}` (Pandoc, Djot) | `id` | `\label{…}` |
| Table of contents | ◐ | ◐ | ● | `[[_TOC_]]` (GitLab), `[TOC]`; Pandoc `--toc` | `<nav>` + `<ol>`, DPUB `doc-toc`; the list itself built ad hoc | `\tableofcontents` |
| Thematic break | ● | ● | ○ | `---` | `<hr>` | `\noindent\rule{\linewidth}{.4pt}` |
| Page break | – | ◐ | ● | — | CSS `break-before: page`; DPUB `doc-pagebreak` marks where a print edition's page ended, and `doc-pagelist` lists them | `\newpage`, `\clearpage` |
| Page landmarks (header, footer, nav, main, search) | – | ● | – | — | `<header>` `<footer>` `<nav>` `<main>` `<search>`; ARIA `banner`, `contentinfo`, `navigation`, `main`, `search` | — (`fancyhdr` running heads are print furniture, not landmarks) |
| Running heads and page numbers | – | ○ | ◐ | — | CSS `@page` margin boxes (print engines); DPUB `doc-pageheader`, `doc-pagefooter` label them | `fancyhdr`; `\thepage` |
| Appendix | – | ◐ | ● | — | `<section role="doc-appendix">` | `\appendix` |
| **Text flow and typography** | | | | | | |
| Paragraph | ● | ● | ● | blank line | `<p>` | blank line |
| Hard line break | ● | ● | ● | trailing `\` or two spaces | `<br>` | `\\` |
| Verse, line block | ◐ | ○ | ● | `\| line` (Pandoc) | `<br>`s, or CSS `white-space: pre-line` | `verse` |
| Contact address | – | ● | ● | — | `<address>` | `\address` (letter class) |
| Non-breaking space | ● | ● | ● | `&nbsp;` (entity); `\ ` (Pandoc, Djot) | `&nbsp;` | `~` |
| Break and hyphenation hints | ● | ● | ● | `&shy;` (entity only) | `<wbr>`, `&shy;`; CSS `hyphens` | `\-`, `\allowbreak`, `\hyphenation{}` |
| Curly quotes from straight | ◐ | – | ● | smart typography (Pandoc, Djot; comrak `--smart`) | — (type the characters) | ` `` '' ` ligatures |
| Dashes and ellipsis from ASCII | ◐ | – | ● | `--` `---` `...` (Pandoc, Djot) | — (type `–` `—` `…`) | `--` `---` ligatures, `\ldots` |
| Inline quotation | – | ● | ◐ | — (typed quote marks only) | `<q cite="…">` | `\enquote` (csquotes) |
| Side comment, small print | ◐ | ● | ● | `-# text` (comrak `-e subtext`, Obsidian plugin) | `<small>` | `\small`, `\footnotesize` (size only) |
| Font size | – | ○ | ● | — | CSS | `\large`, `\small`, … |
| Colored text | ○ | ○ | ◐ | raw `<span style="…">`; Pandoc `[x]{style=…}` | CSS | `\textcolor` (xcolor) |
| Drop cap | – | ○ | ◐ | — | CSS `::first-letter`, `initial-letter` | `lettrine` |
| Block alignment | ○ | ○ | ● | `<p align="center">` (github.com) | CSS `text-align` (`align` is obsolete) | `center`, `flushright`, `\centering` |
| Multiple columns | ◐ | ○ | ● | `:::: columns` (Pandoc), `{grid}` (MyST) | CSS columns or grid | `\twocolumn`; `multicol` |
| **Inline semantics** | | | | | | |
| Emphasis | ● | ● | ● | `*x*` | `<em>` | `\emph` |
| Strong importance | ● | ● | ● | `**x**` | `<strong>` | `\textbf` (bold, not semantic) |
| Alternate voice, not emphasis | ○ | ● | ● | raw `<i>` (`*x*` folds it into emphasis) | `<i>` (with `lang` for foreign phrases): "a span of text in an alternate voice or mood, or otherwise offset from the normal prose", e.g. a technical term, a phrase in another language, a thought | `\textit` (kept distinct from `\emph`) |
| Attention drawn, not importance | ○ | ● | ○ | raw `<b>` (`**x**` folds it into strong) | `<b>`: attention "for utilitarian purposes without conveying any extra importance", e.g. key words in an abstract, an article lede | — (`\textbf` serves for both) |
| Deleted, no longer accurate | ● | ● | ◐ | `~~x~~` | `<del>` (removed), `<s>` (no longer accurate) | `\sout` (ulem), `\st` (soul) |
| Inserted | ◐ | ● | ◐ | `{+x+}` (Djot), `++x++` (comrak `-e insert`) | `<ins>` | `\added` (changes) |
| Underline | ○ | ● | ● | raw `<u>` | `<u>` | `\underline`; `\uline` (ulem) |
| Highlight | ◐ | ● | ◐ | `==x==` (Obsidian, Pandoc `+mark`) | `<mark>` | `\hl` (soul) |
| Superscript, subscript | ◐ | ● | ● | `^x^` `~x~` (Pandoc, Djot); raw `<sup>` on github.com | `<sup>`, `<sub>` | `\textsuperscript`, `\textsubscript` |
| Small caps | ◐ | ○ | ● | `[x]{.smallcaps}` (Pandoc) | CSS `font-variant` | `\textsc` |
| Inline code | ● | ● | ● | `` `x` `` | `<code>` | `\texttt`, `\verb` |
| Inline code with a language | ◐ | ◐ | ◐ | `` `x`{.rust} `` (Pandoc) | `<code class="language-rust">` | `\mintinline` (minted), `\lstinline` (listings) |
| Keyboard input | ○ | ● | ◐ | raw `<kbd>`; `{kbd}` (MyST) | `<kbd>` | `\keys` (menukeys) |
| Sample output | – | ● | ○ | — | `<samp>` | `\texttt` by convention |
| Variable | – | ● | ● | — (`*x*` or `$x$`) | `<var>` | `$x$` |
| Term at its defining use | ◐ | ● | ◐ | `{term}` and glossary (MyST) | `<dfn>`; ARIA `term` and `definition` pair a term with its definition text | `\gls` (glossaries); `\emph` by convention |
| Abbreviation with expansion | ◐ | ● | ◐ | `*[HTML]: HyperText Markup Language` (PHP Extra, Pandoc) | `<abbr title="…">` | `\acrshort` (acronym), `\gls` (glossaries) |
| Title of a work | – | ● | ◐ | — | `<cite>` | `\citetitle` (biblatex); `\emph` by convention |
| Machine-readable date or time | – | ● | ◐ | — | `<time datetime="…">` | `\today`; `datetime2` (formatting, not markup) |
| Machine-readable value | ◐ | ● | – | `key:: value` (Dataview plugin) | `<data value="…">` | — |
| Units and quantities | – | ◐ | ◐ | — (Unicode, as models write it) | the characters; `<data value="…">` | `siunitx` |
| Ruby annotation | ○ | ● | ◐ | raw `<ruby>` | `<ruby>` `<rt>` `<rp>` | `ruby`, `luatexja-ruby` |
| Language of a phrase | ◐ | ● | ◐ | `[x]{lang=fr}` (Pandoc) | `lang` attribute | `\foreignlanguage` (babel) |
| Bidirectional isolation | – | ● | ◐ | — | `<bdi>`, `<bdo dir="…">`, `dir` | `bidi`, `polyglossia` |
| Generic span with attributes | ◐ | ● | ○ | `[x]{.class}` (Pandoc, Djot) | `<span class="…">` | one `\newcommand` per style |
| Spoiler | ◐ | ○ | – | `\|\|x\|\|` (Discord; comrak `-e spoiler`) | CSS or JS (or `<details>`) | — |
| Emoji shortcodes | ● | – | ◐ | `:tada:` (github.com) | — (the characters) | `emoji` (LuaLaTeX) |
| Tooltip | ○ | ● | ◐ | raw `<span title="…">`; Pandoc `[x]{title=…}` | `title`; `popover` | `pdfcomment` |
| Tags | ◐ | ◐ | – | `#tag` (Obsidian) | `<a rel="tag">` | — |
| Mentions, issue references | ● | ○ | – | `@user`, `#123` (github.com) | `<a>` + class | — |
| **Links, references, notes** | | | | | | |
| Hyperlink | ● | ● | ◐ | `[text](url)` | `<a href="…">` | `\href` (hyperref) |
| Bare URL | ● | ● | ◐ | autolinked (GFM), `<url>` | `<a href="…">` | `\url` (url, hyperref) |
| Link defined elsewhere by label | ● | – | – | `[text][ref]` … `[ref]: url` | — | — |
| Wikilink by note name | ◐ | ○ | – | `[[Note\|label]]` (Obsidian, GitLab) | `<a href="…">`; resolution ad hoc | — |
| Link to a heading by its text | ◐ | ○ | ◐ | `[[#Heading]]` (Obsidian), `[Heading][]` (Pandoc) | `<a href="#id">` | `\nameref` (hyperref) |
| Anchor on any block | ◐ | ● | ● | `^id` (Obsidian), `{#id}` (Pandoc, Djot) | `id` on any element | `\label`, `\hypertarget` |
| Numbered cross-reference ("Figure 3") | ◐ | ○ | ● | `@fig-x` (Quarto), `{numref}` (MyST) | `<a href="…">` + CSS counters or a build step | `\ref`; `\autoref` (hyperref), `\cref` (cleveref) |
| Page-number reference | – | ○ | ● | — | CSS `target-counter()` (print engines) | `\pageref` |
| Footnote | ● | ◐ | ● | `[^1]` … `[^1]: text` (github.com) | ad hoc `<sup><a>` + `<ol>`; DPUB `doc-noteref`, `doc-footnote`, `doc-endnotes` | `\footnote` |
| Inline footnote | ◐ | ◐ | ● | `^[note]` (Pandoc, Obsidian) | as above | `\footnote` (already inline) |
| Margin note | ◐ | ◐ | ● | `{margin}` (MyST) | `<aside>` + CSS | `\marginpar`; `marginnote`, `sidenotes` |
| Citation | ◐ | ○ | ● | `[@key, p. 33]` (Pandoc, MyST, Quarto) | `<a>` + a list; DPUB `doc-biblioref` | `\cite` + BibTeX; biblatex |
| Bibliography | ◐ | ◐ | ● | generated by Pandoc `--citeproc` | DPUB `doc-bibliography` | `thebibliography`, `\bibliography`; `\printbibliography` (biblatex) |
| Glossary | ◐ | ◐ | ◐ | `{glossary}` (MyST) | `<dl>` + `<dfn>`; DPUB `doc-glossary`, `doc-glossref` | `glossaries` |
| Index | ◐ | ◐ | ◐ | `{index}` (MyST) | DPUB `doc-index`; built ad hoc | `\index` + `\printindex` (makeidx, imakeidx) |
| List of figures and tables | – | ○ | ● | — (Pandoc `--lof`, LaTeX output only) | `<nav>`; built ad hoc | `\listoffigures`, `\listoftables` |
| **Blocks and containers** | | | | | | |
| Block quote | ● | ● | ● | `> text` | `<blockquote>` | `quote`, `quotation` |
| Quote with attribution | – | ● | ◐ | — (a `— Author` line by convention) | `<figure>` + `<blockquote>` + `<figcaption>`; `cite` attribute | `displayquote` with a citation (csquotes) |
| Epigraph | – | ◐ | ◐ | — | `<blockquote>`, DPUB `doc-epigraph` | `epigraph` |
| Pull quote | – | ◐ | ○ | — | `<aside>`, DPUB `doc-pullquote` | by hand (`tcolorbox`) |
| Callout, admonition | ● | ◐ | ◐ | `> [!NOTE]` (github.com, GitLab, Obsidian, Pandoc `alerts`) | ad hoc div; `<aside>` or ARIA `note` come closest; DPUB `doc-tip` (clarifies), `doc-notice` (consequences of an action), `doc-example` | `tcolorbox`, `awesomebox` |
| Sidebar, tangent | ◐ | ● | ◐ | `{sidebar}` (MyST) | `<aside>` | `tcolorbox`, `wrapfig` |
| Generic container with a class | ◐ | ● | ● | `::: {.class}` (Pandoc, Djot, MyST, docs frameworks) | `<div class="…">` | `\newenvironment` |
| Collapsible section | ○ | ● | – | raw `<details>` (github.com); `> [!note]-` (Obsidian) | `<details>` + `<summary>` | — |
| Tabs | ◐ | ◐ | – | `{tab-set}` (MyST), VitePress code groups | ARIA `tablist`, `tab`, `tabpanel` + JS | — |
| Figure with caption | ◐ | ● | ● | a lone image becomes a figure (Pandoc); `{figure}` (MyST) | `<figure>` + `<figcaption>` | `figure` + `\caption` |
| Subfigures | – | ● | ◐ | — | `<figure>` inside `<figure>` | `subcaption` |
| Floating placement | – | – | ● | — | — | `[htbp]` floats |
| Framed box | ○ | ○ | ● | raw HTML | CSS border | `\fbox`; `tcolorbox` |
| Preformatted text | ● | ● | ● | fence with no language | `<pre>` | `verbatim` |
| Numbered theorem, definition | ◐ | ○ | ● | `::: {#thm-x}` (Quarto); sphinx-proof (MyST) | ad hoc `<section class="…">` (+ `<dfn>`) | `\newtheorem` |
| Proof with end mark | ◐ | ○ | ◐ | `.proof` div (Quarto) | ad hoc | `proof`, `\qed` (amsthm) |
| Algorithm in pseudocode | – | ○ | ◐ | — (a code block) | `<figure>` + `<pre>` | `algorithm2e`, `algorithmicx` |
| Questions and answers | – | ◐ | – | — | `<dl>` (the HTML spec names this use), or `<details>`; DPUB `doc-qna` | — |
| **Lists** | | | | | | |
| Bulleted list | ● | ● | ● | `- item` | `<ul>` | `itemize` |
| Numbered list with a start | ● | ● | ◐ | `3. item` | `<ol start="…">` | `enumerate` + `enumitem` `start=` |
| Reversed numbering | – | ● | ◐ | — | `<ol reversed>` | `etaremune` |
| Letters, roman numerals | ◐ | ● | ◐ | `a.` `i.` `(1)` (Pandoc, Djot) | `<ol type="a">` | `enumitem` `label=\alph*.` |
| Item's own number or label | – | ● | ● | — | `<li value="…">`; CSS `::marker` | `\item[label]` |
| Numbering continued across lists | ◐ | ○ | ◐ | `(@)` example lists (Pandoc) | `<ol start="…">` set by hand | `enumitem` `resume` |
| Task list | ● | ○ | ○ | `- [ ]`, `- [x]` | ad hoc `<input type="checkbox">` in `<li>` | `\item[$\square$]` |
| Definition list | ◐ | ● | ● | `Term` ⏎ `: definition` (Pandoc, PHP Extra, MyST, GitLab) | `<dl>` `<dt>` `<dd>` | `description` |
| Several blocks in one item | ● | ● | ● | indentation | block content in `<li>` | anything inside `\item` |
| List of commands, toolbar | – | ● | – | — | `<menu>` | — |
| **Code and computing** | | | | | | |
| Code block with a language | ● | ◐ | ◐ | ```` ```lang ```` | `<pre><code class="language-…">` | `lstlisting` (listings), `minted` |
| Line numbers, highlighted lines, filename | ◐ | ○ | ◐ | `{.numberLines}` (Pandoc); `title="x" {1,3}` (docs frameworks) | `<figure>` + `<figcaption>` for a filename; CSS counters | options to listings and minted |
| Callouts inside code | – | ○ | ○ | — (AsciiDoc `<1>`) | ad hoc | escapes in listings, by hand |
| Code from a file | ◐ | ○ | ◐ | `literalinclude` (MyST) | a build step | `\lstinputlisting`, `\inputminted` |
| Executable code, computed result | ◐ | ◐ | ◐ | ```` ```{python} ```` (Quarto, R Markdown) | `<output>` for the result | `pythontex`; knitr, Sweave |
| Console session | ○ | ● | ○ | a code block | `<pre>` with `<kbd>` (input) and `<samp>` (output) | `verbatim` |
| Diagram as code | ● | ○ | ◐ | ```` ```mermaid ```` (github.com) | inline `<svg>`, `<canvas>` | TikZ |
| **Tables** | | | | | | |
| Table | ● | ● | ● | pipe table | `<table>` | `tabular` |
| Column alignment | ● | ○ | ● | `:--:` | CSS (`align` is obsolete) | column spec `l c r` |
| Header cells | ● | ● | ○ | first row | `<thead>`, `<th>` | visual only (`\hline`, booktabs rules) |
| Several header rows | ◐ | ● | ○ | grid tables (Pandoc) | several `<tr>` in `<thead>` | by hand; `longtable` `\endhead` repeats them |
| Row headers | ○ | ● | ○ | raw HTML | `<th scope="row">` | a bold first column |
| Complex header association | – | ● | – | — | `headers`, `scope="colgroup"` | — |
| Footer rows | ◐ | ● | ◐ | grid tables (Pandoc), MultiMarkdown | `<tfoot>` | `longtable` `\endfoot` |
| Caption | ◐ | ● | ● | `Table: caption` (Pandoc) | `<caption>` | `table` + `\caption` |
| Column widths | ◐ | ● | ● | relative dash lengths (Pandoc) | `<col>` + CSS | `p{3cm}`; `tabularx` |
| Column and row spans | ◐ | ● | ● | grid tables (Pandoc) | `colspan`, `rowspan` | `\multicolumn`; `\multirow` (multirow) |
| Block content, line breaks in cells | ◐ | ● | ● | raw `<br>` (GFM); grid tables (Pandoc) | any flow content in `<td>` | `p{}` columns, `\newline` |
| Nested tables | ◐ | ● | ● | a grid table in a grid cell (Pandoc) | `<table>` in `<td>` | `tabular` in a cell |
| Cell shading | ○ | ○ | ◐ | raw HTML | CSS | `\cellcolor` (colortbl) |
| Table from CSV | ◐ | ○ | ◐ | `{csv-table}` (MyST) | JS or a build step | `csvsimple`, `pgfplotstable` |
| Table across pages | – | ○ | ◐ | — | browsers repeat `<thead>` when printing | `longtable` |
| **Media and math** | | | | | | |
| Image with alt text | ● | ● | ◐ | `![alt](src)` | `<img alt="…">` | `\includegraphics` (graphicx); `alt=` is ignored without tagging support |
| Image size | ◐ | ● | ◐ | `{width=50%}` (Pandoc), `\|300` (Obsidian) | `<img width="…" height="…">` | `[width=…]` (graphicx) |
| Responsive or themed image sources | ○ | ● | – | raw `<picture>`; `#gh-dark-mode-only` (github.com) | `<picture>`, `srcset` | — |
| Video, audio | ◐ | ● | – | `![[clip.mp4]]` (Obsidian), `![](clip.mp4)` (GitLab, Pandoc) | `<video>`, `<audio>` | — |
| Captions for media | – | ● | – | — | `<track kind="captions">` | — |
| Embedded page | – | ● | – | — | `<iframe>` | — |
| Image map | – | ● | – | — | `<map>`, `<area>` | — |
| Inline math | ● | ● | ● | `$x$` (github.com) | `<math>` (MathML) | `$x$`, `\(x\)` |
| Display math | ● | ● | ● | `$$…$$`, ```` ```math ```` | `<math display="block">` | `\[…\]`, `equation` |
| Numbered, labeled equation | ◐ | ○ | ● | `{#eq-x}` (Quarto), MyST | `<math>` + CSS counters | `equation` + `\label`; `\eqref` (amsmath) |
| Aligned multi-line equations | ◐ | ● | ◐ | `\begin{aligned}` inside `$$` (MathJax, KaTeX) | `<mtable>` (MathML) | `align` (amsmath) |
| Chemistry | ◐ | ◐ | ◐ | `$\ce{…}$` if the renderer loads mhchem | MathML or `<sub>` | `mhchem` |
| **Editorial and review** | | | | | | |
| Tracked insert and delete, with time | ◐ | ● | ◐ | CriticMarkup `{++x++}` `{--x--}` (kramdown, Obsidian plugin) | `<ins>`, `<del>` with `datetime` and `cite` attributes | `changes` |
| Review comment, suggested change | ◐ | ◐ | ◐ | CriticMarkup `{>>x<<}`, `{~~old~>new~~}` | ARIA 1.3 (editor's draft) `comment`, `suggestion` (wrapping `insertion` + `deletion`), linked by `aria-details` | `todonotes`, `pdfcomment` |
| Line numbers for review | – | ○ | ◐ | — | CSS counters | `lineno` |
| Draft watermark | – | ○ | ◐ | — | CSS | `draftwatermark` |
| **Interaction** | | | | | | |
| Forms and controls | – | ● | ◐ | — | `<form>` `<input>` `<select>` `<textarea>` `<button>` `<label>` `<fieldset>` `<legend>` | PDF form fields (hyperref `Form`) |
| Gauge, progress | – | ● | – | — | `<meter>`, `<progress>` | — |
| Dialog | – | ● | – | — | `<dialog>` | — |
| Popover | – | ● | – | — | `popover` attribute | — |
| Hidden, inert content | – | ● | – | — | `hidden`, `inert` | — |
| Live updates | – | ◐ | – | — | `aria-live`; roles `status`, `alert`, `log` | — |
| Structured data | – | ● | ◐ | — (front matter describes only the document) | microdata `itemprop`, RDFa | `hyperxmp` (document-level only) |
| **Accessibility** | | | | | | |
| Text alternative | ● | ● | ◐ | image alt text only | `alt`, `aria-label`, `aria-labelledby` | needs the tagging support graphicx's `alt=` waits on |
| Longer description | – | ◐ | – | — (the image title is a tooltip) | `aria-describedby`, `aria-details`, `<figcaption>` | — |
| Decorative, hidden from assistive tech | ◐ | ● | ◐ | empty alt, `![](x)` | `alt=""`, `aria-hidden="true"`, `role="presentation"` | artifact marking in tagged PDF |
| Current item, expanded state | – | ● | – | — | `aria-current`, `aria-expanded` (`<details>` sets it natively) | — |
| Navigable outline | ● | ● | ◐ | headings | headings plus landmarks | PDF bookmarks (hyperref) |
| **Extension mechanisms** | | | | | | |
| Attributes on any element | ◐ | ● | – | `{#id .class key=val}` (Pandoc, Djot, Markdoc) | global attributes, `data-*` | — (macros take options; there's no generic attribute) |
| Named custom constructs | ◐ | ● | ● | MyST ```` ```{name} ````, Markdoc `{% tag %}`, MDX `<Comp/>` | custom elements, `<template>`, `<slot>` | `\newcommand`, `\newenvironment` |
| Raw passthrough to another format | ● | – | – | raw HTML (core); `{=latex}` (Pandoc, Djot) | — | — |

## What the table shows

These lists are read off the marks above, so they're only as good as the cells.

**Markdown has nothing, or only raw HTML, where HTML and LaTeX both have the idiom:** inline quotation (`<q>` / `\enquote`); the title of a work (`<cite>`); variables (`<var>`); quotes with attribution; underline; an alternate voice that isn't emphasis (`<i>` / `\textit`); keyboard input; ruby; bidirectional text; dates and times; contact addresses; subfigures; reversed lists and an item's own number; appendices, front matter and back matter; page breaks; forms. HTML is also the only one of the three with row headers and header association in tables.

**HTML has no element, only an ARIA label or ad hoc construction, where Markdown and LaTeX both have the idiom:** footnotes and inline footnotes; margin notes; citations and numbered cross-references; section numbering and a generated table of contents; callouts; numbered theorems and proofs; numbered equations; verse; small caps; multiple columns; column alignment in tables (the `align` attribute is obsolete); code line numbers and code from a file; review comments; smart quotes and dashes, which HTML doesn't need because it takes the characters directly. DPUB-ARIA names several of these (`doc-footnote`, `doc-biblioref`, `doc-toc`), but a role only labels a construct. Nothing in HTML numbers notes or builds the list.

**LaTeX has nothing where the web has the idiom:** collapsible sections, tabs, video and audio, media captions, embedded pages, responsive images, image maps, dialogs, popovers, gauges, live regions, hidden or inert content, page landmarks, explicit section containers, attributes on any element, longer descriptions and widget state for assistive technology, mentions, tags and wikilinks. Hyperlinks need a package (hyperref). Text alternatives depend on tagging support: graphicx accepts `alt=` and ignores it unless that support is loaded.

**Markdown alone has:** link definitions referred to by label (`[ref]: url`), task lists as syntax (the other two fake the checkbox), wikilinks, and raw passthrough to another format.

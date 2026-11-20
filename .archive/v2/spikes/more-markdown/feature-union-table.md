# The feature union, with parser support

One row per feature in `feature-union.md`. The last two columns say what comrak 0.54 and pandoc 3.11 do with the feature, as installed on 2026-10-15: "default" means no options are needed (comrak with no flags; pandoc's default `markdown` reader), a flag or extension name means it must be switched on, and "no" means unsupported. Most cells were checked by running a test input through the binary; per-cell notes are in `matrix/data-impl.js`.

**Lineage codes:** CM CommonMark · GFM GFM spec and github.com · GL GitLab · OB Obsidian · PD Pandoc/Quarto · DJ Djot · MY MyST/rST · MK Markdoc · MX MDX · AD AsciiDoc · KM kramdown/MultiMarkdown/PHP Extra · DF docs frameworks. † marks a lineage known only from memory, not verified by the research.

**Two comrak caveats that apply throughout:** comrak replaces raw HTML with `<!-- raw HTML omitted -->` unless run with `--unsafe`; and its `header-attributes`, `fenced-code-attributes`, `inline-code-attributes` and `link-attributes` extensions parse `{…}` blocks but 0.54's HTML output drops the attributes.

| Feature | Lineages | comrak 0.54 | pandoc 3.11 |
|---|---|---|---|
| **1. Document and metadata** | | | |
| Front-matter block | YAML: GFM, GL, OB, PD, MY, MK, MX; TOML/JSON: GL; `%` title block: PD; `Key: value`: KM; `:attr:` header: AD† | `--front-matter-delimiter ---` (stripped, not interpreted) | default (`yaml_metadata_block`; `%` title block too) |
| Document variables substituted into text | AD†, MY/rST†, KM, MK, MX, GL (flag) | no | no (variables exist only in output templates) |
| Conditional content | AD†, MK, MX, Quarto | no | no (Quarto adds it) |
| Include a whole file | AD†, MY, MK, GL, KM, MX, OB | no | no (Lua filters) |
| Include part of a file | AD†, MY, OB | no | no (Lua filters) |
| Comments | all (`<!-- -->`, `%%`, `{% %}`, `{/* */}`, `//`, `..`) | HTML comments (hidden either way) | HTML comments (kept in HTML output, dropped elsewhere) |
| **2. Sections and outline** | | | |
| Headings (ATX, setext, multi-line) | all; setext removed in DJ, MK | default (`--ignore-setext` turns setext off) | default (blank line needed before `#`) |
| Heading identifiers | automatic: GFM, GL, PD, DJ; explicit `{#id}`: PD, DJ, MK, KM; `(label)=`: MY; `[[id]]`: AD† | automatic ids (`--header-id-prefix ''`); explicit `{#id}` dropped | default (`{#id}` plus automatic ids) |
| Section numbering, and unnumbered sections | PD, AD†, Quarto | no | `-N` / `--number-sections`; `{-}` or `.unnumbered` opts out |
| Table of contents | marker: GL, KM, AD†; option: PD, AD†, DF | no | `--toc` (option, no in-text marker) |
| Thematic break | all | default | default |
| Page break | AD† | no | raw LaTeX (`\newpage`) for PDF only |
| Parts and chapters | AD†, MY | no | `--top-level-division=part` or `chapter` |
| **3. Text flow and typography** | | | |
| Hard line breaks (two spaces, backslash) | CM family, PD, DJ (backslash only), AD† (`+`) | default | default |
| Every newline as a break | GitHub comments, OB default, PD option | `--hardbreaks` | `+hard_line_breaks` |
| Line blocks (verse, addresses) | PD, rST†, AD† | no | default (`\| ` lines) |
| Non-breaking space (backslash-space) | DJ, PD | no | default |
| Smart quotes | PD, DJ, KM, AD† | `--smart` | default (`smart`) |
| Smart dashes and ellipsis | PD, DJ, KM | `--smart` | default (`smart`) |
| Symbol replacements (`(c)`, `->`) | AD†, Markdoc option | no | no |
| **4. Inline semantics** | | | |
| Emphasis and strong, `*em*`/`**strong**` | CM family, PD, MK, MX | default | default |
| Emphasis and strong, `_em_`/`*strong*` | DJ, AD† | no | no (Djot reader only) |
| Strikethrough or delete | GFM, GL, OB, PD, DJ, KM | `-e strikethrough` (also strikes single `~x~`) | default (`~~x~~`) |
| Insert / underline | DJ, GL, AD† | `-e insert` (`++x++`), `-e underline` (`__x__`) | default (`[x]{.underline}`); no insert mark |
| Highlight | OB, PD, DJ, KM, AD† | `-e highlight` (`==x==`) | `markdown+mark` (`==x==`) |
| Highlight with color | OB 1.14 | no | span with a style (HTML output only) |
| Superscript and subscript | PD, DJ, AD† | `-e superscript,subscript` | default (`^x^`, `~x~`) |
| Small caps | PD, DJ (class) | no | default (`[x]{.smallcaps}`) |
| Keyboard, menu and button | AD†; `<kbd>` elsewhere | raw HTML (`--unsafe`) | raw HTML |
| Inline code | all | default | default |
| Inline code with a language | PD, MY (role) | no (attribute dropped) | default (`` `x`{.rust} ``) |
| Inline math | GFM, GL, OB, PD, DJ, MY, AD† | `-e math-dollars` or `-e math-code` | default (`$…$`) |
| Abbreviations | KM, PD, MkDocs | no | `+abbreviations` (parsed and dropped; nothing expands) |
| Index terms | AD†, MY | no | raw LaTeX `\index{}` for PDF only |
| Generic inline span with attributes | PD, DJ, MY (roles), MK (annotations), AD† | no | default (`[text]{.class}`) |
| Spoiler | Discord, Reddit, OB plugins | `-e spoiler` (`\|\|x\|\|`) | no |
| Ruby annotation | HTML, OB plugins | raw HTML (`--unsafe`) | raw HTML |
| Emoji and symbol shortcodes | GFM, GL, PD, DJ | `--gemoji` | `+emoji` |
| Raw inline content for one output format | PD, DJ, AD† | no | default (`` `x`{=html} ``) |
| **5. Links and references** | | | |
| Inline links | all | default | default |
| Reference links, resolved anywhere in the document | CM family, PD | default | default |
| Reference links, recognized by shape | DJ | no | no |
| Angle-bracket autolinks | CM (removed in MX) | default | default |
| Bare-URL autolinks | GFM, GL, OB, PD option | `-e autolink` (`--relaxed-autolinks` widens it) | `+autolink_bare_uris` |
| Wikilinks, target first / label first | OB / GL | `-e wikilinks-title-after-pipe` / `-e wikilinks-title-before-pipe` | `+wikilinks_title_after_pipe` / `+wikilinks_title_before_pipe` |
| Links to headings by their text | PD, DJ, OB, MY | no | default (`[Heading]`) |
| Anchors on arbitrary blocks | OB, MY, AD†, DJ, PD | no | a div or empty span with an id |
| Numbered cross-references | MY, Quarto, AD†; PD via filters | no | no (pandoc-crossref filter or Quarto) |
| Citations with a generated bibliography | PD, MY, Quarto, AD†, KM | no | default (`[@key, p. 33]`, formatted with `--citeproc`) |
| Footnotes, by reference | GFM, GL, OB, PD, DJ, MY, KM, AD† | `-e footnotes` | default |
| Footnotes, inline | PD, OB | `-e inline-footnotes` | default (`^[note]`) |
| Margin notes or sidenotes | Tufte layouts, OB plugins | no | span or div with a class, plus CSS or a filter |
| Mentions and platform references | GFM, GL | no | no (`@key` is a citation in pandoc) |
| Tags | OB | no | no |
| **6. Admonitions and callouts** | | | |
| 6a. Fixed five types (note, tip, important, warning, caution) | AD†, DocFX/GitHub, Quarto, PD | `-e alerts` | `+alerts` (default in `commonmark_x` and `gfm`) |
| 6b. Larger built-in set (todo, bug, example, question…) | OB, MY, DF | no | no |
| 6c. Custom types | OB, MY, DF | `-e block-directive` (`::: name` gives a classed div) | default fenced divs (`::: {.name}`) |
| Callout with a custom title | OB, GL, MY, DF, Quarto | `-e alerts` (title after the marker) | no (a title stops it being an alert) |
| Collapsible callout | OB, Quarto, MY | no | no |
| Nested callouts | OB, MY | `-e alerts` | `+alerts` |
| Callout inside a list item | not GitHub | `-e alerts` | `+alerts` |
| Callout with an icon | OB, Quarto | no | no |
| **7. Other block containers** | | | |
| Block quote, plain and nested | all | default | default (blank line needed before) |
| Block quote with attribution | AD† | no | no |
| Fenced block quote (`>>>`) | GL | `-e multiline-block-quotes` | no |
| Generic container with class or attributes | PD, DJ, AD† | `-e block-directive` (class only; attributes not parsed) | default (`::: {#id .class}`) |
| Sidebar and example blocks | AD†, MY | no | divs with a class |
| Collapsible section | most (`<details>`), AD†, MY | raw HTML (`--unsafe`) | raw HTML |
| Tabs | MY, DF, VitePress | no | no (Quarto adds them) |
| Multi-column or grid layout | MY, MX | no | column divs plus CSS or Quarto |
| Figures with captions | PD, MY, AD†, Quarto | no | default (an image alone in a paragraph becomes a figure) |
| Block alignment | PD, DJ, AD†, GFM (HTML) | raw HTML (`--unsafe`) | a div with a style (HTML output only) |
| Raw block for one output format | PD, DJ, MY, AD† | no | default (```` ```{=latex} ````) |
| Literal block with no processing | AD†; code blocks elsewhere | a code block | a code block |
| **8. Lists** | | | |
| Bullet and ordered lists, with a start number | all | default | default |
| Fancy numbering (letters, roman, parentheses) | PD, DJ, AD† | no | default (`fancy_lists`) |
| Auto-numbered markers (`#.`) | PD | no | default |
| Example lists numbered across the document | PD | no | default (`(@label)`) |
| Task lists, two states | GFM and most | `-e tasklist` | default |
| Task lists, more states | OB, GL | `--relaxed-tasklist-character` (any character checks the box; no distinct states) | no |
| Task metadata (dates, priority) | OB plugins | no | no |
| Definition lists, with several definitions per term | PD, DJ, GL, KM, MY, AD† | `-e description-lists` (several definitions work) | default (several definitions work) |
| Question-and-answer lists | AD† | no | no |
| Field lists and option lists | rST†, MY | no | no |
| Several blocks in one list item | all | default | default |
| **9. Code** | | | |
| Fenced code, backtick and tilde | CM family (DJ: backtick only) | default | default |
| Indented code | CM (removed in DJ, MX) | default | default |
| Language tag | all | default | default |
| Code block options (id, line numbers, highlighted lines, filename) | PD, MX/DF, MY, AD† | `--full-info-string` (passes the rest of the info string to a highlighter) | `fenced_code_attributes`, default (`.numberLines`; no highlighted lines or filename) |
| Numbered callouts inside code | AD† | no | no |
| Code included from a file | MY, AD† | no | no |
| Executable code cells | Quarto, R Markdown, MY | no | no (Quarto adds them) |
| Interactive session blocks (doctest) | rST† | a code block | a code block |
| **10. Tables** | | | |
| Pipe tables with column alignment | GFM, GL, OB, PD, DJ, MY, MK, MX | `-e table` | default |
| Headerless tables | PD, DJ, AD† | no | default (simple, multiline or grid tables) |
| More than one header row | DJ | no | default (grid tables) |
| Footer rows | KM, AD† | no | default (grid tables; tested) |
| Captions | PD, DJ, AD†, MY | no | default (`Table: …`) |
| Column widths | PD, AD† | no | default (relative dash lengths in multiline and grid tables) |
| Column and row spans | PD, AD†, MMD | raw HTML (`--unsafe`) | default (grid tables) |
| Block content in cells | PD, AD†, MY, MK | no | default (grid tables) |
| Line breaks in cells | GFM (`<br>`), PD grid tables | `<br>` with `--unsafe` | default (trailing `\` in grid cells) |
| Per-cell alignment and style | AD† | raw HTML (`--unsafe`) | raw HTML |
| Row headers | AD†, HTML | raw HTML (`--unsafe`) | raw HTML |
| Nested tables | AD† | raw HTML (`--unsafe`) | default (grid table inside a grid cell; tested) |
| Tables from data (CSV) | AD†, MY | no | no (filters) |
| **11. Media and math** | | | |
| Images with alt text | all | default | default |
| Image size and attributes | OB, PD, AD†, HTML | raw HTML (`--unsafe`); `{width=}` parsed but dropped | default (`{width=300px}`) |
| Light and dark image variants | GFM, HTML | raw HTML (`--unsafe`) | raw HTML |
| Video and audio | OB, AD†, HTML | raw HTML (`--unsafe`) | raw HTML |
| Display math | GFM, GL, OB, PD, DJ, MY, AD† | `-e math-dollars` (`$$`) or `-e math-code` (```` ```math ````) | default (`$$…$$`) |
| Numbered and labeled equations | MY, Quarto; PD via filters | no | no (pandoc-crossref filter or Quarto) |
| Bare LaTeX environments | PD | no | default (`raw_tex`) |
| `\(…\)` and `\[…\]` delimiters | ChatGPT-style output | `-e math-latex` | `+tex_math_single_backslash` |
| **12. Editorial markup** | | | |
| Tracked-change marks (add, delete, comment) | KM (CriticMarkup), GL, DJ, OB plugins | partly: `-e insert` plus strikethrough; no comments | no (Lua filters) |
| Visible annotations or tooltips | HTML, OB plugins | raw HTML (`--unsafe`) | default (`[x]{title="…"}`) |
| **13. Extension mechanisms** | | | |
| Generic attributes on any element | DJ, PD, MK, AD† | parsed for headings, code and links, then dropped from output | default on headings, code, links, images, spans and divs; any element with `commonmark_x+attributes` |
| Named directives and roles | MY, rST† | `-e block-directive` (name only) | divs plus Lua filters |
| Named tags, macros, shortcodes | MK, AD†, Hugo, Quarto | `-e phoenix-heex` (passes HEEx component tags through) | no |
| Embedded host language | MX | no | no |
| Raw passthrough by output format | PD, DJ, AD† | no | default (`raw_attribute`) |
| Fence info strings handed to renderers | everywhere | the info string becomes a `language-…` class | the info string becomes a class |
| Post-parse filters | PD, AD† | Rust API plugins (highlighters, heading adapters) | Lua and JSON filters |
| **14. Beyond the lineages: LaTeX templates** | | | |
| Abstract | LaTeX | no | `abstract:` in YAML metadata (standalone templates) |
| Title block with affiliations and keywords | LaTeX | no | `title:`, `author:`, `keywords:` in metadata (no affiliations in default templates) |
| Theorem and proof | LaTeX | no | raw LaTeX for PDF only, or divs plus a filter |
| Numbered definition | LaTeX | no | raw LaTeX for PDF only, or divs plus a filter |
| Epigraph | LaTeX | no | raw LaTeX, or a div plus CSS or a filter |
| Pull quote | LaTeX | no | a div plus CSS or a filter |
| Framed box | LaTeX | raw HTML (`--unsafe`) | a div plus CSS, or raw LaTeX |
| Algorithm in pseudocode | LaTeX | no (a code block is closest) | raw LaTeX for PDF only |
| Subfigures | LaTeX | no | raw LaTeX for PDF only (Quarto has layouts) |
| Reference to a page number | LaTeX | no | raw `\pageref` for PDF only |
| List of figures | LaTeX | no | `--lof` (LaTeX and ConTeXt output) |
| Appendix | LaTeX | no | raw `\appendix` for PDF only |
| Acronyms spelled out on first use | LaTeX | no | no (Lua filters) |
| Units and quantities | LaTeX | no | raw `\SI{}{}` for PDF only |
| Chemical equations | LaTeX | `$\ce{…}$` if the math renderer loads mhchem | `$\ce{…}$` if MathJax or LaTeX loads mhchem |
| Margin to-do notes | LaTeX | no | raw `\todo{}` for PDF only |
| Line numbers for review | LaTeX | no | `header-includes:` with lineno, PDF only |
| Drop caps | LaTeX | raw HTML/CSS (`--unsafe`) | raw LaTeX or HTML |
| Hyphenation hints | LaTeX | Unicode soft hyphen (U+00AD) | U+00AD, or raw `\-` for LaTeX |
| Automatically numbered paragraphs | LaTeX | no | no (ordered lists are closest) |
| **14. Beyond the lineages: Obsidian plugins** | | | |
| Colored text | OB plugins | raw HTML (`--unsafe`) | span with a style (HTML output only) |
| Subtext lines | OB plugins, Discord | `-e subtext` (`-# text`) | no |
| Inline badges | OB plugins | raw HTML (`--unsafe`) | span with a class plus CSS |
| Inline data fields (`key:: value`) | OB plugins | no | no |
| Key-value lists | OB plugins | no (description lists are closest) | no (definition lists are closest) |
| Side-brace grouping | OB plugins | math with `-e math-dollars` | math (`\left.\begin{array}…\right\}`) |
| Table formulas | OB plugins | no | no |
| Callout on one list item | OB plugins | no | no |
| Note templates | OB plugins | no | no |
| Inline icons from an icon set | OB plugins | no (emoji only, `--gemoji`) | no (emoji only, `+emoji`) |

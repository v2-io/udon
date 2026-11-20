// Implementation columns: comrak 0.54.0 and pandoc 3.11, as installed on Joseph's machine (2026-10-15).
// Keyed by feature name: the merged matrix row names, plus the section-14 names from
// haiku-unprimed/prompts.json. A cell is [status, syntax-or-flag, note].
//
// Status semantics for these two columns:
//   C  on by default: comrak with no flags (`comrak -c none`); pandoc's default `-f markdown` reader
//      (other pandoc readers are named in the note where they differ)
//   E  available behind a named flag, extension or reader variant (the flag is in the syntax field)
//   H  no syntax for the feature; reachable only through passthrough: raw HTML (comrak needs --unsafe,
//      otherwise it replaces raw HTML with "<!-- raw HTML omitted -->"), raw LaTeX, or a generic
//      span/div attribute that a stylesheet or filter must interpret
//   U  not supported
//   I  descriptive value
// "tested" in a note means the input was run through the binary; "docs" means the tool's help or manual.
// pandoc readers: md = -f markdown, cmx = -f commonmark_x, cm = -f commonmark, gfm = -f gfm.
window.MATRIX = window.MATRIX || { rows: [] };
MATRIX.implColumns = [
  { key: "comrak", name: "comrak 0.54", sub: "flag that enables it" },
  { key: "pandoc", name: "pandoc 3.11", sub: "extension or reader" }
];
MATRIX.impl = {
  // ---- Dialect properties
  "Specification": {
    comrak: ["I", "Implementation", "Claims CommonMark 0.31.2 compliance; GFM and many other extensions behind flags"],
    pandoc: ["I", "Implementation", "Readers: markdown (pandoc's own), commonmark, commonmark_x, gfm, markdown_mmd, markdown_phpextra, markdown_strict; each takes +ext/-ext toggles"] },
  "Relation to CommonMark": {
    comrak: ["I", "CommonMark by default", "Every extension is opt-in"],
    pandoc: ["I", "md: pre-CommonMark lineage; cm/cmx/gfm: CommonMark-based", ""] },
  "Invalid input": { comrak: ["I", "Total", ""], pandoc: ["I", "Total", ""] },
  "Can a later line change an earlier one?": { comrak: ["I", "Yes", "CommonMark rules"], pandoc: ["I", "Yes", ""] },

  // ---- Block structure
  "ATX heading": { comrak: ["C", "", "tested"], pandoc: ["C", "", "md needs a blank line before (blank_before_header); tested"] },
  "Setext (underlined) heading": { comrak: ["C", "--ignore-setext turns it off", "tested"], pandoc: ["C", "", "tested"] },
  "Indented code (4 spaces)": { comrak: ["C", "", ""], pandoc: ["C", "", ""] },
  "Backtick fence": { comrak: ["C", "", ""], pandoc: ["C", "", "fenced_code_attributes adds {#id .class}"] },
  "Tilde fence": { comrak: ["C", "", ""], pandoc: ["C", "", ""] },
  "Block quote": { comrak: ["C", "", ""], pandoc: ["C", "", "md needs a blank line before (blank_before_blockquote)"] },
  "List directly after a paragraph (no blank line)": {
    comrak: ["C", "", "tested"],
    pandoc: ["E", "+lists_without_preceding_blankline", "Off in md (the list stays paragraph text); on in cm, cmx and gfm; tested"] },
  "Lazy continuation lines": { comrak: ["C", "", "CommonMark rule"], pandoc: ["C", "", ""] },
  "Thematic break": { comrak: ["C", "", ""], pandoc: ["C", "", ""] },
  "Raw HTML block": {
    comrak: ["E", "--unsafe", "Without it, raw HTML becomes \"<!-- raw HTML omitted -->\"; tested"],
    pandoc: ["C", "", "raw_html; tested"] },
  "Markdown inside an HTML block": {
    comrak: ["U", "", "Literal until a blank line, per CommonMark; tested with --unsafe"],
    pandoc: ["C", "", "md (markdown_in_html_blocks): **x** between <div> tags is bold; cm/cmx/gfm leave it literal; tested"] },
  "Nested block quote (>> and > >)": { comrak: ["C", "", ""], pandoc: ["C", "", ""] },
  "Fenced block quote (>>> … >>>)": {
    comrak: ["E", "-e multiline-block-quotes", "tested"],
    pandoc: ["U", "", "Read as three nested quotes; tested"] },
  "Line block (verse, addresses)": {
    comrak: ["U", "", "tested"],
    pandoc: ["C", "| line", "md (line_blocks); not in cmx; tested"] },
  "ATX heading closing #s (## H ##)": { comrak: ["C", "", "tested"], pandoc: ["C", "", "tested"] },

  // ---- Line breaks
  "Hard break: two trailing spaces": { comrak: ["C", "", ""], pandoc: ["C", "", ""] },
  "Hard break: backslash": { comrak: ["C", "", ""], pandoc: ["C", "", "escaped_line_breaks"] },
  "Single newline renders as a break": {
    comrak: ["E", "--hardbreaks", "tested"],
    pandoc: ["E", "+hard_line_breaks", "tested"] },

  // ---- Inline core
  "Emphasis": { comrak: ["C", "", ""], pandoc: ["C", "", ""] },
  "Strong": { comrak: ["C", "", ""], pandoc: ["C", "", ""] },
  "Intraword _ emphasis (snake_case_word)": { comrak: ["U", "", "Left literal; tested"], pandoc: ["U", "", "Left literal (intraword_underscores); tested"] },
  "Code span": { comrak: ["C", "", ""], pandoc: ["C", "", ""] },
  "Inline link": { comrak: ["C", "", ""], pandoc: ["C", "", ""] },
  "Reference link + definition": { comrak: ["C", "", ""], pandoc: ["C", "", ""] },
  "Shortcut reference link": { comrak: ["C", "", ""], pandoc: ["C", "", "shortcut_reference_links"] },
  "Angle-bracket autolink": { comrak: ["C", "", ""], pandoc: ["C", "", ""] },
  "Bare URL autolink": {
    comrak: ["E", "-e autolink", "Included in --gfm; --relaxed-autolinks widens it; tested"],
    pandoc: ["E", "+autolink_bare_uris", "On in gfm; tested"] },
  "Image": { comrak: ["C", "", ""], pandoc: ["C", "", ""] },
  "Inline raw HTML": {
    comrak: ["E", "--unsafe", "Without it, tags are replaced by \"<!-- raw HTML omitted -->\"; tested"],
    pandoc: ["C", "", "tested"] },
  "HTML entities": { comrak: ["C", "", ""], pandoc: ["C", "", ""] },
  "Image size": {
    comrak: ["H", "<img width=\"300\"> with --unsafe", "-e link-attributes consumes {width=300} but 0.54's HTML and XML output drop the attribute; tested"],
    pandoc: ["C", "![a](b.png){width=300px}", "link_attributes, in md and cmx; tested"] },
  "Light and dark image variants": {
    comrak: ["H", "<picture> with --unsafe", ""],
    pandoc: ["H", "<picture>", "Raw HTML"] },
  "Video and audio embed": {
    comrak: ["H", "<video> with --unsafe", ""],
    pandoc: ["H", "<video>", "Raw HTML"] },
  "Color swatch in a code span": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },

  // ---- Tables
  "Pipe table": { comrak: ["E", "-e table", "Included in --gfm; tested"], pandoc: ["C", "", "pipe_tables in md, cmx and gfm; also simple, multiline and grid tables in md; tested"] },
  "Table: column alignment": { comrak: ["E", "-e table", "tested"], pandoc: ["C", "", "tested"] },
  "Table: outer pipes optional (a | b)": { comrak: ["E", "-e table", "tested"], pandoc: ["C", "", "tested"] },
  "Table: shortest delimiter cell": { comrak: ["E", "-e table", "|-|-| accepted; tested"], pandoc: ["C", "", "|-|-| accepted; tested"] },
  "Table directly after a paragraph (no blank line)": {
    comrak: ["E", "-e table", "tested"],
    pandoc: ["U", "", "Stays paragraph text in md, cmx and gfm; tested"] },
  "Table: literal | in a cell": { comrak: ["E", "-e table", "\\| ; tested"], pandoc: ["C", "\\|", "tested"] },
  "Table: rows with too many or too few cells": {
    comrak: ["E", "-e table", "Short rows padded, extra cells dropped; tested"],
    pandoc: ["C", "", "Short rows padded, extra cells dropped; tested"] },
  "Table without a header row": {
    comrak: ["U", "", "tested"],
    pandoc: ["C", "simple, multiline or grid table", "Pipe tables still need a header; tested with a simple table"] },
  "Table: more than one header row": {
    comrak: ["U", "", "tested"],
    pandoc: ["C", "grid table", "A spanning cell above the column headings becomes a second header row; tested"] },
  "Line break inside a table cell": {
    comrak: ["H", "<br> with --unsafe", "tested"],
    pandoc: ["C", "grid table, trailing \\", "Also <br> as raw HTML in pipe tables; tested"] },
  "Block content in a table cell (lists, paragraphs)": {
    comrak: ["U", "", ""],
    pandoc: ["C", "grid table", "tested"] },
  "Column and row spans": {
    comrak: ["H", "HTML table with --unsafe", ""],
    pandoc: ["C", "grid table", "Leave out a | to span; colspan tested, rowspan from docs"] },
  "Table caption": {
    comrak: ["U", "", "\"Table: …\" stays text; tested"],
    pandoc: ["C", "Table: Quarterly results", "table_captions (also \": …\"); tested"] },
  "Decimal-point alignment in a column": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },
  "Task checkbox inside a table cell": { comrak: ["U", "", "tested"], pandoc: ["U", "", "tested (gfm)"] },
  "Table formulas": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },
  "Row-header column (vertical headers)": { comrak: ["H", "HTML table with --unsafe", ""], pandoc: ["H", "HTML table", ""] },
  "Per-cell classes and styles": { comrak: ["H", "HTML table with --unsafe", ""], pandoc: ["H", "HTML table", ""] },

  // ---- Lists & tasks
  "Task list item": { comrak: ["E", "-e tasklist", "Included in --gfm; tested"], pandoc: ["C", "", "task_lists in md, cmx and gfm; tested"] },
  "Task states other than done and not done": {
    comrak: ["E", "--relaxed-tasklist-character", "Any character makes a checked box; no distinct states; tested"],
    pandoc: ["U", "", "[/] stays text; tested"] },
  "Ordered task list (1. [ ])": {
    comrak: ["E", "-e tasklist", "tested"],
    pandoc: ["C", "", "md; the gfm reader leaves it as text; tested"] },
  "Fancy list markers": { comrak: ["U", "", "tested"], pandoc: ["C", "", "fancy_lists in md and cmx; tested"] },
  "Auto-numbered list marker (#.)": { comrak: ["U", "", "tested"], pandoc: ["C", "#.", "md (fancy_lists); not in cmx; tested"] },
  "Example list ((@) numbered across the document)": { comrak: ["U", "", "tested"], pandoc: ["C", "(@label)", "md (example_lists); tested"] },
  "Definition list": {
    comrak: ["E", "-e description-lists", "Term / : definition; tested"],
    pandoc: ["C", "", "definition_lists in md and cmx; tested"] },
  "Custom-label list items": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },
  "List-item callouts": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },
  "Key-value list": { comrak: ["U", "", "Closest: -e description-lists"], pandoc: ["U", "", "Closest: definition lists"] },
  "Task metadata (dates, priority, recurrence)": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },
  "Kanban board from headings and lists": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },

  // ---- Inline extensions
  "Strikethrough": {
    comrak: ["E", "-e strikethrough", "Strikes ~~x~~ and ~x~ (single ~ becomes subscript if -e subscript is on); tested"],
    pandoc: ["C", "~~x~~", "strikeout; single ~ is subscript in md, literal in gfm; tested"] },
  "Highlight": {
    comrak: ["E", "-e highlight", "==x== → <mark>; tested"],
    pandoc: ["E", "markdown+mark", "Not available for cmx (pandoc refuses the extension); tested"] },
  "Underline": {
    comrak: ["E", "-e underline", "Makes __x__ an underline instead of strong; tested"],
    pandoc: ["C", "[x]{.underline}", "bracketed_spans, md and cmx; tested"] },
  "Insert / inline diff": {
    comrak: ["E", "-e insert", "++x++ → <ins>; tested"],
    pandoc: ["U", "", "tested"] },
  "Superscript / subscript": {
    comrak: ["E", "-e superscript,subscript", "^x^ and ~x~; tested"],
    pandoc: ["C", "^x^ ~x~", "md and cmx; tested"] },
  "H~2~O (same input)": {
    comrak: ["I", "strikethrough, or subscript with -e subscript", "tested"],
    pandoc: ["I", "subscript (md, cmx); literal (gfm)", "tested"] },
  "Spoiler": {
    comrak: ["E", "-e spoiler", "||x|| → <span class=\"spoiler\">; tested"],
    pandoc: ["U", "", "tested"] },
  "Keyboard key": { comrak: ["H", "<kbd> with --unsafe", "tested"], pandoc: ["H", "<kbd>", "Raw HTML; tested"] },
  "Small caps": { comrak: ["U", "", "tested"], pandoc: ["C", "[x]{.smallcaps}", "md and cmx; tested"] },
  "Smart quotes": { comrak: ["E", "--smart", "tested"], pandoc: ["C", "", "smart, md and cmx; tested"] },
  "Smart dashes and ellipsis (-- --- ...)": { comrak: ["E", "--smart", "tested"], pandoc: ["C", "", "smart; tested"] },
  "Symbol replacements ((c) (tm) +- -> =>)": { comrak: ["U", "", "--smart leaves (c) and -> alone; tested"], pandoc: ["U", "", "tested"] },
  "Non-breaking space (backslash-space)": {
    comrak: ["U", "", "tested"],
    pandoc: ["C", "\\ ", "md (all_symbols_escapable); not cmx; tested"] },
  "Emoji / symbol shortcodes": {
    comrak: ["E", "--gemoji", ":tada: → 🎉; tested"],
    pandoc: ["E", "+emoji", "On in cmx and gfm; tested"] },
  "Abbreviation / acronym": {
    comrak: ["U", "", "tested"],
    pandoc: ["E", "+abbreviations", "Parses *[HTML]: … lines and drops them; pandoc's document model has no abbreviation, so nothing expands; tested"] },
  "Defined terms (glossary)": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },
  "CriticMarkup": { comrak: ["U", "", "tested"], pandoc: ["U", "", "Lua filters exist; tested"] },
  "Icon shortcodes": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },
  "Text color": {
    comrak: ["H", "<span style> with --unsafe", ""],
    pandoc: ["H", "[x]{style=\"color:red\"}", "HTML output only; tested"] },
  "Subtext line": { comrak: ["E", "-e subtext", "-# text → <sub>; tested"], pandoc: ["U", "", "tested"] },
  "Inline badges / inline callouts": { comrak: ["H", "<span> with --unsafe", ""], pandoc: ["H", "[beta]{.badge}", "Styled by CSS"] },
  "Ruby / furigana": { comrak: ["H", "<ruby> with --unsafe", ""], pandoc: ["H", "<ruby>", "Raw HTML"] },
  "Inline annotation / tooltip": {
    comrak: ["H", "<span title> with --unsafe", ""],
    pandoc: ["H", "[x]{title=\"…\"}", "tested"] },
  "Inline code language tag": {
    comrak: ["U", "", "-e inline-code-attributes consumes {.rust} but 0.54's HTML and XML output drop it; tested"],
    pandoc: ["C", "`code`{.rust}", "inline_code_attributes, highlighted; md and cmx; tested"] },

  // ---- Notes & math
  "Footnote": { comrak: ["E", "-e footnotes", "tested"], pandoc: ["C", "", "md, cmx and gfm; tested"] },
  "Inline footnote": {
    comrak: ["E", "-e inline-footnotes", "With -e footnotes; tested"],
    pandoc: ["C", "^[note]", "md (inline_notes); not cmx or gfm; tested"] },
  "Inline math": {
    comrak: ["E", "-e math-dollars or -e math-code", "$…$ or $`…`$; emits a data-math-style span for a client-side renderer; tested"],
    pandoc: ["C", "$…$", "tex_math_dollars in md, cmx and gfm; gfm also takes $`…`$; renders MathML; tested"] },
  "Display math": {
    comrak: ["E", "-e math-dollars or -e math-code", "$$…$$, or ```math with math-code; tested"],
    pandoc: ["C", "$$…$$", "gfm also takes ```math (tex_math_gfm); docs"] },
  "LaTeX \\( \\) and \\[ \\] math delimiters": {
    comrak: ["E", "-e math-latex", "tested"],
    pandoc: ["E", "+tex_math_single_backslash", "+tex_math_double_backslash for \\\\( \\\\); tested"] },
  "Bare LaTeX environment (\\begin{equation})": {
    comrak: ["U", "", "tested"],
    pandoc: ["C", "", "md (raw_tex): rendered as display math; not cmx; tested"] },

  // ---- Callouts & containers
  "Blockquote callout": {
    comrak: ["E", "-e alerts", "The five GitHub types; --alert-style picks <div> or <aside>; tested"],
    pandoc: ["E", "+alerts", "On in cmx and gfm, off in md; five GitHub types; tested"] },
  "Callout with a custom title": {
    comrak: ["E", "-e alerts", "> [!WARNING] Back up → title \"Back up\"; tested"],
    pandoc: ["U", "", "A title after the marker stops it being an alert; tested"] },
  "Collapsible callout": { comrak: ["U", "", "[!tip]- reads the - as title text; tested"], pandoc: ["U", "", "tested"] },
  "Nested callouts": { comrak: ["E", "-e alerts", "tested"], pandoc: ["E", "+alerts", "tested (cmx)"] },
  "Callout inside a list item": { comrak: ["E", "-e alerts", "tested"], pandoc: ["E", "+alerts", "tested (cmx)"] },
  "Callout types beyond the built-in set": { comrak: ["U", "", "[!TODO] stays a quote; tested"], pandoc: ["U", "", "tested"] },
  "Fenced container (:::)": {
    comrak: ["E", "-e block-directive", "::: name → <div class=\"name\">; an attribute block is copied into the class verbatim, not parsed; tested"],
    pandoc: ["C", "::: {#id .class}", "fenced_divs in md and cmx, full attributes; tested"] },
  "Collapsible section": { comrak: ["H", "<details> with --unsafe", "tested"], pandoc: ["H", "<details>", "Raw HTML; tested"] },
  "Block alignment (centering)": { comrak: ["H", "HTML with --unsafe", ""], pandoc: ["H", "::: {style=\"text-align:center\"}", "HTML output only"] },
  "Multi-column layout": { comrak: ["H", "HTML with --unsafe", ""], pandoc: ["H", "::: columns divs", "Needs CSS or a filter; Quarto renders them"] },
  "Margin note / sidenote": { comrak: ["U", "", ""], pandoc: ["H", "[note]{.marginnote} or raw \\marginpar", "Needs a filter, CSS or LaTeX output"] },
  "Side brace grouping": {
    comrak: ["H", "math: \\left.\\begin{array}…\\right\\}", "With -e math-dollars and a client-side renderer"],
    pandoc: ["H", "math: \\left.\\begin{array}…\\right\\}", "Inside $$…$$"] },

  // ---- Attributes & raw
  "Generic attributes": {
    comrak: ["U", "", "-e header-attributes, fenced-code-attributes, inline-code-attributes and link-attributes parse and strip {…} blocks, but 0.54's HTML and XML output don't carry the attributes; tested"],
    pandoc: ["C", "{#id .class key=val}", "Headings, code, links, images, spans, divs; cmx's attributes extension puts them on any element; tested"] },
  "Bracketed span": { comrak: ["U", "", "tested"], pandoc: ["C", "[text]{.class}", "md and cmx; tested"] },
  "Heading identifier": {
    comrak: ["E", "--header-id-prefix ''", "Automatic ids plus an anchor link; explicit {#id} isn't emitted; tested"],
    pandoc: ["C", "{#id}", "Plus automatic ids (auto_identifiers; gfm_auto_identifiers in cmx and gfm); tested"] },
  "Raw passthrough by format": { comrak: ["U", "", "tested"], pandoc: ["C", "`x`{=html}  ```{=latex}", "raw_attribute in md and cmx; tested"] },

  // ---- Linking & knowledge
  "Wikilink": {
    comrak: ["E", "-e wikilinks-title-after-pipe / -before-pipe", "tested"],
    pandoc: ["E", "+wikilinks_title_after_pipe / _before_pipe", "md, cmx and gfm; tested"] },
  "Include another file": { comrak: ["U", "", ""], pandoc: ["U", "", "Lua filters"] },
  "Code embedded from a repository permalink": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },
  "Block identifier": { comrak: ["U", "", ""], pandoc: ["H", "::: {#id} or []{#id}", "A div or an empty anchor span"] },
  "Tags": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },
  "Platform references": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },
  "Implicit heading reference": { comrak: ["U", "", "tested"], pandoc: ["C", "[Heading]", "implicit_header_references, md and cmx; tested"] },
  "Citation": {
    comrak: ["U", "", "tested"],
    pandoc: ["C", "[@doe2020, p. 33]", "md (citations); --citeproc formats them; not cmx; tested"] },
  "Numbered cross-reference": { comrak: ["U", "", ""], pandoc: ["U", "", "pandoc-crossref filter or Quarto"] },
  "Mention (@name)": { comrak: ["I", "literal text", "tested"], pandoc: ["I", "a citation key (md)", "tested"] },
  "Wikilink pipe trick": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },
  "Image caption and alignment": {
    comrak: ["U", "", "tested"],
    pandoc: ["C", "![caption](img.png)", "md: an image alone in a paragraph becomes a figure (implicit_figures); +implicit_figures for cmx; tested"] },

  // ---- Metadata & comments
  "Front matter": {
    comrak: ["E", "--front-matter-delimiter ---", "Removed from the output, not interpreted; tested"],
    pandoc: ["C", "--- yaml ---", "yaml_metadata_block in md, cmx and gfm: parsed into document metadata; tested"] },
  "How front matter displays": {
    comrak: ["I", "removed", "tested"],
    pandoc: ["I", "metadata; title, author etc. shown by standalone templates", "Not in the body; tested"] },
  "Comment": {
    comrak: ["C", "<!-- … -->", "Hidden either way: replaced by \"<!-- raw HTML omitted -->\", or passed through with --unsafe; tested"],
    pandoc: ["C", "<!-- … -->", "Passed through to HTML, dropped elsewhere; tested"] },
  "Inline fields": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },

  // ---- Publishing
  "Table of contents marker": { comrak: ["U", "", ""], pandoc: ["U", "", "No in-text marker; --toc is a command-line option"] },
  "Inline sparkline or chart": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },

  // ---- Components & code
  "Named components / directives": {
    comrak: ["E", "-e phoenix-heex", "Passes Phoenix HEEx component tags (<.button>, <MyComp/>) through without --unsafe; tested"],
    pandoc: ["U", "", "Divs plus Lua filters"] },
  "Variables / expressions": { comrak: ["U", "", ""], pandoc: ["U", "", "Template variables exist only in output templates"] },
  "Module imports": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },
  "Code block options (line numbers, highlighted lines, filename)": {
    comrak: ["E", "--full-info-string", "The rest of the info string goes into a data-meta attribute for a highlighter to use; tested"],
    pandoc: ["E", "```{.js .numberLines startFrom=5}", "fenced_code_attributes: line numbers work; no highlighted lines or filename; tested"] },
  "Templating": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },
  "Block transform selector": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },

  // ---- Section 14 (keyed by haiku-unprimed/prompts.json feature names)
  "Abstract": { comrak: ["U", "", "Front matter is only stripped"], pandoc: ["C", "abstract: in YAML metadata", "Rendered by the standalone templates; docs"] },
  "Title block with affiliations and keywords": {
    comrak: ["U", "", ""],
    pandoc: ["C", "title:, author:, keywords: in YAML metadata", "Affiliations aren't in the default templates (Quarto adds them); docs"] },
  "Theorem and proof": { comrak: ["U", "", ""], pandoc: ["H", "raw \\begin{theorem} (raw_tex)", "LaTeX/PDF output only, or divs plus a filter"] },
  "Numbered definition": { comrak: ["U", "", ""], pandoc: ["H", "raw \\begin{definition}", "LaTeX/PDF output only, or divs plus a filter"] },
  "Epigraph": { comrak: ["U", "", ""], pandoc: ["H", "raw \\epigraph or ::: epigraph", "Needs LaTeX output or a filter/CSS"] },
  "Pull quote": { comrak: ["U", "", ""], pandoc: ["H", "::: pullquote", "Styled by CSS or a filter"] },
  "Framed box": { comrak: ["H", "HTML with --unsafe", ""], pandoc: ["H", "::: {.box} or raw tcolorbox", "Needs CSS, a filter or LaTeX output"] },
  "Algorithm in pseudocode": { comrak: ["U", "", "A code block is the closest"], pandoc: ["H", "raw algorithmic environment", "LaTeX/PDF output only"] },
  "Subfigures": { comrak: ["U", "", ""], pandoc: ["H", "raw subfigure environment", "LaTeX output only; Quarto has layout-ncol"] },
  "Reference to a page number": { comrak: ["U", "", ""], pandoc: ["H", "raw \\pageref", "LaTeX output only"] },
  "List of figures": { comrak: ["U", "", ""], pandoc: ["E", "--lof (or lof: true)", "LaTeX and ConTeXt output; docs"] },
  "Appendix": { comrak: ["U", "", ""], pandoc: ["H", "raw \\appendix", "LaTeX output only"] },
  "Acronyms spelled out on first use": { comrak: ["U", "", ""], pandoc: ["U", "", "Lua filters"] },
  "Units and quantities": { comrak: ["U", "", ""], pandoc: ["H", "raw \\SI{…}{…}", "LaTeX output only"] },
  "Chemical equation": {
    comrak: ["H", "$\\ce{…}$ with -e math-dollars", "If the client-side math renderer loads mhchem"],
    pandoc: ["H", "$\\ce{…}$", "Math passthrough; MathJax's mhchem or LaTeX's mhchem must render it"] },
  "Margin to-do note": { comrak: ["U", "", ""], pandoc: ["H", "raw \\todo{}", "LaTeX output only"] },
  "Line numbers for review": { comrak: ["U", "", ""], pandoc: ["H", "header-includes: \\usepackage{lineno}", "LaTeX output only"] },
  "Drop cap": { comrak: ["H", "HTML/CSS with --unsafe", ""], pandoc: ["H", "raw \\lettrine or HTML", ""] },
  "Hyphenation hints": {
    comrak: ["H", "Unicode soft hyphen (U+00AD)", "Passes through as a character"],
    pandoc: ["H", "U+00AD, or raw \\- for LaTeX", ""] },
  "Numbered paragraphs": { comrak: ["U", "", ""], pandoc: ["U", "", "Closest: ordered lists"] },
  "Colored text": { comrak: ["H", "<span style> with --unsafe", ""], pandoc: ["H", "[x]{style=\"color:red\"}", "HTML output only; tested"] },
  "Subtext line": { comrak: ["E", "-e subtext", "-# text; tested"], pandoc: ["U", "", "tested"] },
  "Inline badge": { comrak: ["H", "<span> with --unsafe", ""], pandoc: ["H", "[beta]{.badge}", "Styled by CSS"] },
  "Inline data fields": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },
  "Side-brace grouping": {
    comrak: ["H", "math: \\left.\\begin{array}…\\right\\}", "With -e math-dollars and a client-side renderer"],
    pandoc: ["H", "math: \\left.\\begin{array}…\\right\\}", "Inside $$…$$"] },
  "Table formula": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },
  "Callout on one list item": { comrak: ["U", "", ""], pandoc: ["U", "", ""] },
  "Note template": { comrak: ["U", "", ""], pandoc: ["U", "", "pandoc templates shape output, not new notes"] },
  "Inline icon": { comrak: ["U", "", "Emoji only, with --gemoji"], pandoc: ["U", "", "Emoji only, with +emoji"] }
};

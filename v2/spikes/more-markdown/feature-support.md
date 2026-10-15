# Feature support: comrak and Pandoc

*2026-10-15. Every feature in `feature-union.md`, with its lineages and how comrak 0.54.0 and Pandoc 3.11 (its `markdown` reader) handle it. Both are the versions installed on this machine.*

**Lineage codes** are the same as in `feature-union.md`: CM = CommonMark · GFM = GFM spec and github.com · GL = GitLab · OB = Obsidian · PD = Pandoc, Quarto, R Markdown · DJ = Djot · MY = MyST, reStructuredText · MK = Markdoc · MX = MDX · AD = AsciiDoc · KM = kramdown, MultiMarkdown, PHP Markdown Extra · DF = docs frameworks.

**How to read the comrak column:** *core* means CommonMark behavior with no options. `-e name` is an extension passed to `--extension`, and `--name` is a command-line option. *raw HTML* means there's no Markdown syntax, but HTML written in the source passes through when `--unsafe` is set. *no* means no support. **AST:** the comrak 0.54 `NodeValue` variant a parse produces (`comrak::nodes::NodeValue`), checked with `comrak-ast/probes.py`; fields in parentheses are that variant's data, and `attrs` is the field the attribute extensions fill.

**How to read the Pandoc column:** *core* means always on. `+name` is an extension that's on by default in `markdown`. `name (off)` is an extension you have to turn on as `markdown+name`. *commonmark_x* marks extensions that are on by default in Pandoc's CommonMark-based reader. *raw HTML* or *raw TeX* means the content passes through to that output format only. *no* means there's no syntax for it; a filter or template could still add it.

**How to read the LLM columns:** four factors, each scored 0–2 from the single prompts, the bundles, the six whole-table fills and the 2026-10-14 probes, and the stars are their total (eight at most). **U**, understood: the fill models and probes write a correct, recognizable syntax when asked. **S**, spontaneous: Haiku and Sonnet produce that same markup when asked in plain words, without being told a syntax. **T**, stable: the models agree on one form (five or six of six in the fills), and it holds across conditions. **P**, parser fit: the form they produce is parsed by both comrak and Pandoc (2), by one of them or only as passed-through raw HTML or TeX (1), or by neither (0). The notes column says what the models actually write where that differs from the feature's own syntax.

**Callouts and admonitions (§6)** are different syntaxes. A *callout* marks a block quote with `[!type]`. An *admonition* is a labeled paragraph (`NOTE: text`) or a labeled block (`!!! note`, `:::note`, reStructuredText's `.. note::`). The probes asked for an "admonition" in plain words; models answered mostly with callouts, then `!!!` blocks and bold labels, and never with `NOTE: text`. The §6 LLM scores come from those answers.

**How to read the HTML column:** the element or attribute HTML itself provides for the meaning (the HTML Living Standard; MathML for math). `adhoc(x)` means HTML has no element for it, and it's commonly built with x: a div or span with a class, CSS, JavaScript, or a build step. ARIA names like `doc-footnote` are roles from the DPUB-ARIA module. — means the feature is raw HTML already, or isn't a syntax.

**Sources:** the flag lists come from `comrak --help` and `pandoc --list-extensions`. Cells marked *(tested)* were run through the tool on this machine on 2026-10-15. Other cells describe what the extension is documented to do.

| Feature | Lineages | comrak 0.54 | Pandoc 3.11 | LLM | LLM factors and notes | HTML |
|---|---|---|---|---|---|---|
| **1. Document and metadata** | | | | | | |
| Front-matter block | GFM GL OB PD MY MK MX KM AD | `--front-matter-delimiter ---`<br>(a `---` … `---` block at the top is set aside, not parsed; tested)<br>AST: `FrontMatter` (the raw text, delimiters included) | `+yaml_metadata_block` (`---` / `key: value` / `---`),<br>`+pandoc_title_block` (`% Title`);<br>`mmd_title_block` (off; `Title: x` lines) | ★★★★★★★★ | U2 S2 T2 P2 | `<head>`: `<title>`, `<meta>` |
| Document variables in text | AD MY KM MK MX GL | no | no<br>(metadata reaches output templates, not the text) | ★★★★ | U2 S0 T2 P0<br>`{{name}}` from front matter | adhoc(templating) |
| Conditional content | AD MK MX PD | no | no<br>(Quarto adds it with divs) | ★★★ | U1 S0 T2 P0<br>Liquid `{% if %}` | adhoc(templating);<br>`hidden` attribute to hide |
| Include a whole file | AD MY MK GL KM MX OB | no | no (filters) | ★ | U1 S0 T0 P0<br>Liquid, mdBook, Hugo forms | `<iframe>` (embeds, doesn't merge);<br>adhoc(server-side include, js) |
| Include part of a file | AD MY OB | no | no (filters) | ★ | U1 S0 T0 P0 | adhoc(build step, js) |
| Comments | all | raw HTML `<!-- -->`<br>AST: `HtmlBlock`, `HtmlInline` | `+raw_html` (`<!-- -->`) | ★★★★★★★★ | U2 S2 T2 P2<br>`<!-- -->` | `<!-- -->` |
| **2. Sections and outline** | | | | | | |
| ATX headings | all | core (`# H` to `###### H`)<br>AST: `Heading` (`level`, `setext: false`) | core (`# H`)<br>(`+blank_before_header`, `+space_in_atx_header`) | ★★★★★★★★ | U2 S2 T2 P2 | `<h1>`–`<h6>` |
| Setext headings | CM family, PD | core (`H` over `===` or `---`);<br>`--ignore-setext` turns them off<br>AST: `Heading` (`setext: true`) | core (`H` over `===` or `---`) | ★★★★★★ | U2 S0 T2 P2<br>understood, never written | `<h1>`, `<h2>` |
| Automatic heading ids | GFM GL PD DJ | `--header-id-prefix PREFIX`<br>(GitHub-style slugs: `# My Heading` gets `my-heading`, tested)<br>AST: none; the slug is made when rendering HTML | `+auto_identifiers` (`# My Heading` gets `my-heading`);<br>`gfm_auto_identifiers`,<br>`ascii_identifiers` (off) | ★★★★★★★★ | U2 S2 T2 P2<br>links to `#slug` | `id` attribute |
| Explicit heading ids `{#id}` | PD DJ MK KM | `-e header-attributes` (`# H {#id .c key=v}`)<br>(tested: parsed into the tree for Rust API users; HTML and XML output drop it, and the heading id still comes from the text)<br>AST: `Heading`, with the attributes in its `attrs` field | `+header_attributes` (`# H {#id .c}`);<br>`mmd_header_identifiers` (off; `# H [id]`, tested) | ★★★★★★★★ | U2 S2 T2 P2 | `id` attribute |
| Section numbering, unnumbered sections | PD AD | no | `--number-sections` option;<br>`# H {-}` or `# H {.unnumbered}` through `+header_attributes` | ★★★★ | U2 S0 T1 P1<br>`{.unnumbered}` | adhoc(css counters) |
| Table of contents | GL KM AD PD | no | `--toc` option (no inline marker) | ★★ | U1 S1 T0 P0<br>`[TOC]` / `toc: true` | `<nav>` with `<ol>`;<br>the list itself adhoc(build step) |
| Thematic break | all | core (`---`, `***`, `___`)<br>AST: `ThematicBreak` | core (`---`, `***`, `___`) | ★★★★★★★★ | U2 S2 T2 P2 | `<hr>` |
| Page break | AD | no | raw TeX (`\newpage`) | ★★★★ | U1 S2 T0 P1<br>CSS page-break `<div>` | adhoc(css `break-before: page`) |
| Parts and chapters | AD MY | no | `--top-level-division=part\|chapter` option | ★★★★ | U1 S1 T1 P1 | `<section>`, `<article>`<br>(no part or chapter level; adhoc(class)) |
| **3. Text flow and typography** | | | | | | |
| Hard break: two trailing spaces | CM family, PD | core<br>AST: `LineBreak` | core | ★★★★★★ | U2 S1 T1 P2 | `<br>` |
| Hard break: trailing backslash | CM PD DJ | core<br>AST: `LineBreak` | `+escaped_line_breaks` | ★★★★★ | U2 S0 T1 P2 | `<br>` |
| Every newline as a break | GFM comments, OB default | `--hardbreaks`<br>AST: `SoftBreak` (the option is applied when rendering) | `hard_line_breaks` (off) | ★★★★★★★ | U1 S2 T2 P2<br>what plain prose assumes | `<br>`;<br>adhoc(css `white-space: pre-line`) |
| Line blocks (verse, addresses) | PD MY AD | no | `+line_blocks` (`\| ` at the start of each line, tested) | ★★★★★ | U2 S0 T2 P1 | adhoc(div with `<br>` or css `white-space: pre-line`);<br>`<address>` for contact details only |
| Non-breaking space (backslash-space) | DJ PD | no | `+all_symbols_escapable` (`\ ` is a non-breaking space, tested) | ★★★★ | U1 S1 T0 P2<br>`&nbsp;` | `&nbsp;` (U+00A0) |
| Smart quotes | PD DJ KM AD | `--smart` (`"x"`, `'x'` become curly, tested)<br>AST: `Text` (the characters are replaced while parsing) | `+smart` (`"x"`, `'x'` become curly) | ★★★★★★ | U2 S1 T1 P2<br>Unicode typed directly | the characters `“ ” ‘ ’`;<br>`<q>` for a quotation |
| Smart dashes and ellipsis | PD DJ KM | `--smart` (`--`, `---`, `...`, tested)<br>AST: `Text` (the characters are replaced while parsing) | `+smart` (`--`, `---`, `...`);<br>`old_dashes` (off; `-` before a digit is an en dash and `--` an em dash, tested) | ★★★★★★★ | U2 S1 T2 P2 | the characters `– — …` |
| Symbol replacements (`(c)`, `->`) | AD MK | no | no | ★★★ | U1 S1 T1 P0<br>Unicode typed directly | the characters `© →` |
| **4. Inline semantics** | | | | | | |
| Emphasis and strong | all | core (`*x*` or `_x_`, `**x**`)<br>AST: `Emph`, `Strong` | core (`*x*` or `_x_`, `**x**`)<br>(`+intraword_underscores`) | ★★★★★★★★ | U2 S2 T2 P2 | `<em>`, `<strong>` |
| Strikethrough | GFM GL OB PD DJ KM | `-e strikethrough` (`~~x~~`; also `~x~` unless subscript is on, tested)<br>AST: `Strikethrough` | `+strikeout` (`~~x~~`) | ★★★★★★★★ | U2 S2 T2 P2 | `<del>` (removed text),<br>`<s>` (no longer accurate) |
| Insert | DJ GL | `-e insert` (`++x++`, tested)<br>AST: `Insert` | no | ★★ | U1 S0 T0 P1 | `<ins>` |
| Underline | DJ AD | `-e underline`<br>(`__x__` becomes `<u>`, tested)<br>AST: `Underline` | no<br>(`[x]{.underline}` through `+bracketed_spans`) | ★★★★★★ | U2 S2 T1 P1<br>`<u>` | `<u>` |
| Highlight | OB PD DJ KM AD | `-e highlight` (`==x==`, tested)<br>AST: `Highlight` | `mark` (off; `==x==`, tested) | ★★★★ | U2 S0 T0 P2<br>bold, `<mark>` or `==` by context | `<mark>` |
| Highlight with color | OB | no | no (a span with a style) | ★★★ | U1 S1 T0 P1 | `<mark>` with adhoc(css) |
| Superscript and subscript | PD DJ AD | `-e superscript`,<br>`-e subscript` (`^x^`, `~x~`, tested)<br>AST: `Superscript`, `Subscript` | `+superscript`,<br>`+subscript` (`^x^`, `~x~`);<br>`short_subsuperscripts` (off; `x^2`, `H~2`, tested) | ★★★★★ | U2 S0 T1 P2<br>Unicode in prose | `<sup>`, `<sub>` |
| Small caps | PD DJ | no | `+bracketed_spans` (`[x]{.smallcaps}`) | ★★★★ | U2 S0 T1 P1<br>Unicode in prose | adhoc(css `font-variant: small-caps`) |
| Keyboard, menu and button | AD | raw HTML (`<kbd>`)<br>AST: `HtmlInline` (one per tag) | raw HTML (`<kbd>`) | ★★ | U1 S0 T0 P1 | `<kbd>` (nested `<kbd>` for key combinations and menu paths) |
| Inline code | all | core (`` `x` ``)<br>AST: `Code` | core (`` `x` ``) | ★★★★★★★★ | U2 S2 T2 P2 | `<code>` |
| Inline code with a language | PD MY | `-e inline-code-attributes` (`` `x`{.rust} ``)<br>(tested: parsed into the tree; HTML drops the class)<br>AST: `Code`, with the class in its `attrs` field | `+inline_code_attributes` (`` `x`{.rust} ``) | ★★★★★★ | U2 S1 T2 P1 | `<code class="language-…">`<br>(a class prefix the HTML spec suggests) |
| Inline math | GFM GL OB PD DJ MY AD | `-e math-dollars` (`$…$`),<br>`-e math-code` (`` $`…`$ ``),<br>`-e math-latex` (`\(…\)`)<br>AST: `Math` (`display_math: false`) | `+tex_math_dollars` (`$…$`);<br>`tex_math_single_backslash` (`\(…\)`),<br>`tex_math_double_backslash` (`\\(…\\)`),<br>`tex_math_gfm` (`` $`…`$ ``)<br>(all off; tested) | ★★★★★★ | U2 S1 T1 P2<br>Unicode in prose; `\(…\)` from some vendors | `<math>` (MathML) |
| Abbreviations | KM PD | no | `abbreviations` (`*[HTML]: HyperText Markup Language`)<br>(off; tested: the definition is parsed and removed, but HTML gets no `<abbr>`) | ★★★★★ | U2 S1 T1 P1<br>`*[HTML]:` or `<abbr>` | `<abbr title>` |
| Index terms | AD MY | no | no | ★★★★★★★ | U2 S2 T2 P1<br>LaTeX `\index{}` | adhoc(span);<br>`<dfn>` marks a defining use |
| Inline span with attributes | PD DJ MY MK AD | no | `+bracketed_spans` (`[x]{.c}`),<br>`+native_spans` (`<span>`) | ★★★★★★ | U2 S1 T2 P1 | `<span>` |
| Spoiler | Discord, Reddit | `-e spoiler` (`\|\|x\|\|`, tested)<br>AST: `SpoileredText` | no | ★★ | U1 S0 T0 P1 | adhoc(span with css or js) |
| Ruby annotation | HTML | raw HTML (`<ruby>`)<br>AST: `HtmlInline` (one per tag) | raw HTML (`<ruby>`) | ★★★★★★★ | U2 S2 T2 P1<br>`<ruby>` | `<ruby>`, `<rt>`, `<rp>` |
| Emoji shortcodes | GFM GL PD DJ | `--gemoji` (`:tada:`, tested)<br>AST: `ShortCode` (`code`, `emoji`) | `emoji` (`:tada:`)<br>(off; on in commonmark_x) | ★★★★★★ | U2 S1 T1 P2<br>emoji characters in prose | the emoji characters |
| Raw inline content for one format | PD DJ AD | no | `+raw_attribute` (`` `x`{=html} ``) | ★★★★★★ | U2 S1 T2 P1 | — (this is the raw HTML itself) |
| **5. Links and references** | | | | | | |
| Inline links | all | core (`[x](url "title")`)<br>AST: `Link` (`url`, `title`) | core (`[x](url)`)<br>(`+link_attributes`: `[x](url){.c}`) | ★★★★★★★★ | U2 S2 T2 P2 | `<a href>` |
| Reference links | CM PD DJ | core (`[x][ref]` and `[ref]: url`)<br>AST: `Link` (resolved; the label and form are dropped, but the source position still shows them: see `comrak-reference-links.md`) | core (`[x][ref]` and `[ref]: url`)<br>(`+shortcut_reference_links`: `[ref]`; `spaced_reference_links` off) | ★★★★★★★★ | U2 S2 T2 P2 | `<a href>` |
| Angle-bracket autolinks | CM (removed in MX) | core (`<https://…>`)<br>AST: `Link` | core (`<https://…>`) | ★★★★★★ | U2 S1 T1 P2 | `<a href>` |
| Bare-URL autolinks | GFM GL OB | `-e autolink` (`www.example.com`, `https://…`, tested)<br>(`--relaxed-autolinks` loosens it)<br>AST: `Link` | `autolink_bare_uris` (off; `https://…`, tested) | ★★★★★★ | U2 S1 T2 P1 | `<a href>` |
| Wikilinks, target first `[[target\|label]]` | OB | `-e wikilinks-title-after-pipe` (`[[target\|label]]`, tested)<br>AST: `WikiLink` (`url`; the label is its children) | `wikilinks_title_after_pipe` (off; `[[target\|label]]`) | ★★★★★★★ | U2 S1 T2 P2 | `<a href>`;<br>resolving the target adhoc |
| Wikilinks, label first `[[label\|target]]` | GL | `-e wikilinks-title-before-pipe` (`[[label\|target]]`, tested)<br>AST: `WikiLink` (`url`; the label is its children) | `wikilinks_title_before_pipe` (off; `[[label\|target]]`) | ★★★ | U1 S0 T0 P2<br>never written | `<a href>`;<br>resolving the target adhoc |
| Links to headings by their text | PD DJ OB MY | no | `+implicit_header_references` (`[Heading text]`, tested) | ★★ | U1 S0 T0 P1 | `<a href="#id">` |
| Anchors on any block | OB MY AD DJ PD | no | a `:::` div with `{#id}` (`+fenced_divs`);<br>`attributes` (commonmark_x: `{#id}` on the line above a block, tested) | ★★★ | U1 S1 T0 P1 | `id` attribute |
| Numbered cross-references | MY AD PD | no | no<br>(pandoc-crossref filter; Quarto) | ★★★★ | U2 S1 T1 P0<br>pandoc-crossref `@fig:` | `<a href="#id">`;<br>the number adhoc(css counters, build step) |
| Citations | PD MY AD KM | no | `+citations` (`[@key, p. 33]`, `@key`, tested)<br>(rendered with `--citeproc`) | ★★★★★★★ | U2 S2 T2 P1<br>`[@key, p. 33]` | `<cite>` for a work's title;<br>the citation itself adhoc(`<a>` and a reference list) |
| Footnotes | GFM GL OB PD DJ MY KM AD | `-e footnotes` (`[^1]` and `[^1]: …`, tested)<br>AST: `FootnoteReference`, `FootnoteDefinition` | `+footnotes` (`[^1]` and `[^1]: …`) | ★★★★★★ | U2 S1 T1 P2<br>Unicode `¹` in prose | adhoc(`<sup><a>` and an `<ol>`);<br>ARIA `doc-noteref`, `doc-footnote` |
| Inline footnotes `^[…]` | PD OB | `-e inline-footnotes` (`^[…]`; needs `-e footnotes` as well, tested)<br>AST: `FootnoteReference`, `FootnoteDefinition` (named `__inline_1`, …) | `+inline_notes` (`^[…]`) | ★★★★★ | U2 S0 T1 P2 | adhoc(`<sup><a>` and an `<ol>`);<br>ARIA `doc-noteref`, `doc-footnote` |
| Margin notes, sidenotes | Obsidian plugins | no | no | ★ | U1 S0 T0 P0 | `<aside>` with adhoc(css) |
| Mentions and platform references | GFM GL | no | no | ★★★★★★ | U2 S2 T2 P0 | `<a href>` with adhoc(class) |
| Tags | OB | no | no | ★★★★★★ | U2 S2 T2 P0 | `<a rel="tag">` |
| **6. Callouts and admonitions** | | | | | | |
| Callout, five fixed types `> [!NOTE]` | GFM GL OB PD | `-e alerts` (`> [!NOTE]`, tested);<br>`--alert-style` chooses the output element (tested)<br>AST: `Alert` (`alert_type`, `title`) | `alerts` (`> [!NOTE]`)<br>(off; on in commonmark_x; tested) | ★★★★★★ | U2 S1 T1 P2 | adhoc(div with class);<br>`<aside>` or ARIA `role="note"` come closest |
| Callout, larger built-in set `> [!todo]` | OB | no<br>(tested: `> [!todo]` stays a block quote)<br>AST: `BlockQuote` (the `[!todo]` stays text) | no (tested) | ★★★ | U2 S1 T0 P0<br>`> [!todo]` vs MkDocs `!!! todo` | adhoc(div with class) |
| Callout, author-defined type `> [!experiment]` | OB | no<br>(tested: `> [!experiment]` stays a block quote)<br>AST: `BlockQuote` | no (tested) | ★★★ | U1 S1 T0 P1 | adhoc(div with class) |
| Callout title `> [!WARNING] Title` | OB GL | `-e alerts`<br>(tested: `> [!WARNING] Back up first` uses the title)<br>AST: `Alert` (`title`) | no<br>(tested: the alert falls back to a block quote) | ★★★★★ | U2 S1 T1 P1 | adhoc(a heading or `<p>` inside the callout) |
| Collapsible callout `> [!tip]-` | OB | no<br>(tested: a `-` after the type becomes part of the title)<br>AST: `Alert` (`title: "- T"`) | no (tested) | ★★★★ | U2 S1 T1 P0<br>`> [!tip]-` | `<details>`, `<summary>` |
| Callout inside a list item | OB GL | `-e alerts` (`- > [!NOTE]`, tested)<br>AST: `Item` holding an `Alert` | `alerts` (`- > [!NOTE]`, tested) | ★★★★★★★ | U2 S1 T2 P2 | `<li>` holding the callout |
| Admonition paragraph `NOTE: text` | AD | no<br>(tested: an ordinary paragraph)<br>AST: `Paragraph` (`Text "NOTE: text"`) | no<br>(tested: an ordinary paragraph) | ? | not measured: no probe asked for it, and no answer used it | adhoc(`<p>` with a label) |
| Bold-label note `**Note:**` or `> **Note**` | convention | core<br>(no admonition: bold text in a paragraph or block quote, tested)<br>AST: `Strong` in a `Paragraph` or `BlockQuote` | core (no admonition) | ★★★★★ | U2 S2 T1 P0<br>what plain-prose prompts produce, often with an emoji (`💡 **Tip:**`) | `<p>` with `<strong>` |
| Admonition block `!!! note` | DF (MkDocs, Python-Markdown) | no<br>(tested: the lines run together into one paragraph)<br>AST: `Paragraph` | no (tested) | ★★★★ | U2 S2 T0 P0<br>Haiku's usual form; competes with callouts | adhoc(div with class) |
| Admonition block `:::note` | PD DJ MY DF | `-e block-directive` (`:::warning` or `::: warning` … `:::`)<br>(tested: becomes `<div class="warning">`; `::: {.warning}` keeps the braces in the class)<br>AST: `BlockDirective` (`info`) | `+fenced_divs` (`::: warning` or `::: {#id .c}` … `:::`, tested) | ★★★★★★★ | U2 S1 T2 P2 | `<div>`, or the element its class means (`<aside>`, `<section>`, `<figure>`) |
| Admonition block title, collapsing and types | MY DF PD | no<br>(tested: `:::warning Back up first` makes every word a class)<br>AST: `BlockDirective` (`info: "warning Back up first"`) | through attributes:<br>`::: {.warning title="Back up first"}` (tested);<br>collapsing needs Quarto | ★★★★ | U2 S1 T0 P1<br>`!!! warning "Title"`, `??? tip`, `::: {.tip collapse="true"}` | `<details>`, `<summary>` for collapsing;<br>otherwise adhoc(div with class) |
| **7. Other block containers** | | | | | | |
| Block quote, plain and nested | all | core (`> `, `> > `)<br>AST: `BlockQuote` | core (`> `, `> > `)<br>(`+blank_before_blockquote`) | ★★★★★★★★ | U2 S2 T2 P2 | `<blockquote>` |
| Block quote with attribution | AD | no | no | ★★★★★★★ | U2 S2 T2 P1<br>`> — Name, *Source*` | `<figure>` with `<blockquote>` and `<figcaption>`;<br>`<cite>` for the work's title |
| Fenced block quote `>>>` | GL | `-e multiline-block-quotes` (`>>>` … `>>>`, tested)<br>AST: `MultilineBlockQuote` | no | ★ | U0 S0 T0 P1<br>never written | `<blockquote>` |
| Generic container with a class | PD DJ AD | `-e block-directive` (`::: name` … `:::`)<br>AST: `BlockDirective` (`info`) | `+fenced_divs` (`::: {.c}` … `:::`),<br>`+native_divs` (`<div>`) | ★★★★★★★ | U2 S1 T2 P2 | `<div class>` |
| Sidebar and example blocks | AD MY | no | no (a div with a class) | ★★★★★ | U2 S0 T1 P2 | `<aside>` (sidebar);<br>`<figure>` or adhoc(div) (example) |
| Collapsible section | AD MY, HTML | raw HTML (`<details>`)<br>AST: `HtmlBlock` for each tag line; the Markdown between them parses as ordinary blocks | raw HTML (`<details>`) | ★★★★★★★ | U2 S2 T2 P1<br>`<details>` | `<details>`, `<summary>` |
| Tabs | MY DF | no | no<br>(Quarto's `.panel-tabset` div) | ★★ | U1 S0 T0 P1 | adhoc(js);<br>ARIA `tablist`, `tab`, `tabpanel` |
| Multi-column layout | MY | no | no<br>(Quarto's `.columns` divs) | ★★★★★ | U2 S0 T2 P1<br>`::: columns` | adhoc(css columns or grid) |
| Figure with caption | PD MY AD | no syntax; the Rust API's `render.figure_with_caption` option renders an image's title as a `<figcaption>` (not on the command line)<br>AST: `Image` (`title`) | `+implicit_figures` (`![caption](img.png)` alone in a paragraph) | ★★★★★★ | U2 S1 T2 P1 | `<figure>`, `<figcaption>` |
| Block alignment | PD DJ AD | raw HTML<br>AST: `HtmlBlock` | a div with a class or style (`+fenced_divs`) | ★★★★ | U1 S1 T1 P1 | adhoc(css `text-align`) |
| Raw block for one format | PD DJ MY AD | no | `+raw_attribute`<br>(```` ```{=latex} ````), `+raw_tex`, `+raw_html` | ★★★★★★★ | U2 S2 T2 P1<br>```` ```{=latex} ```` | — (this is the raw HTML itself) |
| Literal block | AD | core (a code block)<br>AST: `CodeBlock` | core (a code block) | ★★★★★★★★ | U2 S2 T2 P2 | `<pre>` |
| **8. Lists** | | | | | | |
| Ordered list with a starting number | all | core (`3.` or `3)`)<br>AST: `List` and `Item` (`list_type: Ordered`, `start`, `delimiter`) | core (`3.`; `+startnum`) | ★★★★★★★★ | U2 S2 T2 P2 | `<ol start>` |
| Fancy numbering (letters, roman) | PD DJ AD | no | `+fancy_lists` (`a.`, `iv)`, `(B)`, tested) | ★★★★★★★ | U2 S2 T2 P1 | `<ol type="a">` (also `A`, `i`, `I`) |
| Auto-numbered `#.` | PD | no | `+fancy_lists` (`#.`, tested) | ★★★★★ | U2 S1 T1 P1<br>repeated `1.` in prose | `<ol>` |
| Example lists `(@)` | PD | no | `+example_lists` (`(@)`, `(@label)`, tested) | ★★★★★ | U2 S0 T2 P1 | `<ol start>`<br>(numbering carried across lists adhoc) |
| Task list, two states | GFM GL OB PD DJ | `-e tasklist` (`- [ ]`, `- [x]`)<br>AST: `TaskItem` (`symbol`) in a `List` (`is_task_list`) | `+task_lists` (`- [ ]`, `- [x]`) | ★★★★★★★★ | U2 S2 T2 P2 | adhoc(`<input type="checkbox">` in an `<li>`) |
| Task list, more states | OB GL | `--relaxed-tasklist-character`<br>(tested: `- [/]` is accepted, but any character other than a space renders as checked)<br>AST: `TaskItem` (`symbol: '/'`; the AST keeps the character, tested) | no | ★★★★★ | U2 S1 T1 P1<br>`[/] [-] [!]` vs `[~]` | adhoc(css, icons);<br>a checkbox's `indeterminate` gives a third state, via js |
| Task metadata (dates, recurrence) | Obsidian plugins | no | no | ★★★★ | U2 S0 T2 P0<br>Tasks emoji | `<time datetime>`;<br>the rest adhoc |
| Definition lists | PD DJ GL KM MY AD | `-e description-lists` (`Term` / `: def`, tested)<br>AST: `DescriptionList` › `DescriptionItem` › `DescriptionTerm`, `DescriptionDetails` | `+definition_lists` (`Term` / `:   def`, tested) | ★★★★★★ | U2 S0 T2 P2<br>bold labels in prose | `<dl>`, `<dt>`, `<dd>` |
| Question-and-answer lists | AD | no | no | ★★★★★★ | U2 S2 T2 P0<br>a `**Q:**` convention | `<dl>` (the spec names questions and answers as a use) |
| Field lists, option lists | MY | no | no | ★★★★★ | U2 S1 T2 P0 | `<dl>` |
| Several blocks in one list item | all | core (continuation lines indented to the item's content)<br>AST: `Item` with several block children | core (continuation lines indented)<br>(`four_space_rule` off) | ★★★★★★★ | U2 S1 T2 P2 | `<li>` holding block content |
| **9. Code** | | | | | | |
| Fenced code, backtick and tilde | CM family (DJ backtick only) | core (```` ``` ```` or `~~~`)<br>AST: `CodeBlock` (`fenced`, `fence_char`, `info`) | `+backtick_code_blocks` (```` ``` ````),<br>`+fenced_code_blocks` (`~~~`) | ★★★★★★★★ | U2 S2 T2 P2 | `<pre><code>` |
| Indented code | CM (removed in DJ, MX) | core (four spaces)<br>AST: `CodeBlock` (`fenced: false`) | core (four spaces) | ★★★★★ | U2 S0 T1 P2 | `<pre><code>` |
| Fence attributes (id, classes, line numbers, filename) | PD MX DF MY AD | `-e fenced-code-attributes` (```` ```rust {#id .c} ````)<br>(tested: parsed into the tree; HTML drops it);<br>`--full-info-string` keeps the whole info string<br>AST: `CodeBlock`, with the attributes in its `attrs` field | `+fenced_code_attributes`<br>(`{.python .numberLines startFrom="5"}`) | ★★★★ | U2 S1 T0 P1 | `<pre><code class="language-…">`;<br>`<figure>` with `<figcaption>` for a filename;<br>line numbers adhoc(css counters) |
| Numbered callouts inside code | AD | no | no | ★★★ | U1 S1 T1 P0 | adhoc(span markers and an `<ol>`) |
| Code included from a file | MY AD | no | no (filters) | ★ | U1 S0 T0 P0 | adhoc(build step) |
| Executable code cells | PD MY | no | no<br>(Quarto and knitr run them first) | ★★★★★★★ | U2 S2 T2 P1<br>```` ```{python} ```` | `<pre><code>`;<br>`<output>` for the result |
| Interactive session blocks | MY | core (a code block)<br>AST: `CodeBlock` (`info`) | core (a code block) | ★★★★★★★★ | U2 S2 T2 P2 | `<pre>` with `<kbd>` (input) and `<samp>` (output) |
| **10. Tables** | | | | | | |
| Pipe tables and column alignment | GFM GL OB PD DJ MY MK | `-e table` (`\| a \| b \|` over `\|:--\|--:\|`, tested)<br>AST: `Table` (`alignments`) › `TableRow` (header flag) › `TableCell` | `+pipe_tables` (`\| a \| b \|` over `\|:--\|--:\|`) | ★★★★★★★★ | U2 S2 T2 P2 | `<table>`, `<th>`, `<td>`;<br>alignment adhoc(css; the `align` attribute is obsolete) |
| Headerless tables | PD DJ AD | no | `+simple_tables` (columns under dashed rules, tested),<br>`+multiline_tables`,<br>`+grid_tables` (`+---+` borders) | ★★★ | U2 S0 T0 P1 | `<table>` without `<thead>` |
| More than one header row | DJ | no | no | ★ | U1 S0 T0 P0 | `<thead>` with several `<tr>` |
| Footer rows | KM AD | no | `+grid_tables`<br>(a footer section; untested) | ★★ | U1 S1 T0 P0<br>bold totals row | `<tfoot>` |
| Captions | PD DJ AD MY | no | `+table_captions` (`Table: …`) | ★★★★★ | U2 S0 T2 P1<br>`Table: …` | `<caption>` |
| Column widths | PD AD | no | relative widths from dash lengths<br>(`+multiline_tables`, `+grid_tables`) | ★★★★ | U1 S1 T1 P1 | `<colgroup>`, `<col>` with css widths |
| Column and row spans | PD AD KM | raw HTML<br>AST: `HtmlBlock` | `+grid_tables` (`+---+` borders; tested 2026-10-14) | ★★★★★★★ | U2 S2 T2 P1<br>HTML table | `colspan`, `rowspan` |
| Block content in cells | PD AD MY MK | raw HTML<br>AST: `HtmlBlock` | `+grid_tables` (`+---+` borders; tested 2026-10-14) | ★★★★★ | U2 S1 T1 P1 | `<td>` holding block content |
| Line breaks in cells | GFM PD AD | raw HTML (`<br>`)<br>AST: `HtmlInline` (`<br>`) in a `TableCell` | `+grid_tables` with a trailing backslash (`\`; tested 2026-10-14) | ★★★★★★★ | U2 S2 T2 P1<br>`<br>` | `<br>`, or block content in the `<td>` |
| Per-cell alignment and style | AD | raw HTML<br>AST: `HtmlBlock` | no | ★★★★★★ | U2 S2 T1 P1<br>HTML table | adhoc(css) |
| Row headers | AD | raw HTML<br>AST: `HtmlBlock` | no | ★★★★ | U2 S1 T0 P1 | `<th scope="row">` |
| Nested tables | AD | raw HTML<br>AST: `HtmlBlock` | no | ★★★★★★★ | U2 S2 T2 P1<br>HTML table | `<table>` inside a `<td>` |
| Tables from data (CSV) | AD MY GL | no | no (filters) | ★★ | U1 S0 T1 P0 | adhoc(build step, js) |
| **11. Media and math** | | | | | | |
| Images | all | core (`![alt](src)`)<br>AST: `Image` (`url`, `title`; the alt text is its children) | core (`![alt](src)`) | ★★★★★★★★ | U2 S2 T2 P2 | `<img alt>` |
| Image size and attributes | OB PD AD | raw HTML (`<img width>`);<br>`-e link-attributes` parses `{width=50%}` into the tree, but HTML drops it (tested)<br>AST: `Image` with `attrs`, or `HtmlBlock` / `HtmlInline` | `+link_attributes` (`![x](img){width=50%}`) | ★★★★★ | U2 S1 T1 P1<br>`{width=}` or `<img width>` | `<img width height>` |
| Light and dark image variants | GFM | no<br>(GitHub's URL fragment passes through) | no | ★★★★★★ | U2 S2 T1 P1<br>`<picture>` | `<picture>` with `<source media="(prefers-color-scheme: dark)">` |
| Video and audio | OB AD | raw HTML (`<video>`, `<audio>`)<br>AST: `HtmlInline` or `HtmlBlock` | raw HTML (`<video>`, `<audio>`) | ★★★★★★★ | U2 S2 T2 P1<br>`<video>` | `<video>`, `<audio>` |
| Display math | GFM GL OB PD DJ MY AD | `-e math-dollars` (`$$…$$`),<br>`-e math-code` (```` ```math ````)<br>AST: `Math` (`display_math: true`); a ```` ```math ```` fence is a `CodeBlock` with `info: "math"` | `+tex_math_dollars` (`$$…$$`) | ★★★★★★★ | U2 S2 T1 P2 | `<math display="block">` |
| Numbered, labeled equations | MY PD | no | no<br>(pandoc-crossref filter; Quarto) | ★★★★★ | U2 S1 T1 P1 | `<math>`;<br>the number adhoc(css counters, table) |
| Bare LaTeX environments | PD | no | `+raw_tex` (`\begin{…}` … `\end{…}`) | ★★★★ | U2 S0 T1 P1 | `<math>` for math environments;<br>otherwise none |
| **12. Editorial markup** | | | | | | |
| Tracked changes (CriticMarkup) | KM, Obsidian plugins | no | no (filters) | ★★★★★ | U2 S1 T2 P0 | `<ins>`, `<del>` (with `datetime`, `cite`);<br>review comments adhoc |
| Visible annotations, tooltips | HTML | raw HTML<br>AST: `HtmlInline` | `+bracketed_spans` (`[x]{title="…"}`, tested) | ★★★★★ | U2 S1 T1 P1 | `title` attribute;<br>`popover` attribute for richer ones |
| **13. Extension mechanisms** | | | | | | |
| Attributes on any element | DJ PD MK AD | partial: `header-attributes`,<br>`fenced-code-attributes`,<br>`inline-code-attributes`,<br>`link-attributes`<br>(`{#id .c key=v}`; tested: parsed into the tree, dropped from HTML and XML)<br>AST: the `attrs` field (`id`, `classes`, `pairs`) on `Heading`, `CodeBlock`, `Code`, `Link`, `Image` | `+header_attributes`,<br>`+fenced_code_attributes`,<br>`+inline_code_attributes`,<br>`+link_attributes`,<br>`+bracketed_spans`,<br>`+fenced_divs` (`{#id .c key=v}` after the element);<br>`attributes`<br>(commonmark_x: any element) | ★★★★ | U2 S0 T1 P1<br>placement varies | global attributes (`id`, `class`, `data-*`, …) |
| Named directives and roles | MY | no | no | ★ | U1 S0 T0 P0 | custom elements (`<my-thing>`) |
| Named tags, macros, shortcodes | MK AD, Hugo, Quarto | no | no | ★ | U1 S0 T0 P0 | custom elements (`<my-thing>`) |
| Embedded host language | MX | `-e phoenix-heex`<br>(Phoenix HEEx only: `<.link>` tags and `{@x}` pass through, tested)<br>AST: `HeexBlock` (`node: Tag` or `Expression`), `HeexInline` | no | ★ | U1 S0 T0 P0 | custom elements with js |
| Raw passthrough by output format | PD DJ AD | no | `+raw_attribute` (`` `x`{=html} ``, ```` ```{=latex} ````) | ★★★★★★★ | U2 S2 T2 P1 | — (this is the raw HTML itself) |
| Fence info strings handed to renderers | all | `--full-info-string` keeps the info string;<br>rendering is the host's job<br>AST: `CodeBlock` (`info`) | the info string becomes code-block classes;<br>filters render | ★★★★★★★★ | U2 S2 T2 P2<br>mermaid | `<pre><code class="language-…">`;<br>rendering adhoc(js, e.g. Mermaid) |
| Post-parse filters | PD AD | the Rust API: `parse_document` returns a tree of nodes whose `NodeValue` is what this column names | Lua and JSON filters | — | not a syntax | — (not a syntax) |
| **14. From LaTeX templates** | | | | | | |
| Abstract | LaTeX | no | `abstract:` metadata (standard templates) | ★★★★★ | U2 S0 T2 P1 | adhoc(section);<br>ARIA `doc-abstract` |
| Title block with affiliations and keywords | LaTeX | no | `title`,<br>`author`,<br>`keywords` metadata<br>(affiliations depend on the template) | ★★★★★ | U2 S1 T1 P1 | `<header>` with `<h1>`;<br>`<meta name="keywords">`;<br>affiliations adhoc |
| Theorem-like environments and proofs | LaTeX | no | no<br>(raw TeX; Quarto `::: {#thm-…}`) | ★★★★★ | U2 S0 T2 P1 | adhoc(div or section with class);<br>`<dfn>` for a defined term |
| Epigraph | LaTeX | no | no (raw TeX) | ★★★★★ | U2 S0 T2 P1 | `<blockquote>`;<br>ARIA `doc-epigraph` |
| Pull quote | LaTeX | no | no | ★★ | U1 S0 T1 P0 | `<aside>` (the spec's own example);<br>ARIA `doc-pullquote` |
| Framed or boxed text | LaTeX | no | no<br>(raw TeX, or a div with a class) | ★★★★ | U2 S0 T1 P1 | adhoc(css border) |
| Algorithms in pseudocode | LaTeX | no | no (raw TeX) | ★★★★★ | U2 S0 T2 P1 | `<figure>` with `<pre>`;<br>the layout adhoc |
| Subfigures | LaTeX | no | no<br>(raw TeX; Quarto layouts) | ★★★★ | U2 S0 T1 P1 | `<figure>` nested in a `<figure>` |
| References to page numbers | LaTeX | no | no (raw TeX) | ★★★★★ | U2 S0 T2 P1 | adhoc(css `target-counter()`, print only) |
| List of figures and tables | LaTeX | no | `lof: true`,<br>`lot: true` metadata (LaTeX output) | ★★★★★★★ | U2 S2 T2 P1 | `<nav>` with `<ol>`;<br>the list itself adhoc(build step) |
| Appendix | LaTeX | no | no (raw TeX) | ★★★★★ | U2 S0 T2 P1 | `<section>`;<br>ARIA `doc-appendix` |
| Acronyms spelled out on first use | LaTeX | no | no (raw TeX, filters) | ★★★★★ | U2 S1 T1 P1 | `<abbr title>`;<br>the first-use rule adhoc |
| Units and quantities | LaTeX | no | no (raw TeX) | ★★★★★ | U2 S0 T2 P1<br>Unicode in prose | the characters (thin space, `×`, `°`);<br>`<data value>` for a machine value |
| Chemical equations | LaTeX | no | no<br>(`\ce{}` inside math renders where MathJax or KaTeX loads mhchem) | ★★★★★★★ | U2 S2 T2 P1<br>`\ce{}` | `<sub>`, `<sup>`, or `<math>` |
| Margin to-do notes | LaTeX | no | no | ★★★★★ | U2 S0 T2 P1 | `<aside>` with adhoc(css) |
| Line numbers for review | LaTeX | no | no<br>(raw TeX in the header) | ★★★★★★★ | U2 S2 T2 P1 | adhoc(css counters) |
| Drop caps | LaTeX | no | no | ★★★★★ | U2 S0 T2 P1 | adhoc(css `::first-letter`, `initial-letter`) |
| Hyphenation hints | LaTeX | no<br>(a soft hyphen character, U+00AD, works anywhere)<br>AST: `Text` (the U+00AD is kept) | no<br>(soft hyphen character, or raw TeX `\-`) | ★★★★★ | U2 S0 T2 P1 | `&shy;` (U+00AD), `<wbr>`;<br>css `hyphens` |
| Automatically numbered paragraphs | LaTeX | no | no | ★★★★★ | U2 S0 T2 P1 | adhoc(css counters) |
| **14. From Obsidian plugins** | | | | | | |
| Colored text | plugins | raw HTML<br>AST: `HtmlInline` | `+bracketed_spans` (`[x]{style="color:red"}`, tested; HTML output) | ★★★★★★ | U2 S2 T1 P1<br>`<span style>` | adhoc(span with css) |
| Subtext line | plugins, Discord | `-e subtext`<br>(`-# text` becomes `<sub>`, tested)<br>AST: `Subtext` | no | ★★★ | U1 S1 T0 P1 | `<small>` |
| Inline badges | plugins | no | no | ★★★★ | U1 S1 T1 P1 | adhoc(span with css) |
| Inline data fields `key:: value` | Dataview | no | no | ★★★ | U2 S0 T1 P0 | `<data value>`;<br>the key adhoc(span) |
| Key-value lists | plugins | no | no<br>(definition lists come closest) | ★★ | U1 S1 T0 P0 | `<dl>` |
| Side-brace grouping | plugins | no | no<br>(math with `\left.` and `\right\}`) | ★★★★★ | U2 S0 T2 P1 | `<math>` with a stretchy `<mo>}</mo>`;<br>or adhoc(css) |
| Table formulas | plugins | no | no | ★★★ | U1 S1 T1 P0 | `<output>` for the result;<br>the computing adhoc(js) |
| Callout on one list item | plugins | no | no | ★★★★ | U1 S2 T1 P0<br>`⚠️` prefix | `<li>` with adhoc(class) |
| Note templates | Templater | no | no<br>(Pandoc's templates are output templates, a different thing) | ★★★★★ | U2 S2 T1 P0 | adhoc(authoring tool)<br>(`<template>` is a different thing) |
| Inline icons | plugins | no | no | ★★★★ | U1 S1 T1 P1 | `<img alt>` or inline `<svg>`;<br>adhoc(icon font) |

**comrak flags that match no feature above:** `greentext` (4chan-style `>` lines), `cjk-friendly-emphasis`, `tagfilter` (GFM's disallowed raw HTML), `--github-pre-lang`, `--escaped-char-spans`, `--sourcepos`.

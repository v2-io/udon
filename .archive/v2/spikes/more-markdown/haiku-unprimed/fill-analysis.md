## What the whole-table fills show

*Coordinator's reading of the six fills, 2026-10-15. One sample per model per table; counts are out of six.*

**1. Asked for syntax across the whole list, all six models converge on Pandoc-centered extended Markdown.** Where GFM has nothing, the shared answer is overwhelmingly Pandoc's attribute and extension syntax, plus Obsidian and GitHub conventions, CriticMarkup and the Tasks plugin's emoji:

| Feature | Shared answer | Count |
|---|---|---|
| Small caps | `[NASA]{.smallcaps}` | 6 |
| Sub/superscript | `H~2~O`, `2^10^` | 6 |
| Span with a class | `[limited offer]{.promo}` | 6 |
| Raw HTML for one format | `` `<b>bold</b>`{=html} `` | 6 |
| Inline code with a language | `` `let x = 1;`{.rust} `` | 6 |
| Abbreviation | `*[HTML]: HyperText Markup Language` | 6 |
| Citation | `[@doe2020, p. 33]` | 6 |
| Footnote / inline footnote | `[^1]` / `^[…]` | 6 / 6 |
| Example list | `(@)` and `(@label)` | 6 |
| Definition list | `Term` / `: definition` | 6 |
| Field list | `:param x:` … `:author:` | 6 |
| Image size | `{width=300px}` | 6 |
| Numbered equation | `$$…$$ {#eq:…}` | 6 |
| Tracked changes | CriticMarkup `{--…--}{++…++}{>>…<<}` | 6 |
| Extra task states | `[/]`, `[-]`, `[!]` (the Obsidian community convention) | 6 |
| Wikilink | `[[Project Plan\|the plan]]` | 6 |
| Container and columns | `:::` fenced divs | 6 |
| Executable cell | ```` ```{python} ```` | 6 |
| Dashes and quotes | `--`, `---`, straight quotes left for a processor | 6 |
| Underline | `[carefully]{.underline}` | 5 |
| Highlight | `==asdf==` | 5 |
| Auto-numbered list | `#.` | 5 |
| Admonition | `> [!NOTE]`, `> [!todo]`, `> [!tip]- Title` | 5 |
| Emoji | `:tada:` | 5 |
| Task metadata | `📅 2026-11-01 🔁 every month` | 5 |

This fits the earlier finding that Pandoc acts as an attractor. Asked for a syntax for something GFM lacks, models reach for Pandoc's.

**2. Where they diverge is where no lineage owns the feature.**
- **Page break:** `\newpage`, `\clearpage`, a CSS `<div>`, or Quarto's `{{< pagebreak >}}`.
- **Table of contents:** `toc: true` metadata, `[TOC]` or `[[TOC]]`.
- **Includes:** Liquid `{% include %}`, mdBook `{{#include}}`, Hugo/Quarto `{{< include >}}` or AsciiDoc `include::`.
- **Spoiler:** `{.spoiler}`, Discord's `||…||` or Reddit's `>!…!<`.
- **Keyboard keys:** spans, `<kbd>`, AsciiDoc `kbd:[]` or pymdown's `++ctrl+c++`.
- **Hard line break:** `<br>` versus a trailing backslash.
- **Tables beyond pipe tables:** grid tables, HTML or AsciiDoc tables.
- **Anchor on a block:** a `:::` div, a trailing `{#id}` or kramdown's `{: #id}`.

**3. Each model has its own tendencies.**
- **Haiku's second run** used MkDocs `!!!`/`???` admonitions throughout, where its first run used GitHub and Obsidian alerts. Haiku's two runs differ more from each other than Sonnet's two do.
- **Opus** went to AsciiDoc for tables, code callouts, keyboard keys and includes.
- **Sonnet** used HTML for the harder tables.
- **Fable** used Pandoc `:::` divs for admonitions, and Quarto-style ids (`#fig-chart`, `@eq-quad`).

**4. Section 14 asked on its own: the whole table went LaTeX.** Handed only the LaTeX-template and Obsidian-plugin features, all six answered nearly every row in LaTeX:
- the expected ones: `\begin{abstract}`, `amsthm`, `\epigraph`, `algorithmic`, `subcaption`, `\pageref`, `glossaries`, `siunitx` `\SI{…}`, `mhchem` `\ce{…}`, `\todo{}`, `lineno`, `lettrine`, `\-` hyphenation hints, `enumitem`;
- and features with no LaTeX origin: colored text as `\textcolor{red}{…}`, inline icons as `\faHeart`.

Only Dataview's inline fields (`[rating:: 5]`, five of six) and note templates (Obsidian's `{{title}}` or Templater's `<% %>`) kept their own syntax. The neighboring rows set the register for each row.

**5. How each condition chose (single prompt → bundle → whole-table fill):**

| Feature | Single prompt | Bundle | Whole-table fill |
|---|---|---|---|
| Highlight | `**bold**` | `<mark>` (when bold was used elsewhere) | `==…==` |
| Footnote | Unicode `¹` and a line below | `[^1]` | `[^1]` |
| Sub/superscript, small caps | Unicode (`H₂O`, `2¹⁰`, `ɴᴀꜱᴀ`) | mixed | Pandoc (`H~2~O`, `{.smallcaps}`) |
| Emoji | the characters | — | `:tada:` |
| Quotes and dashes | typed as Unicode characters | — | typed as ASCII for a processor |
| Line breaks in an address | plain newlines | two trailing spaces | `<br>` or `\` |

**6. Math: Unicode in prose, delimiters only when typesetting is signalled.** Joseph's observation holds in the single prompts. Speed, temperature, chemistry and exponents came back as `3.5 × 10⁸ m/s`, `21 °C`, `H₂O`, `2¹⁰` and `CH₄ + 2 O₂ → CO₂ + 2 H₂O`, with no delimiters. Only the prompt that asked for "a properly typeset formula" got `$E = mc^2$`. Delimited or LaTeX math (`$…$`, `\SI{}`, `\ce{}`) appeared when the request was framed as source or typesetting.

**What this means:** the framing sets the register.
- **"Write some text"** gets plain prose: Unicode characters, GFM, and bold standing in for structure.
- **"Write the source syntax for these features"** gets Pandoc-centered extended Markdown.
- **A cluster of features from one tradition** gets that tradition's whole toolchain (LaTeX, MyST, AsciiDoc, reStructuredText).

A declared udon-md profile would have to say which register it expects. The parser would also have to accept that agents writing ordinary prose will type Unicode math and symbols, not markup.

## What changed when features were bundled

*Coordinator's reading of the 12 bundle answers, 2026-10-15. Single samples. The single-feature answers being compared are in `haiku-unprimed.md` and `sonnet-unprimed.md`.*

**1. When a request needs more than GFM can do, the model picks one whole toolchain for the document.** Single prompts got GFM plus scattered fallbacks. Bundles that mixed in out-of-GFM features got a single named dialect chosen to cover all of them:

| Bundle | Haiku (no toolchain note) | Sonnet ("use whichever comes most naturally") |
|---|---|---|
| B1: inline code, admonition with an icon, collapsible, variables, flowchart, heading id | **AsciiDoc** (`:product-name:` attributes, `[#install]`, `[TIP]`, `[%collapsible]`) | GFM plus MkDocs, offered as options |
| B2: option list, keyboard keys, literal block, nested admonitions, to-do | Pandoc-style `:::` divs | **reStructuredText/Sphinx** (`:kbd:`, `:menuselection:`, nested directives) |
| B3: executable cell, table caption, attributes, to-do, index term, columns, footer, table of contents | **MyST** (`{code-cell}`, `{table}`, `{grid}`, `{index}`, `{todo}`) | **Quarto** |
| B4: auto-numbering, small caps, table of contents, session, raw HTML, divider | GFM plus HTML and Unicode | **Pandoc** (`#.`, `[NASA]{.smallcaps}`, `{=html}`) |
| B5: headerless table, span with class, raw HTML, list item with blocks, to-do, sub/superscript, comment | GFM plus HTML | **Pandoc** |
| B6-targeted: emphasis and bold, highlight, strikethrough, underline, footnote, note, address, glossary | GFM plus HTML | GFM plus HTML |

So "what models write unprompted" is not one dialect. It's GFM until the feature mix exceeds GFM, and then a whole toolchain chosen per document. That choice varied across AsciiDoc, MyST, reStructuredText, Quarto and Pandoc, even for the same feature (the to-do admonition came out six different ways in six answers).

**2. Highlight next to emphasis: `<mark>`, not bold.** Asked alone, both models highlighted "asdf" as `**asdf**`. In B6, where emphasis and bold were requested separately, both switched to `<mark>asdf</mark>`. Highlight is a distinct construct once bold is spoken for.

**3. Bundling put the models into markup mode for footnotes and line breaks.** Alone, both wrote footnotes as a Unicode `¹` and wrote the mailing address with plain newlines, which CommonMark joins into one line. In B6, both used a real `[^1]` footnote, and both ended each address line with two trailing spaces, a real CommonMark hard break.

**4. More shifts in B6:**
- Sonnet's glossary became a Pandoc/PHP Markdown Extra definition list (`Term` / `: definition`). Alone, it had used bold labels. Haiku kept bold labels both times.
- Sonnet's note admonition became `> [!NOTE]`. Alone, it had used the older `> **Note**` style.

**5. What stayed stable across contexts:**
- **GFM-covered features:** pipe tables with alignment, `---` dividers, fenced code and `>>>` sessions, HTML comments, mermaid fences.
- **Haiku's habits:** Unicode for sub/superscript and small caps, `<b>` for HTML-only bold, repeated `1.` for auto-numbering, `[TOC]`, bold-row table footers.
- **Sonnet's habits:** `{#id}` heading identifiers, `<details>` for collapsible sections.
- **One structure fix:** Haiku's list item with two paragraphs and a code block, broken when asked alone, came out correctly indented in B5.

**6. The toolchain note made Sonnet commit.** It mostly named one toolchain and used it throughout ("I used reStructuredText…", "I used Quarto…", "Pandoc-flavored Markdown covers all seven items"). B1 still offered options. When GFM wasn't enough, Pandoc was its usual choice.

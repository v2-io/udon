# Lightweight Markup Language Feature Matrix

A comprehensive comparison of 26 lightweight markup languages across formatting, structure, interconnections, embedded languages, and tooling.

---

## Overview & Metadata

| Format               | LLM Fluency | Year      | Creator/Origin          | Notes                                             |
| -------------------- | ----------- | --------- | ----------------------- | ------------------------------------------------- |
| **Markdown**         | ★★★★★       | 2004      | John Gruber             | Original spec ambiguous; spawned many dialects    |
| **GFM**              | ★★★★★       | 2009/2017 | GitHub                  | CommonMark superset; formal spec in 2017          |
| **CommonMark**       | ★★★★★       | 2014      | John MacFarlane et al.  | Rigorous spec with 600+ test cases                |
| **MediaWiki**        | ★★★★☆       | 2002      | Magnus Manske           | Wikipedia; complex template system                |
| **BBCode**           | ★★★★☆       | 1998      | Ultimate Bulletin Board | Forum standard; HTML-like tags                    |
| **reStructuredText** | ★★★★☆       | 2001      | David Goodger           | Python ecosystem standard (Sphinx)                |
| **Obsidian**         | ★★★★☆       | 2020      | Shida Li & Erica Xu     | PKM app; CommonMark + wiki links + callouts       |
| **AsciiDoc**         | ★★★★☆       | 2002      | Stuart Rackham          | DocBook heritage; Asciidoctor (2013) now dominant |
| **Org-Mode**         | ★★★★☆       | 2003      | Carsten Dominik         | Emacs-native; extremely powerful                  |
| **Jira**             | ★★★☆☆       | ~2002     | Atlassian               | Issue tracker; moving to rich editor              |
| **DokuWiki**         | ★★★☆☆       | 2004      | Andreas Gohr            | File-based wiki; PHP                              |
| **Textile**          | ★★★☆☆       | 2002      | Dean Allen              | Influenced Markdown; declining use                |
| **djot**             | ★★★☆☆       | 2022      | John MacFarlane         | "Markdown done right"; very new                   |
| **GNU Texinfo**      | ★★★☆☆       | ~1985     | Richard Stallman        | GNU documentation standard                        |
| **pod**              | ★★★☆☆       | 1994      | Larry Wall              | Perl documentation; simple                        |
| **Haddock**          | ★★★☆☆       | 2002      | Simon Marlow            | Haskell documentation                             |
| **Vimdoc**           | ★★★☆☆       | ~1991     | Bram Moolenaar          | Vim help files; unique format                     |
| **Vimwiki**          | ★★☆☆☆       | ~2008     | Maxim Kim               | Personal wiki for Vim                             |
| **Markua**           | ★★☆☆☆       | 2014      | Peter Armstrong         | Leanpub-specific; book-focused                    |
| **txt2tags**         | ★★☆☆☆       | 2001      | Aurelio Jargas          | Multi-target converter                            |
| **XWiki**            | ★★☆☆☆       | 2004      | Ludovic Dubost          | Java-based; multiple syntaxes                     |
| **ZimWiki**          | ★★☆☆☆       | ~2005     | Jaap Karssenberg        | Desktop wiki; DokuWiki-influenced                 |
| **TikiWiki**         | ★★☆☆☆       | 2002      | Luis Argerich           | Full CMS; less distinct markup                    |
| **TWiki**            | ★★☆☆☆       | 1998      | Peter Thoeny            | Enterprise wiki; Foswiki fork                     |
| **Emacs Muse**       | ★★☆☆☆       | ~2004     | John Wiegley            | Defunct since 2010                                |
| **Creole**           | ★★☆☆☆       | 2007      | WikiSym community       | Attempted standard; limited adoption              |

**LLM Fluency Key:** How readily I can generate correct syntax from training. ★★★★★ = extremely confident, extensive training data. ★☆☆☆☆ = uncertain, sparse examples. Within each tier, formats are ordered by relative confidence.

---

## Inline / Sameline Formatting

| Format         | LLM Fluency | Bold           | Italic        | Bold+Italic   | Strikethrough     | Underline      | Sub       | Super     | Code              | Highlight | Kbd       |
| -------------- | ----------- | -------------- | ------------- | ------------- | ----------------- | -------------- | --------- | --------- | ----------------- | --------- | --------- |
| **Markdown**   | ★★★★★       | `**` `__`      | `*` `_`       | `***`         | ✗                 | ✗              | ✗         | ✗         | `` ` ``           | ✗         | ✗         |
| **GFM**        | ★★★★★       | `**` `__`      | `*` `_`       | `***`         | `~~`              | ✗              | ✗         | ✗         | `` ` ``           | ✗         | ✗         |
| **CommonMark** | ★★★★★       | `**` `__`      | `*` `_`       | `***`         | ✗                 | ✗              | ✗         | ✗         | `` ` ``           | ✗         | ✗         |
| **MediaWiki**  | ★★★★☆       | `'''`          | `''`          | `'''''`       | `<s>`             | `<u>`          | `<sub>`   | `<sup>`   | `<code>`          | ✗         | `<kbd>`   |
| **BBCode**     | ★★★★☆       | `[b]`          | `[i]`         | `[b][i]`      | `[s]`             | `[u]`          | `[sub]`   | `[sup]`   | `[code]`          | ✗         | ✗         |
| **rST**        | ★★★★☆       | `**`           | `*`           | ✗             | ✗                 | ✗              | role      | role      | ``` `` ```        | ✗         | ✗         |
| **Obsidian**   | ★★★★☆       | `**`           | `*` `_`       | `***`         | `~~`              | ✗              | ✗         | ✗         | `` ` ``           | `==`      | ✗         |
| **AsciiDoc**   | ★★★★☆       | `**` `*`       | `__` `_`      | `**__`        | `[line-through]#` | `[underline]#` | `~`       | `^`       | `` ` `` `+`       | `#`       | `[kbd]#`  |
| **Org-Mode**   | ★★★★☆       | `*bold*`       | `/italic/`    | `*/both/*`    | `+strike+`        | `_under_`      | `_{sub}`  | `^{sup}`  | `~code~` `=verb=` | ✗         | ✗         |
| **Jira**       | ★★★☆☆       | `*bold*`       | `_italic_`    | `*_both_*`    | `-strike-`        | `+under+`      | `~sub~`   | `^sup^`   | `{{code}}`        | ✗         | ✗         |
| **DokuWiki**   | ★★★☆☆       | `**`           | `//`          | `**//`        | `<del>`           | `__`           | `<sub>`   | `<sup>`   | `''`              | ✗         | ✗         |
| **Textile**    | ★★★☆☆       | `*strong*`     | `_emphasis_`  | `_*both*_`    | `-deleted-`       | `+inserted+`   | `~sub~`   | `^sup^`   | `@code@`          | ✗         | ✗         |
| **djot**       | ★★★☆☆       | `*`            | `_`           | `*_`          | `{~~}`            | ✗              | `{~}`     | `{^}`     | `` ` ``           | `{=}`     | ✗         |
| **Texinfo**    | ★★★☆☆       | `@strong{}`    | `@emph{}`     | nested        | ✗                 | ✗              | ✗         | ✗         | `@code{}`         | ✗         | `@key{}`  |
| **pod**        | ★★★☆☆       | `B<>`          | `I<>`         | `B<I<>>`      | ✗                 | ✗              | ✗         | ✗         | `C<>`             | ✗         | ✗         |
| **Haddock**    | ★★★☆☆       | `__`           | `/`           | ✗             | ✗                 | ✗              | ✗         | ✗         | `@` `` ` ``       | ✗         | ✗         |
| **Vimdoc**     | ★★★☆☆       | ✗              | ✗             | ✗             | ✗                 | ✗              | ✗         | ✗         | ✗                 | `*tag*`   | ✗         |
| **Vimwiki**    | ★★☆☆☆       | `*bold*`       | `_italic_`    | ✗             | `~~`              | ✗              | `,,sub,,` | `^sup^`   | `` ` ``           | ✗         | ✗         |
| **Markua**     | ★★☆☆☆       | `**`           | `*`           | `***`         | `~~`              | ✗              | ✗         | ✗         | `` ` ``           | ✗         | ✗         |
| **txt2tags**   | ★★☆☆☆       | `**`           | `//`          | `**//`        | `--`              | `__`           | `~~`      | `^^`      | ``` `` ```        | ✗         | ✗         |
| **XWiki**      | ★★☆☆☆       | `**`           | `//`          | `**//`        | `--`              | `__`           | `,,`      | `^^`      | `##`              | ✗         | ✗         |
| **ZimWiki**    | ★★☆☆☆       | `**`           | `//`          | `**//`        | `~~`              | `__`           | `_{sub}`  | `^{sup}`  | `''`              | `__`      | ✗         |
| **TikiWiki**   | ★★☆☆☆       | `__`           | `''`          | `__''`        | `--`              | `===`          | ✗         | ✗         | `-+code+-`        | ✗         | ✗         |
| **TWiki**      | ★★☆☆☆       | `*bold*`       | `_italic_`    | `__boldital__`| ✗                 | ✗              | ✗         | ✗         | `=code=`          | ✗         | ✗         |
| **Muse**       | ★★☆☆☆       | `*bold*`       | `*italic*`    | ✗             | ✗                 | `_under_`      | ✗         | ✗         | `=code=`          | ✗         | ✗         |
| **Creole**     | ★★☆☆☆       | `**`           | `//`          | `**//`        | ✗                 | `__`           | ✗         | ✗         | `{{{`             | ✗         | ✗         |

---

## Structure / Block Elements

| Format         | LLM Fluency | H levels       | Lists (UL)    | Lists (OL)    | Def Lists   | Nested | Blockquote      | HR          | Tables        | Admonitions        |     |     |
| -------------- | ----------- | -------------- | ------------- | ------------- | ----------- | ------ | --------------- | ----------- | ------------- | ------------------ | --- | --- |
| **Markdown**   | ★★★★★       | 6 `#`          | `- * +`       | `1.`          | ✗           | ✓      | `>`             | `---`       | ✗             | ✗                  |     |     |
| **GFM**        | ★★★★★       | 6 `#`          | `- * +`       | `1.`          | ✗           | ✓      | `>`             | `---`       | `\|` pipes    | ✗                  |     |     |
| **CommonMark** | ★★★★★       | 6 `#`          | `- * +`       | `1.`          | ✗           | ✓      | `>`             | `---`       | ✗             | ✗                  |     |     |
| **MediaWiki**  | ★★★★☆       | `= ==`         | `* `          | `# `          | `; :`       | ✓      | `<blockquote>`  | `----`      | `{\|}`        | `{{note}}` tmpl    |     |     |
| **BBCode**     | ★★★★☆       | ✗              | `[list]`      | `[list=1]`    | ✗           | ✓      | `[quote]`       | `[hr]`      | `[table]`     | ✗                  |     |     |
| **rST**        | ★★★★☆       | underlines     | `- * +`       | `#. 1.`       | term/def    | ✓      | indent          | `----`      | grid/simple   | `.. note::` etc    |     |     |
| **Obsidian**   | ★★★★☆       | 6 `#`          | `- * +`       | `1.`          | ✗           | ✓      | `>`             | `---`       | `\|` pipes    | `> [!type]`        |     |     |
| **AsciiDoc**   | ★★★★☆       | `= ==`         | `* -`         | `. 1.`        | `term::`    | ✓      | `____`          | `'''` `---` | `\|===`       | `NOTE:` `TIP:` etc |     |     |
| **Org-Mode**   | ★★★★☆       | `* **`         | `- +`         | `1. 1)`       | `- term ::` | ✓      | `#+BEGIN_QUOTE` | `-----`     | `\|` pipes    | `#+BEGIN_` blocks  |     |     |
| **Jira**       | ★★★☆☆       | `h1.` etc      | `* -`         | `# `          | ✗           | ✓      | `{quote}`       | `----`      | `\|\|` header | `{info}` etc       |     |     |
| **DokuWiki**   | ★★★☆☆       | `= ====`       | `* `          | `- `          | ✗           | ✓      | `>`             | ✗           | `^` `\|`      | plugin             |     |     |
| **Textile**    | ★★★☆☆       | `h1.` `h2.`    | `* `          | `# `          | `;` `:`     | ✓      | `bq.`           | ✗           | `\|` pipes    | ✗                  |     |     |
| **djot**       | ★★★☆☆       | `#`            | `- * +`       | `1.`          | `: `        | ✓      | `>`             | `---`       | `\|` pipes    | `::: note`         |     |     |
| **Texinfo**    | ★★★☆☆       | `@chapter` etc | `@itemize`    | `@enumerate`  | `@table`    | ✓      | `@quotation`    | ✗           | `@multitable` | `@quotation Note`  |     |     |
| **pod**        | ★★★☆☆       | `=head1-4`     | `=over =item` | `=over =item` | ✗           | ✓      | ✗               | ✗           | ✗             | ✗                  |     |     |
| **Haddock**    | ★★★☆☆       | limited        | `* `          | `1. (1)`      | `[term]`    | ✓      | `>`             | ✗           | ✗             | `@since` etc       |     |     |
| **Vimdoc**     | ★★★☆☆       | section marks  | ✗             | ✗             | ✗           | ✗      | ✗               | `---`       | column align  | ✗                  |     |     |
| **Vimwiki**    | ★★☆☆☆       | `= ==`         | `- *`         | `# 1)`        | `term::`    | ✓      | ✗               | `----`      | `\|` pipes    | ✗                  |     |     |
| **Markua**     | ★★☆☆☆       | `#`            | `* -`         | `1.`          | ✗           | ✓      | `>`             | `---`       | ✗             | `{blurb}` etc      |     |     |
| **txt2tags**   | ★★☆☆☆       | `= ==`         | `- `          | `+ `          | `: `        | ✓      | `\t`            | `---`       | `\|` pipes    | ✗                  |     |     |
| **XWiki**      | ★★☆☆☆       | `= ==`         | `* `          | `1. `         | `;:`        | ✓      | `>`             | `----`      | `\|` pipes    | `{{info}}`         |     |     |
| **ZimWiki**    | ★★☆☆☆       | `====`         | `* `          | `1.`          | ✗           | ✓      | `'''` ?         | `----`      | ✗             | ✗                  |     |     |
| **TikiWiki**   | ★★☆☆☆       | `!` `!!`       | `* `          | `# `          | `;:`        | ✓      | `^`             | `---`       | `\|\|`        | ✗                  |     |     |
| **TWiki**      | ★★☆☆☆       | `---+`         | `   *`        | `   1`        | `$ :`       | ✓      | ✗               | `---`       | `\|` pipes    | ✗                  |     |     |
| **Muse**       | ★★☆☆☆       | `* **`         | `- `          | `1.`          | ✗           | ✓      | `<quote>`       | `----`      | `             |                    | `   | ✗   |
| **Creole**     | ★★☆☆☆       | `= ==`         | `* `          | `# `          | ✗           | ✓      | ✗               | `----`      | `\|` pipes    | ✗                  |     |     |

### Includes & Templating

| Format         | LLM Fluency | File Include   | Variables/Macros | Conditionals     | Templating     |
| -------------- | ----------- | -------------- | ---------------- | ---------------- | -------------- |
| **Markdown**   | ★★★★★       | ✗              | ✗                | ✗                | ✗              |
| **GFM**        | ★★★★★       | ✗              | ✗                | ✗                | ✗              |
| **CommonMark** | ★★★★★       | ✗              | ✗                | ✗                | ✗              |
| **MediaWiki**  | ★★★★☆       | `{{:page}}`    | `{{{1}}}`        | `{{#if:}}`       | `{{template}}` |
| **BBCode**     | ★★★★☆       | ✗              | ✗                | ✗                | ✗              |
| **rST**        | ★★★★☆       | `.. include::` | `\|sub\|`        | `.. only::`      | Jinja (Sphinx) |
| **Obsidian**   | ★★★★☆       | `![[note]]`    | ○ Templater      | ○ Templater      | ○ Templater    |
| **AsciiDoc**   | ★★★★☆       | `include::[]`  | `{attr}`         | `ifdef::[]`      | ✓              |
| **Org-Mode**   | ★★★★☆       | `#+INCLUDE:`   | macros           | `#+IF` (limited) | Babel          |
| **Jira**       | ★★★☆☆       | ✗              | ✗                | ✗                | ✗              |
| **DokuWiki**   | ★★★☆☆       | `{{page>}}`    | plugin           | plugin           | plugin         |
| **Textile**    | ★★★☆☆       | ✗              | ✗                | ✗                | ✗              |
| **djot**       | ★★★☆☆       | ✗              | `{.class #id}`   | ✗                | ✗              |
| **Texinfo**    | ★★★☆☆       | `@include`     | `@set` `@value`  | `@ifset`         | ✓              |
| **pod**        | ★★★☆☆       | ✗              | ✗                | ✗                | ✗              |
| **Haddock**    | ★★★☆☆       | ✗              | ✗                | ✗                | ✗              |
| **Vimdoc**     | ★★★☆☆       | ✗              | ✗                | ✗                | ✗              |
| **Vimwiki**    | ★★☆☆☆       | ✗              | ✗                | ✗                | ✗              |
| **Markua**     | ★★☆☆☆       | `{include}`    | `%var%`          | ✗                | ✗              |
| **txt2tags**   | ★★☆☆☆       | `%!include`    | `%%date` etc     | `%!preproc`      | ✗              |
| **XWiki**      | ★★☆☆☆       | `{{include/}}` | `$var`           | Velocity         | Velocity       |
| **ZimWiki**    | ★★☆☆☆       | ✗              | ✗                | ✗                | ✗              |
| **TikiWiki**   | ★★☆☆☆       | `{include}`    | `{$var}`         | `{if}`           | Smarty         |
| **TWiki**      | ★★☆☆☆       | `%INCLUDE{}%`  | `%VAR%`          | `%IF{}%`         | ✓              |
| **Muse**       | ★★☆☆☆       | `<include>`    | ✗                | ✗                | ✗              |
| **Creole**     | ★★☆☆☆       | ✗              | ✗                | ✗                | ✗              |

---

## Interconnections

| Format         | LLM Fluency | External Link       | Internal/Wiki Link     | Ref Links     | Footnotes     | Anchors       | Images                  | ToC               |
| -------------- | ----------- | ------------------- | ---------------------- | ------------- | ------------- | ------------- | ----------------------- | ----------------- |
| **Markdown**   | ★★★★★       | `[text](url)`       | ✗                      | `[text][ref]` | ✗             | ✗             | `![](img)`              | ✗                 |
| **GFM**        | ★★★★★       | `[text](url)`       | ✗                      | `[text][ref]` | ✗             | ✗             | `![](img)`              | ✗                 |
| **CommonMark** | ★★★★★       | `[text](url)`       | ✗                      | `[text][ref]` | ✗             | ✗             | `![](img)`              | ✗                 |
| **MediaWiki**  | ★★★★☆       | `[url text]`        | `[[Page]]`             | ✗             | `<ref>`       | `{{anchor}}`  | `[[File:]]`             | `__TOC__`         |
| **BBCode**     | ★★★★☆       | `[url=]text[/url]`  | ✗                      | ✗             | ✗             | ✗             | `[img]`                 | ✗                 |
| **rST**        | ★★★★☆       | `` `text <url>`_ `` | `:ref:` `:doc:`        | `.. _ref:`    | `[#]_`        | `.. _anchor:` | `.. image::`            | `.. contents::`   |
| **Obsidian**   | ★★★★☆       | `[text](url)`       | `[[page]]` `[[p\|alias]]` | `[text][ref]` | `[^1]`        | `^block-id`   | `![[img]]` `![](img)`   | Outline / plugin  |
| **AsciiDoc**   | ★★★★☆       | `link:url[text]`    | `<<ref>>`              | ✗             | `footnote:[]` | `[[anchor]]`  | `image::[]`             | `:toc:`           |
| **Org-Mode**   | ★★★★☆       | `[[url][text]]`     | `[[file:]]`            | ✗             | `[fn:1]`      | `<<anchor>>`  | `[[img]]`               | `#+TOC:`          |
| **Jira**       | ★★★☆☆       | `[text\|url]`       | `[page]`               | ✗             | ✗             | `{anchor:x}`  | `!img!`                 | `{toc}`           |
| **DokuWiki**   | ★★★☆☆       | `[[url\|text]]`     | `[[page]]`             | ✗             | `((note))`    | `{{anchor}}`  | `{{img}}`               | `~~NOTOC~~`       |
| **Textile**    | ★★★☆☆       | `"text":url`        | ✗                      | ✗             | `[1]`         | ✗             | `!img!`                 | ✗                 |
| **djot**       | ★★★☆☆       | `[text](url)`       | ✗                      | `[text][ref]` | `[^1]`        | `{#id}`       | `![](img)`              | ✗                 |
| **Texinfo**    | ★★★☆☆       | `@url{}`            | `@xref{}`              | ✗             | `@footnote{}` | `@anchor{}`   | ✗                       | `@contents`       |
| **pod**        | ★★★☆☆       | `L<url>`            | `L<doc>`               | ✗             | ✗             | ✗             | ✗                       | ✗                 |
| **Haddock**    | ★★★☆☆       | `<url>`             | `"Module"`             | ✗             | ✗             | `#anchor`     | `<<img>>`               | ✗                 |
| **Vimdoc**     | ★★★☆☆       | ✗                   | `\|tag\|`              | ✗             | ✗             | `*tag*`       | ✗                       | ✗                 |
| **Vimwiki**    | ★★☆☆☆       | `[text](url)`       | `[[page]]`             | ✗             | ✗             | ✗             | `{{img}}`               | `:VimwikiTOC`     |
| **Markua**     | ★★☆☆☆       | `[text](url)`       | ✗                      | ✗             | `[^1]`        | ✗             | `![](img)`              | auto              |
| **txt2tags**   | ★★☆☆☆       | `[text url]`        | ✗                      | ✗             | ✗             | ✗             | `[img]`                 | `%%toc`           |
| **XWiki**      | ★★☆☆☆       | `[[text>>url]]`     | `[[page]]`             | ✗             | ✗             | `{{id/}}`     | `[[image:]]`            | `{{toc/}}`        |
| **ZimWiki**    | ★★☆☆☆       | `[[url\|text]]`     | `[[page]]`             | ✗             | ✗             | ✗             | `{{img}}`               | plugin            |
| **TikiWiki**   | ★★☆☆☆       | `[url\|text]`       | `((page))`             | ✗             | `[note]`      | ✗             | `{img}`                 | `{toc}`           |
| **TWiki**      | ★★☆☆☆       | `[[url][text]]`     | `TopicName`            | ✗             | ✗             | `#anchor`     | `%IMAGE{}%`             | `%TOC%`           |
| **Muse**       | ★★☆☆☆       | `[[url][text]]`     | `[[page]]`             | ✗             | `[1]`         | `#anchor`     | `[[img]]`               | `<contents>`      |
| **Creole**     | ★★☆☆☆       | `[[url\|text]]`     | `[[page]]`             | ✗             | ✗             | ✗             | `{{img}}`               | ✗                 |

---

## Embedded Languages

| Format         | LLM Fluency | Code Blocks         | Syntax Highlight  | Math/LaTeX       | Diagrams           | Raw HTML        | Comments      |
| -------------- | ----------- | ------------------- | ----------------- | ---------------- | ------------------ | --------------- | ------------- |
| **Markdown**   | ★★★★★       | indent/fence        | ✗                 | ✗                | ✗                  | inline          | `<!-- -->`    |
| **GFM**        | ★★★★★       | ` ``` ` + lang      | ✓                 | ✗                | ✗ (mermaid render) | inline          | `<!-- -->`    |
| **CommonMark** | ★★★★★       | indent/fence        | ✗                 | ✗                | ✗                  | ✗ (safe)        | ✗             |
| **MediaWiki**  | ★★★★☆       | `<syntaxhighlight>` | ✓                 | `<math>`         | ✗                  | `<nowiki>`      | `<!-- -->`    |
| **BBCode**     | ★★★★☆       | `[code]`            | `[code=lang]`     | ✗                | ✗                  | ✗               | ✗             |
| **rST**        | ★★★★☆       | `::` indent         | `.. code-block::` | `.. math::`      | `.. graphviz::`    | `.. raw:: html` | `.. comment`  |
| **Obsidian**   | ★★★★☆       | ` ``` ` + lang      | ✓                 | `$...$` `$$`     | Mermaid native     | inline          | `%%`          |
| **AsciiDoc**   | ★★★★☆       | `----` `[source]`   | `[source,lang]`   | `latexmath:[]`   | ditaa, PlantUML    | `++++`          | `//` `////`   |
| **Org-Mode**   | ★★★★☆       | `#+BEGIN_SRC`       | ✓ (Babel)         | `$...$` `\[..\]` | ditaa, PlantUML    | `#+BEGIN_HTML`  | `# comment`   |
| **Jira**       | ★★★☆☆       | `{code}`            | `{code:lang}`     | ✗                | ✗                  | ✗               | ✗             |
| **DokuWiki**   | ★★★☆☆       | `<code>`            | `<code lang>`     | plugin           | plugin             | `<html>`        | `/* */`       |
| **Textile**    | ★★★☆☆       | `bc.`               | ✗                 | ✗                | ✗                  | inline          | `###.`        |
| **djot**       | ★★★☆☆       | ` ``` `             | ✓                 | `$...$` `$$`     | ✗                  | ✗               | `{% %}`       |
| **Texinfo**    | ★★★☆☆       | `@example`          | `@verbatim`       | TeX native       | ✗                  | ✗               | `@c`          |
| **pod**        | ★★★☆☆       | verbatim para       | ✗                 | ✗                | ✗                  | ✗               | ✗             |
| **Haddock**    | ★★★☆☆       | `>` prefix          | ✗                 | ✗                | ✗                  | ✗               | `-- \|` (doc) |
| **Vimdoc**     | ★★★☆☆       | indent              | ✗                 | ✗                | ✗                  | ✗               | ✗             |
| **Vimwiki**    | ★★☆☆☆       | `{{{`               | `{{{lang`         | ○                | ✗                  | ✗               | `%%`          |
| **Markua**     | ★★☆☆☆       | ` ``` `             | ✓                 | `$$`             | ✗                  | ✗               | `%% `         |
| **txt2tags**   | ★★☆☆☆       | ```` ``` ````       | ✗                 | ✗                | ✗                  | `'''`           | `%`           |
| **XWiki**      | ★★☆☆☆       | `{{code}}`          | `{{code lang=""}}` | `{{formula}}`   | `{{diagram}}`      | `{{html}}`      | `//`          |
| **ZimWiki**    | ★★☆☆☆       | `'''`               | ✗                 | `$$` plugin      | plugin             | ✗               | ✗             |
| **TikiWiki**   | ★★☆☆☆       | `{CODE()}`          | ✓                 | `{MATH()}`       | plugin             | `{HTML()}`      | `~np~`        |
| **TWiki**      | ★★☆☆☆       | `<verbatim>`        | ✗                 | plugin           | plugin             | ✗               | `<!--- --->`  |
| **Muse**       | ★★☆☆☆       | `<example>`         | `<src>`           | ✗                | ✗                  | `<literal>`     | `; comment`   |
| **Creole**     | ★★☆☆☆       | `{{{`               | ✗                 | ✗                | ✗                  | ✗               | ✗             |

---

## Tooling Ecosystem

| Format         | LLM Fluency | Primary Implementations | Pandoc | SSGs                  | Editor Support          | Ecosystem Size |
| -------------- | ----------- | ----------------------- | ------ | --------------------- | ----------------------- | -------------- |
| **Markdown**   | ★★★★★       | many (100+)             | ✓ r/w  | Hugo, Jekyll, etc     | Excellent               | ★★★★★          |
| **GFM**        | ★★★★★       | cmark-gfm, remark       | ✓ r/w  | most                  | Excellent               | ★★★★★          |
| **CommonMark** | ★★★★★       | cmark, markdown-it      | ✓ r/w  | most modern SSGs      | Excellent               | ★★★★★          |
| **MediaWiki**  | ★★★★☆       | MediaWiki (PHP)         | ✓ r/w  | ✗                     | Limited                 | ★★★★☆          |
| **BBCode**     | ★★★★☆       | many forum sw           | ✓ w    | ✗                     | Forum editors           | ★★★☆☆          |
| **rST**        | ★★★★☆       | docutils, Sphinx        | ✓ r/w  | Sphinx                | Good (VS Code, PyCharm) | ★★★★☆          |
| **Obsidian**   | ★★★★☆       | Obsidian app            | ○ (preprocess) | Quartz, digital gardens | Excellent (native app)  | ★★★★☆          |
| **AsciiDoc**   | ★★★★☆       | Asciidoctor             | ✓ r/w  | Antora                | Good (plugins)          | ★★★★☆          |
| **Org-Mode**   | ★★★★☆       | org-mode (Emacs)        | ✓ r/w  | ox-hugo               | Emacs excellent         | ★★★☆☆          |
| **Jira**       | ★★★☆☆       | Jira (Java)             | ✓ r/w  | ✗                     | Jira editor             | ★★★☆☆          |
| **DokuWiki**   | ★★★☆☆       | DokuWiki (PHP)          | ✓ r/w  | ✗                     | Limited                 | ★★★☆☆          |
| **Textile**    | ★★★☆☆       | RedCloth (Ruby)         | ✓ r/w  | ✗                     | Limited                 | ★★☆☆☆          |
| **djot**       | ★★★☆☆       | djot.lua, djot.js       | ✓ r/w  | emerging              | Emerging                | ★★☆☆☆          |
| **Texinfo**    | ★★★☆☆       | GNU texinfo             | ✓ r/w  | ✗                     | Emacs                   | ★★☆☆☆          |
| **pod**        | ★★★☆☆       | Pod::Simple, perldoc    | ✓ r    | ✗                     | Perl IDEs               | ★★☆☆☆          |
| **Haddock**    | ★★★☆☆       | haddock                 | ✓ r/w  | ✗                     | Haskell IDEs            | ★★☆☆☆          |
| **Vimdoc**     | ★★★☆☆       | vim                     | ✓ w    | ✗                     | Vim                     | ★★☆☆☆          |
| **Vimwiki**    | ★★☆☆☆       | vimwiki (Vim)           | ✓ r    | ✗                     | Vim                     | ★★☆☆☆          |
| **Markua**     | ★★☆☆☆       | Leanpub                 | ✓ w    | ✗                     | Limited                 | ★☆☆☆☆          |
| **txt2tags**   | ★★☆☆☆       | txt2tags (Python)       | ✓ r    | ✗                     | Limited                 | ★★☆☆☆          |
| **XWiki**      | ★★☆☆☆       | XWiki (Java)            | ✓ w    | ✗                     | Limited                 | ★★☆☆☆          |
| **ZimWiki**    | ★★☆☆☆       | Zim (Python)            | ✓ w    | ✗                     | Zim app                 | ★★☆☆☆          |
| **TikiWiki**   | ★★☆☆☆       | TikiWiki (PHP)          | ✓ r    | ✗                     | Limited                 | ★★☆☆☆          |
| **TWiki**      | ★★☆☆☆       | TWiki (Perl)            | ✓ r    | ✗                     | Limited                 | ★★☆☆☆          |
| **Muse**       | ★★☆☆☆       | emacs-muse              | ✓ w    | ✗                     | Emacs only              | ★☆☆☆☆          |
| **Creole**     | ★★☆☆☆       | various parsers         | ✓ r    | ✗                     | Limited                 | ★☆☆☆☆          |

**Pandoc:** r = reader (input), w = writer (output), r/w = both

---

## Notes & Caveats

### LLM Fluency Assessment

My fluency ratings reflect:
- **Training data exposure**: Markdown, GFM, MediaWiki dominate web content
- **Syntax regularity**: More consistent syntaxes are easier to generate correctly
- **Documentation quality**: Well-documented formats with many examples score higher

**High confidence** (★★★★★): I can generate syntactically correct markup without references. Examples exist abundantly in training data.

**Medium confidence** (★★★☆☆): I know the general patterns but may make errors on edge cases or less common features.

**Low confidence** (★★☆☆☆): Sparse training examples; I'm essentially pattern-matching from limited exposure and may hallucinate incorrect syntax.

Within each tier, formats are ordered by relative confidence within that group.

### Format Relationships

```
WikiWikiWeb (1995)
├── TWiki (1998)
├── MediaWiki (2001-2002) ─────────────┐
│   └── influences many wiki syntaxes  │
├── UseModWiki → Wikipedia (early)     │
│                                      │
Setext (1991)                          │
├── atx headers                        │
├── StructuredText (Zope)              │
│   └── reStructuredText (2001)        │
│                                      │
├── Textile (2002) ─────────────────── │ ─┐
│                                      │  │
└── Markdown (2004) ◄──────────────────┘  │
    ├── CommonMark (2014)                 │
    │   ├── GFM (2017 spec)              │
    │   └── Obsidian (2020)              │
    ├── Markua (2014)                    │
    └── djot (2022)                      │
                                         │
AsciiDoc (2002) ◄────────────────────────┘
    └── DocBook heritage

Org-Mode (2003) ← outline-mode (Emacs)

Creole (2006-2007) ← attempted wiki standard

DokuWiki (2004) → ZimWiki (derived)
```

### Known Gaps & Uncertainties

- **Emacs Muse**: Defunct; limited documentation available; syntax may be partially inaccurate
- **TikiWiki/TWiki**: Enterprise wikis with complex macro systems not fully captured
- **XWiki**: Has multiple syntax modes (1.0, 2.0, 2.1); table shows 2.x
- **Vimwiki**: Supports multiple syntaxes internally (default, markdown, mediawiki)
- **ZimWiki**: Year approximate; derived from DokuWiki with modifications
- **Jira**: Atlassian moving away from wiki markup; new editor uses different system
- **Obsidian**: Many features via plugins (Templater, Dataview); core syntax shown here

### Sources

- Wikipedia articles on each format
- Official documentation for each tool/format
- Pandoc manual (format support)
- [Obsidian Help](https://help.obsidian.md/)
- [txt2tags history](https://txt2tags.wordpress.com/2006/07/26/5-years-of-txt2tags/)
- [Creole wiki](http://wikicreole.org/)
- [CommonMark spec](https://commonmark.org/)
- [GFM spec](https://github.github.com/gfm/)
- [djot spec](https://djot.net/)
- Various project repositories and changelogs

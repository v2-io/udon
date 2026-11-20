# Markdown dialect comparison: syntax, extension model, and parsing design

*Scope: the syntactic and design comparison only (popularity/trend and LLM familiarity are covered by sibling researchers). Dialects: CommonMark, GFM (spec + what github.com actually renders), Obsidian Flavored Markdown, Pandoc Markdown, MDX, Djot, plus other sizable players (GitLab Flavored Markdown, MyST, Markdoc, AsciiDoc). Researched 2026-10-14. Primary sources were read directly where possible: the djot syntax reference, the GFM spec text, the pandoc MANUAL, the Obsidian help vault source files, the GitLab markdown doc source, and the CommonMark 0.31.2 spec text already vendored at `v2/spikes/markdown-probe/commonmark-spec-0.31.2.txt`. MDX, MyST, Markdoc, AsciiDoc, and the GitHub docs pages were read through a summarizing fetch tool, so their wording is a little less certain; this is flagged where it matters.*

## Q1. Lineage, specification status, and governance: what is each dialect, formally?

### Takeaway
Only CommonMark has a rigorous, versioned, example-driven spec (and it has been at 0.31.2 since January 2024). GFM's spec is a frozen 2019 superset of CommonMark 0.29 that no longer describes everything github.com renders. Pandoc Markdown is defined by its manual and implementation and comes from the pre-CommonMark lineage. Djot has a careful prose syntax reference but no versioned spec. Obsidian, MDX, MyST, Markdoc, and GitLab are each defined as "CommonMark plus X" by product documentation or implementation.

### Cited Findings
- **CommonMark**: authored by John MacFarlane. Current version 0.31.2, dated 2024-01-28. Earlier versions were 0.30 (2021-06-19) and 0.29 (2019-04-06) — [CommonMark spec index](https://spec.commonmark.org/); [spec.txt header](https://github.com/commonmark/commonmark-spec/blob/master/spec.txt)
- The CommonMark spec has 652 embedded examples, which double as its conformance tests (counted in the 0.31.2 spec text) — [CommonMark 0.31.2](https://spec.commonmark.org/0.31.2/)
- The motivation for CommonMark is that Gruber's original description "does not specify the syntax unambiguously". Its list of unanswered questions includes sublist indentation, whether a blank line is needed before a block quote or heading, whether a blank line is needed before indented code, and loose vs tight lists — [CommonMark 0.31.2 §"Why is a spec needed?"](https://spec.commonmark.org/0.31.2/)
- **GFM**: spec version "0.29-gfm", dated 2019-04-06. It states "GFM is a strict superset of CommonMark". Five sections are marked "(extension)": Tables, Task list items, Strikethrough, Autolinks (extended), and Disallowed Raw HTML — [GFM spec](https://github.github.com/gfm/)
- The GFM spec does not cover footnotes, alerts, or math, all of which github.com renders. They are documented only in GitHub's product docs — [GFM spec](https://github.github.com/gfm/); [GitHub basic formatting docs](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax); [GitHub math docs](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/writing-mathematical-expressions)
- **Obsidian**: "Obsidian supports CommonMark, GitHub Flavored Markdown, and LaTeX." Its stated design is "maximum capability without breaking any existing formats". It warns that its own extensions (internal links, comments, highlights) may show up "as plain text" in other apps — [Obsidian Flavored Markdown (help source)](https://github.com/obsidianmd/obsidian-help/blob/master/en/Editing%20and%20formatting/Obsidian%20Flavored%20Markdown.md)
- **Pandoc Markdown**: "an extended and slightly revised version of John Gruber's Markdown syntax… Except where noted, these differences can be suppressed by using the `markdown_strict` format". Behavior is toggled through named extensions. Pandoc also offers `commonmark`, `gfm`, `commonmark_x` ("CommonMark with many pandoc extensions"), `markdown_mmd` (MultiMarkdown), `markdown_phpextra`, and `markdown_strict` as separate formats — [Pandoc MANUAL, "Pandoc's Markdown" and "Markdown variants"](https://pandoc.org/MANUAL.html#pandocs-markdown)
- Pandoc's stated philosophy differs from Gruber's in one respect: "Markdown was originally designed with HTML generation in mind, pandoc is designed for multiple output formats. Thus, while pandoc allows the embedding of raw HTML, it discourages it" — [Pandoc MANUAL §Philosophy](https://pandoc.org/MANUAL.html#philosophy)
- The latest pandoc release is 3.12.1 (2026-10-08) — [jgm/pandoc releases](https://github.com/jgm/pandoc/releases)
- **MDX**: "MDX supports standard markdown by default (CommonMark)". GFM, frontmatter, math, and syntax highlighting are plugins: "Nonstandard markdown features (such as GFM, frontmatter, math, syntax highlighting) can be enabled with plugins". The latest release is 3.1.1 (2025-08-29) — [What is MDX](https://mdxjs.com/docs/what-is-mdx/); [mdx-js/mdx releases](https://github.com/mdx-js/mdx/releases)
- MDX's syntax is formally described as a micromark state machine, with a dedicated section on "Deviations from markdown" — [micromark/mdx-state-machine](https://github.com/micromark/mdx-state-machine#72-deviations-from-markdown)
- **Djot**: by John MacFarlane (repo `jgm/djot`). It "derives most of its features from commonmark" but fixes parsing problems. The README gives no version number or formal spec status. The full syntax reference is the prose document `doc/syntax.md`. There is no official MIME type (`text/x-djot` is suggested), and the extensions are `.djot` / `.dj` — [jgm/djot README](https://github.com/jgm/djot); [djot syntax reference](https://github.com/jgm/djot/blob/main/doc/syntax.md)
- Djot's development focus has moved from djot.lua (the original reference implementation, which "may not track the latest syntax changes") to djot.js. Other implementations exist in Prolog (djota), PHP, Rust (jotdown), Go (godjot), and Haskell (djoths) — [jgm/djot README](https://github.com/jgm/djot)
- Djot activity: the syntax repo's last commit was 2026-06-16. djot.js's last commit was 2026-10-10, with latest tag `@djot/djot@0.3.2`. The syntax repo's only tags (0.1.0, 0.2.0) date from 2022 — [jgm/djot commits](https://github.com/jgm/djot/commits/main); [jgm/djot.js tags](https://github.com/jgm/djot.js/tags)

### Inferences
- The same person (MacFarlane) wrote the CommonMark spec, pandoc, and djot. Djot reads as the author's own list of CommonMark regrets (the rationale explicitly cites the CommonMark "principle of uniformity" that the spec "doesn't completely abide by"). The README links commonmark/commonmark-spec#634 for this.
- "GFM" is two things: a frozen 2019 spec, and a moving product surface (alerts, footnotes, math, mermaid, color chips, mentions). Anyone saying "GFM-compatible" has to say which one they mean.
- Pandoc Markdown is the only major dialect in this set that is not CommonMark-based at the core (`commonmark_x` is the CommonMark-based alternative). This follows from the manual's "extended… version of John Gruber's Markdown" framing plus the separate `commonmark_x` format. I found no single sentence saying "pandoc markdown is not CommonMark-conformant", so this is an inference.

### Gaps
- I found no CommonMark statement about a 1.0 timeline or whether 0.31.2 is effectively final.
- I didn't find which parser Obsidian uses internally (product docs don't say), or which parser GitLab uses (the docs page doesn't name comrak, commonmarker, or any other).
- No versioned djot spec exists, so "djot conformance" can only mean conformance to `doc/syntax.md` plus djot.js's test suite (not examined here).

## Q2. Divergence on the shared core: emphasis, headings, code, lists, links, line breaks, HTML

### Takeaway
GFM, Obsidian, MyST, Markdoc, and GitLab inherit CommonMark's core almost unchanged. Pandoc alters the core in several deliberate places (blank lines before headings and block quotes, intraword `_`, Markdown inside HTML). MDX *removes* core features (HTML, indented code, autolinks). Djot changes the meaning of the most common tokens: `*x*` is **strong** and `_x_` is *emphasis*, setext headings and indented code are gone, raw HTML is gone, and blocks cannot interrupt paragraphs.

### Cited Findings
**Emphasis**
- CommonMark defines emphasis and strong emphasis with 17 numbered rules over `*`/`_` delimiter runs, using left- and right-flanking logic — [CommonMark 0.31.2 §6.2](https://spec.commonmark.org/0.31.2/#emphasis-and-strong-emphasis)
- Djot: "Emphasized inline content is delimited by `_` characters. Strong emphasis is delimited by `*` characters." Doubled delimiters are not used; `__emphasis inside_ emphasis_` is nested emphasis. Precedence: "the first opener that gets closed takes precedence… Containers can't overlap." `{_` / `_}` force opener or closer status — [djot syntax §Emphasis/strong, §Precedence](https://github.com/jgm/djot/blob/main/doc/syntax.md)
- Pandoc does not treat a `_` surrounded by alphanumerics as emphasis (`intraword_underscores`) — [Pandoc MANUAL](https://pandoc.org/MANUAL.html#extension-intraword_underscores)
- Obsidian's table: bold `** **` or `__ __`; italic `* *` or `_ _`; bold+italic `*** ***` — [Obsidian basic formatting syntax](https://github.com/obsidianmd/obsidian-help/blob/master/en/Editing%20and%20formatting/Basic%20formatting%20syntax.md)

**Headings**
- CommonMark has ATX (`#`) and setext (underline) headings — [CommonMark 0.31.2](https://spec.commonmark.org/0.31.2/#setext-headings)
- Djot removes setext headings. ATX headings can span multiple lines ("The heading text may spill over onto following lines", with or without repeated `#`) and end at a blank line — [djot syntax §Heading](https://github.com/jgm/djot/blob/main/doc/syntax.md); [djot README diff #3](https://github.com/jgm/djot)
- Pandoc requires a blank line before a heading (`blank_before_header`) "because it is all too easy for a `#` to end up at the beginning of a line by accident (perhaps through line wrapping)". The example is `#22, for example` — [Pandoc MANUAL](https://pandoc.org/MANUAL.html#extension-blank_before_header)

**Code**
- CommonMark has both indented (4-space) and fenced code blocks — [CommonMark 0.31.2](https://spec.commonmark.org/0.31.2/#indented-code-blocks)
- MDX: "Indentation to create code blocks is not supported… The reason for this change is so that elements can be indented" — [mdx-state-machine §7.2.2](https://github.com/micromark/mdx-state-machine#72-deviations-from-markdown)
- Djot removes indented code. Code blocks use backticks only (tilde fences are not mentioned). An unclosed fence is implicitly closed by the end of its container. An unclosed inline code span "extends to the end" with no backtracking — [djot syntax §Code block, §Verbatim](https://github.com/jgm/djot/blob/main/doc/syntax.md); [djot README diffs #5, #12](https://github.com/jgm/djot)
- Obsidian supports both backtick and tilde fences, and indented code with Tab or 4 spaces — [Obsidian basic formatting syntax](https://github.com/obsidianmd/obsidian-help/blob/master/en/Editing%20and%20formatting/Basic%20formatting%20syntax.md)

**Lists and block interruption**
- Djot: "Paragraphs can never be interrupted by other block-level elements". An indented `- b` directly after `- a` is lazy paragraph continuation, not a sublist; sublists need a blank line first — [djot syntax §Block syntax, §List item](https://github.com/jgm/djot/blob/main/doc/syntax.md)
- Djot list markers: `-` `+` `*`, plus decimal, lower/upper alpha, and lower/upper roman, each in `1.` / `1)` / `(1)` forms, plus `:` (definition) and `- [ ]` (task). Changing the marker style starts a new list. Ambiguous markers (`i.` roman vs alpha) are resolved toward continuing the list — [djot syntax §List](https://github.com/jgm/djot/blob/main/doc/syntax.md)
- Pandoc: by default a list cannot follow a paragraph without a blank line (`lists_without_preceding_blankline` is an opt-in extension). `four_space_rule` restores pre-2.0 list indentation. `fancy_lists` / `startnum` / `example_lists` (`(@)` numbering that continues across the document, with `(@label)` references) — [Pandoc MANUAL](https://pandoc.org/MANUAL.html#extension-example_lists)

**Links**
- Djot reference links are "local". `[foo][bar]` parses as a link whether or not `bar` is defined. Shortcut reference links `[foo]` are removed. Labels are case-sensitive ("No case normalization"). Quoted link titles are removed (use `{title="…"}`). Every heading gets an implicit link reference, so `[Epilogue][]` links to the heading "Epilogue" — [djot syntax §Link, §Reference link definition, §Links to headings](https://github.com/jgm/djot/blob/main/doc/syntax.md)
- GFM extended autolinks: bare `www.` + valid domain, and bare `http(s)://` and email. Trailing `?!.,:*_~` are excluded — [GFM spec §6.9](https://github.github.com/gfm/#autolinks-extension-)
- MDX: "Autolinks are not supported… whether something is an element (whether HTML or JSX) or an autolink is ambiguous" — [mdx-state-machine §7.2.3](https://github.com/micromark/mdx-state-machine#72-deviations-from-markdown)

**Line breaks**
- CommonMark: hard break is two trailing spaces or a backslash; other newlines are soft breaks — [CommonMark 0.31.2](https://spec.commonmark.org/0.31.2/#hard-line-breaks)
- Djot: hard break is backslash + newline only (trailing spaces are not mentioned as a hard-break form). Backslash + space is a non-breaking space — [djot syntax §Line break, §Ordinary text](https://github.com/jgm/djot/blob/main/doc/syntax.md)
- GitHub: in issues, PRs, and discussions, a single newline renders as a line break, unlike `.md` files — [GitHub basic formatting docs](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)
- Obsidian has a "Strict line breaks" setting "which makes Obsidian follow the standard Markdown specification for line breaks". That implies the default deviates (a single newline renders as a break). The same page also says a single Enter is "treated as a *continuation* of the same paragraph… following typical Markdown behavior", so the help text is internally inconsistent on the default — [Obsidian basic formatting syntax](https://github.com/obsidianmd/obsidian-help/blob/master/en/Editing%20and%20formatting/Basic%20formatting%20syntax.md)
- Pandoc has `hard_line_breaks` (every newline is a break), `ignore_line_breaks`, and `east_asian_line_breaks` options — [Pandoc MANUAL](https://pandoc.org/MANUAL.html#extension-hard_line_breaks)

**Raw HTML (the deepest fault line)**
- CommonMark defines 7 kinds of HTML block, each with its own start and end condition (`<pre`/`<script`…, `<!--`, `<?`, `<!X`, `<![CDATA[`, known block-tag names, any complete open/close tag). Kind 6/7 blocks end at a blank line — [CommonMark 0.31.2 §4.6](https://spec.commonmark.org/0.31.2/#html-blocks)
- GFM keeps raw HTML but filters 9 tags (`title textarea style xmp iframe noembed noframes script plaintext`) by escaping their `<` — [GFM spec §6.11](https://github.github.com/gfm/#disallowed-raw-html-extension-)
- Pandoc by default "interprets material between HTML block tags as Markdown" (`markdown_in_html_blocks`), unlike original Markdown — [Pandoc MANUAL](https://pandoc.org/MANUAL.html#extension-markdown_in_html_blocks)
- Obsidian "does not render Markdown syntax inside HTML elements… an intentional design choice for performance optimization and to keep parser complexity low" — [Obsidian Flavored Markdown](https://github.com/obsidianmd/obsidian-help/blob/master/en/Editing%20and%20formatting/Obsidian%20Flavored%20Markdown.md)
- MDX: "Whether block or inline, HTML in Markdown is not supported… Character data, processing instructions, declarations, and comments are not supported at all". JSX replaces HTML, and comments become `{/* … */}`. Unescaped `<` and `{` must be escaped — [mdx-state-machine §7.2.1](https://github.com/micromark/mdx-state-machine#72-deviations-from-markdown); [What is MDX](https://mdxjs.com/docs/what-is-mdx/)
- Djot: raw HTML is disallowed except when explicitly marked (`` `<a id="foo">`{=html} `` or a ```` ``` =html ```` block). HTML entities are not interpreted — [djot README diff #6](https://github.com/jgm/djot); [djot syntax §Raw inline, §Raw block](https://github.com/jgm/djot/blob/main/doc/syntax.md)

**Block quotes**
- Djot requires a space or newline after `>` — [djot README diff #9](https://github.com/jgm/djot)
- Pandoc requires a blank line before a block quote (`blank_before_blockquote`), for the same hard-wrap reason as headings — [Pandoc MANUAL](https://pandoc.org/MANUAL.html#extension-blank_before_blockquote)

### Inferences
- The HTML rules alone give the same input four different readings. Take `<div>` / `**x**` / `</div>` with no blank lines:
  - CommonMark/GFM: one HTML block, `**x**` stays literal (kind-6 block, no blank line to end it).
  - Pandoc (default): `**x**` is bold.
  - Obsidian: explicitly not bold.
  - MDX: a JSX element.
  - Djot: the tags are literal text.

  I derived this from the cited rules and did not run it through each implementation.
- Two dialects independently cite hard-wrapping as the reason for their deviations: pandoc (blank line before `#` and `>`) and djot ("Hard-wrapping friendliness, so line breaks don't change interpretation", plus no paragraph interruption). That is convergent evidence that CommonMark's "blocks may interrupt paragraphs" rule costs real authors.
- The deviations come in three kinds:
  - **additive**: GFM, Obsidian, GitLab, MyST, Markdoc
  - **subtractive**: MDX (removes HTML, indented code, autolinks to free up `<`, `{`, and indentation)
  - **reinterpretive**: djot (same glyphs, different meanings) and, more mildly, pandoc

  Djot's `*` = strong is the single biggest familiarity hazard in the set. A writer or LLM fluent in CommonMark will produce wrong output silently, not an error.

### Gaps
- I did not verify each implementation's behavior on the edge cases above. A small differential run (the `markdown-probe` apparatus already vendors CommonMark) would settle them.
- I didn't confirm whether MDX 3 parses Markdown inside JSX block children (I believe it does, but didn't verify).
- I didn't confirm whether djot accepts `~~~` fences (the syntax reference mentions only backticks).

## Q3. Extension feature surface: what each dialect adds, and where the same glyph means different things

### Takeaway
A de facto shared extension layer has formed: `[^id]` footnotes, pipe tables, `- [ ]` tasks, `> [!type]` callouts, `$`/`$$` math, and `:::` containers. But the details diverge in ways that matter for interop. `~x~` is strikethrough in GFM and subscript in pandoc/djot. `[[a|b]]` puts the display text after the pipe in Obsidian and before it in GitLab. Math delimiting rules differ. Callout type sets and casing differ.

### Feature matrix (sources per row below)

| Feature | CommonMark | GFM spec / github.com | Obsidian | Pandoc md (default ext.) | MDX (core) | Djot |
|---|---|---|---|---|---|---|
| Tables | — | pipe tables (spec) | pipe (GFM) | pipe, simple, multiline, grid; captions | plugin | pipe tables, multiple header rows, `^ caption` |
| Task lists | — | `- [ ]` / `- [x]` (spec) | `- [ ]`; any char checks (`[?]`, `[-]`) | `task_lists` | plugin | `- [ ]` `[x]` `[X]` |
| Strikethrough / delete | — | `~~x~~`; live spec also `~x~` | `~~x~~` | `~~x~~` (strikeout) | plugin | `{-x-}` (braces mandatory) |
| Insert | — | `<ins>` HTML only | — | — | — | `{+x+}` |
| Highlight | — | — | `==x==` (+ color emoji) | `==x==` via `mark` ext | — | `{=x=}` (braces mandatory) |
| Sub/superscript | — | `<sub>`/`<sup>` HTML only | — (HTML) | `~x~` / `^x^` (no spaces) | — | `~x~` / `^x^` (spaces allowed with braces) |
| Footnotes | — | github.com yes (not in spec) | `[^1]`, inline `^[…]` | `[^1]`, inline `^[…]` | plugin | `[^1]` (block content, indented) |
| Math | — | github.com: `$…$`, `` $`…`$ ``, `$$`, ```` ```math ```` | `$…$`, `$$…$$` (MathJax) | `$…$` with spacing/digit rule, `$$` | plugin | only `` $`…` `` / `` $$`…` `` |
| Callouts/admonitions | — | `> [!NOTE]` 5 types (github.com) | `> [!type]` 13 types + aliases, foldable `+/-`, custom title, nestable | `alerts` ext (GitHub-style) | — | via div `::: warning` |
| Generic block container | — | — | — | `:::: {#id .class}` fenced div | JSX | `::: class` div |
| Generic inline span | — | — | — | `[text]{.class}` | JSX | `[text]{.class}` |
| Attributes | — | — | — | headings, code, links, spans/divs; `attributes` ext for commonmark | JSX props | any element (inline: after; block: line before) |
| Raw passthrough | HTML only | HTML (9 tags filtered) | HTML (no md inside) | HTML, TeX, `{=format}` | none (JSX) | `{=format}` only |
| Wikilinks | — | — (wikis aside) | `[[Note]]`, `[[Note#Head]]`, `[[Note#^block]]`, `[[Note\|text]]` | opt-in, either pipe order | — | — |
| Embeds/transclusion | — | — | `![[file]]`, `![[note#^id]]`, `\|100x145` sizing | — | `import` | — |
| Comments | `<!-- -->` | `<!-- -->` | `%%…%%` (inline/block) | `<!-- -->` | `{/* */}` | `{% … %}` (attribute comment) |
| Metadata block | — | — | YAML frontmatter ("properties") | YAML metadata, pandoc title block | ESM `export`; frontmatter plugin | — |
| Definition lists | — | — | — | PHP-Extra style `Term` / `:   def` | — | `: term` + indented definition |
| Citations | — | — | — | `[@doe99; @smith2000]` | — | — |
| Smart typography | — | — | — | `smart` | — | built in (quotes, `--`, `---`, `...`), overridable with `{"` |
| Symbols/emoji | — | `:shortcode:` (github.com) | — | `emoji` ext | — | `:sym:` (renderer decides) |
| Heading IDs | — | auto (github.com) | block IDs `^id` at line end | `{#id}` + auto IDs | — | auto IDs + `{#id}` + implicit heading refs |

Row sources:
- CommonMark baseline (no extensions): [CommonMark 0.31.2](https://spec.commonmark.org/0.31.2/)
- GFM tables, tasks, strikethrough, autolinks, tagfilter: [GFM spec](https://github.github.com/gfm/)
- github.com footnotes, alerts, comments, emoji, sub/sup/ins via HTML, line breaks, heading anchors: [GitHub basic formatting docs](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)
- github.com math (MathJax): [GitHub math docs](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/writing-mathematical-expressions)
- Obsidian:
  - extension table: [OFM](https://github.com/obsidianmd/obsidian-help/blob/master/en/Editing%20and%20formatting/Obsidian%20Flavored%20Markdown.md)
  - formatting, highlights + colors, tasks, footnotes, comments: [basic syntax](https://github.com/obsidianmd/obsidian-help/blob/master/en/Editing%20and%20formatting/Basic%20formatting%20syntax.md)
  - tables, math, mermaid: [advanced syntax](https://github.com/obsidianmd/obsidian-help/blob/master/en/Editing%20and%20formatting/Advanced%20formatting%20syntax.md)
  - callouts: [callouts](https://github.com/obsidianmd/obsidian-help/blob/master/en/Editing%20and%20formatting/Callouts.md)
  - links, headings, blocks, display text: [internal links](https://github.com/obsidianmd/obsidian-help/blob/master/en/Linking%20notes%20and%20files/Internal%20links.md)
  - embeds: [embed files](https://github.com/obsidianmd/obsidian-help/blob/master/en/Linking%20notes%20and%20files/Embed%20files.md)
  - tags: [tags](https://github.com/obsidianmd/obsidian-help/blob/master/en/Editing%20and%20formatting/Tags.md)
- Pandoc, all rows: [Pandoc MANUAL](https://pandoc.org/MANUAL.html) — extensions `pipe_tables`, `simple_tables`, `multiline_tables`, `grid_tables`, `task_lists`, `strikeout`, `mark`, `superscript`/`subscript`, `footnotes`, `inline_notes`, `tex_math_dollars`, `alerts`, `fenced_divs`, `bracketed_spans`, `attributes`, `raw_attribute`, `raw_tex`, `wikilinks_title_after_pipe`/`_before_pipe`, `yaml_metadata_block`, `pandoc_title_block`, `definition_lists`, `citations`, `smart`, `emoji`, `header_attributes`, `auto_identifiers`
- MDX: [What is MDX](https://mdxjs.com/docs/what-is-mdx/)
- Djot, all rows: [djot syntax reference](https://github.com/jgm/djot/blob/main/doc/syntax.md)

### Cited Findings (details behind the matrix)
- GFM strikethrough. The live spec says "any text wrapped in a matching pair of one or two tildes", with `~there~` struck in Example 491, and "Three or more tildes do not create a strikethrough". The `test/spec.txt` in the cmark-gfm repo (same version label 0.29, last touched 2023-03-25) instead says "wrapped in two tildes". The two published texts conflict — [GFM spec (live)](https://github.github.com/gfm/#strikethrough-extension-); [cmark-gfm test/spec.txt](https://github.com/github/cmark-gfm/blob/master/test/spec.txt)
- Pandoc sub/superscript: "The text between `^...^` or `~...~` may not contain spaces or newlines… to prevent accidental superscripting and subscripting through the ordinary use of `~` and `^`, and also bad interactions with footnotes" (spaces must be backslash-escaped). Example: `H~2~O is a liquid. 2^10^ is 1024.` — [Pandoc MANUAL](https://pandoc.org/MANUAL.html#extension-superscript-subscript)
- Djot sub/superscript: `H~2~O and djot^TM^`. Braces are optional, and with them spaces are allowed: `H{~one two buckle my shoe~}O` — [djot syntax §Super/subscript](https://github.com/jgm/djot/blob/main/doc/syntax.md)
- Pandoc inline math rule: "The opening `$` must have a non-space character immediately to its right, while the closing `$` must have a non-space character immediately to its left, and must not be followed immediately by a digit. Thus, `$20,000 and $30,000` won't parse as math". Display math is `$$` with no blank lines inside — [Pandoc MANUAL](https://pandoc.org/MANUAL.html#extension-tex_math_dollars)
- GitHub math: `$…$` inline; `` $`…`$ `` "when the expression contains characters that overlap with Markdown syntax"; `$$` blocks (in `.md` files a preceding line break may be needed); ```` ```math ```` fences. MathJax renders it. A literal `$` outside math on a math-bearing line needs `<span>$</span>` — [GitHub math docs](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/writing-mathematical-expressions)
- Djot math is always wrapped in verbatim: "put the math in a verbatim span and prefix it with `$` (for inline math) or `$$` (for display math)", e.g. `` $`e=mc^2` `` — [djot syntax §Math](https://github.com/jgm/djot/blob/main/doc/syntax.md)
- GitHub alerts: exactly `[!NOTE]`, `[!TIP]`, `[!IMPORTANT]`, `[!WARNING]`, `[!CAUTION]`. The docs advise against nesting them inside other elements — [GitHub basic formatting docs](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)
- Obsidian callouts have 13 built-in types: note, abstract, info, todo, tip, success, question, warning, failure, danger, bug, example, quote. Aliases include summary/tldr, hint/important, check/done, help/faq, caution/attention, fail/missing. "Any unsupported type defaults to the `note` type. The type identifier is case-insensitive." Callouts can be foldable (`[!faq]-` collapsed, `+` expanded), have custom titles after the type, be title-only, nest, and take custom types via CSS — [Obsidian callouts](https://github.com/obsidianmd/obsidian-help/blob/master/en/Editing%20and%20formatting/Callouts.md)
- Note that GitHub's `IMPORTANT` and `CAUTION` are distinct alert types, while in Obsidian `important` is an alias of `tip` and `caution` an alias of `warning` — [GitHub docs](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax); [Obsidian callouts](https://github.com/obsidianmd/obsidian-help/blob/master/en/Editing%20and%20formatting/Callouts.md)
- Obsidian wikilinks: `[[Example|Custom name]]` (display text after the pipe), `[[Note#Heading]]`, chained headings `[[A#B#C]]`, block refs `[[2023-01-01#^37066d]]` with block IDs written as ` ^id` at the end of a block (Latin letters, numbers, dashes), vault search forms `[[## header]]` and `[[^^block]]`. Characters `# | ^ : %% [[ ]]` "may not work" in link targets. Wikilinks can be turned off in favor of Markdown links — [Obsidian internal links](https://github.com/obsidianmd/obsidian-help/blob/master/en/Linking%20notes%20and%20files/Internal%20links.md)
- Inside an Obsidian table, the wikilink alias pipe must be escaped: `[[Basic formatting syntax\|Markdown syntax]]` — [Obsidian advanced syntax](https://github.com/obsidianmd/obsidian-help/blob/master/en/Editing%20and%20formatting/Advanced%20formatting%20syntax.md)
- GitLab wiki links put the display text before the pipe: `[[How to use GitLab|how-to-use-gitlab]]` "if the page slug is different from the title" — [GitLab markdown doc source](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/user/markdown.md)
- Pandoc supports both pipe orders as separate opt-in extensions: `wikilinks_title_after_pipe` gives `[[URL|title]]` and `wikilinks_title_before_pipe` gives `[[title|URL]]` — [Pandoc MANUAL](https://pandoc.org/MANUAL.html#extension-wikilinks_title_after_pipe)
- Obsidian image sizing via the alt text: `![Engelbart|100x145](url)` and `![[Engelbart.jpg|100]]`. Embeds can target headings, blocks, and PDF pages (`![[Document.pdf#page=3]]`) — [Obsidian basic syntax](https://github.com/obsidianmd/obsidian-help/blob/master/en/Editing%20and%20formatting/Basic%20formatting%20syntax.md); [Obsidian embed files](https://github.com/obsidianmd/obsidian-help/blob/master/en/Linking%20notes%20and%20files/Embed%20files.md)
- Obsidian tags: `#tag`, nested `#a/b`; letters, digits, `_`, `-`, `/`, and Unicode/emoji allowed; at least one non-digit (`#1984` is invalid); case-insensitive; no spaces. Tags can also be set in the YAML `tags:` property — [Obsidian tags](https://github.com/obsidianmd/obsidian-help/blob/master/en/Editing%20and%20formatting/Tags.md)
- Djot pipe tables: every row must start and end with `|`. A separator line makes the *previous* row a header, and later separator lines start new header/alignment regimes. A table can begin with a separator line to set alignment without a header. Pipes inside verbatim spans don't split cells. Cells are inline-only. Captions are `^ caption` — [djot syntax §Pipe table](https://github.com/jgm/djot/blob/main/doc/syntax.md)
- GFM tables: the header and delimiter rows must have the same cell count or no table is recognized. Excess body cells are ignored and missing ones filled. Leading and trailing pipes are optional ("recommended"). The table ends at a blank line or another block start — [GFM spec §4.10](https://github.github.com/gfm/#tables-extension-)
- Pandoc grid tables allow block content in cells; in multiline and grid table cells, backslash-newline is "the only way to create a hard line break" — [Pandoc MANUAL](https://pandoc.org/MANUAL.html#extension-escaped_line_breaks)
- Pandoc implicit figures: "An image with nonempty alt text, occurring by itself in a paragraph, will be rendered as a figure with a caption" — [Pandoc MANUAL](https://pandoc.org/MANUAL.html#extension-implicit_figures)
- Pandoc line blocks: lines starting with `| ` keep their line breaks and leading spaces, for verse and addresses — [Pandoc MANUAL](https://pandoc.org/MANUAL.html#extension-line_blocks)
- Djot smart punctuation: `--` gives an en dash, `---` an em dash, `...` an ellipsis. Longer hyphen runs are split uniformly. Quote direction can be forced with `{"` / `"}`. Symbols `:+1:` are left for filters to interpret — [djot syntax §Smart punctuation, §Symbols](https://github.com/jgm/djot/blob/main/doc/syntax.md)

### Inferences
- **Glyph collisions across dialects** (each derived from the rules cited above):
  - `H~2~O` is subscript in pandoc and djot, but strikethrough under the live GFM spec's single-tilde rule.
  - `^[note]` is an inline footnote in pandoc and Obsidian. In djot, `^` is the superscript delimiter.
  - `{% … %}` is a *comment* in djot but a *tag* in Markdoc (and Liquid/Jinja-family templates).
  - `[[a|b]]` puts the display text after the pipe in Obsidian and before it in GitLab. Pandoc had to ship both orders as separate extensions.
  - `==x==` is highlight in Obsidian and pandoc+`mark`. Djot deliberately requires `{=x=}`.
  - `{+x+}` means insert in djot and GitLab. The delete forms differ: djot `{-x-}`, GitLab `[-x-]`.
- **Callout convergence is real but shallow.** The `> [!type]` carrier is shared by GitHub, Obsidian, GitLab, and pandoc's `alerts`. The type vocabulary (5 vs 13+aliases), case handling, folding, titles, and nesting are not shared. It is a block-quote overload, not a container. A reader without support sees a block quote starting with a literal `[!NOTE]`.
- **Djot's design move is "braces as disambiguators".** Rather than piling up context-sensitive flanking rules, it makes rare constructs require explicit `{x … x}` delimiters (highlight, insert, delete) and lets braces override opener/closer status for common ones. That is a principled answer to the CommonMark emphasis problem, which takes 17 rules.

### Gaps
- I didn't establish who originated `> [!type]` callouts (Obsidian vs GitHub vs earlier) or when. A sibling researcher on trends may have this.
- I didn't verify github.com's actual single-tilde behavior, which would settle the spec conflict above.
- No authoritative source found for github.com mermaid support in this pass. GitLab documents ```` ```mermaid ```` and ```` ```plantuml ```` ([GitLab docs](https://docs.gitlab.com/user/markdown/)). Obsidian documents ```` ```mermaid ```` ([Obsidian advanced syntax](https://github.com/obsidianmd/obsidian-help/blob/master/en/Editing%20and%20formatting/Advanced%20formatting%20syntax.md)).

## Q4. Extensibility model: how does each dialect let users go beyond its fixed feature set?

### Takeaway
There are four models:
1. **Closed enumeration**: CommonMark, GFM, Obsidian. Features are fixed, with HTML as the escape hatch.
2. **Generic attributes plus generic containers**: pandoc, djot, MyST. Divs, spans, `{#id .class key=val}`, and raw `{=format}`, interpreted later by filters.
3. **Named directives/tags with arguments**: MyST `{directive}` and `{role}`, Markdoc `{% tag %}`, GitLab `::include{…}`.
4. **Embedded host language**: MDX (JSX, JS expressions, ESM).

Djot is the purest version of model 2. It defines no semantics for classes or symbols and leaves them all to filters.

### Cited Findings
- Djot design goals include "Arbitrary attributes on any element", "Generic containers for text, inline, and block content", and "No expressive blind spots, so any intended HTML output can be expressed" — [jgm/djot README](https://github.com/jgm/djot)
- Djot attribute syntax is `{#id .class key="value" key2=bare % comment %}`. Inline attributes must *immediately follow* the element. Block attributes go on the line(s) before the block. Stacked specifiers combine (`avant{lang=fr}{.blue}`). Attributes on reference definitions transfer to links, and link-side attributes win — [djot syntax §Inline attributes, §Block attributes, §Reference link definition](https://github.com/jgm/djot/blob/main/doc/syntax.md)
- Djot div: `::: warning` … `:::` (a single class name only on the fence line; other attributes go before it as block attributes). Span: `[read the manual]{.big .red}` — [djot syntax §Div, §Span](https://github.com/jgm/djot/blob/main/doc/syntax.md)
- Pandoc fenced divs: `::::: {#special .sidebar}` … `:::::`. Attributes may be followed by more colons, except that "the `commonmark` parser doesn't permit colons after the attributes". Bracketed spans: `[This is *some text*]{.class key="val"}` — [Pandoc MANUAL](https://pandoc.org/MANUAL.html#extension-fenced_divs)
- Pandoc's `attributes` extension (for `commonmark`) uses djot-like placement: attributes "immediately after an inline element affect that element. If they follow a space, then they belong to the space", and attributes on a line by themselves before a block affect that block — [Pandoc MANUAL](https://pandoc.org/MANUAL.html#extension-attributes)
- Pandoc `raw_attribute`: `` `<a>html</a>`{=html} `` and ```` ```{=openxml} ```` blocks pass through to the named output format — [Pandoc MANUAL](https://pandoc.org/MANUAL.html#extension-raw_attribute)
- MyST: "MyST is a superset of CommonMark". Directives are block-level, in colon-fence (`:::{note}`) or backtick-fence (```` ```{math} ````) form, with arguments after the name. Options can be written as `:key: value` lines, a YAML block, or inline `{name .class #label key="value"}`. Roles are inline: `` {rolename}`content` ``. The design is "inspired by the Sphinx and reStructuredText (RST) ecosystems" — [MyST syntax overview](https://mystmd.org/guide/syntax-overview)
- Markdoc: "Markdoc syntax is a superset of Markdown, specifically the CommonMark specification". Tags are `{% tag %}` … `{% /tag %}`, and self-closing tags are `{% tag … /%}`. Attribute values can be JSON-typed. Annotations attach to the preceding node (`- Function {% width="25%" %}`). Variables are `{% $markdoc.frontmatter.title %}` and functions look like `{% if equals(1, 2) %}`. HTML comments require `allowComments: true` — [Markdoc syntax](https://markdoc.dev/docs/syntax)
- MDX: "MDX allows you to use JSX in your markdown content", plus "expressions in braces (`{1 + 1}`) and ESM (`import` and `export`)". Error behavior: "Whereas all Markdown is valid, incorrect MDX will crash" — [What is MDX](https://mdxjs.com/docs/what-is-mdx/); [mdx-state-machine §7.2.4](https://github.com/micromark/mdx-state-machine#72-deviations-from-markdown)
- GitLab adds named, brace-argument constructs: `::include{file=chapter1.md}`, `[[_TOC_]]` / `[TOC]`, multiline `>>>` block quotes, and front matter in YAML `---`, TOML `+++`, or JSON `;;;` — [GitLab Flavored Markdown](https://docs.gitlab.com/user/markdown/)

### Inferences
- Error semantics split the field. Every Markdown-lineage dialect (including djot) is total: any input yields a document. MDX is partial and crashes on invalid input. Markdoc and MyST sit between (tags and directives can fail validation at render time; I didn't verify their parse-error behavior).
- The `:::` fence is the closest thing to a cross-dialect generic block container: pandoc divs, djot divs, and MyST colon-fence directives. But the line after `:::` means different things: pandoc wants `{attrs}` or a bare class, djot a bare class only, MyST `{directive-name} args`.
- Model 2 (generic attributes and containers) is the only one where adding a new semantic construct needs no parser change. Djot shows this can be done while keeping linear-time, local parsing.

### Gaps
- I didn't fetch the MyST formal spec (mystmd.org links a "Specification") or verify MyST's parse-error behavior.
- I didn't confirm whether Markdoc removes raw HTML or indented code (the syntax page doesn't say).

## Q5. Parsing model and design philosophy: what does each dialect cost to implement and to reason about?

### Takeaway
CommonMark's precision came at the cost of complexity: 17 emphasis rules, 7 HTML block kinds, Unicode-class flanking, entity tables, case-folded reference labels, and reference links that resolve non-locally (the same `[foo]` parses differently depending on a definition anywhere in the document). Djot is explicitly designed against each of those: linear time, no backtracking, local inline parsing, no Unicode classes, no HTML parsing, no entities, no case folding. The other dialects inherit CommonMark's cost and add their own.

### Cited Findings
- Djot design goals verbatim (via the README): linear-time parsing with no backtracking; local inline parsing "so reference links don't depend on definitions elsewhere in the document"; simpler emphasis rules; simple list-item content rules; "No Unicode character classes, HTML tag parsing, entity handling, or Unicode case folding required of parsers"; "Hard-wrapping friendliness"; "Uniform composition, so content means the same inside or outside lists and block quotes" — [jgm/djot README](https://github.com/jgm/djot)
- Djot blocks "can be parsed line by line with no backtracking. The contribution a line makes to block-level structure never depends on a future line. Indentation is only significant for list item or footnote nesting." Thematic breaks may be indented — [djot syntax §Block syntax, §Thematic break](https://github.com/jgm/djot/blob/main/doc/syntax.md)
- Djot inline precedence is "first opener that gets closed takes precedence". Containers can't overlap. When several openers could match a closer, "the closest one is used" — [djot syntax §Precedence](https://github.com/jgm/djot/blob/main/doc/syntax.md)
- Djot security: renderers "do not necessarily sanitize HTML output". Unsafe output can come from raw `{=html}`, from attributes like `onclick`, or from `javascript:` URLs. Nesting limits: "a limit of 512 should be perfectly safe" — [djot syntax §Security, §Nesting limits](https://github.com/jgm/djot/blob/main/doc/syntax.md)
- CommonMark's appendix describes a two-phase strategy (block structure first, then inline structure) — [CommonMark 0.31.2 Appendix](https://spec.commonmark.org/0.31.2/#appendix-a-parsing-strategy)
- CommonMark reference links can be shortcut `[foo]` and are matched case-insensitively. Djot removes shortcut links and makes labels case-sensitive, "a reference defined as `[link]` cannot be used as `[Link]`, as it can in Markdown" — [CommonMark 0.31.2 §Link reference definitions](https://spec.commonmark.org/0.31.2/#link-reference-definitions); [djot syntax](https://github.com/jgm/djot/blob/main/doc/syntax.md)
- Obsidian cites parser complexity as its reason for not parsing Markdown inside HTML ("to keep parser complexity low when managing large documents") — [Obsidian Flavored Markdown](https://github.com/obsidianmd/obsidian-help/blob/master/en/Editing%20and%20formatting/Obsidian%20Flavored%20Markdown.md)
- MDX justifies its removals by ambiguity with JSX: autolinks "can be indistinguishable from JSX (for example: `<svg:rect>`) and we prefer being explicit"; indented code removed "so you can nicely indent your components" — [What is MDX](https://mdxjs.com/docs/what-is-mdx/)
- GitLab caps math rendering for safety: "GitLab renders only the first 1000 inline math instances", with block math limited by render time — [GitLab markdown doc source](https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/user/markdown.md)
- AsciiDoc (a non-Markdown competitor in the same niche): the language specification is "currently underway" under the AsciiDoc Language project of the Eclipse Foundation's AsciiDoc Working Group. It positions Markdown as stopping "short of being a technical writing language", and itself as providing "all the essential elements in technical writing out of the box" (e.g. built-in admonitions, five types; `include` directive) — [asciidoc.org](https://asciidoc.org/)

### Inferences
- **Locality is the hidden axis.** CommonMark has three non-local dependencies: reference resolution (`[foo]` depends on a definition anywhere), paragraph interruption (whether a line starts a block depends on the previous line's type), and HTML block end conditions. Djot removes all three. Pandoc and MDX remove some for other reasons: pandoc's blank-line requirements for hard-wrap safety, MDX's removals for JSX. For streaming or incremental parsing (editors, LLM token streams), the dialects closest to the line-local ideal are djot first, MDX second (but MDX is partial and crashes), and everything CommonMark-derived last.
- **Indentation significance ranking**, from the cited rules: djot is the least sensitive (only list and footnote nesting; no indented code; indented thematic breaks allowed). MDX removes indented code but keeps CommonMark list indentation. CommonMark, GFM, Obsidian, GitLab, MyST, and Markdoc keep 4-space code plus list-relative indentation. Pandoc keeps both and offers `four_space_rule` as a legacy switch.
- **Reconstructability.** Every dialect here has meaning-changing whitespace (trailing spaces as hard breaks everywhere except djot, soft vs hard newline defaults that vary by *surface* on GitHub and Obsidian, tight vs loose lists). The same `.md` file renders differently in GitHub issues vs repo files, and in Obsidian strict vs non-strict mode. "Dialect" is not even stable within one vendor.
- Djot is the only dialect whose design document reads as a set of parsing *invariants* rather than a feature list. Its weak points are adoption (no versioned spec, reference implementation in flux between lua and js) and familiarity (reinterpreted `*`/`_`).

### Gaps
- No benchmark comparison of parser performance across dialects was found in this pass.
- I didn't fetch the CommonMark issue (commonmark/commonmark-spec#634) that djot cites as evidence the spec violates its own uniformity principle.
- Quarto/R Markdown (pandoc-based), kramdown (Jekyll), MultiMarkdown, PHP Markdown Extra, reStructuredText, and Org-mode were not researched individually. Pandoc's own `markdown_mmd` and `markdown_phpextra` formats confirm MultiMarkdown and PHP Markdown Extra are distinct live dialects ([Pandoc MANUAL §Markdown variants](https://pandoc.org/MANUAL.html#markdown-variants)), but their syntax deltas are not catalogued here.

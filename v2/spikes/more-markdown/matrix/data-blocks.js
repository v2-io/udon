// Block structure, line breaks, and inline core.
MATRIX.rows.push(
  { g: "Block structure", f: "ATX heading", c: {
    cm: ["C", "# Heading"], gfm: ["C", "# Heading"], gh: ["C", "# Heading", "Auto anchors"], obs: ["C", "# Heading"],
    gl: ["C", "# Heading"], pd: ["C", "# Heading", "Needs a blank line before (blank_before_header)"],
    dj: ["C", "# Heading", "May spill over several lines; ends at a blank line"], myst: ["C", "# Heading"],
    mdoc: ["C", "# Heading"], mdx: ["C", "# Heading"] } },
  { g: "Block structure", f: "Setext (underlined) heading", c: {
    cm: ["C", "Text\\n===="], gfm: ["C", "Text\\n===="], gh: ["C", "Text\\n===="], obs: ["Q", "", "Not documented"],
    gl: ["C", "Text\\n===="], pd: ["C", "Text\\n===="], dj: ["R", "", "Removed"], myst: ["C", "Text\\n===="],
    mdoc: ["R", "", "The one CommonMark feature Markdoc drops"], mdx: ["C", "Text\\n===="] } },
  { g: "Block structure", f: "Indented code (4 spaces)", c: {
    cm: ["C", "····code"], gfm: ["C", "····code"], gh: ["C", "····code"], obs: ["C", "····code or Tab"],
    gl: ["C", "····code"], pd: ["C", "····code"], dj: ["R", "", "Removed; indentation matters only for list and footnote nesting"],
    myst: ["C", "····code"], mdoc: ["C", "····code", "Experimental allowIndentation removes it"],
    mdx: ["R", "", "Becomes a paragraph, \"so you can nicely indent your components\""] } },
  { g: "Block structure", f: "Backtick fence", c: {
    cm: ["C", "```lang"], gfm: ["C", "```lang"], gh: ["C", "```lang"], obs: ["C", "```lang"], gl: ["C", "```lang"],
    pd: ["C", "```lang  or ``` {#id .class}", "Attributes on fences"], dj: ["C", "```lang", "Unclosed fence ends at end of container"],
    myst: ["C", "```lang  /  ```{directive}"], mdoc: ["C", "```lang"], mdx: ["C", "```lang"] } },
  { g: "Block structure", f: "Tilde fence", c: {
    cm: ["C", "~~~lang"], gfm: ["C", "~~~lang"], gh: ["C", "~~~lang"], obs: ["C", "~~~lang"], gl: ["C", "~~~lang"],
    pd: ["C", "~~~ {#id .class}", "Pandoc's main fence; needs blank lines around it"],
    dj: ["U", "", "Backtick fences only; ~~~ is paragraph text"], myst: ["Q", "", "Not established"],
    mdoc: ["Q", "", "Not established (markdown-it base)"], mdx: ["Q", "", "Not established"] } },
  { g: "Block structure", f: "Block quote", c: {
    cm: ["C", "> text"], gfm: ["C", "> text"], gh: ["C", "> text"], obs: ["C", "> text"],
    gl: ["C", "> text  /  >>> multiline"], pd: ["C", "> text", "Needs a blank line before (blank_before_blockquote)"],
    dj: ["C", "> text", "A space or newline is required after >"], myst: ["C", "> text"], mdoc: ["C", "> text"], mdx: ["C", "> text"] } },
  { g: "Block structure", f: "List directly after a paragraph (no blank line)", c: {
    cm: ["C", "Text\\n- item", "Ordered lists interrupt only if they start at 1"], gfm: ["C", ""], gh: ["C", ""], obs: ["C", ""], gl: ["C", ""],
    pd: ["E", "", "Off by default (lists_without_preceding_blankline)"],
    dj: ["U", "", "\"Paragraphs can never be interrupted\"; the list stays paragraph text"],
    myst: ["C", ""], mdoc: ["C", ""], mdx: ["C", ""] } },
  { g: "Block structure", f: "Lazy continuation lines", c: {
    cm: ["C", ""], gfm: ["C", ""], gh: ["C", ""], obs: ["C", ""], gl: ["C", ""], pd: ["C", ""],
    dj: ["C", "", "Kept for paragraphs; an indented \"- b\" right after \"- a\" is continuation, not a sublist"],
    myst: ["C", ""], mdoc: ["C", ""], mdx: ["R", "", "\"Unexpected lazy line in container\" error"] } },
  { g: "Block structure", f: "Thematic break", c: {
    cm: ["C", "---  ***  ___"], gfm: ["C", "---"], gh: ["C", "---"], obs: ["C", "---"], gl: ["C", "---"], pd: ["C", "---"],
    dj: ["C", "*** or - - -", "3+ characters; may be indented. --- inside text is an em dash"],
    myst: ["C", "---"], mdoc: ["C", "---"], mdx: ["C", "---"] } },
  { g: "Block structure", f: "Raw HTML block", c: {
    cm: ["C", "<div>…", "Seven kinds, each with its own end condition"], gfm: ["C", "<div>…", "Nine tags filtered (tagfilter)"],
    gh: ["C", "<div>…", "Sanitized"], obs: ["C", "<div>…", "Sanitized; must be complete, no blank lines inside"],
    gl: ["C", "<div>…"], pd: ["C", "<div>…"], dj: ["R", "``` =html", "Only through explicit raw blocks"],
    myst: ["Q", "", "Not established"], mdoc: ["Q", "", "Not established"], mdx: ["R", "<Component />", "Replaced by JSX"] } },
  { g: "Block structure", f: "Markdown inside an HTML block", c: {
    cm: ["U", "", "Literal until a blank line ends the HTML block"], gfm: ["U", ""], gh: ["U", ""],
    obs: ["U", "", "Never, by design (\"to keep parser complexity low\")"], gl: ["Q", ""],
    pd: ["C", "", "markdown_in_html_blocks: **x** between <div> tags is bold"],
    dj: ["U", "", "No HTML blocks; tags are literal text"], myst: ["Q", ""], mdoc: ["Q", ""],
    mdx: ["C", "<div>\\n**x**\\n</div>", "JSX children are parsed (not verified on MDX 3)"] } },
  { g: "Line breaks", f: "Hard break: two trailing spaces", c: {
    cm: ["C", "text␠␠"], gfm: ["C", "text␠␠"], gh: ["C", "text␠␠"], obs: ["C", "text␠␠"], gl: ["C", "text␠␠"], pd: ["C", "text␠␠"],
    dj: ["U", "", "Trailing spaces are a soft break"], myst: ["C", "text␠␠"], mdoc: ["Q", ""], mdx: ["Q", ""] } },
  { g: "Line breaks", f: "Hard break: backslash", c: {
    cm: ["C", "text\\"], gfm: ["C", "text\\"], gh: ["C", "text\\"], obs: ["Q", ""], gl: ["C", "text\\"], pd: ["C", "text\\", "escaped_line_breaks"],
    dj: ["C", "text\\", "The only hard break"], myst: ["C", "text\\"], mdoc: ["Q", ""], mdx: ["Q", ""] } },
  { g: "Line breaks", f: "Single newline renders as a break", c: {
    cm: ["U", "", "Soft break"], gfm: ["U", "", "Soft break"],
    gh: ["D", "", "Yes in issues, PRs and discussions; no in .md files"],
    obs: ["C", "", "Yes by default; the Strict line breaks setting turns it off"],
    gl: ["Q", ""], pd: ["E", "", "hard_line_breaks"], dj: ["U", ""], myst: ["U", ""], mdoc: ["Q", ""], mdx: ["U", ""] } },
  { g: "Inline core", f: "Emphasis", c: {
    cm: ["C", "*x*  _x_"], gfm: ["C", "*x*  _x_"], gh: ["C", "*x*  _x_"], obs: ["C", "*x*  _x_"], gl: ["C", "*x*  _x_"], pd: ["C", "*x*  _x_"],
    dj: ["C", "_x_", "*x* means strong in Djot"], myst: ["C", "*x*  _x_"], mdoc: ["C", "*x*  _x_"], mdx: ["C", "*x*  _x_"] } },
  { g: "Inline core", f: "Strong", c: {
    cm: ["C", "**x**  __x__"], gfm: ["C", "**x**"], gh: ["C", "**x**"], obs: ["C", "**x**  __x__"], gl: ["C", "**x**"], pd: ["C", "**x**"],
    dj: ["C", "*x*", "No doubling; **x** is strong inside strong"], myst: ["C", "**x**"], mdoc: ["C", "**x**"], mdx: ["C", "**x**"] } },
  { g: "Inline core", f: "Intraword _ emphasis (snake_case_word)", c: {
    cm: ["U", "", "Left literal"], gfm: ["U", ""], gh: ["U", ""], obs: ["U", ""], gl: ["U", ""], pd: ["U", "", "intraword_underscores"],
    dj: ["C", "snake<em>case</em>word", "Tested: _ opens and closes emphasis inside words"],
    myst: ["U", ""], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Inline core", f: "Code span", c: {
    cm: ["C", "`code`"], gfm: ["C", "`code`"], gh: ["C", "`code`", "Color swatches for hex/RGB in comments"], obs: ["C", "`code`"],
    gl: ["C", "`code`"], pd: ["C", "`code`{.lang}"], dj: ["C", "`code`", "No backtracking; unclosed span runs to end"],
    myst: ["C", "`code`"], mdoc: ["C", "`code`"], mdx: ["C", "`code`"] } },
  { g: "Inline core", f: "Inline link", c: {
    cm: ["C", "[t](url \"title\")"], gfm: ["C", "[t](url)"], gh: ["C", "[t](url)", "Relative links rewritten to the branch"], obs: ["C", "[t](url%20encoded)"],
    gl: ["C", "[t](url)"], pd: ["C", "[t](url){attrs}"], dj: ["C", "[t](url){title=\"…\"}", "No quoted titles; use attributes"],
    myst: ["C", "[t](url)  [](#label)"], mdoc: ["C", "[t](url)"], mdx: ["C", "[t](url)"] } },
  { g: "Inline core", f: "Reference link + definition", c: {
    cm: ["C", "[t][ref] … [ref]: url", "Resolves against definitions anywhere; case-insensitive"], gfm: ["C", ""], gh: ["C", ""], obs: ["C", ""], gl: ["C", ""], pd: ["C", ""],
    dj: ["C", "[t][ref]", "Recognized by shape; case-sensitive labels"], myst: ["C", ""], mdoc: ["C", ""], mdx: ["C", ""] } },
  { g: "Inline core", f: "Shortcut reference link", c: {
    cm: ["C", "[foo]"], gfm: ["C", "[foo]"], gh: ["C", "[foo]"], obs: ["Q", ""], gl: ["C", "[foo]"], pd: ["C", "[foo]"],
    dj: ["R", "", "Removed"], myst: ["C", "[foo]"], mdoc: ["C", "[foo]"], mdx: ["C", "[foo]"] } },
  { g: "Inline core", f: "Angle-bracket autolink", c: {
    cm: ["C", "<https://…>"], gfm: ["C", "<https://…>"], gh: ["C", "<https://…>"], obs: ["C", "<https://…>"], gl: ["C", "<https://…>"], pd: ["C", "<https://…>"],
    dj: ["Q", "", "Not covered by the research notes"], myst: ["C", "<https://…>"], mdoc: ["C", "<https://…>"],
    mdx: ["R", "", "Indistinguishable from JSX (e.g. <svg:rect>)"] } },
  { g: "Inline core", f: "Bare URL autolink", c: {
    cm: ["U", ""], gfm: ["C", "www.example.com", "Extended autolinks"], gh: ["C", "www.… / https://…"], obs: ["C", "https://…"],
    gl: ["C", "https://…"], pd: ["E", "", "autolink_bare_uris"], dj: ["Q", ""], myst: ["E", "", "linkify (myst-parser opt-in; prior knowledge)"],
    mdoc: ["Q", ""], mdx: ["E", "", "GFM plugin"] } },
  { g: "Inline core", f: "Image", c: {
    cm: ["C", "![alt](src)"], gfm: ["C", "![alt](src)"], gh: ["C", "![alt](src)"], obs: ["C", "![alt|100x145](src)", "Sizing in the alt text"],
    gl: ["C", "![alt](src)"], pd: ["C", "![alt](src){width=50%}", "Alone in a paragraph → figure"], dj: ["C", "![alt](src)"],
    myst: ["C", "![alt](src)"], mdoc: ["C", "![alt](src)"], mdx: ["C", "![alt](src)"] } },
  { g: "Inline core", f: "Inline raw HTML", c: {
    cm: ["C", "<b>x</b>"], gfm: ["C", "<b>x</b>"], gh: ["C", "<sub> <sup> <ins> <mark>…"], obs: ["C", "<b>x</b>"], gl: ["C", "<b>x</b>"],
    pd: ["C", "<b>x</b>"], dj: ["R", "`<b>`{=html}", "Only through explicit raw spans"], myst: ["Q", ""], mdoc: ["Q", ""],
    mdx: ["R", "<b>x</b> is JSX", "Bare < and { must be escaped in prose"] } },
  { g: "Inline core", f: "HTML entities", c: {
    cm: ["C", "&amp;  &#42;"], gfm: ["C", "&amp;"], gh: ["C", "&amp;"], obs: ["Q", ""], gl: ["C", "&amp;"], pd: ["C", "&amp;"],
    dj: ["U", "", "Not interpreted"], myst: ["C", "&amp;"], mdoc: ["Q", ""], mdx: ["Q", ""] } }
);

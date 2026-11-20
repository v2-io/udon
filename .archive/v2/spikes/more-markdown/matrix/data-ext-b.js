// Attributes & raw, linking & knowledge, metadata & comments, publishing, components & code.
MATRIX.rows.push(
  { g: "Attributes & raw", f: "Generic attributes", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", ""], obs: ["U", ""], gl: ["U", ""],
    pd: ["C", "{#id .class key=val}", "On headings, code, links, spans, divs; arbitrary elements get wrapped in Span/Div"],
    dj: ["C", "{#id .class key=val}", "On any element: right after an inline, on the line before a block; stackable"],
    myst: ["C", "{name #label .class key=\"v\"}", "Inline options; directive options as :key: lines or YAML"],
    mdoc: ["C", "{% #id .class key=1 %}", "Annotations attach to the preceding node; typed values"],
    mdx: ["U", "", "JSX props instead"] } },
  { g: "Attributes & raw", f: "Bracketed span", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", ""], obs: ["U", ""], gl: ["U", ""], pd: ["C", "[text]{.class}"], dj: ["C", "[text]{.class}"],
    myst: ["C", "{span .class}`text`", "Role syntax"], mdoc: ["U", "", "Inline {% tag %}"], mdx: ["U", "", "JSX"] } },
  { g: "Attributes & raw", f: "Heading identifier", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["D", "auto slug", "Lowercased, punctuation stripped, -1/-2 for duplicates"],
    obs: ["U", "", "Block IDs instead"], gl: ["D", "auto slug"], pd: ["C", "# H {#id}", "Plus auto identifiers"],
    dj: ["C", "{#id}\\n# H", "Attribute on the line before; auto IDs too"], myst: ["C", "(label)=\\n# H"],
    mdoc: ["C", "# H {% #id %}"], mdx: ["U", ""] } },
  { g: "Attributes & raw", f: "Raw passthrough by format", c: {
    cm: ["U", "", "HTML only"], gfm: ["U", ""], gh: ["U", ""], obs: ["U", ""], gl: ["U", ""],
    pd: ["C", "`x`{=html}  ```{=latex}", "raw_attribute; also raw HTML and TeX"], dj: ["C", "`x`{=html}  ``` =html", "The only raw path"],
    myst: ["Q", ""], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Linking & knowledge", f: "Wikilink", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", "", "Wikis aside"], obs: ["C", "[[Note|label]]", "Target first; #Heading and #^block suffixes"],
    gl: ["C", "[[label|slug]]", "Label first (wiki pages)"], pd: ["E", "[[a|b]]", "Either order, as two separate extensions"],
    dj: ["U", ""], myst: ["U", ""], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Linking & knowledge", f: "Embed / transclusion", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", ""], obs: ["C", "![[Note#^id]]  ![[img.png|100]]", "Notes, headings, blocks, PDF pages"],
    gl: ["C", "::include{file=x.md}", "Non-recursive"], pd: ["U", ""], dj: ["U", ""],
    myst: ["Q", "", "include directive (prior knowledge)"], mdoc: ["Q", "", "partials (prior knowledge)"], mdx: ["C", "import X from './x.mdx'"] } },
  { g: "Linking & knowledge", f: "Block identifier", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", ""], obs: ["C", "text ^block-id", "Latin letters, digits, dashes"], gl: ["U", ""],
    pd: ["U", ""], dj: ["U", "", "Attributes give any block an id"], myst: ["C", "(label)="], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Linking & knowledge", f: "Tags", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", "", "#123 is an issue reference"], obs: ["C", "#tag  #a/b", "At least one non-digit"],
    gl: ["U", "", "~label is a reference"], pd: ["U", ""], dj: ["U", ""], myst: ["U", ""], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Linking & knowledge", f: "Platform references", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["D", "@user  #123"], obs: ["U", ""], gl: ["C", "#123 !123 @user ~label %ms &epic"],
    pd: ["U", ""], dj: ["U", ""], myst: ["U", ""], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Linking & knowledge", f: "Implicit heading reference", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", "", "Link to #slug anchors instead"], obs: ["C", "[[#Heading]]"], gl: ["U", ""],
    pd: ["C", "[Heading][]", "implicit_header_references"], dj: ["C", "[Heading][]"], myst: ["C", "[](#label)"], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Linking & knowledge", f: "Citation", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", ""], obs: ["U", ""], gl: ["U", ""],
    pd: ["C", "[@doe99, p. 33]  @doe99", "Rendered by --citeproc with CSL styles"], dj: ["U", "", "No citation syntax"],
    myst: ["C", "@key  {cite}`key`"], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Linking & knowledge", f: "Numbered cross-reference", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", ""], obs: ["U", ""], gl: ["U", ""],
    pd: ["E", "", "Via filters (pandoc-crossref) or Quarto's @fig-x"], dj: ["U", ""],
    myst: ["C", "{numref}`Fig %s <label>`  @label"], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Metadata & comments", f: "Front matter", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["D", "--- yaml ---", "Rendered as a table (since 2013)"],
    obs: ["C", "--- yaml ---", "Typed \"properties\"; JSON accepted, saved as YAML"], gl: ["C", "---  +++  ;;;", "YAML, TOML or JSON"],
    pd: ["C", "--- yaml ---", "yaml_metadata_block; also % title block"], dj: ["U", ""],
    myst: ["C", "--- yaml ---"], mdoc: ["C", "--- yaml ---", "Read as $markdoc.frontmatter"], mdx: ["E", "", "frontmatter plugin; ESM export otherwise"] } },
  { g: "Metadata & comments", f: "Comment", c: {
    cm: ["C", "<!-- x -->", "An HTML comment"], gfm: ["C", "<!-- x -->"], gh: ["C", "<!-- x -->"], obs: ["C", "%%x%%", "Inline or block; HTML comments also work"],
    gl: ["C", "<!-- x -->"], pd: ["C", "<!-- x -->"], dj: ["C", "{% x %}", "An attribute holding only a comment"],
    myst: ["Q", ""], mdoc: ["E", "<!-- x -->", "Needs allowComments: true"], mdx: ["C", "{/* x */}", "HTML comments are a syntax error"] } },
  { g: "Publishing", f: "Diagram fence", c: {
    cm: ["U", "", "An ordinary code block"], gfm: ["U", ""], gh: ["D", "```mermaid  ```geojson  ```stl"], obs: ["C", "```mermaid"],
    gl: ["C", "```mermaid  ```plantuml"], pd: ["U", "", "An ordinary code block; filters can render it"], dj: ["U", ""],
    myst: ["Q", ""], mdoc: ["U", ""], mdx: ["U", "", "A component instead"] } },
  { g: "Publishing", f: "Table of contents marker", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", "", "Outline built by the UI"], obs: ["U", ""], gl: ["C", "[[_TOC_]]  [TOC]"],
    pd: ["U", "", "--toc option"], dj: ["U", ""], myst: ["Q", ""], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Components & code", f: "Named components / directives", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", ""], obs: ["U", ""], gl: ["U", ""], pd: ["U", "", "Lua filters act on divs and spans"],
    dj: ["U", "", "Filters act on classes and symbols"], myst: ["C", "```{directive}  {role}`x`", "Ported from reStructuredText"],
    mdoc: ["C", "{% tag %}…{% /tag %}", "Block when alone on a line, inline otherwise"], mdx: ["C", "<Component prop={x} />"] } },
  { g: "Components & code", f: "Variables / expressions", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", ""], obs: ["U", ""], gl: ["C", "%{placeholder}"], pd: ["U", ""], dj: ["U", ""],
    myst: ["Q", "", "substitution (prior knowledge)"], mdoc: ["C", "{% $var %}  {% if equals(a, b) %}"], mdx: ["C", "{1 + 1}", "Arbitrary JavaScript"] } },
  { g: "Components & code", f: "Module imports", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", ""], obs: ["U", ""], gl: ["U", ""], pd: ["U", ""], dj: ["U", ""], myst: ["U", ""], mdoc: ["U", ""],
    mdx: ["C", "import / export", "ESM"] } }
);

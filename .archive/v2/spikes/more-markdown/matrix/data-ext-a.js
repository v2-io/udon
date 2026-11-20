// Tables & lists, inline extensions, notes & math, callouts & containers.
MATRIX.rows.push(
  { g: "Tables & lists", f: "Pipe table", c: {
    cm: ["U", ""], gfm: ["C", "| a | b |\\n|---|---|", "Header and delimiter rows must have equal cell counts"], gh: ["C", "| a | b |"],
    obs: ["C", "| a | b |", "Escape wikilink pipes as \\|"], gl: ["C", "| a | b |", "Also ```json:table"],
    pd: ["C", "| a | b |", "Also simple, multiline and grid tables"], dj: ["C", "| a | b |", "Rows must start and end with |; inline-only cells; multiple header rows"],
    myst: ["C", "| a | b |"], mdoc: ["C", "| a | b |"], mdx: ["E", "| a | b |", "GFM plugin"] } },
  { g: "Tables & lists", f: "Table caption", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", ""], obs: ["U", ""], gl: ["U", ""], pd: ["C", "Table: caption"],
    dj: ["C", "^ caption"], myst: ["Q", "", "list-table / table directive (prior knowledge)"], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Tables & lists", f: "Task list item", c: {
    cm: ["U", ""], gfm: ["C", "- [ ] / - [x]"], gh: ["C", "- [ ]"], obs: ["C", "- [ ] / - [?]", "Any character marks completion"],
    gl: ["C", "- [ ] / - [~]", "[~] = inapplicable; also inside table cells"], pd: ["C", "- [ ]", "task_lists"], dj: ["C", "- [ ] / - [x]"],
    myst: ["E", "", "tasklist (myst-parser opt-in; prior knowledge)"], mdoc: ["Q", ""], mdx: ["E", "- [ ]", "GFM plugin"] } },
  { g: "Tables & lists", f: "Fancy list markers", c: {
    cm: ["U", "", "1. and 1) only"], gfm: ["U", ""], gh: ["U", ""], obs: ["U", ""], gl: ["U", ""],
    pd: ["C", "a.  i.  (1)  #.  (@)", "fancy_lists, example_lists"], dj: ["C", "a.  i.  (1)  A)", "18 marker types; changing style starts a new list"],
    myst: ["Q", ""], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Tables & lists", f: "Definition list", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", ""], obs: ["U", ""], gl: ["C", "term\\n: definition"],
    pd: ["C", "Term\\n:   definition"], dj: ["C", ": term\\n\\n  definition", "Marker on the term, definition indented"],
    myst: ["E", "", "deflist (prior knowledge)"], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Inline extensions", f: "Strikethrough", c: {
    cm: ["U", ""], gfm: ["C", "~~x~~", "Live spec also strikes ~x~; cmark-gfm's test file says two tildes"], gh: ["C", "~~x~~"],
    obs: ["C", "~~x~~"], gl: ["C", "~~x~~"], pd: ["C", "~~x~~", "strikeout"], dj: ["C", "{-x-}", "Braces mandatory"],
    myst: ["Q", ""], mdoc: ["C", "~~x~~"], mdx: ["E", "~~x~~", "GFM plugin"] } },
  { g: "Inline extensions", f: "Highlight", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", "<mark>", "HTML only"], obs: ["C", "==x==  ==🟣x==", "Color emoji since 1.14 (same as Bear)"],
    gl: ["Q", ""], pd: ["E", "==x==", "mark, off by default"], dj: ["C", "{=x=}", "Braces mandatory"],
    myst: ["Q", ""], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Inline extensions", f: "Insert / inline diff", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", "<ins>", "HTML only"], obs: ["U", ""], gl: ["C", "{+x+}  [-x-]", "Inline diff"],
    pd: ["U", "[x]{.underline}", "Underline via a span class"], dj: ["C", "{+x+}  {-x-}"], myst: ["U", ""], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Inline extensions", f: "Superscript / subscript", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", "<sup> <sub>", "HTML only"], obs: ["U", "", "HTML only"], gl: ["Q", ""],
    pd: ["C", "2^10^  H~2~O", "No spaces inside"], dj: ["C", "2^10^  H~2~O", "Spaces allowed with braces {~ ~}"],
    myst: ["Q", ""], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Inline extensions", f: "H~2~O (same input)", c: {
    cm: ["I", "literal"], gfm: ["I", "strikethrough (comrak) / literal (pandoc -f gfm)", "The two GFM spec texts disagree on single tildes"],
    gh: ["Q", "", "Not verified on github.com"], obs: ["I", "literal (~~ only)"], gl: ["Q", ""],
    pd: ["I", "subscript"], dj: ["I", "subscript"], myst: ["Q", ""], mdoc: ["Q", ""], mdx: ["Q", ""] } },
  { g: "Inline extensions", f: "Smart punctuation", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", ""], obs: ["U", ""], gl: ["U", ""], pd: ["C", "-- --- ... \"quotes\"", "smart"],
    dj: ["C", "-- --- ...  {\"", "Always on; {\" forces quote direction"], myst: ["E", "", "smartquotes (prior knowledge)"], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Inline extensions", f: "Emoji / symbol shortcodes", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["D", ":tada:"], obs: ["U", ""], gl: ["C", ":tada:", "Custom emoji too"],
    pd: ["E", ":tada:", "emoji"], dj: ["C", ":name:", "Left to the renderer; no built-in emoji"], myst: ["Q", ""], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Notes & math", f: "Footnote", c: {
    cm: ["U", ""], gfm: ["U", "", "Not in the spec"], gh: ["D", "[^1] … [^1]: text", "Since 2021; documented bugs"], obs: ["C", "[^1]"],
    gl: ["C", "[^1]"], pd: ["C", "[^1]"], dj: ["C", "[^1]", "Block content, indented"], myst: ["C", "[^1]"], mdoc: ["Q", ""], mdx: ["E", "[^1]", "GFM plugin"] } },
  { g: "Notes & math", f: "Inline footnote", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", ""], obs: ["C", "^[note]", "Reading view only, not Live Preview"], gl: ["U", ""],
    pd: ["C", "^[note]", "inline_notes"], dj: ["U", "", "^ is the superscript delimiter"], myst: ["Q", ""], mdoc: ["U", ""], mdx: ["U", ""] } },
  { g: "Notes & math", f: "Inline math", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["D", "$x$  $`x`$", "MathJax; undocumented delimiter rules"],
    obs: ["C", "$x$", "Pandoc's rule (observed in the app code)"], gl: ["C", "$x$  $`x`$", "KaTeX"],
    pd: ["C", "$x$", "No space inside the delimiters; no digit after the closing $"], dj: ["C", "$`x`", "A $-prefixed verbatim span"],
    myst: ["C", "$x$"], mdoc: ["U", ""], mdx: ["E", "$x$", "math plugin"] } },
  { g: "Notes & math", f: "Display math", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["D", "$$…$$  ```math"], obs: ["C", "$$…$$"], gl: ["C", "$$…$$  ```math"],
    pd: ["C", "$$…$$", "No blank lines inside"], dj: ["C", "$$`…`"], myst: ["C", "$$…$$  ```{math}"], mdoc: ["U", ""], mdx: ["E", "$$…$$", "math plugin"] } },
  { g: "Callouts & containers", f: "Blockquote callout", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["D", "> [!NOTE]", "5 types; no title, folding or nesting"],
    obs: ["C", "> [!tip]- Title", "13 types + aliases; titles, +/- folding, nesting; case-insensitive"],
    gl: ["C", "> [!warning] Title", "Lowercase and titles accepted"], pd: ["E", "> [!NOTE]", "alerts; default in commonmark_x only"],
    dj: ["U", "", "Use a ::: warning div"], myst: ["U", "", "Admonition directives instead"], mdoc: ["U", "", "Tags instead"], mdx: ["U", "", "Components instead"] } },
  { g: "Callouts & containers", f: "Fenced container (:::)", c: {
    cm: ["U", ""], gfm: ["U", ""], gh: ["U", ""], obs: ["U", ""], gl: ["U", ""],
    pd: ["C", "::: {#id .class}", "Attributes mandatory on the opener"], dj: ["C", "::: class", "One class word only; other attributes on the line before"],
    myst: ["C", ":::{note} args", "Names a directive, not a generic div"], mdoc: ["U", "", "{% tag %} instead"], mdx: ["U", "", "JSX instead"] } }
);

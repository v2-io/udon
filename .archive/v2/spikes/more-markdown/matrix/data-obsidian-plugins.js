// Obsidian community plugins: syntax that plugins add on top of Obsidian's core.
//
// Researched 2026-10-14 from each plugin's README (and, where the README was thin, its
// docs folder or source: List Callouts, Kanban, Iconize, Advanced Codeblock, Advanced Ruby,
// Charts, Templater, Tasks). Download counts come from obsidianmd/obsidian-releases
// community-plugin-stats.json fetched the same day; the registry then listed 8,965 plugins.
//
// How these rows use the format:
//   * Only the `obs` cell is filled. Every plugin cell is E (off by default, a named plugin),
//     which matches how the pd column marks pandoc extensions. Other columns are left out on
//     purpose, so they render as Q; the cross-dialect researcher owns them.
//   * `m` (optional) names an existing row whose obs cell this one would replace when merged.
//     Those existing obs cells are all U today, so nothing core is overwritten.
//   * `src` lists [plugin name, GitHub repo, downloads, registry id] for every plugin the
//     cell cites. "not listed" means the plugin is installable only through BRAT or by hand.
//   * Where several plugins offer the same feature, the syntax field shows each form separated
//     by two spaces and the note says which plugin owns which form.
//   * Some plugins act only while you type (smart typography, @-mention pickers, pipe tricks).
//     They leave ordinary text or links in the file and add no syntax; their notes say so.
//   * Fenced-block renderers (```chart, ```dataview, ```gloss …) are mostly left out, as Joseph
//     intended: an info string falls back to a plain code block everywhere, so it adds no
//     syntax. The few here carry a structure the matrix asked about. How common they are,
//     measured 2026-10-14 by searching the released main.js of 799 plugins for
//     registerMarkdownCodeBlockProcessor: 73 of the top 399 by downloads (18%; the top 400
//     account for 85% of all downloads) and 51 of 400 sampled at random from the rest (13%).
//     So it is a large minority, not the bulk. In that same scan, Markdown post-processors
//     (where most inline syntax lives) showed up in 17% and 8%.
//   * Several plugins claim the content of inline code spans (`[!!…]`, `sparkline: …`, `= …`,
//     `INPUT[…]`, `fas:…`, `class: …`). Notes mark this where it applies.
MATRIX.rows.push(

  // ---- Tables ----
  { g: "Tables & lists", f: "Table formulas", c: {
    obs: ["E", "<!-- TBLFM: @>$2=sum(@I..@-1) -->  | =SUM(B2:B4) |",
      "Advanced Tables (~3.3M): an org-mode-style formula in an HTML comment on the line after the table, evaluated on command. Power Tables (~3k): an Excel formula typed into the cell; the plugin stores the computed value in the cell and keeps the formula inside a <span class=\"ptb\"> wrapper. Advanced Tables' alignment, sorting and auto-formatting are editor commands that write ordinary GFM delimiter rows"] },
    src: [["Advanced Tables", "tgrosinger/advanced-tables-obsidian", 3280761, "table-editor-obsidian"],
          ["Power Tables", "obsidian-power-plugins/obsidian-power-tables", 3046, "powertables"]] },

  { g: "Tables & lists", f: "Table cell merge (colspan / rowspan)", c: {
    obs: ["E", "| a || (colspan)  ^^ (rowspan)  |  <  |  ^  |",
      "Table Extended (~74k): MultiMarkdown 6 rules, where an empty cell after || spans columns and ^^ merges with the cell above; the table needs a -tx- line above it unless the experimental native mode is on; incompatible with Advanced Tables' auto-format. Sheets Extended (~65k) and Structural Tables (~2.6k) share a different rule: a cell holding only < merges left and one holding only ^ merges up. Rich Table (~6k) records merges in YAML"] },
    src: [["Table Extended", "aidenlx/table-extended", 73711, "table-extended"],
          ["Sheets Extended", "NicoNekoru/obsidan-advanced-table-xt", 65162, "sheets"],
          ["Structural Tables", "ZHYX91/obsidian-structural-tables", 2602, "structural-tables"],
          ["Rich Table", "SdKay/obsidian-rich-table", 6204, "rich-table"]] },

  { g: "Tables & lists", f: "Multiple header rows / headerless table", c: {
    obs: ["E", "|  | Grouping ||\\nH1 | H2 | H3 |\\n---|:-:|--:|  |--|--|",
      "Table Extended: several header rows above the delimiter row; a table that starts with a delimiter row has no header (both only in -tx- tables, not the native mode). Structural Tables also supports multi-row column headers and headerless tables"] },
    src: [["Table Extended", "aidenlx/table-extended", 73711, "table-extended"],
          ["Structural Tables", "ZHYX91/obsidian-structural-tables", 2602, "structural-tables"]] },

  { g: "Tables & lists", f: "Row-header column (vertical headers)", c: {
    obs: ["E", "| I | - | a |  |---|---||---|",
      "Sheets Extended: a column whose cells contain only dashes makes the columns to its left headers, mirroring the delimiter row. Structural Tables: a || in the delimiter row marks the columns to its left as row headers"] },
    src: [["Sheets Extended", "NicoNekoru/obsidan-advanced-table-xt", 65162, "sheets"],
          ["Structural Tables", "ZHYX91/obsidian-structural-tables", 2602, "structural-tables"]] },

  { g: "Tables & lists", f: "Table caption", m: "Table caption", c: {
    obs: ["E", "[Prototype table]  title: …",
      "Table Extended: a [caption] line right after a -tx- table (MultiMarkdown 6). Rich Table: title: and footer: keys in its YAML"] },
    src: [["Table Extended", "aidenlx/table-extended", 73711, "table-extended"],
          ["Rich Table", "SdKay/obsidian-rich-table", 6204, "rich-table"]] },

  { g: "Tables & lists", f: "Multi-line / block content in a table cell", c: {
    obs: ["E", "| - Item 1 | \\\\n| - Item 2 |  c: |-\\n  - a\\n  - b",
      "Table Extended: a trailing backslash joins a row to the next source line, so a cell can hold lists or a code fence. Rich Table: a cell is a YAML block scalar holding full Markdown (it also accepts <br>). Table Line Break Mobile (~3k) only adds a command that inserts <br>; its README says Shift+Enter does the same with a hardware keyboard. No plugin found lets a plain pipe-table cell span lines without a marker"] },
    src: [["Table Extended", "aidenlx/table-extended", 73711, "table-extended"],
          ["Rich Table", "SdKay/obsidian-rich-table", 6204, "rich-table"],
          ["Table Line Break Mobile", "marcelflymark/new-line-break-inside-table-cell", 3108, "table-line-break"]] },

  { g: "Tables & lists", f: "Checkboxes in table cells", c: {
    obs: ["E", "| [ ] | [x] [ ] |",
      "Table Checkbox Renderer (~15k): makes [ ] and [x] in cells clickable in Reading view and writes the change back to the source; several per cell allowed"] },
    src: [["Table Checkbox Renderer", "dannns/obsidian-table-checkbox-renderer", 15249, "table-checkbox-renderer"]] },

  { g: "Tables & lists", f: "Per-cell classes and styles", c: {
    obs: ["E", "| bar ~ .c1 .c2 |  | x ~ { \"text-align\": \"right\" } |",
      "Sheets Extended: a ~ inside a cell separates the content from classes or inline CSS; the classes are defined in a JSON5 block above a --- line inside a sheet fence. Power Tables (~3k) stores fills and colors as an inline <span class=\"ptb\" style=…> around the cell content"] },
    src: [["Sheets Extended", "NicoNekoru/obsidan-advanced-table-xt", 65162, "sheets"],
          ["Power Tables", "obsidian-power-plugins/obsidian-power-tables", 3046, "powertables"]] },

  { g: "Tables & lists", f: "Table written as a fenced data block", c: {
    obs: ["E", "```rich-table\\n---\\ncolumns: …\\nrows: …\\n---  ```sheet",
      "Rich Table: the whole table is YAML inside a fence (typed columns, merges, styles); its README says it is edited only through the UI. Sheets Extended: a pipe table inside a sheet fence with a style block above it"] },
    src: [["Rich Table", "SdKay/obsidian-rich-table", 6204, "rich-table"],
          ["Sheets Extended", "NicoNekoru/obsidan-advanced-table-xt", 65162, "sheets"]] },

  { g: "Tables & lists", f: "Decimal-point column alignment", c: {
    obs: ["U", "",
      "Not found. A keyword search of the 8,965-entry registry for decimal and align turned up nothing, and Advanced Tables, Rich Table, Structural Tables and Power Tables document only left, center and right alignment"] },
    src: [] },

  // ---- Lists ----
  { g: "Tables & lists", f: "Fancy list markers", m: "Fancy list markers", c: {
    obs: ["E", "A.  a)  iv.  #.   + (square)  * (hollow)",
      "Pandoc Extended Markdown (~8k): Pandoc's letter, Roman and #. auto-numbered markers in Live Preview and Reading view. It also gives -, + and * three different bullet shapes. A setting maps to Pandoc's lists_without_preceding_blankline"] },
    src: [["Pandoc Extended Markdown", "ErrorTzy/obsidian-pandoc-extended-markdown", 7996, "pandoc-extended-markdown"]] },

  { g: "Tables & lists", f: "Example list (@)", c: {
    obs: ["E", "(@) text  (@intro) text … see (@intro)",
      "Pandoc Extended Markdown: Pandoc's example lists, numbered continuously through the note, with references resolved"] },
    src: [["Pandoc Extended Markdown", "ErrorTzy/obsidian-pandoc-extended-markdown", 7996, "pandoc-extended-markdown"]] },

  { g: "Tables & lists", f: "Custom-label list items", c: {
    obs: ["E", "{::P} Premise  {::Q(#step)} …  see {::P}",
      "Pandoc Extended Markdown's own extension, not Pandoc's: items with arbitrary labels, placeholder numbering and references. It ships Lua filters so Pandoc export gets the same result"] },
    src: [["Pandoc Extended Markdown", "ErrorTzy/obsidian-pandoc-extended-markdown", 7996, "pandoc-extended-markdown"]] },

  { g: "Tables & lists", f: "Definition list", m: "Definition list", c: {
    obs: ["E", "Term\\n: definition  Term\\n~ definition",
      "Definition List (~4k): markdownguide-style lists, plus Pandoc's ~ marker and two-space indent; no multi-paragraph definitions or nested lists. Pandoc Extended Markdown also renders Pandoc definition lists"] },
    src: [["Definition List", "shammond42/definition-list", 3996, "definition-list"],
          ["Pandoc Extended Markdown", "ErrorTzy/obsidian-pandoc-extended-markdown", 7996, "pandoc-extended-markdown"]] },

  { g: "Tables & lists", f: "List-item callouts", c: {
    obs: ["E", "- & text  - ? text  - ! text  - ~ @ $ %",
      "List Callouts (~141k): a configurable character after the list marker (defaults & ? ! ~ @ $ %, each with a color, optionally an icon) turns the item into a colored callout. Works after ordered markers and task boxes too"] },
    src: [["List Callouts", "mgmeyers/obsidian-list-callouts", 140743, "obsidian-list-callouts"]] },

  { g: "Tables & lists", f: "Key-value list", c: {
    obs: ["E", "- First name: Donald\\n- Total;:; 100",
      "Key-Value List (~7k): a list where every item, at every level, contains the delimiter (default :) is laid out as aligned key and value columns. ; before or after the delimiter in the first row right-aligns that column. Controlled per note with cssclasses"] },
    src: [["Key-Value List", "christianwannerstedt/obsidian-key-value-list", 6725, "key-value-list"]] },

  { g: "Tables & lists", f: "Custom task statuses", c: {
    obs: ["E", "- [/]  - [-]  - [>]  - [<]  - [?]  - [!]  - [*]  - [i]  - [I]  - [p]  - [c] …",
      "Core Obsidian already accepts any character in the box (see Task list item). Themes such as Minimal draw distinct icons for about 22 characters; the Tasks plugin (~4.4M) gives each character a status type (TODO, IN_PROGRESS, DONE, CANCELLED) and a next status, and ships presets for each theme"] },
    src: [["Tasks", "obsidian-tasks-group/obsidian-tasks", 4419045, "obsidian-tasks-plugin"]] },

  { g: "Tables & lists", f: "Task metadata (dates, priority, recurrence)", c: {
    obs: ["E", "📅 2023-04-16  ⏳ 🛫 ➕ ✅ ❌  ⏫ 🔼 🔽 ⏬ 🔺  🔁 every day  🆔 x ⛔ x  [due:: 2023-04-16]",
      "Tasks: emoji signifiers at the end of a task line set due, scheduled, start, created, done and cancelled dates, priority, recurrence, dependencies and on-completion behavior. It also reads Dataview-style [key:: value] fields"] },
    src: [["Tasks", "obsidian-tasks-group/obsidian-tasks", 4419045, "obsidian-tasks-plugin"],
          ["Dataview", "blacksmithgu/obsidian-dataview", 5143170, "dataview"]] },

  { g: "Tables & lists", f: "Kanban board from headings and lists", c: {
    obs: ["E", "kanban-plugin: board\\n## Lane\\n- [ ] card\\n%% kanban:settings … %%",
      "Kanban (~2.8M): a note whose front matter has kanban-plugin is shown as a board, with ## headings as lanes and task items as cards; board settings are stored in a %% comment at the end of the note"] },
    src: [["Kanban", "mgmeyers/obsidian-kanban", 2751858, "obsidian-kanban"]] },

  // ---- Inline ----
  { g: "Inline extensions", f: "Insert / inline diff", m: "Insert / inline diff", c: {
    obs: ["E", "++x++  <u>x</u>",
      "Extended Markdown Syntax (~10k): ++x++ (exactly two plus signs, no space inside) renders as <ins>, underlined. Underline (~69k) only binds a hotkey that writes HTML <u>…</u>. See also the CriticMarkup row for {++x++}"] },
    src: [["Extended Markdown Syntax", "kotaindah55/extended-markdown-syntax", 10347, "extended-markdown-syntax"],
          ["Underline", "benature/obsidian-underline", 69423, "obsidian-underline"]] },

  { g: "Inline extensions", f: "Superscript / subscript", m: "Superscript / subscript", c: {
    obs: ["E", "2^10^  H~2~O",
      "Extended Markdown Syntax and Pandoc Extended Markdown both use Pandoc's single ^ and ~ with no whitespace inside. Built-in Obsidian syntax wins conflicts, so ~~x~~ stays strikethrough. With either plugin on, H~2~O renders as a subscript (the H~2~O row has Obsidian as literal)"] },
    src: [["Extended Markdown Syntax", "kotaindah55/extended-markdown-syntax", 10347, "extended-markdown-syntax"],
          ["Pandoc Extended Markdown", "ErrorTzy/obsidian-pandoc-extended-markdown", 7996, "pandoc-extended-markdown"]] },

  { g: "Inline extensions", f: "Highlight color", c: {
    obs: ["E", "=={red}x==  <mark class=\"hltr-red\">",
      "Extended Markdown Syntax: a {tag} right after == becomes a highlight class (letters, digits and hyphens only). Highlightr (~737k) is a menu that writes HTML <mark> with inline style or an hltr- class. The Highlight row records a core ==🟣x== emoji form, which this research did not check"] },
    src: [["Extended Markdown Syntax", "kotaindah55/extended-markdown-syntax", 10347, "extended-markdown-syntax"],
          ["Highlightr", "chetachiezikeuzor/Highlightr-Plugin", 737128, "highlightr-plugin"]] },

  { g: "Inline extensions", f: "Text color", c: {
    obs: ["E", "~={id} text=~  $red text  $#ff5500 text",
      "Fast Text Color (~91k): ~={id}…=~, where the id names a style in a theme (color, bold, italic, under/over/strike lines, caps, small caps). Text Color Tags (~1k): $name or $hex before the text; its README shows only whole-line examples, so where the color ends was not established"] },
    src: [["Fast Text Color", "Superschnizel/obsidian-fast-text-color", 91454, "fast-text-color"],
          ["Text Color Tags", "psyda/obsidian-text-color-tags", 1047, "text-color-tags"]] },

  { g: "Inline extensions", f: "Spoiler / redaction", c: {
    obs: ["E", "||x||  `~{x}`  `~[x]`  ```spoiler-block",
      "Discord-style ||x|| from Extended Markdown Syntax, Inline Spoilers (~14k) and Discord Syntax (~1k). Blur (~8k) uses inline code: ~{x} blurs, ~[x] replaces the text with █ blocks. Spoiler Block (~12k) is a plain-text fence"] },
    src: [["Extended Markdown Syntax", "kotaindah55/extended-markdown-syntax", 10347, "extended-markdown-syntax"],
          ["Inline spoilers", "logonoff/obsidian-inline-spoilers", 14288, "inline-spoilers"],
          ["Discord Syntax", "edems-dev/md-discord-syntax", 970, "md-discord-syntax"],
          ["Blur", "gapmiss/blur", 8374, "blur"],
          ["Spoiler Block", "alljavi/spoiler-block-obsidian", 12255, "spoiler-block-obsidian"]] },

  { g: "Inline extensions", f: "Subtext line", c: {
    obs: ["E", "-# subtext", "Discord Syntax: a line starting with -# renders small and muted (Discord's subtext)"] },
    src: [["Discord Syntax", "edems-dev/md-discord-syntax", 970, "md-discord-syntax"]] },

  { g: "Inline extensions", f: "Small caps / run-in / drop cap", c: {
    obs: ["E", "^^Opening words^^  &&run-in&&  @@字@@",
      "Tufte Suite (~2k), Inline module: ^^…^^ small-caps opener, &&…&& italic run-in, @@…@@ two-line CJK drop cap. Dormant unless the Tufte theme is active"] },
    src: [["Tufte Suite", "PleiadesM/tufte-suite", 1897, "tufte-suite"]] },

  { g: "Inline extensions", f: "Smart punctuation", m: "Smart punctuation", c: {
    obs: ["E", "-- --- ... \"\" ''",
      "Smart Punctuation on Rendering (~300) converts these in Reading view only, by regex over the rendered HTML, so backslash escapes cannot stop it. Smart Typography (~174k) and Typographer (~3k) convert them as you type, so the file stores the Unicode characters and no syntax remains"] },
    src: [["Smart Punctuation on Rendering", "ile-24556/obsidian-plugin-smart-punctuation-on-rendering", 281, "smart-punctuation-on-rendering"],
          ["Smart Typography", "mgmeyers/obsidian-smart-typography", 173655, "obsidian-smart-typography"],
          ["Typographer", "coignard/obsidian-typographer", 3097, "typographer"]] },

  { g: "Inline extensions", f: "Arrow and symbol substitution", c: {
    obs: ["E", "-> <- <-> <=> => <= >= +- -+  << >> /= 1/2",
      "Only as you type. Symbols Prettifier (~51k): → ← ↔ ⇔ ⇒ ⇐ ≤ ≥ ± ∓ (it maps =< to ≤ and <= to ⇐). Smart Typography: → ← « » ≤ ≥ ≠ and Unicode fractions. Typographer: user-defined replacement rules. The file keeps the Unicode characters"] },
    src: [["Symbols Prettifier", "FlorianWoelki/obsidian-symbols-prettifier", 50901, "symbols-prettifier"],
          ["Smart Typography", "mgmeyers/obsidian-smart-typography", 173655, "obsidian-smart-typography"],
          ["Typographer", "coignard/obsidian-typographer", 3097, "typographer"]] },

  { g: "Inline extensions", f: "Emoji / symbol shortcodes", m: "Emoji / symbol shortcodes", c: {
    obs: ["E", ":joy:  :book  :LiHeart:",
      "Emoji Shortcodes (~143k) renders Slack- and Discord-style :joy: shortcodes (its registry description says \"just like in Slack or Discord\"). Icon Shortcodes (~63k) opens a picker on : and by default inserts the emoji character, not the shortcode. Its custom icon packs come closest to Slack's custom emoji: the pack name prefixes each icon's shortcode, though the README doesn't give the joined form. Iconize (~2.3M, now deprecated) renders :PrefixName: icons from installed or custom SVG packs (Li = Lucide)"] },
    src: [["Emoji Shortcodes", "phibr0/obsidian-emoji-shortcodes", 143435, "emoji-shortcodes"],
          ["Icon Shortcodes", "aidenlx/obsidian-icon-shortcodes", 63257, "obsidian-icon-shortcodes"],
          ["Iconize", "FlorianWoelki/obsidian-iconize", 2266714, "obsidian-icon-folder"]] },

  { g: "Inline extensions", f: "Inline icons", c: {
    obs: ["E", ":LiAlarmClock:  `fas:heart`  `[!!rocket]`",
      "Iconize: a pack prefix plus a PascalCase name between colons (the colon is configurable). Icons (~110k): inline code starting fas:, far:, ris: or rir: (Font Awesome, Remix). Inline Callouts (~11k): `[!!ICON|LABEL|COLOR]` with any Lucide name. Two of the three take over inline code"] },
    src: [["Iconize", "FlorianWoelki/obsidian-iconize", 2266714, "obsidian-icon-folder"],
          ["Icons", "visini/obsidian-icons-plugin", 110375, "obsidian-icons-plugin"],
          ["Inline Callouts", "gapmiss/inline-callouts", 11370, "inline-callouts"]] },

  { g: "Inline extensions", f: "Inline badges / inline callouts", c: {
    obs: ["E", "`[!!note:text]`  `[!!|ghb>release:1.2.1]`  `[!!|dice|roll:11|120,82,238]`  `[!!info:Docs>>[[Note]]]`",
      "Badges (~16k): inline code starting [!! with a type or Lucide icon, label, optional RGB color, and an optional >> link; pipes need \\| inside tables. Inline Callouts is its successor. Inline Admonitions (~18k) styles any inline code that matches a prefix, suffix, substring or regex set in plugin settings, so the trigger lives outside the file"] },
    src: [["Badges", "gapmiss/badges", 16324, "badges"],
          ["Inline Callouts", "gapmiss/inline-callouts", 11370, "inline-callouts"],
          ["Inline Admonitions", "scottTomaszewski/obsidian-inline-admonitions", 18401, "inline-admonitions"]] },

  { g: "Inline extensions", f: "Ruby / furigana", c: {
    obs: ["E", "{漢字|かんじ}  {漢字|かん|じ}",
      "Markdown Furigana (~18k), using markdown-it-ruby syntax: one reading for the whole base, or one per character. Advanced Ruby (~3k) uses the same {base|ruby} form, adds a second annotation layer, and converts to and from HTML <ruby>"] },
    src: [["Markdown Furigana", "steven-kraft/obsidian-markdown-furigana", 18139, "obsidian-markdown-furigana"],
          ["Advanced Ruby", "peter-yanase/obsidian-advanced-ruby", 2550, "advanced-ruby"]] },

  { g: "Inline extensions", f: "Inline annotation / tooltip", c: {
    obs: ["E", "{locked chest::DC 15}  [Hello]{This is a tooltip}",
      "Inline Annotations (~1k): {text::note}, with the note shown on click or hover; skipped in code, so std::vector is safe. Hover Reveal (~5k): [text]{tooltip}, which is the same shape as the Pandoc and Djot bracketed span [text]{.class}"] },
    src: [["Inline Annotations", "cetrodk/obsidian-inline-annotations", 1270, "inline-annotations"],
          ["Hover Reveal", "asrieal/HoverReveal", 5409, "hover-reveal"]] },

  { g: "Inline extensions", f: "Inline code language tag", c: {
    obs: ["E", "`{python} x if y else z`  `{}{literal}`",
      "Code Styler (~243k): a {language} prefix syntax-highlights inline code; an empty {} prefix escapes it"] },
    src: [["Code Styler", "mayurankv/Obsidian-Code-Styler", 242891, "code-styler"]] },

  { g: "Inline extensions", f: "Sparkline", c: {
    obs: ["E", "`sparkline: [1 2 3 4 5] color=\"green\" width=150`  `sparkline: [@stats]`  =SPARKLINE(B2:G2)",
      "Sparklines (~900): inline code rendered as an inline SVG line, with literal numbers or a front matter key, gaps written as none, and stroke options. Power Tables: a table formula that writes block characters as plain text into the cell, so it reads the same without the plugin"] },
    src: [["Sparklines", "deeplook/obsidian-sparklines", 875, "sparklines"],
          ["Power Tables", "obsidian-power-plugins/obsidian-power-tables", 3046, "powertables"]] },

  // ---- Notes ----
  { g: "Notes & math", f: "Sidenotes / margin notes", c: {
    obs: ["E", "[^1]  [^mn-1]  [^3-r]  > [!sidenote]  %%> cue %%  [mn: note]",
      "Side-Notes (~10k): ordinary footnotes (or <span class=\"sidenote\">) shown in the margin; an mn- prefix makes an unnumbered margin note and -r or -l picks the side. Tufte Suite: footnotes plus [!sidenote] and [!marginnote] callouts. Cornell Marginalia (~36k): %%> cue %% in the margin, %%< for the opposite margin, ? ! X- V- prefixes for color, and > [!cornell] or a cornell fence to group. Margin Notes (~1k): [mn: …] and [mn.type: …]"] },
    src: [["Side-Notes", "cparsell/sidenotes", 9706, "side-notes"],
          ["Tufte Suite", "PleiadesM/tufte-suite", 1897, "tufte-suite"],
          ["Cornell Marginalia", "latazadehomero/cornell-marginalia", 36464, "cornell-marginalia"],
          ["Margin Notes", "writing-editor/margin-notes", 934, "margin-notes"]] },

  { g: "Notes & math", f: "Interlinear gloss", c: {
    obs: ["E", "```gloss\\n\\gla Péter-nek van\\n\\glb Peter-DAT exist\\n\\ft Peter has a cat.  ```ngloss\\n\\gl János [John:NOM]",
      "Interlinear Glossing (~6k): gloss fences take parallel \\gla, \\glb and \\glc lines (aligned word by word, [ ] grouping), plus \\ex source line, \\ft free translation, \\num, \\lbl, \\src and \\set options. ngloss writes each word followed by its glosses in brackets, any number of levels"] },
    src: [["Interlinear Glossing", "Mijyuoon/obsidian-ling-gloss", 6428, "ling-gloss"]] },

  // ---- Containers ----
  { g: "Callouts & containers", f: "Admonition fence", c: {
    obs: ["E", "```ad-tip\\ntitle: …\\ncollapse: open\\nicon: …\\ncolor: 255, 0, 0\\n…",
      "Admonition (~1M): a fence named ad-<type> with option lines at the top, nested by using more backticks. It also defines custom types usable in core > [!type] callouts, and documents > [!note|meta] for callout metadata"] },
    src: [["Admonition", "ebullient/obsidian-admonition", 996299, "obsidian-admonition"]] },

  { g: "Callouts & containers", f: "Fenced container (:::)", m: "Fenced container (:::)", c: {
    obs: ["E", "::: cls1 cls2\\ntext  ::: {.theorem #thm title=\"Theorem &\"}\\n…\\n:::",
      "Extended Markdown Syntax: ::: plus class words, and the div ends at the first blank line, so a closing ::: does nothing (unlike Pandoc). Pandoc Extended Markdown: Pandoc fenced divs with titles, & numbering and @id references, plus a shorthand ::: theorem &.& #id. Multi-Column Markdown also takes ::::: {.columns id=X}"] },
    src: [["Extended Markdown Syntax", "kotaindah55/extended-markdown-syntax", 10347, "extended-markdown-syntax"],
          ["Pandoc Extended Markdown", "ErrorTzy/obsidian-pandoc-extended-markdown", 7996, "pandoc-extended-markdown"],
          ["Multi-Column Markdown", "ckRobinson/multi-column-markdown", 222230, "multi-column-markdown"]] },

  { g: "Callouts & containers", f: "Multi-column layout", c: {
    obs: ["E", "%% col-start %%\\n%% col-break:40 %%\\n…\\n%% col-end %%  --- start-multi-column: ID  > [!col]\\n> > [!col-md-2]  ```col",
      "Advanced Multi Column (~21k): markers in comments, with width and style tokens (b: bc: t: sb:), nesting, and a !tip: Title column header. Multi-Column Markdown (~222k): --- start-multi-column: ID with a column-settings fence, --- end-column ---, --- end-multi-column. Columns (~93k): [!col] and [!col-md-N] callouts, or col and col-md fences with settings above a === line"] },
    src: [["Advanced Multi Column", "amatya-aditya/advanced-multi-column", 20672, "advanced-multi-column"],
          ["Multi-Column Markdown", "ckRobinson/multi-column-markdown", 222230, "multi-column-markdown"],
          ["Columns", "tnichols217/obsidian-columns", 93183, "obsidian-columns"]] },

  { g: "Callouts & containers", f: "Side brace grouping", c: {
    obs: ["E", "> [!brace] Label\\n> line 1\\n> line 2  > [!brace-left]",
      "SideBrace (~700): a large curly brace beside the lines, with the callout title as its label. Without the plugin it shows as an ordinary callout"] },
    src: [["SideBrace", "realhenrylo/obsidian-sidebrace", 733, "sidebrace"]] },

  // ---- Attributes ----
  { g: "Attributes & raw", f: "Generic attributes", m: "Generic attributes", c: {
    obs: ["E", "text { .cls }  # H { id=x }  `class: fancy-list`",
      "Markdown Attributes (~25k, maintenance mode): Pandoc-style {…} at the end of paragraphs, headings, list items, table cells, links, code blocks, quotes and callouts. Custom Classes (~10k): inline code class: x on the line before a block, or inside an element, adds an HTML class"] },
    src: [["Markdown Attributes", "javalent/markdown-attributes", 25246, "markdown-attributes"],
          ["Custom Classes", "lilaRest/obsidian-custom-classes", 10385, "custom-classes"]] },

  { g: "Attributes & raw", f: "Bracketed span", m: "Bracketed span", c: {
    obs: ["E", "!!{my-class other}text!!",
      "Extended Markdown Syntax: a custom span, with classes from letters, digits, hyphens and spaces. Hover Reveal's [text]{tooltip} has the bracketed-span shape with a different meaning (see Inline annotation)"] },
    src: [["Extended Markdown Syntax", "kotaindah55/extended-markdown-syntax", 10347, "extended-markdown-syntax"]] },

  // ---- Linking & knowledge ----
  { g: "Linking & knowledge", f: "@-mention", c: {
    obs: ["E", "@name  → [[@Rich Hickey]] / [@evan](evan.md)",
      "Simple Mention (~7k) is the only one found where @name itself is the syntax: it is highlighted, suggested and indexed (the prefix is configurable). Symbol linking (~5k; successor of @ Symbol Linking) and Mention Things (~1.5k) open a note picker when you type @ (or another symbol) and write an ordinary wikilink or Markdown link"] },
    src: [["Simple Mention", "der-tobi/obsidian-simple-mention", 6594, "obsidian-simple-mention"],
          ["Symbol linking", "mara-li/obsidian-symbol-linking", 5046, "symbol-linking"],
          ["Mention Things", "stracker-phil/obsidian-mention-things", 1477, "mention-things"]] },

  { g: "Linking & knowledge", f: "Wikilink pipe trick", c: {
    obs: ["E", "[[Pipe (computing)|]] → [[Pipe (computing)|Pipe]]  [[X|_|]]",
      "Pipe Tricks (not listed; unmaintained since 2023): MediaWiki's pipe trick, expanded as you type, plus pipe functions (_ lower, ^ upper-first, # title case). Nothing remains in the file but an ordinary aliased wikilink"] },
    src: [["Pipe Tricks", "marcusolsson/obsidian-pipe-tricks", null, "not listed"]] },

  { g: "Linking & knowledge", f: "Image caption and alignment", c: {
    obs: ["E", "![[img.jpg|Caption|center|150]]  ![Caption|150](img.jpg)  <<Wikilink>>",
      "Image Captions (~66k): the alt or embed text becomes a <figure> caption, with Markdown allowed; left, right and center keywords; <<…>> stands for a wikilink inside a caption; % uses the file name. The |150 width is core Obsidian syntax"] },
    src: [["Image Captions", "alangrainger/obsidian-image-captions", 66179, "image-captions"]] },

  { g: "Linking & knowledge", f: "Line import (@import)", c: {
    obs: ["E", "@import \"path/file.go\" {line_begin=4 line_end=14}",
      "Code Import (~250): Markdown Preview Enhanced's @import line, with line ranges (0-based by default, 1-based in settings), rendered as a highlighted code block. It handles code files only; core ![[Note]] embeds cover notes. No plugin found imports a note through @path the way CLAUDE.md does"] },
    src: [["Code Import", "yhao3/obsidian-code-import", 253, "code-import"]] },

  { g: "Linking & knowledge", f: "Ranged / attributed embed", c: {
    obs: ["E", "```quoth\\npath: [[File#Heading]]\\nranges: \"Hello \" to \"world.\"\\nshow: author, title\\ndisplay: inline",
      "Quoth (~8k): embeds part of a block, or several parts joined, inline or as a block, and can print the source's author and title. This is the closest thing found to a quoted, attributed citation that is not a footnote"] },
    src: [["Quoth", "erykwalder/quoth", 7589, "quoth"]] },

  { g: "Linking & knowledge", f: "Citation", m: "Citation", c: {
    obs: ["E", "[@doe99]  @doe99",
      "Citations (~239k) and Zotero Integration (~583k) insert Pandoc citations from a .bib or CSL-JSON file; the format is configurable. Pandoc Reference List (~89k) renders each citekey's formatted reference in a sidebar using Pandoc and a CSL style. None of the READMEs says the citekey is rendered in the note body"] },
    src: [["Citations", "hans/obsidian-citation-plugin", 238760, "obsidian-citation-plugin"],
          ["Zotero Integration", "obsidian-community/obsidian-zotero-integration", 583443, "obsidian-zotero-desktop-connector"],
          ["Pandoc Reference List", "obsidian-community/obsidian-pandoc-reference-list", 89399, "obsidian-pandoc-reference-list"]] },

  { g: "Linking & knowledge", f: "Numbered cross-reference", m: "Numbered cross-reference", c: {
    obs: ["E", "(@intro)  @thm  {::P}",
      "Pandoc Extended Markdown resolves example, fenced-div and custom-label references within the note. The Tufte Suite Figures module numbers figures with clickable references, but its README gives no syntax"] },
    src: [["Pandoc Extended Markdown", "ErrorTzy/obsidian-pandoc-extended-markdown", 7996, "pandoc-extended-markdown"]] },

  { g: "Linking & knowledge", f: "Abbreviation / acronym", c: {
    obs: ["E", "*[HTML]: HyperText Markup Language  abbr:\\n  - CSS: Cascading Style Sheets",
      "Abbreviations and Acronyms (~5k): PHP Markdown Extra definitions (an opt-in setting) or an abbr front matter list; matches render as <abbr title>. A later definition overrides an earlier one from its position on, and an empty one turns the abbreviation off"] },
    src: [["Abbreviations and Acronyms", "dragonish/obsidian-abbreviations", 4526, "abbreviations-mark"]] },

  { g: "Linking & knowledge", f: "Defined terms / glossary", c: {
    obs: ["E", "# Phrase\\n*alias*\\ndefinition\\n---",
      "Note Definitions (~30k): there is no syntax at the point of use. Terms are defined in files marked def-type: consolidated (# phrase, optional *alias* line, body, --- divider, %%END%% hides notes after it) or def-type: atomic, and matching words in any note are underlined with a hover definition"] },
    src: [["Note Definitions", "dominiclet/obsidian-note-definitions", 29612, "note-definitions"]] },

  // ---- Metadata ----
  { g: "Metadata & comments", f: "Inline fields", c: {
    obs: ["E", "Key:: value  [key:: value]  (key:: value)",
      "Dataview (~5.1M): a whole line, or bracketed fields anywhere in text; in the parenthesized form the key is hidden when rendered. Tasks and Better Inline Fields read the same syntax"] },
    src: [["Dataview", "blacksmithgu/obsidian-dataview", 5143170, "dataview"]] },

  { g: "Metadata & comments", f: "CriticMarkup", c: {
    obs: ["E", "{++add++}  {--del--}  {~~old~>new~~}  {>>comment<<}  {==mark==}  {=+ai+=}",
      "Track Changes (~3k): all five CriticMarkup forms, with accept or reject from a side panel, threaded comments from adjacent {>>…<<}, and author=\"…\" date=\"…\" prefixes; {=+…+=} marks AI-inserted text. Commentator (Fevol; not listed, BRAT beta) also adds authorship, timestamps and threads"] },
    src: [["Track Changes", "philphilphil/obsidian-track-changes", 2923, "track-changes"],
          ["Commentator", "Fevol/obsidian-criticmarkup", null, "not listed"]] },

  // ---- Components ----
  { g: "Components & code", f: "Variables / expressions", m: "Variables / expressions", c: {
    obs: ["E", "`= this.file.name`  `$= dv.current().file.mtime`  `INPUT[toggle:done]`  `#: 3ft * 4ft`",
      "Dataview: inline DQL with =, inline JavaScript with $=. Meta Bind (~576k): INPUT[…] fields bound to front matter, plus VIEW[…] displays (VIEW from prior knowledge). Numerals (~74k): #: evaluates and #=: shows the working, with units and currency. All of them take over inline code"] },
    src: [["Dataview", "blacksmithgu/obsidian-dataview", 5143170, "dataview"],
          ["Meta Bind", "mProjectsCode/obsidian-meta-bind-plugin", 575763, "obsidian-meta-bind-plugin"],
          ["Numerals", "gtg922r/obsidian-numerals", 73946, "numerals"]] },

  { g: "Components & code", f: "Query blocks", c: {
    obs: ["E", "```dataview\\nTABLE rating FROM #book  ```dataviewjs  ```tasks\\nnot done\\ndue before tomorrow",
      "Dataview: a SQL-like query language, or JavaScript. Tasks: one filter, sort or group instruction per line. Both render live results in place of the fence"] },
    src: [["Dataview", "blacksmithgu/obsidian-dataview", 5143170, "dataview"],
          ["Tasks", "obsidian-tasks-group/obsidian-tasks", 4419045, "obsidian-tasks-plugin"]] },

  { g: "Components & code", f: "Templating", c: {
    obs: ["E", "<% tp.date.now() %>  <%* js %>  <%+ … %>  <%_ … -%>",
      "Templater (~5.9M): <% outputs a value, <%* runs JavaScript; _ and - trim whitespace, and + defers to preview time (deprecated). It normally runs when a template is inserted, so the note keeps the result. The core Templates plugin's {{date}} and {{title}} are not covered here"] },
    src: [["Templater", "SilentVoid13/Templater", 5914018, "templater-obsidian"]] },

  { g: "Components & code", f: "Code block header options", c: {
    obs: ["E", "```cpp title:x.cpp fold hl:1,3-4,/re/ ln:27  ```python:main.py  ```js nums {1,3-5}",
      "Code Styler (~243k): title, ref, fold, hl (lines, text or regex), ln, unwrap, info/warn/error lines, and R Markdown-style ```{r title, hl=5}. Codeblock Customizer (~71k): hl, file/title, fold and lsep. Embedded Code Title (~16k): lang:filename. Advanced Codeblock (~19k): nums plus {ranges}"] },
    src: [["Code Styler", "mayurankv/Obsidian-Code-Styler", 242891, "code-styler"],
          ["Codeblock Customizer", "mugiwara85/CodeblockCustomizer", 71150, "codeblock-customizer"],
          ["Embedded Code Title", "tadashi-aikawa/obsidian-embedded-code-title", 16200, "obsidian-embedded-code-title"],
          ["Advanced Codeblock", "lijyze/obsidian-advanced-codeblock", 18680, "obsidian-advanced-codeblock"]] },

  { g: "Components & code", f: "Block transform selector", c: {
    obs: ["E", "[list2table]\\n\\n- a\\n  - b  ```anyblock",
      "AnyBlock (~94k): a [processor] line, as its own paragraph, applies to the list, heading section, code block, quote or table under it and turns it into a table, tabs, cards, columns, a mind map, a timeline, mermaid and more. Processors chain. It also works as an anyblock fence"] },
    src: [["AnyBlock", "any-block/any-block", 94468, "any-block"]] },

  { g: "Components & code", f: "Buttons", c: {
    obs: ["E", "```button\\nname Daily Setup\\ntype command\\naction …  `button-id`",
      "Buttons (~482k): a button fence with argument lines, named by a ^button-id block id below it and placed inline by that id in inline code. Meta Bind also has buttons"] },
    src: [["Buttons", "shabegom/buttons", 482278, "buttons"]] },

  // ---- Publishing ----
  { g: "Publishing", f: "Charts and progress bars (fenced)", c: {
    obs: ["E", "```chart\\ntype: bar\\nlabels: […]\\nseries: …  ```text-progress-bar\\nBooks read:5/10  ```progressbar\\nkind: day-year",
      "Charts (~331k): Chart.js from YAML with type, labels and series required. Text Progress Bar (~8k): label:value/total with fill, empty and transition characters. ProgressBar (~19k): time-based or manual bars from YAML. For inline charts see Sparkline"] },
    src: [["Charts", "phibr0/obsidian-charts", 330647, "obsidian-charts"],
          ["Text Progress Bar", "michaeladams/obsidian-text-progress-bar", 7797, "text-progress-bar"],
          ["ProgressBar", "zwpaper/obsidian-progressbar", 19343, "progressbar"]] },

  { g: "Publishing", f: "Diagram fence (beyond mermaid)", c: {
    obs: ["E", "```plantuml  ```plantuml-ascii",
      "PlantUML (~163k). Core Obsidian renders only mermaid (see Diagram fence)"] },
    src: [["PlantUML", "joethei/obsidian-plantuml", 162957, "obsidian-plantuml"]] },

  { g: "Publishing", f: "Table of contents marker", m: "Table of contents marker", c: {
    obs: ["E", "```table-of-contents\\nstyle: nestedList\\nminLevel: 2  ```toc",
      "Automatic Table Of Contents (~166k): a fence that stays current, with title, style, minLevel, maxLevel and include options"] },
    src: [["Automatic Table Of Contents", "johansatge/obsidian-automatic-table-of-contents", 165604, "automatic-table-of-contents"]] }
);

// Markdown dialect feature matrix: columns, statuses, and the dialect-properties rows.
// Sources: reports/Markdown dialect comparison.md and the research notes it cites
// (run 2: research_notes/Markdown dialect comparison/; run 1: the archived family notes).
// A cell is [status, syntax, note]. Status codes:
//   C  core        part of the dialect's base definition (its spec, or for spec-less dialects its primary docs)
//   E  extension   a named option, plugin or extension that is off by default
//   D  de facto    rendered by the platform but written down in no spec (github.com's additions)
//   R  removed     a CommonMark feature this dialect deliberately drops
//   U  unsupported not available (falls back to literal text or raw HTML)
//   Q  unverified  not established by the research; do not read as absent
window.MATRIX = window.MATRIX || { rows: [] };

MATRIX.columns = [
  { key: "cm",   name: "CommonMark", sub: "0.31.2 spec" },
  { key: "gfm",  name: "GFM spec",   sub: "0.29-gfm, 2019" },
  { key: "gh",   name: "github.com", sub: "what GitHub renders" },
  { key: "obs",  name: "Obsidian",   sub: "help docs + app" },
  { key: "gl",   name: "GitLab",     sub: "GLFM" },
  { key: "pd",   name: "Pandoc",     sub: "markdown, default exts" },
  { key: "dj",   name: "Djot",       sub: "syntax.md, unversioned" },
  { key: "myst", name: "MyST",       sub: "mystmd" },
  { key: "mdoc", name: "Markdoc",    sub: "draft spec 0.1.0" },
  { key: "mdx",  name: "MDX",        sub: "3.1.1 core" }
];

MATRIX.statuses = {
  C: { label: "Core",        glyph: "●", desc: "In the dialect's base definition" },
  E: { label: "Extension",   glyph: "◐", desc: "Named option or plugin, off by default" },
  D: { label: "De facto",    glyph: "◇", desc: "Rendered by the platform, written down in no spec" },
  R: { label: "Removed",     glyph: "✕", desc: "A CommonMark feature deliberately dropped" },
  H: { label: "Workaround",  glyph: "↪", desc: "No Markdown syntax for it; the form shown is a fallback, usually raw HTML" },
  U: { label: "Unsupported", glyph: "–", desc: "Not available" },
  Q: { label: "Unverified",  glyph: "?", desc: "Not established by the research" },
  I: { label: "Property",    glyph: "",  desc: "Descriptive value, not a support level" }
};

MATRIX.groups = [
  "Dialect properties", "Block structure", "Line breaks", "Inline core",
  "Tables & lists", "Inline extensions", "Notes & math", "Callouts & containers",
  "Attributes & raw", "Linking & knowledge", "Metadata & comments", "Publishing", "Components & code"
];

MATRIX.rows.push(
  { g: "Dialect properties", f: "Specification", c: {
    cm: ["I", "Versioned spec, 652 examples", "0.31.2 (2024-01-28); no 1.0; only clarifications since"],
    gfm: ["I", "Frozen 2019 spec", "Specifies tables, task lists, strikethrough, extended autolinks, tag filter"],
    gh: ["I", "Product docs only", "Footnotes, math, alerts, diagrams added 2021–23 with no spec text or tests"],
    obs: ["I", "No spec", "\"Not currently on the roadmap\" (moderator, 2022); two internal parsers"],
    gl: ["I", "Product docs", "An earlier example-based GLFM spec existed; status after the comrak switch unclear"],
    pd: ["I", "Manual + implementation", "47 default extensions in pandoc markdown"],
    dj: ["I", "Prose reference, unversioned", "\"Isn't completely stable yet\"; last numbered syntax 0.2 (2022)"],
    myst: ["I", "AST spec \"in dev\"", "myst-spec repo archived 2026, moving into mystmd"],
    mdoc: ["I", "Draft tag spec v0.1.0", "No AST spec; one is \"seriously\" being considered"],
    mdx: ["I", "micromark state machine", "Deviations from Markdown listed in mdx-state-machine"] } },
  { g: "Dialect properties", f: "Relation to CommonMark", c: {
    cm: ["I", "—", ""],
    gfm: ["I", "Additive superset", ""],
    gh: ["I", "Additive superset", ""],
    obs: ["I", "Additive (CommonMark-ish)", "Reading view runs pre-2020 remark-parse, which never claimed full compliance"],
    gl: ["I", "Additive superset", "Goal stated as 100% CommonMark compliant"],
    pd: ["I", "Pre-CommonMark lineage", "commonmark_x is the CommonMark-based alternative"],
    dj: ["I", "Reinterpretive redesign", "Same glyphs, new meanings (e.g. *x* is strong)"],
    myst: ["I", "Additive superset", ""],
    mdoc: ["I", "Additive (drops setext only)", ""],
    mdx: ["I", "Subtractive + JSX", "Removes indented code, autolinks, raw HTML"] } },
  { g: "Dialect properties", f: "Invalid input", c: {
    cm: ["I", "Total: any input is a document", ""], gfm: ["I", "Total", ""], gh: ["I", "Total", ""],
    obs: ["I", "Total", ""], gl: ["I", "Total", ""], pd: ["I", "Total", ""], dj: ["I", "Total", ""],
    myst: ["I", "Total parse; directives can fail at render", "Parse-error behavior not verified"],
    mdoc: ["I", "Total parse; tags validate", "Parse-error behavior not verified"],
    mdx: ["I", "Partial: invalid MDX crashes", "\"Whereas all Markdown is valid, incorrect MDX will crash\""] } },
  { g: "Dialect properties", f: "Can a later line change an earlier one?", c: {
    cm: ["I", "Yes", "Setext underline, reference definitions anywhere, HTML-block end conditions"],
    gfm: ["I", "Yes", "Also: a |---| row turns the line above into a table header"],
    gh: ["I", "Yes", ""], obs: ["I", "Yes", ""], gl: ["I", "Yes", ""], pd: ["I", "Yes", ""],
    dj: ["I", "No (block level)", "\"The contribution a line makes to block-level structure never depends on a future line\""],
    myst: ["I", "Yes", ""], mdoc: ["I", "Yes", ""],
    mdx: ["I", "Yes, less", "Removes some non-local features for JSX's sake"] } }
);

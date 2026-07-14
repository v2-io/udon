# UDON editor support

First editor affordances for UDON. Context: REVIEW-JULY-2026.md §3 (concerns
4 and 6) — UDON's failure modes in unaware editors are *silent* (a reflowed
line that lands `:attr`/`;-)`/`!important` at line start silently becomes
structure), so even minimal editor awareness has outsized value. Everything
here follows one rule: **under-highlight rather than mis-highlight** — a
wrong color teaches a wrong parse.

All three implementations were validated against `examples/cheatsheet.udon`
and `examples/comprehensive.udon` (the Obsidian tokenizer and the TextMate
grammar via automated token dumps; the vim syntax via headless `vim -es`
synID dumps). Spec of record: `spec/FULL-SPEC.md` v0.7-draft.

## Contents

| Path | What | For |
|---|---|---|
| `obsidian-udon/` | Loadable community plugin (no build step) | Obsidian |
| `udon.tmLanguage.json` | TextMate grammar | VS Code, Sublime, anything TextMate |
| `vim/` | syntax + ftdetect + ftplugin | vim / neovim |

There is also the tree-sitter grammar spike at `../tree-sitter-udon/`
(same spec version, Dec 2025). It targets tree-sitter consumers (neovim
nvim-treesitter, helix, udon-aware `gq`) and is complementary to these;
its token rules broadly agree, but it does not model the `;`
context-sensitivity in prose that these grammars are careful about.

## The shared "safeset"

What gets highlighted (only where the parse is locally unambiguous):

- The four sigils in their block positions: `|element`, `:attr`, `;comment`,
  `!directive` — plus element identity parts `[key]`, `.trait`, and the
  suffix modifiers `? ! * +`.
- Inline forms in prose: `|{element ...}`, `;{comment}`,
  `!{{interpolation | filters}}`, `!{directive ...}`, `!{:kind: raw}`.
- Quoted strings, and bare values **only when the whole value is
  syntactically typed** (number / `true` / `false` / `null` / `nil` /
  `[list]`). Bare-string values stay plain — they are just strings.
- `!:lang:` raw blocks and ``` freeform blocks: bodies rendered plain
  (no UDON interpretation — which is exactly what the parser does).
- Line-initial `\`-escapes (`\| \: \; \! \\`) as escape marks.

The two subtle cases, handled deliberately:

- **`;` context-sensitivity** (spec §Comments table): colored as a comment
  only where the spec makes it one — line-initial (block comment), or
  whitespace-preceded on a structure line (element/attr/directive sameline
  context). Semicolons inside block prose are literal and stay plain;
  `;{...}` is the only comment form recognized inside prose.
- **`\` escape**: only line-initial and only before one of `|;:!\`.
  `\hello` is prose, not an escape.

Also deliberate: a `|` inside a prose line is never colored (Markdown tables
survive), and `|` opens an element only when followed by letter/`[`/`.`/
`{`/`'` (spec element-recognition rule).

---

## Obsidian (`obsidian-udon/`)

Plain-JS plugin, checked in ready to load — `manifest.json` + `main.js` +
`styles.css`, no build step (Obsidian provides `obsidian` and the
`@codemirror/*` packages at runtime).

### Install (unpacked community plugin)

```bash
# from the repo root; pick your vault
cp -r editors/obsidian-udon "<vault>/.obsidian/plugins/udon"
```

Then in Obsidian: Settings → Community plugins → reload/enable **UDON**.
`.udon` files in the vault now open in a dedicated editor view.

### What works

1. **Opening**: registers the `.udon` extension with a `TextFileView`
   wrapping a CodeMirror 6 editor. Live files (ASF process maps, LEXICON)
   open, edit, and save (standard Obsidian debounced save).
2. **Indentation**: Enter maintains the current line's indent; Tab indents
   the line by 2 spaces when in leading whitespace (or with a selection),
   inserts 2 spaces mid-line; Shift-Tab dedents. Tabs are never inserted
   (spec: "Spaces only, no tabs").
3. **Safeset highlighting** per above, themed via Obsidian's own
   `--code-*` CSS variables (light/dark both fine).
4. **Folding on indentation**: fold gutter + fold commands; a line folds
   everything blank-or-more-indented below it (mirrors the spec's
   hierarchy rule).
5. **Soft wrap** is on — per REVIEW §3.6, soft-wrap sidesteps the
   reflow-reparenting hazard entirely; never hard-wrap UDON prose.

### Deferred (and the seam for it)

- **Markdown rendering of prose** (the "reading view"): not attempted.
  The seam: `UdonView` owns a single source-mode CM editor; a reading
  sub-view can be added beside it that walks prose spans (the tokenizer
  already knows which lines are prose vs structure vs raw) and renders
  them through Obsidian's `MarkdownRenderer` — without touching the
  tokenizer or the editing extensions.
- No linting (reflow-damage heuristics are the linter's job, per REVIEW).
- Whole-document mode scan runs per edit — fine for daily-use documents
  (hundreds of lines); would want incremental state for very large files.

### Known limitations (honest list)

- Comment **continuation lines** (indented non-prefix lines under a line
  comment) are displayed as prose, not comment — determining them needs
  cross-line indent state we deliberately don't guess at yet. This is the
  one place the display is *lighter* than the parse (under-highlight).
- Not verified inside a live Obsidian instance yet — the API usage is the
  standard TextFileView + CM6 pattern, but first-load should be sanity
  checked on a scratch vault. (The tokenizer itself is test-verified.)
- `.udon` files won't appear in some link/search affordances that are
  markdown-only; that's an Obsidian platform boundary.

---

## VS Code / Sublime (`udon.tmLanguage.json`)

Validated with the real engine (`vscode-textmate` + oniguruma) against both
example files.

### VS Code

Quickest (no marketplace): create a minimal local extension —

```bash
mkdir -p ~/.vscode/extensions/udon-syntax/syntaxes
cp editors/udon.tmLanguage.json ~/.vscode/extensions/udon-syntax/syntaxes/
cat > ~/.vscode/extensions/udon-syntax/package.json <<'EOF'
{
  "name": "udon-syntax", "displayName": "UDON", "version": "0.1.0",
  "engines": { "vscode": "^1.70.0" },
  "contributes": {
    "languages": [{ "id": "udon", "extensions": [".udon"],
                    "configuration": "./language-configuration.json" }],
    "grammars": [{ "language": "udon", "scopeName": "source.udon",
                   "path": "./syntaxes/udon.tmLanguage.json" }]
  }
}
EOF
cat > ~/.vscode/extensions/udon-syntax/language-configuration.json <<'EOF'
{ "comments": { "lineComment": ";" },
  "brackets": [["[", "]"], ["{", "}"]] }
EOF
```

(VS Code's default Enter behavior already maintains the current indent.)

Then reload VS Code. Add to settings for correct indentation behavior:

```json
"[udon]": { "editor.tabSize": 2, "editor.insertSpaces": true,
            "editor.wordWrap": "on" }
```

### Sublime

Sublime consumes `.tmLanguage` (plist) or `.sublime-syntax`; it also loads
JSON TextMate grammars via packages like "TextMate Syntax" — or convert once
with `PackageDev`. (Deferred: a native `.sublime-syntax` port.)

### Notes / limitations

- Block-attribute lines with **multiple** attributes (`:a 1 :b 2` on one
  line) color only the first key: FULL-SPEC says block values run to end of
  line, while `examples/cheatsheet.udon` line 18 uses several attrs per
  block line — the spec and the cheatsheet disagree here, so the grammar
  refuses to guess. (Flagged as a spec ambiguity; sameline attrs on
  element lines are unaffected.)
- Freeform ``` fences may open mid-line (spec-true) — including in prose;
  a literal triple-backtick in prose will start an uncolored region until
  the next ```.
- Comment continuation lines: same under-highlight as Obsidian.

---

## vim / neovim (`vim/`)

### Install

```bash
# vim 8+ / neovim packages path (or use your plugin manager with this dir)
mkdir -p ~/.vim/pack/udon/start
ln -s "$(pwd)/editors/vim" ~/.vim/pack/udon/start/udon
# neovim: ~/.config/nvim/pack/udon/start instead
```

### What works

- Filetype detection for `.udon`.
- **Indentation**: `expandtab shiftwidth=2 softtabstop=2` (never tabs),
  `autoindent` (newline maintains indent — no reindent-guessing
  `indentexpr`, which would be actively dangerous in a
  layout-significant format).
- **Folding for free**: `foldmethod=indent` — matches UDON's hierarchy.
- Safeset highlighting per above, including raw/freeform body
  suppression (indent-scoped via `\z(...\)` regions) and mid-line fences.
- `formatoptions` strips auto-wrap and `comments`/`commentstring` are set
  for `;` so comment toggles work. **Do not `gq` UDON prose** — until a
  udon-aware fill exists (tree-sitter path), reflow can silently promote
  wrapped sigil-initial words to structure. Soft wrap (`wrap linebreak
  breakindent`) is set instead.

### Limitations

- `syn sync fromstart` — simple and correct; could be slow on very large
  files.
- Same comment-continuation and multi-attr-block-line under-highlights as
  the other two.

---

## What I'd do next (in order)

1. Load the Obsidian plugin in a scratch vault against the live ASF
   process maps; fix any first-load API friction.
2. Decide the block-attr multi-attribute question in the spec (value runs
   to EOL vs `:` after a typed value starts a new attr) — all three
   grammars have a marked spot to tighten once decided.
3. Comment continuation lines (needs one line of look-back state; easy in
   CM6, awkward in TextMate, `\z`-region in vim).
4. Obsidian reading mode: markdown-render prose spans through
   `MarkdownRenderer` (seam described above), then `udon` code-block
   highlighting inside markdown notes.
5. Port the safeset to `.sublime-syntax`, and wire `tree-sitter-udon`
   queries up to these same safeset decisions so nvim-treesitter/helix
   agree with the static grammars.

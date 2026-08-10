# UDON plugin for Obsidian

Views and edits `.udon`, `.ud`, `.un`, and `.don` files on Obsidian’s **markdown
editor host** (same stack as notes: wikilinks, vim, editor plugins), and
highlights ```` ```udon ```` fences in ordinary markdown notes — in Reading
view, Live Preview, and Source mode.

`.ud` / `.un` / `.don` are short aliases for vanilla udon (e.g. paths-style
`def/*.ud`, verisectorium-style `terms/*.term.un`).

## Architecture

| Layer | What |
|---|---|
| **Host** | `registerExtensions(['udon','ud','un','don'], 'markdown')` — real note editor |
| **Guest** | Gated CM6 extensions: wasm whole-doc highlight, Tab/Enter indent, indent fold |
| **Guardrail** | Force pure **Source** mode for UDON files (Live Preview mangles structure) |

That split is intentional: wikilinks (`[[term/…]]`, `[[DECISIONS#…|…]]`),
vim mode, and `registerEditorExtension` plugins only attach to markdown’s
editor. A custom `TextFileView` cannot get them without reimplementation.

Highlighting is **parser-driven**: `udon.wasm` is the real udon-core parser
(built from `core/udon-wasm/`), and its event stream with exact spans is
painted directly. There is no grammar in this plugin to drift from the spec.

Colors are **generated, not themed** (the autocolors engine — see
`../autocolors/PLAN.md` for the theory and its 2011 origins): a whole
colorscheme is derived at load in OKLCH, anchored to your active theme's
background/foreground, with contrast bands and kinship shading solved as
constraints.

## Using it

**Settings → Community Plugins → UDON:**

- **Scheme name** — any string. The name is hashed into the RNG seed, so a
  name *is* a scheme: deterministic, portable, shareable. `mochi`
  (the default) renders identically on any machine running this engine.
  To "reroll," just type a different string — a word, a phrase, anything —
  until one sings; then keep its name.
- **Autocolors toggle** — off = static fallback palette from Obsidian theme
  variables (`styles.css`).

The palette regenerates automatically when you switch Obsidian themes or
light/dark mode. Live-use feedback (taste calls, mispaints) lands in
`../TODO-HUMAN-UX.md` (the UX lane, under the Obsidian plugin item).

### Wikilinks

Because UDON files are markdown notes at the host layer, `[[stem]]` /
`[[path#heading|label]]` get Obsidian’s normal link machinery (click,
autocomplete, backlinks). Stem resolution still follows vault path /
basename rules — `[[term/reference-act]]` vs `terms/reference-act.term.un`
is a naming-community concern (see paths D8), not something this plugin
rewrites.

### Source mode

UDON leaves are forced to pure Source (`mode: 'source'`, `source: true`).
Toggle Live Preview or Reading view on a `.un` file and the plugin puts it
back — structure lines are not safe as HyperMD. A UDON reading surface for
prose spans remains future work.

## Install

This repo is itself a test vault (`.obsidian/` is gitignored); the plugin is
symlinked: `.obsidian/plugins/udon → ../../ux/obsidian-udon`. For any
other vault, copy or symlink this directory to
`<vault>/.obsidian/plugins/udon/` and enable it. Four files matter at
runtime: `main.js`, `styles.css`, `manifest.json`, `udon.wasm`.

Reload the plugin (or restart Obsidian) after updating. If a `.udon`/`.ud`/`.un`
file was already open under the old custom view, close and reopen it so it
binds to markdown.

## Rebuilding the parser/engine

After any grammar or engine change:

```bash
cd core && cargo build -p udon-wasm --release --target wasm32-unknown-unknown
cp target/wasm32-unknown-unknown/release/udon_wasm.wasm ../ux/obsidian-udon/udon.wasm
```

then reload the plugin (toggle off/on). One rebuild updates highlighting
*and* scheme generation everywhere — that's the point.

Everything lives in `main.js` on purpose: no build step, and Obsidian's
plugin loader can't `require()` sibling files.

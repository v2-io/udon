# UDON Obsidian plugin — TODO

**Scope: this Obsidian plugin only** (`editors/obsidian-udon/`) — viewing and
editing `.udon` files: safeset syntax highlighting, indentation behavior,
indent-based folding, and how UDON *displays* in the editor. Not the spec, not
the parser, not the other editors. Joseph's live-use feedback lands here.

## Open

- [ ] **Get editing to work.** (Joseph — to be detailed with an Obsidian-focused
      agent later; this is the umbrella item for the editing experience.)
- [ ] **Soft-wrap prose to its own column, not column 1.** When an indented
      prose line is long enough to *display*-wrap (soft word-wrap), its wrapped
      continuation currently returns to **column 1** instead of aligning with
      the prose's start column. Give soft-wrapped prose a **hanging indent** to
      the prose column, so a wrapped paragraph reads as one visually coherent,
      correctly-indented block.
      *Display-only:* this is a CodeMirror soft-wrap-indentation concern — **no
      hard newlines**, no change to the file's bytes or actual indentation.

- [ ] **Validate the ```udon fence highlighter in a live vault** (SPIKE
      2026-07-16, `fence-highlight.js` + `udon.wasm`). Engine (udon-core
      compiled to wasm, `core/udon-wasm/`) is proven under node: instantiation,
      byte→UTF-16 span mapping, fence detection, decoration ranges. What's
      NOT yet exercised is Obsidian itself: (a) Reading view — does stripping
      `language-udon` before span-painting reliably win the race with Prism's
      async pass? (b) Live Preview — do the CM6 mark decorations coexist with
      Obsidian's own HyperMD codeblock decorations? (c) wasm load via
      `vault.adapter.readBinary(manifest.dir + '/udon.wasm')`. Install =
      copy `main.js fence-highlight.js styles.css manifest.json udon.wasm`
      into `<vault>/.obsidian/plugins/udon/` and enable.
      Rebuild after grammar changes:
      `cd core && cargo build -p udon-wasm --release --target wasm32-unknown-unknown`
      then `cp core/target/wasm32-unknown-unknown/release/udon_wasm.wasm editors/obsidian-udon/udon.wasm`.
      Consider automating the copy + trimming size (159 KB now; wasm-opt later).
- [ ] **Converge the two highlighters.** The `.udon`-file view still uses the
      hand-written safeset line scanner in `main.js`; the fence path now uses
      the real parser via wasm. Once the wasm path is validated, the safeset
      scanner should become the fallback (or be retired) so there is exactly
      one source of highlighting truth — the parser.

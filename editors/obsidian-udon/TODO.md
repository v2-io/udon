# UDON Obsidian plugin — TODO

**Scope: this Obsidian plugin only** (`editors/obsidian-udon/`) — viewing and
editing `.udon` files: syntax highlighting, indentation behavior, indent-based
folding, and how UDON *displays* in the editor. Not the spec, not the parser,
not the other editors. Joseph's live-use feedback lands here.

Highlighting is parser-driven (udon-core → wasm; see the banner comment in
`main.js`). Rebuild after grammar changes:
`cd core && cargo build -p udon-wasm --release --target wasm32-unknown-unknown`
then `cp core/target/wasm32-unknown-unknown/release/udon_wasm.wasm editors/obsidian-udon/udon.wasm`.

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
- [ ] **Automate the wasm rebuild+copy** (script or cargo alias), and consider
      trimming size (159 KB now; wasm-opt later).
- [ ] **Live Preview fences: anchor on Obsidian's syntax tree** instead of the
      whole-document line-regex fence scan — the current scan is correct at
      note scale but doesn't handle exotic containers (nested callout depth
      changes, indented-code ambiguity) and is O(doc) per edit.

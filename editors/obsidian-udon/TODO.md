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

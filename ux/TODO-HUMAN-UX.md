# TODO-HUMAN-UX — human-facing tooling

Obsidian, syntax highlighting, editors, and how UDON reads/edits for humans.

## Open

- [ ] **Event-stream highlighting: remaining consumers.** The approach is
      proven and shipping — highlighting rendered purely from parser events
      + spans (no separate grammar; it can never disagree with the parser):
      `core/udon-core/examples/highlight.rs` (ANSI; doubles as a
      span-fidelity audit — any mis-painted character is a span bug) and
      `core/udon-wasm/` (the Obsidian plugin's sole highlighting source).
      The pushdown backend's global spans extend the same walk to
      incremental re-highlighting. Remaining: **LSP semantic tokens** (a
      direct re-emission of the same walk), and **whether the tree-sitter
      spike still earns its keep** against that fidelity argument
      (`tree-sitter-udon/` — its one unique claim is udon-aware editor
      machinery like fill/`gq` in tree-sitter-native editors).

- [ ] **Obsidian plugin** (`obsidian-udon/`) — Joseph's live-use feedback
      lands here. Open items (drained from the former plugin sub-tracker,
      2026-07-16):
      - [x] **Markdown host for .udon/.un/.don** (0.2.0, 2026-08-08) —
            register as `markdown` so wikilinks, vim, and editor plugins
            attach; gate wasm whole-doc highlight + UDON Tab/Enter + indent
            fold as guest extensions; force pure Source mode (Live Preview
            mangles structure). Live check: `terms/descriptor.term.un`
            click-through / backlinks / vim.
      - [ ] **Get editing to work** — residual after host switch: soft-wrap
            hanging indent, reading surface for prose, stem-resolution
            conventions (`[[term/X]]` vs `terms/X.term.un`), taste-test
            highlight vs HyperMD decorations fighting in Source mode.
      - [ ] **Soft-wrap prose to a hanging indent at its own column** —
            display-wrapped continuations currently return to column 1; give
            wrapped prose a hanging indent to the prose column. *Display-only*
            (CodeMirror soft-wrap concern): no hard newlines, no byte changes.
      - [ ] **Automate the wasm rebuild+copy** (script or cargo alias:
            `cd core && cargo build -p udon-wasm --release --target
            wasm32-unknown-unknown`, then copy `udon_wasm.wasm` →
            `obsidian-udon/udon.wasm`); consider trimming size (227 KB with
            the autocolors engine; wasm-opt later).
      - [ ] **Autocolors: first real-vault look** — the settings → wasm
            `udon_theme` → injected `#udon-autocolors` path is node-proven end
            to end but unrendered in a live Obsidian window: check a `.udon`
            file and a ```` ```udon ```` fence in light and dark themes,
            reroll a few scheme names, confirm the settings tab. Taste calls
            to revisit by eye: deliberately mild chroma; comment hue
            randomized like any family (2011 kept comments near-neutral);
            bold on element names.
      - [ ] **Live Preview fences: anchor on Obsidian's syntax tree** instead
            of the whole-document line-regex fence scan — correct at note
            scale but blind to exotic containers (nested callout depth,
            indented-code ambiguity) and O(doc) per edit. (Whole UDON
            files stay in Source; this item is for ```` ```udon ```` inside
            ordinary `.md` notes.)
- [ ] **autocolors — remaining phases.** The engine is live (Rust beside
      the parser in `core/udon-wasm/src/`: 32-role kinship tree, OKLCH +
      WCAG-contrast-band solver, name-is-the-seed determinism, driving the
      Obsidian plugin; theory + 2011 archaeology in `autocolors/PLAN.md`).
      Not yet done: density-adaptive fitness / corpus census / optimization
      loop (phase C); `mapping.udon`-as-UDON dogfood; ANSI/vim emission;
      contextual emphasis (phase D). The first real-vault look is tracked
      under the Obsidian item above. Dec-2025 design ground for the
      multi-target/theme-generation ideas: `../design/semachrome.md` (moved
      from `notes/` 2026-07-16).
- [ ] **Syntax highlighting** — bring `udon.tmLanguage.json`, `vim/`, and
      `tree-sitter-udon/` current with CORE (especially the new escape model,
      `<…>` typing, and the 0.9 uniform block-attr scan — the "spec vs
      cheatsheet disagree on multi-attr block lines" flag all three grammars
      carry is resolved: `:a 1 :b 2` is two attributes).

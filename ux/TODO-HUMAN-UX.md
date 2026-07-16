# TODO-HUMAN-UX — human-facing tooling

Obsidian, syntax highlighting, editors, and how UDON reads/edits for humans.

## Open

- [ ] **Event-stream highlighting is proven — build on it, not beside it.**
      `core/udon-core/examples/highlight.rs` (2026-07-15) renders ANSI
      highlighting purely from parser events + spans: no separate grammar,
      no regexes — token classes arrive labeled with exact byte ranges, and
      highlighting is span-painting (containers underlay, leaves overpaint,
      comments dim their interior, sigils recede). Consequences for this
      lane: (a) editor highlighting can be event-driven (LSP semantic
      tokens are a direct re-emission of the same walk — likely BETTER than
      a tree-sitter grammar for fidelity, since it can never disagree with
      the parser); (b) the tree-sitter spike should be weighed against
      that; (c) the example doubles as a span-fidelity audit — any
      mis-painted character is a span bug. The pushdown backend's global
      spans extend the same approach to incremental re-highlighting.
      *2026-07-16:* realized — the same walk compiles to wasm
      (`core/udon-wasm/`) and is now the Obsidian plugin's **sole**
      highlighting source (validated in a live vault, both fence surfaces;
      the hand-written safeset scanner is retired — git has it). Remaining
      consumers of this item: LSP semantic tokens, and whether the
      tree-sitter spike still earns its keep.

- [ ] **Obsidian plugin** (`obsidian-udon/`) — Joseph's live-use feedback
      lands here. Open items (drained from the former plugin sub-tracker,
      2026-07-16):
      - [ ] **Get editing to work** — the umbrella item for the editing
            experience (Joseph; to be detailed with an Obsidian-focused agent).
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
            indented-code ambiguity) and O(doc) per edit.
- [ ] **autocolors — generated, allocation-theoretic color schemes.**
      Joseph's 2011 project (procedural schemes in perceptual color space:
      emphasis as an information budget, colors as constrained relationships,
      composition-theory balance), unblocked by this week's parser-driven
      highlighting. Plan + 2011 archaeology: `autocolors/PLAN.md`.
      *2026-07-16:* **first build landed** — Rust engine beside the parser
      (`core/udon-wasm/src/{roles,scheme,color,rng}.rs`): 32-role kinship
      tree, OKLCH + WCAG-contrast-band solver, name-is-the-seed determinism
      (FNV-1a 64 + SplitMix64, pinned), live in the Obsidian plugin
      (scheme name = setting, anchored to the active theme's bg/fg,
      regenerated on `css-change`). Phase A+B essentials done; **not**
      done: density-adaptive fitness / corpus census / optimization loop
      (phase C), `mapping.udon`-as-UDON dogfood, ANSI/vim emission,
      contextual emphasis (phase D). Unexercised: real Obsidian render
      (headless-node-proven only) — needs a vault look.
- [ ] **Syntax highlighting** — bring `udon.tmLanguage.json`, `vim/`, and
      `tree-sitter-udon/` current with CORE (especially the new escape model,
      `<…>` typing, and the 0.9 uniform block-attr scan — the "spec vs
      cheatsheet disagree on multi-attr block lines" flag all three grammars
      carry is resolved: `:a 1 :b 2` is two attributes).

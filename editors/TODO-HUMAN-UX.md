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

- [ ] **Obsidian plugin** — editing behavior, soft-wrap-to-prose-column, folding.
      Live feedback + detail stay in `obsidian-udon/TODO.md` (the plugin
      sub-tracker); umbrella tracking here. *(That sub-tracker is intentionally
      plugin-local — it's where live-use feedback lands and it travels with the
      plugin; two-level co-location, not scatter. Don't drain it by reflex.)*
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
      `../tree-sitter-udon/` current with CORE (especially the new escape model
      and `<…>` typing).

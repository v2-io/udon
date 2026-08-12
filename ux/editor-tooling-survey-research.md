# Editor & notes tooling survey — research notes

*Session research write-up (2026-08-11). Scope: alternatives to an ad hoc Obsidian+plugins setup; fit for multi-repo `~/src`, git-backed outline+segment Markdown, custom UDON, and primary work through official agent harnesses (Claude Code, Grok, OpenCode, etc.) rather than API-only host mediation. Includes deep dives on Tangent vs Neovim, specialized UDON editor hosts (CM6 / ProseMirror), and Vim fidelity stacks.*

**Status:** Working research synthesis, not a product decision. Some upstream claims were only partially verified (see [Coverage gaps](#coverage-gaps--uncertainty)).

**Local clones / sources used this pass:**

| Path | Role |
|---|---|
| `~/src-ext/obsidian-help` | Obsidian product docs (views, vaults, plugins) |
| `~/src-ext/tangent` | Tangent monorepo (clone of [suchnsuch/Tangent](https://github.com/suchnsuch/Tangent), HEAD ~`8e38eab`) |
| `firmatum/udon/ux/` (this tree) | UDON human UX, `obsidian-udon`, vim/TextMate/tree-sitter |
| Deep-research workflow report | Licensing, agent hosts, file-first vs DB vaults (partial) |

---

## 1. Framing constraints (Joseph)

1. **Durable store is not a notes app.** Git-backed plain files (ASF-style outline + segments; UDON where used) are primary. Notes UIs are optional shells.[^asf-format][^outline-views]
2. **AI work stays on official harnesses** (`claude`, `grok`, `opencode`, …) with subscription/usage through those products—not “replace harnesses with an editor that only speaks raw Anthropic API.” Zed/Warp-style **hosts** may optionally wrap harnesses; they must not be required as the billing path.
3. **Multi-repo `~/src` trees** matter. Single-vault isolation is a structural weakness for a *primary* workspace surface.[^obsidian-vaults][^obsidian-symlinks]
4. **UDON is a first-class editing problem.** Current Obsidian plugin prioritizes parser-true highlighting + safe indent/soft-wrap; rich authoring UX is still far behind good Markdown editors (explicit user impetus for this survey).[^udon-human-ux][^udon-plugin-readme]
5. **Mutability.** Closed-source tools need plugin APIs to change behavior. Open monorepos can be edited at source; “no plugin API” is not the same kind of lock-in as proprietary cores (correction mid-discussion).

---

## 2. Category split (avoids false comparisons)

| Category | Job | Examples from the longlist |
|---|---|---|
| **A. PKM / notes apps** | Knowledge, links, journals, graphs | Obsidian, Standard Notes, Joplin, Tangent, DeepNotes, Reor, AFFiNE, Logseq |
| **B. Code editors / IDEs** | Edit arbitrary files | Neovim, gvim/MacVim, Visual Studio, VS Code/Code-OSS |
| **C. Agent hosts** | UI shell that hosts coding agents | Zed (ACP), Warp — *not* note apps |

**Name traps:**

- **Visual Studio ≠ VS Code.** VS Code / Code-OSS is the usual “notes + code” candidate; Visual Studio is a different EULA product.[^vscode-license]
- **DeepNotes ≠ Deepnote.** DeepNotes = E2E canvas PKM ([DeepNotesApp/DeepNotes](https://github.com/DeepNotesApp/DeepNotes)). Deepnote = collaborative data notebooks.

**Zed clarification:** Zed can host external agents via ACP; Claude Agent may authenticate with Claude Code / subscription flows rather than only a raw API key.[^zed-external-agents] That still does not make Zed a drop-in replacement for living in official CLI harnesses. Treat agent hosts as optional.

---

## 3. Notes apps & editors — survey matrix

### 3.1 What each product is

| Tool | Category | One-line job | Open source? | Active? | Primary storage |
|---|---|---|---|---|---|
| **Obsidian** | A | Markdown vault + large plugin ecosystem | **No** (proprietary free-to-use under vendor terms)[^obsidian-license] | Very active | Plain `.md` in a vault folder[^obsidian-storage] |
| **Standard Notes** | A | Privacy-first E2E notes | Clients largely open; package-level license complexity | Active | Encrypted note store (not git-native MD trees) |
| **Joplin** | A | Notebooks + sync + encryption | **Yes** (AGPL default)[^joplin-license] | Active | **SQLite** internally; MD *export*[^joplin-sqlite] |
| **Tangent** | A | Local MD, sliding panels + map, always-styled editing | **Yes** (Apache 2.0)[^tangent-site] | Indie, active through 0.12.x | Plain local Markdown[^tangent-workspace] |
| **DeepNotes** | A | E2E infinite canvas, nested pages, collab | **Yes** (AGPL) | Niche / self-host-heavy | App/server model |
| **Reor** | A | Local LLM over notes | **Yes** (AGPL) | **Archived** (~2026-03-07)[^reor-archive] | Local notes + AI index |
| **AFFiNE** | A | Docs + whiteboard hybrid | **Partial** (MIT client; server EE)[^affine-about] | Company-backed | Mixed files + app model |
| **Logseq** | A | Block outliner + graph | **Yes** (AGPL) | Active; file mode vs DB mode | MD/Org files **or** SQLite graphs[^logseq-db] |
| **Neovim** | B | Programmable text editor | **Yes** (Apache 2.0)[^neovim-license] | Very active | Whatever files you open |
| **gvim / MacVim** | B | Classic Vim GUI | **Yes** (Vim license) | Mature | Files on disk |
| **Visual Studio** | B | Full Microsoft IDE | **No** (EULA) | Active | Project/solution files |

### 3.2 Core comparators (notes + editors)

Legend: **Y** strong · **~** partial · **N** weak · **—** not the job.

| Tool | Plain files SoT | Git-friendly | Multi-root | Wiki-links / graph | Outliner | Plugin / mutability | Offline | Built-in AI focus |
|---|---|---|---|---|---|---|---|---|
| Obsidian | **Y** | **Y** | **N**/~ | **Y** | ~ | Huge plugins; closed core | **Y** | ~ |
| Standard Notes | **N** | **N** | **N** | **N**/~ | **N** | Small | **Y** | **N** |
| Joplin | **N** (export **Y**) | **N**/~ | **N** | ~ | **N** | Medium | **Y** | **N** |
| Tangent | **Y** | **Y** | **N**/~ | **Y** (map + links) | **N** | CSS + **source fork** (no plugin API) | **Y** | **N** |
| DeepNotes | **N** | **N** | **N** | Canvas | ~ | Small | ~ | **N** |
| Reor | ~ | ~ | **N** | ~ | **N** | Small | **Y** | **Y** (local) |
| AFFiNE | ~ | ~ | **N** | **Y**/canvas | ~ | Growing | **Y**/~ | ~ |
| Logseq | **Y** file / **N** DB | **Y** file / **N** DB | **N**/~ | **Y** | **Y** | Large | **Y** | ~ |
| Neovim | **Y** | **Y** | **Y** | — | — | Huge (editor) | **Y** | via harnesses |
| gvim/MacVim | **Y** | **Y** | **Y** | — | — | Large (Vim) | **Y** | external |
| Visual Studio | **Y** as files | **Y** | **Y** | — | — | Huge IDE | **Y** | Copilot etc. |

### 3.3 Practical cut for this estate

| Prioritize | Deprioritize |
|---|---|
| File-first, multi-root-capable **editor** foundations you can mutate | Obsidian as **sole primary** over multi-repo trees |
| Notes as git-backed plain Markdown; outlines as views[^outline-views] | SQLite-graph foundations for git-native multi-repo (Logseq DB, Trilium-class) |
| Agentic capability as harness/host layer, not note-app marketing | Reor (archived); AFFiNE if full server forkability matters |
| Parser-true UDON highlighting discipline | Prism/TextMate as authority for full UDON documents |

**Structural matches as human MD shell:** Obsidian (status quo), Tangent, Logseq *file* mode.  
**Structural matches as multi-repo foundation:** Neovim-class or VS Code/Code-OSS-class.  
**Dendron** multi-vault was noted as structurally stronger than single-vault apps for multi-repo notes; post-2023 maintenance not re-verified this pass.[^dendron-multivault]

### 3.4 Licensing one-liners

| Tool | License posture |
|---|---|
| Obsidian | Proprietary free-to-use app[^obsidian-license] |
| Joplin | AGPL-3.0-or-later (default)[^joplin-license] |
| Tangent | Apache 2.0[^tangent-site] |
| AFFiNE | MIT client + Enterprise server[^affine-about] |
| Logseq / DeepNotes / Reor | AGPL (Reor archived)[^reor-archive] |
| Neovim | Apache 2.0[^neovim-license] |
| VS Code product | Microsoft product license; **Code - OSS** is MIT[^vscode-license] |
| Visual Studio | Microsoft EULA |

---

## 4. Tangent vs Neovim (deep dive)

### 4.1 Rendering models vs Obsidian

Obsidian (local help):[^obsidian-views]

| Mode | Behavior |
|---|---|
| **Source mode** | Raw Markdown |
| **Live Preview** | Formatted inline; syntax appears when cursor enters a span |
| **Reading view** | Fully rendered, not editable |
| **Side-by-side** | Edit + Reading via Cmd/Ctrl+click view switcher |

**Tangent** is effectively **always Live Preview-class**: markup hides/reveals with the caret; there is no first-class Source/Reading product surface. Stack: Electron + **Typewriter** (forked submodule) + hand-rolled `NoteParser` + custom elements (`t-link`, `t-checkbox`, `t-math`, `t-code-preview`). Fenced code languages via **Prism.js**; Mermaid via special preview element.[^tangent-readme][^tangent-md-syntax][^tangent-code-syntax]

**Neovim** assembly tiers:

| Tier | Mechanism | Closeness to Obsidian LP |
|---|---|---|
| Syntax only | treesitter / vim syntax | Far |
| In-buffer soft render | e.g. `render-markdown.nvim` (extmarks/virtual text) | Soft WYSIWYG, not true LP |
| Side browser preview | e.g. `markdown-preview.nvim`, `live-preview.nvim` | Closest to “pane off to the side” |
| Hybrid | Soft render + browser | Common “notes in nvim” setup |

Local environment note: NVIM v0.12.x present; `~/.config/nvim/init.vim` shares classic Vim runtimepath (including UDON pack under `~/.vim`).

### 4.2 Extension / mutability

| | Obsidian | Tangent | Neovim |
|---|---|---|---|
| First-class plugins | **Yes** (TypeScript API)[^obsidian-developers] | **No** community plugin API | **Yes** (Lua/Vim, open-ended) |
| Look without forking | Themes, CSS snippets, plugins | **Custom CSS** (`.tangent/styles`, path-scoped `PATH_*`)[^tangent-css] | Colorschemes, UI plugins |
| Change core behavior | Limited (proprietary) | **Edit monorepo** (Apache 2.0) | Edit config + plugins + optionally source |
| Fair mutability framing | High *plugin* extensibility; low *core* mutability | Low *plugin* ecosystem; high *source* mutability | High on both axes |

Correction: scoring Tangent “plugin ease: 1” as if it could not be mutated was wrong. Open source without plugins is often *stronger* for app-level change than proprietary-with-plugins; cost is rebuild/rebase, not lock-out.

### 4.3 Custom syntax / UDON on each host

UDON UX ranking (existing project discipline):[^udon-human-ux]

1. **Parser-event / span paint** (never disagrees with parser) — shipping in Obsidian via `udon.wasm`
2. **CodeMirror multi-line** — good host for novel syntax
3. **TextMate** — awkward cross-line state
4. **tree-sitter** — useful for nvim/helix/zed; spike still fidelity-limited vs real parser

| Host | UDON path | Notes |
|---|---|---|
| Obsidian | `obsidian-udon` + wasm | Highlighting strong; **editing UX** still the open umbrella item[^udon-human-ux] |
| Tangent | Prism for ```` ```udon ```` only; full `.udon` = deep model work | Product is MD-first `NoteParser`; steal architecture, don’t pretend UDON is MD[^tangent-code-syntax] |
| Neovim | `vim/` pack + `tree-sitter-udon` spike; LSP semantic tokens planned | Multi-repo natural; visual LP/table UX poor |

### 4.4 When to trial which

| Goal | Lean |
|---|---|
| Pure MD “always LP” writing app, open source | **Tangent** smoke test |
| Multi-repo + harnesses + UDON syntax pack | **Neovim** (and/or keep Obsidian as shell) |
| Rich structure widgets + designed source fonts for UDON | See [§5](#5-specialized-udon-editor--host-choice) |

---

## 5. Specialized UDON editor — host choice

### 5.1 What current UDON UX actually shipped

Deliberate narrow scope (safety + fidelity):[^udon-ux-readme][^udon-plugin-main]

| Shipped | Role |
|---|---|
| Open `.udon` | Custom `TextFileView` + bare CM6 |
| Indent / Tab / Enter | 2-space only; soft wrap (anti-reflow-hazard) |
| Folding | Indent hierarchy |
| Highlighting | Parser-true wasm event spans |
| Autocolors | Scheme name as seed |
| ```` ```udon ```` in MD | Paint in Reading / LP / Source |

**Explicitly future / open:** Markdown rendering of prose; dual modes; hanging soft-wrap indent; structure widgets; table cell UX; mixed typography; “get editing to work” residual.[^udon-human-ux]

July review load-bearing point: unaware editors fail **silently** (reflow landing `:attr` / `;-)` / `!important` at line start *promotes* to structure). Soft-wrap + under-highlight + indent safety are necessary, not sufficient, for a specialized authoring product.[^udon-review]

### 5.2 Markdown layers law (don’t conflate)

From design notes:[^udon-md-layers]

| Layer | Meaning |
|---|---|
| **1** | Markdown *inside* UDON prose (parser-opaque; named subset for renderers) |
| **2** | Doc-schema vocabulary (`|h1`, tables as elements, …) — schema, not core syntax |
| **3** | Conversion to/from pure Markdown (lossy for general UDON) |
| **4** | Presentation (ANSI, HTML, Obsidian view, future widgets) |

Core parser knows none of Layers 1–4 as “markdown product.” A specialized editor is Layer-4 (+ optional Layer-2 chrome) over real parse structure + prose regions.

### 5.3 Gap vs good Markdown editing

| Affordance | UDON plugin today |
|---|---|
| Live Preview (markup melts) | No (source + marks) |
| Source with mixed proportional/mono fonts | No (feasible in CM; not wired) |
| Google-doc-like table (Tab between cells) | No |
| Interactive lists/checkboxes | No |
| Reading view for `.udon` | Seam only |
| Graph/backlinks as first-class for `.udon` | Platform-second-class historically; host-as-markdown experiments ongoing in TODO |

### 5.4 Flexibility ranking for structure-rich, evolving UDON UI

| Rank | Host | Freedom | Trap |
|---|---|---|---|
| 1 | **Thin shell** (Electron/Tauri + CM6 *or* ProseMirror) + `udon-wasm` | Maximum | Own the shell |
| 2 | **Tangent monorepo** (deep integrate) | Very high rich-text patterns (Typewriter, custom elements) | PKM product baggage; one workspace root |
| 3 | **Obsidian `UdonView` rewrite** | High inside the view; wasm already live | Vault isolation; host ceilings |
| 4 | **VS Code Custom Editor** | High dedicated surface | Extension boilerplate |
| 5 | **Neovim** | High commands/LSP/multi-repo | Low Google-doc visual bar |

Among “options so far” only: **Tangent (source) and Obsidian (custom view)** can grow into the named UI; **Neovim** is companion, not primary visual authoring surface.

---

## 6. CodeMirror 6 vs ProseMirror

Same designer (Marijn Haverbeke); different document models.[^codemirror][^prosemirror]

| | **CodeMirror 6** | **ProseMirror** |
|---|---|---|
| Model | Text (string/rope) + decorations | Schema tree (nodes + marks) |
| Default metaphor | Source typing | Structured rich text |
| Tables / cell Tab | DIY widgets + rewrite source | Node views / table nodes |
| Syntax-as-authority | Natural | Requires honest serialize round-trip |
| Mixed fonts in source | Natural (marks/CSS) | Secondary |
| Current UDON work | Already on CM6 | Green field mapping |
| TipTap | — | Popular PM product layer |

**Rule of thumb:** If **file bytes are the product**, start CM6. If **structure is the product** and text is serialization, start ProseMirror only after UDON layout-significant round-trip is credible. Hybrid (CM source mode + PM/structure mode) is a known pattern and more work.

### 6.1 CodeMirror in tools we discussed

| Tool | Inner editor |
|---|---|
| Obsidian | **CM6**[^obsidian-credits] |
| Joplin (source MD) | **CodeMirror** (CM6 path)[^joplin-cm6] |
| Tangent | **Typewriter**, not CM |
| AFFiNE / DeepNotes-class | Block / TipTap-family stacks |
| VS Code | **Monaco** (not CM) |
| Neovim | Own engine |

**Electron + CM6** is a standard recipe (Chromium window → web UI → `EditorView`). Tauri + CM is the same editor with a lighter shell. Obsidian is the flagship of Electron + CM6 + Markdown product.[^codemirror]

---

## 7. Vim stacks — emulation vs embed

### 7.1 Two meanings of “vim keybindings”

1. **Emulation** — host buffer; JS/TS reimplements modes/motions (always incomplete).  
2. **Neovim as engine** — nvim owns buffers via msgpack RPC / `--embed` / UI protocol; host is a remote display or bridge.[^neovim-rpc]

```
Full Neovim (terminal / Neovide / …)
    ↑
vscode-neovim (Monaco host, nvim engine)
    ↑
IdeaVim ≈ VSCodeVim  (mature emulators)
@replit/codemirror-vim
    ↑
thin hjkl maps
```

**Fidelity vs host product power** generally trade off: pure nvim wins language purity; Obsidian/CM/JetBrains win product features; emulators sit in the middle band.

### 7.2 Layer hygiene: engines vs Vim layers

| Layer | Main players |
|---|---|
| **Editor engines (web)** | **CodeMirror 6**, **Monaco** (Ace historical) |
| **Vim on those engines** | **@replit/codemirror-vim** on CM; **VSCodeVim** or **vscode-neovim** on Monaco/VS Code |
| **JetBrains** | **IdeaVim** on the IntelliJ editor |

Monaco is **not** a peer of codemirror-vim; Monaco peers with **CodeMirror**. codemirror-vim peers with **VSCodeVim**.

### 7.3 Highest-fidelity Vim *for CM6*

Essentially one package: **[@replit/codemirror-vim](https://github.com/replit/codemirror-vim)** (`@replit/codemirror-vim`), with shared `@replit/codemirror-vim-core` engine (CM5/CM6).[^replit-cm-vim]

App sugar (Obsidian vim + vimrc-support plugins, Joplin vim mode) improves **host integration**, not engine class. There is no mature “nvim embedded in CM6” default path comparable to vscode-neovim.

**What even the best CM vim leaves out:** full Ex (`:g`, real `:%s`), plugin platform, real vimrc/Lua, exact register/block/macro semantics, multi-cursor coexistence, soft-wrap/widget edge cases, OS clipboard vs Vim registers.

### 7.4 IdeaVim and the emulator family

| Name | Host | Class |
|---|---|---|
| IdeaVim | JetBrains IDEs | Emulation + strong IDE action bridges |
| VSCodeVim | VS Code | Dominant emulation path |
| vscode-neovim | VS Code | **Real nvim** backend |
| @replit/codemirror-vim | CM5/CM6 hosts | Dominant CM path |
| Vrapper | Eclipse | Older |

### 7.5 Concrete tradeoff examples

#### Motions

- **`ci"` / nested textobjects:** nvim (+ treesitter textobjects) reliable; emulators happy-path only.  
- **Visual block `Ctrl-v` + `I` / paste:** solid in nvim; classic VSCodeVim/CM pain (selection model mismatch).[^vscodevim-vs-neovim]  
- **Soft-wrapped prose:** buffer vs screen lines (`j`/`gj`); CM notes apps amplify confusion.

#### Macros / `.`

- nvim: keystroke macros and `.` are workflow foundations.  
- Emulators: macros miss host events (LSP, format-on-save, autocomplete); `.` often ignores IDE/CM widget edits.

#### Registers / clipboard

- nvim: `"_dd`, `"0`, `"+` distinct.  
- Emulators: often collapse toward one clipboard; mouse copy desyncs named registers.

#### Ex command line

| Command | nvim | Typical emulator |
|---|---|---|
| `:w` | OK | Often mapped to host save |
| `:%s//gc`, `:g//d` | Real | Toy or missing |
| `:norm`, `:bufdo`, quickfix | Core | Host search UI instead |

#### Platform

| Ritual | nvim | CM vim | IdeaVim | vscode-neovim |
|---|---|---|---|---|
| Full Lazy.nvim / runtimepath | Yes | No | No | Yes |
| UDON `vim/` pack as-is | Yes | Reimplement in CM | N/A | Yes |
| Leader → IDE Rename / vault command | Via LSP/Lua | Host maps | **Strong** | Mix |

#### Host features vs modal purity

- Format-on-save / completion widgets interrupt operator-pending state.  
- vscode-neovim: higher fidelity, **sync ghost** class after external buffer rewrites.  
- CM Live Preview / replace decorations: motions walk **underlying text**, not rendered glyphs.  
- Multi-cursor (CM/Monaco) fights single-cursor Vim model.

#### Opposite wishes

| From → to | Wish |
|---|---|
| nvim → CM/Obsidian vim | Keep vault/preview/graph; accept fidelity ceiling |
| CM vim → nvim | Real macros/block/registers/plugins |
| VSCodeVim → vscode-neovim | Block mode + plugins |
| vscode-neovim → VSCodeVim | Fewer sync bugs, lighter stack |
| IdeaVim → nvim | One windowing model, real plugins |
| nvim → IdeaVim | Free enterprise refactor/navigation |

---

## 8. Agent harnesses (brief — not note apps)

Value for this estate lives in harnesses and optional hosts, not PKM AI features:

| Surface | Notes |
|---|---|
| Claude Code | Multi-surface CLI/IDE; commits/PRs; plugin packaging shape[^claude-plugins] |
| Aider | Tight git loop; `--watch-files` coexistence with external editors[^aider-git] |
| OpenCode | LSP optional; ACP for editor hosts; GitHub Action[^opencode-docs] |
| Codex | CLI + IDE extensions |
| Warp / Zed | Host third-party agents; do not replace billing/runtime of those agents[^zed-external-agents][^warp-agents] |

Grok-build plugin marketplace deliberately tracks Claude-compatible layout (`.claude-plugin` fallback).[^grok-marketplace]

---

## 9. Decision shortcuts (as of this write-up)

1. **Replacing Obsidian as pure MD shell:** Tangent is the closest open always-LP peer; Logseq file mode if outliner-native; Joplin if sync/encryption > in-repo MD.  
2. **Long-term multi-repo foundation:** editor over files (Neovim or Code-OSS/VS Code), not vault DB apps.  
3. **AI:** keep official harnesses; hosts optional.  
4. **Specialized UDON authoring product:**  
   - incremental path = deepen Obsidian `UdonView` (CM6 + wasm);  
   - max UI freedom = thin Electron/Tauri + CM6 (or PM if structure-first);  
   - best open rich-text codebase to graft = Tangent/Typewriter **if** willing to own a monorepo branch;  
   - Neovim = multi-repo/agent companion + syntax/LSP, not Google-doc tables.  
5. **Vim in a CM app:** `@replit/codemirror-vim`; do not expect Neovim platform fidelity.  
6. **Mutability:** prefer open cores when the specialized editor must evolve without permission of a plugin sandbox.

---

## 10. Coverage gaps & uncertainty

Carried from deep-research partial status and this pass:

- Ecosystem cadence for Standard Notes, DeepNotes, Tangent long-term bus factor — only partially quantified.  
- Dendron maintenance after ~2023 not re-verified.  
- Whether every agent CLI’s highlighter stack could host first-class `udon` without rebuild — not demonstrated product-wide.  
- Multi-agent same-file safety (hosts re-reading external disk changes) unevenly documented.  
- IdeaVim/VSCodeVim/CM-vim feature parity is **experiential** folklore plus architecture; not a formal conformance suite against Vim.  
- Joplin Server non-AGPL personal-use package notes not re-fetched this pass.  
- Obsidian multi-vault-as-adjunct over `~/src/arch/*` operational test not run here.

---

## 11. Suggested next experiments

1. **Tangent smoke (1–2 h):** pure-MD folder; Thread + Map; `.tangent/styles`.  
2. **Neovim notes smoke:** `render-markdown.nvim` + browser preview + existing UDON pack on an ASF tree.  
3. **UDON editor decision:** list 5–10 “done enough” interactions (table Tab, mixed fonts, LP prose only, hanging wrap, outline from parse) → classify decorations vs node views → pick CM deep vs thin shell vs Tangent graft.  
4. **Do not** start a full Tangent UDON fork until pure-MD UX wins a trial.

---

## Related in-repo docs

| Doc | Relation |
|---|---|
| [`README.md`](./README.md) | UDON UX lane index |
| [`TODO-HUMAN-UX.md`](./TODO-HUMAN-UX.md) | Open human editor/highlight work |
| [`TODO-AGENT-UX.md`](./TODO-AGENT-UX.md) | Agent-facing tooling lane |
| [`obsidian-udon/`](./obsidian-udon/) | Current CM6 + wasm plugin |
| `design/markdown-layers.md` (udon design tree) | Layer 1–4 law |
| `_archive/REVIEW-JULY-2026.md` | Silent reflow / editor necessity |

---

## Footnotes

[^asf-format]: ASF segment file conventions: `~/src/arch/asf/FORMAT.md` (git-backed per-segment Markdown as primary source foundation; Obsidian listed as human authoring platform, not durable store).

[^outline-views]: Outlines-as-views / identity-stable segments: firmatum Verisectorium claim notes and ASF outline generalization working notes (`claim-outline-as-view`, outline-segments generalization 2026-07-23).

[^obsidian-vaults]: Obsidian Help — Manage vaults; vaults are isolated folders/link scopes. Local: `obsidian-help/en/Files and folders/Manage vaults.md`. Nested vaults discouraged in product guidance.

[^obsidian-symlinks]: Obsidian Help — Symbolic links and junctions (official warnings about symlinks into vaults). Local: `obsidian-help/en/Files and folders/Symbolic links and junctions.md`.

[^obsidian-storage]: Obsidian Help — How Obsidian stores data (plain files in vault). Local: `obsidian-help/en/Files and folders/How Obsidian stores data.md`.

[^obsidian-views]: Obsidian Help — Views and editing mode (Reading / Live Preview / Source; side-by-side). Local: `obsidian-help/en/Editing and formatting/Views and editing mode.md`. Also: <https://help.obsidian.md/edit-and-read> (permalink `edit-and-read`).

[^obsidian-license]: Obsidian License Overview: <https://obsidian.md/license> — free for personal, commercial, non-profit, educational, government use under Obsidian’s terms; not an OSI open-source license for the app.

[^obsidian-developers]: Obsidian Help — Developers / community plugins: <https://docs.obsidian.md>; local `obsidian-help/en/Contributing to Obsidian/Developers.md`, `Extending Obsidian/Community plugins.md`.

[^obsidian-credits]: Obsidian Help — Credits (CodeMirror 6 contributions). Local: `obsidian-help/en/Obsidian/Credits.md`.

[^joplin-license]: Joplin monorepo LICENSE (AGPL-3.0-or-later default): <https://raw.githubusercontent.com/laurent22/joplin/dev/LICENSE>.

[^joplin-sqlite]: Joplin stores notes in SQLite; Markdown is the editing language with export paths (common developer comparison summary, e.g. 2026 Obsidian vs Joplin writeups citing SQLite path `~/.config/joplin-desktop/database.sqlite`).

[^joplin-cm6]: Joplin CodeMirror 6 editor / plugins (e.g. CM6 settings plugins on joplinapp.org; desktop CM6 move tracked in laurent22/joplin issues).

[^tangent-site]: Tangent Notes — open source Apache 2.0, local Markdown files: <https://www.tangentnotes.com/>; features: <https://www.tangentnotes.com/Features>; source: <https://github.com/suchnsuch/Tangent>.

[^tangent-workspace]: Local clone docs: `~/src-ext/tangent/Documentation/The Workspace.md`, `Getting Started.md`, `Formatting/Markdown Syntax.md`.

[^tangent-readme]: `~/src-ext/tangent/README.md` — Typewriter submodule, Electron app, always-styled markdown.

[^tangent-md-syntax]: `~/src-ext/tangent/Documentation/Formatting/Markdown Syntax.md` — hide/reveal markup; fence-only code blocks deviation.

[^tangent-code-syntax]: `~/src-ext/tangent/apps/tangent-electron/src/common/markdownModel/codeSyntax.ts` — Prism-based fenced highlighting.

[^tangent-css]: `~/src-ext/tangent/Documentation/Configuration/Custom Styles.md` — `.tangent/styles`, path-based `PATH_*` classes.

[^reor-archive]: reorproject/reor GitHub repository archived read-only (~2026-03-07): <https://github.com/reorproject/reor>.

[^affine-about]: AFFiNE about / licensing (MIT client areas; enterprise server; TOEVERYTHING PTE. LTD.): <https://affine.pro/about-us>.

[^logseq-db]: Logseq DB version notes and community discussion on file vs DB graphs (git workflows require plain-text Markdown/Org modes). See Logseq docs `db-version-changes` and forum threads on DB backwards compatibility.

[^neovim-license]: neovim/neovim `LICENSE.txt` (Apache 2.0 with Vim-licensed and third-party exceptions): <https://github.com/neovim/neovim/blob/master/LICENSE.txt>.

[^vscode-license]: Visual Studio Code FAQ — licensing: product distribution vs MIT Code - OSS: <https://code.visualstudio.com/docs/supporting/faq>.

[^dendron-multivault]: Dendron multi-vault support wiki: <https://wiki.dendron.so/notes/45cfb9f2-46cf-4f67-a41e-834818fbd06e/> (maintenance status not re-audited this pass).

[^udon-human-ux]: This tree: [`TODO-HUMAN-UX.md`](./TODO-HUMAN-UX.md) — wasm event-stream highlighting, Obsidian plugin open items, tree-sitter vs parser fidelity.

[^udon-ux-readme]: [`README.md`](./README.md) — safeset philosophy, shipped surfaces, deferred reading mode.

[^udon-plugin-readme]: [`obsidian-udon/README.md`](./obsidian-udon/README.md) — parser-driven highlighting, autocolors.

[^udon-plugin-main]: [`obsidian-udon/main.js`](./obsidian-udon/main.js) — scope comments: CM6 view, indent, wasm highlight, folding; MD prose rendering future.

[^udon-review]: UDON estate review July 2026 (`_archive/REVIEW-JULY-2026.md` §3.4–3.6) — `;` subtlety; silent reflow promotion; editor support as near-mandatory.

[^udon-md-layers]: `design/markdown-layers.md` (udon design) — four layers; promoted toward `spec/MARKDOWN.md`.

[^codemirror]: CodeMirror project: <https://codemirror.net/> — extensible web code editor component.

[^prosemirror]: ProseMirror toolkit: <https://prosemirror.net/> — structured document editing; schema, nodes, node views.

[^replit-cm-vim]: replit/codemirror-vim: <https://github.com/replit/codemirror-vim> — `@replit/codemirror-vim`, core engine package; CM5 vim keymap maintenance pointed here from historic CM demos.

[^neovim-rpc]: Neovim msgpack-RPC, `--embed`, remote UI — first-class remote API design (see Neovim docs on API and UI protocol).

[^vscodevim-vs-neovim]: Community comparison of VSCodeVim vs vscode-neovim (e.g. visual block / selection fidelity discussions such as Galen Wong’s write-up on choosing vscode-neovim).

[^zed-external-agents]: Zed External Agents / ACP: <https://zed.dev/docs/ai/external-agents>; subscription vs API notes in Zed “use an existing subscription” docs.

[^warp-agents]: Warp third-party CLI agents overview: <https://docs.warp.dev/agents/cli-agents/overview/>.

[^claude-plugins]: Claude Code plugins layout (slash commands, agents, skills, hooks; `.claude-plugin/plugin.json`) — local reference under `~/src-ext/claude-code/plugins` when present; official docs at code.claude.com.

[^aider-git]: Aider git integration: <https://aider.chat/docs/git.html> (auto-commit, watch mode).

[^opencode-docs]: OpenCode docs (LSP, ACP, GitHub Action): <https://opencode.ai/docs/lsp> and related.

[^grok-marketplace]: Grok-build plugin marketplace catalog (Claude-compatible index fallback) — `~/src-ext/grok-build` codegen marketplace sources when present.

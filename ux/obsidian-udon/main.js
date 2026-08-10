/*
 * UDON plugin for Obsidian.
 *
 * Plain CommonJS on purpose: no build step. Obsidian resolves `obsidian` and
 * the @codemirror/* packages at runtime for every plugin, so this file is the
 * checked-in, loadable artifact. Everything must live in this one file:
 * Obsidian's loader only loads main.js, and relative require() fails inside
 * a plugin (verified live 2026-07-16).
 *
 * Architecture (hybrid host, 2026-08-08):
 *   .udon / .ud / .un / .don open as Obsidian's built-in **markdown** view so the
 *   real note stack applies: wikilinks (click, complete, backlinks), vim mode,
 *   vimrc-support, editor settings, and other registerEditorExtension plugins.
 *   UDON-specific behavior (wasm highlighting, indent Tab/Enter, indent fold)
 *   is layered as gated CM6 extensions that arm only for those file types.
 *   Source mode is forced for UDON files so Live Preview does not mangle
 *   structure lines. Reading-view rendering of UDON prose is still FUTURE.
 *
 * Scope (deliberate, in priority order):
 *   1. .udon / .ud / .un / .don open as markdown notes (wikilinks + editor host).
 *      .ud, .un, and .don are short aliases for the same surface (vanilla udon;
 *      .un is the transitional short form used in verisectorium-style
 *      instances, e.g. terms/*.term.un; .ud is the short form used in
 *      paths-style instances, e.g. def/*.ud).
 *   2. Indentation behavior on UDON files: Enter maintains the current
 *      line's indent; Tab / Shift-Tab indent and dedent by 2 spaces; tabs
 *      are never inserted (the spec forbids them).
 *   3. Syntax highlighting -- driven by the REAL parser: udon-core compiled
 *      to WebAssembly (core/udon-wasm), whose event stream with byte spans
 *      is painted directly. Same walk as core/udon-core/examples/
 *      highlight.rs. There is no hand-maintained grammar here to drift from
 *      the spec; rebuild udon.wasm and the highlighting IS the current
 *      parser. Applies to whole .udon/.ud/.un/.don documents and to ```udon
 *      fences inside ordinary .md notes.
 *   4. Folding on indentation (UDON files only).
 *   4b. Autocolors (editors/autocolors/PLAN.md): the same wasm module
 *      generates a named, deterministic color scheme (the scheme NAME is
 *      the SEED) anchored to the live theme, injected as #udon-autocolors.
 *      Scheme name + on/off live in plugin settings.
 *   5. Markdown reading-view of UDON prose is FUTURE (force Source for now).
 *
 * Known trade-off of parser-driven highlighting: the wasm walk re-parses the
 * whole document on each edit (cheap -- the parser runs at hundreds of MB/s
 * and udon documents are small; the span cache absorbs scroll/viewport
 * churn). If a parser bug mis-paints, there is no independent second
 * opinion -- by design: spec/CORE.md is the authority and the parser is
 * measured against it by the compliance fixtures.
 */

'use strict';

const { Plugin } = require('obsidian');
const {
  EditorView, keymap, Decoration, ViewPlugin,
} = require('@codemirror/view');
const { indentMore, indentLess } = require('@codemirror/commands');
const { indentUnit, foldService } = require('@codemirror/language');
const {
  EditorState, Prec, RangeSetBuilder, Compartment,
} = require('@codemirror/state');

const INDENT = '  '; // 2 spaces; spec: "Spaces only, no tabs"
const UDON_EXTS = new Set(['udon', 'ud', 'un', 'don']);

/** Per-editor compartment: indent unit + indent fold only on UDON files. */
const udonFileConf = new Compartment();

/* ========================================================================
 * File / editor host helpers
 * ======================================================================== */

function isUdonExtension(ext) {
  return !!ext && UDON_EXTS.has(ext);
}

function isUdonFile(file) {
  return !!(file && isUdonExtension(file.extension));
}

/**
 * Resolve the vault file that owns a CM6 EditorView. Multi-pane safe:
 * match leaf.view.editor.cm, then fall back to activeEditor.
 */
function fileForEditorView(app, cmView) {
  let found = null;
  app.workspace.iterateAllLeaves((leaf) => {
    if (found) return;
    const v = leaf.view;
    if (!v || typeof v.getViewType !== 'function') return;
    if (v.getViewType() !== 'markdown') return;
    const cm = v.editor && v.editor.cm;
    if (!cm) return;
    if (cm === cmView || cm.dom === cmView.dom) found = v.file;
  });
  if (!found) {
    const ae = app.workspace.activeEditor;
    const cm = ae && ae.editor && ae.editor.cm;
    if (cm && (cm === cmView || cm.dom === cmView.dom)) found = ae.file;
  }
  return found;
}

function isUdonEditorView(app, cmView) {
  return isUdonFile(fileForEditorView(app, cmView));
}

/* ========================================================================
 * CodeMirror integration (UDON files only; gated at run time)
 * ======================================================================== */

/** Indentation-based folding (spec "Hierarchy"): a line folds the maximal
 *  run of following lines that are blank or more-indented.
 *  Installed only via udonFileConf on UDON editors (not on ordinary notes). */
const udonFoldService = foldService.of((state, lineStart, _lineEnd) => {
  const doc = state.doc;
  const line = doc.lineAt(lineStart);
  const text = line.text;
  if (text.trim().length === 0) return null;
  const indent = text.length - text.trimStart().length;
  let lastContent = null;
  for (let ln = line.number + 1; ln <= doc.lines; ln++) {
    const l = doc.line(ln);
    if (l.text.trim().length === 0) continue; // blank lines pass through
    const li = l.text.length - l.text.trimStart().length;
    if (li <= indent) break;
    lastContent = l;
  }
  if (!lastContent) return null;
  return { from: line.to, to: lastContent.to };
});

/** Extensions that should exist only while the editor is a UDON file. */
function udonFileOnlyExtensions() {
  return [
    indentUnit.of(INDENT),
    EditorState.tabSize.of(2),
    udonFoldService,
    // Hook for styles.css: monospace structure, proportional prose.
    // data-* attribute (not class) so we cannot lose a class-merge fight
    // with Obsidian's own editorAttributes.
    EditorView.editorAttributes.of({ 'data-udon-doc': '1' }),
    EditorView.contentAttributes.of({ 'data-udon-doc': '1' }),
  ];
}

/** Enter: maintain the current line's leading indentation. */
function insertNewlineKeepIndent(view) {
  const { state } = view;
  const changes = state.changeByRange((range) => {
    const line = state.doc.lineAt(range.head);
    const ws = /^[ ]*/.exec(line.text)[0];
    // If the cursor sits inside the leading whitespace, only carry what
    // precedes it (avoids pushing text rightwards unexpectedly).
    const col = range.head - line.from;
    const keep = col < ws.length ? ws.slice(0, col) : ws;
    const insert = '\n' + keep;
    return {
      changes: { from: range.from, to: range.to, insert },
      range: { anchor: range.from + insert.length, head: range.from + insert.length },
    };
  });
  view.dispatch(changes, { scrollIntoView: true, userEvent: 'input' });
  return true;
}

/** Tab: indent selection; otherwise insert two spaces (never a tab). */
function tabCommand(view) {
  const { state } = view;
  if (state.selection.ranges.some((r) => !r.empty)) return indentMore(view);
  const line = state.doc.lineAt(state.selection.main.head);
  const col = state.selection.main.head - line.from;
  const ws = /^[ ]*/.exec(line.text)[0];
  if (col <= ws.length) return indentMore(view); // in leading indent: indent line
  view.dispatch(state.replaceSelection(INDENT), { userEvent: 'input' });
  return true;
}

/** Keymap that no-ops (returns false) unless this CM view is a UDON file. */
function makeUdonKeymap(app) {
  const onlyUdon = (fn) => (view) => {
    if (!isUdonEditorView(app, view)) return false;
    return fn(view);
  };
  // Prec.high so we win over markdown list/indent handlers on UDON files;
  // on non-UDON files we return false and the next handler runs.
  return Prec.high(keymap.of([
    { key: 'Enter', run: onlyUdon(insertNewlineKeepIndent) },
    { key: 'Tab', run: onlyUdon(tabCommand) },
    { key: 'Shift-Tab', run: onlyUdon(indentLess) },
  ]));
}

/* ========================================================================
 * Parser-driven highlighting (the wasm engine + its three surfaces)
 * ========================================================================
 * Engine: core/udon-wasm (udon-core compiled to wasm32-unknown-unknown; raw
 * ABI, no wasm-bindgen). Landed as a spike 2026-07-16; both markdown-fence
 * surfaces validated in a live vault the same day, then promoted to the sole
 * highlighting source.
 *
 * Wasm ABI (core/udon-wasm/src/lib.rs):
 *   udon_alloc(len) -> ptr ; udon_highlight(ptr,len) -> [n,(start,end,cls)*n]
 *   as u32s ; udon_free / udon_free_result. Offsets are BYTE offsets;
 *   converted to UTF-16 offsets here for DOM/CM6.
 *
 * Surfaces:
 *   1. Reading view: a MarkdownPostProcessor takes over
 *      `pre > code.language-udon` blocks and span-paints them (bypassing
 *      Prism -- the language-* class is stripped so Prism's async pass
 *      leaves the block alone).
 *   2. Live Preview / Source mode on .md notes: a CM6 ViewPlugin scans
 *      lines for ```udon fences and decorates the fence body.
 *   3. Whole .udon / .ud / .un / .don documents (markdown host): gated ViewPlugin
 *      paints the whole document from one wasm walk.
 */

/* Token role names are read from the wasm module itself (udon_role_names),
 * so JS and Rust cannot drift. Populated on init; see roles.rs for the tree.
 * FALLBACK_ROLE keeps unpainted/unknown indices harmless. */
const FALLBACK_ROLE = 'dim';

/* ---------------------------------------------------------------- engine */

class UdonWasmHighlighter {
  constructor() {
    this.exports = null; // set once loaded
    this.cache = new Map(); // text -> spans (tiny LRU-ish; cleared at cap)
    this.roleNames = []; // read from the wasm module on init
  }

  /** Instantiate from raw wasm bytes (ArrayBuffer). */
  async init(wasmBytes) {
    const { instance } = await WebAssembly.instantiate(wasmBytes, {});
    this.exports = instance.exports;
    this.roleNames = this.readBytesResult(this.exports.udon_role_names())
      .split('\n');
  }

  get ready() { return !!this.exports; }

  /** Decode + free a [len:u32 LE][utf8] result from the wasm side. */
  readBytesResult(ptr) {
    const mem = this.exports.memory.buffer;
    const len = new Uint32Array(mem, ptr, 1)[0];
    const text = new TextDecoder().decode(new Uint8Array(mem, ptr + 4, len));
    this.exports.udon_free_bytes(ptr);
    return text;
  }

  className(cls) {
    return 'udon-hl-' + (this.roleNames[cls] || FALLBACK_ROLE);
  }

  /**
   * Generate the CSS for a named autocolors scheme, anchored to the live
   * theme's background/foreground (0xRRGGBB ints). Deterministic: the
   * scheme NAME is the SEED (see core/udon-wasm/src/rng.rs — pinned).
   */
  themeCss(schemeName, bgRgb, fgRgb) {
    if (!this.exports) return null;
    const nameBytes = new TextEncoder().encode(schemeName);
    const { udon_alloc, udon_free, udon_theme } = this.exports;
    const nptr = udon_alloc(nameBytes.length);
    new Uint8Array(this.exports.memory.buffer, nptr, nameBytes.length).set(nameBytes);
    const res = udon_theme(nptr, nameBytes.length, bgRgb, fgRgb);
    const css = this.readBytesResult(res);
    udon_free(nptr, nameBytes.length);
    return css;
  }

  /**
   * Highlight `text`; returns [{from, to, cls}] with UTF-16 offsets,
   * ascending and tiling the whole string. Sync (wasm), fast.
   */
  highlight(text) {
    if (!this.exports) return null;
    const hit = this.cache.get(text);
    if (hit) return hit;

    const { bytes, byteToChar } = encodeUtf8WithMap(text);
    const { udon_alloc, udon_free, udon_highlight, udon_free_result } = this.exports;
    const ptr = udon_alloc(bytes.length);
    new Uint8Array(this.exports.memory.buffer, ptr, bytes.length).set(bytes);
    const res = udon_highlight(ptr, bytes.length);
    // Re-view memory after the call: it may have grown (detaching old views).
    const view = new Uint32Array(this.exports.memory.buffer, res);
    const n = view[0];
    const spans = [];
    for (let i = 0; i < n; i++) {
      const from = byteToChar[view[1 + i * 3]];
      const to = byteToChar[view[2 + i * 3]];
      const cls = view[3 + i * 3];
      if (to > from) spans.push({ from, to, cls });
    }
    udon_free_result(res);
    udon_free(ptr, bytes.length);

    if (this.cache.size > 64) this.cache.clear();
    this.cache.set(text, spans);
    return spans;
  }
}

/** UTF-8 encode with a byte-offset -> UTF-16-offset map (byteToChar[b]). */
function encodeUtf8WithMap(text) {
  const maxBytes = text.length * 3 + 4; // 3 bytes per UTF-16 unit is the max ratio
  const bytes = new Uint8Array(maxBytes);
  const byteToChar = new Uint32Array(maxBytes + 1);
  let b = 0;
  for (let i = 0; i < text.length; i++) {
    const cp = text.codePointAt(i);
    const start = b;
    if (cp < 0x80) {
      bytes[b++] = cp;
    } else if (cp < 0x800) {
      bytes[b++] = 0xc0 | (cp >> 6);
      bytes[b++] = 0x80 | (cp & 0x3f);
    } else if (cp < 0x10000) {
      bytes[b++] = 0xe0 | (cp >> 12);
      bytes[b++] = 0x80 | ((cp >> 6) & 0x3f);
      bytes[b++] = 0x80 | (cp & 0x3f);
    } else {
      bytes[b++] = 0xf0 | (cp >> 18);
      bytes[b++] = 0x80 | ((cp >> 12) & 0x3f);
      bytes[b++] = 0x80 | ((cp >> 6) & 0x3f);
      bytes[b++] = 0x80 | (cp & 0x3f);
      i++; // consumed a surrogate pair
    }
    for (let k = start; k < b; k++) byteToChar[k] = cp > 0xffff ? i - 1 : i;
    if (cp > 0xffff) byteToChar[start] = i - 1; // pair starts at lead surrogate
  }
  byteToChar[b] = text.length;
  return { bytes: bytes.subarray(0, b), byteToChar };
}

/* ----------------------------------------- surface 1: Reading view (DOM) */

/**
 * MarkdownPostProcessor: span-paint udon code fences ourselves, bypassing
 * Prism. Register with a slightly negative sortOrder so we claim the block
 * before other processors look at it.
 */
function udonReadingViewProcessor(highlighter) {
  return (el /*, ctx */) => {
    const codes = el.querySelectorAll('pre > code[class*="language-udon"]');
    if (!codes.length) return;
    for (const code of codes) {
      // Strip the language-* marker so Obsidian's Prism pass skips it.
      code.classList.remove('language-udon');
      code.classList.add('udon-fence');
      const paint = () => {
        const spans = highlighter.highlight(code.textContent);
        if (!spans) return;
        const text = code.textContent;
        code.textContent = '';
        for (const { from, to, cls } of spans) {
          const s = document.createElement('span');
          s.className = highlighter.className(cls);
          s.textContent = text.slice(from, to);
          code.appendChild(s);
        }
      };
      if (highlighter.ready) paint();
      else if (highlighter.loading) highlighter.loading.then(paint).catch(() => {});
    }
  };
}

/* --------------------------------- surface 2: ```udon fences in .md (CM6) */

const FENCE_OPEN = /^(?:>\s*)*(\s*)(`{3,}|~{3,})\s*udon\b/;

/**
 * Find udon fences in the visible ranges and return mark decorations for
 * their bodies. Fence detection is line-regex-based on the document text —
 * independent of Obsidian's internal markdown syntax-node naming, at the
 * cost of not handling exotic containers (nested callout depth changes,
 * indented-code ambiguity). Spike trade-off, noted.
 *
 * Skipped entirely on .udon/.ud/.un/.don files (whole-doc paint owns those).
 */
function buildFenceDecorations(view, highlighter, app) {
  const builder = new RangeSetBuilder();
  if (!highlighter.ready) return builder.finish();
  if (isUdonEditorView(app, view)) return builder.finish();
  const doc = view.state.doc;
  // Whole-document line scan: correct when a fence opens above the viewport,
  // and O(doc) per update is fine at note scale (spike trade-off; the
  // production version would anchor on Obsidian's syntax tree).
  let ln = 1;
  while (ln <= doc.lines) {
    const open = doc.line(ln);
    const m = FENCE_OPEN.exec(open.text);
    if (!m) { ln++; continue; }
    const closer = new RegExp(
      '^(?:>\\s*)*\\s*' + m[2][0] + '{' + m[2].length + ',}\\s*$'
    );
    let end = doc.lines; // unclosed fence runs to EOF
    for (let k = ln + 1; k <= doc.lines; k++) {
      if (closer.test(doc.line(k).text)) { end = k - 1; break; }
    }
    if (ln + 1 <= end) {
      const bodyFrom = doc.line(ln + 1).from;
      const bodyTo = doc.line(end).to;
      const spans = highlighter.highlight(doc.sliceString(bodyFrom, bodyTo) + '\n');
      if (spans) {
        for (const { from: f, to: t, cls } of spans) {
          const a = bodyFrom + f;
          const b = Math.min(bodyFrom + t, bodyTo);
          if (b > a) {
            builder.add(a, b, Decoration.mark({ class: highlighter.className(cls) }));
          }
        }
      }
    }
    ln = end + 2; // skip past the closing fence line
  }
  return builder.finish();
}

function udonFenceEditorExtension(app, highlighter) {
  return ViewPlugin.fromClass(
    class {
      constructor(view) {
        this.decorations = buildFenceDecorations(view, highlighter, app);
        // If the wasm engine finishes loading after first paint, refresh.
        if (!highlighter.ready && highlighter.loading) {
          highlighter.loading.then(() => {
            this.decorations = buildFenceDecorations(view, highlighter, app);
            view.update([]); // no-op update to trigger redraw
          }).catch(() => {});
        }
      }
      update(u) {
        if (u.docChanged || u.viewportChanged) {
          this.decorations = buildFenceDecorations(u.view, highlighter, app);
        }
      }
    },
    { decorations: (v) => v.decorations },
  );
}

/* ----------------------- surface 3: whole .udon / .ud / .un / .don documents */

function buildDocDecorations(view, highlighter) {
  const builder = new RangeSetBuilder();
  if (!highlighter.ready) return builder.finish();
  const doc = view.state.doc;
  const text = doc.toString();
  const spans = highlighter.highlight(text.endsWith('\n') ? text : text + '\n');
  if (spans) {
    for (const { from, to, cls } of spans) {
      const b = Math.min(to, doc.length); // clamp: we may have appended '\n'
      if (b > from) {
        builder.add(from, b, Decoration.mark({ class: highlighter.className(cls) }));
      }
    }
  }
  return builder.finish();
}

/**
 * Whole-document highlighter for UDON files on the markdown host.
 * Arms only when the owning file's extension is udon/ud/un/don; otherwise
 * empty decorations so ordinary notes are untouched.
 *
 * Also owns udonFileConf: reconfigures indent unit + indent fold when the
 * editor's file type flips (or on first attach after a race).
 */
function udonDocEditorExtension(app, highlighter) {
  return ViewPlugin.fromClass(
    class {
      constructor(view) {
        this.app = app;
        this.highlighter = highlighter;
        this.isUdon = isUdonEditorView(app, view);
        this.confOn = null; // last udonFileConf arm state; null = never synced
        this.decorations = this.isUdon
          ? buildDocDecorations(view, highlighter)
          : Decoration.none;
        // Defer reconfigure: cannot dispatch during EditorView construction.
        queueMicrotask(() => this.syncFileConf(view));
        if (this.isUdon && !highlighter.ready && highlighter.loading) {
          highlighter.loading.then(() => {
            if (!this.isUdon) return;
            this.decorations = buildDocDecorations(view, highlighter);
            view.update([]); // no-op update to trigger redraw
          }).catch(() => {});
        }
      }
      syncFileConf(view) {
        if (this.confOn === this.isUdon) return;
        this.confOn = this.isUdon;
        try {
          view.dispatch({
            effects: udonFileConf.reconfigure(
              this.isUdon ? udonFileOnlyExtensions() : []
            ),
          });
        } catch (e) {
          // View may already be destroyed.
          this.confOn = null;
        }
      }
      update(u) {
        // Re-resolve file on any update: leaf can rebind, and first paint
        // sometimes races file attachment.
        const now = isUdonEditorView(this.app, u.view);
        if (now !== this.isUdon) {
          this.isUdon = now;
          this.decorations = now
            ? buildDocDecorations(u.view, this.highlighter)
            : Decoration.none;
          this.syncFileConf(u.view);
          return;
        }
        // First-paint race: file was missing at construct, attached since.
        if (this.confOn !== this.isUdon) this.syncFileConf(u.view);
        if (this.isUdon && u.docChanged) {
          this.decorations = buildDocDecorations(u.view, this.highlighter);
        }
      }
    },
    { decorations: (v) => v.decorations },
  );
}


/* ========================================================================
 * Autocolors: generated color schemes (editors/autocolors/PLAN.md)
 * ========================================================================
 * The wasm module carries the scheme generator (core/udon-wasm/src/
 * scheme.rs). At load — and again whenever Obsidian's theme CSS changes —
 * the plugin resolves the live theme's background/foreground, asks the
 * engine for the named scheme's CSS, and injects it as a <style> element.
 * The scheme name is a plugin setting; THE NAME IS THE SEED, so any string
 * is a scheme and the same name reproduces the same scheme everywhere.
 * Turning autocolors off falls back to styles.css's static role colors.
 */

const DEFAULT_SETTINGS = {
  autocolors: true,
  schemeName: 'mochi',
};

/** Resolve a CSS color (var reference, hex, rgb()) to a 0xRRGGBB int by
 *  letting the browser compute it on a probe element. Returns null when
 *  resolution is unavailable (e.g. headless smoke tests). */
function resolveCssColor(expr, prop) {
  try {
    const probe = document.createElement('div');
    probe.style.position = 'absolute';
    probe.style.visibility = 'hidden';
    probe.style.setProperty(prop === 'background' ? 'background-color' : 'color', expr);
    document.body.appendChild(probe);
    const computed = getComputedStyle(probe)[
      prop === 'background' ? 'backgroundColor' : 'color'
    ];
    probe.remove();
    const m = /rgba?\(\s*(\d+)[\s,]+(\d+)[\s,]+(\d+)/.exec(computed);
    if (!m) return null;
    return (Number(m[1]) << 16) | (Number(m[2]) << 8) | Number(m[3]);
  } catch (e) {
    return null;
  }
}

/** The live theme's anchors, with dark-theme fallbacks. */
function themeAnchors() {
  const bg = resolveCssColor('var(--background-primary)', 'background');
  const fg = resolveCssColor('var(--text-normal)', 'color');
  return {
    bg: bg == null ? 0x1e1e1e : bg,
    fg: fg == null ? 0xdadada : fg,
  };
}

module.exports = class UdonPlugin extends Plugin {
  async onload() {
    this.settings = Object.assign({}, DEFAULT_SETTINGS, await this.loadData());

    // The single highlighting engine, shared by all three surfaces. Views
    // and extensions register immediately; painting starts once the wasm
    // engine is up (each surface refreshes itself on `loading`).
    const highlighter = new UdonWasmHighlighter();
    this.highlighter = highlighter;
    highlighter.loading = this.app.vault.adapter
      .readBinary(`${this.manifest.dir}/udon.wasm`)
      .then((buf) => highlighter.init(buf))
      .then(() => this.applyAutocolors())
      .catch((e) => console.error('UDON: wasm highlighter failed to load', e));

    // Host: open UDON files as markdown so wikilinks, vim, and the rest of
    // the note editor stack apply. Register each extension independently so
    // a conflict on one (another plugin claiming it) does not block others.
    for (const ext of UDON_EXTS) {
      try {
        this.registerExtensions([ext], 'markdown');
      } catch (e) {
        console.error(`UDON: could not register .${ext} as markdown`, e);
      }
    }

    // Guest: UDON behavior layered on the markdown host (gated by file type).
    // udonFileConf starts empty; udonDocEditorExtension reconfigures it when
    // the editor is a .udon/.ud/.un/.don file (indent unit + indent fold).
    this.registerEditorExtension([
      udonFileConf.of([]),
      makeUdonKeymap(this.app),
      udonDocEditorExtension(this.app, highlighter),
      udonFenceEditorExtension(this.app, highlighter),
    ]);

    this.registerMarkdownPostProcessor(udonReadingViewProcessor(highlighter), -50);

    // Force pure Source mode for UDON files (Live Preview mangles structure;
    // Reading view of UDON prose is future work).
    const forceSource = () => this.forceUdonSourceMode();
    this.app.workspace.onLayoutReady(forceSource);
    this.registerEvent(this.app.workspace.on('file-open', forceSource));
    this.registerEvent(this.app.workspace.on('layout-change', forceSource));
    this.registerEvent(this.app.workspace.on('active-leaf-change', forceSource));

    // Regenerate when the user switches Obsidian theme / light-dark mode:
    // the scheme is anchored to the live bg/fg, so it follows.
    this.registerEvent(this.app.workspace.on('css-change', () => this.applyAutocolors()));
    if (this.addSettingTab && typeof require === 'function') {
      try {
        const { PluginSettingTab, Setting } = require('obsidian');
        this.addSettingTab(new UdonSettingTab(this.app, this, PluginSettingTab, Setting));
      } catch (e) {
        console.error('UDON: settings tab unavailable', e);
      }
    }
  }

  /**
   * Keep every open UDON markdown leaf in pure Source mode
   * (mode: 'source', source: true). Live Preview treats structure lines as
   * markdown; Reading view is not yet a UDON surface.
   */
  forceUdonSourceMode() {
    this.app.workspace.iterateAllLeaves((leaf) => {
      const view = leaf.view;
      if (!view || typeof view.getViewType !== 'function') return;
      if (view.getViewType() !== 'markdown') return;
      if (!isUdonFile(view.file)) return;

      const vs = leaf.getViewState();
      const st = vs.state || {};
      // mode 'source' + source true = pure Source (not Live Preview).
      if (st.mode === 'source' && st.source === true) return;

      leaf.setViewState({
        ...vs,
        state: Object.assign({}, st, { mode: 'source', source: true }),
      });
    });
  }

  /** (Re)generate and inject the autocolors stylesheet. */
  applyAutocolors() {
    if (!this.styleEl) {
      this.styleEl = document.createElement('style');
      this.styleEl.id = 'udon-autocolors';
      document.head.appendChild(this.styleEl);
      this.register(() => this.styleEl.remove());
    }
    if (!this.settings.autocolors || !this.highlighter.ready) {
      this.styleEl.textContent = '';
      return;
    }
    const { bg, fg } = themeAnchors();
    const css = this.highlighter.themeCss(this.settings.schemeName || 'mochi', bg, fg);
    if (css) this.styleEl.textContent = css;
  }

  async saveSettings() {
    await this.saveData(this.settings);
    this.applyAutocolors();
  }

  onunload() {
    // Obsidian detaches registered views/extensions automatically; the
    // autocolors <style> element is removed via this.register above.
  }
};

class UdonSettingTab {
  constructor(app, plugin, PluginSettingTab, Setting) {
    // Composition rather than inheritance so main.js stays loadable in
    // headless smoke tests where `obsidian` is stubbed minimally.
    const tab = new PluginSettingTab(app, plugin);
    tab.display = () => {
      const { containerEl } = tab;
      containerEl.empty();
      new Setting(containerEl)
        .setName('Autocolors')
        .setDesc('Generate the UDON color scheme from the scheme name (the name is the seed). Off = static fallback colors.')
        .addToggle((t) => t
          .setValue(plugin.settings.autocolors)
          .onChange(async (v) => {
            plugin.settings.autocolors = v;
            await plugin.saveSettings();
          }));
      new Setting(containerEl)
        .setName('Scheme name')
        .setDesc('Any string is a scheme. Same name, same colors, everywhere, forever. Try a few until one sings.')
        .addText((t) => t
          .setPlaceholder('mochi')
          .setValue(plugin.settings.schemeName)
          .onChange(async (v) => {
            plugin.settings.schemeName = v.trim() || 'mochi';
            await plugin.saveSettings();
          }));
    };
    return tab;
  }
}

/*
 * UDON plugin for Obsidian.
 *
 * Plain CommonJS on purpose: no build step. Obsidian resolves `obsidian` and
 * the @codemirror/* packages at runtime for every plugin, so this file is the
 * checked-in, loadable artifact. Everything must live in this one file:
 * Obsidian's loader only loads main.js, and relative require() fails inside
 * a plugin (verified live 2026-07-16).
 *
 * Scope (deliberate, in priority order):
 *   1. .udon files open at all (extension registration + a TextFileView
 *      wrapping a CodeMirror 6 editor).
 *   2. Indentation behavior: Enter maintains the current line's indent;
 *      Tab / Shift-Tab indent and dedent by 2 spaces; tabs are never
 *      inserted (the spec forbids them).
 *   3. Syntax highlighting -- driven by the REAL parser: udon-core compiled
 *      to WebAssembly (core/udon-wasm), whose event stream with byte spans
 *      is painted directly. Same walk as core/udon-core/examples/
 *      highlight.rs. There is no hand-maintained grammar here to drift from
 *      the spec; rebuild udon.wasm and the highlighting IS the current
 *      parser. (A hand-written "safeset" line scanner played this role
 *      until 2026-07-16 -- retired in favor of the wasm walk; git has it.)
 *      Applies to both .udon files and ```udon fences in markdown notes.
 *   4. Folding on indentation.
 *   5. Markdown rendering of prose is FUTURE. The seam is UdonView: it owns
 *      a single "source" editor today; a reading sub-view that walks prose
 *      spans through MarkdownRenderer can be added beside it.
 *
 * Known trade-off of parser-driven highlighting: the wasm walk re-parses the
 * whole document on each edit (cheap -- the parser runs at hundreds of MB/s
 * and .udon documents are small; the span cache absorbs scroll/viewport
 * churn). If a parser bug mis-paints, there is no independent second
 * opinion -- by design: spec/CORE.md is the authority and the parser is
 * measured against it by the compliance fixtures.
 */

'use strict';

const { Plugin, TextFileView } = require('obsidian');
const { EditorState } = require('@codemirror/state');
const {
  EditorView, keymap, drawSelection, highlightActiveLine,
  Decoration, ViewPlugin,
} = require('@codemirror/view');
const {
  history, historyKeymap, defaultKeymap, indentMore, indentLess,
} = require('@codemirror/commands');
const {
  indentUnit, foldService, foldGutter, codeFolding, foldKeymap,
} = require('@codemirror/language');
const { RangeSetBuilder } = require('@codemirror/state');

const VIEW_TYPE_UDON = 'udon-view';
const INDENT = '  '; // 2 spaces; spec: "Spaces only, no tabs"

/* ========================================================================
 * CodeMirror integration
 * ======================================================================== */

/** Indentation-based folding (spec "Hierarchy"): a line folds the maximal
 *  run of following lines that are blank or more-indented. */
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

const udonKeymap = keymap.of([
  { key: 'Enter', run: insertNewlineKeepIndent },
  { key: 'Tab', run: tabCommand },
  { key: 'Shift-Tab', run: indentLess },
]);

function udonExtensions(onDocChanged, highlighter) {
  return [
    indentUnit.of(INDENT),
    EditorState.tabSize.of(2),
    udonKeymap,
    history(),
    drawSelection(),
    highlightActiveLine(),
    EditorView.lineWrapping, // soft-wrap: sidesteps the reflow hazard entirely
    codeFolding(),
    udonFoldService,
    foldGutter(),
    udonDocEditorExtension(highlighter),
    keymap.of([...defaultKeymap, ...historyKeymap, ...foldKeymap]),
    EditorView.updateListener.of((u) => {
      if (u.docChanged) onDocChanged();
    }),
    EditorView.contentAttributes.of({ 'aria-label': 'UDON editor' }),
  ];
}

/* ========================================================================
 * Obsidian view + plugin
 * ======================================================================== */

class UdonView extends TextFileView {
  constructor(leaf, highlighter) {
    super(leaf);
    this.highlighter = highlighter;
    this.editor = null;
    this.pendingData = '';
  }

  getViewType() { return VIEW_TYPE_UDON; }
  getDisplayText() { return this.file ? this.file.basename : 'UDON'; }
  getIcon() { return 'file-text'; }

  async onOpen() {
    this.contentEl.empty();
    this.contentEl.addClass('udon-view');
    const host = this.contentEl.createDiv({ cls: 'udon-editor' });
    this.editor = new EditorView({
      state: EditorState.create({
        doc: this.pendingData || '',
        extensions: udonExtensions(() => this.requestSave(), this.highlighter),
      }),
      parent: host,
    });
  }

  async onClose() {
    if (this.editor) { this.editor.destroy(); this.editor = null; }
  }

  getViewData() {
    return this.editor ? this.editor.state.doc.toString() : this.pendingData;
  }

  setViewData(data, clear) {
    this.pendingData = data;
    if (!this.editor) return;
    if (clear) {
      // Fresh file: reset the editor state (drops undo history).
      this.editor.setState(EditorState.create({
        doc: data,
        extensions: udonExtensions(() => this.requestSave(), this.highlighter),
      }));
    } else {
      this.editor.dispatch({
        changes: { from: 0, to: this.editor.state.doc.length, insert: data },
      });
    }
  }

  clear() {
    this.pendingData = '';
    if (this.editor) {
      this.editor.dispatch({
        changes: { from: 0, to: this.editor.state.doc.length, insert: '' },
      });
    }
  }
}

/* ========================================================================
 * Parser-driven highlighting (the wasm engine + its three surfaces)
 * ========================================================================
 * Engine: core/udon-wasm (udon-core compiled to wasm32-unknown-unknown; raw
 * ABI, no wasm-bindgen). Landed as a spike 2026-07-16; both markdown-fence
 * surfaces validated in a live vault the same day, then promoted to the sole
 * highlighting source (the .udon-file view below uses it too).
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
 *   2. Live Preview / Source mode: a CM6 ViewPlugin scans lines for
 *      ```udon fences (regex on fence lines -- deliberately NOT dependent
 *      on Obsidian's internal HyperMD syntax-node names) and decorates the
 *      fence body with mark decorations.
 *   3. The .udon-file view: udonDocEditorExtension paints the whole
 *      document from one wasm walk.
 */

/* Token classes — keep in sync with core/udon-wasm/src/lib.rs and styles.css */
const CLASS_NAMES = [
  'dim', 'name', 'attr', 'string', 'number', 'keyword',
  'text', 'comment', 'dynamic', 'reference', 'warning',
];

/* ---------------------------------------------------------------- engine */

class UdonWasmHighlighter {
  constructor() {
    this.exports = null; // set once loaded
    this.cache = new Map(); // text -> spans (tiny LRU-ish; cleared at cap)
  }

  /** Instantiate from raw wasm bytes (ArrayBuffer). */
  async init(wasmBytes) {
    const { instance } = await WebAssembly.instantiate(wasmBytes, {});
    this.exports = instance.exports;
  }

  get ready() { return !!this.exports; }

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
          s.className = 'udon-hl-' + CLASS_NAMES[cls];
          s.textContent = text.slice(from, to);
          code.appendChild(s);
        }
      };
      if (highlighter.ready) paint();
      else if (highlighter.loading) highlighter.loading.then(paint).catch(() => {});
    }
  };
}

/* --------------------------------- surface 2: Live Preview / Source (CM6) */

const FENCE_OPEN = /^(?:>\s*)*(\s*)(`{3,}|~{3,})\s*udon\b/;

/**
 * Find udon fences in the visible ranges and return mark decorations for
 * their bodies. Fence detection is line-regex-based on the document text —
 * independent of Obsidian's internal markdown syntax-node naming, at the
 * cost of not handling exotic containers (nested callout depth changes,
 * indented-code ambiguity). Spike trade-off, noted.
 */
function buildFenceDecorations(view, highlighter) {
  const builder = new RangeSetBuilder();
  if (!highlighter.ready) return builder.finish();
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
            builder.add(a, b, Decoration.mark({ class: 'udon-hl-' + CLASS_NAMES[cls] }));
          }
        }
      }
    }
    ln = end + 2; // skip past the closing fence line
  }
  return builder.finish();
}

function udonFenceEditorExtension(highlighter) {
  return ViewPlugin.fromClass(
    class {
      constructor(view) {
        this.decorations = buildFenceDecorations(view, highlighter);
        // If the wasm engine finishes loading after first paint, refresh.
        if (!highlighter.ready && highlighter.loading) {
          highlighter.loading.then(() => {
            this.decorations = buildFenceDecorations(view, highlighter);
            view.update([]); // no-op update to trigger redraw
          }).catch(() => {});
        }
      }
      update(u) {
        if (u.docChanged || u.viewportChanged) {
          this.decorations = buildFenceDecorations(u.view, highlighter);
        }
      }
    },
    { decorations: (v) => v.decorations },
  );
}

/* ------------------------------------- surface 3: whole .udon documents */

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
        builder.add(from, b, Decoration.mark({ class: 'udon-hl-' + CLASS_NAMES[cls] }));
      }
    }
  }
  return builder.finish();
}

/** The .udon-file view's highlighter: one wasm walk paints the whole
 *  document. The highlight cache is keyed by full text, so scroll and
 *  selection churn cost nothing; only real edits re-parse. */
function udonDocEditorExtension(highlighter) {
  return ViewPlugin.fromClass(
    class {
      constructor(view) {
        this.decorations = buildDocDecorations(view, highlighter);
        if (!highlighter.ready && highlighter.loading) {
          highlighter.loading.then(() => {
            this.decorations = buildDocDecorations(view, highlighter);
            view.update([]); // no-op update to trigger redraw
          }).catch(() => {});
        }
      }
      update(u) {
        if (u.docChanged) this.decorations = buildDocDecorations(u.view, highlighter);
      }
    },
    { decorations: (v) => v.decorations },
  );
}


module.exports = class UdonPlugin extends Plugin {
  async onload() {
    // The single highlighting engine, shared by all three surfaces. Views
    // and extensions register immediately; painting starts once the wasm
    // engine is up (each surface refreshes itself on `loading`).
    const highlighter = new UdonWasmHighlighter();
    highlighter.loading = this.app.vault.adapter
      .readBinary(`${this.manifest.dir}/udon.wasm`)
      .then((buf) => highlighter.init(buf))
      .catch((e) => console.error('UDON: wasm highlighter failed to load', e));

    this.registerView(VIEW_TYPE_UDON, (leaf) => new UdonView(leaf, highlighter));
    try {
      this.registerExtensions(['udon'], VIEW_TYPE_UDON);
    } catch (e) {
      // Another plugin may have claimed .udon; don't break load.
      console.error('UDON: could not register .udon extension', e);
    }

    this.registerMarkdownPostProcessor(udonReadingViewProcessor(highlighter), -50);
    this.registerEditorExtension(udonFenceEditorExtension(highlighter));
  }

  onunload() {
    // Obsidian detaches registered views/extensions automatically.
  }
};

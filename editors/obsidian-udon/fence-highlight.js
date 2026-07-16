/*
 * SPIKE (2026-07-16) — parser-driven highlighting of ```udon fences in
 * Obsidian markdown notes. Status: wasm engine PROVEN under node; the two
 * Obsidian surfaces below are written to Obsidian's documented APIs but not
 * yet exercised inside a live vault. See editors/TODO-HUMAN-UX.md.
 *
 * The engine is NOT a grammar: it is udon-core (the real reference parser)
 * compiled to WebAssembly (core/udon-wasm), whose event stream with byte
 * spans is painted directly — the same walk as
 * core/udon-core/examples/highlight.rs. There is no third regex grammar to
 * keep in sync with the moving spec; regenerate udon.wasm and the
 * highlighting IS the current parser.
 *
 * Two surfaces:
 *   1. Reading view: a MarkdownPostProcessor that takes over
 *      `pre > code.language-udon` blocks and span-paints them itself
 *      (bypassing Prism entirely — we strip the language-* class so Prism's
 *      async pass leaves the block alone).
 *   2. Live Preview / Source mode: a CM6 ViewPlugin that scans visible
 *      lines for ```udon fences (regex on fence lines — deliberately NOT
 *      dependent on Obsidian's internal HyperMD syntax-node names) and
 *      decorates the fence body with mark decorations.
 *
 * Wasm ABI (core/udon-wasm/src/lib.rs):
 *   udon_alloc(len) -> ptr ; udon_highlight(ptr,len) -> [n,(start,end,cls)*n]
 *   as u32s ; udon_free / udon_free_result. Offsets are BYTE offsets;
 *   this file converts to UTF-16 offsets for DOM/CM6.
 */

'use strict';

const { Decoration, ViewPlugin } = require('@codemirror/view');
const { RangeSetBuilder } = require('@codemirror/state');

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

module.exports = {
  UdonWasmHighlighter,
  udonReadingViewProcessor,
  udonFenceEditorExtension,
  encodeUtf8WithMap, // exported for the node harness
  buildFenceDecorations, // exported for testing
  CLASS_NAMES,
};

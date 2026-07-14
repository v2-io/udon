/*
 * UDON plugin for Obsidian.
 *
 * Plain CommonJS on purpose: no build step. Obsidian resolves `obsidian` and
 * the @codemirror/* packages at runtime for every plugin, so this file is the
 * checked-in, loadable artifact.
 *
 * Scope (deliberate, in priority order):
 *   1. .udon files open at all (extension registration + a TextFileView
 *      wrapping a CodeMirror 6 editor).
 *   2. Indentation behavior: Enter maintains the current line's indent;
 *      Tab / Shift-Tab indent and dedent by 2 spaces; tabs are never
 *      inserted (the spec forbids them).
 *   3. Safeset syntax highlighting -- only constructs whose parse is
 *      unambiguous from local context. Under-highlight rather than
 *      mis-highlight: a wrong color teaches a wrong parse.
 *   4. Folding on indentation.
 *   5. Markdown rendering of prose is FUTURE. The seam is UdonView: it owns
 *      a single "source" editor today; a reading sub-view that walks prose
 *      spans through MarkdownRenderer can be added beside it without
 *      touching the tokenizer.
 *
 * Highlighting fidelity notes (spec: spec/FULL-SPEC.md, v0.7-draft):
 *   - `;` is context-sensitive. It is colored as a comment ONLY where the
 *     spec says it is one: line-initial (block comment), or preceded by
 *     whitespace on a structure line (element/attr/directive sameline
 *     context). Semicolons inside block prose are literal and stay plain.
 *   - `\` escapes only at line start and only before one of  | ; : ! \
 *     (spec "Block-Level Escape"). `\hello` is prose, not an escape.
 *   - `|` opens an element only when followed by letter, `[`, `.`, `{`, or
 *     `'` (spec "Element recognition rule") -- and, in this safeset, only at
 *     line start or after whitespace on a structure line. A pipe inside a
 *     prose line is never highlighted (Markdown tables survive).
 *   - `!:lang:` raw blocks and ``` freeform blocks suppress all UDON
 *     highlighting for their (indentation-delimited) bodies.
 *   - Bare attribute values are left plain unless the whole value is
 *     syntactically typed (quoted string, number, true/false/null/nil,
 *     [list], !{{interpolation}}).
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
 * Tokenizer (safeset)
 * ======================================================================== */

// Decoration cache keyed by class name.
const marks = {};
function mark(cls) {
  return marks[cls] || (marks[cls] = Decoration.mark({ class: cls }));
}

const RE_NUMBER = /^-?(?:0x[0-9a-fA-F][0-9a-fA-F_]*|0o[0-7][0-7_]*|0b[01][01_]*|[0-9][0-9_]*(?:\.[0-9][0-9_]*)?(?:[eE][+-]?[0-9]+)?(?:\/[0-9][0-9_]*r)?)$/;
const RE_CONSTANT = /^(?:true|false|null|nil)$/;
const RE_NAME = /^[A-Za-z][A-Za-z0-9_-]*/;

function classifyScalar(tokenText) {
  if (RE_CONSTANT.test(tokenText)) return 'udon-constant';
  if (RE_NUMBER.test(tokenText)) return 'udon-number';
  return null; // bare string: leave plain
}

/**
 * First pass over the whole document: which lines are inside raw (!:lang:)
 * or freeform (```) bodies?  Returns array of 'n' | 'raw' | 'free' per line
 * (state applying to that line's content).
 *
 * Safeset simplifications (documented limitations):
 *   - only line-initial ``` fences open/close freeform (sameline fences are
 *     left alone -- matching current parser behavior, REVIEW defect #10);
 *   - raw bodies end at the first non-blank line indented <= the directive.
 */
function computeLineModes(lines) {
  const modes = new Array(lines.length);
  let state = 'n';
  let rawIndent = 0;   // indent column of the !:lang: directive line
  let fenceIndent = 0; // indent column of the opening ```
  for (let i = 0; i < lines.length; i++) {
    const text = lines[i];
    const indent = text.length - text.trimStart().length;
    const rest = text.slice(indent);
    const blank = rest.length === 0;

    if (state === 'raw') {
      if (!blank && indent <= rawIndent) state = 'n'; // fall through, reclassify
      else { modes[i] = 'raw'; continue; }
    }
    if (state === 'free') {
      if (!blank && rest.startsWith('```') && indent <= fenceIndent) {
        modes[i] = 'fence-close';
        state = 'n';
        continue;
      }
      modes[i] = 'free';
      continue;
    }
    // normal
    // Freeform fences: spec allows ``` mid-line ("need not be at line
    // start"); everything after it belongs to the freeform block. Comment
    // lines are exempt (their content is comment, not structure).
    if (!blank && !rest.startsWith(';')) {
      const fi = text.indexOf('```');
      if (fi !== -1) {
        modes[i] = rest.startsWith('```') ? 'fence-open' : 'fence-sameline';
        state = 'free';
        fenceIndent = indent;
        continue;
      }
    }
    if (/^!:[A-Za-z][A-Za-z0-9_-]*:\s*$/.test(rest)) {
      modes[i] = 'raw-open';
      state = 'raw';
      rawIndent = indent;
      continue;
    }
    modes[i] = 'n';
  }
  return modes;
}

/**
 * Tokenize one normal-mode line. `push(fromCol, toCol, cls)` receives
 * column offsets within `text`.
 */
function tokenizeLine(text, push) {
  const indent = text.length - text.trimStart().length;
  const rest = text.slice(indent);
  if (rest.length === 0) return;

  const c0 = rest[0];

  // Line-initial comment (block comment; spec "Comments and Indentation").
  if (c0 === ';') {
    push(indent, text.length, 'udon-comment');
    return;
  }

  // Block-level escape: \ followed by a marker char, at line start.
  if (c0 === '\\' && rest.length > 1 && "|;:!\\".includes(rest[1])) {
    push(indent, indent + 2, 'udon-escape');
    scanProse(text, indent + 2, push);
    return;
  }

  // Element line: | followed by letter, [, ., {, or '
  if (c0 === '|' && rest.length > 1 && /[A-Za-z[.{']/.test(rest[1])) {
    scanStructure(text, indent, push);
    return;
  }

  // Block attribute line: : followed by a name or quoted key
  if (c0 === ':' && rest.length > 1 && /[A-Za-z_'"]/.test(rest[1])) {
    scanBlockAttribute(text, indent, push);
    return;
  }

  // Directive line
  if (c0 === '!') {
    if (rest.startsWith('!{{')) { scanProse(text, indent, push); return; }
    const raw = /^!:([A-Za-z][A-Za-z0-9_-]*):/.exec(rest);
    if (raw) {
      push(indent, indent + 2, 'udon-sigil');
      push(indent + 2, indent + 2 + raw[1].length, 'udon-raw-label');
      push(indent + 2 + raw[1].length, indent + raw[0].length, 'udon-sigil');
      // anything after the second colon on this line: leave plain (raw)
      return;
    }
    const name = RE_NAME.exec(rest.slice(1));
    if (name) {
      push(indent, indent + 1, 'udon-sigil');
      push(indent + 1, indent + 1 + name[0].length, 'udon-directive');
      scanStructure(text, indent + 1 + name[0].length, push, /*noComment*/ false);
      return;
    }
    // bare `!...` that isn't a recognizable directive: plain
    return;
  }

  // Anything else is prose.
  scanProse(text, indent, push);
}

/**
 * Block attribute line: `:key value with spaces ; comment`.
 * Value runs to end of line; ` ;` (space + semicolon) starts a comment.
 * The whole value is colored only when it is a single typed token.
 */
function scanBlockAttribute(text, indent, push) {
  const n = text.length;
  let i = indent;
  push(i, i + 1, 'udon-sigil'); // :
  i++;
  if (text[i] === "'" || text[i] === '"') {
    const q = text[i];
    let j = text.indexOf(q, i + 1);
    if (j === -1) j = n - 1;
    push(i, j + 1, 'udon-attr');
    i = j + 1;
  } else {
    const m = /^[A-Za-z_$][A-Za-z0-9_.$-]*/.exec(text.slice(i));
    if (m) { push(i, i + m[0].length, 'udon-attr'); i += m[0].length; }
  }
  // Comment split: first ` ;` after the key (block-attr context).
  let commentAt = -1;
  for (let j = i; j < n - 0; j++) {
    if (text[j] === ';' && j > 0 && (text[j - 1] === ' ' || text[j - 1] === '\t')) { commentAt = j; break; }
  }
  const valueEnd = commentAt === -1 ? n : commentAt;
  // Value: skip the single space after the key.
  let v = i;
  while (v < valueEnd && text[v] === ' ') v++;
  let e = valueEnd;
  while (e > v && (text[e - 1] === ' ' || text[e - 1] === '\t')) e--;
  if (e > v) {
    const val = text.slice(v, e);
    if (val[0] === '"' || val[0] === "'") {
      // color only if the quote closes at the value end
      const done = scanQuotedIfExact(text, v, e, push);
      if (!done) scanInlineForms(text, v, e, push);
    } else if (val[0] === '[' && val[val.length - 1] === ']') {
      scanList(text, v, push);
    } else {
      const cls = classifyScalar(val);
      if (cls) push(v, e, cls);
      else scanInlineForms(text, v, e, push); // e.g. !{{base}}/users/!{{id}}
    }
  }
  if (commentAt !== -1) push(commentAt, n, 'udon-comment');
}

/** Color [v, e) as a string only if it is exactly one quoted token. */
function scanQuotedIfExact(text, v, e, push) {
  const q = text[v];
  let j = v + 1;
  while (j < e) {
    if (text[j] === '\\') { j += 2; continue; }
    if (text[j] === q) break;
    j++;
  }
  if (j === e - 1) { push(v, e, 'udon-string'); return true; }
  return false;
}

/**
 * Scan a structure line (element/directive sameline context) from column
 * `i`. Recognizes: element identity chains, sameline attributes, inline
 * forms, whitespace-preceded `;` comments, quoted strings after attr keys.
 */
function scanStructure(text, i, push) {
  const n = text.length;
  let prevIsSpace = true; // at segment start, treat as boundary
  while (i < n) {
    const ch = text[i];

    if (ch === ' ' || ch === '\t') { prevIsSpace = true; i++; continue; }

    // Comment: `;` preceded by whitespace (sameline context)
    if (ch === ';' && prevIsSpace) {
      if (text[i + 1] === '{') { i = scanInlineComment(text, i, push); prevIsSpace = false; continue; }
      push(i, n, 'udon-comment');
      return;
    }

    if (ch === '|') {
      if (text[i + 1] === '{') { i = scanEmbedded(text, i, push); prevIsSpace = false; continue; }
      if (prevIsSpace === false) { i++; continue; } // mid-token pipe: plain
      if (/[A-Za-z[.']/.test(text[i + 1] || '')) { i = scanIdentity(text, i, push); prevIsSpace = false; continue; }
      i++; prevIsSpace = false; continue;
    }

    if (ch === '!') {
      if (text.startsWith('!{{', i)) { i = scanInterpolation(text, i, push); prevIsSpace = false; continue; }
      if (text[i + 1] === '{') { i = scanInlineDirective(text, i, push); prevIsSpace = false; continue; }
      i++; prevIsSpace = false; continue;
    }

    if (ch === ';' && text[i + 1] === '{') { i = scanInlineComment(text, i, push); prevIsSpace = false; continue; }

    // Sameline attribute: `:key` at a token boundary
    if (ch === ':' && prevIsSpace && /[A-Za-z_'"]/.test(text[i + 1] || '')) {
      i = scanAttrAndValue(text, i, push, /*sameline*/ true);
      prevIsSpace = false;
      continue;
    }

    // plain content: consume to next space (keeps boundaries honest)
    while (i < n && text[i] !== ' ' && text[i] !== '\t') i++;
    prevIsSpace = false;
  }
}

/** |name?[id].class chains. Returns index after the identity. */
function scanIdentity(text, i, push) {
  const n = text.length;
  push(i, i + 1, 'udon-sigil'); // |
  i++;
  // name
  const m = RE_NAME.exec(text.slice(i));
  if (m) { push(i, i + m[0].length, 'udon-element'); i += m[0].length; }
  for (;;) {
    const ch = text[i];
    if (ch === '[') {
      let j = text.indexOf(']', i + 1);
      if (j === -1) j = n - 1;
      push(i, i + 1, 'udon-sigil');
      if (j > i + 1) push(i + 1, j, 'udon-id');
      push(j, j + 1, 'udon-sigil');
      i = j + 1;
      continue;
    }
    if (ch === '.') {
      const cm = RE_NAME.exec(text.slice(i + 1));
      if (!cm) break;
      push(i, i + 1, 'udon-sigil');
      push(i + 1, i + 1 + cm[0].length, 'udon-class');
      i += 1 + cm[0].length;
      continue;
    }
    if (ch === '?' || ch === '*' || ch === '+' || ch === '!') {
      // suffix modifiers (spec "Element Suffixes")
      push(i, i + 1, 'udon-suffix');
      i++;
      continue;
    }
    break;
  }
  return i;
}

/** `:key value` -- key always; value only if syntactically typed. */
function scanAttrAndValue(text, i, push, sameline) {
  const n = text.length;
  push(i, i + 1, 'udon-sigil'); // :
  i++;
  // key: name, or quoted key like '$id'
  if (text[i] === "'" || text[i] === '"') {
    const q = text[i];
    let j = text.indexOf(q, i + 1);
    if (j === -1) j = n - 1;
    push(i, j + 1, 'udon-attr');
    i = j + 1;
  } else {
    const m = /^[A-Za-z_$][A-Za-z0-9_.$-]*/.exec(text.slice(i));
    if (m) { push(i, i + m[0].length, 'udon-attr'); i += m[0].length; }
  }
  // one space then a value token (sameline: space-delimited)
  if (text[i] !== ' ') return i;
  let v = i + 1;
  const ch = text[v];
  if (ch === undefined) return i;
  if (ch === '"' || ch === "'") return scanQuoted(text, v, push);
  if (ch === '[') return scanList(text, v, push);
  if (text.startsWith('!{{', v)) return scanInterpolation(text, v, push);
  if (ch === ':' || ch === '|' || ch === ';') return i; // not a value
  // bare token: color only if fully typed
  let e = v;
  while (e < n && text[e] !== ' ' && text[e] !== '\t' && !(sameline === 'embedded' && text[e] === '}')) e++;
  const cls = classifyScalar(text.slice(v, e));
  if (cls) { push(v, e, cls); return e; }
  return i; // leave bare strings plain, and let scanStructure re-walk them
}

function scanQuoted(text, i, push) {
  const q = text[i];
  let j = i + 1;
  while (j < text.length) {
    if (text[j] === '\\') { j += 2; continue; }
    if (text[j] === q) { j++; break; }
    j++;
  }
  push(i, Math.min(j, text.length), 'udon-string');
  return Math.min(j, text.length);
}

function scanList(text, i, push) {
  const n = text.length;
  push(i, i + 1, 'udon-sigil'); // [
  let j = i + 1;
  while (j < n && text[j] !== ']') {
    if (text[j] === ' ') { j++; continue; }
    if (text[j] === '"' || text[j] === "'") { j = scanQuoted(text, j, push); continue; }
    let e = j;
    while (e < n && text[e] !== ' ' && text[e] !== ']') e++;
    const cls = classifyScalar(text.slice(j, e));
    if (cls) push(j, e, cls);
    j = e;
  }
  if (j < n) { push(j, j + 1, 'udon-sigil'); j++; }
  return j;
}

/** Balanced-brace helper: index just past the matching close brace. */
function matchBraces(text, open) {
  let depth = 0;
  for (let j = open; j < text.length; j++) {
    if (text[j] === '{') depth++;
    else if (text[j] === '}') { depth--; if (depth === 0) return j + 1; }
  }
  return text.length;
}

function scanInterpolation(text, i, push) {
  // !{{expr | filter}} -- double braces; find `}}`
  const close = text.indexOf('}}', i + 3);
  const end = close === -1 ? text.length : close + 2;
  push(i, i + 3, 'udon-sigil');
  if (end - 2 > i + 3) push(i + 3, close === -1 ? end : close, 'udon-interp');
  if (close !== -1) push(close, end, 'udon-sigil');
  return end;
}

function scanInlineDirective(text, i, push) {
  // !{directive ...} or !{:kind: raw...} -- brace-counted
  const end = matchBraces(text, i + 1);
  push(i, i + 2, 'udon-sigil');
  let j = i + 2;
  const raw = /^:([A-Za-z][A-Za-z0-9_-]*):/.exec(text.slice(j));
  if (raw) {
    push(j, j + raw[0].length, 'udon-raw-label');
    // raw payload: leave plain
  } else {
    const m = RE_NAME.exec(text.slice(j));
    if (m) push(j, j + m[0].length, 'udon-directive');
    // directive body may contain nested UDON inline forms
    scanInlineForms(text, j + (m ? m[0].length : 0), end - 1, push);
  }
  if (end - 1 >= i + 2 && text[end - 1] === '}') push(end - 1, end, 'udon-sigil');
  return end;
}

function scanInlineComment(text, i, push) {
  const end = matchBraces(text, i + 1);
  push(i, end, 'udon-comment');
  return end;
}

function scanEmbedded(text, i, push) {
  // |{name[id].class :attr value content} -- brace-counted
  const end = matchBraces(text, i + 1);
  push(i, i + 2, 'udon-sigil');
  let j = i + 2;
  // identity
  const m = RE_NAME.exec(text.slice(j));
  if (m) { push(j, j + m[0].length, 'udon-element'); j += m[0].length; }
  for (;;) {
    if (text[j] === '[') {
      let k = text.indexOf(']', j + 1);
      if (k === -1 || k >= end) break;
      push(j, j + 1, 'udon-sigil');
      if (k > j + 1) push(j + 1, k, 'udon-id');
      push(k, k + 1, 'udon-sigil');
      j = k + 1;
      continue;
    }
    if (text[j] === '.') {
      const cm = RE_NAME.exec(text.slice(j + 1));
      if (!cm) break;
      push(j, j + 1, 'udon-sigil');
      push(j + 1, j + 1 + cm[0].length, 'udon-class');
      j += 1 + cm[0].length;
      continue;
    }
    break;
  }
  // attributes within the embedded element
  while (j < end - 1) {
    if (text[j] === ' ') {
      if (text[j + 1] === ':' && /[A-Za-z_'"]/.test(text[j + 2] || '')) {
        j = scanAttrAndValue(text, j + 1, push, 'embedded');
        continue;
      }
      j++;
      continue;
    }
    break;
  }
  // rest is content; allow nested inline forms
  scanInlineForms(text, j, end - 1, push);
  if (end - 1 >= i + 2 && text[end - 1] === '}') push(end - 1, end, 'udon-sigil');
  return end;
}

/** Within [i, limit): only the four inline forms; everything else plain. */
function scanInlineForms(text, i, limit, push) {
  while (i < limit) {
    if (text.startsWith('|{', i)) { i = Math.min(scanEmbedded(text, i, push), limit); continue; }
    if (text.startsWith('!{{', i)) { i = Math.min(scanInterpolation(text, i, push), limit); continue; }
    if (text.startsWith('!{', i)) { i = Math.min(scanInlineDirective(text, i, push), limit); continue; }
    if (text.startsWith(';{', i)) { i = Math.min(scanInlineComment(text, i, push), limit); continue; }
    i++;
  }
}

/** Prose line: inline forms only. `;` and `|` and `:` stay literal/plain. */
function scanProse(text, i, push) {
  scanInlineForms(text, i, text.length, push);
}

/** Entry point used by the highlighter (and by tests): tokenize one line
 *  given its precomputed block mode. */
function tokenizeModeLine(text, mode, push) {
  if (mode === 'raw' || mode === 'free') return; // opaque body: plain
  if (mode === 'fence-open' || mode === 'fence-close') {
    const idx = text.indexOf('```');
    push(idx, idx + 3, 'udon-fence');
    return; // trailing text on the fence line: plain (freeform payload)
  }
  if (mode === 'fence-sameline') {
    const idx = text.indexOf('```');
    tokenizeLine(text.slice(0, idx), push); // head is normal UDON
    push(idx, idx + 3, 'udon-fence');
    return;
  }
  tokenizeLine(text, push); // 'n' and 'raw-open' (tokenizer knows !:lang:)
}

/* ========================================================================
 * CodeMirror integration
 * ======================================================================== */

const udonHighlighter = ViewPlugin.fromClass(class {
  constructor(view) { this.decorations = this.build(view); }
  update(u) {
    if (u.docChanged || u.viewportChanged) this.decorations = this.build(u.view);
  }
  build(view) {
    const builder = new RangeSetBuilder();
    const doc = view.state.doc;
    // Whole-doc mode pass (raw/freeform bodies). Cheap: string ops per line.
    const lines = [];
    for (let ln = 1; ln <= doc.lines; ln++) lines.push(doc.line(ln).text);
    const modes = computeLineModes(lines);

    for (const { from, to } of view.visibleRanges) {
      const first = doc.lineAt(from).number;
      const last = doc.lineAt(to).number;
      for (let ln = first; ln <= last; ln++) {
        const line = doc.line(ln);
        const mode = modes[ln - 1];
        const toks = [];
        try {
          tokenizeModeLine(line.text, mode, (a, b, cls) => {
            if (b > a) toks.push([a, b, cls]);
          });
        } catch (e) {
          // Never let a tokenizer bug break editing; skip the line.
          continue;
        }
        toks.sort((x, y) => x[0] - y[0] || x[1] - y[1]);
        let prevEnd = -1;
        for (const [a, b, cls] of toks) {
          if (a < prevEnd) continue; // guard against overlaps
          builder.add(line.from + a, line.from + b, mark(cls));
          prevEnd = b;
        }
      }
    }
    return builder.finish();
  }
}, { decorations: (v) => v.decorations });

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

function udonExtensions(onDocChanged) {
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
    udonHighlighter,
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
  constructor(leaf) {
    super(leaf);
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
        extensions: udonExtensions(() => this.requestSave()),
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
        extensions: udonExtensions(() => this.requestSave()),
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

module.exports = class UdonPlugin extends Plugin {
  async onload() {
    this.registerView(VIEW_TYPE_UDON, (leaf) => new UdonView(leaf));
    try {
      this.registerExtensions(['udon'], VIEW_TYPE_UDON);
    } catch (e) {
      // Another plugin may have claimed .udon; don't break load.
      console.error('UDON: could not register .udon extension', e);
    }
  }

  onunload() {
    // Obsidian detaches registered views/extensions automatically.
  }
};

import { JSDOM } from 'jsdom';
const dom = new JSDOM('<!DOCTYPE html><body></body>', { pretendToBeVisual: true });
globalThis.window = dom.window; globalThis.document = dom.window.document;
for (const k of ['HTMLElement','SVGElement','Element','Node','DocumentFragment','getComputedStyle']) if (!(k in globalThis)) globalThis[k] = dom.window[k];
const mermaid = (await import('mermaid')).default; mermaid.initialize({ startOnLoad: false });
const probes = {
  'and-lookahead':      'a <- b &c ;\nb <- "x" ;\nc <- "y" ;',
  'not-lookahead':      'a <- !b "x" ;\nb <- "y" ;',
  'not-quoted':         'a <- "|" !"{" ;',
  'any-char dot':       'a <- !"x" . ;',
  'optional ?':         'a <- "x"? ;',
  'dq multi {':         'a <- "|{" ;',
  'sq multi {':         "a <- '|{' ;",
  'dq bracket':         'a <- "[" ;',
  'sq bracket':         "a <- '[' ;",
  'dq backslash esc':   'a <- "\\\\" ;',
  'sq backslash':       "a <- '\\\\' ;",
  'dq angle':           'a <- "<" ;',
  'sq angle':           "a <- '<' ;",
  'dq question':        'a <- "???" ;',
  'sq question':        "a <- '???' ;",
  'dq set':             'a <- "[set]" ;',
  'dq dquote esc':      'a <- "\\"" ;',
  'sq dquote':          "a <- '\"' ;",
  'dq squote':          'a <- "\'" ;',
  'hyphen names':       'a-b <- c-d ;\nc-d <- "x" ;',
  'comment %%':         'a <- "x" ;\n%% a comment with |{ } [ ] < > \\ ? stuff',
  'title':              'title "T"\na <- "x" ;',
  'grouping + star':    'a <- ("x" / "y")* "z"+ ;',
  'and group':          'a <- "x" &("y" / "z") ;',
  'not group dot':      'a <- (!("y" / "z") .)+ ;',
  'uppercase rule':     'A <- "x" ;\nb <- A ;',
  'dq colon semi':      'a <- ":" / ";" / "@" / "!" / "." / "/" / "#" ;',
  'dq quote char':      "a <- '\"' / \"'\" ;",
  'dq tilde backtick':  'a <- "~" / "`" ;',
  'dq paren':           'a <- "(" / ")" ;',
  'dq hash n':          'a <- "#" / "n" / "0" ;',
};
for (const [name, body] of Object.entries(probes)) {
  const txt = 'railroad-peg-beta\n' + body;
  try { await mermaid.parse(txt); console.log(`ok    ${name}`); }
  catch (e) { console.log(`FAIL  ${name}: ${String(e.message||e).split('\n')[1] || String(e.message||e).split('\n')[0]}`.slice(0,160)); }
}

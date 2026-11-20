import { JSDOM } from 'jsdom';
import fs from 'node:fs';
const dom = new JSDOM('<!DOCTYPE html><body></body>', { pretendToBeVisual: true });
globalThis.window = dom.window; globalThis.document = dom.window.document;
globalThis.DOMPurify = undefined;
for (const k of ['HTMLElement','SVGElement','Element','Node','DocumentFragment','getComputedStyle','requestAnimationFrame']) if (!(k in globalThis)) globalThis[k] = dom.window[k];
const mermaid = (await import('mermaid')).default;
mermaid.initialize({ startOnLoad: false });
const file = process.argv[2];
const text = fs.readFileSync(file, 'utf8');
const blocks = [...text.matchAll(/```mermaid\n([\s\S]*?)\n```/g)].map(m => m[1]);
let bad = 0;
for (const [i, b] of blocks.entries()) {
  const title = (b.match(/^title "?(.*?)"?$/m) || [,'(untitled)'])[1];
  try { await mermaid.parse(b); console.log(`ok   block ${i+1}: ${title}`); }
  catch (e) { bad++; console.log(`FAIL block ${i+1}: ${title}\n  ${String(e.message || e).split('\n').slice(0,6).join('\n  ')}`); }
}
process.exit(bad ? 1 : 0);

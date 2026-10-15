import fs from 'fs';
const [,, which, file] = process.argv;
const src = fs.readFileSync(file, 'utf8');
const out = s => process.stdout.write(String(s).replace(/\n+$/,'') + '\n');
try {
if (which === 'markdoc') {
  const Markdoc = (await import('@markdoc/markdoc')).default;
  const ast = Markdoc.parse(src);
  const errs = Markdoc.validate(ast, {});
  out(Markdoc.renderers.html(Markdoc.transform(ast, {})));
  if (errs.length) out('  [validate: ' + errs.map(e=>e.error.message).join('; ') + ']');
} else if (which === 'mdx' || which === 'mdxgfm') {
  const { evaluate } = await import('@mdx-js/mdx');
  const runtime = await import('react/jsx-runtime');
  const { renderToStaticMarkup } = await import('react-dom/server');
  const React = await import('react');
  const opts = { ...runtime };
  if (which === 'mdxgfm') opts.remarkPlugins = [(await import('remark-gfm')).default];
  const mod = await evaluate(src, opts);
  out(renderToStaticMarkup(React.createElement(mod.default, { components: new Proxy({}, { get: (t,k)=> (typeof k==='string' && /^[A-Z]/.test(k)) ? (p)=>React.createElement('x-'+k.toLowerCase(), null, p.children) : undefined }) })));
} else if (which === 'myst') {
  const { mystParse } = await import('myst-parser');
  const { defaultDirectives } = await import('myst-directives');
  const { defaultRoles } = await import('myst-roles');
  const tree = mystParse(src, { directives: defaultDirectives, roles: defaultRoles });
  const strip = n => { if (n && typeof n === 'object') { delete n.position; delete n.key; for (const k in n) strip(n[k]); } return n; };
  const summ = n => { if (n.type === 'text') return JSON.stringify(n.value); const kids = (n.children||[]).map(summ).join(' '); const extra = Object.entries(n).filter(([k,v])=>!['type','children','value','position','key'].includes(k) && typeof v !== 'object').map(([k,v])=>k+'='+JSON.stringify(v)).join(' '); return '(' + n.type + (extra?' '+extra:'') + (n.value!==undefined?' '+JSON.stringify(n.value):'') + (kids?' '+kids:'') + ')'; };
  out(summ(strip(tree)));
} else if (which === 'djotjs') {
  const djot = await import('@djot/djot');
  out(djot.renderHTML(djot.parse(src)));
} else if (which === 'cmjs') {
  const cm = await import('commonmark');
  out(new cm.HtmlRenderer().render(new cm.Parser().parse(src)));
}
} catch (e) { out('  [ERROR: ' + (e.message||e).toString().split('\n')[0] + ']'); }

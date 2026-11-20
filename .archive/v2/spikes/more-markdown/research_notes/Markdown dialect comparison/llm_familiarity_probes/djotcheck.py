import re,sys,subprocess,os
J=sys.argv[1]; outs=sys.argv[2:]
checks=[("em","<em>"),("strong","<strong>"),("mark","<mark>"),("ins","<ins>"),("del","<del>"),("sup","<sup>"),("sub","<sub>"),
("span.kbd",'<span class="kbd">'),("div.warning",'<div class="warning">'),("footnote",'role="doc-noteref"'),("inline math",'class="math inline"'),
("dl","<dl>"),("caption","<caption>"),("br","<br>"),("raw html (div.raw/custom passed)",None),("table","<table>")]
for f in outs:
    t=open(f).read()
    m=re.search(r"(`{3,4})djot\n(.*?)\n\1\n",t,re.S)
    if not m: print(f,"NO DJOT BLOCK"); continue
    src=m.group(2)
    r=subprocess.run(["node",J],input=src,capture_output=True,text=True)
    html=r.stdout
    res=[]
    for name,pat in checks:
        if pat is None:
            ok = bool(re.search(r"<div[^>]*>(raw|HTML block|raw html)",html)) and "&lt;div" not in html
        else: ok = pat in html
        res.append(("+" if ok else "-")+name)
    hid=re.search(r'<section id="([^"]+)">\s*<h1',html)
    print(os.path.basename(f), " ".join(res), "| h1 section id:", hid.group(1) if hid else None, "| warnings:", r.stderr.strip().replace("\n","; ")[:200])
    open(f+".djot.html","w").write(html)

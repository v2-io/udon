import sys, pegi
rules,_ = pegi.read_grammar(__import__('os').environ.get('G','peg.txt'))
def txt(v): return v if isinstance(v,str) else ''.join(txt(x[1]) for x in v)
def val(v):
    # v: list of children of 'value' or element etc
    out=[]
    for n,c in v:
        if n=='value': out.append(val(c))
        elif n=='number': out.append(txt(c))
        elif n in('boolean','nil'): out.append(txt(c))
        elif n=='delimited-string': out.append('"%s"'%txt(c[0][1]) if False else 'STR'+repr(strtext(c)))
        elif n=='text': out.append('‹'+''.join(piece(p) for p in c)+'›')
        elif n=='list': out.append('['+' '.join(val([x]) for x in c)+']')
        elif n=='list-item': out.append(val(c))
        elif n=='list-text': out.append('‹%s›'%txt(c))
        elif n=='angle': out.append('<%s>'%txt(c))
        elif n=='empty-text': out.append('‹›')
        else: out.append('?%s:%r'%(n,c))
    return ' '.join(out)
def strtext(c):
    s=''
    def walk(v):
        nonlocal s
        for n,x in v:
            if n in('dq-char','sq-char'): s+=txt(x)
            elif n in('dq-escape','sq-escape'): s+='\\'+txt(x)
            elif isinstance(x,list): walk(x)
    walk(c); return s
def piece(p):
    n,c=p
    if n=='piece': return ''.join(piece(x) for x in c)
    if n in('chars','chars-v'): return txt(c)
    if n=='bare-string':
        return txt(c) if isinstance(c,str) else ''.join(('\\'+txt(x[1])) if x[0]=='escape' else txt(x[1]) for x in c)
    if n=='embed': return ''.join(piece(x) for x in c)
    if n=='inline-element': return '|{%s}'%txt(c)
    if n=='reference': return '@{%s}'%txt(c)
    if n=='inline-comment': return ';{%s}'%txt(c)
    return '?'+n
def head(c):
    s=''
    for n,x in c:
        if n=='name': s+=txt(x)
        if n=='key': s+='[%s]'%val(x)
        if n=='trait': s+='.'+txt([y for y in x if y[0]=='LABEL'])
    return s
def node(n,c,ind):
    p='  '*ind; out=[]
    if n=='element':
        out.append(p+'|'+head([x for x in c if x[0]=='head'][0][1]))
        for m,x in c:
            if m!='head' and m!='element-start': out+=node(m,x,ind+1)
    elif n in('attribute','attribute-line'):
        nm=txt([x for x in c if x[0]=='name'][0][1])
        rest=[x for x in c if x[0] not in('name','attribute-start')]
        vals=[x for x in rest if x[0] not in('element','fence','framed-comment')]
        out.append(p+':'+nm+' '+val(vals))
        for m,x in rest:
            if m in('element','fence','framed-comment'): out+=node(m,x,ind+1)
    elif n=='main': out.append(p+':$main '+val(c))
    elif n=='prose': out.append(p+'PROSE'+repr([txt(x[1]) for x in c]))
    elif n=='BLANK': pass
    elif n=='comment-block': out.append(p+';'+repr(txt(c)))
    elif n=='framed-comment': out.append(p+'; (framed)'+repr(txt(c)))
    elif n=='fence':
        out.append(p+'```'+head([x for x in c if x[0]=='head'][0][1]))
        for m,x in c:
            if m not in('head','fence-start'): out+=node(m,x,ind+1)
    elif n=='FENCE-BODY': out.append(p+'BODY'+repr(c))
    elif n=='fence-closer': out+= ([y for m,x in c for y in node(m,x,ind)] if isinstance(c,list) else [p+'(closer)'])
    elif n=='FENCE': pass
    else: out.append(p+'?'+n+' '+repr(c)[:80])
    return out
def summarize(src,mode='block-shared'):
  try:
    return _summ(src,mode)
  except Exception as e:
    return 'HARNESS-EXC '+repr(e)
def _summ(src,mode):
    if not src.endswith('\n'): src+='\n'
    pr=pegi.Parser(rules,src,mode)
    try: r=pr.rule('root',0)
    except pegi.ParseError as e: return 'ERROR '+str(e)
    if r is None: return 'NO PARSE'
    if r[0]!=len(src): return 'PARTIAL'
    out=['root']
    for n,c in r[1][0][1] if r[1] and r[1][0][0]=='root' else r[1]:
        out+=node(n,c,1)
    return '\n'.join(out)
if __name__=='__main__':
    print(summarize(sys.stdin.read(), sys.argv[1] if len(sys.argv)>1 else 'block-shared'))

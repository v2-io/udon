"""A generic interpreter for the mermaid railroad-peg-beta block in peg-2026-10-21.md.

It reads the grammar text itself (no hand transcription) and runs it with
packrat memoization. Lexer tokens named in the PEG's "What the lexer owns"
table are builtins here; their definitions are this auditor's stand-ins for the
open ones (LABEL, NUMBER, ...), stated in BUILTINS below.

Two modes:
  mode="line"  : EOB is zero-width at end of input (the previous harness's model).
  mode="block" : a parser-owned column stack; EOB succeeds at a line whose
                 indent is <= the innermost open block's column (or at EOF);
                 _blocks consumes a deeper line's indentation before each _block.
"""
import re, sys

class ParseError(Exception):
    pass

# ---------------------------------------------------------------- grammar reader
def read_grammar(path):
    rules, order = {}, []
    text = open(path).read()
    for line in text.splitlines():
        s = line.strip()
        if not s or s.startswith('%%') or s.startswith('railroad') or s.startswith('title'):
            continue
        m = re.match(r'^([A-Za-z_][A-Za-z0-9_-]*)\s*<-\s*(.*);\s*$', s)
        if not m:
            raise SystemExit('cannot read line: ' + s)
        rules[m.group(1)] = parse_expr(m.group(2))
        order.append(m.group(1))
    return rules, order

def tokenize(src):
    toks, i = [], 0
    while i < len(src):
        c = src[i]
        if c.isspace():
            i += 1; continue
        if c == '"':
            j = i + 1; buf = ''
            while src[j] != '"':
                if src[j] == '\\':
                    buf += src[j + 1]; j += 2
                else:
                    buf += src[j]; j += 1
            toks.append(('lit', buf)); i = j + 1; continue
        if c in '/()*+?&!.':
            toks.append((c, c)); i += 1; continue
        m = re.match(r'[A-Za-z_][A-Za-z0-9_-]*', src[i:])
        if m:
            toks.append(('id', m.group(0))); i += len(m.group(0)); continue
        raise SystemExit('bad char %r in %r' % (c, src))
    return toks

def parse_expr(src):
    toks = tokenize(src); pos = [0]
    def peek():
        return toks[pos[0]] if pos[0] < len(toks) else (None, None)
    def nxt():
        t = toks[pos[0]]; pos[0] += 1; return t
    def choice():
        alts = [seq()]
        while peek()[0] == '/':
            nxt(); alts.append(seq())
        return alts[0] if len(alts) == 1 else ('choice', alts)
    def seq():
        items = []
        while peek()[0] not in (None, '/', ')'):
            items.append(prefix())
        return items[0] if len(items) == 1 else ('seq', items)
    def prefix():
        if peek()[0] in ('&', '!'):
            op = nxt()[0]; return ('and' if op == '&' else 'not', prefix())
        return suffix()
    def suffix():
        e = primary()
        while peek()[0] in ('*', '+', '?'):
            e = ({'*': 'star', '+': 'plus', '?': 'opt'}[nxt()[0]], e)
        return e
    def primary():
        k, v = nxt()
        if k == '(':
            e = choice(); assert nxt()[0] == ')'; return e
        if k == 'lit':
            if re.fullmatch(r'\[.+\]', v) and len(v) > 2:   # "[0-7]"-style class
                return ('class', v)
            return ('lit', v)
        if k == '.':
            return ('any',)
        if k == 'id':
            return ('ref', v)
        raise SystemExit('unexpected %r' % (k,))
    e = choice()
    assert pos[0] == len(toks), (src, toks[pos[0]:])
    return e

# ---------------------------------------------------------------- interpreter
COMMIT = {'key', 'list', 'angle', 'inline-element', 'reference', 'inline-comment',
          'double-quoted-string', 'single-quoted-string'}
VALUE_ESCAPABLE = set('|:;@!{}"\'[<0123456789+-`\\')

class Parser:
    def __init__(self, rules, text, mode='line', trace_errors=True):
        self.shared = mode.endswith('-shared')
        mode = mode.replace('-shared', '')
        self.r, self.s, self.mode = rules, text, mode
        self.memo = {}
        self.cols = [-1]          # block mode: column stack (root at -1)
        self.starts = [-1]
        self.edges = []
        self.warnings = []

    # helpers
    def col(self, i):
        return i - (self.s.rfind('\n', 0, i) + 1)
    def at_line_start(self, i):
        return i == 0 or self.s[i - 1] == '\n'
    def line_indent(self, i):
        j = i
        while j < len(self.s) and self.s[j] == ' ':
            j += 1
        blank = j >= len(self.s) or self.s[j] == '\n'
        return j - i, blank

    def builtin(self, name, i):
        s = self.s
        n = len(s)
        if name == 'WS':
            if self.at_line_start(i): return None
            j = i
            while j < n and s[j] == ' ': j += 1
            return (j, None) if j > i else None
        if name == 'EOL':
            if i < n and s[i] == '\n': return (i + 1, None)
            if self.shared and i > 0 and s[i - 1] == '\n': return (i, None)
            return None
        if name == 'IND':
            if not self.at_line_start(i): return None
            ind, blank = self.line_indent(i)
            return (i + ind, None)
        if name == 'BOL':
            return (i, None) if i > 0 and s[i - 1] == '\n' else None
        if name == 'DEEPER':
            if not self.at_line_start(i) or not self.edges: return None
            ind, blank = self.line_indent(i)
            return (i, None) if not blank and ind > self.edges[-1] else None
        if name == 'EOF':
            return (i, None) if i == n else None
        if name == 'BLANK':
            if not self.at_line_start(i): return None
            ind, blank = self.line_indent(i)
            if blank and i + ind < n: return (i + ind + 1, None)
            return None
        if name == 'EOB':
            if self.mode == 'line':
                return (i, None) if i == n else None
            # block: next non-blank line at or left of the innermost open column
            j = i
            if not self.at_line_start(j) and j != n: return None
            while j < n:
                ind, blank = self.line_indent(j)
                if not blank: break
                j = s.index('\n', j) + 1
            if j >= n: return (i, None)
            ind, _ = self.line_indent(j)
            return (i, None) if ind <= self.cols[-1] else None
        if name == 'LABEL':
            m = re.compile(r'[A-Za-z_][A-Za-z0-9_-]*').match(s, i)
            return (m.end(), s[i:m.end()]) if m else None
        if name == 'NAME-FIRST':
            return (i + 1, None) if i < n and (s[i].isalpha() or s[i] == '_') else None
        if name == 'NUMBER':
            m = re.compile(r'[-+]?\d+(\.\d+)?').match(s, i)
            return (m.end(), s[i:m.end()]) if m else None
        if name == 'BOUND':
            return (i, None) if i == n or s[i] in ' \n]' else None
        if name == 'DIGIT':
            return (i + 1, None) if i < n and s[i].isdigit() else None
        if name == 'HEX':
            return (i + 1, None) if i < n and s[i] in '0123456789abcdefABCDEF' else None
        if name == 'ESCAPABLE':
            return (i + 1, None) if i < n and s[i] in VALUE_ESCAPABLE else None
        if name == 'CHAR':
            if i >= n or s[i] == '\n': return None
            for op in ('|{', '@{', ';{', '!{'):
                if s.startswith(op, i): return None
            return (i + 1, None)
        if name == 'BS-SEP':   # WS "\" (WS / &EOL), consumed
            r = self.builtin('WS', i)
            if not r or r[0] >= n or s[r[0]] != '\\': return None
            j = r[0] + 1
            if j < n and s[j] == '\n': return (j, None)
            r2 = self.builtin('WS', j)
            return (r2[0], None) if r2 else None
        if name == 'FENCE':    # 3+ backticks, no later backtick on the line
            j = i
            while j < n and s[j] == '`': j += 1
            if j - i < 3: return None
            eol = s.find('\n', j); eol = n if eol < 0 else eol
            if '`' in s[j:eol]: return None
            return (j, s[i:j])
        if name in ('RAW', 'INTERIOR'):
            prev = s[i - 1] if i > 0 else ''
            pairs = {'<': '>', '{': '}'}
            if prev in pairs:
                o, c, d, j = prev, pairs[prev], 1, i
                while j < n and s[j] != '\n':
                    if s[j] == '\\' and j + 1 < n and s[j + 1] in (o, c, '\\'):
                        j += 2; continue
                    if s[j] == '\\' and name == 'RAW':
                        raise ParseError('unknown escape in span at %d' % j)
                    if s[j] == o: d += 1
                    elif s[j] == c:
                        d -= 1
                        if d == 0: return (j, s[i:j])
                    j += 1
                return None
            # comment rest: rest of line; after a block-starting ';', also the line end and deeper lines
            eol = s.find('\n', i); eol = n if eol < 0 else eol
            if prev == ';' and self.at_line_start(i - 1 - self.col(i - 1)) and s[i - 1 - self.col(i - 1):i - 1].strip() == '':
                c0 = self.col(i - 1); j = eol + 1
                while j < n:
                    ind, blank = self.line_indent(j)
                    if not blank and ind <= c0: break
                    j = s.index('\n', j) + 1
                return (min(j, n), s[i:min(j, n)])
            return (eol, s[i:eol])
        if name in ('FENCE-BODY', 'FENCE-CLOSE'):
            return self.fence_tok(name, i)
        return 'nobuiltin'

    def fence_tok(self, name, i):
        # find the opener: the FENCE token on the line before i
        s = self.s
        ls = s.rfind('\n', 0, i - 1) + 1
        m = re.search(r'`{3,}', s[ls:i])
        N = len(m.group(0)) if m else 3
        if name == 'FENCE-BODY':
            j = i
            while j < len(s):
                ind, _ = self.line_indent(j)
                k = j + ind
                run = len(s[k:]) - len(s[k:].lstrip('`'))
                if run >= N: return (j, s[i:j])
                nl = s.find('\n', j)
                if nl < 0: return None
                j = nl + 1
            return None
        ind, _ = self.line_indent(i)
        k = i + ind
        run = len(s[k:]) - len(s[k:].lstrip('`'))
        return (k + run, None) if run >= N else None

    def rule(self, name, i):
        key = (name, i, len(self.cols), self.cols[-1], self.starts[-1], self.edges[-1] if self.edges else None)
        if key in self.memo: return self.memo[key]
        if name not in self.r:
            if name not in ('EOB', 'EOF', 'EOL', 'BOL', 'DEEPER', 'FENCE-BODY', 'FENCE-CLOSE') and self.gated(i):
                self.memo[key] = None
                return None
            b = self.builtin(name, i)
            if b == 'nobuiltin':
                raise SystemExit('undefined rule ' + name)
            res = None if b is None else (b[0], [(name, b[1])] if name in ('LABEL', 'NUMBER', 'RAW', 'FENCE', 'INTERIOR', 'FENCE-BODY') else [])
            self.memo[key] = res
            return res
        if self.mode == 'block' and name == '_blocks':
            res = self.blocks(i)
            self.memo[key] = res
            return res
        pushed = False
        pe = False
        if name == 'prose':
            self.edges.append(self.col(i)); pe = True
        if self.mode == 'block' and name in ('element', 'attribute-line', 'comment-block'):
            self.cols.append(self.col(i)); self.starts.append(i); pushed = True
        try:
            res = self.ev(self.r[name], i)
        finally:
            if pushed: self.cols.pop(); self.starts.pop()
            if pe: self.edges.pop()
        if res is not None and name.startswith('ERROR-'):
            raise ParseError('%s at %d (line %d col %d)' % (name, i, self.s.count('\n', 0, i) + 1, self.col(i)))
        if res is None and name in COMMIT:
            first = self.r[name]
            # did the opener match?
            op = first[1][0] if first[0] == 'seq' else None
            if op and op[0] == 'lit' and self.s.startswith(op[1], i):
                raise ParseError('unclosed or malformed %s at %d (line %d col %d)' % (name, i, self.s.count('\n', 0, i) + 1, self.col(i)))
        if res is not None:
            end, kids = res
            if name[0].islower() and not name.startswith('_'):
                kids = [(name, kids if kids else self.s[i:end])]
            res = (end, kids)
        self.memo[key] = res
        return res

    def blocks(self, i):
        """_blocks <- _block*, with a lexer-like indentation step before each block."""
        kids = []
        while True:
            j = i
            if self.at_line_start(j) and j < len(self.s):
                ind, blank = self.line_indent(j)
                if not blank:
                    if ind <= self.cols[-1]:
                        break
                    j = j + ind
            r = self.rule('_block', j)
            if r is None or r[0] == i:
                break
            i, k = r[0], kids + r[1]
            kids = k
        return (i, kids)

    def gated(self, i):
        # block mode: the lexer has put EOB before a line at or left of the open column
        if self.mode != 'block' or i == 0 or i >= len(self.s) or self.s[i - 1] != '\n':
            return False
        if i == self.starts[-1] + 0 or self.col(self.starts[-1]) == 0 and i == self.starts[-1]:
            return False
        ind, blank = self.line_indent(i)
        if self.starts[-1] >= 0 and i <= self.starts[-1] <= i + ind:
            return False
        return (not blank) and ind <= self.cols[-1]

    def ev(self, e, i):
        t = e[0]
        if t in ('lit', 'class', 'any') and self.gated(i):
            return None
        if t == 'lit':
            return (i + len(e[1]), []) if self.s.startswith(e[1], i) else None
        if t == 'class':
            return (i + 1, []) if i < len(self.s) and re.fullmatch(e[1], self.s[i]) else None
        if t == 'any':
            return (i + 1, []) if i < len(self.s) else None
        if t == 'ref':
            return self.rule(e[1], i)
        if t == 'seq':
            kids = []
            for x in e[1]:
                r = self.ev(x, i)
                if r is None: return None
                i = r[0]; kids += r[1]
            return (i, kids)
        if t == 'choice':
            for x in e[1]:
                r = self.ev(x, i)
                if r is not None: return r
            return None
        if t in ('star', 'plus'):
            kids, n = [], 0
            while True:
                r = self.ev(e[1], i)
                if r is None or r[0] == i: break
                i = r[0]; kids += r[1]; n += 1
            return (i, kids) if (n or t == 'star') else None
        if t == 'opt':
            r = self.ev(e[1], i)
            return r if r is not None else (i, [])
        if t == 'and':
            return (i, []) if self.ev(e[1], i) is not None else None
        if t == 'not':
            return (i, []) if self.ev(e[1], i) is None else None
        raise SystemExit(t)

def show(node, ind=0):
    out = []
    for name, v in node:
        if isinstance(v, list):
            out.append('  ' * ind + name)
            out += show(v, ind + 1)
        else:
            out.append('  ' * ind + '%s %r' % (name, v))
    return out

def run(rules, text, mode):
    if not text.endswith('\n'): text += '\n'
    p = Parser(rules, text, mode)
    try:
        r = p.rule('root', 0)
    except ParseError as ex:
        return 'ERROR ' + str(ex)
    except RecursionError:
        return 'RECURSION'
    if r is None:
        return 'NO PARSE'
    return '\n'.join(show(r[1]))

if __name__ == '__main__':
    rules, _ = read_grammar(sys.argv[1])
    mode = sys.argv[2]
    src = sys.stdin.read()
    print(run(rules, src, mode))

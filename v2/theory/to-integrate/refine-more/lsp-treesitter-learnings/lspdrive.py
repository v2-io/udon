#!/usr/bin/env python3
"""Minimal LSP client to drive rust-analyzer and time real operations.

Firsthand instrumentation for the udon lsp/tree-sitter prior-art spike.
Measures: cold start -> indexing complete -> find-references latency.
"""
import json, subprocess, sys, threading, time, os, urllib.parse

ROOT = "/Users/josephwecker-v2/src/udon/core"
ROOT_URI = "file://" + urllib.parse.quote(ROOT)

t0 = time.time()

def el():
    return f"{time.time()-t0:7.2f}s"

proc = subprocess.Popen(
    ["rust-analyzer"], stdin=subprocess.PIPE, stdout=subprocess.PIPE,
    stderr=subprocess.DEVNULL, cwd=ROOT,
)

lock = threading.Lock()
_id = [0]
responses = {}
notifications = []
done_indexing = threading.Event()
progress_log = []

def send(obj):
    data = json.dumps(obj).encode()
    with lock:
        proc.stdin.write(b"Content-Length: %d\r\n\r\n" % len(data))
        proc.stdin.write(data)
        proc.stdin.flush()

def request(method, params):
    _id[0] += 1
    i = _id[0]
    send({"jsonrpc": "2.0", "id": i, "method": method, "params": params})
    return i

def notify(method, params):
    send({"jsonrpc": "2.0", "method": method, "params": params})

def reader():
    buf = b""
    while True:
        hdr = b""
        while not hdr.endswith(b"\r\n\r\n"):
            c = proc.stdout.read(1)
            if not c:
                return
            hdr += c
        n = int([l for l in hdr.decode().split("\r\n") if l.lower().startswith("content-length")][0].split(":")[1])
        body = b""
        while len(body) < n:
            body += proc.stdout.read(n - len(body))
        msg = json.loads(body)
        if "id" in msg and "method" not in msg:
            responses[msg["id"]] = msg
        else:
            m = msg.get("method")
            if m == "$/progress":
                v = msg["params"].get("value", {})
                tok = msg["params"].get("token")
                progress_log.append((time.time() - t0, tok, v.get("kind"), v.get("title") or v.get("message")))
                if v.get("kind") == "end" and ("Indexing" in str(tok) or "cachePriming" in str(tok) or "Roots Scanned" in str(tok)):
                    done_indexing.set()
            elif m == "window/workDoneProgress/create":
                pass

threading.Thread(target=reader, daemon=True).start()

print(f"[{el()}] spawning rust-analyzer, sending initialize")
init_id = request("initialize", {
    "processId": os.getpid(),
    "rootUri": ROOT_URI,
    "capabilities": {
        "window": {"workDoneProgress": True},
        "textDocument": {"references": {}, "rename": {"prepareSupport": True}},
        "workspace": {"symbol": {}, "workspaceEdit": {"documentChanges": True}},
    },
})

def wait_for(i, timeout=600):
    s = time.time()
    while i not in responses:
        if time.time() - s > timeout:
            raise TimeoutError(f"timeout waiting for {i}")
        time.sleep(0.02)
    return responses[i]

r = wait_for(init_id)
print(f"[{el()}] initialize returned")
notify("initialized", {})

print(f"[{el()}] waiting for indexing to complete...")
done_indexing.wait(timeout=240)
print(f"[{el()}] INDEXING SIGNAL (or timed out at 240s)")
for p in progress_log:
    print(f"    progress {p[0]:7.2f}s  {p[1]}  {p[2]}  {p[3]}")

# Open parser.rs
PARSER = os.path.join(ROOT, "udon-core/src/parser.rs")
text = open(PARSER, encoding="utf-8").read()
notify("textDocument/didOpen", {"textDocument": {
    "uri": "file://" + urllib.parse.quote(PARSER), "languageId": "rust",
    "version": 1, "text": text}})
time.sleep(1)

# BlankLine variant is declared at line 42 (1-based) -> 0-based 41
lines = text.split("\n")
decl_line = None
for idx, l in enumerate(lines):
    if l.strip().startswith("BlankLine {"):
        decl_line = idx
        break
col = lines[decl_line].index("BlankLine")
print(f"[{el()}] BlankLine variant declared at 0-based line {decl_line}, col {col}: {lines[decl_line][:60]!r}")

res = []
attempts = 0
while not res and attempts < 12:
    attempts += 1
    ts = time.time()
    ref_id = request("textDocument/references", {
        "textDocument": {"uri": "file://" + urllib.parse.quote(PARSER)},
        "position": {"line": decl_line, "character": col},
        "context": {"includeDeclaration": False},
    })
    resp = wait_for(ref_id)
    lat = time.time() - ts
    res = resp.get("result") or []
    if not res:
        print(f"[{el()}] attempt {attempts}: empty/err ({resp.get('error')}) after {lat*1000:.0f}ms; retrying")
        time.sleep(10)
print(f"[{el()}] references resolved after {attempts} attempt(s)")
print(f"[{el()}] find-references returned {len(res)} refs in {lat*1000:.0f}ms")
from collections import Counter
c = Counter(urllib.parse.unquote(x["uri"]).replace("file://" + ROOT + "/", "") for x in res)
for k, v in sorted(c.items(), key=lambda kv: -kv[1]):
    print(f"    {v:3d}  {k}")

# Also: prepare a rename to see the workspace edit shape
ts = time.time()
ren_id = request("textDocument/rename", {
    "textDocument": {"uri": "file://" + urllib.parse.quote(PARSER)},
    "position": {"line": decl_line, "character": col},
    "newName": "BlankLineXX",
})
resp = wait_for(ren_id)
lat = time.time() - ts
edit = resp.get("result") or {}
changes = edit.get("changes") or {}
docch = edit.get("documentChanges") or []
tot = 0
files = set()
if changes:
    for u, es in changes.items():
        files.add(urllib.parse.unquote(u).replace("file://" + ROOT + "/", ""))
        tot += len(es)
for d in docch:
    u = d.get("textDocument", {}).get("uri", "")
    files.add(urllib.parse.unquote(u).replace("file://" + ROOT + "/", ""))
    tot += len(d.get("edits", []))
print(f"[{el()}] rename produced {tot} edits across {len(files)} files in {lat*1000:.0f}ms")
for f in sorted(files):
    print(f"    {f}")

# workspace/symbol query
ts = time.time()
ws_id = request("workspace/symbol", {"query": "BlankLine"})
resp = wait_for(ws_id)
lat = time.time() - ts
syms = resp.get("result") or []
print(f"[{el()}] workspace/symbol 'BlankLine' -> {len(syms)} symbols in {lat*1000:.0f}ms")
for s in syms[:20]:
    loc = s.get("location", {}).get("uri", "")
    print(f"    {s.get('name')}  kind={s.get('kind')}  container={s.get('containerName')}  {urllib.parse.unquote(loc).split('/')[-1]}")

proc.terminate()
print(f"[{el()}] done")

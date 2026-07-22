#!/usr/bin/env python3
"""Build UNION.txt (dedup union + per-path matching queries) and a first-cut
classification into corpus-own / already-in-corpus / needs-disposition.

Classification is deliberately conservative: when in doubt a path lands in
needs-disposition (the safe direction — over-including the work-list never
falsely marks something 'covered'). 'already-in-corpus' = the path is greppable
(as absolute, ~-form, or udon-repo-relative) inside the three accounting
surfaces the brief names: TARGET-FILES.md, LEDGER.md, and 02-provenanced/**.
"""
import os, re, glob, collections

HOME = os.path.expanduser("~")
HERE = os.path.dirname(os.path.abspath(__file__))
HITS = os.path.join(HERE, "hits")
IDEATION = os.path.abspath(os.path.join(HERE, "..", ".."))          # 01-ideation
UDON_V2 = os.path.abspath(os.path.join(IDEATION, ".."))             # udon/v2
UDON_REPO = os.path.abspath(os.path.join(UDON_V2, ".."))           # udon/

# --- accounting text (the three named surfaces) -----------------------------
acct_parts = []
for p in [os.path.join(IDEATION, "01-reconciled-target-files", "TARGET-FILES.md"),
          os.path.join(IDEATION, "02-provenanced", "LEDGER.md")]:
    acct_parts.append(open(p, encoding="utf-8", errors="replace").read())
for root, _, files in os.walk(os.path.join(IDEATION, "02-provenanced")):
    for f in files:
        try:
            acct_parts.append(open(os.path.join(root, f), encoding="utf-8", errors="replace").read())
        except Exception:
            pass
ACCT = "\n".join(acct_parts)

# --- read all hits, build path -> set(query slugs) --------------------------
path_queries = collections.defaultdict(set)
query_counts = {}
for hf in sorted(glob.glob(os.path.join(HITS, "hits-*.txt"))):
    slug = os.path.basename(hf)[len("hits-"):-len(".txt")]
    n = 0
    with open(hf, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            p = line.rstrip("\n")
            if not p:
                continue
            path_queries[p].add(slug)
            n += 1
    query_counts[slug] = n

def classify(p):
    # corpus-own: anything under the demand-side v2 effort (incl. this dir,
    # .archived, quarantines) — the corpus matching itself, not a candidate.
    if p.startswith(UDON_V2 + os.sep):
        return "corpus-own"
    # greppable-in-accounting test
    cands = [p]
    if p.startswith(HOME + os.sep):
        cands.append("~" + p[len(HOME):])
    if p.startswith(UDON_REPO + os.sep):
        cands.append(p[len(UDON_REPO) + 1:])       # udon-repo-relative
    for c in cands:
        if c in ACCT:
            return "already-in-corpus"
    return "needs-disposition"

buckets = collections.defaultdict(list)
for p in path_queries:
    buckets[classify(p)].append(p)

# --- write UNION.txt --------------------------------------------------------
allp = sorted(path_queries)
with open(os.path.join(HERE, "UNION.txt"), "w", encoding="utf-8") as out:
    out.write("# UNION — deduplicated union of all battery hits\n")
    out.write("# format: <class>\t<path>\t<matched-query-slugs>\n")
    out.write(f"# total unique paths: {len(allp)}\n")
    for cls in ("needs-disposition", "already-in-corpus", "corpus-own"):
        out.write(f"#   {cls}: {len(buckets[cls])}\n")
    out.write("#\n")
    for p in allp:
        cls = classify(p)
        qs = ",".join(sorted(path_queries[p]))
        out.write(f"{cls}\t{p}\t{qs}\n")

# --- write per-bucket work-lists -------------------------------------------
for cls in buckets:
    with open(os.path.join(HERE, f"UNION-{cls}.txt"), "w", encoding="utf-8") as out:
        for p in sorted(buckets[cls]):
            out.write(f"{p}\t{','.join(sorted(path_queries[p]))}\n")

# --- report -----------------------------------------------------------------
print(f"queries run: {len(query_counts)}")
print(f"total unique paths in union: {len(allp)}")
for cls in ("needs-disposition", "already-in-corpus", "corpus-own"):
    print(f"  {cls}: {len(buckets[cls])}")

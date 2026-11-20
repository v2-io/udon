# recall-floor/ — the checkable coverage net

Built 2026-07-21 so that "did we look at X?" is answerable by `grep`, not by trust. Full method, every query verbatim with hit counts, exclusion patterns, and caveats: **`BATTERY.md`**.

## What's here

| File | What |
|---|---|
| `BATTERY.md` | the writeup — queries, counts, exclusions, classification method, caveats |
| `run-battery.sh` | source of truth: regenerates `hits/hits-*.txt` (reproducible) |
| `build-union.py` | source of truth: rebuilds `UNION*.txt` from `hits/` |
| `hits/hits-{fn,ct}-<slug>.txt` | raw paths, one per line, per query (59 files) |
| `UNION.txt` | dedup union: `<class>\t<path>\t<matched-query-slugs>` |
| `UNION-needs-disposition.txt` | **the work-list** — 16,329 paths not accounted for |
| `UNION-already-in-corpus.txt` | 219 paths greppable in the accounting surfaces |
| `UNION-corpus-own.txt` | 350 paths under `udon/v2/` (the corpus itself) |
| `battery-stderr.log` | sweep stderr (permission-denied on system dirs only) |

## For the next phase

`UNION-needs-disposition.txt` is a **candidate** list, not a relevance verdict — relevance was deliberately not judged here. Two things to know before working it (both detailed in `BATTERY.md`):

1. `already-in-corpus` is a **floor** — wildcard/dir-glob accounting entries mean some already-swept files still land in needs-disposition. Intersecting against the maps' directory globs (`~/src/_core/sapientia/**` etc.) will shrink it.
2. The net is **intentionally wide** — ~5,200 residual paths are `~/src-ext/` external tool clones where the query strings saturate.

To re-run from scratch: `bash run-battery.sh && python3 build-union.py`.

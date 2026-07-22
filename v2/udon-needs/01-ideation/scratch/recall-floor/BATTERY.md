# Recall-floor battery — the checkable lexical net over the estate

**Built 2026-07-21.** Purpose: make "did we look at X?" answerable by `grep`
instead of by trust. ~20 territory-sweep agents plus semantic audits never
checked the *union* of their territories against the estate; one plain
`rg -li 'principled tool'` then surfaced ~10 unaccounted files. This battery is
the broad lexical net whose design bet is: **a relevant file that matches NO
query is the failure mode** — recall over precision, breadth of net over
cleverness of any single mesh. Relevance of the residual is deliberately **not**
judged here (that is the next phase's job); the product is the checkable
work-list.

Reproducible: `bash run-battery.sh` regenerates every `hits/hits-*.txt`;
`python3 build-union.py` rebuilds `UNION*.txt`. Both are the source of truth for
what follows.

## Roots searched

```
~/src        ~/vaults        ~/src-ext
```
(the estate + the two known adjacent roots named in the brief).

## Exclusion patterns (mechanically-obvious noise only)

Applied identically to `find` (dir-name `-prune`) and `rg` (`--glob '!…'`). Every
pattern is a build/dependency/VCS artifact directory — the named set
(`node_modules .git target/ deps/ binary`) plus its exact analogs in the other
toolchains present in the estate:

| Pattern | Why (mechanical) |
|---|---|
| `.git/` | VCS internals (named) |
| `node_modules/` | JS deps (named) |
| `target/` | Rust build (named) |
| `deps/` | dependency dir (named) |
| `_build/` | **Elixir** build — exact analog of `target/` (551 compiled `.beam` paths, all via `*cli*`) |
| `vendor/` | vendored third-party deps (Go/PHP/Ruby analog of `node_modules`) |
| `.venv/` `venv/` `__pycache__/` `.mypy_cache/` | Python build/env |
| `dist/` `build/` | generic build output |

Binary content is auto-skipped by `rg` (content queries only; `find` filename
queries don't read content, so binary artifacts can still surface by name — the
`_build/` exclusion is what removes the compiled-`.beam` filename noise). No
other exclusions: no relevance/topic/location filtering, no `.gitignore`
respect (see below).

**`rg` recall flags:** `-li --no-ignore --hidden -F`. `--no-ignore` deliberately
does **not** respect `.gitignore` — a gitignored file can be exactly the
un-accounted-for one. `--hidden` searches dotfiles/dirs (`.git` re-excluded by
glob). `-F` = fixed-string, `-i` = case-insensitive, `-l` = paths only.

## Filename queries (`find -iname`, case-insensitive)

Seed set from the brief, extended from the corpus's own vocabulary
(`instrumenta`, `operata`, `praxes` are project terms; `needs`/`demand` are the
demand-side framing).

| slug | `-iname` pattern | hits |
|---|---|---|
| tool | `*tool*` | 2303 |
| agent | `*agent*` | 1865 |
| instrumenta | `*instrumenta*` | 92 |
| praxes | `*praxes*` | 22 |
| praxis | `*praxis*` | 9 |
| tooling | `*tooling*` | 35 |
| cli | `*cli*` | 1310 |
| harness | `*harness*` | 93 |
| operata | `*operata*` | 54 |
| agentic | `*agentic*` | 114 |
| affordance | `*affordance*` | 5 |
| cheat | `*cheat*` | 23 |
| scaffold | `*scaffold*` | 66 |
| needs | `*needs*` | 9 |
| demand | `*demand*` | 11 |
| guardrail | `*guardrail*` | 5 |
| prompt | `*prompt*` | 940 |

## Content queries (`rg -li -F`, fixed strings, case-insensitive)

Seed set from the brief plus the corpus's own category vocabulary (mined from
`02-provenanced/**` frontmatter `categories:` and `TARGET-FILES.md` section
headings: `harness-facing`, `edit-representation`, `cross-tier`,
`orchestrator-worker`, `self-chunking`, `demand-side`, `propose-apply`, etc.).

| slug | literal string | hits |
|---|---|---|
| principled-tool | `principled tool` | 46 |
| for-agents | `for agents` | 1491 |
| agent-facing | `agent-facing` | 117 |
| tool-use | `tool-use` | 1577 |
| agentic | `agentic` | 3149 |
| crystallized | `crystallized` | 901 |
| instrumenta | `instrumenta` | 2070 |
| quick-tool | `quick-tool` | 197 |
| agentic-tooling | `agentic tooling` | 35 |
| tools-for-agents | `tools for agents` | 15 |
| tool-for-agents | `tool for agents` | 5 |
| agent-tool | `agent tool` | 697 |
| agent-facing-tool | `agent-facing tool` | 24 |
| harness-facing | `harness-facing` | 21 |
| edit-representation | `edit representation` | 7 |
| edit-tool | `edit tool` | 435 |
| tool-schema | `tool schema` | 387 |
| tool-definition | `tool definition` | 1059 |
| tool-calling | `tool calling` | 299 |
| affordance | `affordance` | 676 |
| guardrail | `guardrail` | 833 |
| cross-tier | `cross-tier` | 84 |
| memory-system | `memory system` | 573 |
| context-system | `context system` | 19 |
| context-engineering | `context engineering` | 283 |
| feedback-loop | `feedback loop` | 1719 |
| agent-loop | `agent loop` | 389 |
| demand-side | `demand-side` | 81 |
| demand-first | `demand-first` | 17 |
| praxes | `praxes` | 661 |
| operata | `operata` | 873 |
| orchestrator-worker | `orchestrator-worker` | 68 |
| multi-agent | `multi-agent` | 2367 |
| agents-need | `agents need` | 435 |
| what-agents-need | `what agents need` | 16 |
| mcp-tool | `mcp tool` | 1625 |
| tool-suite | `tool suite` | 125 |
| self-chunking | `self-chunking` | 68 |
| meta-tool | `meta-tool` | 80 |
| propose-apply | `propose-apply` | 8 |
| patch-tool | `patch tool` | 56 |
| diff-tool | `diff tool` | 65 |

**59 queries total** (17 filename + 42 content). Per-query raw path lists:
`hits/hits-fn-<slug>.txt` and `hits/hits-ct-<slug>.txt`.

## Union & classification

`UNION.txt` — deduplicated union, one row per unique path,
`<class>\t<path>\t<comma-separated matched-query-slugs>`.

| | count |
|---|---|
| **total unique paths** | **16,898** |
| corpus-own | 350 |
| already-in-corpus | 219 |
| **needs-disposition** | **16,329** |

Per-class lists split out: `UNION-corpus-own.txt`,
`UNION-already-in-corpus.txt`, `UNION-needs-disposition.txt`.

**Classification rules** (conservative — when in doubt, needs-disposition, so
the work-list is never falsely marked "covered"):

1. **corpus-own** — path under `~/src/udon/v2/` (this compilation effort,
   including `01-ideation/`, `.archived/`, quarantines, and this
   `recall-floor/` dir itself). The corpus matching itself; not a candidate.
2. **already-in-corpus** — path is *greppable* (as absolute, `~`-form, or
   udon-repo-relative) inside the three accounting surfaces the brief names:
   `01-reconciled-target-files/TARGET-FILES.md`, `02-provenanced/LEDGER.md`,
   and all of `02-provenanced/**`.
3. **needs-disposition** — everything else. The checkable work-list.

### Caveats on the classification (read before trusting a "covered" verdict)

- **already-in-corpus is a floor, not a ceiling.** Many accounting entries use
  wildcards (`test/usability/results/udon-realistic-*.yaml`), directory globs
  (`~/src/_core/sapientia/**`), or line-span/annotation suffixes. A concrete
  file under such an entry will *not* substring-match and therefore lands in
  needs-disposition even though its territory was swept. This is the safe
  failure direction (over-inclusion of the work-list), but it means the
  needs-disposition set contains an unknown number of already-swept files. The
  next phase should expect that and can intersect against the maps' directory
  globs to shrink it.
- **The net is intentionally wide.** Broad queries (`agentic` 3149, `multi-agent`
  2367, `mcp tool` 1625, `tool-use` 1577, `feedback loop` 1719) dominate the
  union; ~5,200 of the residual is under `~/src-ext/` (external tool clones —
  aider/opencode/codex/kilocode/etc.), where these strings saturate. Recall was
  the mandate; precision is downstream.

## Recall validation

The battery re-catches every file class named in the motivating incident:

- `principled tool` content query: **46 hits** (the seed command).
- `~/src/_ref/_arch/synaptic-cultivator/**` — 23 paths in the union.
- `~/src/_ref/_arch/geminex/AGENTS.md` — present.
- `~/src-ext/sapientia.snapshot-backup/curated-sessions/**` (curated jsonl/dialog
  set) — present.

No non-permission errors during the sweep (system-dir `Permission denied` lines
only; logged to `battery-stderr.log`).

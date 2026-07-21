# Bulk-import prior UDON agent sessions into Grok experimental memory

**Spike date:** 2026-07-21  
**Workspace memory target:** `~/.grok/memory/udon-4fdadfea/`  
**Status:** Investigation complete. **No live writes** under `~/.grok/memory/` from this spike (samples + plan only).  
**Safety:** No session logs deleted; no `grok memory clear` run.

---

## Executive summary

Grok experimental memory is a **Markdown file tree + SQLite hybrid index** under `~/.grok/memory/`. There is **no import/export CLI for memory** (only `grok memory clear`, which is destructive). The supported external path is:

1. Write Markdown under `~/.grok/memory/<workspace-slug>/sessions/` (and/or workspace `MEMORY.md`).
2. Let the **file watcher reindex** on the next memory search (default `watcher.enabled = true`).

`/flush` and `/dream` **do not operate on arbitrary historical transcripts**:

| Command | Scope | Notes |
|---------|--------|--------|
| `/flush` | **Current** session only | LLM summary of *this* conversation → appends to a dated session log under workspace `sessions/` |
| `/dream` | Existing memory files | Consolidates session logs + entries into workspace `MEMORY.md`; needs memory enabled; auto-dream gates on min hours/sessions |
| session-end auto-save | Ending session with memory on | **Metadata only** (message counts + up to 5 topic prompts); no tool/file paths; skips trivial sessions |
| File drop | Any Markdown under `~/.grok/memory/` | Documented: “edit memory files directly… reindexed on the next memory search” |

**Highest-value import is not raw transcripts** — it is already-curated Claude project memory (~47 KB, 16 topic files + index) plus selective Grok historical flushes (resume + `/flush`, or offline LLM summary of `grok export`).

---

## 1. Inventory — Grok

### 1.1 Layout (local docs)

Authoritative docs (installed with the CLI):

- `~/.grok/docs/user-guide/13-memory.md`
- `~/.grok/docs/user-guide/17-sessions.md`
- `~/.grok/docs/user-guide/04-slash-commands.md` (memory slash commands)

Config today (`~/.grok/config.toml`): **no `[memory]` section** — memory was used via `--experimental-memory` / session flag, not persistent config.

### 1.2 Memory store (current)

```
~/.grok/memory/
  MEMORY.md                          # global (stub Preferences)
  udon-4fdadfea/
    MEMORY.md                        # workspace (stub: “Auto-populated by dream”)
    index.sqlite                     # ~4.4 MB; FTS5 + vec0 embeddings (1024-d)
    sessions/
      2026-07-21-interval-019f82c8.md  # ONLY rich session log (from memory-enabled work)
  archema-io-14db248b/               # sibling workspace (not udon)
```

**Slug rule (docs):** `<project-slug>-<hash8>` from Git `origin` as `org/repo` when present. Udon `origin` is `https://github.com/v2-io/udon.git` → `udon-4fdadfea`. Subdir CWDs of the same repo (e.g. `spec/msc/greenfield-3b`) **share** this memory workspace.

**Session log naming observed:** `YYYY-MM-DD-interval-<first-8-of-session-id>.md`  
Example: session `019f82c8-a5fa-…` → `2026-07-21-interval-019f82c8.md`.

**Flush shape (live file):** repeated blocks with headings  
`## Decisions & rationale` / `## Technical context` / `## Problems & solutions`, separated by `---` and `<!-- flush HH:MM:SS UTC -->` markers. Multiple flushes **append** to the same interval file.

### 1.3 Index requirements (`index.sqlite`)

Tables (workspace index):

- `chunks` — path, line range, text, hash, **source** ∈ {`global`,`workspace`,`session`}, timestamps
- `chunks_fts` — FTS5
- `chunks_vec` — sqlite-vec `vec0`, FLOAT[1024]
- `meta` — e.g. `embedding_dimensions=1024`, `reindex_claim`

Observed udon index contents (2026-07-21):

| path | source | chunks |
|------|--------|--------|
| global `MEMORY.md` | global | 1 |
| `archema-io-…/sessions/…` | **global** (other workspace files appear in this index) | 16 |
| udon `MEMORY.md` | workspace | 1 |
| udon `sessions/2026-07-21-interval-019f82c8.md` | session | 32 |

**Implication:** do **not** hand-write SQLite rows. Drop Markdown and let Grok reindex (watcher + next search). Hand-editing the DB would skip embeddings and desync FTS/vec.

**Chunking defaults (docs):** `max_chunk_chars=1600`, `chunk_overlap_chars=320`. Session chunks get temporal decay (`half_life_days=7` default).

### 1.4 Raw Grok sessions (udon-related)

Base: `~/.grok/sessions/<url-encoded-cwd>/<session-id>/`

| CWD group | Sessions | Date range (created) | Notes |
|-----------|----------|----------------------|--------|
| `/Users/…/src/udon` | **5** | 2026-07-15 → 2026-07-21 | Main work |
| `/Users/…/src/udon/spec/msc/greenfield-3b` | **1** | 2026-07-20 | Large greenfield authoring session |

Per-session files (typical): `summary.json`, `updates.jsonl` (ACP truth), `chat_history.jsonl`, `events.jsonl`, `signals.json`, `rewind_points.jsonl`, `terminal/`, sometimes `subagents/`.

| Session ID | Created | Title (generated) | updates.jsonl | Memory log? |
|------------|---------|-------------------|---------------|-------------|
| `019f67df-2183-…` | 2026-07-15 | Codebase Orientation… | ~6.1 MB / 1190 lines | **No** |
| `019f6a01-636c-…` | 2026-07-16 | Resume Claude Session ID be2e5fbd-… | ~4.4 MB | **No** |
| `019f7328-2fc2-…` | 2026-07-18 | Thorough Exploration of Udon… | ~3.5 MB | **No** |
| `019f82c8-a5fa-…` | 2026-07-21 | v2-spec Orientation Wide Agency… | ~2.9 MB | **Yes** → interval file |
| `019f830e-bc39-…` | 2026-07-21 | (this investigation parent / empty title) | ~0.7 MB | in progress / none at probe |
| `019f7d71-f464-…` (greenfield-3b cwd) | 2026-07-20 | Greenfield Principled Udon Spec… | ~6.7 MB / 941 lines | **No** |

**Only one session produced rich memory** (`019f82c8…`). Older Jul 15–20 sessions predate memory enablement (or ran without the flag).

Also present:

- `~/.grok/sessions/session_search.sqlite` — FTS over session **titles/prompts** for `grok sessions search` (separate from memory index)
- `~/.grok/logs/unified.jsonl` — runtime log (~2.4 MB)
- `~/.grok/memtrace/*.jsonl` — process memory footprints, **not** conversation memory

### 1.5 Grok CLI surface (memory / sessions)

```text
grok --experimental-memory          # enable
grok --no-memory                    # force off
grok memory clear [--workspace|--global|--all] [--yes]   # DESTRUCTIVE only
grok sessions list|search|delete
grok export <SESSION_ID> [OUTPUT]   # full transcript → Markdown (stdout or file)
```

**No** `grok memory import`, `reindex`, `flush`, or `dream` CLI. Flush/dream are TUI slash commands with memory enabled.

`grok export` verified: e.g. `019f7328-…` → ~113 KB Markdown (`## User` / `## Assistant` / `## Tools` sections). Suitable as **input** to offline summarization, not as a direct sessions/ drop (too large/noisy; temporal decay + search quality suffer).

---

## 2. Inventory — Claude Code (and related)

### 2.1 Claude Code project sessions

```
~/.claude/projects/-Users-josephwecker-v2-src-udon/
  <uuid>.jsonl                 # primary transcript (JSONL)
  <uuid>/subagents|tool-results|workflows/   # side artifacts
  memory/                      # curated project memory (HIGH VALUE)
```

| Metric | Value |
|--------|--------|
| Session JSONL count | **17** |
| Total size | **~80.6 MB** |
| Date range (timestamps in files) | **2026-07-08 → 2026-07-20** |
| Format | JSONL: `type` ∈ user/assistant/system/mode/…; messages nested under `message` |

Notable large sessions (by size): `da5d1672…` (~17 MB, multi-day from Jul 8), `5d686e10…`, `be2e5fbd…`, `64bde246…`, `22abfaae…`, etc.

### 2.2 Claude project memory (already distilled)

```
~/.claude/projects/-Users-josephwecker-v2-src-udon/memory/
  MEMORY.md + 16 topic files
  ~47 KB total, ~679 lines
```

Topics include: wire-deratified cleanroom pivot, CORE sole source of truth, read-primary-source, proposals≠ratifications, descent-first spike authority inversion, design-session mode, toolchain facts, hedging/devaluing-source patterns, etc.

This is the **best Claude → Grok memory import feedstock** (curated, short, decision-shaped).

### 2.3 Other Claude-adjacent artifacts

| Path | Role |
|------|------|
| `~/.claude/history.jsonl` | Prompt history (~17k lines, ~7.8 MB); ~1850 lines match “udon” |
| `~/.claude/memory` → `~/src/memorata/claude/memory/` | **Global** discipline/collaboration memory (not udon-specific sessions) |
| `~/.claude/session-env/<uuid>/` | Per-session env stubs |
| `~/.claude/sessions/` | Empty/minimal at probe time |

### 2.4 Codex

`~/.codex/sessions/YYYY/MM/DD/rollout-….jsonl` — date-sharded.

- **session_reader** lists **3** codex sessions with cwd `/Users/…/src/udon` (titles: FULL-EBNF sync, early “thoughts on udon”, concept feedback).
- Broader content scan found **8** rollouts mentioning `/src/udon` in the first 30 lines (Dec 2025 – Mar 2026), ~5.5 MB combined — early/legacy, lower priority than Jul 2026 Claude/Grok.

Reader: `~/.grok/bundled/skills/shared/resume-session/session_reader.py`  
(`claude|codex|cursor` × `list|show`).

### 2.5 Cursor

`~/.cursor/projects/Users-josephwecker-v2-src-udon/agent-transcripts/<uuid>/<uuid>.jsonl` — **1** transcript observed (~minimal footprint vs Claude).

---

## 3. What memory indexing actually requires

### 3.1 File layout (write these; not the DB)

```
~/.grok/memory/udon-4fdadfea/
  MEMORY.md                 # durable project facts (dream consolidates here)
  sessions/
    YYYY-MM-DD-….md         # session logs (flush-style or imported summaries)
~/.grok/memory/MEMORY.md    # global only if truly cross-project
```

### 3.2 When reindex happens

From docs:

- Watcher on `~/.grok/memory/` (default on): create/modify → reindex on **next memory search**; delete → drop stale chunks.
- First-turn injection searches memory when a new memory-enabled session starts.
- Search tools: `memory_search` (hybrid vector 0.7 + BM25 0.3), `memory_get` (path read).

**No manual reindex command.** Starting `grok --experimental-memory` and running a memory query (or waiting for first-turn injection) is the practical trigger.

### 3.3 Content quality vs volume

| Content type | Good for memory? | Why |
|--------------|------------------|-----|
| Claude `memory/*.md` | **Excellent** | Already decision/rationale shaped |
| `/flush` LLM summaries | **Excellent** | Matches native format |
| Auto session-end metadata | Weak | Topics only |
| Full `grok export` / Claude JSONL | Poor as-is | Noise, tool dumps, staleness; hurts ranking |
| Offline LLM summary of export | **Good** | If structured like flush headings |

---

## 4. Feasible import procedures (ranked)

### Rank 1 — Import Claude curated project memory (recommended first)

**Practicality:** high · **Risk:** low · **Signal:** high

1. Review `~/.claude/projects/-Users-josephwecker-v2-src-udon/memory/*.md`.
2. Either:
   - **A.** Concatenate topic files into a single  
     `~/.grok/memory/udon-4fdadfea/sessions/2026-07-import-claude-project-memory.md`  
     with clear provenance header, **or**
   - **B.** Merge durable bullets into workspace `MEMORY.md` (better for long-term; survives session decay).
3. Open Grok with memory; confirm via `/memory` or `memory_search`.
4. Optionally `/dream` after a few session files accumulate to consolidate into `MEMORY.md`.

**Do not** dump all 80 MB of Claude JSONL.

### Rank 2 — Resume historical Grok sessions + `/flush` (native, best fidelity for Grok)

**Practicality:** medium · **Risk:** low · **Signal:** high for the 4–5 pre-memory Grok sessions

For each important session:

```bash
cd ~/src/udon
grok --experimental-memory --resume 019f7328-2fc2-7e50-831b-8df8a0b1e247
# in TUI: /flush
# optional: /dream later
```

Caveats:

- Resume loads full history into context (large sessions may compact first; pre-compact flush settings exist under `[compaction.memory_flush]`).
- greenfield-3b session: resume from that cwd or pass the id if the picker finds it cross-cwd via search.
- Only works for **Grok** sessions, not Claude/Codex.

Priority candidates: `019f7d71…` (greenfield-3b), `019f67df…` (first orientation), `019f7328…` (exploration), `019f6a01…` (Claude resume bridge).

### Rank 3 — Offline: `grok export` → LLM summary → file drop

**Practicality:** medium · **Risk:** low if staged under this spike first · **Signal:** good

```bash
grok export <SESSION_ID> v2-spec/spikes/memory-import/samples/export-<id8>.md
# summarize with any model into flush-shaped MD
# review, then:
cp reviewed.md ~/.grok/memory/udon-4fdadfea/sessions/YYYY-MM-DD-import-<id8>.md
```

Spike helper (metadata + skeleton only, **no LLM**):

```bash
python3 v2-spec/spikes/memory-import/convert_session_to_memory_md.py --list-udon
python3 v2-spec/spikes/memory-import/convert_session_to_memory_md.py 019f7328-2fc2-7e50-831b-8df8a0b1e247
# optional full export:
python3 v2-spec/spikes/memory-import/convert_session_to_memory_md.py 019f7328-2fc2-7e50-831b-8df8a0b1e247 --export-first
```

Samples already written under `samples/`.

### Rank 4 — Claude/Codex transcripts via session_reader + summarize

**Practicality:** medium-low for bulk · **Risk:** low if summarized · **Signal:** variable

```bash
python3 ~/.grok/bundled/skills/shared/resume-session/session_reader.py claude list --cwd ~/src/udon --json
python3 …/session_reader.py claude show <id|latest> --cwd ~/src/udon --json
```

Use `show` output as **untrusted inert history** (skill CORE.md), summarize to flush-shaped MD, drop into sessions/. Prioritize sessions that produced rulings still live in CHANGELOG / v2-spec — not every orientation.

Grok skill `resume-claude` is for **continuing work**, not bulk memory import; it deliberately avoids dumping full transcripts into context.

### Rank 5 — Blind dump of exports into `sessions/`

**Practicality:** easy · **Risk:** medium (noise, embedding cost, search pollution) · **Not recommended**

Temporal decay helps eventually; `/dream` may struggle to distill junk. Prefer Rank 1–3.

---

## 5. Explicit answers to investigation questions

| Question | Answer |
|----------|--------|
| Where do Grok session transcripts live? | `~/.grok/sessions/<encoded-cwd>/<uuid>/` (`updates.jsonl`, `chat_history.jsonl`, …) |
| Where is experimental memory? | `~/.grok/memory/udon-4fdadfea/` (+ global `MEMORY.md`) |
| Logs? | `~/.grok/logs/unified.jsonl`; memtrace is RSS, not dialogue |
| Claude udon logs? | `~/.claude/projects/-Users-josephwecker-v2-src-udon/*.jsonl` + `memory/` |
| Can `/flush` do historical sessions? | **Only if resumed as the current session**; not bulk offline |
| Can `/dream` ingest history? | Only consolidates **already-written** memory Markdown |
| CLI import/reindex? | **No** — file drop + watcher |
| Safe live write now? | Prefer staging under this spike; live drop of **Claude memory** or **flush-quality** files is safe once reviewed |

---

## 6. Commands run (non-destructive)

- Inventory: `ls` / `find` under `~/.grok/{memory,sessions,logs,docs}`, `~/.claude/projects/…-udon`, `~/.codex/sessions`, `~/.cursor/projects/…-udon`
- Read docs: `13-memory.md`, `17-sessions.md`, slash-commands memory section, `config.toml`
- SQLite inspect (read-only URI): schemas + counts for `udon-4fdadfea/index.sqlite`, `archema-…/index.sqlite`, `session_search.sqlite`
- `grok memory --help`, `grok sessions --help`, `grok export --help`
- `grok export 019f7328-…` → `/tmp/grok-export-test/explore.md` (~113 KB)
- `session_reader.py claude|codex list --cwd …/udon --json`
- Python inventories of Claude JSONL dates/sizes; Claude history.jsonl udon line count
- Wrote spike samples + converter under `v2-spec/spikes/memory-import/` only

**Not run:** `grok memory clear`, any deletion, live copy into `~/.grok/memory/`.

---

## 7. Spike artifacts

```
v2-spec/spikes/memory-import/
  FINDINGS.md                              # this report
  convert_session_to_memory_md.py          # offline metadata/skeleton converter
  samples/
    2026-07-18-import-019f7328-metadata.md
    2026-07-18-import-019f7328-flush-skeleton.md
```

---

## 8. Recommended next step (for main agent)

**Do Rank 1 immediately after a one-pass human skim:** copy Claude’s curated udon project memory into either workspace `MEMORY.md` (durable bullets) or a single dated `sessions/2026-07-import-claude-project-memory.md`, enable Grok memory, verify search hits, then **Rank 2** on the two heaviest pre-memory Grok sessions (`019f7d71` greenfield-3b and `019f67df` or `019f7328`) via `grok --experimental-memory -r <id>` + `/flush`. Skip bulk JSONL/export dumps until those two paths prove search quality; only then batch offline LLM summaries for remaining Grok sessions and a shortlist of Claude sessions that are not already represented in the Claude memory files or in `spec/msc/CHANGELOG.md` / `v2-spec/`. Keep all staging under this spike directory until Joseph okays the live drop-in.

---

## Appendix A — Enable memory persistently (optional)

```toml
# ~/.grok/config.toml
[memory]
enabled = true

# optional later:
# [memory.dream]
# enabled = true
# min_hours = 4
# min_sessions = 3
```

Or per invocation: `GROK_MEMORY=1` / `grok --experimental-memory`.

## Appendix B — Provenance header template for imported files

```markdown
# Imported: <title>

> **Provenance:** <claude-project-memory | grok-export+llm | resume-flush>
> **Source path:** `…`
> **Source session id:** `…`
> **Original dates:** …
> **Imported:** 2026-07-21
> **Trust:** historical; verify against live CORE / RULING-TABLE before acting

## Decisions & rationale
…
```

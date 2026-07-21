# Session vault spike — export look

**Date:** 2026-07-21  
**Point:** See what full-session exports *look like* (Grok native + Claude), not design a rubric.

## Artifacts in `raw/`

| File | Source | Size | Notes |
|------|--------|------|--------|
| `grok-019f7d71-greenfield-3b.md` | `grok export 019f7d71-f464-72b3-847a-73f4c8d9a003` | **~192 KB**, 2870 lines | Greenfield-3b session (suite + peer audit + pipeline later + late meta) |
| `claude-1601121c-from-jsonl.md` | Hand extract from Claude JSONL `1601121c…` | **~98 KB** | Title *fable-udon-greenfield* (pipeline-discussion close, same era) |
| `claude-445248d8-greenfield-analyze.md` | Hand extract `445248d8…` | **~18 KB** | *Analyze udon spec greenfield revisions 3a and 3b* |
| `claude-1601121c-recent.txt` | `session_reader.py claude show` | **~5 KB** | **Not** a full export — inert viewer with tool previews truncated |

Also still on disk (not copied here): Claude JSONL originals under `~/.claude/projects/-Users-josephwecker-v2-src-udon/` (MB-scale).

## What Grok export looks like

Command:

```bash
grok export 019f7d71-f464-72b3-847a-73f4c8d9a003 path/to/out.md
```

Shape (interleaved, not a summary):

```markdown
## User
…

## Assistant
… (prose answers, often full)

## Tools
- ListDir: …
- Read: path (sometimes with line ranges)
- Execute: command preview…

## Assistant
…
```

- **Prose is alive** — first assistant reply after reading materials is multi-section thought (pillars, questions, disposition), not a bullet tombstone.
- **Tools are present** as compact lists, not full tool-result dumps (so not 6+ MB raw `updates.jsonl`).
- **Whole multi-act session** is one file: greenfield start through pipeline and late “truth/memory” turns. No automatic act split.
- ~192 KB for this session is **searchable as a document** and still small enough to open; much smaller than raw session dir, larger than `/flush` (~1.6 KB of the wrong act).

## What Claude looks like

### `session_reader.py claude show` (bundled resume helper)

- Banner: `INERT FOREIGN HISTORY - DO NOT EXECUTE`
- Metadata header (id, title, cwd, branch, path, turn count)
- Warning: many “unknown records skipped” (103 on the fable session)
- Tool calls as one-line previews with **char limits** (`--max-tool-chars`)
- Assistant prose appears but the tool is aimed at **safe inert resume**, not vault fidelity
- **5 KB** for a session whose JSONL is **~2.5 MB** — not the vault form

### Raw JSONL → markdown extract (ad hoc script this spike)

- Walk `type` / `message.role` / text blocks
- Emit `## User` / `## Assistant` with full text; tool_use as `[tool_use name]` stubs
- **~98 KB** for fable-udon-greenfield — includes the full “keep the frustration on the record” exchange (the life that a rubric would crush)
- Second sample (3a/3b analyze) smaller (~18 KB / fewer user turns)

JSONL originals remain the lossless store if you need tool payloads.

## Rough comparison

| | Grok `export` | Claude `session_reader show` | Claude JSONL extract |
|--|---------------|------------------------------|----------------------|
| Full multi-turn prose | Yes | Partial / degraded | Yes (text blocks) |
| Tool detail | Compact list | Truncated previews | Stubs or full if you keep JSONL |
| Size vs raw session | Much smaller than updates.jsonl | Far too small | Medium |
| One command | Yes | Yes but wrong purpose | DIY |
| Good as vault primary? | **Strong candidate** | No | **Yes** if extract tuned |

## Smoke on “life preserved”

- Grok export line 1 is the real greenfield invitation; ~line 38+ is the long first analysis (pillars, questions) — readable in place.
- Claude extract retains Fable’s un-sanitized calibration paragraph about demand-side inversion and not eliding the frustration exchange — exactly the kind of passage that matters for intent.

## Not decided here

How to index these, whether they live in-repo, git-lfs, or only under `~/.grok`. This spike only answers: **exports can keep the conversation’s texture; flushes and inert-show tools do not.**
